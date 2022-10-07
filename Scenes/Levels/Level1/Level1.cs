using Godot;
using static Godot.GD;
using System;

public class Level1 : Node2D
{
    private HUD _hud;
    private AudioStreamPlayer _music;
    private Player _player;
    private Light2D _light = null;
    private SceneTree _sceneTree;

    // Declare member variables here. Examples:
    // private int a = 2;
    // private string b = "text";

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        this.PauseMode = PauseModeEnum.Stop;
        _music = GetNode<AudioStreamPlayer>("Music");
        _music.PauseMode = PauseModeEnum.Stop;
        _player = GetNode<Player>("Player");
        _sceneTree = GetTree();
    }

    public void Start()
    {
        _player.Start();
        _music.Play();
    }

    public void Play()
    {
        Print("Play");
        _sceneTree.Paused = false;
    }

    public void Pause()
    {
        Print("Pause");
        _sceneTree.Paused = true;
    }

    //  // Called every frame. 'delta' is the elapsed time since the previous frame.
    //  public override void _Process(float delta)
    //  {
    //      
    //  }
}
