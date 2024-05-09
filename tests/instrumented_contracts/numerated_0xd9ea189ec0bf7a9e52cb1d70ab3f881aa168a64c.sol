1 /**
2  OIL token by keyper
3  */
4 
5 
6 pragma solidity 0.4.23;
7 
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 
16 
17 contract ERC20 is ERC20Basic {
18   function allowance(address owner, address spender) public view returns (uint256);
19   function transferFrom(address from, address to, uint256 value) public returns (bool);
20   function approve(address spender, uint256 value) public returns (bool);
21   event Approval(address indexed owner, address indexed spender, uint256 value);
22 }
23 
24 
25 
26 contract DetailedERC20 is ERC20 {
27   string public name;
28   string public symbol;
29   uint8 public decimals;
30 
31   constructor(string _name, string _symbol, uint8 _decimals) public {
32     name = _name;
33     symbol = _symbol;
34     decimals = _decimals;
35   }
36 }
37 
38 
39 
40 contract Ownable {
41   address public owner;
42   address public admin;
43 
44   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46   /**
47    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48    * account.
49    */
50   constructor() public {
51     owner = msg.sender;
52   }
53 
54 
55   /**
56    * @dev Throws if called by any account other than the owner.
57    */
58   modifier onlyOwner() {
59     require(msg.sender == owner);
60     _;
61   }
62 
63   modifier onlyOwnerOrAdmin() {
64     require(msg.sender != address(0) && (msg.sender == owner || msg.sender == admin));
65     _;
66   }
67 
68   /**
69    * @dev Allows the current owner to transfer control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function transferOwnership(address newOwner) onlyOwner public {
73     require(newOwner != address(0));
74     require(newOwner != owner);
75     require(newOwner != admin);
76 
77     emit OwnershipTransferred(owner, newOwner);
78     owner = newOwner;
79   }
80 
81   function setAdmin(address newAdmin) onlyOwner public {
82     require(admin != newAdmin);
83     require(owner != newAdmin);
84 
85     admin = newAdmin;
86   }
87 }
88 
89 
90 
91 library SafeMath {
92   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
93     if (a == 0 || b == 0) {
94       return 0;
95     }
96 
97     uint256 c = a * b;
98     assert(c / a == b);
99     return c;
100   }
101 
102   function div(uint256 a, uint256 b) internal pure returns (uint256) {
103     // assert(b > 0); // Solidity automatically throws when dividing by 0
104     uint256 c = a / b;
105     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
106     return c;
107   }
108 
109   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
110     assert(b <= a);
111     return a - b;
112   }
113 
114   function add(uint256 a, uint256 b) internal pure returns (uint256) {
115     uint256 c = a + b;
116     assert(c >= a); // overflow check
117     return c;
118   }
119 }
120 
121 
122 
123 contract BasicToken is ERC20Basic {
124   using SafeMath for uint256;
125 
126   mapping(address => uint256) balances;
127 
128   uint256 _totalSupply;
129 
130   /**
131   * @dev total number of tokens in existence
132   */
133   function totalSupply() public view returns (uint256) {
134     return _totalSupply;
135   }
136 
137   /**
138   * @dev transfer token for a specified address
139   * @param _to The address to transfer to.
140   * @param _value The amount to be transferred.
141   */
142   function transfer(address _to, uint256 _value) public returns (bool) {
143     require(_to != address(0));
144     require(_value > 0);
145     require(_value <= balances[msg.sender]);
146 
147     // SafeMath.sub will throw if there is not enough balance.
148     balances[msg.sender] = balances[msg.sender].sub(_value);
149     balances[_to] = balances[_to].add(_value);
150     emit Transfer(msg.sender, _to, _value);
151     return true;
152   }
153 
154   /**
155   * @dev Gets the balance of the specified address.
156   * @param _owner The address to query the the balance of.
157   * @return An uint256 representing the amount owned by the passed address.
158   */
159   function balanceOf(address _owner) public view returns (uint256 balance) {
160     return balances[_owner];
161   }
162 }
163 
164 contract ERC20Token is BasicToken, ERC20 {
165   using SafeMath for uint256;
166   mapping (address => mapping (address => uint256)) allowed;
167 
168   function approve(address _spender, uint256 _value) public returns (bool) {
169     require(_value == 0 || allowed[msg.sender][_spender] == 0);
170 
171     allowed[msg.sender][_spender] = _value;
172     emit Approval(msg.sender, _spender, _value);
173 
174     return true;
175   }
176 
177   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
178     return allowed[_owner][_spender];
179   }
180 
181   function increaseApproval(address _spender, uint256 _addedValue) public returns (bool success) {
182     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
183     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
184     return true;
185   }
186 
187   function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool success) {
188     uint256 oldValue = allowed[msg.sender][_spender];
189     if (_subtractedValue >= oldValue) {
190       allowed[msg.sender][_spender] = 0;
191     } else {
192       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
193     }
194     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
195     return true;
196   }
197 
198 }
199 /**
200  * @title Mintable token
201  * @dev Simple ERC20 Token example, with mintable token creation
202  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
203  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
204  */
205 contract MintableToken is BasicToken, Ownable {
206   event Mint(address indexed to, uint256 amount);
207   event MintFinished();
208 
209   bool public mintingFinished = false;
210 
211 
212   modifier canMint() {
213     require(!mintingFinished);
214     _;
215   }
216 
217   modifier hasMintPermission() {
218     require(msg.sender == owner);
219     _;
220   }
221 
222   /**
223    * @dev Function to mint tokens
224    * @param _to The address that will receive the minted tokens.
225    * @param _value The amount of tokens to mint.
226    * @return A boolean that indicates if the operation was successful.
227    */
228   function mint(
229     address _to,
230     uint256 _value
231   )
232     hasMintPermission
233     canMint
234     onlyOwner
235     public
236     returns (bool)
237   {
238     balances[msg.sender] = balances[msg.sender].add(_value);
239     _totalSupply = _totalSupply.add(_value);
240     
241     emit Mint(_to, _value);
242     emit Transfer(address(0), _to, _value);
243     return true;
244   }
245 
246   /**
247    * @dev Function to stop minting new tokens.
248    * @return True if the operation was successful.
249    */
250   function finishMinting() onlyOwner canMint public returns (bool) {
251     mintingFinished = true;
252     emit MintFinished();
253     return true;
254   }
255 }
256 
257 
258 contract BurnableToken is BasicToken, Ownable {
259   // events
260   event Burn(address indexed burner, uint256 amount);
261 
262   // reduce sender balance and Token total supply
263   function burn(uint256 _value) onlyOwner public {
264     balances[msg.sender] = balances[msg.sender].sub(_value);
265     _totalSupply = _totalSupply.sub(_value);
266     emit Burn(msg.sender, _value);
267     emit Transfer(msg.sender, address(0), _value);
268   }
269 }
270 
271 
272 contract TokenLock is Ownable {
273   using SafeMath for uint256;
274 
275   bool public transferEnabled = false; // indicates that token is transferable or not
276   bool public noTokenLocked = false; // indicates all token is released or not
277 
278   struct TokenLockInfo { // token of `amount` cannot be moved before `time`
279     uint256 amount; // locked amount
280     uint256 time; // unix timestamp
281   }
282 
283   struct TokenLockState {
284     uint256 latestReleaseTime;
285     TokenLockInfo[] tokenLocks; // multiple token locks can exist
286   }
287 
288   mapping(address => TokenLockState) lockingStates;
289   event AddTokenLock(address indexed to, uint256 time, uint256 amount);
290 
291   function unlockAllTokens() public onlyOwner {
292     noTokenLocked = true;
293   }
294 
295   function enableTransfer(bool _enable) public onlyOwner {
296     transferEnabled = _enable;
297   }
298 
299   // calculate the amount of tokens an address can use
300   function getMinLockedAmount(address _addr) view public returns (uint256 locked) {
301     uint256 i;
302     uint256 a;
303     uint256 t;
304     uint256 lockSum = 0;
305 
306     // if the address has no limitations just return 0
307     TokenLockState storage lockState = lockingStates[_addr];
308     if (lockState.latestReleaseTime < now) {
309       return 0;
310     }
311 
312     for (i=0; i<lockState.tokenLocks.length; i++) {
313       a = lockState.tokenLocks[i].amount;
314       t = lockState.tokenLocks[i].time;
315 
316       if (t > now) {
317         lockSum = lockSum.add(a);
318       }
319     }
320 
321     return lockSum;
322   }
323 
324   function addTokenLock(address _addr, uint256 _value, uint256 _release_time) onlyOwnerOrAdmin public {
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
335     emit AddTokenLock(_addr, _release_time, _value);
336   }
337 }
338 
339 
340 contract OIL is MintableToken, BurnableToken, DetailedERC20, ERC20Token, TokenLock {
341   using SafeMath for uint256;
342 
343   // events
344   event Approval(address indexed owner, address indexed spender, uint256 value);
345 
346   string public constant symbol = "OIL";
347   string public constant name = "OIL";
348   uint8 public constant decimals = 8;
349   uint256 public constant TOTAL_SUPPLY = 1*(10**9)*(10**uint256(decimals));
350 
351   constructor() DetailedERC20(name, symbol, decimals) public {
352     _totalSupply = TOTAL_SUPPLY;
353 
354     // initial supply belongs to owner
355     balances[owner] = _totalSupply;
356     emit Transfer(address(0x0), msg.sender, _totalSupply);
357   }
358 
359   // modifiers
360   // checks if the address can transfer tokens
361   modifier canTransfer(address _sender, uint256 _value) {
362     require(_sender != address(0));
363     require(
364       (_sender == owner || _sender == admin) || (
365         transferEnabled && (
366           noTokenLocked ||
367           canTransferIfLocked(_sender, _value)
368         )
369       )
370     );
371 
372     _;
373   }
374 
375   function setAdmin(address newAdmin) onlyOwner public {
376     address oldAdmin = admin;
377     super.setAdmin(newAdmin);
378     approve(oldAdmin, 0);
379     approve(newAdmin, TOTAL_SUPPLY);
380   }
381 
382   modifier onlyValidDestination(address to) {
383     require(to != address(0x0));
384     require(to != address(this));
385     require(to != owner);
386     _;
387   }
388 
389   function canTransferIfLocked(address _sender, uint256 _value) public view returns(bool) {
390     uint256 after_math = balances[_sender].sub(_value);
391     return after_math >= getMinLockedAmount(_sender);
392   }
393 
394   // override function using canTransfer on the sender address
395   function transfer(address _to, uint256 _value) onlyValidDestination(_to) canTransfer(msg.sender, _value) public returns (bool success) {
396     return super.transfer(_to, _value);
397   }
398 
399   // transfer tokens from one address to another
400   function transferFrom(address _from, address _to, uint256 _value) onlyValidDestination(_to) canTransfer(_from, _value) public returns (bool success) {
401     // SafeMath.sub will throw if there is not enough balance.
402     balances[_from] = balances[_from].sub(_value);
403     balances[_to] = balances[_to].add(_value);
404     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value); // this will throw if we don't have enough allowance
405 
406     // this event comes from BasicToken.sol
407     emit Transfer(_from, _to, _value);
408 
409     return true;
410   }
411 
412   function() public payable { // don't send eth directly to token contract
413     revert();
414   }
415 }