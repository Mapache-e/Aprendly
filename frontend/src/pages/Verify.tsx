
import { useState, type FormEvent } from 'react';
import { Link, useNavigate } from 'react-router-dom';

import { api } from '../services/api';
import { useAuth } from '../hooks/AuthContext';
import type { PublicUser } from '../types';
import { Icon } from '../components/UI';

import aprendlyLogoBlanco from '../assets/aprendly-logo-blanco.png';
import aprendlyLogo from '../assets/aprendly-logo.png';
import aprendlyIconoBlanco from '../assets/aprendly-icono-blanco.png';

export default function Verify() {
  const navigate = useNavigate();
  const { setSession } = useAuth();

  const [email, setEmail] = useState(
    sessionStorage.getItem('skillsync_pending_email') || ''
  );

  const [code, setCode] = useState('');
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState('');

  const handleSubmit = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();

    if (busy) return;

    setError('');

    if (!email.trim()) {
      setError('Ingresa tu correo institucional.');
      return;
    }

    if (!/^\d{6}$/.test(code)) {
      setError('Ingresa un código de 6 dígitos.');
      return;
    }

    setBusy(true);

    try {
      const data = await api.post<{
        user: PublicUser;
        token: string;
      }>('/api/auth/verify', {
        email: email.trim().toLowerCase(),
        code
      });

      sessionStorage.removeItem('skillsync_pending_email');
      sessionStorage.removeItem('skillsync_demo_code');

      setSession(data.user, data.token);

      navigate('/perfil', { replace: true });

    } catch (err) {
      setError(
        err instanceof Error
          ? err.message
          : 'No se pudo verificar tu cuenta.'
      );
    } finally {
      setBusy(false);
    }
  };

  return (
    <div className="ap-verify-new">

      <style>{`
        .ap-verify-new,
        .ap-verify-new * {
          box-sizing: border-box;
        }

        .ap-verify-new {
          display: grid;
          grid-template-columns: 40% 60%;
          width: 100%;
          height: 100dvh;
          overflow: hidden;
          background: #fff;
          color: #34283c;
        }

        /* PANEL IZQUIERDO */

        .ap-verify-left {
          display: flex;
          flex-direction: column;
          justify-content: space-between;
          min-height: 0;
          padding: clamp(24px, 3vw, 46px);
          overflow: hidden;

          background:
            radial-gradient(
              circle at 80% 75%,
              rgba(239,119,125,.3),
              transparent 50%
            ),
            linear-gradient(145deg,#34283e,#49304a);

          color: #fff;
        }

        .ap-verify-logo {
          display: block;
          width: 170px;
          max-width: 65%;
          height: auto;
        }

        .ap-verify-left-content {
          max-width: 470px;
        }

        .ap-verify-left-content > span {
          font-size: 10px;
          letter-spacing: 1.5px;
          font-weight: 800;
          color: #ffbcbf;
        }

        .ap-verify-left h1 {
          color: #fff;
          font-size: clamp(29px, 3vw, 44px);
          line-height: 1.17;
          letter-spacing: -1.3px;
          margin: 18px 0;
        }

        .ap-verify-left h1 em {
          font-style: normal;
          color: #ffb2b8;
        }

        .ap-verify-left p {
          color: #e4d5e1;
          font-size: 13px;
          line-height: 1.7;
        }

        .ap-verify-illustration {
          height: clamp(110px, 20vh, 195px);
          margin-top: 25px;
          display: grid;
          place-items: center;
          position: relative;
        }

        .ap-verify-symbol-box {
          width: clamp(110px, 13vw, 165px);
          height: clamp(110px, 13vw, 165px);
          border-radius: 38px;
          background: linear-gradient(135deg,#f78b85,#df606e);
          display: grid;
          place-items: center;
          transform: rotate(-9deg);
          box-shadow: 0 22px 60px #1f152244;
        }

        .ap-verify-symbol-box img {
          width: 65%;
          transform: rotate(9deg);
        }

        .ap-verify-floating {
          position: absolute;
          background: #fff;
          color: #60475d;
          border-radius: 12px;
          padding: 11px 14px;
          font-size: 11px;
          font-weight: 750;
          box-shadow: 0 12px 30px #21152633;
        }

        .ap-verify-floating.one {
          top: 10%;
          left: 0;
        }

        .ap-verify-floating.two {
          right: 0;
          bottom: 6%;
        }

        .ap-verify-footer {
          font-size: 11px !important;
          color: #d7c1d2 !important;
        }

        /* PANEL DERECHO */

        .ap-verify-right {
          display: flex;
          flex-direction: column;
          min-height: 0;
          overflow-y: auto;
          padding:
            clamp(16px,2vh,24px)
            clamp(24px,4vw,70px);
        }

        .ap-verify-top {
          display: flex;
          justify-content: flex-end;
          font-size: 11px;
          color: #978896;
        }

        .ap-verify-top a {
          color: #dc6973;
          text-decoration: none;
          font-weight: 800;
        }

        .ap-verify-content {
          width: 100%;
          max-width: 460px;
          margin: auto;
          padding: 20px 0;
        }

        .ap-verify-brand {
          display: block;
          width: 155px;
          max-width: 100%;
          height: auto;
          margin-bottom: 30px;
        }

        .ap-verify-status-icon {
          width: 60px;
          height: 60px;
          display: grid;
          place-items: center;
          color: #de727c;
          background: #fff0ef;
          border-radius: 18px;
          margin-bottom: 22px;
        }

        .ap-verify-tag {
          font-size: 10px;
          font-weight: 800;
          letter-spacing: 1px;
          color: #d2646c;
        }

        .ap-verify-content h2 {
          color: #34283c;
          font-size: clamp(27px,2.5vw,34px);
          letter-spacing: -1px;
          margin: 10px 0;
        }

        .ap-verify-description {
          color: #978896;
          font-size: 12px;
          line-height: 1.7;
          margin: 0 0 27px;
        }

        .ap-verify-form {
          display: flex;
          flex-direction: column;
          gap: 19px;
        }

        .ap-verify-field {
          display: flex;
          flex-direction: column;
          gap: 8px;
        }

        .ap-verify-field > span {
          font-size: 12px;
          font-weight: 750;
          color: #453745;
        }

        .ap-verify-field input {
          height: 49px;
          width: 100%;
          border: 1px solid #eee1e7;
          border-radius: 11px;
          background: #fff;
          padding: 0 15px;
          font-size: 13px;
          color: #453847;
          outline: none;
          transition: border-color .2s, box-shadow .2s;
        }

        .ap-verify-field input:focus {
          border-color: #e67c83;
          box-shadow: 0 0 0 3px #f9dcde;
        }

        .ap-verify-code-input {
          text-align: center;
          font-size: 24px !important;
          font-weight: 800;
          letter-spacing: 9px;
          font-variant-numeric: tabular-nums;
        }

        .ap-verify-submit {
          width: 100%;
          min-height: 49px;
          border: 0;
          border-radius: 11px;
          display: flex;
          align-items: center;
          justify-content: center;
          gap: 10px;
          color: #fff;
          background: linear-gradient(110deg,#f0807e,#e46470);
          font-size: 13px;
          font-weight: 800;
          cursor: pointer;
          box-shadow: 0 9px 18px #e7797d25;
          transition: transform .2s, box-shadow .2s;
        }

        .ap-verify-submit:hover:not(:disabled) {
          transform: translateY(-2px);
          box-shadow: 0 12px 24px #e7797d35;
        }

        .ap-verify-submit:disabled {
          opacity: .65;
          cursor: not-allowed;
        }

        .ap-verify-error {
          margin-bottom: 18px;
          padding: 12px 14px;
          border: 1px solid #f5d6d6;
          border-radius: 10px;
          background: #fff1f1;
          color: #bc4353;
          font-size: 12px;
        }

        .ap-verify-note {
          margin-top: 23px;
          padding: 15px;
          background: #fff7f6;
          border: 1px solid #f8e5e5;
          border-radius: 12px;
          color: #947c86;
          font-size: 11px;
          line-height: 1.7;
        }

        .ap-verify-bottom {
          text-align: center;
          font-size: 11px;
          color: #998d98;
          margin-top: 25px;
        }

        .ap-verify-bottom a {
          text-decoration: none;
          font-weight: 800;
          color: #dc6973;
        }

        @media(max-width:900px) {
          .ap-verify-new {
            display: block;
            height: auto;
            min-height: 100dvh;
            overflow: visible;
          }

          .ap-verify-left {
            min-height: 220px;
            padding: 26px;
          }

          .ap-verify-left-content {
            margin: 20px 0;
          }

          .ap-verify-left h1 {
            font-size: 28px;
          }

          .ap-verify-illustration {
            display: none;
          }

          .ap-verify-right {
            padding: 28px 22px;
            overflow: visible;
          }

          .ap-verify-content {
            max-width: 460px;
          }
        }
      `}</style>

      {/* PANEL IZQUIERDO */}
      <aside className="ap-verify-left">
        <Link to="/login">
          <img
            src={aprendlyLogoBlanco}
            className="ap-verify-logo"
            alt="Aprendly"
          />
        </Link>

        <div className="ap-verify-left-content">
          <span>ESTÁS A UN PASO DE COMENZAR</span>

          <h1>
            Tu próxima aventura
            <em> comienza aquí.</em>
          </h1>

          <p>
            Confirma tu cuenta para comenzar a descubrir
            estudiantes, compartir conocimientos y encontrar
            nuevas oportunidades de aprendizaje.
          </p>

          <div className="ap-verify-illustration">
            <div className="ap-verify-symbol-box">
              <img src={aprendlyIconoBlanco} alt="" />
            </div>

            <span className="ap-verify-floating one">
              ✦ Tu comunidad te espera
            </span>

            <span className="ap-verify-floating two">
              ♥ Aprende y comparte
            </span>
          </div>
        </div>

        <p className="ap-verify-footer">
          Conecta. Aprende. Comparte. · Aprendly
        </p>
      </aside>

      {/* PANEL DERECHO */}
      <section className="ap-verify-right">
        <div className="ap-verify-top">
          <Link to="/login">
            Volver a iniciar sesión
          </Link>
        </div>

        <div className="ap-verify-content">
          <img
            className="ap-verify-brand"
            src={aprendlyLogo}
            alt="Aprendly"
          />

          <div className="ap-verify-status-icon">
            <Icon name="shield" size={30} />
          </div>

          <span className="ap-verify-tag">
            PROTEGEMOS TU CUENTA
          </span>

          <h2>Verifica tu cuenta</h2>

          <p className="ap-verify-description">
            Ingresa el código de seis dígitos asociado a tu registro
            para activar tu cuenta y continuar a tu perfil.
          </p>

          {error && (
            <div className="ap-verify-error" role="alert">
              {error}
            </div>
          )}

          <form className="ap-verify-form" onSubmit={handleSubmit}>
            <label className="ap-verify-field">
              <span>Correo institucional</span>

              <input
                type="email"
                value={email}
                onChange={e => setEmail(e.target.value)}
                placeholder="nombre@universidad.edu.pe"
                autoComplete="email"
                maxLength={160}
                required
              />
            </label>

            <label className="ap-verify-field">
              <span>Código de verificación</span>

              <input
                className="ap-verify-code-input"
                type="text"
                inputMode="numeric"
                pattern="[0-9]{6}"
                maxLength={6}
                value={code}
                onChange={e =>
                  setCode(
                    e.target.value.replace(/\D/g, '').slice(0, 6)
                  )
                }
                placeholder="000000"
                autoComplete="one-time-code"
                required
              />
            </label>

            <button
              type="submit"
              className="ap-verify-submit"
              disabled={busy || code.length !== 6}
            >
              {busy ? 'Verificando...' : 'Verificar y continuar'}
              {!busy && <Icon name="arrow" size={17} />}
            </button>
          </form>

          <div className="ap-verify-note">
            <Icon name="shield" size={16} />{' '}
            La verificación permite confirmar el acceso a tu cuenta
            antes de utilizar las funciones de Aprendly.
          </div>

          <div className="ap-verify-bottom">
            ¿Ya verificaste tu cuenta?{' '}
            <Link to="/login">Iniciar sesión</Link>
          </div>
        </div>
      </section>
    </div>
  );
}
