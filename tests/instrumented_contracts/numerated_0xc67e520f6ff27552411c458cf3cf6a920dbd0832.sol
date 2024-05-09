1 pragma solidity ^0.4.0;
2 contract MessaggioInBottiglia {
3     address public owner; //proprietario del contratto
4     string public message; //messaggio da lanciare
5     string public ownerName;
6     
7     mapping(address => string[]) public comments; //commenti
8     
9     modifier onlyOwner() { require(owner == msg.sender); _; }
10     
11     event newComment(address _sender, string _comment);
12     
13     constructor() public { //costruttore del contratto
14         owner = msg.sender;
15         ownerName = "Gaibrasch Tripfud";
16         message = "Questo è messaggio di prova, scritto dal un temibile pirata. Aggiungi un commento se vuoi scopire dove si trova il tesoro nascosto.";
17     }
18     
19     function addComment(string commento) public payable returns(bool){ //aggiunge testo al contratto
20         comments[msg.sender].push(commento);
21         emit newComment(msg.sender, commento);
22         return true;
23     }
24     
25     function destroyBottle() public onlyOwner { //distrugge la bottiglia e il messaggio e quindi tutto il contratto
26         selfdestruct(owner);
27     }
28 }