1 pragma solidity 0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         uint256 c = a * b;
10         require(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         require(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a);
29         return c;
30     }
31 }
32 
33 /**
34  * @title ERC20Basic
35  * @dev Simpler version of ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/179
37  */
38 contract ERC20Basic {
39     uint256 public totalSupply;
40     function balanceOf(address who) public view returns (uint256);
41     function transfer(address to, uint256 value) public returns (bool);
42     event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 /**
46  * @title Basic token
47  * @dev Basic version of StandardToken, with no allowances.
48  */
49 contract BasicToken is ERC20Basic {
50     using SafeMath for uint256;
51 
52     mapping(address => uint256) public balances;
53 
54     /**
55     * @dev transfer token for a specified address
56     * @param _to The address to transfer to.
57     * @param _value The amount to be transferred.
58     */
59     function transfer(address _to, uint256 _value) public returns (bool) {
60         require(_to != address(0));
61         require(_value <= balances[msg.sender]);
62 
63         // SafeMath.sub will throw if there is not enough balance.
64         balances[msg.sender] = balances[msg.sender].sub(_value);
65         balances[_to] = balances[_to].add(_value);
66         Transfer(msg.sender, _to, _value);
67         return true;
68     }
69 
70     /**
71     * @dev Gets the balance of the specified address.
72     * @param _owner The address to query the the balance of.
73     * @return An uint256 representing the amount owned by the passed address.
74     */
75     function balanceOf(address _owner) public view returns (uint256 balance) {
76         return balances[_owner];
77     }
78 
79 }
80 
81 /**
82  * @title ERC20 interface
83  * @dev see https://github.com/ethereum/EIPs/issues/20
84  */
85 contract ERC20 is ERC20Basic {
86     function allowance(address owner, address spender) public view returns (uint256);
87     function transferFrom(address from, address to, uint256 value) public returns (bool);
88     function approve(address spender, uint256 value) public returns (bool);
89     event Approval(address indexed owner, address indexed spender, uint256 value);
90 }
91 
92 /**
93  * @title SafeERC20
94  * @dev Wrappers around ERC20 operations that throw on failure.
95  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
96  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
97  */
98 library SafeERC20 {
99     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
100         assert(token.transfer(to, value));
101     }
102 
103     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
104         assert(token.transferFrom(from, to, value));
105     }
106 
107     function safeApprove(ERC20 token, address spender, uint256 value) internal {
108         assert(token.approve(spender, value));
109     }
110 }
111 
112 /**
113  * @title TokenTimelock
114  * @dev TokenTimelock is a token holder contract that will allow a
115  * beneficiary to extract the tokens after a given release time
116  */
117 contract TokenTimelock {
118     using SafeERC20 for ERC20Basic;
119 
120     // ERC20 basic token contract being held
121     ERC20Basic public token;
122 
123     // beneficiary of tokens after they are released
124     address public beneficiary;
125 
126     // timestamp when token release is enabled
127     uint64 public releaseTime;
128 
129     function TokenTimelock(ERC20Basic _token, address _beneficiary, uint64 _releaseTime) public {
130         require(_releaseTime > uint64(block.timestamp));
131         token = _token;
132         beneficiary = _beneficiary;
133         releaseTime = _releaseTime;
134     }
135 
136     /**
137      * @notice Transfers tokens held by timelock to beneficiary.
138      */
139     function release() public {
140         require(uint64(block.timestamp) >= releaseTime);
141 
142         uint256 amount = token.balanceOf(this);
143         require(amount > 0);
144 
145         token.safeTransfer(beneficiary, amount);
146     }
147 }
148 
149 /**
150  * @title Standard ERC20 token
151  *
152  * @dev Implementation of the basic standard token.
153  * @dev https://github.com/ethereum/EIPs/issues/20
154  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
155  */
156 contract StandardToken is ERC20, BasicToken {
157 
158     mapping (address => mapping (address => uint256)) internal allowed;
159 
160     /**
161      * @dev Transfer tokens from one address to another
162      * @param _from address The address which you want to send tokens from
163      * @param _to address The address which you want to transfer to
164      * @param _value uint256 the amount of tokens to be transferred
165      */
166     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
167         require(_to != address(0));
168         require(_value <= balances[_from]);
169         require(_value <= allowed[_from][msg.sender]);
170 
171         balances[_from] = balances[_from].sub(_value);
172         balances[_to] = balances[_to].add(_value);
173         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
174         Transfer(_from, _to, _value);
175         return true;
176     }
177 
178     /**
179      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
180      *
181      * Beware that changing an allowance with this method brings the risk that someone may use both the old
182      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
183      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
184      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
185      * @param _spender The address which will spend the funds.
186      * @param _value The amount of tokens to be spent.
187      */
188     function approve(address _spender, uint256 _value) public returns (bool) {
189         allowed[msg.sender][_spender] = _value;
190         Approval(msg.sender, _spender, _value);
191         return true;
192     }
193 
194     /**
195      * @dev Function to check the amount of tokens that an owner allowed to a spender.
196      * @param _owner address The address which owns the funds.
197      * @param _spender address The address which will spend the funds.
198      * @return A uint256 specifying the amount of tokens still available for the spender.
199      */
200     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
201         return allowed[_owner][_spender];
202     }
203 
204     /**
205      * approve should be called when allowed[_spender] == 0. To increment
206      * allowed value is better to use this function to avoid 2 calls (and wait until
207      * the first transaction is mined)
208      * From MonolithDAO Token.sol
209      */
210     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
211         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
212         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
213         return true;
214     }
215 
216     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
217         uint oldValue = allowed[msg.sender][_spender];
218         if (_subtractedValue > oldValue) {
219             allowed[msg.sender][_spender] = 0;
220         } else {
221             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
222         }
223         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
224         return true;
225     }
226 
227 }
228 
229 contract Owned {
230     address public owner;
231 
232     function Owned() public {
233         owner = msg.sender;
234     }
235 
236     modifier onlyOwner {
237         require(msg.sender == owner);
238         _;
239     }
240 }
241 
242 contract TokiaToken is StandardToken, Owned {
243     string public constant name = "TokiaToken";
244     string public constant symbol = "TKA";
245     uint8 public constant decimals = 18;
246 
247     /// Maximum tokens to be allocated.
248     uint256 public constant HARD_CAP = 62500000 * 10**uint256(decimals);
249 
250     /// Maximum tokens to be allocated on the sale (75% of the hard cap)
251     uint256 public constant TOKENS_SALE_HARD_CAP = 50000000 * 10**uint256(decimals);
252 
253     /// Base exchange rate is set to 1 ETH = 714 TKA.
254     uint256 public constant BASE_RATE = 714;
255 
256     /// seconds since 01.01.1970 to 04.12.2017 (both 00:00:00 o'clock UTC)
257     /// presale start time
258     uint64 private constant date04Dec2017 = 1512345600;
259 
260     /// presale end time; round 1 start time
261     uint64 private constant date01Jan2018 = 1514764800;
262 
263     /// round 1 end time; round 2 start time
264     uint64 private constant date01Feb2018 = 1517443200;
265 
266     /// round 2 end time; round 3 start time
267     uint64 private constant date15Feb2018 = 1518652800;
268 
269     /// round 3 end time; round 4 start time
270     uint64 private constant date01Mar2018 = 1519862400;
271 
272     /// round 4 end time; closing token sale
273     uint64 private constant date15Mar2018 = 1521072000;
274 
275     /// team tokens are locked until this date (01.01.2019)
276     uint64 private constant date01Jan2019 = 1546300800;
277 
278     /// token trading opening time (01.05.2018)
279     uint64 private constant date01May2018 = 1525219199;
280 
281     /// no tokens can be ever issued when this is set to "true"
282     bool public tokenSaleClosed = false;
283 
284     /// contract to be called to release the Tokia team tokens
285     address public timelockContractAddress;
286 
287     /// Issue event index starting from 0.
288     uint64 public issueIndex = 0;
289 
290     /// Emitted for each sucuessful token purchase.
291     event Issue(uint64 issueIndex, address addr, uint256 tokenAmount);
292 
293     modifier inProgress {
294         require(totalSupply < TOKENS_SALE_HARD_CAP
295             && !tokenSaleClosed);
296         _;
297     }
298 
299     /// Allow the closing to happen only once
300     modifier beforeEnd {
301         require(!tokenSaleClosed);
302         _;
303     }
304 
305     /// Require that the end of the sale has passed (time is 01 May 2018 or later)
306     modifier tradingOpen {
307         require(uint64(block.timestamp) > date01May2018);
308         _;
309     }
310 
311     function TokiaToken() public {
312     }
313 
314     /// @dev This default function allows token to be purchased by directly
315     /// sending ether to this smart contract.
316     function () public payable {
317         purchaseTokens(msg.sender);
318     }
319 
320     /// @dev Issue token based on Ether received.
321     /// @param _beneficiary Address that newly issued token will be sent to.
322     function purchaseTokens(address _beneficiary) public payable inProgress {
323         // only accept a minimum amount of ETH?
324         require(msg.value >= 0.01 ether);
325 
326         uint256 tokens = computeTokenAmount(msg.value);
327         doIssueTokens(_beneficiary, tokens);
328 
329         /// forward the raised funds to the contract creator
330         owner.transfer(this.balance);
331     }
332 
333     /// @dev Batch issue tokens on the presale
334     /// @param _addresses addresses that the presale tokens will be sent to.
335     /// @param _addresses the amounts of tokens, with decimals expanded (full).
336     function issueTokensMulti(address[] _addresses, uint256[] _tokens) public onlyOwner inProgress {
337         require(_addresses.length == _tokens.length);
338         require(_addresses.length <= 100);
339 
340         for (uint256 i = 0; i < _tokens.length; i = i.add(1)) {
341             doIssueTokens(_addresses[i], _tokens[i].mul(10**uint256(decimals)));
342         }
343     }
344 
345     /// @dev Issue tokens for a single buyer on the presale
346     /// @param _beneficiary addresses that the presale tokens will be sent to.
347     /// @param _tokens the amount of tokens, with decimals expanded (full).
348     function issueTokens(address _beneficiary, uint256 _tokens) public onlyOwner inProgress {
349         doIssueTokens(_beneficiary, _tokens.mul(10**uint256(decimals)));
350     }
351 
352     /// @dev issue tokens for a single buyer
353     /// @param _beneficiary addresses that the tokens will be sent to.
354     /// @param _tokens the amount of tokens, with decimals expanded (full).
355     function doIssueTokens(address _beneficiary, uint256 _tokens) internal {
356         require(_beneficiary != address(0));
357 
358         // compute without actually increasing it
359         uint256 increasedTotalSupply = totalSupply.add(_tokens);
360         // roll back if hard cap reached
361         require(increasedTotalSupply <= TOKENS_SALE_HARD_CAP);
362 
363         // increase token total supply
364         totalSupply = increasedTotalSupply;
365         // update the beneficiary balance to number of tokens sent
366         balances[_beneficiary] = balances[_beneficiary].add(_tokens);
367 
368         // event is fired when tokens issued
369         Issue(
370             issueIndex++,
371             _beneficiary,
372             _tokens
373         );
374     }
375 
376     /// @dev Returns the current price.
377     function price() public view returns (uint256 tokens) {
378         return computeTokenAmount(1 ether);
379     }
380 
381     /// @dev Compute the amount of TKA token that can be purchased.
382     /// @param ethAmount Amount of Ether to purchase TKA.
383     /// @return Amount of TKA token to purchase
384     function computeTokenAmount(uint256 ethAmount) internal view returns (uint256 tokens) {
385         uint256 tokenBase = ethAmount.mul(BASE_RATE);
386         uint8[5] memory roundDiscountPercentages = [47, 35, 25, 15, 5];
387 
388         uint8 roundDiscountPercentage = roundDiscountPercentages[currentRoundIndex()];
389         uint8 amountDiscountPercentage = getAmountDiscountPercentage(tokenBase);
390 
391         tokens = tokenBase.mul(100).div(100 - (roundDiscountPercentage + amountDiscountPercentage));
392     }
393 
394     /// @dev Compute the additional discount for the purchaed amount of TKA
395     /// @param tokenBase the base tokens amount computed only against the base rate
396     /// @return integer representing the percentage discount
397     function getAmountDiscountPercentage(uint256 tokenBase) internal pure returns (uint8) {
398         if(tokenBase >= 1500 * 10**uint256(decimals)) return 9;
399         if(tokenBase >= 1000 * 10**uint256(decimals)) return 5;
400         if(tokenBase >= 500 * 10**uint256(decimals)) return 3;
401         return 0;
402     }
403 
404     /// @dev Determine the current sale round
405     /// @return integer representing the index of the current sale round
406     function currentRoundIndex() internal view returns (uint8 roundNum) {
407         roundNum = currentRoundIndexByDate();
408 
409         /// token caps for each round
410         uint256[5] memory roundCaps = [
411             10000000 * 10**uint256(decimals),
412             22500000 * 10**uint256(decimals), // + round 1
413             35000000 * 10**uint256(decimals), // + round 2
414             40000000 * 10**uint256(decimals), // + round 3
415             50000000 * 10**uint256(decimals)  // + round 4
416         ];
417 
418         /// round determined by conjunction of both time and total sold tokens
419         while(roundNum < 4 && totalSupply > roundCaps[roundNum]) {
420             roundNum++;
421         }
422     }
423 
424     /// @dev Determine the current sale tier.
425     /// @return the index of the current sale tier by date.
426     function currentRoundIndexByDate() internal view returns (uint8 roundNum) {
427         uint64 _now = uint64(block.timestamp);
428         require(_now <= date15Mar2018);
429 
430         roundNum = 0;
431         if(_now > date01Mar2018) roundNum = 4;
432         if(_now > date15Feb2018) roundNum = 3;
433         if(_now > date01Feb2018) roundNum = 2;
434         if(_now > date01Jan2018) roundNum = 1;
435         return roundNum;
436     }
437 
438     /// @dev Closes the sale, issues the team tokens and burns the unsold
439     function close() public onlyOwner beforeEnd {
440         /// team tokens are equal to 25% of the sold tokens
441         uint256 teamTokens = totalSupply.mul(25).div(100);
442 
443         /// check for rounding errors when cap is reached
444         if(totalSupply.add(teamTokens) > HARD_CAP) {
445             teamTokens = HARD_CAP.sub(totalSupply);
446         }
447 
448         /// team tokens are locked until this date (01.01.2019)
449         TokenTimelock lockedTeamTokens = new TokenTimelock(this, owner, date01Jan2019);
450         timelockContractAddress = address(lockedTeamTokens);
451         balances[timelockContractAddress] = balances[timelockContractAddress].add(teamTokens);
452         /// increase token total supply
453         totalSupply = totalSupply.add(teamTokens);
454         /// fire event when tokens issued
455         Issue(
456             issueIndex++,
457             timelockContractAddress,
458             teamTokens
459         );
460 
461         /// burn the unallocated tokens - no more tokens can be issued after this line
462         tokenSaleClosed = true;
463 
464         /// forward the raised funds to the contract creator
465         owner.transfer(this.balance);
466     }
467 
468     /// Transfer limited by the tradingOpen modifier (time is 01 May 2018 or later)
469     function transferFrom(address _from, address _to, uint256 _value) public tradingOpen returns (bool) {
470         return super.transferFrom(_from, _to, _value);
471     }
472 
473     /// Transfer limited by the tradingOpen modifier (time is 01 May 2018 or later)
474     function transfer(address _to, uint256 _value) public tradingOpen returns (bool) {
475         return super.transfer(_to, _value);
476     }
477 }