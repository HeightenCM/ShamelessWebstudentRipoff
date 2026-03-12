using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
namespace ShamelessWebstudentRipoff
{
    public partial class Default : System.Web.UI.Page
    {
        private string ConnStr =>
            ConfigurationManager.ConnectionStrings["UniversityDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                PopulateStats();
        }

        private void PopulateStats()
        {
            using (var con = new SqlConnection(ConnStr))
            {
                con.Open();

                lblStudents.Text = ScalarQuery(con, "SELECT COUNT(*) FROM Students");
                lblCourses.Text = ScalarQuery(con, "SELECT COUNT(*) FROM Courses");
                lblGrades.Text = ScalarQuery(con, "SELECT COUNT(*) FROM Grades");

                string avg = ScalarQuery(con, "SELECT CAST(AVG(CAST(Grade AS FLOAT)) AS DECIMAL(4,2)) FROM Grades");
                lblAvg.Text = string.IsNullOrEmpty(avg) ? "—" : avg;
            }
        }

        private string ScalarQuery(SqlConnection con, string sql)
        {
            using (var cmd = new SqlCommand(sql, con))
            {
                var result = cmd.ExecuteScalar();
                return (result == null || result == DBNull.Value) ? "—" : result.ToString();
            }
        }
    }
}