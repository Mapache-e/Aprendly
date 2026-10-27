
import {
  useState,
  type ChangeEvent,
  type FormEvent
} from 'react';

import { Link, useNavigate } from 'react-router-dom';
import { api } from '../services/api';
import { Icon } from '../components/UI';

import aprendlyLogoBlanco from '../assets/aprendly-logo-blanco.png';
import aprendlyIconoBlanco from '../assets/aprendly-icono-blanco.png';

const universidades = [
  'Universidad Tecnológica del Perú (UTP)',
  'Universidad Nacional Mayor de San Marcos',
  'Pontificia Universidad Católica del Perú',
  'Universidad Peruana de Ciencias Aplicadas',
  'Universidad Nacional de Ingeniería',
  'Universidad Privada del Norte',
  'Universidad César Vallejo',
  'Universidad de Lima',
  'Universidad de San Martín de Porres',
  'Universidad Nacional Federico Villarreal',
  'Universidad Continental',
  'Universidad Científica del Sur'
];

const ciclos = [
  '1.er ciclo',
  '2.º ciclo',
  '3.er ciclo',
  '4.º ciclo',
  '5.º ciclo',
  '6.º ciclo',
  '7.º ciclo',
  '8.º ciclo',
  '9.º ciclo',
  '10.º ciclo'
];

type RegisterForm = {
  first_name: string;
  last_name: string;
  institutional_email: string;
  university: string;
  otherUniversity: string;
  career: string;
  semester: string;
  password: string;
  confirm_password: string;
};

const initialForm: RegisterForm = {
  first_name: '',
  last_name: '',
  institutional_email: '',
  university: '',
  otherUniversity: '',
  career: '',
  semester: '',
  password: '',
  confirm_password: ''
};

export default function Register() {
  const navigate = useNavigate();

  const [form, setForm] = useState<RegisterForm>(initialForm);
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirm, setShowConfirm] = useState(false);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState('');

  const update =
    (field: keyof RegisterForm) =>
    (event: ChangeEvent<HTMLInputElement | HTMLSelectElement>) => {
      setForm(current => ({
        ...current,
        [field]: event.target.value
      }));

      setError('');
    };

  const getUniversity = () =>
    form.university === 'otros'
      ? form.otherUniversity.trim()
      : form.university.trim();

  const handleSubmit = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault();

    if (busy) return;

    setError('');

    if (!form.first_name.trim() || !form.last_name.trim()) {
      setError('Ingresa tu nombre y apellido.');
      return;
    }

    if (!getUniversity()) {
      setError('Selecciona o escribe tu universidad.');
      return;
    }

    if (!form.career.trim() || !form.semester) {
      setError('Completa tu carrera y ciclo académico.');
      return;
    }

    if (form.password.length < 8) {
      setError('La contraseña debe tener al menos 8 caracteres.');
      return;
    }

    if (form.password !== form.confirm_password) {
      setError('Las contraseñas no coinciden.');
      return;
    }

    setBusy(true);

    try {
      const email = form.institutional_email.trim().toLowerCase();

      await api.post('/api/auth/register', {
        first_name: form.first_name.trim(),
        last_name: form.last_name.trim(),
        institutional_email: email,
        university_name: getUniversity(),
        career: form.career.trim(),
        semester: form.semester,
        password: form.password,
        confirm_password: form.confirm_password
      });

      // Limpiar datos del flujo antiguo de verificación.
      sessionStorage.removeItem('skillsync_pending_email');
      sessionStorage.removeItem('skillsync_demo_code');

      // Ir directamente al inicio de sesión.
      navigate('/login', {
        replace: true,
        state: {
          registrationSuccess: true,
          registeredEmail: email
        }
      });

    } catch (err) {
      setError(
        err instanceof Error
          ? err.message
          : 'No se pudo completar el registro.'
      );
    } finally {
      setBusy(false);
    }
  };

  return (
    <div className="ap-reg-screen">

      <style>{`
        .ap-reg-screen,
        .ap-reg-screen * {
          box-sizing: border-box;
        }

        .ap-reg-screen {
          display: grid;
          grid-template-columns: 40% 60%;
          width: 100%;
          height: 100dvh;
          min-height: 0;
          overflow: hidden;
          background: #fff;
          color: #34283c;
        }

        /* PANEL IZQUIERDO */

        .ap-reg-promo {
          position: relative;
          display: flex;
          flex-direction: column;
          justify-content: space-between;
          padding: clamp(24px, 3vw, 46px);
          min-height: 0;
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

        .ap-reg-logo {
          width: 170px;
          max-width: 65%;
          height: auto;
          display: block;
        }

        .ap-reg-promo-content {
          position: relative;
          z-index: 1;
          max-width: 470px;
        }

        .ap-reg-eyebrow {
          color: #ffbcbf;
          font-size: 10px;
          font-weight: 800;
          letter-spacing: 1.5px;
        }

        .ap-reg-promo h1 {
          color: #fff;
          font-size: clamp(28px,3vw,44px);
          line-height: 1.17;
          letter-spacing: -1.3px;
          margin: 18px 0;
        }

        .ap-reg-promo h1 em {
          font-style: normal;
          color: #ffb2b8;
        }

        .ap-reg-promo-content > p {
          max-width: 390px;
          color: #e4d5e1;
          line-height: 1.7;
          font-size: 13px;
        }

        .ap-reg-art {
          position: relative;
          height: clamp(100px,18vh,190px);
          display: grid;
          place-items: center;
          margin-top: 24px;
        }

        .ap-reg-art-circle {
          display: grid;
          place-items: center;
          width: clamp(95px,12vw,155px);
          height: clamp(95px,12vw,155px);
          border-radius: 40px;
          background: linear-gradient(135deg,#f78b85,#df606e);
          transform: rotate(-9deg);
          box-shadow: 0 22px 60px #1f152244;
        }

        .ap-reg-art-circle img {
          width: 65%;
          transform: rotate(9deg);
        }

        .ap-reg-floating {
          position: absolute;
          border-radius: 12px;
          background: #fff;
          padding: 10px 13px;
          color: #6b5369;
          font-size: 10px;
          font-weight: 750;
          box-shadow: 0 12px 30px #21152633;
        }

        .ap-reg-floating.one {
          left: 0;
          top: 13%;
        }

        .ap-reg-floating.two {
          right: 0;
          bottom: 7%;
        }

        .ap-reg-footer {
          font-size: 11px;
          color: #d7c1d2;
        }

        /* PANEL DERECHO */

        .ap-reg-right {
          display: flex;
          flex-direction: column;
          min-height: 0;
          padding:
            clamp(14px,2vh,24px)
            clamp(24px,4vw,70px);
          background: #fff;
          overflow-y: auto;
        }

        .ap-reg-top {
          display: flex;
          justify-content: flex-end;
          gap: 5px;
          align-items: center;
          font-size: 11px;
          color: #8e808c;
          flex-shrink: 0;
        }

        .ap-reg-top a,
        .ap-reg-bottom a {
          color: #dd6972;
          font-weight: 800;
          text-decoration: none;
        }

        .ap-reg-content {
          width: 100%;
          max-width: 690px;
          margin: auto;
          padding: 12px 0;
        }

        .ap-reg-tag {
          display: inline-flex;
          align-items: center;
          gap: 7px;
          background: #fff0ef;
          color: #d2646c;
          border-radius: 30px;
          padding: 7px 11px;
          font-size: 10px;
          letter-spacing: .6px;
          font-weight: 800;
        }

        .ap-reg-content h2 {
          margin: 12px 0 4px;
          color: #34283c;
          font-size: clamp(23px,2vw,29px);
          letter-spacing: -.8px;
          line-height: 1.15;
        }

        .ap-reg-description {
          font-size: 11.5px;
          color: #978896;
          margin: 0 0 16px;
          line-height: 1.5;
        }

        /* FORMULARIO */

        .ap-reg-form {
          display: grid;
          grid-template-columns: repeat(2,minmax(0,1fr));
          gap: 12px 14px;
        }

        .ap-reg-field {
          display: flex;
          flex-direction: column;
          min-width: 0;
          gap: 6px;
        }

        .ap-reg-field.full {
          grid-column: 1 / -1;
        }

        .ap-reg-field > span {
          font-size: 11px;
          font-weight: 750;
          color: #453745;
        }

        .ap-reg-field input,
        .ap-reg-field select {
          width: 100%;
          min-width: 0;
          height: 41px;
          padding: 0 12px;
          border: 1px solid #eee1e7;
          border-radius: 10px;
          background: #fff;
          outline: none;
          font: inherit;
          font-size: 12px;
          color: #453847;
          transition: border-color .2s,box-shadow .2s;
        }

        .ap-reg-field input:focus,
        .ap-reg-field select:focus {
          border-color: #e67c83;
          box-shadow: 0 0 0 3px #f9dcde;
        }

        .ap-reg-field input::placeholder {
          color: #b1a3ae;
        }

        .ap-reg-password {
          position: relative;
        }

        .ap-reg-password input {
          padding-right: 66px;
        }

        .ap-reg-password button {
          position: absolute;
          top: 50%;
          right: 8px;
          transform: translateY(-50%);
          border: 0;
          background: transparent;
          color: #d26971;
          font-size: 10px;
          font-weight: 800;
          cursor: pointer;
          padding: 6px 3px;
        }

        .ap-reg-info {
          grid-column: 1 / -1;
          display: flex;
          align-items: center;
          gap: 9px;
          background: #fff7f6;
          color: #947c86;
          border: 1px solid #f8e5e5;
          border-radius: 10px;
          padding: 10px 12px;
          font-size: 10.5px;
          line-height: 1.45;
        }

        .ap-reg-submit {
          grid-column: 1 / -1;
          width: 100%;
          min-height: 43px;
          display: flex;
          align-items: center;
          justify-content: center;
          gap: 9px;
          color: #fff;
          font-size: 12px;
          font-weight: 800;
          border: 0;
          border-radius: 11px;
          background: linear-gradient(110deg,#f0807e,#e46470);
          cursor: pointer;
          box-shadow: 0 9px 18px #e7797d25;
        }

        .ap-reg-submit:disabled {
          opacity: .65;
          cursor: not-allowed;
        }

        .ap-reg-bottom {
          margin-top: 13px;
          font-size: 11px;
          color: #998d98;
          text-align: center;
        }

        .ap-reg-error {
          margin-bottom: 12px;
          background: #fff1f1;
          color: #bc4353;
          border: 1px solid #f5d6d6;
          border-radius: 10px;
          padding: 10px 12px;
          font-size: 11px;
        }

        /* ALTURA REDUCIDA */

        @media (min-width:901px) and (max-height:760px) {
          .ap-reg-right {
            padding-top: 10px;
            padding-bottom: 10px;
          }

          .ap-reg-content {
            padding: 4px 0;
          }

          .ap-reg-description {
            margin-bottom: 10px;
          }

          .ap-reg-form {
            gap: 8px 12px;
          }

          .ap-reg-field input,
          .ap-reg-field select {
            height: 36px;
          }

          .ap-reg-field {
            gap: 4px;
          }

          .ap-reg-info {
            padding: 7px 10px;
          }

          .ap-reg-submit {
            min-height: 39px;
          }
        }

        /* RESPONSIVE */

        @media (max-width:900px) {
          .ap-reg-screen {
            display: block;
            height: auto;
            min-height: 100dvh;
            overflow: visible;
          }

          .ap-reg-promo {
            min-height: 230px;
            padding: 26px;
          }

          .ap-reg-promo-content {
            margin: 20px 0;
          }

          .ap-reg-promo h1 {
            font-size: 30px;
          }

          .ap-reg-art {
            display: none;
          }

          .ap-reg-right {
            padding: 28px 22px;
            overflow: visible;
          }

          .ap-reg-content {
            max-width: 650px;
          }
        }

        @media (max-width:520px) {
          .ap-reg-form {
            grid-template-columns: 1fr;
          }

          .ap-reg-field.full,
          .ap-reg-info,
          .ap-reg-submit {
            grid-column: 1;
          }

          .ap-reg-promo h1 {
            font-size: 25px;
          }
        }
      `}</style>

      {/* PANEL IZQUIERDO */}

      <aside className="ap-reg-promo">
        <Link to="/login">
          <img
            className="ap-reg-logo"
            src={aprendlyLogoBlanco}
            alt="Aprendly"
          />
        </Link>

        <div className="ap-reg-promo-content">
          <span className="ap-reg-eyebrow">
            TU CAMINO COMIENZA AQUÍ
          </span>

          <h1>
            Todos tenemos algo
            <em> que enseñar y aprender.</em>
          </h1>

          <p>
            Crea tu perfil universitario, descubre estudiantes
            con intereses similares y comparte tus conocimientos
            con la comunidad.
          </p>

          <div className="ap-reg-art">
            <div className="ap-reg-art-circle">
              <img src={aprendlyIconoBlanco} alt="" />
            </div>

            <span className="ap-reg-floating one">
              ✦ Comparte lo que sabes
            </span>

            <span className="ap-reg-floating two">
              ♥ Aprende algo nuevo
            </span>
          </div>
        </div>

        <p className="ap-reg-footer">
          Conecta. Aprende. Comparte. · Aprendly
        </p>
      </aside>

      {/* PANEL DERECHO */}

      <section className="ap-reg-right">
        <div className="ap-reg-top">
          ¿Ya tienes una cuenta?
          <Link to="/login">Inicia sesión</Link>
        </div>

        <div className="ap-reg-content">
          <span className="ap-reg-tag">
            <Icon name="spark" size={14} />
            ÚNETE A APRENDLY
          </span>

          <h2>¡Comencemos!</h2>

          <p className="ap-reg-description">
            Completa tus datos académicos para crear tu cuenta.
          </p>

          {error && (
            <div className="ap-reg-error" role="alert">
              {error}
            </div>
          )}

          <form className="ap-reg-form" onSubmit={handleSubmit}>
            <label className="ap-reg-field">
              <span>Nombre</span>
              <input
                value={form.first_name}
                onChange={update('first_name')}
                placeholder="Ej. Leonardo"
                autoComplete="given-name"
                maxLength={80}
                required
              />
            </label>

            <label className="ap-reg-field">
              <span>Apellido</span>
              <input
                value={form.last_name}
                onChange={update('last_name')}
                placeholder="Ej. Ramos"
                autoComplete="family-name"
                maxLength={80}
                required
              />
            </label>

            <label className="ap-reg-field">
              <span>Correo institucional</span>
              <input
                type="email"
                value={form.institutional_email}
                onChange={update('institutional_email')}
                placeholder="nombre@universidad.edu.pe"
                autoComplete="email"
                maxLength={160}
                required
              />
            </label>

            <label className="ap-reg-field">
              <span>Universidad</span>
              <select
                value={form.university}
                onChange={update('university')}
                required
              >
                <option value="" disabled>
                  Selecciona tu universidad
                </option>

                {universidades.map(universidad => (
                  <option key={universidad} value={universidad}>
                    {universidad}
                  </option>
                ))}

                <option value="otros">
                  Otra universidad
                </option>
              </select>
            </label>

            {form.university === 'otros' && (
              <label className="ap-reg-field full">
                <span>Nombre de tu universidad</span>
                <input
                  value={form.otherUniversity}
                  onChange={update('otherUniversity')}
                  placeholder="Escribe el nombre completo"
                  maxLength={150}
                  required
                />
              </label>
            )}

            <label className="ap-reg-field">
              <span>Carrera universitaria</span>
              <input
                value={form.career}
                onChange={update('career')}
                placeholder="Ej. Ingeniería de Sistemas"
                maxLength={120}
                required
              />
            </label>

            <label className="ap-reg-field">
              <span>Ciclo académico</span>
              <select
                value={form.semester}
                onChange={update('semester')}
                required
              >
                <option value="" disabled>
                  Selecciona tu ciclo
                </option>

                {ciclos.map(ciclo => (
                  <option key={ciclo} value={ciclo}>
                    {ciclo}
                  </option>
                ))}
              </select>
            </label>

            <label className="ap-reg-field">
              <span>Contraseña</span>
              <div className="ap-reg-password">
                <input
                  type={showPassword ? 'text' : 'password'}
                  value={form.password}
                  onChange={update('password')}
                  placeholder="Mínimo 8 caracteres"
                  autoComplete="new-password"
                  minLength={8}
                  required
                />

                <button
                  type="button"
                  onClick={() => setShowPassword(value => !value)}
                  aria-label={
                    showPassword
                      ? 'Ocultar contraseña'
                      : 'Mostrar contraseña'
                  }
                >
                  {showPassword ? 'Ocultar' : 'Mostrar'}
                </button>
              </div>
            </label>

            <label className="ap-reg-field">
              <span>Confirmar contraseña</span>
              <div className="ap-reg-password">
                <input
                  type={showConfirm ? 'text' : 'password'}
                  value={form.confirm_password}
                  onChange={update('confirm_password')}
                  placeholder="Repite tu contraseña"
                  autoComplete="new-password"
                  minLength={8}
                  required
                />

                <button
                  type="button"
                  onClick={() => setShowConfirm(value => !value)}
                  aria-label={
                    showConfirm
                      ? 'Ocultar confirmación'
                      : 'Mostrar confirmación'
                  }
                >
                  {showConfirm ? 'Ocultar' : 'Mostrar'}
                </button>
              </div>
            </label>

            <div className="ap-reg-info">
              <Icon name="shield" size={16} />
              Utiliza tus datos académicos correctos.
              El correo y la universidad quedarán asociados a tu cuenta.
            </div>

            <button
              type="submit"
              className="ap-reg-submit"
              disabled={busy}
            >
              {busy ? 'Creando tu cuenta...' : 'Crear mi cuenta'}
              {!busy && <Icon name="arrow" size={16} />}
            </button>
          </form>

          <div className="ap-reg-bottom">
            ¿Ya formas parte de Aprendly?{' '}
            <Link to="/login">Inicia sesión</Link>
          </div>
        </div>
      </section>
    </div>
  );
}
