//Costum binding for the TinyMCE Editor
ko.bindingHandlers.wysiwyg = {
    init: function (element, valueAccessor, allBindingsAccessor, viewModel) {
        var value = valueAccessor();
        var valueUnwrapped = ko.unwrap(value);
        var allBindings = allBindingsAccessor();
        var $element = $(element);
        $element.attr('id', 'wysiwyg_' + Date.now());

        function htmlEncode(value) {
            if (value)
                return value.replaceAll('&lt;', '<')
                        .replaceAll('&gt;', '>')
                        .replaceAll('&amp;', '&');
            return '';
        }

        var readonly = $element.attr('enable') === "1" ? 1 : 0;
        if (ko.isObservable(value)) {
            var isSubscriberChange = false;
            var isEditorChange = true;
            $element.html(htmlEncode(value()));
            var isEditorChange = false;

            tinymce.init({
                selector: '#' + $element.attr('id'),
                inline: true,
                menubar: false,
                readonly: readonly,
                plugins: [
                    "advlist autolink lists link image charmap print preview anchor",
                    "searchreplace visualblocks code fullscreen",
                    "insertdatetime media table contextmenu paste"
                ],
                toolbar: "insertfile undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link",
                setup: function (editor) {
                    editor.on('change', function () {
                        if (!isSubscriberChange) {
                            isEditorChange = true;
                            value($element.html());
                            isEditorChange = false;
                        }
                    });
                }
            });
            value.subscribe(function (newValue) {
                if (!isEditorChange) {
                    isSubscriberChange = true;
                    $element.html(newValue);
                    isSubscriberChange = false;
                }
            });
        }
    }
};