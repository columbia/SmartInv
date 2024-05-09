1 pragma solidity ^0.4.19;
2 
3 //Submit your eth to show how big your Eth penis is. The 
4 //biggest Eth dick for 2 days wins the balance and can claim
5 //prize restarting the game. The creator gets 3% and the
6 //winner gets the rest.
7 contract EthDickMeasuringGame {
8     address public largestPenisOwner;
9     address public owner;
10     uint public largestPenis;
11     uint public withdrawDate;
12 
13     function EthDickMeasuringGame() public{
14         owner = msg.sender;
15         largestPenisOwner = 0;
16         largestPenis = 0;
17     }
18 
19     function () public payable{
20         require(largestPenis < msg.value);
21         largestPenis = msg.value;
22         withdrawDate = now + 2 days;
23         largestPenisOwner = msg.sender;
24     }
25 
26     function withdraw() public{
27         require(now >= withdrawDate);
28 
29         //Reset game
30         largestPenis = 0;
31 
32         //Judging penises isn't a fun job
33         //taking my 3% from the total prize.
34         owner.transfer(this.balance*3/100);
35         
36         //Congratulation on your giant penis
37         largestPenisOwner.transfer(this.balance);
38         largestPenisOwner = 0;
39     }
40 }