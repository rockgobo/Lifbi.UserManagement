var usersviewmodel = function(authKey, handlerPath, imagePath) {
    var self = this;
    self.authKey = authKey;
    self.serviceUsers = handlerPath + "Users/";
    self.groups = ko.observableArray([]);

    self.Loading = ko.observable(true);

    self.isLoggedOut = ko.computed(function() { return self.authKey == ''; });
    self.isNotResponsible = ko.computed(function() { return !self.isLoggedOut() && self.groups().length == 0 && !self.Loading(); });

    self.ExampleTelephone = "Bitte verwenden sie folgende Formatierung: +49 XXXX XXXXXX";

    self.User = ko.observable();
    self.ImagePath = ko.observable(imagePath);
    
    /***********************************************************
    *                           LOADER
    ************************************************************/
    self.loadUser = function () {
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

    self.loadUsers = function () {
        self.Loading(true);
        $.ajax({
                type: 'POST',
                dataType: 'json',
                url: self.serviceUsers + "GetUsersByResponsible/",
                data: { AuthKey: self.authKey },
                success: function(data) {
                    self.groups = ko.mapping.fromJS(data, mapping, self.groups);
                    self.Loading(false);
                },
                error: function(jqXHR, textStatus, errorThrown) {
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

var UserModel = function(data) {
    var self = this;

    ko.mapping.fromJS(data, {}, self);

    self.New = ko.observable(data.New ? true : false);
    self.RequestComment = ko.observable("");

    self.OldTitle = ko.observable(data.Title);
    self.OldFirstName = ko.observable(data.FirstName);
    self.OldLastName = ko.observable(data.LastName);
    self.OldEmail = ko.observable(data.Email);

    self.OldStreet = ko.observable(data.Street);
    self.OldStreetNr = ko.observable(data.StreetNr);
    self.OldZip = ko.observable(data.Zip);
    self.OldCity = ko.observable(data.City);
    self.OldPhone = ko.observable(data.Phone);

    self.RowVersion = null;

    self.ShowDetails = ko.observable(false);
    self.ToggleDetails = function () {
        self.ShowDetails(!self.ShowDetails());
    };

    self.HasChanged = ko.computed(function () {
        return self.OldTitle() != self.Title() || self.OldFirstName() != self.FirstName() || self.OldLastName() != self.LastName() || self.OldEmail() != self.Email() || self.OldStreet() != self.Street() || self.OldStreetNr() != self.StreetNr() || self.OldZip() != self.Zip() || self.OldCity() != self.City() || self.OldPhone() != self.Phone();
    });

    self.CanSave = ko.computed(function() {
        return self.LastName() != "" && self.Email() != "" && self.LastName() != null && self.Email() != null;
    });

    self.Deleted = ko.observable(false);

    self.Cancel = function() {
        self.Title(self.OldTitle());
        self.FirstName(self.OldFirstName());
        self.LastName(self.OldLastName());
        self.Email(self.OldEmail());

        self.Street(self.OldStreet());
        self.StreetNr(self.OldStreetNr());
        self.Zip(self.OldZip());
        self.City(self.OldCity());
        self.Phone(self.OldPhone());
    };

    self.ShowRemoveUser = ko.observable(false);
    self.ToggleRemoveUser = function () {
        self.ShowRemoveUser(!self.ShowRemoveUser());
    };

    self.Save = function () {
        if (!self.HasChanged()) {
            alert("No changes need to be saved");
            self.ShowDetails(false);
            return;
        }

        $.ajax({
            type: 'POST',
            dataType: 'json',
            url: apiPath +"Users/SaveUser/",
            data: { AuthKey: auth_key, User: ko.mapping.toJSON(self) },
            success: function (data) {
                if (data.ResultCode == 0) {
                    self.OldTitle(self.Title());
                    self.OldFirstName(self.FirstName());
                    self.OldLastName(self.LastName());
                    self.OldEmail(self.Email());

                    self.OldStreet(self.Street());
                    self.OldStreetNr(self.StreetNr());
                    self.OldZip(self.Zip());
                    self.OldCity(self.City());
                    self.OldPhone(self.Phone());

                    alert("User successfully saved.");

                    self.ShowDetails(false);
                }
                if (data.ResultCode == 4) {
                    alert("No chances has been saved.");
                    self.ShowDetails(false);
                }
                if (data.ResultCode == -1) {
                    alert("Error: User could not be saved.");
                    self.ShowDetails(false);
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