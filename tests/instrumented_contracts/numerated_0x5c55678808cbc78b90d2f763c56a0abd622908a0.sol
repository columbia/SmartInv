1 pragma solidity 0.4.24;
2 
3 // File: contracts/zeppelin/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return a / b;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: contracts/zeppelin/token/ERC20/ERC20Basic.sol
52 
53 /**
54  * @title ERC20Basic
55  * @dev Simpler version of ERC20 interface
56  * @dev see https://github.com/ethereum/EIPs/issues/179
57  */
58 contract ERC20Basic {
59   function totalSupply() public view returns (uint256);
60   function balanceOf(address who) public view returns (uint256);
61   function transfer(address to, uint256 value) public returns (bool);
62   event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 // File: contracts/zeppelin/token/ERC20/BasicToken.sol
66 
67 /**
68  * @title Basic token
69  * @dev Basic version of StandardToken, with no allowances.
70  */
71 contract BasicToken is ERC20Basic {
72   using SafeMath for uint256;
73 
74   mapping(address => uint256) balances;
75 
76   uint256 totalSupply_;
77 
78   /**
79   * @dev total number of tokens in existence
80   */
81   function totalSupply() public view returns (uint256) {
82     return totalSupply_;
83   }
84 
85   /**
86   * @dev transfer token for a specified address
87   * @param _to The address to transfer to.
88   * @param _value The amount to be transferred.
89   */
90   function transfer(address _to, uint256 _value) public returns (bool) {
91     require(_to != address(0));
92     require(_to != address(this));
93     require(_value <= balances[msg.sender]);
94 
95     balances[msg.sender] = balances[msg.sender].sub(_value);
96     balances[_to] = balances[_to].add(_value);
97     emit Transfer(msg.sender, _to, _value);
98     return true;
99   }
100 
101   /**
102   * @dev Gets the balance of the specified address.
103   * @param _owner The address to query the the balance of.
104   * @return An uint256 representing the amount owned by the passed address.
105   */
106   function balanceOf(address _owner) public view returns (uint256 balance) {
107     return balances[_owner];
108   }
109 
110 }
111 
112 // File: contracts/zeppelin/ownership/Ownable.sol
113 
114 /**
115  * @title Ownable
116  * @dev The Ownable contract has an owner address, and provides basic authorization control
117  * functions, this simplifies the implementation of "user permissions".
118  */
119 contract Ownable {
120   address public owner;
121 
122 
123   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
124 
125 
126   /**
127    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
128    * account.
129    */
130   constructor() public {
131     owner = msg.sender;
132   }
133 
134   /**
135    * @dev Throws if called by any account other than the owner.
136    */
137   modifier onlyOwner() {
138     require(msg.sender == owner);
139     _;
140   }
141 
142   /**
143    * @dev Allows the current owner to transfer control of the contract to a newOwner.
144    * @param newOwner The address to transfer ownership to.
145    */
146   function transferOwnership(address newOwner) public onlyOwner {
147     require(newOwner != address(0));
148     emit OwnershipTransferred(owner, newOwner);
149     owner = newOwner;
150   }
151 
152 }
153 
154 // File: contracts/zeppelin/token/ERC20/ERC20.sol
155 
156 /**
157  * @title ERC20 interface
158  * @dev see https://github.com/ethereum/EIPs/issues/20
159  */
160 contract ERC20 is ERC20Basic {
161   function allowance(address owner, address spender) public view returns (uint256);
162   function transferFrom(address from, address to, uint256 value) public returns (bool);
163   function approve(address spender, uint256 value) public returns (bool);
164   event Approval(address indexed owner, address indexed spender, uint256 value);
165 }
166 
167 // File: contracts/zeppelin/token/ERC20/StandardToken.sol
168 
169 /**
170  * @title Standard ERC20 token
171  *
172  * @dev Implementation of the basic standard token.
173  * @dev https://github.com/ethereum/EIPs/issues/20
174  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
175  */
176 contract StandardToken is ERC20, BasicToken {
177 
178   mapping (address => mapping (address => uint256)) internal allowed;
179 
180 
181   /**
182    * @dev Transfer tokens from one address to another
183    * @param _from address The address which you want to send tokens from
184    * @param _to address The address which you want to transfer to
185    * @param _value uint256 the amount of tokens to be transferred
186    */
187   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
188     require(_to != address(0));
189     require(_to != address(this));
190     require(_value <= balances[_from]);
191     require(_value <= allowed[_from][msg.sender]);
192 
193     balances[_from] = balances[_from].sub(_value);
194     balances[_to] = balances[_to].add(_value);
195     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
196     emit Transfer(_from, _to, _value);
197     return true;
198   }
199 
200   /**
201    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
202    *
203    * Beware that changing an allowance with this method brings the risk that someone may use both the old
204    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
205    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
206    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
207    * @param _spender The address which will spend the funds.
208    * @param _value The amount of tokens to be spent.
209    */
210   function approve(address _spender, uint256 _value) public returns (bool) {
211     allowed[msg.sender][_spender] = _value;
212     emit Approval(msg.sender, _spender, _value);
213     return true;
214   }
215 
216   /**
217    * @dev Function to check the amount of tokens that an owner allowed to a spender.
218    * @param _owner address The address which owns the funds.
219    * @param _spender address The address which will spend the funds.
220    * @return A uint256 specifying the amount of tokens still available for the spender.
221    */
222   function allowance(address _owner, address _spender) public view returns (uint256) {
223     return allowed[_owner][_spender];
224   }
225 
226   /**
227    * @dev Increase the amount of tokens that an owner allowed to a spender.
228    *
229    * approve should be called when allowed[_spender] == 0. To increment
230    * allowed value is better to use this function to avoid 2 calls (and wait until
231    * the first transaction is mined)
232    * From MonolithDAO Token.sol
233    * @param _spender The address which will spend the funds.
234    * @param _addedValue The amount of tokens to increase the allowance by.
235    */
236   function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
237     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
238     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
239     return true;
240   }
241 
242   /**
243    * @dev Decrease the amount of tokens that an owner allowed to a spender.
244    *
245    * approve should be called when allowed[_spender] == 0. To decrement
246    * allowed value is better to use this function to avoid 2 calls (and wait until
247    * the first transaction is mined)
248    * From MonolithDAO Token.sol
249    * @param _spender The address which will spend the funds.
250    * @param _subtractedValue The amount of tokens to decrease the allowance by.
251    */
252   function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
253     uint256 oldValue = allowed[msg.sender][_spender];
254     if (_subtractedValue > oldValue) {
255       allowed[msg.sender][_spender] = 0;
256     } else {
257       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
258     }
259     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
260     return true;
261   }
262 
263 }
264 
265 // File: contracts/zeppelin/token/ERC20/MintableToken.sol
266 
267 /**
268  * @title Mintable token
269  * @dev Simple ERC20 Token example, with mintable token creation
270  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
271  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
272  */
273 contract PausableToken is StandardToken, Ownable {
274   event Pause();
275   event Unpause();
276 
277   bool public paused = false;
278 
279 
280     /**
281    * @dev Modifier to make a function callable only when the contract is not paused.
282    */
283   modifier whenNotPaused() {
284     require(!paused);
285     _;
286   }
287 
288   /**
289    * @dev Modifier to make a function callable only when the contract is paused.
290    */
291   modifier whenPaused() {
292     require(paused);
293     _;
294   }
295 
296   /**
297    * @dev called by the owner to pause, triggers stopped state
298    */
299   function pause() onlyOwner whenNotPaused public {
300     paused = true;
301     emit Pause();
302   }
303 
304   /**
305    * @dev called by the owner to unpause, returns to normal state
306    */
307   function unpause() onlyOwner whenPaused public {
308     paused = false;
309     emit Unpause();
310   }
311 
312 
313 
314   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
315     return super.transfer(_to, _value);
316   }
317 
318   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
319     return super.transferFrom(_from, _to, _value);
320   }
321 
322   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
323     return super.approve(_spender, _value);
324   }
325 
326   function increaseApproval(address _spender, uint256 _addedValue) public whenNotPaused returns (bool success) {
327     return super.increaseApproval(_spender, _addedValue);
328   }
329 
330   function decreaseApproval(address _spender, uint256 _subtractedValue) public whenNotPaused returns (bool success) {
331     return super.decreaseApproval(_spender, _subtractedValue);
332   }
333 }
334 
335 // File: contracts/AegisEconomyCoin.sol
336 
337 contract AegisEconomyCoin is PausableToken {
338 
339     string  public constant     name = "Aegis Economy Coin";
340     string  public constant     symbol= "AGEC";
341     uint256 public constant     decimals= 18;
342     uint256 private     initialSupply = 10*(10**6)* (10**18);
343     uint256 private     finalSupply = 500*(10**6)*(10**18);
344     uint256 private     inflationPeriod = 50 years;
345     uint256 private     inflationPeriodStart = now;
346     uint256 private     releasedTokens;
347     uint256 private     inflationPeriodEnd = inflationPeriodStart + inflationPeriod;
348     uint256 private     inflationResolution = 100 * (10**8);
349 
350 
351     constructor() public {
352         paused = false;
353     }
354 
355 
356     function balanceOf(address _owner) public view returns (uint256) {
357 
358         //Only contract owner balance is calculated differently. It is dynamic and is always calculated as difference
359         // between totalSupply which is dyanmic and amount of tokens released by the contract.
360         if (_owner == owner)
361         {
362           return totalSupply() - releasedTokens;
363         }
364         else {
365           return balances[_owner];
366         }
367     }
368 
369     /**
370     * @dev Return dynamic totalSuply of this token. It is linear function.
371     */
372 
373     function totalSupply() public view returns (uint256)
374     {
375       uint256 currentTime = 0 ;
376       uint256 curSupply = 0;
377       currentTime = now;
378       if (currentTime > inflationPeriodEnd)
379       {
380         currentTime = inflationPeriodEnd;
381       }
382 
383       uint256 timeLapsed = currentTime - inflationPeriodStart;
384       uint256 timePer = _timePer();
385 
386       curSupply = finalSupply.sub(initialSupply).mul(timePer).div(inflationResolution).add(initialSupply);
387       return curSupply;
388     }
389 
390 
391 
392     function _timePer() internal view returns (uint256 _timePer)
393     {
394              uint currentTime = 0 ;
395              currentTime = now;
396             if (currentTime > inflationPeriodEnd)
397             {
398               currentTime = inflationPeriodEnd;
399             }
400 
401            uint256 timeLapsed = currentTime - inflationPeriodStart;
402            uint256 timePer = timeLapsed.mul(inflationResolution).div(inflationPeriod);
403 
404            return(timePer);
405 
406 
407     }
408 
409     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool success) {
410         require(balanceOf(msg.sender) >= _value);
411         if(msg.sender == owner)
412         {
413         releasedTokens = releasedTokens.add(_value);
414         }
415         else
416         {
417           balances[msg.sender] = balances[msg.sender].sub(_value);
418         }
419 
420         if(_to == owner)
421         {
422           releasedTokens = releasedTokens.sub(_value);
423         }
424         else {
425           balances[_to] = balances[_to].add(_value);
426         }
427 
428         Transfer(msg.sender, _to, _value);
429         return true;
430     }
431 
432     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool success) {
433 
434         require(balanceOf(_from) >= _value);
435         require(_value <= allowed[_from][msg.sender]);
436 
437 
438         if(_from == owner)
439         {
440         releasedTokens = releasedTokens.add(_value);
441         }
442         else
443         {
444           balances[_from] = balances[_from].sub(_value);
445         }
446 
447         if(_to == owner)
448         {
449           releasedTokens = releasedTokens.sub(_value);
450         }
451         else {
452           balances[_to] = balances[_to].add(_value);
453         }
454 
455         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
456         Transfer(_from, _to, _value);
457         return true;
458     }
459 
460 
461 }