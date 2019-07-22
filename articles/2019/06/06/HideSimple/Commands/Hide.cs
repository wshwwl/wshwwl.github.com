
using System.Collections.Generic;
using System.Drawing;
using System.Windows.Forms;
using SpaceClaim.Api.V15.LX.Properties;

namespace SpaceClaim.Api.V15.LX {

    // This command provides an example of how to dynamically update Text and Hint strings when the language changes 
    // within a SpaceClaim session. To do so, this command derives from BaseCommandCapsule and passes delegates to
    // the base class constructor.
    class HideCapsule : BaseCommandCapsule
    {
        // The name must match the name specified in the ribbon bar XML.
        public const string CommandName = "LXAddIn.C#.V17.Hide";

        public HideCapsule()
            : base(CommandName, () => Resources.HideText, Resources.HideImage, () => Resources.HideHint)
        {
        }

        protected override void OnInitialize(Command command)
        {
            base.OnInitialize(command);

            // Add a keyboard shortcut for this command.
            // A block will be created when Y is pressed.
            const Keys shortcut = Keys.Y;
            if (Command.GetCommand(shortcut) == null) // else shortcut is already used by another command
                command.Shortcuts = new[] { shortcut };
        }

        protected override void OnUpdate(Command command)
        {
            // When a command is disabled, all UI components associated with the command are also disabled.
            command.IsEnabled = Window.ActiveWindow.ActiveContext.Selection.Count > 0;
        }

        protected override void OnExecute(Command command, ExecutionContext context, Rectangle buttonRect)
        {
            Window window = Window.ActiveWindow;
            if (window == null) return;
            ICollection<IDocObject> selectItems = window.ActiveContext.Selection;
            foreach (var selecteditem in selectItems)
            {
                IDesignBody visibleItem = selecteditem as IDesignBody ?? selecteditem.GetAncestor<IDesignBody>();
                if (visibleItem != null )  visibleItem.SetVisibility(null,false);
            }
            window.ActiveContext.Selection = null;
            window.ActiveContext.Preselection = null;
        }
    }
}