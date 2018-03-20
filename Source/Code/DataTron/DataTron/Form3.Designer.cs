namespace DataTron
{
    partial class Form3
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.buttonBack = new System.Windows.Forms.Button();
            this.buttonTestNode = new System.Windows.Forms.Button();
            this.buttonGetLicense = new System.Windows.Forms.Button();
            this.buttonUpdateLicense = new System.Windows.Forms.Button();
            this.buttonGetSnapshot = new System.Windows.Forms.Button();
            this.buttonRegisterSnapShot = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // buttonBack
            // 
            this.buttonBack.Location = new System.Drawing.Point(534, 214);
            this.buttonBack.Name = "buttonBack";
            this.buttonBack.Size = new System.Drawing.Size(152, 23);
            this.buttonBack.TabIndex = 0;
            this.buttonBack.Text = "Back";
            this.buttonBack.UseVisualStyleBackColor = true;
            this.buttonBack.Click += new System.EventHandler(this.buttonBack_Click);
            // 
            // buttonTestNode
            // 
            this.buttonTestNode.Location = new System.Drawing.Point(13, 14);
            this.buttonTestNode.Name = "buttonTestNode";
            this.buttonTestNode.Size = new System.Drawing.Size(143, 23);
            this.buttonTestNode.TabIndex = 1;
            this.buttonTestNode.Text = "Test Node";
            this.buttonTestNode.UseVisualStyleBackColor = true;
            this.buttonTestNode.Click += new System.EventHandler(this.buttonTestNode_Click);
            // 
            // buttonGetLicense
            // 
            this.buttonGetLicense.Location = new System.Drawing.Point(13, 43);
            this.buttonGetLicense.Name = "buttonGetLicense";
            this.buttonGetLicense.Size = new System.Drawing.Size(143, 23);
            this.buttonGetLicense.TabIndex = 2;
            this.buttonGetLicense.Text = "Get License";
            this.buttonGetLicense.UseVisualStyleBackColor = true;
            this.buttonGetLicense.Click += new System.EventHandler(this.buttonGetLicense_Click);
            // 
            // buttonUpdateLicense
            // 
            this.buttonUpdateLicense.Location = new System.Drawing.Point(13, 73);
            this.buttonUpdateLicense.Name = "buttonUpdateLicense";
            this.buttonUpdateLicense.Size = new System.Drawing.Size(143, 23);
            this.buttonUpdateLicense.TabIndex = 3;
            this.buttonUpdateLicense.Text = "Update License";
            this.buttonUpdateLicense.UseVisualStyleBackColor = true;
            this.buttonUpdateLicense.Click += new System.EventHandler(this.buttonUpdateLicense_Click);
            // 
            // buttonGetSnapshot
            // 
            this.buttonGetSnapshot.Location = new System.Drawing.Point(13, 114);
            this.buttonGetSnapshot.Name = "buttonGetSnapshot";
            this.buttonGetSnapshot.Size = new System.Drawing.Size(143, 23);
            this.buttonGetSnapshot.TabIndex = 4;
            this.buttonGetSnapshot.Text = "Check Snapshot";
            this.buttonGetSnapshot.UseVisualStyleBackColor = true;
            this.buttonGetSnapshot.Click += new System.EventHandler(this.buttonGetSnapshot_Click);
            // 
            // buttonRegisterSnapShot
            // 
            this.buttonRegisterSnapShot.Location = new System.Drawing.Point(13, 144);
            this.buttonRegisterSnapShot.Name = "buttonRegisterSnapShot";
            this.buttonRegisterSnapShot.Size = new System.Drawing.Size(143, 23);
            this.buttonRegisterSnapShot.TabIndex = 5;
            this.buttonRegisterSnapShot.Text = "Register Backup Location";
            this.buttonRegisterSnapShot.UseVisualStyleBackColor = true;
            this.buttonRegisterSnapShot.Click += new System.EventHandler(this.buttonRegisterSnapShot_Click);
            // 
            // Form3
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(712, 330);
            this.Controls.Add(this.buttonRegisterSnapShot);
            this.Controls.Add(this.buttonGetSnapshot);
            this.Controls.Add(this.buttonUpdateLicense);
            this.Controls.Add(this.buttonGetLicense);
            this.Controls.Add(this.buttonTestNode);
            this.Controls.Add(this.buttonBack);
            this.Name = "Form3";
            this.Text = "Form3";
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Button buttonBack;
        private System.Windows.Forms.Button buttonTestNode;
        private System.Windows.Forms.Button buttonGetLicense;
        private System.Windows.Forms.Button buttonUpdateLicense;
        private System.Windows.Forms.Button buttonGetSnapshot;
        private System.Windows.Forms.Button buttonRegisterSnapShot;
    }
}