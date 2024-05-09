1 pragma solidity ^0.4.23;
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
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20 
21   /**
22   * @dev Multiplies two numbers, throws on overflow.
23   */
24   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
25     if (a == 0) {
26       return 0;
27     }
28     c = a * b;
29     assert(c / a == b);
30     return c;
31   }
32 
33   /**
34   * @dev Integer division of two numbers, truncating the quotient.
35   */
36   function div(uint256 a, uint256 b) internal pure returns (uint256) {
37     // assert(b > 0); // Solidity automatically throws when dividing by 0
38     // uint256 c = a / b;
39     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40     return a / b;
41   }
42 
43   /**
44   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
45   */
46   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47     assert(b <= a);
48     return a - b;
49   }
50 
51   /**
52   * @dev Adds two numbers, throws on overflow.
53   */
54   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
55     c = a + b;
56     assert(c >= a);
57     return c;
58   }
59 }
60 
61 /**
62  * @title Basic token
63  * @dev Basic version of StandardToken, with no allowances.
64  */
65 contract BasicToken is ERC20Basic {
66   using SafeMath for uint256;
67 
68   mapping(address => uint256) balances;
69 
70   uint256 totalSupply_;
71 
72   /**
73   * @dev total number of tokens in existence
74   */
75   function totalSupply() public view returns (uint256) {
76     return totalSupply_;
77   }
78 
79   /**
80   * @dev transfer token for a specified address
81   * @param _to The address to transfer to.
82   * @param _value The amount to be transferred.
83   */
84   function transfer(address _to, uint256 _value) public returns (bool) {
85     require(_to != address(0));
86     require(_value <= balances[msg.sender]);
87 
88     balances[msg.sender] = balances[msg.sender].sub(_value);
89     balances[_to] = balances[_to].add(_value);
90     emit Transfer(msg.sender, _to, _value);
91     return true;
92   }
93 
94   /**
95   * @dev Gets the balance of the specified address.
96   * @param _owner The address to query the the balance of.
97   * @return An uint256 representing the amount owned by the passed address.
98   */
99   function balanceOf(address _owner) public view returns (uint256) {
100     return balances[_owner];
101   }
102 
103 }
104 
105 /**
106  * @title ERC20 interface
107  * @dev see https://github.com/ethereum/EIPs/issues/20
108  */
109 contract ERC20 is ERC20Basic {
110   function allowance(address owner, address spender) public view returns (uint256);
111   function transferFrom(address from, address to, uint256 value) public returns (bool);
112   function approve(address spender, uint256 value) public returns (bool);
113   event Approval(address indexed owner, address indexed spender, uint256 value);
114 }
115 
116 /**
117  * @title Standard ERC20 token
118  *
119  * @dev Implementation of the basic standard token.
120  * @dev https://github.com/ethereum/EIPs/issues/20
121  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
122  */
123 contract StandardToken is ERC20, BasicToken {
124 
125   mapping (address => mapping (address => uint256)) internal allowed;
126 
127 
128   /**
129    * @dev Transfer tokens from one address to another
130    * @param _from address The address which you want to send tokens from
131    * @param _to address The address which you want to transfer to
132    * @param _value uint256 the amount of tokens to be transferred
133    */
134   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
135     require(_to != address(0));
136     require(_value <= balances[_from]);
137     require(_value <= allowed[_from][msg.sender]);
138 
139     balances[_from] = balances[_from].sub(_value);
140     balances[_to] = balances[_to].add(_value);
141     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
142     emit Transfer(_from, _to, _value);
143     return true;
144   }
145 
146   /**
147    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
148    *
149    * Beware that changing an allowance with this method brings the risk that someone may use both the old
150    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
151    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
152    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153    * @param _spender The address which will spend the funds.
154    * @param _value The amount of tokens to be spent.
155    */
156   function approve(address _spender, uint256 _value) public returns (bool) {
157     allowed[msg.sender][_spender] = _value;
158     emit Approval(msg.sender, _spender, _value);
159     return true;
160   }
161 
162   /**
163    * @dev Function to check the amount of tokens that an owner allowed to a spender.
164    * @param _owner address The address which owns the funds.
165    * @param _spender address The address which will spend the funds.
166    * @return A uint256 specifying the amount of tokens still available for the spender.
167    */
168   function allowance(address _owner, address _spender) public view returns (uint256) {
169     return allowed[_owner][_spender];
170   }
171 
172   /**
173    * @dev Increase the amount of tokens that an owner allowed to a spender.
174    *
175    * approve should be called when allowed[_spender] == 0. To increment
176    * allowed value is better to use this function to avoid 2 calls (and wait until
177    * the first transaction is mined)
178    * From MonolithDAO Token.sol
179    * @param _spender The address which will spend the funds.
180    * @param _addedValue The amount of tokens to increase the allowance by.
181    */
182   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
183     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
184     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
185     return true;
186   }
187 
188   /**
189    * @dev Decrease the amount of tokens that an owner allowed to a spender.
190    *
191    * approve should be called when allowed[_spender] == 0. To decrement
192    * allowed value is better to use this function to avoid 2 calls (and wait until
193    * the first transaction is mined)
194    * From MonolithDAO Token.sol
195    * @param _spender The address which will spend the funds.
196    * @param _subtractedValue The amount of tokens to decrease the allowance by.
197    */
198   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
199     uint oldValue = allowed[msg.sender][_spender];
200     if (_subtractedValue > oldValue) {
201       allowed[msg.sender][_spender] = 0;
202     } else {
203       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
204     }
205     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
206     return true;
207   }
208 
209 }
210 
211 /**
212  * @title Ownable
213  * @dev The Ownable contract has an owner address, and provides basic authorization control
214  * functions, this simplifies the implementation of "user permissions".
215  */
216 contract Ownable {
217   address public owner;
218 
219 
220   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
221 
222 
223   /**
224    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
225    * account.
226    */
227   function Ownable() public {
228     owner = msg.sender;
229   }
230 
231   /**
232    * @dev Throws if called by any account other than the owner.
233    */
234   modifier onlyOwner() {
235     require(msg.sender == owner);
236     _;
237   }
238 
239   /**
240    * @dev Allows the current owner to transfer control of the contract to a newOwner.
241    * @param newOwner The address to transfer ownership to.
242    */
243   function transferOwnership(address newOwner) public onlyOwner {
244     require(newOwner != address(0));
245     emit OwnershipTransferred(owner, newOwner);
246     owner = newOwner;
247   }
248 
249 }
250 
251 /**
252  * @title Mintable token
253  * @dev Simple ERC20 Token example, with mintable token creation
254  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
255  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
256  */
257 contract MintableToken is StandardToken, Ownable {
258   event Mint(address indexed to, uint256 amount);
259   event MintFinished();
260 
261   bool public mintingFinished = false;
262 
263 
264   modifier canMint() {
265     require(!mintingFinished);
266     _;
267   }
268 
269   /**
270    * @dev Function to mint tokens
271    * @param _to The address that will receive the minted tokens.
272    * @param _amount The amount of tokens to mint.
273    * @return A boolean that indicates if the operation was successful.
274    */
275   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
276     totalSupply_ = totalSupply_.add(_amount);
277     balances[_to] = balances[_to].add(_amount);
278     emit Mint(_to, _amount);
279     emit Transfer(address(0), _to, _amount);
280     return true;
281   }
282 
283   /**
284    * @dev Function to stop minting new tokens.
285    * @return True if the operation was successful.
286    */
287   function finishMinting() onlyOwner canMint public returns (bool) {
288     mintingFinished = true;
289     emit MintFinished();
290     return true;
291   }
292 }
293 
294 /**
295  * @title Burnable Token
296  * @dev Token that can be irreversibly burned (destroyed).
297  */
298 contract BurnableByOwnerToken is BasicToken, Ownable {
299 
300   event Burn(address indexed burner, uint256 value);
301 
302   /**
303    * @dev Burns a specific amount of tokens.
304    * @param _value The amount of token to be burned.
305    */
306   function burn(address _who, uint256 _value) public onlyOwner {
307     _burn(_who, _value);
308   }
309 
310   function _burn(address _who, uint256 _value) internal {
311     require(_value <= balances[_who]);
312     // no need to require value <= totalSupply, since that would imply the
313     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
314 
315     balances[_who] = balances[_who].sub(_value);
316     totalSupply_ = totalSupply_.sub(_value);
317     emit Burn(_who, _value);
318     emit Transfer(_who, address(0), _value);
319   }
320 }
321 
322 contract MultiTransferableToken is BasicToken {
323     function multiTransfer(address[] _to, uint256[] _values) public returns (bool) {
324         require(_to.length == _values.length);
325         uint sum = 0;
326         uint i;
327         for (i = 0; i < _values.length; i++) {
328             sum = sum.add(_values[i]);
329         }
330         require(sum <= balances[msg.sender]);
331     
332         for (i = 0; i < _to.length; i++) {
333             require(_to[i] != address(0));
334             
335             balances[_to[i]] = balances[_to[i]].add(_values[i]);
336             emit Transfer(msg.sender, _to[i], _values[i]);
337         }
338         
339         balances[msg.sender] = balances[msg.sender].sub(sum);
340         return true;
341     }
342 }
343 
344 contract ZodiaqToken is StandardToken, MintableToken, BurnableByOwnerToken, MultiTransferableToken {
345     string public name = 'Zodiaq Token';
346     string public symbol = 'ZOD';
347     uint8 public decimals = 8;
348 }
349 
350 contract Managable is Ownable {
351     address public manager = 0x0;
352 
353     event ManagerIsChanged(address indexed previousManager, address indexed newManager);
354     
355     modifier onlyManager() {
356         require(msg.sender == owner || msg.sender == manager);
357         _;
358     }
359 
360     function changeManager(address newManager) public onlyOwner {
361         manager = newManager;
362         
363         emit ManagerIsChanged(manager, newManager);
364     }
365 }
366 
367 library SafeMathExtended {
368 
369     /**
370     * @dev Multiplies two numbers, throws on overflow.
371     */
372     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
373         if (a == 0) {
374             return 0;
375         }
376         c = a * b;
377         assert(c / a == b);
378         return c;
379     }
380 
381     /**
382     * @dev Integer division of two numbers, truncating the quotient.
383     */
384     function div(uint256 a, uint256 b) internal pure returns (uint256) {
385         // assert(b > 0); // Solidity automatically throws when dividing by 0
386         // uint256 c = a / b;
387         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
388         return a / b;
389     }
390 
391     /**
392     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
393     */
394     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
395         assert(b <= a);
396         return a - b;
397     }
398 
399     /**
400     * @dev Adds two numbers, throws on overflow.
401     */
402     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
403         c = a + b;
404         assert(c >= a);
405         return c;
406     }
407     function mulToFraction(uint256 number, uint256 numerator, uint256 denominator) internal pure returns (uint256) {
408         return div(mul(number, numerator), denominator);
409     }
410 }
411 
412 contract ZodiaqDistribution is Managable {
413     using SafeMathExtended for uint256;
414 
415     ZodiaqToken public token;
416     uint256 public BASE = 10 ** 8;
417 
418     address public bountyOwner;
419     address public referralProgramOwner;
420     address public team;
421     address public partners;
422 
423     bool    public isICOFinished = false;
424     uint256 public icoFinishedDate = 0;
425 
426     uint256 public teamReward = 0;
427     uint256 public partnersReward = 0;
428 
429     constructor(address zodiaqToken) public {
430         require(zodiaqToken != 0x0);
431         token = ZodiaqToken(zodiaqToken);
432     }
433     
434     modifier isICORunning {
435         require(!isICOFinished);
436         _;
437     }
438     
439     function init(address _bountyOwner, address _referralProgramOwner, address _team, address _partners) public onlyOwner {
440         // can be called only once
441         require(bountyOwner == 0x0);
442 
443         require(_bountyOwner != 0x0);
444         require(_referralProgramOwner != 0x0);
445         require(_team != 0x0);
446         require(_partners != 0x0);
447         
448         bountyOwner = _bountyOwner;
449         referralProgramOwner = _referralProgramOwner;
450         team = _team;
451         partners = _partners;
452         
453         token.mint(address(this), 240000000 * BASE);
454         token.mint(bountyOwner,          9000000 * BASE);
455         token.mint(referralProgramOwner, 6000000 * BASE);
456     }
457     
458     function sendTokensTo(address[] recipients, uint256[] values) public onlyManager isICORunning {
459         require(recipients.length == values.length);
460         for (uint256 i = 0; i < recipients.length; i++) {
461             assert(token.transfer(recipients[i], values[i]));
462         }
463     }
464     
465     function stopICO() public onlyOwner isICORunning {
466         token.burn(address(this), token.balanceOf(address(this)));
467         token.burn(referralProgramOwner, token.balanceOf(referralProgramOwner));
468         token.burn(bountyOwner, token.balanceOf(bountyOwner));
469 
470         uint256 totalSupply = token.totalSupply().mulToFraction(100, 85);
471         teamReward = totalSupply.mulToFraction(10, 100);
472         partnersReward = totalSupply.mulToFraction(5, 100);
473 
474         token.mint(address(this), teamReward + partnersReward);
475 
476         token.finishMinting();
477 
478         isICOFinished = true;
479         icoFinishedDate = now;
480     }
481 
482     function payPartners() public {
483         require(partnersReward != 0);
484         uint secondsInYear = 31536000;
485         require(icoFinishedDate + secondsInYear / 2 < now);
486         assert(token.transfer(partners, partnersReward));
487         partnersReward = 0;
488     }
489 
490     function payTeam() public {
491         require(teamReward != 0);
492         uint secondsInYear = 31536000;
493         require(icoFinishedDate + secondsInYear * 2 < now);
494         assert(token.transfer(team, teamReward));
495         teamReward = 0;
496     }
497 }