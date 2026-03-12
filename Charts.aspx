<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Charts.aspx.cs" Inherits="ShamelessWebstudentRipoff.Charts" %>

<%@ Register Assembly="System.Web.DataVisualization, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
             Namespace="System.Web.UI.DataVisualization.Charting" TagPrefix="asp" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Statistics — University Manager</title>
    <link rel="stylesheet" href="university.css" />
    <style>
        .charts-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.5rem;
        }
        @media (max-width: 780px) {
            .charts-grid { grid-template-columns: 1fr; }
        }
        .chart-card {
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 24px rgba(15,34,64,0.10);
            padding: 1.5rem;
        }
        .chart-card h2 {
            font-family: 'DM Serif Display', serif;
            font-size: 1.05rem;
            color: #0f2240;
            margin-bottom: 1rem;
        }
        .chart-card p {
            font-size: 0.82rem;
            color: #6b6456;
            margin-top: 0.6rem;
        }
        .stats-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
            gap: 1rem;
            margin-bottom: 1.5rem;
        }
        .stat-box {
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 24px rgba(15,34,64,0.08);
            padding: 1.1rem 1.4rem;
            border-left: 4px solid #c9a84c;
        }
        .stat-box .stat-value {
            font-family: 'DM Serif Display', serif;
            font-size: 1.9rem;
            color: #0f2240;
            line-height: 1;
        }
        .stat-box .stat-label {
            font-size: 0.8rem;
            color: #6b6456;
            margin-top: 0.3rem;
        }
    </style>
</head>
<body>

    <header class="site-header">
        <a class="logo" href="Default.aspx">&#127979; UniManager</a>
        <nav>
            <a href="Grades.aspx">Grades</a>
            <a href="Schedule.aspx">Schedule</a>
            <a href="Charts.aspx" class="active">Statistics</a>
        </nav>
    </header>

    <form id="form1" runat="server">
    <div class="page-wrapper">

        <h1 class="page-title">Grade Statistics</h1>
        <p class="page-subtitle">Visual overview of performance across all courses.</p>

        <!-- ── Summary stat boxes ── -->
        <div class="stats-row">
            <div class="stat-box">
                <div class="stat-value"><asp:Label ID="lblTotalGrades"   runat="server" Text="—" /></div>
                <div class="stat-label">Total grades recorded</div>
            </div>
            <div class="stat-box">
                <div class="stat-value"><asp:Label ID="lblOverallAvg"    runat="server" Text="—" /></div>
                <div class="stat-label">Overall average</div>
            </div>
            <div class="stat-box">
                <div class="stat-value"><asp:Label ID="lblPassRate"      runat="server" Text="—" /></div>
                <div class="stat-label">Pass rate (≥ 5)</div>
            </div>
            <div class="stat-box">
                <div class="stat-value"><asp:Label ID="lblTopCourse"     runat="server" Text="—" /></div>
                <div class="stat-label">Highest avg. course</div>
            </div>
        </div>

        <!-- ── Charts grid ── -->
        <div class="charts-grid">

            <!-- Bar chart: average grade per course -->
            <div class="chart-card">
                <h2>Average Grade by Course</h2>
                <asp:Chart ID="chartBarAvg" runat="server" Width="460px" Height="300px">
                    <Series>
                        <asp:Series Name="Averages" ChartType="Bar"
                            Color="#1a3a6b"
                            LabelForeColor="#ffffff"
                            Font="DM Sans, 8pt" />
                    </Series>
                    <ChartAreas>
                        <asp:ChartArea Name="AreaBar"
                            BackColor="Transparent">
                            <AxisX LabelStyle-Font="DM Sans, 8pt" />
                            <AxisY Minimum="0" Maximum="10"
                                   LabelStyle-Font="DM Sans, 8pt" />
                        </asp:ChartArea>
                    </ChartAreas>
                </asp:Chart>
                <p>Average grade earned per course across all students.</p>
            </div>

            <!-- Column chart: number of students per course -->
            <div class="chart-card">
                <h2>Student Count by Course</h2>
                <asp:Chart ID="chartColCount" runat="server" Width="460px" Height="300px">
                    <Series>
                        <asp:Series Name="Counts" ChartType="Column"
                            Color="#c9a84c"
                            LabelForeColor="#0f2240"
                            Font="DM Sans, 8pt" />
                    </Series>
                    <ChartAreas>
                        <asp:ChartArea Name="AreaCol" BackColor="Transparent">
                            <AxisX LabelStyle-Font="DM Sans, 8pt" />
                            <AxisY LabelStyle-Font="DM Sans, 8pt" />
                        </asp:ChartArea>
                    </ChartAreas>
                </asp:Chart>
                <p>Number of graded students per course.</p>
            </div>

            <!-- Pie chart: grade distribution buckets -->
            <div class="chart-card">
                <h2>Grade Distribution</h2>
                <asp:Chart ID="chartPieDist" runat="server" Width="460px" Height="300px">
                    <Series>
                        <asp:Series Name="Distribution" ChartType="Pie"
                            Font="DM Sans, 8pt"
                            LabelForeColor="#0f2240" />
                    </Series>
                    <ChartAreas>
                        <asp:ChartArea Name="AreaPie" BackColor="Transparent" />
                    </ChartAreas>
                    <Legends>
                        <asp:Legend Name="LegendPie" Font="DM Sans, 8pt" />
                    </Legends>
                </asp:Chart>
                <p>Breakdown of all grades into performance bands.</p>
            </div>

            <!-- Doughnut chart: pass vs fail -->
            <div class="chart-card">
                <h2>Pass / Fail Overview</h2>
                <asp:Chart ID="chartDoughnut" runat="server" Width="460px" Height="300px">
                    <Series>
                        <asp:Series Name="PassFail" ChartType="Doughnut"
                            Font="DM Sans, 9pt" />
                    </Series>
                    <ChartAreas>
                        <asp:ChartArea Name="AreaDoughnut" BackColor="Transparent" />
                    </ChartAreas>
                    <Legends>
                        <asp:Legend Name="LegendDoughnut" Font="DM Sans, 8pt" />
                    </Legends>
                </asp:Chart>
                <p>Overall pass rate across all students and courses.</p>
            </div>

        </div>
    </div>
    </form>
</body>
</html>
