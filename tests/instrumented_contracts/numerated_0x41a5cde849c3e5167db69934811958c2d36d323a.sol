1 pragma solidity ^0.4.19;
2 
3 //Submit your eth to show how big your Eth penis is. The 
4 //biggest Eth dick for 2 days wins the balance and can claim
5 //prize restarting the contest. The creator gets 3% and the
6 //winner gets the rest.
7 contract EthDickMeasuringContest {
8     address public largestPenisOwner;
9     address public owner;
10     uint public largestPenis;
11     uint public withdrawDate;
12 
13     function EthDickMeasuringContest() public{
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
28         require(msg.sender == largestPenisOwner);
29 
30         //Reset game
31         largestPenisOwner = 0;
32         largestPenis = 0;
33 
34         //Judging penises isn't a fun job
35         //taking my 3% from the total prize.
36         owner.transfer(this.balance*3/100);
37         
38         //Congratulation on your giant penis.
39         //Swing that big dig around
40         msg.sender.transfer(this.balance);
41     }
42 }