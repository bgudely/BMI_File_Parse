$workingDir   = 'H:\Scripts\'
$newFile      = $workingDir + '20160105_SPACACP_CLS.SDC.xls'
$emergingFile = $workingDir + 'Emerging-061416.xls'
$outFile      = $workingDir + 'Emerging-Deleted.xls'

# Iterate through new file to pick up stock keys

$file = New-Object System.IO.StreamReader($newFile)

$lineSkip = 1
$i = 0

$stockKeys = @()

while (($line = $file.Readline()) -ne $null)
{
    $column = $line.Split("`t")

    if (($i -ge $lineSkip) -and ($column[0] -ne 'LINE COUNT:'))
    {
        $stockKeys += $column[12]
    }

    $i++
}

$file.Close()

# Remove lines from emerging file where stock key exists in new file

$file = New-Object System.IO.StreamReader($emergingFile)

$lineSkip = 0
$i = 0

while(($line = $file.ReadLine()) -ne $null)
{
    $column = $line.Split("`t")

    if(($i -ge $lineSkip) -and ($column[0] -ne 'LINE COUNT:'))
    {
        $stockKey = $column[12]

        if ($stockKeys.Contains($stockKey) -ne $true)
        {
            $outLine = $line
            $outLine | Out-File $outFile -append -encoding ASCII
        }
    }

    $i++
}

$file.Close()