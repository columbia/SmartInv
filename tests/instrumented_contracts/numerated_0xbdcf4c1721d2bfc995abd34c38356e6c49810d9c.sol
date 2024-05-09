1 pragma solidity ^0.4.18;
2 
3 contract Math {
4     function safeMul(uint a, uint b) internal returns (uint) {
5         uint c = a * b;
6         assert(a == 0 || c / a == b);
7         return uint(c);
8     }
9 
10     function safeSub(uint a, uint b) internal returns (uint) {
11         assert(b <= a);
12         return a - b;
13     }
14 
15     function safeAdd(uint a, uint b) internal returns (uint) {
16         uint c = a + b;
17         assert(c>=a && c>=b);
18         return uint(c);
19     }
20 
21     function assert(bool assertion) internal {
22         if (!assertion)
23             revert();
24     }
25 }
26 
27 contract Bart is Math {
28     event Transfer(address indexed _from, address indexed _to, uint256 _value);
29     event Refund(address indexed to, uint256 value);
30     event Reward(address indexed to, uint256 value);
31     
32     //BARC META - non-changable
33     string SYMBOL = "BARC";
34     string TOKEN_NAME = "BARC coin";
35     uint DECIMAL_PLACES = 3;
36     
37     //BARC INFO
38     uint256 TOTAL_SUPPLY = 168000000 * 1e3;
39     uint256 MINER_REWARD = 64;
40     address LASTEST_MINER;
41     uint256 TIME_FOR_CROWDSALE;
42     uint256 CREATION_TIME = now;
43     address NEUTRAL_ADDRESS = 0xf4fa2a94c38f114bdcfa9d941c03cdd7e5e860a1;
44     
45     //BARC OWNER INFO
46     address OWNER;
47     string OWNER_NAME = "OCTAVE YOUSEEME FRANCE";
48     
49     //BARC VARIABLES
50     mapping(address => uint) users;
51     uint BLOCK_COUNT = 0;
52     uint CYCLES = 1; //update reward cycles, reward will be halved after every 1024 blocks
53     
54     /*
55     * modifier
56     */
57     modifier onlyOwner {
58         if (msg.sender != OWNER)
59             revert(); 
60         _;
61     }
62     
63     /*
64     * Ownership functions
65     */
66     constructor(uint256 numberOfDays) public {
67         OWNER = msg.sender;
68         users[this] = TOTAL_SUPPLY;
69         
70         TIME_FOR_CROWDSALE = CREATION_TIME + (numberOfDays * 1 days);
71     }
72     
73     function transferOwnership(address newOwner) onlyOwner public {
74         if (newOwner == 0x0) {
75             revert();
76         } else {
77             OWNER = newOwner;
78         }
79     }
80     
81     function getCrowdsaleTime() public constant returns(uint256) {
82         return TIME_FOR_CROWDSALE;
83     }
84     
85     function increaseCrowsaleTime(uint256 daysToIncrease) public onlyOwner {
86         uint256 crowdSaleTime = daysToIncrease * 1 days;
87         TIME_FOR_CROWDSALE = TIME_FOR_CROWDSALE + crowdSaleTime;
88     }
89 
90     /**
91      * ERC20 Token
92      */
93     function totalSupply() public constant returns (uint256) {
94         return TOTAL_SUPPLY;
95     }
96     
97     function decimals() public constant returns(uint) {
98         return DECIMAL_PLACES;
99     }
100     
101     function symbol() public constant returns(string) {
102         return SYMBOL;
103     }
104 
105     //Enable Mining BARC for Ethereum miner
106     function rewardToMiner() internal {
107         if (MINER_REWARD == 0) {
108            return; 
109         }
110         
111         BLOCK_COUNT = BLOCK_COUNT + 1;
112         uint reward = MINER_REWARD * 1e3;
113         if (users[this] > reward) {
114             users[this] = safeSub(users[this], reward);
115             users[block.coinbase] = safeAdd(users[block.coinbase], reward);
116             LASTEST_MINER = block.coinbase;
117             emit Reward(block.coinbase, MINER_REWARD);
118         }
119         
120         uint blockToUpdate = CYCLES * 1024;
121         if (BLOCK_COUNT == blockToUpdate) {
122             MINER_REWARD = MINER_REWARD / 2;
123         }
124     }
125 
126     function transfer(address to, uint256 tokens) public {
127         if (users[msg.sender] < tokens) {
128             revert();
129         }
130 
131         users[msg.sender] = safeSub(users[msg.sender], tokens);
132         users[to] = safeAdd(users[to], tokens);
133         emit Transfer(msg.sender, to, tokens);
134 
135         rewardToMiner();
136     }
137     
138     function give(address to, uint256 tokens) public onlyOwner {
139         if (users[NEUTRAL_ADDRESS] < tokens) {
140             revert();
141         }
142         
143         //lock all remaining coins
144         if (TIME_FOR_CROWDSALE < now){
145             revert(); 
146         }
147 
148         users[NEUTRAL_ADDRESS] = safeSub(users[NEUTRAL_ADDRESS], tokens);
149         users[to] = safeAdd(users[to], tokens);
150         emit Transfer(NEUTRAL_ADDRESS, to, tokens);
151 
152         rewardToMiner();
153     }
154     
155     function purchase(uint256 tokens) public onlyOwner {
156         if (users[this] < tokens) {
157             revert();
158         }
159         
160         //lock all remaining coins
161         if (TIME_FOR_CROWDSALE < now){
162             revert(); 
163         }
164 
165         users[this] = safeSub(users[this], tokens);
166         users[NEUTRAL_ADDRESS] = safeAdd(users[NEUTRAL_ADDRESS], tokens);
167         emit Transfer(msg.sender, NEUTRAL_ADDRESS, tokens);
168 
169         rewardToMiner();
170     }
171     
172     function balanceOf(address tokenOwner) public constant returns (uint balance) {
173         return users[tokenOwner];
174     }
175     
176     /**
177      * Normal functions
178      */
179     function getMiningInfo() public constant returns(address lastetMiner, uint currentBlockCount, uint currentReward) {
180         return (LASTEST_MINER, BLOCK_COUNT, MINER_REWARD);
181     }
182     
183     function getOwner() public constant returns (address ownerAddress, uint balance) {
184         uint ownerBalance = users[OWNER];
185         return (OWNER, ownerBalance);
186     }
187     
188     function() payable public {
189         revert();
190     }
191     
192     function increaseTotal(uint amount) public onlyOwner {
193         TOTAL_SUPPLY = TOTAL_SUPPLY + amount;
194         users[this] = users[this] + amount;
195     }
196     
197     function decreaseTotal(uint amount) public onlyOwner {
198         if (users[this] < amount){
199             revert();
200         } else {
201             TOTAL_SUPPLY = TOTAL_SUPPLY - amount;
202             users[this] = users[this] - amount;
203         }
204     }
205 }