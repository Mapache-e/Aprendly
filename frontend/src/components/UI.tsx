import type { ReactNode } from 'react';
import { Link } from 'react-router-dom';

const artwork: Record<string, ReactNode> = {
  home: <><path d="m3 10 9-7 9 7v10H3z"/><path d="M9 20v-7h6v7"/></>,
  discover: <><circle cx="12" cy="12" r="9"/><path d="m15.5 8.5-3 6-4 1 3-6z"/></>,
  people: <><circle cx="9" cy="8" r="3"/><path d="M3 20v-2c0-3 2.5-5 6-5s6 2 6 5v2M17 5a3 3 0 0 1 0 6M17 14c2.6 0 4 2 4 5"/></>,
  chat: <path d="M20 12a8 8 0 0 1-8 8c-1.4 0-2.8-.4-4-1l-4 1 1-4a8 8 0 1 1 15-4z"/>,
  calendar: <><rect x="3" y="5" width="18" height="16" rx="2"/><path d="M8 3v4M16 3v4M3 10h18"/></>,
  panel: <><rect x="3" y="4" width="18" height="16" rx="2"/><path d="M9 4v16"/></>,
  search: <><circle cx="11" cy="11" r="7"/><path d="m16 16 5 5"/></>,
  bell: <><path d="M18 9a6 6 0 0 0-12 0c0 7-3 7-3 9h18c0-2-3-2-3-9M10 21h4"/></>,
  arrow: <path d="M5 12h14m-6-6 6 6-6 6"/>,
  chevron: <path d="m9 18 6-6-6-6"/>,
  star: <path d="m12 3 2.8 5.8 6.4 1-4.6 4.5 1.1 6.4-5.7-3-5.7 3 1.1-6.4-4.6-4.5 6.4-1z"/>,
  trophy: <><path d="M7 3h10v8a5 5 0 0 1-10 0V3ZM7 5H4v3a4 4 0 0 0 4 4M17 5h3v3a4 4 0 0 1-4 4M12 16v4M8 21h8"/></>,
  book: <path d="M12 5a8 8 0 0 0-9-1v15a8 8 0 0 1 9 1 8 8 0 0 1 9-1V4a8 8 0 0 0-9 1v15"/>,
  clock: <><circle cx="12" cy="12" r="9"/><path d="M12 7v5l4 2"/></>,
  user: <><circle cx="12" cy="8" r="4"/><path d="M4 21c0-4 3-7 8-7s8 3 8 7"/></>,
  logout: <><path d="M10 4H5a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h5M14 8l4 4-4 4M9 12h9"/></>,
  medal: <><circle cx="12" cy="15" r="6"/><path d="M8 10 5 3h5l2 5 2-5h5l-3 7"/></>,
  check: <path d="m5 12 4 4L19 6"/>,
  plus: <path d="M12 5v14M5 12h14"/>,
  close: <path d="M5 5l14 14M19 5 5 19"/>,
  send: <><path d="m21 3-7 18-3-8-8-3z"/><path d="m11 13 10-10"/></>,
  shield: <><path d="m12 2 8 4v6c0 5-3 8-8 10-5-2-8-5-8-10V6z"/><path d="m8 12 3 3 5-6"/></>,
  edit: <><path d="M4 17 3 21l4-1 12-12a2 2 0 0 0-3-3z"/></>,
  menu: <path d="M4 7h16M4 12h16M4 17h16"/>,
  mail: <><rect x="3" y="5" width="18" height="14" rx="2"/><path d="m3 7 9 7 9-7"/></>,
  lock: <><rect x="4" y="10" width="16" height="11" rx="2"/><path d="M8 10V7a4 4 0 0 1 8 0v3"/></>,
  spark: <path d="m12 2 2.3 7.7L22 12l-7.7 2.3L12 22l-2.3-7.7L2 12l7.7-2.3z"/>,
};

export function Icon({ name, size = 20, className = '' }: { name: string; size?: number; className?: string }) {
  return <svg className={className} width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">{artwork[name] || artwork.spark}</svg>;
}

export function Avatar({ first, last = '', size = 'md' }: { first: string; last?: string; size?: 'sm' | 'md' | 'lg' }) {
  return <span className={`ap-avatar ap-avatar-${size}`}>{(first.charAt(0) + last.charAt(0)).toUpperCase()}</span>;
}

export function PageHead({ eyebrow, title, description, action }: { eyebrow: string; title: string; description?: string; action?: ReactNode }) {
  return <div className="ap-page-head"><div><span className="ap-eyebrow">{eyebrow}</span><h1>{title}</h1>{description && <p>{description}</p>}</div>{action}</div>;
}

export function SkillPills({ skills, variant = 'coral' }: { skills: string[]; variant?: 'coral'|'mint'|'violet' }) {
  return <div className="ap-pills">{skills.length ? skills.map(s => <span key={s} className={`ap-pill ${variant}`}>{s}</span>) : <span className="ap-subtle">Sin conocimientos registrados</span>}</div>;
}

export function ButtonLink({ to, children, secondary = false }: { to: string; children: ReactNode; secondary?: boolean }) {
  return <Link to={to} className={`ap-btn ${secondary ? 'ap-btn-light' : ''}`}>{children}</Link>;
}