using Godot;
using System;

public class Main : Node
{
    private HUD _hud;
    private Level1 _level1;
    private DateTime timeSinceEscape;
    private bool gameStarted = false;

    public Main()
    {
    }

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        _hud = GetNode<HUD>("HUD");
        _level1 = GetNode<Level1>("Level1");
    }

    public void NewGame()
    {
        _level1.Start();
        gameStarted = true;
    }

    // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _Process(float delta)
    {
        if (gameStarted
            && Input.IsActionJustReleased("open_menu")
            && (DateTime.Now - timeSinceEscape) > TimeSpan.FromSeconds(0.5))
        {
            timeSinceEscape = DateTime.Now;
            var sceneTree = GetTree();
            if (sceneTree.Paused)
            {
                CloseMenu();
            }
            else
            {
                OpenMenu();
            }

        }
    }

    private void OpenMenu()
    {
        _level1.Pause();
        _hud.ShowHideMenu(true);
    }

    private void CloseMenu()
    {
        _level1.Play();
        _hud.ShowHideMenu(false);
    }
}
