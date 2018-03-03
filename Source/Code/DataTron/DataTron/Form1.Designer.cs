namespace DataTron
{
    partial class Form1
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Form1));
            this.lblClusterName = new System.Windows.Forms.Label();
            this.lblNodeName = new System.Windows.Forms.Label();
            this.lblMasterNode = new System.Windows.Forms.Label();
            this.lblDataNode = new System.Windows.Forms.Label();
            this.lblMinMaster = new System.Windows.Forms.Label();
            this.lbl = new System.Windows.Forms.Label();
            this.lblMonitoringNode = new System.Windows.Forms.Label();
            this.lblDataPath = new System.Windows.Forms.Label();
            this.lblBackupLocation = new System.Windows.Forms.Label();
            this.lblEsUserName = new System.Windows.Forms.Label();
            this.lblElasticPassword = new System.Windows.Forms.Label();
            this.lblRelUserName = new System.Windows.Forms.Label();
            this.lblRelPassword = new System.Windows.Forms.Label();
            this.textBoxClusterName = new System.Windows.Forms.TextBox();
            this.textBoxNodeName = new System.Windows.Forms.TextBox();
            this.textBoxMasterNode = new System.Windows.Forms.TextBox();
            this.textBoxDataNode = new System.Windows.Forms.TextBox();
            this.textBoxNumberMasters = new System.Windows.Forms.TextBox();
            this.textBoxMonitorNode = new System.Windows.Forms.TextBox();
            this.textBoxMonitoringNode = new System.Windows.Forms.TextBox();
            this.textBoxDataPath = new System.Windows.Forms.TextBox();
            this.textBoxBackupLoc = new System.Windows.Forms.TextBox();
            this.textBoxESUser = new System.Windows.Forms.TextBox();
            this.textBoxESPassword = new System.Windows.Forms.TextBox();
            this.textBoxRelUser = new System.Windows.Forms.TextBox();
            this.textBoxRelPass = new System.Windows.Forms.TextBox();
            this.btnLoadResponce = new System.Windows.Forms.Button();
            this.btnForm1Next = new System.Windows.Forms.Button();
            this.btnCreateResponseFile = new System.Windows.Forms.Button();
            this.btnUpdateResponse = new System.Windows.Forms.Button();
            this.lblUnicastHosts = new System.Windows.Forms.Label();
            this.textBoxUnicastHosts = new System.Windows.Forms.TextBox();
            this.checkBoxNoResponseFile = new System.Windows.Forms.CheckBox();
            this.lblAuthWebServer = new System.Windows.Forms.Label();
            this.textBoxAuthWebServer = new System.Windows.Forms.TextBox();
            this.SuspendLayout();
            // 
            // lblClusterName
            // 
            this.lblClusterName.AutoSize = true;
            this.lblClusterName.Location = new System.Drawing.Point(190, 8);
            this.lblClusterName.Name = "lblClusterName";
            this.lblClusterName.Size = new System.Drawing.Size(82, 13);
            this.lblClusterName.TabIndex = 0;
            this.lblClusterName.Text = "Cluster Name";
            // 
            // lblNodeName
            // 
            this.lblNodeName.AutoSize = true;
            this.lblNodeName.Location = new System.Drawing.Point(197, 34);
            this.lblNodeName.Name = "lblNodeName";
            this.lblNodeName.Size = new System.Drawing.Size(73, 13);
            this.lblNodeName.TabIndex = 0;
            this.lblNodeName.Text = "Node Name";
            // 
            // lblMasterNode
            // 
            this.lblMasterNode.AutoSize = true;
            this.lblMasterNode.Location = new System.Drawing.Point(164, 57);
            this.lblMasterNode.Name = "lblMasterNode";
            this.lblMasterNode.Size = new System.Drawing.Size(109, 13);
            this.lblMasterNode.TabIndex = 0;
            this.lblMasterNode.Text = "Master Node Role";
            // 
            // lblDataNode
            // 
            this.lblDataNode.AutoSize = true;
            this.lblDataNode.Location = new System.Drawing.Point(175, 83);
            this.lblDataNode.Name = "lblDataNode";
            this.lblDataNode.Size = new System.Drawing.Size(98, 13);
            this.lblDataNode.TabIndex = 0;
            this.lblDataNode.Text = "Data Node Role";
            // 
            // lblMinMaster
            // 
            this.lblMinMaster.AutoSize = true;
            this.lblMinMaster.Location = new System.Drawing.Point(126, 109);
            this.lblMinMaster.Name = "lblMinMaster";
            this.lblMinMaster.Size = new System.Drawing.Size(147, 13);
            this.lblMinMaster.TabIndex = 0;
            this.lblMinMaster.Text = "Number of Master Nodes";
            // 
            // lbl
            // 
            this.lbl.AutoSize = true;
            this.lbl.Location = new System.Drawing.Point(143, 138);
            this.lbl.Name = "lbl";
            this.lbl.Size = new System.Drawing.Size(130, 13);
            this.lbl.TabIndex = 0;
            this.lbl.Text = "Monitoring Node Role";
            // 
            // lblMonitoringNode
            // 
            this.lblMonitoringNode.AutoSize = true;
            this.lblMonitoringNode.Location = new System.Drawing.Point(136, 162);
            this.lblMonitoringNode.Name = "lblMonitoringNode";
            this.lblMonitoringNode.Size = new System.Drawing.Size(136, 13);
            this.lblMonitoringNode.TabIndex = 0;
            this.lblMonitoringNode.Text = "Monitoring Node Name";
            // 
            // lblDataPath
            // 
            this.lblDataPath.AutoSize = true;
            this.lblDataPath.Location = new System.Drawing.Point(206, 188);
            this.lblDataPath.Name = "lblDataPath";
            this.lblDataPath.Size = new System.Drawing.Size(64, 13);
            this.lblDataPath.TabIndex = 0;
            this.lblDataPath.Text = "Data Path";
            // 
            // lblBackupLocation
            // 
            this.lblBackupLocation.AutoSize = true;
            this.lblBackupLocation.Location = new System.Drawing.Point(169, 215);
            this.lblBackupLocation.Name = "lblBackupLocation";
            this.lblBackupLocation.Size = new System.Drawing.Size(103, 13);
            this.lblBackupLocation.TabIndex = 0;
            this.lblBackupLocation.Text = "Backup Location";
            // 
            // lblEsUserName
            // 
            this.lblEsUserName.AutoSize = true;
            this.lblEsUserName.Location = new System.Drawing.Point(129, 241);
            this.lblEsUserName.Name = "lblEsUserName";
            this.lblEsUserName.Size = new System.Drawing.Size(142, 13);
            this.lblEsUserName.TabIndex = 0;
            this.lblEsUserName.Text = "Elastic REST Username";
            // 
            // lblElasticPassword
            // 
            this.lblElasticPassword.AutoSize = true;
            this.lblElasticPassword.Location = new System.Drawing.Point(133, 267);
            this.lblElasticPassword.Name = "lblElasticPassword";
            this.lblElasticPassword.Size = new System.Drawing.Size(140, 13);
            this.lblElasticPassword.TabIndex = 0;
            this.lblElasticPassword.Text = "Elastic REST Password";
            // 
            // lblRelUserName
            // 
            this.lblRelUserName.AutoSize = true;
            this.lblRelUserName.Location = new System.Drawing.Point(53, 292);
            this.lblRelUserName.Name = "lblRelUserName";
            this.lblRelUserName.Size = new System.Drawing.Size(220, 13);
            this.lblRelUserName.TabIndex = 0;
            this.lblRelUserName.Text = "Relativity Service Account UserName";
            // 
            // lblRelPassword
            // 
            this.lblRelPassword.AutoSize = true;
            this.lblRelPassword.Location = new System.Drawing.Point(57, 318);
            this.lblRelPassword.Name = "lblRelPassword";
            this.lblRelPassword.Size = new System.Drawing.Size(216, 13);
            this.lblRelPassword.TabIndex = 0;
            this.lblRelPassword.Text = "Relativity Service Account Password";
            // 
            // textBoxClusterName
            // 
            this.textBoxClusterName.Location = new System.Drawing.Point(279, 8);
            this.textBoxClusterName.Name = "textBoxClusterName";
            this.textBoxClusterName.Size = new System.Drawing.Size(116, 20);
            this.textBoxClusterName.TabIndex = 1;
            this.textBoxClusterName.TextChanged += new System.EventHandler(this.textBoxClusterName_TextChanged);
            // 
            // textBoxNodeName
            // 
            this.textBoxNodeName.Location = new System.Drawing.Point(279, 34);
            this.textBoxNodeName.Name = "textBoxNodeName";
            this.textBoxNodeName.Size = new System.Drawing.Size(116, 20);
            this.textBoxNodeName.TabIndex = 2;
            this.textBoxNodeName.TextChanged += new System.EventHandler(this.textBoxNodeName_TextChanged);
            // 
            // textBoxMasterNode
            // 
            this.textBoxMasterNode.Location = new System.Drawing.Point(279, 57);
            this.textBoxMasterNode.Name = "textBoxMasterNode";
            this.textBoxMasterNode.Size = new System.Drawing.Size(116, 20);
            this.textBoxMasterNode.TabIndex = 3;
            this.textBoxMasterNode.TextChanged += new System.EventHandler(this.textBoxMasterNode_TextChanged);
            // 
            // textBoxDataNode
            // 
            this.textBoxDataNode.Location = new System.Drawing.Point(279, 83);
            this.textBoxDataNode.Name = "textBoxDataNode";
            this.textBoxDataNode.Size = new System.Drawing.Size(116, 20);
            this.textBoxDataNode.TabIndex = 4;
            this.textBoxDataNode.TextChanged += new System.EventHandler(this.textBoxDataNode_TextChanged);
            // 
            // textBoxNumberMasters
            // 
            this.textBoxNumberMasters.Location = new System.Drawing.Point(279, 109);
            this.textBoxNumberMasters.Name = "textBoxNumberMasters";
            this.textBoxNumberMasters.Size = new System.Drawing.Size(116, 20);
            this.textBoxNumberMasters.TabIndex = 5;
            this.textBoxNumberMasters.TextChanged += new System.EventHandler(this.textBoxNumberMasters_TextChanged);
            // 
            // textBoxMonitorNode
            // 
            this.textBoxMonitorNode.Location = new System.Drawing.Point(279, 138);
            this.textBoxMonitorNode.Name = "textBoxMonitorNode";
            this.textBoxMonitorNode.Size = new System.Drawing.Size(116, 20);
            this.textBoxMonitorNode.TabIndex = 6;
            this.textBoxMonitorNode.TextChanged += new System.EventHandler(this.textBoxMonitorNode_TextChanged);
            // 
            // textBoxMonitoringNode
            // 
            this.textBoxMonitoringNode.Location = new System.Drawing.Point(279, 162);
            this.textBoxMonitoringNode.Name = "textBoxMonitoringNode";
            this.textBoxMonitoringNode.Size = new System.Drawing.Size(116, 20);
            this.textBoxMonitoringNode.TabIndex = 7;
            this.textBoxMonitoringNode.TextChanged += new System.EventHandler(this.textBoxMonitoringNode_TextChanged);
            // 
            // textBoxDataPath
            // 
            this.textBoxDataPath.Location = new System.Drawing.Point(279, 188);
            this.textBoxDataPath.Name = "textBoxDataPath";
            this.textBoxDataPath.Size = new System.Drawing.Size(116, 20);
            this.textBoxDataPath.TabIndex = 8;
            this.textBoxDataPath.TextChanged += new System.EventHandler(this.textBoxDataPath_TextChanged);
            // 
            // textBoxBackupLoc
            // 
            this.textBoxBackupLoc.Location = new System.Drawing.Point(279, 215);
            this.textBoxBackupLoc.Name = "textBoxBackupLoc";
            this.textBoxBackupLoc.Size = new System.Drawing.Size(116, 20);
            this.textBoxBackupLoc.TabIndex = 9;
            this.textBoxBackupLoc.TextChanged += new System.EventHandler(this.textBoxBackupLoc_TextChanged);
            // 
            // textBoxESUser
            // 
            this.textBoxESUser.Location = new System.Drawing.Point(279, 241);
            this.textBoxESUser.Name = "textBoxESUser";
            this.textBoxESUser.Size = new System.Drawing.Size(116, 20);
            this.textBoxESUser.TabIndex = 10;
            this.textBoxESUser.TextChanged += new System.EventHandler(this.textBoxESUser_TextChanged);
            // 
            // textBoxESPassword
            // 
            this.textBoxESPassword.Location = new System.Drawing.Point(279, 267);
            this.textBoxESPassword.Name = "textBoxESPassword";
            this.textBoxESPassword.Size = new System.Drawing.Size(116, 20);
            this.textBoxESPassword.TabIndex = 11;
            this.textBoxESPassword.TextChanged += new System.EventHandler(this.textBoxESPassword_TextChanged);
            // 
            // textBoxRelUser
            // 
            this.textBoxRelUser.Location = new System.Drawing.Point(279, 292);
            this.textBoxRelUser.Name = "textBoxRelUser";
            this.textBoxRelUser.Size = new System.Drawing.Size(116, 20);
            this.textBoxRelUser.TabIndex = 12;
            this.textBoxRelUser.TextChanged += new System.EventHandler(this.textBoxRelUser_TextChanged);
            // 
            // textBoxRelPass
            // 
            this.textBoxRelPass.Location = new System.Drawing.Point(279, 318);
            this.textBoxRelPass.Name = "textBoxRelPass";
            this.textBoxRelPass.Size = new System.Drawing.Size(116, 20);
            this.textBoxRelPass.TabIndex = 13;
            this.textBoxRelPass.TextChanged += new System.EventHandler(this.textBoxRelPass_TextChanged);
            // 
            // btnLoadResponce
            // 
            this.btnLoadResponce.Location = new System.Drawing.Point(741, 41);
            this.btnLoadResponce.Name = "btnLoadResponce";
            this.btnLoadResponce.Size = new System.Drawing.Size(210, 23);
            this.btnLoadResponce.TabIndex = 0;
            this.btnLoadResponce.TabStop = false;
            this.btnLoadResponce.Text = "Load Responce File";
            this.btnLoadResponce.UseVisualStyleBackColor = true;
            this.btnLoadResponce.Click += new System.EventHandler(this.btnLoadResponce_Click);
            // 
            // btnForm1Next
            // 
            this.btnForm1Next.Location = new System.Drawing.Point(741, 267);
            this.btnForm1Next.Name = "btnForm1Next";
            this.btnForm1Next.Size = new System.Drawing.Size(210, 23);
            this.btnForm1Next.TabIndex = 0;
            this.btnForm1Next.Text = "Next";
            this.btnForm1Next.UseVisualStyleBackColor = true;
            this.btnForm1Next.Click += new System.EventHandler(this.btnForm1Next_Click);
            // 
            // btnCreateResponseFile
            // 
            this.btnCreateResponseFile.Location = new System.Drawing.Point(741, 12);
            this.btnCreateResponseFile.Name = "btnCreateResponseFile";
            this.btnCreateResponseFile.Size = new System.Drawing.Size(210, 23);
            this.btnCreateResponseFile.TabIndex = 0;
            this.btnCreateResponseFile.TabStop = false;
            this.btnCreateResponseFile.Text = "Create Blank Response File";
            this.btnCreateResponseFile.UseVisualStyleBackColor = true;
            this.btnCreateResponseFile.Click += new System.EventHandler(this.btnCreateResponseFile_Click);
            // 
            // btnUpdateResponse
            // 
            this.btnUpdateResponse.Location = new System.Drawing.Point(741, 70);
            this.btnUpdateResponse.Name = "btnUpdateResponse";
            this.btnUpdateResponse.Size = new System.Drawing.Size(210, 23);
            this.btnUpdateResponse.TabIndex = 0;
            this.btnUpdateResponse.TabStop = false;
            this.btnUpdateResponse.Text = "Update Response File";
            this.btnUpdateResponse.UseVisualStyleBackColor = true;
            this.btnUpdateResponse.Click += new System.EventHandler(this.btnUpdateResponse_Click);
            // 
            // lblUnicastHosts
            // 
            this.lblUnicastHosts.AutoSize = true;
            this.lblUnicastHosts.Location = new System.Drawing.Point(181, 345);
            this.lblUnicastHosts.Name = "lblUnicastHosts";
            this.lblUnicastHosts.Size = new System.Drawing.Size(92, 13);
            this.lblUnicastHosts.TabIndex = 6;
            this.lblUnicastHosts.Text = "Unicasts Hosts";
            // 
            // textBoxUnicastHosts
            // 
            this.textBoxUnicastHosts.Location = new System.Drawing.Point(279, 345);
            this.textBoxUnicastHosts.Name = "textBoxUnicastHosts";
            this.textBoxUnicastHosts.Size = new System.Drawing.Size(642, 20);
            this.textBoxUnicastHosts.TabIndex = 14;
            this.textBoxUnicastHosts.TextChanged += new System.EventHandler(this.textBoxUnicastHosts_TextChanged);
            // 
            // checkBoxNoResponseFile
            // 
            this.checkBoxNoResponseFile.AutoSize = true;
            this.checkBoxNoResponseFile.Location = new System.Drawing.Point(741, 104);
            this.checkBoxNoResponseFile.Name = "checkBoxNoResponseFile";
            this.checkBoxNoResponseFile.Size = new System.Drawing.Size(176, 17);
            this.checkBoxNoResponseFile.TabIndex = 0;
            this.checkBoxNoResponseFile.TabStop = false;
            this.checkBoxNoResponseFile.Text = "Do Not Use Response File";
            this.checkBoxNoResponseFile.UseVisualStyleBackColor = true;
            this.checkBoxNoResponseFile.CheckedChanged += new System.EventHandler(this.checkBoxNoResponseFile_CheckedChanged);
            // 
            // lblAuthWebServer
            // 
            this.lblAuthWebServer.AutoSize = true;
            this.lblAuthWebServer.Location = new System.Drawing.Point(113, 372);
            this.lblAuthWebServer.Name = "lblAuthWebServer";
            this.lblAuthWebServer.Size = new System.Drawing.Size(160, 13);
            this.lblAuthWebServer.TabIndex = 9;
            this.lblAuthWebServer.Text = "Authentication Web Server";
            // 
            // textBoxAuthWebServer
            // 
            this.textBoxAuthWebServer.Location = new System.Drawing.Point(279, 372);
            this.textBoxAuthWebServer.Name = "textBoxAuthWebServer";
            this.textBoxAuthWebServer.Size = new System.Drawing.Size(116, 20);
            this.textBoxAuthWebServer.TabIndex = 15;
            this.textBoxAuthWebServer.TextChanged += new System.EventHandler(this.textBoxAuthWebServer_TextChanged);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.Silver;
            this.ClientSize = new System.Drawing.Size(976, 406);
            this.Controls.Add(this.textBoxAuthWebServer);
            this.Controls.Add(this.lblAuthWebServer);
            this.Controls.Add(this.checkBoxNoResponseFile);
            this.Controls.Add(this.textBoxUnicastHosts);
            this.Controls.Add(this.lblUnicastHosts);
            this.Controls.Add(this.btnUpdateResponse);
            this.Controls.Add(this.btnCreateResponseFile);
            this.Controls.Add(this.btnForm1Next);
            this.Controls.Add(this.btnLoadResponce);
            this.Controls.Add(this.textBoxRelPass);
            this.Controls.Add(this.textBoxRelUser);
            this.Controls.Add(this.textBoxESPassword);
            this.Controls.Add(this.textBoxESUser);
            this.Controls.Add(this.textBoxBackupLoc);
            this.Controls.Add(this.textBoxDataPath);
            this.Controls.Add(this.textBoxMonitoringNode);
            this.Controls.Add(this.textBoxMonitorNode);
            this.Controls.Add(this.textBoxNumberMasters);
            this.Controls.Add(this.textBoxDataNode);
            this.Controls.Add(this.textBoxMasterNode);
            this.Controls.Add(this.textBoxNodeName);
            this.Controls.Add(this.textBoxClusterName);
            this.Controls.Add(this.lblRelPassword);
            this.Controls.Add(this.lblRelUserName);
            this.Controls.Add(this.lblElasticPassword);
            this.Controls.Add(this.lblEsUserName);
            this.Controls.Add(this.lblBackupLocation);
            this.Controls.Add(this.lblDataPath);
            this.Controls.Add(this.lblMonitoringNode);
            this.Controls.Add(this.lbl);
            this.Controls.Add(this.lblMinMaster);
            this.Controls.Add(this.lblDataNode);
            this.Controls.Add(this.lblMasterNode);
            this.Controls.Add(this.lblNodeName);
            this.Controls.Add(this.lblClusterName);
            this.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.ForeColor = System.Drawing.Color.Navy;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Name = "Form1";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "DataTron Responce File Utility";
            this.Load += new System.EventHandler(this.Form1_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label lblClusterName;
        private System.Windows.Forms.Label lblNodeName;
        private System.Windows.Forms.Label lblMasterNode;
        private System.Windows.Forms.Label lblDataNode;
        private System.Windows.Forms.Label lblMinMaster;
        private System.Windows.Forms.Label lbl;
        private System.Windows.Forms.Label lblMonitoringNode;
        private System.Windows.Forms.Label lblDataPath;
        private System.Windows.Forms.Label lblBackupLocation;
        private System.Windows.Forms.Label lblEsUserName;
        private System.Windows.Forms.Label lblElasticPassword;
        private System.Windows.Forms.Label lblRelUserName;
        private System.Windows.Forms.Label lblRelPassword;
        public System.Windows.Forms.TextBox textBoxClusterName;
        private System.Windows.Forms.TextBox textBoxNodeName;
        private System.Windows.Forms.TextBox textBoxMasterNode;
        private System.Windows.Forms.TextBox textBoxDataNode;
        private System.Windows.Forms.TextBox textBoxNumberMasters;
        private System.Windows.Forms.TextBox textBoxMonitorNode;
        private System.Windows.Forms.TextBox textBoxMonitoringNode;
        private System.Windows.Forms.TextBox textBoxDataPath;
        private System.Windows.Forms.TextBox textBoxBackupLoc;
        private System.Windows.Forms.TextBox textBoxESUser;
        private System.Windows.Forms.TextBox textBoxESPassword;
        private System.Windows.Forms.TextBox textBoxRelUser;
        private System.Windows.Forms.TextBox textBoxRelPass;
        private System.Windows.Forms.Button btnLoadResponce;
        private System.Windows.Forms.Button btnForm1Next;
        private System.Windows.Forms.Button btnCreateResponseFile;
        private System.Windows.Forms.Button btnUpdateResponse;
        private System.Windows.Forms.Label lblUnicastHosts;
        private System.Windows.Forms.TextBox textBoxUnicastHosts;
        private System.Windows.Forms.CheckBox checkBoxNoResponseFile;
        private System.Windows.Forms.Label lblAuthWebServer;
        private System.Windows.Forms.TextBox textBoxAuthWebServer;
    }
}

