using System;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Web.UI.DataVisualization.Charting;
using System.Configuration;

namespace ShamelessWebstudentRipoff
{
    public partial class Charts : System.Web.UI.Page
    {
        private string ConnStr =>
            ConfigurationManager.ConnectionStrings["UniversityDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                var avgTable = GetCourseAverages();
                var allGrades = GetAllGradeValues();

                PopulateSummaryStats(avgTable, allGrades);
                BuildBarChart(avgTable);
                BuildColumnChart(avgTable);
                BuildPieChart(allGrades);
                BuildDoughnutChart(allGrades);
            }
        }

        private DataTable GetCourseAverages()
        {
            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand("sp_GetCourseAverages", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                con.Open();
                var dt = new DataTable();
                dt.Load(cmd.ExecuteReader());
                return dt;
            }
        }

        private DataTable GetAllGradeValues()
        {
            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand("SELECT Grade FROM Grades", con))
            {
                con.Open();
                var dt = new DataTable();
                dt.Load(cmd.ExecuteReader());
                return dt;
            }
        }

        private void PopulateSummaryStats(DataTable avgTable, DataTable allGrades)
        {
            int total = allGrades.Rows.Count;
            lblTotalGrades.Text = total.ToString();

            if (total == 0) return;

            double sum = 0;
            int pass = 0;
            foreach (DataRow row in allGrades.Rows)
            {
                double g = Convert.ToDouble(row["Grade"]);
                sum += g;
                if (g >= 5) pass++;
            }

            lblOverallAvg.Text = (sum / total).ToString("0.00");
            lblPassRate.Text = ((pass * 100.0) / total).ToString("0") + "%";

            double best = -1;
            string bestName = "—";
            foreach (DataRow row in avgTable.Rows)
            {
                double avg = Convert.ToDouble(row["AverageGrade"]);
                if (avg > best) { best = avg; bestName = row["CourseName"].ToString(); }
            }
            lblTopCourse.Text = bestName.Length > 20
                ? bestName.Substring(0, 20) + "…"
                : bestName;
        }

        private void BuildBarChart(DataTable dt)
        {
            var series = chartBarAvg.Series["Averages"];
            series.IsValueShownAsLabel = true;
            series.LabelFormat = "0.0";

            Color[] palette = {
                ColorTranslator.FromHtml("#0f2240"),
                ColorTranslator.FromHtml("#1a3a6b"),
                ColorTranslator.FromHtml("#2a5298"),
                ColorTranslator.FromHtml("#c9a84c"),
            };

            int i = 0;
            foreach (DataRow row in dt.Rows)
            {
                string name = row["CourseName"].ToString();
                double avg = Convert.ToDouble(row["AverageGrade"]);
                var pt = new DataPoint();
                pt.SetValueXY(name, avg);
                pt.Color = palette[i % palette.Length];
                series.Points.Add(pt);
                i++;
            }

            chartBarAvg.ChartAreas["AreaBar"].AxisY.Maximum = 10;
            chartBarAvg.ChartAreas["AreaBar"].AxisY.Minimum = 0;
            chartBarAvg.BackColor = Color.Transparent;
        }

        private void BuildColumnChart(DataTable dt)
        {
            var series = chartColCount.Series["Counts"];
            series.IsValueShownAsLabel = true;

            foreach (DataRow row in dt.Rows)
            {
                string name = row["CourseName"].ToString();
                int count = Convert.ToInt32(row["StudentCount"]);
                series.Points.AddXY(name, count);
            }

            chartColCount.BackColor = Color.Transparent;
        }

        private void BuildPieChart(DataTable dt)
        {
            int excellent = 0, good = 0, satisfactory = 0, fail = 0;

            foreach (DataRow row in dt.Rows)
            {
                double g = Convert.ToDouble(row["Grade"]);
                if (g >= 9) excellent++;
                else if (g >= 7) good++;
                else if (g >= 5) satisfactory++;
                else fail++;
            }

            var series = chartPieDist.Series["Distribution"];
            series["PieLabelStyle"] = "Outside";

            void AddSlice(string label, int val, string hex)
            {
                if (val == 0) return;
                var pt = new DataPoint();
                pt.SetValueXY(label, val);
                pt.Color = ColorTranslator.FromHtml(hex);
                pt.LegendText = $"{label} ({val})";
                series.Points.Add(pt);
            }

            AddSlice("Excellent (9–10)", excellent, "#2a7a4b");
            AddSlice("Good (7–8.99)", good, "#1a3a6b");
            AddSlice("Pass (5–6.99)", satisfactory, "#c9a84c");
            AddSlice("Fail (< 5)", fail, "#b83232");

            chartPieDist.BackColor = Color.Transparent;
        }

        private void BuildDoughnutChart(DataTable dt)
        {
            int pass = 0, fail = 0;
            foreach (DataRow row in dt.Rows)
            {
                double g = Convert.ToDouble(row["Grade"]);
                if (g >= 5) pass++; else fail++;
            }

            var series = chartDoughnut.Series["PassFail"];

            var ptPass = new DataPoint();
            ptPass.SetValueXY("Pass", pass);
            ptPass.Color = ColorTranslator.FromHtml("#2a7a4b");
            ptPass.LegendText = $"Pass ({pass})";
            series.Points.Add(ptPass);

            var ptFail = new DataPoint();
            ptFail.SetValueXY("Fail", fail);
            ptFail.Color = ColorTranslator.FromHtml("#b83232");
            ptFail.LegendText = $"Fail ({fail})";
            series.Points.Add(ptFail);

            series["PieLabelStyle"] = "Outside";
            series.Label = "#PERCENT{P0}";

            chartDoughnut.BackColor = Color.Transparent;
        }
    }
}