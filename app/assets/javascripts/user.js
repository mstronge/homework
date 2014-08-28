$(document).ready(function(){
  if (($("#user_role").val()!=null)&&($("#user_role").val()!='student')) {
    $("#user_parent_id").val('');
    $("#user_parent_id").prop("disabled", true);
  }
  
  $("#user_role").change(function() {
    if ($("#user_role").val()!='student') {
      $("#user_parent_id").val('');
      $("#user_parent_id").prop("disabled", true);
    } else { $("#user_parent_id").prop("disabled", false); }   
    return false;
  })

  return false;
})