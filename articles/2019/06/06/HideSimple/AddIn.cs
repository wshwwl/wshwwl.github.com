/*
 * Sample add-in for the SpaceClaim API
 */

using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Windows.Forms;
using SpaceClaim.Api.V15.LX.Properties;
using SpaceClaim.Api.V15.Extensibility;
using SpaceClaim.Api.V15.Geometry;

namespace SpaceClaim.Api.V15.LX {
	public class LXAddIn : AddIn, IExtensibility, ICommandExtensibility, IRibbonExtensibility {
		readonly CommandCapsule[] capsules = new[] {
			new CommandCapsule("LXAddIn.C#.V17.RibbonTab", Resources.RibbonTabText),
			new CommandCapsule("LXAddIn.C#.V17.PartGroup", Resources.PartGroupText),
			new HideCapsule(),
			
		};

		#region IExtensibility Members

		public bool Connect() {
			return true;
		}

		public void Disconnect() {

		}

		#endregion

		#region ICommandExtensibility Members

		public void Initialize() {
			foreach (CommandCapsule capsule in capsules)
				capsule.Initialize();
		}

		#endregion

		#region IRibbonExtensibility Members

		public string GetCustomUI() {

			return Resources.Ribbon;
		}

		#endregion
	}

}