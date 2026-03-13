<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Schedule.aspx.cs" Inherits="ShamelessWebstudentRipoff.Schedule" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Orar</title>
    <link rel="stylesheet" href="university.css" />
</head>
<body>

    <header class="site-header">
        <a class="logo" href="Default.aspx">&#127979; NetStudent</a>
        <nav>
            <a href="Grades.aspx">Calificative</a>
            <a href="Schedule.aspx" class="active">Orar</a>
            <a href="Charts.aspx">Statistici</a>
        </nav>
    </header>

    <form id="form1" runat="server">
    <div class="page-wrapper">

        <h1 class="page-title">Programul cursurilor</h1>
        <p class="page-subtitle">Vezi, adauga si modifica ore in program.</p>

        <!-- ── Filter toolbar ── -->
        <div class="card">
            <div class="toolbar">
                <label>Filtreaza dupa zi:</label>
                <asp:DropDownList ID="ddlDay" runat="server" AutoPostBack="true"
                    OnSelectedIndexChanged="ddlDay_SelectedIndexChanged"
                    CssClass="asp-dropdownlist">
                    <asp:ListItem Text="All days" Value="" />
                    <asp:ListItem Text="Monday"    Value="Monday" />
                    <asp:ListItem Text="Tuesday"   Value="Tuesday" />
                    <asp:ListItem Text="Wednesday" Value="Wednesday" />
                    <asp:ListItem Text="Thursday"  Value="Thursday" />
                    <asp:ListItem Text="Friday"    Value="Friday" />
                </asp:DropDownList>
            </div>

            <!-- ── GridView ── -->
            <div class="grid-wrapper">
                <asp:GridView ID="gvSchedule" runat="server"
                    AutoGenerateColumns="False"
                    DataKeyNames="CourseID"
                    CssClass="gridview"
                    OnRowEditing="gvSchedule_RowEditing"
                    OnRowUpdating="gvSchedule_RowUpdating"
                    OnRowCancelingEdit="gvSchedule_RowCancelingEdit"
                    OnRowDeleting="gvSchedule_RowDeleting"
                    EditRowStyle-CssClass="edit-row"
                    EmptyDataText="Niciun curs gasit.">
                    <Columns>

                        <asp:TemplateField HeaderText="Nume curs">
                            <ItemTemplate><%# Eval("CourseName") %></ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtCourseName" runat="server"
                                    Text='<%# Eval("CourseName") %>' CssClass="asp-textbox" />
                            </EditItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Profesor">
                            <ItemTemplate><%# Eval("ProfessorName") %></ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtProfessor" runat="server"
                                    Text='<%# Eval("ProfessorName") %>' CssClass="asp-textbox" />
                            </EditItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Zi">
                            <ItemTemplate><%# Eval("DayOfWeek") %></ItemTemplate>
                            <EditItemTemplate>
                                <asp:DropDownList ID="ddlEditDay" runat="server" CssClass="asp-dropdownlist">
                                    <asp:ListItem Text="Monday"    Value="Monday" />
                                    <asp:ListItem Text="Tuesday"   Value="Tuesday" />
                                    <asp:ListItem Text="Wednesday" Value="Wednesday" />
                                    <asp:ListItem Text="Thursday"  Value="Thursday" />
                                    <asp:ListItem Text="Friday"    Value="Friday" />
                                </asp:DropDownList>
                            </EditItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Start">
                            <ItemTemplate><%# Eval("StartTime") %></ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtStart" runat="server"
                                    Text='<%# Eval("StartTime") %>'
                                    CssClass="asp-textbox" Style="width:80px" placeholder="08:00" />
                            </EditItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Sfarsit">
                            <ItemTemplate><%# Eval("EndTime") %></ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtEnd" runat="server"
                                    Text='<%# Eval("EndTime") %>'
                                    CssClass="asp-textbox" Style="width:80px" placeholder="10:00" />
                            </EditItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Sala">
                            <ItemTemplate><%# Eval("Room") %></ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtRoom" runat="server"
                                    Text='<%# Eval("Room") %>'
                                    CssClass="asp-textbox" Style="width:70px" />
                            </EditItemTemplate>
                        </asp:TemplateField>

                        <asp:CommandField ShowEditButton="True"
                            EditText="Modifica" UpdateText="Salveaza" CancelText="Anuleaza"
                            ButtonType="Button"
                            ControlStyle-CssClass="btn btn-ghost" />

                        <asp:TemplateField HeaderText="">
                            <ItemTemplate>
                                <asp:Button ID="btnDelete" runat="server"
                                    CommandName="Delete" Text="Sterge"
                                    CssClass="btn btn-danger"
                                    OnClientClick="return confirm('Delete this course?');" />
                            </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>
                </asp:GridView>
            </div>

            <asp:Label ID="lblMessage" runat="server" CssClass="msg-success" />
        </div>

        <!-- ── Insert panel ── -->
        <div class="card">
            <h2 style="font-family:'DM Serif Display',serif;font-size:1.15rem;margin-bottom:1rem;">
                Adauga un curs nou
            </h2>
            <div class="insert-panel">

                <div class="field">
                    <label>Nume curs</label>
                    <asp:TextBox ID="txtInsertCourseName" runat="server" CssClass="asp-textbox" />
                </div>

                <div class="field">
                    <label>Profesor</label>
                    <asp:TextBox ID="txtInsertProfessor" runat="server" CssClass="asp-textbox" />
                </div>

                <div class="field">
                    <label>Zi</label>
                    <asp:DropDownList ID="ddlInsertDay" runat="server" CssClass="asp-dropdownlist">
                        <asp:ListItem Text="Monday"    Value="Monday" />
                        <asp:ListItem Text="Tuesday"   Value="Tuesday" />
                        <asp:ListItem Text="Wednesday" Value="Wednesday" />
                        <asp:ListItem Text="Thursday"  Value="Thursday" />
                        <asp:ListItem Text="Friday"    Value="Friday" />
                    </asp:DropDownList>
                </div>

                <div class="field">
                    <label>Start (HH:mm)</label>
                    <asp:TextBox ID="txtInsertStart" runat="server"
                        CssClass="asp-textbox" Style="width:80px" placeholder="08:00" />
                </div>

                <div class="field">
                    <label>Sfarsit (HH:mm)</label>
                    <asp:TextBox ID="txtInsertEnd" runat="server"
                        CssClass="asp-textbox" Style="width:80px" placeholder="10:00" />
                </div>

                <div class="field">
                    <label>Sala</label>
                    <asp:TextBox ID="txtInsertRoom" runat="server"
                        CssClass="asp-textbox" Style="width:70px" />
                </div>

                <div class="field" style="justify-content:flex-end">
                    <asp:Button ID="btnInsert" runat="server" Text="Adauga curs"
                        OnClick="btnInsert_Click" CssClass="btn btn-gold" />
                </div>

            </div>
            <asp:Label ID="lblInsertMessage" runat="server" CssClass="msg-success" />
        </div>

    </div>
    </form>
</body>
</html>
