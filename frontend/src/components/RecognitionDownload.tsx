import { useEffect, useState } from 'react';
import { api } from '../services/api';
import { Icon } from './UI';

type Recognition = {
  me: null | { position: number; given: number; reviews: number; score: number | null };
  eligible: boolean;
  issued: boolean;
};

export default function RecognitionDownload() {
  const [data, setData] = useState<Recognition | null>(null);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState('');
  useEffect(() => {
    api.get<Recognition>('/api/ranking/recognition')
      .then(setData)
      .catch(e => setError((e as Error).message));
  }, []);
  const download = async () => {
    if (!data?.eligible || busy) return;
    setBusy(true); setError('');
    try {
      await api.downloadPdf('/api/ranking/recognition/pdf', 'reconocimiento-aprendly.pdf');
      setData(previous => previous ? { ...previous, issued: true } : previous);
    } catch (e) { setError((e as Error).message); }
    finally { setBusy(false); }
  };
  return <div>
    <p className="ap2-body-copy">Solo quienes ocupan los puestos <strong>TOP 1, TOP 2 y TOP 3</strong>
      del ranking general y tienen asesorías evaluadas pueden descargar su reconocimiento.</p>
    <div className="ap2-metric">
      <span>Tu posición actual</span><strong>{data?.me ? `TOP ${data.me.position}` : '—'}</strong>
    </div>
    <div className="ap2-metric">
      <span>Asesorías / reseñas</span>
      <strong>{data?.me ? `${data.me.given} / ${data.me.reviews}` : '—'}</strong>
    </div>
    {error && <p className="ap-alert error" role="alert">{error}</p>}
    {data?.eligible && <button type="button" className="ap-btn" disabled={busy} onClick={download}>
      <Icon name="medal" size={17}/>
      {busy ? 'Generando PDF...' : data.issued ? 'Volver a descargar reconocimiento' : 'Descargar reconocimiento'}
    </button>}
    {!data?.eligible && <p className="ap2-hint">La descarga está disponible únicamente para los primeros tres puestos.</p>}
    <p className="ap2-hint">Reconocimiento de participación en Aprendly; no es un certificado académico oficial.</p>
  </div>;
}