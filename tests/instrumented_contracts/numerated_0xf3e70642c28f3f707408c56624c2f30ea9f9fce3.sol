1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   /**
9   * @dev Multiplies two numbers, throws on overflow.
10   */
11   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
12     if (a == 0) {
13       return 0;
14     }
15     c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 
20   /**
21   * @dev Integer division of two numbers, truncating the quotient.
22   */
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     // assert(b > 0); // Solidity automatically throws when dividing by 0
25     // uint256 c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27     return a / b;
28   }
29 
30   /**
31   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32   */
33   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   /**
39   * @dev Adds two numbers, throws on overflow.
40   */
41   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
42     c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 }
47 
48 /**
49  * @title Ownable
50  * @dev The Ownable contract has an owner address, and provides basic authorization control
51  * functions, this simplifies the implementation of "user permissions".
52  */
53 contract Ownable {
54   address public owner;
55 
56   event OwnershipRenounced(address indexed previousOwner);
57   event OwnershipTransferred(
58     address indexed previousOwner,
59     address indexed newOwner
60   );
61 
62   /**
63    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64    * account.
65    */
66   constructor() public {
67     owner = msg.sender;
68   }
69 
70   /**
71    * @dev Throws if called by any account other than the owner.
72    */
73   modifier onlyOwner() {
74     require(msg.sender == owner);
75     _;
76   }
77 
78   /**
79    * @dev Allows the current owner to transfer control of the contract to a newOwner.
80    * @param newOwner The address to transfer ownership to.
81    */
82   function transferOwnership(address newOwner) public onlyOwner {
83     require(newOwner != address(0));
84     emit OwnershipTransferred(owner, newOwner);
85     owner = newOwner;
86   }
87 
88   /**
89    * @dev Allows the current owner to relinquish control of the contract.
90    */
91   function renounceOwnership() public onlyOwner {
92     emit OwnershipRenounced(owner);
93     owner = address(0);
94   }
95 }
96 
97 contract ERC20Basic {
98   function totalSupply() public view returns (uint256);
99   function balanceOf(address who) public view returns (uint256);
100   function transfer(address to, uint256 value) public returns (bool);
101   event Transfer(address indexed from, address indexed to, uint256 value);
102 }
103 
104 contract BasicToken is ERC20Basic, Ownable {
105   using SafeMath for uint256;
106     
107   mapping (address => bool) public staff;
108   mapping (address => uint256) balances;
109   uint256 totalSupply_;
110   mapping (address => uint256) public uniqueTokens;
111   mapping (address => uint256) public preSaleTokens;
112   mapping (address => uint256) public crowdSaleTokens;
113   mapping (address => uint256) public freezeTokens;
114   mapping (address => uint256) public freezeTimeBlock;
115   uint256 public launchTime = 999999999999999999999999999999;
116   uint256 public totalFreezeTokens = 0;
117   bool public listing = false;
118   bool public freezing = true;
119   address public agentAddress;
120   
121   function totalSupply() public view returns (uint256) {
122     return totalSupply_;
123   }
124   
125   modifier afterListing() {
126     require(listing == true || owner == msg.sender || agentAddress == msg.sender);
127     _;
128   }
129   
130   function checkVesting(address sender) public view returns (uint256) {
131     if (now >= launchTime.add(270 days)) {
132         return balances[sender];
133     } else if (now >= launchTime.add(180 days)) {
134         return balances[sender].sub(uniqueTokens[sender].mul(35).div(100));
135     } else if (now >= launchTime.add(120 days)) {
136         return balances[sender].sub(uniqueTokens[sender].mul(7).div(10));
137     } else if (now >= launchTime.add(90 days)) {
138         return balances[sender].sub((uniqueTokens[sender].mul(7).div(10)).add(crowdSaleTokens[sender].mul(2).div(10)));
139     } else if (now >= launchTime.add(60 days)) {
140         return balances[sender].sub(uniqueTokens[sender].add(preSaleTokens[sender].mul(3).div(10)).add(crowdSaleTokens[sender].mul(4).div(10)));
141     } else if (now >= launchTime.add(30 days)) {
142         return balances[sender].sub(uniqueTokens[sender].add(preSaleTokens[sender].mul(6).div(10)).add(crowdSaleTokens[sender].mul(6).div(10)));
143     } else {
144         return balances[sender].sub(uniqueTokens[sender].add(preSaleTokens[sender].mul(9).div(10)).add(crowdSaleTokens[sender].mul(8).div(10)));
145     }
146   }
147   
148   function checkVestingWithFrozen(address sender) public view returns (uint256) {
149     if (freezing) {
150         
151       if (freezeTimeBlock[sender] <= now) {
152           return checkVesting(sender);
153       } else {
154           return checkVesting(sender).sub(freezeTokens[sender]);
155       }
156     
157     } else {
158         return checkVesting(sender);
159     }
160   }
161   
162   /**
163   * @dev transfer token for a specified address
164   * @param _to The address to transfer to.
165   * @param _value The amount to be transferred.
166   */
167   function transfer(address _to, uint256 _value) afterListing public returns (bool) {
168     require(_to != address(0));
169     require(_value <= balances[msg.sender]);
170     if (!staff[msg.sender]) {
171         require(_value <= checkVestingWithFrozen(msg.sender));
172     }
173 
174     balances[msg.sender] = balances[msg.sender].sub(_value);
175     balances[_to] = balances[_to].add(_value);
176     emit Transfer(msg.sender, _to, _value);
177     return true;
178   }
179 
180   /**
181   * @dev Gets the balance of the specified address.
182   * @param _owner The address to query the the balance of. 
183   * @return An uint256 representing the amount owned by the passed address.
184   */
185   function balanceOf(address _owner) public view returns (uint256 balance) {
186     if (!staff[_owner]) {
187         return checkVestingWithFrozen(_owner);
188     }
189     return balances[_owner];
190   }
191 }
192 
193 contract ERC20 is ERC20Basic {
194   function allowance(address owner, address spender) public view returns (uint256);
195   function transferFrom(address from, address to, uint256 value) public returns (bool);
196   function approve(address spender, uint256 value) public returns (bool);
197   event Approval(address indexed owner, address indexed spender, uint256 value);
198 }
199 
200 contract BurnableToken is BasicToken {
201 
202   event Burn(address indexed burner, uint256 value);
203 
204   /**
205    * @dev Burns a specific amount of tokens.
206    * @param _value The amount of token to be burned.
207    */
208   function burn(uint256 _value) afterListing public {
209     require(_value <= balances[msg.sender]);
210     if (!staff[msg.sender]) {
211         require(_value <= checkVestingWithFrozen(msg.sender));
212     }
213     // no need to require value <= totalSupply, since that would imply the
214     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
215 
216     address burner = msg.sender;
217     balances[burner] = balances[burner].sub(_value);
218     totalSupply_ = totalSupply_.sub(_value);
219     emit Burn(burner, _value);
220     emit Transfer(burner, address(0), _value);
221   }
222 }
223 
224 contract StandardToken is ERC20, BurnableToken {
225 
226   mapping (address => mapping (address => uint256)) allowed;
227 
228   function transferFrom(address _from, address _to, uint256 _value) afterListing public returns (bool) {
229     require(_to != address(0));
230     require(_value <= balances[_from]);
231     require(_value <= allowed[_from][msg.sender]);
232     if (!staff[_from]) {
233         require(_value <= checkVestingWithFrozen(_from));
234     }
235 
236     balances[_to] = balances[_to].add(_value);
237     balances[_from] = balances[_from].sub(_value);
238     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
239 
240     emit Transfer(_from, _to, _value);
241     return true;
242   }
243 
244   /**
245    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
246    * @param _spender The address which will spend the funds.
247    * @param _value The amount of tokens to be spent.
248    */
249   function approve(address _spender, uint256 _value) public returns (bool) {
250     allowed[msg.sender][_spender] = _value;
251     emit Approval(msg.sender, _spender, _value);
252     return true;
253   }
254 
255   /**
256    * @dev Function to check the amount of tokens that an owner allowed to a spender.
257    * @param _owner address The address which owns the funds.
258    * @param _spender address The address which will spend the funds.
259    * @return A uint256 specifing the amount of tokens still avaible for the spender.
260    */
261   function allowance(address _owner, address _spender) public view returns (uint256) {
262     return allowed[_owner][_spender];
263   }
264   
265 }
266 
267 contract AlbosWallet is Ownable {
268   using SafeMath for uint256;
269 
270   uint256 public withdrawFoundersTokens;
271   uint256 public withdrawReservedTokens;
272 
273   address public foundersAddress;
274   address public reservedAddress;
275 
276   AlbosToken public albosAddress;
277   
278   constructor(address _albosAddress, address _foundersAddress, address _reservedAddress) public {
279     albosAddress = AlbosToken(_albosAddress);
280     owner = albosAddress;
281 
282     foundersAddress = _foundersAddress;
283     reservedAddress = _reservedAddress;
284   }
285 
286   modifier onlyFounders() {
287     require(msg.sender == foundersAddress);
288     _;
289   }
290 
291   modifier onlyReserved() {
292     require(msg.sender == reservedAddress);
293     _;
294   }
295 
296   function viewFoundersTokens() public view returns (uint256) {
297     if (now >= albosAddress.launchTime().add(270 days)) {
298       return albosAddress.foundersSupply();
299     } else if (now >= albosAddress.launchTime().add(180 days)) {
300       return albosAddress.foundersSupply().mul(65).div(100);
301     } else if (now >= albosAddress.launchTime().add(90 days)) {
302       return albosAddress.foundersSupply().mul(3).div(10);
303     } else {
304       return 0;
305     }
306   }
307 
308   function viewReservedTokens() public view returns (uint256) {
309     if (now >= albosAddress.launchTime().add(270 days)) {
310       return albosAddress.reservedSupply();
311     } else if (now >= albosAddress.launchTime().add(180 days)) {
312       return albosAddress.reservedSupply().mul(65).div(100);
313     } else if (now >= albosAddress.launchTime().add(90 days)) {
314       return albosAddress.reservedSupply().mul(3).div(10);
315     } else {
316       return 0;
317     }
318   }
319 
320   function getFoundersTokens(uint256 _tokens) public onlyFounders {
321     uint256 tokens = _tokens.mul(10 ** 18);
322     require(withdrawFoundersTokens.add(tokens) <= viewFoundersTokens());
323     albosAddress.transfer(foundersAddress, tokens);
324     withdrawFoundersTokens = withdrawFoundersTokens.add(tokens);
325   }
326 
327   function getReservedTokens(uint256 _tokens) public onlyReserved {
328     uint256 tokens = _tokens.mul(10 ** 18);
329     require(withdrawReservedTokens.add(tokens) <= viewReservedTokens());
330     albosAddress.transfer(reservedAddress, tokens);
331     withdrawReservedTokens = withdrawReservedTokens.add(tokens);
332   }
333 }
334 
335 contract AlbosToken is StandardToken {
336   string constant public name = "ALBOS Token";
337   string constant public symbol = "ALB";
338   uint256 public decimals = 18;
339   
340   uint256 public INITIAL_SUPPLY = uint256(28710000000).mul(10 ** decimals); // 28,710,000,000 tokens
341   uint256 public foundersSupply = uint256(4306500000).mul(10 ** decimals); // 4,306,500,000 tokens
342   uint256 public reservedSupply = uint256(2871000000).mul(10 ** decimals); // 2,871,000,000 tokens
343   AlbosWallet public albosWallet;
344   
345   constructor() public {
346     totalSupply_ = INITIAL_SUPPLY;
347     balances[address(this)] = totalSupply_;
348     emit Transfer(0x0, address(this), totalSupply_);
349 
350     agentAddress = msg.sender;
351     staff[owner] = true;
352     staff[agentAddress] = true;
353   }
354   
355   modifier onlyAgent() {
356     require(msg.sender == agentAddress || msg.sender == owner);
357     _;
358   }
359 
360   function startListing() public onlyOwner {
361     require(!listing);
362     launchTime = now;
363     listing = true;
364   }
365 
366   function setTeamContract(address _albosWallet) external onlyOwner {
367 
368     albosWallet = AlbosWallet(_albosWallet);
369 
370     balances[address(albosWallet)] = balances[address(albosWallet)].add(foundersSupply).add(reservedSupply);
371     balances[address(this)] = balances[address(this)].sub(foundersSupply).sub(reservedSupply);
372      emit Transfer(address(this), address(albosWallet), balances[address(albosWallet)]);
373   }
374 
375   function addUniqueSaleTokens(address sender, uint256 amount) external onlyAgent {
376     uniqueTokens[sender] = uniqueTokens[sender].add(amount);
377     
378     balances[address(this)] = balances[address(this)].sub(amount);
379     balances[sender] = balances[sender].add(amount);
380     emit Transfer(address(this), sender, amount);
381   }
382   
383   function addUniqueSaleTokensMulti(address[] sender, uint256[] amount) external onlyAgent {
384     require(sender.length > 0 && sender.length == amount.length);
385     
386     for(uint i = 0; i < sender.length; i++) {
387       uniqueTokens[sender[i]] = uniqueTokens[sender[i]].add(amount[i]);
388       balances[address(this)] = balances[address(this)].sub(amount[i]);
389       balances[sender[i]] = balances[sender[i]].add(amount[i]);
390       emit Transfer(address(this), sender[i], amount[i]);
391     }
392   }
393   
394   function addPrivateSaleTokens(address sender, uint256 amount) external onlyAgent {
395     balances[address(this)] = balances[address(this)].sub(amount);
396     balances[sender] = balances[sender].add(amount);
397     emit Transfer(address(this), sender, amount);
398   }
399   
400   function addPrivateSaleTokensMulti(address[] sender, uint256[] amount) external onlyAgent {
401     require(sender.length > 0 && sender.length == amount.length);
402     
403     for(uint i = 0; i < sender.length; i++) {
404       balances[address(this)] = balances[address(this)].sub(amount[i]);
405       balances[sender[i]] = balances[sender[i]].add(amount[i]);
406       emit Transfer(address(this), sender[i], amount[i]);
407     }
408   }
409   
410   function addPreSaleTokens(address sender, uint256 amount) external onlyAgent {
411     preSaleTokens[sender] = preSaleTokens[sender].add(amount);
412     
413     balances[address(this)] = balances[address(this)].sub(amount);
414     balances[sender] = balances[sender].add(amount);
415     emit Transfer(address(this), sender, amount);
416   }
417   
418   function addPreSaleTokensMulti(address[] sender, uint256[] amount) external onlyAgent {
419     require(sender.length > 0 && sender.length == amount.length);
420     
421     for(uint i = 0; i < sender.length; i++) {
422       preSaleTokens[sender[i]] = preSaleTokens[sender[i]].add(amount[i]);
423       balances[address(this)] = balances[address(this)].sub(amount[i]);
424       balances[sender[i]] = balances[sender[i]].add(amount[i]);
425       emit Transfer(address(this), sender[i], amount[i]);
426     }
427   }
428   
429   function addCrowdSaleTokens(address sender, uint256 amount) external onlyAgent {
430     crowdSaleTokens[sender] = crowdSaleTokens[sender].add(amount);
431     
432     balances[address(this)] = balances[address(this)].sub(amount);
433     balances[sender] = balances[sender].add(amount);
434     emit Transfer(address(this), sender, amount);
435   }
436 
437   function addCrowdSaleTokensMulti(address[] sender, uint256[] amount) external onlyAgent {
438     require(sender.length > 0 && sender.length == amount.length);
439     
440     for(uint i = 0; i < sender.length; i++) {
441       crowdSaleTokens[sender[i]] = crowdSaleTokens[sender[i]].add(amount[i]);
442       balances[address(this)] = balances[address(this)].sub(amount[i]);
443       balances[sender[i]] = balances[sender[i]].add(amount[i]);
444       emit Transfer(address(this), sender[i], amount[i]);
445     }
446   }
447   
448   function addFrostTokens(address sender, uint256 amount, uint256 blockTime) public onlyAgent {
449 
450     totalFreezeTokens = totalFreezeTokens.add(amount);
451     require(totalFreezeTokens <= totalSupply_.mul(2).div(10));
452 
453     freezeTokens[sender] = amount;
454     freezeTimeBlock[sender] = blockTime;
455   }
456   
457   function transferAndFrostTokens(address sender, uint256 amount, uint256 blockTime) external onlyAgent {
458     balances[address(this)] = balances[address(this)].sub(amount);
459     balances[sender] = balances[sender].add(amount);
460     emit Transfer(address(this), sender, amount);
461     addFrostTokens(sender, amount, blockTime);
462   }
463   
464   function addFrostTokensMulti(address[] sender, uint256[] amount, uint256[] blockTime) external onlyAgent {
465     require(sender.length > 0 && sender.length == amount.length && amount.length == blockTime.length);
466 
467     for(uint i = 0; i < sender.length; i++) {
468       totalFreezeTokens = totalFreezeTokens.add(amount[i]);
469       freezeTokens[sender[i]] = amount[i];
470       freezeTimeBlock[sender[i]] = blockTime[i];
471     }
472     require(totalFreezeTokens <= totalSupply_.mul(2).div(10));
473   }
474   
475   function transferAgent(address _agent) external onlyOwner {
476     agentAddress = _agent;
477   }
478 
479   function addStaff(address _staff) external onlyOwner {
480     staff[_staff] = true;
481   }
482 
483   function killFrost() external onlyOwner {
484     freezing = false;
485   }
486 }