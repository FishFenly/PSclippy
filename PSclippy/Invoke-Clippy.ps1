while($true){
#region xaml
    Add-Type -AssemblyName PresentationFramework, System.Drawing, System.Windows.Forms
    $Icon = [System.Drawing.Icon]::ExtractAssociatedIcon("$PSHOME\powershell.exe")
# Create XAML form in Visual Studio, ensuring the ListView looks chromeless
[xml] $XAML =  @"
    <Window
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="MainWindow" Height="657" Width="525" Background="Transparent" AllowsTransparency="True" WindowStyle="None" Topmost="True">
        <Window.Resources>
            <Style x:Key="ClippyButton" TargetType="Button">
                <Setter Property="Template">
                    <Setter.Value>
                        <ControlTemplate TargetType="Button">
                            <Border CornerRadius="5" Background="#FFFFFDCF" BorderThickness="1" Padding="2" BorderBrush="Black">
                                <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                            </Border>
                        </ControlTemplate>
                    </Setter.Value>

                </Setter>

            </Style>
        </Window.Resources>
        <Grid Name="grid"  Height="200" Width="400">
            <ListView Name="listview" SelectionMode="Single" Margin="0,50,0,0" Foreground="White"
		    Background="Transparent" BorderBrush="Transparent" IsHitTestVisible="False">
                <ListView.ItemContainerStyle>
                    <Style>
                        <Setter Property="Control.HorizontalContentAlignment" Value="Stretch"/>
                        <Setter Property="Control.VerticalContentAlignment" Value="Stretch"/>
                    </Style>
                </ListView.ItemContainerStyle>
                <Image x:Name="image" Height="140" Width="156" Source="$pwd\Clippy.png"/>
            </ListView>
            <Grid x:Name="gr3id" Margin="150,-190,29,190">
                <Grid.RowDefinitions>
                    <RowDefinition Height="*"/>
                    <RowDefinition Height="40"/>
                </Grid.RowDefinitions>
                <Rectangle Fill="#FFFFFDCF" Stroke="#FF000000" RadiusX="10" RadiusY="10"/>
                <Path Fill="#FFFFFDCF" Stretch="Fill" Stroke="#FF000000" HorizontalAlignment="Left" Margin="30,-1.6,0,0" Width="25" Grid.Row="1" 
            Data="M22.166642,154.45381 L29.999666,187.66699 40.791059,154.54395"/>
                <TextBlock HorizontalAlignment="Center" Name ="ClippyText" VerticalAlignment="Center" FontSize="16" Text="" TextWrapping="Wrap" FontFamily="Arial" Height="88" Margin="2,20,3,52"/>
            </Grid>
        </Grid>
    </Window>
"@
#endregion
    $WindowCode = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
    $AsyncWindow = Add-Type -MemberDefinition $WindowCode -Name Win32ShowWindowAsync -namespace Win32Functions -PassThru
    $null = $AsyncWindow::ShowWindowAsync((Get-Process -PID $PID).MainWindowHandle, 0)
    $Text = "Stop Coughing...","Noones heard about that anime..."
    function randomPhrase{
    	$x = $Text.Count
        $i = Get-Random -Maximum $x
        $ClippyText.Text = $Text[$i]
    }
    $Window = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $XAML))
    $XAML.SelectNodes("//*[@Name]") | ForEach-Object { Set-Variable -Name ($_.Name) -Value $Window.FindName($_.Name) -Scope Script }
    randomPhrase
    $Window.Left = $([System.Windows.SystemParameters]::WorkArea.Width-$Window.Width)
    $Window.Top = $([System.Windows.SystemParameters]::WorkArea.Height-$Window.Height)
    $Window.Show()
    $Window.Activate()
    Start-Sleep -Seconds 5
    $window.Close()
    Start-Sleep -Seconds 5
    [Void]$Window.ShowDialog()
}
