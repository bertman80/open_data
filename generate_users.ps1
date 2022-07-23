# variable
$emaildomain = "@trebnie.nl"
$totalusers = 10

# get data
$imput_lastname = "https://raw.githubusercontent.com/bertman80/open_data/main/names_lastname.txt"
$input_firstname_boy = "https://raw.githubusercontent.com/bertman80/open_data/main/names_firstname_boy.txt"
$input_firstname_girl = "https://raw.githubusercontent.com/bertman80/open_data/main/names_firstname_girl.txt"

$surnames = (invoke-webrequest -uri $imput_lastname -usebasicparsing).content -split "`r`n"
$girls = (invoke-webrequest -uri $input_firstname_girl -usebasicparsing).content -split "`r`n"
$boys = (invoke-webrequest -uri $input_firstname_boy -usebasicparsing).content -split "`r`n"

# generate user
$users = @()
for ($i = 0; $i -lt $totalusers) {
    $birthday = get-date(get-random -max (get-date).addyears(-15).ticks -min (get-date).addyears(-80).ticks)
    $gender = "m","f" | get-random
    if ($gender -eq "f") {
        $firstname = get-random $girls
    } else {
        $firstname = get-random $boys
    }
    $lastname = get-random  $surnames

    $row = new-object psobject -property @{
        firstname = $firstname
        lastname = $lastname
        birthday = $birthday
        gender = $gender
        email = "$($firstname.tolower()).$($lastname.tolower())$($emaildomain)"
    }
    $users += $row
    write-progress -activity "generating user" -status "$firstname $lastname" -currentoperation $computer -percentcomplete (($i / $totalusers) * 100)
    $i++
}
write-progress -activity "generating user" -status "ready" -completed
$users | out-gridview