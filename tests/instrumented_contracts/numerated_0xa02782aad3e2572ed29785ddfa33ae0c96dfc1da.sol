1 pragma solidity ^0.4.19;
2 
3 /*
4 Tokensgate Limited
5 Version 1.01
6 Release date: 2018-05-15
7 */
8 
9 // File: zeppelin-solidity/contracts/math/SafeMath.sol
10 
11 /**
12  * @title SafeMath
13  * @dev Math operations with safety checks that throw on error
14  */
15 library SafeMath {
16   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17     if (a == 0) {
18       return 0;
19     }
20     uint256 c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37   function add(uint256 a, uint256 b) internal pure returns (uint256) {
38     uint256 c = a + b;
39     assert(c >= a);
40     return c;
41   }
42 }
43 
44 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
45 
46 /**
47  * @title Ownable
48  * @dev The Ownable contract has an owner address, and provides basic authorization control
49  * functions, this simplifies the implementation of "user permissions".
50  */
51 contract Ownable {
52   address public owner;
53 
54 
55   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
56 
57 
58   /**
59    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
60    * account.
61    */
62   function Ownable() public {
63     owner = msg.sender;
64   }
65 
66 
67   /**
68    * @dev Throws if called by any account other than the owner.
69    */
70   modifier onlyOwner() {
71     require(msg.sender == owner);
72     _;
73   }
74 
75 
76   /**
77    * @dev Allows the current owner to transfer control of the contract to a newOwner.
78    * @param newOwner The address to transfer ownership to.
79    */
80   function transferOwnership(address newOwner) public onlyOwner {
81     require(newOwner != address(0));
82     OwnershipTransferred(owner, newOwner);
83     owner = newOwner;
84   }
85 
86 }
87 
88 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
89 
90 /**
91  * @title ERC20Basic
92  * @dev Simpler version of ERC20 interface
93  * @dev see https://github.com/ethereum/EIPs/issues/179
94  */
95 contract ERC20Basic {
96   uint256 public totalSupply;
97   function balanceOf(address who) public view returns (uint256);
98   function transfer(address to, uint256 value) public returns (bool);
99   event Transfer(address indexed from, address indexed to, uint256 value);
100 }
101 
102 // File: zeppelin-solidity/contracts/token/BasicToken.sol
103 
104 /**
105  * @title Basic token
106  * @dev Basic version of StandardToken, with no allowances.
107  */
108 contract BasicToken is ERC20Basic {
109   using SafeMath for uint256;
110 
111   mapping(address => uint256) balances;
112 
113   /**
114   * @dev transfer token for a specified address
115   * @param _to The address to transfer to.
116   * @param _value The amount to be transferred.
117   */
118   function transfer(address _to, uint256 _value) public returns (bool) {
119     require(_to != address(0));
120     require(_value <= balances[msg.sender]);
121 
122     // SafeMath.sub will throw if there is not enough balance.
123     balances[msg.sender] = balances[msg.sender].sub(_value);
124     balances[_to] = balances[_to].add(_value);
125     Transfer(msg.sender, _to, _value);
126     return true;
127   }
128 
129   /**
130   * @dev Gets the balance of the specified address.
131   * @param _owner The address to query the the balance of.
132   * @return An uint256 representing the amount owned by the passed address.
133   */
134   function balanceOf(address _owner) public view returns (uint256 balance) {
135     return balances[_owner];
136   }
137 
138 }
139 
140 // File: zeppelin-solidity/contracts/token/ERC20.sol
141 
142 /**
143  * @title ERC20 interface
144  * @dev see https://github.com/ethereum/EIPs/issues/20
145  */
146 contract ERC20 is ERC20Basic {
147   function allowance(address owner, address spender) public view returns (uint256);
148   function transferFrom(address from, address to, uint256 value) public returns (bool);
149   function approve(address spender, uint256 value) public returns (bool);
150   event Approval(address indexed owner, address indexed spender, uint256 value);
151 }
152 
153 // File: zeppelin-solidity/contracts/token/StandardToken.sol
154 
155 /**
156  * @title Standard ERC20 token
157  *
158  * @dev Implementation of the basic standard token.
159  * @dev https://github.com/ethereum/EIPs/issues/20
160  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
161  */
162 contract StandardToken is ERC20, BasicToken {
163 
164   mapping (address => mapping (address => uint256)) internal allowed;
165 
166 
167   /**
168    * @dev Transfer tokens from one address to another
169    * @param _from address The address which you want to send tokens from
170    * @param _to address The address which you want to transfer to
171    * @param _value uint256 the amount of tokens to be transferred
172    */
173   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
174     require(_to != address(0));
175     require(_value <= balances[_from]);
176     require(_value <= allowed[_from][msg.sender]);
177 
178     balances[_from] = balances[_from].sub(_value);
179     balances[_to] = balances[_to].add(_value);
180     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
181     Transfer(_from, _to, _value);
182     return true;
183   }
184 
185   /**
186    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
187    *
188    * Beware that changing an allowance with this method brings the risk that someone may use both the old
189    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
190    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
191    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
192    * @param _spender The address which will spend the funds.
193    * @param _value The amount of tokens to be spent.
194    */
195   function approve(address _spender, uint256 _value) public returns (bool) {
196     allowed[msg.sender][_spender] = _value;
197     Approval(msg.sender, _spender, _value);
198     return true;
199   }
200 
201   /**
202    * @dev Function to check the amount of tokens that an owner allowed to a spender.
203    * @param _owner address The address which owns the funds.
204    * @param _spender address The address which will spend the funds.
205    * @return A uint256 specifying the amount of tokens still available for the spender.
206    */
207   function allowance(address _owner, address _spender) public view returns (uint256) {
208     return allowed[_owner][_spender];
209   }
210 
211   /**
212    * @dev Increase the amount of tokens that an owner allowed to a spender.
213    *
214    * approve should be called when allowed[_spender] == 0. To increment
215    * allowed value is better to use this function to avoid 2 calls (and wait until
216    * the first transaction is mined)
217    * From MonolithDAO Token.sol
218    * @param _spender The address which will spend the funds.
219    * @param _addedValue The amount of tokens to increase the allowance by.
220    */
221   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
222     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
223     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
224     return true;
225   }
226 
227   /**
228    * @dev Decrease the amount of tokens that an owner allowed to a spender.
229    *
230    * approve should be called when allowed[_spender] == 0. To decrement
231    * allowed value is better to use this function to avoid 2 calls (and wait until
232    * the first transaction is mined)
233    * From MonolithDAO Token.sol
234    * @param _spender The address which will spend the funds.
235    * @param _subtractedValue The amount of tokens to decrease the allowance by.
236    */
237   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
238     uint oldValue = allowed[msg.sender][_spender];
239     if (_subtractedValue > oldValue) {
240       allowed[msg.sender][_spender] = 0;
241     } else {
242       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
243     }
244     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
245     return true;
246   }
247 
248 }
249 
250 // File: zeppelin-solidity/contracts/token/MintableToken.sol
251 
252 /**
253  * @title Mintable token
254  * @dev Simple ERC20 Token example, with mintable token creation
255  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
256  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
257  */
258 
259 contract MintableToken is StandardToken, Ownable {
260   event Mint(address indexed to, uint256 amount);
261   event MintFinished();
262 
263   bool public mintingFinished = false;
264 
265 
266   modifier canMint() {
267     require(!mintingFinished);
268     _;
269   }
270 
271   /**
272    * @dev Function to mint tokens
273    * @param _to The address that will receive the minted tokens.
274    * @param _amount The amount of tokens to mint.
275    * @return A boolean that indicates if the operation was successful.
276    */
277   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
278     totalSupply = totalSupply.add(_amount);
279     balances[_to] = balances[_to].add(_amount);
280     Mint(_to, _amount);
281     Transfer(address(0), _to, _amount);
282     return true;
283   }
284 
285   /**
286    * @dev Function to stop minting new tokens.
287    * @return True if the operation was successful.
288    */
289   function finishMinting() onlyOwner canMint public returns (bool) {
290     mintingFinished = true;
291     MintFinished();
292     return true;
293   }
294 }
295 
296 contract TokensGate is MintableToken {
297   event Burn(address indexed burner, uint256 value);
298 
299   string public constant name = "TokensGate";
300   string public constant symbol = "TGC";
301   uint8 public constant decimals = 18;
302   
303   bool public AllowTransferGlobal = false;
304   bool public AllowTransferLocal = false;
305   bool public AllowTransferExternal = false;
306   bool public AllowBurnByCreator = true;
307   bool public AllowBurn = true;
308   
309   mapping(address => uint256) public Whitelist;
310   mapping(address => uint256) public LockupList;
311   mapping(address => bool) public WildcardList;
312   mapping(address => bool) public Managers;
313     
314   function allowTransfer(address _from, address _to) public view returns (bool) {
315     if (WildcardList[_from])
316       return true;
317       
318     if (LockupList[_from] > now)
319       return false;
320     
321     if (!AllowTransferGlobal) {
322       if (AllowTransferLocal && Whitelist[_from] != 0 && Whitelist[_to] != 0 && Whitelist[_from] < now && Whitelist[_to] < now)
323         return true;
324             
325       if (AllowTransferExternal && Whitelist[_from] != 0 && Whitelist[_from] < now)
326         return true;
327         
328       return false;
329     }
330       
331     return true;
332   }
333     
334   function allowManager() public view returns (bool) {
335     if (msg.sender == owner)
336       return true;
337     
338     if (Managers[msg.sender])
339       return true;
340       
341     return false;
342   }
343     
344   function transfer(address _to, uint256 _value) public returns (bool) {
345     require(allowTransfer(msg.sender, _to));
346       
347     return super.transfer(_to, _value);
348   }
349   
350   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
351     require(allowTransfer(_from, _to));
352       
353     return super.transferFrom(_from, _to, _value);
354   }
355     
356   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
357     require(totalSupply.add(_amount) <= 1000000000000000000000000000);
358 
359     return super.mint(_to, _amount);
360   }
361     
362   function burn(uint256 _value) public {
363     require(AllowBurn);
364     require(_value <= balances[msg.sender]);
365 
366     balances[msg.sender] = balances[msg.sender].sub(_value);
367     totalSupply = totalSupply.sub(_value);
368     Burn(msg.sender, _value);
369     Transfer(msg.sender, address(0), _value);
370   }
371   
372   function burnByCreator(address _burner, uint256 _value) onlyOwner public {
373     require(AllowBurnByCreator);
374     require(_value <= balances[_burner]);
375     
376     balances[_burner] = balances[_burner].sub(_value);
377     totalSupply = totalSupply.sub(_value);
378     Burn(_burner, _value);
379     Transfer(_burner, address(0), _value);
380   }
381   
382   function finishBurning() onlyOwner public returns (bool) {
383     AllowBurn = false;
384     return true;
385   }
386   
387   function finishBurningByCreator() onlyOwner public returns (bool) {
388     AllowBurnByCreator = false;
389     return true;
390   }
391   
392   function setManager(address _manager, bool _status) onlyOwner public {
393     Managers[_manager] = _status;
394   }
395   
396   function setAllowTransferGlobal(bool _status) onlyOwner public {
397     AllowTransferGlobal = _status;
398   }
399   
400   function setAllowTransferLocal(bool _status) onlyOwner public {
401     AllowTransferLocal = _status;
402   }
403   
404   function setAllowTransferExternal(bool _status) onlyOwner public {
405     AllowTransferExternal = _status;
406   }
407     
408   function setWhitelist(address _address, uint256 _date) public {
409     require(allowManager());
410     
411     Whitelist[_address] = _date;
412   }
413   
414   function setLockupList(address _address, uint256 _date) onlyOwner public {
415     LockupList[_address] = _date;
416   }
417   
418   function setWildcardList(address _address, bool _status) onlyOwner public {
419     WildcardList[_address] = _status;
420   }
421   
422   function transferTokens(address walletToTransfer, address tokenAddress, uint256 tokenAmount) onlyOwner payable public {
423     ERC20 erc20 = ERC20(tokenAddress);
424     erc20.transfer(walletToTransfer, tokenAmount);
425   }
426   
427   function transferEth(address walletToTransfer, uint256 weiAmount) onlyOwner payable public {
428     require(walletToTransfer != address(0));
429     require(address(this).balance >= weiAmount);
430     require(address(this) != walletToTransfer);
431 
432     require(walletToTransfer.call.value(weiAmount)());
433   }
434 }