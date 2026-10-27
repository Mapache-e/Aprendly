import { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { api } from '../services/api';
import { useAuth } from '../hooks/AuthContext';
import { Avatar, Icon } from './UI';

export type RankingRow = {
  position: number;
  id: number;
  name: string;
  university: string;
  career: string;
  given: number;
  reviews: number;
  rating: number | null;
  score: number | null;
};
export type RankingData = { top: RankingRow[]; me: RankingRow | null; total: number; type: 'historical' };

export default function RankingPanel({ data: provided, loading: providedLoading = false }: {
  data?: RankingData | null; loading?: boolean
}) {
  const { user } = useAuth();
  const [stored, setStored] = useState<RankingData | null>(null);
  const [loading, setLoading] = useState(false);
  useEffect(() => {
    if (provided !== undefined) return;
    let active = true;
    setLoading(true);
    api.get<RankingData>('/api/ranking')
      .then(value => { if (active) setStored(value); })
      .catch(() => { if (active) setStored(null); })
      .finally(() => { if (active) setLoading(false); });
    return () => { active = false; };
  }, [provided]);

  const data = provided === undefined ? stored : provided;
  const busy = provided === undefined ? loading : providedLoading;
  const top = data?.top.slice(0, 5) ?? [];
  const me = data?.me;
  const isTop = me && me.position <= 5;

  return (
    <aside className="ap-rank ap2-rank">
      <div className="ap-rank-heading">
        <span className="ap-eyebrow">LA COMUNIDAD TE INSPIRA</span>
        <h2>Top mentores <Icon name="spark" size={18} /></h2>
        <p>Mentores destacados por sus asesorías y evaluaciones.</p>
      </div>
      {busy && <p className="ap-subtle">Cargando clasificación...</p>}
      {!busy && !top.length && <p className="ap-subtle">Aún no hay usuarios registrados.</p>}
      <div className="ap2-rank-list">
        {top.map(row => (
          <Link key={row.id}
            to={row.id === user?.id ? '/perfil' : `/perfil/${row.id}`}
            className={`ap-rank-person ${row.position === 1 ? 'ap-rank-winner' : ''}`}>
            <span className="ap-rank-number">{String(row.position).padStart(2, '0')}</span>
            <Avatar first={row.name.split(' ')[0]} last={row.name.split(' ').slice(-1)[0]}
              size={row.position === 1 ? 'lg' : 'sm'} />
            <span className="ap-rank-person-info">
              <strong>{row.name}{row.id === user?.id ? ' (Tú)' : ''}</strong>
              <small>{row.given} asesorías · {row.university}</small>
            </span>
            <span className="ap-rank-score">★ {row.score !== null ? row.score.toFixed(1) : '—'}</span>
          </Link>
        ))}
      </div>
      <div className="ap-my-position">
        <span>TU POSICIÓN EN LA COMUNIDAD</span>
        <strong>{me ? `TOP ${me.position}` : '—'}</strong>
        {isTop && me && <small>{me.name} · Estás en los cinco primeros puestos.</small>}
      </div>
      <p className="ap-rank-disclaimer">Clasificación general según asesorías completadas y reseñas verificadas.</p>
    </aside>
  );
}