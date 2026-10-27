import { useCallback, useEffect, useMemo, useState, type FormEvent } from 'react';
import { Link } from 'react-router-dom';
import { api } from '../services/api';
import { Icon, PageHead } from '../components/UI';

interface Mentor {
  id: number;
  name: string;
  university: string;
  skills: Array<{ id: number; name: string }>;
}
interface Session {
  id: number;
  mentor_id: number;
  learner_id: number;
  topic: string;
  scheduled_start: string;
  scheduled_end: string;
  modality: 'online' | 'presential';
  meeting_url: string | null;
  status: 'proposed' | 'accepted' | 'rejected' | 'cancelled' | 'completed' | 'no_show';
  mentor_confirmed: boolean;
  learner_confirmed: boolean;
  mentor_name: string;
  learner_name: string;
  has_reviewed: boolean;
  role: 'mentor' | 'learner';
}
const weekdays = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
const statusLabel: Record<Session['status'], string> = {
  proposed: 'Solicitud pendiente', accepted: 'Confirmada', rejected: 'Rechazada',
  cancelled: 'Cancelada', completed: 'Completada', no_show: 'No realizada'
};
const localToday = () => {
  const d = new Date();
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`;
};
const pretty = (iso: string) => new Date(`${iso.slice(0, 10)}T12:00:00`)
  .toLocaleDateString('es-PE', { day: 'numeric', month: 'long', year: 'numeric' });
const toDate = (iso: string) => new Date(`${iso}:00-05:00`).getTime();

export default function Calendar() {
  const [month, setMonth] = useState(() => new Date(new Date().getFullYear(), new Date().getMonth(), 1));
  const [selected, setSelected] = useState(localToday);
  const [sessions, setSessions] = useState<Session[]>([]);
  const [mentors, setMentors] = useState<Mentor[]>([]);
  const [mentorId, setMentorId] = useState('');
  const [skillId, setSkillId] = useState('');
  const [date, setDate] = useState(localToday);
  const [time, setTime] = useState('17:00');
  const [duration, setDuration] = useState('60');
  const [modality, setModality] = useState<'online' | 'presential'>('online');
  const [meetingUrl, setMeetingUrl] = useState('');
  const [showForm, setShowForm] = useState(false);
  const [reviewId, setReviewId] = useState<number | null>(null);
  const [rating, setRating] = useState(5);
  const [comment, setComment] = useState('');
  const [busy, setBusy] = useState(false);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');

  const refresh = useCallback(async () => {
    const data = await api.get<Session[]>('/api/sessions');
    setSessions(data);
  }, []);

  useEffect(() => {
    let active = true;
    Promise.all([
      api.get<Session[]>('/api/sessions'),
      api.get<Mentor[]>('/api/sessions/mentors')
    ]).then(([items, people]) => {
      if (!active) return;
      setSessions(items);
      setMentors(people);
    }).catch(e => {
      if (active) setError((e as Error).message);
    }).finally(() => {
      if (active) setLoading(false);
    });
    return () => { active = false; };
  }, []);

  const selectedMentor = mentors.find(m => m.id === Number(mentorId));
  const firstDay = (month.getDay() + 6) % 7;
  const daysInMonth = new Date(month.getFullYear(), month.getMonth() + 1, 0).getDate();
  const cells: Array<number | null> = [
    ...Array.from({ length: firstDay }, () => null),
    ...Array.from({ length: daysInMonth }, (_, i) => i + 1)
  ];
  while (cells.length % 7) cells.push(null);
  const dayKey = (day: number) =>
    `${month.getFullYear()}-${String(month.getMonth() + 1).padStart(2, '0')}-${String(day).padStart(2, '0')}`;
  const dayItems = useMemo(() => sessions.filter(s => s.scheduled_start.startsWith(selected)), [sessions, selected]);
  const pending = sessions.filter(s => s.status === 'proposed' && s.role === 'mentor');
  const active = sessions.filter(s => ['accepted', 'proposed'].includes(s.status));
  const unreadReviews = sessions.filter(s => s.status === 'completed' && !s.has_reviewed);
  const reviewedSession = sessions.find(s => s.id === reviewId);
  const reviewedName = reviewedSession ? (reviewedSession.role === 'mentor' ? reviewedSession.learner_name : reviewedSession.mentor_name) : '';

  const action = async (path: string, body: unknown) => {
    setBusy(true); setError(''); setSuccess('');
    try {
      const result = await api.post<{ message: string }>(path, body);
      await refresh();
      setSuccess(result.message);
      return true;
    } catch (e) {
      setError((e as Error).message);
      return false;
    } finally { setBusy(false); }
  };

  const propose = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    if (!mentorId || !skillId) { setError('Selecciona un mentor y una materia.'); return; }
    if (await action('/api/sessions', {
      mentor_id: Number(mentorId), knowledge_id: Number(skillId),
      scheduled_start: `${date}T${time}`, duration_minutes: Number(duration),
      modality, meeting_url: meetingUrl
    })) {
      setShowForm(false);
      setSelected(date);
      setMonth(new Date(Number(date.slice(0, 4)), Number(date.slice(5, 7)) - 1, 1));
    }
  };

  const review = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    if (reviewId === null) return;
    if (await action(`/api/sessions/${reviewId}/review`, { rating, comment })) {
      setReviewId(null);
      setComment('');
      setRating(5);
    }
  };

  const SessionCard = ({ item }: { item: Session }) => {
    const other = item.role === 'mentor' ? item.learner_name : item.mentor_name;
    const mineConfirmed = item.role === 'mentor' ? item.mentor_confirmed : item.learner_confirmed;
    const canConfirm = item.status === 'accepted' && toDate(item.scheduled_end) <= Date.now() && !mineConfirmed;
    return (
      <article className="apr-session">
        <div className="apr-session-head">
          <div><strong>{item.topic}</strong><small>{other} · {item.role === 'mentor' ? 'Tú enseñas' : 'Tú aprendes'}</small></div>
          <span className={`apr-chip apr-${item.status}`}>{statusLabel[item.status]}</span>
        </div>
        <p>{pretty(item.scheduled_start)} · {item.scheduled_start.slice(11, 16)} – {item.scheduled_end.slice(11, 16)} · {item.modality === 'online' ? 'En línea' : 'Presencial'}</p>
        <div className="apr-actions">
          {item.status === 'proposed' && item.role === 'mentor' && <>
            <button disabled={busy} onClick={() => void action(`/api/sessions/${item.id}/decision`, { action: 'accept' })}>Aceptar</button>
            <button disabled={busy} className="apr-ghost" onClick={() => void action(`/api/sessions/${item.id}/decision`, { action: 'reject' })}>Rechazar</button>
          </>}
          {['proposed', 'accepted'].includes(item.status) &&
            <button disabled={busy} className="apr-ghost" onClick={() => void action(`/api/sessions/${item.id}/decision`, { action: 'cancel' })}>Cancelar</button>}
          {canConfirm && <button disabled={busy} onClick={() => void action(`/api/sessions/${item.id}/confirm`, {})}>Confirmar que se realizó</button>}
          {item.status === 'accepted' && mineConfirmed && <span className="apr-note">Esperando confirmación de la otra persona</span>}
          {item.status === 'accepted' && item.meeting_url && <a href={item.meeting_url} target="_blank" rel="noopener noreferrer">Abrir reunión ↗</a>}
          {item.status === 'completed' && !item.has_reviewed && <button onClick={() => setReviewId(item.id)}>Dejar reseña</button>}
          {item.status === 'completed' && item.has_reviewed && <span className="apr-note">✓ Reseña enviada</span>}
        </div>
      </article>
    );
  };

  return <div className="apr-calendar-page">
    <style>{`
      .apr-calendar-page{color:#342838}.apr-dashboard{display:grid;grid-template-columns:minmax(0,1.4fr) minmax(270px,.9fr);gap:18px;align-items:start}
      .apr-card{background:#fff;border:1px solid #f0e2e8;border-radius:19px;padding:24px;box-shadow:0 12px 32px #462b4710;min-width:0}
      .apr-toolbar{display:flex;align-items:center;justify-content:space-between;gap:10px;margin-bottom:22px}.apr-toolbar h2{font-size:20px;margin:0;text-transform:capitalize}.apr-toolbar>div{display:flex;gap:8px}
      .apr-toolbar button{background:#fff4f3;color:#bb6171;border:1px solid #f6e2e3;border-radius:9px;padding:8px 12px;cursor:pointer}
      .apr-grid{display:grid;grid-template-columns:repeat(7,minmax(0,1fr));gap:7px}.apr-weekday{text-align:center;color:#a093a0;font-size:12px;font-weight:700;padding:6px 0}
      .apr-day{min-height:71px;display:flex;flex-direction:column;align-items:flex-start;justify-content:space-between;border:1px solid #f3e7eb;background:#fff;border-radius:12px;padding:10px;color:#433546;cursor:pointer;font-size:13px}
      .apr-day:hover{background:#fff4f3}.apr-day.selected{border-color:#e77783;background:#fff0ee;box-shadow:0 0 0 2px #f9dde0}.apr-day.today{font-weight:800}.apr-day i{width:7px;height:7px;border-radius:50%;background:#e97980}.apr-empty{min-height:71px}
      .apr-summary{display:grid;grid-template-columns:repeat(3,1fr);gap:12px;margin-bottom:18px}.apr-summary>div{background:#fff;border:1px solid #f0e2e8;border-radius:16px;padding:16px}.apr-summary strong{font-size:24px;color:#d66c78;display:block}.apr-summary small{font-size:11px;color:#958493}
      .apr-aside{display:grid;gap:17px}.apr-card h3{margin:0 0 15px;font-size:17px}.apr-primary,.apr-actions button{border:0;border-radius:11px;background:#e9777f;color:white;font:inherit;font-size:12px;font-weight:750;padding:11px 15px;cursor:pointer}.apr-primary:disabled,.apr-actions button:disabled{opacity:.55;cursor:not-allowed}
      .apr-session{border:1px solid #f1e3e8;border-radius:13px;padding:15px;margin-top:12px;background:#fffdfd}.apr-session-head{display:flex;justify-content:space-between;gap:8px;align-items:start}.apr-session-head strong{font-size:13px;display:block}.apr-session-head small{display:block;margin-top:5px;color:#918090;font-size:11px}.apr-session p{font-size:11px;color:#918090;margin:11px 0}
      .apr-chip{font-size:10px;font-weight:800;padding:7px 9px;border-radius:8px;white-space:nowrap;background:#f5edf3;color:#8b6d89}.apr-accepted,.apr-completed{background:#e8f6f0;color:#388a6f}.apr-proposed{background:#fff0de;color:#b27c35}
      .apr-actions{display:flex;gap:7px;flex-wrap:wrap;align-items:center}.apr-actions .apr-ghost{border:1px solid #f1dfe3;background:#fff;color:#a55d68}.apr-actions a{font-size:11px;color:#ba6170;font-weight:700}.apr-note{font-size:11px;color:#7f7b86}
      .apr-form{display:grid;grid-template-columns:1fr 1fr;gap:12px}.apr-form label{display:grid;gap:6px;font-size:11px;font-weight:700;color:#5e5061}.apr-form input,.apr-form select,.apr-form textarea{min-width:0;max-width:100%;height:42px;border:1px solid #eadde5;border-radius:10px;background:#fff;color:#443345;font:inherit;font-size:12px;padding:9px}.apr-form textarea{height:92px;resize:vertical}.apr-form .full{grid-column:1/-1}.apr-form .apr-primary{grid-column:1/-1}
      .apr-alert{padding:12px 16px;margin-bottom:15px;border-radius:11px;font-size:12px}.apr-alert.error{background:#fff0f0;color:#a94352}.apr-alert.success{background:#e8f7f0;color:#31795b}
      .apr-section{margin-top:18px}.apr-section h3{font-size:15px}.apr-muted{color:#9b8c98;font-size:12px;line-height:1.7}.apr-stars{display:flex;gap:5px}.apr-stars button{border:0;background:#fff0ed;color:#b5a3a8;border-radius:9px;padding:8px 11px;font-size:21px;cursor:pointer}.apr-stars button.on{color:#e7a442}
      @media(max-width:960px){.apr-dashboard{grid-template-columns:1fr}}@media(max-width:530px){.apr-summary{grid-template-columns:1fr 1fr}.apr-card{padding:15px}.apr-grid{gap:3px}.apr-day,.apr-empty{min-height:53px;padding:7px}.apr-form{grid-template-columns:1fr}}
    `}</style>

    <PageHead eyebrow="ORGANIZA TU APRENDIZAJE" title="Mi calendario"
      description="Solicita, acepta y registra tus asesorías en un solo lugar."
      action={<button className="apr-primary" onClick={() => setShowForm(v => !v)}><Icon name="plus" size={16} /> Nueva asesoría</button>} />
    {error && <div className="apr-alert error" role="alert">{error}</div>}
    {success && <div className="apr-alert success" role="status">{success}</div>}
    <div className="apr-summary">
      <div><strong>{active.length}</strong><small>Programadas o pendientes</small></div>
      <div><strong>{pending.length}</strong><small>Por responder</small></div>
      <div><strong>{unreadReviews.length}</strong><small>Reseñas por escribir</small></div>
    </div>

    {showForm && <section className="apr-card apr-section">
      <h3>Solicitar una asesoría</h3>
      <form className="apr-form" onSubmit={propose}>
        <label className="full">Mentor
          <select required value={mentorId} onChange={e => { setMentorId(e.target.value); setSkillId(''); }}>
            <option value="">Selecciona a quién quieres aprender</option>
            {mentors.map(m => <option key={m.id} value={m.id}>{m.name} · {m.university}</option>)}
          </select>
        </label>
        <label className="full">Tema que enseña el mentor
          <select required value={skillId} onChange={e => setSkillId(e.target.value)}>
            <option value="">Selecciona un tema</option>
            {selectedMentor?.skills.map(s => <option key={s.id} value={s.id}>{s.name}</option>)}
          </select>
        </label>
        <label>Fecha <input required type="date" min={localToday()} value={date} onChange={e => setDate(e.target.value)} /></label>
        <label>Hora <input required type="time" value={time} onChange={e => setTime(e.target.value)} /></label>
        <label>Duración <select value={duration} onChange={e => setDuration(e.target.value)}>
          {[30, 45, 60, 90, 120, 180].map(n => <option key={n} value={n}>{n} minutos</option>)}
        </select></label>
        <label>Modalidad <select value={modality} onChange={e => setModality(e.target.value as 'online' | 'presential')}>
          <option value="online">En línea</option><option value="presential">Presencial</option>
        </select></label>
        {modality === 'online' && <label className="full">Enlace de reunión (opcional)
          <input type="url" value={meetingUrl} onChange={e => setMeetingUrl(e.target.value)} placeholder="https://meet.google.com/..." />
        </label>}
        <button type="submit" className="apr-primary" disabled={busy}>Enviar solicitud de asesoría</button>
      </form>
    </section>}

    <div className="apr-dashboard apr-section">
      <section className="apr-card">
        <div className="apr-toolbar">
          <h2>{month.toLocaleDateString('es-PE', { month: 'long', year: 'numeric' })}</h2>
          <div>
            <button aria-label="Mes anterior" onClick={() => setMonth(new Date(month.getFullYear(), month.getMonth() - 1, 1))}>‹</button>
            <button onClick={() => { setMonth(new Date(new Date().getFullYear(), new Date().getMonth(), 1)); setSelected(localToday()); }}>Hoy</button>
            <button aria-label="Mes siguiente" onClick={() => setMonth(new Date(month.getFullYear(), month.getMonth() + 1, 1))}>›</button>
          </div>
        </div>
        <div className="apr-grid">
          {weekdays.map(d => <span className="apr-weekday" key={d}>{d}</span>)}
          {cells.map((day, i) => day === null ? <span className="apr-empty" key={`e${i}`} /> :
            <button type="button" key={day} className={`apr-day ${selected === dayKey(day) ? 'selected' : ''} ${dayKey(day) === localToday() ? 'today' : ''}`}
              onClick={() => setSelected(dayKey(day))} aria-label={`Seleccionar día ${day}`}>
              <span>{day}</span>{sessions.some(s => s.scheduled_start.startsWith(dayKey(day))) && <i />}
            </button>)}
        </div>
      </section>
      <aside className="apr-aside">
        <section className="apr-card">
          <span className="ap-eyebrow">DÍA SELECCIONADO</span>
          <h3 style={{ marginTop: 9 }}>{pretty(selected)}</h3>
          {loading ? <p className="apr-muted">Cargando asesorías…</p> : dayItems.length ?
            dayItems.map(s => <SessionCard item={s} key={s.id} />) :
            <p className="apr-muted">No tienes asesorías para este día. Puedes solicitar una nueva.</p>}
        </section>
        {!!pending.length && <section className="apr-card">
          <h3>Solicitudes por responder</h3>
          {pending.map(s => <SessionCard item={s} key={s.id} />)}
        </section>}
        {!!unreadReviews.length && <section className="apr-card">
          <h3>Reseñas pendientes</h3>
          {unreadReviews.map(s => <SessionCard item={s} key={s.id} />)}
        </section>}
      </aside>
    </div>

    {reviewedSession && <div className="apr-review-backdrop" onMouseDown={e => { if (e.target === e.currentTarget && !busy) setReviewId(null); }}>
      <section className="apr-review-modal" role="dialog" aria-modal="true" aria-labelledby="apr-review-title">
        <button className="apr-review-close" type="button" aria-label="Cerrar" disabled={busy} onClick={() => setReviewId(null)}>×</button>
        <div className="apr-review-symbol"><Icon name="star" size={25}/></div>
        <h3 id="apr-review-title">¿Cómo estuvo la asesoría?</h3>
        <p>Tu opinión ayuda a otros estudiantes a encontrar buenos compañeros para aprender.</p>
        <div className="apr-review-person">
          <span className="apr-review-avatar">{reviewedName.charAt(0).toUpperCase()}</span>
          <div><strong>{reviewedName}</strong><small>{reviewedSession.topic} · Asesoría completada</small></div>
        </div>
        <form onSubmit={review}>
          <div className="apr-stars" role="group" aria-label="Selecciona entre 1 y 5 estrellas">
            {[1, 2, 3, 4, 5].map(n => <button key={n} type="button"
              className={n <= rating ? 'on' : ''} aria-label={`${n} ${n === 1 ? 'estrella' : 'estrellas'}`}
              aria-pressed={rating === n} onClick={() => setRating(n)}>★</button>)}
          </div>
          <div className="apr-review-selection">{rating} de 5 estrellas</div>
          <label>Cuéntanos tu experiencia (opcional)
            <textarea maxLength={1000} value={comment} onChange={e => setComment(e.target.value)}
              placeholder="¿Qué fue lo más útil de esta asesoría?" />
          </label>
          <div className="apr-review-actions">
            <button type="button" className="cancel" disabled={busy} onClick={() => setReviewId(null)}>Cancelar</button>
            <button type="submit" className="submit" disabled={busy}>{busy ? 'Enviando...' : 'Enviar reseña'}</button>
          </div>
        </form>
      </section>
    </div>}
    <p className="apr-muted apr-section">¿Quieres conversar antes de agendar? <Link to="/mensajes">Ir a Mensajes</Link>. Las fechas se interpretan en hora de Perú.</p>
  </div>;
}