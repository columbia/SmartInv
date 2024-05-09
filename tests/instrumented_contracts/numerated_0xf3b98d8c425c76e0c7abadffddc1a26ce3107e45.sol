1 pragma solidity ^0.4.21;
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
212  * @title Mintable token
213  * @dev Simple ERC20 Token example, with mintable token creation
214  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
215  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
216  */
217 contract MintableToken is StandardToken {
218   event Mint(address indexed to, uint256 amount);
219   event MintFinished();
220 
221   bool public mintingFinished = false;
222 
223 
224   modifier canMint() {
225     require(!mintingFinished);
226     _;
227   }
228 
229   /**
230    * @dev Function to mint tokens
231    * @param _to The address that will receive the minted tokens.
232    * @param _amount The amount of tokens to mint.
233    * @return A boolean that indicates if the operation was successful.
234    */
235   function mint(address _to, uint256 _amount) canMint internal returns (bool) {
236     totalSupply_ = totalSupply_.add(_amount);
237     balances[_to] = balances[_to].add(_amount);
238     emit Mint(_to, _amount);
239     emit Transfer(address(0), _to, _amount);
240     return true;
241   }
242 
243   /**
244    * @dev Function to stop minting new tokens.
245    * @return True if the operation was successful.
246    */
247   function finishMinting() canMint internal returns (bool) {
248     mintingFinished = true;
249     emit MintFinished();
250     return true;
251   }
252 }
253 
254 /**
255  * @title Ownable
256  * @dev The Ownable contract has an owner address, and provides basic authorization control
257  * functions, this simplifies the implementation of "user permissions".
258  */
259 contract Ownable {
260   address public owner;
261 
262 
263   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
264 
265 
266   /**
267    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
268    * account.
269    */
270   function Ownable() public {
271     owner = msg.sender;
272   }
273 
274   /**
275    * @dev Throws if called by any account other than the owner.
276    */
277   modifier onlyOwner() {
278     require(msg.sender == owner);
279     _;
280   }
281 
282   /**
283    * @dev Allows the current owner to transfer control of the contract to a newOwner.
284    * @param newOwner The address to transfer ownership to.
285    */
286   function transferOwnership(address newOwner) public onlyOwner {
287     require(newOwner != address(0));
288     emit OwnershipTransferred(owner, newOwner);
289     owner = newOwner;
290   }
291 
292 }
293 
294 contract MTF is MintableToken, Ownable {
295 
296     using SafeMath for uint256;
297     //The name of the  token
298     string public constant name = "MintFlint Token";
299     //The token symbol
300     string public constant symbol = "MTF";
301     //The precision used in the balance calculations in contract
302     uint8 public constant decimals = 18;
303 
304     //maximum cap to be sold on ICO
305     uint256 public constant maxCap = 1500000000e18;
306     //to save total number of ethers received
307     uint256 public totalWeiReceived;
308 
309     //time when the sale starts
310     uint256 public startTime;
311     //time when the presale ends
312     uint256 public endTime;
313     //to check the sale status
314     bool public paused;
315 
316     //events
317     event StateChanged(bool);
318     event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
319 
320     function MTF(uint256 _startTime, uint256 _endTime) public {
321         startTime = _startTime;
322         endTime = _endTime;
323         paused = false;
324         totalSupply_ = 0;
325     }
326 
327     modifier whenSaleEnded() {
328         require(now >= endTime);
329         _;
330     }
331 
332     /**
333      * @dev to determine the timeframe of sale
334      */
335     modifier validTimeframe() {
336         require(!paused && now >=startTime && now < endTime);
337         _;
338     }
339 
340     /**
341      * @dev Allocate tokens to team members
342      */
343     function teamAllocation(address _airdropAddress) public onlyOwner whenSaleEnded {
344         uint256 toDistribute = totalSupply_.mul(2);
345         // Receiver1 3.0%
346         uint256 part1 = toDistribute.mul(3).div(400);
347         mint(0x1117Db9F1bf18C91233Bff3BF2676137709463B3, part1);
348         mint(0x6C137b489cEE58C32fd8Aec66EAdC4B959550198, part1);
349         mint(0x450023b2D943498949f0A9cdb1DbBd827844EE78, part1);
350         mint(0x89080db76A555c42D7b43556E40AcaAFeB786CDD, part1);
351 
352         // Receiver2 19.5%
353         uint256 part2 = toDistribute.mul(195).div(4000);
354         mint(0xcFc43257606C6a642d9438dCd82bf5b39A17dbAB, part2);
355         mint(0x4a8C5Ea0619c40070f288c8aC289ef2f6Bb87cff, part2);
356         mint(0x947251376EeAFb0B0CD1bD47cC6056A5162bEaF4, part2);
357         mint(0x39A49403eFB1e85F835A9e5dc82706B970D112e4, part2);
358 
359         // Receiver3 2.0% 0x733bc7201261aC3c9508D20a811D99179304240a
360         mint(0x733bc7201261aC3c9508D20a811D99179304240a, toDistribute.mul(2).div(100));
361 
362         // Receiver4 18.0% 0x4b6716bd349dC65d07152844ed4990C2077cF1a7
363         mint(0x4b6716bd349dC65d07152844ed4990C2077cF1a7, toDistribute.mul(18).div(100));
364 
365         // Receiver5 6% 0xEf628A29668C00d5C7C4D915F07188dC96cF24eb
366         uint256 part5 = toDistribute.mul(6).div(400);
367         mint(0xEf628A29668C00d5C7C4D915F07188dC96cF24eb, part5);
368         mint(0xF28a5e85316E0C950f8703e2d99F15A7c077014c, part5);
369         mint(0x0c8C9Dcfa4ed27e02349D536fE30957a32b44a04, part5);
370         mint(0x0A86174f18D145D3850501e2f4C160519207B829, part5);
371 
372         // Receiver6 1.50%
373         // 0.75% in 0x35eeb3216E2Ff669F2c1Ff90A08A22F60e6c5728 and
374         // 0.75% in 0x28dcC9Af670252A5f76296207cfcC29B4E3C68D5
375         mint(0x35eeb3216E2Ff669F2c1Ff90A08A22F60e6c5728, toDistribute.mul(75).div(10000));
376         mint(0x28dcC9Af670252A5f76296207cfcC29B4E3C68D5, toDistribute.mul(75).div(10000));
377 
378         mint(_airdropAddress, 175000000 ether);
379 
380         finishMinting();
381     }
382 
383     function transfer(address _to, uint _value) whenSaleEnded public returns(bool _success) {
384         return super.transfer(_to, _value);
385     }
386 
387     function transferFrom(address _from, address _to, uint256 _value) whenSaleEnded public returns (bool) {
388         return super.transferFrom(_from, _to, _value);
389     }
390 
391     /**
392     * @dev Calculate number of tokens that will be received in one ether
393     *
394     */
395     function getPrice() public pure returns(uint256) {
396         return 100000;
397     }
398 
399     /**
400     * @dev to enable pause sale for break in ICO and Pre-ICO
401     *
402     */
403     function pauseSale() public onlyOwner {
404         require(!paused);
405         paused = true;
406     }
407 
408     /**
409     * @dev to resume paused sale
410     *
411     */
412     function resumeSale() public onlyOwner {
413         require(paused);
414         paused = false;
415     }
416 
417     function buyTokens(address beneficiary) internal validTimeframe {
418         uint256 tokensBought = msg.value.mul(getPrice());
419         totalWeiReceived = totalWeiReceived.add(msg.value);
420         emit TokenPurchase(beneficiary, msg.value, tokensBought);
421         mint(beneficiary, tokensBought);
422         require(totalSupply_ <= maxCap);
423     }
424 
425     function () public payable {
426         buyTokens(msg.sender);
427     }
428 
429     /**
430     * @dev Failsafe drain.
431     */
432     function drain() public onlyOwner whenSaleEnded {
433         owner.transfer(address(this).balance);
434     }
435 }