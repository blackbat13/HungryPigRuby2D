require 'ruby2d'

set title: 'Hungry Pig', width: 800, height: 800

Image.new('images/bg.png')

beet = Image.new('images/beetroot.png', x: 200, y: 200)

pig = Sprite.new(
    'images/pig.png',
    width: 110,
    height: 90,
    clip_width: 110,
    animations: {
        down: 0..0,
        left: 1..1,
        right: 2..2,
        up: 3..3,
        dead: 4..4
    })

pig.x = Window.width / 2 - pig.width / 2
pig.y = Window.height / 2 - pig.height / 2
pig_vx = 0
pig_vy = 0
pig_v = 3
pig_points = 0
pig_dead = false

points = Text.new(
    "0",
    x: Window.width / 2 - 20,
    y: 50,
    size: 60,
    color: '#fdee00',
    font: 'fonts/kenney_bold.ttf'
    )

game_over = Text.new(
    "GAME OVER",
    x: 120,
    y: Window.height / 2,
    size: 70,
    color: '#e30022',
    font: 'fonts/kenney_bold.ttf',
    z: -1
)

continue = Text.new(
    "Press SPACE to try again",
    x: 90,
    y: 2 * Window.height / 3,
    size: 30,
    color: '#e30022',
    font: 'fonts/kenney_bold.ttf',
    z: -1
)

squeak = Sound.new('sounds/pig.wav')

update do
    if not pig_dead
        pig.x += pig_vx
        pig.y += pig_vy

        if pig.contains? beet.x + beet.width / 2, beet.y + beet.height / 2
            pig_points += 1
            points.text = pig_points
            beet.x = rand(50..Window.width - beet.width - 50)
            beet.y = rand(50..Window.height - beet.height - 50)
            pig_v += 0.8
            squeak.play
        end

        if pig.x < 0 or pig.x > Window.width or pig.y < 0 or pig.y > Window.height
            pig_dead = true
            pig.x = Window.width / 2 - pig.width / 2
            pig.y = Window.height / 3 - pig.height / 2
            pig.play animation: :dead, loop: true
            game_over.z = 10
            continue.z = 10
        end
    end

    
end

on :key_down do |event|
    if pig_dead
        if event.key == 'space'
            pig.x = Window.width / 2 - pig.width / 2
            pig.y = Window.height / 2 - pig.height / 2
            pig_vx = 0
            pig_vy = 0
            pig_v = 3
            pig_points = 0
            pig_dead = false
            pig.play animation: :down, loop: true
            game_over.z = -1
            continue.z = -1
            points.text = pig_points
        end
    else
        case event.key
            when 'left'
                pig.play animation: :left, loop: true
                pig_vx = -pig_v
                pig_vy = 0
            when 'right'
                pig.play animation: :right, loop: true
                pig_vx = pig_v
                pig_vy = 0
            when 'up'
                pig.play animation: :up, loop: true
                pig_vx = 0
                pig_vy = -pig_v
            when 'down'
                pig.play animation: :down, loop: true
                pig_vx = 0
                pig_vy = pig_v
        end
    end
end

show