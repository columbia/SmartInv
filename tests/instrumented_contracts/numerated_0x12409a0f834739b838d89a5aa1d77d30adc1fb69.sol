1 pragma solidity 0.4.19;
2 
3 // ================= Ownable Contract start =============================
4 /*
5  * Ownable
6  *
7  * Base contract with an owner.
8  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
9  */
10 contract Ownable {
11   address public owner;
12 
13   function Ownable() public {
14     owner = msg.sender;
15   }
16 
17   modifier onlyOwner() {
18     require(msg.sender == owner);
19     _;
20   }
21 
22   function transferOwnership(address newOwner) public onlyOwner {
23     if (newOwner != address(0)) {
24       owner = newOwner;
25     }
26   }
27 }
28 // ================= Ownable Contract end ===============================
29 
30 // ================= Safemath Lib ============================
31 library SafeMath {
32 
33   /**
34   * @dev Multiplies two numbers, throws on overflow.
35   */
36   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
37     if (a == 0) {
38       return 0;
39     }
40     uint256 c = a * b;
41     assert(c / a == b);
42     return c;
43   }
44 
45   /**
46   * @dev Integer division of two numbers, truncating the quotient.
47   */
48   function div(uint256 a, uint256 b) internal pure returns (uint256) {
49     // assert(b > 0); // Solidity automatically throws when dividing by 0
50     uint256 c = a / b;
51     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
52     return c;
53   }
54 
55   /**
56   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
57   */
58   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59     assert(b <= a);
60     return a - b;
61   }
62 
63   /**
64   * @dev Adds two numbers, throws on overflow.
65   */
66   function add(uint256 a, uint256 b) internal pure returns (uint256) {
67     uint256 c = a + b;
68     assert(c >= a);
69     return c;
70   }
71 }
72 // ================= Safemath Lib end ==============================
73 
74 // ================= ERC20 Token Contract start =========================
75 /*
76  * ERC20 interface
77  * see https://github.com/ethereum/EIPs/issues/20
78  */
79 contract ERC20 {
80   function totalSupply() public view returns (uint256);
81   function balanceOf(address who) public view returns (uint256);
82   function transfer(address to, uint256 value) public returns (bool);
83   function allowance(address owner, address spender) public view returns (uint256);
84   function transferFrom(address from, address to, uint256 value) public returns (bool);
85   function approve(address spender, uint256 value) public returns (bool);
86   event Transfer(address indexed from, address indexed to, uint256 value);
87   event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 // ================= ERC20 Token Contract end ===========================
90 
91 // ================= Standard Token Contract start ======================
92 contract StandardToken is ERC20 {
93   using SafeMath for uint256;
94 
95   mapping(address => uint256) balances;
96   mapping (address => mapping (address => uint256)) internal allowed;
97 
98   uint256 totalSupply_;
99 
100   /**
101   * @dev total number of tokens in existence
102   */
103   function totalSupply() public view returns (uint256) {
104     return totalSupply_;
105   }
106 
107   /**
108   * @dev transfer token for a specified address
109   * @param _to The address to transfer to.
110   * @param _value The amount to be transferred.
111   */
112   function transfer(address _to, uint256 _value) public returns (bool) {
113     require(_to != address(0));
114     require(_value <= balances[msg.sender]);
115 
116     // SafeMath.sub will throw if there is not enough balance.
117     balances[msg.sender] = balances[msg.sender].sub(_value);
118     balances[_to] = balances[_to].add(_value);
119     Transfer(msg.sender, _to, _value);
120     return true;
121   }
122 
123   /**
124   * @dev Gets the balance of the specified address.
125   * @param _owner The address to query the the balance of.
126   * @return An uint256 representing the amount owned by the passed address.
127   */
128   function balanceOf(address _owner) public view returns (uint256 balance) {
129     return balances[_owner];
130   }
131 
132 
133   /**
134    * @dev Transfer tokens from one address to another
135    * @param _from address The address which you want to send tokens from
136    * @param _to address The address which you want to transfer to
137    * @param _value uint256 the amount of tokens to be transferred
138    */
139   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
140     require(_to != address(0));
141     require(_value <= balances[_from]);
142     require(_value <= allowed[_from][msg.sender]);
143 
144     balances[_from] = balances[_from].sub(_value);
145     balances[_to] = balances[_to].add(_value);
146     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
147     Transfer(_from, _to, _value);
148     return true;
149   }
150 
151   /**
152    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
153    *
154    * Beware that changing an allowance with this method brings the risk that someone may use both the old
155    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
156    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
157    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158    * @param _spender The address which will spend the funds.
159    * @param _value The amount of tokens to be spent.
160    */
161   function approve(address _spender, uint256 _value) public returns (bool) {
162     allowed[msg.sender][_spender] = _value;
163     Approval(msg.sender, _spender, _value);
164     return true;
165   }
166 
167   /**
168    * @dev Function to check the amount of tokens that an owner allowed to a spender.
169    * @param _owner address The address which owns the funds.
170    * @param _spender address The address which will spend the funds.
171    * @return A uint256 specifying the amount of tokens still available for the spender.
172    */
173   function allowance(address _owner, address _spender) public view returns (uint256) {
174     return allowed[_owner][_spender];
175   }
176 }
177 // ================= Standard Token Contract end ========================
178 
179 // ================= Pausable Token Contract start ======================
180 /**
181  * @title Pausable
182  * @dev Base contract which allows children to implement an emergency stop mechanism.
183  */
184 contract Pausable is Ownable {
185   event Pause();
186   event Unpause();
187 
188   bool public paused = false;
189 
190 
191   /**
192   * @dev modifier to allow actions only when the contract IS paused
193   */
194   modifier whenNotPaused() {
195     require (!paused);
196     _;
197   }
198 
199   /**
200   * @dev modifier to allow actions only when the contract IS NOT paused
201   */
202   modifier whenPaused {
203     require (paused) ;
204     _;
205   }
206 
207   /**
208   * @dev called by the owner to pause, triggers stopped state
209   */
210   function pause() public onlyOwner whenNotPaused returns (bool) {
211     paused = true;
212     Pause();
213     return true;
214   }
215 
216   /**
217   * @dev called by the owner to unpause, returns to normal state
218   */
219   function unpause() public onlyOwner whenPaused returns (bool) {
220     paused = false;
221     Unpause();
222     return true;
223   }
224 }
225 // ================= Pausable Token Contract end ========================
226 
227 // ================= Tomocoin  start =======================
228 contract TomoCoin is StandardToken, Pausable {
229   string public constant name = 'Tomocoin';
230   string public constant symbol = 'TOMO';
231   uint256 public constant decimals = 18;
232   address public tokenSaleAddress;
233   address public tomoDepositAddress; // multisig wallet
234 
235   uint256 public constant tomoDeposit = 100000000 * 10**decimals;
236 
237   function TomoCoin(address _tomoDepositAddress) public { 
238     tomoDepositAddress = _tomoDepositAddress;
239 
240     balances[tomoDepositAddress] = tomoDeposit;
241     Transfer(0x0, tomoDepositAddress, tomoDeposit);
242     totalSupply_ = tomoDeposit;
243   }
244 
245   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool success) {
246     return super.transfer(_to,_value);
247   }
248 
249   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool success) {
250     return super.approve(_spender, _value);
251   }
252 
253   function balanceOf(address _owner) public view returns (uint256 balance) {
254     return super.balanceOf(_owner);
255   }
256 
257   // Setup Token Sale Smart Contract
258   function setTokenSaleAddress(address _tokenSaleAddress) public onlyOwner {
259     if (_tokenSaleAddress != address(0)) {
260       tokenSaleAddress = _tokenSaleAddress;
261     }
262   }
263 
264   function mint(address _recipient, uint256 _value) public whenNotPaused returns (bool success) {
265       require(_value > 0);
266       // This function is only called by Token Sale Smart Contract
267       require(msg.sender == tokenSaleAddress);
268 
269       balances[tomoDepositAddress] = balances[tomoDepositAddress].sub(_value);
270       balances[ _recipient ] = balances[_recipient].add(_value);
271 
272       Transfer(tomoDepositAddress, _recipient, _value);
273       return true;
274   }
275 }
276 // ================= Ico Token Contract end =======================
277 
278 
279 // ================= Whitelist start ====================
280 contract TomoContributorWhitelist is Ownable {
281     mapping(address => uint256) public whitelist;
282 
283     function TomoContributorWhitelist() public {}
284 
285     event ListAddress( address _user, uint256 cap, uint256 _time );
286 
287     function listAddress( address _user, uint256 cap ) public onlyOwner {
288         whitelist[_user] = cap;
289         ListAddress( _user, cap, now );
290     }
291 
292     function listAddresses( address[] _users, uint256[] _caps ) public onlyOwner {
293         for( uint i = 0 ; i < _users.length ; i++ ) {
294             listAddress( _users[i], _caps[i] );
295         }
296     }
297 
298     function getCap( address _user ) public view returns(uint) {
299         return whitelist[_user];
300     }
301 }
302 // ================= Whitelist end ====================
303 
304 // ================= Actual Sale Contract Start ====================
305 contract TomoTokenSale is Pausable {
306   using SafeMath for uint256;
307 
308   TomoCoin tomo;
309   TomoContributorWhitelist whitelist;
310   mapping(address => uint256) public participated;
311 
312   address public ethFundDepositAddress;
313   address public tomoDepositAddress;
314 
315   uint256 public constant tokenCreationCap = 4000000 * 10**18;
316   uint256 public totalTokenSold = 0;
317   uint256 public constant fundingStartTime = 1519876800; // 2018/03/01 04:00:00
318   uint256 public constant fundingPoCEndTime = 1519963200; // 2018/03/02 04:00:00
319   uint256 public constant fundingEndTime = 1520136000; // 2018/03/04 04:00:00
320   uint256 public constant minContribution = 0.1 ether;
321   uint256 public constant maxContribution = 10 ether;
322   uint256 public constant tokenExchangeRate = 3200;
323   uint256 public constant maxCap = tokenExchangeRate * maxContribution;
324 
325   bool public isFinalized;
326 
327   event MintTomo(address from, address to, uint256 val);
328   event RefundTomo(address to, uint256 val);
329 
330   function TomoTokenSale(
331     TomoCoin _tomoCoinAddress,
332     TomoContributorWhitelist _tomoContributorWhitelistAddress,
333     address _ethFundDepositAddress,
334     address _tomoDepositAddress
335   ) public
336   {
337     tomo = TomoCoin(_tomoCoinAddress);
338     whitelist = TomoContributorWhitelist(_tomoContributorWhitelistAddress);
339     ethFundDepositAddress = _ethFundDepositAddress;
340     tomoDepositAddress = _tomoDepositAddress;
341 
342     isFinalized = false;
343   }
344 
345   function buy(address to, uint256 val) internal returns (bool success) {
346     MintTomo(tomoDepositAddress, to, val);
347     return tomo.mint(to, val);
348   }
349 
350   function () public payable {    
351     createTokens(msg.sender, msg.value);
352   }
353 
354   function createTokens(address _beneficiary, uint256 _value) internal whenNotPaused {
355     require (now >= fundingStartTime);
356     require (now <= fundingEndTime);
357     require (_value >= minContribution);
358     require (_value <= maxContribution);
359     require (!isFinalized);
360 
361     uint256 tokens = _value.mul(tokenExchangeRate);
362 
363     uint256 cap = whitelist.getCap(_beneficiary);
364     require (cap > 0);
365 
366     uint256 tokensToAllocate = 0;
367     uint256 tokensToRefund = 0;
368     uint256 etherToRefund = 0;
369 
370     // running while PoC Buying Time
371     if (now <= fundingPoCEndTime) {
372       tokensToAllocate = cap.sub(participated[_beneficiary]);
373     } else {
374       tokensToAllocate = maxCap.sub(participated[_beneficiary]);
375     }
376 
377     // calculate refund if over max cap or individual cap
378     if (tokens > tokensToAllocate) {
379       tokensToRefund = tokens.sub(tokensToAllocate);
380       etherToRefund = tokensToRefund.div(tokenExchangeRate);
381     } else {
382       // user can buy amount they want
383       tokensToAllocate = tokens;
384     }
385 
386     uint256 checkedTokenSold = totalTokenSold.add(tokensToAllocate);
387 
388     // if reaches hard cap
389     if (tokenCreationCap < checkedTokenSold) {
390       tokensToAllocate = tokenCreationCap.sub(totalTokenSold);
391       tokensToRefund   = tokens.sub(tokensToAllocate);
392       etherToRefund = tokensToRefund.div(tokenExchangeRate);
393       totalTokenSold = tokenCreationCap;
394     } else {
395       totalTokenSold = checkedTokenSold;
396     }
397 
398     // save to participated data
399     participated[_beneficiary] = participated[_beneficiary].add(tokensToAllocate);
400 
401     // allocate tokens
402     require(buy(_beneficiary, tokensToAllocate));
403     if (etherToRefund > 0) {
404       // refund in case user buy over hard cap, individual cap
405       RefundTomo(msg.sender, etherToRefund);
406       msg.sender.transfer(etherToRefund);
407     }
408     ethFundDepositAddress.transfer(this.balance);
409     return;
410   }
411 
412   /// @dev Ends the funding period and sends the ETH home
413   function finalize() external onlyOwner {
414     require (!isFinalized);
415     // move to operational
416     isFinalized = true;
417     ethFundDepositAddress.transfer(this.balance);
418   }
419 }