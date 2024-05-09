1 pragma solidity ^0.4.25;
2 
3 /**
4  * EtherDice - fully transparent and decentralized betting
5  * 
6  * Winning chance: 50%
7  * Winning bet pays: 1.98x
8  *
9  * Web              - https://etherdice.biz
10  * Telegram chat    - https://t.me/EtherDice
11  * Telegram channel - https://t.me/EtherDiceInfo
12  *
13  * Recommended gas limit: 200000
14  * Recommended gas price: https://ethgasstation.info/
15  */
16 contract EtherDice {
17     
18     address public constant OWNER = 0x8026F25c6f898b4afE03d05F87e6c2AFeaaC3a3D;
19     address public constant MANAGER = 0xD25BD6c44D6cF3C0358AB30ed5E89F2090409a79;
20     uint constant public FEE_PERCENT = 1;
21     
22     uint public minBet;
23     uint public maxBet;
24     uint public currentIndex;
25     uint public lockBalance;
26     uint public betsOfBlock;
27     uint entropy;
28     
29     struct Bet {
30         address player;
31         uint deposit;
32         uint block;
33     }
34 
35     Bet[] public bets;
36 
37     event PlaceBet(uint num, address player, uint bet, uint payout, uint roll, uint time);
38 
39     // Modifier on methods invokable only by contract owner and manager
40     modifier onlyOwner {
41         require(OWNER == msg.sender || MANAGER == msg.sender);
42         _;
43     }
44 
45     // This function called every time anyone sends a transaction to this contract
46     function() public payable {
47         if (msg.value > 0) {
48             createBet(msg.sender, msg.value);
49         }
50         
51         placeBets();
52     }
53     
54     // Records a new bet to the public storage
55     function createBet(address _player, uint _deposit) internal {
56         
57         require(_deposit >= minBet && _deposit <= maxBet); // check deposit limits
58         
59         uint lastBlock = bets.length > 0 ? bets[bets.length-1].block : 0;
60         
61         require(block.number != lastBlock || betsOfBlock < 50); // maximum 50 bets per block
62         
63         uint fee = _deposit * FEE_PERCENT / 100;
64         uint betAmount = _deposit - fee; 
65         
66         require(betAmount * 2 + fee <= address(this).balance - lockBalance); // profit check
67         
68         sendOwner(fee);
69         
70         betsOfBlock = block.number != lastBlock ? 1 : betsOfBlock + 1;
71         lockBalance += betAmount * 2;
72         bets.push(Bet(_player, _deposit, block.number));
73     }
74 
75     // process all the bets of previous players
76     function placeBets() internal {
77         
78         for (uint i = currentIndex; i < bets.length; i++) {
79             
80             Bet memory bet = bets[i];
81             
82             if (bet.block < block.number) {
83                 
84                 uint betAmount = bet.deposit - bet.deposit * FEE_PERCENT / 100;
85                 lockBalance -= betAmount * 2;
86 
87                 // Bets made more than 256 blocks ago are considered failed - this has to do
88                 // with EVM limitations on block hashes that are queryable 
89                 if (block.number - bet.block <= 256) {
90                     entropy = uint(keccak256(abi.encodePacked(blockhash(bet.block), entropy)));
91                     uint roll = entropy % 100 + 1;
92                     uint payout = roll < 51 ? betAmount * 2 : 0;
93                     send(bet.player, payout);
94                     emit PlaceBet(i + 1, bet.player, bet.deposit, payout, roll, now); 
95                 }
96             } else {
97                 break;
98             }
99         }
100         
101         currentIndex = i;
102     }
103     
104     // Safely sends the ETH by the passed parameters
105     function send(address _receiver, uint _amount) internal {
106         if (_amount > 0 && _receiver != address(0)) {
107             _receiver.send(_amount);
108         }
109     }
110     
111     // Sends funds to the owner and manager
112     function sendOwner(uint _amount) internal {
113         send(OWNER, _amount * 7 / 10);
114         send(MANAGER, _amount * 3 / 10);
115     }
116     
117     // Funds withdrawal
118     function withdraw(uint _amount) public onlyOwner {
119         require(_amount <= address(this).balance - lockBalance);
120         sendOwner(_amount);
121     }
122     
123     // Set limits for deposits
124     function configure(uint _minBet, uint _maxBet) onlyOwner public {
125         require(_minBet >= 0.001 ether && _minBet <= _maxBet);
126         minBet = _minBet;
127         maxBet = _maxBet;
128     }
129 
130     // This function deliberately left empty. It's primary use case is to top up the bank roll
131     function deposit() public payable {}
132     
133     // Returns the number of bets created
134     function totalBets() public view returns(uint) {
135         return bets.length;
136     }
137 }