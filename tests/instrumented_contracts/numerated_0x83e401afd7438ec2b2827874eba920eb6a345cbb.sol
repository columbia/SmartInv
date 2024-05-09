1 pragma solidity >=0.5.0 <0.7.0;
2 
3 /*
4                                               N     .N      
5                                             .ONN.   NN      
6                                           ..NNDN  :NNNN     
7                                          .8NN  NNNN. NN     
8                                         NNN. .NNN....NN     
9                                     ..NNN ~NNNO     .N:     
10                                  .,NNNDNNNN?.       NN      
11                     ..?NNNNNNNNNNNNNNND..          NN       
12                ..$NNNNN$.    .=NNN=             ..NN        
13              .NNNN,         .NNON               NNN         
14            NNN+.           NN~.NN           ..NNN           
15          NNN..            NN.  ON          .NNN             
16       .:NN.              ,N=    NN.    .,NNNN               
17       NNI.              .NN     .NNNNNNNN$.,N?              
18     ,NN.                .NI     .NNN,.   .  NN.             
19     NN .                ?N.       ?NNNNNN... NN             
20     NN.                 NN=       ..NN .NNNN NN             
21      NN                 NNN.         NN..NN.  NN            
22      IN.                NNN.          :NNN=   :N,           
23       NN.               N$NN..         .NN.   .NN           
24       .NN.              N7 NN .               .NNI          
25         NN.             NO  DNN  .          .ZNNNN.         
26         .NN             NN .  NNN:..     ..NNN. .NN         
27          .NN.           NN .  . INNNNNNNNNNNN:. .ZN         
28            NNI.         NN       . NNNN+   .ONNN8 NN        
29              NN.        .N.     .NN, $NN?   . .INNN         
30               NN?       .NN    NNO     :NNNNNNNN+           
31                ~NN      .NN   NN,                           
32                 .NNN.     NI..NI.                           
33                    NNN    NN.NN                             
34                     .NND.. NNNI                             
35                        NNN.$NN.                             
36                          ONNNN?                             
37                             NNN                             
38 
39    ,        ,     II   N        NN     OOOOOO       SSSS    
40    M        M     II   NN       NN   OOOOOOOOOO    SSSSSSS  
41    MM      MM     II   NNN      NN  OOO      OOO  SS     SS   
42    MMM    MMM     II   NNNN     NN OO?        OO  SS        
43   MM~MM  MMMMM    II   NN NNN   NN OO         OO$  SSSSSS   
44   MM MM  MM MM    II   NN  NNN  NN OO         OO=     SSSS  
45   MM  MMMM  MM    II   NN   NNN:NN .OOO      OOO        SS  
46  MM    MM    MM   II   NN    NNNNN  =OOO    OOO   SS    SS  
47  MM    MM    MM   II   NN     NNNN    OOOOOOO      SSSSSS   
48 */
49 
50 /**
51  * @title SafeMath
52  * @dev Math operations with safety checks that revert on error
53  */
54 library SafeMath {
55 
56   /**
57   * @dev Multiplies two numbers, reverts on overflow.
58   */
59   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
60     if (a == 0) {
61       return 0;
62     }
63 
64     uint256 c = a * b;
65     require(c / a == b);
66 
67     return c;
68   }
69 
70   /**
71   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
72   */
73   function div(uint256 a, uint256 b) internal pure returns (uint256) {
74     require(b > 0); // Solidity only automatically asserts when dividing by 0
75     uint256 c = a / b;
76 
77     return c;
78   }
79 
80   /**
81   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
82   */
83   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
84     require(b <= a);
85     uint256 c = a - b;
86 
87     return c;
88   }
89 
90   /**
91   * @dev Adds two numbers, reverts on overflow.
92   */
93   function add(uint256 a, uint256 b) internal pure returns (uint256) {
94     uint256 c = a + b;
95     require(c >= a);
96 
97     return c;
98   }
99 
100   /**
101   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
102   * reverts when dividing by zero.
103   */
104   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
105     require(b != 0);
106     return a % b;
107   }
108 }
109 
110 /**
111  * @title Ownable
112  * @dev The Ownable contract has an owner address, and provides basic authorization control
113  * functions, this simplifies the implementation of "user permissions".
114  */
115 contract Ownable {
116   address private _owner;
117 
118   /**
119    * Event that notifies clients about the ownership transference
120    * @param previousOwner Address registered as the former owner
121    * @param newOwner Address that is registered as the new owner
122    */
123   event OwnershipTransferred(
124     address indexed previousOwner,
125     address indexed newOwner
126   );
127 
128   /**
129    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
130    * account.
131    */
132   constructor() internal {
133     _owner = msg.sender;
134     emit OwnershipTransferred(address(0), _owner);
135   }
136 
137   /**
138    * @return the address of the owner.
139    */
140   function owner() public view returns(address) {
141     return _owner;
142   }
143 
144   /**
145    * @dev Throws if called by any account other than the owner.
146    */
147   modifier onlyOwner() {
148     require(isOwner(), "Ownable: Caller is not the owner");
149     _;
150   }
151 
152   /**
153    * @return true if `msg.sender` is the owner of the contract.
154    */
155   function isOwner() public view returns(bool) {
156     return msg.sender == _owner;
157   }
158 
159   /**
160    * @dev Allows the current owner to transfer control of the contract to a newOwner.
161    * @param newOwner The address to transfer ownership to.
162    */
163   function transferOwnership(address newOwner) public onlyOwner {
164     require(newOwner != address(0), "Ownable: New owner is the zero address");
165     emit OwnershipTransferred(_owner, newOwner);
166     _owner = newOwner;
167   }
168 }
169 
170 /**
171  * @title ERC20 interface
172  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
173  */
174 interface IERC20 {
175 
176   function balanceOf(address account) external view returns (uint256);
177  
178   function transfer(address to, uint256 value) external returns (bool);
179 
180   function transferFrom(address from, address to, uint256 value)
181     external returns (bool);
182 
183   function approve(address spender, uint256 value)
184     external returns (bool);
185 
186   function allowance(address owner, address spender)
187     external view returns (uint256);
188 
189   /**
190    * Event that notifies clients about the amount transferred
191    * @param from Address owner of the transferred funds
192    * @param to Destination address
193    * @param value Amount of tokens transferred
194    */
195   event Transfer(
196     address indexed from,
197     address indexed to,
198     uint256 value
199   );
200 
201   /**
202    * Event that notifies clients about the amount approved to be spent
203    * @param owner Address owner of the approved funds
204    * @param spender The address authorized to spend the funds
205    * @param value Amount of tokens approved
206    */
207   event Approval(
208     address indexed owner,
209     address indexed spender,
210     uint256 value
211   );
212 }
213 
214 /**
215  * @title ERC20
216  * @dev Implements the functions declared in the IERC20 interface
217  */
218 contract ERC20 is IERC20 {
219   using SafeMath for uint256;
220 
221   mapping (address => uint256) internal balances;
222   mapping (address => mapping (address => uint256)) internal allowed;
223 
224   uint256 public totalSupply;
225   
226   constructor(uint256 initialSupply) internal {
227     require(msg.sender != address(0));
228     totalSupply = initialSupply;
229     balances[msg.sender] = initialSupply;
230     emit Transfer(address(0), msg.sender, initialSupply);
231   }
232 
233   /**
234    * @dev Gets the balance of the specified address.
235    * @param account The address to query the balance of.
236    * @return An uint256 representing the amount owned by the passed address.
237    */
238   function balanceOf(address account) external view returns (uint256) {
239     return balances[account];
240   }
241 
242   /**
243    * @dev Transfer token for a specified address
244    * @param to The address to transfer to.
245    * @param value The amount to be transferred.
246    */
247   function transfer(address to, uint256 value) public returns (bool) {
248     require(value <= balances[msg.sender]);
249     require(to != address(0));
250 
251     balances[msg.sender] = balances[msg.sender].sub(value);
252     balances[to] = balances[to].add(value);
253     emit Transfer(msg.sender, to, value);
254     return true;
255   }
256 
257   /**
258    * @dev Transfer tokens from one address to another
259    * @param from address The address which you want to send tokens from
260    * @param to address The address which you want to transfer to
261    * @param value uint256 the amount of tokens to be transferred
262    */
263   function transferFrom(
264     address from,
265     address to,
266     uint256 value
267   )
268     public
269     returns (bool)
270   {
271     require(value <= balances[from]);
272     require(value <= allowed[from][msg.sender]);
273     require(to != address(0));
274 
275     balances[from] = balances[from].sub(value);
276     balances[to] = balances[to].add(value);
277     allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
278     emit Transfer(from, to, value);
279     return true;
280   }
281 
282   /**
283    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
284    * Beware that changing an allowance with this method brings the risk that someone may use both the old
285    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
286    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
287    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
288    * @param spender The address which will spend the funds.
289    * @param value The amount of tokens to be spent.
290    */
291   function approve(address spender, uint256 value) public returns (bool) {
292     require(spender != address(0));
293 
294     allowed[msg.sender][spender] = value;
295     emit Approval(msg.sender, spender, value);
296     return true;
297   }
298 
299   /**
300    * @dev Function to check the amount of tokens that an owner allowed to a spender.
301    * @param owner address The address which owns the funds.
302    * @param spender address The address which will spend the funds.
303    * @return A uint256 specifying the amount of tokens still available for the spender.
304    */
305   function allowance(
306     address owner,
307     address spender
308    )
309     external
310     view
311     returns (uint256)
312   {
313     return allowed[owner][spender];
314   }
315 
316   /**
317    * @dev Increase the amount of tokens that an owner allowed to a spender.
318    * approve should be called when allowed[spender] == 0. To increment
319    * allowed value is better to use this function to avoid 2 calls (and wait until
320    * the first transaction is mined)
321    * From MonolithDAO Token.sol
322    * @param spender The address which will spend the funds.
323    * @param addedValue The amount of tokens to increase the allowance by.
324    */
325   function increaseAllowance(
326     address spender,
327     uint256 addedValue
328   )
329     public
330     returns (bool)
331   {
332     require(spender != address(0));
333 
334     allowed[msg.sender][spender] = (
335       allowed[msg.sender][spender].add(addedValue));
336     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
337     return true;
338   }
339 
340   /**
341    * @dev Decrease the amount of tokens that an owner allowed to a spender.
342    * approve should be called when allowed[spender] == 0. To decrement
343    * allowed value is better to use this function to avoid 2 calls (and wait until
344    * the first transaction is mined)
345    * From MonolithDAO Token.sol
346    * @param spender The address which will spend the funds.
347    * @param subtractedValue The amount of tokens to decrease the allowance by.
348    */
349   function decreaseAllowance(
350     address spender,
351     uint256 subtractedValue
352   )
353     public
354     returns (bool)
355   {
356     require(spender != address(0));
357 
358     allowed[msg.sender][spender] = (
359       allowed[msg.sender][spender].sub(subtractedValue));
360     emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
361     return true;
362   }
363 }
364 
365 /**
366  * @title Burnable Token
367  * @dev Token that can be irreversibly burned (destroyed).
368  */
369 contract Burnable is ERC20 {
370 
371   /**
372    * Event that notifies clients about the amount burnt
373    * @param from Address owner of the burnt funds
374    * @param value Amount of tokens burnt
375    */
376   event Burn(
377     address indexed from,
378     uint256 value
379   );
380   
381   /**
382    * @dev Burns a specific amount of tokens.
383    * @param value The amount of token to be burned.
384    */
385   function burn(uint256 value) public {
386     _burn(msg.sender, value);
387   }
388 
389   /**
390    * @dev Burns a specific amount of tokens from the target address and decrements allowance
391    * @param from address The address which you want to send tokens from
392    * @param value uint256 The amount of token to be burned
393    */
394   function burnFrom(address from, uint256 value) public {
395     require(value <= allowed[from][msg.sender], "Burnable: Amount to be burnt exceeds the account balance");
396 
397     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
398     // this function needs to emit an event with the updated approval.
399     allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
400     _burn(from, value);
401   }
402 
403   /**
404    * @dev Internal function that burns an amount of the token of a given
405    * account.
406    * @param account The account whose tokens will be burnt.
407    * @param amount The amount that will be burnt.
408    */
409   function _burn(address account, uint256 amount) internal {
410     require(account != address(0), "Burnable: Burn from the zero address");
411     require(amount > 0, "Burnable: Can not burn negative amount");
412     require(amount <= balances[account], "Burnable: Amount to be burnt exceeds the account balance");
413 
414     totalSupply = totalSupply.sub(amount);
415     balances[account] = balances[account].sub(amount);
416     emit Burn(account, amount);
417   }
418 }
419 
420 /**
421  * @title Freezable Token
422  * @dev Token that can be frozen.
423  */
424 contract Freezable is ERC20 {
425 
426   mapping (address => uint256) private _freeze;
427 
428   /**
429    * Event that notifies clients about the amount frozen
430    * @param from Address owner of the frozen funds
431    * @param value Amount of tokens frozen
432    */
433   event Freeze(
434     address indexed from,
435     uint256 value
436   );
437 
438   /**
439    * Event that notifies clients about the amount unfrozen
440    * @param from Address owner of the unfrozen funds
441    * @param value Amount of tokens unfrozen
442    */
443   event Unfreeze(
444     address indexed from,
445     uint256 value
446   );
447 
448   /**
449    * @dev Gets the frozen balance of the specified address.
450    * @param account The address to query the frozen balance of.
451    * @return An uint256 representing the amount frozen by the passed address.
452    */
453   function freezeOf(address account) public view returns (uint256) {
454     return _freeze[account];
455   }
456 
457   /**
458    * @dev Freezes a specific amount of tokens
459    * @param amount uint256 The amount of token to be frozen
460    */
461   function freeze(uint256 amount) public {
462     require(balances[msg.sender] >= amount, "Freezable: Amount to be frozen exceeds the account balance");
463     require(amount > 0, "Freezable: Can not freeze negative amount");
464     balances[msg.sender] = balances[msg.sender].sub(amount);
465     _freeze[msg.sender] = _freeze[msg.sender].add(amount);
466     emit Freeze(msg.sender, amount);
467   }
468 
469   /**
470    * @dev Unfreezes a specific amount of tokens
471    * @param amount uint256 The amount of token to be unfrozen
472    */
473   function unfreeze(uint256 amount) public {
474     require(_freeze[msg.sender] >= amount, "Freezable: Amount to be unfrozen exceeds the account balance");
475     require(amount > 0, "Freezable: Can not unfreeze negative amount");
476     _freeze[msg.sender] = _freeze[msg.sender].sub(amount);
477     balances[msg.sender] = balances[msg.sender].add(amount);
478     emit Unfreeze(msg.sender, amount);
479   }
480 }
481 
482 /**
483  * @title MinosCoin 
484  * @dev Contract for MinosCoin token
485  **/
486 contract MinosCoin is ERC20, Burnable, Freezable, Ownable {
487 
488   string public constant name = "MinosCoin";
489   string public constant symbol = "MNS";
490   uint8 public constant decimals = 18;
491 
492   // Initial supply is the balance assigned to the owner
493   uint256 private constant _initialSupply = 300000000 * (10 ** uint256(decimals));
494 
495   /**
496    * @dev Constructor
497    */
498   constructor() 
499     public 
500     ERC20(_initialSupply)
501   {
502     require(msg.sender != address(0), "MinosCoin: Create contract from the zero address");
503   }
504   
505   /**
506    * @dev Allows to transfer out the ether balance that was sent into this contract
507    */
508   function withdrawEther() public onlyOwner {
509     uint256 totalBalance = address(this).balance;
510     require(totalBalance > 0, "MinosCoin: No ether available to be withdrawn");
511     msg.sender.transfer(totalBalance);
512   }
513 }