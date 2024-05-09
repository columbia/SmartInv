1 // ----------------------------------------------------------------------------
2 // KVIChianN contract
3 // Symbol      : KVI
4 // Name        : KVIChianN
5 // Decimals    : 18
6 // ----------------------------------------------------------------------------
7 
8 pragma solidity ^0.4.24;
9 
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 
18 contract ERC20 is ERC20Basic {
19   function allowance(address owner, address spender) public view returns (uint256);
20   function transferFrom(address from, address to, uint256 value) public returns (bool);
21   function approve(address spender, uint256 value) public returns (bool);
22   event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
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
88 
89 library SafeMath {
90   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
91     if (a == 0 || b == 0) {
92       return 0;
93     }
94 
95     uint256 c = a * b;
96     assert(c / a == b);
97     return c;
98   }
99 
100   function div(uint256 a, uint256 b) internal pure returns (uint256) {
101     // assert(b > 0); // Solidity automatically throws when dividing by 0
102     uint256 c = a / b;
103     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
104     return c;
105   }
106 
107   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
108     assert(b <= a);
109     return a - b;
110   }
111 
112   function add(uint256 a, uint256 b) internal pure returns (uint256) {
113     uint256 c = a + b;
114     assert(c >= a); // overflow check
115     return c;
116   }
117 }
118 
119 
120 contract BasicToken is ERC20Basic {
121   using SafeMath for uint256;
122 
123   mapping(address => uint256) balances;
124 
125   uint256 _totalSupply;
126 
127   /**
128   * @dev total number of tokens in existence
129   */
130   function totalSupply() public view returns (uint256) {
131     return _totalSupply;
132   }
133 
134   /**
135   * @dev transfer token for a specified address
136   * @param _to The address to transfer to.
137   * @param _value The amount to be transferred.
138   */
139   function transfer(address _to, uint256 _value) public returns (bool) {
140     require(_to != address(0));
141     require(_value > 0);
142     require(_value <= balances[msg.sender]);
143 
144     // SafeMath.sub will throw if there is not enough balance.
145     balances[msg.sender] = balances[msg.sender].sub(_value);
146     balances[_to] = balances[_to].add(_value);
147     emit Transfer(msg.sender, _to, _value);
148     return true;
149   }
150 
151   /**
152   * @dev Gets the balance of the specified address.
153   * @param _owner The address to query the the balance of.
154   * @return An uint256 representing the amount owned by the passed address.
155   */
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
214   bool public noTokenLocked = false; // indicates all token is released or not
215 
216   struct TokenLockInfo { // token of `amount` cannot be moved before `time`
217     uint256 amount; // locked amount
218     uint256 time; // unix timestamp
219   }
220 
221   struct TokenLockState {
222     uint256 latestReleaseTime;
223     TokenLockInfo[] tokenLocks; // multiple token locks can exist
224   }
225 
226   mapping(address => TokenLockState) lockingStates;
227   event AddTokenLock(address indexed to, uint256 time, uint256 amount);
228 
229   function unlockAllTokens() public onlyOwner {
230     noTokenLocked = true;
231   }
232 
233   function enableTransfer(bool _enable) public onlyOwner {
234     transferEnabled = _enable;
235   }
236 
237   // calculate the amount of tokens an address can use
238   function getMinLockedAmount(address _addr) view public returns (uint256 locked) {
239     uint256 i;
240     uint256 a;
241     uint256 t;
242     uint256 lockSum = 0;
243 
244     // if the address has no limitations just return 0
245     TokenLockState storage lockState = lockingStates[_addr];
246     if (lockState.latestReleaseTime < now) {
247       return 0;
248     }
249 
250     for (i=0; i<lockState.tokenLocks.length; i++) {
251       a = lockState.tokenLocks[i].amount;
252       t = lockState.tokenLocks[i].time;
253 
254       if (t > now) {
255         lockSum = lockSum.add(a);
256       }
257     }
258 
259     return lockSum;
260   }
261 
262   function addTokenLock(address _addr, uint256 _value, uint256 _release_time) onlyOwnerOrAdmin public {
263     require(_addr != address(0));
264     require(_value > 0);
265     require(_release_time > now);
266 
267     TokenLockState storage lockState = lockingStates[_addr]; // assigns a pointer. change the member value will update struct itself.
268     if (_release_time > lockState.latestReleaseTime) {
269       lockState.latestReleaseTime = _release_time;
270     }
271     lockState.tokenLocks.push(TokenLockInfo(_value, _release_time));
272 
273     emit AddTokenLock(_addr, _release_time, _value);
274   }
275 }
276 
277 contract KVIChianN is BurnableToken, DetailedERC20, ERC20Token, TokenLock {
278   using SafeMath for uint256;
279 
280   // events
281   event Approval(address indexed owner, address indexed spender, uint256 value);
282 
283   string public constant symbol = "KVI";
284   string public constant name = "KVIChianN";
285   uint8 public constant decimals = 18;
286   uint256 public constant TOTAL_SUPPLY = 10000000000*(10**uint256(decimals));
287 
288   constructor() DetailedERC20(name, symbol, decimals) public {
289     _totalSupply = TOTAL_SUPPLY;
290 
291     // initial supply belongs to owner
292     balances[owner] = _totalSupply;
293     emit Transfer(address(0x0), msg.sender, _totalSupply);
294   }
295 
296   // modifiers
297   // checks if the address can transfer tokens
298   modifier canTransfer(address _sender, uint256 _value) {
299     require(_sender != address(0));
300     require(
301       (_sender == owner || _sender == admin) || (
302         transferEnabled && (
303           noTokenLocked ||
304           canTransferIfLocked(_sender, _value)
305         )
306       )
307     );
308 
309     _;
310   }
311 
312   function setAdmin(address newAdmin) onlyOwner public {
313     address oldAdmin = admin;
314     super.setAdmin(newAdmin);
315     approve(oldAdmin, 0);
316     approve(newAdmin, 0);
317   }
318 
319   modifier onlyValidDestination(address to) {
320     require(to != address(0x0));
321     require(to != address(this));
322     require(to != owner);
323     _;
324   }
325 
326   function canTransferIfLocked(address _sender, uint256 _value) public view returns(bool) {
327     uint256 after_math = balances[_sender].sub(_value);
328     return after_math >= getMinLockedAmount(_sender);
329   }
330 
331   // override function using canTransfer on the sender address
332   function transfer(address _to, uint256 _value) onlyValidDestination(_to) canTransfer(msg.sender, _value) public returns (bool success) {
333     return super.transfer(_to, _value);
334   }
335 
336   // transfer tokens from one address to another
337   function transferFrom(address _from, address _to, uint256 _value) onlyValidDestination(_to) canTransfer(_from, _value) public returns (bool success) {
338     // SafeMath.sub will throw if there is not enough balance.
339     balances[_from] = balances[_from].sub(_value);
340     balances[_to] = balances[_to].add(_value);
341     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value); // this will throw if we don't have enough allowance
342 
343     // this event comes from BasicToken.sol
344     emit Transfer(_from, _to, _value);
345 
346     return true;
347   }
348 
349   function() public payable {
350     revert();
351   }
352 }