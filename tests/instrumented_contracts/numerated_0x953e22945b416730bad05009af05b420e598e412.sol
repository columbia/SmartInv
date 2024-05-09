1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0 || b == 0) {
6       return 0;
7     }
8 
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a); // overflow check
29     return c;
30   }
31 }
32 
33 contract ERC20Basic {
34   function totalSupply() public view returns (uint256);
35   function balanceOf(address who) public view returns (uint256);
36   function transfer(address to, uint256 value) public returns (bool);
37   event Transfer(address indexed from, address indexed to, uint256 value);
38 }
39 
40 contract ERC20 is ERC20Basic {
41   function allowance(address owner, address spender) public view returns (uint256);
42   function transferFrom(address from, address to, uint256 value) public returns (bool);
43   function approve(address spender, uint256 value) public returns (bool);
44   event Approval(address indexed owner, address indexed spender, uint256 value);
45 }
46 
47 contract DetailedERC20 is ERC20 {
48   string public name;
49   string public symbol;
50   uint8 public decimals;
51 
52   constructor(string _name, string _symbol, uint8 _decimals) public {
53     name = _name;
54     symbol = _symbol;
55     decimals = _decimals;
56   }
57 }
58 
59 contract Ownable {
60   address public owner;
61   address public admin;
62 
63   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
64 
65   /**
66    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
67    * account.
68    */
69   constructor() public {
70     owner = msg.sender;
71   }
72 
73 
74   /**
75    * @dev Throws if called by any account other than the owner.
76    */
77   modifier onlyOwner() {
78     require(msg.sender == owner);
79     _;
80   }
81 
82   modifier onlyOwnerOrAdmin() {
83     require(msg.sender != address(0) && (msg.sender == owner || msg.sender == admin));
84     _;
85   }
86 
87   /**
88    * @dev Allows the current owner to transfer control of the contract to a newOwner.
89    * @param newOwner The address to transfer ownership to.
90    */
91   function transferOwnership(address newOwner) onlyOwner public {
92     require(newOwner != address(0));
93     require(newOwner != owner);
94     require(newOwner != admin);
95 
96     emit OwnershipTransferred(owner, newOwner);
97     owner = newOwner;
98   }
99 
100   function setAdmin(address newAdmin) onlyOwner public {
101     require(admin != newAdmin);
102     require(owner != newAdmin);
103 
104     admin = newAdmin;
105   }
106 }
107 
108 contract BasicToken is ERC20Basic {
109   using SafeMath for uint256;
110 
111   mapping(address => uint256) balances;
112 
113   uint256 _totalSupply;
114 
115   /**
116   * @dev total number of tokens in existence
117   */
118   function totalSupply() public view returns (uint256) {
119     return _totalSupply;
120   }
121 
122   /**
123   * @dev transfer token for a specified address
124   * @param _to The address to transfer to.
125   * @param _value The amount to be transferred.
126   */
127   function transfer(address _to, uint256 _value) public returns (bool) {
128     require(_to != address(0));
129     require(_value > 0);
130     require(_value <= balances[msg.sender]);
131 
132     // SafeMath.sub will throw if there is not enough balance.
133     balances[msg.sender] = balances[msg.sender].sub(_value);
134     balances[_to] = balances[_to].add(_value);
135     emit Transfer(msg.sender, _to, _value);
136     return true;
137   }
138 
139   /**
140   * @dev Gets the balance of the specified address.
141   * @param _owner The address to query the the balance of.
142   * @return An uint256 representing the amount owned by the passed address.
143   */
144   function balanceOf(address _owner) public view returns (uint256 balance) {
145     return balances[_owner];
146   }
147 }
148 
149 contract ERC20Token is BasicToken, ERC20 {
150   using SafeMath for uint256;
151   mapping (address => mapping (address => uint256)) allowed;
152 
153   function approve(address _spender, uint256 _value) public returns (bool) {
154     require(_value == 0 || allowed[msg.sender][_spender] == 0);
155 
156     allowed[msg.sender][_spender] = _value;
157     emit Approval(msg.sender, _spender, _value);
158 
159     return true;
160   }
161 
162   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
163     return allowed[_owner][_spender];
164   }
165 
166   function increaseApproval(address _spender, uint256 _addedValue) public returns (bool success) {
167     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
168     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
169     return true;
170   }
171 
172   function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool success) {
173     uint256 oldValue = allowed[msg.sender][_spender];
174     if (_subtractedValue >= oldValue) {
175       allowed[msg.sender][_spender] = 0;
176     } else {
177       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
178     }
179     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
180     return true;
181   }
182 
183 }
184 
185 contract BurnableToken is BasicToken, Ownable {
186   // events
187   event Burn(address indexed burner, uint256 amount);
188 
189   // reduce sender balance and Token total supply
190   function burn(uint256 _value) onlyOwner public {
191     balances[msg.sender] = balances[msg.sender].sub(_value);
192     _totalSupply = _totalSupply.sub(_value);
193     emit Burn(msg.sender, _value);
194     emit Transfer(msg.sender, address(0), _value);
195   }
196 }
197 
198 contract TokenLock is Ownable {
199   using SafeMath for uint256;
200 
201   bool public transferEnabled = false; // indicates that token is transferable or not
202   bool public noTokenLocked = false; // indicates all token is released or not
203 
204   struct TokenLockInfo { // token of `amount` cannot be moved before `time`
205     uint256 amount; // locked amount
206     uint256 time; // unix timestamp
207   }
208 
209   struct TokenLockState {
210     uint256 latestReleaseTime;
211     TokenLockInfo[] tokenLocks; // multiple token locks can exist
212   }
213 
214   mapping(address => TokenLockState) lockingStates;
215   event AddTokenLock(address indexed to, uint256 time, uint256 amount);
216 
217   function unlockAllTokens() public onlyOwner {
218     noTokenLocked = true;
219   }
220 
221   function enableTransfer(bool _enable) public onlyOwner {
222     transferEnabled = _enable;
223   }
224 
225   // calculate the amount of tokens an address can use
226   function getMinLockedAmount(address _addr) view public returns (uint256 locked) {
227     uint256 i;
228     uint256 a;
229     uint256 t;
230     uint256 lockSum = 0;
231 
232     // if the address has no limitations just return 0
233     TokenLockState storage lockState = lockingStates[_addr];
234     if (lockState.latestReleaseTime < now) {
235       return 0;
236     }
237 
238     for (i=0; i<lockState.tokenLocks.length; i++) {
239       a = lockState.tokenLocks[i].amount;
240       t = lockState.tokenLocks[i].time;
241 
242       if (t > now) {
243         lockSum = lockSum.add(a);
244       }
245     }
246 
247     return lockSum;
248   }
249 
250   function addTokenLock(address _addr, uint256 _value, uint256 _release_time) onlyOwnerOrAdmin public {
251     require(_addr != address(0));
252     require(_value > 0);
253     require(_release_time > now);
254 
255     TokenLockState storage lockState = lockingStates[_addr]; // assigns a pointer. change the member value will update struct itself.
256     if (_release_time > lockState.latestReleaseTime) {
257       lockState.latestReleaseTime = _release_time;
258     }
259     lockState.tokenLocks.push(TokenLockInfo(_value, _release_time));
260 
261     emit AddTokenLock(_addr, _release_time, _value);
262   }
263 }
264 
265 contract GXCToken is BurnableToken, DetailedERC20, ERC20Token, TokenLock {
266   using SafeMath for uint256;
267   // uint256 public DISTRIBUTE_DATE = 1538319600; // 2018-10-01T00:00:00+09:00
268   uint256 public DISTRIBUTE_DATE = 1536224400; // 2018-09-06T18:00:00+09:00
269 
270   // events
271   event Approval(address indexed owner, address indexed spender, uint256 value);
272   event UpdatedBlockingState(address indexed to, uint256 start_time, uint256 step_time, uint256 unlock_step, uint256 value);
273 
274   string public constant symbol = "GXC";
275   string public constant name = "Game X Coin";
276   uint8 public constant decimals = 18;
277   uint256 public constant TOTAL_SUPPLY = 1*(10**9)*(10**uint256(decimals));
278 
279   constructor() DetailedERC20(name, symbol, decimals) public {
280     _totalSupply = TOTAL_SUPPLY;
281 
282     // initial supply belongs to owner
283     balances[owner] = _totalSupply;
284     emit Transfer(address(0x0), msg.sender, _totalSupply);
285   }
286 
287   // modifiers
288   // checks if the address can transfer tokens
289   modifier canTransfer(address _sender, uint256 _value) {
290     require(_sender != address(0));
291     require(
292       canTransferBefore(_sender) || (
293         transferEnabled && (
294         now > DISTRIBUTE_DATE && (
295             noTokenLocked ||
296             canTransferIfLocked(_sender, _value)
297           )
298         )
299       )
300     );
301 
302     _;
303   }
304 
305   function setAdmin(address newAdmin) onlyOwner public {
306     address oldAdmin = admin;
307     super.setAdmin(newAdmin);
308     approve(oldAdmin, 0);
309     approve(newAdmin, TOTAL_SUPPLY);
310   }
311 
312   modifier onlyValidDestination(address to) {
313     require(to != address(0x0));
314     require(to != address(this));
315     require(to != owner);
316     _;
317   }
318 
319   function canTransferBefore(address _sender) public view returns(bool) {
320     return _sender != address(0) && (_sender == owner || _sender == admin);
321   }
322 
323   function canTransferIfLocked(address _sender, uint256 _value) public view returns(bool) {
324     require(now >= DISTRIBUTE_DATE);
325     uint256 after_math = balances[_sender].sub(_value);
326     return after_math >= getMinLockedAmount(_sender);
327   }
328 
329   // override function using canTransfer on the sender address
330   function transfer(address _to, uint256 _value) onlyValidDestination(_to) canTransfer(msg.sender, _value) public returns (bool success) {
331     return super.transfer(_to, _value);
332   }
333 
334   // transfer tokens from one address to another
335   function transferFrom(address _from, address _to, uint256 _value) onlyValidDestination(_to) canTransfer(_from, _value) public returns (bool success) {
336     // SafeMath.sub will throw if there is not enough balance.
337     balances[_from] = balances[_from].sub(_value);
338     balances[_to] = balances[_to].add(_value);
339     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value); // this will throw if we don't have enough allowance
340 
341     // this event comes from BasicToken.sol
342     emit Transfer(_from, _to, _value);
343 
344     return true;
345   }
346 
347   function() public payable { // don't send eth directly to token contract
348     revert();
349   }
350   function test() public view returns(uint, uint) {
351     return (block.timestamp, block.number);
352   }
353 }