1 pragma solidity ^0.4.11;
2 
3 contract TimeBank {
4 
5     struct Holder {
6     uint fundsDeposited;
7     uint withdrawTime;
8     }
9     mapping (address => Holder) holders;
10 
11     function getInfo() constant returns(uint,uint,uint){
12         return(holders[msg.sender].fundsDeposited,holders[msg.sender].withdrawTime,block.timestamp);
13     }
14 
15     function depositFunds(uint _withdrawTime) payable returns (uint _fundsDeposited){
16         //requires Ether to be sent, and _withdrawTime to be in future but no more than 5 years
17 
18         require(msg.value > 0 && _withdrawTime > block.timestamp && _withdrawTime < block.timestamp + 157680000);
19         //increments value in case holder deposits more than once, but won't update the original withdrawTime in case caller wants to change the 'future withdrawTime' to a much closer time but still future time
20         if (!(holders[msg.sender].withdrawTime > 0)) holders[msg.sender].withdrawTime = _withdrawTime;
21         holders[msg.sender].fundsDeposited += msg.value;
22         return msg.value;
23     }
24 
25     function withdrawFunds() {
26         require(holders[msg.sender].withdrawTime < block.timestamp); //throws error if current time is before the designated withdrawTime
27 
28         uint funds = holders[msg.sender].fundsDeposited; // separates the funds into a separate variable, so user can still withdraw after the struct is updated
29 
30         holders[msg.sender].fundsDeposited = 0; // adjusts recorded eth deposit before funds are returned
31         holders[msg.sender].withdrawTime = 0; // clears withdrawTime to allow future deposits
32         msg.sender.transfer(funds); //sends ether to msg.sender if they have funds held
33     }
34 }