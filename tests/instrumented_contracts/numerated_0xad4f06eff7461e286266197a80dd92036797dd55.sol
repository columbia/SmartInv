1 pragma solidity ^0.4.18;
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
46  * @title Pausable
47  * @dev Base contract which allows children to implement an emergency stop mechanism.
48  */
49 contract Pausable is Ownable {
50   event Pause();
51   event Unpause();
52 
53   bool public paused = false;
54 
55 
56   /**
57    * @dev Modifier to make a function callable only when the contract is not paused.
58    */
59   modifier whenNotPaused() {
60     require(!paused);
61     _;
62   }
63 
64   /**
65    * @dev Modifier to make a function callable only when the contract is paused.
66    */
67   modifier whenPaused() {
68     require(paused);
69     _;
70   }
71 
72   /**
73    * @dev called by the owner to pause, triggers stopped state
74    */
75   function pause() onlyOwner whenNotPaused public {
76     paused = true;
77     Pause();
78   }
79 
80   /**
81    * @dev called by the owner to unpause, returns to normal state
82    */
83   function unpause() onlyOwner whenPaused public {
84     paused = false;
85     Unpause();
86   }
87 }
88 
89 
90 /**
91  * @title SafeMath
92  * @dev Math operations with safety checks that throw on error
93  */
94 library SafeMath {
95   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
96     if (a == 0) {
97       return 0;
98     }
99     uint256 c = a * b;
100     assert(c / a == b);
101     return c;
102   }
103 
104   function div(uint256 a, uint256 b) internal pure returns (uint256) {
105     // assert(b > 0); // Solidity automatically throws when dividing by 0
106     uint256 c = a / b;
107     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
108     return c;
109   }
110 
111   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
112     assert(b <= a);
113     return a - b;
114   }
115 
116   function add(uint256 a, uint256 b) internal pure returns (uint256) {
117     uint256 c = a + b;
118     assert(c >= a);
119     return c;
120   }
121 }
122 
123 
124 /**
125  * @title ERC20Basic
126  * @dev Simpler version of ERC20 interface
127  * @dev see https://github.com/ethereum/EIPs/issues/179
128  */
129 contract ERC20Basic {
130   uint256 public totalSupply;
131   function balanceOf(address who) public constant returns (uint256);
132   function transfer(address to, uint256 value) public returns (bool);
133   event Transfer(address indexed from, address indexed to, uint256 value);
134 }
135 
136 /**
137  * @title ERC20 interface
138  * @dev see https://github.com/ethereum/EIPs/issues/20
139  */
140 contract ERC20 is ERC20Basic {
141   function allowance(address owner, address spender) public constant returns (uint256);
142   function transferFrom(address from, address to, uint256 value) public returns (bool);
143   function approve(address spender, uint256 value) public returns (bool);
144   event Approval(address indexed owner, address indexed spender, uint256 value);
145 }
146 
147 /**
148  * @title Basic token
149  * @dev Basic version of StandardToken, with no allowances.
150  */
151 contract BasicToken is ERC20Basic {
152   using SafeMath for uint256;
153 
154   mapping(address => uint256) balances;
155 
156   /**
157   * @dev transfer token for a specified address
158   * @param _to The address to transfer to.
159   * @param _value The amount to be transferred.
160   */
161   function transfer(address _to, uint256 _value) public returns (bool) {
162     require(_to != address(0));
163     require(_value <= balances[msg.sender]);
164 
165     // SafeMath.sub will throw if there is not enough balance.
166     balances[msg.sender] = balances[msg.sender].sub(_value);
167     balances[_to] = balances[_to].add(_value);
168     Transfer(msg.sender, _to, _value);
169     return true;
170   }
171 
172   /**
173   * @dev Gets the balance of the specified address.
174   * @param _owner The address to query the the balance of.
175   * @return An uint256 representing the amount owned by the passed address.
176   */
177   function balanceOf(address _owner) public constant returns (uint256 balance) {
178     return balances[_owner];
179   }
180 
181 }
182 
183 
184 
185 /**
186  * @title Standard ERC20 token
187  *
188  * @dev Implementation of the basic standard token.
189  * @dev https://github.com/ethereum/EIPs/issues/20
190  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
191  */
192 contract StandardToken is ERC20, BasicToken {
193 
194   mapping (address => mapping (address => uint256)) internal allowed;
195 
196 
197   /**
198    * @dev Transfer tokens from one address to another
199    * @param _from address The address which you want to send tokens from
200    * @param _to address The address which you want to transfer to
201    * @param _value uint256 the amount of tokens to be transferred
202    */
203   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
204     require(_to != address(0));
205     require(_value <= balances[_from]);
206     require(_value <= allowed[_from][msg.sender]);
207 
208     balances[_from] = balances[_from].sub(_value);
209     balances[_to] = balances[_to].add(_value);
210     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
211     Transfer(_from, _to, _value);
212     return true;
213   }
214 
215   /**
216    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
217    *
218    * Beware that changing an allowance with this method brings the risk that someone may use both the old
219    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
220    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
221    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
222    * @param _spender The address which will spend the funds.
223    * @param _value The amount of tokens to be spent.
224    */
225   function approve(address _spender, uint256 _value) public returns (bool) {
226     allowed[msg.sender][_spender] = _value;
227     Approval(msg.sender, _spender, _value);
228     return true;
229   }
230 
231   /**
232    * @dev Function to check the amount of tokens that an owner allowed to a spender.
233    * @param _owner address The address which owns the funds.
234    * @param _spender address The address which will spend the funds.
235    * @return A uint256 specifying the amount of tokens still available for the spender.
236    */
237   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
238     return allowed[_owner][_spender];
239   }
240 
241   /**
242    * approve should be called when allowed[_spender] == 0. To increment
243    * allowed value is better to use this function to avoid 2 calls (and wait until
244    * the first transaction is mined)
245    * From MonolithDAO Token.sol
246    */
247   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
248     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
249     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
250     return true;
251   }
252 
253   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
254     uint oldValue = allowed[msg.sender][_spender];
255     if (_subtractedValue > oldValue) {
256       allowed[msg.sender][_spender] = 0;
257     } else {
258       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
259     }
260     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
261     return true;
262   }
263 
264 }
265 
266 
267 /**
268  * @title Pausable token
269  *
270  * @dev StandardToken modified with pausable transfers.
271  **/
272 
273 contract PausableToken is StandardToken, Pausable {
274 
275   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
276     return super.transfer(_to, _value);
277   }
278 
279   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
280     return super.transferFrom(_from, _to, _value);
281   }
282 
283   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
284     return super.approve(_spender, _value);
285   }
286 
287   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
288     return super.increaseApproval(_spender, _addedValue);
289   }
290 
291   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
292     return super.decreaseApproval(_spender, _subtractedValue);
293   }
294 }
295 
296 
297 /**
298  * @title Mintable token
299  * @dev Simple ERC20 Token example, with mintable token creation
300  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
301  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
302  */
303 
304 contract MintableToken is StandardToken, Ownable {
305   event Mint(address indexed to, uint256 amount);
306   event MintFinished();
307 
308   bool public mintingFinished = false;
309 
310 
311   modifier canMint() {
312     require(!mintingFinished);
313     _;
314   }
315 
316   /**
317    * @dev Function to mint tokens
318    * @param _to The address that will receive the minted tokens.
319    * @param _amount The amount of tokens to mint.
320    * @return A boolean that indicates if the operation was successful.
321    */
322   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
323     totalSupply = totalSupply.add(_amount);
324     balances[_to] = balances[_to].add(_amount);
325     Mint(_to, _amount);
326     Transfer(0x0, _to, _amount);
327     return true;
328   }
329 
330   /**
331    * @dev Function to stop minting new tokens.
332    * @return True if the operation was successful.
333    */
334   function finishMinting() onlyOwner public returns (bool) {
335     mintingFinished = true;
336     MintFinished();
337     return true;
338   }
339 }
340 
341 
342 /**
343  * @title Destructible
344  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
345  */
346 contract Destructible is Ownable {
347 
348   function Destructible() public payable { }
349 
350   /**
351    * @dev Transfers the current balance to the owner and terminates the contract.
352    */
353   function destroy() onlyOwner public {
354     selfdestruct(owner);
355   }
356 
357   function destroyAndSend(address _recipient) onlyOwner public {
358     selfdestruct(_recipient);
359   }
360 }
361 
362 
363 contract PreSaleToken is MintableToken,PausableToken,Destructible {
364   string public name = "Helbiz Genesis";
365   string public symbol = "HBG";
366   uint256 public decimals = 18;
367 }
368 
369 contract PreSaleHelbiz is Ownable,Destructible{
370     using SafeMath for uint256;
371     PreSaleToken public token;
372     mapping (address => uint256) public tokenHoldersToClaim; //still to be claimed to someone
373     mapping (address => uint256) public tokenHoldersTotal; //total token claimed to someone
374     mapping (address => uint256) public tokenHoldersClaimed; //already made claimed by someone
375     address[] tokenHolders; //list of tokeholders that had already claimed their token
376     bool public isReady;
377     
378     event AddedTokenHolder(address holder, uint256 amount);
379     event RemovedTokenHolder(address holder);
380     event Claimed(address holder, uint256 amount);
381     event StartClaim();
382     event EndClaim();
383     
384     modifier canClaim(){
385         require(isReady);
386         _;
387     }
388     
389     function PreSaleHelbiz() public{
390         token=new PreSaleToken();
391         token.pause();
392         isReady=false;
393     }
394     
395     function () payable canClaim public{
396         require(msg.value == 0);
397         claim();
398     }
399     
400     function startClaim() onlyOwner public{
401         require(!isReady);
402         isReady=true;
403         StartClaim();
404     }
405     
406     function endClaim() onlyOwner public{
407         require(isReady);
408         isReady=false;
409         EndClaim();
410     }
411     
412     //methods to access externally state of PreICO claimed
413     function getCountHolder() view public returns(uint){
414         return tokenHolders.length;
415     }
416     
417     function getHolderAtIndex(uint i) view public  returns(address){
418         return tokenHolders[i];
419     } 
420     
421     function balanceOfHolder(address add) view public  returns(uint256){
422         return token.balanceOf(add);
423     } //ends methods
424     
425     function addHolder(address add, uint256 amount) onlyOwner public{
426         //if user had already claimed his funds we add an additional quantity of token
427         //if there were already an amount not claimed it wil be updated
428         //if it is a new users a new entry will be added
429         tokenHoldersToClaim[add]=amount;
430         tokenHoldersTotal[add]=tokenHoldersClaimed[add]+amount;
431         AddedTokenHolder(add,amount);
432     }
433 
434     
435     function claim() private{
436         var amount=tokenHoldersToClaim[msg.sender];
437         if(amount>0){
438             tokenHoldersToClaim[msg.sender]=0;
439             token.mint(msg.sender,amount*10**token.decimals());
440             tokenHoldersClaimed[msg.sender]+=amount;
441             tokenHolders.push(msg.sender);
442             Claimed(msg.sender,amount);
443         }
444     }
445 	
446 	function preAssign(address add) onlyOwner public{
447         var amount=tokenHoldersToClaim[add];
448         if(amount>0){
449             tokenHoldersToClaim[add]=0;
450             token.mint(add,amount*10**token.decimals());
451             tokenHoldersClaimed[add]+=amount;
452             tokenHolders.push(add);
453             Claimed(add,amount);
454         }
455     }
456     
457     function transferTokenOwnership() onlyOwner public{
458         token.transferOwnership(owner);
459     }
460     
461     //override
462     function destroy() onlyOwner public {
463         token.destroy();
464         super.destroy();
465     }
466     
467     //override
468     function destroyAndSend(address _recipient) onlyOwner public {
469         token.destroyAndSend(_recipient);
470         super.destroyAndSend(_recipient);
471      }
472 
473     
474 }