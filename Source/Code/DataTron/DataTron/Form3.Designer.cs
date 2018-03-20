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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Form3));
            this.buttonExit = new System.Windows.Forms.Button();
            this.buttonTestNode = new System.Windows.Forms.Button();
            this.buttonGetLicense = new System.Windows.Forms.Button();
            this.buttonUpdateLicense = new System.Windows.Forms.Button();
            this.buttonGetSnapshot = new System.Windows.Forms.Button();
            this.buttonRegisterSnapShot = new System.Windows.Forms.Button();
            this.buttonKibanaTemplate = new System.Windows.Forms.Button();
            this.buttonMarvelTemplate = new System.Windows.Forms.Button();
            this.buttonBack = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // buttonExit
            // 
            this.buttonExit.Location = new System.Drawing.Point(750, 311);
            this.buttonExit.Name = "buttonExit";
            this.buttonExit.Size = new System.Drawing.Size(177, 23);
            this.buttonExit.TabIndex = 0;
            this.buttonExit.Text = "Exit";
            this.buttonExit.UseVisualStyleBackColor = true;
            this.buttonExit.Click += new System.EventHandler(this.buttonBack_Click);
            // 
            // buttonTestNode
            // 
            this.buttonTestNode.Location = new System.Drawing.Point(15, 14);
            this.buttonTestNode.Name = "buttonTestNode";
            this.buttonTestNode.Size = new System.Drawing.Size(167, 23);
            this.buttonTestNode.TabIndex = 1;
            this.buttonTestNode.Text = "Test Node";
            this.buttonTestNode.UseVisualStyleBackColor = true;
            this.buttonTestNode.Click += new System.EventHandler(this.buttonTestNode_Click);
            // 
            // buttonGetLicense
            // 
            this.buttonGetLicense.Location = new System.Drawing.Point(15, 43);
            this.buttonGetLicense.Name = "buttonGetLicense";
            this.buttonGetLicense.Size = new System.Drawing.Size(167, 23);
            this.buttonGetLicense.TabIndex = 2;
            this.buttonGetLicense.Text = "Get License";
            this.buttonGetLicense.UseVisualStyleBackColor = true;
            this.buttonGetLicense.Click += new System.EventHandler(this.buttonGetLicense_Click);
            // 
            // buttonUpdateLicense
            // 
            this.buttonUpdateLicense.Location = new System.Drawing.Point(15, 73);
            this.buttonUpdateLicense.Name = "buttonUpdateLicense";
            this.buttonUpdateLicense.Size = new System.Drawing.Size(167, 23);
            this.buttonUpdateLicense.TabIndex = 3;
            this.buttonUpdateLicense.Text = "Update License";
            this.buttonUpdateLicense.UseVisualStyleBackColor = true;
            this.buttonUpdateLicense.Click += new System.EventHandler(this.buttonUpdateLicense_Click);
            // 
            // buttonGetSnapshot
            // 
            this.buttonGetSnapshot.Location = new System.Drawing.Point(15, 114);
            this.buttonGetSnapshot.Name = "buttonGetSnapshot";
            this.buttonGetSnapshot.Size = new System.Drawing.Size(167, 23);
            this.buttonGetSnapshot.TabIndex = 4;
            this.buttonGetSnapshot.Text = "Check Snapshot";
            this.buttonGetSnapshot.UseVisualStyleBackColor = true;
            this.buttonGetSnapshot.Click += new System.EventHandler(this.buttonGetSnapshot_Click);
            // 
            // buttonRegisterSnapShot
            // 
            this.buttonRegisterSnapShot.Location = new System.Drawing.Point(15, 144);
            this.buttonRegisterSnapShot.Name = "buttonRegisterSnapShot";
            this.buttonRegisterSnapShot.Size = new System.Drawing.Size(167, 23);
            this.buttonRegisterSnapShot.TabIndex = 5;
            this.buttonRegisterSnapShot.Text = "Register Backup Location";
            this.buttonRegisterSnapShot.UseVisualStyleBackColor = true;
            this.buttonRegisterSnapShot.Click += new System.EventHandler(this.buttonRegisterSnapShot_Click);
            // 
            // buttonKibanaTemplate
            // 
            this.buttonKibanaTemplate.Location = new System.Drawing.Point(15, 213);
            this.buttonKibanaTemplate.Name = "buttonKibanaTemplate";
            this.buttonKibanaTemplate.Size = new System.Drawing.Size(167, 23);
            this.buttonKibanaTemplate.TabIndex = 6;
            this.buttonKibanaTemplate.Text = "Update Template Kibana";
            this.buttonKibanaTemplate.UseVisualStyleBackColor = true;
            // 
            // buttonMarvelTemplate
            // 
            this.buttonMarvelTemplate.Location = new System.Drawing.Point(15, 243);
            this.buttonMarvelTemplate.Name = "buttonMarvelTemplate";
            this.buttonMarvelTemplate.Size = new System.Drawing.Size(167, 23);
            this.buttonMarvelTemplate.TabIndex = 7;
            this.buttonMarvelTemplate.Text = "Update Template Marvel";
            this.buttonMarvelTemplate.UseVisualStyleBackColor = true;
            // 
            // buttonBack
            // 
            this.buttonBack.Location = new System.Drawing.Point(750, 250);
            this.buttonBack.Name = "buttonBack";
            this.buttonBack.Size = new System.Drawing.Size(177, 23);
            this.buttonBack.TabIndex = 8;
            this.buttonBack.Text = "Back";
            this.buttonBack.UseVisualStyleBackColor = true;
            this.buttonBack.Click += new System.EventHandler(this.buttonBack_Click_1);
            // 
            // Form3
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.Silver;
            this.ClientSize = new System.Drawing.Size(984, 461);
            this.Controls.Add(this.buttonBack);
            this.Controls.Add(this.buttonMarvelTemplate);
            this.Controls.Add(this.buttonKibanaTemplate);
            this.Controls.Add(this.buttonRegisterSnapShot);
            this.Controls.Add(this.buttonGetSnapshot);
            this.Controls.Add(this.buttonUpdateLicense);
            this.Controls.Add(this.buttonGetLicense);
            this.Controls.Add(this.buttonTestNode);
            this.Controls.Add(this.buttonExit);
            this.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.ForeColor = System.Drawing.Color.Navy;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Name = "Form3";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Form3";
            this.FormClosed += new System.Windows.Forms.FormClosedEventHandler(this.Form3_FormClosed);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Button buttonExit;
        private System.Windows.Forms.Button buttonTestNode;
        private System.Windows.Forms.Button buttonGetLicense;
        private System.Windows.Forms.Button buttonUpdateLicense;
        private System.Windows.Forms.Button buttonGetSnapshot;
        private System.Windows.Forms.Button buttonRegisterSnapShot;
        private System.Windows.Forms.Button buttonKibanaTemplate;
        private System.Windows.Forms.Button buttonMarvelTemplate;
        private System.Windows.Forms.Button buttonBack;
    }
}