1 pragma solidity 0.4.19;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 /**
46  * @title SafeMath
47  * @dev Math operations with safety checks that throw on error
48  */
49 library SafeMath {
50   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
51     if (a == 0) {
52       return 0;
53     }
54     uint256 c = a * b;
55     assert(c / a == b);
56     return c;
57   }
58 
59   function div(uint256 a, uint256 b) internal pure returns (uint256) {
60     // assert(b > 0); // Solidity automatically throws when dividing by 0
61     uint256 c = a / b;
62     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
63     return c;
64   }
65 
66   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67     assert(b <= a);
68     return a - b;
69   }
70 
71   function add(uint256 a, uint256 b) internal pure returns (uint256) {
72     uint256 c = a + b;
73     assert(c >= a);
74     return c;
75   }
76 }
77 
78 /**
79  * @title ERC20Basic
80  * @dev Simpler version of ERC20 interface
81  * @dev see https://github.com/ethereum/EIPs/issues/179
82  */
83 contract ERC20Basic {
84   uint256 public totalSupply;
85   function balanceOf(address who) public view returns (uint256);
86   function transfer(address to, uint256 value) public returns (bool);
87   event Transfer(address indexed from, address indexed to, uint256 value);
88 }
89 
90 /**
91  * @title ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/20
93  */
94 contract ERC20 is ERC20Basic {
95   function allowance(address owner, address spender) public view returns (uint256);
96   function transferFrom(address from, address to, uint256 value) public returns (bool);
97   function approve(address spender, uint256 value) public returns (bool);
98   event Approval(address indexed owner, address indexed spender, uint256 value);
99 }
100 
101 /**
102  * @title Basic token
103  * @dev Basic version of StandardToken, with no allowances.
104  */
105 contract BasicToken is ERC20Basic {
106   using SafeMath for uint256;
107 
108   mapping(address => uint256) balances;
109 
110   /**
111   * @dev transfer token for a specified address
112   * @param _to The address to transfer to.
113   * @param _value The amount to be transferred.
114   */
115   function transfer(address _to, uint256 _value) public returns (bool) {
116     require(_to != address(0));
117     require(_value <= balances[msg.sender]);
118 
119     // SafeMath.sub will throw if there is not enough balance.
120     balances[msg.sender] = balances[msg.sender].sub(_value);
121     balances[_to] = balances[_to].add(_value);
122     Transfer(msg.sender, _to, _value);
123     return true;
124   }
125 
126   /**
127   * @dev Gets the balance of the specified address.
128   * @param _owner The address to query the the balance of.
129   * @return An uint256 representing the amount owned by the passed address.
130   */
131   function balanceOf(address _owner) public view returns (uint256 balance) {
132     return balances[_owner];
133   }
134 
135 }
136 
137 /**
138  * @title Standard ERC20 token
139  *
140  * @dev Implementation of the basic standard token.
141  * @dev https://github.com/ethereum/EIPs/issues/20
142  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
143  */
144 contract StandardToken is ERC20, BasicToken {
145 
146   mapping (address => mapping (address => uint256)) internal allowed;
147 
148 
149   /**
150    * @dev Transfer tokens from one address to another
151    * @param _from address The address which you want to send tokens from
152    * @param _to address The address which you want to transfer to
153    * @param _value uint256 the amount of tokens to be transferred
154    */
155   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
156     require(_to != address(0));
157     require(_value <= balances[_from]);
158     require(_value <= allowed[_from][msg.sender]);
159 
160     balances[_from] = balances[_from].sub(_value);
161     balances[_to] = balances[_to].add(_value);
162     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
163     Transfer(_from, _to, _value);
164     return true;
165   }
166 
167   /**
168    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
169    *
170    * Beware that changing an allowance with this method brings the risk that someone may use both the old
171    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
172    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
173    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
174    * @param _spender The address which will spend the funds.
175    * @param _value The amount of tokens to be spent.
176    */
177   function approve(address _spender, uint256 _value) public returns (bool) {
178     allowed[msg.sender][_spender] = _value;
179     Approval(msg.sender, _spender, _value);
180     return true;
181   }
182 
183   /**
184    * @dev Function to check the amount of tokens that an owner allowed to a spender.
185    * @param _owner address The address which owns the funds.
186    * @param _spender address The address which will spend the funds.
187    * @return A uint256 specifying the amount of tokens still available for the spender.
188    */
189   function allowance(address _owner, address _spender) public view returns (uint256) {
190     return allowed[_owner][_spender];
191   }
192 
193   /**
194    * approve should be called when allowed[_spender] == 0. To increment
195    * allowed value is better to use this function to avoid 2 calls (and wait until
196    * the first transaction is mined)
197    * From MonolithDAO Token.sol
198    */
199   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
200     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
201     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
202     return true;
203   }
204 
205   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
206     uint oldValue = allowed[msg.sender][_spender];
207     if (_subtractedValue > oldValue) {
208       allowed[msg.sender][_spender] = 0;
209     } else {
210       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
211     }
212     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
213     return true;
214   }
215 
216 }
217 
218 /**
219  * @title Mintable token
220  * @dev Simple ERC20 Token example, with mintable token creation
221  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
222  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
223  */
224 contract MintableToken is StandardToken, Ownable {
225   event Mint(address indexed to, uint256 amount);
226   event MintFinished();
227 
228   bool public mintingFinished = false;
229 
230 
231   modifier canMint() {
232     require(!mintingFinished);
233     _;
234   }
235 
236   /**
237    * @dev Function to mint tokens
238    * @param _to The address that will receive the minted tokens.
239    * @param _amount The amount of tokens to mint.
240    * @return A boolean that indicates if the operation was successful.
241    */
242   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
243     totalSupply = totalSupply.add(_amount);
244     balances[_to] = balances[_to].add(_amount);
245     Mint(_to, _amount);
246     Transfer(address(0), _to, _amount);
247     return true;
248   }
249 
250   /**
251    * @dev Function to stop minting new tokens.
252    * @return True if the operation was successful.
253    */
254   function finishMinting() onlyOwner canMint public returns (bool) {
255     mintingFinished = true;
256     MintFinished();
257     return true;
258   }
259 }
260 
261 
262 /**
263  * @title FemaleToken
264  * @dev The main token contract
265  */
266 contract FemaleToken is MintableToken {
267 
268   string public name = "Female Token";
269   string public symbol = "FEM";
270   uint public decimals = 18;
271 
272   bool public tradingStarted = false;
273 
274   /**
275    * @dev modifier that throws if trading has not started yet
276    */
277   modifier hasStartedTrading() {
278     require(tradingStarted);
279     _;
280   }
281 
282   /**
283    * @dev Allows the owner to enable the trading. This can not be undone
284    */
285   function startTrading() public onlyOwner {
286     tradingStarted = true;
287   }
288 
289   /**
290    * @dev Allows anyone to transfer the TEST tokens once trading has started
291    * @param _to the recipient address of the tokens. 
292    * @param _value number of tokens to be transfered. 
293    */
294   function transfer(address _to, uint _value) public hasStartedTrading returns (bool) {
295     super.transfer(_to, _value);
296   }
297 
298    /**
299    * @dev Allows anyone to transfer the TEST tokens once trading has started
300    * @param _from address The address which you want to send tokens from
301    * @param _to address The address which you want to transfer to
302    * @param _value uint the amout of tokens to be transfered
303    */
304   function transferFrom(address _from, address _to, uint _value) public hasStartedTrading returns (bool) {
305     super.transferFrom(_from, _to, _value);
306   }
307 
308 }
309 
310 
311 /**
312  * @title FemaleTokenSale
313  * @dev The main Female token sale contract
314  */
315 contract FemaleTokenSale is Ownable {
316   using SafeMath for uint;
317   event TokenSold(address recipient, uint ether_amount, uint pay_amount);
318   event AuthorizedCreate(address recipient, uint pay_amount);
319   event MainSaleClosed();
320 
321   FemaleToken public token = new FemaleToken();
322 
323   address public multisigVault = 0xB80F274a7596D4Dc995f032e24Cb55B3902399F5;
324 
325   uint hardcap = 100000 ether;
326   uint public rate = 1000; // 1ETH = 1000FEM
327   uint restrictedPercent = 20;
328 
329   uint public fiatDeposits = 0;
330   uint public startTime = 1514764800; //Mon, 01 Jan 2018 00:00:00 GMT
331   uint public endTime = 1517356800; // Wed, 31 Jan 2018 00:00:00 GMT
332   uint public bonusTime = 1518220800; // Sat, 10 Feb 2018 00:00:00 GMT
333   //Start of token transfer allowance -  Sun, 11 Feb 2018 
334   mapping(address => bool) femalestate;
335   
336   /**
337    * @dev modifier to allow token creation only when the sale IS ON
338    */
339   modifier saleIsOn() {
340     require(now > startTime && now < endTime);
341     _;
342   }
343 
344   /**
345    * @dev modifier to allow token creation only when the hardcap has not been reached
346    */
347   modifier isUnderHardCap() {
348     require(multisigVault.balance + fiatDeposits <= hardcap);
349     _;
350   }
351  /**
352  * @dev Function for calculation bonus tokens
353  * bonus 1% for each 100 FEM batch per buy (up to max 50% bonus)
354  * @param initwei - amount of donation in wei
355  */
356  function bonusRate(uint initwei) internal view returns (uint){
357 	uint bonRate;
358 	uint calcRate = initwei.div(100000000000000000);
359 	if (calcRate > 50 ) bonRate = 150 * rate / 100;
360 	else if (calcRate <1) bonRate = rate;
361 	else {
362 		bonRate = calcRate.mul(rate) / 100;
363 		bonRate += rate;
364 	}
365 	return bonRate;
366   }
367    
368   /**
369    * @dev Allows anyone to create tokens by depositing ether.
370    * @param recipient the recipient to receive tokens. 
371    */
372   function createTokens(address recipient) public isUnderHardCap saleIsOn payable {
373     uint256 weiAmount = msg.value;
374 	uint bonusTokensRate = bonusRate(weiAmount);
375 	uint tokens = bonusTokensRate.mul(weiAmount);
376 	token.mint(recipient, tokens);
377     require(multisigVault.send(msg.value));
378     TokenSold(recipient, msg.value, tokens);
379 	femalestate[msg.sender]= false;
380   }
381 
382   /**
383    * @dev Allows create tokens. This is used for fiat deposits.
384    * @param recipient the recipient to receive tokens.
385    * @param fiatdeposit - amount of deposit in ETH. 
386    */
387   function altCreateTokens(address recipient, uint fiatdeposit) public isUnderHardCap saleIsOn onlyOwner {
388     require(recipient != address(0));
389 	require(fiatdeposit > 0);
390 	fiatDeposits += fiatdeposit;
391 	uint bonusTokensRate = bonusRate(fiatdeposit);
392 	uint tokens = bonusTokensRate.mul(fiatdeposit);
393 	token.mint(recipient, tokens);
394     AuthorizedCreate(recipient, tokens);
395 	femalestate[recipient]= false;
396   }
397 
398   /**
399    * @dev Allows the owner to finish the minting. This will create the 
400    * restricted tokens and then close the minting.
401    * Then the ownership of the FEM token contract is transfered to this owner.
402    * Also it allows token transfer function.
403    */
404   function finishMinting() public onlyOwner {
405     require(now > bonusTime);
406 	uint issuedTokenSupply = token.totalSupply();
407     uint restrictedTokens = issuedTokenSupply.mul(restrictedPercent).div(100 - restrictedPercent);
408     token.mint(multisigVault, restrictedTokens);
409     token.finishMinting();
410 	token.startTrading();
411     token.transferOwnership(owner);
412     MainSaleClosed();
413   }
414 
415   /**
416   * @dev Allows the owner to double tokens of female investors.
417   * @param adr - address of female investor.
418   * femalestate allows to set double tokens only once per investor.
419   * doublebonus can only be set during 10 days period after ICO end.
420   */
421   
422   function doubleBonus(address adr) public onlyOwner {
423 	require (now > endTime && now < bonusTime);
424 	if (!femalestate[adr]) {
425 		femalestate[adr]= true;
426 		uint unittoken = token.balanceOf(adr);
427 		uint doubletoken = unittoken.mul(2);
428 		if (unittoken < doubletoken) {token.mint(adr, unittoken);}
429 	}
430   }
431   
432   /**
433   * @dev Same as doubleBonus - just for array of addresses.
434   * As was said before - this function works only during 10 days after ICO ends.
435   */ 
436   
437    function doubleBonusArray(address[] adr) public onlyOwner {
438 	uint i = 0;
439 	while (i < adr.length) {
440 		doubleBonus(adr[i]);
441 		i++;
442     }
443   }
444   
445   /**
446    * @dev Allows the owner to transfer ERC20 tokens to the multi sig vault
447    * @param _token the contract address of the ERC20 contract
448    */
449   function retrieveTokens(address _token) public onlyOwner {
450     ERC20 alttoken = ERC20(_token);
451     alttoken.transfer(multisigVault, alttoken.balanceOf(this));
452   }
453 
454   /**
455    * @dev Fallback function which receives ether and created the appropriate number of tokens for the 
456    * msg.sender.
457    */
458   function() external payable {
459     createTokens(msg.sender);
460   }
461 
462 }