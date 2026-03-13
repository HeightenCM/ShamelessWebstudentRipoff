<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Grades.aspx.cs" Inherits="ShamelessWebstudentRipoff.Grades" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Calificative</title>
    <link rel="stylesheet" href="university.css" />
</head>
<body>

    <!-- ── Header ── -->
    <header class="site-header">
        <a class="logo" href="Default.aspx">&#127979; NetStudent</a>
        <nav>
            <a href="Grades.aspx" class="active">Calificative</a>
            <a href="Schedule.aspx">Orar</a>
            <a href="Charts.aspx">Statistici</a>
        </nav>
    </header>

    <form id="form1" runat="server">
    <div class="page-wrapper">

        <h1 class="page-title">Managementul calificativelor</h1>
        <p class="page-subtitle">Vezi, modifica si adauga calificative studentilor.</p>

        <!-- ── Filter toolbar ── -->
        <div class="card">
            <div class="toolbar">
                <label for="ddlFilterCourse">Filtreaza dupa curs:</label>
                <asp:DropDownList ID="ddlFilterCourse" runat="server" AutoPostBack="true"
                    OnSelectedIndexChanged="ddlFilterCourse_SelectedIndexChanged"
                    CssClass="asp-dropdownlist" />

                <label for="ddlFilterGroup">Grup:</label>
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
                        <asp:BoundField DataField="GroupName"   HeaderText="Grup"    ReadOnly="True" />
                        <asp:BoundField DataField="CourseName"  HeaderText="Curs"   ReadOnly="True" />

                        <%-- Grade: plain text when editing, pill when viewing --%>
                        <asp:TemplateField HeaderText="Calificativ">
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
                        <asp:TemplateField HeaderText="Data">
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
                            EditText="Modifica" UpdateText="Salveaza" CancelText="Anuleaza"
                            ButtonType="Button"
                            ControlStyle-CssClass="btn btn-ghost" />

                        <asp:TemplateField HeaderText="">
                            <ItemTemplate>
                                <asp:Button ID="btnDelete" runat="server"
                                    CommandName="Delete"
                                    Text="Sterge"
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
                Adauga un nou calificativ
            </h2>
            <div class="insert-panel">

                <div class="field">
                    <label>Student</label>
                    <asp:DropDownList ID="ddlInsertStudent" runat="server"
                        CssClass="asp-dropdownlist" />
                </div>

                <div class="field">
                    <label>Curs</label>
                    <asp:DropDownList ID="ddlInsertCourse" runat="server"
                        CssClass="asp-dropdownlist" />
                </div>

                <div class="field">
                    <label>Nota (1–10)</label>
                    <asp:TextBox ID="txtInsertGrade" runat="server"
                        CssClass="asp-textbox" Style="width:70px" placeholder="ex. 8.5" />
                    <asp:RangeValidator runat="server"
                        ControlToValidate="txtInsertGrade"
                        MinimumValue="1" MaximumValue="10"
                        Type="Double"
                        ErrorMessage="Must be 1–10"
                        CssClass="msg-error" />
                </div>

                <div class="field">
                    <label>Data</label>
                    <asp:TextBox ID="txtInsertDate" runat="server"
                        TextMode="Date" CssClass="asp-textbox" />
                </div>

                <div class="field" style="justify-content:flex-end">
                    <asp:Button ID="btnInsert" runat="server" Text="Adauga calificativ"
                        OnClick="btnInsert_Click" CssClass="btn btn-gold" />
                </div>

            </div>
            <asp:Label ID="lblInsertMessage" runat="server" CssClass="msg-success" />
        </div>

    </div>
    </form>
</body>
</html>