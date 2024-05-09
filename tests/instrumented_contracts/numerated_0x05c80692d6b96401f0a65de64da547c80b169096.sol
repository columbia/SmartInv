1 pragma solidity ^0.4.24;
2 
3 
4 contract ERC20Basic {
5   function totalSupply() public view returns (uint256);
6   function balanceOf(address who) public view returns (uint256);
7   function transfer(address to, uint256 value) public returns (bool);
8   event Transfer(address indexed from, address indexed to, uint256 value);
9 }
10 
11 contract ERC20 is ERC20Basic {
12   function allowance(address owner, address spender) public view returns (uint256);
13   function transferFrom(address from, address to, uint256 value) public returns (bool);
14   function approve(address spender, uint256 value) public returns (bool);
15   event Approval(address indexed owner, address indexed spender, uint256 value);
16 }
17 
18 contract DetailedERC20 is ERC20 {
19   string public name;
20   string public symbol;
21   string public note;
22   uint8 public decimals;
23 
24   constructor(string _name, string _symbol, string _note, uint8 _decimals) public {
25     name = _name;
26     symbol = _symbol;
27     note = _note;
28     decimals = _decimals;
29   }
30 }
31 
32 contract Ownable {
33   address public owner;
34   address public admin;
35 
36   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38   /**
39    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
40    * account.
41    */
42   constructor() public {
43     owner = msg.sender;
44   }
45 
46 
47   /**
48    * @dev Throws if called by any account other than the owner.
49    */
50   modifier onlyOwner() {
51     require(msg.sender == owner);
52     _;
53   }
54 
55   modifier onlyOwnerOrAdmin() {
56     require(msg.sender != address(0) && (msg.sender == owner || msg.sender == admin));
57     _;
58   }
59 
60   /**
61    * @dev Allows the current owner to transfer control of the contract to a newOwner.
62    * @param newOwner The address to transfer ownership to.
63    */
64   function transferOwnership(address newOwner) onlyOwner public {
65     require(newOwner != address(0));
66     require(newOwner != owner);
67     require(newOwner != admin);
68 
69     emit OwnershipTransferred(owner, newOwner);
70     owner = newOwner;
71   }
72 
73   function setAdmin(address newAdmin) onlyOwner public {
74     require(admin != newAdmin);
75     require(owner != newAdmin);
76 
77     admin = newAdmin;
78   }
79 }
80 
81 library SafeMath {
82   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
83     if (a == 0 || b == 0) {
84       return 0;
85     }
86 
87     uint256 c = a * b;
88     assert(c / a == b);
89     return c;
90   }
91 
92   function div(uint256 a, uint256 b) internal pure returns (uint256) {
93     // assert(b > 0); // Solidity automatically throws when dividing by 0
94     uint256 c = a / b;
95     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
96     return c;
97   }
98 
99   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
100     assert(b <= a);
101     return a - b;
102   }
103 
104   function add(uint256 a, uint256 b) internal pure returns (uint256) {
105     uint256 c = a + b;
106     assert(c >= a); // overflow check
107     return c;
108   }
109 }
110 
111 contract BasicToken is ERC20Basic {
112   using SafeMath for uint256;
113 
114   mapping(address => uint256) balances;
115 
116   uint256 _totalSupply;
117 
118   /**
119   * @dev total number of tokens in existence
120   */
121   function totalSupply() public view returns (uint256) {
122     return _totalSupply;
123   }
124 
125   /**
126   * @dev transfer token for a specified address
127   * @param _to The address to transfer to.
128   * @param _value The amount to be transferred.
129   */
130   function transfer(address _to, uint256 _value) public returns (bool) {
131     require(_to != address(0));
132     require(_value > 0);
133     require(_value <= balances[msg.sender]);
134 
135     // SafeMath.sub will throw if there is not enough balance.
136     balances[msg.sender] = balances[msg.sender].sub(_value);
137     balances[_to] = balances[_to].add(_value);
138     emit Transfer(msg.sender, _to, _value);
139     return true;
140   }
141 
142   /**
143   * @dev Gets the balance of the specified address.
144   * @param _owner The address to query the the balance of.
145   * @return An uint256 representing the amount owned by the passed address.
146   */
147   function balanceOf(address _owner) public view returns (uint256 balance) {
148     return balances[_owner];
149   }
150 }
151 
152 contract ERC20Token is BasicToken, ERC20 {
153   using SafeMath for uint256;
154   mapping (address => mapping (address => uint256)) allowed;
155 
156   function approve(address _spender, uint256 _value) public returns (bool) {
157     require(_value == 0 || allowed[msg.sender][_spender] == 0);
158 
159     allowed[msg.sender][_spender] = _value;
160     emit Approval(msg.sender, _spender, _value);
161 
162     return true;
163   }
164 
165   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
166     return allowed[_owner][_spender];
167   }
168 
169   function increaseApproval(address _spender, uint256 _addedValue) public returns (bool success) {
170     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
171     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
172     return true;
173   }
174 
175   function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool success) {
176     uint256 oldValue = allowed[msg.sender][_spender];
177     if (_subtractedValue >= oldValue) {
178       allowed[msg.sender][_spender] = 0;
179     } else {
180       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
181     }
182     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
183     return true;
184   }
185 
186 }
187 
188 contract BurnableToken is BasicToken, Ownable {
189   string internal constant INVALID_TOKEN_VALUES = 'Invalid token values';
190   string internal constant NOT_ENOUGH_TOKENS = 'Not enough tokens';
191   
192   // events
193   event Burn(address indexed burner, uint256 amount);
194   event Mint(address indexed minter, uint256 amount);
195   event AddressBurn(address burner, uint256 amount);
196 
197   // reduce sender balance and Token total supply
198   function burn(uint256 _value) onlyOwner public {
199     balances[msg.sender] = balances[msg.sender].sub(_value);
200     _totalSupply = _totalSupply.sub(_value);
201     emit Burn(msg.sender, _value);
202     emit Transfer(msg.sender, address(0), _value);
203   }
204    // reduce address balance and Token total supply
205   function addressburn(address _of, uint256 _value) onlyOwner public {
206     require(_value > 0, INVALID_TOKEN_VALUES);
207   require(_value <= balances[_of], NOT_ENOUGH_TOKENS);
208   balances[_of] = balances[_of].sub(_value);
209   _totalSupply = _totalSupply.sub(_value);
210   emit AddressBurn(_of, _value);
211     emit Transfer(_of, address(0), _value);
212   }
213   
214   // increase sender balance and Token total supply
215   function mint(uint256 _value) onlyOwner public {
216     balances[msg.sender] = balances[msg.sender].add(_value);
217     _totalSupply = _totalSupply.add(_value);
218     emit Mint(msg.sender, _value);
219     emit Transfer(address(0), msg.sender, _value);
220   }
221 }
222 
223 contract TokenLock is Ownable {
224   using SafeMath for uint256;
225 
226   bool public transferEnabled = false; // indicates that token is transferable or not
227   bool public noTokenLocked = false; // indicates all token is released or not
228 
229   struct TokenLockInfo { // token of `amount` cannot be moved before `time`
230     uint256 amount; // locked amount
231     uint256 time; // unix timestamp
232   }
233 
234   struct TokenLockState {
235     uint256 latestReleaseTime;
236     TokenLockInfo[] tokenLocks; // multiple token locks can exist
237   }
238 
239   mapping(address => TokenLockState) lockingStates;  
240   mapping(address => bool) addresslock;
241   mapping(address => uint256) lockbalances;
242   
243   event AddTokenLockDate(address indexed to, uint256 time, uint256 amount);
244   event AddTokenLock(address indexed to, uint256 amount);
245   event AddressLockTransfer(address indexed to, bool _enable);
246 
247   function unlockAllTokens() public onlyOwner {
248     noTokenLocked = true;
249   }
250 
251   function enableTransfer(bool _enable) public onlyOwner {
252     transferEnabled = _enable;
253   }
254 
255   // calculate the amount of tokens an address can use
256   function getMinLockedAmount(address _addr) view public returns (uint256 locked) {
257     uint256 i;
258     uint256 a;
259     uint256 t;
260     uint256 lockSum = 0;
261 
262     // if the address has no limitations just return 0
263     TokenLockState storage lockState = lockingStates[_addr];
264     if (lockState.latestReleaseTime < now) {
265       return 0;
266     }
267 
268     for (i=0; i<lockState.tokenLocks.length; i++) {
269       a = lockState.tokenLocks[i].amount;
270       t = lockState.tokenLocks[i].time;
271 
272       if (t > now) {
273         lockSum = lockSum.add(a);
274       }
275     }
276 
277     return lockSum;
278   }
279   
280   function lockVolumeAddress(address _sender) view public returns (uint256 locked) {
281     return lockbalances[_sender];
282   }
283 
284   function addTokenLockDate(address _addr, uint256 _value, uint256 _release_time) onlyOwnerOrAdmin public {
285     require(_addr != address(0));
286     require(_value > 0);
287     require(_release_time > now);
288 
289     TokenLockState storage lockState = lockingStates[_addr]; // assigns a pointer. change the member value will update struct itself.
290     if (_release_time > lockState.latestReleaseTime) {
291       lockState.latestReleaseTime = _release_time;
292     }
293     lockState.tokenLocks.push(TokenLockInfo(_value, _release_time));
294 
295     emit AddTokenLockDate(_addr, _release_time, _value);
296   }
297   
298   function addTokenLock(address _addr, uint256 _value) onlyOwnerOrAdmin public {
299     require(_addr != address(0));
300     require(_value >= 0);
301 
302     lockbalances[_addr] = _value;
303 
304     emit AddTokenLock(_addr, _value);
305   }
306   
307   function addressLockTransfer(address _addr, bool _enable) public onlyOwner {
308     require(_addr != address(0));
309     addresslock[_addr] = _enable;
310   
311   emit AddressLockTransfer(_addr, _enable);
312   }
313 }
314 
315 contract SNTToken is BurnableToken, DetailedERC20, ERC20Token, TokenLock {
316   using SafeMath for uint256;
317 
318   // events
319   event Approval(address indexed owner, address indexed spender, uint256 value);
320 
321   string public constant symbol = "SNT";
322   string public constant name = "Saint Way Token";
323   string public constant note = "A project to form a development alliance for the establishment of a block chain ecosystem to be used as the key currency of Egypt under the Fourth Industrial Promotion Plan led by the Korea Culture and Tourism Association";
324   uint8  public constant decimals = 18;
325   
326   uint256 constant TOTAL_SUPPLY = 20000000 *(10**uint256(decimals));
327 
328   uint256 public   price = 250;  // 1 ETH = 250 tokens    
329   
330   /*  
331   *  Addresses  
332   */
333 
334   address public addressOwner              = 0x374443121aFDBf845CDE6462050CEB6Fba1522BF;  // owner token holder
335 
336   address public addressETHDepositDevelop  = 0xdeC80ea82965234376739e4ae4B3AFa9d843d647;  // (25%)  - Development
337   address public addressETHDepositMarket   = 0x2a53Ce6b62C9AcFb9676dCf4b40aAf4E729faE0E;  // (50%)  - market activity     
338   address public addressETHWeeklyRecomm    = 0x872677C61e8767A9E2C36BE592519b7bB11f488C;  // (7.5%) - weekly settlement recommendation reward    
339   address public addressETHDailyMarket     = 0xdCB1A2CefB6cF560ebEB90b5c0a11a075eC86009;  // (7.5%) - daliy  settlement market activity reward
340   address public addressETHWeeklyComprh    = 0x4C35A7986c19111b1bcd2d438d07a606f72586e4;  // (10%)  - weekly settlement comprehensive reward 
341 
342 
343   constructor() DetailedERC20(name, symbol, note, decimals) public {
344     _totalSupply = TOTAL_SUPPLY;
345 
346     // initial supply belongs to owner
347     balances[addressOwner] = _totalSupply;
348     emit Transfer(address(0x0), addressOwner, _totalSupply);
349   }
350 
351   // modifiers
352   // checks if the address can transfer tokens
353   modifier canTransfer(address _sender, uint256 _value) {
354     require(_sender != address(0));
355     require(
356       (_sender == owner || _sender == admin) || (
357         transferEnabled && (
358           noTokenLocked ||
359           (!addresslock[_sender] && canTransferIfLocked(_sender, _value) && canTransferIfLocked(_sender, _value))
360         )
361       )
362     );
363 
364     _;
365   }
366 
367   function setAdmin(address newAdmin) onlyOwner public {
368   address oldAdmin = admin;
369     super.setAdmin(newAdmin);
370     approve(oldAdmin, 0);
371     approve(newAdmin, TOTAL_SUPPLY);
372   }
373 
374   modifier onlyValidDestination(address to) {
375     require(to != address(0x0));
376     require(to != address(this));
377     require(to != owner);
378     _;
379   }
380 
381   function canTransferIfLocked(address _sender, uint256 _value) public view returns(bool) {
382     uint256 after_math = balances[_sender].sub(_value);
383   
384     return after_math >= (getMinLockedAmount(_sender) + lockVolumeAddress(_sender));
385   }
386   
387   function LockTransferAddress(address _sender) public view returns(bool) {
388     return addresslock[_sender];
389   }
390 
391   // override function using canTransfer on the sender address
392   function transfer(address _to, uint256 _value) onlyValidDestination(_to) canTransfer(msg.sender, _value) public returns (bool success) {
393     return super.transfer(_to, _value);
394   }
395 
396   // transfer tokens from one address to another
397   function transferFrom(address _from, address _to, uint256 _value) onlyValidDestination(_to) canTransfer(_from, _value) public returns (bool success) {
398     // SafeMath.sub will throw if there is not enough balance.
399     balances[_from] = balances[_from].sub(_value);
400     balances[_to] = balances[_to].add(_value);
401     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value); // this will throw if we don't have enough allowance
402 
403     // this event comes from BasicToken.sol
404     emit Transfer(_from, _to, _value);
405 
406     return true;
407   }
408 
409  
410    /*
411     *  Set token price 
412     *  owner only function 
413     */ 
414     
415     function setPrice(uint256 _newPrice) onlyOwner public {
416         require(_newPrice > 0);
417         price = _newPrice;
418     }
419     
420     function getPrice()  public view returns (uint256) {
421        return price;
422     }
423 
424 
425     /*  
426      *  main function for receiving the ETH from the investors 
427      *  and transferring tokens after calculating the price 
428      */    
429     
430     function buyTokens(address _buyer, uint256 _value) internal  {
431 
432             // prevent transfer to 0x0 address
433             require(_buyer != 0x0);
434 
435             // msg value should be more than 0
436             require(_value > 0);
437 
438             // total tokens equal price is multiplied by the ether value provided 
439             uint tokens = (SafeMath.mul(_value, price));
440 
441             // tokens should be less than or equal to available for sale
442             require(tokens <= balances[addressOwner]);
443             
444             addressETHDepositDevelop.transfer(SafeMath.div(SafeMath.mul(_value,25),100));
445             addressETHDepositMarket.transfer(SafeMath.div(SafeMath.mul(_value, 50),100));
446         
447             addressETHWeeklyRecomm.transfer(SafeMath.div(SafeMath.mul(_value, 75),1000));
448             addressETHDailyMarket.transfer(SafeMath.div(SafeMath.mul(_value,  75),1000));
449             addressETHWeeklyComprh.transfer(SafeMath.div(SafeMath.mul(_value, 10),100));
450     
451             balances[_buyer] = SafeMath.add( balances[_buyer], tokens);
452             balances[addressOwner] = SafeMath.sub(balances[addressOwner], tokens);
453             emit Transfer(this, _buyer, tokens );
454         }
455 
456 
457      /*
458      *  default fall back function 
459      *  Buy Tokens      
460      */
461 
462   function() public payable { 
463           buyTokens(msg.sender, msg.value);    
464   }
465 }