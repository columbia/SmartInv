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
193 
194   // reduce sender balance and Token total supply
195   function burn(uint256 _value) onlyOwner public {
196     balances[msg.sender] = balances[msg.sender].sub(_value);
197     _totalSupply = _totalSupply.sub(_value);
198     emit Burn(msg.sender, _value);
199     emit Transfer(msg.sender, address(0), _value);
200   }
201 }
202 
203 contract TokenLock is Ownable {
204   using SafeMath for uint256;
205 
206   bool public transferEnabled = false; // indicates that token is transferable or not
207   bool public noTokenLocked = false; // indicates all token is released or not
208 
209   struct TokenLockInfo { // token of `amount` cannot be moved before `time`
210     uint256 amount; // locked amount
211     uint256 time; // unix timestamp
212   }
213 
214   struct TokenLockState {
215     uint256 latestReleaseTime;
216     TokenLockInfo[] tokenLocks; // multiple token locks can exist
217   }
218 
219   mapping(address => TokenLockState) lockingStates;  
220   mapping(address => bool) addresslock;
221   mapping(address => uint256) lockbalances;
222   
223   event AddTokenLockDate(address indexed to, uint256 time, uint256 amount);
224   event AddTokenLock(address indexed to, uint256 amount);
225   event AddressLockTransfer(address indexed to, bool _enable);
226 
227   function unlockAllTokens() public onlyOwner {
228     noTokenLocked = true;
229   }
230 
231   function enableTransfer(bool _enable) public onlyOwner {
232     transferEnabled = _enable;
233   }
234 
235   // calculate the amount of tokens an address can use
236   function getMinLockedAmount(address _addr) view public returns (uint256 locked) {
237     uint256 i;
238     uint256 a;
239     uint256 t;
240     uint256 lockSum = 0;
241 
242     // if the address has no limitations just return 0
243     TokenLockState storage lockState = lockingStates[_addr];
244     if (lockState.latestReleaseTime < now) {
245       return 0;
246     }
247 
248     for (i=0; i<lockState.tokenLocks.length; i++) {
249       a = lockState.tokenLocks[i].amount;
250       t = lockState.tokenLocks[i].time;
251 
252       if (t > now) {
253         lockSum = lockSum.add(a);
254       }
255     }
256 
257     return lockSum;
258   }
259   
260   function lockVolumeAddress(address _sender) view public returns (uint256 locked) {
261     return lockbalances[_sender];
262   }
263 
264   function addTokenLockDate(address _addr, uint256 _value, uint256 _release_time) onlyOwnerOrAdmin public {
265     require(_addr != address(0));
266     require(_value > 0);
267     require(_release_time > now);
268 
269     TokenLockState storage lockState = lockingStates[_addr]; // assigns a pointer. change the member value will update struct itself.
270     if (_release_time > lockState.latestReleaseTime) {
271       lockState.latestReleaseTime = _release_time;
272     }
273     lockState.tokenLocks.push(TokenLockInfo(_value, _release_time));
274 
275     emit AddTokenLockDate(_addr, _release_time, _value);
276   }
277   
278   function addTokenLock(address _addr, uint256 _value) onlyOwnerOrAdmin public {
279     require(_addr != address(0));
280     require(_value >= 0);
281 
282     lockbalances[_addr] = _value;
283 
284     emit AddTokenLock(_addr, _value);
285   }
286   
287   function addressLockTransfer(address _addr, bool _enable) public onlyOwner {
288     require(_addr != address(0));
289     addresslock[_addr] = _enable;
290 	
291 	emit AddressLockTransfer(_addr, _enable);
292   }
293 }
294 
295 contract DRE is BurnableToken, DetailedERC20, ERC20Token, TokenLock {
296   using SafeMath for uint256;
297 
298   // events
299   event Approval(address indexed owner, address indexed spender, uint256 value);
300 
301   string public constant symbol = "DRE";
302   string public constant name = "DoRen";
303   string public constant note = "Decentralized New Renewable Energy Integrated Control and Intermediation Project";
304   uint8 public constant decimals = 18;
305   uint256 constant TOTAL_SUPPLY = 9000000000 *(10**uint256(decimals));
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
319     require(
320       (_sender == owner || _sender == admin) || (
321         transferEnabled && (
322           noTokenLocked ||
323           (!addresslock[_sender] && canTransferIfLocked(_sender, _value) )
324         )
325       )
326     );
327 
328     _;
329   }
330 
331   function setAdmin(address newAdmin) onlyOwner public {
332 	address oldAdmin = admin;
333     super.setAdmin(newAdmin);
334     approve(oldAdmin, 0);
335     approve(newAdmin, TOTAL_SUPPLY);
336   }
337 
338   modifier onlyValidDestination(address to) {
339     require(to != address(0x0));
340     require(to != address(this));
341     //require(to != owner);
342     _;
343   }
344 
345   function canTransferIfLocked(address _sender, uint256 _value) public view returns(bool) {
346     uint256 after_math = balances[_sender].sub(_value);
347 	
348     return after_math >= (getMinLockedAmount(_sender) + lockVolumeAddress(_sender));
349   }
350   
351   function LockTransferAddress(address _sender) public view returns(bool) {
352     return addresslock[_sender];
353   }
354 
355   // override function using canTransfer on the sender address
356   function transfer(address _to, uint256 _value) onlyValidDestination(_to) canTransfer(msg.sender, _value) public returns (bool success) {
357     return super.transfer(_to, _value);
358   }
359 
360   // transfer tokens from one address to another
361   function transferFrom(address _from, address _to, uint256 _value) onlyValidDestination(_to) canTransfer(_from, _value) public returns (bool success) {
362     // SafeMath.sub will throw if there is not enough balance.
363     balances[_from] = balances[_from].sub(_value);
364     balances[_to] = balances[_to].add(_value);
365     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value); // this will throw if we don't have enough allowance
366 
367     // this event comes from BasicToken.sol
368     emit Transfer(_from, _to, _value);
369 
370     return true;
371   }
372 
373   function() public payable { // don't send eth directly to token contract
374     revert();
375   }
376 }