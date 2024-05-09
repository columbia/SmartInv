1 pragma solidity ^0.4.0;
2 
3 contract Coinflip {
4 
5     uint public minWager = 10000000000000000;
6     uint public joinDelta = 10;
7     uint public fee = 1; //1%
8     uint public cancelFee = 1; //1%
9     uint public maxDuration = 86400; //24h
10     bool public canCreateGames = true;
11 
12     address public owner = msg.sender;
13 
14     uint public gamesCounter = 0;
15     mapping(uint => CoinFlipGame) private games;
16     event gameStateChanged(uint gameId, uint state);
17     event onWithdraw(uint amount, uint time);
18     event onDeposit(uint amount, address from, uint time);
19 
20     struct CoinFlipGame {
21         uint state;
22         uint createTime;
23         uint endTime;
24         uint odds;
25         uint fee;
26         uint hostWager;
27         uint opponentWager;
28         uint cancelFee;
29         uint winAmount;
30         address host;
31         address opponent;
32         address winner;
33     }
34 
35     function() public payable {
36         onDeposit(msg.value, msg.sender, now);
37     }
38 
39     modifier onlyBy(address _account)
40     {
41         require(msg.sender == _account);
42         _;
43     }
44 
45     function terminate() public onlyBy(owner) {
46         selfdestruct(owner);
47     }
48 
49     function randomize() private view returns (uint) {
50         var firstPart =  uint(block.blockhash(block.number-1)) % 25;
51         var secondPart =  uint(block.blockhash(block.number-2)) % 25;
52         var thirdPart =  uint(block.blockhash(block.number-3)) % 25;
53         var fourthPart =  uint(block.blockhash(block.number-4)) % 25;
54         return firstPart + secondPart + thirdPart + fourthPart;
55     }
56 
57     function withdraw(uint amount) onlyBy(owner) public {
58         require(amount > 0);
59         owner.transfer(amount);
60         onWithdraw(amount, now);
61     }
62 
63     function toggleCanCreateGames() onlyBy(owner) public {
64         canCreateGames = !canCreateGames;
65     }
66 
67     function setCancelFee(uint newCancelFee) onlyBy(owner) public {
68         require(newCancelFee > 0 && newCancelFee < 25);
69         cancelFee = newCancelFee;
70     }
71 
72     function setMinWager(uint newMinWager) onlyBy(owner) public {
73         require(newMinWager > 0);
74         minWager = newMinWager;
75     }
76 
77     function setMaxDuration(uint newMaxDuration) onlyBy(owner) public {
78         require(newMaxDuration > 0);
79         maxDuration = newMaxDuration;
80     }
81 
82     function setFee(uint newFee) onlyBy(owner) public {
83         require(newFee < 25);
84         fee = newFee;
85     }
86 
87     function setJoinDelta(uint newJoinDelta) onlyBy(owner) public {
88         require(newJoinDelta > 0);
89         require(newJoinDelta < 100);
90         joinDelta = newJoinDelta;
91     }
92 
93     function getGame(uint id) public constant returns(  uint gameId,
94                                                         uint state,
95                                                         uint createTime,
96                                                         uint endTime,
97                                                         uint odds,
98                                                         address host,
99                                                         uint hostWager,
100                                                         address opponent,
101                                                         uint opponentWager,
102                                                         address winner,
103                                                         uint winAmount) {
104         require(id <= gamesCounter);
105         var game = games[id];
106         return (
107         id,
108         game.state,
109         game.createTime,
110         game.endTime,
111         game.odds,
112         game.host,
113         game.hostWager,
114         game.opponent,
115         game.opponentWager,
116         game.winner,
117         game.winAmount);
118     }
119 
120     function getGameFees(uint id) public constant returns(  uint gameId,
121         uint feeVal,
122         uint cancelFeeVal) {
123         require(id <= gamesCounter);
124         var game = games[id];
125         return (
126         id,
127         game.fee,
128         game.cancelFee);
129     }
130 
131     function cancelGame(uint id) public {
132         require(id <= gamesCounter);
133         CoinFlipGame storage game = games[id];
134         if(msg.sender == game.host) {
135             game.state = 3; //cacneled
136             game.endTime = now;
137             game.host.transfer(game.hostWager);
138             gameStateChanged(id, 3);
139         } else {
140             require(game.state == 1); //active
141             require((now - game.createTime) >= maxDuration); //outdated
142             require(msg.sender == owner); //server cancel
143             gameStateChanged(id, 3);
144             game.state = 3; //canceled
145             game.endTime = now;
146             var cancelFeeValue = game.hostWager * cancelFee / 100;
147             game.host.transfer(game.hostWager - cancelFeeValue);
148             game.cancelFee = cancelFeeValue;
149         }
150     }
151 
152     function joinGame(uint id) public payable {
153         var game = games[id];
154         require(game.state == 1);
155         require(msg.value >= minWager);
156         require((now - game.createTime) < maxDuration); //not outdated
157         if(msg.value != game.hostWager) {
158             uint delta;
159             if( game.hostWager < msg.value ) {
160                 delta = msg.value - game.hostWager;
161             } else {
162                 delta = game.hostWager - msg.value;
163             }
164             require( ((delta * 100) / game.hostWager ) <= joinDelta);
165         }
166 
167         game.state = 2;
168         gameStateChanged(id, 2);
169         game.opponent = msg.sender;
170         game.opponentWager = msg.value;
171         game.endTime = now;
172         game.odds = randomize() % 100;
173         var totalAmount = (game.hostWager + game.opponentWager);
174         var hostWagerPercentage = (100 * game.hostWager) / totalAmount;
175         game.fee = (totalAmount * fee) / 100;
176         var transferAmount = totalAmount - game.fee;
177         require(game.odds >= 0 && game.odds <= 100);
178         if(hostWagerPercentage > game.odds) {
179             game.winner = game.host;
180             game.winAmount = transferAmount;
181             game.host.transfer(transferAmount);
182         } else {
183             game.winner = game.opponent;
184             game.winAmount = transferAmount;
185             game.opponent.transfer(transferAmount);
186         }
187     }
188 
189     function startGame() public payable returns(uint) {
190         require(canCreateGames == true);
191         require(msg.value >= minWager);
192         gamesCounter++;
193         var game = games[gamesCounter];
194         gameStateChanged(gamesCounter, 1);
195         game.state = 1;
196         game.createTime = now;
197         game.host = msg.sender;
198         game.hostWager = msg.value;
199     }
200 
201 }