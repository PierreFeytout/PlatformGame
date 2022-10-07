using Godot;
public class HitBox : Area2D
{
    [Export]
    public int Damage { get; set; }

    public HitBox()
    {
        CollisionLayer = 2;
        CollisionMask = 0;
    }

    public override void _Ready()
    {
        
    }

//  // Called every frame. 'delta' is the elapsed time since the previous frame.
//  public override void _Process(float delta)
//  {
//      
//  }
}
