1 pragma solidity ^0.4.23;
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
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
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
62 
63 /**
64  * @title ERC20 interface
65  * @dev see https://github.com/ethereum/EIPs/issues/20
66  */
67 contract ERC20 is ERC20Basic {
68   function allowance(address owner, address spender) public view returns (uint256);
69   function transferFrom(address from, address to, uint256 value) public returns (bool);
70   function approve(address spender, uint256 value) public returns (bool);
71   event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 
74 
75 contract ERC223 is ERC20{
76     function transfer(address to, uint256 value, bytes data) public returns (bool);
77     event Transfer(address indexed from, address indexed to, uint256 value, bytes data);
78 }
79 
80 contract ReceivingContract { 
81 /**
82  * @dev Standard ERC223 function that will handle incoming token transfers.
83  *
84  * @param _from  Token sender address.
85  * @param _value Amount of tokens.
86  * @param _data  Transaction metadata.
87  */
88     function tokenFallback(address _from, uint _value, bytes _data) public;
89 }
90 
91 
92 
93 /**
94  * @title Basic token
95  * @dev Basic version of StandardToken, with no allowances.
96  */
97 contract BasicToken is ERC20Basic {
98   using SafeMath for uint256;
99 
100   mapping(address => uint256) balances;
101 
102   uint256 totalSupply_;
103 
104   /**
105   * @dev total number of tokens in existence
106   */
107   function totalSupply() public view returns (uint256) {
108     return totalSupply_;
109   }
110 
111 
112   /**
113   * @dev Gets the balance of the specified address.
114   * @param _owner The address to query the the balance of.
115   * @return An uint256 representing the amount owned by the passed address.
116   */
117   function balanceOf(address _owner) public view returns (uint256 balance) {
118     return balances[_owner];
119   }
120 
121 }
122 
123 
124 /**
125  * @title Standard ERC20 and ERC223 token
126  *
127  * @dev Implementation of the basic standard token.
128  * @dev https://github.com/ethereum/EIPs/issues/20  https://github.com/ethereum/EIPs/issues/223
129  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
130  */
131 contract StandardToken is ERC223, BasicToken {
132 
133     mapping (address => mapping (address => uint256)) internal allowed;
134     mapping (address => uint256) public frozenTimestamp; // 有限期时间内冻结的账户
135     address public admin; // admin owner
136 
137    /**
138     * @dev Contructor that gives msg.sender all of existing tokens. 
139     */
140     constructor() public {
141         //init tokens
142         admin = msg.sender;
143     }
144     
145     //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
146     function isContract(address _addr) public view returns (bool) {
147         if (_addr == address(0)) 
148             return false;
149         uint256 length;
150         assembly {
151             //retrieve the size of the code on target address, this needs assembly
152             length := extcodesize(_addr)
153         }
154         return (length>0);
155     }
156   
157     /**
158     * Standard function transfer similar to ERC20 ERC223 transfer with _data .
159     * Added due to backwards compatibility reasons .
160     * @dev transfer token for a user or another contract address  for ERC20 and ERC223
161     * @param _to The user address or contract address to transfer to.
162     * @param _value The amount to be transferred.
163     * @param _data The bytes date to be transferred
164     */
165     function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
166         if(isContract(_to)) {
167             return transferToContract(_to, _value, _data);
168         }
169         else {
170             return transferToAddress(_to, _value, _data);
171         }
172     }
173   
174     /**
175     * Standard function transfer similar to ERC20 ERC223 transfer with no _data .
176     * Added due to backwards compatibility reasons .
177     * @dev transfer token for a user or another contract address  for ERC20 and ERC223
178     * @param _to The user address or contract address to transfer to.
179     * @param _value The amount to be transferred.
180     */
181     function transfer(address _to, uint256 _value) public returns (bool) {
182         //standard function transfer similar to ERC20 transfer with no _data
183         //added due to backwards compatibility reasons
184         bytes memory empty;
185         if(isContract(_to)) {
186             return transferToContract(_to, _value, empty);
187         }
188         else {
189             return transferToAddress(_to, _value, empty);
190         }
191     }
192   
193     /**
194     * @dev Transfer tokens from one address to another
195     * @param _to address The address which you want to transfer to
196     * @param _value uint256 the amount of tokens to be transferred
197     * @param _data bytes The bytes to be transferred 
198     */
199     function transferToAddress(address _to, uint256 _value, bytes _data) private returns (bool){
200         require(block.timestamp > frozenTimestamp[msg.sender]);
201         require(_to != address(0));
202         require(_value <= balances[msg.sender]);
203 
204         // SafeMath.sub will throw if there is not enough balance.
205         balances[msg.sender] = balances[msg.sender].sub(_value);
206         balances[_to] = balances[_to].add(_value);
207         emit Transfer(msg.sender, _to, _value, _data);
208         return true;
209     }
210   
211     /**
212     * @dev Transfer tokens from one address to a contract
213     * @param _to address The address which you want to transfer to
214     * @param _value uint256 the amount of tokens to be transferred
215     * @param _data bytes The bytes to be transferred 
216     */
217     function transferToContract(address _to, uint _value, bytes _data) private returns (bool) {
218         require(block.timestamp > frozenTimestamp[msg.sender]);
219         require(_to != address(0));
220         require(_value <= balances[msg.sender]);
221         balances[msg.sender] = balances[msg.sender].sub(_value);
222         balances[_to] = balances[_to].add(_value);
223         ReceivingContract receiver = ReceivingContract(_to);
224         receiver.tokenFallback(msg.sender, _value, _data);
225         emit Transfer(msg.sender, _to, _value, _data);
226         return true;
227     }
228 
229     /**
230     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
231     *
232     * Beware that changing an allowance with this method brings the risk that someone may use both the old
233     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
234     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
235     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
236     * @param _spender The address which will spend the funds.
237     * @param _value The amount of tokens to be spent.
238     */
239     function approve(address _spender, uint256 _value) public returns (bool) {
240         allowed[msg.sender][_spender] = _value;
241         emit Approval(msg.sender, _spender, _value);
242         return true;
243     }
244 
245     /**
246     * @dev Function to check the amount of tokens that an owner allowed to a spender.
247     * @param _owner address The address which owns the funds.
248     * @param _spender address The address which will spend the funds.
249     * @return A uint256 specifying the amount of tokens still available for the spender.
250     */
251     function allowance(address _owner, address _spender) public view returns (uint256) {
252         return allowed[_owner][_spender];
253     }
254 
255     /**
256     * @dev Increase the amount of tokens that an owner allowed to a spender.
257     *
258     * approve should be called when allowed[_spender] == 0. To increment
259     * allowed value is better to use this function to avoid 2 calls (and wait until
260     * the first transaction is mined)
261     * From MonolithDAO Token.sol
262     * @param _spender The address which will spend the funds.
263     * @param _addedValue The amount of tokens to increase the allowance by.
264     */
265     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
266         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
267         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
268         return true;
269     }
270 
271     /**
272     * @dev Decrease the amount of tokens that an owner allowed to a spender.
273     *
274     * approve should be called when allowed[_spender] == 0. To decrement
275     * allowed value is better to use this function to avoid 2 calls (and wait until
276     * the first transaction is mined)
277     * From MonolithDAO Token.sol
278     * @param _spender The address which will spend the funds.
279     * @param _subtractedValue The amount of tokens to decrease the allowance by.
280     */
281     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
282         uint oldValue = allowed[msg.sender][_spender];
283         if (_subtractedValue > oldValue) {
284             allowed[msg.sender][_spender] = 0;
285         } else {
286             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
287         }
288         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
289         return true;
290     }
291   
292     /**
293     * 通过时间戳锁定账户
294     */
295     function freezeWithTimestamp( address _target, uint256 _timestamp) public returns (bool) {
296         require(msg.sender == admin);
297         require(_target != address(0));
298         frozenTimestamp[_target] = _timestamp;
299         return true;
300     }
301     
302     /**
303      * 批量通过时间戳锁定账户
304      */
305     function multiFreezeWithTimestamp(address[] _targets, uint256[] _timestamps) public returns (bool) {
306         require(msg.sender == admin);
307         require(_targets.length == _timestamps.length);
308         uint256 len = _targets.length;
309         require(len > 0);
310         for (uint256 i = 0; i < len; i = i.add(1)) {
311             address _target = _targets[i];
312             require(_target != address(0));
313             uint256 _timestamp = _timestamps[i];
314             frozenTimestamp[_target] = _timestamp;
315         }
316         return true;
317     }    
318     
319    /**
320     * 批量转账
321     */
322     function multiTransfer(address[] _tos, uint256[] _values) public returns (bool) {
323         require(block.timestamp > frozenTimestamp[msg.sender]);
324         require(_tos.length == _values.length);
325         uint256 len = _tos.length;
326         require(len > 0);
327         uint256 amount = 0;
328         for (uint256 i = 0; i < len; i = i.add(1)) {
329             amount = amount.add(_values[i]);
330         }
331         require(amount <= balances[msg.sender]);
332         for (uint256 j = 0; j < len; j = j.add(1)) {
333             address _to = _tos[j];
334             require(_to != address(0));
335             balances[_to] = balances[_to].add(_values[j]);
336             balances[msg.sender] = balances[msg.sender].sub(_values[j]);
337             emit Transfer(msg.sender, _to, _values[j]);
338         }
339         return true;
340     }
341     
342     //查询账户是否存在锁定时间戳
343     function getFrozenTimestamp(address _target) public view returns (uint256) {
344         require(_target != address(0));
345         return frozenTimestamp[_target];
346     }
347 
348  
349  
350    /**
351     * 从调用者作为from代理将from账户中的token转账至to
352     * 调用者在from的许可额度中必须>=value
353     * @dev Transfer tokens from one address to another
354     * @param _from address The address which you want to send tokens from
355     * @param _to address The address which you want to transfer to
356     * @param _value uint256 the amount of tokens to be transferred
357     */    
358     function transferFrom(address _from, address _to, uint256 _value) public returns (bool)
359     {
360         require(block.timestamp > frozenTimestamp[msg.sender]);
361         require(_to != address(0));
362         require(_value <= balances[_from]);
363         require(_value <= allowed[_from][msg.sender]);
364 
365         balances[_from] = balances[_from].sub(_value);
366         balances[_to] = balances[_to].add(_value);
367         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
368 
369         emit Transfer(_from, _to, _value);
370         return true;
371     }
372 
373     
374 
375 }
376 
377 /**
378  * @title Ownable
379  * @dev The Ownable contract has an owner address, and provides basic authorization control
380  * functions, this simplifies the implementation of "user permissions".
381  */
382 contract Ownable {
383   address public owner;
384 
385 
386   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
387 
388 
389   /**
390    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
391    * account.
392    */
393   constructor() public {
394     owner = msg.sender;
395   }
396 
397   /**
398    * @dev Throws if called by any account other than the owner.
399    */
400   modifier onlyOwner() {
401     require(msg.sender == owner);
402     _;
403   }
404 
405   /**
406    * @dev Allows the current owner to transfer control of the contract to a newOwner.
407    * @param newOwner The address to transfer ownership to.
408    */
409   function transferOwnership(address newOwner) public onlyOwner {
410     require(newOwner != address(0));
411     emit OwnershipTransferred(owner, newOwner);
412     owner = newOwner;
413   }
414 
415 }
416 
417 /**
418  * @title Mintable token
419  * @dev Simple ERC20 Token example, with mintable token creation
420  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
421  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
422  */
423 contract MintableToken is StandardToken, Ownable {
424   event Mint(address indexed to, uint256 amount);
425   event MintFinished();
426 
427   bool public mintingFinished = false;
428 
429 
430   modifier canMint() {
431     require(!mintingFinished);
432     _;
433   }
434 
435   modifier hasMintPermission() {
436     require(msg.sender == owner);
437     _;
438   }
439   
440   /**
441    * @dev Function to mint tokens
442    * @param _to The address that will receive the minted tokens.
443    * @param _amount The amount of tokens to mint.
444    * @return A boolean that indicates if the operation was successful.
445    */
446   function mint(address _to, uint256 _amount) hasMintPermission canMint public returns (bool) {
447     totalSupply_ = totalSupply_.add(_amount);
448     balances[_to] = balances[_to].add(_amount);
449     emit Mint(_to, _amount);
450     emit Transfer(address(0), _to, _amount);
451     return true;
452   }
453 
454   /**
455    * @dev Function to stop minting new tokens.
456    * @return True if the operation was successful.
457    */
458   function finishMinting() onlyOwner canMint public returns (bool) {
459     mintingFinished = true;
460     emit MintFinished();
461     return true;
462   }
463 }
464 
465 
466 /**
467  * @title vGameIO Token contract 
468  * @dev Implements Standard Token Interface for vGameIO token.
469  * @author Sunny
470  */
471 contract VGameToken is MintableToken {
472 
473     string public constant name = "VGame.io Token";
474     string public constant symbol = "VT";
475     uint256 public constant decimals = 8;
476 
477     uint256 public constant INITIAL_SUPPLY = 500000000 * (10 ** uint256(decimals));  //5亿是初始化来的,另5亿是用户自己挖出的(先分配到用户池再逐步挖出)
478 
479     
480    /**
481     * @dev Contructor that gives msg.sender all of existing tokens. 
482     */
483     // 构造函数
484     constructor() public {
485         //init tokens
486         totalSupply_ = INITIAL_SUPPLY; 
487         balances[msg.sender] = INITIAL_SUPPLY;
488         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
489         admin = msg.sender;
490     }
491 
492 }