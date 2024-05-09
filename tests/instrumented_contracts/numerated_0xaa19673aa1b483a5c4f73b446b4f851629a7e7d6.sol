1 /**
2  *
3  * ██╗  ██╗███████╗████████╗██╗  ██╗
4  * ╚██╗██╔╝██╔════╝╚══██╔══╝██║  ██║
5  *  ╚███╔╝ █████╗     ██║   ███████║
6  *  ██╔██╗ ██╔══╝     ██║   ██╔══██║
7  * ██╔╝ ██╗███████╗   ██║   ██║  ██║
8  * ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚═╝  ╚═╝
9  * 
10  *    An Ethereum pegged 
11  * base-down, burn-up currency. 
12  *                    
13  *  https://xEth.finance
14  *                              
15  * 
16 **/
17 
18 
19 pragma solidity ^0.6.6;
20 
21 
22 contract Ownable {
23     address public owner;
24 
25     event TransferOwnership(address _from, address _to);
26 
27     modifier onlyOwner() {
28         require(msg.sender == owner, "only owner");
29         _;
30     }
31 
32     function setOwner(address _owner) external onlyOwner {
33         emit TransferOwnership(owner, _owner);
34         owner = _owner;
35     }
36 }
37 
38 contract XplosiveEthereum is Ownable {
39     
40     using SafeMath for uint256;
41     
42     event Rebase(uint256 indexed epoch, uint256 scalingFactor);
43     event NewRebaser(address oldRebaser, address newRebaser);
44     
45     event Transfer(address indexed from, address indexed to, uint amount);
46     event Approval(address indexed owner, address indexed spender, uint amount);
47 
48     string public name     = "Xplosive Ethereum";
49     string public symbol   = "xETH";
50     uint8  public decimals = 18;
51     
52     address public rebaser;
53     
54     address public rewardAddress;
55 
56     /**
57      * @notice Internal decimals used to handle scaling factor
58      */
59     uint256 public constant internalDecimals = 10**24;
60 
61     /**
62      * @notice Used for percentage maths
63      */
64     uint256 public constant BASE = 10**18;
65 
66     /**
67      * @notice Scaling factor that adjusts everyone's balances
68      */
69     uint256 public xETHScalingFactor  = BASE;
70 
71     mapping (address => uint256) internal _xETHBalances;
72     mapping (address => mapping (address => uint256)) internal _allowedFragments;
73     
74     
75     mapping(address => bool) public whitelistFrom;
76     mapping(address => bool) public whitelistTo;
77     mapping(address => bool) public whitelistRebase;
78     
79     
80     address public noRebaseAddress;
81     
82     uint256 initSupply = 0;
83     uint256 _totalSupply = 0;
84     uint16 public SELL_FEE = 33;
85     uint16 public TX_FEE = 50;
86     
87     event WhitelistFrom(address _addr, bool _whitelisted);
88     event WhitelistTo(address _addr, bool _whitelisted);
89     event WhitelistRebase(address _addr, bool _whitelisted);
90     
91      constructor(
92         uint256 initialSupply,
93         address initialSupplyAddr
94         
95         ) public {
96         owner = msg.sender;
97         emit TransferOwnership(address(0), msg.sender);
98         _mint(initialSupplyAddr,initialSupply);
99         
100     }
101     
102     function totalSupply() public view returns (uint256) {
103         return _totalSupply;
104     }
105     
106     function getSellBurn(uint256 value) public view returns (uint256)  {
107         uint256 nPercent = value.divRound(SELL_FEE);
108         return nPercent;
109     }
110     function getTxBurn(uint256 value) public view returns (uint256)  {
111         uint256 nPercent = value.divRound(TX_FEE);
112         return nPercent;
113     }
114     
115     function _isWhitelisted(address _from, address _to) internal view returns (bool) {
116         return whitelistFrom[_from]||whitelistTo[_to];
117     }
118     function _isRebaseWhitelisted(address _addr) internal view returns (bool) {
119         return whitelistRebase[_addr];
120     }
121 
122     function setWhitelistedTo(address _addr, bool _whitelisted) external onlyOwner {
123         emit WhitelistTo(_addr, _whitelisted);
124         whitelistTo[_addr] = _whitelisted;
125     }
126     
127     function setTxFee(uint16 fee) external onlyRebaser {
128         TX_FEE = fee;
129     }
130     
131     function setSellFee(uint16 fee) external onlyRebaser {
132         SELL_FEE = fee;
133     }
134     
135     function setWhitelistedFrom(address _addr, bool _whitelisted) external onlyOwner {
136         emit WhitelistFrom(_addr, _whitelisted);
137         whitelistFrom[_addr] = _whitelisted;
138     }
139       
140     function setWhitelistedRebase(address _addr, bool _whitelisted) external onlyOwner {
141         emit WhitelistRebase(_addr, _whitelisted);
142         whitelistRebase[_addr] = _whitelisted;
143     }
144     
145     function setNoRebaseAddress(address _addr) external onlyOwner {
146         noRebaseAddress = _addr;
147     }
148     
149     
150    
151 
152     modifier onlyRebaser() {
153         require(msg.sender == rebaser);
154         _;
155     }
156 
157 
158 
159     
160     /**
161     * @notice Computes the current max scaling factor
162     */
163     function maxScalingFactor()
164         external
165         view
166         returns (uint256)
167     {
168         return _maxScalingFactor();
169     }
170 
171     function _maxScalingFactor()
172         internal
173         view
174         returns (uint256)
175     {
176         // scaling factor can only go up to 2**256-1 = initSupply * xETHScalingFactor
177         // this is used to check if xETHScalingFactor will be too high to compute balances when rebasing.
178         return uint256(-1) / initSupply;
179     }
180 
181    
182     function _mint(address to, uint256 amount)
183         internal
184     {
185       // increase totalSupply
186       _totalSupply = _totalSupply.add(amount);
187 
188       // get underlying value
189       uint256 xETHValue = amount.mul(internalDecimals).div(xETHScalingFactor);
190 
191       // increase initSupply
192       initSupply = initSupply.add(xETHValue);
193 
194       // make sure the mint didnt push maxScalingFactor too low
195       require(xETHScalingFactor <= _maxScalingFactor(), "max scaling factor too low");
196 
197       // add balance
198       _xETHBalances[to] = _xETHBalances[to].add(xETHValue);
199       
200       emit Transfer(address(0),to,amount);
201 
202      
203     }
204     
205    
206 
207     /* - ERC20 functionality - */
208 
209     /**
210     * @dev Transfer tokens to a specified address.
211     * @param to The address to transfer to.
212     * @param value The amount to be transferred.
213     * @return True on success, false otherwise.
214     */
215     function transfer(address to, uint256 value)
216         external
217         returns (bool)
218     {
219         // underlying balance is stored in xETH, so divide by current scaling factor
220 
221         // note, this means as scaling factor grows, dust will be untransferrable.
222         // minimum transfer value == xETHScalingFactor / 1e24;
223         
224         // get amount in underlying
225         //from noRebaseWallet
226         if(_isRebaseWhitelisted(msg.sender)){
227             uint256 noReValue = value.mul(internalDecimals).div(BASE);
228             uint256 noReNextValue = noReValue.mul(BASE).div(xETHScalingFactor);
229             _xETHBalances[msg.sender] = _xETHBalances[msg.sender].sub(noReValue); //value==underlying
230             _xETHBalances[to] = _xETHBalances[to].add(noReNextValue);
231             emit Transfer(msg.sender, to, value);
232         }
233         else if(_isRebaseWhitelisted(to)){
234             uint256 fee = getSellBurn(value);
235             uint256 tokensToBurn = fee/2;
236             uint256 tokensForRewards = fee-tokensToBurn;
237             uint256 tokensToTransfer = value-fee;
238                 
239             uint256 xETHValue = value.mul(internalDecimals).div(xETHScalingFactor);
240             uint256 xETHValueKeep = tokensToTransfer.mul(internalDecimals).div(xETHScalingFactor);
241             uint256 xETHValueReward = tokensForRewards.mul(internalDecimals).div(xETHScalingFactor);
242             
243             
244             uint256 xETHNextValue = xETHValueKeep.mul(xETHScalingFactor).div(BASE);
245             
246             _totalSupply = _totalSupply-fee;
247             _xETHBalances[address(0)] = _xETHBalances[address(0)].add(fee/2);
248             _xETHBalances[msg.sender] = _xETHBalances[msg.sender].sub(xETHValue); 
249             _xETHBalances[to] = _xETHBalances[to].add(xETHNextValue);
250             _xETHBalances[rewardAddress] = _xETHBalances[rewardAddress].add(xETHValueReward);
251             emit Transfer(msg.sender, to, tokensToTransfer);
252             emit Transfer(msg.sender, address(0), tokensToBurn);
253             emit Transfer(msg.sender, rewardAddress, tokensForRewards);
254         }
255         else{
256           if(!_isWhitelisted(msg.sender, to)){
257                 uint256 fee = getTxBurn(value);
258                 uint256 tokensToBurn = fee/2;
259                 uint256 tokensForRewards = fee-tokensToBurn;
260                 uint256 tokensToTransfer = value-fee;
261                     
262                 uint256 xETHValue = value.mul(internalDecimals).div(xETHScalingFactor);
263                 uint256 xETHValueKeep = tokensToTransfer.mul(internalDecimals).div(xETHScalingFactor);
264                 uint256 xETHValueReward = tokensForRewards.mul(internalDecimals).div(xETHScalingFactor);
265                 
266                 _totalSupply = _totalSupply-fee;
267                 _xETHBalances[address(0)] = _xETHBalances[address(0)].add(fee/2);
268                 _xETHBalances[msg.sender] = _xETHBalances[msg.sender].sub(xETHValue); 
269                 _xETHBalances[to] = _xETHBalances[to].add(xETHValueKeep);
270                 _xETHBalances[rewardAddress] = _xETHBalances[rewardAddress].add(xETHValueReward);
271                 emit Transfer(msg.sender, to, tokensToTransfer);
272                 emit Transfer(msg.sender, address(0), tokensToBurn);
273                 emit Transfer(msg.sender, rewardAddress, tokensForRewards);
274            }
275              else{
276                 uint256 xETHValue = value.mul(internalDecimals).div(xETHScalingFactor);
277                
278                 _xETHBalances[msg.sender] = _xETHBalances[msg.sender].sub(xETHValue); 
279                 _xETHBalances[to] = _xETHBalances[to].add(xETHValue);
280                 emit Transfer(msg.sender, to, xETHValue);
281              }
282         }
283         return true;
284     }
285 
286 
287 
288     /**
289     * @dev Transfer tokens from one address to another.
290     * @param from The address you want to send tokens from.
291     * @param to The address you want to transfer to.
292     * @param value The amount of tokens to be transferred.
293     */
294     function transferFrom(address from, address to, uint256 value)
295         external
296         returns (bool)
297     {
298         // decrease allowance
299         _allowedFragments[from][msg.sender] = _allowedFragments[from][msg.sender].sub(value);
300 
301         if(_isRebaseWhitelisted(from)){
302             uint256 noReValue = value.mul(internalDecimals).div(BASE);
303             uint256 noReNextValue = noReValue.mul(BASE).div(xETHScalingFactor);
304             _xETHBalances[from] = _xETHBalances[from].sub(noReValue); //value==underlying
305             _xETHBalances[to] = _xETHBalances[to].add(noReNextValue);
306             emit Transfer(from, to, value);
307         }
308         else if(_isRebaseWhitelisted(to)){
309             uint256 fee = getSellBurn(value);
310             uint256 tokensForRewards = fee-(fee/2);
311             uint256 tokensToTransfer = value-fee;
312             
313             uint256 xETHValue = value.mul(internalDecimals).div(xETHScalingFactor);
314             uint256 xETHValueKeep = tokensToTransfer.mul(internalDecimals).div(xETHScalingFactor);
315             uint256 xETHValueReward = tokensForRewards.mul(internalDecimals).div(xETHScalingFactor);
316             uint256 xETHNextValue = xETHValueKeep.mul(xETHScalingFactor).div(BASE);
317             
318             _totalSupply = _totalSupply-fee;
319             
320             _xETHBalances[from] = _xETHBalances[from].sub(xETHValue); 
321             _xETHBalances[to] = _xETHBalances[to].add(xETHNextValue);
322             _xETHBalances[rewardAddress] = _xETHBalances[rewardAddress].add(xETHValueReward);
323             _xETHBalances[address(0)] = _xETHBalances[address(0)].add(fee/2);
324             emit Transfer(from, to, tokensToTransfer);
325             emit Transfer(from, address(0), fee/2);
326             emit Transfer(from, rewardAddress, tokensForRewards);
327         }
328         else{
329           if(!_isWhitelisted(from, to)){
330                 uint256 fee = getTxBurn(value);
331                 uint256 tokensToBurn = fee/2;
332                 uint256 tokensForRewards = fee-tokensToBurn;
333                 uint256 tokensToTransfer = value-fee;
334                     
335                 uint256 xETHValue = value.mul(internalDecimals).div(xETHScalingFactor);
336                 uint256 xETHValueKeep = tokensToTransfer.mul(internalDecimals).div(xETHScalingFactor);
337                 uint256 xETHValueReward = tokensForRewards.mul(internalDecimals).div(xETHScalingFactor);
338             
339                 _totalSupply = _totalSupply-fee;
340                 _xETHBalances[address(0)] = _xETHBalances[address(0)].add(fee/2);
341                 _xETHBalances[from] = _xETHBalances[from].sub(xETHValue); 
342                 _xETHBalances[to] = _xETHBalances[to].add(xETHValueKeep);
343                 _xETHBalances[rewardAddress] = _xETHBalances[rewardAddress].add(xETHValueReward);
344                 emit Transfer(from, to, tokensToTransfer);
345                 emit Transfer(from, address(0), tokensToBurn);
346                 emit Transfer(from, rewardAddress, tokensForRewards);
347            }
348              else{
349                 uint256 xETHValue = value.mul(internalDecimals).div(xETHScalingFactor);
350                
351                 _xETHBalances[from] = _xETHBalances[from].sub(xETHValue); 
352                 _xETHBalances[to] = _xETHBalances[to].add(xETHValue);
353                 emit Transfer(from, to, xETHValue);
354                 
355             
356              }
357         }
358         return true;
359     }
360 
361     /**
362     * @param who The address to query.
363     * @return The balance of the specified address.
364     */
365     function balanceOf(address who)
366       external
367       view
368       returns (uint256)
369     {
370       if(_isRebaseWhitelisted(who)){
371         return _xETHBalances[who].mul(BASE).div(internalDecimals);
372       }
373       else{
374         return _xETHBalances[who].mul(xETHScalingFactor).div(internalDecimals);
375       }
376     }
377 
378     /** @notice Currently returns the internal storage amount
379     * @param who The address to query.
380     * @return The underlying balance of the specified address.
381     */
382     function balanceOfUnderlying(address who)
383       external
384       view
385       returns (uint256)
386     {
387       return _xETHBalances[who];
388     }
389 
390     /**
391      * @dev Function to check the amount of tokens that an owner has allowed to a spender.
392      * @param owner_ The address which owns the funds.
393      * @param spender The address which will spend the funds.
394      * @return The number of tokens still available for the spender.
395      */
396     function allowance(address owner_, address spender)
397         external
398         view
399         returns (uint256)
400     {
401         return _allowedFragments[owner_][spender];
402     }
403 
404     /**
405      * @dev Approve the passed address to spend the specified amount of tokens on behalf of
406      * msg.sender. This method is included for ERC20 compatibility.
407      * increaseAllowance and decreaseAllowance should be used instead.
408      * Changing an allowance with this method brings the risk that someone may transfer both
409      * the old and the new allowance - if they are both greater than zero - if a transfer
410      * transaction is mined before the later approve() call is mined.
411      *
412      * @param spender The address which will spend the funds.
413      * @param value The amount of tokens to be spent.
414      */
415     function approve(address spender, uint256 value)
416         external
417         returns (bool)
418     {
419         _allowedFragments[msg.sender][spender] = value;
420         emit Approval(msg.sender, spender, value);
421         return true;
422     }
423 
424     /**
425      * @dev Increase the amount of tokens that an owner has allowed to a spender.
426      * This method should be used instead of approve() to avoid the double approval vulnerability
427      * described above.
428      * @param spender The address which will spend the funds.
429      * @param addedValue The amount of tokens to increase the allowance by.
430      */
431     function increaseAllowance(address spender, uint256 addedValue)
432         external
433         returns (bool)
434     {
435         _allowedFragments[msg.sender][spender] =
436             _allowedFragments[msg.sender][spender].add(addedValue);
437         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
438         return true;
439     }
440 
441     /**
442      * @dev Decrease the amount of tokens that an owner has allowed to a spender.
443      *
444      * @param spender The address which will spend the funds.
445      * @param subtractedValue The amount of tokens to decrease the allowance by.
446      */
447     function decreaseAllowance(address spender, uint256 subtractedValue)
448         external
449         returns (bool)
450     {
451         uint256 oldValue = _allowedFragments[msg.sender][spender];
452         if (subtractedValue >= oldValue) {
453             _allowedFragments[msg.sender][spender] = 0;
454         } else {
455             _allowedFragments[msg.sender][spender] = oldValue.sub(subtractedValue);
456         }
457         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
458         return true;
459     }
460 
461     /* - Governance Functions - */
462 
463     /** @notice sets the rebaser
464      * @param rebaser_ The address of the rebaser contract to use for authentication.
465      */
466     function _setRebaser(address rebaser_)
467         external
468         onlyOwner
469     {
470         address oldRebaser = rebaser;
471         rebaser = rebaser_;
472         emit NewRebaser(oldRebaser, rebaser_);
473     }
474     
475      function _setRewardAddress(address rewards_)
476         external
477         onlyOwner
478     {
479         rewardAddress = rewards_;
480       
481     }
482     
483     /**
484     * @notice Initiates a new rebase operation, provided the minimum time period has elapsed.
485     *
486     * @dev The supply adjustment equals (totalSupply * DeviationFromTargetRate) / rebaseLag
487     *      Where DeviationFromTargetRate is (MarketOracleRate - targetRate) / targetRate
488     *      and targetRate is CpiOracleRate / baseCpi
489     */
490     function rebase(
491         uint256 epoch,
492         uint256 indexDelta,
493         bool positive
494     )
495         external
496         onlyRebaser
497         returns (uint256)
498     {
499         if (indexDelta == 0 || !positive) {
500           emit Rebase(epoch, xETHScalingFactor);
501           return _totalSupply;
502         }
503 
504             uint256 newScalingFactor = xETHScalingFactor.mul(BASE.add(indexDelta)).div(BASE);
505             if (newScalingFactor < _maxScalingFactor()) {
506                 xETHScalingFactor = newScalingFactor;
507             } else {
508               xETHScalingFactor = _maxScalingFactor();
509             }
510         
511 
512         _totalSupply = ((initSupply.sub(_xETHBalances[address(0)]).sub(_xETHBalances[noRebaseAddress]))
513                         .mul(xETHScalingFactor).div(internalDecimals))
514                         .add(_xETHBalances[noRebaseAddress].mul(BASE).div(internalDecimals));
515         emit Rebase(epoch, xETHScalingFactor);
516         return _totalSupply;
517     }
518 }
519 
520     
521 library SafeMath {
522 
523   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
524     if (a == 0) {
525       return 0;
526     }
527 
528     uint256 c = a * b;
529     require(c / a == b);
530 
531     return c;
532   }
533 
534  
535  function div(uint256 a, uint256 b) internal pure returns (uint256) {
536     require(b > 0); // Solidity only automatically asserts when dividing by 0
537     uint256 c = a / b;
538     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
539 
540     return c;
541   }
542 
543  
544  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
545     require(b <= a);
546     uint256 c = a - b;
547 
548     return c;
549   }
550 
551   
552   function add(uint256 a, uint256 b) internal pure returns (uint256) {
553     uint256 c = a + b;
554     require(c >= a);
555 
556     return c;
557   }
558   
559   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
560     uint256 c = add(a,m);
561     uint256 d = sub(c,1);
562     return mul(div(d,m),m);
563   }
564 
565   /**
566   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
567   * reverts when dividing by zero.
568   */
569   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
570     require(b != 0);
571     return a % b;
572   }
573   
574   function divRound(uint256 x, uint256 y) internal pure returns (uint256) {
575         require(y != 0, "Div by zero");
576         uint256 r = x / y;
577         if (x % y != 0) {
578             r = r + 1;
579         }
580 
581         return r;
582     }
583 }