
import { Link } from 'react-router-dom';
import { Icon } from './UI';

export type Advisor = {
  position: number;
  id: number;
  name: string;
  university: string;
  given: number;
  rating: number;
};

type Props = {
  advisors: Advisor[];
  loading?: boolean;
};

export default function TopAdvisors({
  advisors,
  loading = false
}: Props) {
  return (
    <section className="ap-panel ap-top-advisors">

      <div className="ap-panel-heading">
        <div>
          <span className="ap-eyebrow">
            ESTUDIANTES DESTACADOS
          </span>

          <h2>Top 5 de asesores</h2>
        </div>

        <span className="ap-ranking-symbol">
          <Icon name="trophy" size={22} />
        </span>
      </div>

      {loading ? (
        <p className="muted">
          Cargando ranking...
        </p>
      ) : advisors.length === 0 ? (
        <p className="muted">
          Todavía no hay asesores disponibles.
        </p>
      ) : (
        <div className="ap-ranking-list">

          {advisors.slice(0, 5).map(advisor => (
            <div
              className="ap-ranking-row"
              key={advisor.id}
            >

              <span className="ap-ranking-position">
                {advisor.position}
              </span>

              <span className="ap-small-avatar">
                {advisor.name.charAt(0)}
              </span>

              <div className="ap-ranking-info">

                <strong>{advisor.name}</strong>

                <small>
                  {advisor.university}
                </small>

                <span className="ap-ranking-rating">
                  ★ {advisor.rating.toFixed(1)}

                  <span>
                    {' '}· {advisor.given} asesorías
                  </span>
                </span>

              </div>

              <Link
                to={`/perfil/${advisor.id}`}
                className="ap-outline-link"
              >
                Perfil
              </Link>

            </div>
          ))}

        </div>
      )}
    </section>
  );
}
