1 pragma solidity ^0.5.1;
2 
3 /**
4  * @title Vrenelium Token - VRE
5  * @author Vrenelium AG 2018/2019
6  */
7 
8 /**
9  * @title Ownable
10  * @dev The Ownable contract has an owner address, and provides basic authorization control
11  * functions, this simplifies the implementation of "user permissions".
12  */
13 contract Ownable {
14   address public owner;
15 
16 
17   event OwnershipRenounced(address indexed previousOwner);
18   event OwnershipTransferred(
19     address indexed previousOwner,
20     address indexed newOwner
21   );
22 
23 
24   /**
25    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
26    * account.
27    */
28   constructor() public {
29     owner = msg.sender;
30   }
31 
32   /**
33    * @dev Throws if called by any account other than the owner.
34    */
35   modifier onlyOwner() {
36     require(msg.sender == owner);
37     _;
38   }
39 
40   /**
41    * @dev Allows the current owner to transfer control of the contract to a newOwner.
42    * @param _newOwner The address to transfer ownership to.
43    */
44   function transferOwnership(address _newOwner) public onlyOwner {
45     _transferOwnership(_newOwner);
46   }
47 
48   /**
49    * @dev Transfers control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function _transferOwnership(address _newOwner) internal {
53     require(_newOwner != address(0));
54     emit OwnershipTransferred(owner, _newOwner);
55     owner = _newOwner;
56   }
57 }
58 
59 /**
60  * @title SafeMath
61  *
62  * @dev Math operations with safety checks that throw on error
63  */
64 library SafeMath {
65 
66   /**
67   * @dev Multiplies two numbers, throws on overflow.
68   */
69   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
70     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
71     // benefit is lost if 'b' is also tested.
72     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
73     if (a == 0) {
74       return 0;
75     }
76 
77     c = a * b;
78     assert(c / a == b);
79     return c;
80   }
81 
82   /**
83   * @dev Integer division of two numbers, truncating the quotient.
84   */
85   function div(uint256 a, uint256 b) internal pure returns (uint256) {
86     // assert(b > 0); // Solidity automatically throws when dividing by 0
87     // uint256 c = a / b;
88     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
89     return a / b;
90   }
91 
92   /**
93   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
94   */
95   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
96     assert(b <= a);
97     return a - b;
98   }
99 
100   /**
101   * @dev Adds two numbers, throws on overflow.
102   */
103   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
104     c = a + b;
105     assert(c >= a);
106     return c;
107   }
108 }
109 
110 /**
111  * @title ERC20Basic
112  * @dev Simpler version of ERC20 interface
113  * See https://github.com/ethereum/EIPs/issues/179
114  */
115 contract ERC20Basic {
116   function totalSupply() public view returns (uint256);
117   function balanceOf(address who) public view returns (uint256);
118   function transfer(address to, uint256 value) public returns (bool);
119   event Transfer(address indexed from, address indexed to, uint256 value);
120 }
121 
122 /**
123  * @title ERC20 interface
124  * @dev see https://github.com/ethereum/EIPs/issues/20
125  */
126 contract ERC20 is ERC20Basic {
127   function allowance(address owner, address spender)
128     public view returns (uint256);
129 
130   function transferFrom(address from, address to, uint256 value)
131     public returns (bool);
132 
133   function approve(address spender, uint256 value) public returns (bool);
134   event Approval(
135     address indexed owner,
136     address indexed spender,
137     uint256 value
138   );
139 }
140 
141 /**
142  * @title Basic token
143  *
144  * @dev Basic version of StandardToken, with no allowances.
145  */
146 contract BasicToken is ERC20Basic {
147   using SafeMath for uint256;
148 
149   mapping(address => uint256) balances;
150 
151   uint256 totalSupply_;
152 
153   /**
154   * @dev Total number of tokens in existence
155   */
156   function totalSupply() public view returns (uint256) {
157     return totalSupply_;
158   }
159 
160   /**
161   * @dev Transfer token for a specified address
162   * @param _to The address to transfer to.
163   * @param _value The amount to be transferred.
164   */
165   function transfer(address _to, uint256 _value) public returns (bool) {
166     require(_value <= balances[msg.sender]);
167     require(_to != address(0));
168 
169     balances[msg.sender] = balances[msg.sender].sub(_value);
170     balances[_to] = balances[_to].add(_value);
171     emit Transfer(msg.sender, _to, _value);
172     return true;
173   }
174 
175   /**
176   * @dev Gets the balance of the specified address.
177   * @param _owner The address to query the the balance of.
178   * @return An uint256 representing the amount owned by the passed address.
179   */
180   function balanceOf(address _owner) public view returns (uint256) {
181     return balances[_owner];
182   }
183 
184 }
185 
186 
187 /**
188  * @title ERC20 token implementation
189  *
190  * @dev Implementation of the ERC20 token.
191  */
192 contract StandardToken is ERC20, BasicToken {
193 
194   mapping (address => mapping (address => uint256)) internal allowed;
195 
196   /**
197    * @dev Transfer tokens from one address to another
198    * @param _from address The address which you want to send tokens from
199    * @param _to address The address which you want to transfer to
200    * @param _value uint256 the amount of tokens to be transferred
201    */
202   function transferFrom(
203     address _from,
204     address _to,
205     uint256 _value
206   )
207     public
208     returns (bool)
209   {
210     require(_value <= balances[_from]);
211     require(_value <= allowed[_from][msg.sender]);
212     require(_to != address(0));
213 
214     balances[_from] = balances[_from].sub(_value);
215     balances[_to] = balances[_to].add(_value);
216     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
217     emit Transfer(_from, _to, _value);
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
237    * @dev Function to check the amount of tokens that an owner allowed to a spender.
238    * @param _owner address The address which owns the funds.
239    * @param _spender address The address which will spend the funds.
240    * @return A uint256 specifying the amount of tokens still available for the spender.
241    */
242   function allowance(
243     address _owner,
244     address _spender
245    )
246     public
247     view
248     returns (uint256)
249   {
250     return allowed[_owner][_spender];
251   }
252 
253   /**
254    * @dev Increase the amount of tokens that an owner allowed to a spender.
255    * approve should be called when allowed[_spender] == 0. To increment
256    * allowed value is better to use this function to avoid 2 calls (and wait until
257    * the first transaction is mined)
258    * @param _spender The address which will spend the funds.
259    * @param _addedValue The amount of tokens to increase the allowance by.
260    */
261   function increaseApproval(
262     address _spender,
263     uint256 _addedValue
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
276    * approve should be called when allowed[_spender] == 0. To decrement
277    * allowed value is better to use this function to avoid 2 calls (and wait until
278    * the first transaction is mined)
279    * @param _spender The address which will spend the funds.
280    * @param _subtractedValue The amount of tokens to decrease the allowance by.
281    */
282   function decreaseApproval(
283     address _spender,
284     uint256 _subtractedValue
285   )
286     public
287     returns (bool)
288   {
289     uint256 oldValue = allowed[msg.sender][_spender];
290     if (_subtractedValue >= oldValue) {
291       allowed[msg.sender][_spender] = 0;
292     } else {
293       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
294     }
295     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
296     return true;
297   }
298 
299 }
300 
301 
302 /**
303  * @title Mintable token with logarithmic approximation to token cap
304  */
305 contract MintableTokenWithCap is StandardToken, Ownable {
306 
307   event Mint(address indexed to, uint256 amount);
308 
309   uint256 public constant TOTAL_TOKEN_CAP      = 78000000 * 10 ** 18; // Maximum amount of tokens
310   uint256 public constant PRE_MINTED_TOKEN_CAP = 24100000 * 10 ** 18; // Amount of pre minted tokens
311 
312   uint256 public constant PRE_MINTING_END      = 1577750400; // x1 - 2019-12-31T00:00:00+00:00 - Pre minting end Timestamp
313   uint256 public constant MINTING_END          = 3187295999; // x2 - 2070-12-31T23:59:59+00:00 - Minting end Timestamp
314 
315 
316   modifier hasMintPermission() {
317     require(msg.sender == owner);
318     _;
319   }
320 
321   /**
322    * @dev Function to mint tokens
323    * @param _to The address that will receive the minted tokens.
324    * @param _amount The amount of tokens to mint.
325    * @return A boolean that indicates if the operation was successful.
326    */
327   function mint(
328     address _to,
329     uint256 _amount
330   )
331     hasMintPermission
332     public
333     returns (bool)
334   {
335     require(totalSupply_ + _amount <= getCurrentMintingLimit());
336 
337     totalSupply_ = totalSupply_.add(_amount);
338     balances[_to] = balances[_to].add(_amount);
339     emit Mint(_to, _amount);
340     emit Transfer(address(0), _to, _amount);
341     return true;
342   }
343 
344   function getCurrentMintingLimit()
345     public
346     view
347     returns(uint256)
348   {
349     if(now <= PRE_MINTING_END) {
350 
351       return PRE_MINTED_TOKEN_CAP;
352     }
353     else if(now <= MINTING_END) {
354 
355       // Logarithmic approximation until MINTING_END
356       // qfactor = (ln(2x + 0.2) - ln(0.2)) / (ln(2.2)-ln(0.2))
357       // Pre calculated values are used for efficiency reasons
358 
359       if(now <= 1609459199) { // 12/31/2020 @ 11:59pm (UTC)
360             return 28132170 *10 ** 18;
361       }
362       else if(now <= 1640995199) { // 12/31/2021 @ 11:59pm (UTC)
363             return 31541205 *10 ** 18;
364       }
365       else if(now <= 1672531199) { // 12/31/2022 @ 11:59pm (UTC)
366             return 34500660 *10 ** 18;
367       }
368       else if(now <= 1704067199) { // 12/31/2023 @ 11:59pm (UTC)
369             return 37115417 *10 ** 18;
370       }
371       else if(now <= 1735603199) { // 12/31/2024 @ 11:59pm (UTC)
372             return 39457461 *10 ** 18;
373       }
374       else if(now <= 1767225599) { // 12/31/2025 @ 11:59pm (UTC)
375             return 41583887 *10 ** 18;
376       }
377       else if(now <= 1798761599) { // 12/31/2026 @ 11:59pm (UTC)
378             return 43521339 *10 ** 18;
379       }
380       else if(now <= 1830297599) { // 12/31/2027 @ 11:59pm (UTC)
381             return 45304967 *10 ** 18;
382       }
383       else if(now <= 1861919999) { // 12/31/2028 @ 11:59pm (UTC)
384             return 46961775 *10 ** 18;
385       }
386       else if(now <= 1893455999) { // 12/31/2029 @ 11:59pm (UTC)
387             return 48500727 *10 ** 18;
388       }
389       else if(now <= 1924991999) { // 12/31/2030 @ 11:59pm (UTC)
390             return 49941032 *10 ** 18;
391       }
392       else if(now <= 1956527999) { // 12/31/2031 @ 11:59pm (UTC)
393             return 51294580 *10 ** 18;
394       }
395       else if(now <= 1988150399) { // 12/31/2032 @ 11:59pm (UTC)
396             return 52574631 *10 ** 18;
397       }
398       else if(now <= 2019686399) { // 12/31/2033 @ 11:59pm (UTC)
399             return 53782475 *10 ** 18;
400       }
401       else if(now <= 2051222399) { // 12/31/2034 @ 11:59pm (UTC)
402             return 54928714 *10 ** 18;
403       }
404       else if(now <= 2082758399) { // 12/31/2035 @ 11:59pm (UTC)
405             return 56019326 *10 ** 18;
406       }
407       else if(now <= 2114380799) { // 12/31/2036 @ 11:59pm (UTC)
408             return 57062248 *10 ** 18;
409       }
410       else if(now <= 2145916799) { // 12/31/2037 @ 11:59pm (UTC)
411             return 58056255 *10 ** 18;
412       }
413       else if(now <= 2177452799) { // 12/31/2038 @ 11:59pm (UTC)
414             return 59008160 *10 ** 18;
415       }
416       else if(now <= 2208988799) { // 12/31/2039 @ 11:59pm (UTC)
417             return 59921387 *10 ** 18;
418       }
419       else if(now <= 2240611199) { // 12/31/2040 @ 11:59pm (UTC)
420             return 60801313 *10 ** 18;
421       }
422       else if(now <= 2272147199) { // 12/31/2041 @ 11:59pm (UTC)
423             return 61645817 *10 ** 18;
424       }
425       else if(now <= 2303683199) { // 12/31/2042 @ 11:59pm (UTC)
426             return 62459738 *10 ** 18;
427       }
428       else if(now <= 2335219199) { // 12/31/2043 @ 11:59pm (UTC)
429             return 63245214 *10 ** 18;
430       }
431       else if(now <= 2366841599) { // 12/31/2044 @ 11:59pm (UTC)
432             return 64006212 *10 ** 18;
433       }
434       else if(now <= 2398377599) { // 12/31/2045 @ 11:59pm (UTC)
435             return 64740308 *10 ** 18;
436       }
437       else if(now <= 2429913599) { // 12/31/2046 @ 11:59pm (UTC)
438             return 65451186 *10 ** 18;
439       }
440       else if(now <= 2461449599) { // 12/31/2047 @ 11:59pm (UTC)
441             return 66140270 *10 ** 18;
442       }
443       else if(now <= 2493071999) { // 12/31/2048 @ 11:59pm (UTC)
444             return 66810661 *10 ** 18;
445       }
446       else if(now <= 2524607999) { // 12/31/2049 @ 11:59pm (UTC)
447             return 67459883 *10 ** 18;
448       }
449       else if(now <= 2556143999) { // 12/31/2050 @ 11:59pm (UTC)
450             return 68090879 *10 ** 18;
451       }
452       else if(now <= 2587679999) { // 12/31/2051 @ 11:59pm (UTC)
453             return 68704644 *10 ** 18;
454       }
455       else if(now <= 2619302399) { // 12/31/2052 @ 11:59pm (UTC)
456             return 69303710 *10 ** 18;
457       }
458       else if(now <= 2650838399) { // 12/31/2053 @ 11:59pm (UTC)
459             return 69885650 *10 ** 18;
460       }
461       else if(now <= 2682374399) { // 12/31/2054 @ 11:59pm (UTC)
462             return 70452903 *10 ** 18;
463       }
464       else if(now <= 2713910399) { // 12/31/2055 @ 11:59pm (UTC)
465             return 71006193 *10 ** 18;
466       }
467       else if(now <= 2745532799) { // 12/31/2056 @ 11:59pm (UTC)
468             return 71547652 *10 ** 18;
469       }
470       else if(now <= 2777068799) { // 12/31/2057 @ 11:59pm (UTC)
471             return 72074946 *10 ** 18;
472       }
473       else if(now <= 2808604799) { // 12/31/2058 @ 11:59pm (UTC)
474             return 72590155 *10 ** 18;
475       }
476       else if(now <= 2840140799) { // 12/31/2059 @ 11:59pm (UTC)
477             return 73093818 *10 ** 18;
478       }
479       else if(now <= 2871763199) { // 12/31/2060 @ 11:59pm (UTC)
480             return 73587778 *10 ** 18;
481       }
482       else if(now <= 2903299199) { // 12/31/2061 @ 11:59pm (UTC)
483             return 74069809 *10 ** 18;
484       }
485       else if(now <= 2934835199) { // 12/31/2062 @ 11:59pm (UTC)
486             return 74541721 *10 ** 18;
487       }
488       else if(now <= 2966371199) { // 12/31/2063 @ 11:59pm (UTC)
489             return 75003928 *10 ** 18;
490       }
491       else if(now <= 2997993599) { // 12/31/2064 @ 11:59pm (UTC)
492             return 75458050 *10 ** 18;
493       }
494       else if(now <= 3029529599) { // 12/31/2065 @ 11:59pm (UTC)
495             return 75901975 *10 ** 18;
496       }
497       else if(now <= 3061065599) { // 12/31/2066 @ 11:59pm (UTC)
498             return 76337302 *10 ** 18;
499       }
500       else if(now <= 3092601599) { // 12/31/2067 @ 11:59pm (UTC)
501             return 76764358 *10 ** 18;
502       }
503       else if(now <= 3124223999) { // 12/31/2068 @ 11:59pm (UTC)
504             return 77184590 *10 ** 18;
505       }
506       else if(now <= 3155759999) { // 12/31/2069 @ 11:59pm (UTC)
507             return 77595992 *10 ** 18;
508       }
509       else if(now <= 3187295999) { // 12/31/2070 @ 11:59pm (UTC)
510             return 78000000 *10 ** 18;
511       }
512     }
513     else {
514 
515       return TOTAL_TOKEN_CAP;
516     }
517   }
518 }
519 
520 
521 /**
522 * @title Vrenelium Token Smart Contract
523 */
524 contract VreneliumToken is MintableTokenWithCap {
525 
526     // Public Constants
527     string public constant name = "Vrenelium Token";
528     string public constant symbol = "VRE";
529     uint8 public constant decimals = 18;
530 
531     /**
532     * @dev Modifier to not allow transfers
533     * to this contract
534     */
535     modifier validDestination(address _to) {
536         require(_to != address(this));
537         _;
538     }
539 
540     constructor() public {
541     }
542 
543     function transferFrom(address _from, address _to, uint256 _value) public
544         validDestination(_to)
545         returns (bool) {
546         return super.transferFrom(_from, _to, _value);
547     }
548 
549     function approve(address _spender, uint256 _value) public
550         returns (bool) {
551         return super.approve(_spender, _value);
552     }
553 
554     function increaseApproval (address _spender, uint _addedValue) public
555         returns (bool) {
556         return super.increaseApproval(_spender, _addedValue);
557     }
558 
559     function decreaseApproval (address _spender, uint _subtractedValue) public
560         returns (bool) {
561         return super.decreaseApproval(_spender, _subtractedValue);
562     }
563 
564     function transfer(address _to, uint256 _value) public
565         validDestination(_to)
566         returns (bool) {
567         return super.transfer(_to, _value);
568     }
569 }