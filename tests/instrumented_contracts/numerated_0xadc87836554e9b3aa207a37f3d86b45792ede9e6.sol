1 /**
2  *Submitted for verification at Etherscan.io on 2022-03-08
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-03-08
7 */
8 
9 pragma solidity ^0.4.24;
10 
11 contract ERC20Basic {
12   function totalSupply() public view returns (uint256);
13   function balanceOf(address who) public view returns (uint256);
14   function transfer(address to, uint256 value) public returns (bool);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 contract ERC20 is ERC20Basic {
19   function allowance(address owner, address spender) public view returns (uint256);
20   function transferFrom(address from, address to, uint256 value) public returns (bool);
21   function approve(address spender, uint256 value) public returns (bool);
22   event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 contract DetailedERC20 is ERC20 {
26   string public name;
27   string public symbol;
28   string public note;
29   uint8 public decimals;
30 
31   constructor(string _name, string _symbol, string _note, uint8 _decimals) public {
32     name = _name;
33     symbol = _symbol;
34     note = _note;
35     decimals = _decimals;
36   }
37 }
38 
39 contract Ownable {
40   address public owner;
41   address public admin;
42 
43   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45   /**
46    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47    * account.
48    */
49   constructor() public {
50     owner = msg.sender;
51   }
52 
53 
54   /**
55    * @dev Throws if called by any account other than the owner.
56    */
57   modifier onlyOwner() {
58     require(msg.sender == owner);
59     _;
60   }
61 
62   modifier onlyOwnerOrAdmin() {
63     require(msg.sender != address(0) && (msg.sender == owner || msg.sender == admin));
64     _;
65   }
66 
67   /**
68    * @dev Allows the current owner to transfer control of the contract to a newOwner.
69    * @param newOwner The address to transfer ownership to.
70    */
71   function transferOwnership(address newOwner) onlyOwner public {
72     require(newOwner != address(0));
73     require(newOwner != owner);
74     require(newOwner != admin);
75 
76     emit OwnershipTransferred(owner, newOwner);
77     owner = newOwner;
78   }
79 
80   function setAdmin(address newAdmin) onlyOwner public {
81     require(admin != newAdmin);
82     require(owner != newAdmin);
83 
84     admin = newAdmin;
85   }
86 }
87 
88 library SafeMath {
89   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
90     if (a == 0 || b == 0) {
91       return 0;
92     }
93 
94     uint256 c = a * b;
95     assert(c / a == b);
96     return c;
97   }
98 
99   function div(uint256 a, uint256 b) internal pure returns (uint256) {
100     // assert(b > 0); // Solidity automatically throws when dividing by 0
101     uint256 c = a / b;
102     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
103     return c;
104   }
105 
106   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
107     assert(b <= a);
108     return a - b;
109   }
110 
111   function add(uint256 a, uint256 b) internal pure returns (uint256) {
112     uint256 c = a + b;
113     assert(c >= a); // overflow check
114     return c;
115   }
116 }
117 
118 contract BasicToken is ERC20Basic {
119   using SafeMath for uint256;
120 
121   mapping(address => uint256) balances;
122 
123   uint256 _totalSupply;
124 
125   /**
126   * @dev total number of tokens in existence
127   */
128   function totalSupply() public view returns (uint256) {
129     return _totalSupply;
130   }
131 
132   /**
133   * @dev transfer token for a specified address
134   * @param _to The address to transfer to.
135   * @param _value The amount to be transferred.
136   */
137   function transfer(address _to, uint256 _value) public returns (bool) {
138     require(_to != address(0));
139     require(_value > 0);
140     require(_value <= balances[msg.sender]);
141 
142     // SafeMath.sub will throw if there is not enough balance.
143     balances[msg.sender] = balances[msg.sender].sub(_value);
144     balances[_to] = balances[_to].add(_value);
145     emit Transfer(msg.sender, _to, _value);
146     return true;
147   }
148 
149   /**
150   * @dev Gets the balance of the specified address.
151   * @param _owner The address to query the the balance of.
152   * @return An uint256 representing the amount owned by the passed address.
153   */
154   function balanceOf(address _owner) public view returns (uint256 balance) {
155     return balances[_owner];
156   }
157 }
158 
159 contract ERC20Token is BasicToken, ERC20 {
160   using SafeMath for uint256;
161   mapping (address => mapping (address => uint256)) allowed;
162 
163   function approve(address _spender, uint256 _value) public returns (bool) {
164     require(_value == 0 || allowed[msg.sender][_spender] == 0);
165 
166     allowed[msg.sender][_spender] = _value;
167     emit Approval(msg.sender, _spender, _value);
168 
169     return true;
170   }
171 
172   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
173     return allowed[_owner][_spender];
174   }
175 
176   function increaseApproval(address _spender, uint256 _addedValue) public returns (bool success) {
177     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
178     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
179     return true;
180   }
181 
182   function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool success) {
183     uint256 oldValue = allowed[msg.sender][_spender];
184     if (_subtractedValue >= oldValue) {
185       allowed[msg.sender][_spender] = 0;
186     } else {
187       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
188     }
189     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
190     return true;
191   }
192 
193 }
194 
195 contract BurnableToken is BasicToken, Ownable {
196   string internal constant INVALID_TOKEN_VALUES = 'Invalid token values';
197   string internal constant NOT_ENOUGH_TOKENS = 'Not enough tokens';
198   
199   // events
200   event Burn(address indexed burner, uint256 amount);
201   
202   
203 
204   // reduce sender balance and Token total supply
205   function burn(uint256 _value) onlyOwner public {
206     balances[msg.sender] = balances[msg.sender].sub(_value);
207     _totalSupply = _totalSupply.sub(_value);
208     emit Burn(msg.sender, _value);
209     emit Transfer(msg.sender, address(0), _value);
210   }
211    // reduce address balance and Token total supply
212   
213   
214 
215 }
216 
217 contract TokenLock is Ownable {
218   using SafeMath for uint256;
219 
220   
221   
222 
223   struct TokenLockInfo { // token of `amount` cannot be moved before `time`
224     uint256 amount; // locked amount
225     uint256 time; // unix timestamp
226   }
227 
228   struct TokenLockState {
229     uint256 latestReleaseTime;
230     TokenLockInfo[] tokenLocks; // multiple token locks can exist
231   }
232 
233   mapping(address => TokenLockState) lockingStates;  
234   mapping(address => bool) addresslock;
235   mapping(address => uint256) lockbalances;
236   
237   event AddTokenLockDate(address indexed to, uint256 time, uint256 amount);
238   event AddTokenLock(address indexed to, uint256 amount);
239   
240   // calculate the amount of tokens an address can use
241   function getMinLockedAmount(address _addr) view public returns (uint256 locked) {
242     uint256 i;
243     uint256 a;
244     uint256 t;
245     uint256 lockSum = 0;
246 
247     // if the address has no limitations just return 0
248     TokenLockState storage lockState = lockingStates[_addr];
249     if (lockState.latestReleaseTime < now) {
250       return 0;
251     }
252 
253     for (i=0; i<lockState.tokenLocks.length; i++) {
254       a = lockState.tokenLocks[i].amount;
255       t = lockState.tokenLocks[i].time;
256 
257       if (t > now) {
258         lockSum = lockSum.add(a);
259       }
260     }
261 
262     return lockSum;
263   }
264   
265   function lockVolumeAddress(address _sender) view public returns (uint256 locked) {
266     return lockbalances[_sender];
267   }
268 
269   function addTokenLockDate(address _addr, uint256 _value, uint256 _release_time) onlyOwnerOrAdmin public {
270     require(_addr != address(0));
271     require(_value > 0);
272     require(_release_time > now);
273 
274     TokenLockState storage lockState = lockingStates[_addr]; // assigns a pointer. change the member value will update struct itself.
275     if (_release_time > lockState.latestReleaseTime) {
276       lockState.latestReleaseTime = _release_time;
277     }
278     lockState.tokenLocks.push(TokenLockInfo(_value, _release_time));
279 
280     emit AddTokenLockDate(_addr, _release_time, _value);
281   }
282   
283   function addTokenLock(address _addr, uint256 _value) onlyOwnerOrAdmin public {
284     require(_addr != address(0));
285     require(_value >= 0);
286 
287     lockbalances[_addr] = _value;
288 
289     emit AddTokenLock(_addr, _value);
290   }
291   
292 
293 }
294 
295 contract DTR is BurnableToken, DetailedERC20, ERC20Token, TokenLock {
296   using SafeMath for uint256;
297 
298   // events
299   event Approval(address indexed owner, address indexed spender, uint256 value);
300 
301   string public constant symbol = "DTR";
302   string public constant name = "DOTORI";
303   string public constant note = "Cyworld";
304   uint8 public constant decimals = 18;
305   uint256 constant TOTAL_SUPPLY = 10000000000 *(10**uint256(decimals));
306 
307   constructor() DetailedERC20(name, symbol, note, decimals) public {
308     _totalSupply = TOTAL_SUPPLY;
309 
310     // initial supply belongs to owner
311     balances[owner] = _totalSupply;
312     emit Transfer(address(0x0), msg.sender, _totalSupply);
313   }
314 
315   // modifiers
316   // checks if the address can transfer tokens
317   modifier canTransfer(address _sender, uint256 _value) {
318     require(_sender != address(0));
319     require((_sender == owner || _sender == admin) || ( (!addresslock[_sender] && canTransferIfLocked(_sender, _value) && canTransferIfLocked(_sender, _value)) )  );
320 
321     _;
322   }
323 
324   function setAdmin(address newAdmin) onlyOwner public {
325 	address oldAdmin = admin;
326     super.setAdmin(newAdmin);
327     approve(oldAdmin, 0);
328     approve(newAdmin, TOTAL_SUPPLY);
329   }
330 
331   modifier onlyValidDestination(address to) {
332     require(to != address(0x0));
333     require(to != address(this));
334     //require(to != owner);
335     _;
336   }
337 
338   function canTransferIfLocked(address _sender, uint256 _value) public view returns(bool) {
339     uint256 after_math = balances[_sender].sub(_value);
340 	
341     return after_math >= (getMinLockedAmount(_sender) + lockVolumeAddress(_sender));
342   }
343   
344   function LockTransferAddress(address _sender) public view returns(bool) {
345     return addresslock[_sender];
346   }
347 
348   // override function using canTransfer on the sender address
349   function transfer(address _to, uint256 _value) onlyValidDestination(_to) canTransfer(msg.sender, _value) public returns (bool success) {
350     return super.transfer(_to, _value);
351   }
352 
353   // transfer tokens from one address to another
354   function transferFrom(address _from, address _to, uint256 _value) onlyValidDestination(_to) canTransfer(_from, _value) public returns (bool success) {
355     // SafeMath.sub will throw if there is not enough balance.
356     balances[_from] = balances[_from].sub(_value);
357     balances[_to] = balances[_to].add(_value);
358     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value); // this will throw if we don't have enough allowance
359 
360     // this event comes from BasicToken.sol
361     emit Transfer(_from, _to, _value);
362 
363     return true;
364   }
365 
366   function() public payable { // don't send eth directly to token contract
367     revert();
368   }
369 }