1 /**
2  * The Mountable token contract bases on the ERC20 standard token contracts from
3  * open-zeppelin and is extended by functions to issue tokens as needed by the
4  * Mountable ICO.
5  * */
6 
7 pragma solidity 0.5.8;
8 
9 /**
10  * @title SafeMath
11  * @dev Math operations with safety checks that throw on error
12  */
13 library SafeMath {
14     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15         uint256 c = a * b;
16         require(a == 0 || c / a == b);
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         require(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         require(c >= a);
28         return c;
29     }
30 }
31 
32 /**
33  * @title ERC20Basic
34  * @dev Simpler version of ERC20 interface
35  * @dev see https://github.com/ethereum/EIPs/issues/179
36  */
37 contract ERC20Basic {
38     uint256 public totalSupply;
39     function balanceOf(address who) public view returns (uint256);
40     function transfer(address to, uint256 value) public returns (bool);
41     event Transfer(address indexed from, address indexed to, uint256 value);
42 }
43 
44 /**
45  * @title Basic token
46  * @dev Basic version of StandardToken, with no allowances.
47  */
48 contract BasicToken is ERC20Basic {
49     using SafeMath for uint256;
50 
51     mapping(address => uint256) public balances;
52 
53     /**
54     * @dev transfer token for a specified address
55     * @param _to The address to transfer to.
56     * @param _value The amount to be transferred.
57     */
58     function transfer(address _to, uint256 _value) public returns (bool) {
59         require(_to != address(0));
60         require(_value <= balances[msg.sender]);
61 
62         balances[msg.sender] = balances[msg.sender].sub(_value);
63         balances[_to] = balances[_to].add(_value);
64         emit Transfer(msg.sender, _to, _value);
65         return true;
66     }
67 
68     /**
69     * @dev Gets the balance of the specified address.
70     * @param _owner The address to query the the balance of.
71     * @return An uint256 representing the amount owned by the passed address.
72     */
73     function balanceOf(address _owner) public view returns (uint256 balance) {
74         return balances[_owner];
75     }
76 
77 }
78 
79 /**
80  * @title ERC20 interface
81  * @dev see https://github.com/ethereum/EIPs/issues/20
82  */
83 contract ERC20 is ERC20Basic {
84     function allowance(address owner, address spender) public view returns (uint256);
85     function transferFrom(address from, address to, uint256 value) public returns (bool);
86     function approve(address spender, uint256 value) public returns (bool);
87     event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 
90 /**
91  * @title SafeERC20
92  * @dev Wrappers around ERC20 operations that throw on failure.
93  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
94  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
95  */
96 library SafeERC20 {
97     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
98         assert(token.transfer(to, value));
99     }
100 
101     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
102         assert(token.transferFrom(from, to, value));
103     }
104 
105     function safeApprove(ERC20 token, address spender, uint256 value) internal {
106         assert(token.approve(spender, value));
107     }
108 }
109 
110 /**
111  * @title TokenTimelock
112  * @dev TokenTimelock is a token holder contract that will allow a
113  * beneficiary to extract the tokens after a given release time
114  */
115 contract TokenTimelock {
116     using SafeERC20 for ERC20Basic;
117 
118     ERC20Basic public token;
119     address public beneficiary;
120     uint64 public releaseTime;
121 
122     function tokenTimelock(ERC20Basic _token, address _beneficiary, uint64 _releaseTime) public {
123         require(_releaseTime > uint64(block.timestamp));
124         token = _token;
125         beneficiary = _beneficiary;
126         releaseTime = _releaseTime;
127     }
128 
129     /**
130      * @notice Transfers tokens held by timelock to beneficiary.
131      */
132     function release() public {
133         require(uint64(block.timestamp) >= releaseTime);
134 
135         uint256 amount = token.balanceOf(address(this));
136         require(amount > 0);
137 
138         token.safeTransfer(beneficiary, amount);
139     }
140 }
141 
142 /**
143  * @title Standard ERC20 token
144  *
145  * @dev Implementation of the basic standard token.
146  * @dev https://github.com/ethereum/EIPs/issues/20
147  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
148  */
149 contract StandardToken is ERC20, BasicToken {
150 
151     mapping (address => mapping (address => uint256)) internal allowed;
152 
153     /**
154      * @dev Transfer tokens from one address to another
155      * @param _from address The address which you want to send tokens from
156      * @param _to address The address which you want to transfer to
157      * @param _value uint256 the amount of tokens to be transferred
158      */
159     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
160         require(_to != address(0));
161         require(_value <= balances[_from]);
162         require(_value <= allowed[_from][msg.sender]);
163 
164         balances[_from] = balances[_from].sub(_value);
165         balances[_to] = balances[_to].add(_value);
166         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
167         emit Transfer(_from, _to, _value);
168         return true;
169     }
170 
171     /**
172      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
173      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
174      * @param _spender The address which will spend the funds.
175      * @param _value The amount of tokens to be spent.
176      */
177     function approve(address _spender, uint256 _value) public returns (bool) {
178         allowed[msg.sender][_spender] = _value;
179         emit Approval(msg.sender, _spender, _value);
180         return true;
181     }
182 
183     /**
184      * @dev Function to check the amount of tokens that an owner allowed to a spender.
185      * @param _owner address The address which owns the funds.
186      * @param _spender address The address which will spend the funds.
187      * @return A uint256 specifying the amount of tokens still available for the spender.
188      */
189     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
190         return allowed[_owner][_spender];
191     }
192 
193     /**
194      * approve should be called when allowed[_spender] == 0. To increment
195      * allowed value is better to use this function to avoid 2 calls (and wait until
196      * the first transaction is mined)
197      * From MonolithDAO Token.sol
198      */
199     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
200         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
201         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
202         return true;
203     }
204 
205     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
206         uint oldValue = allowed[msg.sender][_spender];
207         if (_subtractedValue > oldValue) {
208             allowed[msg.sender][_spender] = 0;
209         } else {
210             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
211         }
212         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
213         return true;
214     }
215 
216 }
217 
218 contract Owned {
219     address payable public owner;
220 
221     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
222 
223     function owned() public {
224         owner = msg.sender;
225     }
226 
227     /**
228     * @dev Allows the current owner to transfer control of the contract to a newOwner.
229     * @param newOwner The address to transfer ownership to.
230     */
231     function transferOwnership(address payable newOwner) public onlyOwner {
232         require(newOwner != address(0));
233         emit OwnershipTransferred(owner, newOwner);
234         owner = newOwner;
235     }
236 
237     modifier onlyOwner {
238         require(msg.sender == owner);
239         _;
240     }
241 }
242 
243 contract BurnableToken is BasicToken {
244 
245   event Burn(address indexed burner, uint256 value);
246 
247   function burn(uint256 _value) public {
248     require(_value > 0);
249     require(_value <= balances[msg.sender]);
250 
251     address burner = msg.sender;
252     balances[burner] = balances[burner].sub(_value);
253     totalSupply = totalSupply.sub(_value);
254     emit Burn(burner, _value);
255   }
256 }
257 
258 contract MountableToken is StandardToken, Owned, BurnableToken {
259     string public constant name = "Mountable Token";
260     string public constant symbol = "MNT";
261     uint8 public constant decimals = 15;
262 
263     /// Maximum tokens to be allocated on the sale (75% of the hard cap)
264     uint256 public constant TOKENS_SALE_HARD_CAP = 750000000000000000000000; // 750000000000 * 10**15
265 
266     /// Base exchange rate is set to 1 ETH = 325000 MNT.
267     uint256 public constant BASE_RATE = 325000;
268 
269     /// seconds since 01.01.1970 to 06.07.2019 (10:00:00 o'clock UTC+7 / WIB)
270     /// DD.MM.YYYY
271     /// HOT sale start time
272     uint64 private constant dateHOTSale = 1562407200 - 7 hours;
273     
274     /// preSale start time 13.07.2019 (10:00:00 o'clock UTC+7 / WIB)
275     uint64 private constant preSale = 1563012000 - 7 hours;
276 
277     /// Token Sale 1 start time; Sale 1 20.07.2019 (10:00:00 o'clock UTC+7 / WIB)
278     uint64 private constant tokenSale1 = 1563616800 - 7 hours;
279 
280     /// Token Sale 2 start time; Sale 2 03.08.2019 (10:00:00 o'clock UTC+7 / WIB)
281     uint64 private constant tokenSale2 = 1564826400 - 7 hours;
282 
283     /// Token Sale 3 start time; Sale 3 17.08.2019 (10:00:00 o'clock UTC+7 / WIB)
284     uint64 private constant tokenSale3 = 1566036000 - 7 hours;
285 
286     /// Token Sale start time; 31.08.2019 (10:00:00 o'clock UTC+7 / WIB)
287     uint64 private constant endDate = 1567245600 - 7 hours;
288 
289     /// token caps for each round
290     uint256[5] private roundCaps = [
291         100000000000000000000000, // HOT sale   100000000 * 10**15
292         200000000000000000000000, // Pre Sale   100000000 * 10**15
293         350000000000000000000000, // Token Sale 1   150000000 * 10**15
294         550000000000000000000000, // Token Sale 2   200000000 * 10**15
295         750000000000000000000000 // Token Sale 3   200000000 * 10**15
296     ];
297     uint8[5] private roundDiscountPercentages = [50, 33, 25, 12, 6];
298 
299     /// team tokens are locked until this date 31.08.2020 (10:00:00 o'clock UTC+7 / WIB)
300     uint64 private constant dateTeamTokensLockedTill = 1598868000 - 7 hours;
301 
302     /// no tokens can be ever issued when this is set to "true"
303     bool public tokenSaleClosed = false;
304 
305     /// contract to be called to release the Mountable team tokens
306     address public timelockContractAddress;
307 
308     modifier inProgress {
309         require(totalSupply < TOKENS_SALE_HARD_CAP
310             && !tokenSaleClosed && now >= dateHOTSale);
311         _;
312     }
313 
314     /// Allow the closing to happen only once
315     modifier beforeEnd {
316         require(!tokenSaleClosed);
317         _;
318     }
319 
320     /// Require that the token sale has been closed
321     modifier tradingOpen {
322         require(tokenSaleClosed);
323         _;
324     }
325 
326     /// @dev This default function allows token to be purchased by directly
327     /// sending ether to this smart contract.
328     function () external payable {
329         purchaseTokens(msg.sender);
330     }
331 
332     /// @dev Issue token based on Ether received.
333     /// @param _beneficiary Address that newly issued token will be sent to.
334     function purchaseTokens(address _beneficiary) public payable inProgress {
335         require(msg.value >= 0.05 ether);
336 
337         uint256 tokens = computeTokenAmount(msg.value);
338 
339         require(totalSupply.add(tokens) <= TOKENS_SALE_HARD_CAP);
340 
341         doIssueTokens(_beneficiary, tokens);
342         owner.transfer(address(this).balance);
343 
344     }
345 
346     /// @dev Issue tokens for a single buyer on the presale
347     /// @param _beneficiary addresses that the presale tokens will be sent to.
348     /// @param _tokens the amount of tokens, with decimals expanded (full).
349     function issueTokens(address _beneficiary, uint256 _tokens) public onlyOwner beforeEnd {
350         doIssueTokens(_beneficiary, _tokens);
351     }
352 
353     /// @dev issue tokens for a single buyer
354     /// @param _beneficiary addresses that the tokens will be sent to.
355     /// @param _tokens the amount of tokens, with decimals expanded (full).
356     function doIssueTokens(address _beneficiary, uint256 _tokens) internal {
357         require(_beneficiary != address(0));
358 
359         totalSupply = totalSupply.add(_tokens);
360         balances[_beneficiary] = balances[_beneficiary].add(_tokens);
361 
362         emit Transfer(address(0), _beneficiary, _tokens);
363     }
364 
365     /// @dev Returns the current price.
366     function price() public view returns (uint256 tokens) {
367         return computeTokenAmount(1 ether);
368     }
369 
370     /// @dev Compute the amount of MNT token that can be purchased.
371     /// @param ethAmount Amount of Ether in WEI to purchase MNT.
372     /// @return Amount of MNT token to purchase
373     function computeTokenAmount(uint256 ethAmount) internal view returns (uint256 tokens) {
374         uint256 tokenBase = (ethAmount.mul(BASE_RATE)/10000000000000)*10000000000;
375         uint8 roundNum = currentRoundIndex();
376         tokens = tokenBase.mul(100)/(100 - (roundDiscountPercentages[roundNum]));
377         while(tokens.add(totalSupply) > roundCaps[roundNum] && roundNum < 4){
378            roundNum++;
379            tokens = tokenBase.mul(100)/(100 - (roundDiscountPercentages[roundNum]));
380         }
381     }
382 
383     /// @dev Determine the current sale round
384     /// @return integer representing the index of the current sale round
385     function currentRoundIndex() internal view returns (uint8 roundNum) {
386         roundNum = currentRoundIndexByDate();
387 
388         /// round determined by conjunction of both time and total sold tokens
389         while(roundNum < 4 && totalSupply > roundCaps[roundNum]) {
390             roundNum++;
391         }
392     }
393 
394     /// @dev Determine the current sale tier.
395     /// @return the index of the current sale tier by date.
396     function currentRoundIndexByDate() internal view returns (uint8 roundNum) {
397         require(now <= endDate);
398         if(now > tokenSale3) return 4;
399         if(now > tokenSale2) return 3;
400         if(now > tokenSale1) return 2;
401         if(now > preSale) return 1;
402         else return 0;
403     }
404 
405     /// @dev Closes the sale, issues the team tokens and burns the unsold
406     function close() public onlyOwner beforeEnd {
407         /// team tokens are equal to 12% of the allocated tokens
408         /// 13% group tokens are added to the locked tokens
409         uint256 lockedTokens = 120000000000000000000000;
410         //partner tokens are available from the beginning
411         uint256 partnerTokens = 130000000000000000000000;
412 
413         issueLockedTokens(lockedTokens);
414         issuePartnerTokens(partnerTokens);
415 
416         totalSupply = totalSupply.add(lockedTokens+partnerTokens);
417 
418         /// burn the unallocated tokens - no more tokens can be issued after this line
419         tokenSaleClosed = true;
420 
421         owner.transfer(address(this).balance);
422         
423     }
424 
425     /**
426      * issue the tokens for the team and the group.
427      * tokens are locked for 1 year.
428      * @param lockedTokens the amount of tokens to the issued and locked
429      * */
430     function issueLockedTokens( uint lockedTokens) internal{
431         /// team tokens are locked until this date (31.08.2020)
432         TokenTimelock lockedTeamTokens = new TokenTimelock();
433         lockedTeamTokens.tokenTimelock(this, owner, dateTeamTokensLockedTill);
434         timelockContractAddress = address(lockedTeamTokens);
435         balances[timelockContractAddress] = balances[timelockContractAddress].add(lockedTokens);
436         /// fire event when tokens issued
437         emit Transfer(address(0), timelockContractAddress, lockedTokens);
438 
439     }
440 
441     /**
442      * issue the tokens for partners and advisors
443      * @param partnerTokens the amount of tokens to be issued
444      * */
445     function issuePartnerTokens(uint partnerTokens) internal{
446         balances[owner] = partnerTokens;
447         emit Transfer(address(0), owner, partnerTokens);
448     }
449 
450     /// Transfer limited by the tradingOpen modifier
451     function transferFrom(address _from, address _to, uint256 _value) public tradingOpen returns (bool) {
452         return super.transferFrom(_from, _to, _value);
453     }
454 
455     /// Transfer limited by the tradingOpen modifier
456     function transfer(address _to, uint256 _value) public tradingOpen returns (bool) {
457         return super.transfer(_to, _value);
458     }
459 
460 }