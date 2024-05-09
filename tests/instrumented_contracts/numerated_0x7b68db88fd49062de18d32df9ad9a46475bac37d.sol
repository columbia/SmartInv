1 pragma solidity 0.4.20;
2 
3 contract ETHDistributor {
4     
5   address public owner;
6     
7   function ETHDistributor() public {
8     owner = msg.sender;
9   }
10    
11   function addReceivers(address[] receivers, uint[] balances) public {
12     require(msg.sender == owner);
13     for(uint i = 0; i < receivers.length; i++) {
14       receivers[i].transfer(balances[i]);
15     }
16   } 
17   
18   function refund() public {
19     require(msg.sender == owner);      
20     owner.transfer(this.balance);
21   }
22 
23   function () public payable {
24   }
25 
26 }