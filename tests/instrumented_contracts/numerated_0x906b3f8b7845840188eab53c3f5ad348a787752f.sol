1 /**
2  * The dorado token contract bases on the ERC20 standard token contracts from
3  * open-zeppelin and is extended by functions to issue tokens as needed by the 
4  * dorado ICO.
5  * authors: Julia Altenried, Yuri Kashnikov
6  * */
7 
8 pragma solidity 0.4.19;
9 
10 /**
11  * @title SafeMath
12  * @dev Math operations with safety checks that throw on error
13  */
14 library SafeMath {
15     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16         uint256 c = a * b;
17         require(a == 0 || c / a == b);
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
232     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
233 
234     function Owned() public {
235         owner = msg.sender;
236     }
237     
238     /**
239     * @dev Allows the current owner to transfer control of the contract to a newOwner.
240     * @param newOwner The address to transfer ownership to.
241     */
242     function transferOwnership(address newOwner) public onlyOwner {
243         require(newOwner != address(0));
244         OwnershipTransferred(owner, newOwner);
245         owner = newOwner;
246     }
247 
248     modifier onlyOwner {
249         require(msg.sender == owner);
250         _;
251     }
252 }
253 
254 contract DoradoToken is StandardToken, Owned {
255     string public constant name = "DoradoToken";
256     string public constant symbol = "DOR";
257     uint8 public constant decimals = 15;
258 
259     /// Maximum tokens to be allocated on the sale (51% of the hard cap)
260     uint256 public constant TOKENS_SALE_HARD_CAP = 510000000000000000000000; // 510000000 * 10**15
261 
262     /// Base exchange rate is set to 1 ETH = 6667 DOR.
263     uint256 public constant BASE_RATE = 6667;
264 
265     /// seconds since 01.01.1970 to 07.02.2018 (16:00:00 o'clock UTC)
266     /// HOT sale start time
267     uint64 private constant dateHOTSale = 1517961600 + 16 hours;
268 
269     /// HOT sale end time; Sale A start time 21.02.2018
270     uint64 private constant dateSaleA = 1519171200 + 16 hours;
271 
272     /// Sale A end time; Sale B start time 07.03.2018
273     uint64 private constant dateSaleB = 1520380800 + 16 hours;
274 
275     /// Sale B end time; Sale C start time 21.03.2018
276     uint64 private constant dateSaleC = 1521590400 + 16 hours;
277 
278     /// Sale C end time; Sale D start time 04.04.2018
279     uint64 private constant dateSaleD = 1522800000 + 16 hours;
280 
281     /// Sale D end time; Sale E start time 18.04.2018
282     uint64 private constant dateSaleE = 1524009600 + 16 hours;
283 
284     /// Sale E end time;  Sale F start time 02.05.2018
285     uint64 private constant dateSaleF = 1525219200 + 16 hours;
286 
287     /// Sale F end time; 16.05.2018 
288     uint64 private constant date16May2018 = 1526428800 + 16 hours;
289     
290     /// token caps for each round
291     uint256[7] private roundCaps = [
292         70000000000000000000000, // HOT sale  70000000 * 10**15 
293         140000000000000000000000, // Sale A   140000000 * 10**15
294         210000000000000000000000, // Sale B   210000000 * 10**15
295         285000000000000000000000, // Sale C   285000000 * 10**15
296         360000000000000000000000, // Sale D   360000000 * 10**15
297         435000000000000000000000, // Sale E   435000000 * 10**15
298         510000000000000000000000  // Sale F   510000000 * 10**15
299     ];
300     uint8[7] private roundDiscountPercentages = [33, 30, 27, 22, 17, 12, 7];
301 
302     
303     /// team tokens are locked until this date (01.01.2021) 00:00:00
304     uint64 private constant dateTeamTokensLockedTill = 1609459200;
305    
306 
307     /// no tokens can be ever issued when this is set to "true"
308     bool public tokenSaleClosed = false;
309 
310     /// contract to be called to release the Dorado team tokens
311     address public timelockContractAddress;
312 
313     modifier inProgress {
314         require(totalSupply < TOKENS_SALE_HARD_CAP
315             && !tokenSaleClosed && now >= dateHOTSale);
316         _;
317     }
318 
319     /// Allow the closing to happen only once
320     modifier beforeEnd {
321         require(!tokenSaleClosed);
322         _;
323     }
324 
325     /// Require that the token sale has been closed
326     modifier tradingOpen {
327         require(tokenSaleClosed);
328         _;
329     }
330 
331     function DoradoToken() public {
332     }
333 
334     /// @dev This default function allows token to be purchased by directly
335     /// sending ether to this smart contract.
336     function () public payable {
337         purchaseTokens(msg.sender);
338     }
339 
340     /// @dev Issue token based on Ether received.
341     /// @param _beneficiary Address that newly issued token will be sent to.
342     function purchaseTokens(address _beneficiary) public payable inProgress {
343         // only accept a minimum amount of ETH?
344         require(msg.value >= 0.01 ether);
345 
346         uint256 tokens = computeTokenAmount(msg.value);
347         
348         // roll back if hard cap reached
349         require(totalSupply.add(tokens) <= TOKENS_SALE_HARD_CAP);
350         
351         doIssueTokens(_beneficiary, tokens);
352 
353         /// forward the raised funds to the contract creator
354         owner.transfer(this.balance);
355     }
356 
357     /// @dev Batch issue tokens on the presale
358     /// @param _addresses addresses that the presale tokens will be sent to.
359     /// @param _addresses the amounts of tokens, with decimals expanded (full).
360     function issueTokensMulti(address[] _addresses, uint256[] _tokens) public onlyOwner beforeEnd {
361         require(_addresses.length == _tokens.length);
362         require(_addresses.length <= 100);
363 
364         for (uint256 i = 0; i < _tokens.length; i = i.add(1)) {
365             doIssueTokens(_addresses[i], _tokens[i]);
366         }
367     }
368 
369     /// @dev Issue tokens for a single buyer on the presale
370     /// @param _beneficiary addresses that the presale tokens will be sent to.
371     /// @param _tokens the amount of tokens, with decimals expanded (full).
372     function issueTokens(address _beneficiary, uint256 _tokens) public onlyOwner beforeEnd {
373         doIssueTokens(_beneficiary, _tokens);
374     }
375 
376     /// @dev issue tokens for a single buyer
377     /// @param _beneficiary addresses that the tokens will be sent to.
378     /// @param _tokens the amount of tokens, with decimals expanded (full).
379     function doIssueTokens(address _beneficiary, uint256 _tokens) internal {
380         require(_beneficiary != address(0));
381 
382         // increase token total supply
383         totalSupply = totalSupply.add(_tokens);
384         // update the beneficiary balance to number of tokens sent
385         balances[_beneficiary] = balances[_beneficiary].add(_tokens);
386 
387         // event is fired when tokens issued
388         Transfer(address(0), _beneficiary, _tokens);
389     }
390 
391     /// @dev Returns the current price.
392     function price() public view returns (uint256 tokens) {
393         return computeTokenAmount(1 ether);
394     }
395 
396     /// @dev Compute the amount of DOR token that can be purchased.
397     /// @param ethAmount Amount of Ether in WEI to purchase DOR.
398     /// @return Amount of DOR token to purchase
399     function computeTokenAmount(uint256 ethAmount) internal view returns (uint256 tokens) {
400         uint256 tokenBase = (ethAmount.mul(BASE_RATE)/10000000000000)*10000000000;//18 decimals to 15 decimals, set precision to 5 decimals
401         uint8 roundNum = currentRoundIndex();
402         tokens = tokenBase.mul(100)/(100 - (roundDiscountPercentages[roundNum]));
403         while(tokens.add(totalSupply) > roundCaps[roundNum] && roundNum < 6){
404            roundNum++;
405            tokens = tokenBase.mul(100)/(100 - (roundDiscountPercentages[roundNum])); 
406         }
407     }
408 
409     /// @dev Determine the current sale round
410     /// @return integer representing the index of the current sale round
411     function currentRoundIndex() internal view returns (uint8 roundNum) {
412         roundNum = currentRoundIndexByDate();
413 
414         /// round determined by conjunction of both time and total sold tokens
415         while(roundNum < 6 && totalSupply > roundCaps[roundNum]) {
416             roundNum++;
417         }
418     }
419 
420     /// @dev Determine the current sale tier.
421     /// @return the index of the current sale tier by date.
422     function currentRoundIndexByDate() internal view returns (uint8 roundNum) {
423         require(now <= date16May2018); 
424         if(now > dateSaleF) return 6;
425         if(now > dateSaleE) return 5;
426         if(now > dateSaleD) return 4;
427         if(now > dateSaleC) return 3;
428         if(now > dateSaleB) return 2;
429         if(now > dateSaleA) return 1;
430         else return 0;
431     }
432 
433     /// @dev Closes the sale, issues the team tokens and burns the unsold
434     function close() public onlyOwner beforeEnd {
435         /// team tokens are equal to 15% of the sold tokens
436         /// 8% foodout group tokens are added to the locked tokens
437         uint256 lockedTokens = 230000000000000000000000;
438         //partner tokens are available from the beginning
439         uint256 partnerTokens = 260000000000000000000000;
440         
441         issueLockedTokens(lockedTokens);
442         issuePartnerTokens(partnerTokens);
443         
444         /// increase token total supply
445         totalSupply = totalSupply.add(lockedTokens+partnerTokens);
446         
447         /// burn the unallocated tokens - no more tokens can be issued after this line
448         tokenSaleClosed = true;
449 
450         /// forward the raised funds to the contract creator
451         owner.transfer(this.balance);
452     }
453     
454     /**
455      * issue the tokens for the team and the foodout group.
456      * tokens are locked for 3 years.
457      * @param lockedTokens the amount of tokens to the issued and locked
458      * */
459     function issueLockedTokens( uint lockedTokens) internal{
460         /// team tokens are locked until this date (01.01.2021)
461         TokenTimelock lockedTeamTokens = new TokenTimelock(this, owner, dateTeamTokensLockedTill);
462         timelockContractAddress = address(lockedTeamTokens);
463         balances[timelockContractAddress] = balances[timelockContractAddress].add(lockedTokens);
464         /// fire event when tokens issued
465         Transfer(address(0), timelockContractAddress, lockedTokens);
466         
467     }
468     
469     /**
470      * issue the tokens for partners and advisors
471      * @param partnerTokens the amount of tokens to be issued
472      * */
473     function issuePartnerTokens(uint partnerTokens) internal{
474         balances[owner] = partnerTokens;
475         Transfer(address(0), owner, partnerTokens);
476     }
477 
478     /// Transfer limited by the tradingOpen modifier
479     function transferFrom(address _from, address _to, uint256 _value) public tradingOpen returns (bool) {
480         return super.transferFrom(_from, _to, _value);
481     }
482 
483     /// Transfer limited by the tradingOpen modifier
484     function transfer(address _to, uint256 _value) public tradingOpen returns (bool) {
485         return super.transfer(_to, _value);
486     }
487 }