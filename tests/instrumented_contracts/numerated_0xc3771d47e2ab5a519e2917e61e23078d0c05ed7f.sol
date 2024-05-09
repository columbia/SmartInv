1 pragma solidity ^0.4.26;
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
50 // File: contracts/Ownable.sol
51 
52 pragma solidity ^0.4.26;
53 
54 
55 /**
56  * @title Ownable
57  * @dev The Ownable contract has an owner address, and provides basic authorization control
58  * functions, this simplifies the implementation of "user permissions".
59  */
60 contract Ownable {
61   address public owner;
62 
63 
64   event OwnershipRenounced(address indexed previousOwner);
65   event OwnershipTransferred(
66     address indexed previousOwner,
67     address indexed newOwner
68   );
69 
70 
71   /**
72    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
73    * account.
74    */
75   constructor() public {
76     owner = msg.sender;
77   }
78 
79   /**
80    * @dev Throws if called by any account other than the owner.
81    */
82   modifier onlyOwner() {
83     require(msg.sender == owner);
84     _;
85   }
86 
87   /**
88    * @dev Allows the current owner to transfer control of the contract to a newOwner.
89    * @param newOwner The address to transfer ownership to.
90    */
91   function transferOwnership(address newOwner) public onlyOwner {
92     require(newOwner != address(0));
93     emit OwnershipTransferred(owner, newOwner);
94     owner = newOwner;
95   }
96 
97 }
98 
99 // File: contracts/Gather_coin.sol
100 
101 pragma solidity ^0.4.26;
102 
103 
104 
105 
106 /**
107  * @title ERC20Basic
108  * @dev Simpler version of ERC20 interface
109  * @dev see https://github.com/ethereum/EIPs/issues/179
110  */
111 contract ERC20Basic {
112   function totalSupply() public view returns (uint256);
113   function balanceOf(address who) public view returns (uint256);
114   function transfer(address to, uint256 value) public returns (bool);
115   event Transfer(address indexed from, address indexed to, uint256 value);
116 }
117 
118 /**
119  * @title ERC20 interface
120  * @dev see https://github.com/ethereum/EIPs/issues/20
121  */
122 contract ERC20 is ERC20Basic {
123   function allowance(address owner, address spender)
124     public view returns (uint256);
125 
126   function transferFrom(address from, address to, uint256 value)
127     public returns (bool);
128 
129   function approve(address spender, uint256 value) public returns (bool);
130   event Approval(
131     address indexed owner,
132     address indexed spender,
133     uint256 value
134   );
135 }
136 
137 /**
138  * @title Basic token
139  * @dev Basic version of StandardToken, with no allowances.
140  */
141 contract BasicToken is ERC20Basic {
142   using SafeMath for uint256;
143 
144   mapping(address => uint256) balances;
145 
146   uint256 totalSupply_;
147 
148   /**
149   * @dev total number of tokens in existence
150   */
151   function totalSupply() public view returns (uint256) {
152     return totalSupply_;
153   }
154 
155   /**
156   * @dev transfer token for a specified address
157   * @param _to The address to transfer to.
158   * @param _value The amount to be transferred.
159   */
160   function transfer(address _to, uint256 _value) public returns (bool) {
161     require(_to != address(0));
162     require(_value <= balances[msg.sender]);
163 
164     balances[msg.sender] = balances[msg.sender].sub(_value);
165     balances[_to] = balances[_to].add(_value);
166     emit Transfer(msg.sender, _to, _value);
167     return true;
168   }
169 
170   /**
171   * @dev Gets the balance of the specified address.
172   * @param _owner The address to query the the balance of.
173   * @return An uint256 representing the amount owned by the passed address.
174   */
175   function balanceOf(address _owner) public view returns (uint256) {
176     return balances[_owner];
177   }
178 
179 }
180 
181 /**
182  * @title Standard ERC20 token
183  *
184  * @dev Implementation of the basic standard token.
185  * @dev https://github.com/ethereum/EIPs/issues/20
186  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
187  */
188 contract StandardToken is ERC20, BasicToken {
189 
190   mapping (address => mapping (address => uint256)) internal allowed;
191 
192 
193   /**
194    * @dev Transfer tokens from one address to another
195    * @param _from address The address which you want to send tokens from
196    * @param _to address The address which you want to transfer to
197    * @param _value uint256 the amount of tokens to be transferred
198    */
199   function transferFrom(
200     address _from,
201     address _to,
202     uint256 _value
203   )
204     public
205     returns (bool)
206   {
207     require(_to != address(0));
208     require(_value <= balances[_from]);
209     require(_value <= allowed[_from][msg.sender]);
210 
211     balances[_from] = balances[_from].sub(_value);
212     balances[_to] = balances[_to].add(_value);
213     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
214     emit Transfer(_from, _to, _value);
215     return true;
216   }
217 
218   /**
219    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
220    *
221    * Beware that changing an allowance with this method brings the risk that someone may use both the old
222    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
223    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
224    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
225    * @param _spender The address which will spend the funds.
226    * @param _value The amount of tokens to be spent.
227    */
228   function approve(address _spender, uint256 _value) public returns (bool) {
229     allowed[msg.sender][_spender] = _value;
230     emit Approval(msg.sender, _spender, _value);
231     return true;
232   }
233 
234   /**
235    * @dev Function to check the amount of tokens that an owner allowed to a spender.
236    * @param _owner address The address which owns the funds.
237    * @param _spender address The address which will spend the funds.
238    * @return A uint256 specifying the amount of tokens still available for the spender.
239    */
240   function allowance(
241     address _owner,
242     address _spender
243    )
244     public
245     view
246     returns (uint256)
247   {
248     return allowed[_owner][_spender];
249   }
250 
251   /**
252    * @dev Increase the amount of tokens that an owner allowed to a spender.
253    *
254    * approve should be called when allowed[_spender] == 0. To increment
255    * allowed value is better to use this function to avoid 2 calls (and wait until
256    * the first transaction is mined)
257    * From MonolithDAO Token.sol
258    * @param _spender The address which will spend the funds.
259    * @param _addedValue The amount of tokens to increase the allowance by.
260    */
261   function increaseApproval(
262     address _spender,
263     uint _addedValue
264   )
265     public
266     returns (bool)
267   {
268     allowed[msg.sender][_spender] = (
269       allowed[msg.sender][_spender].add(_addedValue));
270     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
271     return true;
272   }
273 
274   /**
275    * @dev Decrease the amount of tokens that an owner allowed to a spender.
276    *
277    * approve should be called when allowed[_spender] == 0. To decrement
278    * allowed value is better to use this function to avoid 2 calls (and wait until
279    * the first transaction is mined)
280    * From MonolithDAO Token.sol
281    * @param _spender The address which will spend the funds.
282    * @param _subtractedValue The amount of tokens to decrease the allowance by.
283    */
284   function decreaseApproval(
285     address _spender,
286     uint _subtractedValue
287   )
288     public
289     returns (bool)
290   {
291     uint oldValue = allowed[msg.sender][_spender];
292     if (_subtractedValue > oldValue) {
293       allowed[msg.sender][_spender] = 0;
294     } else {
295       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
296     }
297     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
298     return true;
299   }
300 
301 }
302 
303 
304  /**
305  * @title Mintable token
306  * @dev Simple ERC20 Token example, with mintable token creation
307  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
308  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
309  */
310 contract MintableToken is StandardToken, Ownable {
311   event Mint(address indexed to, uint256 amount);
312   event Mintai(address indexed owner, address indexed msgSender, uint256 msgSenderBalance, uint256 amount);
313   event MintFinished();
314 
315   bool public mintingFinished = false;
316 
317   mapping(address=>uint256) mintPermissions;
318 
319   uint256 public maxMintLimit;
320 
321 
322   modifier canMint() {
323     require(!mintingFinished);
324     _;
325   }
326 
327   modifier hasMintPermission() {
328     require(checkMintPermission(msg.sender));
329     _;
330   }
331 
332   function checkMintPermission(address _minter) private view returns (bool) {
333     if (_minter == owner) {
334       return true;
335     }
336 
337     return mintPermissions[_minter] > 0;
338 
339   }
340 
341   function setMinter(address _minter, uint256 _amount) public onlyOwner {
342     require(_minter != owner);
343     mintPermissions[_minter] = _amount;
344   }
345 
346   /**
347    * @dev Function to mint tokens. Delegates minting to internal function
348    * @param _to The address that will receive the minted tokens.
349    * @param _amount The amount of tokens to mint.
350    * @return A boolean that indicates if the operation was successful.
351    */
352   function mint(
353     address _to,
354     uint256 _amount
355   )
356     hasMintPermission
357     canMint
358     public
359     returns (bool)
360   {
361     return mintInternal(_to, _amount);
362   }
363 
364   /**
365    * @dev Function to mint tokens
366    * @param _to The address that will receive the minted tokens.
367    * @param _amount The amount of tokens to mint.
368    * @return A boolean that indicates if the operation was successful.
369    */
370   function mintInternal(address _to, uint256 _amount) internal returns (bool) {
371     if (msg.sender != owner) {
372       mintPermissions[msg.sender] = mintPermissions[msg.sender].sub(_amount);
373     }
374 
375     totalSupply_ = totalSupply_.add(_amount);
376     require(totalSupply_ <= maxMintLimit);
377 
378     balances[_to] = balances[_to].add(_amount);
379     emit Mint(_to, _amount);
380     emit Transfer(address(0), _to, _amount);
381     return true;
382   }
383 
384   function mintAllowed(address _minter) public view returns (uint256) {
385     return mintPermissions[_minter];
386   }
387 
388   /**
389    * @dev Function to stop minting new tokens.
390    * @return True if the operation was successful.
391    */
392   function finishMinting() public onlyOwner canMint returns (bool) {
393     mintingFinished = true;
394     emit MintFinished();
395     return true;
396   }
397 }
398 
399 
400 contract GatherToken is MintableToken {
401 
402   string public constant name = "Gather";
403   string public constant symbol = "GTH";
404   uint32 public constant decimals = 18;
405 
406   bool public transferPaused = true;
407 
408   constructor() public {
409     maxMintLimit = 400000000 * (10 ** uint(decimals));
410   }
411 
412   function unpauseTransfer() public onlyOwner {
413     transferPaused = false;
414   }
415 
416   function pauseTransfer() public onlyOwner {
417     transferPaused = true;
418   }
419 
420   // The modifier checks, if address can send tokens or not at current contract state.
421   modifier tranferable() {
422     require(!transferPaused, "Gath3r: Token transfer is pauses");
423     _;
424   }
425 
426   function transferFrom(address _from, address _to, uint256 _value) public tranferable returns (bool) {
427     return super.transferFrom(_from, _to, _value);
428   }
429 
430   function transfer(address _to, uint256 _value) public tranferable returns (bool) {
431     return super.transfer(_to, _value);
432   }
433 }