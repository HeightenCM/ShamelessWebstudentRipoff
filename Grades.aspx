<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Grades.aspx.cs" Inherits="ShamelessWebstudentRipoff.Grades" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Grades — University Manager</title>
    <link rel="stylesheet" href="university.css" />
</head>
<body>

    <!-- ── Header ── -->
    <header class="site-header">
        <a class="logo" href="Default.aspx">&#127979; UniManager</a>
        <nav>
            <a href="Grades.aspx" class="active">Grades</a>
            <a href="Schedule.aspx">Schedule</a>
            <a href="Charts.aspx">Statistics</a>
        </nav>
    </header>

    <form id="form1" runat="server">
    <div class="page-wrapper">

        <h1 class="page-title">Grade Management</h1>
        <p class="page-subtitle">View, edit, and record student grades across all courses.</p>

        <!-- ── Filter toolbar ── -->
        <div class="card">
            <div class="toolbar">
                <label for="ddlFilterCourse">Filter by course:</label>
                <asp:DropDownList ID="ddlFilterCourse" runat="server" AutoPostBack="true"
                    OnSelectedIndexChanged="ddlFilterCourse_SelectedIndexChanged"
                    CssClass="asp-dropdownlist" />

                <label for="ddlFilterGroup">Group:</label>
                <asp:DropDownList ID="ddlFilterGroup" runat="server" AutoPostBack="true"
                    OnSelectedIndexChanged="ddlFilterGroup_SelectedIndexChanged"
                    CssClass="asp-dropdownlist" />

                <asp:Button ID="btnClearFilter" runat="server" Text="Clear filters"
                    OnClick="btnClearFilter_Click" CssClass="btn btn-ghost" />
            </div>

            <!-- ── GridView ── -->
            <div class="grid-wrapper">
                <asp:GridView ID="gvGrades" runat="server"
                    AutoGenerateColumns="False"
                    DataKeyNames="GradeID"
                    CssClass="gridview"
                    OnRowEditing="gvGrades_RowEditing"
                    OnRowUpdating="gvGrades_RowUpdating"
                    OnRowCancelingEdit="gvGrades_RowCancelingEdit"
                    OnRowDeleting="gvGrades_RowDeleting"
                    EditRowStyle-CssClass="edit-row"
                    EmptyDataText="No grades found.">

                    <Columns>

                        <asp:BoundField DataField="StudentName" HeaderText="Student"  ReadOnly="True" />
                        <asp:BoundField DataField="GroupName"   HeaderText="Group"    ReadOnly="True" />
                        <asp:BoundField DataField="CourseName"  HeaderText="Course"   ReadOnly="True" />

                        <%-- Grade: plain text when editing, pill when viewing --%>
                        <asp:TemplateField HeaderText="Grade">
                            <ItemTemplate>
                                <%# FormatGradePill(Eval("Grade")) %>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtEditGrade" runat="server"
                                    Text='<%# Eval("Grade") %>'
                                    CssClass="asp-textbox" Style="width:60px" />
                                <asp:RangeValidator runat="server"
                                    ControlToValidate="txtEditGrade"
                                    MinimumValue="1" MaximumValue="10"
                                    Type="Double"
                                    ErrorMessage="1-10"
                                    CssClass="msg-error" />
                            </EditItemTemplate>
                        </asp:TemplateField>

                        <%-- Date --%>
                        <asp:TemplateField HeaderText="Date">
                            <ItemTemplate>
                                <%# Eval("GradeDate", "{0:yyyy-MM-dd}") %>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtEditDate" runat="server"
                                    Text='<%# Eval("GradeDate", "{0:yyyy-MM-dd}") %>'
                                    TextMode="Date"
                                    CssClass="asp-textbox" />
                            </EditItemTemplate>
                        </asp:TemplateField>

                        <%-- Edit / Update / Cancel / Delete --%>
                        <asp:CommandField ShowEditButton="True"
                            EditText="Edit" UpdateText="Save" CancelText="Cancel"
                            ButtonType="Button"
                            ControlStyle-CssClass="btn btn-ghost" />

                        <asp:TemplateField HeaderText="">
                            <ItemTemplate>
                                <asp:Button ID="btnDelete" runat="server"
                                    CommandName="Delete"
                                    Text="Delete"
                                    CssClass="btn btn-danger"
                                    OnClientClick="return confirm('Delete this grade?');" />
                            </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>
                </asp:GridView>
            </div>

            <%-- Feedback label --%>
            <asp:Label ID="lblMessage" runat="server" CssClass="msg-success" />
        </div>

        <!-- ── Insert panel ── -->
        <div class="card">
            <h2 style="font-family:'DM Serif Display',serif;font-size:1.15rem;margin-bottom:1rem;">
                Add New Grade
            </h2>
            <div class="insert-panel">

                <div class="field">
                    <label>Student</label>
                    <asp:DropDownList ID="ddlInsertStudent" runat="server"
                        CssClass="asp-dropdownlist" />
                </div>

                <div class="field">
                    <label>Course</label>
                    <asp:DropDownList ID="ddlInsertCourse" runat="server"
                        CssClass="asp-dropdownlist" />
                </div>

                <div class="field">
                    <label>Grade (1–10)</label>
                    <asp:TextBox ID="txtInsertGrade" runat="server"
                        CssClass="asp-textbox" Style="width:70px" placeholder="e.g. 8.5" />
                    <asp:RangeValidator runat="server"
                        ControlToValidate="txtInsertGrade"
                        MinimumValue="1" MaximumValue="10"
                        Type="Double"
                        ErrorMessage="Must be 1–10"
                        CssClass="msg-error" />
                </div>

                <div class="field">
                    <label>Date</label>
                    <asp:TextBox ID="txtInsertDate" runat="server"
                        TextMode="Date" CssClass="asp-textbox" />
                </div>

                <div class="field" style="justify-content:flex-end">
                    <asp:Button ID="btnInsert" runat="server" Text="Add Grade"
                        OnClick="btnInsert_Click" CssClass="btn btn-gold" />
                </div>

            </div>
            <asp:Label ID="lblInsertMessage" runat="server" CssClass="msg-success" />
        </div>

    </div>
    </form>
</body>
</html>