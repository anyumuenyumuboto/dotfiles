# UTF-8コードページに変更
chcp 65001

# [Installation | Task](https://taskfile.dev/docs/installation#setup-completions)
Invoke-Expression  (&task --completion powershell | Out-String)

# [Starship](https://starship.rs/)
Invoke-Expression (&starship init powershell)

# neovimのshadaファイルを削除する
function My-Remove-NvimShada {
	Remove-Item -Path "~\AppData\Local\nvim-data\shada\*"
	Write-Host 'Remove-Item -Path "~\AppData\Local\nvim-data\shada\*\"'
}
# .envファイルを読み込む
function My-Load-DotEnv {
    param(
        [string]$Path = "."
    )

    $envFile = Join-Path $Path ".env"

    if (-Not (Test-Path $envFile)) {
        Write-Host ".env ファイルが '$envFile' にありません。" -ForegroundColor Red
        return
    }

    Get-Content $envFile | ForEach-Object {
        if ($_ -match '^\s*#') { return }
        if ($_ -match '^\s*([a-zA-Z_]\w*)=(.*)?') {
            $name = $matches[1]
            $value = $matches[2] -replace '^"|"$', ''
            Set-Item Env:$name $value
        }
    }

    Write-Host ".env ファイルを読み込みました: $envFile" -ForegroundColor Green
}
# ゴミ箱にファイルを移動する
function My-Move-ToRecycleBin {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
        [string[]]$Path,

        [switch]$Force
    )

    begin {
        Add-Type -AssemblyName Microsoft.VisualBasic
        $uiOption = [Microsoft.VisualBasic.FileIO.UIOption]::OnlyErrorDialogs
        $recycleOption = [Microsoft.VisualBasic.FileIO.RecycleOption]::SendToRecycleBin
    }

    process {
        foreach ($item in $Path) {
            if ($PSCmdlet.ShouldProcess($item, "Move to Recycle Bin")) {
                try {
                    [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile(
                        $item,
                        $uiOption,
                        $recycleOption
                    )
                } catch {
                    Write-Error "Failed to move '$item' to Recycle Bin: $_"
                }
            }
        }
    }
}

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

# .ps1ファイルにフォーマッターを適用する
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
