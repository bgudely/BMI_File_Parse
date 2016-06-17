$workingDir      = 'H:\Scripts\'
$aShareInFile    = $workingDir + '20160105_SPACACP_CLS.SDC.xls'
$aShareOutFile   = $workingDir + '20160105_SPACACP_CLS_new.SDC.xls'
$emergingInFile  = $workingDir + 'Emerging-061416.xls'
$emergingOutFile = $workingDir + 'Emerging-Deleted.xls'

# Iterate through new file to pick up stock keys

$file = New-Object System.IO.StreamReader($aShareInFile)

$lineSkip = 0
$i = 0

$stockKeys = @()

while (($line = $file.Readline()) -ne $null)
{
    $column = $line.Split("`t")

    if (($i -ge $lineSkip) -and ($column[0] -ne 'LINE COUNT:'))
    {
        $stockKeys += $column[12]

        if ($i -ge 1)
        {
            $column[17] = 'A1'
            $column[18] = 'A1'
        }
        
        $outLine = $null;

        for ($i = 1; $i -le 37; $i++)
        {
            $outLine += $column[$i] + "`t"
        }

        $outLine += $column[38]

        $outLine | Out-File $aShareOutFile -append -encoding ASCII
    }   

    $i++
}

$file.Close()


# Remove lines from emerging file where stock key exists in new file

$file = New-Object System.IO.StreamReader($emergingInFile)

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
            $outLine | Out-File $emergingOutFile -append -encoding ASCII
        }
    }

    $i++
}

$file.Close()