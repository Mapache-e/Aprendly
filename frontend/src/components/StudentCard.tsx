import { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { api } from '../services/api';
import type { MatchView } from '../types';
import { Avatar, Icon, SkillPills } from './UI';

export default function StudentCard({ match }: { match: MatchView }) {
  const navigate = useNavigate();
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState('');
  const u = match.user;
  const connect = async () => {
    setBusy(true);setError('');
    try {
      // API actual: abre una conversación. Las solicitudes con aceptación se integrarán después.
      const result = await api.post<{ conversationId: number }>('/api/matches', { user_id: u.id });
      navigate(`/mensajes?c=${result.conversationId}`);
    } catch (e) {setError((e as Error).message);} finally {setBusy(false);}
  };
  return <article className="ap-student-card">
    <div className="ap-student-top"><Avatar first={u.first_name} last={u.last_name} size="lg"/><div className="ap-student-id"><h3>{u.first_name} {u.last_name}</h3><small>{u.career || 'Estudiante universitario'}</small><small>{u.university_name}</small></div><span className="ap-match-rate">{Math.round(match.compatibility)}% compatible</span></div>
    <p className="ap-student-caption">TE PUEDE ENSEÑAR</p><SkillPills skills={match.teach.slice(0, 4)} variant="coral" />
    <p className="ap-student-caption">QUIERE APRENDER</p><SkillPills skills={match.learn.slice(0, 3)} variant="violet" />
    <div className="ap-student-foot"><Link className="ap-btn ap-btn-light" to={`/perfil/${u.id}`}>Ver perfil</Link><button className="ap-btn" type="button" disabled={busy} onClick={connect}>{busy ? 'Abriendo...' : 'Conectar'} <Icon name="arrow" size={15}/></button></div>
    {error && <p className="ap-alert error">{error}</p>}
  </article>;
}