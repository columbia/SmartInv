1 pragma solidity ^0.4.24;
2 
3 contract ERC20 {
4   function totalSupply() public view returns (uint256);
5 
6   function balanceOf(address _who) public view returns (uint256);
7 
8   function allowance(address _owner, address _spender)
9     public view returns (uint256);
10 
11   function transfer(address _to, uint256 _value) public returns (bool);
12 
13   function approve(address _spender, uint256 _value)
14     public returns (bool);
15 
16   function transferFrom(address _from, address _to, uint256 _value)
17     public returns (bool);
18 
19   event Transfer(
20     address indexed from,
21     address indexed to,
22     uint256 value
23   );
24 
25   event Approval(
26     address indexed owner,
27     address indexed spender,
28     uint256 value
29   );
30 }
31 
32 contract Ownable {
33 
34   // Owner's address
35   address public owner;
36 
37   /**
38    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
39    * account.
40    */
41   constructor() public {
42     owner = msg.sender;
43   }
44 
45   /**
46    * @dev Throws if called by any account other than the owner.
47    */
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52 
53   /**
54    * @dev Allows the current owner to transfer control of the contract to a newOwner.
55    * @param _newOwner The address to transfer ownership to.
56    */
57   function transferOwnership(address _newOwner) public onlyOwner {
58     require(_newOwner != address(0));
59     emit OwnerChanged(owner, _newOwner);
60     owner = _newOwner;
61   }
62 
63   event OwnerChanged(address indexed previousOwner,address indexed newOwner);
64 
65 }
66 
67 contract Pausable is Ownable {
68 
69     bool public paused = false;
70 
71     /**
72     * @dev Modifier to make a function callable only when the contract is not paused.
73     */
74     modifier whenNotPaused() {
75         require(!paused, "Contract is paused.");
76         _;
77     }
78 
79     /**
80     * @dev Modifier to make a function callable only when the contract is paused.
81     */
82     modifier whenPaused() {
83         require(paused);
84         _;
85     }
86 
87     /**
88     * @dev called by the owner to pause, triggers stopped state
89     */
90     function pause() public onlyOwner whenNotPaused {
91         paused = true;
92         emit Pause();
93     }
94 
95     /**
96     * @dev called by the owner to unpause, returns to normal state
97     */
98     function unpause() public onlyOwner whenPaused {
99         paused = false;
100         emit Unpause();
101     }
102 
103     event Pause();
104     event Unpause();
105 }
106 
107 library SafeMath {
108 
109   /**
110   * @dev Multiplies two numbers, throws on overflow.
111   */
112   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
113     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
114     // benefit is lost if 'b' is also tested.
115     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
116     if (_a == 0) {
117       return 0;
118     }
119 
120     c = _a * _b;
121     assert(c / _a == _b);
122     return c;
123   }
124 
125   /**
126   * @dev Integer division of two numbers, truncating the quotient.
127   */
128   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
129     // assert(_b > 0); // Solidity automatically throws when dividing by 0
130     // uint256 c = _a / _b;
131     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
132     return _a / _b;
133   }
134 
135   /**
136   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
137   */
138   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
139     assert(_b <= _a);
140     return _a - _b;
141   }
142 
143   /**
144   * @dev Adds two numbers, throws on overflow.
145   */
146   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
147     c = _a + _b;
148     assert(c >= _a);
149     return c;
150   }
151 }
152 
153 contract StandardToken is ERC20 {
154   using SafeMath for uint256;
155 
156   mapping(address => uint256) balances;
157 
158   mapping (address => mapping (address => uint256)) internal allowed;
159 
160   uint256 totalSupply_;
161 
162   /**
163   * @dev Total number of tokens in existence
164   */
165   function totalSupply() public view returns (uint256) {
166     return totalSupply_;
167   }
168 
169   /**
170   * @dev Gets the balance of the specified address.
171   * @param _owner The address to query the the balance of.
172   * @return An uint256 representing the amount owned by the passed address.
173   */
174   function balanceOf(address _owner) public view returns (uint256) {
175     return balances[_owner];
176   }
177 
178   /**
179    * @dev Function to check the amount of tokens that an owner allowed to a spender.
180    * @param _owner address The address which owns the funds.
181    * @param _spender address The address which will spend the funds.
182    * @return A uint256 specifying the amount of tokens still available for the spender.
183    */
184   function allowance(
185     address _owner,
186     address _spender
187    )
188     public
189     view
190     returns (uint256)
191   {
192     return allowed[_owner][_spender];
193   }
194 
195   /**
196   * @dev Transfer token for a specified address
197   * @param _to The address to transfer to.
198   * @param _value The amount to be transferred.
199   */
200   function transfer(address _to, uint256 _value) public returns (bool) {
201     require(_value <= balances[msg.sender]);
202     require(_to != address(0));
203 
204     balances[msg.sender] = balances[msg.sender].sub(_value);
205     balances[_to] = balances[_to].add(_value);
206     emit Transfer(msg.sender, _to, _value);
207     return true;
208   }
209 
210   /**
211    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
212    * Beware that changing an allowance with this method brings the risk that someone may use both the old
213    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
214    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
215    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
216    * @param _spender The address which will spend the funds.
217    * @param _value The amount of tokens to be spent.
218    */
219   function approve(address _spender, uint256 _value) public returns (bool) {
220     allowed[msg.sender][_spender] = _value;
221     emit Approval(msg.sender, _spender, _value);
222     return true;
223   }
224 
225   /**
226    * @dev Transfer tokens from one address to another
227    * @param _from address The address which you want to send tokens from
228    * @param _to address The address which you want to transfer to
229    * @param _value uint256 the amount of tokens to be transferred
230    */
231   function transferFrom(
232     address _from,
233     address _to,
234     uint256 _value
235   )
236     public
237     returns (bool)
238   {
239     require(_value <= balances[_from]);
240     require(_value <= allowed[_from][msg.sender]);
241     require(_to != address(0));
242 
243     balances[_from] = balances[_from].sub(_value);
244     balances[_to] = balances[_to].add(_value);
245     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
246     emit Transfer(_from, _to, _value);
247     return true;
248   }
249 
250   /**
251    * @dev Increase the amount of tokens that an owner allowed to a spender.
252    * approve should be called when allowed[_spender] == 0. To increment
253    * allowed value is better to use this function to avoid 2 calls (and wait until
254    * the first transaction is mined)
255    * From MonolithDAO Token.sol
256    * @param _spender The address which will spend the funds.
257    * @param _addedValue The amount of tokens to increase the allowance by.
258    */
259   function increaseApproval(
260     address _spender,
261     uint256 _addedValue
262   )
263     public
264     returns (bool)
265   {
266     allowed[msg.sender][_spender] = (
267       allowed[msg.sender][_spender].add(_addedValue));
268     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
269     return true;
270   }
271 
272   /**
273    * @dev Decrease the amount of tokens that an owner allowed to a spender.
274    * approve should be called when allowed[_spender] == 0. To decrement
275    * allowed value is better to use this function to avoid 2 calls (and wait until
276    * the first transaction is mined)
277    * From MonolithDAO Token.sol
278    * @param _spender The address which will spend the funds.
279    * @param _subtractedValue The amount of tokens to decrease the allowance by.
280    */
281   function decreaseApproval(
282     address _spender,
283     uint256 _subtractedValue
284   )
285     public
286     returns (bool)
287   {
288     uint256 oldValue = allowed[msg.sender][_spender];
289     if (_subtractedValue >= oldValue) {
290       allowed[msg.sender][_spender] = 0;
291     } else {
292       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
293     }
294     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
295     return true;
296   }
297 
298 }
299 
300 contract PausableToken is StandardToken, Pausable {
301 
302   function transfer(
303     address _to,
304     uint256 _value
305   )
306     public
307     whenNotPaused
308     returns (bool)
309   {
310     return super.transfer(_to, _value);
311   }
312 
313   function transferFrom(
314     address _from,
315     address _to,
316     uint256 _value
317   )
318     public
319     whenNotPaused
320     returns (bool)
321   {
322     return super.transferFrom(_from, _to, _value);
323   }
324 
325   function approve(
326     address _spender,
327     uint256 _value
328   )
329     public
330     whenNotPaused
331     returns (bool)
332   {
333     return super.approve(_spender, _value);
334   }
335 
336   function increaseApproval(
337     address _spender,
338     uint _addedValue
339   )
340     public
341     whenNotPaused
342     returns (bool success)
343   {
344     return super.increaseApproval(_spender, _addedValue);
345   }
346 
347   function decreaseApproval(
348     address _spender,
349     uint _subtractedValue
350   )
351     public
352     whenNotPaused
353     returns (bool success)
354   {
355     return super.decreaseApproval(_spender, _subtractedValue);
356   }
357 }
358 
359 contract ElpisToken is PausableToken {
360 
361     // token name
362     string public constant name = "Elpis AI Trading Token";
363     
364     // token symbol
365     string public constant symbol = "ELP";
366 
367     // token decimals
368     uint8 public constant decimals = 18;
369     
370     // contract deployment block
371     uint256 public deploymentBlock;
372 
373     constructor() public {
374         deploymentBlock = block.number;
375         totalSupply_ = 250000000 ether;
376         balances[msg.sender] = totalSupply_;
377         
378         // special contributors
379         transfer(0x6467704b5CD5a5A380656886AE0284133825D378, 7000000000000000000000000);
380         transfer(0x7EF7F9104867454f0E3cd8B4aE99045a01f605c0, 1000000000000000000000000);
381 
382         // transfer to existing contributors
383         transfer(0x1499493fd2fdb2c6d536569322fe37f5da24a5c9, 4672955120000000000000000);
384         transfer(0x22a5c82364faa085394b6e82d8d39643d0ad38e7, 2500000000000000000000000);
385         transfer(0xdc64259785a9dbae1b40fee4dfe2055af4fefd6b, 2000000000000000000000000);
386         transfer(0xbd14c21b0ed5fefee65d9c0609136fff8aafb1e8, 1500000000000000000000000);
387         transfer(0x4aca633f98559bb7e6025c629e1789537b9ee72f, 1000000000000000000000000);
388         transfer(0x4aeac209d18151f79ff5dc320619a554872b099d, 1000000000000000000000000);
389         transfer(0x9d3b6f11c9f17bf98e1bc8618a17bb1e9928e1c1, 1000000000000000000000000);
390         transfer(0xffdfb7ef8e05b02a6bc024c15ce5e89f0561a6f7, 646900270000000000000000);
391         transfer(0x6d91062c251eb5042a71312e704c297fb924409c, 379937110000000000000000);
392         transfer(0x5182531e3ebeb35af19e00fa5de03a12d46eba72, 379200360000000000000000);
393         transfer(0x8b751c5d881ab355a0b5109ea1a1a7e0a7c0ea36, 125000000000000000000000);
394         transfer(0x6a877aa35ef434186985d07270ba50685d1b7ada, 60000000000000000000000);
395         transfer(0x9ecedc01e9fde532a5f30f398cbc0261e88136a1, 28264000000000000000000);
396         transfer(0xd24400ae8bfebb18ca49be86258a3c749cf46853, 22641509433000000000000);
397         transfer(0x964fcf14cbbd03b89caab136050cc02e6949d5e7, 15094339622000000000000);
398         transfer(0xdc8ce4f0278968f48c059461abbc59c27c08b6f0, 10062893081000000000000);
399         transfer(0x2c06c71e718ca02435804b0ce313a1333cb06d02, 9811320754000000000000);
400         transfer(0x9cca8e43a9a37c3969bfd0d3e0cdf60e732c0cee, 8050314464000000000000);
401         transfer(0xa48f71410d01ec4ca59c36af3a2e2602c28d8fc2, 7547169811000000000000);
402         transfer(0xeb5e9a1469da277b056a4bc250af4489eda36621, 5031446540000000000000);
403         transfer(0xbb5c14e2a821c0bada4ae7217d23c919472f7f77, 3773584905000000000000);
404         transfer(0x46b5c439228015e2596c7b2da8e81a705990c6ac, 3773584905000000000000);
405         transfer(0x3e7a3fb0976556aaf12484de68350ac3b6ae4c40, 2515723270000000000000);
406         transfer(0xe14362f83a0625e57f1ca92d515c3c060d7d5659, 2264150943000000000000);
407         transfer(0x795df9a9699b399ffc512732d2c797c781c22bc7, 1509433962000000000000);
408         transfer(0xaca9fd46bfa5e903a75fb604f977792bd349a1af, 1396226415000000000000);
409         transfer(0xe2cdffd7b906cdd7ae74d8eb8553328a66d12b84, 1368887886000000000000);
410         transfer(0xee76d34d75ee0a72540abca5b26270b975f6adb6, 1320754716000000000000);
411         transfer(0xc44aa2d68d51fa5195b3d03af14a3706feeb29fc, 1320754716000000000000);
412         transfer(0xe694d8dd4b01bb12cb44568ebed792bd45a3f2cf, 1257861635000000000000);
413         transfer(0x9484e40deff4c6b4a475fe7625d3c70c71f54db7, 1207547169000000000000);
414         transfer(0x15ae5afd84c15f740a28a45fe166e161e3ed9251, 1132075471000000000000);
415         transfer(0x7fd9138acbcf9b1600eea70befe87729cc30968b, 1006289308000000000000);
416         transfer(0xfd3c389d724a230b4d086a77c83013ef6b4afdf1, 766037735000000000000);
417         transfer(0x774c988ec49df627093b6755c3baebb0d9a9d0b3, 758650475000000000000);
418         transfer(0x7a0702d58d6a4b6f06a9d275dc027555148e81c7, 754716981000000000000);
419         transfer(0x4b1b467a6a80af7ebc53051015e089b20588f1e7, 566037735000000000000);
420         transfer(0x0f6e5559ba758638d0931528967a54b9b5182b93, 566037735000000000000);
421         transfer(0xc1ec7ea396923d1a866a4f3798a87d1a92b9e37a, 556345720000000000000);
422         transfer(0x64bea49dd8d3a328a4aa4c739d776b0bfdda6128, 503144654000000000000);
423         transfer(0x472745526b7f72f7a9eb117e738f309d2abcc1a2, 503144654000000000000);
424         transfer(0xe3f68a6b6b39534a975eb9605dd71c8e36989e52, 490566037000000000000);
425         transfer(0x0caef953d12a24680c821d6e292a74634351d5a6, 452830188000000000000);
426         transfer(0x3f5d8a83b470b9d51b9c5a9ac1928e4e77a37842, 427942513000000000000);
427         transfer(0xfbb1b73c4f0bda4f67dca266ce6ef42f520fbb98, 422382641000000000000);
428         transfer(0x0b9fe4475e6a5ecbfb1fefc56c4c28fe97064dc1, 415094339000000000000);
429         transfer(0x83658d1d001092cabf33502cd1c66c91c16a18a6, 377358490000000000000);
430         transfer(0x236bea162cc2115b20309c632619ac876682becc, 94339622000000000000);
431         transfer(0xdfb2b0210081bd17bc30bd163c415ba8a0f3e316, 60314465000000000000);
432         transfer(0x92df16e27d3147cf05e190e633bf934e654eec86, 50314465000000000000);
433         transfer(0x6dd451c3f06a24da0b37d90e709f0e9f08987673, 40314465000000000000);
434         transfer(0x550c6de28d89d876ca5b45e3b87e5ae4374aa770, 1000000000000000000);
435     }
436 
437     /**
438     * @dev Revertible fallback function
439     */
440     function() external payable {
441         revert();
442     }
443 
444     /**
445     * @dev This method can be used by the owner to extract mistakenly sent tokens
446     * or Ether sent to this contract.
447     * @param _token address The address of the token contract that you want to
448     * recover set to 0 in case you want to extract ether.
449     */
450     function claimTokens(address _token) public onlyOwner {
451         if (_token == address(0)) {
452             owner.transfer(address(this).balance);
453             return;
454         }
455 
456         ERC20 token = ERC20(_token);
457         uint balance = token.balanceOf(address(this));
458         token.transfer(owner, balance);
459         emit ClaimedTokens(_token, owner, balance);
460     }
461 
462     /**
463     * @dev Owner can burn a specific amount of tokens from the target address.
464     * @param _target address The address which you want to burn tokens from
465     * @param _value uint256 The amount of token to be burned
466     */
467     function burn(address _target, uint256 _value) public onlyOwner {
468         require(_value <= balances[_target]);
469         balances[_target] = balances[_target].sub(_value);
470         totalSupply_ = totalSupply_.sub(_value);
471         emit Burn(_target, _value);
472         emit Transfer(_target, address(0), _value);
473     }
474 
475     /** 
476     * Event for logging burning tokens
477     * @param burner whose tokens are burned
478     * @param value value of burned tokens
479     */
480     event Burn(address indexed burner, uint256 value);
481 
482     /** 
483     * Event for logging when tokens are claimed
484     * @param token claimed token
485     * @param owner who owns the contract
486     * @param amount amount of the claimed token
487     */
488     event ClaimedTokens(address indexed token, address indexed owner, uint256 amount);
489 
490 }