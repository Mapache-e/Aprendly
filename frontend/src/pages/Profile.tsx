import { useEffect, useState, type FormEvent } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { api } from '../services/api';
import { useAuth } from '../hooks/AuthContext';
import { Avatar, Icon, PageHead, SkillPills } from '../components/UI';
import type { RankingData } from '../components/RankingPanel';
import RecognitionDownload from '../components/RecognitionDownload';

type Tab = 'informacion' | 'habilidades' | 'seguridad' | 'reconocimientos';
const ciclos = [
  '1.er ciclo', '2.º ciclo', '3.er ciclo', '4.º ciclo', '5.º ciclo',
  '6.º ciclo', '7.º ciclo', '8.º ciclo', '9.º ciclo', '10.º ciclo'
];

export default function Profile() {
  const { profile, refreshProfile, logout } = useAuth();
  const navigate = useNavigate();
  const [tab, setTab] = useState<Tab>('informacion');
  const [semester, setSemester] = useState('');
  const [bio, setBio] = useState('');
  const [academic, setAcademic] = useState({ university: '', career: '', currentPassword: '' });
  const [universities, setUniversities] = useState<Array<{ id: number; name: string }>>([]);
  const [teachInput, setTeachInput] = useState('');
  const [learnInput, setLearnInput] = useState('');
  const [password, setPassword] = useState({ current: '', next: '', repeat: '' });
  const [showPassword, setShowPassword] = useState(false);
  const [ranking, setRanking] = useState<RankingData | null>(null);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');

  useEffect(() => {
    if (!profile) return;
    setSemester(profile.semester || '');
    setBio(profile.bio || '');
    setAcademic(previous => ({ ...previous, university: profile.user.university_name, career: profile.career }));
  }, [profile]);

  useEffect(() => {
    let active = true;
    api.get<RankingData>('/api/ranking')
      .then(data => { if (active) setRanking(data); })
      .catch(() => { if (active) setRanking(null); });
    return () => { active = false; };
  }, []);

  useEffect(() => {
    api.get<Array<{ id: number; name: string }>>('/api/profile/universities')
      .then(setUniversities).catch(() => setUniversities([]));
  }, []);

  const saveAcademicIdentity = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    if (busy) return;
    if (!academic.currentPassword) { setError('Confirma tu contraseña actual para actualizar universidad o carrera.'); return; }
    setBusy(true); setError(''); setSuccess('');
    try {
      await api.put('/api/profile/academic', {
        university_name: academic.university.trim(), career: academic.career.trim(),
        current_password: academic.currentPassword
      });
      await refreshProfile();
      setAcademic(previous => ({ ...previous, currentPassword: '' }));
      setSuccess('Universidad y carrera actualizadas correctamente.');
    } catch (err) { setError((err as Error).message); }
    finally { setBusy(false); }
  };

  const goTab = (next: Tab) => {
    setTab(next);
    setError('');
    setSuccess('');
  };

  const saveAcademic = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    if (!profile || busy) return;
    if (!ciclos.includes(semester)) {
      setError('Selecciona un ciclo académico válido.');
      return;
    }
    setBusy(true); setError(''); setSuccess('');
    try {
      await api.put('/api/profile', {
        semester, bio: bio.trim()
      });
      await refreshProfile();
      setSuccess('Tu información se guardó correctamente.');
    } catch (err) { setError((err as Error).message); }
    finally { setBusy(false); }
  };

  const changeSkills = async (kind: 'teach' | 'learn', remove?: string) => {
    if (!profile || busy) return;
    const input = (kind === 'teach' ? teachInput : learnInput).trim();
    if (!remove && !input) return;
    const current = profile[kind];
    const next = remove
      ? current.filter(skill => skill !== remove)
      : [...current, input].filter((skill, index, list) =>
          skill && list.findIndex(x => x.toLowerCase() === skill.toLowerCase()) === index
        );
    setBusy(true); setError(''); setSuccess('');
    try {
      await api.post('/api/knowledge', { [kind]: next });
      await refreshProfile();
      if (kind === 'teach') setTeachInput(''); else setLearnInput('');
      setSuccess('Tus conocimientos fueron actualizados.');
    } catch (err) { setError((err as Error).message); }
    finally { setBusy(false); }
  };

  const changePassword = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    if (busy) return;
    if (password.next.length < 8 || new TextEncoder().encode(password.next).length > 72) {
      setError('La nueva contraseña debe tener al menos 8 caracteres y máximo 72 bytes.');
      return;
    }
    if (password.next !== password.repeat) {
      setError('Las nuevas contraseñas no coinciden.');
      return;
    }
    setBusy(true); setError(''); setSuccess('');
    try {
      await api.post('/api/profile/password', {
        current_password: password.current,
        new_password: password.next
      });
      setPassword({ current: '', next: '', repeat: '' });
      setShowPassword(false);
      setSuccess('Tu contraseña se cambió correctamente.');
    } catch (err) { setError((err as Error).message); }
    finally { setBusy(false); }
  };

  if (!profile) return <div className="ap-panel">Cargando información de tu cuenta...</div>;

  const { user } = profile;
  const me = ranking?.me;
  const rating = me && me.score !== null ? me.score.toFixed(1) : '—';
  const given = me?.given ?? 0;
  const fullName = `${user.first_name} ${user.last_name}`;

  return (
    <div className="ap2-profile">
      <PageHead
        eyebrow="MI ESPACIO PERSONAL"
        title="Mi perfil y ajustes"
        description="Tu identidad académica, habilidades y seguridad en un solo lugar."
      />

      <div className="ap2-cover">
        <span>APRENDLY · CRECE COMPARTIENDO</span>
        <strong>Un espacio que se parece a ti.</strong>
        <div className="ap2-cover-orb" aria-hidden="true" />
      </div>

      <div className="ap2-profile-intro ap-panel">
        <div className="ap2-profile-person">
          <Avatar first={user.first_name} last={user.last_name} size="lg" />
          <div className="ap2-minwidth">
            <span className="ap-eyebrow">ESTUDIANTE DE APRENDLY</span>
            <h2>{fullName}</h2>
            <p>{profile.career || 'Carrera no registrada'} · {profile.semester || 'Ciclo sin definir'}</p>
            <small>{user.university_name}</small>
          </div>
        </div>
        <div className="ap2-summary-numbers">
          <div><strong>{profile.teach.length}</strong><small>Enseño</small></div>
          <div><strong>{profile.learn.length}</strong><small>Aprendo</small></div>
          <div><strong>{rating}</strong><small>Puntuación general</small></div>
        </div>
      </div>

      <div className="ap2-profile-tabs" role="tablist" aria-label="Apartados de perfil">
        {([
          ['informacion', 'Información', 'user'],
          ['habilidades', 'Mis habilidades', 'book'],
          ['seguridad', 'Cuenta y seguridad', 'shield'],
          ['reconocimientos', 'Reconocimientos', 'medal']
        ] as const).map(([value, label, icon]) => (
          <button
            key={value} type="button" role="tab" aria-selected={tab === value}
            className={tab === value ? 'active' : ''} onClick={() => goTab(value)}
          >
            <Icon name={icon} size={17} /> {label}
          </button>
        ))}
      </div>

      {error && <div className="ap-alert error" role="alert">{error}</div>}
      {success && <div className="ap-alert success" role="status">{success}</div>}

      {tab === 'informacion' && (
        <div className="ap2-profile-grid">
          <section className="ap-panel">
            <div className="ap-panel-header">
              <div><span className="ap-eyebrow">INFORMACIÓN ACADÉMICA</span><h3>Sobre mí</h3></div>
              <Icon name="edit" />
            </div>
            <form className="ap2-form" onSubmit={saveAcademic}>
              <div className="ap2-fields">
                <label>Nombre completo<input value={fullName} disabled /></label>
                <label>Correo institucional<input value={user.institutional_email} disabled /></label>
                <label>Universidad<input value={user.university_name} disabled /></label>
                <label>Carrera<input value={profile.career || 'Sin registrar'} disabled /></label>
                <label>Ciclo académico
                  <select value={semester} onChange={e => setSemester(e.target.value)} required>
                    <option value="" disabled>Selecciona un ciclo</option>
                    {ciclos.map(cycle => <option key={cycle} value={cycle}>{cycle}</option>)}
                  </select>
                </label>
              </div>
              <label>Mi presentación
                <textarea rows={5} maxLength={500} value={bio} onChange={e => setBio(e.target.value)} placeholder="Cuéntale a otros estudiantes qué te motiva a aprender..." />
                <small className="ap2-counter">{bio.length}/500 caracteres</small>
              </label>
              <div className="ap2-form-bottom">
                <span><Icon name="lock" size={15} /> El correo institucional no se puede editar. Universidad y carrera se cambian abajo con contraseña.</span>
                <button type="submit" className="ap-btn" disabled={busy}>{busy ? 'Guardando...' : 'Guardar cambios'}</button>
              </div>
            </form>
            <div className="ap2-divider" />
            <form className="ap2-form" onSubmit={saveAcademicIdentity}>
              <span className="ap-eyebrow">ACTUALIZAR DATOS ACADÉMICOS</span>
              <p className="ap2-body-copy">Puedes cambiar tu universidad o carrera. Por seguridad, debes confirmar tu contraseña actual.</p>
              <label>Universidad
                <input list="ap-university-options" value={academic.university} maxLength={150} required
                  onChange={e => setAcademic(previous => ({ ...previous, university: e.target.value }))}
                  placeholder="Selecciona o escribe tu universidad" />
                <datalist id="ap-university-options">
                  {universities.map(u => <option key={u.id} value={u.name} />)}
                </datalist>
              </label>
              <label>Carrera
                <input value={academic.career} required maxLength={120}
                  onChange={e => setAcademic(previous => ({ ...previous, career: e.target.value }))}
                  placeholder="Escribe tu carrera" />
              </label>
              <label>Contraseña actual
                <input type="password" value={academic.currentPassword} required autoComplete="current-password"
                  onChange={e => setAcademic(previous => ({ ...previous, currentPassword: e.target.value }))} />
              </label>
              <div className="ap2-form-bottom">
                <span><Icon name="shield" size={15}/> Cambio protegido con contraseña.</span>
                <button className="ap-btn" type="submit" disabled={busy}>{busy ? 'Guardando...' : 'Actualizar universidad y carrera'}</button>
              </div>
            </form>
          </section>
          <aside className="ap2-side-stack">
            <section className="ap-panel">
              <span className="ap-eyebrow">TU PRESENTACIÓN PÚBLICA</span>
              <h3>Comparte tu historia</h3>
              <p className="ap2-body-copy">{profile.bio || 'Completa tu presentación para que otros estudiantes conozcan tus intereses.'}</p>
              <Link className="ap-text-link" to="/descubrir">Descubrir estudiantes <Icon name="arrow" size={15}/></Link>
            </section>
            <section className="ap-panel ap2-stats-card">
              <span className="ap-eyebrow">TU ACTIVIDAD</span><h3>Participación académica</h3>
              <div className="ap2-metric"><span>Asesorías completadas</span><strong>{given}</strong></div>
              <div className="ap2-metric"><span>Puntuación general</span><strong>{rating === '—' ? 'Sin puntuación' : `${rating} / 5`}</strong></div>
              <p className="ap2-hint">Métricas basadas en asesorías completadas y evaluaciones válidas.</p>
            </section>
          </aside>
        </div>
      )}

      {tab === 'habilidades' && (
        <div className="ap2-profile-grid ap2-skills-grid">
          {([
            { kind: 'teach' as const, title: 'Lo que puedo enseñar', caption: 'Comparte tus fortalezas.', input: teachInput, set: setTeachInput, variant: 'mint' as const, placeholder: 'Ej. Python, Excel...' },
            { kind: 'learn' as const, title: 'Lo que quiero aprender', caption: 'Cuéntanos qué te interesa descubrir.', input: learnInput, set: setLearnInput, variant: 'violet' as const, placeholder: 'Ej. Estadística, diseño UX...' }
          ]).map(group => (
            <section className="ap-panel" key={group.kind}>
              <span className="ap-eyebrow">{group.kind === 'teach' ? 'COMPARTIR CONOCIMIENTO' : 'SEGUIR CRECIENDO'}</span>
              <h3>{group.title}</h3><p className="ap2-body-copy">{group.caption}</p>
              <div className="ap2-skills-edit">
                {profile[group.kind].map(skill => (
                  <span className={`ap-pill ${group.variant}`} key={skill}>{skill}
                    <button type="button" disabled={busy} aria-label={`Quitar ${skill}`} onClick={() => void changeSkills(group.kind, skill)}>×</button>
                  </span>
                ))}
                {profile[group.kind].length === 0 && <p className="ap2-hint">Aún no registraste conocimientos en esta sección.</p>}
              </div>
              <form className="ap2-add-skill" onSubmit={e => { e.preventDefault(); void changeSkills(group.kind); }}>
                <input value={group.input} onChange={e => group.set(e.target.value)} maxLength={80} placeholder={group.placeholder} />
                <button type="submit" className="ap-btn" disabled={busy || !group.input.trim()}><Icon name="plus" size={15} /> Agregar</button>
              </form>
            </section>
          ))}
        </div>
      )}

      {tab === 'seguridad' && (
        <div className="ap2-profile-grid">
          <section className="ap-panel">
            <span className="ap-eyebrow">PROTEGE TU ACCESO</span><h3>Cambiar contraseña</h3>
            <p className="ap2-body-copy">Para cambiarla, confirma primero tu contraseña actual.</p>
            <form className="ap2-form" onSubmit={changePassword}>
              <label>Contraseña actual
                <input type={showPassword ? 'text' : 'password'} autoComplete="current-password" required value={password.current} onChange={e => setPassword(p => ({ ...p, current: e.target.value }))} />
              </label>
              <label>Nueva contraseña
                <input type={showPassword ? 'text' : 'password'} autoComplete="new-password" minLength={8} required value={password.next} onChange={e => setPassword(p => ({ ...p, next: e.target.value }))} />
              </label>
              <label>Confirmar nueva contraseña
                <input type={showPassword ? 'text' : 'password'} autoComplete="new-password" required value={password.repeat} onChange={e => setPassword(p => ({ ...p, repeat: e.target.value }))} />
              </label>
              <label className="ap2-check"><input type="checkbox" checked={showPassword} onChange={e => setShowPassword(e.target.checked)} /> Mostrar contraseñas</label>
              <button type="submit" className="ap-btn" disabled={busy}>{busy ? 'Actualizando...' : 'Actualizar contraseña'}</button>
            </form>
          </section>
          <aside className="ap2-side-stack">
            <section className="ap-panel"><span className="ap-eyebrow">DATOS DE ACCESO</span><h3>Tu cuenta</h3>
              <div className="ap2-metric"><span>Correo</span><strong className="ap2-wrap">{user.institutional_email}</strong></div>
              <div className="ap2-metric"><span>Universidad</span><strong>{user.university_name}</strong></div>
              <p className="ap2-hint">Tu correo y universidad se mantienen fijos para conservar tu identidad académica.</p>
            </section>
            <section className="ap-panel"><span className="ap-eyebrow">SESIÓN ACTIVA</span><h3>Salir de Aprendly</h3>
              <p className="ap2-body-copy">Puedes cerrar esta sesión cuando lo necesites.</p>
              <button type="button" className="ap-btn ap-btn-light" onClick={() => { logout(); navigate('/login', { replace: true }); }}><Icon name="logout" size={16} /> Cerrar sesión</button>
            </section>
          </aside>
        </div>
      )}

      {tab === 'reconocimientos' && (
        <div className="ap2-profile-grid">
          <section className="ap-panel ap2-award-card">
            <span className="ap-eyebrow">RECONOCIMIENTO APRENDLY</span>
            <div className="ap2-award-icon"><Icon name="medal" size={32} /></div>
            <h3>Lo que enseñas deja huella</h3>
            <p>Las personas con asesorías completadas y reseñas verificadas podrán optar a los reconocimientos de la comunidad.</p>
            <RecognitionDownload />
          </section>
          <aside className="ap-panel">
            <span className="ap-eyebrow">TU CAMINO</span><h3>Participación en Aprendly</h3>
            <div className="ap2-metric"><span>Posición general</span><strong>{me ? `Top ${me.position}` : 'Sin posición'}</strong></div>
            <div className="ap2-metric"><span>Asesorías completadas</span><strong>{given}</strong></div>
            <div className="ap2-metric"><span>Puntuación general</span><strong>{rating}</strong></div>
            <p className="ap2-hint">Solo el TOP 3 del ranking general puede descargar el reconocimiento.</p>
          </aside>
        </div>
      )}
    </div>
  );
}