using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ShamelessWebstudentRipoff
{
    public partial class Grades : Page
    {
        private string ConnStr =>
            ConfigurationManager.ConnectionStrings["UniversityDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                PopulateFilterDropdowns();
                PopulateInsertDropdowns();
                BindGrid();

                txtInsertDate.Text = DateTime.Today.ToString("yyyy-MM-dd");
            }
        }

        protected string FormatGradePill(object gradeObj)
        {
            if (gradeObj == DBNull.Value || gradeObj == null) return "-";
            double g = Convert.ToDouble(gradeObj);
            string css = g >= 8.5 ? "grade-high" : g >= 5 ? "grade-mid" : "grade-low";
            return $"<span class='grade-pill {css}'>{g:0.##}</span>";
        }

        private void BindGrid()
        {
            string course = ddlFilterCourse.SelectedValue;
            string group = ddlFilterGroup.SelectedValue;

            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand("sp_GetAllGrades", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                con.Open();

                var dt = new DataTable();
                dt.Load(cmd.ExecuteReader());

                if (!string.IsNullOrEmpty(course))
                    dt = FilterTable(dt, "CourseName", course);
                if (!string.IsNullOrEmpty(group))
                    dt = FilterTable(dt, "GroupName", group);

                gvGrades.DataSource = dt;
                gvGrades.DataBind();
            }
        }

        private DataTable FilterTable(DataTable dt, string col, string val)
        {
            var view = new DataView(dt) { RowFilter = $"{col} = '{val}'" };
            return view.ToTable();
        }

        private void PopulateFilterDropdowns()
        {
            ddlFilterCourse.Items.Clear();
            ddlFilterCourse.Items.Add(new ListItem("All courses", ""));
            ddlFilterGroup.Items.Clear();
            ddlFilterGroup.Items.Add(new ListItem("All groups", ""));

            using (var con = new SqlConnection(ConnStr))
            {
                con.Open();

                var cmd = new SqlCommand("SELECT CourseID, CourseName FROM Courses ORDER BY CourseName", con);
                using (var rdr = cmd.ExecuteReader())
                    while (rdr.Read())
                        ddlFilterCourse.Items.Add(new ListItem(rdr["CourseName"].ToString(), rdr["CourseName"].ToString()));

                cmd = new SqlCommand("SELECT DISTINCT GroupName FROM Students ORDER BY GroupName", con);
                using (var rdr = cmd.ExecuteReader())
                    while (rdr.Read())
                        ddlFilterGroup.Items.Add(new ListItem(rdr["GroupName"].ToString()));
            }
        }

        private void PopulateInsertDropdowns()
        {
            ddlInsertStudent.Items.Clear();
            ddlInsertCourse.Items.Clear();

            using (var con = new SqlConnection(ConnStr))
            {
                con.Open();

                var cmd = new SqlCommand("SELECT StudentID, Name FROM Students ORDER BY Name", con);
                using (var rdr = cmd.ExecuteReader())
                    while (rdr.Read())
                        ddlInsertStudent.Items.Add(new ListItem(rdr["Name"].ToString(), rdr["StudentID"].ToString()));

                cmd = new SqlCommand("SELECT CourseID, CourseName FROM Courses ORDER BY CourseName", con);
                using (var rdr = cmd.ExecuteReader())
                    while (rdr.Read())
                        ddlInsertCourse.Items.Add(new ListItem(rdr["CourseName"].ToString(), rdr["CourseID"].ToString()));
            }
        }

        protected void ddlFilterCourse_SelectedIndexChanged(object sender, EventArgs e) => BindGrid();
        protected void ddlFilterGroup_SelectedIndexChanged(object sender, EventArgs e) => BindGrid();

        protected void btnClearFilter_Click(object sender, EventArgs e)
        {
            ddlFilterCourse.SelectedIndex = 0;
            ddlFilterGroup.SelectedIndex = 0;
            BindGrid();
        }

        protected void gvGrades_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvGrades.EditIndex = e.NewEditIndex;
            BindGrid();
        }

        protected void gvGrades_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvGrades.EditIndex = -1;
            BindGrid();
        }

        protected void gvGrades_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int gradeId = Convert.ToInt32(gvGrades.DataKeys[e.RowIndex].Value);

            var row = gvGrades.Rows[e.RowIndex];
            var txtGrade = (TextBox)row.FindControl("txtEditGrade");
            var txtDate = (TextBox)row.FindControl("txtEditDate");

            if (!decimal.TryParse(txtGrade.Text, out decimal grade) || grade < 1 || grade > 10)
            {
                lblMessage.Text = "⚠ Nota trebuie sa fie intre 1 si 10.";
                lblMessage.CssClass = "msg-error";
                return;
            }

            if (!DateTime.TryParse(txtDate.Text, out DateTime gradeDate))
            {
                lblMessage.Text = "⚠ Data invalida.";
                lblMessage.CssClass = "msg-error";
                return;
            }

            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand("sp_UpdateGrade", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@GradeID", gradeId);
                cmd.Parameters.AddWithValue("@Grade", grade);
                cmd.Parameters.AddWithValue("@GradeDate", gradeDate);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            gvGrades.EditIndex = -1;
            lblMessage.Text = "✓ Nota modificata cu succes.";
            lblMessage.CssClass = "msg-success";
            BindGrid();
        }

        protected void gvGrades_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int gradeId = Convert.ToInt32(gvGrades.DataKeys[e.RowIndex].Value);

            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand("sp_DeleteGrade", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@GradeID", gradeId);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            lblMessage.Text = "✓ Nota stearsa.";
            lblMessage.CssClass = "msg-success";
            BindGrid();
        }

        protected void btnInsert_Click(object sender, EventArgs e)
        {
            if (!decimal.TryParse(txtInsertGrade.Text, out decimal grade) || grade < 1 || grade > 10)
            {
                lblInsertMessage.Text = "⚠ Nota trebuie sa fie intre 1 si 10.";
                lblInsertMessage.CssClass = "msg-error";
                return;
            }

            if (!DateTime.TryParse(txtInsertDate.Text, out DateTime gradeDate))
            {
                lblInsertMessage.Text = "⚠ Data invalida.";
                lblInsertMessage.CssClass = "msg-error";
                return;
            }

            int studentId = Convert.ToInt32(ddlInsertStudent.SelectedValue);
            int courseId = Convert.ToInt32(ddlInsertCourse.SelectedValue);

            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand("sp_InsertGrade", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@StudentID", studentId);
                cmd.Parameters.AddWithValue("@CourseID", courseId);
                cmd.Parameters.AddWithValue("@Grade", grade);
                cmd.Parameters.AddWithValue("@GradeDate", gradeDate);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            txtInsertGrade.Text = "";
            txtInsertDate.Text = DateTime.Today.ToString("yyyy-MM-dd");
            lblInsertMessage.Text = "✓ Calificativ adaugat cu succes.";
            lblInsertMessage.CssClass = "msg-success";
            BindGrid();
        }
    }
}