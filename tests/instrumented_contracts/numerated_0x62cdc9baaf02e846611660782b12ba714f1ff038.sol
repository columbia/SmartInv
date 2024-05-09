1 pragma solidity ^0.4.18;
2 
3 /**
4 * Send 0.00025 to guess a random number from 0-9. Winner gets 90% of the pot.
5 * 10% goes to the house. Note: house is supplying the initial pot so cry me a 
6 * river.
7 */
8 
9 contract LuckyNumber {
10 
11     address owner;
12     bool contractIsAlive = true;
13     
14     //modifier requiring contract to be live. Set bool to false to kill contract
15     modifier live() {
16         require(contractIsAlive);
17         _;
18     }
19 
20     // The constructor. 
21     function LuckyNumber() public { 
22         owner = msg.sender;
23     }
24 
25     //Used for the owner to add money to the pot. 
26     function addBalance() public payable live {
27     }
28     
29 
30     //explicit getter for "balance"
31     function getBalance() view external live returns (uint) {
32         return this.balance;
33     }
34 
35     //allows the owner to abort the contract and retrieve all funds
36     function kill() external live { 
37         if (msg.sender == owner)           // only allow this action if the account sending the signal is the creator
38             owner.transfer(this.balance);
39             contractIsAlive = false;       // kills this contract and sends remaining funds back to creator
40     }
41 
42     /**
43      *Take a guess. Transfer 0.00025 ETH to take a guess. 1/10 chance you are 
44      * correct. If you win, the function will transfer you 90% of the balance. 
45      * It will then kill the contract and return the remainder to the owner.
46      */
47     function takeAGuess(uint8 _myGuess) public payable live {
48         require(msg.value == 0.00025 ether);
49          uint8 winningNumber = uint8(keccak256(now, owner)) % 10;
50         if (_myGuess == winningNumber) {
51             msg.sender.transfer((this.balance*9)/10);
52             owner.transfer(this.balance);
53             contractIsAlive = false;   
54         }
55     }
56 
57 
58 }//end of contract