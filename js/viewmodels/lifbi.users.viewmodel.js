var usersviewmodel = function(authKey, handlerPath, imagePath) {
    var self = this;
    self.authKey = authKey;
    self.serviceUsers = handlerPath + "Users/";
    self.groups = ko.observableArray([]);

    self.Loading = ko.observable(false);

    self.isLoggedOut = ko.computed(function() { return self.authKey == ''; });
    self.isNotResponsible = ko.computed(function() { return !self.isLoggedOut() && self.groups().length == 0 && !self.Loading(); });

    self.ExampleTelephone = "Bitte verwenden sie folgende Formatierung: +49 XXXX XXXXXX";

    self.User = ko.observable();
    self.ImagePath = ko.observable(imagePath);
    self.Comment = ko.observable("");

    self.editMode = ko.observable(false);

    /*************************
    *      Image
    **************************/
    self.fileData = ko.observable({
        dataURL: ko.observable()
    });
    self.onClear = function (fileData) {
        fileData.clear && fileData.clear();
    };

    self.fileData().dataURL.subscribe(function (dataURL) {
        // dataURL has changed do something with it!
    });

    /***********************************************************
    *                           LOADER
    ************************************************************/
    self.loadUser = function () {
        if (!self.authKey){ return };
        self.Loading(true);
        $.ajax({
            type: 'POST',
            dataType: 'json',
            url: self.serviceUsers + "GetMe/",
            data: { AuthKey: self.authKey },
            success: function (data) {
                self.User(new UserModel(data));
                self.Loading(false);
            },
            error: function (jqXHR, textStatus, errorThrown) {
                self.Loading(false);
                var err = jqXHR.responseText;
                if (err) {
                    self.Warning(err.replace(/"/g, ''));
                } else {
                    self.Warning("Unknown server error.");
                }
            }
        }
        );
    };

    /***********************************************************
    *                           Save
    ************************************************************/
    self.Save = function () {
        var user = self.User();
        var imageData = self.fileData().dataURL();
        imageData = imageData == undefined ? '' : imageData;

        $.ajax({
            type: 'POST',
            dataType: 'json',
            url: apiPath + "Users/SaveUser/",
            data: {
                AuthKey: auth_key,
                User: ko.mapping.toJSON(user),
                ImageData: imageData
            },
            success: function (data) {
                if (data.ResultCode == -1) {
                    self.Comment("Alert: User could not be saved");
                }
                else {
                    self.Comment("User saved");
                    if (imageData) {
                        $("#profile").attr("src", imageData)
                        $("#profile_new").attr("src", "")
                    }
                }
            },
            error: function (jqXHR, textStatus, errorThrown) {
                var err = jqXHR.responseText;
                if (err)
                    alert(err.replace(/"/g, ''));
                else
                    alert("Unknown server error.");
            }
        }
       );
    };
};

var mapping = {
    create : function(options) {
        return new GroupModel(options.data);
    },
    
};

var usermapping =
{
    'Users': {
        create: function(options) {
            return new UserModel(options.data);
        }
    }
};

/************************************************
*              Additional Models
*************************************************/
var GroupModel = function(data) {
    var self = this;
    ko.mapping.fromJS(data, usermapping, self);

    self.ReadableGroupName = ko.computed(function() {
        if (self.GroupName().indexOf("ngg_") == 0 && self.Description() != "") {
            return self.Description() + " (" + self.GroupName() + ") ";
        }
        return self.GroupName();
    });

    self.NewUser = ko.observable(new UserModel({ "New": true, "Title": "", "FirstName": "", "LastName": "", "Email": "", "Street": "", "StreetNr": "", "Zip": "", "City": "", "Phone": "", "Department": "", "Institution": "" }));

    self.AddNewUser = function() {
        //self.Users.push(self.NewUser());
        self.RequestAction(self.NewUser(), "Add user to list");
        self.ShowNewUser(false);
    };

    self.ShowNewUser = ko.observable(false);
    self.ToggleNewUser = function() {
        self.ShowNewUser(!self.ShowNewUser());
    };

    /***********************************************************
    *                           UTILS
    ************************************************************/

    self.ToggleDetails = function (user) {
        $.each(self.Users(), function(index, value) {
            if (value.Id() == user.Id()) {
                user.ShowDetails(!user.ShowDetails());
            }
            else{
                value.ShowDetails(false);
            }
        });
        
    };

    self.RemoveUser = function (user) {
        self.RequestAction(user, "Remove user from list");   
    };
    self.DisableUser = function (user) {
       self.RequestAction(user, "Disable user");   
    };

    self.RequestAction = function (user, action) {

        $.ajax({
            type: 'POST',
            dataType: 'json',
            url: apiPath + "Users/RequestUserAction/",
            data: { AuthKey: auth_key, GroupId: self.Id(), Comment: user.RequestComment(), Action: action, User: ko.mapping.toJSON(user) },
            success: function (data) {
                alert("Your request was send to the LIfBi adminstration.");
                user.ShowRemoveUser(false);
                user.ShowDetails(false);
            },
            error: function (jqXHR, textStatus, errorThrown) {
                var err = jqXHR.responseText;
                if (err)
                    alert(err.replace(/"/g, ''));
                else
                    alert("Unknown server error.");
            }
        }
       );
    };

    self.SortColumn = ko.observable(0);

    self.OrderByLastName = function() {
        self.Users.sort(function (left, right) { return left.LastName() > right.LastName() ? 1 : -1; });
        self.SortColumn(3);
    };
    self.OrderByFirstName = function () {
        self.Users.sort(function (left, right) { return left.FirstName() > right.FirstName() ? 1 : -1; });
        self.SortColumn(2);
    };
    self.OrderByEmail = function () {
        self.Users.sort(function (left, right) { return left.Email() > right.Email() ? 1 : -1; });
        self.SortColumn(4);
    };
    self.OrderByTitle = function () {
        self.Users.sort(function (left, right) { return left.Title() > right.Title() ? 1 : -1; });
        self.SortColumn(1);
    };
    self.OrderByLastName();
};

String.prototype.replaceAll = function (search, replacement) {
    var target = this;
    return target.replace(new RegExp(search, 'g'), replacement);
};

var UserModel = function(data) {
    var self = this;

    ko.mapping.fromJS(data, {}, self);
        
    self.RowVersion = null;

    self.HasChanged = ko.computed(function () {
        return true;
    });

    self.CanSave = ko.computed(function() {
        return true;
    });

    self.Cancel = function() {
    };
};