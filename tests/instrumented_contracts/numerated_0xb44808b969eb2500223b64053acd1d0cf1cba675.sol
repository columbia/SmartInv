1 pragma solidity ^0.4.18;
2 
3 // See thecryptobutton.com
4 contract Countdown {
5     
6     uint public deadline;
7     address owner;
8     address public winner;
9     uint public reward = 0;
10     uint public tips = 0;
11     uint public buttonClicks = 0;
12     
13     function Countdown() public payable {
14         owner = msg.sender;
15         deadline = now + 3 hours;
16         winner = msg.sender;
17         reward += msg.value;
18     }
19     
20     function ClickButton() public payable {
21         // Pay at least 1 dollar to click the button
22         require(msg.value >= 0.001 ether);
23         
24         // Refund people who click the button
25         // after it expires
26         if (now > deadline) {
27             revert();
28         }
29     
30         reward += msg.value * 8 / 10;
31         // Take 20% tip for server costs.
32         tips += msg.value * 2 / 10;
33         winner = msg.sender;
34         deadline = now + 30 minutes;
35         buttonClicks += 1;
36     }
37     
38     // The winner is responsible for withdrawing the funds
39     // after the button expires
40     function Win() public {
41         require(msg.sender == winner);
42         require(now > deadline);
43         uint pendingReward = reward;
44         reward = 0;
45         winner.transfer(pendingReward);
46     }
47     
48     function withdrawTips() public {
49         // The owner can only withdraw the tips
50         uint pendingTips = tips;
51         tips = 0;
52         owner.transfer(pendingTips);
53     }
54     
55 }