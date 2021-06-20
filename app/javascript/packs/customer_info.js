$("#searchKey").on("change", function () {
  if (this.value === "timestamp") {
    console.log(this.value);
    $("#searchStartDate").show();
    $("#searchEndDate").show();
    $("#searchVal").hide();
    $("#searchVal").val("");
  } else {
    $("#searchStartDate").hide();
    $("#searchStartDate").val("");
    $("#searchEndDate").hide();
    $("#searchEndDate").val("");
    $("#searchVal").val("");
    $("#searchVal").show();
  }
});
