using Godot;

public class HUD : Godot.CanvasLayer
{
    [Signal]
    public delegate void StartGame();

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {

    }

    public void ShowMessage(string text)
    {
        var message = GetNode<Label>("Message");
        message.Text = text;
        message.Show();

        GetNode<Timer>("MessageTimer").Start();
    }

    async public void ShowGameOver()
    {
        ShowMessage("Game Over");

        await ToSignal(GetTree().CreateTimer(1), "timeout");
        GetNode<Button>("StartButton").Show();
        GetNode<Button>("QuitButton").Show();
    }

    public void QuittButtonPressed()
    {
        GetTree().Quit();
    }

    public void OnStartButtonPressed()
    {
        ShowHideMenu(false);
        EmitSignal("StartGame");
    }

    public void ShowHideMenu(bool isVisible)
    {
        if (isVisible)
        {
            GetNode<Button>("StartButton").Show();
            GetNode<Button>("QuitButton").Show();
        }
        else
        {
            GetNode<Button>("StartButton").Hide();
            GetNode<Button>("QuitButton").Hide();
        }
    }

    public void OnMessageTimerTimeout()
    {
        GetNode<Label>("Message").Hide();
    }

    //  // Called every frame. 'delta' is the elapsed time since the previous frame.
    //  public override void _Process(float delta)
    //  {
    //      
    //  }
}
