using Godot;
using static Godot.GD;

public class Player : KinematicBody2D
{
    private bool isAttacking = false;
    private const string WalkSoundPath = "res://Assets/Audio/Walk02.wav";
    private const string JumpSoundPath = "res://Assets/Audio/jump.wav";
    private const string attackSoundPath = "res://Assets/Audio/SFX/UI/Whoosh/whoosh 05.wav";

    AudioStream walkAudioStream;
    AudioStream jumpAudioStream;
    AudioStream attackAudioStream;

    Sprite sprite;
    AnimationPlayer animationPlayer;
    const float GRAVITY = 600;
    const float WALK_SPEED = 200;
    const float JUMP_FORCE = 250;
    Vector2 velocity;
    AudioStreamPlayer2D playerSounds;

    private bool isJumping = false;

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        walkAudioStream = GD.Load<AudioStream>(WalkSoundPath);
        jumpAudioStream = GD.Load<AudioStream>(JumpSoundPath);
        attackAudioStream = GD.Load<AudioStream>(attackSoundPath);

        playerSounds = GetNode<AudioStreamPlayer2D>("PlayerSounds");
        animationPlayer = GetNode<AnimationPlayer>("AnimationPlayer");
        sprite = GetNode<Sprite>("Sprite");
        Hide();
        SetPhysicsProcess(false);
    }

    public override void _PhysicsProcess(float delta)
    {
        if (isAttacking)
        {
            return;
        }

        var snap = new Vector2(0, 32);

        velocity.y += delta * GRAVITY;

        if (Input.IsActionPressed("move_left"))
        {
            velocity.x = -WALK_SPEED;
            sprite.Scale = new Vector2(-1, 1);

            if (IsOnFloor())
            {
                if (playerSounds.Stream != walkAudioStream || !playerSounds.Playing)
                {
                    playerSounds.Stream = walkAudioStream;
                    playerSounds.Play();
                }

                animationPlayer.Play("Run");
            }
        }
        else if (Input.IsActionPressed("move_right"))
        {
            velocity.x = WALK_SPEED;
            sprite.Scale = new Vector2(1, 1);

            if (IsOnFloor())
            {
                animationPlayer.Play("Run");

                if (playerSounds.Stream != walkAudioStream || !playerSounds.Playing)
                {
                    playerSounds.Stream = walkAudioStream;
                    playerSounds.Play();
                }
            }
        }
        else
        {
            if (playerSounds.Stream == walkAudioStream)
            {
                playerSounds.Stream = walkAudioStream;
                playerSounds.Stop();
            }

            velocity.x = 0;
            velocity.x = Mathf.Lerp(velocity.x, 0, 0.1f);

            if (IsOnFloor())
            {
                animationPlayer.Play("Idle");
            }
        }

        if (Input.IsActionJustPressed("jump") && IsOnFloor())
        {
            velocity.y = -JUMP_FORCE;

            //animatedSprite.Play("Jump");
            animationPlayer.Play("Jump");

            isJumping = true;

            playerSounds.Stream = jumpAudioStream;
            playerSounds.Play();
        }
        if (!IsOnFloor() && velocity.y > 0)
        {
            animationPlayer.Play("Falling");
            isJumping = false; ;
        }

        if (isJumping)
        {
            snap = new Vector2();
        }

        // We don't need to multiply velocity by delta because "MoveAndSlide" already takes delta time into account.

        // The second parameter of "MoveAndSlide" is the normal pointing up.
        // In the case of a 2D platformer, in Godot, upward is negative y, which translates to -1 as a normal.
        velocity = MoveAndSlideWithSnap(velocity, snap, Vector2.Up, true);
    }

    public void Start()
    {
        velocity = new Vector2(0, 0);
        MoveAndSlide(velocity, Vector2.Up);
        Show();
        SetPhysicsProcess(true);
    }

    // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _Process(float delta)
    {
        if (animationPlayer.AssignedAnimation == "Attack1" && animationPlayer.CurrentAnimation != animationPlayer.AssignedAnimation)
        {
            isAttacking = false;
        }

        if (Input.IsActionJustPressed("attack_1") && IsOnFloor() && !isAttacking)
        {
            isAttacking = true;
            playerSounds.Stream = attackAudioStream;
            playerSounds.Play();
            animationPlayer.Play("Attack1");
        }
    }
}