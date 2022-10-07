using Godot;
using TutoProject.Scenes;
using static Godot.GD;

public class HurtBox : Area2D
{
    [Export]
    public int Damage { get; set; }

    public HurtBox()
    {
        CollisionLayer = 0;
        CollisionMask = 2;
    }

    public override void _Ready()
    {
        Connect("area_entered", this, "OnAreaEntered");
    }

    public void OnAreaEntered(Area2D node)
    {
        Print("Hurted");
        if (Owner is ICharacter character)
        {
            character.TakeKnockBack(node.GlobalPosition);
        }
    }

//  // Called every frame. 'delta' is the elapsed time since the previous frame.
//  public override void _Process(float delta)
//  {
//      
//  }
}
