function companyupdates() {
 $('#updates').validate({
  debug: true,
  rules: {
   "hrs[name1]": {
    required: true
  },
  "hrs[description1]": {
    required:true
  }
},

errorElement: "span",

errorClass: "help-block",

messages: {
 "hrs[name1]" : {
  required: "This field is required"
},

"hrs[description1]":{
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

