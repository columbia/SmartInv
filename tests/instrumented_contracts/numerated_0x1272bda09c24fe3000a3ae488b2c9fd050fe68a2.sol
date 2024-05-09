1 pragma solidity 0.5.7;
2 
3 // ----------------------------------------------------------------------------
4 // 'GENES' Genesis crowdsale contract
5 //
6 // Symbol           : GENES
7 // Name             : Genesis Smart Coin
8 // Total supply     : 70,000,000,000.000000000000000000
9 // Contract supply  : 50,000,000,000.000000000000000000
10 // Decimals         : 18
11 //
12 // (c) ViktorZidenyk / Ltd Genesis World 2019. The MIT Licence.
13 // ----------------------------------------------------------------------------
14 
15 // ----------------------------------------------------------------------------
16 // Safe maths
17 // ----------------------------------------------------------------------------
18 library SafeMath {
19     function add(uint a, uint b) internal pure returns (uint c) {
20         c = a + b;
21         require(c >= a);
22     }
23     function sub(uint a, uint b) internal pure returns (uint c) {
24         require(b <= a);
25         c = a - b;
26     }
27     function mul(uint a, uint b) internal pure returns (uint c) {
28         c = a * b;
29         require(a == 0 || c / a == b);
30     }
31     function div(uint a, uint b) internal pure returns (uint c) {
32         require(b > 0);
33         c = a / b;
34     }
35 }
36 
37 // ----------------------------------------------------------------------------
38 // Address
39 // ----------------------------------------------------------------------------
40 library Address {
41   function toAddress(bytes memory source) internal pure returns(address addr) {
42     assembly { addr := mload(add(source,0x14)) }
43     return addr;
44   }
45 
46   function isNotContract(address addr) internal view returns(bool) {
47     uint length;
48     assembly { length := extcodesize(addr) }
49     return length == 0;
50   }
51 }
52 
53 // ----------------------------------------------------------------------------
54 // Zero
55 // ----------------------------------------------------------------------------
56 library Zero {
57   function requireNotZero(address addr) internal pure {
58     require(addr != address(0), "require not zero address");
59   }
60 
61   function requireNotZero(uint val) internal pure {
62     require(val != 0, "require not zero value");
63   }
64 
65   function notZero(address addr) internal pure returns(bool) {
66     return !(addr == address(0));
67   }
68 
69   function isZero(address addr) internal pure returns(bool) {
70     return addr == address(0);
71   }
72 
73   function isZero(uint a) internal pure returns(bool) {
74     return a == 0;
75   }
76 
77   function notZero(uint a) internal pure returns(bool) {
78     return a != 0;
79   }
80 }
81 
82 // ----------------------------------------------------------------------------
83 // Owned contract
84 // ----------------------------------------------------------------------------
85 
86 contract owned {
87     address public owner;
88     address public newOwner;
89 
90     event OwnershipTransferred(address indexed _from, address indexed _to);
91 
92     constructor() public {
93         owner = msg.sender;
94     }
95 
96     modifier onlyOwner {
97         require(msg.sender == owner);
98         _;
99     }
100 
101     function transferOwnership(address _newOwner) public onlyOwner {
102         newOwner = _newOwner;
103     }
104 	
105     function acceptOwnership() public {
106         require(msg.sender == newOwner);
107         emit OwnershipTransferred(owner, newOwner);
108         owner = newOwner;
109         newOwner = address(0);
110     }
111 }
112 
113 interface token {
114     function transfer(address receiver, uint amount) external;
115 }
116 
117 contract preCrowdsaleETH is owned {
118     
119     // Library
120     using SafeMath for uint;
121     
122     uint public price;
123     uint8 decimals;
124     uint8 public refPercent;
125     uint256 public softCap;
126 	uint256 public hardCap;
127 	uint256 public totalSalesEth;
128 	uint256 public totalSalesTokens;
129 	uint public startDate;
130 	uint public bonusEnds50;
131 	uint public bonusEnds30;
132 	uint public bonusEnds20;
133 	uint public bonusEnds10;
134 	uint public bonusEnds5;
135     uint public endDate;
136     address public beneficiary;
137     token public tokenReward;
138     
139     mapping(address => uint256) public balanceOfEth;
140     mapping(address => uint256) public balanceTokens;
141     mapping(address => uint256) public buyTokens;
142     mapping(address => uint256) public buyTokensBonus;
143     mapping(address => uint256) public bountyTokens;
144     mapping(address => uint256) public refTokens;
145     
146     bool fundingGoalReached = false;
147     bool crowdsaleClosed = false;
148     
149     using Address for *;
150     using Zero for *;
151 
152     event GoalReached(address recipient, uint256 totalAmountRaised);
153     event FundTransfer(address backer, uint256 amount, bool isContribution);
154 
155     /**
156      * Constructor
157      *
158      * Setup the owner
159      */
160     constructor(address _addressOfTokenUsedAsReward) public {
161         price = 2500;
162         decimals = 18;
163         refPercent = 5;
164         softCap = 1000000 * 10**uint(decimals);
165 		hardCap = 100000000 * 10**uint(decimals);
166 		startDate = 1555286400;		//15.04.2019
167 		bonusEnds50 = 1557014400;   //05.05.2019
168 		bonusEnds30 = 1558828800;   //26.05.2019
169 		bonusEnds20 = 1560211200;   //11.06.2019
170 		bonusEnds10 = 1561161600;   //22.06.2019
171 		bonusEnds5 = 1562112000;	//03.07.2019
172 		endDate = 1571097600; 		//15.10.2019
173 		beneficiary = owner;
174         tokenReward = token(_addressOfTokenUsedAsReward);
175     }
176 
177     /**
178      * Fallback function
179      *
180      * The function without name is the default function that is called whenever anyone sends funds to a contract
181      */
182 
183     function () payable external {
184         require(!crowdsaleClosed);
185         require(now >= startDate && now <= endDate);
186         
187         uint256 amount = msg.value;
188         uint256 buyTokens = msg.value.mul(price);
189         uint256 buyBonus = 0;
190         
191         // HardCap
192         require(hardCap >= buyTokens.add(buyBonus));
193 
194         if (now <= bonusEnds50) {
195             buyBonus = msg.value.mul(price.mul(50).div(100));
196         } else if (now <= bonusEnds30){
197 			buyBonus = msg.value.mul(price.mul(30).div(100));
198 		} else if (now <= bonusEnds20){
199 			buyBonus = msg.value.mul(price.mul(20).div(100));
200 		} else if (now <= bonusEnds10){
201 			buyBonus = msg.value.mul(price.mul(10).div(100));	
202 		} else if (now <= bonusEnds5){
203 			buyBonus = msg.value.mul(price.mul(5).div(100));
204 		}
205 		
206 		// Verification of input data on referral
207         address referrerAddr = msg.data.toAddress();
208         uint256 refTokens = msg.value.mul(price).mul(refPercent).div(100);
209         if (referrerAddr.notZero() && referrerAddr != msg.sender && hardCap < buyTokens.add(buyBonus).add(refTokens)) {
210             balanceOfEth[msg.sender] = balanceOfEth[msg.sender].add(amount);
211             totalSalesEth = totalSalesEth.add(amount);
212             totalSalesTokens = totalSalesTokens.add(buyTokens).add(buyBonus).add(refTokens);
213             addTokensBonusRef(msg.sender, buyTokens, buyBonus, referrerAddr, refTokens);
214 		    emit FundTransfer(msg.sender, amount, true);
215 		    
216         } else {
217     
218             balanceOfEth[msg.sender] = balanceOfEth[msg.sender].add(amount);
219             totalSalesEth = totalSalesEth.add(amount);
220             totalSalesTokens = totalSalesTokens.add(buyTokens).add(buyBonus);
221             addTokensBonus(msg.sender, buyTokens, buyBonus);
222 		    emit FundTransfer(msg.sender, amount, true);
223         }
224     }
225 
226     modifier afterDeadline() { if (now >= endDate) _; }
227 
228     /**
229      * Check if goal was reached
230      *
231      * Checks if the goal or time limit has been reached and ends the campaign
232      */
233     function checkGoalReached() public afterDeadline {
234         if (totalSalesTokens >= softCap){
235             fundingGoalReached = true;
236             emit GoalReached(beneficiary, totalSalesEth);
237         }
238         crowdsaleClosed = true;
239     }
240 
241 
242     /**
243      * Withdraw the funds
244      *
245      * Checks to see if goal or time limit has been reached, and if so, and the funding goal was reached,
246      * sends the entire amount to the beneficiary. If goal was not reached, each contributor can withdraw
247      * the amount they contributed.
248      */
249     function safeWithdrawal() public afterDeadline {
250         require(crowdsaleClosed);
251         if (!fundingGoalReached) {
252             uint256 amount = balanceOfEth[msg.sender];
253             balanceOfEth[msg.sender] = 0;
254             if (amount > 0) {
255                 if (msg.sender.send(amount)) {
256                    emit FundTransfer(msg.sender, amount, false);
257                 } else {
258                     balanceOfEth[msg.sender] = amount;
259                 }
260             }
261         }
262 
263         if (fundingGoalReached && beneficiary == msg.sender) {
264             if (msg.sender.send(address(this).balance)) {
265                emit FundTransfer(beneficiary, address(this).balance, false);
266             } else {
267                 // If we fail to send the funds to beneficiary, unlock funders balance
268                 fundingGoalReached = false;
269             }
270         }
271     }
272     
273     // ------------------------------------------------------------------------
274     // Set referer percent
275     // ------------------------------------------------------------------------
276 	function setRefPer(uint8 percent) public onlyOwner {
277 	    refPercent = percent;
278 	}
279 	
280 	function addTokens(address to, uint256 tokens) internal {
281         require(!crowdsaleClosed);
282         balanceTokens[to] = balanceTokens[to].add(tokens);
283         buyTokens[to] = buyTokens[to].add(tokens);
284         tokenReward.transfer(to, tokens);
285     }
286     
287     function addTokensBonus(address to, uint256 buyToken, uint256 buyBonus) internal {
288         require(!crowdsaleClosed);
289         balanceTokens[to] = balanceTokens[to].add(buyToken).add(buyBonus);
290         buyTokens[to] = buyTokens[to].add(buyToken);
291         buyTokensBonus[to] = buyTokensBonus[to].add(buyBonus);
292         tokenReward.transfer(to, buyToken.add(buyBonus));
293     }
294     
295     function addBountyTokens(address to, uint256 bountyToken) internal {
296         require(!crowdsaleClosed);
297         balanceTokens[to] = balanceTokens[to].add(bountyToken);
298         bountyTokens[to] = bountyTokens[to].add(bountyToken);
299         tokenReward.transfer(to, bountyToken);
300     }
301     
302     function addTokensBonusRef(address to, uint256 buyToken, uint256 buyBonus, address referrerAddr, uint256 refToken) internal {
303         require(!crowdsaleClosed);
304         balanceTokens[to] = balanceTokens[to].add(buyToken).add(buyBonus);
305         buyTokens[to] = buyTokens[to].add(buyToken);
306         buyTokensBonus[to] = buyTokensBonus[to].add(buyBonus);
307         tokenReward.transfer(to, buyToken.add(buyBonus));
308         
309         // Referral bonus
310         balanceTokens[referrerAddr] = balanceTokens[referrerAddr].add(refToken);
311         refTokens[referrerAddr] = refTokens[referrerAddr].add(refToken);
312         tokenReward.transfer(referrerAddr, refToken);
313     }
314     
315     /// @notice Send all tokens to Owner after ICO
316     function sendAllTokensToOwner(uint256 _revardTokens) onlyOwner public {
317         tokenReward.transfer(owner, _revardTokens);
318     }
319 }