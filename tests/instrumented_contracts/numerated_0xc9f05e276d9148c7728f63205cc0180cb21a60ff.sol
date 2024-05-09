1 pragma solidity ^0.4.18;
2 
3 // File: contracts/commons/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     uint256 c = a / b;
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 // File: contracts/flavours/Ownable.sol
37 
38 /**
39  * @title Ownable
40  * @dev The Ownable contract has an owner address, and provides basic authorization control
41  * functions, this simplifies the implementation of "user permissions".
42  */
43 contract Ownable {
44   address public owner;
45 
46   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48   /**
49    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
50    * account.
51    */
52   function Ownable() public {
53     owner = msg.sender;
54   }
55 
56   /**
57    * @dev Throws if called by any account other than the owner.
58    */
59   modifier onlyOwner() {
60     require(msg.sender == owner);
61     _;
62   }
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) public onlyOwner {
69     require(newOwner != address(0));
70     OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 }
74 
75 // File: contracts/flavours/Lockable.sol
76 
77 /**
78  * @title Lockable
79  * @dev Base contract which allows children to
80  *      implement main operations locking mechanism.
81  */
82 contract Lockable is Ownable {
83   event Lock();
84   event Unlock();
85 
86   bool public locked = false;
87 
88   /**
89    * @dev Modifier to make a function callable
90   *       only when the contract is not locked.
91    */
92   modifier whenNotLocked() {
93     require(!locked);
94     _;
95   }
96 
97   /**
98    * @dev Modifier to make a function callable
99    *      only when the contract is locked.
100    */
101   modifier whenLocked() {
102     require(locked);
103     _;
104   }
105 
106   /**
107    * @dev called by the owner to locke, triggers locked state
108    */
109   function lock() onlyOwner whenNotLocked public {
110     locked = true;
111     Lock();
112   }
113 
114   /**
115    * @dev called by the owner
116    *      to unlock, returns to unlocked state
117    */
118   function unlock() onlyOwner whenLocked public {
119     locked = false;
120     Unlock();
121   }
122 }
123 
124 // File: contracts/base/BaseFixedERC20Token.sol
125 
126 contract BaseFixedERC20Token is Lockable {
127   using SafeMath for uint;
128 
129   /// @dev ERC20 Total supply
130   uint public totalSupply;
131 
132   mapping(address => uint) balances;
133 
134   mapping(address => mapping (address => uint)) private allowed;
135 
136   /// @dev Fired if Token transferred accourding to ERC20
137   event Transfer(address indexed from, address indexed to, uint value);
138 
139   /// @dev Fired if Token withdraw is approved accourding to ERC20
140   event Approval(address indexed owner, address indexed spender, uint value);
141 
142   /**
143    * @dev Gets the balance of the specified address.
144    * @param owner_ The address to query the the balance of.
145    * @return An uint representing the amount owned by the passed address.
146    */
147   function balanceOf(address owner_) public view returns (uint balance) {
148     return balances[owner_];
149   }
150 
151   /**
152    * @dev Transfer token for a specified address
153    * @param to_ The address to transfer to.
154    * @param value_ The amount to be transferred.
155    */
156   function transfer(address to_, uint value_) whenNotLocked public returns (bool) {
157     require(to_ != address(0) && value_ <= balances[msg.sender]);
158     // SafeMath.sub will throw if there is not enough balance.
159     balances[msg.sender] = balances[msg.sender].sub(value_);
160     balances[to_] = balances[to_].add(value_);
161     Transfer(msg.sender, to_, value_);
162     return true;
163   }
164 
165   /**
166    * @dev Transfer tokens from one address to another
167    * @param from_ address The address which you want to send tokens from
168    * @param to_ address The address which you want to transfer to
169    * @param value_ uint the amount of tokens to be transferred
170    */
171   function transferFrom(address from_, address to_, uint value_) whenNotLocked public returns (bool) {
172     require(to_ != address(0) && value_ <= balances[from_] && value_ <= allowed[from_][msg.sender]);
173     balances[from_] = balances[from_].sub(value_);
174     balances[to_] = balances[to_].add(value_);
175     allowed[from_][msg.sender] = allowed[from_][msg.sender].sub(value_);
176     Transfer(from_, to_, value_);
177     return true;
178   }
179 
180   /**
181    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
182    *
183    * Beware that changing an allowance with this method brings the risk that someone may use both the old
184    * and the new allowance by unfortunate transaction ordering.
185    *
186    * To change the approve amount you first have to reduce the addresses
187    * allowance to zero by calling `approve(spender_, 0)` if it is not
188    * already 0 to mitigate the race condition described in:
189    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
190    *
191    * @param spender_ The address which will spend the funds.
192    * @param value_ The amount of tokens to be spent.
193    */
194   function approve(address spender_, uint value_) whenNotLocked public returns (bool) {
195     if (value_ != 0 && allowed[msg.sender][spender_] != 0) {
196       revert();
197     }
198     allowed[msg.sender][spender_] = value_;
199     Approval(msg.sender, spender_, value_);
200     return true;
201   }
202 
203   /**
204    * @dev Function to check the amount of tokens that an owner allowed to a spender.
205    * @param owner_ address The address which owns the funds.
206    * @param spender_ address The address which will spend the funds.
207    * @return A uint specifying the amount of tokens still available for the spender.
208    */
209   function allowance(address owner_, address spender_) view public returns (uint) {
210     return allowed[owner_][spender_];
211   }
212 }
213 
214 // File: contracts/base/BaseICOToken.sol
215 
216 /**
217  * @dev Not mintable, ERC20 compilant token, distributed by ICO.
218  */
219 contract BaseICOToken is BaseFixedERC20Token {
220 
221   /// @dev Available supply of tokens
222   uint public availableSupply;
223 
224   /// @dev ICO smart contract allowed to distribute public funds for this
225   address public ico;
226 
227   /// @dev Fired if investment for `amount` of tokens performed by `to` address
228   event ICOTokensInvested(address indexed to, uint amount);
229 
230   /// @dev ICO contract changed for this token
231   event ICOChanged(address indexed icoContract);
232 
233   /**
234    * @dev Not mintable, ERC20 compilant token, distributed by ICO.
235    * @param totalSupply_ Total tokens supply.
236    */
237   function BaseICOToken(uint totalSupply_) public {
238     locked = true;
239     totalSupply = totalSupply_;
240     availableSupply = totalSupply_;
241   }
242 
243   /**
244    * @dev Set address of ICO smart-contract which controls token
245    * initial token distribution.
246    * @param ico_ ICO contract address.
247    */
248   function changeICO(address ico_) onlyOwner public {
249     ico = ico_;
250     ICOChanged(ico);
251   }
252 
253   function isValidICOInvestment(address to_, uint amount_) internal view returns(bool) {
254     return msg.sender == ico && to_ != address(0) && amount_ <= availableSupply;
255   }
256 
257   /**
258    * @dev Assign `amount_` of tokens to investor identified by `to_` address.
259    * @param to_ Investor address.
260    * @param amount_ Number of tokens distributed.
261    */
262   function icoInvestment(address to_, uint amount_) public returns (uint) {
263     require(isValidICOInvestment(to_, amount_));
264     availableSupply -= amount_;
265     balances[to_] = balances[to_].add(amount_);
266     ICOTokensInvested(to_, amount_);
267     return amount_;
268   }
269 }
270 
271 // File: contracts/DATOToken.sol
272 
273 contract DATOToken is BaseICOToken {
274     using SafeMath for uint;
275 
276     string public constant name = 'DATO token';
277 
278     string public constant symbol = 'DATO';
279 
280     uint8 public constant decimals = 18;
281 
282     uint internal constant ONE_TOKEN = 1e18;
283 
284     uint public utilityLockedDate;
285 
286     /// @dev Fired some tokens distributed to someone from staff, locked
287     event ReservedTokensDistributed(address indexed to, uint8 group, uint amount);
288 
289     function DATOToken(uint totalSupplyTokens_,
290         uint reservedStaffTokens_,
291         uint reservedUtilityTokens_)
292     BaseICOToken(totalSupplyTokens_ * ONE_TOKEN) public {
293         require(availableSupply == totalSupply);
294         utilityLockedDate = block.timestamp + 1 years;
295         availableSupply = availableSupply
296             .sub(reservedStaffTokens_ * ONE_TOKEN)
297             .sub(reservedUtilityTokens_ * ONE_TOKEN);
298         reserved[RESERVED_STAFF_GROUP] = reservedStaffTokens_ * ONE_TOKEN;
299         reserved[RESERVED_UTILITY_GROUP] = reservedUtilityTokens_ * ONE_TOKEN;
300     }
301 
302     // Disable direct payments
303     function() external payable {
304         revert();
305     }
306 
307     //---------------------------- DATO specific
308 
309     uint8 public RESERVED_STAFF_GROUP = 0x1;
310 
311     uint8 public RESERVED_UTILITY_GROUP = 0x2;
312 
313     /// @dev Token reservation mapping: key(RESERVED_X) => value(number of tokens)
314     mapping(uint8 => uint) public reserved;
315 
316     /**
317      * @dev Get reserved tokens for specific group
318      */
319     function getReservedTokens(uint8 group_) view public returns (uint) {
320         return reserved[group_];
321     }
322 
323     /**
324      * @dev Assign `amount_` of privately distributed tokens
325      *      to someone identified with `to_` address.
326      * @param to_   Tokens owner
327      * @param group_ Group identifier of privately distributed tokens
328      * @param amount_ Number of tokens distributed with decimals part
329      */
330     function assignReserved(address to_, uint8 group_, uint amount_) onlyOwner public {
331         require(to_ != address(0) && (group_ & 0x3) != 0);
332         if (group_ == RESERVED_UTILITY_GROUP) {
333             require(block.timestamp >= utilityLockedDate);
334         }
335 
336         // SafeMath will check reserved[group_] >= amount
337         reserved[group_] = reserved[group_].sub(amount_);
338         balances[to_] = balances[to_].add(amount_);
339         ReservedTokensDistributed(to_, group_, amount_);
340     }
341 }