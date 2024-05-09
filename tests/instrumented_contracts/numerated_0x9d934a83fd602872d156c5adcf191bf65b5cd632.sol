1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4 
5     /**
6     * @dev Multiplies two numbers, throws on overflow.
7     */
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     /**
18     * @dev Integer division of two numbers, truncating the quotient.
19     */
20     function div(uint256 a, uint256 b) internal pure returns (uint256) {
21         // assert(b > 0); // Solidity automatically throws when dividing by 0
22         uint256 c = a / b;
23         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24         return c;
25     }
26 
27     /**
28     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29     */
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         assert(b <= a);
32         return a - b;
33     }
34 
35     /**
36     * @dev Adds two numbers, throws on overflow.
37     */
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a + b;
40         assert(c >= a);
41         return c;
42     }
43 }
44 
45 library SafeERC20 {
46     function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
47         assert(token.transfer(to, value));
48     }
49 
50     function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
51         assert(token.transferFrom(from, to, value));
52     }
53 
54     function safeApprove(ERC20 token, address spender, uint256 value) internal {
55         assert(token.approve(spender, value));
56     }
57 }
58 
59 contract Ownable {
60     address public owner;
61 
62 
63     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
64 
65 
66     /**
67      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
68      * account.
69      */
70     constructor() public {
71         owner = msg.sender;
72     }
73 
74     /**
75      * @dev Throws if called by any account other than the owner.
76      */
77     modifier onlyOwner() {
78         require(msg.sender == owner);
79         _;
80     }
81 
82     /**
83      * @dev Allows the current owner to transfer control of the contract to a newOwner.
84      * @param newOwner The address to transfer ownership to.
85      */
86     function transferOwnership(address newOwner) public onlyOwner {
87         require(newOwner != address(0));
88         emit OwnershipTransferred(owner, newOwner);
89         owner = newOwner;
90     }
91 }
92 
93 library Math {
94     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
95         return a >= b ? a : b;
96     }
97 
98     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
99         return a < b ? a : b;
100     }
101 
102     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
103         return a >= b ? a : b;
104     }
105 
106     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
107         return a < b ? a : b;
108     }
109 }
110 
111 contract ERC20Basic {
112     function totalSupply() public view returns (uint256);
113 
114     function balanceOf(address who) public view returns (uint256);
115 
116     function transfer(address to, uint256 value) public returns (bool);
117 
118     event Transfer(address indexed from, address indexed to, uint256 value);
119 }
120 
121 contract ERC20 is ERC20Basic {
122     function allowance(address owner, address spender) public view returns (uint256);
123 
124     function transferFrom(address from, address to, uint256 value) public returns (bool);
125 
126     function approve(address spender, uint256 value) public returns (bool);
127 
128     event Approval(address indexed owner, address indexed spender, uint256 value);
129 }
130 
131 
132 contract BasicToken is ERC20Basic {
133     using SafeMath for uint256;
134 
135     mapping(address => uint256) balances;
136 
137     uint256 totalSupply_;
138 
139     /**
140     * @dev total number of tokens in existence
141     */
142     function totalSupply() public view returns (uint256) {
143         return totalSupply_;
144     }
145 
146     /**
147     * @dev transfer token for a specified address
148     * @param _to The address to transfer to.
149     * @param _value The amount to be transferred.
150     */
151     function transfer(address _to, uint256 _value) public returns (bool) {
152         require(_to != address(0));
153         require(_value <= balances[msg.sender]);
154 
155         // SafeMath.sub will throw if there is not enough balance.
156         balances[msg.sender] = balances[msg.sender].sub(_value);
157         balances[_to] = balances[_to].add(_value);
158         emit Transfer(msg.sender, _to, _value);
159         return true;
160     }
161 
162     /**
163     * @dev Gets the balance of the specified address.
164     * @param _owner The address to query the the balance of.
165     * @return An uint256 representing the amount owned by the passed address.
166     */
167     function balanceOf(address _owner) public view returns (uint256 balance) {
168         return balances[_owner];
169     }
170 
171 }
172 
173 contract StandardToken is ERC20, BasicToken {
174 
175     mapping(address => mapping(address => uint256)) internal allowed;
176 
177 
178     /**
179      * @dev Transfer tokens from one address to another
180      * @param _from address The address which you want to send tokens from
181      * @param _to address The address which you want to transfer to
182      * @param _value uint256 the amount of tokens to be transferred
183      */
184     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
185         require(_to != address(0));
186         require(_value <= balances[_from]);
187         require(_value <= allowed[_from][msg.sender]);
188 
189         balances[_from] = balances[_from].sub(_value);
190         balances[_to] = balances[_to].add(_value);
191         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
192         emit Transfer(_from, _to, _value);
193         return true;
194     }
195 
196     /**
197      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
198      *
199      * Beware that changing an allowance with this method brings the risk that someone may use both the old
200      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
201      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
202      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
203      * @param _spender The address which will spend the funds.
204      * @param _value The amount of tokens to be spent.
205      */
206     function approve(address _spender, uint256 _value) public returns (bool) {
207         allowed[msg.sender][_spender] = _value;
208         emit Approval(msg.sender, _spender, _value);
209         return true;
210     }
211 
212     /**
213      * @dev Function to check the amount of tokens that an owner allowed to a spender.
214      * @param _owner address The address which owns the funds.
215      * @param _spender address The address which will spend the funds.
216      * @return A uint256 specifying the amount of tokens still available for the spender.
217      */
218     function allowance(address _owner, address _spender) public view returns (uint256) {
219         return allowed[_owner][_spender];
220     }
221 
222     /**
223      * @dev Increase the amount of tokens that an owner allowed to a spender.
224      *
225      * approve should be called when allowed[_spender] == 0. To increment
226      * allowed value is better to use this function to avoid 2 calls (and wait until
227      * the first transaction is mined)
228      * From MonolithDAO Token.sol
229      * @param _spender The address which will spend the funds.
230      * @param _addedValue The amount of tokens to increase the allowance by.
231      */
232     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
233         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
234         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
235         return true;
236     }
237 
238     /**
239      * @dev Decrease the amount of tokens that an owner allowed to a spender.
240      *
241      * approve should be called when allowed[_spender] == 0. To decrement
242      * allowed value is better to use this function to avoid 2 calls (and wait until
243      * the first transaction is mined)
244      * From MonolithDAO Token.sol
245      * @param _spender The address which will spend the funds.
246      * @param _subtractedValue The amount of tokens to decrease the allowance by.
247      */
248     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
249         uint oldValue = allowed[msg.sender][_spender];
250         if (_subtractedValue > oldValue) {
251             allowed[msg.sender][_spender] = 0;
252         } else {
253             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
254         }
255         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
256         return true;
257     }
258 }
259 
260 contract FreeLimitPool is BasicToken, Ownable {
261     // not for sell vars pool
262     uint256 public nfsPoolLeft;
263     uint256 public nfsPoolCount;
264 
265     function nfsPoolTransfer(address _to, uint256 _value) public onlyOwner returns (bool) {
266         require(nfsPoolLeft >= _value, "Value more than tokens left");
267         require(_to != address(0), "Not allowed send to trash tokens");
268 
269         nfsPoolLeft -= _value;
270         balances[_to] = balances[_to].add(_value);
271 
272         emit Transfer(address(0), _to, _value);
273 
274         return true;
275     }
276 }
277 
278 contract TwoPhases is FreeLimitPool {
279     EthRateOracle public oracle;
280     uint256 public soldTokensCount = 0;
281 
282     // first period token price
283     uint256 public tokenStartPrice;
284 
285     // second phase token cost in cents
286     uint256 public tokenSecondPeriodPrice;
287 
288     uint256 public sPerDate;
289     uint256 public sPeriodEndDate;
290     uint256 public sPeriodSoldTokensLimit;
291 
292     function() public payable {
293         require(0.0001 ether <= msg.value, "min limit eth 0.0001");
294         require(sPeriodEndDate >= now, "Sell tokens all periods ended");
295         uint256 tokensCount;
296         uint256 ethUsdRate = oracle.getEthUsdRate();
297         bool isSecondPeriodNow = now >= sPerDate;
298         bool isSecondPeriodTokensLimitReached = soldTokensCount >= (totalSupply_ - sPeriodSoldTokensLimit - nfsPoolCount);
299 
300         if (isSecondPeriodNow || isSecondPeriodTokensLimitReached) {
301             tokensCount = msg.value * ethUsdRate / tokenSecondPeriodPrice;
302         } else {
303             tokensCount = msg.value * ethUsdRate / tokenStartPrice;
304 
305             uint256 sPeriodTokensCount = reminderCalc(soldTokensCount + tokensCount, totalSupply_ - sPeriodSoldTokensLimit - nfsPoolCount);
306 
307             if (sPeriodTokensCount > 0) {
308                 tokensCount -= sPeriodTokensCount;
309 
310                 uint256 weiLeft = sPeriodTokensCount * tokenStartPrice / ethUsdRate;
311 
312                 tokensCount += weiLeft * ethUsdRate / tokenSecondPeriodPrice;
313             }
314         }
315         require(tokensCount > 0, "tokens count must be positive");
316         require((soldTokensCount + tokensCount) <= (totalSupply_ - nfsPoolCount), "tokens limit");
317 
318         balances[msg.sender] += tokensCount;
319         soldTokensCount += tokensCount;
320 
321         emit Transfer(address(0), msg.sender, tokensCount);
322     }
323 
324     function reminderCalc(uint256 x, uint256 y) internal pure returns (uint256) {
325         if (y >= x) {
326             return 0;
327         }
328         return x - y;
329     }
330 
331     function setOracleAddress(address _oracleAddress) public onlyOwner {
332         oracle = EthRateOracle(_oracleAddress);
333     }
334 }
335 
336 contract Exchangeable is StandardToken, Ownable {
337     uint256 public transfersAllowDate;
338 
339     function transfer(address _to, uint256 _value) public returns (bool) {
340         require(transfersAllowDate <= now, "Function cannot be called at this time.");
341 
342         return BasicToken.transfer(_to, _value);
343     }
344 
345     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
346         require(transfersAllowDate <= now);
347 
348         return StandardToken.transferFrom(_from, _to, _value);
349     }
350 }
351 
352 contract EthRateOracle is Ownable {
353     uint256 public ethUsdRate;
354 
355     function update(uint256 _newValue) public onlyOwner {
356         ethUsdRate = _newValue;
357     }
358 
359     function getEthUsdRate() public view returns (uint256) {
360         return ethUsdRate;
361     }
362 }
363 
364 contract JokerToken is Exchangeable, TwoPhases {
365     string public name;
366     string public symbol;
367     uint8 public decimals;
368 
369     constructor() public {
370         name = "Joker.buzz token";
371         symbol = "JOKER";
372         decimals = 18;
373         totalSupply_ = 20000000 * (uint256(10) ** decimals);
374         // in us cents
375         tokenStartPrice = 40;
376         // not for sell
377         nfsPoolCount = 10900000 * (uint256(10) ** decimals);
378         nfsPoolLeft = nfsPoolCount;
379         // period 2, another price, and after some date
380         tokenSecondPeriodPrice = 200;
381         sPerDate = now + 149 days;
382         sPeriodEndDate = now + 281 days;
383         sPeriodSoldTokensLimit = (totalSupply_ - nfsPoolCount) - 1200000 * (uint256(10) ** decimals);
384         // transfer ability
385         transfersAllowDate = now + 281 days;
386     }
387 
388     function getCurrentPhase() public view returns (string) {
389         bool isSecondPeriodNow = now >= sPerDate;
390         bool isSecondPeriodTokensLimitReached = soldTokensCount >= (totalSupply_ - sPeriodSoldTokensLimit - nfsPoolCount);
391         if (transfersAllowDate <= now) {
392             return "Last third phase, you can transfer tokens between users, but can't buy more tokens.";
393         }
394         if (sPeriodEndDate < now) {
395             return "Second phase ended, You can not buy more tokens.";
396         }
397         if (isSecondPeriodNow && isSecondPeriodTokensLimitReached) {
398             return "Second phase by time and solded tokens";
399         }
400         if (isSecondPeriodNow) {
401             return "Second phase by time";
402         }
403         if (isSecondPeriodTokensLimitReached) {
404             return "Second phase by solded tokens";
405         }
406         return "First phase";
407     }
408 
409     function getIsSecondPhaseByTime() public view returns (bool) {
410         return now >= sPerDate;
411     }
412 
413     function getRemainingDaysToSecondPhase() public view returns (uint) {
414         return (sPerDate - now) / 1 days;
415     }
416 
417     function getRemainingDaysToThirdPhase() public view returns (uint) {
418         return (transfersAllowDate - now) / 1 days;
419     }
420 
421     function getIsSecondPhaseEndedByTime() public view returns (bool) {
422         return sPeriodEndDate < now;
423     }
424 
425     function getIsSecondPhaseBySoldedTokens() public view returns (bool) {
426         return soldTokensCount >= (totalSupply_ - sPeriodSoldTokensLimit - nfsPoolCount);
427     }
428 
429     function getIsThirdPhase() public view returns (bool) {
430         return transfersAllowDate <= now;
431     }
432 
433     function getBalance(address addr) public view returns (uint) {
434         return balances[addr];
435     }
436 
437     function getWeiBalance() public constant returns (uint weiBal) {
438         return address(this).balance;
439     }
440 
441     function EthToOwner(address _address, uint amount) public onlyOwner {
442         require(amount <= address(this).balance);
443         _address.transfer(amount);
444     }
445 }