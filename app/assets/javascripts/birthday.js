function birthday() {
 $('#bday').validate({
  debug: true,
  rules: {
   "hrs[birthday]": {
    required: true
  }
},

errorElement: "span",

errorClass: "help-block",

messages: {
 "hrs[birthday]" : {
  required: "This field is required"
}
},
highlight: function(element) {
 $(element).parent().parent().addClass("has-error");
},

unhighlight: function(element) {
 $(element).parent().parent().removeClass("has-error");
},

      submitHandler: function(form){
      $(form)
      .submit()
      .always(function(){ hideLoadingScreen() });
      }
     });

}

