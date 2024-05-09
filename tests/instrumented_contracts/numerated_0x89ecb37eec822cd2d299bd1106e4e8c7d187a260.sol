1 /**
2  * @title SafeMath
3  * @dev Math operations with safety checks that throw on error
4  */
5 library SafeMath {
6 
7   /**
8   * @dev Multiplies two numbers, throws on overflow.
9   */
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   /**
20   * @dev Integer division of two numbers, truncating the quotient.
21   */
22   function div(uint256 a, uint256 b) internal pure returns (uint256) {
23     // assert(b > 0); // Solidity automatically throws when dividing by 0
24     uint256 c = a / b;
25     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26     return c;
27   }
28 
29   /**
30   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
31   */
32   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37   /**
38   * @dev Adds two numbers, throws on overflow.
39   */
40   function add(uint256 a, uint256 b) internal pure returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 
47 /**
48  * @title ERC20Basic
49  * @dev Simpler version of ERC20 interface
50  * @dev see https://github.com/ethereum/EIPs/issues/179
51  */
52 contract ERC20Basic {
53   function totalSupply() public view returns (uint256);
54   function balanceOf(address who) public view returns (uint256);
55   function transfer(address to, uint256 value) public returns (bool);
56   event Transfer(address indexed from, address indexed to, uint256 value);
57 }
58 
59 /**
60  * @title ERC20 interface
61  * @dev see https://github.com/ethereum/EIPs/issues/20
62  */
63 contract ERC20 is ERC20Basic {
64   function allowance(address owner, address spender) public view returns (uint256);
65   function transferFrom(address from, address to, uint256 value) public returns (bool);
66   function approve(address spender, uint256 value) public returns (bool);
67   event Approval(address indexed owner, address indexed spender, uint256 value);
68 }
69 
70 
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) balances;
79 
80   uint256 totalSupply_;
81 
82   /**
83   * @dev total number of tokens in existence
84   */
85   function totalSupply() public view returns (uint256) {
86     return totalSupply_;
87   }
88 
89   /**
90   * @dev transfer token for a specified address
91   * @param _to The address to transfer to.
92   * @param _value The amount to be transferred.
93   */
94   function transfer(address _to, uint256 _value) public returns (bool) {
95     require(_to != address(0));
96     require(_value <= balances[msg.sender]);
97 
98     // SafeMath.sub will throw if there is not enough balance.
99     balances[msg.sender] = balances[msg.sender].sub(_value);
100     balances[_to] = balances[_to].add(_value);
101     Transfer(msg.sender, _to, _value);
102     return true;
103   }
104 
105   /**
106   * @dev Gets the balance of the specified address.
107   * @param _owner The address to query the the balance of.
108   * @return An uint256 representing the amount owned by the passed address.
109   */
110   function balanceOf(address _owner) public view returns (uint256 balance) {
111     return balances[_owner];
112   }
113 
114 }
115 
116 
117 
118 
119 /**
120  * @title Standard ERC20 token
121  *
122  * @dev Implementation of the basic standard token.
123  * @dev https://github.com/ethereum/EIPs/issues/20
124  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
125  */
126 contract StandardToken is ERC20, BasicToken {
127 
128   mapping (address => mapping (address => uint256)) internal allowed;
129 
130 
131   /**
132    * @dev Transfer tokens from one address to another
133    * @param _from address The address which you want to send tokens from
134    * @param _to address The address which you want to transfer to
135    * @param _value uint256 the amount of tokens to be transferred
136    */
137   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
138     require(_to != address(0));
139     require(_value <= balances[_from]);
140     require(_value <= allowed[_from][msg.sender]);
141 
142     balances[_from] = balances[_from].sub(_value);
143     balances[_to] = balances[_to].add(_value);
144     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
145     Transfer(_from, _to, _value);
146     return true;
147   }
148 
149   /**
150    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
151    *
152    * Beware that changing an allowance with this method brings the risk that someone may use both the old
153    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
154    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
155    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
156    * @param _spender The address which will spend the funds.
157    * @param _value The amount of tokens to be spent.
158    */
159   function approve(address _spender, uint256 _value) public returns (bool) {
160     allowed[msg.sender][_spender] = _value;
161     Approval(msg.sender, _spender, _value);
162     return true;
163   }
164 
165   /**
166    * @dev Function to check the amount of tokens that an owner allowed to a spender.
167    * @param _owner address The address which owns the funds.
168    * @param _spender address The address which will spend the funds.
169    * @return A uint256 specifying the amount of tokens still available for the spender.
170    */
171   function allowance(address _owner, address _spender) public view returns (uint256) {
172     return allowed[_owner][_spender];
173   }
174 
175   /**
176    * @dev Increase the amount of tokens that an owner allowed to a spender.
177    *
178    * approve should be called when allowed[_spender] == 0. To increment
179    * allowed value is better to use this function to avoid 2 calls (and wait until
180    * the first transaction is mined)
181    * From MonolithDAO Token.sol
182    * @param _spender The address which will spend the funds.
183    * @param _addedValue The amount of tokens to increase the allowance by.
184    */
185   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
186     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
187     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
188     return true;
189   }
190 
191   /**
192    * @dev Decrease the amount of tokens that an owner allowed to a spender.
193    *
194    * approve should be called when allowed[_spender] == 0. To decrement
195    * allowed value is better to use this function to avoid 2 calls (and wait until
196    * the first transaction is mined)
197    * From MonolithDAO Token.sol
198    * @param _spender The address which will spend the funds.
199    * @param _subtractedValue The amount of tokens to decrease the allowance by.
200    */
201   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
202     uint oldValue = allowed[msg.sender][_spender];
203     if (_subtractedValue > oldValue) {
204       allowed[msg.sender][_spender] = 0;
205     } else {
206       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
207     }
208     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
209     return true;
210   }
211 
212 }
213 
214 /**
215  * @title Boosto Pool
216  */
217 contract BoostoPool{
218     using SafeMath for uint256;
219 
220     // total number of investors
221     uint256 public totalInvestors;
222 
223     address[] investorsList;
224 
225     mapping(address => bool) public investors;
226     mapping(address => bool) public winners;
227 
228     address private BSTContract = 0xDf0041891BdA1f911C4243f328F7Cf61b37F965b;
229     address private fundsWallet;
230     address private operatorWallet;
231 
232     uint256 public unit;
233     uint256 public size;
234 
235     uint256 public BSTAmount;
236 
237     uint256 public winnerCount;
238     uint256 public paidWinners = 0;
239 
240     uint256 public bonus;
241     bool public bonusInETH;
242 
243     uint256 public startDate;
244     uint256 public duration; // in seconds
245 
246     /**
247      * @dev Creates a new pool
248      */
249     constructor(
250         uint256 _startDate,
251         uint256 _duration,
252         uint256 _winnerCount,
253         uint256 _bonus,
254         bool _bonusInETH,
255         uint256 _unit,
256         uint256 _BSTAmount,
257         uint256 _size,
258         address _fundsWallet,
259         address _operatorWallet
260         ) public{
261         
262         startDate = _startDate;
263         duration = _duration;
264         
265         winnerCount = _winnerCount;
266         bonus = _bonus;
267         bonusInETH = _bonusInETH;
268         unit = _unit;
269         BSTAmount = _BSTAmount;
270         size = _size;
271 
272         fundsWallet = _fundsWallet;
273         operatorWallet = _operatorWallet;
274     }
275 
276     /**
277      * @dev Checks if the pool is still open or not
278      */
279     modifier isPoolOpen() {
280         require(totalInvestors < size && now < (startDate + duration) && now >= startDate);
281         _;
282     }
283 
284     /**
285      * @dev Checks if the pool is closed
286      */
287     modifier isPoolClosed() {
288         require(totalInvestors >= size || now >= (startDate + duration));
289         _;
290     }
291 
292     /**
293      * @dev Checks if the pool is finished successfully
294      */
295     modifier isPoolFinished() {
296         require(totalInvestors >= size);
297         _;
298     }
299 
300     /**
301      * @dev modifier for check msg.value
302      */
303     modifier checkInvestAmount(){
304         require(msg.value == unit);
305         _;
306     }
307 
308     /**
309      * @dev check if the sender is already invested
310      */
311     modifier notInvestedYet(){
312         require(!investors[msg.sender]);
313         _;
314     }
315 
316     /**
317      * @dev check if the sender is admin
318      */
319     modifier isAdmin(){
320         require(msg.sender == operatorWallet);
321         _;
322     }
323 
324     /**
325      * @dev fallback function
326      */
327     function() checkInvestAmount notInvestedYet isPoolOpen payable public{
328         fundsWallet.transfer(msg.value);
329 
330         StandardToken bst = StandardToken(BSTContract);
331         bst.transfer(msg.sender, BSTAmount);
332 
333         investorsList[investorsList.length++] = msg.sender;
334         investors[msg.sender] = true;
335 
336         totalInvestors += 1;
337     }
338 
339     /**
340      * @dev Allows the admin to tranfer ETH to SC 
341      * when bounus is in ETH
342      */
343     function adminDropETH() isAdmin payable public{
344         assert(bonusInETH);
345         assert(msg.value == winnerCount.mul(bonus));
346     }
347 
348     /**
349      * @dev Allows the admin to withdraw remaining token and ETH when
350      * the pool is closed and not reached the goal(no rewards)
351      */
352     function adminWithdraw() isAdmin isPoolClosed public{
353         assert(totalInvestors <= size);
354 
355         StandardToken bst = StandardToken(BSTContract);
356         uint256 bstBalance = bst.balanceOf(this);
357 
358         if(bstBalance > 0){
359             bst.transfer(msg.sender, bstBalance);
360         }
361 
362         uint256 ethBalance = address(this).balance;
363         if(ethBalance > 0){
364             msg.sender.transfer(ethBalance);
365         }
366     }
367 
368     /**
369      * @dev Selects a random winner and transfer the funds.
370      * This function could fail when the selected wallet is a duplicate winner
371      * and need to try again to select an another random investor.
372      * When we have N winners, the admin need to call this function N times. This is 
373      * not an efficient method but since we have just a few winners it will work fine.
374      */
375     function adminAddWinner() isPoolFinished isAdmin public{
376         assert(paidWinners < winnerCount);
377         uint256 winnerIndex = random();
378         assert(!winners[investorsList[winnerIndex]]);
379 
380         winners[investorsList[winnerIndex]] = true;
381         paidWinners += 1;
382 
383         if(bonusInETH){
384             investorsList[winnerIndex].transfer(bonus);
385         }else{
386             StandardToken(BSTContract).transfer(investorsList[winnerIndex], bonus);
387         }
388     }
389 
390     /**
391      * @dev Selects a random winner among all investors
392      */
393     function random() public view returns (uint256) {
394         return uint256(keccak256(block.timestamp, block.difficulty))%size;
395     }
396 
397     /**
398      * @dev Returns the details of an investor by its index.
399      * UI can use this function to show the info.
400      * @param index Index of the investor in investorsList
401      */
402     function getWalletInfoByIndex(uint256 index) 
403             public constant returns (address _addr, bool _isWinner){
404         _addr = investorsList[index];
405         _isWinner = winners[_addr];
406     }
407 
408     /**
409      * @dev Returns the details of an investor
410      * UI can use this function to show the info.
411      * @param addr Address of the investor
412      */
413     function getWalletInfo(address addr) 
414             public constant returns (bool _isWinner){
415         _isWinner = winners[addr];
416     }
417 
418     /**
419      * @dev checks if there is enough funds in the contract or not
420      * @param status Boolean to show if there is enough funds or not
421      */
422     function isHealthy() 
423             public constant returns (bool status){
424 
425         // ETH balance is not enough
426         if(bonusInETH && address(this).balance < winnerCount.mul(bonus)){
427             return false;
428         }
429         
430         uint256 bstBalance = StandardToken(BSTContract).balanceOf(this);
431 
432         uint256 enoughBalance = BSTAmount.mul(size - totalInvestors); 
433         if(!bonusInETH){
434             enoughBalance = bstBalance.add(winnerCount.mul(bonus));
435         }
436         if(bstBalance < enoughBalance){
437             return false;
438         }
439         return true;
440     }
441 }
442 
443 contract BoostoPoolFactory {
444 
445     event NewPool(address creator, address pool);
446 
447     function createNew(
448         uint256 _startDate,
449         uint256 _duration,
450         uint256 _winnerCount,
451         uint256 _bonus,
452         bool _bonusInETH,
453         uint256 _unit,
454         uint256 _BSTAmount,
455         uint256 _size,
456         address _fundsWallet,
457         address _operatorWallet
458     ) public returns(address created){
459         address ret = new BoostoPool(
460             _startDate,
461             _duration,
462             _winnerCount,
463             _bonus,
464             _bonusInETH,
465             _unit,
466             _BSTAmount,
467             _size,
468             _fundsWallet,
469             _operatorWallet
470         );
471         emit NewPool(msg.sender, ret);
472     }
473 }