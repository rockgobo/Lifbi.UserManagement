/*
' Copyright (c) 2014  Christoc.com
'  All rights reserved.
' 
' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED
' TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
' THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
' CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
' DEALINGS IN THE SOFTWARE.
' 
*/

using System;
using DotNetNuke.Security;
using DotNetNuke.Services.Exceptions;
using DotNetNuke.Entities.Modules;
using DotNetNuke.Entities.Modules.Actions;
using DotNetNuke.Services.Localization;
using Neps.Security;
using DotNetNuke.Common.Utilities;

namespace Christoc.Modules.Lifbi.UserManagement
{
    /// -----------------------------------------------------------------------------
    /// <summary>
    /// The View class displays the content
    /// 
    /// Typically your view control would be used to display content or functionality in your module.
    /// 
    /// View may be the only control you have in your project depending on the complexity of your module
    /// 
    /// Because the control inherits from Lifbi.UserManagementModuleBase you have access to any custom properties
    /// defined there, as well as properties from DNN such as PortalId, ModuleId, TabId, UserId and many more.
    /// 
    /// </summary>
    /// -----------------------------------------------------------------------------
    public partial class View : LifbiUserManagementModuleBase, IActionable
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                //Scripts
                DotNetNuke.Framework.jQuery.RequestRegistration();
                Page.ClientScript.RegisterClientScriptInclude("tinymce.min.js", this.ControlPath + "js/tinymce/tinymce.min.js");
                Page.ClientScript.RegisterClientScriptInclude("knockout.js", this.ControlPath + "js/knockout-3.0.0.js");
                Page.ClientScript.RegisterClientScriptInclude("knockout.mapping.js", this.ControlPath + "js/knockout.mapping-latest.js");
                Page.ClientScript.RegisterClientScriptInclude("wysiwyg.binding.js", this.ControlPath + "js/wysiwyg.binding.js");
                Page.ClientScript.RegisterClientScriptInclude("knockout-file-bindings.js", this.ControlPath + "js/knockout-file-bindings.js");
                Page.ClientScript.RegisterClientScriptInclude("json2.js", this.ControlPath + "js/json2.js");
                Page.ClientScript.RegisterClientScriptInclude("neps.studydesignchanges.viewmodel", this.ControlPath + "js/viewmodels/lifbi.users.viewmodel.js");
                

            }
            catch (Exception exc) //Module failed to load
            {
                Exceptions.ProcessModuleLoadException(this, exc);
            }
        }


        /// <summary>
        /// Returns the URL of the Search handler
        /// </summary>
        public string HandlerPath
        {
            get
            {
                return string.Concat(DesktopModuleAbsolutePath, "NepsServices/API/");
            }
        }

        /// <summary>
        /// Gets the absolute path of the application (ie. http://localhost)
        /// </summary>
        private string ApplicationAbsolutePath
        {
            get
            {
                return
                    Context.Request.Url.GetLeftPart(UriPartial.Path)
                                       .Substring(0,
                                        Context.Request.Url.GetLeftPart(
                                        UriPartial.Path).IndexOf(
                                        DotNetNuke.Common.Globals.
                                        ApplicationPath,
                                        System.StringComparison.
                                        CurrentCultureIgnoreCase));
            }
        }
        /// <summary>
        /// Gets the absolute path of the DesktopModule (ie. http://localhost/navigio.website/DesktopModules/)
        /// </summary>
        private string DesktopModuleAbsolutePath
        {
            get { return String.Concat(ApplicationAbsolutePath, DotNetNuke.Common.Globals.DesktopModulePath); }
        }

        //Decrypted user name
        public string AuthKey
        {
            get
            {
                return SecurityHelper.Encrypt(this.UserInfo.Username);
            }
        }
        //Decrypted user name
        public string Username
        {
            get
            {
                return this.UserInfo.Username;
            }
        }

        //User logged in?
        public bool IsLoggedIn
        {
            get
            {
                return this.UserInfo.UserID > 0;
            }
        }

        //User logged in?
        public string ImagePath
        {
            get
            {
                return ApplicationAbsolutePath + Page.ResolveUrl("~/UserImages/");
            }
        }

        public ModuleActionCollection ModuleActions
        {
            get
            {
                var actions = new ModuleActionCollection
                    {
                        {
                            GetNextActionID(), Localization.GetString("EditModule", LocalResourceFile), "", "", "",
                            EditUrl(), false, SecurityAccessLevel.Edit, true, false
                        }
                    };
                return actions;
            }
        }
    }
}