1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract Ownable {
33   address public owner;
34 
35 
36   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38 
39   /**
40    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
41    * account.
42    */
43   function Ownable() public {
44     owner = msg.sender;
45   }
46 
47 
48   /**
49    * @dev Throws if called by any account other than the owner.
50    */
51   modifier onlyOwner() {
52     require(msg.sender == owner);
53     _;
54   }
55 
56 
57   /**
58    * @dev Allows the current owner to transfer control of the contract to a newOwner.
59    * @param newOwner The address to transfer ownership to.
60    */
61   function transferOwnership(address newOwner) public onlyOwner {
62     require(newOwner != address(0));
63     OwnershipTransferred(owner, newOwner);
64     owner = newOwner;
65   }
66 
67 }
68 
69 contract BeatTokenCrowdsale is Ownable {
70 
71     enum Stages {
72         Deployed,
73         PreIco,
74         IcoPhase1,
75         IcoPhase2,
76         IcoPhase3,
77         IcoEnded,
78         Finalized
79     }
80     Stages public stage;
81 
82     using SafeMath for uint256;
83 
84     BeatToken public token;
85 
86     uint256 public contractStartTime;
87     uint256 public preIcoEndTime;
88     uint256 public icoPhase1EndTime;
89     uint256 public icoPhase2EndTime;
90     uint256 public icoPhase3EndTime;
91     uint256 public contractEndTime;
92 
93     address public ethTeamWallet;
94     address public beatTeamWallet;
95 
96     uint256 public ethWeiRaised;
97     mapping(address => uint256) public balanceOf;
98 
99     uint public constant PRE_ICO_PERIOD = 28 days;
100     uint public constant ICO_PHASE1_PERIOD = 28 days;
101     uint public constant ICO_PHASE2_PERIOD = 28 days;
102     uint public constant ICO_PHASE3_PERIOD = 28 days;
103 
104     uint256 public constant PRE_ICO_BONUS_PERCENTAGE = 100;
105     uint256 public constant ICO_PHASE1_BONUS_PERCENTAGE = 75;
106     uint256 public constant ICO_PHASE2_BONUS_PERCENTAGE = 50;
107     uint256 public constant ICO_PHASE3_BONUS_PERCENTAGE = 25;
108 
109     // 5.0 bn (2.5 bn regular + 2.5 bn bonus)
110     uint256 public constant PRE_ICO_AMOUNT = 5000 * (10 ** 6) * (10 ** 18);
111     // 7.0 bn (4.0 bn regular + 3.0 bn bonus)
112     uint256 public constant ICO_PHASE1_AMOUNT = 7000 * (10 ** 6) * (10 ** 18);
113     // 10.5 bn (7.0 bn regular + 3.5 bn bonus)
114     uint256 public constant ICO_PHASE2_AMOUNT = 10500 * (10 ** 6) * (10 ** 18);
115     // 11.875 bn (9.5 bn regular + 2.375 bn bonus)
116     uint256 public constant ICO_PHASE3_AMOUNT = 11875 * (10 ** 6) * (10 ** 18);
117 
118     uint256 public constant PRE_ICO_LIMIT = PRE_ICO_AMOUNT;
119     uint256 public constant ICO_PHASE1_LIMIT = PRE_ICO_LIMIT + ICO_PHASE1_AMOUNT;
120     uint256 public constant ICO_PHASE2_LIMIT = ICO_PHASE1_LIMIT + ICO_PHASE2_AMOUNT;
121     uint256 public constant ICO_PHASE3_LIMIT = ICO_PHASE2_LIMIT + ICO_PHASE3_AMOUNT;
122 
123     // 230 bn
124     uint256 public constant HARD_CAP = 230 * (10 ** 9) * (10 ** 18);
125 
126     uint256 public ethPriceInEuroCent;
127 
128     event BeatTokenPurchased(address indexed purchaser, address indexed beneficiary, uint256 ethWeiAmount, uint256 beatWeiAmount);
129     event BeatTokenEthPriceChanged(uint256 newPrice);
130     event BeatTokenPreIcoStarted();
131     event BeatTokenIcoPhase1Started();
132     event BeatTokenIcoPhase2Started();
133     event BeatTokenIcoPhase3Started();
134     event BeatTokenIcoFinalized();
135 
136     function BeatTokenCrowdsale(address _ethTeamWallet, address _beatTeamWallet) public {
137         require(_ethTeamWallet != address(0));
138         require(_beatTeamWallet != address(0));
139 
140         token = new BeatToken(HARD_CAP);
141         stage = Stages.Deployed;
142         ethTeamWallet = _ethTeamWallet;
143         beatTeamWallet = _beatTeamWallet;
144         ethPriceInEuroCent = 0;
145 
146         contractStartTime = 0;
147         preIcoEndTime = 0;
148         icoPhase1EndTime = 0;
149         icoPhase2EndTime = 0;
150         icoPhase3EndTime = 0;
151         contractEndTime = 0;
152     }
153 
154     function setEtherPriceInEuroCent(uint256 _ethPriceInEuroCent) onlyOwner public {
155         ethPriceInEuroCent = _ethPriceInEuroCent;
156         BeatTokenEthPriceChanged(_ethPriceInEuroCent);
157     }
158 
159     function start() onlyOwner public {
160         require(stage == Stages.Deployed);
161         require(ethPriceInEuroCent > 0);
162 
163         contractStartTime = now;
164         BeatTokenPreIcoStarted();
165 
166         stage = Stages.PreIco;
167     }
168 
169     function finalize() onlyOwner public {
170         require(stage != Stages.Deployed);
171         require(stage != Stages.Finalized);
172 
173         if (preIcoEndTime == 0) {
174             preIcoEndTime = now;
175         }
176         if (icoPhase1EndTime == 0) {
177             icoPhase1EndTime = now;
178         }
179         if (icoPhase2EndTime == 0) {
180             icoPhase2EndTime = now;
181         }
182         if (icoPhase3EndTime == 0) {
183             icoPhase3EndTime = now;
184         }
185         if (contractEndTime == 0) {
186             contractEndTime = now;
187         }
188 
189         uint256 unsoldTokens = HARD_CAP - token.getTotalSupply();
190         token.mint(beatTeamWallet, unsoldTokens);
191 
192         BeatTokenIcoFinalized();
193 
194         stage = Stages.Finalized;
195     }
196 
197     function() payable public {
198         buyTokens(msg.sender);
199     }
200 
201     function buyTokens(address beneficiary) payable public {
202         require(isWithinValidIcoPhase());
203         require(ethPriceInEuroCent > 0);
204         require(beneficiary != address(0));
205         require(msg.value != 0);
206 
207         uint256 ethWeiAmount = msg.value;
208         // calculate BEAT wei amount to be created
209         uint256 beatWeiAmount = calculateBeatWeiAmount(ethWeiAmount);
210         require(isWithinTokenAllocLimit(beatWeiAmount));
211 
212         determineCurrentStage(beatWeiAmount);
213 
214         balanceOf[beneficiary] += beatWeiAmount;
215         ethWeiRaised += ethWeiAmount;
216 
217         token.mint(beneficiary, beatWeiAmount);
218         BeatTokenPurchased(msg.sender, beneficiary, ethWeiAmount, beatWeiAmount);
219 
220         ethTeamWallet.transfer(ethWeiAmount);
221     }
222 
223     function isWithinValidIcoPhase() internal view returns (bool) {
224         return (stage == Stages.PreIco || stage == Stages.IcoPhase1 || stage == Stages.IcoPhase2 || stage == Stages.IcoPhase3);
225     }
226 
227     function calculateBeatWeiAmount(uint256 ethWeiAmount) internal view returns (uint256) {
228         uint256 beatWeiAmount = ethWeiAmount.mul(ethPriceInEuroCent);
229         uint256 bonusPercentage = 0;
230 
231         if (stage == Stages.PreIco) {
232             bonusPercentage = PRE_ICO_BONUS_PERCENTAGE;
233         } else if (stage == Stages.IcoPhase1) {
234             bonusPercentage = ICO_PHASE1_BONUS_PERCENTAGE;
235         } else if (stage == Stages.IcoPhase2) {
236             bonusPercentage = ICO_PHASE2_BONUS_PERCENTAGE;
237         } else if (stage == Stages.IcoPhase3) {
238             bonusPercentage = ICO_PHASE3_BONUS_PERCENTAGE;
239         }
240 
241         // implement poor man's rounding by adding 50 because all integer divisions rounds DOWN to nearest integer
242         return beatWeiAmount.mul(100 + bonusPercentage).add(50).div(100);
243     }
244 
245     function isWithinTokenAllocLimit(uint256 beatWeiAmount) internal view returns (bool) {
246         return token.getTotalSupply().add(beatWeiAmount) <= ICO_PHASE3_LIMIT;
247     }
248 
249     function determineCurrentStage(uint256 beatWeiAmount) internal {
250         uint256 newTokenTotalSupply = token.getTotalSupply().add(beatWeiAmount);
251 
252         if (stage == Stages.PreIco && (newTokenTotalSupply > PRE_ICO_LIMIT || now >= contractStartTime + PRE_ICO_PERIOD)) {
253             preIcoEndTime = now;
254             stage = Stages.IcoPhase1;
255             BeatTokenIcoPhase1Started();
256         } else if (stage == Stages.IcoPhase1 && (newTokenTotalSupply > ICO_PHASE1_LIMIT || now >= preIcoEndTime + ICO_PHASE1_PERIOD)) {
257             icoPhase1EndTime = now;
258             stage = Stages.IcoPhase2;
259             BeatTokenIcoPhase2Started();
260         } else if (stage == Stages.IcoPhase2 && (newTokenTotalSupply > ICO_PHASE2_LIMIT || now >= icoPhase1EndTime + ICO_PHASE2_PERIOD)) {
261             icoPhase2EndTime = now;
262             stage = Stages.IcoPhase3;
263             BeatTokenIcoPhase3Started();
264         } else if (stage == Stages.IcoPhase3 && (newTokenTotalSupply == ICO_PHASE3_LIMIT || now >= icoPhase2EndTime + ICO_PHASE3_PERIOD)) {
265             icoPhase3EndTime = now;
266             stage = Stages.IcoEnded;
267         }
268     }
269 
270 }
271 
272 contract ERC20Basic {
273   uint256 public totalSupply;
274   function balanceOf(address who) public view returns (uint256);
275   function transfer(address to, uint256 value) public returns (bool);
276   event Transfer(address indexed from, address indexed to, uint256 value);
277 }
278 
279 contract BasicToken is ERC20Basic {
280   using SafeMath for uint256;
281 
282   mapping(address => uint256) balances;
283 
284   /**
285   * @dev transfer token for a specified address
286   * @param _to The address to transfer to.
287   * @param _value The amount to be transferred.
288   */
289   function transfer(address _to, uint256 _value) public returns (bool) {
290     require(_to != address(0));
291     require(_value <= balances[msg.sender]);
292 
293     // SafeMath.sub will throw if there is not enough balance.
294     balances[msg.sender] = balances[msg.sender].sub(_value);
295     balances[_to] = balances[_to].add(_value);
296     Transfer(msg.sender, _to, _value);
297     return true;
298   }
299 
300   /**
301   * @dev Gets the balance of the specified address.
302   * @param _owner The address to query the the balance of.
303   * @return An uint256 representing the amount owned by the passed address.
304   */
305   function balanceOf(address _owner) public view returns (uint256 balance) {
306     return balances[_owner];
307   }
308 
309 }
310 
311 contract ERC20 is ERC20Basic {
312   function allowance(address owner, address spender) public view returns (uint256);
313   function transferFrom(address from, address to, uint256 value) public returns (bool);
314   function approve(address spender, uint256 value) public returns (bool);
315   event Approval(address indexed owner, address indexed spender, uint256 value);
316 }
317 
318 contract StandardToken is ERC20, BasicToken {
319 
320   mapping (address => mapping (address => uint256)) internal allowed;
321 
322 
323   /**
324    * @dev Transfer tokens from one address to another
325    * @param _from address The address which you want to send tokens from
326    * @param _to address The address which you want to transfer to
327    * @param _value uint256 the amount of tokens to be transferred
328    */
329   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
330     require(_to != address(0));
331     require(_value <= balances[_from]);
332     require(_value <= allowed[_from][msg.sender]);
333 
334     balances[_from] = balances[_from].sub(_value);
335     balances[_to] = balances[_to].add(_value);
336     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
337     Transfer(_from, _to, _value);
338     return true;
339   }
340 
341   /**
342    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
343    *
344    * Beware that changing an allowance with this method brings the risk that someone may use both the old
345    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
346    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
347    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
348    * @param _spender The address which will spend the funds.
349    * @param _value The amount of tokens to be spent.
350    */
351   function approve(address _spender, uint256 _value) public returns (bool) {
352     allowed[msg.sender][_spender] = _value;
353     Approval(msg.sender, _spender, _value);
354     return true;
355   }
356 
357   /**
358    * @dev Function to check the amount of tokens that an owner allowed to a spender.
359    * @param _owner address The address which owns the funds.
360    * @param _spender address The address which will spend the funds.
361    * @return A uint256 specifying the amount of tokens still available for the spender.
362    */
363   function allowance(address _owner, address _spender) public view returns (uint256) {
364     return allowed[_owner][_spender];
365   }
366 
367   /**
368    * @dev Increase the amount of tokens that an owner allowed to a spender.
369    *
370    * approve should be called when allowed[_spender] == 0. To increment
371    * allowed value is better to use this function to avoid 2 calls (and wait until
372    * the first transaction is mined)
373    * From MonolithDAO Token.sol
374    * @param _spender The address which will spend the funds.
375    * @param _addedValue The amount of tokens to increase the allowance by.
376    */
377   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
378     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
379     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
380     return true;
381   }
382 
383   /**
384    * @dev Decrease the amount of tokens that an owner allowed to a spender.
385    *
386    * approve should be called when allowed[_spender] == 0. To decrement
387    * allowed value is better to use this function to avoid 2 calls (and wait until
388    * the first transaction is mined)
389    * From MonolithDAO Token.sol
390    * @param _spender The address which will spend the funds.
391    * @param _subtractedValue The amount of tokens to decrease the allowance by.
392    */
393   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
394     uint oldValue = allowed[msg.sender][_spender];
395     if (_subtractedValue > oldValue) {
396       allowed[msg.sender][_spender] = 0;
397     } else {
398       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
399     }
400     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
401     return true;
402   }
403 
404 }
405 
406 contract MintableToken is StandardToken, Ownable {
407   event Mint(address indexed to, uint256 amount);
408   event MintFinished();
409 
410   bool public mintingFinished = false;
411 
412 
413   modifier canMint() {
414     require(!mintingFinished);
415     _;
416   }
417 
418   /**
419    * @dev Function to mint tokens
420    * @param _to The address that will receive the minted tokens.
421    * @param _amount The amount of tokens to mint.
422    * @return A boolean that indicates if the operation was successful.
423    */
424   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
425     totalSupply = totalSupply.add(_amount);
426     balances[_to] = balances[_to].add(_amount);
427     Mint(_to, _amount);
428     Transfer(address(0), _to, _amount);
429     return true;
430   }
431 
432   /**
433    * @dev Function to stop minting new tokens.
434    * @return True if the operation was successful.
435    */
436   function finishMinting() onlyOwner canMint public returns (bool) {
437     mintingFinished = true;
438     MintFinished();
439     return true;
440   }
441 }
442 
443 contract CappedToken is MintableToken {
444 
445   uint256 public cap;
446 
447   function CappedToken(uint256 _cap) public {
448     require(_cap > 0);
449     cap = _cap;
450   }
451 
452   /**
453    * @dev Function to mint tokens
454    * @param _to The address that will receive the minted tokens.
455    * @param _amount The amount of tokens to mint.
456    * @return A boolean that indicates if the operation was successful.
457    */
458   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
459     require(totalSupply.add(_amount) <= cap);
460 
461     return super.mint(_to, _amount);
462   }
463 
464 }
465 
466 contract BeatToken is CappedToken {
467 
468     string public constant name = "BEAT Token";
469     string public constant symbol = "BEAT";
470     uint8 public constant decimals = 18;
471 
472     function BeatToken(uint256 _cap) CappedToken(_cap) public {
473     }
474 
475     function getTotalSupply() public view returns (uint256) {
476         return totalSupply;
477     }
478 
479 }