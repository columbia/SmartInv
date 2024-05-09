1 pragma solidity ^0.4.24;
2 
3 contract FamilienSpardose {
4     
5     // Created by N. Fuchs
6     
7     // Name der Familienspardose
8     string public spardosenName;
9     
10     //weist einer Addresse ein Guthaben zu
11     mapping (address => uint) public guthaben;
12     
13     // zeigt im smart contract an, wieviel Ether alle Sparer insgesamt halten
14     // ".balance" ist eine Objektattribut des Datentyps address, das für jede wallet und jeden smart contract das entsprechende 
15     //  Ether-Guthaben darstellt.
16     uint public gesamtGuthaben = address(this).balance;
17     
18     // Konstruktorfunktion: Wird einmalig beim deployment des smart contracts ausgeführt
19     // Wenn Transaktionen, die Funktionen auszuführen beabsichtigen, Ether mitgesendet wird (TXvalue > 0), so muss die
20     //  ausgeführte Transaktion mit "payable" gekennzeichnet sein. Sicherheitsfeature im Interesse der Nutzer
21     constructor(string _name, address _sparer) payable {
22         
23         
24         // Weist der Variablen spardosenName den String _name zu, welcher vom Ersteller
25         // des smart contracts als Parameter in der Transaktion übergeben wird:
26         spardosenName = _name;
27         
28         
29         // Erstellt einen unsignierten integer, der mit der Menge Ether definiert wird, die der 
30         // Transaktion mitgeliefert wird:
31         uint startGuthaben = msg.value;
32         
33         // Wenn der ersteller des smart contracts in der transaktion einen Begünstigten angegeben hat, soll ihm 
34         // der zuvor als Startguthaben definierte Wert als Guthaben gutgeschrieben werden.
35         // Das mitgesendete Ether wird dabei dem smart contract gutgeschrieben, er war der Empfänger der Transaktion.
36         if (_sparer != 0x0) guthaben[_sparer] = startGuthaben;
37         else guthaben[msg.sender] = startGuthaben;
38     }
39     
40     
41     // Schreibt dem Absender der Transaktion (TXfrom) ihren Wert (TXvalue) als Guthaben zu
42     function einzahlen() public payable{
43         guthaben[msg.sender] = msg.value;
44     }
45     
46     // Ermöglicht jemandem, so viel Ether aus dem smart contract abzubuchen, wie ihm an Guthaben zur Verfügung steht
47     function abbuchen(uint _betrag) public {
48         
49         // Zunächst prüfen, ob dieser jemand über ausreichend Guthaben verfügt.
50         // Wird diese Bedingung nicht erfüllt, wird die Ausführung der Funktion abgebrochen.
51         require(guthaben[msg.sender] >= _betrag);
52         
53         // Subtrahieren des abzuhebenden Guthabens 
54         guthaben [msg.sender] = guthaben [msg.sender] - _betrag;
55         
56         // Überweisung des Ethers
57         // ".transfer" ist eine Objektmethode des Datentyps address, die an die gegebene Addresse 
58         // die gewünschte Menge Ether zu transferieren versucht. Schlägt dies fehl, wird die
59         // Ausführung der Funktion abgebrochen und bisherige Änderungen rückgängig gemacht.
60         msg.sender.transfer(_betrag);
61     }
62     
63     // Getter-Funktion; Gibt das Guthaben einer Addresse zurück.
64     // Dient der Veranschaulichung von Funktionen, die den state nicht verändern.
65     // Nicht explizit notwendig, da jede als public Variable, so auch das mapping guthaben,
66     // vom compiler eine automatische, gleichnamige Getter-Funktion erhalten, wenn sie als public
67     // deklariert sind.
68     function guthabenAnzeigen(address _sparer) view returns (uint) {
69         return guthaben[_sparer];
70     }
71     
72     // Eine weitere Veranschaulichung eines Funktionstyps, der den state nicht ändert. 
73     // Weil mit pure gekennzeichnete Funktionen auf den state sogar garnicht nicht zugreifen können,
74     // werden entsprechende opcodes nicht benötigt und der smart contract kostet weniger Guthabens
75     // beim deployment benötigt. 
76     function addieren(uint _menge1, uint _menge2) pure returns (uint) {
77         return _menge1 + _menge2;
78     }
79 }