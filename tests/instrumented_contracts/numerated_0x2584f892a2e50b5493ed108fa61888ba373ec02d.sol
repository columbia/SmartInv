1 pragma solidity ^0.4.11;
2 
3 library SafeMath {
4     function mul(uint a, uint b) internal returns (uint) {
5         uint c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint a, uint b) internal returns (uint) {
11         // assert(b > 0); // Solidity automatically throws when dividing by 0
12         uint c = a / b;
13         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14         return c;
15     }
16 
17     function sub(uint a, uint b) internal returns (uint) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint a, uint b) internal returns (uint) {
23         uint c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 
28     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
29         return a >= b ? a : b;
30     }
31 
32     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
33         return a < b ? a : b;
34     }
35 
36     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
37         return a >= b ? a : b;
38     }
39 
40     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
41         return a < b ? a : b;
42     }
43 }
44 
45 /// @dev `Owned` is a base level contract that assigns an `owner` that can be
46 ///  later changed
47 contract Owned {
48 
49     /// @dev `owner` is the only address that can call a function with this
50     /// modifier
51     modifier onlyOwner() {
52         if(msg.sender != owner) throw;
53         _;
54     }
55 
56     address public owner;
57 
58     /// @notice The Constructor assigns the message sender to be `owner`
59     function Owned() {
60         owner = msg.sender;
61     }
62 
63     address public newOwner;
64 
65     /// @notice `owner` can step down and assign some other address to this role
66     /// @param _newOwner The address of the new owner. 0x0 can be used to create
67     ///  an unowned neutral vault, however that cannot be undone
68     function changeOwner(address _newOwner) onlyOwner {
69         newOwner = _newOwner;
70     }
71 
72 
73     function acceptOwnership() {
74         if (msg.sender == newOwner) {
75             owner = newOwner;
76         }
77     }
78 }
79 
80 contract ERC20Token {
81     /* This is a slight change to the ERC20 base standard.
82     function totalSupply() constant returns (uint256 supply);
83     is replaced with:
84     uint256 public totalSupply;
85     This automatically creates a getter function for the totalSupply.
86     This is moved to the base contract since public getter functions are not
87     currently recognised as an implementation of the matching abstract
88     function by the compiler.
89     */
90     /// total amount of tokens
91     uint256 public totalSupply;
92 
93     /// @param _owner The address from which the balance will be retrieved
94     /// @return The balance
95     function balanceOf(address _owner) constant returns (uint256 balance);
96 
97     /// @notice send `_value` token to `_to` from `msg.sender`
98     /// @param _to The address of the recipient
99     /// @param _value The amount of token to be transferred
100     /// @return Whether the transfer was successful or not
101     function transfer(address _to, uint256 _value) returns (bool success);
102 
103     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
104     /// @param _from The address of the sender
105     /// @param _to The address of the recipient
106     /// @param _value The amount of token to be transferred
107     /// @return Whether the transfer was successful or not
108     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
109 
110     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
111     /// @param _spender The address of the account able to transfer the tokens
112     /// @param _value The amount of tokens to be approved for transfer
113     /// @return Whether the approval was successful or not
114     function approve(address _spender, uint256 _value) returns (bool success);
115 
116     /// @param _owner The address of the account owning tokens
117     /// @param _spender The address of the account able to transfer the tokens
118     /// @return Amount of remaining tokens allowed to spent
119     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
120 
121     event Transfer(address indexed _from, address indexed _to, uint256 _value);
122     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
123 }
124 contract Controlled {
125     /// @notice The address of the controller is the only address that can call
126     ///  a function with this modifier
127     modifier onlyController { if (msg.sender != controller) throw; _; }
128 
129     address public controller;
130 
131     function Controlled() { controller = msg.sender;}
132 
133     /// @notice Changes the controller of the contract
134     /// @param _newController The new controller of the contract
135     function changeController(address _newController) onlyController {
136         controller = _newController;
137     }
138 }
139 
140 contract StandardToken is ERC20Token ,Controlled{
141 
142     bool public showValue=true;
143 
144     // Flag that determines if the token is transferable or not.
145     bool public transfersEnabled;
146 
147     function transfer(address _to, uint256 _value) returns (bool success) {
148 
149         if(!transfersEnabled) throw;
150 
151         if (balances[msg.sender] >= _value && _value > 0) {
152             balances[msg.sender] -= _value;
153             balances[_to] += _value;
154             Transfer(msg.sender, _to, _value);
155             return true;
156         } else {
157             return false;
158         }
159     }
160 
161     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
162 
163         if(!transfersEnabled) throw;
164         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
165             balances[_to] += _value;
166             balances[_from] -= _value;
167             allowed[_from][msg.sender] -= _value;
168             Transfer(_from, _to, _value);
169             return true;
170         } else {
171             return false;
172         }
173     }
174 
175     function balanceOf(address _owner) constant returns (uint256 balance) {
176         if(!showValue)
177         return 0;
178         return balances[_owner];
179     }
180 
181     function approve(address _spender, uint256 _value) returns (bool success) {
182         if(!transfersEnabled) throw;
183         allowed[msg.sender][_spender] = _value;
184         Approval(msg.sender, _spender, _value);
185         return true;
186     }
187 
188     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
189         if(!transfersEnabled) throw;
190         return allowed[_owner][_spender];
191     }
192 
193     /// @notice Enables token holders to transfer their tokens freely if true
194     /// @param _transfersEnabled True if transfers are allowed in the clone
195     function enableTransfers(bool _transfersEnabled) onlyController {
196         transfersEnabled = _transfersEnabled;
197     }
198     function enableShowValue(bool _showValue) onlyController {
199         showValue = _showValue;
200     }
201 
202     function generateTokens(address _owner, uint _amount
203     ) onlyController returns (bool) {
204         uint curTotalSupply = totalSupply;
205         if (curTotalSupply + _amount < curTotalSupply) throw; // Check for overflow
206         totalSupply=curTotalSupply + _amount;
207 
208         balances[_owner]+=_amount;
209 
210         Transfer(0, _owner, _amount);
211         return true;
212     }
213     mapping (address => uint256) balances;
214     mapping (address => mapping (address => uint256)) allowed;
215 }
216 
217 contract MiniMeTokenSimple is StandardToken {
218 
219     string public name;                //The Token's name: e.g. DigixDAO Tokens
220     uint8 public decimals;             //Number of decimals of the smallest unit
221     string public symbol;              //An identifier: e.g. REP
222     string public version = 'MMT_0.1'; //An arbitrary versioning scheme
223 
224 
225     // `parentToken` is the Token address that was cloned to produce this token;
226     //  it will be 0x0 for a token that was not cloned
227     address public parentToken;
228 
229     // `parentSnapShotBlock` is the block number from the Parent Token that was
230     //  used to determine the initial distribution of the Clone Token
231     uint public parentSnapShotBlock;
232 
233     // `creationBlock` is the block number that the Clone Token was created
234     uint public creationBlock;
235 
236     // The factory used to create new clone tokens
237     address public tokenFactory;
238 
239     ////////////////
240     // Constructor
241     ////////////////
242 
243     /// @notice Constructor to create a MiniMeTokenSimple
244     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
245     ///  will create the Clone token contracts, the token factory needs to be
246     ///  deployed first
247     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
248     ///  new token
249     /// @param _parentSnapShotBlock Block of the parent token that will
250     ///  determine the initial distribution of the clone token, set to 0 if it
251     ///  is a new token
252     /// @param _tokenName Name of the new token
253     /// @param _decimalUnits Number of decimals of the new token
254     /// @param _tokenSymbol Token Symbol for the new token
255     /// @param _transfersEnabled If true, tokens will be able to be transferred
256     function MiniMeTokenSimple(
257     address _tokenFactory,
258     address _parentToken,
259     uint _parentSnapShotBlock,
260     string _tokenName,
261     uint8 _decimalUnits,
262     string _tokenSymbol,
263     bool _transfersEnabled
264     ) {
265         tokenFactory = _tokenFactory;
266         name = _tokenName;                                 // Set the name
267         decimals = _decimalUnits;                          // Set the decimals
268         symbol = _tokenSymbol;                             // Set the symbol
269         parentToken = _parentToken;
270         parentSnapShotBlock = _parentSnapShotBlock;
271         transfersEnabled = _transfersEnabled;
272         creationBlock = block.number;
273     }
274     //////////
275     // Safety Methods
276     //////////
277 
278     /// @notice This method can be used by the controller to extract mistakenly
279     ///  sent tokens to this contract.
280     /// @param _token The address of the token contract that you want to recover
281     ///  set to 0 in case you want to extract ether.
282     function claimTokens(address _token) onlyController {
283         if (_token == 0x0) {
284             controller.transfer(this.balance);
285             return;
286         }
287 
288         ERC20Token token = ERC20Token(_token);
289         uint balance = token.balanceOf(this);
290         token.transfer(controller, balance);
291         ClaimedTokens(_token, controller, balance);
292     }
293 
294     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
295 
296 }
297 
298 
299 contract PFCContribution is Owned {
300 
301     using SafeMath for uint256;
302     MiniMeTokenSimple public PFC;
303     uint256 public ratio=25000;
304 
305     uint256 public constant MIN_FUND = (0.001 ether);
306 
307     uint256 public startTime=0 ;
308     uint256 public endTime =0;
309     uint256 public finalizedBlock=0;
310     uint256 public finalizedTime=0;
311 
312     bool public isFinalize = false;
313 
314     uint256 public totalContributedETH = 0;
315     uint256 public totalTokenSaled=0;
316 
317     uint256 public MaxEth=15000 ether;
318 
319 
320     address public pfcController;
321     address public destEthFoundation;
322 
323     bool public paused;
324 
325     modifier initialized() {
326         require(address(PFC) != 0x0);
327         _;
328     }
329 
330     modifier contributionOpen() {
331         require(time() >= startTime &&
332         time() <= endTime &&
333         finalizedBlock == 0 &&
334         address(PFC) != 0x0);
335         _;
336     }
337 
338     modifier notPaused() {
339         require(!paused);
340         _;
341     }
342 
343     function PFCCContribution() {
344         paused = false;
345     }
346 
347 
348     /// @notice This method should be called by the owner before the contribution
349     ///  period starts This initializes most of the parameters
350     /// @param _pfc Address of the PFC token contract
351     /// @param _pfcController Token controller for the PFC that will be transferred after
352     ///  the contribution finalizes.
353     /// @param _startTime Time when the contribution period starts
354     /// @param _endTime The time that the contribution period ends
355     /// @param _destEthFoundation Destination address where the contribution ether is sent
356     function initialize(
357     address _pfc,
358     address _pfcController,
359     uint256 _startTime,
360     uint256 _endTime,
361     address _destEthFoundation,
362     uint256 _maxEth
363     ) public onlyOwner {
364         // Initialize only once
365         require(address(PFC) == 0x0);
366 
367         PFC = MiniMeTokenSimple(_pfc);
368         require(PFC.totalSupply() == 0);
369         require(PFC.controller() == address(this));
370         require(PFC.decimals() == 18);  // Same amount of decimals as ETH
371 
372         startTime = _startTime;
373         endTime = _endTime;
374 
375         assert(startTime < endTime);
376 
377         require(_pfcController != 0x0);
378         pfcController = _pfcController;
379 
380         require(_destEthFoundation != 0x0);
381         destEthFoundation = _destEthFoundation;
382 
383         require(_maxEth >1 ether);
384         MaxEth=_maxEth;
385     }
386 
387     /// @notice If anybody sends Ether directly to this contract, consider he is
388     ///  getting PFCs.
389     function () public payable notPaused {
390 
391         if(totalContributedETH>=MaxEth) throw;
392         proxyPayment(msg.sender);
393     }
394 
395 
396     //////////
397     // MiniMe Controller functions
398     //////////
399 
400     /// @notice This method will generally be called by the PFC token contract to
401     ///  acquire PFCs. Or directly from third parties that want to acquire PFCs in
402     ///  behalf of a token holder.
403     /// @param _account PFC holder where the PFC will be minted.
404     function proxyPayment(address _account) public payable initialized contributionOpen returns (bool) {
405         require(_account != 0x0);
406 
407         require( msg.value >= MIN_FUND );
408 
409         uint256 tokenSaling;
410         uint256 rValue;
411         uint256 t_totalContributedEth=totalContributedETH+msg.value;
412         uint256 reFund=0;
413         if(t_totalContributedEth>MaxEth) {
414             reFund=t_totalContributedEth-MaxEth;
415         }
416         rValue=msg.value-reFund;
417         tokenSaling=rValue.mul(ratio);
418         if(reFund>0)
419         msg.sender.transfer(reFund);
420         assert(PFC.generateTokens(_account,tokenSaling));
421         destEthFoundation.transfer(rValue);
422 
423         totalContributedETH +=rValue;
424         totalTokenSaled+=tokenSaling;
425 
426         NewSale(msg.sender, rValue,tokenSaling);
427     }
428 
429     function setMaxEth(uint256 _maxEth) onlyOwner initialized{
430         MaxEth=_maxEth;
431     }
432 
433     function setRatio(uint256 _ratio) onlyOwner initialized{
434         ratio=_ratio;
435     }
436 
437     function issueTokenToAddress(address _account, uint256 _amount) onlyOwner initialized {
438 
439 
440         assert(PFC.generateTokens(_account, _amount));
441 
442         totalTokenSaled +=_amount;
443 
444         NewIssue(_account, _amount);
445 
446     }
447 
448     function finalize() public onlyOwner initialized {
449         require(time() >= startTime);
450 
451         require(finalizedBlock == 0);
452 
453         finalizedBlock = getBlockNumber();
454         finalizedTime = now;
455 
456         PFC.changeController(pfcController);
457         isFinalize=true;
458         Finalized();
459     }
460 
461     function time() constant returns (uint) {
462         return block.timestamp;
463     }
464 
465     //////////
466     // Constant functions
467     //////////
468 
469     /// @return Total tokens issued in weis.
470     function tokensIssued() public constant returns (uint256) {
471         return PFC.totalSupply();
472     }
473 
474     //////////
475     // Testing specific methods
476     //////////
477 
478     /// @notice This function is overridden by the test Mocks.
479     function getBlockNumber() internal constant returns (uint256) {
480         return block.number;
481     }
482 
483     //////////
484     // Safety Methods
485     //////////
486 
487     /// @notice This method can be used by the controller to extract mistakenly
488     ///  sent tokens to this contract.
489     /// @param _token The address of the token contract that you want to recover
490     ///  set to 0 in case you want to extract ether.
491     function claimTokens(address _token) public onlyOwner {
492         if (PFC.controller() == address(this)) {
493             PFC.claimTokens(_token);
494         }
495         if (_token == 0x0) {
496             owner.transfer(this.balance);
497             return;
498         }
499 
500         ERC20Token token = ERC20Token(_token);
501         uint256 balance = token.balanceOf(this);
502         token.transfer(owner, balance);
503         ClaimedTokens(_token, owner, balance);
504     }
505 
506     /// @notice Pauses the contribution if there is any issue
507     function pauseContribution() onlyOwner {
508         paused = true;
509     }
510 
511     /// @notice Resumes the contribution
512     function resumeContribution() onlyOwner {
513         paused = false;
514     }
515 
516     event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);
517     event NewSale(address _account, uint256 _amount,uint256 _tokenAmount);
518     event NewIssue(address indexed _th, uint256 _amount);
519     event Finalized();
520 }