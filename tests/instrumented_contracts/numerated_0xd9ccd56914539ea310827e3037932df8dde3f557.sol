1 pragma solidity 0.4.21;
2 
3 // How fast can you get to 100 points and win the prize?
4 // First person to deposit 0.1 eth (100 finney) wins the entire prize!
5 // 1 finney = 1 point
6 
7 contract RACEFORETH {
8     // 100 points to win!
9     uint256 public SCORE_TO_WIN = 100 finney;
10     uint256 public PRIZE;
11     
12     // 100 points = 0.1 ether
13     // Speed limit: 0.05 eth to prevent insta-win
14     // Prevents people from going too fast!
15     uint256 public speed_limit = 50 finney;
16     
17     // Keep track of everyone's score
18     mapping (address => uint256) racerScore;
19     mapping (address => uint256) racerSpeedLimit;
20     
21     uint256 latestTimestamp;
22     address owner;
23     
24     function RACEFORETH () public payable {
25         PRIZE = msg.value;
26         owner = msg.sender;
27     }
28     
29     function race() public payable {
30         if (racerSpeedLimit[msg.sender] == 0) { racerSpeedLimit[msg.sender] = speed_limit; }
31         require(msg.value <= racerSpeedLimit[msg.sender] && msg.value > 1 wei);
32         
33         racerScore[msg.sender] += msg.value;
34         racerSpeedLimit[msg.sender] = (racerSpeedLimit[msg.sender] / 2);
35         
36         latestTimestamp = now;
37     
38         // YOU WON
39         if (racerScore[msg.sender] >= SCORE_TO_WIN) {
40             msg.sender.transfer(PRIZE);
41         }
42     }
43     
44     function () public payable {
45         race();
46     }
47     
48     // Pull the prize if no one has raced in 3 days :(
49     function endRace() public {
50         require(msg.sender == owner);
51         require(now > latestTimestamp + 3 days);
52         
53         msg.sender.transfer(this.balance);
54     }
55 }