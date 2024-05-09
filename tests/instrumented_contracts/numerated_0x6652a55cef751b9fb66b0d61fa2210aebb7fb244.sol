1 /**
2  *  Crowdsale for m+plus coin phase 1
3  *
4  *  Based on OpenZeppelin framework.
5  *  https://openzeppelin.org
6  **/
7 
8 pragma solidity ^0.4.18;
9 
10 /**
11  * Safe Math library from OpenZeppelin framework
12  * https://openzeppelin.org
13  *
14  * @title SafeMath
15  * @dev Math operations with safety checks that throw on error
16  */
17 library SafeMath {
18     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
19         if (a == 0) {
20             return 0;
21         }
22         uint256 c = a * b;
23         assert(c / a == b);
24         return c;
25     }
26 
27     function div(uint256 a, uint256 b) internal pure returns (uint256) {
28         // assert(b > 0); // Solidity automatically throws when dividing by 0
29         uint256 c = a / b;
30         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31         return c;
32     }
33 
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     function add(uint256 a, uint256 b) internal pure returns (uint256) {
40         uint256 c = a + b;
41         assert(c >= a);
42         return c;
43     }
44 }
45 
46 // ERC20 interface
47 contract ERC20 {
48     function totalSupply() public view returns (uint256);
49     function balanceOf(address who) public view returns (uint256);
50     function transfer(address to, uint256 value) public returns (bool);
51     function allowance(address owner, address spender) public view returns (uint256);
52     function transferFrom(address from, address to, uint256 value) public returns (bool);
53     function approve(address spender, uint256 value) public returns (bool);
54     event Approval(address indexed owner, address indexed spender, uint256 value);
55     event Transfer(address indexed from, address indexed to, uint256 value);
56 }
57 
58 
59 /**
60  * @title Crowdsale for m+plus coin phase 1
61  */
62 contract MplusCrowdsaleA {
63     using SafeMath for uint256;
64 
65     // Number of stages
66     uint256 internal constant NUM_STAGES = 4;
67 
68     // 02/20/2018 - 03/16/2018
69     uint256 internal constant ICO_START1 = 1519056000;
70     // 03/17/2018 - 04/01/2018
71     uint256 internal constant ICO_START2 = 1521216000;
72     // 04/02/2018 - 04/16/2018
73     uint256 internal constant ICO_START3 = 1522598400;
74     // 04/17/2018 - 05/01/2018
75     uint256 internal constant ICO_START4 = 1523894400;
76     // 05/01/2018
77     uint256 internal constant ICO_END = 1525190399;
78 
79     // Exchange rate for each term periods
80     uint256 internal constant ICO_RATE1 = 20000;
81     uint256 internal constant ICO_RATE2 = 18000;
82     uint256 internal constant ICO_RATE3 = 17000;
83     uint256 internal constant ICO_RATE4 = 16000;
84 
85     // Funding goal and soft cap in Token
86     //uint256 internal constant HARD_CAP = 2000000000 * (10 ** 18);
87     // Cap for each term periods in ETH
88     // Exchange rate for each term periods
89     uint256 internal constant ICO_CAP1 = 14000 * (10 ** 18);
90     uint256 internal constant ICO_CAP2 = 21000 * (10 ** 18);
91     uint256 internal constant ICO_CAP3 = 28000 * (10 ** 18);
92     uint256 internal constant ICO_CAP4 = 35000 * (10 ** 18);
93 
94     // Caps per a purchase
95     uint256 internal constant MIN_CAP = (10 ** 17);
96     uint256 internal constant MAX_CAP = 1000 * (10 ** 18);
97 
98     // Owner of this contract
99     address internal owner;
100 
101     // The token being sold
102     ERC20 public tokenReward;
103 
104     // Tokens will be transfered from this address
105     address internal tokenOwner;
106 
107     // Address where funds are collected
108     address internal wallet;
109 
110     // Stage of ICO
111     uint256 public stage = 0;
112 
113     // Amount of tokens sold
114     uint256 public tokensSold = 0;
115 
116     // Amount of raised money in wei
117     uint256 public weiRaised = 0;
118 
119     // Event for token purchase logging
120     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
121 
122     event IcoStageStarted(uint256 stage);
123     event IcoEnded();
124 
125     /**
126      * @dev Throws if called by any account other than the owner.
127      */
128     modifier onlyOwner() {
129         require(msg.sender == owner);
130         _;
131     }
132 
133     function MplusCrowdsaleA(address _tokenAddress, address _wallet) public {
134         require(_tokenAddress != address(0));
135         require(_wallet != address(0));
136 
137         owner = msg.sender;
138         tokenOwner = msg.sender;
139         wallet = _wallet;
140 
141         tokenReward = ERC20(_tokenAddress);
142     }
143 
144     // Fallback function can be used to buy tokens
145     function () external payable {
146         buyTokens(msg.sender);
147     }
148 
149     // Low level token purchase function
150     function buyTokens(address _beneficiary) public payable {
151         require(_beneficiary != address(0));
152         require(msg.value >= MIN_CAP);
153         require(msg.value <= MAX_CAP);
154         require(now >= ICO_START1);
155         require(now <= ICO_END);
156         require(stage <= NUM_STAGES);
157 
158         determineCurrentStage();
159 
160         uint256 weiAmount = msg.value;
161 
162         // calculate token amount to be created
163         uint256 tokens = getTokenAmount(weiAmount);
164         require(tokens > 0);
165 
166         // Update totals
167         weiRaised = weiRaised.add(weiAmount);
168         tokensSold = tokensSold.add(tokens);
169         checkCap();
170 
171         TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
172         require(tokenReward.transferFrom(tokenOwner, _beneficiary, tokens));
173         forwardFunds();
174     }
175 
176     // Send ether to the fund collection wallet
177     function forwardFunds() internal {
178         wallet.transfer(msg.value);
179     }
180 
181     // Determine the current stage by term period
182     function determineCurrentStage() internal {
183         if (stage < 4 && now >= ICO_START4) {
184             stage = 4;
185             IcoStageStarted(4);
186         } else if (stage < 3 && now >= ICO_START3) {
187             stage = 3;
188             IcoStageStarted(3);
189         } else if (stage < 2 && now >= ICO_START2) {
190             stage = 2;
191             IcoStageStarted(2);
192         } else if (stage < 1 && now >= ICO_START1) {
193             stage = 1;
194             IcoStageStarted(1);
195         }
196     }
197 
198     // Check cap and change the stage
199     function checkCap() internal {
200         if (weiRaised >= ICO_CAP4) {
201             stage = 5;
202             IcoEnded();
203         } else if (stage < 4 && weiRaised >= ICO_CAP3) {
204             stage = 4;
205             IcoStageStarted(4);
206         } else if (stage < 3 && weiRaised >= ICO_CAP2) {
207             stage = 3;
208             IcoStageStarted(3);
209         } else if (stage < 2 && weiRaised >= ICO_CAP1) {
210             stage = 2;
211             IcoStageStarted(2);
212         }
213     }
214 
215     // Get ammount of tokens
216     function getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
217         uint256 rate = 0;
218 
219         if (stage == 1) {
220             rate = ICO_RATE1;
221         } else if (stage == 2) {
222             rate = ICO_RATE2;
223         } else if (stage == 3) {
224             rate = ICO_RATE3;
225         } else if (stage == 4) {
226             rate = ICO_RATE4;
227         }
228 
229         return rate.mul(_weiAmount);
230     }
231 }