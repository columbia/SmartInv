1 pragma solidity ^0.4.10;
2 
3 contract Metronome {
4 
5     // This is the constructor whose code is
6     // run only when the contract is created.
7     function Metronome() {
8     }
9     
10     
11     // total amount invested
12     uint public invested = 0;
13     
14     // stores the last ping of every participants
15     mapping (address => uint) public lastPing;
16     // stores the balance of each participant
17     mapping (address => uint) public balanceOf;
18     // stores the value of rewards the last time a player collected rewards
19     mapping (address => uint) public lastRewards;
20 
21     uint public constant largeConstant = 1000000 ether;
22     // cumulative ratio of rewards over invested (multiplied by largeConstant)
23     uint public cumulativeRatios = 0;
24     
25     // this array is not used in the rules of the game
26     // it enables players to check the state of other players more easily
27     mapping (uint => address) public participants;
28     uint public countParticipants = 0;
29     
30     
31     /** Private and Constant functions */
32     
33     // adds a player to the array of participants
34     function addPlayer(address a) private {
35         if (lastPing[a] == 0) {
36             participants[countParticipants] = a;
37             countParticipants = countParticipants + 1;
38         }
39         lastPing[a] = now;
40     }
41     
42     
43     // updates the balance and updates the total invested amount
44     function modifyBalance(address a, uint x) private {
45         balanceOf[a] = balanceOf[a] + x;
46         invested = invested + x;
47     }
48     
49     // creates a new reward that can be claimed by users
50     function createReward(uint value, uint oldTotal) private {
51         if (oldTotal > 0)
52             cumulativeRatios = cumulativeRatios + (value * largeConstant) / oldTotal;
53     }
54     
55     // function called to forbid a player from claiming all past rewards
56     function forbid(address a) private {
57         lastRewards[a] = cumulativeRatios;
58     }
59     
60     // function to compute the next reward of a player
61     function getReward(address a) constant returns (uint) {
62         uint rewardsDifference = cumulativeRatios - lastRewards[a];
63         return (rewardsDifference * balanceOf[a]) / largeConstant;
64     }
65     
66     // function to compute the lost amount
67     function losingAmount(address a, uint toShare) constant returns (uint) {
68         return toShare - (((toShare*largeConstant)/invested)*balanceOf[a]) / largeConstant;
69     }
70     
71     /** Public functions */
72     
73     // to be called every day
74     function idle() {
75         lastPing[msg.sender] = now;
76     }
77     
78     // function called when a user wants to invest in the contract
79     // after calling this function you cannot claim past rewards
80     function invest() payable {
81         uint reward = getReward(msg.sender);
82         addPlayer(msg.sender);
83         modifyBalance(msg.sender, msg.value);
84         forbid(msg.sender);
85         createReward(reward, invested);
86     }
87     
88     // function called when a user wants to divest
89     function divest(uint256 value) {
90         require(value <= balanceOf[msg.sender]);
91         
92         uint reward = getReward(msg.sender);
93         modifyBalance(msg.sender, -value);
94         forbid(msg.sender);
95         createReward(reward, invested);
96         msg.sender.transfer(value);
97     }
98     
99     // claims the rewards
100     function claimRewards() {
101         uint reward = getReward(msg.sender);
102         modifyBalance(msg.sender,reward);
103         forbid(msg.sender);
104     }
105     
106     // used to take create a reward from the funds of someone who has not
107     // idled in the last 10 minutes
108     function poke(address a) {
109         require(now > lastPing[a] + 14 hours && balanceOf[a] > 0);
110         
111         uint missed = getReward(a);
112         uint toShare = balanceOf[a] / 10;
113         uint toLose = losingAmount(a, toShare);
114         
115         createReward(toShare, invested);
116         modifyBalance(a, -toLose);
117         forbid(a);
118         lastPing[a] = now;
119         createReward(missed, invested);
120     }
121 }