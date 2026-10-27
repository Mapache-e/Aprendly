
import {
  BrowserRouter,
  Navigate,
  Route,
  Routes
} from 'react-router-dom';

import {
  AuthProvider,
  useAuth
} from './hooks/AuthContext';

import Layout from './components/Layout';

import Login from './pages/Login';
import Register from './pages/Register';
import Dashboard from './pages/Dashboard';
import Discover from './pages/Discover';
import Matches from './pages/Matches';
import Messages from './pages/Messages';
import Calendar from './pages/Calendar';
import Profile from './pages/Profile';
import PublicProfile from './pages/PublicProfile';

// ==========================================
// PROTEGER PÁGINAS PRIVADAS
// ==========================================

function Protected({
  children
}: {
  children: JSX.Element;
}) {
  const { user, loading } = useAuth();

  if (loading) {
    return (
      <div className="ap-loading">
        Cargando Aprendly...
      </div>
    );
  }

  return user
    ? children
    : <Navigate to="/login" replace />;
}

// ==========================================
// RUTAS
// ==========================================

function RouterContent() {
  return (
    <Layout>
      <Routes>

        {/* AUTENTICACIÓN */}
        <Route
          path="/login"
          element={<Login />}
        />

        <Route
          path="/registro"
          element={<Register />}
        />

        {/* DASHBOARD */}
        <Route
          path="/"
          element={
            <Protected>
              <Dashboard />
            </Protected>
          }
        />

        {/* DESCUBRIR */}
        <Route
          path="/descubrir"
          element={
            <Protected>
              <Discover />
            </Protected>
          }
        />

        {/* PEERS */}
        <Route
          path="/matches"
          element={
            <Protected>
              <Matches />
            </Protected>
          }
        />

        <Route
          path="/peers"
          element={
            <Navigate to="/matches" replace />
          }
        />

        {/* MENSAJES */}
        <Route
          path="/mensajes"
          element={
            <Protected>
              <Messages />
            </Protected>
          }
        />

        {/* CALENDARIO */}
        <Route
          path="/calendario"
          element={
            <Protected>
              <Calendar />
            </Protected>
          }
        />

        <Route
          path="/asesorias"
          element={
            <Navigate to="/calendario" replace />
          }
        />

        {/* RANKING EN DASHBOARD */}
        <Route
          path="/ranking"
          element={
            <Navigate to="/" replace />
          }
        />

        {/* PERFIL */}
        <Route
          path="/perfil"
          element={
            <Protected>
              <Profile />
            </Protected>
          }
        />

        <Route
          path="/perfil/:id"
          element={
            <Protected>
              <PublicProfile />
            </Protected>
          }
        />

        {/* RUTAS DESCONOCIDAS */}
        <Route
          path="*"
          element={<Navigate to="/" replace />}
        />

      </Routes>
    </Layout>
  );
}

// ==========================================
// APLICACIÓN PRINCIPAL
// ==========================================

export default function App() {
  return (
    <AuthProvider>
      <BrowserRouter>
        <RouterContent />
      </BrowserRouter>
    </AuthProvider>
  );
}
