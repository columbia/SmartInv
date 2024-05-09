1 pragma solidity ^0.4.24;
2 
3 // File: contracts\token\ERC20.sol
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 contract ERC20 {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address owner) public view returns (uint256);
12   function allowance(address owner, address spender) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   function transferFrom(address from, address to, uint256 value) public returns (bool);
15   function approve(address spender, uint256 value) public returns (bool);
16 
17   event Transfer(address indexed from, address indexed to, uint256 value);
18   event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 // File: contracts\common\Ownable.sol
22 
23 contract Ownable {
24   address private _owner;
25 
26   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
27 
28   modifier onlyOwner() {
29     require(msg.sender == _owner, "Unauthorized.");
30     _;
31   }
32 
33   constructor() public {
34     _owner = msg.sender;
35   }
36 
37   function owner() public view returns (address) {
38     return _owner;
39   }
40 
41   function transferOwnership(address newOwner) public onlyOwner {
42     require(newOwner != address(0), "Non-zero address required.");
43     emit OwnershipTransferred(_owner, newOwner);
44     _owner = newOwner;
45   }
46 }
47 
48 // File: contracts\common\SafeMath.sol
49 
50 library SafeMath {
51 
52   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
53     if (_a == 0) {
54       return 0;
55     }
56 
57     uint256 c = _a * _b;
58     require(c / _a == _b, "Invalid argument.");
59 
60     return c;
61   }
62 
63   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
64     require(_b > 0, "Invalid argument.");
65     uint256 c = _a / _b;
66 
67     return c;
68   }
69 
70   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
71     require(_b <= _a, "Invalid argument.");
72     uint256 c = _a - _b;
73 
74     return c;
75   }
76 
77   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
78     uint256 c = _a + _b;
79     require(c >= _a, "Invalid argument.");
80 
81     return c;
82   }
83 
84   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
85     require(b != 0, "Invalid argument.");
86     return a % b;
87   }
88 }
89 
90 // File: contracts\token\StandardToken.sol
91 
92 contract StandardToken is ERC20, Ownable {
93   using SafeMath for uint256;
94 
95   uint256 internal _totalSupply;
96 
97   mapping (address => uint256) internal _balances;
98   mapping (address => mapping (address => uint256)) internal _allowed;
99 
100   event Transfer(address indexed from, address indexed to, uint256 value);
101   event Approval(address indexed owner, address indexed spender, uint256 value);
102 
103   constructor(uint256 initialSupply) public {
104     _totalSupply = initialSupply;
105     _balances[msg.sender] = initialSupply;
106   }
107 
108   function () public payable {
109     revert("You cannot buy tokens.");
110   }
111 
112   function totalSupply() public view returns (uint256) {
113     return _totalSupply;
114   }
115 
116   function balanceOf(address owner) public view returns (uint256) {
117     return _balances[owner];
118   }
119 
120   /**
121    * Transfer
122    */
123 
124   function transfer(address to, uint256 value) public returns (bool) {
125     require(to != address(0), "Non-zero address required.");
126     require(_balances[msg.sender] >= value, "Insufficient balance.");
127 
128     _balances[msg.sender] = _balances[msg.sender].sub(value);
129     _balances[to] = _balances[to].add(value);
130     emit Transfer(msg.sender, to, value);
131     return true;
132   }
133 
134   function transferFrom(address from, address to, uint256 value) public returns (bool) {
135     require(to != address(0), "Non-zero address required.");
136     require(_balances[from] >= value, "Insufficient balance.");
137     require(_allowed[from][msg.sender] >= value, "Insufficient balance.");
138 
139     _balances[from] = _balances[from].sub(value);
140     _balances[to] = _balances[to].add(value);
141     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
142     emit Transfer(from, to, value);
143     return true;
144   }
145 
146   /**
147    * Approve
148    */
149 
150   function allowance(address owner, address spender) public view returns (uint256) {
151     return _allowed[owner][spender];
152   }
153 
154   function approve(address spender, uint256 value) public returns (bool) {
155     _allowed[msg.sender][spender] = value;
156     emit Approval(msg.sender, spender, value);
157     return true;
158   }
159 }
160 
161 // File: contracts\token\ERC223.sol
162 
163 /**
164  * @title ERC223 interface
165  * @dev see https://github.com/ethereum/EIPs/issues/223
166  */
167 contract ERC223 {
168   function name() public view returns (string);
169   function symbol() public view returns (string);
170   function decimals() public view returns (uint8);
171 
172   function transfer(address to, uint256 value, bytes data) public returns (bool);
173   function transferFrom(address from, address to, uint256 value, bytes data) public returns (bool);
174 
175   event Transfer(address indexed from, address indexed to, uint256 value, bytes data);
176 }
177 
178 contract ERC223Receiver {
179   function tokenFallback(address from, uint256 value, bytes data) public;
180 }
181 
182 // File: contracts\token\MintableToken.sol
183 
184 contract MintableToken {
185   function mintingFinished() public view returns (bool);
186   function finishMinting() public returns (bool);
187 
188   function mint(address to, uint256 value) public returns (bool);
189 }
190 
191 // File: contracts\token\BurnableToken.sol
192 
193 contract BurnableToken {
194   function burn(uint256 value) public returns (bool);
195   function burnFrom(address from, uint256 value) public returns (bool);
196 }
197 
198 // File: contracts\token\ExtendedToken.sol
199 
200 contract ExtendedToken is StandardToken, ERC223, MintableToken, BurnableToken {
201   using SafeMath for uint256;
202 
203   string internal _name;
204   string internal _symbol;
205   uint8 internal _decimals;
206   bool internal _mintingFinished;
207 
208   event Burn(address indexed account, uint256 value);
209   event Mint(address indexed account, uint256 value);
210   event MintingFinished();
211 
212   constructor(uint256 totalSupply, string name, string symbol, uint8 decimals) StandardToken(totalSupply) public {
213     _name = name;
214     _symbol = symbol;
215     _decimals = decimals;
216     _mintingFinished = false;
217   }
218 
219   function name() public view returns (string) {
220     return _name;
221   }
222 
223   function symbol() public view returns (string) {
224     return _symbol;
225   }
226 
227   function decimals() public view returns (uint8) {
228     return _decimals;
229   }
230 
231   /**
232    * Transfer
233    */
234 
235   function transfer(address to, uint256 value) public returns (bool) {
236     bytes memory empty;
237     return transfer(to, value, empty);
238   }
239 
240   function transferFrom(address from, address to, uint256 value) public returns (bool) {
241     bytes memory empty;
242     return transferFrom(from, to, value, empty);
243   }
244 
245   function transfer(address to, uint256 value, bytes data) public returns (bool) {
246     if (_isContract(to)) {
247       ERC223Receiver receiver = ERC223Receiver(to);
248       receiver.tokenFallback(msg.sender, value, data);
249 
250       super.transfer(to, value);
251 
252       emit Transfer(msg.sender, to, value, data);
253       return true;
254     }
255 
256     return super.transfer(to, value);
257   }
258 
259   function transferFrom(address from, address to, uint256 value, bytes data) public returns (bool) {
260     if (_isContract(to)) {
261       ERC223Receiver receiver = ERC223Receiver(to);
262       receiver.tokenFallback(from, value, data);
263 
264       super.transferFrom(from, to, value);
265 
266       emit Transfer(from, to, value, data);
267       return true;
268     }
269 
270     return super.transferFrom(from, to, value);
271   }
272 
273   /**
274    * Burn
275    */
276 
277   function burn(uint256 value) public returns (bool) {
278     require(_balances[msg.sender] >= value, "Insufficient balance.");
279 
280     return _burn(msg.sender, value);
281   }
282 
283   function burnFrom(address from, uint256 value) public returns (bool) {
284     require(from != address(0), "Non-zero address required.");
285     require(_balances[from] >= value, "Insufficient balance.");
286     require(_allowed[from][msg.sender] >= value, "Insufficient balance.");
287 
288     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
289     return _burn(from, value);
290   }
291 
292   function _burn(address from, uint256 value) private returns (bool) {
293     _totalSupply = _totalSupply.sub(value);
294     _balances[from] = _balances[from].sub(value);
295     emit Transfer(from, address(0), value);
296     emit Burn(from, value);
297     return true;
298   }
299 
300   /**
301    * Mint
302    */
303 
304   function mintingFinished() public view returns(bool) {
305     return _mintingFinished;
306   }
307 
308   function finishMinting() public returns (bool) {
309     require(_mintingFinished == false, "");
310     _mintingFinished = true;
311     emit MintingFinished();
312     return true;
313   }
314 
315   function mint(address to, uint256 value) public returns (bool) {
316     require(to != address(0), "Non-zero address required.");
317 
318     _totalSupply = _totalSupply.add(value);
319     _balances[to] = _balances[to].add(value);
320     emit Transfer(address(0), to, value);
321     emit Mint(to, value);
322     return true;
323   }
324 
325   /**
326    * Etc
327    */
328 
329   function _isContract(address _account) private view returns (bool) {
330     uint256 size = 0;
331     // solium-disable-next-line security/no-inline-assembly
332     assembly { size := extcodesize(_account) }
333     return size > 0;
334   }
335 }
336 
337 // File: contracts\LivePodToken.sol
338 
339 contract LivePodToken is ExtendedToken {
340   using SafeMath for uint256;
341 
342   bool private _tradingStarted;
343   address private _preSaleAgent;
344   address private _publicSaleAgent;
345 
346   event TradeStarted();
347 
348   constructor() ExtendedToken(0 * (10 ** 18), "LIVEPOD TOKEN", "LVPD", 18) public {
349     _tradingStarted = false;
350     _preSaleAgent = 0;
351     _publicSaleAgent = 0;
352   }
353 
354   /**
355    * Transfer
356    */
357 
358   function transfer(address to, uint256 value) public hasStartedTrading returns (bool) {
359     return super.transfer(to, value);
360   }
361 
362   function transferFrom(address from, address to, uint256 value) public hasStartedTrading returns (bool) {
363     return super.transferFrom(from, to, value);
364   }
365 
366   function approve(address spender, uint256 value) public hasStartedTrading returns (bool) {
367     return super.approve(spender, value);
368   }
369 
370   function transfer(address to, uint256 value, bytes data) public hasStartedTrading returns (bool) {
371     return super.transfer(to, value, data);
372   }
373 
374   function transferFrom(address from, address to, uint256 value, bytes data) public hasStartedTrading returns (bool) {
375     return super.transferFrom(from, to, value, data);
376   }
377 
378   /**
379    * Trade
380    */
381 
382   modifier hasStartedTrading() {
383     require(_tradingStarted, "The trade has not started yet.");
384     _;
385   }
386 
387   function trading() public view returns (bool) {
388     return _tradingStarted;
389   }
390 
391   function startTrading() public onlyOwnerAndAgents returns (bool) {
392     _tradingStarted = true;
393     emit TradeStarted();
394     return true;
395   }
396 
397   /**
398    * Agents
399    */
400 
401   function setPreSaleAgent(address agent) public onlyOwner returns (bool) {
402     require(agent != address(0), "Non-zero address required.");
403 
404     _preSaleAgent = agent;
405     return true;
406   }
407 
408   function setPublicSaleAgent(address agent) public onlyOwner returns (bool) {
409     require(agent != address(0), "Non-zero address required.");
410 
411     _publicSaleAgent = agent;
412     return true;
413   }
414 
415   modifier onlyOwnerAndAgents() {
416     require((msg.sender == owner()) || (msg.sender == _preSaleAgent) || (msg.sender == _publicSaleAgent), "Unauthorized.");
417     _;
418   }
419 
420   /**
421    * Mint
422    */
423 
424   function finishMinting() public onlyOwner returns (bool) {
425     return super.finishMinting();
426   }
427 
428   function mint(address to, uint256 value) public onlyOwnerAndAgents returns (bool) {
429     require(!_tradingStarted, "Trading has started.");
430 
431     return super.mint(to, value);
432   }
433 
434   /**
435    * Etc
436    */
437 
438   function transferAnyERC20Token(address tokenAddress, uint256 amount) public onlyOwner returns (bool) {
439     return ERC20(tokenAddress).transfer(owner(), amount);
440   }
441 
442   function destroy() public onlyOwner {
443     selfdestruct(owner());
444   }
445 }