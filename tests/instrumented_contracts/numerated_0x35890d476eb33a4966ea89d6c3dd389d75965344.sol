1 pragma solidity ^0.4.25;
2 
3 /**
4  * EtherDice - fully transparent and decentralized betting
5  *
6  * Web              - https://etherdice.biz
7  * Telegram chat    - https://t.me/EtherDice
8  * Telegram channel - https://t.me/EtherDiceInfo
9  *
10  * Recommended gas limit: 200000
11  * Recommended gas price: https://ethgasstation.info/
12  */
13 contract EtherDice {
14     
15     address public constant OWNER = 0x8026F25c6f898b4afE03d05F87e6c2AFeaaC3a3D;
16     address public constant MANAGER = 0xD25BD6c44D6cF3C0358AB30ed5E89F2090409a79;
17     uint constant public FEE_PERCENT = 2;
18     
19     uint public minBet;
20     uint public maxBet;
21     uint public currentIndex;
22     uint public lockBalance;
23     uint public betsOfBlock;
24     uint entropy;
25     
26     struct Bet {
27         address player;
28         uint deposit;
29         uint block;
30     }
31 
32     Bet[] public bets;
33 
34     event PlaceBet(uint num, address player, uint bet, uint payout, uint roll, uint time);
35 
36     // Modifier on methods invokable only by contract owner and manager
37     modifier onlyOwner {
38         require(OWNER == msg.sender || MANAGER == msg.sender);
39         _;
40     }
41 
42     // This function called every time anyone sends a transaction to this contract
43     function() public payable {
44         if (msg.value > 0) {
45             createBet(msg.sender, msg.value);
46         }
47         
48         placeBets();
49     }
50     
51     // Records a new bet to the public storage
52     function createBet(address _player, uint _deposit) internal {
53         
54         require(_deposit >= minBet && _deposit <= maxBet); // check deposit limits
55         
56         uint lastBlock = bets.length > 0 ? bets[bets.length-1].block : 0;
57         
58         require(block.number != lastBlock || betsOfBlock < 50); // maximum 50 bets per block
59         
60         uint fee = _deposit * FEE_PERCENT / 100;
61         uint betAmount = _deposit - fee; 
62         
63         require(betAmount * 2 + fee <= address(this).balance - lockBalance); // profit check
64         
65         sendOwner(fee);
66         
67         betsOfBlock = block.number != lastBlock ? 1 : betsOfBlock + 1;
68         lockBalance += betAmount * 2;
69         bets.push(Bet(_player, _deposit, block.number));
70     }
71 
72     // process all the bets of previous players
73     function placeBets() internal {
74         
75         for (uint i = currentIndex; i < bets.length; i++) {
76             
77             Bet memory bet = bets[i];
78             
79             if (bet.block < block.number) {
80                 
81                 uint betAmount = bet.deposit - bet.deposit * FEE_PERCENT / 100;
82                 lockBalance -= betAmount * 2;
83 
84                 // Bets made more than 256 blocks ago are considered failed - this has to do
85                 // with EVM limitations on block hashes that are queryable 
86                 if (block.number - bet.block <= 256) {
87                     entropy = uint(keccak256(abi.encodePacked(blockhash(bet.block), entropy)));
88                     uint roll = entropy % 100 + 1;
89                     uint payout = roll < 50 ? betAmount * 2 : 0;
90                     send(bet.player, payout);
91                     emit PlaceBet(i + 1, bet.player, bet.deposit, payout, roll, now); 
92                 }
93             } else {
94                 break;
95             }
96         }
97         
98         currentIndex = i;
99     }
100     
101     // Safely sends the ETH by the passed parameters
102     function send(address _receiver, uint _amount) internal {
103         if (_amount > 0 && _receiver != address(0)) {
104             _receiver.send(_amount);
105         }
106     }
107     
108     // Sends funds to the owner and manager
109     function sendOwner(uint _amount) internal {
110         send(OWNER, _amount * 7 / 10);
111         send(MANAGER, _amount * 3 / 10);
112     }
113     
114     // Funds withdrawal
115     function withdraw(uint _amount) public onlyOwner {
116         require(_amount <= address(this).balance - lockBalance);
117         sendOwner(_amount);
118     }
119     
120     // Set limits for deposits
121     function configure(uint _minBet, uint _maxBet) onlyOwner public {
122         require(_minBet >= 0.001 ether && _minBet <= _maxBet);
123         minBet = _minBet;
124         maxBet = _maxBet;
125     }
126 
127     // This function deliberately left empty. It's primary use case is to top up the bank roll
128     function deposit() public payable {}
129     
130     // Returns the number of bets created
131     function totalBets() public view returns(uint) {
132         return bets.length;
133     }
134 }