1 pragma solidity 0.4.24;
2 
3 contract ERC20 {
4  // modifiers
5 
6  // mitigate short address attack
7  // thanks to https://github.com/numerai/contract/blob/c182465f82e50ced8dacb3977ec374a892f5fa8c/contracts/Safe.sol#L30-L34.
8  // TODO: doublecheck implication of >= compared to ==
9     modifier onlyPayloadSize(uint numWords) {
10         assert(msg.data.length >= numWords * 32 + 4);
11         _;
12     }
13 
14     uint256 public totalSupply;
15     /*
16       *  Public functions
17       */
18     function balanceOf(address who) public view returns (uint256);
19     function transfer(address to, uint256 value) public returns (bool);
20 
21     function allowance(address owner, address spender) public view returns (uint256);
22     function transferFrom(address from, address to, uint256 value) public returns (bool);
23     function approve(address spender, uint256 value) public returns (bool);
24 
25     /*
26       *  Events
27       */
28     event Transfer(address indexed from, address indexed to, uint256 value);
29     event Approval(address indexed owner, address indexed spender, uint256 value);
30     event Burn(address indexed from, uint256 value);
31     event SaleContractActivation(address saleContract, uint256 tokensForSale);
32 }
33 /**
34  * @title SafeMath
35  * @dev Math operations with safety checks that throw on error
36  */
37 library SafeMath {
38   // it is recommended to define functions which can neither read the state of blockchain nor write in it as pure instead of constant
39 
40   /**
41   * @dev Multiplies two numbers, throws on overflow.
42   */
43     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
44         if (a == 0) {
45             return 0;
46         }
47         uint256 c = a * b;
48         assert(c / a == b);
49         return c;
50     }
51 
52     /**
53     * @dev Integer division of two numbers, truncating the quotient.
54     */
55     function div(uint256 a, uint256 b) internal pure returns (uint256) {
56         // assert(b > 0); // Solidity automatically throws when dividing by 0
57         // uint256 c = a / b;
58         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59         return a / b;
60     }
61 
62     /**
63     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
64     */
65     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
66         assert(b <= a);
67         return a - b;
68     }
69 
70     /**
71     * @dev Adds two numbers, throws on overflow.
72     */
73     function add(uint256 a, uint256 b) internal pure returns (uint256) {
74         uint256 c = a + b;
75         assert(c >= a);
76         return c;
77     }
78 
79 }
80 
81 /**
82  * @title Ownable
83  * @dev The Ownable contract has an owner address, and provides basic authorization control
84  * functions, this simplifies the implementation of "user permissions".
85  */
86 
87 contract Ownable {
88     address public owner;
89     address public creater;
90 
91     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
92 
93     /**
94     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
95     * account.
96     */
97     function Ownable(address _owner) public {
98         creater = msg.sender;
99         if (_owner != 0) {
100             owner = _owner;
101 
102         }
103         else {
104             owner = creater;
105         }
106 
107     }
108     /**
109     * @dev Throws if called by any account other than the owner.
110     */
111 
112     modifier onlyOwner() {
113         require(msg.sender == owner);
114         _;
115     }
116 
117     modifier isCreator() {
118         require(msg.sender == creater);
119         _;
120     }
121 
122    
123 
124 }
125 
126 
127 
128 
129 
130 
131 /**
132  * @title Standard ERC20 token
133  *
134  * @dev Implementation of the basic standard token.
135  * @dev https://github.com/ethereum/EIPs/issues/20
136  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
137  */
138 contract StandardToken is ERC20 {
139     using SafeMath for uint256;
140     mapping (address => mapping (address => uint256)) internal allowed;
141     mapping(address => uint256) balances;
142 
143   /// @dev Returns number of tokens owned by given address
144   /// @param _owner Address of token owner
145   /// @return Balance of owner
146 
147   // it is recommended to define functions which can read the state of blockchain but cannot write in it as view instead of constant
148 
149     function balanceOf(address _owner) public view returns (uint256) {
150         return balances[_owner];
151     }
152 
153   /// @dev Transfers sender's tokens to a given address. Returns success
154   /// @param _to Address of token receiver
155   /// @param _value Number of tokens to transfer
156   /// @return Was transfer successful?
157 
158     function transfer(address _to, uint256 _value) public onlyPayloadSize(2) returns (bool success) {
159         if (balances[msg.sender] >= _value && _value > 0 && balances[_to].add(_value) > balances[_to]) {
160             balances[msg.sender] = balances[msg.sender].sub(_value);
161             balances[_to] = balances[_to].add(_value);
162             emit Transfer(msg.sender, _to, _value); // solhint-disable-line
163             return true;
164         } else {
165             return false;
166         }
167     }
168 
169     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success
170     /// @param _from Address from where tokens are withdrawn
171     /// @param _to Address to where tokens are sent
172     /// @param _value Number of tokens to transfer
173     /// @return Was transfer successful?
174 
175     function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3) returns (bool) {
176         require(_to != address(0));
177         require(_value <= balances[_from]);
178         require(_value <= allowed[_from][msg.sender]);
179 
180         balances[_from] = balances[_from].sub(_value);
181         balances[_to] = balances[_to].add(_value);
182         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
183         emit Transfer(_from, _to, _value); // solhint-disable-line
184         return true;
185     }
186 
187   /**
188    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
189    *
190    * Beware that changing an allowance with this method brings the risk that someone may use both the old
191    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
192    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
193    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
194    * @param _spender The address which will spend the funds.
195    * @param _value The amount of tokens to be spent.
196    */
197 
198 
199     function approve(address _spender, uint256 _value) public onlyPayloadSize(2) returns (bool) {
200       // To change the approve amount you first have to reduce the addresses`
201       //  allowance to zero by calling `approve(_spender, 0)` if it is not
202       //  already 0 to mitigate the race condition described here:
203       //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
204 
205         require(_value == 0 && (allowed[msg.sender][_spender] == 0));
206         allowed[msg.sender][_spender] = _value;
207         emit Approval(msg.sender, _spender, _value); // solhint-disable-line
208         return true;
209     }
210 
211     function changeApproval(address _spender, uint256 _oldValue, uint256 _newValue) public onlyPayloadSize(3) returns (bool success) {
212         require(allowed[msg.sender][_spender] == _oldValue);
213         allowed[msg.sender][_spender] = _newValue;
214         emit Approval(msg.sender, _spender, _newValue); // solhint-disable-line
215         return true;
216     }
217 
218   /**
219    * @dev Function to check the amount of tokens that an owner allowed to a spender.
220    * @param _owner address The address which owns the funds.
221    * @param _spender address The address which will spend the funds.
222    * @return A uint256 specifying the amount of tokens still available for the spender.
223    */
224     function allowance(address _owner, address _spender) public view returns (uint256) {
225         return allowed[_owner][_spender];
226     }
227 
228  /**
229   * @dev Burns a specific amount of tokens.
230   * @param _value The amount of token to be burned.
231   */
232     function burn(uint256 _value) public returns (bool burnSuccess) {
233         require(_value > 0);
234         require(_value <= balances[msg.sender]);
235         // no need to require value <= totalSupply, since that would imply the
236         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
237 
238         address burner = msg.sender;
239         balances[burner] = balances[burner].sub(_value);
240         totalSupply = totalSupply.sub(_value);
241         emit Burn(burner, _value); // solhint-disable-line
242         return true;
243     }
244 
245 }
246 contract TravelHelperToken is StandardToken, Ownable {
247 
248 
249 //Begin: state variables
250     address public saleContract;
251     string public constant name = "TravelHelperToken";
252     string public constant symbol = "TRH";
253     uint public constant decimals = 18;
254     bool public fundraising = true;
255     uint public totalReleased = 0;
256     address public teamAddressOne;
257     address public teamAddressTwo;
258     address public marketingAddress;
259     address public advisorsAddress;
260     address public teamAddressThree;
261     uint public icoStartBlock;
262     uint256 public tokensUnlockPeriod = 37 days / 15; // 7 days presale + 30 days crowdsale
263     uint public tokensSupply = 5000000000; // 5 billion
264     uint public teamTokens = 1480000000 * 1 ether; // 1.48 billion
265     uint public teamAddressThreeTokens = 20000000 * 1 ether; // 20 million
266     uint public marketingTeamTokens = 500000000 * 1 ether; // 500 million
267     uint public advisorsTokens = 350000000 * 1 ether; // 350 million
268     uint public bountyTokens = 150000000 * 1 ether; //150 million
269      uint public tokensForSale = 2500000000 * 1 ether; // 2.5 billion
270     uint public releasedTeamTokens = 0;
271     uint public releasedAdvisorsTokens = 0;
272     uint public releasedMarketingTokens = 0;
273     bool public tokensLocked = true;
274     Ownable ownable;
275     mapping (address => bool) public frozenAccounts;
276    
277  //End: state variables
278  //Begin: events
279     event FrozenFund(address target, bool frozen);
280     event PriceLog(string text);
281 //End: events
282 
283 //Begin: modifiers
284 
285 
286     modifier manageTransfer() {
287         if (msg.sender == owner) {
288             _;
289         }
290         else {
291             require(fundraising == false);
292             _;
293         }
294     }
295     
296     modifier tokenNotLocked() {
297       if (icoStartBlock > 0 && block.number.sub(icoStartBlock) > tokensUnlockPeriod) {
298         tokensLocked = false;
299         _;
300       } else {
301         revert();
302       }
303     
304   }
305 
306 //End: modifiers
307 
308 //Begin: constructor
309     function TravelHelperToken(
310     address _tokensOwner,
311     address _teamAddressOne,
312     address _teamAddressTwo,
313     address _marketingAddress,
314     address _advisorsAddress,
315     address _teamAddressThree) public Ownable(_tokensOwner) {
316         require(_tokensOwner != 0x0);
317         require(_teamAddressOne != 0x0);
318         require(_teamAddressTwo != 0x0);
319         teamAddressOne = _teamAddressOne;
320         teamAddressTwo = _teamAddressTwo;
321         advisorsAddress = _advisorsAddress;
322         marketingAddress = _marketingAddress;
323         teamAddressThree = _teamAddressThree;
324         totalSupply = tokensSupply * (uint256(10) ** decimals);
325 
326     }
327 
328    
329 
330 //End: constructor
331 
332     
333 
334 //Begin: overriden methods
335 
336     function transfer(address _to, uint256 _value) public manageTransfer onlyPayloadSize(2) returns (bool success) {
337         require(_to != address(0));
338         require(!frozenAccounts[msg.sender]);
339         super.transfer(_to,_value);
340         return true;
341     }
342 
343     function transferFrom(address _from, address _to, uint256 _value)
344         public
345         manageTransfer
346         onlyPayloadSize(3) returns (bool)
347     {
348         require(_to != address(0));
349         require(_from != address(0));
350         require(!frozenAccounts[msg.sender]);
351         super.transferFrom(_from,_to,_value);
352         return true;
353 
354     }
355 
356 
357 
358 //End: overriden methods
359 
360 
361 //Being: setters
362    
363     function activateSaleContract(address _saleContract) public onlyOwner {
364     require(tokensForSale > 0);
365     require(teamTokens > 0);
366     require(_saleContract != address(0));
367     require(saleContract == address(0));
368     saleContract = _saleContract;
369     uint  totalValue = teamTokens.mul(50).div(100);
370     balances[teamAddressOne] = balances[teamAddressOne].add(totalValue);
371     balances[teamAddressTwo] = balances[teamAddressTwo].add(totalValue);
372     balances[advisorsAddress] = balances[advisorsAddress].add(advisorsTokens);
373     balances[teamAddressThree] = balances[teamAddressThree].add(teamAddressThreeTokens);
374     balances[marketingAddress] = balances[marketingAddress].add(marketingTeamTokens);
375     releasedTeamTokens = releasedTeamTokens.add(teamTokens);
376     releasedAdvisorsTokens = releasedAdvisorsTokens.add(advisorsTokens);
377     releasedMarketingTokens = releasedMarketingTokens.add(marketingTeamTokens);
378     balances[saleContract] = balances[saleContract].add(tokensForSale);
379     totalReleased = totalReleased.add(tokensForSale).add(teamTokens).add(advisorsTokens).add(teamAddressThreeTokens).add(marketingTeamTokens);
380     tokensForSale = 0; 
381     teamTokens = 0; 
382     teamAddressThreeTokens = 0;
383     icoStartBlock = block.number;
384     assert(totalReleased <= totalSupply);
385     emit Transfer(address(this), teamAddressOne, totalValue);
386     emit Transfer(address(this), teamAddressTwo, totalValue);
387     emit Transfer(address(this),teamAddressThree,teamAddressThreeTokens);
388     emit Transfer(address(this), saleContract, 2500000000 * 1 ether);
389     emit SaleContractActivation(saleContract, 2500000000 * 1 ether);
390   }
391   
392  function saleTransfer(address _to, uint256 _value) public returns (bool) {
393     require(saleContract != address(0));
394     require(msg.sender == saleContract);
395     return super.transfer(_to, _value);
396   }
397   
398   
399   function burnTokensForSale() public returns (bool) {
400     require(saleContract != address(0));
401     require(msg.sender == saleContract);
402     uint256 tokens = balances[saleContract];
403     require(tokens > 0);
404     require(tokens <= totalSupply);
405     balances[saleContract] = 0;
406     totalSupply = totalSupply.sub(tokens);
407     emit Burn(saleContract, tokens);
408     return true;
409   }
410   
411    
412  
413     
414 
415     function finalize() public {
416         require(fundraising != false);
417         require(msg.sender == saleContract);
418         // Switch to Operational state. This is the only place this can happen.
419         fundraising = false;
420     }
421 
422    function freezeAccount (address target, bool freeze) public onlyOwner {
423         require(target != 0x0);
424         require(freeze == (true || false));
425         frozenAccounts[target] = freeze;
426         emit FrozenFund(target, freeze); // solhint-disable-line
427     }
428     
429     function sendBounty(address _to, uint256 _value) public onlyOwner returns (bool) {
430     uint256 value = _value.mul(1 ether);
431     require(bountyTokens >= value);
432     totalReleased = totalReleased.add(value);
433     require(totalReleased <= totalSupply);
434     balances[_to] = balances[_to].add(value);
435     bountyTokens = bountyTokens.sub(value);
436     emit Transfer(address(this), _to, value);
437     return true;
438   }
439  /**
440     * @dev Allows the current owner to transfer control of the contract to a newOwner.
441     * @param newOwner The address to transfer ownership to.
442     */
443     function transferOwnership(address newOwner) onlyOwner public  {
444         owner = newOwner;
445         emit OwnershipTransferred(owner, newOwner); // solhint-disable-line
446         
447     }
448 //End: setters
449    
450     function() public {
451         revert();
452     }
453 
454 }