1 pragma solidity ^0.4.23;
2 
3 // ----------------------------------------------------------------------------
4 // TOKENMOM Token(TM) Smart contract V.10
5 // 토큰맘 탈중앙화거래소 토큰 스마트 컨트랙트 버전 1.0
6 // Exchange URL : https://tokenmom.com
7 // Ethereum based Decentralized Exchange(DEX) & CEX Smart Contract V1.0
8 // Trading FEE  : 0.00% Event (Maker and Taker)
9 // Symbol       : TM
10 // Name         : TOKENMOM Token
11 // Total supply : 2,000,000,000
12 // Decimals     : 8
13 // ----------------------------------------------------------------------------
14 
15 contract ERC20Basic {
16   function totalSupply() public view returns (uint256);
17   function balanceOf(address who) public view returns (uint256);
18   function transfer(address to, uint256 value) public returns (bool);
19   event Transfer(address indexed from, address indexed to, uint256 value);
20 }
21 
22 contract Ownable {
23   address public owner;
24 
25 
26   event OwnershipRenounced(address indexed previousOwner);
27   event OwnershipTransferred(
28     address indexed previousOwner,
29     address indexed newOwner
30   );
31 
32   constructor() public {
33     owner = msg.sender;
34   }
35 
36   modifier onlyOwner() {
37     require(msg.sender == owner);
38     _;
39   }
40 
41 
42   function transferOwnership(address newOwner) public onlyOwner {
43     require(newOwner != address(0));
44     emit OwnershipTransferred(owner, newOwner);
45     owner = newOwner;
46   }
47 
48   function renounceOwnership() public onlyOwner {
49     emit OwnershipRenounced(owner);
50     owner = address(0);
51   }
52 }
53 
54 library Math {
55   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
56     return a >= b ? a : b;
57   }
58 
59   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
60     return a < b ? a : b;
61   }
62 
63   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
64     return a >= b ? a : b;
65   }
66 
67   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
68     return a < b ? a : b;
69   }
70 }
71 
72 library SafeMath {
73 
74   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
75     if (a == 0) {
76       return 0;
77     }
78     c = a * b;
79     assert(c / a == b);
80     return c;
81   }
82 
83   function div(uint256 a, uint256 b) internal pure returns (uint256) {
84     // assert(b > 0); // Solidity automatically throws when dividing by 0
85     // uint256 c = a / b;
86     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
87     return a / b;
88   }
89 
90   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
91     assert(b <= a);
92     return a - b;
93   }
94 
95   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
96     c = a + b;
97     assert(c >= a);
98     return c;
99   }
100 }
101 
102 library AddressUtils {
103 
104   function isContract(address addr) internal view returns (bool) {
105     uint256 size;
106     assembly { size := extcodesize(addr) }  // solium-disable-line security/no-inline-assembly
107     return size > 0;
108   }
109 
110 }
111 
112 contract ReentrancyGuard {
113 
114   bool private reentrancyLock = false;
115 
116   modifier nonReentrant() {
117     require(!reentrancyLock);
118     reentrancyLock = true;
119     _;
120     reentrancyLock = false;
121   }
122 
123 }
124 
125 contract BasicToken is ERC20Basic, ReentrancyGuard  {
126   using SafeMath for uint256;
127 
128   mapping(address => uint256) balances;
129 
130   uint256 totalSupply_;
131 
132   function totalSupply() public view returns (uint256) {
133     return totalSupply_;
134   }
135 
136 
137   function transfer(address _to, uint256 _value) public returns (bool) {
138     require(_to != address(0));
139     require(_value <= balances[msg.sender]);
140 
141     balances[msg.sender] = balances[msg.sender].sub(_value);
142     balances[_to] = balances[_to].add(_value);
143     emit Transfer(msg.sender, _to, _value);
144     return true;
145   }
146 
147   function balanceOf(address _owner) public view returns (uint256) {
148     return balances[_owner];
149   }
150 
151 }
152 
153 contract ERC20 is ERC20Basic {
154   function allowance(address owner, address spender) public view returns (uint256);
155   function transferFrom(address from, address to, uint256 value) public returns (bool);
156   function approve(address spender, uint256 value) public returns (bool);
157   event Approval(address indexed owner, address indexed spender, uint256 value);
158 }
159 
160 contract DetailedERC20 is ERC20 {
161   string public name;
162   string public symbol;
163   uint8 public decimals;
164 
165   constructor(string _name, string _symbol, uint8 _decimals) public {
166     name = _name;
167     symbol = _symbol;
168     decimals = _decimals;
169   }
170 }
171 
172 library SafeERC20 {
173   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
174     require(token.transfer(to, value));
175   }
176 
177   function safeTransferFrom(
178     ERC20 token,
179     address from,
180     address to,
181     uint256 value
182   )
183     internal
184   {
185     require(token.transferFrom(from, to, value));
186   }
187 
188   function safeApprove(ERC20 token, address spender, uint256 value) internal {
189     require(token.approve(spender, value));
190   }
191 }
192 
193 contract StandardToken is ERC20, BasicToken {
194 
195   mapping (address => mapping (address => uint256)) internal allowed;
196 
197   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
198     require(_to != address(0));
199     require(_value <= balances[_from]);
200     require(_value <= allowed[_from][msg.sender]);
201 
202     balances[_from] = balances[_from].sub(_value);
203     balances[_to] = balances[_to].add(_value);
204     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
205     emit Transfer(_from, _to, _value);
206     return true;
207   }
208 
209   function approve(address _spender, uint256 _value) public returns (bool) {
210     allowed[msg.sender][_spender] = _value;
211     emit Approval(msg.sender, _spender, _value);
212     return true;
213   }
214 
215   function allowance(address _owner, address _spender) public view returns (uint256) {
216     return allowed[_owner][_spender];
217   }
218 
219   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
220     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
221     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
222     return true;
223   }
224 
225   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
226     uint oldValue = allowed[msg.sender][_spender];
227     if (_subtractedValue > oldValue) {
228       allowed[msg.sender][_spender] = 0;
229     } else {
230       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
231     }
232     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
233     return true;
234   }
235 
236 }
237 
238 contract MintableToken is StandardToken, Ownable {
239   event Mint(address indexed to, uint256 amount);
240   event MintFinished();
241 
242   bool public mintingFinished = false;
243 
244 
245   modifier canMint() {
246     require(!mintingFinished);
247     _;
248   }
249 
250   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
251     totalSupply_ = totalSupply_.add(_amount);
252     balances[_to] = balances[_to].add(_amount);
253     emit Mint(_to, _amount);
254     emit Transfer(address(0), _to, _amount);
255     return true;
256   }
257 
258   function finishMinting() onlyOwner canMint public returns (bool) {
259     mintingFinished = true;
260     emit MintFinished();
261     return true;
262   }
263 }
264 
265 contract BurnableToken is BasicToken {
266 
267   event Burn(address indexed burner, uint256 value);
268 
269   function burn(uint256 _value) public {
270     _burn(msg.sender, _value);
271   }
272 
273   function _burn(address _who, uint256 _value) internal {
274     require(_value <= balances[_who]);
275 
276     balances[_who] = balances[_who].sub(_value);
277     totalSupply_ = totalSupply_.sub(_value);
278     emit Burn(_who, _value);
279     emit Transfer(_who, address(0), _value);
280   }
281 }
282 
283 contract Pausable is Ownable {
284   event Pause();
285   event Unpause();
286 
287   bool public paused = false;
288 
289   modifier whenNotPaused() {
290     require(!paused);
291     _;
292   }
293 
294   modifier whenPaused() {
295     require(paused);
296     _;
297   }
298 
299   function pause() onlyOwner whenNotPaused public {
300     paused = true;
301     emit Pause();
302   }
303 
304   function unpause() onlyOwner whenPaused public {
305     paused = false;
306     emit Unpause();
307   }
308 }
309 
310 contract TokenTimelock {
311   using SafeERC20 for ERC20Basic;
312 
313   // ERC20 basic token contract being held
314   ERC20Basic public token;
315 
316   // beneficiary of tokens after they are released
317   address public beneficiary;
318 
319   // timestamp when token release is enabled
320   uint256 public releaseTime;
321 
322   constructor(ERC20Basic _token, address _beneficiary, uint256 _releaseTime) public {
323     // solium-disable-next-line security/no-block-members
324     require(_releaseTime > block.timestamp);
325     token = _token;
326     beneficiary = _beneficiary;
327     releaseTime = _releaseTime;
328   }
329 
330   /**
331    * @notice Transfers tokens held by timelock to beneficiary.
332    */
333   function release() public {
334     // solium-disable-next-line security/no-block-members
335     require(block.timestamp >= releaseTime);
336 
337     uint256 amount = token.balanceOf(this);
338     require(amount > 0);
339 
340     token.safeTransfer(beneficiary, amount);
341   }
342 }
343 
344 contract TokenVesting is Ownable {
345   using SafeMath for uint256;
346   using SafeERC20 for ERC20Basic;
347 
348   event Released(uint256 amount);
349   event Revoked();
350 
351   // beneficiary of tokens after they are released
352   address public beneficiary;
353 
354   uint256 public cliff;
355   uint256 public start;
356   uint256 public duration;
357 
358   bool public revocable;
359 
360   mapping (address => uint256) public released;
361   mapping (address => bool) public revoked;
362 
363 
364   constructor(
365     address _beneficiary,
366     uint256 _start,
367     uint256 _cliff,
368     uint256 _duration,
369     bool _revocable
370   )
371     public
372   {
373     require(_beneficiary != address(0));
374     require(_cliff <= _duration);
375 
376     beneficiary = _beneficiary;
377     revocable = _revocable;
378     duration = _duration;
379     cliff = _start.add(_cliff);
380     start = _start;
381   }
382 
383   function release(ERC20Basic token) public {
384     uint256 unreleased = releasableAmount(token);
385 
386     require(unreleased > 0);
387 
388     released[token] = released[token].add(unreleased);
389 
390     token.safeTransfer(beneficiary, unreleased);
391 
392     emit Released(unreleased);
393   }
394 
395   function revoke(ERC20Basic token) public onlyOwner {
396     require(revocable);
397     require(!revoked[token]);
398 
399     uint256 balance = token.balanceOf(this);
400 
401     uint256 unreleased = releasableAmount(token);
402     uint256 refund = balance.sub(unreleased);
403 
404     revoked[token] = true;
405 
406     token.safeTransfer(owner, refund);
407 
408     emit Revoked();
409   }
410 
411   function releasableAmount(ERC20Basic token) public view returns (uint256) {
412     return vestedAmount(token).sub(released[token]);
413   }
414 
415   function vestedAmount(ERC20Basic token) public view returns (uint256) {
416     uint256 currentBalance = token.balanceOf(this);
417     uint256 totalBalance = currentBalance.add(released[token]);
418 
419     if (block.timestamp < cliff) {
420       return 0;
421     } else if (block.timestamp >= start.add(duration) || revoked[token]) {
422       return totalBalance;
423     } else {
424       return totalBalance.mul(block.timestamp.sub(start)).div(duration);
425     }
426   }
427 }
428 
429 contract StandardBurnableToken is BurnableToken, StandardToken  {
430 
431   /**
432    * @dev Burns a specific amount of tokens from the target address and decrements allowance
433    * @param _from address The address which you want to send tokens from
434    * @param _value uint256 The amount of token to be burned
435    */
436   function burnFrom(address _from, uint256 _value) public {
437     require(_value <= allowed[_from][msg.sender]);
438     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
439     // this function needs to emit an event with the updated approval.
440     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
441     _burn(_from, _value);
442   }
443 }
444 
445 contract TMToken is StandardBurnableToken, MintableToken, Pausable {
446 
447   string public constant name = "Tokenmom"; // solium-disable-line uppercase
448   string public constant symbol = "TM"; // solium-disable-line uppercase
449   uint8 public constant decimals = 8;
450   mapping(address => uint256) balances;
451   mapping(address => mapping(address => uint256)) allowed;
452   event Burn(address indexed from, uint256 value);
453   event Pause(address indexed from, uint256 value);
454   event Mint(address indexed to, uint256 amount);
455   uint256 public constant INITIAL_SUPPLY = 2000000000 * (10 ** uint256(decimals));
456   
457   constructor() public {
458     totalSupply_ = INITIAL_SUPPLY;
459     balances[msg.sender] = INITIAL_SUPPLY;
460     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
461   }
462 }