1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     if (a == 0) {
15       return 0;
16     }
17     c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     // uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return a / b;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
44     c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 /**
51  * @title ERC20Basic
52  * @dev Simpler version of ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/179
54  */
55 contract ERC20Basic {
56   function totalSupply() public view returns (uint256);
57   function balanceOf(address who) public view returns (uint256);
58   function transfer(address to, uint256 value) public returns (bool);
59   event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 /**
63  * @title ERC20 interface
64  * @dev see https://github.com/ethereum/EIPs/issues/20
65  */
66 contract ERC20 is ERC20Basic {
67   function allowance(address owner, address spender) public view returns (uint256);
68   function transferFrom(address from, address to, uint256 value) public returns (bool);
69   function approve(address spender, uint256 value) public returns (bool);
70   event Approval(address indexed owner, address indexed spender, uint256 value);
71 }
72 
73 /**
74  * @title Basic token
75  * @dev Basic version of StandardToken, with no allowances.
76  */
77 contract BasicToken is ERC20Basic {
78   using SafeMath for uint256;
79 
80   mapping(address => uint256) balances;
81 
82   uint256 totalSupply_;
83 
84   /**
85   * @dev total number of tokens in existence
86   */
87   function totalSupply() public view returns (uint256) {
88     return totalSupply_;
89   }
90 
91   /**
92   * @dev transfer token for a specified address
93   * @param _to The address to transfer to.
94   * @param _value The amount to be transferred.
95   */
96   function transfer(address _to, uint256 _value) public returns (bool) {
97     require(_to != address(0));
98     require(_value <= balances[msg.sender]);
99 
100     balances[msg.sender] = balances[msg.sender].sub(_value);
101     balances[_to] = balances[_to].add(_value);
102     emit Transfer(msg.sender, _to, _value);
103     return true;
104   }
105 
106   /**
107   * @dev Gets the balance of the specified address.
108   * @param _owner The address to query the the balance of.
109   * @return An uint256 representing the amount owned by the passed address.
110   */
111   function balanceOf(address _owner) public view returns (uint256) {
112     return balances[_owner];
113   }
114 
115 }
116 
117 /**
118  * @title Standard ERC20 token
119  *
120  * @dev Implementation of the basic standard token.
121  * @dev https://github.com/ethereum/EIPs/issues/20
122  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
123  */
124 contract StandardToken is ERC20, BasicToken {
125 
126   mapping (address => mapping (address => uint256)) internal allowed;
127 
128 
129   /**
130    * @dev Transfer tokens from one address to another
131    * @param _from address The address which you want to send tokens from
132    * @param _to address The address which you want to transfer to
133    * @param _value uint256 the amount of tokens to be transferred
134    */
135   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
136     require(_to != address(0));
137     require(_value <= balances[_from]);
138     require(_value <= allowed[_from][msg.sender]);
139 
140     balances[_from] = balances[_from].sub(_value);
141     balances[_to] = balances[_to].add(_value);
142     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
143     emit Transfer(_from, _to, _value);
144     return true;
145   }
146 
147   /**
148    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
149    *
150    * Beware that changing an allowance with this method brings the risk that someone may use both the old
151    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
152    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
153    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
154    * @param _spender The address which will spend the funds.
155    * @param _value The amount of tokens to be spent.
156    */
157   function approve(address _spender, uint256 _value) public returns (bool) {
158     allowed[msg.sender][_spender] = _value;
159     emit Approval(msg.sender, _spender, _value);
160     return true;
161   }
162 
163   /**
164    * @dev Function to check the amount of tokens that an owner allowed to a spender.
165    * @param _owner address The address which owns the funds.
166    * @param _spender address The address which will spend the funds.
167    * @return A uint256 specifying the amount of tokens still available for the spender.
168    */
169   function allowance(address _owner, address _spender) public view returns (uint256) {
170     return allowed[_owner][_spender];
171   }
172 
173   /**
174    * @dev Increase the amount of tokens that an owner allowed to a spender.
175    *
176    * approve should be called when allowed[_spender] == 0. To increment
177    * allowed value is better to use this function to avoid 2 calls (and wait until
178    * the first transaction is mined)
179    * From MonolithDAO Token.sol
180    * @param _spender The address which will spend the funds.
181    * @param _addedValue The amount of tokens to increase the allowance by.
182    */
183   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
184     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
185     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
186     return true;
187   }
188 
189   /**
190    * @dev Decrease the amount of tokens that an owner allowed to a spender.
191    *
192    * approve should be called when allowed[_spender] == 0. To decrement
193    * allowed value is better to use this function to avoid 2 calls (and wait until
194    * the first transaction is mined)
195    * From MonolithDAO Token.sol
196    * @param _spender The address which will spend the funds.
197    * @param _subtractedValue The amount of tokens to decrease the allowance by.
198    */
199   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
200     uint oldValue = allowed[msg.sender][_spender];
201     if (_subtractedValue > oldValue) {
202       allowed[msg.sender][_spender] = 0;
203     } else {
204       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
205     }
206     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
207     return true;
208   }
209 
210 }
211 
212 /**
213  * @title Ownable
214  * @dev The Ownable contract has an owner address, and provides basic authorization control
215  * functions, this simplifies the implementation of "user permissions".
216  */
217 contract Ownable {
218   address public owner;
219 
220 
221   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
222 
223 
224   /**
225    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
226    * account.
227    */
228   constructor() public {
229     owner = msg.sender;
230   }
231 
232   /**
233    * @dev Throws if called by any account other than the owner.
234    */
235   modifier onlyOwner() {
236     require(msg.sender == owner);
237     _;
238   }
239 
240   /**
241    * @dev Allows the current owner to transfer control of the contract to a newOwner.
242    * @param newOwner The address to transfer ownership to.
243    */
244   function transferOwnership(address newOwner) public onlyOwner {
245     require(newOwner != address(0));
246     emit OwnershipTransferred(owner, newOwner);
247     owner = newOwner;
248   }
249 
250 }
251 
252 contract Claimable is Ownable {
253   address public pendingOwner;
254 
255   /**
256    * @dev Modifier throws if called by any account other than the pendingOwner.
257    */
258   modifier onlyPendingOwner() {
259     require(msg.sender == pendingOwner);
260     _;
261   }
262 
263   /**
264    * @dev Allows the current owner to set the pendingOwner address.
265    * @param newOwner The address to transfer ownership to.
266    */
267   function transferOwnership(address newOwner) onlyOwner public {
268     pendingOwner = newOwner;
269   }
270 
271   /**
272    * @dev Allows the pendingOwner address to finalize the transfer.
273    */
274   function claimOwnership() onlyPendingOwner public {
275     emit OwnershipTransferred(owner, pendingOwner);
276     owner = pendingOwner;
277     pendingOwner = address(0);
278   }
279 }
280 
281 contract ClubMatesCom is StandardToken, Claimable {
282   using SafeMath for uint256;
283   uint8 public constant PERCENT_BONUS=15;
284 
285   ///////////////////////
286   // DATA STRUCTURES  ///
287   ///////////////////////
288   enum StatusName {Pending, OneSign, TwoSign, Minted}
289 
290   struct MintStatus {
291     StatusName status;
292     address    beneficiary;
293     uint256    amount;
294     address    firstSign;
295     address    secondSign;
296   }
297   
298   MintStatus public additionalMint;
299 
300   string  public name;
301   string  public symbol;
302   uint8   public decimals;
303   address public accICO;
304   address public accBonusTokens;
305   address public accMinterOne; 
306   address public accMinterTwo;
307 
308   ///////////////
309   // EVENTS    //
310   ///////////////
311   event BatchDistrib(uint8 cnt , uint256 batchAmount);
312   event NewMintPending(address _beneficiary, uint256 mintAmount, uint64 timestamp);
313   event FirstSign(address _signer, uint64 timestamp);
314   event SecondSign(address _signer, uint64 timestamp);
315   event Minted(address _to, uint256 _amount);
316 
317   constructor (
318       address _accICO, 
319       address _accBonusTokens, 
320       address _accMinterOne, 
321       address _accMinterTwo,
322       uint256 _initialSupply)
323   public 
324   {
325       name           = "ClubMatesCom_TEST";
326       symbol         = "CMC";
327       decimals       = 18;
328       accICO         = _accICO;
329       accBonusTokens = _accBonusTokens;
330       accMinterOne   = _accMinterOne; 
331       accMinterTwo   = _accMinterTwo;
332       totalSupply_   = _initialSupply * (10 ** uint256(decimals));// All CIX tokens in the world
333       //Initial token distribution
334       balances[_accICO]         = totalSupply()/100*(100-PERCENT_BONUS);
335       balances[_accBonusTokens] = totalSupply()/100*PERCENT_BONUS;
336       emit Transfer(address(0), _accICO, totalSupply()/100*(100-PERCENT_BONUS));
337       emit Transfer(address(0), _accBonusTokens, totalSupply()/100*PERCENT_BONUS);
338       //Default values for additionalMint record
339       additionalMint.status     = StatusName.Minted;
340       additionalMint.amount     = totalSupply();
341       additionalMint.firstSign  = address(0);
342       additionalMint.secondSign = address(0);
343   }
344 
345   modifier onlyTrustedSign() {
346       require(msg.sender == accMinterOne || msg.sender == accMinterTwo);
347       _;
348   }
349 
350   modifier onlyTokenKeeper() {
351       require(msg.sender == accICO || msg.sender == accBonusTokens);
352       _;
353   }
354 
355 
356   function() public { } 
357 
358 
359   //Batch token distribution from cab
360   function multiTransfer(address[] _investors, uint256[] _value )  
361       public 
362       onlyTokenKeeper 
363       returns (uint256 _batchAmount)
364   {
365       require(_investors.length <= 255); //audit recommendation
366       require(_value.length == _investors.length);
367       uint8      cnt = uint8(_investors.length);
368       uint256 amount = 0;
369       for (uint i=0; i<cnt; i++){
370         amount = amount.add(_value[i]);
371         require(_investors[i] != address(0));
372         balances[_investors[i]] = balances[_investors[i]].add(_value[i]);
373         emit Transfer(msg.sender, _investors[i], _value[i]);
374       }
375       require(amount <= balances[msg.sender]);
376       balances[msg.sender] = balances[msg.sender].sub(amount);
377       emit BatchDistrib(cnt, amount);
378       return amount;
379   }
380 
381   function requestNewMint(address _beneficiary, uint256 _amount) public onlyOwner  {
382       require(_beneficiary != address(0) && _beneficiary != address(this));
383       require(_amount > 0);
384       require(
385           additionalMint.status == StatusName.Minted  ||
386           additionalMint.status == StatusName.Pending || 
387           additionalMint.status == StatusName.OneSign 
388       );
389       additionalMint.status      = StatusName.Pending;
390       additionalMint.beneficiary = _beneficiary;
391       additionalMint.amount      = _amount;
392       additionalMint.firstSign   = address(0);
393       additionalMint.secondSign  = address(0);
394       emit NewMintPending(_beneficiary,  _amount, uint64(now));
395   }
396 
397   //Get  signs  from defined accounts
398   function sign() public onlyTrustedSign  returns (bool) {
399       require(
400           additionalMint.status == StatusName.Pending || 
401           additionalMint.status == StatusName.OneSign ||
402           additionalMint.status == StatusName.TwoSign //non existing sit
403       );
404 
405       if (additionalMint.status == StatusName.Pending) {
406           additionalMint.firstSign = msg.sender;
407           additionalMint.status    = StatusName.OneSign;
408           emit FirstSign(msg.sender, uint64(now));
409           return true;
410       }
411 
412       if (additionalMint.status == StatusName.OneSign) {
413         if (additionalMint.firstSign != msg.sender) {
414             additionalMint.secondSign = msg.sender;
415             additionalMint.status     = StatusName.TwoSign;
416             emit SecondSign(msg.sender, uint64(now));
417         }    
418       }
419         
420       if (additionalMint.status == StatusName.TwoSign) {
421           if (mint(additionalMint.beneficiary, additionalMint.amount)) {
422               additionalMint.status = StatusName.Minted;
423               emit   Minted(additionalMint.beneficiary, additionalMint.amount);
424           }    
425       }
426       return true;
427   }
428 
429   //
430   function mint(address _to, uint256 _amount) internal returns (bool) {
431       totalSupply_  = totalSupply_.add(_amount);
432       balances[_to] = balances[_to].add(_amount);
433       emit Transfer(address(0), _to, _amount);
434       return true;
435   }
436 }