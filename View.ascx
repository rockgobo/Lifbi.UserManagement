<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="View.ascx.cs" Inherits="Christoc.Modules.Lifbi.UserManagement.View" %>


<script language="javascript">
    var auth_key = '<%= AuthKey  %>';
    var username = '<%= Username  %>';
    var is_logged_in = <%=  IsLoggedIn ? 1 : 0 %>;
    var apiPath = '<%= HandlerPath %>';
    var image_path = '<%= ProfileImage%>';


    $(document).ready(function () {
        viewModel = new usersviewmodel(auth_key, '<%= HandlerPath %>', image_path);
        viewModel.loadUser();
        viewModel.loadUsers();
        ko.applyBindings(viewModel, document.getElementById('view'));  
     });
</script>



<div id="view">
    <div data-bind="visible: isLoggedOut" class="dnnFormMessage dnnFormWarning">
        Sie müssen sich zunächst an der Webseite anmelden.
    </div>
    
    <div  data-bind="visible: Loading">
            <asp:Image runat="server" ImageUrl="img/loading.gif" ID="ImageLoading"/>    
    </div>
    
    <!-- ko with: User -->
    <h2 onclick="$(this).next().toggle()" data-bind="text: 'Stammdaten von '+ FirstName() + ' ' + LastName() "></h2>
    <div class="profile" style="display: none">
        <table class="dnnFormItem">
                <tr>
                    <td class="label">Titel: </td> 
                    <td class="dnnFormItem"><input type="text" data-bind="value: Title"/></td>
                    <td rowspan="6" style="width: 50%; vertical-align: top; text-align: right">
                        <img data-bind="attr: {src: $root.ImagePath}" style="height: 200px"/>
                    </td>
                </tr>
                <tr>
                    <td class="label">Vorname: </td> 
                    <td class="dnnFormItem"><input type="text" data-bind="value: FirstName"/></td>
                </tr>
                <tr>
                    <td class="label">Nachname*: </td> 
                    <td class="dnnFormItem"><input type="text" data-bind="value: LastName, css:{empty: LastName() == ''}"/></td>
                </tr>
                <tr>
                    <td class="label">Email*: </td> 
                    <td class="dnnFormItem"><input type="text" data-bind="value: Email, css:{empty: Email() == ''}"/></td>
                </tr>
                <tr>
                    <td class="label">Abteilung: </td> 
                    <td class="dnnFormItem"><input type="text" data-bind="value: Department"/></td>
                </tr>
                <tr>
                    <td class="label">Institution: </td> 
                    <td class="dnnFormItem"><input type="text" data-bind="value: Institution"/></td>
                </tr>
                <tr>
                    <td colspan="2">
                        &nbsp;
                    </td>
                </tr>
                    <tr class="details">
                    <td colspan="7">
                        <table>
                            <tr>
                                <td class="label">Strasse: </td><td class="dnnFormItem"><input type="text" data-bind="value: Street" /></td>
                                <td class="label">Hausnummer: </td><td class="dnnFormItem"><input type="text" data-bind="value: StreetNr" /></td>
                            </tr>
                            <tr>
                                <td class="label">Postleitzahl: </td><td class="dnnFormItem"><input type="text" data-bind="value: Zip" /></td>
                                <td class="label">Stadt: </td><td class="dnnFormItem"><input type="text" data-bind="value: City" /></td>
                            </tr>
                            <tr>
                                <td class="label" >Telefon: </td><td colspan="3" class="dnnFormItem"><input type="text" data-bind="value: Phone" /></td>
                                </tr>
                            <tr>
                                <td class="label" >&nbsp; </td><td colspan="3" class="dnnFormItem" data-bind="text: $root.ExampleTelephone"></td>
                            </tr>
                        </table>
                    </td>
               </tr>
               <tr>
                    <td class="label">Biographie: </td> 
                    <td class="dnnFormItem"  colspan="2">
                        <textarea disabled="true"><%= ProfileBiography %></textarea>
                    </td>
                </tr>
                </table>
            
                <div class="actions">
                    <input data-bind="click: Save, enable: CanSave" type="button" class="dnnPrimaryAction" value="Speichern"/>
                </div>
            
    </div>
    <!-- /ko -->
    

    <h2 onclick="$(this).siblings('.groups').toggle()" data-bind="visible: !isLoggedOut() && !Loading()">Gruppen</h2>
    
    
    <div  data-bind="visible: isNotResponsible" class="dnnFormMessage dnnFormInfo">
        Sie haben für keine Gruppe die Verantwortung.
    </div>

    <div data-bind="foreach: groups" class="groups">
        <h3 data-bind="text: ReadableGroupName() + ' [' + Users().length + ']'" onclick="$(this).next().toggle()"></h3>
        <div class="groupusers" style="display: none">
            <div data-bind="text: Description" class="description"></div>
            <a data-bind="click: ToggleNewUser" type="button" class="dnnPrimaryAction">Neuen Nutzer beantragen</a>
            <div data-bind="with: NewUser, visible: ShowNewUser" class="newuser">
                <table width="100%" class="usergroup userfields" >
                <tr>
                    <td class="label">Titel: </td> <td><input data-bind="value: Title"/></td>
                </tr>
                <tr>
                    <td class="label">Vorname: </td> <td><input data-bind="value: FirstName"/></td>
                </tr>
                <tr>
                    <td class="label">Nachname*: </td> <td><input data-bind="value: LastName, css:{empty: LastName() == ''}"/></td>
                </tr>
                <tr>
                    <td class="label">Email*: </td> <td><input data-bind="value: Email, css:{empty: Email() == ''}"/></td>
                </tr>
                <tr>
                    <td class="label">Abteilung: </td> <td><input data-bind="value: Department"/></td>
                </tr>
                <tr>
                    <td class="label">Institution: </td> <td><input data-bind="value: Institution"/></td>
                </tr>
                <tr>
                    <td colspan="2">
                        &nbsp;
                    </td>
                </tr>
                    <tr class="details">
                    <td colspan="7">
                        <table width="100%">
                            <tr>
                                <td class="label">Strasse: </td><td><input data-bind="value: Street" /></td>
                                <td class="label">Hausnummer: </td><td><input data-bind="value: StreetNr" /></td>
                            </tr>
                            <tr>
                                <td class="label">Postleitzahl: </td><td><input data-bind="value: Zip" /></td>
                                <td class="label">Stadt: </td><td><input data-bind="value: City" /></td>
                            </tr>
                            <tr>
                                <td class="label" >Telefon: </td><td colspan="3"><input data-bind="value: Phone" /></td>
                            </tr>
                            <tr>
                                <td class="label" >&nbsp;</td><td colspan="3"  data-bind="text: $root.ExampleTelephone"></td>
                            </tr>
                            <tr>
                                <td class="label">Kommentar: </td>
                                <td  colspan="3"><textarea rows="5" data-bind="value: RequestComment" ></textarea></td>
                            </tr>
                        </table>
                    </td>
               </tr>
                    
                </table>
                <div class="actions">
                    <input data-bind="click: $parent.AddNewUser, enable: CanSave" type="button" class="dnnPrimaryAction" value="Absenden"/>
                    <input onclick="$(this).parent().parent().toggle()" type="button" class="dnnSecondaryAction" value="Abbrechen"/>
                </div>
            </div>

            
            <table class="usergroup nepsTable" width="100%">
                <tr>
                    <th data-bind="click: OrderByTitle" class="sortable">Titel <span data-bind="visible: SortColumn() == 1"><asp:Image  ID="ImageTitle" runat="server" ImageUrl="img/dnnSpinnerDownArrowWhite.png"/></span></th>
                    <th data-bind="click: OrderByFirstName" class="sortable">Vorname <span data-bind="visible: SortColumn() == 2"><asp:Image ID="ImageFirstName" runat="server" ImageUrl="img/dnnSpinnerDownArrowWhite.png"/></span></th>
                    <th data-bind="click: OrderByLastName" class="sortable">Nachname <span data-bind="visible: SortColumn() == 3"><asp:Image ID="ImageLastName" runat="server" ImageUrl="img/dnnSpinnerDownArrowWhite.png"/></span></th>
                    <th data-bind="click: OrderByEmail" class="sortable">Email <span data-bind="visible: SortColumn() == 4"><asp:Image ID="ImageEmail" runat="server" ImageUrl="img/dnnSpinnerDownArrowWhite.png"/></span></th>
                    <th title="Ungesicherte Inhalte?"></th>
                </tr>
                <!-- ko foreach: Users --> 
               <tr data-bind="visible: !Deleted(), css:{selected: ShowDetails}" class="user">
                    <td data-bind="click: $parent.ToggleDetails" style="width:50px"><span data-bind="text: OldTitle"></span></td>
                    <td data-bind="click: $parent.ToggleDetails"><span data-bind="    text: OldFirstName"></span></td>
                    <td data-bind="click: $parent.ToggleDetails"><span data-bind="    text: OldLastName"></span></td>
                    <td data-bind="click: $parent.ToggleDetails"><span data-bind="    text: OldEmail"></span></td>
                    
                    <td  style="width:10px">
                        <span data-bind="visible: HasChanged">*</span>
                    </td>
               </tr>
               <tr data-bind="visible: !Deleted() && ShowDetails(), css:{selected: ShowDetails}" class="details">
                    <td colspan="7">
                        <table width="100%" class="userfields">
                            <tr>
                                <td class="label">Titel: </td><td colspan="3"><input data-bind="value: Title" /></td>
                            </tr>
                            <tr>
                                <td class="label">Vorname: </td><td colspan="3"><input data-bind="value: FirstName" /></td>
                            </tr>
                            <tr>
                                <td class="label">Nachname: </td><td colspan="3"><input data-bind="value: LastName, css:{empty: LastName() == ''}" /></td>
                            </tr>
                            <tr>
                                <td class="label">Email: </td><td colspan="3"><input data-bind="value: Email, css:{empty: Email() == ''}" /></td>
                            </tr>
                            <tr>
                                <td class="label">Abteilung: </td> <td colspan="3"><input data-bind="value: Department"/></td>
                            </tr>
                            <tr>
                                <td class="label">Institution: </td> <td colspan="3"><input data-bind="value: Institution"/></td>
                            </tr>
                            <tr>
                                <td class="label">Strasse: </td><td><input data-bind="value: Street" /></td>
                                <td class="label">Hausnummer: </td><td><input data-bind="value: StreetNr" /></td>
                            </tr>
                            <tr>
                                <td class="label">Postleitzahl: </td><td><input data-bind="value: Zip" /></td>
                                <td class="label">Stadt: </td><td><input data-bind="value: City" /></td>
                            </tr>
                            <tr>
                                <td class="label">Telefon: </td><td colspan="3"><input data-bind="value: Phone" /></td>
                            </tr>
                            <tr>
                                <td class="label">&nbsp;</td><td colspan="3" data-bind="text: $root.ExampleTelephone"></td>
                            </tr>
                        </table>
                        
                        <div class="actions">
                            <input type="button" data-bind="click: Save, enable: CanSave" class="dnnPrimaryAction" value="Speichern"/>
                            <input type="button" data-bind="click: $parent.ToggleDetails" class="dnnSecondaryAction" value="Abbrechen"/>
                            <div style="float:right">
                                <input type="button"  data-bind="click: ToggleRemoveUser, enable: CanSave() && !ShowRemoveUser()" class="dnnPrimaryAction" title="Nutzer entfernen?" value="Antrag zum Entfernen"/>
                            </div>
                            <div class="popup" data-bind="visible: ShowRemoveUser">
                                <b>Wollen sie den Nutzer wirklich entfernen?</b>
                                <p>Hiermit stellen Sie einen Antrag diesen Nutzer zu entfernen.</p> 
                                <p>Beachten Sie bitte, dass der Nutzer erst aus der Liste entfernt wird, wenn die Administration diesen Antrag bearbeitet. Sie bekommen nach dem Antrag eine Auftragbestättigung an die bei uns hinterlegte Email-Adresse.</p>
                                <p>Bitte nennen Sie uns auch die Gründe für dieses Vorhaben:</p>
                                <textarea data-bind="value:RequestComment"></textarea>
                                <input type="button"  data-bind="click: $parent.RemoveUser, enable: CanSave" class="dnnPrimaryAction" title="Nutzer wirklich entfernen?" value="Abschicken"/>
                                <input type="button"  data-bind="click: ToggleRemoveUser, enable: CanSave" class="dnnSecondaryAction" value="Abbrechen"/>
                            </div>
                        </div>
                    </td>
               </tr>
                <!-- /ko -->
            </table>
        </div>
        
        
        <div id="dialog_newuser" data-bind="with: NewUser">
            
        </div>
    </div>
</div>