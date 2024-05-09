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
222 contract PayNKCL is BasicToken, Ownable {
223   using SafeMath for uint256;
224 
225   address public payer;
226   uint16 public payfee;
227   
228   function setPayer(address newPayer) onlyOwner public {
229     require(payer != newPayer);
230 
231     payer = newPayer;
232   }
233   
234   function setPayFee(uint16 newFee) onlyOwner public {
235 	require(newFee <= 10000);
236 	
237     payfee = newFee;
238   }
239   
240   
241   function Pay( address _to, uint256 _value) public returns (bool) {
242 	require(payer != address(0));
243     require(payfee >= 0);
244     require(_value > 0);
245     require(_value <= balances[msg.sender]);
246 	
247 	uint256 pay_qty = _value.div(10000);
248 	pay_qty = pay_qty.mul(payfee);
249 	
250 	uint256 after_pay = _value.sub(pay_qty);
251 	
252 	balances[msg.sender] = balances[msg.sender].sub(_value);
253 	balances[_to] = balances[_to].add(after_pay);
254 	balances[payer] = balances[payer].add(pay_qty);
255 	
256     emit Transfer(msg.sender, _to, after_pay);
257     emit Transfer(msg.sender, payer, pay_qty);
258 	
259     return true;
260   }  
261 }
262 
263 contract TokenLock is Ownable {
264   using SafeMath for uint256;
265 
266   bool public transferEnabled = false; // indicates that token is transferable or not
267   bool public noTokenLocked = false; // indicates all token is released or not
268 
269   struct TokenLockInfo { // token of `amount` cannot be moved before `time`
270     uint256 amount; // locked amount
271     uint256 time; // unix timestamp
272   }
273 
274   struct TokenLockState {
275     uint256 latestReleaseTime;
276     TokenLockInfo[] tokenLocks; // multiple token locks can exist
277   }
278 
279   mapping(address => TokenLockState) lockingStates;  
280   mapping(address => bool) addresslock;
281   mapping(address => uint256) lockbalances;
282   
283   event AddTokenLockDate(address indexed to, uint256 time, uint256 amount);
284   event AddTokenLock(address indexed to, uint256 amount);
285   event AddressLockTransfer(address indexed to, bool _enable);
286 
287   function unlockAllTokens() public onlyOwner {
288     noTokenLocked = true;
289   }
290 
291   function enableTransfer(bool _enable) public onlyOwner {
292     transferEnabled = _enable;
293   }
294 
295   // calculate the amount of tokens an address can use
296   function getMinLockedAmount(address _addr) view public returns (uint256 locked) {
297     uint256 i;
298     uint256 a;
299     uint256 t;
300     uint256 lockSum = 0;
301 
302     // if the address has no limitations just return 0
303     TokenLockState storage lockState = lockingStates[_addr];
304     if (lockState.latestReleaseTime < now) {
305       return 0;
306     }
307 
308     for (i=0; i<lockState.tokenLocks.length; i++) {
309       a = lockState.tokenLocks[i].amount;
310       t = lockState.tokenLocks[i].time;
311 
312       if (t > now) {
313         lockSum = lockSum.add(a);
314       }
315     }
316 
317     return lockSum;
318   }
319   
320   function lockVolumeAddress(address _sender) view public returns (uint256 locked) {
321     return lockbalances[_sender];
322   }
323 
324   function addTokenLockDate(address _addr, uint256 _value, uint256 _release_time) onlyOwnerOrAdmin public {
325     require(_addr != address(0));
326     require(_value > 0);
327     require(_release_time > now);
328 
329     TokenLockState storage lockState = lockingStates[_addr]; // assigns a pointer. change the member value will update struct itself.
330     if (_release_time > lockState.latestReleaseTime) {
331       lockState.latestReleaseTime = _release_time;
332     }
333     lockState.tokenLocks.push(TokenLockInfo(_value, _release_time));
334 
335     emit AddTokenLockDate(_addr, _release_time, _value);
336   }
337   
338   function addTokenLock(address _addr, uint256 _value) onlyOwnerOrAdmin public {
339     require(_addr != address(0));
340     require(_value >= 0);
341 
342     lockbalances[_addr] = _value;
343 
344     emit AddTokenLock(_addr, _value);
345   }
346   
347   function addressLockTransfer(address _addr, bool _enable) public onlyOwner {
348     require(_addr != address(0));
349     addresslock[_addr] = _enable;
350 	
351 	emit AddressLockTransfer(_addr, _enable);
352   }
353 }
354 
355 contract NKCLM is BurnableToken, DetailedERC20, ERC20Token, TokenLock, PayNKCL {
356   using SafeMath for uint256;
357 
358   // events
359   event Approval(address indexed owner, address indexed spender, uint256 value);
360 
361   string public constant symbol = "NKCLM";
362   string public constant name = "NKCL Master";
363   string public constant note = "NKCL is a Personalized Immune-Care Platform using NK Cell. NKCLM is the master coin of NKCL.";
364   uint8 public constant decimals = 18;
365   uint256 constant TOTAL_SUPPLY = 100000000 *(10**uint256(decimals));
366 
367   constructor() DetailedERC20(name, symbol, note, decimals) public {
368     _totalSupply = TOTAL_SUPPLY;
369 
370     // initial supply belongs to owner
371     balances[owner] = _totalSupply;
372     emit Transfer(address(0x0), msg.sender, _totalSupply);
373   }
374 
375   // modifiers
376   // checks if the address can transfer tokens
377   modifier canTransfer(address _sender, uint256 _value) {
378     require(_sender != address(0));
379     require(
380       (_sender == owner || _sender == admin) || (
381         transferEnabled && (
382           noTokenLocked ||
383           (!addresslock[_sender] && canTransferIfLocked(_sender, _value) && canTransferIfLocked(_sender, _value))
384         )
385       )
386     );
387 
388     _;
389   }
390 
391   function setAdmin(address newAdmin) onlyOwner public {
392 	address oldAdmin = admin;
393     super.setAdmin(newAdmin);
394     approve(oldAdmin, 0);
395     approve(newAdmin, TOTAL_SUPPLY);
396   }
397 
398   function setPayer(address newPayer) onlyOwner public {
399     super.setPayer(newPayer);
400   }
401 
402   function setPayFee(uint16 newFee) onlyOwner public {
403     super.setPayFee(newFee);
404   }
405 
406   modifier onlyValidDestination(address to) {
407     require(to != address(0x0));
408     require(to != address(this));
409     require(to != owner);
410     _;
411   }
412 
413   function canTransferIfLocked(address _sender, uint256 _value) public view returns(bool) {
414     uint256 after_math = balances[_sender].sub(_value);
415 	
416     return after_math >= (getMinLockedAmount(_sender) + lockVolumeAddress(_sender));
417   }
418   
419   function LockTransferAddress(address _sender) public view returns(bool) {
420     return addresslock[_sender];
421   }
422 
423   // override function using canTransfer on the sender address
424   function transfer(address _to, uint256 _value) onlyValidDestination(_to) canTransfer(msg.sender, _value) public returns (bool success) {
425     return super.transfer(_to, _value);
426   }
427 
428   // transfer tokens from one address to another
429   function transferFrom(address _from, address _to, uint256 _value) onlyValidDestination(_to) canTransfer(_from, _value) public returns (bool success) {
430     // SafeMath.sub will throw if there is not enough balance.
431     balances[_from] = balances[_from].sub(_value);
432     balances[_to] = balances[_to].add(_value);
433     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value); // this will throw if we don't have enough allowance
434 
435     // this event comes from BasicToken.sol
436     emit Transfer(_from, _to, _value);
437 
438     return true;
439   }  
440   
441   function Pay(address _to, uint256 _value) onlyValidDestination(_to) canTransfer(msg.sender, _value) public returns (bool success) {
442     return super.Pay(_to, _value);
443   }
444 
445   function() public payable { // don't send eth directly to token contract
446     revert();
447   }
448 }