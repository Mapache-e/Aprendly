import { useEffect, useState, type FormEvent } from 'react';
import { useSearchParams } from 'react-router-dom';
import { api } from '../services/api';
import type { MatchView } from '../types';
import { Icon, PageHead } from '../components/UI';
import StudentCard from '../components/StudentCard';

export default function Discover() {
  const [params] = useSearchParams();
  const [name, setName] = useState(params.get('name') || '');
  const [university, setUniversity] = useState('');
  const [career, setCareer] = useState('');
  const [knowledge, setKnowledge] = useState('');
  const [results, setResults] = useState<MatchView[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const load = async (filters: { name: string; university: string; career: string; knowledge: string }) => {
    setLoading(true); setError('');
    try {
      const query = new URLSearchParams();
      Object.entries(filters).forEach(([k, v]) => { if (v.trim()) query.set(k, v.trim()); });
      const data = await api.get<MatchView[]>(`/api/matches/discover${query.size ? '?' + query : ''}`);
      setResults(data);
    } catch (err) {setError((err as Error).message);} finally {setLoading(false);}
  };
  useEffect(() => {
    const q = params.get('name') || '';
    setName(q);
    load({ name:q, university:'', career:'', knowledge:'' });
  }, [params]);
  const search = (e: FormEvent) => {e.preventDefault();load({name, university, career, knowledge});};
  const clear = () => {setName('');setCareer('');setUniversity('');setKnowledge('');load({name:'',university:'',career:'',knowledge:''});};
  return <>
    <PageHead eyebrow="EXPLORA NUEVAS POSIBILIDADES" title="Descubre talentos" description="Encuentra estudiantes con quienes puedas aprender y compartir." action={<span className="ap-label-count">{results.length} resultados</span>}/>
    <div className="ap-discover-banner"><span className="ap-eyebrow">UN MUNDO DE CONOCIMIENTOS</span><h2>Tu próximo aprendizaje está a un clic ✦</h2><p>Busca por universidad, carrera o habilidad. Todos tenemos algo que enseñar.</p></div>
    <div className="ap-discover-layout"><aside className="ap-panel ap-filters"><h3><Icon name="search" size={18}/> Filtrar búsqueda</h3><form onSubmit={search} className="ap-form"><label>Nombre del estudiante<input value={name} onChange={e => setName(e.target.value)} placeholder="Ej. Andrea"/></label><label>Universidad<input value={university} onChange={e => setUniversity(e.target.value)} placeholder="Ej. UTP"/></label><label>Carrera<input value={career} onChange={e => setCareer(e.target.value)} placeholder="Ej. Ingeniería"/></label><label>Conocimiento<input value={knowledge} onChange={e => setKnowledge(e.target.value)} placeholder="Ej. Estadística"/></label><button className="ap-btn" disabled={loading}>Buscar estudiantes <Icon name="search" size={16}/></button></form><button type="button" onClick={clear} className="ap-clear">Limpiar filtros</button></aside>
    <section className="ap-results"><div className="ap-results-heading"><h3>Estudiantes para ti <span>({results.length})</span></h3><small>Ordenados por compatibilidad</small></div>{loading && <p className="ap-subtle">Buscando estudiantes...</p>}{error && <p className="ap-alert error">{error}</p>}{!loading && !results.length && !error && <div className="ap-panel"><p>No encontramos coincidencias con esos filtros.</p></div>}<div className="ap-students-grid">{results.map(m => <StudentCard key={m.user.id} match={m}/>)}</div></section></div>
  </>;
}