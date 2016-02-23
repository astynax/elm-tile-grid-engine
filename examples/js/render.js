function initRender(port, canvasId, sx, sy, tiles) {
    var canvas = document.getElementById(canvasId);
    var ctx = canvas.getContext("2d");

    var images = {};
    for (k in tiles) {
        images[k] = document.getElementById(tiles[k])
    };

    function render(map) {
        for (var y = 0; y < map.length; y++) {
            var row = map[y];
            for (var x = 0; x < row.length; x++) {
                ctx.drawImage(images[row[x]], x * sx, y * sy);
            };
        };
    };

    port.subscribe(render);
};
