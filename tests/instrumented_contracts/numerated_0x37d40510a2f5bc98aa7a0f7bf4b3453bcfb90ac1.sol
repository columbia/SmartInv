1 pragma solidity 0.4.18;
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
50 
51 
52 /**
53  * @title Basic token
54  * @dev Basic version of StandardToken, with no allowances.
55  */
56 
57 /**
58  * @title ERC20Basic
59  * @dev Simpler version of ERC20 interface
60  * @dev see https://github.com/ethereum/EIPs/issues/179
61  */
62 contract ERC20Basic {
63   function totalSupply() public view returns (uint256);
64   function balanceOf(address who) public view returns (uint256);
65   function transfer(address to, uint256 value) public returns (bool);
66   event Transfer(address indexed from, address indexed to, uint256 value);
67 }
68 
69 
70 /**
71  * @title ERC20 interface
72  * @dev see https://github.com/ethereum/EIPs/issues/20
73  */
74 contract ERC20 is ERC20Basic {
75   function allowance(address owner, address spender) public view returns (uint256);
76   function transferFrom(address from, address to, uint256 value) public returns (bool);
77   function approve(address spender, uint256 value) public returns (bool);
78   event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 
82 
83 contract BasicToken is ERC20Basic {
84   using SafeMath for uint256;
85 
86   mapping(address => uint256) balances;
87 
88   uint256 totalSupply_;
89 
90   /**
91   * @dev total number of tokens in existence
92   */
93   function totalSupply() public view returns (uint256) {
94     return totalSupply_;
95   }
96 
97   /**
98   * @dev transfer token for a specified address
99   * @param _to The address to transfer to.
100   * @param _value The amount to be transferred.
101   */
102   function transfer(address _to, uint256 _value) public returns (bool) {
103     require(_to != address(0));
104     require(_value <= balances[msg.sender]);
105 
106     // SafeMath.sub will throw if there is not enough balance.
107     balances[msg.sender] = balances[msg.sender].sub(_value);
108     balances[_to] = balances[_to].add(_value);
109     Transfer(msg.sender, _to, _value);
110     return true;
111   }
112 
113   /**
114   * @dev Gets the balance of the specified address.
115   * @param _owner The address to query the the balance of.
116   * @return An uint256 representing the amount owned by the passed address.
117   */
118   function balanceOf(address _owner) public view returns (uint256 balance) {
119     return balances[_owner];
120   }
121 
122 }
123 
124 
125 /**
126  * @title Standard ERC20 token
127  *
128  * @dev Implementation of the basic standard token.
129  * @dev https://github.com/ethereum/EIPs/issues/20
130  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
131  */
132 contract StandardToken is ERC20, BasicToken {
133 
134   mapping (address => mapping (address => uint256)) internal allowed;
135 
136 
137   /**
138    * @dev Transfer tokens from one address to another
139    * @param _from address The address which you want to send tokens from
140    * @param _to address The address which you want to transfer to
141    * @param _value uint256 the amount of tokens to be transferred
142    */
143   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
144     require(_to != address(0));
145     require(_value <= balances[_from]);
146     require(_value <= allowed[_from][msg.sender]);
147 
148     balances[_from] = balances[_from].sub(_value);
149     balances[_to] = balances[_to].add(_value);
150     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
151     Transfer(_from, _to, _value);
152     return true;
153   }
154 
155   /**
156    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
157    *
158    * Beware that changing an allowance with this method brings the risk that someone may use both the old
159    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
160    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
161    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
162    * @param _spender The address which will spend the funds.
163    * @param _value The amount of tokens to be spent.
164    */
165   function approve(address _spender, uint256 _value) public returns (bool) {
166     allowed[msg.sender][_spender] = _value;
167     Approval(msg.sender, _spender, _value);
168     return true;
169   }
170 
171   /**
172    * @dev Function to check the amount of tokens that an owner allowed to a spender.
173    * @param _owner address The address which owns the funds.
174    * @param _spender address The address which will spend the funds.
175    * @return A uint256 specifying the amount of tokens still available for the spender.
176    */
177   function allowance(address _owner, address _spender) public view returns (uint256) {
178     return allowed[_owner][_spender];
179   }
180 
181   /**
182    * @dev Increase the amount of tokens that an owner allowed to a spender.
183    *
184    * approve should be called when allowed[_spender] == 0. To increment
185    * allowed value is better to use this function to avoid 2 calls (and wait until
186    * the first transaction is mined)
187    * From MonolithDAO Token.sol
188    * @param _spender The address which will spend the funds.
189    * @param _addedValue The amount of tokens to increase the allowance by.
190    */
191   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
192     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
193     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
194     return true;
195   }
196 
197   /**
198    * @dev Decrease the amount of tokens that an owner allowed to a spender.
199    *
200    * approve should be called when allowed[_spender] == 0. To decrement
201    * allowed value is better to use this function to avoid 2 calls (and wait until
202    * the first transaction is mined)
203    * From MonolithDAO Token.sol
204    * @param _spender The address which will spend the funds.
205    * @param _subtractedValue The amount of tokens to decrease the allowance by.
206    */
207   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
208     uint oldValue = allowed[msg.sender][_spender];
209     if (_subtractedValue > oldValue) {
210       allowed[msg.sender][_spender] = 0;
211     } else {
212       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
213     }
214     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
215     return true;
216   }
217 
218 }
219 
220 
221 contract BBIToken is StandardToken {
222 
223     string  public constant name    = "Beluga Banking Infrastructure Token";
224     string  public constant symbol  = "BBI";
225     uint256 public constant decimals= 18;   
226     
227     uint  public totalUsed   = 0;
228     uint  public etherRaised = 0;
229 
230     /*
231     *   ICO     : 01-Mar-2018 00:00:00 GMT - 31-Mar-2018 23:59:59 GMT
232     */
233 
234     uint public icoEndDate        = 1522540799;   // 31-Mar-2018 23:59:59 GMT  
235     uint constant SECONDS_IN_YEAR = 31536000;     // 365 * 24 * 60 * 60 secs
236 
237     // flag for emergency stop or start 
238     bool public halted = false;              
239     
240     uint  public etherCap               =  30000 * (10 ** uint256(decimals));  // 30,000 Ether
241 
242     uint  public maxAvailableForSale    =  29800000 * (10 ** uint256(decimals));      // ( 29.8M ) 
243     uint  public tokensPreSale          =  10200000 * (10 ** uint256(decimals));      // ( 10.2M ) 
244     uint  public tokensTeam             =  30000000 * (10 ** uint256(decimals));      // ( 30M )
245     uint  public tokensCommunity        =   5000000 * (10 ** uint256(decimals));      // ( 5M )
246     uint  public tokensMasterNodes      =   5000000 * (10 ** uint256(decimals));      // ( 5M )
247     uint  public tokensBankPartners     =   5000000 * (10 ** uint256(decimals));      // ( 5M ) 
248     uint  public tokensDataProviders    =   5000000 * (10 ** uint256(decimals));      // ( 5M )
249 
250    /* 
251    * team classification flag
252    * for defining the lock period 
253    */ 
254 
255    uint constant teamInternal = 1;   // team and community
256    uint constant teamPartners = 2;   // bank partner, data providers etc
257    uint constant icoInvestors = 3;   // ico investors
258 
259     /*  
260     *  Addresses  
261     */
262 
263     address public addressETHDeposit       = 0x0D2b5B427E0Bd97c71D4DF281224540044D279E1;  
264     address public addressTeam             = 0x7C898F01e85a5387D58b52C6356B5AE0D5aa48ba;   
265     address public addressCommunity        = 0xB7218D5a1f1b304E6bD69ea35C93BA4c1379FA43;  
266     address public addressBankPartners     = 0xD5BC3c2894af7CB046398257df7A447F44b0CcA1;  
267     address public addressDataProviders    = 0x9f6fce8c014210D823FdFFA274f461BAdC279A42;  
268     address public addressMasterNodes      = 0x8ceA6dABB68bc9FCD6982E537A16bC9D219605b0;  
269     address public addressPreSale          = 0x2526082305FdB4B999340Db3D53bD2a60F674101;     
270     address public addressICOManager       = 0xE5B3eF1fde3761225C9976EBde8D67bb54d7Ae17;
271 
272 
273     /*
274     * Contract Constructor
275     */
276 
277     function BBIToken() public {
278             
279                      totalSupply_ = 90000000 * (10 ** uint256(decimals));    // 90,000,000 - 90M;                 
280 
281                      balances[addressTeam] = tokensTeam;
282                      balances[addressCommunity] = tokensCommunity;
283                      balances[addressBankPartners] = tokensBankPartners;
284                      balances[addressDataProviders] = tokensDataProviders;
285                      balances[addressMasterNodes] = tokensMasterNodes;
286                      balances[addressPreSale] = tokensPreSale;
287                      balances[addressICOManager] = maxAvailableForSale;
288                      
289                      Transfer(this, addressTeam, tokensTeam);
290                      Transfer(this, addressCommunity, tokensCommunity);
291                      Transfer(this, addressBankPartners, tokensBankPartners);
292                      Transfer(this, addressDataProviders, tokensDataProviders);
293                      Transfer(this, addressMasterNodes, tokensMasterNodes);
294                      Transfer(this, addressPreSale, tokensPreSale);
295                      Transfer(this, addressICOManager, maxAvailableForSale);
296                  
297             }
298     
299     /*
300     *   Emergency Stop or Start ICO.
301     */
302 
303     function  halt() onlyManager public{
304         require(msg.sender == addressICOManager);
305         halted = true;
306     }
307 
308     function  unhalt() onlyManager public {
309         require(msg.sender == addressICOManager);
310         halted = false;
311     }
312 
313     /*
314     *   Check whether ICO running or not.
315     */
316 
317     modifier onIcoRunning() {
318         // Checks, if ICO is running and has not been stopped
319         require( halted == false);
320         _;
321     }
322    
323     modifier onIcoStopped() {
324         // Checks if ICO was stopped or deadline is reached
325       require( halted == true);
326         _;
327     }
328 
329     modifier onlyManager() {
330         // only ICO manager can do this action
331         require(msg.sender == addressICOManager);
332         _;
333     }
334 
335     /*
336      * ERC 20 Standard Token interface transfer function
337      * Prevent transfers until ICO period is over.
338      * 
339      * Transfer 
340      *    - Allow 50% after six months for Community and Team
341      *    - Allow all including (Dataproviders, MasterNodes, Bank) after one year
342      *    - Allow Investors after ICO end date 
343      */
344 
345 
346    function transfer(address _to, uint256 _value) public returns (bool success) 
347     {
348            if ( msg.sender == addressICOManager) { return super.transfer(_to, _value); }           
349 
350            // Team can transfer upto 50% of tokens after six months of ICO end date 
351            if ( !halted &&  msg.sender == addressTeam &&  SafeMath.sub(balances[msg.sender], _value) >= tokensTeam/2 && (now > icoEndDate + SECONDS_IN_YEAR/2) ) 
352                 { return super.transfer(_to, _value); }         
353 
354            // Community can transfer upto 50% of tokens after six months of ICO end date
355            if ( !halted &&  msg.sender == addressCommunity &&  SafeMath.sub(balances[msg.sender], _value) >= tokensCommunity/2 && (now > icoEndDate + SECONDS_IN_YEAR/2) )
356                 { return super.transfer(_to, _value); }            
357            
358            // ICO investors can transfer after the ICO period
359            if ( !halted && identifyAddress(msg.sender) == icoInvestors && now > icoEndDate ) { return super.transfer(_to, _value); }
360            
361            // All can transfer after a year from ICO end date 
362            if ( !halted && now > icoEndDate + SECONDS_IN_YEAR) { return super.transfer(_to, _value); }
363 
364         return false;
365          
366     }
367 
368 
369     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) 
370     {
371            if ( msg.sender == addressICOManager) { return super.transferFrom(_from,_to, _value); }
372 
373            // Team can transfer upto 50% of tokens after six months of ICO end date 
374            if ( !halted &&  msg.sender == addressTeam &&  SafeMath.sub(balances[msg.sender], _value) >= tokensTeam/2 && (now > icoEndDate + SECONDS_IN_YEAR/2) ) 
375                 { return super.transferFrom(_from,_to, _value); }
376            
377            // Community can transfer upto 50% of tokens after six months of ICO end date
378            if ( !halted &&  msg.sender == addressCommunity &&  SafeMath.sub(balances[msg.sender], _value) >= tokensCommunity/2 && (now > icoEndDate + SECONDS_IN_YEAR/2)) 
379                 { return super.transferFrom(_from,_to, _value); }      
380 
381            // ICO investors can transfer after the ICO period
382            if ( !halted && identifyAddress(msg.sender) == icoInvestors && now > icoEndDate ) { return super.transferFrom(_from,_to, _value); }
383 
384            // All can transfer after a year from ICO end date 
385            if ( !halted && now > icoEndDate + SECONDS_IN_YEAR) { return super.transferFrom(_from,_to, _value); }
386 
387         return false;
388     }
389 
390    function identifyAddress(address _buyer) constant public returns(uint) {
391         if (_buyer == addressTeam || _buyer == addressCommunity) return teamInternal;
392         if (_buyer == addressMasterNodes || _buyer == addressBankPartners || _buyer == addressDataProviders) return teamPartners;
393              return icoInvestors;
394     }
395 
396     /**
397      * Destroy tokens
398      * Remove _value tokens from the system irreversibly
399      */
400 
401     function  burn(uint256 _value)  onlyManager public returns (bool success) {
402         require(balances[msg.sender] >= _value);   // Check if the sender has enough BBI
403         balances[msg.sender] -= _value;            // Subtract from the sender
404         totalSupply_ -= _value;                    // Updates totalSupply
405         return true;
406     }
407 
408 
409     /*  
410      *  main function for receiving the ETH from the investors 
411      *  and transferring tokens after calculating the price 
412      */    
413     
414     function buyBBITokens(address _buyer, uint256 _value) internal  {
415             // prevent transfer to 0x0 address
416             require(_buyer != 0x0);
417 
418             // msg value should be more than 0
419             require(_value > 0);
420 
421             // if not halted
422             require(!halted);
423 
424             // Now is before ICO end date 
425             require(now < icoEndDate);
426 
427             // total tokens is price (1ETH = 960 tokens) multiplied by the ether value provided 
428             uint tokens = (SafeMath.mul(_value, 960));
429 
430             // total used + tokens should be less than maximum available for sale
431             require(SafeMath.add(totalUsed, tokens) < balances[addressICOManager]);
432 
433             // Ether raised + new value should be less than the Ether cap
434             require(SafeMath.add(etherRaised, _value) < etherCap);
435             
436             balances[_buyer] = SafeMath.add( balances[_buyer], tokens);
437             balances[addressICOManager] = SafeMath.sub(balances[addressICOManager], tokens);
438             totalUsed += tokens;            
439             etherRaised += _value;  
440       
441             addressETHDeposit.transfer(_value);
442             Transfer(this, _buyer, tokens );
443         }
444 
445      /*
446      *  default fall back function      
447      */
448     function () payable onIcoRunning public {
449                 buyBBITokens(msg.sender, msg.value);           
450             }
451 }