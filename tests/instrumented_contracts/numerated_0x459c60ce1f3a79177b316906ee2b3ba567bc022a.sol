1 pragma solidity ^0.4.23;
2 
3 /***
4  * @title -MinerWinner beta_0.1
5  * 
6  * MinerWinner is a game created based on Ethereum. 
7  * We try to create a completely fair game.
8  * Try to streamline processes and operations.
9  * This game has no commission.
10  * Everyone have to participate through the equal way.
11  * 
12  * MinerWinner User Guide:
13  * Players can play the game by transferring fund to protocol address at 
14  *  a cost of 1 eth at a time (note: single transfer shall not be less
15  *  than 1 eth, otherwise, the transfer will fail. If the transfer is
16  *  greater than 1 eth, players cannot get extra benefits. If you want
17  *  to make more benefits, you can transfer 1 eth at a time for several times.).
18  * 
19  * Besides eth reward, players can get MinerWinner unique token reward.
20  * 
21  * Token Reward:
22  * Token reward is incrementally awarded to players according to the sort
23  *  entered by the player, for instance, the tenth participant gets 10 tokens,
24  *  and the 100th participant gets 100 token.
25  * 
26  * The eth reward is divided into two parts.
27  * 1.After each new player enters, the reward will be given to the previous
28  *    player in the form of an accelerated round tour.
29  * 2.When the countdown is over but no player enters, the players that have
30  *    extra eth can play repeatedly. If the token of this repeated player is
31  *    more than the latter 8 players in current queue, this play can receive 3
32  *    eth rewards and reactivate the countdown. In this way, the incentive will
33  *    encourage more players to promote the game process.
34  * 
35  * Token transaction:
36  * Token rewards can be traded to players who want to win the promotion reward.
37  *  This is to become the token owner that has most of the token and to compete
38  *  for the promotion reward.
39  *
40  * Then we will launch a series of versions.
41  * This token is available for all versions of MinerWinner.
42  *
43  * WARNING:  THIS PRODUCT IS HIGHLY ADDICTIVE.  IF YOU HAVE AN ADDICTIVE NATURE.  DO NOT PLAY.
44  */
45 //===========================================================================================>
46 
47 contract miner_winner_basic {  
48 
49     address public owner;
50     address public reward_winaddr;
51     uint256 public deadline;
52     uint256 public time;
53     uint256 public price;
54     uint256 public reward_value;
55     token public token_reward;
56     address[] public plyr;
57     uint256 public next_count;
58 }
59 
60 contract miner_winner is miner_winner_basic {
61 
62     constructor(address _token_reward_address) public {
63 
64         owner = msg.sender;
65         reward_winaddr = address(0);
66         time = 8 * 60 minutes;
67         deadline = now + time;
68         price = 1 ether;
69         reward_value = 0;
70         token_reward = token(_token_reward_address);
71         plyr = new address[](0);
72         plyr.push(msg.sender);
73         next_count = 0;
74     }
75 
76     function() public payable {
77 
78         require(msg.value >= price);
79 
80         plyr.push(msg.sender);
81 
82         if( next_count >= plyr.length) {
83             next_count = 0;
84         }
85         plyr[next_count].transfer(price * 20/100);
86         next_count++;
87         
88         if( next_count >= plyr.length) {
89             next_count = 0;
90         }
91         plyr[next_count].transfer(price * 20/100);
92         next_count++;    
93 
94         reward_value = token_reward.balanceOf(address(this));
95 
96         uint256 _pvalue = plyr.length * price;
97 
98         if(reward_value >= _pvalue){
99             token_reward.transfer(msg.sender, _pvalue);
100         }
101         
102         uint256 _now = now;
103 
104         if( _now > deadline) {
105 
106             if( reward_winaddr == address(0)) {
107                 reward_winaddr = plyr[plyr.length - 1];
108             }
109 
110             for(uint256 i = plyr.length - 9; i < plyr.length; i++) {
111 
112                 if(token_reward.balanceOf(plyr[i]) > token_reward.balanceOf(reward_winaddr)){
113                     reward_winaddr = plyr[i];
114                 }
115             }
116 
117             if(address(this).balance > 3 ether){
118                 reward_winaddr.transfer(3 ether);
119             }
120         }
121 
122         deadline = _now + time;
123     }
124 }
125 
126 contract token{
127 
128     function transfer(address receiver, uint amount) public;
129     function balanceOf(address receiver) constant public returns (uint balance);
130 }