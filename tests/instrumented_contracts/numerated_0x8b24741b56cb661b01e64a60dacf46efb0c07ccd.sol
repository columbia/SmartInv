1 /**
2  *Submitted for verification at Etherscan.io on 2020-05-28
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2020-05-26
7 */
8 
9 pragma solidity 0.4.23;
10 
11 // File: contracts/token/ERC20Basic.sol
12 
13 contract ERC20Basic {
14   function totalSupply() public view returns (uint256);
15   function balanceOf(address who) public view returns (uint256);
16   function transfer(address to, uint256 value) public returns (bool);
17   event Transfer(address indexed from, address indexed to, uint256 value);
18 }
19 
20 // File: contracts/token/ERC20.sol
21 
22 contract ERC20 is ERC20Basic {
23   function allowance(address owner, address spender) public view returns (uint256);
24   function transferFrom(address from, address to, uint256 value) public returns (bool);
25   function approve(address spender, uint256 value) public returns (bool);
26   event Approval(address indexed owner, address indexed spender, uint256 value);
27 }
28 
29 // File: contracts/token/DetailedERC20.sol
30 
31 contract DetailedERC20 is ERC20 {
32   string public name;
33   string public symbol;
34   uint8 public decimals;
35 
36   constructor(string _name, string _symbol, uint8 _decimals) public {
37     name = _name;
38     symbol = _symbol;
39     decimals = _decimals;
40   }
41 }
42 
43 // File: contracts/token/Ownable.sol
44 
45 contract Ownable {
46   address public owner;
47   address public admin;
48 
49   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51   /**
52    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
53    * account.
54    */
55   constructor() public {
56     owner = msg.sender;
57   }
58 
59 
60   /**
61    * @dev Throws if called by any account other than the owner.
62    */
63   modifier onlyOwner() {
64     require(msg.sender == owner);
65     _;
66   }
67 
68   modifier onlyOwnerOrAdmin() {
69     require(msg.sender != address(0) && (msg.sender == owner || msg.sender == admin));
70     _;
71   }
72 
73   /**
74    * @dev Allows the current owner to transfer control of the contract to a newOwner.
75    * @param newOwner The address to transfer ownership to.
76    */
77   function transferOwnership(address newOwner) onlyOwner public {
78     require(newOwner != address(0));
79     require(newOwner != owner);
80     require(newOwner != admin);
81 
82     emit OwnershipTransferred(owner, newOwner);
83     owner = newOwner;
84   }
85 
86   function setAdmin(address newAdmin) onlyOwner public {
87     require(admin != newAdmin);
88     require(owner != newAdmin);
89 
90     admin = newAdmin;
91   }
92 }
93 
94 // File: contracts/token/SafeMath.sol
95 
96 library SafeMath {
97   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
98     if (a == 0 || b == 0) {
99       return 0;
100     }
101 
102     uint256 c = a * b;
103     assert(c / a == b);
104     return c;
105   }
106 
107   function div(uint256 a, uint256 b) internal pure returns (uint256) {
108     // assert(b > 0); // Solidity automatically throws when dividing by 0
109     uint256 c = a / b;
110     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
111     return c;
112   }
113 
114   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
115     assert(b <= a);
116     return a - b;
117   }
118 
119   function add(uint256 a, uint256 b) internal pure returns (uint256) {
120     uint256 c = a + b;
121     assert(c >= a); // overflow check
122     return c;
123   }
124 }
125 
126 // File: contracts/token/MVLToken.sol
127 
128 contract BasicToken is ERC20Basic {
129   using SafeMath for uint256;
130 
131   mapping(address => uint256) balances;
132 
133   uint256 _totalSupply;
134 
135   /**
136   * @dev total number of tokens in existence
137   */
138   function totalSupply() public view returns (uint256) {
139     return _totalSupply;
140   }
141 
142 
143   function transfer(address _to, uint256 _value) public returns (bool) {
144     require(_to != address(0));
145     require(_value > 0);
146     require(_value <= balances[msg.sender]);
147 
148 
149     balances[msg.sender] = balances[msg.sender].sub(_value);
150     balances[_to] = balances[_to].add(_value);
151     emit Transfer(msg.sender, _to, _value);
152     return true;
153   }
154 
155   
156   function balanceOf(address _owner) public view returns (uint256 balance) {
157     return balances[_owner];
158   }
159 }
160 
161 contract ERC20Token is BasicToken, ERC20 {
162   using SafeMath for uint256;
163   mapping (address => mapping (address => uint256)) allowed;
164 
165   function approve(address _spender, uint256 _value) public returns (bool) {
166     require(_value == 0 || allowed[msg.sender][_spender] == 0);
167 
168     allowed[msg.sender][_spender] = _value;
169     emit Approval(msg.sender, _spender, _value);
170 
171     return true;
172   }
173 
174   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
175     return allowed[_owner][_spender];
176   }
177 
178   function increaseApproval(address _spender, uint256 _addedValue) public returns (bool success) {
179     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
180     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
181     return true;
182   }
183 
184   function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool success) {
185     uint256 oldValue = allowed[msg.sender][_spender];
186     if (_subtractedValue >= oldValue) {
187       allowed[msg.sender][_spender] = 0;
188     } else {
189       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
190     }
191     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
192     return true;
193   }
194 
195 }
196 
197 contract BurnableToken is BasicToken, Ownable {
198   // events
199   event Burn(address indexed burner, uint256 amount);
200 
201   // reduce sender balance and Token total supply
202   function burn(uint256 _value) onlyOwner public {
203     balances[msg.sender] = balances[msg.sender].sub(_value);
204     _totalSupply = _totalSupply.sub(_value);
205     emit Burn(msg.sender, _value);
206     emit Transfer(msg.sender, address(0), _value);
207   }
208 }
209 
210 contract TokenLock is Ownable {
211   using SafeMath for uint256;
212 
213   bool public transferEnabled = false; // indicates that token is transferable or not
214 
215 //   bool public noTokenLocked = false; // indicates all token is released or not
216 
217   struct TokenLockInfo { // token of `amount` cannot be moved before `time`
218     uint256 amount; // locked amount
219     uint256 time; // unix timestamp
220 
221   }
222   
223 
224   struct TokenLockState {
225     uint256 latestReleaseTime;
226     TokenLockInfo[] tokenLocks; // multiple token locks can exist
227     bool noTokenLocked;
228   }
229 
230   mapping(address => TokenLockState) lockingStates;
231   mapping(address => TokenLockInfo) lockInfo;
232   event AddTokenLock(address indexed to, uint256 time, uint256 amount);
233 
234 //   function unlockAllTokens() public onlyOwner {
235 //     noTokenLocked = true;
236 //   }
237 
238   function enableTransfer(bool _enable) public onlyOwner {
239     transferEnabled = _enable;
240   }
241 
242   // calculate the amount of tokens an address can use
243   function getMinLockedAmount(address _addr) view public returns (uint256 locked) {
244     uint256 i;
245     uint256 a;
246     uint256 t;
247     uint256 lockSum = 0;
248 
249     // if the address has no limitations just return 0
250     TokenLockState storage lockState = lockingStates[_addr];
251     if (lockState.latestReleaseTime < now) {
252       return 0;
253     }
254 
255     for (i=0; i<lockState.tokenLocks.length; i++) {
256       a = lockState.tokenLocks[i].amount;
257       t = lockState.tokenLocks[i].time;
258 
259       if (t > now) {
260         lockSum = lockSum.add(a);
261       }
262     }
263     return lockSum;
264   }
265   
266   function getLockAmountDate(address _addr) view public returns (uint256 locked, uint256 time, uint releaseT) {
267     uint256 i;
268     uint256 a;
269     uint256 t;
270     uint256 lockSum = 0;
271     uint256 releaseTime;
272 
273     // if the address has no limitations just return 0
274     TokenLockState storage lockState = lockingStates[_addr];
275     if (lockState.latestReleaseTime < now) {
276       return (0,0,0);
277     }
278 
279     for (i=0; i<lockState.tokenLocks.length; i++) {
280         // if (lockState.noTokenLocked == true) {
281             a = lockState.tokenLocks[i].amount;
282             t = lockState.tokenLocks[i].time;
283             if (t > now) {
284                 lockSum = lockSum.add(a);
285                 releaseTime = uint(t - now);
286             } else {
287                 releaseTime = 0;
288             }
289         // }
290     }
291     return (lockSum, releaseTime, t);
292   }
293   
294   function unlockAddress(address _addr) onlyOwnerOrAdmin external {
295     require(_addr != address(0));
296     uint16 i;
297     for(i=0; i<lockingStates[_addr].tokenLocks.length; i++ ){
298         if (lockingStates[_addr].tokenLocks[i].time > now) {
299             lockingStates[_addr].tokenLocks[i].time = now + 60;
300         }
301     }
302   }
303 
304 
305   function addTokenLock(address _addr, uint256 _value, uint256 _release_time) onlyOwnerOrAdmin public {
306     require(_addr != address(0));
307     require(_value > 0); 
308     require(_release_time > now);
309 
310     TokenLockState storage lockState = lockingStates[_addr]; // assigns a pointer. change the member value will update struct itself.
311     if (_release_time > lockState.latestReleaseTime) {
312       lockState.latestReleaseTime = _release_time;
313     }
314     // uint8 a;
315     // for (a=0; a<10; a++){
316     // //   lockState.tokenLocks.push(TokenLockInfo(_value / 10, _release_time + 30  days * a));  
317     //   lockState.tokenLocks.push(TokenLockInfo(_value / 10, _release_time + (60 * a)));
318     // }
319     lockState.tokenLocks.push(TokenLockInfo(_value, _release_time));
320 
321     emit AddTokenLock(_addr, _release_time, _value);
322   }
323 }
324 
325 contract AMFToken is BurnableToken, DetailedERC20, ERC20Token, TokenLock {
326   using SafeMath for uint256;
327 
328   // events
329   event Approval(address indexed owner, address indexed spender, uint256 value);
330 
331   string public constant symbol = "AMF";
332   string public constant name = "Asia Model Festival";
333   uint8 public constant decimals = 18;
334   uint256 public constant TOTAL_SUPPLY = 4*(10**9)*(10**uint256(decimals));
335 
336   constructor() DetailedERC20(name, symbol, decimals) public {
337     _totalSupply = TOTAL_SUPPLY;
338 
339     // initial supply belongs to owner
340     balances[owner] = _totalSupply;
341     emit Transfer(address(0x0), msg.sender, _totalSupply);
342   }
343 
344   // modifiers
345   // checks if the address can transfer tokens
346   modifier canTransfer(address _sender, uint256 _value) {
347     require(_sender != address(0));
348     require(
349       (_sender == owner || _sender == admin) || (
350         transferEnabled && (
351         //   noTokenLocked ||
352           canTransferIfLocked(_sender, _value)
353         )
354       )
355     );
356 
357     _;
358   }
359 
360   function setAdmin(address newAdmin) onlyOwner public {
361     address oldAdmin = admin;
362     super.setAdmin(newAdmin);
363     approve(oldAdmin, 0);
364     approve(newAdmin, TOTAL_SUPPLY);
365   }
366 
367 //   modifier onlyValidDestination(address to) {
368 //     require(to != address(0x0));
369 //     require(to != address(this));
370 //     require(to != owner);
371 //     _;
372 //   }
373 
374   function canTransferIfLocked(address _sender, uint256 _value) public view returns(bool) {
375     uint256 after_math = balances[_sender].sub(_value);
376     return after_math >= getMinLockedAmount(_sender);
377   }
378 
379   // override function using canTransfer on the sender address
380 //   function transfer(address _to, uint256 _value) onlyValidDestination(_to) canTransfer(msg.sender, _value) public returns (bool success) {
381   function transfer(address _to, uint256 _value) canTransfer(msg.sender, _value) public returns (bool success) {
382     return super.transfer(_to, _value);
383   }
384 
385   // transfer tokens from one address to another
386 //   function transferFrom(address _from, address _to, uint256 _value) onlyValidDestination(_to) canTransfer(_from, _value) public returns (bool success) {
387   function transferFrom(address _from, address _to, uint256 _value)  canTransfer(_from, _value) public returns (bool success) {
388     // SafeMath.sub will throw if there is not enough balance.
389     balances[_from] = balances[_from].sub(_value);
390     balances[_to] = balances[_to].add(_value);
391     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value); // this will throw if we don't have enough allowance
392 
393     // this event comes from BasicToken.sol
394     emit Transfer(_from, _to, _value);
395 
396     return true;
397   }
398 
399   function() public payable { // don't send eth directly to token contract
400     revert();
401   }
402 }