1 /**
2  * The OGXNext "Orgura Exchange" token contract bases on the ERC20 standard token contracts 
3  * OGX Coin ICO. (Orgura group)
4  * authors: Roongrote Suranart
5  * */
6 
7 pragma solidity ^0.4.20;
8 
9 library SafeMath {
10     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11         uint256 c = a * b;
12         require(a == 0 || c / a == b);
13         return c;
14     }
15 
16     function div(uint256 a, uint256 b) internal pure returns (uint256) {
17         // assert(b > 0); // Solidity automatically throws when dividing by 0
18         uint256 c = a / b;
19         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20         return c;
21     }
22 
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         require(b <= a);
25         return a - b;
26     }
27 
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a);
31         return c;
32     }
33 }
34 
35 
36 /**
37  * @title ERC20Basic
38  * @dev Simpler version of ERC20 interface
39  * @dev see https://github.com/ethereum/EIPs/issues/179
40  */
41 contract ERC20Basic {
42     uint256 public totalSupply;
43     function balanceOf(address who) public view returns (uint256);
44     function transfer(address to, uint256 value) public returns (bool);
45     event Transfer(address indexed from, address indexed to, uint256 value);
46 }
47 
48 /**
49  * @title Basic token
50  * @dev Basic version of StandardToken, with no allowances.
51  */
52 contract BasicToken is ERC20Basic {
53     using SafeMath for uint256;
54 
55     mapping(address => uint256) public balances;
56 
57     /**
58     * @dev transfer token for a specified address
59     * @param _to The address to transfer to.
60     * @param _value The amount to be transferred.
61     */
62     function transfer(address _to, uint256 _value) public returns (bool) {
63         require(_to != address(0));
64         require(_value <= balances[msg.sender]);
65 
66         // SafeMath.sub will throw if there is not enough balance.
67         balances[msg.sender] = balances[msg.sender].sub(_value);
68         balances[_to] = balances[_to].add(_value);
69         Transfer(msg.sender, _to, _value);
70         return true;
71     }
72 
73     /**
74     * @dev Gets the balance of the specified address.
75     * @param _owner The address to query the the balance of.
76     * @return An uint256 representing the amount owned by the passed address.
77     */
78     function balanceOf(address _owner) public view returns (uint256 balance) {
79         return balances[_owner];
80     }
81 
82 }
83 
84 /**
85  * @title ERC20 interface
86  * @dev see https://github.com/ethereum/EIPs/issues/20
87  */
88 contract ERC20 is ERC20Basic {
89     function allowance(address owner, address spender) public view returns (uint256);
90     function transferFrom(address from, address to, uint256 value) public returns (bool);
91     function approve(address spender, uint256 value) public returns (bool);
92     event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 /**
96  * @title SafeERC20
97  * @dev Wrappers around ERC20 operations that throw on failure.
98  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
99  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
100  */
101 library SafeERC20 {
102     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
103         assert(token.transfer(to, value));
104     }
105 
106     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
107         assert(token.transferFrom(from, to, value));
108     }
109 
110     function safeApprove(ERC20 token, address spender, uint256 value) internal {
111         assert(token.approve(spender, value));
112     }
113 }
114 
115 
116 /**
117  * @title TokenTimelock
118  * @dev TokenTimelock is a token holder contract that will allow a
119  * beneficiary to extract the tokens after a given release time
120  */
121 contract TokenTimelock {
122     using SafeERC20 for ERC20Basic;
123 
124     // ERC20 basic token contract being held
125     ERC20Basic public token;
126 
127     // beneficiary of tokens after they are released
128     address public beneficiary;
129 
130     // timestamp when token release is enabled
131     uint64 public releaseTime;
132 
133     function TokenTimelock(ERC20Basic _token, address _beneficiary, uint64 _releaseTime) public {
134         require(_releaseTime > uint64(block.timestamp));
135         token = _token;
136         beneficiary = _beneficiary;
137         releaseTime = _releaseTime;
138     }
139 
140     /**
141      * @notice Transfers tokens held by timelock to beneficiary.
142      */
143     function release() public {
144         require(uint64(block.timestamp) >= releaseTime);
145 
146         uint256 amount = token.balanceOf(this);
147         require(amount > 0);
148 
149         token.safeTransfer(beneficiary, amount);
150     }
151 }
152 
153 
154 /**
155  * @title Standard ERC20 token
156  *
157  * @dev Implementation of the basic standard token.
158  * @dev https://github.com/ethereum/EIPs/issues/20
159  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
160  */
161 contract StandardToken is ERC20, BasicToken {
162 
163     mapping (address => mapping (address => uint256)) internal allowed;
164 
165     /**
166      * @dev Transfer tokens from one address to another
167      * @param _from address The address which you want to send tokens from
168      * @param _to address The address which you want to transfer to
169      * @param _value uint256 the amount of tokens to be transferred
170      */
171     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
172         require(_to != address(0));
173         require(_value <= balances[_from]);
174         require(_value <= allowed[_from][msg.sender]);
175 
176         balances[_from] = balances[_from].sub(_value);
177         balances[_to] = balances[_to].add(_value);
178         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
179         Transfer(_from, _to, _value);
180         return true;
181     }
182 
183     /**
184      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
185      *
186      * Beware that changing an allowance with this method brings the risk that someone may use both the old
187      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
188      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
189      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
190      * @param _spender The address which will spend the funds.
191      * @param _value The amount of tokens to be spent.
192      */
193     function approve(address _spender, uint256 _value) public returns (bool) {
194         allowed[msg.sender][_spender] = _value;
195         Approval(msg.sender, _spender, _value);
196         return true;
197     }
198 
199     /**
200      * @dev Function to check the amount of tokens that an owner allowed to a spender.
201      * @param _owner address The address which owns the funds.
202      * @param _spender address The address which will spend the funds.
203      * @return A uint256 specifying the amount of tokens still available for the spender.
204      */
205     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
206         return allowed[_owner][_spender];
207     }
208 
209     /**
210      * approve should be called when allowed[_spender] == 0. To increment
211      * allowed value is better to use this function to avoid 2 calls (and wait until
212      * the first transaction is mined)
213      * From MonolithDAO Token.sol
214      */
215     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
216         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
217         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218         return true;
219     }
220 
221     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
222         uint oldValue = allowed[msg.sender][_spender];
223         if (_subtractedValue > oldValue) {
224             allowed[msg.sender][_spender] = 0;
225         } else {
226             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
227         }
228         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
229         return true;
230     }
231 
232 }
233 
234 
235 contract Owned {
236     address public owner;
237     
238     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
239 
240     function Owned() public {
241         owner = msg.sender;
242     }
243     
244     /**
245     * @dev Allows the current owner to transfer control of the contract to a newOwner.
246     * @param newOwner The address to transfer ownership to.
247     */
248     function transferOwnership(address newOwner) public onlyOwner {
249         require(newOwner != address(0));
250         OwnershipTransferred(owner, newOwner);
251         owner = newOwner;
252     }
253 
254     modifier onlyOwner {
255         require(msg.sender == owner);
256         _;
257     }
258 }
259 
260 
261 contract OrguraExchange is StandardToken, Owned {
262     string public constant name = "Orgura Exchange";
263     string public constant symbol = "OGX";
264     uint8 public constant decimals = 18;
265 
266     /// Maximum tokens to be allocated.
267     uint256 public constant HARD_CAP = 800000000 * 10**uint256(decimals);  /* Initial supply is 800,000,000 OGX */
268 
269     /// Maximum tokens to be allocated on the sale (50% of the hard cap)
270     uint256 public constant TOKENS_SALE_HARD_CAP = 400000000 * 10**uint256(decimals);
271 
272     /// Base exchange rate is set to 1 ETH = 7,169 OGX.
273     uint256 public constant BASE_RATE = 7169;
274 
275 
276     /// seconds since 01.01.1970 to 19.04.2018 (0:00:00 o'clock UTC)
277     /// HOT sale start time
278     uint64 private constant dateSeedSale = 1523145600 + 0 hours; // 8 April 2018 00:00:00 o'clock UTC
279 
280     /// Seed sale end time; Sale PreSale start time 20.04.2018
281     uint64 private constant datePreSale = 1524182400 + 0 hours; // 20 April 2018 0:00:00 o'clock UTC
282 
283     /// Sale PreSale end time; Sale Round 1 start time 1.05.2018
284     uint64 private constant dateSaleR1 = 1525132800 + 0 hours; // 1 May 2018 0:00:00 o'clock UTC
285 
286     /// Sale Round 1 end time; Sale Round 2 start time 15.05.2018
287     uint64 private constant dateSaleR2 = 1526342400 + 0 hours; // 15 May 2018 0:00:00 o'clock UTC
288 
289     /// Sale Round 2 end time; Sale Round 3 start time 31.05.2018
290     uint64 private constant dateSaleR3 = 1527724800 + 0 hours; // 31 May 2018 0:00:00 o'clock UTC
291 
292     /// Sale Round 3  end time; 14.06.2018 0:00:00 o'clock UTC
293     uint64 private constant date14June2018 = 1528934400 + 0 hours;
294 
295     /// Token trading opening time (14.07.2018)
296     uint64 private constant date14July2018 = 1531526400;
297     
298     /// token caps for each round
299     uint256[5] private roundCaps = [
300         50000000* 10**uint256(decimals), // Sale Seed 50M  
301         50000000* 10**uint256(decimals), // Sale Presale 50M
302         100000000* 10**uint256(decimals), // Sale Round 1 100M
303         100000000* 10**uint256(decimals), // Sale Round 2 100M
304         100000000* 10**uint256(decimals) // Sale Round 3 100M
305     ];
306     uint8[5] private roundDiscountPercentages = [90, 75, 50, 30, 15];
307 
308 
309     /// Date Locked until
310     uint64[4] private dateTokensLockedTills = [
311         1536883200, // locked until this date (14 Sep 2018) 00:00:00 o'clock UTC
312         1544745600, // locked until this date (14 Dec 2018) 00:00:00 o'clock UTC
313         1557792000, // locked until this date (14 May 2019) 00:00:00 o'clock UTC
314         1581638400 // locked until this date (14 Feb 2020) 00:00:00 o'clock UTC
315     ];
316 
317     //Locked Unil percentages
318     uint8[4] private lockedTillPercentages = [20, 20, 30, 30];
319 
320     /// team tokens are locked until this date (27 APR 2019) 00:00:00
321     uint64 private constant dateTeamTokensLockedTill = 1556323200;
322 
323     /// no tokens can be ever issued when this is set to "true"
324     bool public tokenSaleClosed = false;
325 
326     /// contract to be called to release the Penthamon team tokens
327     address public timelockContractAddress;
328 
329     modifier inProgress {
330         require(totalSupply < TOKENS_SALE_HARD_CAP
331             && !tokenSaleClosed && now >= dateSeedSale);
332         _;
333     }
334 
335     /// Allow the closing to happen only once
336     modifier beforeEnd {
337         require(!tokenSaleClosed);
338         _;
339     }
340 
341     /// Require that the token sale has been closed
342     modifier tradingOpen {
343         //Begin ad token sale closed
344         //require(tokenSaleClosed);
345         //_; 
346 
347         //Begin at date trading open setting
348         require(uint64(block.timestamp) > date14July2018);
349         _;
350     }
351 
352     function OrguraExchange() public {
353     }
354 
355     /// @dev This default function allows token to be purchased by directly
356     /// sending ether to this smart contract.
357     function () public payable {
358         purchaseTokens(msg.sender);
359     }
360 
361     /// @dev Issue token based on Ether received.
362     /// @param _beneficiary Address that newly issued token will be sent to.
363     function purchaseTokens(address _beneficiary) public payable inProgress {
364         // only accept a minimum amount of ETH?
365         require(msg.value >= 0.01 ether);
366 
367         uint256 tokens = computeTokenAmount(msg.value);
368         
369         // roll back if hard cap reached
370         require(totalSupply.add(tokens) <= TOKENS_SALE_HARD_CAP);
371         
372         doIssueTokens(_beneficiary, tokens);
373 
374         /// forward the raised funds to the contract creator
375         owner.transfer(this.balance);
376     }
377 
378     /// @dev Batch issue tokens on the presale
379     /// @param _addresses addresses that the presale tokens will be sent to.
380     /// @param _addresses the amounts of tokens, with decimals expanded (full).
381     function issueTokensMulti(address[] _addresses, uint256[] _tokens) public onlyOwner beforeEnd {
382         require(_addresses.length == _tokens.length);
383         require(_addresses.length <= 100);
384 
385         for (uint256 i = 0; i < _tokens.length; i = i.add(1)) {
386             doIssueTokens(_addresses[i], _tokens[i]);
387         }
388     }
389 
390 
391     /// @dev Issue tokens for a single buyer on the presale
392     /// @param _beneficiary addresses that the presale tokens will be sent to.
393     /// @param _tokens the amount of tokens, with decimals expanded (full).
394     function issueTokens(address _beneficiary, uint256 _tokens) public onlyOwner beforeEnd {
395         doIssueTokens(_beneficiary, _tokens);
396     }
397 
398     /// @dev issue tokens for a single buyer
399     /// @param _beneficiary addresses that the tokens will be sent to.
400     /// @param _tokens the amount of tokens, with decimals expanded (full).
401     function doIssueTokens(address _beneficiary, uint256 _tokens) internal {
402         require(_beneficiary != address(0));
403 
404         // increase token total supply
405         totalSupply = totalSupply.add(_tokens);
406         // update the beneficiary balance to number of tokens sent
407         balances[_beneficiary] = balances[_beneficiary].add(_tokens);
408 
409         // event is fired when tokens issued
410         Transfer(address(0), _beneficiary, _tokens);
411     }
412 
413     /// @dev Returns the current price.
414     function price() public view returns (uint256 tokens) {
415         return computeTokenAmount(1 ether);
416     }
417 
418     /// @dev Compute the amount of OGX token that can be purchased.
419     /// @param ethAmount Amount of Ether in WEI to purchase OGX.
420     /// @return Amount of LKC token to purchase
421     function computeTokenAmount(uint256 ethAmount) internal view returns (uint256 tokens) {
422         uint256 tokenBase = ethAmount.mul(BASE_RATE);
423         uint8 roundNum = currentRoundIndex();
424         tokens = tokenBase.mul(100)/(100 - (roundDiscountPercentages[roundNum]));
425         while(tokens.add(totalSupply) > roundCaps[roundNum] && roundNum < 4){
426            roundNum++;
427            tokens = tokenBase.mul(100)/(100 - (roundDiscountPercentages[roundNum])); 
428         }
429     }
430 
431     /// @dev Determine the current sale round
432     /// @return integer representing the index of the current sale round
433     function currentRoundIndex() internal view returns (uint8 roundNum) {
434         roundNum = currentRoundIndexByDate();
435 
436         /// round determined by conjunction of both time and total sold tokens
437         while(roundNum < 4 && totalSupply > roundCaps[roundNum]) {
438             roundNum++;
439         }
440     }
441 
442     /// @dev Determine the current sale tier.
443     /// @return the index of the current sale tier by date.
444     function currentRoundIndexByDate() internal view returns (uint8 roundNum) {
445         require(now <= date14June2018); 
446         if(now > dateSaleR3) return 4;
447         if(now > dateSaleR2) return 3;
448         if(now > dateSaleR1) return 2;
449         if(now > datePreSale) return 1;
450         else return 0;
451     }
452 
453      /// @dev Closes the sale, issues the team tokens and burns the unsold
454     function close() public onlyOwner beforeEnd {
455 
456       /// Company team advisor and group tokens are equal to 37.5%
457         uint256 amount_lockedTokens = 300000000; // No decimals
458         
459         uint256 lockedTokens = amount_lockedTokens* 10**uint256(decimals); // 300M Reserve for Founder and team are added to the locked tokens 
460         
461         //resevred tokens are available from the beginning 25%
462         uint256 reservedTokens =  100000000* 10**uint256(decimals); // 100M Reserve for parner
463         
464         //Sum tokens of locked and Reserved tokens 
465         uint256 sumlockedAndReservedTokens = lockedTokens + reservedTokens;
466 
467         //Init fegment
468         uint256 fagmentSale = 0* 10**uint256(decimals); // 0 fegment Sale
469 
470         /// check for rounding errors when cap is reached
471         if(totalSupply.add(sumlockedAndReservedTokens) > HARD_CAP) {
472 
473             sumlockedAndReservedTokens = HARD_CAP.sub(totalSupply);
474 
475         }
476 
477         //issueLockedTokens(lockedTokens);
478         
479         //-----------------------------------------------
480         // Locked until Loop calculat
481 
482         uint256 _total_lockedTokens =0;
483 
484         for (uint256 i = 0; i < lockedTillPercentages.length; i = i.add(1)) 
485         {
486             _total_lockedTokens =0;
487             _total_lockedTokens = amount_lockedTokens.mul(lockedTillPercentages[i])* 10**uint256(decimals)/100;
488             //Locked  add % of Token amount locked
489             issueLockedTokensCustom( _total_lockedTokens, dateTokensLockedTills[i] );
490 
491         }
492         //---------------------------------------------------
493 
494 
495         issueReservedTokens(reservedTokens);
496         
497         
498         /// increase token total supply
499         totalSupply = totalSupply.add(sumlockedAndReservedTokens);
500         
501         /// burn the unallocated tokens - no more tokens can be issued after this line
502         tokenSaleClosed = true;
503 
504         /// forward the raised funds to the contract creator
505         owner.transfer(this.balance);
506     }
507 
508     /**
509      * issue the tokens for the team and the foodout group.
510      * tokens are locked for 1 years.
511      * @param lockedTokens the amount of tokens to the issued and locked
512      * */
513     function issueLockedTokens( uint lockedTokens) internal{
514         /// team tokens are locked until this date (01.01.2019)
515         TokenTimelock lockedTeamTokens = new TokenTimelock(this, owner, dateTeamTokensLockedTill);
516         timelockContractAddress = address(lockedTeamTokens);
517         balances[timelockContractAddress] = balances[timelockContractAddress].add(lockedTokens);
518         /// fire event when tokens issued
519         Transfer(address(0), timelockContractAddress, lockedTokens);
520         
521     }
522 
523     function issueLockedTokensCustom( uint lockedTokens , uint64 _dateTokensLockedTill) internal{
524         /// team tokens are locked until this date (01.01.2019)
525         TokenTimelock lockedTeamTokens = new TokenTimelock(this, owner, _dateTokensLockedTill);
526         timelockContractAddress = address(lockedTeamTokens);
527         balances[timelockContractAddress] = balances[timelockContractAddress].add(lockedTokens);
528         /// fire event when tokens issued
529         Transfer(address(0), timelockContractAddress, lockedTokens);
530         
531     }
532 
533     /**
534      * issue the tokens for Reserved 
535      * @param reservedTokens & bounty Tokens the amount of tokens to be issued
536      * */
537     function issueReservedTokens(uint reservedTokens) internal{
538         balances[owner] = reservedTokens;
539         Transfer(address(0), owner, reservedTokens);
540     }
541 
542     // Transfer limited by the tradingOpen modifier (time is 14 July 2018 or later)
543     function transferFrom(address _from, address _to, uint256 _value) public tradingOpen returns (bool) {
544         return super.transferFrom(_from, _to, _value);
545     }
546 
547     /// Transfer limited by the tradingOpen modifier (time is 14 July 2018 or later)
548     function transfer(address _to, uint256 _value) public tradingOpen returns (bool) {
549         return super.transfer(_to, _value);
550     }
551 
552 }