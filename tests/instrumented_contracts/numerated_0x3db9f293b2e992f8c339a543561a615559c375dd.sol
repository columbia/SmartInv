1 pragma solidity ^0.4.19;
2 
3 // See biteuthusiast.github.io
4 
5 // Press the button to become the winner (costs 0.0001)
6 // Then you can take 10% of the balance whent the countdown reach 0
7 
8 // Dev fee is 0.0005 per winner
9 
10 // Enjoy, don't forget to check this account
11 // I will refill it
12 
13 contract Countdown {
14     uint public deadline = now;
15     uint private constant waittime = 12 hours;
16     
17     address private owner = msg.sender;
18     address public winner;
19     
20     function () public payable {
21         
22     }
23     
24     function click() public payable {
25         require(msg.value >= 0.0001 ether);
26         deadline = now + waittime;
27         winner = msg.sender;
28     }
29     
30     function withdraw() public {
31         require(now > deadline);
32         require(msg.sender == winner);
33         
34         deadline = now + waittime;
35 
36         // Winner take 10% of the funds
37         // And the game continues !
38         if(this.balance < 0.0005 ether)
39             msg.sender.transfer(this.balance);
40         else
41             msg.sender.transfer(this.balance /  10);
42 
43         // The only fee I will take
44         if(this.balance > 0.0005 ether)
45             owner.transfer(0.0005 ether);
46     }
47 }