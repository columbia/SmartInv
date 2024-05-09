1 pragma solidity ^0.4.18;
2 
3 // File: contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   /**
34   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: contracts/Dividends.sol
52 
53 contract DividendContract {
54   using SafeMath for uint256;
55   event Dividends(uint256 round, uint256 value);
56   event ClaimDividends(address investor, uint256 value);
57 
58   uint256 totalDividendsAmount = 0;
59   uint256 totalDividendsRounds = 0;
60   uint256 totalUnPayedDividendsAmount = 0;
61   mapping(address => uint256) payedDividends;
62 
63 
64   function getTotalDividendsAmount() public constant returns (uint256) {
65     return totalDividendsAmount;
66   }
67 
68   function getTotalDividendsRounds() public constant returns (uint256) {
69     return totalDividendsRounds;
70   }
71 
72   function getTotalUnPayedDividendsAmount() public constant returns (uint256) {
73     return totalUnPayedDividendsAmount;
74   }
75 
76   function dividendsAmount(address investor) public constant returns (uint256);
77   function claimDividends() payable public;
78 
79   function payDividends() payable public {
80     require(msg.value > 0);
81     totalDividendsAmount = totalDividendsAmount.add(msg.value);
82     totalUnPayedDividendsAmount = totalUnPayedDividendsAmount.add(msg.value);
83     totalDividendsRounds += 1;
84     Dividends(totalDividendsRounds, msg.value);
85   }
86 }
87 
88 // File: contracts/token/ERC20/ERC20Basic.sol
89 
90 /**
91  * @title ERC20Basic
92  * @dev Simpler version of ERC20 interface
93  * @dev see https://github.com/ethereum/EIPs/issues/179
94  */
95 contract ERC20Basic {
96   function totalSupply() public view returns (uint256);
97   function balanceOf(address who) public view returns (uint256);
98   function transfer(address to, uint256 value) public returns (bool);
99   event Transfer(address indexed from, address indexed to, uint256 value);
100 }
101 
102 // File: contracts/token/ERC20/ERC20.sol
103 
104 /**
105  * @title ERC20 interface
106  * @dev see https://github.com/ethereum/EIPs/issues/20
107  */
108 contract ERC20 is ERC20Basic {
109   function allowance(address owner, address spender) public view returns (uint256);
110   function transferFrom(address from, address to, uint256 value) public returns (bool);
111   function approve(address spender, uint256 value) public returns (bool);
112   event Approval(address indexed owner, address indexed spender, uint256 value);
113 }
114 
115 // File: contracts/ESlotsICOToken.sol
116 
117 contract ESlotsICOToken is ERC20, DividendContract {
118 
119     string public constant name = "Ethereum Slot Machine Token";
120     string public constant symbol = "EST";
121     uint8 public constant decimals = 18;
122 
123     function maxTokensToSale() public view returns (uint256);
124     function availableTokens() public view returns (uint256);
125     function completeICO() public;
126     function connectCrowdsaleContract(address crowdsaleContract) public;
127 }
128 
129 // File: contracts/ESlotsICOTokenDeployed.sol
130 
131 contract ESlotsICOTokenDeployed {
132 
133     // address of token contract (for dividend payments)
134     address internal tokenContractAddress;
135     ESlotsICOToken icoContract;
136 
137     function ESlotsICOTokenDeployed(address tokenContract) public {
138         require(tokenContract != address(0));
139         tokenContractAddress = tokenContract;
140         icoContract = ESlotsICOToken(tokenContractAddress);
141     }
142 }
143 
144 // File: contracts/ownership/Ownable.sol
145 
146 /**
147  * @title Ownable
148  * @dev The Ownable contract has an owner address, and provides basic authorization control
149  * functions, this simplifies the implementation of "user permissions".
150  */
151 contract Ownable {
152   address public owner;
153 
154 
155   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
156 
157 
158   /**
159    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
160    * account.
161    */
162   function Ownable() public {
163     owner = msg.sender;
164   }
165 
166   /**
167    * @dev Throws if called by any account other than the owner.
168    */
169   modifier onlyOwner() {
170     require(msg.sender == owner);
171     _;
172   }
173 
174   /**
175    * @dev Allows the current owner to transfer control of the contract to a newOwner.
176    * @param newOwner The address to transfer ownership to.
177    */
178   function transferOwnership(address newOwner) public onlyOwner {
179     require(newOwner != address(0));
180     OwnershipTransferred(owner, newOwner);
181     owner = newOwner;
182   }
183 
184 }
185 
186 // File: contracts/ESlotsCrowdsale.sol
187 
188 contract ESlotsCrowdsale is Ownable, ESlotsICOTokenDeployed {
189     using SafeMath for uint256;
190 
191     enum State { PrivatePreSale, PreSale, ActiveICO, ICOComplete }
192     State public state;
193 
194     // start and end timestamps for dates when investments are allowed (both inclusive)
195     uint256 public startTime;
196     uint256 public endTime;
197 
198     // address for funds collecting
199     address public wallet = 0x7b97B31E12f7d029769c53cB91c83d29611A4F7A;
200 
201     // how many token units a buyer gets per wei
202     uint256 public rate = 1000; //base price: 1 EST token costs 0.001 Ether
203 
204     // amount of raised money in wei
205     uint256 public weiRaised;
206 
207     mapping (address => uint256) public privateInvestors;
208 
209     /**
210    * event for token purchase logging
211    * @param purchaser who paid for the tokens
212    * @param beneficiary who got the tokens
213    * @param value weis paid for purchase
214    * @param amount amount of tokens purchased
215    */
216     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
217 
218     function ESlotsCrowdsale(address tokenContract) public
219     ESlotsICOTokenDeployed(tokenContract)
220     {
221         state = State.PrivatePreSale;
222         startTime = 0;
223         endTime = 0;
224         weiRaised = 0;
225         //do not forget to call
226         //icoContract.connectCrowdsaleContract(this);
227     }
228 
229     // fallback function can be used to buy tokens
230     function () external payable {
231         buyTokens(msg.sender);
232     }
233 
234     // low level token purchase function
235     function buyTokens(address beneficiary) public payable {
236         require(beneficiary != address(0));
237         require(validPurchase());
238 
239 
240         uint256 weiAmount = msg.value;
241         // calculate amount of tokens to be created
242         uint256 tokens = getTokenAmount(weiAmount);
243         uint256 av_tokens = icoContract.availableTokens();
244         require(av_tokens >= tokens);
245         if(state == State.PrivatePreSale) {
246             require(privateInvestors[beneficiary] > 0);
247             //restrict sales in private period
248             if(privateInvestors[beneficiary] < tokens) {
249                 tokens = privateInvestors[beneficiary];
250             }
251         }
252             // update state
253         weiRaised = weiRaised.add(weiAmount);
254         //we can get only 75% to development, 25% will be unlocked after 2 months to fill out casino contract bankroll
255         wallet.transfer(percents(weiAmount, 75));
256         icoContract.transferFrom(owner, beneficiary, tokens);
257         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
258     }
259 
260     function addPrivateInvestor(address beneficiary, uint256 value) public onlyOwner {
261         require(state == State.PrivatePreSale);
262         privateInvestors[beneficiary] = privateInvestors[beneficiary].add(value);
263     }
264 
265     function startPreSale() public onlyOwner {
266         require(state == State.PrivatePreSale);
267         state = State.PreSale;
268     }
269 
270     function startICO() public onlyOwner {
271         require(state == State.PreSale);
272         state = State.ActiveICO;
273         startTime = now;
274         endTime = startTime + 7 weeks;
275     }
276 
277     function stopICO() public onlyOwner {
278         require(state == State.ActiveICO);
279         require(icoContract.availableTokens() == 0 || (endTime > 0 && now >= endTime));
280         require(weiRaised > 0);
281         state = State.ICOComplete;
282         endTime = now;
283     }
284 
285     // Allow getting slots bankroll after 60 days only
286     function cleanup() public onlyOwner {
287         require(state == State.ICOComplete);
288         require(now >= (endTime + 60 days));
289         wallet.transfer(this.balance);
290     }
291 
292     // @return true if crowdsale ended
293     function hasEnded() public view returns (bool) {
294         return state == State.ICOComplete || icoContract.availableTokens() == 0 || (endTime > 0 && now >= endTime);
295     }
296 
297     // Calculate amount of tokens depending on crowdsale phase and time
298     function getTokenAmount(uint256 weiAmount) public view returns(uint256) {
299         uint256 totalTokens = weiAmount.mul(rate);
300         uint256 bonus = getLargeAmountBonus(weiAmount);
301         if(state == State.PrivatePreSale ||  state == State.PreSale) {
302             //PreSale has 50% bonus!
303             bonus = bonus.add(50);
304         } else if(state == State.ActiveICO) {
305             if((now - startTime) < 1 weeks) {
306                 //30% first week
307                 bonus = bonus.add(30);
308             } else if((now - startTime) < 3 weeks) {
309                 //15% second and third weeks
310                 bonus = bonus.add(15);
311             }
312         }
313         return addPercents(totalTokens, bonus);
314     }
315 
316     function addPercents(uint256 amount, uint256 percent) internal pure returns(uint256) {
317         if(percent == 0) return amount;
318         return amount.add(percents(amount, percent));
319     }
320 
321     function percents(uint256 amount, uint256 percent) internal pure returns(uint256) {
322         if(percent == 0) return 0;
323         return amount.mul(percent).div(100);
324     }
325 
326     function getLargeAmountBonus(uint256 weiAmount) internal pure returns(uint256) {
327         if(weiAmount >= 1000 ether) {
328             return 50;
329         }
330         if(weiAmount >= 500 ether) {
331             return 30;
332         }
333         if(weiAmount >= 100 ether) {
334             return 15;
335         }
336         if(weiAmount >= 50 ether) {
337             return 10;
338         }
339         if(weiAmount >= 10 ether) {
340             return 5;
341         }
342        return 0;
343     }
344 
345     // return true if the transaction is suitable for buying tokens
346     function validPurchase() internal view returns (bool) {
347         bool nonZeroPurchase = msg.value != 0;
348         return hasEnded() == false && nonZeroPurchase;
349     }
350 
351 }