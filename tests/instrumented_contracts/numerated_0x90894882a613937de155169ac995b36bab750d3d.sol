1 pragma solidity ^0.4.24;
2  
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 /**
15  * @title SafeMath
16  * @dev Math operations with safety checks that throw on error
17  */
18 library SafeMath {
19 
20   /**
21   * @dev Multiplies two numbers, throws on overflow.
22   */
23   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
24     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
25     // benefit is lost if 'b' is also tested.
26     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
27     if (a == 0) {
28       return 0;
29     }
30 
31     c = a * b;
32     assert(c / a == b);
33     return c;
34   }
35 
36   /**
37   * @dev Integer division of two numbers, truncating the quotient.
38   */
39   function div(uint256 a, uint256 b) internal pure returns (uint256) {
40     // assert(b > 0); // Solidity automatically throws when dividing by 0
41     // uint256 c = a / b;
42     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
43     return a / b;
44   }
45 
46   /**
47   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
48   */
49   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50     assert(b <= a);
51     return a - b;
52   }
53 
54   /**
55   * @dev Adds two numbers, throws on overflow.
56   */
57   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
58     c = a + b;
59     assert(c >= a);
60     return c;
61   }
62 }
63 /**
64  * @title Basic token
65  * @dev Basic version of StandardToken, with no allowances.
66  */
67 contract BasicToken is ERC20Basic {
68   using SafeMath for uint256;
69 
70   mapping(address => uint256) balances;
71 
72   uint256 totalSupply_;
73 
74   /**
75   * @dev Total number of tokens in existence
76   */
77   function totalSupply() public view returns (uint256) {
78     return totalSupply_;
79   }
80 
81   /**
82   * @dev Transfer token for a specified address
83   * @param _to The address to transfer to.
84   * @param _value The amount to be transferred.
85   */
86   function transfer(address _to, uint256 _value) public returns (bool) {
87     require(_to != address(0));
88     require(_value <= balances[msg.sender]);
89 
90     balances[msg.sender] = balances[msg.sender].sub(_value);
91     balances[_to] = balances[_to].add(_value);
92     emit Transfer(msg.sender, _to, _value);
93     return true;
94   }
95 
96   /**
97   * @dev Gets the balance of the specified address.
98   * @param _owner The address to query the the balance of.
99   * @return An uint256 representing the amount owned by the passed address.
100   */
101   function balanceOf(address _owner) public view returns (uint256) {
102     return balances[_owner];
103   }
104 
105 }
106 
107 /**
108  * @title ERC20 interface
109  * @dev see https://github.com/ethereum/EIPs/issues/20
110  */
111 contract ERC20 is ERC20Basic {
112     function allowance(address owner, address spender) public view returns (uint256);
113 
114     function transferFrom(address from, address to, uint256 value) public returns (bool);
115 
116     function approve(address spender, uint256 value) public returns (bool);
117     event Approval(address indexed owner,address indexed spender,uint256 value);
118 }
119 
120 /**
121  * @title Standard ERC20 token
122  *
123  * @dev Implementation of the basic standard token.
124  * @dev https://github.com/ethereum/EIPs/issues/20
125  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
126  */
127 contract StandardToken is ERC20, BasicToken {
128 
129   mapping (address => mapping (address => uint256)) internal allowed;
130 
131 
132   /**
133    * @dev Transfer tokens from one address to another
134    * @param _from address The address which you want to send tokens from
135    * @param _to address The address which you want to transfer to
136    * @param _value uint256 the amount of tokens to be transferred
137    */
138   function transferFrom(
139     address _from,
140     address _to,
141     uint256 _value
142   )
143     public
144     returns (bool)
145   {
146     require(_to != address(0));
147     require(_value <= balances[_from]);
148     require(_value <= allowed[_from][msg.sender]);
149 
150     balances[_from] = balances[_from].sub(_value);
151     balances[_to] = balances[_to].add(_value);
152     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
153     emit Transfer(_from, _to, _value);
154     return true;
155   }
156 
157   /**
158    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
159    *
160    * Beware that changing an allowance with this method brings the risk that someone may use both the old
161    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
162    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
163    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164    * @param _spender The address which will spend the funds.
165    * @param _value The amount of tokens to be spent.
166    */
167   function approve(address _spender, uint256 _value) public returns (bool) {
168     allowed[msg.sender][_spender] = _value;
169     emit Approval(msg.sender, _spender, _value);
170     return true;
171   }
172 
173   /**
174    * @dev Function to check the amount of tokens that an owner allowed to a spender.
175    * @param _owner address The address which owns the funds.
176    * @param _spender address The address which will spend the funds.
177    * @return A uint256 specifying the amount of tokens still available for the spender.
178    */
179   function allowance(
180     address _owner,
181     address _spender
182    )
183     public
184     view
185     returns (uint256)
186   {
187     return allowed[_owner][_spender];
188   }
189 
190   /**
191    * @dev Increase the amount of tokens that an owner allowed to a spender.
192    *
193    * approve should be called when allowed[_spender] == 0. To increment
194    * allowed value is better to use this function to avoid 2 calls (and wait until
195    * the first transaction is mined)
196    * From MonolithDAO Token.sol
197    * @param _spender The address which will spend the funds.
198    * @param _addedValue The amount of tokens to increase the allowance by.
199    */
200   function increaseApproval(
201     address _spender,
202     uint _addedValue
203   )
204     public
205     returns (bool)
206   {
207     allowed[msg.sender][_spender] = (
208       allowed[msg.sender][_spender].add(_addedValue));
209     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
210     return true;
211   }
212 
213   /**
214    * @dev Decrease the amount of tokens that an owner allowed to a spender.
215    *
216    * approve should be called when allowed[_spender] == 0. To decrement
217    * allowed value is better to use this function to avoid 2 calls (and wait until
218    * the first transaction is mined)
219    * From MonolithDAO Token.sol
220    * @param _spender The address which will spend the funds.
221    * @param _subtractedValue The amount of tokens to decrease the allowance by.
222    */
223   function decreaseApproval(
224     address _spender,
225     uint _subtractedValue
226   )
227     public
228     returns (bool)
229   {
230     uint oldValue = allowed[msg.sender][_spender];
231     if (_subtractedValue > oldValue) {
232       allowed[msg.sender][_spender] = 0;
233     } else {
234       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
235     }
236     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
237     return true;
238   }
239 
240 }
241 
242 contract Ownable {
243     
244   address public owner;
245   
246    //这里是个事件，供前端监听
247   event OwnerEvent(address indexed previousOwner, address indexed newOwner);
248 
249   /**
250    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
251    * account.这是一个构造函数，在合约启动时只运行一次，将合约的地址赋给地址owner
252    */
253   constructor() public {
254     owner = msg.sender;
255   }
256 
257 
258   /**
259    * @dev Throws if called by any account other than the owner。这里就是modifier onlyOwner的修饰符，用来判定是否是合约的发布者
260    * 
261    */
262   modifier onlyOwner() {
263     require(msg.sender == owner);
264     _;
265   }
266 
267 
268   /**
269    * @dev Allows the current owner to transfer control of the contract to a newOwner.
270    * @param newOwner The address to transfer ownership to.
271    * 让合约拥有者修改指定新的合约拥有者，并调用事件来监听
272    */
273   function transferOwnership(address newOwner) public onlyOwner {
274     require(newOwner != address(0));
275     emit OwnerEvent(owner, newOwner);
276     owner = newOwner;
277   }
278 
279 }
280 /**
281  * @title Pausable
282  * @dev Base contract which allows children to implement an emergency stop mechanism.
283  */
284 contract Pausable is Ownable {
285   event Pause();
286   event Unpause();
287 
288   bool public paused = false;
289 
290 
291   /**
292    * @dev Modifier to make a function callable only when the contract is not paused.
293    */
294   modifier whenNotPaused() {
295     require(!paused);
296     _;
297   }
298 
299   /**
300    * @dev Modifier to make a function callable only when the contract is paused.
301    */
302   modifier whenPaused() {
303     require(paused);
304     _;
305   }
306 
307   /**
308    * @dev called by the owner to pause, triggers stopped state
309    */
310   function pause() onlyOwner whenNotPaused public {
311     paused = true;
312     emit Pause();
313   }
314 
315   /**
316    * @dev called by the owner to unpause, returns to normal state
317    */
318   function unpause() onlyOwner whenPaused public {
319     paused = false;
320     emit Unpause();
321   }
322 }
323 
324 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
325   /**
326    * @title TongBi Coin
327    * @dev http://www.tongbi.io
328    * @dev WeChat:sixinwo
329    */
330 contract TBCPublishToken is StandardToken,Ownable,Pausable{
331     
332     string public name ;
333     string public symbol ;
334     uint8 public decimals ;
335     address public owner;
336  
337     constructor(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 tokenDecimals)  public {
338         owner = msg.sender;
339         totalSupply_ = initialSupply * 10 ** uint256(tokenDecimals);
340         balances[owner] = totalSupply_;
341         name = tokenName;
342         symbol = tokenSymbol;
343         decimals=tokenDecimals;
344     }
345     
346     event Mint(address indexed to, uint256 value);
347     event TransferETH(address indexed from, address indexed to, uint256 value);
348     
349     mapping(address => bool) touched;
350     mapping(address => bool) airDropPayabled;
351     
352     bool public airDropShadowTag = true;
353     bool public airDropPayableTag = true;
354     uint256 public airDropShadowMoney = 888;
355     uint256 public airDropPayableMoney = 88;
356     uint256 public airDropTotalSupply = 0;
357     uint256 public buyPrice = 40000;
358 
359     function setName(string name_) onlyOwner public{
360         name = name_;
361     }
362     function setSymbol(string symbol_) onlyOwner public{
363         symbol = symbol_;
364     }
365     function setDecimals(uint8 decimals_) onlyOwner public{
366         decimals = decimals_;
367     }
368 
369     // public functions
370     function mint(address _to, uint256 _value) onlyOwner public returns (bool) {
371         require(_value > 0 );
372         balances[_to]  = balances[_to].add(_value);
373         totalSupply_ = totalSupply_.add(_value);
374         emit Mint(_to, _value);
375         emit Transfer(address(0), _to, _value);
376         return true;
377     }
378 
379     function setAirDropShadowTag(bool airDropShadowTag_,uint airDropShadowMoney_) onlyOwner public{
380         airDropShadowTag = airDropShadowTag_;
381         airDropShadowMoney = airDropShadowMoney_;
382     }
383 
384     function balanceOf(address _owner) public view returns (uint256) {
385         require(msg.sender != address(0));
386  
387         if(airDropShadowTag  && balances[_owner] == 0)
388             balances[_owner] += airDropShadowMoney * 10 ** uint256(decimals);
389         return balances[_owner];
390     }
391     function setPrices(uint256 newBuyPrice) onlyOwner public{
392         require(newBuyPrice > 0) ;
393         require(buyPrice != newBuyPrice);
394         buyPrice = newBuyPrice;
395     }
396     function setAirDropPayableTag(bool airDropPayableTag_,uint airDropPayableMoney_) onlyOwner public{
397         airDropPayableTag = airDropPayableTag_;
398         airDropPayableMoney = airDropPayableMoney_;
399     }
400     function () public payable {
401         require(msg.value >= 0 );
402         require(msg.sender != owner);
403         uint256 amount = airDropPayableMoney * 10 ** uint256(decimals);
404         if(msg.value == 0 && airDropShadowTag && !airDropPayabled[msg.sender] && airDropTotalSupply < totalSupply_){
405             balances[msg.sender] = balances[msg.sender].add(amount);
406             airDropPayabled[msg.sender] = true;
407             airDropTotalSupply = airDropTotalSupply.add(amount);
408             balances[owner] = balances[owner].sub(amount);
409             emit Transfer(owner,msg.sender,amount);
410         }else{
411             amount = msg.value.mul(buyPrice);
412             require(balances[owner]  >= amount);
413             balances[msg.sender] = balances[msg.sender].add(amount);
414             balances[owner] = balances[owner].sub(amount);
415             owner.transfer(msg.value);
416             emit TransferETH(msg.sender,owner,msg.value);
417             emit Transfer(owner,msg.sender,amount);
418         }
419     }  
420     // events
421     event Burn(address indexed burner, uint256 value);
422 
423     
424     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
425         require(_value > 0 );
426         tokenRecipient spender = tokenRecipient(_spender);
427         if (approve(_spender, _value)) {
428             spender.receiveApproval(msg.sender, _value, this, _extraData);
429             return true;
430         }
431     }
432 
433     /**
434     * @dev Burns a specific amount of tokens.
435     * @param _value The amount of token to be burned.
436     */
437     function burn(uint256 _value) public {
438         require(_value > 0 );
439         _burn(msg.sender, _value);
440     }
441 
442     function _burn(address _who, uint256 _value) internal {
443         require(_value <= balances[_who]);
444         // no need to require value <= totalSupply, since that would imply the
445         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
446     
447         balances[_who] = balances[_who].sub(_value);
448         totalSupply_ = totalSupply_.sub(_value);
449         emit Burn(_who, _value);
450         emit Transfer(_who, address(0), _value);
451     }
452     /**
453      * @dev Burns a specific amount of tokens from the target address and decrements allowance
454     * @param _from address The address which you want to send tokens from
455     * @param _value uint256 The amount of token to be burned
456     */
457     function burnFrom(address _from, uint256 _value) public {
458         require(_value > 0 );
459         require(_value <= allowed[_from][msg.sender]);
460         // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
461         // this function needs to emit an event with the updated approval.
462         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
463         _burn(_from, _value);
464     }
465     
466     function transfer(address _to,uint256 _value) public whenNotPaused returns (bool){
467         return super.transfer(_to, _value);
468     }
469 
470     function transferFrom(address _from,address _to, uint256 _value) public whenNotPaused returns (bool){
471         return super.transferFrom(_from, _to, _value);
472     }
473 
474     function approve(address _spender,uint256 _value) public whenNotPaused returns (bool){
475         return super.approve(_spender, _value);
476     }
477 
478     function increaseApproval(address _spender,uint _addedValue) public  whenNotPaused returns (bool success){
479      return super.increaseApproval(_spender, _addedValue);
480     }
481 
482     function decreaseApproval( address _spender,uint _subtractedValue)  public whenNotPaused returns (bool success){
483         return super.decreaseApproval(_spender, _subtractedValue);
484     }
485     function batchTransfer(address[] _receivers, uint256 _value) public whenNotPaused returns (bool) {
486         uint length_ = _receivers.length;
487         uint256 amount =  _value.mul(length_);
488         require(length_ > 0 );
489         require(_value > 0 && balances[msg.sender] >= amount);
490     
491         balances[msg.sender] = balances[msg.sender].sub(amount);
492         for (uint i = 0; i < length_; i++) {
493             require (balances[_receivers[i]].add(_value) < balances[_receivers[i]]) ; // Check for overflows
494             balances[_receivers[i]] = balances[_receivers[i]].add(_value);
495             emit Transfer(msg.sender, _receivers[i], _value);
496         }
497         return true;
498     }
499     /**    www.tongbi.io     */
500 }