1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint);
10   function balanceOf(address who) public view returns (uint);
11   function transfer(address to, uint value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) public view returns (uint);
21   function transferFrom(address from, address to, uint value) public returns (bool);
22   function approve(address spender, uint value) public returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint value);
24 }
25 
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31 
32   /**
33   * @dev Multiplies two numbers, throws on overflow.
34   */
35   function mul(uint a, uint b) internal pure returns (uint c) {
36     if (a == 0) {
37       return 0;
38     }
39     c = a * b;
40     assert(c / a == b);
41     return c;
42   }
43 
44   /**
45   * @dev Integer division of two numbers, truncating the quotient.
46   */
47   function div(uint a, uint b) internal pure returns (uint) {
48     // assert(b > 0); // Solidity automatically throws when dividing by 0
49     // uint c = a / b;
50     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
51     return a / b;
52   }
53 
54   /**
55   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
56   */
57   function sub(uint a, uint b) internal pure returns (uint) {
58     assert(b <= a);
59     return a - b;
60   }
61 
62   /**
63   * @dev Adds two numbers, throws on overflow.
64   */
65   function add(uint a, uint b) internal pure returns (uint c) {
66     c = a + b;
67     assert(c >= a);
68     return c;
69   }
70 }
71 
72 /**
73  * @title Basic token
74  * @dev Basic version of StandardToken, with no allowances.
75  */
76 contract BasicToken is ERC20Basic {
77   using SafeMath for uint;
78 
79   mapping(address => uint) balances;
80 
81   uint totalSupply_;
82 
83   /**
84   * @dev total number of tokens in existence
85   */
86   function totalSupply() public view returns (uint) {
87     return totalSupply_;
88   }
89 
90   /**
91   * @dev transfer token for a specified address
92   * @param _to The address to transfer to.
93   * @param _value The amount to be transferred.
94   */
95   function transfer(address _to, uint _value) public returns (bool) {
96     require(_to != address(0));
97     require(_value <= balances[msg.sender]);
98 
99     balances[msg.sender] = balances[msg.sender].sub(_value);
100     balances[_to] = balances[_to].add(_value);
101     emit Transfer(msg.sender, _to, _value);
102     return true;
103   }
104 
105   /**
106   * @dev Gets the balance of the specified address.
107   * @param _owner The address to query the the balance of.
108   * @return An uint representing the amount owned by the passed address.
109   */
110   function balanceOf(address _owner) public view returns (uint) {
111     return balances[_owner];
112   }
113 
114 }
115 
116 /**
117  * @title Standard ERC20 token
118  *
119  * @dev Implementation of the basic standard token.
120  * @dev https://github.com/ethereum/EIPs/issues/20
121  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
122  */
123 /**
124  * @title Standard ERC20 token
125  *
126  * @dev Implementation of the basic standard token.
127  * @dev https://github.com/ethereum/EIPs/issues/20
128  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
129  */
130 contract StandardToken is ERC20, BasicToken {
131 
132   mapping (address => mapping (address => uint)) internal allowed;
133 
134 
135   /**
136    * @dev Transfer tokens from one address to another
137    * @param _from address The address which you want to send tokens from
138    * @param _to address The address which you want to transfer to
139    * @param _value uint the amount of tokens to be transferred
140    */
141   function transferFrom(address _from, address _to, uint _value) public returns (bool) {
142     require(_to != address(0));
143     require(_value <= balances[_from]);
144     require(_value <= allowed[_from][msg.sender]);
145 
146     balances[_from] = balances[_from].sub(_value);
147     balances[_to] = balances[_to].add(_value);
148     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
149     emit Transfer(_from, _to, _value);
150     return true;
151   }
152 
153   /**
154    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
155    *
156    * Beware that changing an allowance with this method brings the risk that someone may use both the old
157    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
158    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
159    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
160    * @param _spender The address which will spend the funds.
161    * @param _value The amount of tokens to be spent.
162    */
163   function approve(address _spender, uint _value) public returns (bool) {
164     allowed[msg.sender][_spender] = _value;
165     emit Approval(msg.sender, _spender, _value);
166     return true;
167   }
168 
169   /**
170    * @dev Function to check the amount of tokens that an owner allowed to a spender.
171    * @param _owner address The address which owns the funds.
172    * @param _spender address The address which will spend the funds.
173    * @return A uint specifying the amount of tokens still available for the spender.
174    */
175   function allowance(address _owner, address _spender) public view returns (uint) {
176     return allowed[_owner][_spender];
177   }
178 
179   /**
180    * @dev Increase the amount of tokens that an owner allowed to a spender.
181    *
182    * approve should be called when allowed[_spender] == 0. To increment
183    * allowed value is better to use this function to avoid 2 calls (and wait until
184    * the first transaction is mined)
185    * From MonolithDAO Token.sol
186    * @param _spender The address which will spend the funds.
187    * @param _addedValue The amount of tokens to increase the allowance by.
188    */
189   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
190     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
191     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
192     return true;
193   }
194 
195   /**
196    * @dev Decrease the amount of tokens that an owner allowed to a spender.
197    *
198    * approve should be called when allowed[_spender] == 0. To decrement
199    * allowed value is better to use this function to avoid 2 calls (and wait until
200    * the first transaction is mined)
201    * From MonolithDAO Token.sol
202    * @param _spender The address which will spend the funds.
203    * @param _subtractedValue The amount of tokens to decrease the allowance by.
204    */
205   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
206     uint oldValue = allowed[msg.sender][_spender];
207     if (_subtractedValue > oldValue) {
208       allowed[msg.sender][_spender] = 0;
209     } else {
210       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
211     }
212     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
213     return true;
214   }
215 
216 }
217 /**
218  * @title Ownable
219  * @dev The Ownable contract has an owner address, and provides basic authorization control
220  * functions, this simplifies the implementation of "user permissions".
221  */
222 contract Ownable {
223     
224   address public owner;
225 
226   /**
227    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
228    * account.
229    */
230   function Ownable() public {
231     owner = msg.sender;
232   }
233 
234   /**
235    * @dev Throws if called by any account other than the owner.
236    */
237   modifier onlyOwner() {
238     require(msg.sender == owner);
239     _;
240   }
241 
242   /**
243    * @dev Allows the current owner to transfer control of the contract to a newOwner.
244    * @param newOwner The address to transfer ownership to.
245    */
246   function transferOwnership(address newOwner) onlyOwner public {
247     require(newOwner != address(0));      
248     owner = newOwner;
249   }
250 
251 }
252 
253 /**
254  * @title Mintable token
255  * @dev Simple ERC20 Token example, with mintable token creation
256  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
257  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
258  */
259 contract MintableToken is StandardToken, Ownable {
260   event Mint(address indexed to, uint amount);
261   event MintFinished();
262 
263   bool public mintingFinished = false;
264 
265 
266   modifier canMint() {
267     require(!mintingFinished);
268     _;
269   }
270 
271   /**
272    * @dev Function to mint tokens
273    * @param _to The address that will receive the minted tokens.
274    * @param _amount The amount of tokens to mint.
275    * @return A boolean that indicates if the operation was successful.
276    */
277   function mint(address _to, uint _amount) onlyOwner canMint public returns (bool) {
278     totalSupply_ = totalSupply_.add(_amount);
279     balances[_to] = balances[_to].add(_amount);
280     emit Mint(_to, _amount);
281     emit Transfer(address(0), _to, _amount);
282     return true;
283   }
284 
285   /**
286    * @dev Function to stop minting new tokens.
287    * @return True if the operation was successful.
288    */
289   function finishMinting() onlyOwner canMint public returns (bool) {
290     mintingFinished = true;
291     emit MintFinished();
292     return true;
293   }
294 }
295 
296 contract RobotarTestToken is MintableToken {
297     
298   // Constants
299   // =========
300   
301     string public constant name = "Robotar token";
302     
303     string public constant symbol = "TTAR";
304     
305     uint32 public constant decimals = 18;
306     
307     // Tokens are frozen until ICO ends.
308     
309     bool public frozen = true;
310     
311     
312   address public ico;
313   modifier icoOnly { require(msg.sender == ico); _; }
314   
315   
316   // Constructor
317   // ===========
318   
319   function RobotarTestToken(address _ico) public {
320     ico = _ico;
321   }
322   
323     function defrost() external icoOnly {
324     frozen = false;
325   }
326     
327      // ERC20 functions
328   // =========================
329 
330   function transfer(address _to, uint _value)  public returns (bool) {
331     require(!frozen);
332     return super.transfer(_to, _value);
333   }
334 
335 
336   function transferFrom(address _from, address _to, uint _value) public returns (bool) {
337     require(!frozen);
338     return super.transferFrom(_from, _to, _value);
339   }
340 
341 
342   function approve(address _spender, uint _value) public returns (bool) {
343     require(!frozen);
344     return super.approve(_spender, _value);
345   }
346     
347  /**  
348   // Save tokens from contract
349   function withdrawToken(address _tokenContract, address where, uint _value) external icoOnly {
350     ERC20 _token = ERC20(_tokenContract);
351     _token.transfer(where, _value);
352   }
353   */
354   
355   function supplyBezNolei() public view returns(uint) {
356   return totalSupply().div(1 ether);
357   }
358     
359 }
360 
361 
362 contract TestRobotarCrowdsale is Ownable {
363     
364     using SafeMath for uint;
365     
366     address multisig;
367 
368    RobotarTestToken public token = new RobotarTestToken(this);
369 
370 // uint public created_time = now;
371 
372     
373   uint rate = 1000;
374        
375 	uint PresaleStart = 0;
376 	uint CrowdsaleStart = 0;
377 	uint PresalePeriod = 1 days;
378 	uint CrowdsalePeriod = 1 days;
379 	uint public threshold = 1000000000000000;	
380 	
381 	uint bountyPercent = 10;
382 	uint foundationPercent = 50;
383 	uint teamPercent = 40;
384 	
385 	address bounty;
386 	address foundation;
387 	address team;
388 	
389  // Crowdsale constructor
390  
391     function TestRobotarCrowdsale() public {
392         
393 	multisig = owner;	
394 			
395 	      }
396 	      	      
397 	      function setPresaleStart(uint _presaleStart) onlyOwner public returns (bool) {
398 	      PresaleStart = _presaleStart;
399 	 //     require(PresaleStart > now) ;
400 	      return true;
401 	      }
402 	      
403 	       function setCrowdsaleStart(uint _crowdsaleStart)  onlyOwner public returns (bool) {
404 	       CrowdsaleStart = _crowdsaleStart;
405 	 //      require(CrowdsaleStart > now && CrowdsaleStart > PresaleStart + 7 days ) ;
406 	       return true;
407 	       }
408       
409    /**    modifier saleIsOn() {
410 require(now > testStart && now < testEnd || now > PresaleStart && now < PresaleStart + PresalePeriod || now > CrowdsaleStart && now <  CrowdsaleStart + CrowdsalePeriod);
411     	_;
412     } **/
413     
414 
415    function createTokens() public payable  {
416        uint tokens = 0;
417        uint bonusTokens = 0;
418        
419          if (now > PresaleStart && now < PresaleStart + PresalePeriod) {
420        tokens = rate.mul(msg.value);
421         bonusTokens = tokens.div(4);
422         } 
423         else if (now > CrowdsaleStart && now <  CrowdsaleStart + CrowdsalePeriod){
424         tokens = rate.mul(msg.value);
425         
426         if(now < CrowdsaleStart + CrowdsalePeriod/4) {bonusTokens = tokens.mul(15).div(100);}
427         else if(now >= CrowdsaleStart + CrowdsalePeriod/4 && now < CrowdsaleStart + CrowdsalePeriod/2) {bonusTokens = tokens.div(10);} 
428         else if(now >= CrowdsaleStart + CrowdsalePeriod/2 && now < CrowdsaleStart + CrowdsalePeriod*3/4) {bonusTokens = tokens.div(20);}
429         
430         }      
431                  
432         tokens += bonusTokens;
433        if (tokens>0) {token.mint(msg.sender, tokens);}
434     }        
435        
436 
437    function() external payable {
438    if (msg.value >= threshold) createTokens();   
439    
440         }
441    
442        
443     
444    
445     
446     function finishICO(address _team, address _foundation, address _bounty) external onlyOwner {
447 	uint issuedTokenSupply = token.totalSupply();
448 	uint bountyTokens = issuedTokenSupply.mul(bountyPercent).div(100);
449 	uint foundationTokens = issuedTokenSupply.mul(foundationPercent).div(100);
450 	uint teamTokens = issuedTokenSupply.mul(teamPercent).div(100);
451 	bounty = _bounty;
452 	foundation = _foundation;
453 	team = _team;
454 	
455 	token.mint(bounty, bountyTokens);
456 	token.mint(foundation, foundationTokens);
457 	token.mint(team, teamTokens);
458 	
459         token.finishMinting();
460       
461             }
462 
463 function defrost() external onlyOwner {
464 token.defrost();
465 }
466   
467   function withdrawEther(uint _value) external onlyOwner {
468     multisig.transfer(_value);
469   }
470   
471  /**
472       
473   
474   // Save tokens from contract
475   function withdrawToken(address _tokenContract, uint _value) external onlyOwner {
476     ERC20 _token = ERC20(_tokenContract);
477     _token.transfer(multisig, _value);
478   }
479   function withdrawTokenFromTAR(address _tokenContract, uint _value) external onlyOwner {
480     token.withdrawToken(_tokenContract, multisig, _value);
481   }
482   
483 //the end    
484   */
485 }