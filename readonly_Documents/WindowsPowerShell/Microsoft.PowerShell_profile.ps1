# $PROFILE\Microsoft.PowerShell_profile.ps1
# 文字コードをutf8にする
chcp 65001

# 管理者権限でpowershellを起動
function CustomSudo {
    Start-Process powershell.exe -Verb runas
}

# firefox のbookmarkを上書きコピーでバックアップ
function firefoxbookmarkbackup() {
    # firefox のbookmarkを上書きコピーでバックアップ(確認メッセージ付き)
    function FirefoxBookmarkBackup() {
        Copy-Item -Path "${Home}\APPDATA\Roaming\Mozilla\Firefox\Profiles\yz4s9hkf.default-release\bookmarks.html" -Destination "${Home}\Documents\myroot\firefox_bookmarklog" -Force
    }
    DoCommand-WithConfirm 'FirefoxBookmarkBackup'
}


#コマンド実行前確認メッセージ
# [コマンドを実行する前に確認メッセージを出力する #PowerShell - Qiita](https://qiita.com/Fuhduki/items/04eca7e2f38a1d4b8f81)
function  DoCommand-WithConfirm([string]$command, [string]$addMessage = "", [bool]$isDefaultYes = $false) {
    #選択肢の作成
    $CollectionType = [System.Management.Automation.Host.ChoiceDescription]
    $ChoiceType = "System.Collections.ObjectModel.Collection"

    #選択肢コレクションの作成
    $descriptions = New-Object "$ChoiceType``1[$CollectionType]"
    $questions = (("&Yes", "実行します"), ("&No", "実行しない"))
    $questions | % { $descriptions.Add((New-Object $CollectionType $_)) } 

    #確認メッセージ作成
    $message = "「" + $command + "」" + "を実行しますか？"
    if ( -not [string]::IsNullOrEmpty($addMessage)) {
        $message += [System.Environment]::NewLine + $addMessage
    }
    
    #規定値の設定
    $defoltType = 1;
    if ($isDefaultYes -eq $true) {
        $defoltType = 0;
    }

    #確認メッセージの表示とコマンドの実行
    $answer = $host.ui.PromptForChoice("<実行確認>", $message , $descriptions, $defoltType)
    if ($answer -eq 0) {
        Invoke-Expression $command
    }
}

# .psファイルにフォーマッターを適用する
function Format-PSScript {
    param (
        [string]$Path
    )
    $formattedCode = Invoke-Formatter -ScriptDefinition (Get-Content $Path -Raw)
    # BOM付UTF-8形式でファイルに出力
    # $formattedCode | Set-Content $Path
    $formattedCode | Out-File -FilePath $Path -Encoding UTF8
    Write-Output "Formatted: $Path"
}

# [Installation | Task](https://taskfile.dev/docs/installation#setup-completions)
Invoke-Expression  (&task --completion powershell | Out-String)
