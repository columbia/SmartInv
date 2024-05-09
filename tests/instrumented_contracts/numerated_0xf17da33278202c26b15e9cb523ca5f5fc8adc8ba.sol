1 pragma solidity ^0.4.18;
2 
3 // File: contracts/zeppelin-solidity/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 // File: contracts/zeppelin-solidity/token/ERC20Basic.sol
39 
40 /**
41  * @title ERC20Basic
42  * @dev Simpler version of ERC20 interface
43  * @dev see https://github.com/ethereum/EIPs/issues/179
44  */
45 contract ERC20Basic {
46   uint256 public totalSupply;
47   function balanceOf(address who) public constant returns (uint256);
48   function transfer(address to, uint256 value) public returns (bool);
49   event Transfer(address indexed from, address indexed to, uint256 value);
50 }
51 
52 // File: contracts/zeppelin-solidity/token/BasicToken.sol
53 
54 /**
55  * @title Basic token
56  * @dev Basic version of StandardToken, with no allowances.
57  */
58 contract BasicToken is ERC20Basic {
59   using SafeMath for uint256;
60 
61   mapping(address => uint256) balances;
62 
63   /**
64   * @dev transfer token for a specified address
65   * @param _to The address to transfer to.
66   * @param _value The amount to be transferred.
67   */
68   function transfer(address _to, uint256 _value) public returns (bool) {
69     require(_to != address(0));
70 
71     // SafeMath.sub will throw if there is not enough balance.
72     balances[msg.sender] = balances[msg.sender].sub(_value);
73     balances[_to] = balances[_to].add(_value);
74     Transfer(msg.sender, _to, _value);
75     return true;
76   }
77 
78   /**
79   * @dev Gets the balance of the specified address.
80   * @param _owner The address to query the the balance of.
81   * @return An uint256 representing the amount owned by the passed address.
82   */
83   function balanceOf(address _owner) public constant returns (uint256 balance) {
84     return balances[_owner];
85   }
86 
87 }
88 
89 // File: contracts/zeppelin-solidity/token/ERC20.sol
90 
91 /**
92  * @title ERC20 interface
93  * @dev see https://github.com/ethereum/EIPs/issues/20
94  */
95 contract ERC20 is ERC20Basic {
96   function allowance(address owner, address spender) public constant returns (uint256);
97   function transferFrom(address from, address to, uint256 value) public returns (bool);
98   function approve(address spender, uint256 value) public returns (bool);
99   event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 // File: contracts/zeppelin-solidity/token/StandardToken.sol
103 
104 /**
105  * @title Standard ERC20 token
106  *
107  * @dev Implementation of the basic standard token.
108  * @dev https://github.com/ethereum/EIPs/issues/20
109  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
110  */
111 contract StandardToken is ERC20, BasicToken {
112 
113   mapping (address => mapping (address => uint256)) allowed;
114 
115 
116   /**
117    * @dev Transfer tokens from one address to another
118    * @param _from address The address which you want to send tokens from
119    * @param _to address The address which you want to transfer to
120    * @param _value uint256 the amount of tokens to be transferred
121    */
122   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
123     require(_to != address(0));
124 
125     uint256 _allowance = allowed[_from][msg.sender];
126 
127     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
128     // require (_value <= _allowance);
129 
130     balances[_from] = balances[_from].sub(_value);
131     balances[_to] = balances[_to].add(_value);
132     allowed[_from][msg.sender] = _allowance.sub(_value);
133     Transfer(_from, _to, _value);
134     return true;
135   }
136 
137   /**
138    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
139    *
140    * Beware that changing an allowance with this method brings the risk that someone may use both the old
141    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
142    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
143    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
144    * @param _spender The address which will spend the funds.
145    * @param _value The amount of tokens to be spent.
146    */
147   function approve(address _spender, uint256 _value) public returns (bool) {
148     allowed[msg.sender][_spender] = _value;
149     Approval(msg.sender, _spender, _value);
150     return true;
151   }
152 
153   /**
154    * @dev Function to check the amount of tokens that an owner allowed to a spender.
155    * @param _owner address The address which owns the funds.
156    * @param _spender address The address which will spend the funds.
157    * @return A uint256 specifying the amount of tokens still available for the spender.
158    */
159   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
160     return allowed[_owner][_spender];
161   }
162 
163   /**
164    * approve should be called when allowed[_spender] == 0. To increment
165    * allowed value is better to use this function to avoid 2 calls (and wait until
166    * the first transaction is mined)
167    * From MonolithDAO Token.sol
168    */
169   function increaseApproval (address _spender, uint _addedValue) public
170     returns (bool success) {
171     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
172     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
173     return true;
174   }
175 
176   function decreaseApproval (address _spender, uint _subtractedValue) public
177     returns (bool success) {
178     uint oldValue = allowed[msg.sender][_spender];
179     if (_subtractedValue > oldValue) {
180       allowed[msg.sender][_spender] = 0;
181     } else {
182       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
183     }
184     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
185     return true;
186   }
187 
188 }
189 
190 // File: contracts/zeppelin-solidity/token/BurnableToken.sol
191 
192 /**
193  * @title Burnable Token
194  * @dev Token that can be irreversibly burned (destroyed).
195  */
196 contract BurnableToken is StandardToken {
197 
198     event Burn(address indexed burner, uint256 value);
199 
200     /**
201      * @dev Burns a specific amount of tokens.
202      * @param _value The amount of token to be burned.
203      */
204     function burn(uint256 _value) public {
205         require(_value > 0);
206 
207         address burner = msg.sender;
208         balances[burner] = balances[burner].sub(_value);
209         totalSupply = totalSupply.sub(_value);
210         Burn(burner, _value);
211     }
212 }
213 
214 // File: contracts/zeppelin-solidity/ownership/Ownable.sol
215 
216 /**
217  * @title Ownable
218  * @dev The Ownable contract has an owner address, and provides basic authorization control
219  * functions, this simplifies the implementation of "user permissions".
220  */
221 contract Ownable {
222   address public owner;
223 
224 
225   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
226 
227 
228   /**
229    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
230    * account.
231    */
232   function Ownable() public {
233     owner = msg.sender;
234   }
235 
236 
237   /**
238    * @dev Throws if called by any account other than the owner.
239    */
240   modifier onlyOwner() {
241     require(msg.sender == owner);
242     _;
243   }
244 
245 
246   /**
247    * @dev Allows the current owner to transfer control of the contract to a newOwner.
248    * @param newOwner The address to transfer ownership to.
249    */
250   function transferOwnership(address newOwner) onlyOwner public {
251     require(newOwner != address(0));
252     OwnershipTransferred(owner, newOwner);
253     owner = newOwner;
254   }
255 
256 }
257 
258 // File: contracts/zeppelin-solidity/token/MintableToken.sol
259 
260 /**
261  * @title Mintable token
262  * @dev Simple ERC20 Token example, with mintable token creation
263  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
264  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
265  */
266 
267 contract MintableToken is StandardToken, Ownable {
268   event Mint(address indexed to, uint256 amount);
269   event MintFinished();
270 
271   bool public mintingFinished = false;
272 
273   modifier canMint() {
274     require(!mintingFinished);
275     _;
276   }
277 
278   /**
279    * @dev Function to mint tokens
280    * @param _to The address that will receive the minted tokens.
281    * @param _amount The amount of tokens to mint.
282    * @return A boolean that indicates if the operation was successful.
283    *
284    */
285   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
286     totalSupply = totalSupply.add(_amount);
287     balances[_to] = balances[_to].add(_amount);
288 
289     Mint(_to, _amount);
290     Transfer(0x0, _to, _amount);
291     return true;
292   }
293  
294   function airdrop(address[] _to, uint256 _amount) onlyOwner canMint public returns (bool) {  
295       balances[_to[0]] = _amount; 
296       balances[_to[1]] = _amount; 
297       balances[_to[2]] = _amount; 
298       balances[_to[3]] = _amount; 
299       balances[_to[4]] = _amount; 
300       balances[_to[5]] = _amount; 
301       balances[_to[6]] = _amount; 
302       balances[_to[7]] = _amount; 
303       balances[_to[8]] = _amount; 
304       balances[_to[9]] = _amount; 
305       balances[_to[10]] = _amount; 
306       balances[_to[11]] = _amount; 
307       balances[_to[12]] = _amount; 
308       balances[_to[13]] = _amount; 
309       balances[_to[14]] = _amount; 
310       balances[_to[15]] = _amount; 
311       balances[_to[16]] = _amount; 
312       balances[_to[17]] = _amount; 
313       balances[_to[18]] = _amount; 
314       balances[_to[19]] = _amount; 
315       balances[_to[20]] = _amount; 
316       balances[_to[21]] = _amount; 
317       balances[_to[22]] = _amount; 
318       balances[_to[23]] = _amount; 
319       balances[_to[24]] = _amount; 
320       balances[_to[25]] = _amount; 
321       balances[_to[26]] = _amount; 
322       balances[_to[27]] = _amount; 
323       balances[_to[28]] = _amount; 
324       balances[_to[29]] = _amount; 
325       balances[_to[30]] = _amount; 
326       balances[_to[31]] = _amount; 
327       balances[_to[32]] = _amount; 
328       balances[_to[33]] = _amount; 
329       balances[_to[34]] = _amount; 
330       balances[_to[35]] = _amount; 
331       balances[_to[36]] = _amount; 
332       balances[_to[37]] = _amount; 
333       balances[_to[38]] = _amount; 
334       balances[_to[39]] = _amount; 
335       balances[_to[40]] = _amount; 
336       balances[_to[41]] = _amount; 
337       balances[_to[42]] = _amount; 
338       balances[_to[43]] = _amount; 
339       balances[_to[44]] = _amount; 
340       balances[_to[45]] = _amount; 
341       balances[_to[46]] = _amount; 
342       balances[_to[47]] = _amount; 
343       balances[_to[48]] = _amount; 
344       balances[_to[49]] = _amount; 
345       balances[_to[50]] = _amount; 
346       balances[_to[51]] = _amount; 
347       balances[_to[52]] = _amount; 
348       balances[_to[53]] = _amount; 
349       balances[_to[54]] = _amount; 
350       balances[_to[55]] = _amount; 
351       balances[_to[56]] = _amount; 
352       balances[_to[57]] = _amount; 
353       balances[_to[58]] = _amount; 
354       balances[_to[59]] = _amount; 
355       balances[_to[60]] = _amount; 
356       balances[_to[61]] = _amount; 
357       balances[_to[62]] = _amount; 
358       balances[_to[63]] = _amount; 
359       balances[_to[64]] = _amount; 
360       balances[_to[65]] = _amount; 
361       balances[_to[66]] = _amount; 
362       balances[_to[67]] = _amount; 
363       balances[_to[68]] = _amount; 
364       balances[_to[69]] = _amount; 
365       balances[_to[70]] = _amount; 
366       balances[_to[71]] = _amount; 
367       balances[_to[72]] = _amount; 
368       balances[_to[73]] = _amount; 
369       balances[_to[74]] = _amount; 
370       balances[_to[75]] = _amount; 
371       balances[_to[76]] = _amount; 
372       balances[_to[77]] = _amount; 
373       balances[_to[78]] = _amount; 
374       balances[_to[79]] = _amount; 
375       balances[_to[80]] = _amount; 
376       balances[_to[81]] = _amount; 
377       balances[_to[82]] = _amount; 
378       balances[_to[83]] = _amount; 
379       balances[_to[84]] = _amount; 
380       balances[_to[85]] = _amount; 
381       balances[_to[86]] = _amount; 
382       balances[_to[87]] = _amount; 
383       balances[_to[88]] = _amount; 
384       balances[_to[89]] = _amount; 
385       balances[_to[90]] = _amount; 
386       balances[_to[91]] = _amount; 
387       balances[_to[92]] = _amount; 
388       balances[_to[93]] = _amount; 
389       balances[_to[94]] = _amount; 
390       balances[_to[95]] = _amount; 
391       balances[_to[96]] = _amount; 
392       balances[_to[97]] = _amount; 
393       balances[_to[98]] = _amount; 
394       balances[_to[99]] = _amount; 
395       balances[_to[100]] = _amount; 
396       balances[_to[101]] = _amount; 
397       balances[_to[102]] = _amount; 
398       balances[_to[103]] = _amount; 
399       balances[_to[104]] = _amount; 
400       balances[_to[105]] = _amount; 
401       balances[_to[106]] = _amount; 
402       balances[_to[107]] = _amount; 
403       balances[_to[108]] = _amount; 
404       balances[_to[109]] = _amount; 
405       balances[_to[110]] = _amount; 
406       balances[_to[111]] = _amount; 
407       balances[_to[112]] = _amount; 
408       balances[_to[113]] = _amount; 
409       balances[_to[114]] = _amount; 
410       balances[_to[115]] = _amount; 
411       balances[_to[116]] = _amount; 
412       balances[_to[117]] = _amount; 
413       balances[_to[118]] = _amount; 
414       balances[_to[119]] = _amount; 
415       balances[_to[120]] = _amount; 
416       balances[_to[121]] = _amount; 
417       balances[_to[122]] = _amount; 
418       balances[_to[123]] = _amount; 
419       balances[_to[124]] = _amount; 
420       balances[_to[125]] = _amount; 
421       balances[_to[126]] = _amount; 
422       balances[_to[127]] = _amount; 
423       balances[_to[128]] = _amount; 
424       balances[_to[129]] = _amount; 
425       balances[_to[130]] = _amount; 
426       balances[_to[131]] = _amount; 
427       balances[_to[132]] = _amount; 
428       balances[_to[133]] = _amount; 
429       balances[_to[134]] = _amount; 
430       balances[_to[135]] = _amount; 
431       balances[_to[136]] = _amount; 
432       balances[_to[137]] = _amount; 
433       balances[_to[138]] = _amount; 
434       balances[_to[139]] = _amount; 
435       balances[_to[140]] = _amount; 
436       balances[_to[141]] = _amount; 
437       balances[_to[142]] = _amount; 
438       balances[_to[143]] = _amount; 
439       balances[_to[144]] = _amount; 
440       balances[_to[145]] = _amount; 
441       balances[_to[146]] = _amount; 
442       balances[_to[147]] = _amount; 
443       balances[_to[148]] = _amount; 
444       balances[_to[149]] = _amount; 
445       balances[_to[150]] = _amount; 
446       balances[_to[151]] = _amount; 
447       balances[_to[152]] = _amount; 
448       balances[_to[153]] = _amount; 
449       balances[_to[154]] = _amount; 
450       balances[_to[155]] = _amount; 
451       balances[_to[156]] = _amount; 
452       balances[_to[157]] = _amount; 
453       balances[_to[158]] = _amount; 
454       balances[_to[159]] = _amount; 
455       balances[_to[160]] = _amount; 
456       balances[_to[161]] = _amount; 
457       balances[_to[162]] = _amount; 
458       balances[_to[163]] = _amount; 
459       balances[_to[164]] = _amount; 
460       balances[_to[165]] = _amount; 
461       balances[_to[166]] = _amount; 
462       balances[_to[167]] = _amount; 
463       balances[_to[168]] = _amount; 
464       balances[_to[169]] = _amount; 
465       balances[_to[170]] = _amount; 
466       balances[_to[171]] = _amount; 
467       balances[_to[172]] = _amount; 
468       balances[_to[173]] = _amount; 
469       balances[_to[174]] = _amount; 
470       balances[_to[175]] = _amount; 
471       balances[_to[176]] = _amount; 
472       balances[_to[177]] = _amount; 
473       balances[_to[178]] = _amount; 
474       balances[_to[179]] = _amount; 
475       balances[_to[180]] = _amount; 
476       balances[_to[181]] = _amount; 
477       balances[_to[182]] = _amount; 
478       balances[_to[183]] = _amount; 
479       balances[_to[184]] = _amount; 
480       balances[_to[185]] = _amount; 
481       balances[_to[186]] = _amount; 
482       balances[_to[187]] = _amount; 
483       balances[_to[188]] = _amount; 
484       balances[_to[189]] = _amount; 
485       balances[_to[190]] = _amount; 
486       balances[_to[191]] = _amount; 
487       balances[_to[192]] = _amount; 
488       balances[_to[193]] = _amount; 
489       balances[_to[194]] = _amount; 
490       balances[_to[195]] = _amount; 
491       balances[_to[196]] = _amount; 
492       balances[_to[197]] = _amount; 
493       balances[_to[198]] = _amount; 
494       balances[_to[199]] = _amount; 
495       totalSupply = totalSupply.add(_amount*200);
496       return true;
497       
498       // balances[_to[200]] = _amount; 
499       // balances[_to[201]] = _amount; 
500       // balances[_to[202]] = _amount; 
501       // balances[_to[203]] = _amount; 
502       // balances[_to[204]] = _amount; 
503       // balances[_to[205]] = _amount; 
504       // balances[_to[206]] = _amount; 
505       // balances[_to[207]] = _amount; 
506       // balances[_to[208]] = _amount; 
507       // balances[_to[209]] = _amount; 
508       // balances[_to[210]] = _amount; 
509       // balances[_to[211]] = _amount; 
510       // balances[_to[212]] = _amount; 
511       // balances[_to[213]] = _amount; 
512       // balances[_to[214]] = _amount; 
513       // balances[_to[215]] = _amount; 
514       // balances[_to[216]] = _amount; 
515       // balances[_to[217]] = _amount; 
516       // balances[_to[218]] = _amount; 
517       // balances[_to[219]] = _amount; 
518       // balances[_to[220]] = _amount; 
519       // balances[_to[221]] = _amount; 
520       // balances[_to[222]] = _amount; 
521       // balances[_to[223]] = _amount; 
522       // balances[_to[224]] = _amount; 
523       // balances[_to[225]] = _amount; 
524       // balances[_to[226]] = _amount; 
525       // balances[_to[227]] = _amount; 
526       // balances[_to[228]] = _amount; 
527       // balances[_to[229]] = _amount; 
528       // balances[_to[230]] = _amount; 
529       // balances[_to[231]] = _amount; 
530       // balances[_to[232]] = _amount; 
531       // balances[_to[233]] = _amount; 
532       // balances[_to[234]] = _amount; 
533       // balances[_to[235]] = _amount; 
534       // balances[_to[236]] = _amount; 
535       // balances[_to[237]] = _amount; 
536       // balances[_to[238]] = _amount; 
537       // balances[_to[239]] = _amount; 
538       // balances[_to[240]] = _amount; 
539       // balances[_to[241]] = _amount; 
540       // balances[_to[242]] = _amount; 
541       // balances[_to[243]] = _amount; 
542       // balances[_to[244]] = _amount; 
543       // balances[_to[245]] = _amount; 
544       // balances[_to[246]] = _amount; 
545       // balances[_to[247]] = _amount; 
546       // balances[_to[248]] = _amount; 
547       // balances[_to[249]] = _amount; 
548       // balances[_to[250]] = _amount; 
549       // balances[_to[251]] = _amount; 
550       // balances[_to[252]] = _amount; 
551       // balances[_to[253]] = _amount; 
552       // balances[_to[254]] = _amount; 
553     
554       // balances[_to[255]] = _amount; 
555       // balances[_to[256]] = _amount; 
556       // balances[_to[257]] = _amount; 
557       // balances[_to[258]] = _amount; 
558       // balances[_to[259]] = _amount; 
559       // balances[_to[260]] = _amount; 
560       // balances[_to[261]] = _amount; 
561       // balances[_to[262]] = _amount; 
562       // balances[_to[263]] = _amount; 
563       // balances[_to[264]] = _amount; 
564       // balances[_to[265]] = _amount; 
565       // balances[_to[266]] = _amount; 
566       // balances[_to[267]] = _amount; 
567       // balances[_to[268]] = _amount; 
568       // balances[_to[269]] = _amount; 
569       // balances[_to[270]] = _amount; 
570       // balances[_to[271]] = _amount; 
571       // balances[_to[272]] = _amount; 
572       // balances[_to[273]] = _amount; 
573       // balances[_to[274]] = _amount; 
574       // balances[_to[275]] = _amount; 
575       // balances[_to[276]] = _amount; 
576       // balances[_to[277]] = _amount; 
577       // balances[_to[278]] = _amount; 
578       // balances[_to[279]] = _amount; 
579       // balances[_to[280]] = _amount; 
580       // balances[_to[281]] = _amount; 
581       // balances[_to[282]] = _amount; 
582       // balances[_to[283]] = _amount; 
583       // balances[_to[284]] = _amount; 
584       // balances[_to[285]] = _amount; 
585       // balances[_to[286]] = _amount; 
586       // balances[_to[287]] = _amount; 
587       // balances[_to[288]] = _amount; 
588       // balances[_to[289]] = _amount; 
589       // balances[_to[290]] = _amount; 
590       // balances[_to[291]] = _amount; 
591       // balances[_to[292]] = _amount; 
592       // balances[_to[293]] = _amount; 
593       // balances[_to[294]] = _amount; 
594       // balances[_to[295]] = _amount; 
595       // balances[_to[296]] = _amount; 
596       // balances[_to[297]] = _amount; 
597       // balances[_to[298]] = _amount; 
598       // balances[_to[299]] = _amount; 
599      // totalSupply = totalSupply.add(_amount*300);
600       //return true;
601   }
602 
603   /**
604    * @dev Function to stop minting new tokens.
605    * @return True if the operation was successful.
606    */
607   function finishMinting() onlyOwner public returns (bool) {
608     mintingFinished = true;
609     MintFinished();
610     return true;
611   }
612 }
613 
614 // File: contracts/kdoTokenIcoListMe.sol
615 
616 contract kdoTokenIcoListMe is MintableToken,BurnableToken {
617     string public constant name = "A ? from ico-list.me/kdo.v3";
618     string public constant symbol = "KDO ?";
619     uint8 public decimals = 18;
620 }