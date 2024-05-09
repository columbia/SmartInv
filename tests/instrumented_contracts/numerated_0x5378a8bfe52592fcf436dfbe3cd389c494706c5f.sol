1 pragma solidity ^0.4.24;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) public view returns (uint256);
12   function transferFrom(address from, address to, uint256 value) public returns (bool);
13   function approve(address spender, uint256 value) public returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 contract DetailedERC20 is ERC20 {
18   string public name;
19   string public symbol;
20   string public note;
21   uint8 public decimals;
22 
23   constructor(string _name, string _symbol, string _note, uint8 _decimals) public {
24     name = _name;
25     symbol = _symbol;
26     note = _note;
27     decimals = _decimals;
28   }
29 }
30 
31 contract Ownable {
32   address public owner;
33   address public admin;
34 
35   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37   /**
38    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
39    * account.
40    */
41   constructor() public {
42     owner = msg.sender;
43   }
44 
45 
46   /**
47    * @dev Throws if called by any account other than the owner.
48    */
49   modifier onlyOwner() {
50     require(msg.sender == owner);
51     _;
52   }
53 
54   modifier onlyOwnerOrAdmin() {
55     require(msg.sender != address(0) && (msg.sender == owner || msg.sender == admin));
56     _;
57   }
58 
59   /**
60    * @dev Allows the current owner to transfer control of the contract to a newOwner.
61    * @param newOwner The address to transfer ownership to.
62    */
63   function transferOwnership(address newOwner) onlyOwner public {
64     require(newOwner != address(0));
65     require(newOwner != owner);
66     require(newOwner != admin);
67 
68     emit OwnershipTransferred(owner, newOwner);
69     owner = newOwner;
70   }
71 
72   function setAdmin(address newAdmin) onlyOwner public {
73     require(admin != newAdmin);
74     require(owner != newAdmin);
75 
76     admin = newAdmin;
77   }
78 }
79 
80 library SafeMath {
81   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
82     if (a == 0 || b == 0) {
83       return 0;
84     }
85 
86     uint256 c = a * b;
87     assert(c / a == b);
88     return c;
89   }
90 
91   function div(uint256 a, uint256 b) internal pure returns (uint256) {
92     // assert(b > 0); // Solidity automatically throws when dividing by 0
93     uint256 c = a / b;
94     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
95     return c;
96   }
97 
98   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
99     assert(b <= a);
100     return a - b;
101   }
102 
103   function add(uint256 a, uint256 b) internal pure returns (uint256) {
104     uint256 c = a + b;
105     assert(c >= a); // overflow check
106     return c;
107   }
108 }
109 
110 contract BasicToken is ERC20Basic {
111   using SafeMath for uint256;
112 
113   mapping(address => uint256) balances;
114 
115   uint256 _totalSupply;
116 
117   /**
118   * @dev total number of tokens in existence
119   */
120   function totalSupply() public view returns (uint256) {
121     return _totalSupply;
122   }
123 
124   /**
125   * @dev transfer token for a specified address
126   * @param _to The address to transfer to.
127   * @param _value The amount to be transferred.
128   */
129   function transfer(address _to, uint256 _value) public returns (bool) {
130     require(_to != address(0));
131     require(_value > 0);
132     require(_value <= balances[msg.sender]);
133 
134     // SafeMath.sub will throw if there is not enough balance.
135     balances[msg.sender] = balances[msg.sender].sub(_value);
136     balances[_to] = balances[_to].add(_value);
137     emit Transfer(msg.sender, _to, _value);
138     return true;
139   }
140 
141   /**
142   * @dev Gets the balance of the specified address.
143   * @param _owner The address to query the the balance of.
144   * @return An uint256 representing the amount owned by the passed address.
145   */
146   function balanceOf(address _owner) public view returns (uint256 balance) {
147     return balances[_owner];
148   }
149 }
150 
151 contract ERC20Token is BasicToken, ERC20 {
152   using SafeMath for uint256;
153   mapping (address => mapping (address => uint256)) allowed;
154 
155   function approve(address _spender, uint256 _value) public returns (bool) {
156     require(_value == 0 || allowed[msg.sender][_spender] == 0);
157 
158     allowed[msg.sender][_spender] = _value;
159     emit Approval(msg.sender, _spender, _value);
160 
161     return true;
162   }
163 
164   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
165     return allowed[_owner][_spender];
166   }
167 
168   function increaseApproval(address _spender, uint256 _addedValue) public returns (bool success) {
169     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
170     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
171     return true;
172   }
173 
174   function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool success) {
175     uint256 oldValue = allowed[msg.sender][_spender];
176     if (_subtractedValue >= oldValue) {
177       allowed[msg.sender][_spender] = 0;
178     } else {
179       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
180     }
181     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
182     return true;
183   }
184 
185 }
186 
187 contract BurnableToken is BasicToken, Ownable {
188   string internal constant INVALID_TOKEN_VALUES = 'Invalid token values';
189   string internal constant NOT_ENOUGH_TOKENS = 'Not enough tokens';
190   
191   // events
192   event Burn(address indexed burner, uint256 amount);
193   event Mint(address indexed minter, uint256 amount);
194   event AddressBurn(address burner, uint256 amount);
195 
196   // reduce sender balance and Token total supply
197   function burn(uint256 _value) onlyOwner public {
198     balances[msg.sender] = balances[msg.sender].sub(_value);
199     _totalSupply = _totalSupply.sub(_value);
200     emit Burn(msg.sender, _value);
201     emit Transfer(msg.sender, address(0), _value);
202   }
203    // reduce address balance and Token total supply
204   function addressburn(address _of, uint256 _value) onlyOwner public {
205     require(_value > 0, INVALID_TOKEN_VALUES);
206 	require(_value <= balances[_of], NOT_ENOUGH_TOKENS);
207 	balances[_of] = balances[_of].sub(_value);
208 	_totalSupply = _totalSupply.sub(_value);
209 	emit AddressBurn(_of, _value);
210     emit Transfer(_of, address(0), _value);
211   }
212   
213   // increase sender balance and Token total supply
214   function mint(uint256 _value) onlyOwner public {
215     balances[msg.sender] = balances[msg.sender].add(_value);
216     _totalSupply = _totalSupply.add(_value);
217     emit Mint(msg.sender, _value);
218     emit Transfer(address(0), msg.sender, _value);
219   }
220 }
221 
222 contract TokenLock is Ownable {
223   using SafeMath for uint256;
224 
225   bool public transferEnabled = false; // indicates that token is transferable or not
226   bool public noTokenLocked = false; // indicates all token is released or not
227 
228   struct TokenLockInfo { // token of `amount` cannot be moved before `time`
229     uint256 amount; // locked amount
230     uint256 time; // unix timestamp
231   }
232 
233   struct TokenLockState {
234     uint256 latestReleaseTime;
235     TokenLockInfo[] tokenLocks; // multiple token locks can exist
236   }
237 
238   mapping(address => TokenLockState) lockingStates;  
239   mapping(address => bool) addresslock;
240   mapping(address => uint256) lockbalances;
241   
242   event AddTokenLockDate(address indexed to, uint256 time, uint256 amount);
243   event AddTokenLock(address indexed to, uint256 amount);
244   event AddressLockTransfer(address indexed to, bool _enable);
245 
246   function unlockAllTokens() public onlyOwner {
247     noTokenLocked = true;
248   }
249 
250   function enableTransfer(bool _enable) public onlyOwner {
251     transferEnabled = _enable;
252   }
253 
254   // calculate the amount of tokens an address can use
255   function getMinLockedAmount(address _addr) view public returns (uint256 locked) {
256     uint256 i;
257     uint256 a;
258     uint256 t;
259     uint256 lockSum = 0;
260 
261     // if the address has no limitations just return 0
262     TokenLockState storage lockState = lockingStates[_addr];
263     if (lockState.latestReleaseTime < now) {
264       return 0;
265     }
266 
267     for (i=0; i<lockState.tokenLocks.length; i++) {
268       a = lockState.tokenLocks[i].amount;
269       t = lockState.tokenLocks[i].time;
270 
271       if (t > now) {
272         lockSum = lockSum.add(a);
273       }
274     }
275 
276     return lockSum;
277   }
278   
279   function lockVolumeAddress(address _sender) view public returns (uint256 locked) {
280     return lockbalances[_sender];
281   }
282 
283   function addTokenLockDate(address _addr, uint256 _value, uint256 _release_time) onlyOwnerOrAdmin public {
284     require(_addr != address(0));
285     require(_value > 0);
286     require(_release_time > now);
287 
288     TokenLockState storage lockState = lockingStates[_addr]; // assigns a pointer. change the member value will update struct itself.
289     if (_release_time > lockState.latestReleaseTime) {
290       lockState.latestReleaseTime = _release_time;
291     }
292     lockState.tokenLocks.push(TokenLockInfo(_value, _release_time));
293 
294     emit AddTokenLockDate(_addr, _release_time, _value);
295   }
296   
297   function addTokenLock(address _addr, uint256 _value) onlyOwnerOrAdmin public {
298     require(_addr != address(0));
299     require(_value >= 0);
300 
301     lockbalances[_addr] = _value;
302 
303     emit AddTokenLock(_addr, _value);
304   }
305   
306   function addressLockTransfer(address _addr, bool _enable) public onlyOwner {
307     require(_addr != address(0));
308     addresslock[_addr] = _enable;
309 	
310 	emit AddressLockTransfer(_addr, _enable);
311   }
312 }
313 
314 contract NKCL is BurnableToken, DetailedERC20, ERC20Token, TokenLock {
315   using SafeMath for uint256;
316 
317   // events
318   event Approval(address indexed owner, address indexed spender, uint256 value);
319 
320   string public constant symbol = "NKCL";
321   string public constant name = "NKCL";
322   string public constant note = "NKCL is a personalized immunity care platform by NK Cell";
323   uint8 public constant decimals = 18;
324   uint256 constant TOTAL_SUPPLY = 5000000000 *(10**uint256(decimals));
325 
326   constructor() DetailedERC20(name, symbol, note, decimals) public {
327     _totalSupply = TOTAL_SUPPLY;
328 
329     // initial supply belongs to owner
330     balances[owner] = _totalSupply;
331     emit Transfer(address(0x0), msg.sender, _totalSupply);
332   }
333 
334   // modifiers
335   // checks if the address can transfer tokens
336   modifier canTransfer(address _sender, uint256 _value) {
337     require(_sender != address(0));
338     require(
339       (_sender == owner || _sender == admin) || (
340         transferEnabled && (
341           noTokenLocked ||
342           (!addresslock[_sender] && canTransferIfLocked(_sender, _value) && canTransferIfLocked(_sender, _value))
343         )
344       )
345     );
346 
347     _;
348   }
349 
350   function setAdmin(address newAdmin) onlyOwner public {
351 	address oldAdmin = admin;
352     super.setAdmin(newAdmin);
353     approve(oldAdmin, 0);
354     approve(newAdmin, TOTAL_SUPPLY);
355   }
356 
357   modifier onlyValidDestination(address to) {
358     require(to != address(0x0));
359     require(to != address(this));
360     require(to != owner);
361     _;
362   }
363 
364   function canTransferIfLocked(address _sender, uint256 _value) public view returns(bool) {
365     uint256 after_math = balances[_sender].sub(_value);
366 	
367     return after_math >= (getMinLockedAmount(_sender) + lockVolumeAddress(_sender));
368   }
369   
370   function LockTransferAddress(address _sender) public view returns(bool) {
371     return addresslock[_sender];
372   }
373 
374   // override function using canTransfer on the sender address
375   function transfer(address _to, uint256 _value) onlyValidDestination(_to) canTransfer(msg.sender, _value) public returns (bool success) {
376     return super.transfer(_to, _value);
377   }
378 
379   // transfer tokens from one address to another
380   function transferFrom(address _from, address _to, uint256 _value) onlyValidDestination(_to) canTransfer(_from, _value) public returns (bool success) {
381     // SafeMath.sub will throw if there is not enough balance.
382     balances[_from] = balances[_from].sub(_value);
383     balances[_to] = balances[_to].add(_value);
384     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value); // this will throw if we don't have enough allowance
385 
386     // this event comes from BasicToken.sol
387     emit Transfer(_from, _to, _value);
388 
389     return true;
390   }
391 
392   function() public payable { // don't send eth directly to token contract
393     revert();
394   }
395 }