namespace DataTron
{
    partial class Form2
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
            this.btnForm2Back = new System.Windows.Forms.Button();
            this.btnForm2Next = new System.Windows.Forms.Button();
            this.btnCopyPackage = new System.Windows.Forms.Button();
            this.btnSetJavaHeap = new System.Windows.Forms.Button();
            this.btnInstallJava = new System.Windows.Forms.Button();
            this.btnSetEnvVariables = new System.Windows.Forms.Button();
            this.btnInstalWebCert = new System.Windows.Forms.Button();
            this.btnUpdateYML = new System.Windows.Forms.Button();
            this.btnInstallService = new System.Windows.Forms.Button();
            this.btnCreateEsUsers = new System.Windows.Forms.Button();
            this.checkBox1 = new System.Windows.Forms.CheckBox();
            this.SuspendLayout();
            // 
            // btnForm2Back
            // 
            this.btnForm2Back.Location = new System.Drawing.Point(369, 281);
            this.btnForm2Back.Name = "btnForm2Back";
            this.btnForm2Back.Size = new System.Drawing.Size(182, 23);
            this.btnForm2Back.TabIndex = 0;
            this.btnForm2Back.Text = "Back";
            this.btnForm2Back.UseVisualStyleBackColor = true;
            this.btnForm2Back.Click += new System.EventHandler(this.btnForm2Back_Click);
            // 
            // btnForm2Next
            // 
            this.btnForm2Next.Location = new System.Drawing.Point(369, 324);
            this.btnForm2Next.Name = "btnForm2Next";
            this.btnForm2Next.Size = new System.Drawing.Size(182, 23);
            this.btnForm2Next.TabIndex = 1;
            this.btnForm2Next.Text = "Next";
            this.btnForm2Next.UseVisualStyleBackColor = true;
            // 
            // btnCopyPackage
            // 
            this.btnCopyPackage.Location = new System.Drawing.Point(24, 23);
            this.btnCopyPackage.Name = "btnCopyPackage";
            this.btnCopyPackage.Size = new System.Drawing.Size(222, 23);
            this.btnCopyPackage.TabIndex = 2;
            this.btnCopyPackage.Text = "Copy Data Grid Package to Disk";
            this.btnCopyPackage.UseVisualStyleBackColor = true;
            // 
            // btnSetJavaHeap
            // 
            this.btnSetJavaHeap.Location = new System.Drawing.Point(24, 62);
            this.btnSetJavaHeap.Name = "btnSetJavaHeap";
            this.btnSetJavaHeap.Size = new System.Drawing.Size(222, 23);
            this.btnSetJavaHeap.TabIndex = 2;
            this.btnSetJavaHeap.Text = "Set Java Heap";
            this.btnSetJavaHeap.UseVisualStyleBackColor = true;
            // 
            // btnInstallJava
            // 
            this.btnInstallJava.Location = new System.Drawing.Point(24, 103);
            this.btnInstallJava.Name = "btnInstallJava";
            this.btnInstallJava.Size = new System.Drawing.Size(222, 23);
            this.btnInstallJava.TabIndex = 2;
            this.btnInstallJava.Text = "Install Java";
            this.btnInstallJava.UseVisualStyleBackColor = true;
            // 
            // btnSetEnvVariables
            // 
            this.btnSetEnvVariables.Location = new System.Drawing.Point(24, 145);
            this.btnSetEnvVariables.Name = "btnSetEnvVariables";
            this.btnSetEnvVariables.Size = new System.Drawing.Size(222, 23);
            this.btnSetEnvVariables.TabIndex = 2;
            this.btnSetEnvVariables.Text = "Create Java Home";
            this.btnSetEnvVariables.UseVisualStyleBackColor = true;
            // 
            // btnInstalWebCert
            // 
            this.btnInstalWebCert.Location = new System.Drawing.Point(24, 185);
            this.btnInstalWebCert.Name = "btnInstalWebCert";
            this.btnInstalWebCert.Size = new System.Drawing.Size(222, 23);
            this.btnInstalWebCert.TabIndex = 2;
            this.btnInstalWebCert.Text = "Install Web Server Certificate";
            this.btnInstalWebCert.UseVisualStyleBackColor = true;
            // 
            // btnUpdateYML
            // 
            this.btnUpdateYML.Location = new System.Drawing.Point(24, 228);
            this.btnUpdateYML.Name = "btnUpdateYML";
            this.btnUpdateYML.Size = new System.Drawing.Size(222, 23);
            this.btnUpdateYML.TabIndex = 2;
            this.btnUpdateYML.Text = "Update YML File";
            this.btnUpdateYML.UseVisualStyleBackColor = true;
            // 
            // btnInstallService
            // 
            this.btnInstallService.Location = new System.Drawing.Point(24, 267);
            this.btnInstallService.Name = "btnInstallService";
            this.btnInstallService.Size = new System.Drawing.Size(222, 23);
            this.btnInstallService.TabIndex = 2;
            this.btnInstallService.Text = "Install Elastic Service";
            this.btnInstallService.UseVisualStyleBackColor = true;
            // 
            // btnCreateEsUsers
            // 
            this.btnCreateEsUsers.Location = new System.Drawing.Point(24, 308);
            this.btnCreateEsUsers.Name = "btnCreateEsUsers";
            this.btnCreateEsUsers.Size = new System.Drawing.Size(222, 23);
            this.btnCreateEsUsers.TabIndex = 2;
            this.btnCreateEsUsers.Text = "Create Elastic REST User";
            this.btnCreateEsUsers.UseVisualStyleBackColor = true;
            // 
            // checkBox1
            // 
            this.checkBox1.AutoSize = true;
            this.checkBox1.Location = new System.Drawing.Point(271, 27);
            this.checkBox1.Name = "checkBox1";
            this.checkBox1.Size = new System.Drawing.Size(80, 17);
            this.checkBox1.TabIndex = 3;
            this.checkBox1.Text = "checkBox1";
            this.checkBox1.UseVisualStyleBackColor = true;
            // 
            // Form2
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(603, 380);
            this.Controls.Add(this.checkBox1);
            this.Controls.Add(this.btnCreateEsUsers);
            this.Controls.Add(this.btnInstallService);
            this.Controls.Add(this.btnUpdateYML);
            this.Controls.Add(this.btnInstalWebCert);
            this.Controls.Add(this.btnSetEnvVariables);
            this.Controls.Add(this.btnInstallJava);
            this.Controls.Add(this.btnSetJavaHeap);
            this.Controls.Add(this.btnCopyPackage);
            this.Controls.Add(this.btnForm2Next);
            this.Controls.Add(this.btnForm2Back);
            this.Name = "Form2";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Install Elastic";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button btnForm2Back;
        private System.Windows.Forms.Button btnForm2Next;
        private System.Windows.Forms.Button btnCopyPackage;
        private System.Windows.Forms.Button btnSetJavaHeap;
        private System.Windows.Forms.Button btnInstallJava;
        private System.Windows.Forms.Button btnSetEnvVariables;
        private System.Windows.Forms.Button btnInstalWebCert;
        private System.Windows.Forms.Button btnUpdateYML;
        private System.Windows.Forms.Button btnInstallService;
        private System.Windows.Forms.Button btnCreateEsUsers;
        private System.Windows.Forms.CheckBox checkBox1;
    }
}