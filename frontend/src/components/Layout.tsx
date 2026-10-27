
import { useState, type FormEvent, type ReactNode } from 'react';
import { Link, NavLink, useLocation, useNavigate } from 'react-router-dom';
import { useAuth } from '../hooks/AuthContext';
import { Avatar, Icon } from './UI';

// Logotipos importados desde src/assets
import aprendlyLogoBlanco from '../assets/aprendly-logo-blanco.png';
import aprendlyIconoBlanco from '../assets/aprendly-icono-blanco.png';

const menu = [
  { to: '/', text: 'Inicio', icon: 'home' },
  { to: '/descubrir', text: 'Descubrir', icon: 'discover' },
  { to: '/matches', text: 'Peers', icon: 'people' },
  { to: '/mensajes', text: 'Mensajes', icon: 'chat' },
  { to: '/calendario', text: 'Mi calendario', icon: 'calendar' },
];

const titleByPath: Record<string, string> = {
  '/': 'Inicio',
  '/descubrir': 'Descubrir',
  '/matches': 'Peers',
  '/mensajes': 'Mensajes',
  '/calendario': 'Mi calendario',
  '/perfil': 'Mi perfil',
};

export default function Layout({
  children,
}: {
  children: ReactNode;
}) {
  const { user, logout } = useAuth();
  const location = useLocation();
  const navigate = useNavigate();

  const [collapsed, setCollapsed] = useState(
    () => localStorage.getItem('aprendly_menu_compacto') === '1'
  );

  const [mobileOpen, setMobileOpen] = useState(false);
  const [search, setSearch] = useState('');

  const toggle = () =>
    setCollapsed(current => {
      localStorage.setItem(
        'aprendly_menu_compacto',
        current ? '0' : '1'
      );
      return !current;
    });

  const signOut = () => {
    logout();
    navigate('/login');
  };

  const submitSearch = (event: FormEvent) => {
    event.preventDefault();
    const q = search.trim();

    navigate(
      q
        ? `/descubrir?name=${encodeURIComponent(q)}`
        : '/descubrir'
    );

    setSearch('');
  };

  if (!user) {
    return <main className="ap-auth-root">{children}</main>;
  }

  return (
    <div className={`ap-shell ${collapsed ? 'ap-collapsed' : ''}`}>

      {mobileOpen && (
        <button
          type="button"
          className="ap-backdrop"
          aria-label="Cerrar menú"
          onClick={() => setMobileOpen(false)}
        />
      )}

      <aside
        className={`ap-sidebar ${mobileOpen ? 'ap-mobile-open' : ''}`}
      >

        {/* LOGOTIPO Y BOTÓN DEL SIDEBAR */}
        <div className="ap-side-top">

          <Link
            to="/"
            onClick={() => setMobileOpen(false)}
            className="ap-side-brand"
            aria-label="Aprendly Inicio"
          >
            <img
              className="ap-side-logo"
              src={aprendlyLogoBlanco}
              alt="Aprendly"
            />

            <img
              className="ap-side-symbol"
              src={aprendlyIconoBlanco}
              alt=""
            />
          </Link>

          <button
            type="button"
            className="ap-side-toggle"
            aria-label={
              collapsed ? 'Expandir menú' : 'Contraer menú'
            }
            title={
              collapsed ? 'Expandir menú' : 'Contraer menú'
            }
            onClick={toggle}
          >
            <Icon name="panel" size={19} />
          </button>

          <button
            type="button"
            className="ap-side-mobile-close"
            aria-label="Cerrar menú"
            onClick={() => setMobileOpen(false)}
          >
            <Icon name="close" />
          </button>
        </div>

        {/* MENÚ DE NAVEGACIÓN */}
        <nav
          className="ap-side-menu"
          aria-label="Menú principal"
        >
          {menu.map(item => (
            <NavLink
              key={item.to}
              to={item.to}
              end={item.to === '/'}
              title={item.text}
              onClick={() => setMobileOpen(false)}
              className={({ isActive }) =>
                `ap-side-link ${isActive ? 'active' : ''}`
              }
            >
              <Icon name={item.icon} size={20} />

              <span className="ap-side-text">
                {item.text}
              </span>
            </NavLink>
          ))}
        </nav>

        {/* MENSAJE INFORMATIVO */}
        <div className="ap-side-tip">

          <span className="ap-side-tip-icon">
            <Icon name="spark" size={19} />
          </span>

          <strong>
            Siempre hay algo nuevo por aprender
          </strong>

          <p>
            Comparte lo que sabes y descubre nuevas ideas.
          </p>

          <Link to="/descubrir">
            Explorar ahora
            <Icon name="arrow" size={14} />
          </Link>
        </div>

        {/* USUARIO Y CERRAR SESIÓN */}
        <div className="ap-side-bottom">

          <Link
            to="/perfil"
            title="Ver mi perfil"
            onClick={() => setMobileOpen(false)}
            className="ap-side-account"
          >
            <Avatar
              first={user.first_name}
              last={user.last_name}
              size="sm"
            />

            <span className="ap-side-text">
              <strong>
                {user.first_name} {user.last_name}
              </strong>
              <small>Ver mi perfil ›</small>
            </span>
          </Link>

          <button
            type="button"
            className="ap-side-link ap-signout"
            onClick={signOut}
            title="Cerrar sesión"
          >
            <Icon name="logout" size={19} />

            <span className="ap-side-text">
              Cerrar sesión
            </span>
          </button>
        </div>

      </aside>

      {/* CONTENIDO PRINCIPAL */}
      <div className="ap-workspace">

        <header className="ap-topbar">

          <div className="ap-top-left">

            <button
              type="button"
              className="ap-hamburger"
              onClick={() => setMobileOpen(true)}
              aria-label="Abrir menú"
            >
              <Icon name="menu" />
            </button>

            <span className="ap-breadcrumb">
              Aprendly
              <span>/</span>
              <b>
                {titleByPath[location.pathname] || 'Perfil'}
              </b>
            </span>
          </div>

          <div className="ap-top-actions">

            <form
              className="ap-top-search"
              onSubmit={submitSearch}
            >
              <Icon name="search" size={17} />

              <input
                aria-label="Buscar estudiantes"
                placeholder="Busca habilidades o estudiantes..."
                value={search}
                onChange={e => setSearch(e.target.value)}
              />
            </form>

            <Link
              to="/mensajes"
              title="Mensajes"
              className="ap-top-icon"
            >
              <Icon name="bell" size={19} />
            </Link>

            <Link
              className="ap-top-user"
              to="/perfil"
            >
              <span>
                <strong>{user.first_name}</strong>
                <small>Estudiante</small>
              </span>

              <Avatar
                first={user.first_name}
                last={user.last_name}
                size="sm"
              />
            </Link>

          </div>
        </header>

        <main className="ap-content">
          {children}
        </main>

      </div>
    </div>
  );
}
