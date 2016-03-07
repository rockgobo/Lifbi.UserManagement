<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="View.ascx.cs" Inherits="Christoc.Modules.Lifbi.UserManagement.View" %>

<script language="javascript">
    var auth_key = '<%= AuthKey  %>';
    var username = '<%= Username  %>';
    var is_logged_in = <%=  IsLoggedIn ? 1 : 0 %>;
    var apiPath = '<%= HandlerPath %>';
    var image_path = '<%= ImagePath%>';


    $(document).ready(function () {
        viewModel = new usersviewmodel(auth_key, '<%= HandlerPath %>', image_path);
        viewModel.loadUser();
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
    <h2 data-bind="text: 'Stammdaten von '+ UAMUser.FirstName() + ' ' + UAMUser.LastName() "></h2> 
    <div class="profile">
        <input type="checkbox" data-bind="checked: $root.editMode" /> Stammdaten verändern
        <table class="dnnFormItem">
                <tr>
                    <td class="label">Titel: </td> 
                    <td class="dnnFormItem">
                        <input type="text" data-bind="value: UAMUser.Title, enable: $root.editMode"/>
                    </td>
                    <td rowspan="9" style="width: 50%; vertical-align: top; text-align: right">
                        <img data-bind="attr: {src: $root.ImagePath() +Extensions.Folder() + Extensions.FileName()+'?'+(new Date().getTime())}" style="height: 200px; border-radius: 4px;" id="profile"/>
                        <div id="new_image_container">
                            <input id="fileupload" type="file" name="image" accept="image/*" data-bind="fileInput: $root.fileData, customFileInput: {
                buttonClass: 'dnnPrimaryAction',
                clearButtonClass: 'dnnSecondaryAction clearbutton',
                fileNameClass: 'disabled form-control',
                onClear: $root.onClear,
            }" />
                            <div>
                                <img id="profile_new" style="height: 125px;" class="img-rounded  thumb" data-bind="attr: { src: $root.fileData().dataURL }, visible: $root.fileData().dataURL" />
                            </div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td class="label">Vorname: </td> 
                    <td class="dnnFormItem"><input type="text" data-bind="value: UAMUser.FirstName,enable: $root.editMode"/></td>
                </tr>
                <tr>
                    <td class="label">Nachname*: </td> 
                    <td class="dnnFormItem"><input type="text" data-bind="value: UAMUser.LastName,enable: $root.editMode, css:{empty: UAMUser.LastName() == ''}"/></td>
                </tr>
                <tr>
                    <td class="label">Email*: </td> 
                    <td class="dnnFormItem"><input type="text" data-bind="value: UAMUser.Email,enable: $root.editMode, css:{empty: UAMUser.Email() == ''}"/></td>
                </tr>
                <tr>
                    <td class="label">Strasse: </td>
                    <td class="dnnFormItem"><input type="text" data-bind="value: UAMUser.Street,enable: $root.editMode" /></td>
                </tr>
                <tr>
                    
                    <td class="label">Hausnummer: </td>
                    <td class="dnnFormItem"><input type="text" data-bind="value: UAMUser.StreetNr,enable: $root.editMode" /></td>
                </tr>
                <tr>
                    <td class="label">Postleitzahl: </td>
                    <td class="dnnFormItem"><input type="text" data-bind="value: UAMUser.Zip,enable: $root.editMode" /></td>
                </tr>
                <tr>
                    
                    <td class="label">Stadt: </td>
                    <td class="dnnFormItem"><input type="text" data-bind="value: UAMUser.City,enable: $root.editMode" /></td>
                </tr>
                <tr>
                    <td class="label" >Telefon: </td>
                    <td class="dnnFormItem"><input type="text" data-bind="value: UAMUser.Phone,enable: $root.editMode" /></td>
                    </tr>
                <tr>
                    <td class="label" >&nbsp; </td>
                    <td  class="dnnFormItem" data-bind="text: $root.ExampleTelephone,enable: $root.editMode"></td>
                </tr>
               <tr>
                    <td class="label">Biographie:</td> 
                    <td class="dnnFormItem" colspan="2">
                        <div data-bind="wysiwyg: Extensions.Biography"></div>
                    </td>
                </tr>
            
               <tr>
                    <td class="label">Biographie (en):</td> 
                    <td class="dnnFormItem" colspan="2">
                        <div data-bind="wysiwyg: Extensions.Biography_En"></div>
                    </td>
                </tr>
            
               <tr>
                    <td class="label">Veröffentlichungen:</td> 
                    <td class="dnnFormItem" colspan="2">
                        <div data-bind="wysiwyg: Extensions.Publications"></div>
                    </td>
                </tr>
                </table>
    </div> 
    
    <div class="actions">
        <input data-bind="click: $root.Save" type="button" class="dnnPrimaryAction" value="Speichern"/>
    </div>
    <!-- /ko -->
    <div data-bind="text: Comment, visible: Comment" class="dnnFormMessage dnnFormInfo"></div>
</div>
  