var openedApp = ".main-screen"

qbFitbit = {}
var steps = "233.5k"

var direction = 0;
var distance = 0;


$(document).ready(function () {
    // console.log('Fitbit is loaded..')

    window.addEventListener('message', function (event) {
        var eventData = event.data;

        if (eventData.action == "openWatch") {
            qbFitbit.Open();
        }
        if (eventData.action == "stepsData") {
            $('.circle-text').html(eventData.steps)
        }
        if (eventData.action == "directionData") {
            direction = eventData.direction;
            distance = eventData.distance;
            setupDirection(direction, distance)
        }

    });
});

$(document).on('keydown', function () {
    switch (event.keyCode) {
        case 27:
            qbFitbit.Close();
            break;
    }
});

qbFitbit.Open = function () {
    $(".container").fadeIn(150);
}

qbFitbit.Close = function () {
    $(".container").fadeOut(150);
    $.post('https://qb-fitbit/close')
}

$(document).on('click', '.fitbit-app', function (e) {
    e.preventDefault();

    var pressedApp = $(this).data('app');

    $(openedApp).css({ "display": "none" });
    $("." + pressedApp + "-app").css({ "display": "block" });
    if (currentapp === "step-app") {
        $('.circle-text span').text(steps);
    };
    openedApp = pressedApp;
});

$(document).on('click', '.back-food-settings', function (e) {
    e.preventDefault();

    $(".food-app").css({ "display": "none" });
    $(".main-screen").css({ "display": "block" });

    openedApp = ".main-screen";
});

$(document).on('click', '.back-thirst-settings', function (e) {
    e.preventDefault();

    $(".thirst-app").css({ "display": "none" });
    $(".main-screen").css({ "display": "block" });

    openedApp = ".main-screen";
});

$(document).on('click', '.back-step-settings', function (e) {
    e.preventDefault();

    $(".step-app").css({ "display": "none" });
    $(".main-screen").css({ "display": "block" });

    openedApp = ".main-screen";
});
$(document).on('click', '.back-direction-settings', function (e) {
    e.preventDefault();

    $(".direction-app").css({ "display": "none" });
    $(".main-screen").css({ "display": "block" });

    openedApp = ".main-screen";
});

$(document).on('click', '.save-food-settings', function (e) {
    e.preventDefault();

    var foodValue = $(this).parent().parent().find('input');

    if (parseInt(foodValue.val()) <= 100) {
        $.post('https://qb-fitbit/setFoodWarning', JSON.stringify({
            value: foodValue.val()
        }));
    }
});

$(document).on('click', '.save-thirst-settings', function (e) {
    e.preventDefault();

    var thirstValue = $(this).parent().parent().find('input');

    if (parseInt(thirstValue.val()) <= 100) {
        $.post('https://qb-fitbit/setThirstWarning', JSON.stringify({
            value: thirstValue.val()
        }));
    }
});


$(document).on('click', '.reset-steps', function (e) {
    e.preventDefault();

    steps = 0
    $('.circle-text span').text(steps);
    $.post('https://qb-fitbit/setStepCount', JSON.stringify({
        value: steps
    }));
});


function setupDirection(direction, distance) {

    // 0 = You Have Arrived
    // 1 = Recalculating Route, Please make a u-turn where safe
    // 2 = Please Proceed the Highlighted Route
    // 3 = In (distToNxJunction) Turn Left
    // 4 = In (distToNxJunction) Turn Right
    // 5 = In (distToNxJunction) Go Straight
    // 6 = In (distToNxJunction) Keep Left
    // 7 = In (distToNxJunction) Keep Right
    // 8 = In (distToNxJunction) Join the freeway
    // 9 = In (distToNxJunction) Exit Freeway
    var tp="m"
    if (distance>1000) {
        tp="km"
        distance=(distance/1000).toFixed(1)
    } else {
        tp="m"
        distance=(distance | 0)
    }
    switch (direction) {
        case 0:
            $('#directionTitle').html('Direction')
            $('.direction-text').html('Arrive')
            break;
        case 1:
            $('#directionTitle').html('Direction')
            $('.direction-text').html('U-Turn')
            break;
        case 2:
            $('#directionTitle').html('Direction')
            $('.direction-text').html('<i class="fas fa-arrow-up"></i>')
            break;
        case 3:
            $('#directionTitle').html('Direction')
            $('.direction-text').html('<i class="fas fa-arrow-left"></i>')
            break;
        case 4:
            $('#directionTitle').html('Direction')
            $('.direction-text').html('<i class="fas fa-arrow-right"></i>')
            break;
        case 5:
            $('#directionTitle').html('Direction')
            $('.direction-text').html('<i class="fas fa-arrow-up"></i>')
            break;
        case 6:
            $('#directionTitle').html('Direction')
            $('.direction-text').html('<i class="fas fa-arrow-up icorote45"></i>')
            break;
        case 7:
            $('#directionTitle').html('Direction')
            $('.direction-text').html('<i class="fas fa-arrow-up icorote315"></i>')
            break;
        case 8:
            $('directionTitle').html('Direction')
            $('.direction-text').html('<i class="fas fa-road"></i>')
            break;
        case 9:
            $('#directionTitle').html('Direction')
            $('.direction-text').html('<i class="fas fa-road"></i>')
        case "noblip":
            $('#directionTitle').html('Direction')
            $('.direction-text').html('No blip')
            break;
        case "onFoot":
            $('#directionTitle').html('Distance')
            $('.direction-text').html(distance+ " "+tp)
            break;
        default:
            $('#directionTitle').html('Direction')
            $('.direction-text').html('No blip')
            break;
    }

}






function kFormatter(num) {
    return Math.abs(num) > 999 ? Math.sign(num) * ((Math.abs(num) / 1000).toFixed(1)) + 'k' : Math.sign(num) * Math.abs(num)
}
