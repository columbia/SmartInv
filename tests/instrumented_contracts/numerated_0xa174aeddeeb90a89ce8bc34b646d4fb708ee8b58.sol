1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, reverts on overflow.
7   */
8   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
9     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
10     // benefit is lost if 'b' is also tested.
11     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12     if (_a == 0) {
13       return 0;
14     }
15 
16     uint256 c = _a * _b;
17     require(c / _a == _b);
18 
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
24   */
25   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
26     require(_b > 0); // Solidity only automatically asserts when dividing by 0
27     uint256 c = _a / _b;
28     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
29 
30     return c;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
37     require(_b <= _a);
38     uint256 c = _a - _b;
39 
40     return c;
41   }
42 
43   /**
44   * @dev Adds two numbers, reverts on overflow.
45   */
46   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
47     uint256 c = _a + _b;
48     require(c >= _a);
49 
50     return c;
51   }
52 
53   /**
54   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
55   * reverts when dividing by zero.
56   */
57   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
58     require(b != 0);
59     return a % b;
60   }
61 }
62 
63 contract Ownable {
64   address public owner;
65 
66 
67   event OwnershipRenounced(address indexed previousOwner);
68   event OwnershipTransferred(
69     address indexed previousOwner,
70     address indexed newOwner
71   );
72 
73 
74   /**
75    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
76    * account.
77    */
78   constructor() public {
79     owner = msg.sender;
80   }
81 
82   /**
83    * @dev Throws if called by any account other than the owner.
84    */
85   modifier onlyOwner() {
86     require(msg.sender == owner);
87     _;
88   }
89 
90   /**
91    * @dev Allows the current owner to relinquish control of the contract.
92    * @notice Renouncing to ownership will leave the contract without an owner.
93    * It will not be possible to call the functions with the `onlyOwner`
94    * modifier anymore.
95    */
96   function renounceOwnership() public onlyOwner {
97     emit OwnershipRenounced(owner);
98     owner = address(0);
99   }
100 
101   /**
102    * @dev Allows the current owner to transfer control of the contract to a newOwner.
103    * @param _newOwner The address to transfer ownership to.
104    */
105   function transferOwnership(address _newOwner) public onlyOwner {
106     _transferOwnership(_newOwner);
107   }
108 
109   /**
110    * @dev Transfers control of the contract to a newOwner.
111    * @param _newOwner The address to transfer ownership to.
112    */
113   function _transferOwnership(address _newOwner) internal {
114     require(_newOwner != address(0));
115     emit OwnershipTransferred(owner, _newOwner);
116     owner = _newOwner;
117   }
118 }
119 
120 contract ERC20 {
121   function totalSupply() public view returns (uint256);
122 
123   function balanceOf(address _who) public view returns (uint256);
124 
125   function allowance(address _owner, address _spender)
126     public view returns (uint256);
127 
128   function transfer(address _to, uint256 _value) public returns (bool);
129 
130   function approve(address _spender, uint256 _value)
131     public returns (bool);
132 
133   function transferFrom(address _from, address _to, uint256 _value)
134     public returns (bool);
135 
136   event Transfer(
137     address indexed from,
138     address indexed to,
139     uint256 value
140   );
141 
142   event Approval(
143     address indexed owner,
144     address indexed spender,
145     uint256 value
146   );
147 }
148 
149 contract Rays is ERC20, Ownable {
150   using SafeMath for uint256;
151 
152   mapping (address => uint256) internal balances;
153 
154   mapping (address => mapping (address => uint256)) private allowed;
155 
156   uint256 internal totalSupply_;
157   
158   
159   event Burn(address indexed burner, uint256 value);
160   
161   string public name = "Rays Network";
162   string public symbol = "RAYS";
163   uint8 public decimals = 18;
164   uint256 public constant INITIAL_SUPPLY = 500000000 * 10**18;
165 
166   constructor() public {
167     totalSupply_ = INITIAL_SUPPLY;
168     balances[msg.sender] = INITIAL_SUPPLY;
169     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
170   }
171 
172   /**
173   * @dev Total number of tokens in existence
174   */
175   function totalSupply() public view returns (uint256) {
176     return totalSupply_;
177   }
178   
179 
180   /**
181   * @dev Gets the balance of the specified address.
182   * @param _owner The address to query the the balance of.
183   * @return An uint256 representing the amount owned by the passed address.
184   */
185   function balanceOf(address _owner) public view returns (uint256) {
186     return balances[_owner];
187   }
188 
189   /**
190    * @dev Function to check the amount of tokens that an owner allowed to a spender.
191    * @param _owner address The address which owns the funds.
192    * @param _spender address The address which will spend the funds.
193    * @return A uint256 specifying the amount of tokens still available for the spender.
194    */
195   function allowance(
196     address _owner,
197     address _spender
198    )
199     public
200     view
201     returns (uint256)
202   {
203     return allowed[_owner][_spender];
204   }
205 
206   /**
207   * @dev Transfer token for a specified address
208   * @param _to The address to transfer to.
209   * @param _value The amount to be transferred.
210   */
211   function transfer(address _to, uint256 _value) public returns (bool) {
212     require(_value <= balances[msg.sender]);
213     require(_to != address(0));
214 
215     balances[msg.sender] = balances[msg.sender].sub(_value);
216     balances[_to] = balances[_to].add(_value);
217     emit Transfer(msg.sender, _to, _value);
218     return true;
219   }
220 
221   /**
222    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
223    * Beware that changing an allowance with this method brings the risk that someone may use both the old
224    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
225    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
226    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
227    * @param _spender The address which will spend the funds.
228    * @param _value The amount of tokens to be spent.
229    */
230   function approve(address _spender, uint256 _value) public returns (bool) {
231     allowed[msg.sender][_spender] = _value;
232     emit Approval(msg.sender, _spender, _value);
233     return true;
234   }
235 
236   /**
237    * @dev Transfer tokens from one address to another
238    * @param _from address The address which you want to send tokens from
239    * @param _to address The address which you want to transfer to
240    * @param _value uint256 the amount of tokens to be transferred
241    */
242   function transferFrom(
243     address _from,
244     address _to,
245     uint256 _value
246   )
247     public
248     returns (bool)
249   {
250     require(_value <= balances[_from]);
251     require(_value <= allowed[_from][msg.sender]);
252     require(_to != address(0));
253 
254     balances[_from] = balances[_from].sub(_value);
255     balances[_to] = balances[_to].add(_value);
256     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
257     emit Transfer(_from, _to, _value);
258     return true;
259   }
260 
261   /**
262    * @dev Increase the amount of tokens that an owner allowed to a spender.
263    * approve should be called when allowed[_spender] == 0. To increment
264    * allowed value is better to use this function to avoid 2 calls (and wait until
265    * the first transaction is mined)
266    * From MonolithDAO Token.sol
267    * @param _spender The address which will spend the funds.
268    * @param _addedValue The amount of tokens to increase the allowance by.
269    */
270   function increaseApproval(
271     address _spender,
272     uint256 _addedValue
273   )
274     public
275     returns (bool)
276   {
277     allowed[msg.sender][_spender] = (
278       allowed[msg.sender][_spender].add(_addedValue));
279     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
280     return true;
281   }
282 
283   /**
284    * @dev Decrease the amount of tokens that an owner allowed to a spender.
285    * approve should be called when allowed[_spender] == 0. To decrement
286    * allowed value is better to use this function to avoid 2 calls (and wait until
287    * the first transaction is mined)
288    * From MonolithDAO Token.sol
289    * @param _spender The address which will spend the funds.
290    * @param _subtractedValue The amount of tokens to decrease the allowance by.
291    */
292   function decreaseApproval(
293     address _spender,
294     uint256 _subtractedValue
295   )
296     public
297     returns (bool)
298   {
299     uint256 oldValue = allowed[msg.sender][_spender];
300     if (_subtractedValue >= oldValue) {
301       allowed[msg.sender][_spender] = 0;
302     } else {
303       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
304     }
305     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
306     return true;
307   }
308 
309   /**
310    * @dev Internal function that mints an amount of the token and assigns it to
311    * an account. This encapsulates the modification of balances such that the
312    * proper events are emitted.
313    * @param _account The account that will receive the created tokens.
314    * @param _amount The amount that will be created.
315    */
316   function _mint(address _account, uint256 _amount) public onlyOwner {
317     require(_account != 0);
318     totalSupply_ = totalSupply_.add(_amount);
319     balances[_account] = balances[_account].add(_amount);
320     emit Transfer(address(0), _account, _amount);
321   }
322 
323   /**
324    * @dev Internal function that burns an amount of the token of a given
325    * account.
326    * @param _account The account whose tokens will be burnt.
327    * @param _amount The amount that will be burnt.
328    */
329   function _burn(address _account, uint256 _amount) public onlyOwner {
330     require(_account != 0);
331     require(_amount <= balances[_account]);
332 
333     totalSupply_ = totalSupply_.sub(_amount);
334     balances[_account] = balances[_account].sub(_amount);
335     emit Transfer(_account, address(0), _amount);
336   }
337   
338 }
339 
340 contract Crowdsale is Rays {
341     // ICO rounds
342     enum IcoStages {preSale, preIco, ico} 
343     IcoStages Stage;
344     bool private crowdsaleFinished;
345     
346     uint private startPreSaleDate;
347     uint private endPreSaleDate;
348     uint public preSaleGoal;
349     uint private preSaleRaised;
350     
351     uint private startPreIcoDate;
352     uint private endPreIcoDate;
353     uint public preIcoGoal;
354     uint private preIcoRaised;
355     
356     uint private startIcoDate;
357     uint private endIcoDate;
358     uint public icoGoal;
359     uint private icoRaised;
360     
361     uint private softCup; // 2 000 000 $ (300$ = 1 ether)
362     uint private totalCup;
363     uint private price;
364     uint private total;
365     uint private reserved;
366     uint private hardCup;// 20 000 000 $ (300$ = 1 ether)
367     
368     struct Benefeciary{ // collect all participants of ICO
369         address wallet;
370         uint amount;
371     }
372     Benefeciary[] private benefeciary;
373     uint private ethersRefund;
374     
375     constructor() public {
376         startPreSaleDate = 1534723200; // insert here your pre sale start date
377         endPreSaleDate = 1536969600; // insert here your pre sale end date
378         preSaleGoal = 60000000; // pre-sale goal 
379         preSaleRaised = 0; // raised on pre-sale stage
380         startPreIcoDate = 1534723200; // insert here your pre ico start date
381         endPreIcoDate = 1538265600; // insert here your pre ico end date
382         preIcoGoal = 60000000; // pre ico goal 
383         preIcoRaised = 0; // raised on pre ico
384         startIcoDate = 1534723200; // insert here your ico start date
385         endIcoDate = 1546214400; // insert here your ico end date
386         icoGoal = 80000000; // ico goal 
387         icoRaised = 0; // raised on ico stage
388         softCup = 6670 * 10**18; 
389         hardCup = 66670 * 10**18;
390         totalCup = 0;
391         price = 1160;
392         total = preSaleGoal + preIcoGoal + icoGoal;
393         reserved = (70000000 + 200000000 + 5000000 + 25000000) * 10**18;
394         crowdsaleFinished = false;
395     }
396   
397     function getCrowdsaleInfo() private returns(uint stage, 
398                                                uint tokenAvailable, 
399                                                uint bonus){
400         // Token calculating
401         if(now <= endPreSaleDate && preSaleRaised < preSaleGoal){
402             Stage = IcoStages.preSale;
403             tokenAvailable = preSaleGoal - preSaleRaised;
404             total -= preSaleRaised;
405             bonus = 0; // insert your bonus value on pre sale phase
406         } else if(startPreIcoDate <= now && now <= endPreIcoDate && preIcoRaised < preIcoGoal){
407             Stage = IcoStages.preIco;
408             tokenAvailable = preIcoGoal - preIcoRaised;
409             total -= preIcoRaised;
410             bonus = 50; // + 50% seems like bonus
411         } else if(startIcoDate <= now && now <= endIcoDate && icoRaised < total){
412             tokenAvailable = total - icoRaised;
413             Stage = IcoStages.ico;
414             bonus = 0;
415         } else {
416             // if ICO has not been started
417             revert();
418         }
419         return (uint(Stage), tokenAvailable, bonus);
420     }
421     //per 0.1 ether will recieved 116 tokens
422     function evaluateTokens(uint _value, address _sender) private returns(uint tokens){
423         ethersRefund = 0;
424         uint bonus;
425         uint tokenAvailable;
426         uint stage;
427         (stage,tokenAvailable,bonus) = getCrowdsaleInfo();
428         tokens = _value * price / 10**18; 
429         if(bonus != 0){
430             tokens = tokens + (tokens * bonus / 100); // calculate bonus tokens
431         } 
432         if(tokenAvailable < tokens){ // if not enough tokens in reserve
433             tokens = tokenAvailable;
434             ethersRefund = _value - (tokens / price * 10**18); // calculate how many ethers will respond to user
435             _sender.transfer(ethersRefund);// payback 
436         }
437         owner.transfer(_value - ethersRefund);
438         // Add token value to raised variable
439         if(stage == 0){
440             preSaleRaised += tokens;
441         } else if(stage == 1){
442             preIcoRaised += tokens;
443         } else if(stage == 2){
444             icoRaised += tokens;
445         } 
446         addInvestor(_sender, _value);
447         return tokens;
448     }
449     
450     function addInvestor(address _sender, uint _value) private {
451         Benefeciary memory ben;
452         for(uint i = 0; i < benefeciary.length; i++){
453             if(benefeciary[i].wallet == _sender){
454                 benefeciary[i].amount = benefeciary[i].amount + _value - ethersRefund;
455             }
456         }
457         ben.wallet = msg.sender;
458         ben.amount = msg.value - ethersRefund;
459         benefeciary.push(ben);
460     }
461     
462     
463     function() public payable {
464         require(startPreSaleDate <= now && now <= endIcoDate);
465         require(msg.value >= 0.1 ether);
466         require(!crowdsaleFinished);
467         totalCup += msg.value;
468         uint token = evaluateTokens(msg.value, msg.sender);
469         // send tokens to buyer
470         balances[msg.sender] = balances[msg.sender].add(token * 10**18);
471         balances[owner] = balances[owner].sub(token * 10**18);
472         emit Transfer(owner, msg.sender, token * 10**18);
473     }
474     
475     function showParticipantWei(address _wallet) public view onlyOwner returns(uint){
476         for(uint i = 0; i < benefeciary.length; i++){
477             if(benefeciary[i].wallet == _wallet){
478                 return benefeciary[i].amount;// show in wei
479             }
480         }
481         return 0;
482     }
483     
484     function burnUnsoldTokens() public onlyOwner icoHasFinished{
485         _burn(owner, balanceOf(owner).sub(reserved));
486     }
487     
488     function crowdSaleStage() public view returns(string){
489         string memory result;
490         if(uint(Stage) == 0){
491             result = "Pre Sale";
492         } else if(uint(Stage) == 1){
493             result = "Pre-ICO";
494         } else if(uint(Stage) == 2){
495             result = "ICO";
496         }
497         return result;
498     }
499     
500     function preSaleRaise() public view returns(uint){
501         return preSaleRaised;
502     }
503     
504     function preIcoRaise() public view returns(uint){
505         return preIcoRaised;
506     }
507     
508     function icoRaise() public view returns(uint){
509         return icoRaised;
510     }
511     
512     modifier icoHasFinished() {
513         require(now >= endIcoDate || icoRaised == total || crowdsaleFinished);
514         _;
515     }
516     
517     function endIcoByCup() public onlyOwner{
518         require(!crowdsaleFinished);
519         require(totalCup >= softCup && totalCup <= hardCup);
520         crowdsaleFinished = true;
521     }
522     
523     // Output all funds in wei
524     function showAllFunds() public onlyOwner view returns(uint){
525         return totalCup;
526     }
527 }