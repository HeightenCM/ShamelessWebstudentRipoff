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
    public partial class Schedule : System.Web.UI.Page
    {
        private string ConnStr =>
            ConfigurationManager.ConnectionStrings["UniversityDB"].ConnectionString;

        // =====================================================================
        //  PAGE LOAD
        // =====================================================================
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                BindGrid();
        }

        // =====================================================================
        //  HELPERS
        // =====================================================================

        /// <summary>
        /// Calls sp_GetSchedule with the currently selected day filter.
        /// Passing NULL returns all days.
        /// </summary>
        private void BindGrid()
        {
            string day = ddlDay.SelectedValue; // "" means all

            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand("sp_GetSchedule", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@DayOfWeek",
                    string.IsNullOrEmpty(day) ? (object)DBNull.Value : day);

                con.Open();
                var dt = new DataTable();
                dt.Load(cmd.ExecuteReader());

                gvSchedule.DataSource = dt;
                gvSchedule.DataBind();
            }
        }

        // =====================================================================
        //  FILTER
        // =====================================================================
        protected void ddlDay_SelectedIndexChanged(object sender, EventArgs e)
            => BindGrid();

        // =====================================================================
        //  GRIDVIEW — EDIT / CANCEL
        // =====================================================================
        protected void gvSchedule_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvSchedule.EditIndex = e.NewEditIndex;
            BindGrid();

            // Pre-select the correct day in the edit dropdown
            var row = gvSchedule.Rows[e.NewEditIndex];
            var ddl = (DropDownList)row.FindControl("ddlEditDay");
            var dtItem = gvSchedule.DataKeys[e.NewEditIndex];

            // Read the day value from the bound data via the hidden DataKey
            // We re-query just this row to get the day value reliably
            string currentDay = GetDayForCourse(Convert.ToInt32(dtItem.Value));
            if (ddl != null && !string.IsNullOrEmpty(currentDay))
                ddl.SelectedValue = currentDay;
        }

        protected void gvSchedule_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvSchedule.EditIndex = -1;
            BindGrid();
        }

        // =====================================================================
        //  GRIDVIEW — UPDATE  →  direct SQL (no stored proc for course update,
        //  but we reuse sp_GetSchedule for the read; update is inline T-SQL)
        // =====================================================================
        protected void gvSchedule_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int courseId = Convert.ToInt32(gvSchedule.DataKeys[e.RowIndex].Value);
            var row = gvSchedule.Rows[e.RowIndex];

            string courseName = ((TextBox)row.FindControl("txtCourseName")).Text.Trim();
            string professor = ((TextBox)row.FindControl("txtProfessor")).Text.Trim();
            string day = ((DropDownList)row.FindControl("ddlEditDay")).SelectedValue;
            string start = ((TextBox)row.FindControl("txtStart")).Text.Trim();
            string end = ((TextBox)row.FindControl("txtEnd")).Text.Trim();
            string room = ((TextBox)row.FindControl("txtRoom")).Text.Trim();

            if (string.IsNullOrEmpty(courseName) || string.IsNullOrEmpty(professor))
            {
                lblMessage.Text = "⚠ Course name and professor are required.";
                lblMessage.CssClass = "msg-error";
                return;
            }

            if (!TimeSpan.TryParse(start, out TimeSpan startTime) ||
                !TimeSpan.TryParse(end, out TimeSpan endTime))
            {
                lblMessage.Text = "⚠ Times must be in HH:mm format (e.g. 08:00).";
                lblMessage.CssClass = "msg-error";
                return;
            }

            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(
                @"UPDATE Courses SET
                    CourseName    = @CourseName,
                    ProfessorName = @ProfessorName,
                    DayOfWeek     = @DayOfWeek,
                    StartTime     = @StartTime,
                    EndTime       = @EndTime,
                    Room          = @Room
                  WHERE CourseID  = @CourseID", con))
            {
                cmd.Parameters.AddWithValue("@CourseName", courseName);
                cmd.Parameters.AddWithValue("@ProfessorName", professor);
                cmd.Parameters.AddWithValue("@DayOfWeek", day);
                cmd.Parameters.AddWithValue("@StartTime", startTime);
                cmd.Parameters.AddWithValue("@EndTime", endTime);
                cmd.Parameters.AddWithValue("@Room", room);
                cmd.Parameters.AddWithValue("@CourseID", courseId);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            gvSchedule.EditIndex = -1;
            lblMessage.Text = "✓ Course updated successfully.";
            lblMessage.CssClass = "msg-success";
            BindGrid();
        }

        // =====================================================================
        //  GRIDVIEW — DELETE
        // =====================================================================
        protected void gvSchedule_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int courseId = Convert.ToInt32(gvSchedule.DataKeys[e.RowIndex].Value);

            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand("DELETE FROM Courses WHERE CourseID = @CourseID", con))
            {
                cmd.Parameters.AddWithValue("@CourseID", courseId);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            lblMessage.Text = "✓ Course deleted.";
            lblMessage.CssClass = "msg-success";
            BindGrid();
        }

        // =====================================================================
        //  INSERT  →  direct INSERT (sp_GetSchedule handles reads)
        // =====================================================================
        protected void btnInsert_Click(object sender, EventArgs e)
        {
            string courseName = txtInsertCourseName.Text.Trim();
            string professor = txtInsertProfessor.Text.Trim();
            string day = ddlInsertDay.SelectedValue;
            string start = txtInsertStart.Text.Trim();
            string end = txtInsertEnd.Text.Trim();
            string room = txtInsertRoom.Text.Trim();

            if (string.IsNullOrEmpty(courseName) || string.IsNullOrEmpty(professor)
                || string.IsNullOrEmpty(room))
            {
                lblInsertMessage.Text = "⚠ Course name, professor, and room are required.";
                lblInsertMessage.CssClass = "msg-error";
                return;
            }

            if (!TimeSpan.TryParse(start, out TimeSpan startTime) ||
                !TimeSpan.TryParse(end, out TimeSpan endTime))
            {
                lblInsertMessage.Text = "⚠ Times must be in HH:mm format (e.g. 08:00).";
                lblInsertMessage.CssClass = "msg-error";
                return;
            }

            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(
                @"INSERT INTO Courses (CourseName, ProfessorName, DayOfWeek, StartTime, EndTime, Room)
                  VALUES (@CourseName, @ProfessorName, @DayOfWeek, @StartTime, @EndTime, @Room)", con))
            {
                cmd.Parameters.AddWithValue("@CourseName", courseName);
                cmd.Parameters.AddWithValue("@ProfessorName", professor);
                cmd.Parameters.AddWithValue("@DayOfWeek", day);
                cmd.Parameters.AddWithValue("@StartTime", startTime);
                cmd.Parameters.AddWithValue("@EndTime", endTime);
                cmd.Parameters.AddWithValue("@Room", room);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            txtInsertCourseName.Text = "";
            txtInsertProfessor.Text = "";
            txtInsertStart.Text = "";
            txtInsertEnd.Text = "";
            txtInsertRoom.Text = "";

            lblInsertMessage.Text = "✓ Course added successfully.";
            lblInsertMessage.CssClass = "msg-success";
            BindGrid();
        }

        // =====================================================================
        //  UTILITY — fetch just the DayOfWeek for a single course
        // =====================================================================
        private string GetDayForCourse(int courseId)
        {
            using (var con = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(
                "SELECT DayOfWeek FROM Courses WHERE CourseID = @CourseID", con))
            {
                cmd.Parameters.AddWithValue("@CourseID", courseId);
                con.Open();
                var result = cmd.ExecuteScalar();
                return result?.ToString() ?? "";
            }
        }
    }
}