1 pragma solidity 0.4.23;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10     /**
11     * @dev Multiplies two numbers, throws on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         if (a == 0) {
15             return 0;
16         }
17         uint256 c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22     /**
23     * @dev Integer division of two numbers, truncating the quotient.
24     */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         // assert(b > 0); // Solidity automatically throws when dividing by 0
27         uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return c;
30     }
31 
32     /**
33     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34     */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     /**
41     * @dev Adds two numbers, throws on overflow.
42     */
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         assert(c >= a);
46         return c;
47     }
48 }
49 
50 /**
51  * @title ERC20Basic
52  * @dev Simpler version of ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/179
54  */
55 contract ERC20Basic {
56     function totalSupply() public view returns (uint256);
57     function balanceOf(address who) public view returns (uint256);
58     function transfer(address to, uint256 value) public returns (bool);
59     event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 /**
63  * @title Basic token
64  * @dev Basic version of StandardToken, with no allowances.
65  */
66 contract BasicToken is ERC20Basic {
67     using SafeMath for uint256;
68 
69     mapping(address => uint256) balances;
70 
71     uint256 totalSupply_;
72 
73     /**
74     * @dev total number of tokens in existence
75     */
76     function totalSupply() public view returns (uint256) {
77         return totalSupply_;
78     }
79 
80     /**
81     * @dev transfer token for a specified address
82     * @param _to The address to transfer to.
83     * @param _value The amount to be transferred.
84     */
85     function transfer(address _to, uint256 _value) public returns (bool) {
86         require(_to != address(0));
87         require(_value <= balances[msg.sender]);
88 
89         // SafeMath.sub will throw if there is not enough balance.
90         balances[msg.sender] = balances[msg.sender].sub(_value);
91         balances[_to] = balances[_to].add(_value);
92         emit Transfer(msg.sender, _to, _value);
93         return true;
94     }
95 
96     /**
97     * @dev Gets the balance of the specified address.
98     * @param _owner The address to query the the balance of.
99     * @return An uint256 representing the amount owned by the passed address.
100     */
101     function balanceOf(address _owner) public view returns (uint256 balance) {
102         return balances[_owner];
103     }
104 }
105 
106 /**
107  * @title ERC20 interface
108  * @dev see https://github.com/ethereum/EIPs/issues/20
109  */
110 contract ERC20 is ERC20Basic {
111     function allowance(address owner, address spender) public view returns (uint256);
112     function transferFrom(address from, address to, uint256 value) public returns (bool);
113     function approve(address spender, uint256 value) public returns (bool);
114     event Approval(address indexed owner, address indexed spender, uint256 value);
115 }
116 
117 /**
118  * @title Standard ERC20 token
119  *
120  * @dev Implementation of the basic standard token.
121  * @dev https://github.com/ethereum/EIPs/issues/20
122  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
123  */
124 contract StandardToken is ERC20, BasicToken {
125 
126     mapping (address => mapping (address => uint256)) internal allowed;
127 
128     /**
129      * @dev Transfer tokens from one address to another
130      * @param _from address The address which you want to send tokens from
131      * @param _to address The address which you want to transfer to
132      * @param _value uint256 the amount of tokens to be transferred
133      */
134     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
135         require(_to != address(0));
136         require(_value <= balances[_from]);
137         require(_value <= allowed[_from][msg.sender]);
138 
139         balances[_from] = balances[_from].sub(_value);
140         balances[_to] = balances[_to].add(_value);
141         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
142         emit Transfer(_from, _to, _value);
143         return true;
144     }
145 
146     /**
147      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
148      *
149      * Beware that changing an allowance with this method brings the risk that someone may use both the old
150      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
151      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
152      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153      * @param _spender The address which will spend the funds.
154      * @param _value The amount of tokens to be spent.
155      */
156     function approve(address _spender, uint256 _value) public returns (bool) {
157         allowed[msg.sender][_spender] = _value;
158         emit Approval(msg.sender, _spender, _value);
159         return true;
160     }
161 
162     /**
163      * @dev Function to check the amount of tokens that an owner allowed to a spender.
164      * @param _owner address The address which owns the funds.
165      * @param _spender address The address which will spend the funds.
166      * @return A uint256 specifying the amount of tokens still available for the spender.
167      */
168     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
169         return allowed[_owner][_spender];
170     }
171 
172     /**
173      * approve should be called when allowed[_spender] == 0. To increment
174      * allowed value is better to use this function to avoid 2 calls (and wait until
175      * the first transaction is mined)
176      * From MonolithDAO Token.sol
177      */
178     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
179         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
180         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
181         return true;
182     }
183 
184     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
185         uint oldValue = allowed[msg.sender][_spender];
186         if (_subtractedValue > oldValue) {
187             allowed[msg.sender][_spender] = 0;
188         } else {
189             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
190         }
191         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
192         return true;
193     }
194 }
195 
196 /**
197  * @title SafeERC20
198  * @dev Wrappers around ERC20 operations that throw on failure.
199  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
200  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
201  */
202 library SafeERC20 {
203     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
204         assert(token.transfer(to, value));
205     }
206 
207     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
208         assert(token.transferFrom(from, to, value));
209     }
210 
211     function safeApprove(ERC20 token, address spender, uint256 value) internal {
212         assert(token.approve(spender, value));
213     }
214 }
215 
216 /**
217  * @title TokenTimelock
218  * @dev TokenTimelock is a token holder contract that will allow a
219  * beneficiary to extract the tokens after a given release time
220  */
221 contract TokenTimelock {
222     using SafeERC20 for ERC20Basic;
223 
224     // ERC20 basic token contract being held
225     ERC20Basic public token;
226 
227     // beneficiary of tokens after they are released
228     address public beneficiary;
229 
230     // timestamp when token release is enabled
231     uint64 public releaseTime;
232 
233     constructor(ERC20Basic _token, address _beneficiary, uint64 _releaseTime) public {
234         require(_releaseTime > uint64(block.timestamp));
235         token = _token;
236         beneficiary = _beneficiary;
237         releaseTime = _releaseTime;
238     }
239 
240     /**
241      * @notice Transfers tokens held by timelock to beneficiary.
242      */
243     function release() public {
244         require(uint64(block.timestamp) >= releaseTime);
245 
246         uint256 amount = token.balanceOf(this);
247         require(amount > 0);
248 
249         token.safeTransfer(beneficiary, amount);
250     }
251 }
252 
253 contract Owned {
254     address public owner;
255 
256     constructor() public {
257         owner = msg.sender;
258     }
259 
260     modifier onlyOwner {
261         require(msg.sender == owner);
262         _;
263     }
264 }
265 
266 contract ReferralDiscountToken is StandardToken, Owned {
267     /// Store the referrers by the referred addresses
268     mapping(address => address) referrerOf;
269     address[] ownersIndex;
270 
271     // Emitted when an investor declares his referrer
272     event Referral(address indexed referred, address indexed referrer);
273 
274     /// Compute the earned discount, topped at 60%
275     function referralDiscountPercentage(address _owner) public view returns (uint256 percent) {
276         uint256 total = 0;
277 
278         /// get one time discount for having been referred
279         if(referrerOf[_owner] != address(0)) {
280             total = total.add(10);
281         }
282 
283         /// get a 10% discount for each one referred
284         for(uint256 i = 0; i < ownersIndex.length; i++) {
285             if(referrerOf[ownersIndex[i]] == _owner) {
286                 total = total.add(10);
287                 // if(total >= 60) break;
288             }
289         }
290 
291         return total;
292     }
293 
294     // /**
295     //  * Activate referral discounts by declaring one's own referrer
296     //  * @param _referrer can't be self
297     //  * @param _referrer must own tokens at the time of the call
298     //  * You must own tokens at the time of the call
299     //  */
300     // function setReferrer(address _referrer) public returns (bool success) {
301     //     require(_referrer != address(0));
302     //     require(_referrer != address(msg.sender));
303     //     require(balanceOf(msg.sender) > 0);
304     //     require(balanceOf(_referrer) > 0);
305     //     assert(referrerOf[msg.sender] == address(0));
306 
307     //     ownersIndex.push(msg.sender);
308     //     referrerOf[msg.sender] = _referrer;
309 
310     //     Referral(msg.sender, _referrer);
311     //     return true;
312     // }
313 
314     /**
315      * Activate referral discounts by declaring one's own referrer
316      * @param _referrer the investor who brought another
317      * @param _referred the investor who was brought by another
318      * @dev _referrer and _referred must own tokens at the time of the call
319      */
320     function setReferrer(address _referred, address _referrer) onlyOwner public returns (bool success) {
321         require(_referrer != address(0));
322         require(_referrer != address(_referred));
323         //        require(balanceOf(_referred) > 0);
324         //        require(balanceOf(_referrer) > 0);
325         require(referrerOf[_referred] == address(0));
326 
327         ownersIndex.push(_referred);
328         referrerOf[_referred] = _referrer;
329 
330         emit Referral(_referred, _referrer);
331         return true;
332     }
333 }
334 
335 contract NaorisToken is ReferralDiscountToken {
336     string public constant name = "NaorisToken";
337     string public constant symbol = "NAO";
338     uint256 public constant decimals = 18;
339 
340     /// The owner of this address will manage the sale process.
341     address public saleTeamAddress;
342 
343     /// The owner of this address will manage the referal and airdrop campaigns.
344     address public referalAirdropsTokensAddress;
345 
346     /// The owner of this address is the Naoris Reserve fund.
347     address public reserveFundAddress;
348 
349     /// The owner of this address is the Naoris Think Tank fund.
350     address public thinkTankFundAddress;
351 
352     /// This address keeps the locked board bonus until 1st of May 2019
353     address public lockedBoardBonusAddress;
354 
355     /// This is the address of the timelock contract for the locked Board Bonus tokens
356     address public treasuryTimelockAddress;
357 
358     /// After this flag is changed to 'true' no more tokens can be created
359     bool public tokenSaleClosed = false;
360 
361     // seconds since 01.01.1970 to 1st of May 2019 (both 00:00:00 o'clock UTC)
362     uint64 date01May2019 = 1556668800;
363 
364     /// Maximum tokens to be allocated.
365     uint256 public constant TOKENS_HARD_CAP = 400000000 * 10 ** decimals;
366 
367     /// Maximum tokens to be sold.
368     uint256 public constant TOKENS_SALE_HARD_CAP = 300000000 * 10 ** decimals;
369 
370     /// Tokens to be allocated to the Referal tokens fund.
371     uint256 public constant REFERRAL_TOKENS = 10000000 * 10 ** decimals;
372 
373     /// Tokens to be allocated to the Airdrop tokens fund.
374     uint256 public constant AIRDROP_TOKENS = 10000000 * 10 ** decimals;
375 
376     /// Tokens to be allocated to the Think Tank fund.
377     uint256 public constant THINK_TANK_FUND_TOKENS = 40000000 * 10 ** decimals;
378 
379     /// Tokens to be allocated to the Naoris Team fund.
380     uint256 public constant NAORIS_TEAM_TOKENS = 20000000 * 10 ** decimals;
381 
382     /// Tokens to be allocated to the locked Board Bonus.
383     uint256 public constant LOCKED_BOARD_BONUS_TOKENS = 20000000 * 10 ** decimals;
384 
385     /// Only the sale team or the owner are allowed to execute
386     modifier onlyTeam {
387         assert(msg.sender == saleTeamAddress || msg.sender == owner);
388         _;
389     }
390 
391     /// Only allowed to execute while the sale is not yet closed
392     modifier beforeEnd {
393         assert(!tokenSaleClosed);
394         _;
395     }
396 
397     constructor(address _saleTeamAddress, address _referalAirdropsTokensAddress, address _reserveFundAddress,
398     address _thinkTankFundAddress, address _lockedBoardBonusAddress) public {
399         require(_saleTeamAddress != address(0));
400         require(_referalAirdropsTokensAddress != address(0));
401         require(_reserveFundAddress != address(0));
402         require(_thinkTankFundAddress != address(0));
403         require(_lockedBoardBonusAddress != address(0));
404 
405         saleTeamAddress = _saleTeamAddress;
406         referalAirdropsTokensAddress = _referalAirdropsTokensAddress;
407         reserveFundAddress = _reserveFundAddress;
408         thinkTankFundAddress = _thinkTankFundAddress;
409         lockedBoardBonusAddress = _lockedBoardBonusAddress;
410                 
411         /// The unsold sale tokens will be burnt when the sale is closed
412         balances[saleTeamAddress] = TOKENS_SALE_HARD_CAP;
413         totalSupply_ = TOKENS_SALE_HARD_CAP;
414         emit Transfer(0x0, saleTeamAddress, TOKENS_SALE_HARD_CAP);
415 
416         /// The unspent referal/airdrop tokens will be sent back
417         /// to the reserve fund when the sale is closed
418         balances[referalAirdropsTokensAddress] = REFERRAL_TOKENS;
419         totalSupply_ = totalSupply_.add(REFERRAL_TOKENS);
420         emit Transfer(0x0, referalAirdropsTokensAddress, REFERRAL_TOKENS);
421 
422         balances[referalAirdropsTokensAddress] = balances[referalAirdropsTokensAddress].add(AIRDROP_TOKENS);
423         totalSupply_ = totalSupply_.add(AIRDROP_TOKENS);
424         emit Transfer(0x0, referalAirdropsTokensAddress, AIRDROP_TOKENS);
425     }
426 
427     function close() public onlyTeam beforeEnd {
428         /// burn the unsold sale tokens
429         uint256 unsoldSaleTokens = balances[saleTeamAddress];
430         if(unsoldSaleTokens > 0) {
431             balances[saleTeamAddress] = 0;
432             totalSupply_ = totalSupply_.sub(unsoldSaleTokens);
433             emit Transfer(saleTeamAddress, 0x0, unsoldSaleTokens);
434         }
435         
436         /// transfer the unspent referal/airdrop tokens to the Reserve fund
437         uint256 unspentReferalAirdropTokens = balances[referalAirdropsTokensAddress];
438         if(unspentReferalAirdropTokens > 0) {
439             balances[referalAirdropsTokensAddress] = 0;
440             balances[reserveFundAddress] = balances[reserveFundAddress].add(unspentReferalAirdropTokens);
441             emit Transfer(referalAirdropsTokensAddress, reserveFundAddress, unspentReferalAirdropTokens);
442         }
443         
444         /// 40% allocated to the Naoris Think Tank Fund
445         balances[thinkTankFundAddress] = balances[thinkTankFundAddress].add(THINK_TANK_FUND_TOKENS);
446         totalSupply_ = totalSupply_.add(THINK_TANK_FUND_TOKENS);
447         emit Transfer(0x0, thinkTankFundAddress, THINK_TANK_FUND_TOKENS);
448 
449         /// 20% allocated to the Naoris Team and Advisors Fund
450         balances[owner] = balances[owner].add(NAORIS_TEAM_TOKENS);
451         totalSupply_ = totalSupply_.add(NAORIS_TEAM_TOKENS);
452         emit Transfer(0x0, owner, NAORIS_TEAM_TOKENS);
453 
454         /// tokens of the Board Bonus locked until 1st of May 2019
455         TokenTimelock lockedTreasuryTokens = new TokenTimelock(this, lockedBoardBonusAddress, date01May2019);
456         treasuryTimelockAddress = address(lockedTreasuryTokens);
457         balances[treasuryTimelockAddress] = balances[treasuryTimelockAddress].add(LOCKED_BOARD_BONUS_TOKENS);
458         totalSupply_ = totalSupply_.add(LOCKED_BOARD_BONUS_TOKENS);
459         emit Transfer(0x0, treasuryTimelockAddress, LOCKED_BOARD_BONUS_TOKENS);
460 
461         require(totalSupply_ <= TOKENS_HARD_CAP);
462 
463         tokenSaleClosed = true;
464     }
465 
466     function tokenDiscountPercentage(address _owner) public view returns (uint256 percent) {
467         if(balanceOf(_owner) >= 1000000 * 10**decimals) {
468             return 50;
469         } else if(balanceOf(_owner) >= 500000 * 10**decimals) {
470             return 30;
471         } else if(balanceOf(_owner) >= 250000 * 10**decimals) {
472             return 25;
473         } else if(balanceOf(_owner) >= 100000 * 10**decimals) {
474             return 20;
475         } else if(balanceOf(_owner) >= 50000 * 10**decimals) {
476             return 15;
477         } else if(balanceOf(_owner) >= 10000 * 10**decimals) {
478             return 10;
479         } else if(balanceOf(_owner) >= 1000 * 10**decimals) {
480             return 5;
481         } else {
482             return 0;
483         }
484     }
485 
486     function getTotalDiscount(address _owner) public view returns (uint256 percent) {
487         uint256 total = 0;
488 
489         total += tokenDiscountPercentage(_owner);
490         total += referralDiscountPercentage(_owner);
491 
492         return (total > 60) ? 60 : total;
493     }
494 
495     /// @dev Trading limited - requires the token sale to have closed
496     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
497         if(tokenSaleClosed) {
498             return super.transferFrom(_from, _to, _value);
499         }
500         return false;
501     }
502 
503     /// @dev Trading limited - requires the token sale to have closed
504     function transfer(address _to, uint256 _value) public returns (bool) {
505         if(tokenSaleClosed || msg.sender == referalAirdropsTokensAddress
506                         || msg.sender == saleTeamAddress) {
507             return super.transfer(_to, _value);
508         }
509         return false;
510     }
511 }