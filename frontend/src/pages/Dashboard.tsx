import { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { api } from '../services/api';
import type { ConversationView, MatchView } from '../types';
import { useAuth } from '../hooks/AuthContext';
import { Avatar, Icon, SkillPills } from '../components/UI';
import RankingPanel, { type RankingData } from '../components/RankingPanel';
import aprendlyIcono from '../assets/aprendly-icono-blanco.png';

type SessionPreview = {
  id: number;
  topic: string;
  scheduled_start: string;
  mentor_name: string;
  learner_name: string;
  role: 'mentor' | 'learner';
  status: string;
};

export default function Dashboard() {
  const { profile, user } = useAuth();
  const [matches, setMatches] = useState<MatchView[]>([]);
  const [convs, setConvs] = useState<ConversationView[]>([]);
  const [ranking, setRanking] = useState<RankingData | null>(null);
  const [sessions, setSessions] = useState<SessionPreview[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(false);

  useEffect(() => {
    let active = true;
    Promise.allSettled([
      api.get<MatchView[]>('/api/matches'),
      api.get<ConversationView[]>('/api/conversations'),
      api.get<RankingData>('/api/ranking'),
      api.get<SessionPreview[]>('/api/sessions')
    ]).then(([m, c, r, s]) => {
      if (!active) return;
      if (m.status === 'fulfilled') setMatches(m.value); else setError(true);
      if (c.status === 'fulfilled') setConvs(c.value);
      if (r.status === 'fulfilled') setRanking(r.value);
      if (s.status === 'fulfilled') setSessions(s.value);
    }).finally(() => { if (active) setLoading(false); });
    return () => { active = false; };
  }, []);

  const first = user?.first_name || 'estudiante';
  const skills = (profile?.teach.length || 0) + (profile?.learn.length || 0);
  const myRating = ranking?.me?.score;
  const currentDate = new Date().toLocaleDateString('es-PE', {
    day: 'numeric', month: 'long', year: 'numeric'
  });
  const scheduled = sessions.filter(s => s.status === 'accepted' &&
    new Date(`${s.scheduled_start}:00-05:00`).getTime() >= Date.now());
  const upcoming = scheduled.sort((a, b) => a.scheduled_start.localeCompare(b.scheduled_start))[0];

  return <div className="ap-dashboard-grid">
    <div className="ap-dashboard-main">
      <div className="ap-dashboard-greeting">
        <div>
          <span className="ap-eyebrow">✦ TU ESPACIO DE APRENDIZAJE</span>
          <h1>¡Qué bueno verte, <em>{first}!</em></h1>
          <p>Un espacio para aprender, compartir y seguir creciendo a tu ritmo.</p>
        </div>
        <span className="ap-date"><Icon name="calendar" size={16} />{currentDate}</span>
      </div>
      <section className="ap-hero">
        <div className="ap-hero-copy">
          <span className="ap-eyebrow">APRENDER NOS ACERCA</span>
          <h2>Lo que sabes puede<br />cambiar el día de alguien.</h2>
          <p>Conoce estudiantes con intereses afines y transforma tus habilidades en nuevas experiencias.</p>
          <div className="ap-hero-actions">
            <Link to="/descubrir" className="ap-btn">Descubrir estudiantes <Icon name="arrow" size={17} /></Link>
            <Link to="/matches" className="ap-text-link">Ver mis Peers <Icon name="arrow" size={15} /></Link>
          </div>
        </div>
        <div className="ap-hero-decoration" aria-hidden="true">
          <span className="ap-deco-a">
            <img src={aprendlyIcono} alt="" style={{ width:124, height:124, objectFit:'contain', display:'block' }} />
          </span>
          <span className="ap-deco-pill one">✦ Aprende</span>
          <span className="ap-deco-pill two" style={{ transform: 'translateY(65px)' }}>↗ Comparte</span>
          <span className="ap-deco-pill three">♥ Crece</span>
        </div>
      </section>
      <div className="ap-summary-strip">
        <Link to="/matches"><Icon name="people" /><span><strong>{convs.length}</strong><small>Peers con conversación</small></span><Icon name="chevron" size={17} /></Link>
        <Link to="/calendario"><Icon name="calendar" /><span><strong>{scheduled.length}</strong><small>Próximas asesorías</small></span><Icon name="chevron" size={17} /></Link>
        <Link to="/perfil"><Icon name="star" /><span><strong>{myRating != null ? myRating.toFixed(1) : '—'}<i>★</i></strong><small>Puntuación general</small></span><Icon name="chevron" size={17} /></Link>
        <Link to="/perfil"><Icon name="book" /><span><strong>{skills}</strong><small>Conocimientos</small></span><Icon name="chevron" size={17} /></Link>
      </div>
      <div className="ap-section-heading"><span className="ap-eyebrow">CONTINÚA TU CAMINO</span><h2>Lo importante, a un vistazo</h2></div>
      <div className="ap-dashboard-panels">
        <section className="ap-panel">
          <div className="ap-panel-header"><div><span className="ap-eyebrow">TU AGENDA</span><h3>Próxima asesoría</h3></div><Link to="/calendario" className="ap-text-link">Ver calendario <Icon name="arrow" size={15}/></Link></div>
          <div className="ap-placeholder ap-calendar-preview">
            <span><Icon name="calendar" size={24} /></span>
            <div>{upcoming ? <>
              <strong>{upcoming.topic}</strong>
              <p>{new Date(`${upcoming.scheduled_start.slice(0,10)}T12:00:00`).toLocaleDateString('es-PE', { day:'numeric', month:'long' })} · {upcoming.scheduled_start.slice(11,16)} · {upcoming.role === 'mentor' ? upcoming.learner_name : upcoming.mentor_name}</p>
            </> : <><strong>No tienes asesorías próximas</strong><p>Solicita una sesión desde Mi calendario y aparecerá aquí cuando sea aceptada.</p></>}</div>
          </div>
        </section>
        <section className="ap-panel ap-pending-panel">
          <div className="ap-panel-header"><div><span className="ap-eyebrow">COMUNIDAD</span><h3>Sigue haciendo crecer tu red</h3></div></div>
          <div className="ap-community-tip"><span><Icon name="spark" /></span><div>
            <strong>Cada conversación puede iniciar algo grande</strong>
            <p>Explora perfiles, comparte conocimientos y coordina tus próximas sesiones.</p>
            <Link to="/descubrir" className="ap-text-link">Explorar ahora <Icon name="arrow" size={14}/></Link>
          </div></div>
        </section>
      </div>
      <section className="ap-panel ap-suggest-section">
        <div className="ap-panel-header"><div><span className="ap-eyebrow">PERSONAS QUE TE PUEDEN AYUDAR</span><h3>Compatibles contigo</h3></div><Link to="/descubrir" className="ap-text-link">Ver todos <Icon name="arrow" size={15}/></Link></div>
        {loading && <p className="ap-subtle">Cargando coincidencias...</p>}
        {error && <p className="ap-alert error">No se pudieron cargar las coincidencias. Revisa el backend.</p>}
        {!loading && !matches.length && !error && <p className="ap-subtle">Aún no hay coincidencias. Agrega habilidades a tu perfil.</p>}
        <div className="ap-mini-grid">{matches.slice(0, 3).map(m => <article className="ap-mini-person" key={m.user.id}>
          <div className="ap-mini-header"><Avatar first={m.user.first_name} last={m.user.last_name}/><span>{Math.round(m.compatibility)}% match</span></div>
          <strong>{m.user.first_name} {m.user.last_name}</strong><small>{m.user.university_name}</small>
          <SkillPills skills={m.theyCanTeachYou.length ? m.theyCanTeachYou.slice(0,2) : m.teach.slice(0,2)}/>
          <Link to={`/perfil/${m.user.id}`} className="ap-text-link">Ver perfil <Icon name="arrow" size={14}/></Link>
        </article>)}</div>
      </section>
    </div>
    <div className="ap-dashboard-right">
      <RankingPanel data={ranking} loading={loading}/>
      <div className="ap-recognition"><span><Icon name="medal" size={23}/></span>
        <h3>Lo que compartes también deja huella.</h3>
        <p>Los tres mentores con mayor puntuación general pueden descargar su reconocimiento de participación.</p>
        <Link to="/perfil" className="ap-text-link">Ver mi perfil <Icon name="arrow" size={15}/></Link>
      </div>
    </div>
  </div>;
}