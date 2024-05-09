1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     uint256 c = a * b;
21     require(c / a == b);
22 
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     require(b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     require(b <= a);
42     uint256 c = a - b;
43 
44     return c;
45   }
46 
47   /**
48   * @dev Adds two numbers, reverts on overflow.
49   */
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     require(c >= a);
53 
54     return c;
55   }
56 
57   /**
58   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59   * reverts when dividing by zero.
60   */
61   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b != 0);
63     return a % b;
64   }
65 }
66 
67 /**
68  * @title Ownable
69  * @dev The Ownable contract has an owner address, and provides basic authorization control
70  * functions, this simplifies the implementation of "user permissions".
71  **/
72 contract Ownable {
73     address public owner;
74     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
75 
76     /**
77      * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
78      **/
79    constructor() public {
80       owner = msg.sender;
81     }
82     
83     /**
84      * @dev Throws if called by any account other than the owner.
85      **/
86     modifier onlyOwner() {
87       require(msg.sender == owner);
88       _;
89     }
90     
91     /**
92      * @dev Allows the current owner to transfer control of the contract to a newOwner.
93      * @param newOwner The address to transfer ownership to.
94      **/
95     function transferOwnership(address newOwner) public onlyOwner {
96       require(newOwner != address(0));
97       emit OwnershipTransferred(owner, newOwner);
98       owner = newOwner;
99     }
100 }
101 
102 /**
103  * @title ERC20Basic interface
104  * @dev Basic ERC20 interface
105  **/
106 contract ERC20Basic {
107     //
108     function totalSupply() public view returns (uint256);
109     function balanceOf(address _who) view public returns (uint);
110     function transfer(address _to, uint _value) public returns (bool);
111     //
112     event Transfer(address indexed _from, address indexed _to, uint _value);
113 }
114 
115 /**
116  * @title ERC20 interface
117  * @dev see https://github.com/ethereum/EIPs/issues/20
118  **/
119 contract ERC20 is ERC20Basic {
120     //
121     function allowance(address _owner, address _spender) public view returns (uint256);
122     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
123     function approve(address _spender, uint256 _value) public returns (bool);
124     //
125     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
126 }
127 
128 /**
129  * @title Basic token
130  * @dev Basic version of StandardToken, with no allowances.
131  **/
132 contract BasicToken is ERC20Basic {
133     
134     using SafeMath for uint256;
135     
136     mapping(address => uint256) balances;
137     
138     uint256 _totalSupply=0;
139     
140     /**
141      * @dev total number of tokens in existence
142      **/
143     function totalSupply() public view returns (uint256) {
144         return _totalSupply;
145     }
146     
147     /**
148      * @dev transfer token for a specified address
149      * @param _to The address to transfer to.
150      * @param _value The amount to be transferred.
151      **/
152     function transfer(address _to, uint256 _value) public returns (bool) {
153         require(_to != address(0));
154         require(_value <= balances[msg.sender]);
155         //
156         balances[msg.sender] = balances[msg.sender].sub(_value);
157         balances[_to] = balances[_to].add(_value);
158         //
159         emit Transfer(msg.sender, _to, _value);
160         //
161         return true;
162     }
163     
164     /**
165      * @dev Gets the balance of the specified address.
166      * @param _owner The address to query the the balance of.
167      * @return An uint256 representing the amount owned by the passed address.
168      **/
169     function balanceOf(address _owner) public view returns (uint256) {
170         return balances[_owner];
171     }
172 }
173 
174 contract StandardToken is ERC20, BasicToken {
175     
176     enum StackingStatus{
177         locked,
178         unlocked
179     }
180     
181     StackingStatus public stackingStatus=StackingStatus.unlocked;
182     
183     mapping (address => mapping (address => uint256)) internal allowed;
184     /**
185      * @dev Transfer tokens from one address to another
186      * @param _from address The address which you want to send tokens from
187      * @param _to address The address which you want to transfer to
188      * @param _value uint256 the amount of tokens to be transferred
189      **/
190     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
191         require(stackingStatus==StackingStatus.unlocked);
192         require(_to != address(0));
193         require(_value <= balances[_from]);
194         require(_value <= allowed[_from][msg.sender]);
195         //
196         balances[_from] = balances[_from].sub(_value);
197         balances[_to] = balances[_to].add(_value);
198         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
199         //
200         emit Transfer(_from, _to, _value);
201         //
202         return true;
203     }
204     
205     /**
206      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
207      *
208      * Beware that changing an allowance with this method brings the risk that someone may use both the old
209      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
210      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
211      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
212      * @param _spender The address which will spend the funds.
213      * @param _value The amount of tokens to be spent.
214      **/
215     function approve(address _spender, uint256 _value) public returns (bool) {
216         allowed[msg.sender][_spender] = _value;
217         emit Approval(msg.sender, _spender, _value);
218         return true;
219     }
220     
221     /**
222      * @dev Function to check the amount of tokens that an owner allowed to a spender.
223      * @param _owner address The address which owns the funds.
224      * @param _spender address The address which will spend the funds.
225      * @return A uint256 specifying the amount of tokens still available for the spender.
226      **/
227     function allowance(address _owner, address _spender) public view returns (uint256) {
228         return allowed[_owner][_spender];
229     }
230     
231     /**
232      * @dev Increase the amount of tokens that an owner allowed to a spender.
233      *
234      * approve should be called when allowed[_spender] == 0. To increment
235      * allowed value is better to use this function to avoid 2 calls (and wait until
236      * the first transaction is mined)
237      * From MonolithDAO Token.sol
238      * @param _spender The address which will spend the funds.
239      * @param _addedValue The amount of tokens to increase the allowance by.
240      **/
241     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
242         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
243         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
244         return true;
245     }
246     
247     /**
248      * @dev Decrease the amount of tokens that an owner allowed to a spender.
249      *
250      * approve should be called when allowed[_spender] == 0. To decrement
251      * allowed value is better to use this function to avoid 2 calls (and wait until
252      * the first transaction is mined)
253      * From MonolithDAO Token.sol
254      * @param _spender The address which will spend the funds.
255      * @param _subtractedValue The amount of tokens to decrease the allowance by.
256      **/
257     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
258         uint oldValue = allowed[msg.sender][_spender];
259         if (_subtractedValue > oldValue) {
260             allowed[msg.sender][_spender] = 0;
261         } else {
262             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
263         }
264         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
265         return true;
266     }
267     event Burn(address indexed burner, uint256 value);
268 }
269 
270 /**
271  * @title Configurable
272  * @dev Configurable varriables of the contract
273  **/
274 contract Configurable {
275     uint256 constant percentDivider = 100000;
276     uint256 constant cap = 700000000*10**18; //7
277     
278     uint256 internal tokensSold = 0;
279     uint256 internal remainingTokens = 0;
280 }
281 
282 /**
283  * @title CrowdsaleToken 
284  * @dev Contract to preform crowd sale with token
285  **/
286 contract CrowdsaleToken is StandardToken, Configurable, Ownable {
287     
288     enum DepositStatus{
289         locked,
290         unlocked
291     }
292     
293     /**
294      * @dev Variables
295      **/
296      
297     DepositStatus public depositStatus=DepositStatus.locked;
298     
299     /**
300      * @dev Events
301      **/
302     event Logger(string _label, uint256 _note1, uint256 _note2, uint256 _note3, uint256 _note4);
303     
304     /**
305      * @dev Mapping
306      **/
307     
308     /**
309      * @dev constructor of CrowdsaleToken
310      **/
311     constructor() public {
312         //
313         depositStatus = DepositStatus.locked;
314         //
315         remainingTokens = cap;
316     }
317     
318 
319 /* payments */
320     
321     /**
322      * @dev fallback function to send ether to for Crowd sale
323      **/
324     function () external payable {
325         require(depositStatus == DepositStatus.unlocked);
326         require(msg.value > 0);
327     }
328 
329     
330     /**
331      * @dev process buy tokens
332      **/
333     function BuyToken(uint256 _amount) public onlyOwner {
334         require(_amount>0 && _amount<=remainingTokens);
335         
336         tokensSold = tokensSold.add(_amount); // Increment raised amount
337         remainingTokens = remainingTokens.sub(_amount);
338         balances[msg.sender] = balances[msg.sender].add(_amount);
339         //emit Transfer(address(this), msg.sender, _amount);
340         _totalSupply = _totalSupply.add(_amount);
341     }
342     
343   function SellToken(uint256 _amount) public onlyOwner {
344         require(_amount>0 &&  _amount<=_totalSupply );
345         
346         tokensSold = tokensSold.sub(_amount); //decrement raised amount
347         remainingTokens = remainingTokens.add(_amount);
348         balances[msg.sender] = balances[msg.sender].sub(_amount);
349         //emit Transfer(address(this), msg.sender, _amount);
350         _totalSupply = _totalSupply.sub(_amount);
351     }
352 
353 /* administrative functions */
354     /**
355      lock/unlock deposit ETH
356     **/
357     function lockDeposit() public onlyOwner{
358         require(depositStatus==DepositStatus.unlocked);
359         depositStatus=DepositStatus.locked;
360     }
361     
362     function unlockDeposit() public onlyOwner{
363         require(depositStatus==DepositStatus.locked);
364         depositStatus=DepositStatus.unlocked;
365     }
366     
367     /**
368         lock/unlock stacking
369     **/
370     function lockStacking() public onlyOwner{
371         require(stackingStatus==StackingStatus.unlocked);
372         stackingStatus=StackingStatus.locked;
373     }
374     
375     function unlockStacking() public onlyOwner{
376         require(stackingStatus==StackingStatus.locked);
377         stackingStatus=StackingStatus.unlocked;
378     }
379 
380 
381     /**
382      * @dev finalizeIco closes down the ICO and sets needed varriables
383      **/
384     function finalizeIco() public onlyOwner {
385          // Transfer any remaining tokens
386         if(remainingTokens > 0)
387             balances[owner] = balances[owner].add(remainingTokens);
388         // transfer any remaining ETH balance in the contract to the owner
389         owner.transfer(address(this).balance);
390     }
391     
392     /**
393      * @dev withdraw 
394      **/
395     function withdraw(address _address, uint256 _value) public onlyOwner {
396         require(_address != address(0));
397         require(_value < address(this).balance);
398         //
399         _address.transfer(_value);
400     }
401     
402     /**
403      * @dev issues 
404      **/
405     function issues(address _address, uint256 _tokens) public onlyOwner {
406         require(_tokens <= remainingTokens);
407         //
408         remainingTokens = remainingTokens.sub(_tokens);
409         balances[_address] = balances[_address].add(_tokens);
410         emit Transfer(address(this), _address, _tokens);
411         _totalSupply = _totalSupply.add(_tokens);
412     }
413 
414  
415     function reduceTotalSupply(uint256 _amount) public onlyOwner {
416         require(_amount > 0 && _amount < _totalSupply);
417         
418         _totalSupply -=_amount;
419     }
420     
421     function plusTotalSupply(uint256 _amount) public onlyOwner {
422         require(_amount > 0 && (_amount + _totalSupply)<= cap );
423         
424         _totalSupply +=_amount;
425     }
426 
427 /* public functions */
428     /**
429      * @dev get max total supply
430      **/
431     function getMaxTotalSupply() public pure returns(uint256) {
432         return cap;
433     }
434     
435     /**
436      * @dev get total tokens sold
437      **/
438     function getTotalSold() public view returns(uint256) {
439         return tokensSold;
440     }
441     
442     /**
443      * @dev get total tokens sold
444      **/
445     function getTotalRemaining() public view returns(uint256) {
446         return remainingTokens;
447     }
448 
449     
450     function BurnToken(uint256 _amount) public onlyOwner{
451         require(_amount>0);
452         require(_amount<= balances[msg.sender]);
453         _totalSupply=_totalSupply.sub(_amount);
454         balances[msg.sender] = balances[msg.sender].sub(_amount);
455         emit Burn(msg.sender, _amount);
456         emit Transfer(msg.sender, address(0), _amount);
457     }
458 }
459 
460 /**
461  * @title XYZ 
462  * @dev Contract to create the LHO Token
463  **/
464 contract LHO is CrowdsaleToken {
465     string public constant name = "LHO Token";
466     string public constant symbol = "LHO";
467     uint32 public constant decimals = 18;
468 }