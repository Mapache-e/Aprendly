
import { useState, type FormEvent } from 'react';
import { Link, useNavigate } from 'react-router-dom';

import { useAuth } from '../hooks/AuthContext';
import { Icon } from '../components/UI';

import aprendlyLogoBlanco from '../assets/aprendly-logo-blanco.png';
import aprendlyIconoBlanco from '../assets/aprendly-icono-blanco.png';

export default function Login() {
  const { login } = useAuth();
  const navigate = useNavigate();

  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [rememberMe, setRememberMe] = useState(true);

  const [busy, setBusy] = useState(false);
  const [error, setError] = useState('');

  // ==========================================
  // INICIAR SESIÓN
  // ==========================================

  const handleSubmit = async (
    event: FormEvent<HTMLFormElement>
  ) => {
    event.preventDefault();

    if (busy) return;

    setError('');

    if (!email.trim() || !password) {
      setError('Completa tu correo y contraseña.');
      return;
    }

    setBusy(true);

    try {
      await login(
        email.trim().toLowerCase(),
        password
      );

      navigate('/', { replace: true });

    } catch (err) {
      setError(
        err instanceof Error
          ? err.message
          : 'No se pudo iniciar sesión. Verifica tus datos.'
      );
    } finally {
      setBusy(false);
    }
  };

  return (
    <div className="ap-login-screen">

      <style>{`
        /* =====================================
           APRENDLY - LOGIN
        ===================================== */

        .ap-login-screen,
        .ap-login-screen * {
          box-sizing: border-box;
        }

        .ap-login-screen {
          display: grid;
          grid-template-columns: 40% 60%;
          width: 100%;
          height: 100dvh;
          min-height: 0;
          overflow: hidden;
          background: #ffffff;
          color: #34283c;
        }

        /* =====================================
           PANEL IZQUIERDO
        ===================================== */

        .ap-login-promo {
          position: relative;
          display: flex;
          flex-direction: column;
          justify-content: space-between;
          min-height: 0;
          overflow: hidden;
          padding: clamp(24px, 3vw, 46px);

          background:
            radial-gradient(
              circle at 80% 75%,
              rgba(239, 119, 125, .3),
              transparent 50%
            ),
            linear-gradient(
              145deg,
              #34283e,
              #49304a
            );

          color: #ffffff;
        }

        .ap-login-logo {
          display: block;
          width: 170px;
          max-width: 65%;
          height: auto;
        }

        .ap-login-promo-content {
          position: relative;
          z-index: 1;
          width: 100%;
          max-width: 470px;
        }

        .ap-login-eyebrow {
          color: #ffbcbf;
          font-size: 10px;
          font-weight: 800;
          letter-spacing: 1.5px;
        }

        .ap-login-promo h1 {
          color: #ffffff;
          font-size: clamp(30px, 3vw, 44px);
          line-height: 1.17;
          letter-spacing: -1.3px;
          margin: 18px 0;
        }

        .ap-login-promo h1 em {
          color: #ffb2b8;
          font-style: normal;
        }

        .ap-login-promo-content > p {
          max-width: 390px;
          color: #e4d5e1;
          line-height: 1.7;
          font-size: 13px;
          margin: 0;
        }

        /* ILUSTRACIÓN */

        .ap-login-art {
          position: relative;
          height: clamp(120px, 22vh, 210px);
          display: grid;
          place-items: center;
          margin-top: 25px;
        }

        .ap-login-art-circle {
          display: grid;
          place-items: center;
          width: clamp(115px, 14vw, 175px);
          height: clamp(115px, 14vw, 175px);
          border-radius: 42px;

          background:
            linear-gradient(
              135deg,
              #f78b85,
              #df606e
            );

          transform: rotate(-9deg);

          box-shadow:
            0 22px 60px rgba(31, 21, 34, .28);
        }

        .ap-login-art-circle img {
          display: block;
          width: 65%;
          height: 65%;
          object-fit: contain;
          transform: rotate(9deg);
        }

        .ap-login-floating {
          position: absolute;
          display: flex;
          align-items: center;
          gap: 7px;

          padding: 11px 14px;
          border-radius: 12px;

          background: #ffffff;
          color: #6b5369;

          font-size: 10px;
          font-weight: 750;
          box-shadow: 0 12px 30px #21152633;
        }

        .ap-login-floating.one {
          top: 12%;
          left: 0;
        }

        .ap-login-floating.two {
          right: 0;
          bottom: 8%;
        }

        .ap-login-footer {
          color: #d7c1d2;
          font-size: 11px;
          margin: 0;
        }

        /* =====================================
           PANEL DERECHO
        ===================================== */

        .ap-login-right {
          display: flex;
          flex-direction: column;
          min-height: 0;

          padding:
            clamp(16px, 2vh, 24px)
            clamp(24px, 4vw, 70px);

          background: #ffffff;
          overflow-y: auto;
        }

        .ap-login-top {
          display: flex;
          align-items: center;
          justify-content: flex-end;
          gap: 6px;

          font-size: 11px;
          color: #8e808c;
          flex-shrink: 0;
        }

        .ap-login-top a,
        .ap-login-bottom a {
          color: #dd6972;
          font-weight: 800;
          text-decoration: none;
        }

        .ap-login-top a:hover,
        .ap-login-bottom a:hover {
          text-decoration: underline;
        }

        /* =====================================
           FORMULARIO
        ===================================== */

        .ap-login-content {
          width: 100%;
          max-width: 460px;
          margin: auto;
          padding: 24px 0;
        }

        .ap-login-tag {
          display: inline-flex;
          align-items: center;
          gap: 7px;

          padding: 7px 11px;
          border-radius: 30px;

          background: #fff0ef;
          color: #d2646c;

          font-size: 10px;
          letter-spacing: .6px;
          font-weight: 800;
        }

        .ap-login-content h2 {
          margin: 16px 0 7px;
          color: #34283c;

          font-size: clamp(27px, 2.5vw, 34px);
          line-height: 1.2;
          letter-spacing: -1px;
        }

        .ap-login-description {
          color: #978896;
          font-size: 12px;
          line-height: 1.6;
          margin: 0 0 26px;
        }

        .ap-login-form {
          display: flex;
          flex-direction: column;
          gap: 19px;
        }

        .ap-login-field {
          display: flex;
          flex-direction: column;
          gap: 8px;
          min-width: 0;
        }

        .ap-login-field > span {
          font-size: 12px;
          font-weight: 750;
          color: #453745;
        }

        .ap-login-input {
          position: relative;
          display: flex;
          align-items: center;
          width: 100%;
        }

        .ap-login-input > svg {
          position: absolute;
          left: 15px;
          color: #b4a4b1;
          pointer-events: none;
        }

        .ap-login-input input {
          width: 100%;
          height: 49px;
          min-width: 0;

          padding: 0 15px 0 43px;

          border: 1px solid #eee1e7;
          border-radius: 11px;

          background: #ffffff;
          color: #453847;

          font: inherit;
          font-size: 13px;
          outline: none;

          transition:
            border-color .2s ease,
            box-shadow .2s ease;
        }

        .ap-login-input input:focus {
          border-color: #e67c83;
          box-shadow: 0 0 0 3px #f9dcde;
        }

        .ap-login-input input::placeholder {
          color: #b1a3ae;
        }

        .ap-login-password input {
          padding-right: 76px;
        }

        .ap-login-show {
          position: absolute;
          right: 10px;
          top: 50%;
          transform: translateY(-50%);

          padding: 8px 5px;

          border: none;
          background: transparent;

          color: #d26971;
          font-size: 11px;
          font-weight: 800;
          cursor: pointer;
        }

        .ap-login-show:hover {
          color: #a94e5b;
        }

        /* RECORDAR SESIÓN */

        .ap-login-options {
          display: flex;
          align-items: center;
          justify-content: space-between;
          gap: 12px;

          margin-top: -2px;
        }

        .ap-login-remember {
          display: inline-flex;
          align-items: center;
          gap: 9px;

          color: #8d7e89;
          font-size: 11px;
          cursor: pointer;
        }

        .ap-login-remember input {
          width: 15px;
          height: 15px;
          margin: 0;
          accent-color: #e8757a;
        }

        .ap-login-note {
          color: #a0929d;
          font-size: 10px;
        }

        /* BOTÓN PRINCIPAL */

        .ap-login-submit {
          display: flex;
          align-items: center;
          justify-content: center;
          gap: 10px;

          width: 100%;
          min-height: 49px;

          margin-top: 3px;
          border: none;
          border-radius: 11px;

          background:
            linear-gradient(
              110deg,
              #f0807e,
              #e46470
            );

          color: #ffffff;
          font-size: 13px;
          font-weight: 800;

          cursor: pointer;
          box-shadow: 0 9px 18px #e7797d25;

          transition:
            transform .2s ease,
            box-shadow .2s ease,
            filter .2s ease;
        }

        .ap-login-submit:hover:not(:disabled) {
          transform: translateY(-2px);
          box-shadow: 0 12px 24px #e7797d35;
          filter: brightness(1.02);
        }

        .ap-login-submit:disabled {
          opacity: .65;
          cursor: not-allowed;
        }

        .ap-login-bottom {
          margin-top: 23px;
          color: #998d98;
          font-size: 11px;
          text-align: center;
        }

        .ap-login-divider {
          height: 1px;
          background: #f2e9ed;
          margin: 23px 0;
        }

        .ap-login-help {
          text-align: center;
          color: #a0929d;
          font-size: 11px;
          line-height: 1.6;
        }

        .ap-login-help strong {
          color: #dd6972;
        }

        /* MENSAJE DE ERROR */

        .ap-login-error {
          margin-bottom: 18px;

          padding: 12px 14px;
          border-radius: 10px;

          background: #fff1f1;
          color: #bc4353;

          border: 1px solid #f5d6d6;
          font-size: 11px;
          line-height: 1.5;
        }

        /* =====================================
           PANTALLAS DE BAJA ALTURA
        ===================================== */

        @media (min-width: 901px) and (max-height: 650px) {
          .ap-login-content {
            padding: 8px 0;
          }

          .ap-login-description {
            margin-bottom: 15px;
          }

          .ap-login-form {
            gap: 12px;
          }

          .ap-login-input input {
            height: 41px;
          }

          .ap-login-divider {
            margin: 12px 0;
          }

          .ap-login-bottom {
            margin-top: 12px;
          }

          .ap-login-art {
            height: 105px;
            margin-top: 10px;
          }
        }

        /* =====================================
           TABLET / MÓVIL
        ===================================== */

        @media (max-width: 900px) {
          .ap-login-screen {
            display: block;
            height: auto;
            min-height: 100dvh;
            overflow: visible;
          }

          .ap-login-promo {
            min-height: 235px;
            padding: 26px;
          }

          .ap-login-promo-content {
            margin: 20px 0;
          }

          .ap-login-promo h1 {
            font-size: 29px;
          }

          .ap-login-art {
            display: none;
          }

          .ap-login-right {
            min-height: 500px;
            padding: 28px 22px;
            overflow: visible;
          }

          .ap-login-content {
            max-width: 460px;
          }
        }

        @media (max-width: 520px) {
          .ap-login-promo h1 {
            font-size: 25px;
          }

          .ap-login-content h2 {
            font-size: 27px;
          }

          .ap-login-options {
            align-items: flex-start;
          }
        }

        @media (prefers-reduced-motion: reduce) {
          .ap-login-submit {
            transition: none;
          }
        }
      `}</style>

      {/* =====================================
          PANEL IZQUIERDO
      ===================================== */}

      <aside className="ap-login-promo">

        <Link to="/login" aria-label="Aprendly">
          <img
            className="ap-login-logo"
            src={aprendlyLogoBlanco}
            alt="Aprendly"
          />
        </Link>

        <div className="ap-login-promo-content">

          <span className="ap-login-eyebrow">
            TU COMUNIDAD, TU SIGUIENTE PASO
          </span>

          <h1>
            Aprender es mejor
            <em> cuando lo haces acompañado.</em>
          </h1>

          <p>
            Encuentra estudiantes que compartan tus intereses,
            enseña lo que sabes y descubre nuevas formas de
            aprender junto a otros.
          </p>

          <div className="ap-login-art">

            <div className="ap-login-art-circle">
              <img
                src={aprendlyIconoBlanco}
                alt=""
              />
            </div>

            <span className="ap-login-floating one">
              ✦ Comparte lo que sabes
            </span>

            <span className="ap-login-floating two">
              ♥ Aprende algo nuevo
            </span>

          </div>
        </div>

        <p className="ap-login-footer">
          Conecta. Aprende. Comparte. · Aprendly
        </p>

      </aside>

      {/* =====================================
          PANEL DERECHO
      ===================================== */}

      <section className="ap-login-right">

        <div className="ap-login-top">
          ¿Aún no tienes cuenta?
          <Link to="/registro">
            Regístrate
          </Link>
        </div>

        <div className="ap-login-content">

          <span className="ap-login-tag">
            <Icon name="spark" size={14} />
            BIENVENIDO A APRENDLY
          </span>

          <h2>¡Qué bueno verte!</h2>

          <p className="ap-login-description">
            Inicia sesión y continúa aprendiendo con tu comunidad
            universitaria.
          </p>

          {error && (
            <div
              className="ap-login-error"
              role="alert"
            >
              {error}
            </div>
          )}

          <form
            className="ap-login-form"
            onSubmit={handleSubmit}
          >

            {/* CORREO */}

            <label className="ap-login-field">
              <span>Correo institucional</span>

              <div className="ap-login-input">

                <Icon name="mail" size={18} />

                <input
                  type="email"
                  placeholder="nombre@universidad.edu.pe"
                  value={email}
                  onChange={event => {
                    setEmail(event.target.value);
                    setError('');
                  }}
                  autoComplete="username"
                  maxLength={160}
                  required
                />

              </div>
            </label>

            {/* CONTRASEÑA */}

            <label className="ap-login-field">
              <span>Contraseña</span>

              <div className="ap-login-input ap-login-password">

                <Icon name="lock" size={18} />

                <input
                  type={showPassword ? 'text' : 'password'}
                  placeholder="Ingresa tu contraseña"
                  value={password}
                  onChange={event => {
                    setPassword(event.target.value);
                    setError('');
                  }}
                  autoComplete="current-password"
                  required
                />

                <button
                  className="ap-login-show"
                  type="button"
                  onClick={() =>
                    setShowPassword(current => !current)
                  }
                  aria-label={
                    showPassword
                      ? 'Ocultar contraseña'
                      : 'Mostrar contraseña'
                  }
                  aria-pressed={showPassword}
                >
                  {showPassword ? 'Ocultar' : 'Mostrar'}
                </button>

              </div>
            </label>

            {/* OPCIONES */}

            <div className="ap-login-options">

              <label className="ap-login-remember">

                <input
                  type="checkbox"
                  checked={rememberMe}
                  onChange={event =>
                    setRememberMe(event.target.checked)
                  }
                />

                Recordarme

              </label>

              <span className="ap-login-note">
                Acceso seguro
              </span>
            </div>

            {/* BOTÓN DE INICIO */}

            <button
              type="submit"
              className="ap-login-submit"
              disabled={busy}
            >
              {busy
                ? 'Iniciando sesión...'
                : 'Entrar a Aprendly'}

              {!busy && (
                <Icon name="arrow" size={17} />
              )}
            </button>

          </form>

          <div className="ap-login-bottom">
            ¿Todavía no formas parte de Aprendly?{' '}
            <Link to="/registro">
              Crear mi cuenta
            </Link>
          </div>

          <div className="ap-login-divider" />

          <div className="ap-login-help">
            Tu espacio para aprender, enseñar y compartir
            conocimientos con otros estudiantes.
          </div>

        </div>
      </section>
    </div>
  );
}
