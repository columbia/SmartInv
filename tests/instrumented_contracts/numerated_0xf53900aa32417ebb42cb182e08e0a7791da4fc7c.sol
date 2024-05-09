1 /**
2  *  Crowdsale for 0+1 Tokens.
3  *
4  *  Based on OpenZeppelin framework.
5  *  https://openzeppelin.org
6  *
7  *  Author: Eversystem Inc.
8  **/
9 
10 pragma solidity ^0.4.18;
11 
12 /**
13  * Safe Math library from OpenZeppelin framework
14  * https://openzeppelin.org
15  *
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21         if (a == 0) {
22             return 0;
23         }
24         uint256 c = a * b;
25         assert(c / a == b);
26         return c;
27     }
28 
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         // assert(b > 0); // Solidity automatically throws when dividing by 0
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33         return c;
34     }
35 
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         assert(b <= a);
38         return a - b;
39     }
40 
41     function add(uint256 a, uint256 b) internal pure returns (uint256) {
42         uint256 c = a + b;
43         assert(c >= a);
44         return c;
45     }
46 }
47 
48 contract ERC20 {
49   function totalSupply() public view returns (uint256);
50   function balanceOf(address who) public view returns (uint256);
51   function transfer(address to, uint256 value) public returns (bool);
52   function allowance(address owner, address spender) public view returns (uint256);
53   function transferFrom(address from, address to, uint256 value) public returns (bool);
54   function approve(address spender, uint256 value) public returns (bool);
55   event Approval(address indexed owner, address indexed spender, uint256 value);
56   event Transfer(address indexed from, address indexed to, uint256 value);
57 }
58 
59 /**
60  * @title 0+1 Crowdsale phase 1
61 1519056000
62 1521129600
63 1522512000
64 1523808000
65 
66 1525104000
67 1526400000
68 1527782400
69 1529078400
70 
71 1530374400
72 1531670400
73 1533052800
74 1534348800
75  */
76 contract ZpoCrowdsaleA {
77     using SafeMath for uint256;
78 
79     // Funding goal and soft cap
80     uint256 public constant HARD_CAP = 2000000000 * (10 ** 18);
81 
82     // Cap for each term periods
83     uint256 public constant ICO_CAP = 7000;
84 
85     // Number of stages
86     uint256 public constant NUM_STAGES = 4;
87 
88     uint256 public constant ICO_START1 = 1518689400;
89     uint256 public constant ICO_START2 = ICO_START1 + 300 seconds;
90     uint256 public constant ICO_START3 = ICO_START2 + 300 seconds;
91     uint256 public constant ICO_START4 = ICO_START3 + 300 seconds;
92     uint256 public constant ICO_END = ICO_START4 + 300 seconds;
93 
94     /*
95     // 2018/02/20 - 2018/03/15
96     uint256 public constant ICO_START1 = 1519056000;
97     // 2018/03/16 - 2018/03/31
98     uint256 public constant ICO_START2 = 1521129600;
99     // 2018/04/01 - 2018/04/15
100     uint256 public constant ICO_START3 = 1522512000;
101     // 2018/04/16 - 2018/04/30
102     uint256 public constant ICO_START4 = 1523808000;
103     // 2018/04/16 - 2018/04/30
104     uint256 public constant ICO_END = 152510399;
105     */
106 
107     // Exchange rate for each term periods
108     uint256 public constant ICO_RATE1 = 20000 * (10 ** 18);
109     uint256 public constant ICO_RATE2 = 18000 * (10 ** 18);
110     uint256 public constant ICO_RATE3 = 17000 * (10 ** 18);
111     uint256 public constant ICO_RATE4 = 16000 * (10 ** 18);
112 
113     // Exchange rate for each term periods
114     uint256 public constant ICO_CAP1 = 14000;
115     uint256 public constant ICO_CAP2 = 21000;
116     uint256 public constant ICO_CAP3 = 28000;
117     uint256 public constant ICO_CAP4 = 35000;
118 
119     // Owner of this contract
120     address public owner;
121 
122     // The token being sold
123     ERC20 public tokenReward;
124 
125     // Tokens will be transfered from this address
126     address public tokenOwner;
127 
128     // Address where funds are collected
129     address public wallet;
130 
131     // Stage of ICO
132     uint256 public stage = 0;
133 
134     // Amount of tokens sold
135     uint256 public tokensSold = 0;
136 
137     // Amount of raised money in wei
138     uint256 public weiRaised = 0;
139 
140     /**
141      * Event for token purchase logging
142      *
143      * @param purchaser who paid for the tokens
144      * @param beneficiary who got the tokens
145      * @param value weis paid for purchase
146      * @param amount amount of tokens purchased
147      */
148     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
149 
150     event IcoStageStarted(uint256 stage);
151 
152     /**
153      * @dev Throws if called by any account other than the owner.
154      */
155     modifier onlyOwner() {
156         require(msg.sender == owner);
157         _;
158     }
159 
160     function ZpoCrowdsaleA(address _tokenAddress, address _wallet) public {
161         require(_tokenAddress != address(0));
162         require(_wallet != address(0));
163 
164         owner = msg.sender;
165         tokenOwner = msg.sender;
166         wallet = _wallet;
167 
168         tokenReward = ERC20(_tokenAddress);
169 
170         stage = 0;
171     }
172 
173     // Fallback function can be used to buy tokens
174     function () external payable {
175         buyTokens(msg.sender);
176     }
177 
178     // Low level token purchase function
179     function buyTokens(address _beneficiary) public payable {
180         require(_beneficiary != address(0));
181         require(stage <= NUM_STAGES);
182         require(validPurchase());
183         require(now <= ICO_END);
184         require(weiRaised < ICO_CAP4);
185         require(msg.value >= (10 ** 17));
186         require(msg.value <= (1000 ** 18));
187 
188         determineCurrentStage();
189         require(stage >= 1 && stage <= NUM_STAGES);
190 
191         uint256 weiAmount = msg.value;
192 
193         // calculate token amount to be created
194         uint256 tokens = getTokenAmount(weiAmount);
195         require(tokens > 0);
196 
197         // Update totals
198         weiRaised = weiRaised.add(weiAmount);
199         tokensSold = tokensSold.add(tokens);
200 
201         assert(tokenReward.transferFrom(tokenOwner, _beneficiary, tokens));
202         TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
203         forwardFunds();
204     }
205 
206     // Send ether to the fund collection wallet
207     function forwardFunds() internal {
208         wallet.transfer(msg.value);
209     }
210 
211     function determineCurrentStage() internal {
212         uint256 prevStage = stage;
213         checkCap();
214 
215         if (stage < 4 && now >= ICO_START4) {
216             stage = 4;
217             checkNewPeriod(prevStage);
218             return;
219         }
220         if (stage < 3 && now >= ICO_START3) {
221             stage = 3;
222             checkNewPeriod(prevStage);
223             return;
224         }
225         if (stage < 2 && now >= ICO_START2) {
226             stage = 2;
227             checkNewPeriod(prevStage);
228             return;
229         }
230         if (stage < 1 && now >= ICO_START1) {
231             stage = 1;
232             checkNewPeriod(prevStage);
233             return;
234         }
235     }
236 
237     function checkCap() internal {
238         if (weiRaised >= ICO_CAP3) {
239             stage = 4;
240         }
241         else if (weiRaised >= ICO_CAP2) {
242             stage = 3;
243         }
244         else if (weiRaised >= ICO_CAP1) {
245             stage = 2;
246         }
247     }
248 
249     function checkNewPeriod(uint256 _prevStage) internal {
250         if (stage != _prevStage) {
251             IcoStageStarted(stage);
252         }
253     }
254 
255     function getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
256         uint256 rate = 0;
257 
258         if (stage == 1) {
259             rate = ICO_RATE1;
260         } else if (stage == 2) {
261             rate = ICO_RATE2;
262         } else if (stage == 3) {
263             rate = ICO_RATE3;
264         } else if (stage == 4) {
265             rate = ICO_RATE4;
266         }
267 
268         return rate.mul(_weiAmount);
269     }
270 
271     // @return true if the transaction can buy tokens
272     function validPurchase() internal view returns (bool) {
273         bool withinPeriod = now >= ICO_START1 && now <= ICO_END;
274         bool nonZeroPurchase = msg.value != 0;
275 
276         return withinPeriod && nonZeroPurchase;
277     }
278 }