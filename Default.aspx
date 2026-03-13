<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="ShamelessWebstudentRipoff.Default" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>NetStudent — Managementul Universitatii</title>
    <link rel="stylesheet" href="university.css" />
    <style>
        .hero {
            background: var(--navy);
            color: #fff;
            padding: 4rem 2.5rem 3.5rem;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        .hero::before {
            content: '';
            position: absolute;
            inset: 0;
            background:
                radial-gradient(ellipse at 20% 50%, rgba(201,168,76,0.12) 0%, transparent 60%),
                radial-gradient(ellipse at 80% 20%, rgba(42,82,152,0.3) 0%, transparent 55%);
            pointer-events: none;
        }
        .hero-label {
            display: inline-block;
            background: rgba(201,168,76,0.15);
            border: 1px solid rgba(201,168,76,0.35);
            color: var(--gold-light);
            font-size: 0.78rem;
            font-weight: 600;
            letter-spacing: 0.12em;
            text-transform: uppercase;
            padding: 0.3rem 0.9rem;
            border-radius: 20px;
            margin-bottom: 1.2rem;
        }
        .hero h1 {
            font-family: 'DM Serif Display', serif;
            font-size: clamp(2rem, 5vw, 3.2rem);
            color: #fff;
            line-height: 1.15;
            margin-bottom: 1rem;
        }
        .hero h1 span { color: var(--gold); }
        .hero p {
            color: #a8bcd4;
            font-size: 1rem;
            max-width: 520px;
            margin: 0 auto 2rem;
            line-height: 1.65;
        }
        .hero-actions {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
        }
        .hero-actions a {
            text-decoration: none;
            padding: 0.65rem 1.6rem;
            border-radius: 7px;
            font-weight: 600;
            font-size: 0.92rem;
            transition: opacity 0.15s, transform 0.1s;
        }
        .hero-actions a:active { transform: scale(0.97); }
        .btn-hero-primary {
            background: var(--gold);
            color: var(--navy);
        }
        .btn-hero-ghost {
            background: transparent;
            color: #fff;
            border: 1.5px solid rgba(255,255,255,0.25);
        }
        .btn-hero-primary:hover, .btn-hero-ghost:hover { opacity: 0.85; }

        /* ── Feature cards ── */
        .features {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 1.25rem;
            margin-bottom: 2rem;
        }
        .feature-card {
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 24px rgba(15,34,64,0.08);
            padding: 1.6rem 1.5rem;
            text-decoration: none;
            color: inherit;
            display: block;
            border-top: 3px solid transparent;
            transition: transform 0.15s, box-shadow 0.15s, border-color 0.15s;
        }
        .feature-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 32px rgba(15,34,64,0.13);
            border-top-color: var(--gold);
        }
        .feature-icon {
            font-size: 2rem;
            margin-bottom: 0.75rem;
            display: block;
        }
        .feature-card h3 {
            font-family: 'DM Serif Display', serif;
            font-size: 1.1rem;
            color: var(--navy);
            margin-bottom: 0.4rem;
        }
        .feature-card p {
            font-size: 0.87rem;
            color: var(--gray-600);
            line-height: 1.55;
        }
        .feature-card .card-link {
            display: inline-block;
            margin-top: 0.9rem;
            font-size: 0.82rem;
            font-weight: 600;
            color: var(--navy-mid);
        }

        /* ── Stats strip ── */
        .stats-strip {
            background: var(--navy);
            border-radius: 10px;
            padding: 1.5rem 2rem;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
            gap: 1rem;
            text-align: center;
            margin-bottom: 2rem;
        }
        .strip-stat .val {
            font-family: 'DM Serif Display', serif;
            font-size: 1.8rem;
            color: var(--gold);
        }
        .strip-stat .lbl {
            font-size: 0.78rem;
            color: #a8bcd4;
            margin-top: 0.2rem;
        }
    </style>
</head>
<body>

    <header class="site-header">
        <a class="logo" href="Default.aspx">&#127979; NetStudent</a>
        <nav>
            <a href="Grades.aspx">Calificative</a>
            <a href="Schedule.aspx">Orar</a>
            <a href="Charts.aspx">Statistici</a>
        </nav>
    </header>

    <form id="form1" runat="server">

        <!-- ── Hero ── -->
        <div class="hero">
            <div class="hero-label">Unealta administrativa pentru universitati</div>
            <h1><span>Calificative</span> &amp;<br /><span>orare</span> cu usurinta.</h1>
            <p>Incarca calificative pentru studenti, modifica programul orelor
               si vezi statistici cu performanta la cateva click-uri distanta!</p>
            <div class="hero-actions">
                <a href="Grades.aspx"   class="btn-hero-primary">Acorda Calificative</a>
                <a href="Schedule.aspx" class="btn-hero-ghost">Vezi Orarul</a>
            </div>
        </div>

        <div class="page-wrapper">

            <!-- ── Live stats strip ── -->
            <div class="stats-strip">
                <div class="strip-stat">
                    <div class="val"><asp:Label ID="lblStudents" runat="server" Text="—" /></div>
                    <div class="lbl">Studenti</div>
                </div>
                <div class="strip-stat">
                    <div class="val"><asp:Label ID="lblCourses" runat="server" Text="—" /></div>
                    <div class="lbl">Cursuri</div>
                </div>
                <div class="strip-stat">
                    <div class="val"><asp:Label ID="lblGrades" runat="server" Text="—" /></div>
                    <div class="lbl">Calificative acordate</div>
                </div>
                <div class="strip-stat">
                    <div class="val"><asp:Label ID="lblAvg" runat="server" Text="—" /></div>
                    <div class="lbl">Media generala</div>
                </div>
            </div>

            <!-- ── Feature cards ── -->
            <div class="features">

                <a href="Grades.aspx" class="feature-card">
                    <span class="feature-icon">&#128221;</span>
                    <h3>Calificative</h3>
                    <p>Inregistreaza, modifica si sterge notele studentilor la orice materie.
                       Filtreaza dupa curs sau grup pentru o regasire rapida.</p>
                    <span class="card-link">Vezi calificativele &rarr;</span>
                </a>

                <a href="Schedule.aspx" class="feature-card">
                    <span class="feature-icon">&#128197;</span>
                    <h3>Orar</h3>
                    <p>Exploreaza orarul saptamanal. Adauga cursuri noi sau rectifica
                       sala sau timpul in orice moment.</p>
                    <span class="card-link">Vezi orarul &rarr;</span>
                </a>

                <a href="Charts.aspx" class="feature-card">
                    <span class="feature-icon">&#128200;</span>
                    <h3>Statistici</h3>
                    <p>O varietate de grafice afisand medii, distributii
                       de note si rata de premianti.</p>
                    <span class="card-link">Vezi statisticile &rarr;</span>
                </a>

            </div>
        </div>
    </form>
</body>
</html>