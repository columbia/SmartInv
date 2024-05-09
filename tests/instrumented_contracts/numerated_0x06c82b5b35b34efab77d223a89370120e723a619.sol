1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47     c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 /// @title Role based access control mixin for Rasmart Platform
54 /// @author Mai Abha <maiabha82@gmail.com>
55 /// @dev Ignore DRY approach to achieve readability
56 contract RBACMixin {
57   /// @notice Constant string message to throw on lack of access
58   string constant FORBIDDEN = "Haven't enough right to access";
59   /// @notice Public map of owners
60   mapping (address => bool) public owners;
61   /// @notice Public map of minters
62   mapping (address => bool) public minters;
63 
64   /// @notice The event indicates the addition of a new owner
65   /// @param who is address of added owner
66   event AddOwner(address indexed who);
67   /// @notice The event indicates the deletion of an owner
68   /// @param who is address of deleted owner
69   event DeleteOwner(address indexed who);
70 
71   /// @notice The event indicates the addition of a new minter
72   /// @param who is address of added minter
73   event AddMinter(address indexed who);
74   /// @notice The event indicates the deletion of a minter
75   /// @param who is address of deleted minter
76   event DeleteMinter(address indexed who);
77 
78   constructor () public {
79     _setOwner(msg.sender, true);
80   }
81 
82   /// @notice The functional modifier rejects the interaction of senders who are not owners
83   modifier onlyOwner() {
84     require(isOwner(msg.sender), FORBIDDEN);
85     _;
86   }
87 
88   /// @notice Functional modifier for rejecting the interaction of senders that are not minters
89   modifier onlyMinter() {
90     require(isMinter(msg.sender), FORBIDDEN);
91     _;
92   }
93 
94   /// @notice Look up for the owner role on providen address
95   /// @param _who is address to look up
96   /// @return A boolean of owner role
97   function isOwner(address _who) public view returns (bool) {
98     return owners[_who];
99   }
100 
101   /// @notice Look up for the minter role on providen address
102   /// @param _who is address to look up
103   /// @return A boolean of minter role
104   function isMinter(address _who) public view returns (bool) {
105     return minters[_who];
106   }
107 
108   /// @notice Adds the owner role to provided address
109   /// @dev Requires owner role to interact
110   /// @param _who is address to add role
111   /// @return A boolean that indicates if the operation was successful.
112   function addOwner(address _who) public onlyOwner returns (bool) {
113     _setOwner(_who, true);
114   }
115 
116   /// @notice Deletes the owner role to provided address
117   /// @dev Requires owner role to interact
118   /// @param _who is address to delete role
119   /// @return A boolean that indicates if the operation was successful.
120   function deleteOwner(address _who) public onlyOwner returns (bool) {
121     _setOwner(_who, false);
122   }
123 
124   /// @notice Adds the minter role to provided address
125   /// @dev Requires owner role to interact
126   /// @param _who is address to add role
127   /// @return A boolean that indicates if the operation was successful.
128   function addMinter(address _who) public onlyOwner returns (bool) {
129     _setMinter(_who, true);
130   }
131 
132   /// @notice Deletes the minter role to provided address
133   /// @dev Requires owner role to interact
134   /// @param _who is address to delete role
135   /// @return A boolean that indicates if the operation was successful.
136   function deleteMinter(address _who) public onlyOwner returns (bool) {
137     _setMinter(_who, false);
138   }
139 
140   /// @notice Changes the owner role to provided address
141   /// @param _who is address to change role
142   /// @param _flag is next role status after success
143   /// @return A boolean that indicates if the operation was successful.
144   function _setOwner(address _who, bool _flag) private returns (bool) {
145     require(owners[_who] != _flag);
146     owners[_who] = _flag;
147     if (_flag) {
148       emit AddOwner(_who);
149     } else {
150       emit DeleteOwner(_who);
151     }
152     return true;
153   }
154 
155   /// @notice Changes the minter role to provided address
156   /// @param _who is address to change role
157   /// @param _flag is next role status after success
158   /// @return A boolean that indicates if the operation was successful.
159   function _setMinter(address _who, bool _flag) private returns (bool) {
160     require(minters[_who] != _flag);
161     minters[_who] = _flag;
162     if (_flag) {
163       emit AddMinter(_who);
164     } else {
165       emit DeleteMinter(_who);
166     }
167     return true;
168   }
169 }
170 
171 interface IMintableToken {
172   function mint(address _to, uint256 _amount) external returns (bool);
173 }
174 
175 
176 /// @title Very simplified implementation of Token Bucket Algorithm to secure token minting
177 /// @author Mai Abha <maiabha82@gmail.com>
178 /// @notice Works with tokens implemented Mintable interface
179 /// @dev Transfer ownership/minting role to contract and execute mint over ICOBucket proxy to secure
180 contract ICOBucket is RBACMixin {
181   using SafeMath for uint;
182 
183   /// @notice Limit maximum amount of available for minting tokens when bucket is full
184   /// @dev Should be enough to mint tokens with proper speed but less enough to prevent overminting in case of losing pkey
185   uint256 public size;
186   /// @notice Bucket refill rate
187   /// @dev Tokens per second (based on block.timestamp). Amount without decimals (in smallest part of token)
188   uint256 public rate;
189   /// @notice Stored time of latest minting
190   /// @dev Each successful call of minting function will update field with call timestamp
191   uint256 public lastMintTime;
192   /// @notice Left tokens in bucket on time of latest minting
193   uint256 public leftOnLastMint;
194 
195   /// @notice Reference of Mintable token
196   /// @dev Setup in contructor phase and never change in future
197   IMintableToken public token;
198 
199   /// @notice Token Bucket leak event fires on each minting
200   /// @param to is address of target tokens holder
201   /// @param left is amount of tokens available in bucket after leak
202   event Leak(address indexed to, uint256 left);
203 
204   /// ICO SECTION
205   /// @notice A token price
206   uint256 public tokenCost;
207 
208   /// @notice Allow only whitelisted wallets to purchase
209   mapping(address => bool) public whiteList;
210 
211   /// @notice Main wallet all funds are transferred to
212   address public wallet;
213 
214   /// @notice Main wallet all funds are transferred to
215   uint256 public bonus;
216 
217   /// @notice Minimum amount of tokens can be purchased
218   uint256 public minimumTokensForPurchase;
219 
220   /// @notice A helper
221   modifier onlyWhiteList {
222       require(whiteList[msg.sender]);
223       _;
224   }
225   /// END ICO SECTION
226 
227   /// @param _token is address of Mintable token
228   /// @param _size initial size of token bucket
229   /// @param _rate initial refill rate (tokens/sec)
230   constructor (address _token, uint256 _size, uint256 _rate, uint256 _cost, address _wallet, uint256 _bonus, uint256 _minimum) public {
231     token = IMintableToken(_token);
232     size = _size;
233     rate = _rate;
234     leftOnLastMint = _size;
235     tokenCost = _cost;
236     wallet = _wallet;
237     bonus = _bonus;
238     minimumTokensForPurchase = _minimum;
239   }
240 
241   /// @notice Change size of bucket
242   /// @dev Require owner role to call
243   /// @param _size is new size of bucket
244   /// @return A boolean that indicates if the operation was successful.
245   function setSize(uint256 _size) public onlyOwner returns (bool) {
246     size = _size;
247     return true;
248   }
249 
250   /// @notice Change refill rate of bucket
251   /// @dev Require owner role to call
252   /// @param _rate is new refill rate of bucket
253   /// @return A boolean that indicates if the operation was successful.
254   function setRate(uint256 _rate) public onlyOwner returns (bool) {
255     rate = _rate;
256     return true;
257   }
258 
259   /// @notice Change size and refill rate of bucket
260   /// @dev Require owner role to call
261   /// @param _size is new size of bucket
262   /// @param _rate is new refill rate of bucket
263   /// @return A boolean that indicates if the operation was successful.
264   function setSizeAndRate(uint256 _size, uint256 _rate) public onlyOwner returns (bool) {
265     return setSize(_size) && setRate(_rate);
266   }
267 
268   /// @notice Function to calculate and get available in bucket tokens
269   /// @return An amount of available tokens in bucket
270   function availableTokens() public view returns (uint) {
271      // solium-disable-next-line security/no-block-members
272     uint256 timeAfterMint = now.sub(lastMintTime);
273     uint256 refillAmount = rate.mul(timeAfterMint).add(leftOnLastMint);
274     return size < refillAmount ? size : refillAmount;
275   }
276 
277   /// ICO METHODS
278   function addToWhiteList(address _address) public onlyMinter {
279     whiteList[_address] = true;
280   }
281 
282   function removeFromWhiteList(address _address) public onlyMinter {
283     whiteList[_address] = false;
284   }
285 
286   function setWallet(address _wallet) public onlyOwner {
287     wallet = _wallet;
288   }
289 
290   function setBonus(uint256 _bonus) public onlyOwner {
291     bonus = _bonus;
292   }
293 
294   function setMinimumTokensForPurchase(uint256 _minimum) public onlyOwner {
295     minimumTokensForPurchase = _minimum;
296   }
297 
298   function setTokenCost(uint256 _tokencost) public onlyOwner {
299     tokenCost = _tokencost;
300   }
301 
302   /// @notice Purchase function mints tokens
303   /// @return A boolean that indicates if the operation was successful.
304   function () public payable onlyWhiteList {
305     uint256 tokensAmount = tokensAmountForPurchase();
306     uint256 available = availableTokens();
307     uint256 minimum = minimumTokensForPurchase;
308     require(tokensAmount <= available);
309     require(tokensAmount >= minimum);
310     // transfer all funcds to external multisig wallet
311     wallet.transfer(msg.value);
312     leftOnLastMint = available.sub(tokensAmount);
313     lastMintTime = now; // solium-disable-line security/no-block-members
314     require(token.mint(msg.sender, tokensAmount));
315   }
316 
317   function tokensAmountForPurchase() private constant returns(uint256) {
318     return msg.value.mul(10 ** 18)
319                     .div(tokenCost)
320                     .mul(100 + bonus)
321                     .div(100);
322   }
323 }