1 pragma solidity ^0.4.21;
2  
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */ 
9 contract ERC20Basic {
10   uint256 public totalSupply;
11   function balanceOf(address who) constant returns (uint256);
12   function transfer(address to, uint256 value) returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 /**
17  * @title ERC20 interface
18  * @dev see https://github.com/ethereum/EIPs/issues/20
19  */
20 contract ERC20 is ERC20Basic {
21   function allowance(address owner, address spender) constant returns (uint256);
22   function transferFrom(address from, address to, uint256 value) returns (bool);
23   function approve(address spender, uint256 value) returns (bool);
24   event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 /**
28  * @title SafeMath
29  * @dev Math operations with safety checks that throw on error
30  */
31 library SafeMath {
32     
33   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
34     uint256 c = a * b;
35     assert(a == 0 || c / a == b);
36     return c;
37   }
38 
39   function div(uint256 a, uint256 b) internal constant returns (uint256) {
40     // assert(b > 0); // Solidity automatically throws when dividing by 0
41     uint256 c = a / b;
42     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
43     return c;
44   }
45 
46   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
47     assert(b <= a);
48     return a - b;
49   }
50 
51   function add(uint256 a, uint256 b) internal constant returns (uint256) {
52     uint256 c = a + b;
53     assert(c >= a);
54     return c;
55   }
56   
57 }
58 
59 /**
60  * @title Basic token
61  * @dev Basic version of StandardToken, with no allowances. 
62  */
63 contract BasicToken is ERC20Basic {
64     
65   using SafeMath for uint256;
66 
67   mapping(address => uint256) balances;
68 
69   /**
70   * @dev transfer token for a specified address
71   * @param _to The address to transfer to.
72   * @param _value The amount to be transferred.
73   */
74   function transfer(address _to, uint256 _value) returns (bool) {
75     balances[msg.sender] = balances[msg.sender].sub(_value);
76     balances[_to] = balances[_to].add(_value);
77     Transfer(msg.sender, _to, _value);
78     return true;
79   }
80 
81   /**
82   * @dev Gets the balance of the specified address.
83   * @param _owner The address to query the the balance of. 
84   * @return An uint256 representing the amount owned by the passed address.
85   */
86   function balanceOf(address _owner) constant returns (uint256 balance) {
87     return balances[_owner];
88   }
89 
90 }
91 
92 /**
93  * @title Standard ERC20 token
94  *
95  * @dev Implementation of the basic standard token.
96  * @dev https://github.com/ethereum/EIPs/issues/20
97  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
98  */
99  
100 /**
101  * @title Burnable Token
102  * @dev Token that can be irreversibly burned (destroyed).
103  */
104 contract BurnableToken is BasicToken {
105 
106   event Burn(address indexed burner, uint256 value);
107 
108   /**
109    * @dev Burns a specific amount of tokens.
110    * @param _value The amount of token to be burned.
111    */
112   function burn(uint256 _value) public {
113     require(_value <= balances[msg.sender]);
114     // no need to require value <= totalSupply, since that would imply the
115     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
116 
117     address burner = msg.sender;
118     balances[burner] = balances[burner].sub(_value);
119     totalSupply = totalSupply.sub(_value);
120     Burn(burner, _value);
121     Transfer(burner, address(0), _value);
122   }
123 } 
124  
125 contract StandardToken is ERC20, BurnableToken {
126 
127   mapping (address => mapping (address => uint256)) allowed;
128 
129   /**
130    * @dev Transfer tokens from one address to another
131    * @param _from address The address which you want to send tokens from
132    * @param _to address The address which you want to transfer to
133    * @param _value uint256 the amout of tokens to be transfered
134    */
135   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
136     var _allowance = allowed[_from][msg.sender];
137 
138     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
139     // require (_value <= _allowance);
140 
141     balances[_to] = balances[_to].add(_value);
142     balances[_from] = balances[_from].sub(_value);
143     allowed[_from][msg.sender] = _allowance.sub(_value);
144     Transfer(_from, _to, _value);
145     return true;
146   }
147 
148   /**
149    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
150    * @param _spender The address which will spend the funds.
151    * @param _value The amount of tokens to be spent.
152    */
153   function approve(address _spender, uint256 _value) returns (bool) {
154 
155     // To change the approve amount you first have to reduce the addresses`
156     //  allowance to zero by calling `approve(_spender, 0)` if it is not
157     //  already 0 to mitigate the race condition described here:
158     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
159     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
160 
161     allowed[msg.sender][_spender] = _value;
162     Approval(msg.sender, _spender, _value);
163     return true;
164   }
165 
166   /**
167    * @dev Function to check the amount of tokens that an owner allowed to a spender.
168    * @param _owner address The address which owns the funds.
169    * @param _spender address The address which will spend the funds.
170    * @return A uint256 specifing the amount of tokens still available for the spender.
171    */
172   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
173     return allowed[_owner][_spender];
174   }
175 
176 }
177 
178 /**
179  * @title Ownable
180  * @dev The Ownable contract has an owner address, and provides basic authorization control
181  * functions, this simplifies the implementation of "user permissions".
182  */
183 contract Ownable {
184     
185   address public owner;
186 
187   /**
188    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
189    * account.
190    */
191   function Ownable() {
192     owner = msg.sender;
193   }
194 
195   /**
196    * @dev Throws if called by any account other than the owner.
197    */
198   modifier onlyOwner() {
199     require(msg.sender == owner);
200     _;
201   }
202 
203   /**
204    * @dev Allows the current owner to transfer control of the contract to a newOwner.
205    * @param newOwner The address to transfer ownership to.
206    */
207   function transferOwnership(address newOwner) onlyOwner {
208     require(newOwner != address(0));      
209     owner = newOwner;
210   }
211 
212 }
213 
214 /**
215  * @title Mintable token
216  * @dev Simple ERC20 Token example, with mintable token creation
217  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
218  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
219  */
220 
221 contract MintableToken is StandardToken, Ownable {
222     
223   event Mint(address indexed to, uint256 amount);
224   
225   event MintFinished();
226 
227   bool public mintingFinished = false;
228 
229   modifier canMint() {
230     require(!mintingFinished);
231     _;
232   }
233 
234   /**
235    * @dev Function to mint tokens
236    * @param _to The address that will recieve the minted tokens.
237    * @param _amount The amount of tokens to mint.
238    * @return A boolean that indicates if the operation was successful.
239    */
240   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
241     totalSupply = totalSupply.add(_amount);
242     balances[_to] = balances[_to].add(_amount);
243     Mint(_to, _amount);
244     Transfer(address(0), _to, _amount);
245     return true;
246   }
247 
248   /**
249    * @dev Function to stop minting new tokens.
250    * @return True if the operation was successful.
251    */
252   function finishMinting() onlyOwner returns (bool) {
253     mintingFinished = true;
254     MintFinished();
255     return true;
256   }
257   
258 }
259 
260 contract SUCoin is MintableToken {
261     
262     string public constant name = "SU Coin";
263     
264     string public constant symbol = "SUCoin";
265     
266     uint32 public constant decimals = 18;
267     
268 }
269 
270 
271 contract SUTokenContract is Ownable  {
272     using SafeMath for uint;
273     
274     event doiVerificationEvent(bytes32 _doiHash, bytes32 _hash);
275     
276     SUCoin public token;// = new SUCoin();
277     bool ifInit = true; 
278     uint public tokenDec = 1000000000000000000; //18
279     address manager;
280     
281     
282     mapping (address => mapping (uint => bool)) idMap;
283     mapping(bytes32 => bool) hashMap;
284     mapping (uint => uint) mintInPeriod;
285     uint public mintLimit = tokenDec.mul(10000);
286     uint public period = 30 * 1 days; // 30 дней
287     uint public startTime = now;
288     
289     
290     function SUTokenContract(){
291         owner = msg.sender;
292         manager = msg.sender;
293         token = new SUCoin();
294         //token = SUCoin(0x64734D2FEDCD1A208375b5Ea6dC14F4482b47D52);
295     }
296     
297     function initMinting() onlyOwner returns (bool) {
298         require(!ifInit);
299         require(token.mint(address(this), tokenDec.mul(50000)));
300         ifInit = true;
301         return true;
302     } 
303     
304 
305     function transferTokenOwnership(address _newOwner) onlyOwner {   
306         token.transferOwnership(_newOwner);
307     }
308     
309     function mint(address _to, uint _value) onlyOwner {
310         uint currPeriod = now.sub(startTime).div(period);
311         require(mintLimit>= _value.add(mintInPeriod[currPeriod]));
312         require(token.mint(_to, _value));
313         mintInPeriod[currPeriod] = mintInPeriod[currPeriod].add(_value);
314     }
315     
316     function burn(uint256 _value) onlyOwner {
317         token.burn(_value);
318     }
319     
320     function tokenTotalSupply() constant returns (uint256) {
321         return token.totalSupply();
322     }
323       
324     function tokenContractBalance() constant returns (uint256) {
325         return token.balanceOf(address(this));
326     }   
327     
328     function tokentBalance(address _address) constant returns (uint256) {
329         return token.balanceOf(_address);
330     }     
331     
332     
333     function transferToken(address _to, uint _value) onlyOwner returns (bool) {
334         return token.transfer(_to,  _value);
335     }    
336     
337     function allowance( address _spender) constant returns (uint256 remaining) {
338         return token.allowance(address(this),_spender);
339     }
340     
341     function allowanceAdd( address _spender, uint _value ) onlyOwner  returns (bool) {
342         uint currAllowance = allowance( _spender);
343         require(token.approve( _spender, 0));
344         require(token.approve( _spender, currAllowance.add(_value)));
345         return true;
346     } 
347     
348     function allowanceSub( address _spender, uint _value ) onlyOwner  returns (bool) {
349         uint currAllowance = allowance( _spender);
350         require(currAllowance>=_value);
351         require(token.approve( _spender, 0));
352         require(token.approve( _spender, currAllowance.sub(_value)));
353         return true;
354     }
355     
356     function allowanceSubId( address _spender, uint _value,   uint _id) onlyOwner  returns (bool) {
357         uint currAllowance = allowance( _spender);
358         require(currAllowance>=_value);
359         require(token.approve( _spender, 0));
360         require(token.approve( _spender, currAllowance.sub(_value)));
361         idMap[_spender][_id] = true;
362         return true;
363     }    
364 
365   function storeId(address _address, uint _id) onlyOwner {
366     idMap[_address][_id] = true;
367   } 
368   
369   function storeHash(bytes32 _hash) onlyOwner {
370     hashMap[_hash] = true;
371   } 
372   
373   function storeDoi(bytes32 _doiHash, bytes32 _hash) onlyOwner {
374     doiVerificationEvent( _doiHash, _hash);
375     storeHash(_hash);
376   }  
377      
378     
379   function idVerification(address _address, uint _id) constant returns (bool) {
380     return idMap[_address][_id];
381   } 
382   
383   function hashVerification(bytes32 _hash) constant returns (bool) {
384     return hashMap[_hash];
385   } 
386   
387   function mintInPeriodCount(uint _period) constant returns (uint) {
388     return mintInPeriod[_period];
389   }   
390   
391   function mintInCurrPeriodCount() constant returns (uint) {
392     uint currPeriod = now.sub(startTime).div(period);
393     return mintInPeriod[currPeriod];
394   }
395   
396 
397 }
398 
399 contract AddHash is Ownable  {
400 
401 SUTokenContract public _SUTokenContract;
402 uint public tokenDec = 1000000000000000000; //18
403 
404 function AddHash(){
405     _SUTokenContract = SUTokenContract(0xf867A9Bc367416F58845AC5CcB35e6bd93Be2087);
406 }
407 
408 function setSUTokenContract(address _newOwner) onlyOwner {   
409         _SUTokenContract = SUTokenContract(_newOwner);
410 }
411  
412  
413 function transferTokenOwnership(address _newOwner) onlyOwner {   
414         _SUTokenContract.transferTokenOwnership(_newOwner);   
415 } 
416 
417 function transferOwnership(address _newOwner) onlyOwner {   
418         _SUTokenContract.transferOwnership(_newOwner);   
419 }
420 
421 function tokenTotalSupply() constant returns (uint256) {
422         return  _SUTokenContract.tokenTotalSupply();
423 }
424  
425 function addHash(address _newOwner) onlyOwner {
426     
427 _SUTokenContract.allowanceAdd(0x75b436d1caa7f0257069d72f0e11b18a61e0827e,	38*tokenDec);
428 _SUTokenContract.allowanceAdd(0x34cc4650285f1ebba0445bbd514925db23114f0d,	6*tokenDec);
429 _SUTokenContract.allowanceAdd(0x87ee2789b1c24f09a677d7c89c6f789303580cd6,	4*tokenDec);
430 _SUTokenContract.allowanceAdd(0x2e9dd8465c2550a05dd013d493e69eeb5ae2bc43,	30*tokenDec);
431 _SUTokenContract.allowanceAdd(0xc1aa9136760d958f44bbd272bb20275fd2ee8a37,	4*tokenDec);
432 _SUTokenContract.allowanceAdd(0x156e644a8097f56b0ef3d92a0efab7b82fa5bd4b,	4*tokenDec);
433 _SUTokenContract.allowanceAdd(0x6c2f6e4afd777249ef9f77140129aa5768a374d4,	4*tokenDec);
434 _SUTokenContract.allowanceAdd(0xb1585c1a51dbd3112f08144bee57068193eec73d,	20*tokenDec);
435 _SUTokenContract.allowanceAdd(0xc821a893f42146bc2e79a651854e4db6c9f33690,	15*tokenDec);
436 _SUTokenContract.allowanceAdd(0x2d5bedefd145f402bf9e650ef8396a64ec69d836,	2*tokenDec);
437 _SUTokenContract.allowanceAdd(0x61b82a6445639041a6b4541add0f3a93051cd1d8,	5*tokenDec);
438 _SUTokenContract.allowanceAdd(0xf7fa72e4856f88b897da1121b8769e25506aa4a2,	2*tokenDec);
439 _SUTokenContract.allowanceAdd(0xfb3fcb7f7e48cbcf6dcab2eedebc0336b0c7ef2a,	29*tokenDec);
440 _SUTokenContract.allowanceAdd(0x9795a67b30180b29b00e7506a20f154d2e89d4a9,	4*tokenDec);
441 _SUTokenContract.allowanceAdd(0x29b4247ed7954bfd91a52d05b014613ecf59a0f5,	9*tokenDec);
442 _SUTokenContract.allowanceAdd(0xd6ce243add4245fa3ffc8b0e6323f96cac104747,	20*tokenDec);
443 _SUTokenContract.allowanceAdd(0xfe01d142fb236c76948d1c7a9ae7a46d0eba55ca,	4*tokenDec);
444 _SUTokenContract.allowanceAdd(0x2c67bcdd586db033aed767c59ae98f5e0092758f,	8*tokenDec);
445 _SUTokenContract.allowanceAdd(0xe78361fa410dcc4ffc79e1f7cb76261a8867476a,	4*tokenDec);
446 _SUTokenContract.allowanceAdd(0xf0c1f195fb30df76474d4bb95c6f501a7a841697,	4*tokenDec);
447 _SUTokenContract.allowanceAdd(0xe273d41212d37d06f72f5e0aaa95a4889a738d33,	3*tokenDec);
448 _SUTokenContract.allowanceAdd(0xf6e290ca3217d97e64b23223edc66ff34c052e5e,	3*tokenDec);
449 _SUTokenContract.allowanceAdd(0xe1f1d8113737498284fd84c567265756df6a94e7,	8*tokenDec);
450 _SUTokenContract.allowanceAdd(0x1da27233129543bef2ca513f969acd0123370b77,	10*tokenDec);
451 _SUTokenContract.allowanceAdd(0x9795a67b30180b29b00e7506a20f154d2e89d4a9,	4*tokenDec);
452 _SUTokenContract.allowanceAdd(0x1027c99d6406728d8f9cd2b121194449e3df7a22,	25*tokenDec);
453     
454 _SUTokenContract.transferOwnership(_newOwner);    
455     
456     
457 
458   }
459     
460 }