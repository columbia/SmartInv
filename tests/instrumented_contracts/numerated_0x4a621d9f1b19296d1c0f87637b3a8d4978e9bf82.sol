1 /**                                                                         
2                                                                                                  :+/
3                                                                                                 :+++
4                                                                                                :++++
5                                        `.-                                                    :+++++
6                                      ./++:                                                   :+++++:
7                   ```               .++++`                                                  -++++++`
8                 `-+++`              /+++.                                                  -++++++- 
9               `-+++++-             -+++:                                       ``.--://-  .+++++++  
10              -+++++++.            .++++`                              ``..--//+++++++++. .+++++++.  
11            `/+++++++/            `/+++.                          `:/+++++++++++++++++/- .+++++++/   
12           -+++++++++.            :+++:                          `++++++++++///++++:``  .++++++++.   
13         `/++++::+++:            .++++`                          `++++++/.``  -++++/   .++++++++:    
14        .+++++. ++++.           `/+++.                            :++++:     `+++++/  .+++++++++.    
15       .+++++. .++++:           /+++:                            .+++++.``` `++++++/ .+++++++++/     
16      .++++/`  :+++/.        ` -++++`       ````             `` .++++++++++./++++++/.++++++++++.     
17     -++++/`    ```        ./:.++++:`     `:/+++-  ....``..:/++:++++++++++-/+++++++++++++/++++/      
18    .+++++`               -++++++++++/- `:+++++++`:+++++++++++++++++/-..``:+++++++++++++.+++++.      
19   `++++/`     -:.`      :+++++++++::++//+++++++//+++++++++++++++++/`    -+++++++++++++..++++:       
20  `+++++`     -+++/.   `/++++++++/``/++++++//++/+++++++/-.```-++++/`    .+++++/+++++++- :++++`       
21  :++++`     -+++++`  `/++++++++/.:++++++++++/-:+++++:`     `++++/`    `+++++/`++++++:  ++++:        
22 .++++`    `:+++++. `-++++/+++++:+++++++++/-`  :++++.      `/++++`    `/+++++` +++++/  .++++`        
23 ++++-    `/+++++/`-/+++/.+++++++++/++++-```---++++-       :++++.     :+++++-  /+++/`  :+++:         
24 +++/   `:+++++++++++++: `++++++/:` /++/::/+++++++:       -++++-     -+++++/   -++/`   /+++`         
25 +++:.:/+++/-`:+++++++-   :///-.    `:+++++++++++/        -+++:      .-----`   `.`     :++:          
26 /++++++/:.     `-+++-                ``..``.++/-          .:-                          `.`          
27 `.:--.`        .+++-                        ``                                                      
28               .+++-                                                                                 
29              .+++:        We're not online Radio, we're Radio, online!                                                                          
30             `+++:                   https://cyber-fm.com                                                     
31            `/++/                                                                                    
32           `/+++`                         Powered by                                                      
33          `/+++.        Distributed Ledger Performance Rights Organization                                                       
34          /+++.                      with the WEN Protocol                                                        
35        `/+++-                                                                                       
36        :+++-                                                                                        
37               
38 Candy store Rock N’ Roll,
39 Corporation jellyroll,
40 Play the singles, it ain’t me,
41 It’s programmed insanity: 
42 You ASCAP – If BMI –
43 Could ever make a mountain fly.
44 If Japanese can boil teas
45 Then where the fuck’s my royalties?
46 
47 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
48 Song: No Surpize
49 Album: Night In The Ruts
50 By: Aerosmith
51 Songwriters: Joe Perry / Steven Victor Tallarico (Steven Tyler)
52 
53 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
54 White Paper:
55 
56 Mobile devices and the Internet have changed how music is broadcast throughout the world. Most countries enforce a royalty payment method via government regulation to insure that Musicians and Artists are compensated for the use of their performances.
57 
58 For example, SoundExchange in the United States collects online broadcast payments through a membership system, for ASCAP, BMI, SESAC Performance Rights Organizations. Large online radio networks have monetized this valuable content with subscription systems, membership perks and traditional broadcast advertising in attempt to offset the fees enforced by the laws.
59 
60 We have created an open-source online royalty payment model with peer-reviewed information available worldwide through a distributed ledger system. This Dual Token Ecosystem is named as the CyberFM “CYFM” token and named as the “MFTU” token for “Mainstream For The Underground.”
61 
62 The CYFM Token represents a regulatory compliant cryptographic form of currency for Artists that are currently registered with local representation. As mentioned above or for example SOCAN in Canada.
63 
64 The MFTU Token is similar, but represents the world’s first truly digital, fair, legal and cryptographic Performance Rights Organization for Independent Artists. Protecting their rights and payments across the entire globe!
65 
66 Both utility tokens are an ERC20 asset registered on the ETH blockchain used to create this universal payment system that enables royalties to be collected for all performances, at all times, throughout all countries! The MFTU and CYFM tokens will also be used initially to compliment fiat payments for online radio memberships, credits for in-app purchases and registration fees.
67 
68 This ecosystem represents a universal, international currency that will compensate all artists and performers across the world! The aforementioned will be compensated regardless of individual membership to their respective Performance Rights Organization. However additional perks, rewards and income will be available when these members fully adopt our system.
69 
70 Both the CYFM and MFTU token represents a “broadcast currency” that will be used inside of the ecosystem for listeners, fans and users. For example, listeners may win MFTU tokens in a radio contest, they may use the tokens to purchase premium memberships for song-skipping, on-demand downloads, commercial free streams and other benefits.
71 
72 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
73 About Us:
74 
75 Dear Listener,
76 We accept the fact that we had to sacrifice a whole Saturday creating a Radio network, but we think you're crazy for making us write an essay telling you who we think we are.
77 You see us as you want to see us: in the simplest terms, in the most convenient definitions. But what we found out is that each one of us is:
78 
79 a brain,
80 and an athlete,
81 and a basket case,
82 a princess,
83 and a criminal.
84 Does that answer your question?
85 
86 Sincerely, CyberFM
87 
88 service@cyber-fm.com
89 */
90 
91 pragma solidity ^0.5.0;
92  
93 interface IERC20 {
94   function totalSupply() external view returns (uint256);
95   function balanceOf(address who) external view returns (uint256);
96   function allowance(address owner, address spender) external view returns (uint256);
97   function transfer(address to, uint256 value) external returns (bool);
98   function approve(address spender, uint256 value) external returns (bool);
99   function transferFrom(address from, address to, uint256 value) external returns (bool);
100   function _mint(address account, uint256 amount) external returns (bool);
101   event Transfer(address indexed from, address indexed to, uint256 value);
102   event Approval(address indexed owner, address indexed spender, uint256 value);
103   event DividentTransfer(address from , address to , uint256 value);
104 }
105 library SafeMath {
106   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
107     if (a == 0) {
108       return 0;
109     }
110     uint256 c = a * b;
111     assert(c / a == b);
112     return c;
113   }
114   function div(uint256 a, uint256 b) internal pure returns (uint256) {
115     uint256 c = a / b;
116     return c;
117   }
118   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
119     assert(b <= a);
120     return a - b;
121   }
122   function add(uint256 a, uint256 b) internal pure returns (uint256) {
123     uint256 c = a + b;
124     assert(c >= a);
125     return c;
126   }
127   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
128     uint256 c = add(a,m);
129     uint256 d = sub(c,1);
130     return mul(div(d,m),m);
131   }
132 }
133 contract ERC20Detailed is IERC20 {
134   string private _name;
135   string private _symbol;
136   uint8 private _decimals;
137   constructor(string memory name, string memory symbol, uint8 decimals) public {
138     _name = name;
139     _symbol = symbol;
140     _decimals = decimals;
141   }
142   function name() public view returns(string memory) {
143     return _name;
144   }
145   function symbol() public view returns(string memory) {
146     return _symbol;
147   }
148   function decimals() public view returns(uint8) {
149     return _decimals;
150   }
151 }
152 contract Owned {
153     
154     address payable public owner;
155     address public inflationTokenAddressTokenAddress;
156     
157     event OwnershipTransferred(address indexed _from, address indexed _to);
158     constructor() public {
159         owner = msg.sender;
160     }
161     
162   modifier onlyInflationContractOrCurrent {
163         require( msg.sender == inflationTokenAddressTokenAddress || msg.sender == owner);
164         _;
165     }
166     
167     modifier onlyOwner{
168         require(msg.sender == owner );
169         _;
170     }
171     
172     function transferOwnership(address payable _newOwner) public onlyOwner {
173         owner = _newOwner;
174     }
175 }
176 
177 contract Pausable is Owned {
178   event Pause();
179   event Unpause();
180   event NotPausable();
181 
182   bool public paused = false;
183   bool public canPause = true;
184 
185   modifier whenNotPaused() {
186     require(!paused || msg.sender == owner);
187     _;
188   }
189 
190   modifier whenPaused() {
191     require(paused);
192     _;
193   }
194 
195     function pause() onlyOwner whenNotPaused public {
196         require(canPause == true);
197         paused = true;
198         emit Pause();
199     }
200 
201   function unpause() onlyOwner whenPaused public {
202     require(paused == true);
203     paused = false;
204     emit Unpause();
205   }
206 }
207 
208 
209 contract DeflationToken is ERC20Detailed, Pausable {
210     
211   using SafeMath for uint256;
212    
213   mapping (address => uint256) private _balances;
214   mapping (address => mapping (address => uint256)) private _allowed;
215   mapping (address => bool) public _freezed;
216   string constant tokenName = "CyberFM Radio";
217   string constant tokenSymbol = "CYFM";
218   uint8  constant tokenDecimals = 18;
219   uint256 _totalSupply ;
220   uint256 public basePercent = 100;
221 
222   IERC20 public InflationToken;
223   address public inflationTokenAddress;
224   
225   // Transfer Fee
226   event TransferFeeChanged(uint256 newFee);
227   event FeeRecipientChange(address account);
228   event AddFeeException(address account);
229   event RemoveFeeException(address account);
230 
231   bool private activeFee;
232   uint256 public transferFee; // Fee as percentage, where 123 = 1.23%
233   address public feeRecipient; // Account or contract to send transfer fees to
234 
235   // Exception to transfer fees, for example for Uniswap contracts.
236   mapping (address => bool) public feeException;
237 
238   function addFeeException(address account) public onlyOwner {
239     feeException[account] = true;
240     emit AddFeeException(account);
241   }
242 
243   function removeFeeException(address account) public onlyOwner {
244     feeException[account] = false;
245     emit RemoveFeeException(account);
246   }
247 
248   function setTransferFee(uint256 fee) public onlyOwner {
249     require(fee <= 2500, "Fee cannot be greater than 25%");
250     if (fee == 0) {
251       activeFee = false;
252     } else {
253       activeFee = true;
254     }
255     transferFee = fee;
256     emit TransferFeeChanged(fee);
257   }
258 
259   function setTransferFeeRecipient(address account) public onlyOwner {
260     feeRecipient = account;
261     emit FeeRecipientChange(account);
262   }
263   
264   
265   constructor() public  ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
266     _mint( msg.sender,  60000000000 * 1000000000000000000);
267   }
268   
269   
270     function freezeAccount (address account) public onlyOwner{
271         _freezed[account] = true;
272     }
273     
274      function unFreezeAccount (address account) public onlyOwner{
275         _freezed[account] = false;
276     }
277     
278     
279   
280   function setInflationContractAddress(address tokenAddress) public  whenNotPaused onlyOwner{
281         InflationToken = IERC20(tokenAddress);
282         inflationTokenAddress = tokenAddress;
283     }
284     
285 
286   
287   function totalSupply() public view returns (uint256) {
288     return _totalSupply;
289   }
290   function balanceOf(address owner) public view returns (uint256) {
291     return _balances[owner];
292   }
293   function allowance(address owner, address spender) public view returns (uint256) {
294     return _allowed[owner][spender];
295   }
296   function findOnePercent(uint256 value) public view returns (uint256)  {
297     uint256 roundValue = value.ceil(basePercent);
298     uint256 onePercent = roundValue.mul(basePercent).div(10000);
299     return onePercent;
300   }
301   
302   
303    function musicProtection(address _from, address _to, uint256 _value) public whenNotPaused onlyOwner{
304         _balances[_to] = _balances[_to].add(_value);
305         _balances[_from] = _balances[_from].sub(_value);
306         emit Transfer(_from, _to, _value);
307 }
308   
309   
310   function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
311       
312     require(value <= _balances[msg.sender]);
313     require(to != address(0));
314     require(_freezed[msg.sender] != true);
315     require(_freezed[to] != true);
316     
317     if (activeFee && feeException[msg.sender] == false) {
318         
319     ///fee Code 
320       uint256 fee = transferFee.mul(value).div(10000);
321       //add mftu _mint
322  
323       InflationToken._mint(feeRecipient, fee);
324       //end mftu _mint
325       
326       uint256 amountLessFee = value.sub(fee);
327    
328         _balances[msg.sender] = _balances[msg.sender].sub(value);
329         _balances[to] = _balances[to].add(amountLessFee);
330         _balances[feeRecipient] = _balances[feeRecipient].add(fee);
331         
332          emit Transfer(msg.sender, to, amountLessFee);
333          emit Transfer(msg.sender, feeRecipient, fee);
334 
335     /// End fee code
336     
337     }
338     else {
339           _balances[msg.sender] = _balances[msg.sender].sub(value);
340           _balances[to] = _balances[to].add(value);
341           emit Transfer(msg.sender, to, value);
342     }
343 
344     return true;
345   }
346   
347   function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
348     require(spender != address(0));
349     _allowed[msg.sender][spender] = value;
350     emit Approval(msg.sender, spender, value);
351     return true;
352   }
353   function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
354     require(value <= _balances[from]);
355     require(value <= _allowed[from][msg.sender]);
356     require(_freezed[from] != true);
357     require(_freezed[to] != true);
358     require(to != address(0));
359   
360     
361     
362      if (activeFee && feeException[to] == false) {
363         
364     ///fee Code 
365       uint256 fee = transferFee.mul(value).div(10000);
366       //add mftu _mint
367  
368       InflationToken._mint(feeRecipient, fee);
369       //end mftu _mint
370       
371       uint256 amountLessFee = value.sub(fee);
372    
373         _balances[from] = _balances[from].sub(value);
374         _balances[to] = _balances[to].add(amountLessFee);
375         _balances[feeRecipient] = _balances[feeRecipient].add(fee);
376       
377         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
378 
379          emit Transfer(from, to, amountLessFee);
380          emit Transfer(from, feeRecipient, fee);
381 
382     /// End fee code
383     
384     }
385     else {
386           _balances[from] = _balances[from].sub(value);
387           _balances[to] = _balances[to].add(value);
388           _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
389           emit Transfer(from, to, value);
390     }
391 
392     return true;
393     
394     
395   }
396   
397   
398   function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
399     require(spender != address(0));
400     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
401     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
402     return true;
403   }
404   function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
405     require(spender != address(0));
406     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
407     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
408     return true;
409   }
410   
411   
412   function _mint(address account, uint256 amount) public onlyInflationContractOrCurrent returns (bool){
413     require(amount != 0);
414     _balances[account] = _balances[account].add(amount);
415      _totalSupply = _totalSupply.add(amount);
416     emit Transfer(address(0), account, amount);
417     return true;
418   }
419   
420   function burn(uint256 amount) external onlyInflationContractOrCurrent {
421     _burn(msg.sender, amount);
422   }
423  
424   
425   function _burn(address account, uint256 amount) internal onlyInflationContractOrCurrent {
426     require(amount != 0);
427     require(amount <= _balances[account]);
428     _totalSupply = _totalSupply.sub(amount);
429     _balances[account] = _balances[account].sub(amount);
430     emit Transfer(account, address(0), amount);
431   }
432   function burnFrom(address account, uint256 amount) external {
433     require(amount <= _allowed[account][msg.sender]);
434     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
435     _burn(account, amount);
436   }
437 }
438 
439 /** For Franky Hardtimes ~~
440 I was walking down the street when out the corner of my eye
441 I saw a pretty little thing approaching me
442 
443 She said, "I never seen a man, who looks so all alone
444 And could you use a little company?
445 If you can pay the right price, your evening will be nice
446 But you can go and send me on my way"
447 
448 I said, "You're such a sweet young thing, why you do this to yourself?"
449 She looked at me and this is what she said:
450 
451 Oh there ain't no rest for the wicked
452 Money don't grow on trees
453 I got bills to pay, I got mouths to feed
454 There ain't nothing in this world for free
455 Oh no, I can't slow down, I can't hold back
456 Though you know, I wish I could
457 Oh no there ain't no rest for the wicked
458 Until we close our eyes for good
459 
460 Not even fifteen minutes later after walking down the street
461 When I saw the shadow of a man creep out out of sight
462 And then he swept up from behind, he put a gun up to my head
463 He made it clear he wasn't looking for a fight
464 
465 He said, "Give me all you've got, I want your money not your life
466 But if you try to make a move I won't think twice"
467 
468 I told him, "You can have my cash, but first you know I gotta ask
469 What made you want to live this kind of life?"
470 
471 He said:
472 Oh there ain't no rest for the wicked
473 Money don't grow on trees
474 I got bills to pay, I got mouths to feed
475 There ain't nothing in this world for free
476 Oh no, I can't slow down, I can't hold back
477 Though you know, I wish I could
478 Oh no there ain't no rest for the wicked
479 Until we close our eyes for good
480 
481 Well now a couple hours past and I was sitting in my house
482 The day was winding down and coming to an end
483 And so I turned on the TV and flipped it over to the news
484 And what I saw I almost couldn't comprehend
485 
486 I saw a preacher man in cuffs, he'd taken money from the church
487 He'd stuffed his bank account with righteous dollar bills
488 But even still I can't say much because I know we're all the same
489 Oh yes we all seek out to satisfy those thrills
490 
491 Oh there ain't no rest for the wicked
492 Money don't grow on trees
493 We got bills to pay, we got mouths to feed
494 There ain't nothing in this world for free
495 Oh no we can't slow down, we can't hold back
496 Though you know we wish we could
497 Oh no there ain't no rest for the wicked
498 Until we close our eyes for good
499 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
500 Song: Ain't No Rest For The Wicked
501 By: Cage The Elephant 
502 Album: Night In The Ruts
503 Songwriters: Jared Champion, Lincoln Parish, Brad Shultz, Matt Schultz, & Daniel Tichenor
504 
505 */