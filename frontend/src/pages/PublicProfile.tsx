import { useEffect, useState } from 'react';
import { Link, useNavigate, useParams } from 'react-router-dom';
import { api } from '../services/api';
import { useAuth } from '../hooks/AuthContext';
import type { ProfileFull } from '../types';
import type { RankingRow } from '../components/RankingPanel';
import { Avatar, Icon, SkillPills } from '../components/UI';

export default function PublicProfile() {
  const { id } = useParams();
  const navigate = useNavigate();
  const { user: signedIn } = useAuth();
  const [profile, setProfile] = useState<ProfileFull | null>(null);
  const [stats, setStats] = useState<RankingRow | null>(null);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(true);
  const [busy, setBusy] = useState(false);

  useEffect(() => {
    let active = true;
    setProfile(null); setStats(null); setError(''); setLoading(true);
    Promise.allSettled([
      api.get<ProfileFull>(`/api/profile/${id}`),
      api.get<{ stats: RankingRow | null }>(`/api/ranking/user/${id}`)
    ]).then(([p, r]) => {
      if (!active) return;
      if (p.status === 'fulfilled') setProfile(p.value);
      else setError(p.reason instanceof Error ? p.reason.message : 'No se pudo cargar el perfil.');
      if (r.status === 'fulfilled') setStats(r.value.stats);
    }).finally(() => { if (active) setLoading(false); });
    return () => { active = false; };
  }, [id]);

  const contact = async () => {
    if (busy || !id) return;
    setBusy(true); setError('');
    try {
      const response = await api.post<{ conversationId: number }>('/api/matches', { user_id: Number(id) });
      navigate(`/mensajes?c=${response.conversationId}`);
    } catch (err) { setError((err as Error).message); }
    finally { setBusy(false); }
  };

  if (loading) return <div className="ap-panel">Cargando perfil del estudiante...</div>;
  if (!profile) return <div className="ap-alert error" role="alert">{error || 'Estudiante no encontrado.'}</div>;

  const { user } = profile;
  const own = signedIn?.id === user.id;
  const rating = stats && stats.score !== null ? stats.score.toFixed(1) : '—';
  const given = stats?.given ?? null;

  return (
    <div className="ap2-public">
      <Link className="ap-text-link ap2-back" to="/descubrir">‹ Volver a Descubrir</Link>
      <div className="ap2-public-cover"><span>PERSONAS QUE INSPIRAN A APRENDER</span><strong>Conoce a tu próximo Peer</strong></div>

      <section className="ap-panel ap2-public-header">
        <div className="ap2-public-person">
          <Avatar first={user.first_name} last={user.last_name} size="lg" />
          <div className="ap2-minwidth">
            <span className="ap-eyebrow">PERFIL DE ESTUDIANTE</span>
            <h1>{user.first_name} {user.last_name}</h1>
            <p>{profile.career || 'Carrera sin registrar'}</p>
            <small>{user.university_name} · {profile.semester || 'Ciclo sin registrar'}</small>
          </div>
        </div>
        <div className="ap2-public-action">
          {own ? (
            <Link to="/perfil" className="ap-btn ap-btn-light"><Icon name="edit" size={16} /> Editar mi perfil</Link>
          ) : (
            <button className="ap-btn" type="button" disabled={busy} onClick={contact}>
              <Icon name="chat" size={17} /> {busy ? 'Abriendo conversación...' : 'Contactar'}
            </button>
          )}
          <small>El contacto abrirá una conversación en Mensajes.</small>
        </div>
      </section>

      {error && <div role="alert" className="ap-alert error">{error}</div>}

      <div className="ap2-public-metrics">
        <div><span className="ap2-metric-icon"><Icon name="star" size={19} /></span><strong>{rating}{rating !== '—' ? ' / 5' : ''}</strong><small>Puntuación general</small></div>
        <div><span className="ap2-metric-icon"><Icon name="calendar" size={19} /></span><strong>{given !== null ? given : '—'}</strong><small>Asesorías completadas</small></div>
        <div><span className="ap2-metric-icon"><Icon name="trophy" size={19} /></span><strong>{stats ? `Top ${stats.position}` : '—'}</strong><small>Puesto general</small></div>
      </div>

      <div className="ap2-public-columns">
        <section className="ap-panel">
          <div className="ap-panel-header"><div><span className="ap-eyebrow">CONOCE A TU PEER</span><h3>Acerca de {user.first_name}</h3></div><Icon name="user" size={20}/></div>
          <p className="ap2-body-copy">{profile.bio || 'Este estudiante todavía no ha compartido una presentación.'}</p>
          <div className="ap2-public-details">
            <div><small>UNIVERSIDAD</small><strong>{user.university_name}</strong></div>
            <div><small>CARRERA</small><strong>{profile.career || 'No registrada'}</strong></div>
            <div><small>CICLO</small><strong>{profile.semester || 'No registrado'}</strong></div>
          </div>
        </section>
        <section className="ap-panel">
          <span className="ap-eyebrow">CONOCIMIENTOS</span><h3>¿En qué puede ayudarte?</h3>
          <h4 className="ap2-knowledge-title">Puede enseñar</h4>
          <SkillPills skills={profile.teach} variant="mint" />
          <div className="ap2-divider" />
          <h4 className="ap2-knowledge-title">Quiere aprender</h4>
          <SkillPills skills={profile.learn} variant="violet" />
          <p className="ap2-hint">Las afinidades se calculan según los conocimientos compartidos.</p>
        </section>
      </div>
      <p className="ap2-hint ap2-public-disclaimer">La posición se calcula con la fórmula bayesiana y todas las asesorías completadas y evaluadas.</p>
    </div>
  );
}