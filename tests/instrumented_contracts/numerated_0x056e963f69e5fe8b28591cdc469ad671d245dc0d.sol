1 pragma solidity ^0.5.7;
2 
3 contract Evento {
4     
5     mapping(address => uint256) private _partecipanti;
6     uint8 private _numeroPartecipanti;
7     address payable private _organizzatore;
8     bool private _registrazioneAperta;
9     
10     uint constant public prezzo = 0.00001 ether;
11     
12     constructor() public {
13         _organizzatore = msg.sender;
14         _registrazioneAperta = false;
15     }
16     
17     modifier onlyOwner() {
18         require(msg.sender == _organizzatore, "Non sei autorizzato");
19         _ ;
20     }
21     
22     modifier costoBiglietto() {
23         require(msg.value >= prezzo, "L'importo non è corretto");
24         _ ;
25     }
26     
27     function controlRegistration(bool status) public onlyOwner {
28         _registrazioneAperta = status;
29     } 
30     
31     function registrazione() public payable costoBiglietto {
32         require(_registrazioneAperta == true, "La registrazione non è aperta");
33         require(_partecipanti[msg.sender] == 0, "Sei già registrato");
34         _partecipanti[msg.sender] = now;
35         _numeroPartecipanti = _numeroPartecipanti + 1;
36         _organizzatore.transfer(msg.value);
37     }
38     
39     function numberOfAttendees() public view returns (uint8) {
40         return _numeroPartecipanti;
41     }
42 
43     function checkin() public view returns(bool){
44         return _partecipanti[msg.sender] > 0;
45     }
46     
47 }