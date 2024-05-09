1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
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
20   function allowance(address owner, address spender) public view returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27  * @title Ownable
28  * @dev The Ownable contract has an owner address, and provides basic authorization control
29  * functions, this simplifies the implementation of "user permissions".
30  */
31 contract Ownable {
32   address public owner;
33 
34 
35   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37 
38   /**
39    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
40    * account.
41    */
42   function Ownable() public {
43     owner = msg.sender;
44   }
45 
46   /**
47    * @dev Throws if called by any account other than the owner.
48    */
49   modifier onlyOwner() {
50     require(msg.sender == owner);
51     _;
52   }
53 
54   /**
55    * @dev Allows the current owner to transfer control of the contract to a newOwner.
56    * @param newOwner The address to transfer ownership to.
57    */
58   function transferOwnership(address newOwner) public onlyOwner {
59     require(newOwner != address(0));
60     OwnershipTransferred(owner, newOwner);
61     owner = newOwner;
62   }
63 
64 }
65 
66 /**
67  * @title SafeMath
68  * @dev Math operations with safety checks that throw on error
69  */
70 library SafeMath {
71 
72   /**
73   * @dev Multiplies two numbers, throws on overflow.
74   */
75   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76     if (a == 0) {
77       return 0;
78     }
79     uint256 c = a * b;
80     assert(c / a == b);
81     return c;
82   }
83 
84   /**
85   * @dev Integer division of two numbers, truncating the quotient.
86   */
87   function div(uint256 a, uint256 b) internal pure returns (uint256) {
88     // assert(b > 0); // Solidity automatically throws when dividing by 0
89     uint256 c = a / b;
90     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
91     return c;
92   }
93 
94   /**
95   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
96   */
97   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
98     assert(b <= a);
99     return a - b;
100   }
101 
102   /**
103   * @dev Adds two numbers, throws on overflow.
104   */
105   function add(uint256 a, uint256 b) internal pure returns (uint256) {
106     uint256 c = a + b;
107     assert(c >= a);
108     return c;
109   }
110 }
111 
112 contract SelfllerySaleFoundation is Ownable {
113     using SafeMath for uint;
114 
115     // Amount of Ether paid from each address
116     mapping (address => uint) public paidEther;
117     // Pre-sale participant tokens for each address
118     mapping (address => uint) public preSaleParticipantTokens;
119     // Number of tokens was sent during the ICO for each address
120     mapping (address => uint) public sentTokens;
121 
122     // SELFLLERY PTE LTD (manager wallet)
123     address public selflleryManagerWallet;
124     // The token contract used for this ICO
125     ERC20 public token;
126     // Number of cents for 1 YOU
127     uint public tokenCents;
128     // The token price from 1 wei
129     uint public tokenPriceWei;
130     // Number of tokens in cents for sale
131     uint public saleTokensCents;
132 
133     // The amount purchased tokens at the moment
134     uint public currentCapTokens;
135     // The amount of Ether raised at the moment
136     uint public currentCapEther;
137     // Start date of the ICO
138     uint public startDate;
139     // End date of bonus time
140     uint public bonusEndDate;
141     // End date of the ICO
142     uint public endDate;
143     // Hard cap of tokens
144     uint public hardCapTokens;
145     // The minimum purchase for user
146     uint public minimumPurchaseAmount;
147     // The bonus percent for purchase first 48 hours
148     uint8 public bonusPercent;
149 
150     event PreSalePurchase(address indexed purchasedBy, uint amountTokens);
151 
152     event Purchase(address indexed purchasedBy, uint amountTokens, uint etherWei);
153 
154     /**
155     * @dev Throws if date isn't between ICO dates.
156     */
157     modifier onlyDuringICODates() {
158         require(now >= startDate && now <= endDate);
159         _;
160     }
161 
162     /**
163      * @dev Initialize the ICO contract
164     */
165     function SelfllerySaleFoundation(
166         address _token,
167         address _selflleryManagerWallet,
168         uint _tokenCents,
169         uint _tokenPriceWei,
170         uint _saleTokensCents,
171         uint _startDate,
172         uint _bonusEndDate,
173         uint _endDate,
174         uint _hardCapTokens,
175         uint _minimumPurchaseAmount,
176         uint8 _bonusPercent
177     )
178         public
179         Ownable()
180     {
181         token = ERC20(_token);
182         selflleryManagerWallet = _selflleryManagerWallet;
183         tokenCents = _tokenCents;
184         tokenPriceWei = _tokenPriceWei;
185         saleTokensCents = _saleTokensCents;
186         startDate = _startDate;
187         bonusEndDate = _bonusEndDate;
188         endDate = _endDate;
189         hardCapTokens = _hardCapTokens;
190         minimumPurchaseAmount = _minimumPurchaseAmount;
191         bonusPercent = _bonusPercent;
192     }
193 
194     /**
195      * @dev Purchase tokens for the amount of ether sent to this contract
196      */
197     function () public payable {
198         purchase();
199     }
200 
201     /**
202      * @dev Purchase tokens for the amount of ether sent to this contract
203      * @return A boolean that indicates if the operation was successful.
204      */
205     function purchase() public payable returns(bool) {
206         return purchaseFor(msg.sender);
207     }
208 
209     /**
210      * @dev Purchase tokens for the amount of ether sent to this contract for custom address
211      * @param _participant The address of the participant
212      * @return A boolean that indicates if the operation was successful.
213      */
214     function purchaseFor(address _participant) public payable onlyDuringICODates() returns(bool) {
215         require(_participant != 0x0);
216         require(paidEther[_participant].add(msg.value) >= minimumPurchaseAmount);
217 
218         selflleryManagerWallet.transfer(msg.value);
219 
220         uint currentBonusPercent = getCurrentBonusPercent();
221         uint totalTokens = calcTotalTokens(msg.value, currentBonusPercent);
222         require(currentCapTokens.add(totalTokens) <= saleTokensCents);
223         require(token.transferFrom(owner, _participant, totalTokens));
224         sentTokens[_participant] = sentTokens[_participant].add(totalTokens);
225         currentCapTokens = currentCapTokens.add(totalTokens);
226         currentCapEther = currentCapEther.add(msg.value);
227         paidEther[_participant] = paidEther[_participant].add(msg.value);
228         Purchase(_participant, totalTokens, msg.value);
229 
230         return true;
231     }
232 
233     /**
234      * @dev Change minimum purchase amount any time only owner
235      * @param _newMinimumPurchaseAmount New minimum puchase amount
236      * @return A boolean that indicates if the operation was successful.
237      */
238     function changeMinimumPurchaseAmount(uint _newMinimumPurchaseAmount) public onlyOwner returns(bool) {
239         require(_newMinimumPurchaseAmount >= 0);
240         minimumPurchaseAmount = _newMinimumPurchaseAmount;
241         return true;
242     }
243 
244     /**
245      * @dev Add pre-sale purchased tokens only owner
246      * @param _participant The address of the participant
247      * @param _totalTokens Total tokens amount for pre-sale participant
248      * @return A boolean that indicates if the operation was successful.
249      */
250     function addPreSalePurchaseTokens(address _participant, uint _totalTokens) public onlyOwner returns(bool) {
251         require(_participant != 0x0);
252         require(_totalTokens > 0);
253         require(currentCapTokens.add(_totalTokens) <= saleTokensCents);
254 
255         require(token.transferFrom(owner, _participant, _totalTokens));
256         sentTokens[_participant] = sentTokens[_participant].add(_totalTokens);
257         preSaleParticipantTokens[_participant] = preSaleParticipantTokens[_participant].add(_totalTokens);
258         currentCapTokens = currentCapTokens.add(_totalTokens);
259         PreSalePurchase(_participant, _totalTokens);
260         return true;
261     }
262 
263     /**
264      * @dev Is finish date ICO reached?
265      * @return A boolean that indicates if finish date ICO reached.
266      */
267     function isFinishDateReached() public constant returns(bool) {
268         return endDate <= now;
269     }
270 
271     /**
272      * @dev Is hard cap tokens reached?
273      * @return A boolean that indicates if hard cap tokens reached.
274      */
275     function isHardCapTokensReached() public constant returns(bool) {
276         return hardCapTokens <= currentCapTokens;
277     }
278 
279     /**
280      * @dev Is ICO Finished?
281      * @return A boolean that indicates if ICO finished.
282      */
283     function isIcoFinished() public constant returns(bool) {
284         return isFinishDateReached() || isHardCapTokensReached();
285     }
286 
287     /**
288      * @dev Calc total tokens for fixed value and bonus percent
289      * @param _value Amount of ether
290      * @param _bonusPercent Bonus percent
291      * @return uint
292      */
293     function calcTotalTokens(uint _value, uint _bonusPercent) internal view returns(uint) {
294         uint tokensAmount = _value.mul(tokenCents).div(tokenPriceWei);
295         require(tokensAmount > 0);
296         uint bonusTokens = tokensAmount.mul(_bonusPercent).div(100);
297         uint totalTokens = tokensAmount.add(bonusTokens);
298         return totalTokens;
299     }
300 
301     /**
302      * @dev Get current bonus percent for this transaction
303      * @return uint
304      */
305     function getCurrentBonusPercent() internal constant returns (uint) {
306         uint currentBonusPercent;
307         if (now <= bonusEndDate) {
308             currentBonusPercent = bonusPercent;
309         } else {
310             currentBonusPercent = 0;
311         }
312         return currentBonusPercent;
313     }
314 }
315 
316 contract SelfllerySale is SelfllerySaleFoundation {
317     address constant TOKEN_ADDRESS = 0x7e921CA9b78d9A6cCC39891BA545836365525C06; // Token YOU
318     address constant SELFLLERY_MANAGER_WALLET = 0xdABb398298192192e5d4Ed2f120Ff7Af312B06eb;// SELFLLERY PTE LTD
319     uint constant TOKEN_CENTS = 1e18;
320     uint constant TOKEN_PRICE_WEI = 1e15;
321     uint constant SALE_TOKENS_CENTS = 55000000 * TOKEN_CENTS;
322     uint constant SALE_HARD_CAP_TOKENS = 55000000 * TOKEN_CENTS;
323 
324     uint8 constant BONUS_PERCENT = 5;
325     uint constant MINIMUM_PURCHASE_AMOUNT = 0.1 ether;
326 
327     uint constant SALE_START_DATE = 1520240400; // 05.03.2018 9:00 UTC
328     uint constant SALE_BONUS_END_DATE = 1520413200; // 07.03.2018 9:00 UTC
329     uint constant SALE_END_DATE = 1522144800; // 27.03.2018 10:00 UTC
330 
331     /**
332      * @dev Initialize the ICO contract
333     */
334     function SelfllerySale()
335         public
336         SelfllerySaleFoundation(
337             TOKEN_ADDRESS,
338             SELFLLERY_MANAGER_WALLET,
339             TOKEN_CENTS,
340             TOKEN_PRICE_WEI,
341             SALE_TOKENS_CENTS,
342             SALE_START_DATE,
343             SALE_BONUS_END_DATE,
344             SALE_END_DATE,
345             SALE_HARD_CAP_TOKENS,
346             MINIMUM_PURCHASE_AMOUNT,
347             BONUS_PERCENT
348         ) {}
349 }