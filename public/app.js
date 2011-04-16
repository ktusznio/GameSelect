$(function() {
  $("#pick").click(function() {
    $.ajax("/random", {
      data: {
        username: $("#username").val(),
        num_games: $("#num_games").val(),
        num_players: $("#num_players").val(),
        playtime: $("#playtime").val()
      },
      dataType: "json",
      success: function(games) {
        var ul = "<ul>";
        $.each(games, function(index, game) {
          ul += "<li>" + game.name + "</li>";
        });
        ul += "</ul>";
        $("#games").html(ul);
      },
      type: "POST"
    });
  });
});
