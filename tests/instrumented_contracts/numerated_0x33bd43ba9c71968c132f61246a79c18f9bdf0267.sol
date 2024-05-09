1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * See https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender)
21     public view returns (uint256);
22 
23   function transferFrom(address from, address to, uint256 value)
24     public returns (bool);
25 
26   function approve(address spender, uint256 value) public returns (bool);
27   event Approval(
28     address indexed owner,
29     address indexed spender,
30     uint256 value
31   );
32 }
33 
34 contract BouncyCoinSelfdrop {
35 
36   event TokensSold(address buyer, uint256 tokensAmount, uint256 ethAmount);
37 
38   // Total Supply: 20,000,000,000, 70% for the selfrop
39   uint256 public constant MAX_TOKENS_SOLD = 14000000000 * 10**18;
40 
41   // Token Price: 0.00000006665 ETH = 1 BOUNCY <=> 1 ETH ~= 15,000,000 BOUNCY
42   uint256 public constant PRICE = 0.00000006665 * 10**18;
43 
44   uint256 public constant MIN_CONTRIBUTION = 0.01 ether;
45 
46   uint256 public constant HARD_CAP = 500 ether;
47 
48   // 1st round: October 17-23, 2018
49   // 1539734400 is equivalent to: 10/17/2018 @ 12:00am (UTC)
50   uint256 oct_17 = 1539734400;
51 
52   // 2nd round: October 24-27, 2018
53   // 1540339200 is equivalent to: 10/24/2018 @ 12:00am (UTC)
54   uint256 oct_24 = 1540339200;
55 
56   // 3rd round: October 28-31, 2018
57   // 1540684800 is equivalent to: 10/28/2018 @ 12:00am (UTC)
58   uint256 oct_28 = 1540684800;
59 
60   // base multiplier does not include extra 10% for 1 ETH and above
61   uint256 public first_round_base_multiplier = 40; // 40% base bonus
62   uint256 public second_round_base_multiplier = 20; // 20% base bonus
63   uint256 public third_round_base_multiplier = 0; // 0% base bonus
64 
65   address public owner;
66 
67   address public wallet;
68 
69   uint256 public tokensSold;
70 
71   uint256 public totalReceived;
72 
73   ERC20 public bouncyCoinToken;
74 
75   /* Current stage */
76   Stages public stage;
77 
78   enum Stages {
79     Deployed,
80     Started,
81     Ended
82   }
83 
84   /* Modifiers */
85 
86   modifier atStage(Stages _stage) {
87     require(stage == _stage);
88     _;
89   }
90 
91   modifier isOwner() {
92     require(msg.sender == owner);
93     _;
94   }
95 
96   /* Constructor */
97 
98   constructor(address _wallet, address _bouncyCoinToken)
99     public {
100     require(_wallet != 0x0);
101     require(_bouncyCoinToken != 0x0);
102 
103     owner = msg.sender;
104     wallet = _wallet;
105     bouncyCoinToken = ERC20(_bouncyCoinToken);
106     stage = Stages.Deployed;
107   }
108 
109   /* Public functions */
110 
111   function()
112     public
113     payable {
114     if (stage == Stages.Started) {
115       buyTokens();
116     } else {
117       revert();
118     }
119   }
120 
121   function buyTokens()
122     public
123     payable
124     atStage(Stages.Started) {
125     require(msg.value >= MIN_CONTRIBUTION);
126 
127     uint256 base_multiplier;
128     if (now > oct_28) {
129       base_multiplier = third_round_base_multiplier;
130     } else if (now > oct_24) {
131       base_multiplier = second_round_base_multiplier;
132     } else if (now > oct_17) {
133       base_multiplier = first_round_base_multiplier;
134     } else {
135       base_multiplier = 0;
136     }
137 
138     uint256 multiplier;
139     if (msg.value >= 1 ether) multiplier = base_multiplier + 10;
140     else multiplier = base_multiplier;
141 
142     uint256 amountRemaining = msg.value;
143 
144     uint256 tokensAvailable = MAX_TOKENS_SOLD - tokensSold;
145     uint256 baseTokens = amountRemaining * 10**18 / PRICE;
146     // adjust for bonus multiplier
147     uint256 maxTokensByAmount = baseTokens + ((baseTokens * multiplier) / 100);
148 
149     uint256 tokensToReceive = 0;
150     if (maxTokensByAmount > tokensAvailable) {
151       tokensToReceive = tokensAvailable;
152       amountRemaining -= (PRICE * tokensToReceive) / 10**18;
153     } else {
154       tokensToReceive = maxTokensByAmount;
155       amountRemaining = 0;
156     }
157     tokensSold += tokensToReceive;
158 
159     assert(tokensToReceive > 0);
160     assert(bouncyCoinToken.transfer(msg.sender, tokensToReceive));
161 
162     if (amountRemaining != 0) {
163       msg.sender.transfer(amountRemaining);
164     }
165 
166     uint256 amountAccepted = msg.value - amountRemaining;
167     wallet.transfer(amountAccepted);
168     totalReceived += amountAccepted;
169     require(totalReceived <= HARD_CAP);
170 
171     if (tokensSold == MAX_TOKENS_SOLD) {
172       finalize();
173     }
174 
175     emit TokensSold(msg.sender, tokensToReceive, amountAccepted);
176   }
177 
178   function start()
179     public
180     isOwner {
181     stage = Stages.Started;
182   }
183 
184   function stop()
185     public
186     isOwner {
187     finalize();
188   }
189 
190   function finalize()
191     private {
192     stage = Stages.Ended;
193   }
194 
195   // In case of accidental ether lock on contract
196   function withdraw()
197     public
198     isOwner {
199     owner.transfer(address(this).balance);
200   }
201 
202   // In case of accidental token transfer to this address, owner can transfer it elsewhere
203   function transferERC20Token(address _tokenAddress, address _to, uint256 _value)
204     public
205     isOwner {
206     ERC20 token = ERC20(_tokenAddress);
207     assert(token.transfer(_to, _value));
208   }
209 
210 }