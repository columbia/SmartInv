1 pragma solidity ^0.4.25;
2 
3 /*
4     Owned contract interface
5 */
6 contract IOwned {
7 
8     // this function isn't abstract since the compiler emits automatically generated getter functions as external
9     // function owner() public view returns (address) {}
10 
11     function transferOwnership(address _newOwner) public;
12 
13     function acceptOwnership() public;
14 }
15 
16 /*
17     Provides support and utilities for contract ownership
18 */
19 contract Owned is IOwned {
20 
21     address public owner;
22     address public newOwner;
23 
24     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
25 
26     /**
27         @dev constructor
28     */
29     constructor() public {
30         owner = msg.sender;
31     }
32 
33     // allows execution by the owner only
34     modifier ownerOnly {
35         require(msg.sender == owner, "Only the owner can call");
36         _;
37     }
38 
39     /**
40         @dev allows transferring the contract ownership
41         the new owner still needs to accept the transfer
42         can only be called by the contract owner
43 
44         @param _newOwner    new contract owner
45     */
46     function transferOwnership(address _newOwner) public ownerOnly {
47         require(_newOwner != owner, "The new owner cannot be the same as the original owner");
48         newOwner = _newOwner;
49     }
50 
51     /**
52         @dev used by a new owner to accept an ownership transfer
53     */
54     function acceptOwnership() public {
55         require(msg.sender == newOwner, "Only the new owner can call");
56         emit OwnerUpdate(owner, newOwner);
57         owner = newOwner;
58         newOwner = address(0);
59     }
60 }
61 
62 
63 /**
64  * @title ERC20 interface
65  * @dev see https://github.com/ethereum/EIPs/issues/20
66  */
67 interface IERC20 {
68     
69   function name() external view returns (string);
70   
71   function symbol() external view returns (string);
72   
73   function decimals() external view returns (uint8);
74 
75   function totalSupply() external view returns (uint256);
76 
77   function balanceOf(address who) external view returns (uint256);
78 
79   function allowance(address owner, address spender)
80     external view returns (uint256);
81 
82   function transfer(address to, uint256 value) external returns (bool);
83 
84   function approve(address spender, uint256 value)
85     external returns (bool);
86 
87   function transferFrom(address from, address to, uint256 value)
88     external returns (bool);
89 
90   event Transfer(
91     address indexed from,
92     address indexed to,
93     uint256 value
94   );
95 
96   event Approval(
97     address indexed owner,
98     address indexed spender,
99     uint256 value
100   );
101 }
102 
103 /**
104  * @title SafeMath
105  * @dev Math operations with safety checks that revert on error
106  */
107 library SafeMath {
108 
109   /**
110   * @dev Multiplies two numbers, reverts on overflow.
111   */
112   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
113     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
114     // benefit is lost if 'b' is also tested.
115     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
116     if (a == 0) {
117       return 0;
118     }
119 
120     uint256 c = a * b;
121     require(c / a == b);
122 
123     return c;
124   }
125 
126   /**
127   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
128   */
129   function div(uint256 a, uint256 b) internal pure returns (uint256) {
130     require(b > 0); // Solidity only automatically asserts when dividing by 0
131     uint256 c = a / b;
132     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
133 
134     return c;
135   }
136 
137   /**
138   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
139   */
140   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
141     require(b <= a);
142     uint256 c = a - b;
143 
144     return c;
145   }
146 
147   /**
148   * @dev Adds two numbers, reverts on overflow.
149   */
150   function add(uint256 a, uint256 b) internal pure returns (uint256) {
151     uint256 c = a + b;
152     require(c >= a);
153 
154     return c;
155   }
156 
157   /**
158   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
159   * reverts when dividing by zero.
160   */
161   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
162     require(b != 0);
163     return a % b;
164   }
165 }
166 
167 /**
168  * @title Standard ERC20 token
169  *
170  * @dev Implementation of the basic standard token.
171  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
172  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
173  */
174 contract DFH is Owned, IERC20 {
175   using SafeMath for uint256;
176 
177   mapping (address => uint256) private _balances;
178 
179   mapping (address => mapping (address => uint256)) private _allowed;
180 
181   string private _name = 'Diamond Family Home';
182   
183   string private _symbol = 'DFH';
184   
185   uint8 private _decimals = 18;
186 
187   uint256 private _totalSupply;
188   
189   function name() public view returns (string) {
190       return _name;
191   }
192   
193   function symbol() public view returns (string) {
194       return _symbol;
195   }
196   
197   function decimals() public view returns (uint8) {
198       return _decimals;
199   }
200 
201   /**
202   * @dev Total number of tokens in existence
203   */
204   function totalSupply() public view returns (uint256) {
205     return _totalSupply;
206   }
207 
208   /**
209   * @dev Gets the balance of the specified address.
210   * @param owner The address to query the balance of.
211   * @return An uint256 representing the amount owned by the passed address.
212   */
213   function balanceOf(address owner) public view returns (uint256) {
214     return _balances[owner];
215   }
216 
217   /**
218    * @dev Function to check the amount of tokens that an owner allowed to a spender.
219    * @param owner address The address which owns the funds.
220    * @param spender address The address which will spend the funds.
221    * @return A uint256 specifying the amount of tokens still available for the spender.
222    */
223   function allowance(
224     address owner,
225     address spender
226    )
227     public
228     view
229     returns (uint256)
230   {
231     return _allowed[owner][spender];
232   }
233 
234   /**
235   * @dev Transfer token for a specified address
236   * @param to The address to transfer to.
237   * @param value The amount to be transferred.
238   */
239   function transfer(address to, uint256 value) public returns (bool) {
240     _transfer(msg.sender, to, value);
241     return true;
242   }
243 
244   /**
245    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
246    * Beware that changing an allowance with this method brings the risk that someone may use both the old
247    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
248    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
249    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
250    * @param spender The address which will spend the funds.
251    * @param value The amount of tokens to be spent.
252    */
253   function approve(address spender, uint256 value) public returns (bool) {
254     require(spender != address(0));
255 
256     _allowed[msg.sender][spender] = value;
257     emit Approval(msg.sender, spender, value);
258     return true;
259   }
260 
261   /**
262    * @dev Transfer tokens from one address to another
263    * @param from address The address which you want to send tokens from
264    * @param to address The address which you want to transfer to
265    * @param value uint256 the amount of tokens to be transferred
266    */
267   function transferFrom(
268     address from,
269     address to,
270     uint256 value
271   )
272     public
273     returns (bool)
274   {
275     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
276     _transfer(from, to, value);
277     return true;
278   }
279 
280   /**
281    * @dev Increase the amount of tokens that an owner allowed to a spender.
282    * approve should be called when allowed_[_spender] == 0. To increment
283    * allowed value is better to use this function to avoid 2 calls (and wait until
284    * the first transaction is mined)
285    * From MonolithDAO Token.sol
286    * @param spender The address which will spend the funds.
287    * @param addedValue The amount of tokens to increase the allowance by.
288    */
289   function increaseAllowance(
290     address spender,
291     uint256 addedValue
292   )
293     public
294     returns (bool)
295   {
296     require(spender != address(0));
297 
298     _allowed[msg.sender][spender] = (
299       _allowed[msg.sender][spender].add(addedValue));
300     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
301     return true;
302   }
303 
304   /**
305    * @dev Decrease the amount of tokens that an owner allowed to a spender.
306    * approve should be called when allowed_[_spender] == 0. To decrement
307    * allowed value is better to use this function to avoid 2 calls (and wait until
308    * the first transaction is mined)
309    * From MonolithDAO Token.sol
310    * @param spender The address which will spend the funds.
311    * @param subtractedValue The amount of tokens to decrease the allowance by.
312    */
313   function decreaseAllowance(
314     address spender,
315     uint256 subtractedValue
316   )
317     public
318     returns (bool)
319   {
320     require(spender != address(0));
321 
322     _allowed[msg.sender][spender] = (
323       _allowed[msg.sender][spender].sub(subtractedValue));
324     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
325     return true;
326   }
327 
328   /**
329    * @dev Function that mints an amount of the token and assigns it to
330    * an account. This encapsulates the modification of balances such that the
331    * proper events are emitted.
332    * @param account The account that will receive the created tokens.
333    * @param value The amount that will be created.
334    */
335   function mint(address account, uint256 value) public ownerOnly {
336     require(account != address(0));
337 
338     _totalSupply = _totalSupply.add(value);
339     _balances[account] = _balances[account].add(value);
340     emit Transfer(address(0), account, value);
341   }
342 
343   /**
344    * @dev Function that burns an amount of the token of a given
345    * account.
346    * @param account The account whose tokens will be burnt.
347    * @param value The amount that will be burnt.
348    */
349   function burn(address account, uint256 value) public ownerOnly {
350     require(account != address(0));
351 
352     _totalSupply = _totalSupply.sub(value);
353     _balances[account] = _balances[account].sub(value);
354     emit Transfer(account, address(0), value);
355   }
356 
357   /**
358    * @dev Function that burns an amount of the token of a given
359    * account, deducting from the sender's allowance for said account. Uses the
360    * internal burn function.
361    * @param account The account whose tokens will be burnt.
362    * @param value The amount that will be burnt.
363    */
364   function burnFrom(address account, uint256 value) public ownerOnly {
365     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
366     // this function needs to emit an event with the updated approval.
367     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
368       value);
369     burn(account, value);
370   }
371   
372   /**
373   * @dev Transfer token for a specified addresses
374   * @param from The address to transfer from.
375   * @param to The address to transfer to.
376   * @param value The amount to be transferred.
377   */
378   function _transfer(address from, address to, uint256 value) internal {
379     require(to != address(0));
380 
381     _balances[from] = _balances[from].sub(value);
382     _balances[to] = _balances[to].add(value);
383     emit Transfer(from, to, value);
384   }
385 }