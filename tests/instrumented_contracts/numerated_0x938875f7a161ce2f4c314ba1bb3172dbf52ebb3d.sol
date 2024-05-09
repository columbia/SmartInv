1 pragma solidity ^0.4.0;
2 
3 contract Presale {
4    struct PresaleEntry {
5         address ethID;
6         string email;
7         string bitcoinSRC;
8         string bitcoinDEST;
9         uint satoshis;
10         uint centiWRG;
11     }
12   
13    PresaleEntry [] public entries ;
14    address public master; // master address
15    uint public presaleAmount;
16    bool public presaleGoing;
17    
18    event presaleMade(string sender, uint satoshis);
19 
20     /* Initializes contract with initial supply tokens to the creator of the contract */
21 
22     function Presale() {
23      master = msg.sender;
24      presaleAmount = 23970000 * 100; // 6 030 000 was sold to first investors
25      presaleGoing = true;
26     }
27 
28     /* Very simple trade function */
29 
30     function makePresale(string mail, address adr, uint satoshis, uint centiWRG,string bitcoinSRC, string bitcoinDEST) returns(bool sufficient) {
31         PresaleEntry memory entry;
32         int expectedWRG = int(presaleAmount) - int(centiWRG);
33         
34         if (!presaleGoing) return;
35         
36         if (msg.sender != master) return false; 
37         if (expectedWRG < 0) return false;
38         
39         presaleAmount -= centiWRG;
40         entry.ethID = adr;
41         entry.email = mail;
42         entry.satoshis = satoshis;
43         entry.centiWRG = centiWRG;
44         entry.bitcoinSRC = bitcoinSRC;
45         entry.bitcoinDEST = bitcoinDEST;
46         
47         entries.push(entry);
48         
49         return true;
50      }
51      
52      function stopPresale() returns (bool ok) {
53           if (msg.sender != master) return false; 
54           presaleGoing = false;
55           return true;
56      }
57      
58      function getAmountLeft() returns (uint amount){
59          return presaleAmount;
60      }
61      
62      function getPresaleNumber() returns (uint length){
63          return entries.length;
64      }
65     
66      function getPresale(uint i) returns (string,address,uint,uint,string,string){
67          uint max = entries.length;
68          if (i >= max) {
69              return ("NotFound",0,0,0,"","");
70          }
71          return (entries[i].email,entries[i].ethID, entries[i].satoshis, entries[i].centiWRG,entries[i].bitcoinSRC,entries[i].bitcoinDEST);
72      }
73 
74 }