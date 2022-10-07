using Godot;

namespace TutoProject.Scenes
{
    public interface ICharacter
    {
        void TakeKnockBack(Vector2 attackerPosition);
    }
}
