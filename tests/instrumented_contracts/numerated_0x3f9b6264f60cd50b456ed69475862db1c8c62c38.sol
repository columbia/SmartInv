1 pragma solidity 0.4.21;
2 
3 // How fast can you get to 1000 points and win the prize?
4 
5 contract RACEFORETH {
6     // 1000 points to win!
7     uint256 public SCORE_TO_WIN = 1000 finney;
8     uint256 PRIZE;
9     
10     // 1000 points = 1 ether
11     // Speed limit: 0.5 eth to prevent insta-win
12     // Prevents people from going too fast!
13     uint256 public speed_limit = 500 finney;
14     
15     // Keep track of everyone's score
16     mapping (address => uint256) racerScore;
17     mapping (address => uint256) racerSpeedLimit;
18     
19     uint256 latestTimestamp;
20     address owner;
21     
22     function RACEFORETH () public payable {
23         PRIZE = msg.value;
24         owner = msg.sender;
25     }
26     
27     function race() public payable {
28         if (racerSpeedLimit[msg.sender] == 0) { racerSpeedLimit[msg.sender] = speed_limit; }
29         require(msg.value <= racerSpeedLimit[msg.sender] && msg.value > 1 wei);
30         
31         racerScore[msg.sender] += msg.value;
32         racerSpeedLimit[msg.sender] = (racerSpeedLimit[msg.sender] / 2);
33         
34         latestTimestamp = now;
35     
36         // YOU WON
37         if (racerScore[msg.sender] >= SCORE_TO_WIN) {
38             msg.sender.transfer(this.balance);
39         }
40     }
41     
42     function () public payable {
43         race();
44     }
45     
46     // Pull the prize if no one has raced in 3 days :(
47     function endRace() public {
48         require(msg.sender == owner);
49         require(now > latestTimestamp + 3 days);
50         
51         msg.sender.transfer(this.balance);
52     }
53 }