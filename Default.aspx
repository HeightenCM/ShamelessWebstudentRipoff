<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="ShamelessWebstudentRipoff.Default" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>UniManager — University Grade & Schedule System</title>
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
        <a class="logo" href="Default.aspx">&#127979; UniManager</a>
        <nav>
            <a href="Grades.aspx">Grades</a>
            <a href="Schedule.aspx">Schedule</a>
            <a href="Charts.aspx">Statistics</a>
        </nav>
    </header>

    <form id="form1" runat="server">

        <!-- ── Hero ── -->
        <div class="hero">
            <div class="hero-label">University Management System</div>
            <h1>Manage grades &amp;<br /><span>schedules</span> with ease.</h1>
            <p>A unified tool for recording student grades, browsing course timetables,
               and visualising academic performance at a glance.</p>
            <div class="hero-actions">
                <a href="Grades.aspx"   class="btn-hero-primary">Open Grades</a>
                <a href="Schedule.aspx" class="btn-hero-ghost">View Schedule</a>
            </div>
        </div>

        <div class="page-wrapper">

            <!-- ── Live stats strip ── -->
            <div class="stats-strip">
                <div class="strip-stat">
                    <div class="val"><asp:Label ID="lblStudents" runat="server" Text="—" /></div>
                    <div class="lbl">Students</div>
                </div>
                <div class="strip-stat">
                    <div class="val"><asp:Label ID="lblCourses" runat="server" Text="—" /></div>
                    <div class="lbl">Courses</div>
                </div>
                <div class="strip-stat">
                    <div class="val"><asp:Label ID="lblGrades" runat="server" Text="—" /></div>
                    <div class="lbl">Grades recorded</div>
                </div>
                <div class="strip-stat">
                    <div class="val"><asp:Label ID="lblAvg" runat="server" Text="—" /></div>
                    <div class="lbl">Overall average</div>
                </div>
            </div>

            <!-- ── Feature cards ── -->
            <div class="features">

                <a href="Grades.aspx" class="feature-card">
                    <span class="feature-icon">&#128221;</span>
                    <h3>Grade Management</h3>
                    <p>Record, edit, and delete student grades across all courses.
                       Filter by course or group to find entries quickly.</p>
                    <span class="card-link">Open grades &rarr;</span>
                </a>

                <a href="Schedule.aspx" class="feature-card">
                    <span class="feature-icon">&#128197;</span>
                    <h3>Course Schedule</h3>
                    <p>Browse the full weekly timetable. Add new courses or update
                       room and time information at any time.</p>
                    <span class="card-link">View schedule &rarr;</span>
                </a>

                <a href="Charts.aspx" class="feature-card">
                    <span class="feature-icon">&#128200;</span>
                    <h3>Statistics</h3>
                    <p>Visual charts showing average grades per course, grade
                       distribution bands, and overall pass / fail rates.</p>
                    <span class="card-link">See statistics &rarr;</span>
                </a>

            </div>
        </div>
    </form>
</body>
</html>