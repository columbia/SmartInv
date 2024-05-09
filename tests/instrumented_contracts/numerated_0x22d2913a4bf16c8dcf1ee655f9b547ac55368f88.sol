1 pragma solidity ^0.4.24;
2 
3 contract WaRoll {
4 
5     struct BetData {
6         uint gameId;
7         address player;
8         uint amount;
9         uint value;
10         uint blockNum;
11         bytes betData;
12     }
13 
14     uint constant private FEE_PERCENT = 1;
15     uint constant private MIN_FEE = 0.0003 ether;
16 
17     uint constant private MIN_STAKE = 0.001 ether;
18     uint constant private MAX_STAKE = 10 ether;
19 
20     uint constant private ROULETTE_BASE_STAKE = 0.01 ether;
21 
22     uint constant private TYPE_ROLL = 0;
23     uint constant private TYPE_ROULETTE = 1;
24     uint constant private ROLL_MAX_MOD = 100;
25     uint constant private ROULETTE_MAX_MOD = 37;
26 
27     mapping(bytes32 => BetData) private bets;
28 
29     address private owner;
30     address private signer;
31     address public croupier;
32 
33     event BetEvent(uint gamdId, bytes32 commit, bytes data);
34     event RollPayment(address player, uint gameId, uint payAmount, uint value, uint result, uint betAmount, uint betValue, bytes32 betTx);
35     event RoulettePayment(address player, uint gameId, uint payAmount, uint value, uint result, uint betAmount, bytes32 betTx, bytes betData);
36     event PaymentFail(address player, uint amount);
37 
38     constructor() public payable {
39         owner = msg.sender;
40         signer = msg.sender;
41         croupier = msg.sender;
42     }
43 
44     modifier ownerOnly(){
45         require(msg.sender == owner, "not owner");
46         _;
47     }
48 
49     modifier croupierOnly(){
50         require(msg.sender == croupier, "not croupier");
51         _;
52     }
53 
54     modifier validSignAndBlock(uint blockNum, bytes32 commit, bytes32 r, bytes32 s){
55         require(blockNum >= block.number, "commit has expired");
56         bytes32 v1 = keccak256(abi.encodePacked(uint40(blockNum), commit));
57         require(signer == ecrecover(v1, 27, r, s) || signer == ecrecover(v1, 28, r, s), "signer valid error");
58         _;
59     }
60 
61     function setCroupier(address c) public ownerOnly {
62         croupier = c;
63     }
64 
65     function setSigner(address c) public ownerOnly {
66         signer = c;
67     }
68 
69 
70     function kill() public ownerOnly {
71         selfdestruct(owner);
72     }
73 
74     function doRollBet(uint value, uint expiredBlockNum, bytes32 commit, bytes32 r, bytes32 s) public payable validSignAndBlock(expiredBlockNum, commit, r, s) {
75         require(value >= 1 && value <= ROLL_MAX_MOD - 3, "invalid value");
76         uint stake = msg.value;
77         require(stake >= MIN_STAKE && stake <= MAX_STAKE);
78         BetData storage bet = bets[commit];
79         require(bet.player == address(0));
80         bet.gameId = TYPE_ROLL;
81         bet.value = value;
82         bet.amount = stake;
83         bet.player = msg.sender;
84         bet.blockNum = block.number;
85         emit BetEvent(bet.gameId, commit, new bytes(0));
86     }
87 
88     function doRouletteBet(bytes data, uint expiredBlockNum, bytes32 commit, bytes32 r, bytes32 s) public payable validSignAndBlock(expiredBlockNum, commit, r, s) {
89         uint stake = msg.value;
90         validRouletteBetData(data, stake);
91         BetData storage bet = bets[commit];
92         require(bet.player == address(0));
93         bet.gameId = TYPE_ROULETTE;
94         bet.betData = data;
95         bet.amount = stake;
96         bet.player = msg.sender;
97         bet.blockNum = block.number;
98         emit BetEvent(bet.gameId, commit, data);
99     }
100 
101     function validRouletteBetData(bytes data, uint amount) pure private {
102         uint length = uint8(data[0]);
103         require(data.length == length * 2 + 1);
104         uint total = 0;
105         for (uint i = 0; i < length; i ++) {
106             total += uint8(data[2 + i * 2]);
107         }
108         require(total * ROULETTE_BASE_STAKE == amount);
109     }
110 
111     function doResult(uint value, bytes32 blockHash, bytes32 betTx, uint paymentMutiplier) public croupierOnly payable {
112         bytes32 commit = keccak256(abi.encodePacked(value));
113         BetData storage bet = bets[commit];
114         require(blockhash(bet.blockNum) == blockHash);
115         if (bet.gameId == TYPE_ROLL) {
116             doRollResult(value, bet, betTx);
117         } else if (bet.gameId == TYPE_ROULETTE) {
118             doRouletteResult(value, bet, betTx, paymentMutiplier);
119         }
120     }
121 
122     function doRollResult(uint value, BetData bet, bytes32 betTx) private croupierOnly {
123         uint result = (value % ROLL_MAX_MOD) + 1;
124         uint betAmount = bet.amount;
125         uint payAmount = 0;
126         if (result <= bet.value) {
127             uint fee = betAmount / 100 * FEE_PERCENT;
128             if (fee < MIN_FEE) {
129                 fee = MIN_FEE;
130             }
131             payAmount = (betAmount - fee) * ROLL_MAX_MOD / bet.value;
132         }
133         if (bet.player.send(payAmount)) {
134             emit RollPayment(bet.player, bet.gameId, payAmount, value, result, bet.amount, bet.value, betTx);
135         } else {
136             emit PaymentFail(bet.player, payAmount);
137         }
138     }
139 
140     function doRouletteResult(uint value, BetData bet, bytes32 betTx, uint paymentMutiplier) private croupierOnly {
141         uint result = value % ROULETTE_MAX_MOD;
142         uint payAmount = ROULETTE_BASE_STAKE * paymentMutiplier;
143         if (bet.player.send(payAmount)) {
144             emit RoulettePayment(bet.player, bet.gameId, payAmount, value, result, bet.amount, betTx, bet.betData);
145         } else {
146             emit PaymentFail(bet.player, payAmount);
147         }
148     }
149 
150 
151     function() public payable {
152     }
153 
154     function withdraw(address add, uint amount) ownerOnly payable public {
155         add.transfer(amount);
156     }
157 }