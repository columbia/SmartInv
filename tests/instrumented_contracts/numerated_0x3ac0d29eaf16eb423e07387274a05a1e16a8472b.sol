1 pragma solidity ^0.4.18;
2 
3 /**
4 * Send 0.0001 to guess a random number from 1-10. Winner gets 90% of the pot.
5 * 10% goes to the house. Note: house is supplying the initial pot so cry me a 
6 * river.
7 */
8 
9 contract LuckyNumber {
10 
11     address owner;
12     uint winningNumber = uint(keccak256(now, owner)) % 10;
13 
14     function LuckyNumber() public { // The constructor. 
15         owner = msg.sender;
16     }
17 
18     //Used for the owner to add money to the pot. 
19     function addBalance() public payable {
20     }
21 
22     //fallback function, returns accidental payments to sender
23     function() public payable {
24        msg.sender.transfer(msg.value); 
25     }
26     
27     //explicit getter for "owner"
28     function getOwner() view public returns (address)  {
29         return owner;
30     }
31 
32     //explicit getter for "balance"
33     function getBalance() view public returns (uint) {
34         return this.balance;
35     }
36 
37     //allows the owner to abort the contract and retrieve all funds
38     function kill() public { 
39         if (msg.sender == owner)  // only allow this action if the account sending the signal is the creator
40             selfdestruct(owner);       // kills this contract and sends remaining funds back to creator
41     }
42 
43     /**
44      *Take a guess. Transfer 0.00001 ETH to take a guess. 1/10 chance you are 
45      * correct. If you win, the function will transfer you 90% of the balance. 
46      * It will then kill the contract and return the remainder to the owner.
47      */
48     function takeAGuess(uint _myGuess) public payable {
49         require(msg.value == 0.0001 ether);
50         if (_myGuess == winningNumber) {
51             msg.sender.transfer((this.balance*9)/10);
52             selfdestruct(owner);
53         }
54     }
55 
56 
57 }//end of contract