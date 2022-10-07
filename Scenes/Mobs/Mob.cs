using Godot;
using static Godot.GD;
using TutoProject.Scenes.Mobs;
using TutoProject.Scenes;
using System.Drawing.Text;

public class Mob : KinematicBody2D, ICharacter
{
    Player _player;
    AnimatedSprite sprite;
    const float GRAVITY = 600;
    const float WALK_SPEED = 100;
    Vector2 velocity;
    MobOrder order = MobOrder.Idle;
    
    Vector2 targetPosition;

    float knockBackDelta = 0f;
    bool tookKnockBack = false;


    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        sprite = GetNode<AnimatedSprite>("AnimatedSprite");
        targetPosition = this.Position;
    }

    public override void _PhysicsProcess(float delta)
    {
        if (_player != null && Mathf.Abs(_player.GlobalPosition.x - GlobalPosition.x) < 25f && !tookKnockBack)
        {
            if (velocity != Vector2.Zero)
            {
                velocity = Vector2.Zero;
                MoveAndSlide(velocity);
            }

            sprite.Play("attack");
            var hitbox = GetNode<CollisionShape2D>("SwordHitBox/CollisionShape2D");
            hitbox.Disabled = false;
            return;
        }

        velocity.y += delta * GRAVITY;

        if (tookKnockBack)
        {
            knockBackDelta += delta;
            velocity = velocity.MoveToward(Vector2.Zero, 200 * delta);
            velocity.x = Mathf.Lerp(velocity.x, 0, 0.1f);
            if (knockBackDelta >= 0.8f)
            {
                tookKnockBack = false;
                knockBackDelta = 0.0f;
            }
        }
        else
        {
            HandleClassicMovement(delta);
        }


        // We don't need to multiply velocity by delta because "MoveAndSlide" already takes delta time into account.

        // The second parameter of "MoveAndSlide" is the normal pointing up.
        // In the case of a 2D platformer, in Godot, upward is negative y, which translates to -1 as a normal.
        velocity = MoveAndSlide(velocity, Vector2.Up);
    }

        private void HandleClassicMovement(float delta)
        {
            switch (order)
            {
                case MobOrder.Left:
                    velocity.x = -WALK_SPEED;
                    sprite.FlipH = false;

                    if (IsOnFloor())
                    {
                        sprite.Play("walk");
                    }
                    break;
                case MobOrder.Right:
                    velocity.x = WALK_SPEED;
                    sprite.FlipH = true;

                    if (IsOnFloor())
                    {
                        sprite.Play("walk");
                    }
                    break;
                case MobOrder.Idle:
                default:
                    velocity = velocity.MoveToward(Vector2.Zero, 200 * delta);
                    velocity.x = Mathf.Lerp(velocity.x, 0, 0.1f);

                    if (IsOnFloor())
                    {
                        sprite.Play("idle");
                    }
                    break;
            }
        }

    public void OnArea2DBodyEntered(Node body)
    {
        if (body is Player player)
        {
            _player = player;
            if (player.Position.x < Position.x)
            {
                order = MobOrder.Left;
            }
            else
            {
                order = MobOrder.Right;
            }
        }
    }

    public void OnArea2DBodyExited(Node body)
    {
        if (body is Player player)
        {
            _player = player;
            order = MobOrder.Idle;
        }
    }

    private void AnimationFinished()
    {
        if (sprite.Animation == "attack")
        {
            var hitbox = GetNode<CollisionShape2D>("SwordHitBox/CollisionShape2D");
            hitbox.Disabled = true;
        }
    }

    private void DetectPlayerRaycast()
    {
        var spaceState = GetWorld2d().DirectSpaceState;
        // use global coordinates, not local to node
        var result = spaceState.IntersectRay(this.GlobalPosition, new Vector2(20, 0), new Godot.Collections.Array { this });
        if (result.Count > 0)
        {
            if (result["collider"] is Player player)
            {
                targetPosition = (Vector2)result["position"];
                order = MobOrder.Left;
                Print($"Player left {player.Position}    {targetPosition}");
            }
        }

        result = spaceState.IntersectRay(this.GlobalPosition, new Vector2(-20, 0), new Godot.Collections.Array { this });
        if (result.Count > 0)
        {
            if (result["collider"] is Player player)
            {
                targetPosition = (Vector2)result["position"];
                order = MobOrder.Right;
                Print($"Player right {player.Position}    {targetPosition}");
            }
        }
    }

    public void TakeKnockBack(Vector2 attackerPosition)
    {
        if (tookKnockBack)
        {
            return;
        }
        else
        {
            tookKnockBack = true;
        }

        velocity.x = Mathf.Lerp(velocity.x, attackerPosition.x < GlobalPosition.x ? 1500 : -1500, 0.5f);
        sprite.Play("hurt");
    }

    //  // Called every frame. 'delta' is the elapsed time since the previous frame.
    //  public override void _Process(float delta)
    //  {
    //      
    //  }
}
