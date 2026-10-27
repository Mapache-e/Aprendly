import { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { api } from '../services/api';
import type { ConversationView } from '../types';
import { Avatar, ButtonLink, Icon, PageHead } from '../components/UI';

export default function Matches() {
  const [conversations, setConversations] = useState<ConversationView[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  useEffect(() => {
    api.get<ConversationView[]>('/api/conversations').then(setConversations).catch(e => setError((e as Error).message)).finally(() => setLoading(false));
  }, []);
  return <><PageHead eyebrow="TU COMUNIDAD" title="Mis Peers" description="Estudiantes con quienes ya has abierto una conversación." action={<ButtonLink to="/descubrir"><Icon name="plus" size={17}/> Encontrar Peers</ButtonLink>}/>
  <div className="ap-peer-note"><Icon name="people" size={19}/><span>Estamos mostrando tus conversaciones existentes. La aceptación de solicitudes se incorporará cuando terminemos su API.</span></div>
  {loading && <p className="ap-subtle">Cargando Peers...</p>}{error && <p className="ap-alert error">{error}</p>}
  <div className="ap-peer-grid">{conversations.map(c => <article className="ap-peer-card" key={c.id}><Avatar first={c.other.first_name} last={c.other.last_name} size="lg"/><h3>{c.other.first_name} {c.other.last_name}</h3><p>{c.other.career}</p><small>{c.other.university_name}</small><div className="ap-peer-actions"><Link className="ap-btn" to={`/mensajes?c=${c.id}`}><Icon name="chat" size={16}/> Mensaje</Link><Link className="ap-btn ap-btn-light" to={`/perfil/${c.other.id}`}>Perfil</Link></div></article>)}</div>
  {!loading && !conversations.length && !error && <div className="ap-panel ap-empty"><Icon name="people" size={28}/><h3>¡Aquí aparecerán tus Peers!</h3><p>Conoce estudiantes desde Descubrir y comienza una conversación.</p><ButtonLink to="/descubrir">Descubrir estudiantes</ButtonLink></div>}
  </>;
}