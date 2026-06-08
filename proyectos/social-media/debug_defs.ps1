$definitions = @(
    @{ Name='lunes.png'; Width=1080; Height=1920; Text='El silencio no siempre es ausencia.'; Tag='Historia de un amor inconcluso'; }
)
$def = $definitions[0]
Write-Host ($def['Width'].GetType().FullName)
Write-Host ($def['Width'] -is [Array])
Write-Host $def['Width'].Count
Write-Host $def['Width'][0]
