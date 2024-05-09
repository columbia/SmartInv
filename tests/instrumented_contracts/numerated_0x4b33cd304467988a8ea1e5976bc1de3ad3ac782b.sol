1 /**
2  *  Crowdsale for m+plus coin phase 2
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
46 
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
62 contract MplusCrowdsaleB {
63     using SafeMath for uint256;
64 
65     // Number of stages
66     uint256 internal constant NUM_STAGES = 4;
67 
68     // 05/02 - 05/16
69     uint256 internal constant ICO_START1 = 1525190400;
70     // 05/17 - 06/01
71     uint256 internal constant ICO_START2 = 1526486400;
72     // 06/02 - 06/16
73     uint256 internal constant ICO_START3 = 1527868800;
74     // 06/17 - 07/01
75     uint256 internal constant ICO_START4 = 1529164800;
76     // 07/01
77     uint256 internal constant ICO_END = 1530460799;
78 
79     // Exchange rate for each term periods
80     uint256 internal constant ICO_RATE1 = 13000;
81     uint256 internal constant ICO_RATE2 = 12500;
82     uint256 internal constant ICO_RATE3 = 12000;
83     uint256 internal constant ICO_RATE4 = 11500;
84 
85     // Funding goal and soft cap in Token
86     //uint256 internal constant HARD_CAP = 2000000000 * (10 ** 18);
87     // Cap for each term periods in ETH
88     // Exchange rate for each term periods
89     uint256 internal constant ICO_CAP1 = 8000 * (10 ** 18);
90     uint256 internal constant ICO_CAP2 = 16000 * (10 ** 18);
91     uint256 internal constant ICO_CAP3 = 24000 * (10 ** 18);
92     uint256 internal constant ICO_CAP4 = 32000 * (10 ** 18);
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
119     /**
120      * Event for token purchase logging
121      *
122      * @param purchaser who paid for the tokens
123      * @param beneficiary who got the tokens
124      * @param value weis paid for purchase
125      * @param amount amount of tokens purchased
126      */
127     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
128 
129     event IcoStageStarted(uint256 stage);
130     event IcoEnded();
131 
132     /**
133      * @dev Throws if called by any account other than the owner.
134      */
135     modifier onlyOwner() {
136         require(msg.sender == owner);
137         _;
138     }
139 
140     function MplusCrowdsaleB(address _tokenAddress, address _wallet) public {
141         require(_tokenAddress != address(0));
142         require(_wallet != address(0));
143 
144         owner = msg.sender;
145         tokenOwner = msg.sender;
146         wallet = _wallet;
147 
148         tokenReward = ERC20(_tokenAddress);
149     }
150 
151     // Fallback function can be used to buy tokens
152     function () external payable {
153         buyTokens(msg.sender);
154     }
155 
156     // Low level token purchase function
157     function buyTokens(address _beneficiary) public payable {
158         require(_beneficiary != address(0));
159         require(msg.value >= MIN_CAP);
160         require(msg.value <= MAX_CAP);
161         require(now >= ICO_START1);
162         require(now <= ICO_END);
163         require(stage <= NUM_STAGES);
164 
165         determineCurrentStage();
166 //        require(stage >= 1 && stage <= NUM_STAGES);
167 
168         uint256 weiAmount = msg.value;
169 
170         // calculate token amount to be created
171         uint256 tokens = getTokenAmount(weiAmount);
172         require(tokens > 0);
173 
174         // Update totals
175         weiRaised = weiRaised.add(weiAmount);
176         tokensSold = tokensSold.add(tokens);
177         checkCap();
178 
179         emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
180         require(tokenReward.transferFrom(tokenOwner, _beneficiary, tokens));
181         forwardFunds();
182     }
183 
184     // Send ether to the fund collection wallet
185     function forwardFunds() internal {
186         wallet.transfer(msg.value);
187     }
188 
189     function determineCurrentStage() internal {
190 //        uint256 prevStage = stage;
191         if (stage < 4 && now >= ICO_START4) {
192             stage = 4;
193             emit IcoStageStarted(4);
194         } else if (stage < 3 && now >= ICO_START3) {
195             stage = 3;
196             emit IcoStageStarted(3);
197         } else if (stage < 2 && now >= ICO_START2) {
198             stage = 2;
199             emit IcoStageStarted(2);
200         } else if (stage < 1 && now >= ICO_START1) {
201             stage = 1;
202             emit IcoStageStarted(1);
203         }
204     }
205 
206     function checkCap() internal {
207         if (weiRaised >= ICO_CAP4) {
208             stage = 5;
209             emit IcoEnded();
210         } else if (stage < 4 && weiRaised >= ICO_CAP3) {
211             stage = 4;
212             emit IcoStageStarted(4);
213         } else if (stage < 3 && weiRaised >= ICO_CAP2) {
214             stage = 3;
215             emit IcoStageStarted(3);
216         } else if (stage < 2 && weiRaised >= ICO_CAP1) {
217             stage = 2;
218             emit IcoStageStarted(2);
219         }
220     }
221 
222     function getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
223         uint256 rate = 0;
224 
225         if (stage == 1) {
226             rate = ICO_RATE1;
227         } else if (stage == 2) {
228             rate = ICO_RATE2;
229         } else if (stage == 3) {
230             rate = ICO_RATE3;
231         } else if (stage == 4) {
232             rate = ICO_RATE4;
233         }
234 
235         return rate.mul(_weiAmount);
236     }
237 }