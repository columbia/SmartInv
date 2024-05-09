1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (_a == 0) {
17       return 0;
18     }
19 
20     uint256 c = _a * _b;
21     require(c / _a == _b);
22 
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28   */
29   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
30     require(_b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = _a / _b;
32     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
41     require(_b <= _a);
42     uint256 c = _a - _b;
43 
44     return c;
45   }
46 
47   /**
48   * @dev Adds two numbers, reverts on overflow.
49   */
50   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
51     uint256 c = _a + _b;
52     require(c >= _a);
53 
54     return c;
55   }
56 
57   /**
58   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59   * reverts when dividing by zero.
60   */
61   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b != 0);
63     return a % b;
64   }
65 }
66 
67 /**
68  * @title Ownable
69  * @dev The Ownable contract has an owner address, and provides basic authorization control
70  * functions, this simplifies the implementation of "user permissions".
71  */
72 contract Ownable {
73   address public owner;
74 
75 
76   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
77 
78 
79   /**
80    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
81    * account.
82    */
83   constructor() public {
84     owner = msg.sender;
85   }
86 
87 
88   /**
89    * @dev Throws if called by any account other than the owner.
90    */
91   modifier onlyOwner() {
92     require(msg.sender == owner);
93     _;
94   }
95 
96 
97   /**
98    * @dev Allows the current owner to transfer control of the contract to a newOwner.
99    * @param newOwner The address to transfer ownership to.
100    */
101   function transferOwnership(address newOwner) onlyOwner public {
102     require(newOwner != address(0));
103     emit OwnershipTransferred(owner, newOwner);
104     owner = newOwner;
105   }
106 }
107 
108 interface token { 
109   function transfer(address, uint) external returns (bool);
110   function transferFrom(address, address, uint) external returns (bool); 
111   function allowance(address, address) external constant returns (uint256);
112   function balanceOf(address) external constant returns (uint256);
113 }
114 
115 /** LOGIC DESCRIPTION
116  * 11% fees in and out for ETH
117  * 11% fees in and out for NOVA
118  *
119  * ETH fees split: 
120  * 6% to nova holders
121  * 4% to eth holders
122  * 1% to fixed address
123  * 
124  * NOVA fees split: 
125  * 6% to nova holders
126  * 4% to eth holders
127  * 1% airdrop to a random address based on their nova shares
128  * rules: 
129  * - you need to have both nova and eth to get dividends
130  */
131 
132 contract NovaBox is Ownable {
133   
134   using SafeMath for uint;
135   token tokenReward;
136 
137   
138   constructor() public {
139     tokenReward = token(0x72FBc0fc1446f5AcCC1B083F0852a7ef70a8ec9f);
140   }
141 
142   event AirDrop(address to, uint amount, uint randomTicket);
143 
144   // ether contributions
145   mapping (address => uint) public contributionsEth;
146   // token contributions
147   mapping (address => uint) public contributionsToken;
148 
149   // investors list who have deposited BOTH ether and token
150   mapping (address => uint) public indexes;
151   mapping (uint => address) public addresses;
152   uint256 public lastIndex = 0;
153 
154   function addToList(address sender) private {
155     // if the sender is not in the list
156     if (indexes[sender] == 0) {
157       // add the sender to the list
158       lastIndex++;
159       addresses[lastIndex] = sender;
160       indexes[sender] = lastIndex;
161     }
162   }
163   function removeFromList(address sender) private {
164     // if the sender is in temp eth list 
165     if (indexes[sender] > 0) {
166       // remove the sender from temp eth list
167       addresses[indexes[sender]] = addresses[lastIndex];
168       indexes[addresses[lastIndex]] = indexes[sender];
169       indexes[sender] = 0;
170       delete addresses[lastIndex];
171       lastIndex--;
172     }
173   }
174 
175   // desposit ether
176   function () payable public {
177     
178     uint weiAmount = msg.value;
179     address sender = msg.sender;
180 
181     // number of ether sent must be greater than 0
182     require(weiAmount > 0);
183 
184     uint _89percent = weiAmount.mul(89).div(100);
185     uint _6percent = weiAmount.mul(6).div(100);
186     uint _4percent = weiAmount.mul(4).div(100);
187     uint _1percent = weiAmount.mul(1).div(100);
188 
189 
190     
191 
192 
193     distributeEth(
194       _6percent, // to nova investors
195       _4percent  // to eth investors
196     ); 
197     //1% goes to REX Investors
198     owner.transfer(_1percent);
199 
200     contributionsEth[sender] = contributionsEth[sender].add(_89percent);
201 
202     // if the sender has also deposited tokens, add sender to list
203     if (contributionsToken[sender]>0) addToList(sender);
204   }
205 
206   // withdraw ether
207   function withdrawEth(uint amount) public {
208     address sender = msg.sender;
209     require(amount>0 && contributionsEth[sender] >= amount);
210 
211     uint _89percent = amount.mul(89).div(100);
212     uint _6percent = amount.mul(6).div(100);
213     uint _4percent = amount.mul(4).div(100);
214     uint _1percent = amount.mul(1).div(100);
215 
216     contributionsEth[sender] = contributionsEth[sender].sub(amount);
217 
218     // if the sender has withdrawn all their eth
219       // remove the sender from list
220     if (contributionsEth[sender] == 0) removeFromList(sender);
221 
222     sender.transfer(_89percent);
223     distributeEth(
224       _6percent, // to nova investors
225       _4percent  // to eth investors
226     );
227     owner.transfer(_1percent);
228   }
229 
230   // deposit tokens
231   function depositTokens(address randomAddr, uint randomTicket) public {
232    
233 
234     address sender = msg.sender;
235     uint amount = tokenReward.allowance(sender, address(this));
236     
237     // number of allowed tokens must be greater than 0
238     // if it is then transfer the allowed tokens from sender to the contract
239     // if not transferred then throw
240     require(amount>0 && tokenReward.transferFrom(sender, address(this), amount));
241 
242 
243     uint _89percent = amount.mul(89).div(100);
244     uint _6percent = amount.mul(6).div(100);
245     uint _4percent = amount.mul(4).div(100);
246     uint _1percent = amount.mul(1).div(100);
247     
248     
249 
250     distributeTokens(
251       _6percent, // to nova investors
252       _4percent  // to eth investors
253       );
254     tokenReward.transfer(randomAddr, _1percent);
255     // 1% for Airdrop
256     emit AirDrop(randomAddr, _1percent, randomTicket);
257 
258     contributionsToken[sender] = contributionsToken[sender].add(_89percent);
259     // if the sender has also contributed ether add sender to list
260     if (contributionsEth[sender]>0) addToList(sender);
261   }
262 
263   // withdraw tokens
264   function withdrawTokens(uint amount, address randomAddr, uint randomTicket) public {
265     address sender = msg.sender;
266     // requested amount must be greater than 0 and 
267     // the sender must have contributed tokens no less than `amount`
268     require(amount>0 && contributionsToken[sender]>=amount);
269 
270     uint _89percent = amount.mul(89).div(100);
271     uint _6percent = amount.mul(6).div(100);
272     uint _4percent = amount.mul(4).div(100);
273     uint _1percent = amount.mul(1).div(100);
274 
275     contributionsToken[sender] = contributionsToken[sender].sub(amount);
276 
277     // if sender withdrawn all their tokens, remove them from list
278     if (contributionsToken[sender] == 0) removeFromList(sender);
279 
280     tokenReward.transfer(sender, _89percent);
281     distributeTokens(
282       _6percent, // to nova investors
283       _4percent  // to eth investors
284     );
285     // airdropToRandom(_1percent);  
286     tokenReward.transfer(randomAddr, _1percent);
287     emit AirDrop(randomAddr, _1percent, randomTicket);
288   }
289 
290   function distributeTokens(uint _6percent, uint _4percent) private {
291     uint totalTokens = getTotalTokens();
292     uint totalWei = getTotalWei();
293 
294     // loop over investors (`holders`) list
295     for (uint i = 1; i <= lastIndex; i++) {
296 
297       address holder = addresses[i];
298       // `holder` will get part of 6% fee based on their token shares
299       uint _rewardTokens = contributionsToken[holder].mul(_6percent).div(totalTokens);
300       // `holder` will get part of 4% fee based on their ether shares
301       uint _rewardWei = contributionsEth[holder].mul(_4percent).div(totalWei);
302       // Transfer tokens equal to the sum of the fee parts to `holder`
303       tokenReward.transfer(holder,_rewardTokens.add(_rewardWei));
304     }
305   }
306 
307   function distributeEth(uint _6percent, uint _4percent) private {
308     uint totalTokens = getTotalTokens();
309     uint totalWei = getTotalWei();
310 
311     // loop over investors (`holders`) list
312     for (uint i = 1; i <= lastIndex; i++) {
313       address holder = addresses[i];
314       // `holder` will get part of 6% fee based on their token shares
315       uint _rewardTokens = contributionsToken[holder].mul(_6percent).div(totalTokens);
316       // `holder` will get part of 4% fee based on their ether shares
317       uint _rewardWei = contributionsEth[holder].mul(_4percent).div(totalWei);
318       // Transfer ether equal to the sum of the fee parts to `holder`
319       holder.transfer(_rewardTokens.add(_rewardWei));
320     }
321   }
322 
323 
324   // get sum of tokens contributed by the ether investors
325   function getTotalTokens() public view returns (uint) {
326     uint result;
327     for (uint i = 1; i <= lastIndex; i++) {
328       result = result.add(contributionsToken[addresses[i]]);
329     }
330     return result;
331   }
332 
333   // get the sum of wei contributed by the token investors
334   function getTotalWei() public view returns (uint) {
335     uint result;
336     for (uint i = 1; i <= lastIndex; i++) {
337       result = result.add(contributionsEth[addresses[i]]);
338     }
339     return result;
340   }
341 
342 
343   // get the list of investors
344   function getList() public view returns (address[], uint[]) {
345     address[] memory _addrs = new address[](lastIndex);
346     uint[] memory _contributions = new uint[](lastIndex);
347 
348     for (uint i = 1; i <= lastIndex; i++) {
349       _addrs[i-1] = addresses[i];
350       _contributions[i-1] = contributionsToken[addresses[i]];
351     }
352     return (_addrs, _contributions);
353   }
354 
355 
356 
357 }