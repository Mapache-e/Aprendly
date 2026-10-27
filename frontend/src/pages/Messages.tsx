import { useEffect, useRef, useState, type FormEvent } from 'react';
import { Link, useSearchParams } from 'react-router-dom';
import { api } from '../services/api';
import { useAuth } from '../hooks/AuthContext';
import type { ConversationView, MessageView } from '../types';
import { Avatar, Icon, PageHead } from '../components/UI';

export default function Messages() {
  const { user } = useAuth();
  const [params, setParams] = useSearchParams();
  const activeId = Number(params.get('c') || 0) || null;
  const [conversations, setConversations] = useState<ConversationView[]>([]);
  const [messages, setMessages] = useState<MessageView[]>([]);
  const [draft, setDraft] = useState('');
  const [search, setSearch] = useState('');
  const [error, setError] = useState('');
  const [showProposal, setShowProposal] = useState(false);
  const [date, setDate] = useState('');
  const [time, setTime] = useState('17:00');
  const [mode, setMode] = useState('Google Meet');
  const [busy, setBusy] = useState(false);
  const bottom = useRef<HTMLDivElement>(null);

  const reloadConversations = async () => {
    const list = await api.get<ConversationView[]>('/api/conversations');
    setConversations(list);
    if (!activeId && list.length) setParams({c:String(list[0].id)}, {replace:true});
  };
  useEffect(() => {reloadConversations().catch(e => setError((e as Error).message));}, []);
  useEffect(() => {
    if (!activeId) {setMessages([]);return;}
    let valid = true;
    api.get<MessageView[]>(`/api/conversations/${activeId}/messages`).then(m => {if (valid) setMessages(m);}).catch(e => {if (valid) setError((e as Error).message);});
    return () => {valid = false;};
  }, [activeId]);
  useEffect(() => {bottom.current?.scrollIntoView({block:'end'});}, [messages]);
  const active = conversations.find(c => c.id === activeId);

  const sendMessage = async (body: string) => {
    if (!activeId || !body.trim()) return false;
    setBusy(true);setError('');
    try {
      await api.post(`/api/conversations/${activeId}/messages`, {body:body.trim()});
      setMessages(await api.get<MessageView[]>(`/api/conversations/${activeId}/messages`));
      reloadConversations().catch(() => {});
      return true;
    } catch (e) {setError((e as Error).message);return false;}
    finally {setBusy(false);}
  };
  const submit = async (e: FormEvent) => {e.preventDefault();if (await sendMessage(draft)) setDraft('');};
  const propose = async (e: FormEvent) => {e.preventDefault();if (!date) return;const ok = await sendMessage(`Te propongo una asesoría el ${date} a las ${time}, por ${mode}. ¿Te parece bien?`);if (ok) setShowProposal(false);};

  return <><PageHead eyebrow="HABLEMOS DE IDEAS" title="Mensajes" description="Las mejores conversaciones comienzan con una pregunta." />
  {error && <div className="ap-alert error">{error}</div>}
  <div className="ap-messages-layout"><aside className="ap-chat-side"><div className="ap-chat-side-top"><h3>Conversaciones <small>({conversations.length})</small></h3><div className="ap-chat-search"><Icon name="search" size={16}/><input value={search} onChange={e => setSearch(e.target.value)} placeholder="Buscar personas..."/></div></div><div className="ap-conversations">{conversations.filter(c => `${c.other.first_name} ${c.other.last_name}`.toLowerCase().includes(search.toLowerCase())).map(c => <button type="button" key={c.id} className={`ap-conv ${activeId === c.id ? 'active' : ''}`} onClick={() => setParams({c:String(c.id)})}><Avatar first={c.other.first_name} last={c.other.last_name} size="sm"/><span><strong>{c.other.first_name} {c.other.last_name}</strong><small>{c.lastMessage || 'Comienza una conversación'}</small></span></button>)}{!conversations.length && <p className="ap-subtle ap-conv-empty">No tienes conversaciones todavía.</p>}</div></aside>
  <section className="ap-chat-room">{!active ? <div className="ap-chat-noactive"><Icon name="chat" size={33}/><h3>Selecciona una conversación</h3><p>O busca a alguien desde Descubrir.</p><Link className="ap-btn" to="/descubrir">Descubrir</Link></div> : <>
    <div className="ap-chat-room-head"><Avatar first={active.other.first_name} last={active.other.last_name} size="sm"/><div><strong>{active.other.first_name} {active.other.last_name}</strong><small>{active.other.career} · {active.other.university_name}</small></div><Link className="ap-btn ap-btn-light" to={`/perfil/${active.other.id}`}>Ver perfil</Link><button type="button" className="ap-btn" onClick={() => setShowProposal(v => !v)}><Icon name="calendar" size={16}/> Proponer sesión</button></div>
    <div className="ap-chat-messages"><span className="ap-chat-day">CONVERSACIÓN DE APRENDLY</span>{messages.map(m => <div key={m.id} className={`ap-chat-line ${m.sender_id === user?.id ? 'mine' : ''}`}><span className="ap-bubble">{m.body}</span><small>{new Date(m.created_at).toLocaleString('es-PE', {day:'2-digit',month:'short',hour:'2-digit',minute:'2-digit'})}</small></div>)}<div ref={bottom}/></div>
    {showProposal && <form className="ap-proposal" onSubmit={propose}><strong>Proponer asesoría</strong><p>Por ahora se enviará como mensaje. El registro formal en calendario se incorporará con la API de sesiones.</p><div><input aria-label="Fecha de asesoría" type="date" required min={new Date().toISOString().slice(0,10)} value={date} onChange={e => setDate(e.target.value)}/><input aria-label="Hora" type="time" value={time} onChange={e => setTime(e.target.value)}/><select aria-label="Modalidad" value={mode} onChange={e => setMode(e.target.value)}><option>Google Meet</option><option>Zoom</option><option>Presencial</option></select><button className="ap-btn" disabled={busy}>Enviar propuesta</button></div></form>}
    <div className="ap-chat-quick">{['¡Hola! Me gustaría aprender contigo', '¿Qué días estás disponible?', '¡Muchas gracias!'].map(t => <button type="button" key={t} onClick={() => setDraft(t)}>{t}</button>)}</div>
    <form onSubmit={submit} className="ap-chat-input"><input value={draft} onChange={e => setDraft(e.target.value)} placeholder="Escribe tu mensaje..." maxLength={1000} required/><button type="submit" className="ap-btn" disabled={busy}><Icon name="send" size={17}/> Enviar</button></form>
  </>}</section></div></>;
}