$RHSatServer = "<SERVER ADDRESS>"
$headers = @{ Authorization = "Basic " + "<BASE64 KEYPAIR>"}

#Ignore Cert errors
add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy

$LastUpdated = get-date;
$RHServers = @();
$page = 1
$MorePages = $true;		
$limit = 5
$inc = 0;
while($MorePages){
    $result = Invoke-RestMethod -Method GET -Headers $headers -Uri $RHSatServer"hosts?per_page=40&sort=name""&page="$page
    $page++;
    if($result.results.count -eq 0){
        #No more pages
        $MorePages = $false;
    }
    else{
        foreach($server in $result.results){
            $UTCDate = [DateTime] $server.updated_at.Replace(" UTC","")
			$old = $false;

			#More than <$limit> days is old
			if($UTCDate -lt (Get-Date).AddDays(-$limit)){
				$old = $true;
			}
            $obj = [PSCustomObject]@{			
                'Id'            = $server.id
                'Name'          = $server.name.Split('.')[0]
                'IP'            = $server.ip
                'Environment'   = $server.environment_name
                'Domain'        = $server.domain_name
                'OperatingSystem' = $server.operatingsystem_name
                'UpdatedAt'     = $UTCDate.ToLocalTime()
                'Model'         = $server.model_name
                'LastUpdated'  = $LastUpdated
				'Old' = $old
            }

            #filter out host boxes with no OS value
            if($obj.OperatingSystem -ne $null){
                #filter out duplicate names, old hosts
                if($RHServers.name -notcontains $obj.name -and $obj.name -notlike '*template' -and $obj.old -eq $true){
				    $inc++
                    $RHServers += "========================== OLD RECORD #" + $inc + "=========================="
					$RHServers += $server
                }
            }
        }
    }
}
