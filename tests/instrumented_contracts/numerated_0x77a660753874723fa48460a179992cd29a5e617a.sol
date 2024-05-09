1 pragma solidity ^0.4.23;
2 
3 
4 
5 
6 /**
7  * @title Ownable
8  * @dev The Ownable contract has an owner address, and provides basic authorization control
9  * functions, this simplifies the implementation of "user permissions".
10  */
11 contract Ownable {
12   address public owner;
13 
14 
15   event OwnershipRenounced(address indexed previousOwner);
16   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) public onlyOwner {
40     require(newOwner != address(0));
41     emit OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45   /**
46    * @dev Allows the current owner to relinquish control of the contract.
47    */
48   function renounceOwnership() public onlyOwner {
49     emit OwnershipRenounced(owner);
50     owner = address(0);
51   }
52 }
53 
54 
55 
56 
57 
58 
59 /**
60  * @title ERC20Basic
61  * @dev Simpler version of ERC20 interface
62  * @dev see https://github.com/ethereum/EIPs/issues/179
63  */
64 contract ERC20Basic {
65   function totalSupply() public view returns (uint256);
66   function balanceOf(address who) public view returns (uint256);
67   function transfer(address to, uint256 value) public returns (bool);
68   event Transfer(address indexed from, address indexed to, uint256 value);
69 }
70 
71 
72 /**
73  * @title SafeMath
74  * @dev Math operations with safety checks that throw on error
75  */
76 library SafeMath {
77 
78   /**
79   * @dev Multiplies two numbers, throws on overflow.
80   */
81   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
82     if (a == 0) {
83       return 0;
84     }
85     c = a * b;
86     assert(c / a == b);
87     return c;
88   }
89 
90   /**
91   * @dev Integer division of two numbers, truncating the quotient.
92   */
93   function div(uint256 a, uint256 b) internal pure returns (uint256) {
94     // assert(b > 0); // Solidity automatically throws when dividing by 0
95     // uint256 c = a / b;
96     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
97     return a / b;
98   }
99 
100   /**
101   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
102   */
103   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
104     assert(b <= a);
105     return a - b;
106   }
107 
108   /**
109   * @dev Adds two numbers, throws on overflow.
110   */
111   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
112     c = a + b;
113     assert(c >= a);
114     return c;
115   }
116 }
117 
118 
119 /**
120  * @title Basic token
121  * @dev Basic version of StandardToken, with no allowances.
122  */
123 contract BasicToken is ERC20Basic {
124   using SafeMath for uint256;
125 
126   mapping(address => uint256) balances;
127 
128   uint256 totalSupply_;
129 
130   /**
131   * @dev total number of tokens in existence
132   */
133   function totalSupply() public view returns (uint256) {
134     return totalSupply_;
135   }
136 
137   /**
138   * @dev transfer token for a specified address
139   * @param _to The address to transfer to.
140   * @param _value The amount to be transferred.
141   */
142   function transfer(address _to, uint256 _value) public returns (bool) {
143     require(_to != address(0));
144     require(_value <= balances[msg.sender]);
145 
146     balances[msg.sender] = balances[msg.sender].sub(_value);
147     balances[_to] = balances[_to].add(_value);
148     emit Transfer(msg.sender, _to, _value);
149     return true;
150   }
151 
152   /**
153   * @dev Gets the balance of the specified address.
154   * @param _owner The address to query the the balance of.
155   * @return An uint256 representing the amount owned by the passed address.
156   */
157   function balanceOf(address _owner) public view returns (uint256) {
158     return balances[_owner];
159   }
160 
161 }
162 
163 
164 
165 /**
166  * @title ERC20 interface
167  * @dev see https://github.com/ethereum/EIPs/issues/20
168  */
169 contract ERC20 is ERC20Basic {
170   function allowance(address owner, address spender) public view returns (uint256);
171   function transferFrom(address from, address to, uint256 value) public returns (bool);
172   function approve(address spender, uint256 value) public returns (bool);
173   event Approval(address indexed owner, address indexed spender, uint256 value);
174 }
175 
176 
177 /**
178  * @title Standard ERC20 token
179  *
180  * @dev Implementation of the basic standard token.
181  * @dev https://github.com/ethereum/EIPs/issues/20
182  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
183  */
184 contract StandardToken is ERC20, BasicToken {
185 
186   mapping (address => mapping (address => uint256)) internal allowed;
187 
188 
189   /**
190    * @dev Transfer tokens from one address to another
191    * @param _from address The address which you want to send tokens from
192    * @param _to address The address which you want to transfer to
193    * @param _value uint256 the amount of tokens to be transferred
194    */
195   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
196     require(_to != address(0));
197     require(_value <= balances[_from]);
198     require(_value <= allowed[_from][msg.sender]);
199 
200     balances[_from] = balances[_from].sub(_value);
201     balances[_to] = balances[_to].add(_value);
202     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
203     emit Transfer(_from, _to, _value);
204     return true;
205   }
206 
207   /**
208    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
209    *
210    * Beware that changing an allowance with this method brings the risk that someone may use both the old
211    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
212    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
213    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
214    * @param _spender The address which will spend the funds.
215    * @param _value The amount of tokens to be spent.
216    */
217   function approve(address _spender, uint256 _value) public returns (bool) {
218     allowed[msg.sender][_spender] = _value;
219     emit Approval(msg.sender, _spender, _value);
220     return true;
221   }
222 
223   /**
224    * @dev Function to check the amount of tokens that an owner allowed to a spender.
225    * @param _owner address The address which owns the funds.
226    * @param _spender address The address which will spend the funds.
227    * @return A uint256 specifying the amount of tokens still available for the spender.
228    */
229   function allowance(address _owner, address _spender) public view returns (uint256) {
230     return allowed[_owner][_spender];
231   }
232 
233   /**
234    * @dev Increase the amount of tokens that an owner allowed to a spender.
235    *
236    * approve should be called when allowed[_spender] == 0. To increment
237    * allowed value is better to use this function to avoid 2 calls (and wait until
238    * the first transaction is mined)
239    * From MonolithDAO Token.sol
240    * @param _spender The address which will spend the funds.
241    * @param _addedValue The amount of tokens to increase the allowance by.
242    */
243   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
244     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
245     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
246     return true;
247   }
248 
249   /**
250    * @dev Decrease the amount of tokens that an owner allowed to a spender.
251    *
252    * approve should be called when allowed[_spender] == 0. To decrement
253    * allowed value is better to use this function to avoid 2 calls (and wait until
254    * the first transaction is mined)
255    * From MonolithDAO Token.sol
256    * @param _spender The address which will spend the funds.
257    * @param _subtractedValue The amount of tokens to decrease the allowance by.
258    */
259   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
260     uint oldValue = allowed[msg.sender][_spender];
261     if (_subtractedValue > oldValue) {
262       allowed[msg.sender][_spender] = 0;
263     } else {
264       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
265     }
266     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
267     return true;
268   }
269 
270 }
271 
272 
273 /**
274  * @title Mintable token
275  * @dev Simple ERC20 Token example, with mintable token creation
276  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
277  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
278  */
279 contract MintableToken is StandardToken, Ownable {
280   event Mint(address indexed to, uint256 amount);
281   event MintFinished();
282 
283   bool public mintingFinished = false;
284 
285 
286   modifier canMint() {
287     require(!mintingFinished);
288     _;
289   }
290 
291   modifier hasMintPermission() {
292     require(msg.sender == owner);
293     _;
294   }
295 
296   /**
297    * @dev Function to mint tokens
298    * @param _to The address that will receive the minted tokens.
299    * @param _amount The amount of tokens to mint.
300    * @return A boolean that indicates if the operation was successful.
301    */
302   function mint(address _to, uint256 _amount) hasMintPermission canMint public returns (bool) {
303     totalSupply_ = totalSupply_.add(_amount);
304     balances[_to] = balances[_to].add(_amount);
305     emit Mint(_to, _amount);
306     emit Transfer(address(0), _to, _amount);
307     return true;
308   }
309 
310   /**
311    * @dev Function to stop minting new tokens.
312    * @return True if the operation was successful.
313    */
314   function finishMinting() onlyOwner canMint public returns (bool) {
315     mintingFinished = true;
316     emit MintFinished();
317     return true;
318   }
319 }
320 
321 
322 /**
323  * @title ContractableToken
324  * @dev The Ownable contract has an ownerncontract address, and provides basic authorization control
325  * functions, this simplifies the implementation of "user permissions".
326  */
327 contract OptionsToken is StandardToken, Ownable {
328     using SafeMath for uint256;
329     bool revertable = true;
330     mapping (address => uint256) public optionsOwner;
331     
332     modifier hasOptionPermision() {
333         require(msg.sender == owner);
334         _;
335     }  
336 
337     function storeOptions(address recipient, uint256 amount) public hasOptionPermision() {
338         optionsOwner[recipient] += amount;
339     }
340 
341     function refundOptions(address discharged) public onlyOwner() returns (bool) {
342         require(revertable);
343         require(optionsOwner[discharged] > 0);
344         require(optionsOwner[discharged] <= balances[discharged]);
345 
346         uint256 revertTokens = optionsOwner[discharged];
347         optionsOwner[discharged] = 0;
348 
349         balances[discharged] = balances[discharged].sub(revertTokens);
350         balances[owner] = balances[owner].add(revertTokens);
351         emit Transfer(discharged, owner, revertTokens);
352         return true;
353     }
354 
355     function doneOptions() public onlyOwner() {
356         require(revertable);
357         revertable = false;
358     }
359 }
360 
361 
362 
363 /**
364  * @title ContractableToken
365  * @dev The Contractable contract has an ownerncontract address, and provides basic authorization control
366  * functions, this simplifies the implementation of "user permissions".
367  */
368 contract ContractableToken is MintableToken, OptionsToken {
369     address[5] public contract_addr;
370     uint8 public contract_num = 0;
371 
372     function existsContract(address sender) public view returns(bool) {
373         bool found = false;
374         for (uint8 i = 0; i < contract_num; i++) {
375             if (sender == contract_addr[i]) {
376                 found = true;
377             }
378         }
379         return found;
380     }
381 
382     modifier onlyContract() {
383         require(existsContract(msg.sender));
384         _;
385     }
386 
387     modifier hasMintPermission() {
388         require(existsContract(msg.sender));
389         _;
390     }
391     
392     modifier hasOptionPermision() {
393         require(existsContract(msg.sender));
394         _;
395     }  
396   
397     event ContractRenounced();
398     event ContractTransferred(address indexed newContract);
399   
400     /**
401      * @dev Allows the current owner to transfer control of the contract to a newContract.
402      * @param newContract The address to transfer ownership to.
403      */
404     function setContract(address newContract) public onlyOwner() {
405         require(newContract != address(0));
406         contract_num++;
407         require(contract_num <= 5);
408         emit ContractTransferred(newContract);
409         contract_addr[contract_num-1] = newContract;
410     }
411   
412     function renounceContract() public onlyOwner() {
413         emit ContractRenounced();
414         contract_num = 0;
415     }
416   
417 }
418 
419 
420 
421 /**
422  * @title FTIToken
423  * @dev Very simple ERC20 Token that can be minted.
424  * It is meant to be used in a crowdsale contract.
425  */
426 contract FTIToken is ContractableToken {
427 
428     string public constant name = "GlobalCarService Token";
429     string public constant symbol = "FTI";
430     uint8 public constant decimals = 18;
431 
432     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
433         require(msg.sender == owner || mintingFinished);
434         super.transferFrom(_from, _to, _value);
435         return true;
436     }
437   
438     function transfer(address _to, uint256 _value) public returns (bool) {
439         require(msg.sender == owner || mintingFinished);
440         super.transfer(_to, _value);
441         return true;
442     }
443 }