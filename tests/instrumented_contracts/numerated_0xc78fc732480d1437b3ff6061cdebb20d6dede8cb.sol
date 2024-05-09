1 // File: contracts/SafeMath.sol
2 
3 pragma solidity ^0.5.0;
4 
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     uint256 c = a * b;
13     assert(a == 0 || c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 // File: contracts/Ownable.sol
37 
38 pragma solidity ^0.5.0;
39 
40 
41 /**
42  * @title Ownable
43  * @dev The Ownable contract has an owner address, and provides basic authorization control
44  * functions, this simplifies the implementation of "user permissions".
45  */
46 contract Ownable {
47   address public owner;
48 
49 
50   /**
51    * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
52    */
53   constructor () public {
54     owner = msg.sender;
55   }
56 
57   /**
58    * @dev Throws if called by any account other than the owner.
59    */
60   modifier onlyOwner() {
61     require(msg.sender == owner);
62     _;
63   }
64 
65   /**
66    * @dev Allows the current owner to transfer control of the contract to a newOwner.
67    * @param newOwner The address to transfer ownership to.
68    */
69   function transferOwnership(address newOwner) public onlyOwner {
70     if (newOwner != address(0)) {
71       owner = newOwner;
72     }
73   }
74 
75 }
76 
77 // File: contracts/Pausable.sol
78 
79 pragma solidity ^0.5.0;
80 
81 
82 
83 /**
84  * @title Pausable
85  * @dev Base contract which allows children to implement an emergency stop mechanism.
86  */
87 contract Pausable is Ownable {
88   event Pause();
89   event Unpause();
90 
91   bool public paused = false;
92 
93   constructor() public {}
94 
95   /**
96    * @dev modifier to allow actions only when the contract IS paused
97    */
98   modifier whenNotPaused() {
99     require(!paused);
100     _;
101   }
102 
103   /**
104    * @dev modifier to allow actions only when the contract IS NOT paused
105    */
106   modifier whenPaused {
107     require(paused);
108     _;
109   }
110 
111   /**
112    * @dev called by the owner to pause, triggers stopped state
113    */
114   function pause() public onlyOwner whenNotPaused returns (bool) {
115     paused = true;
116     emit Pause();
117     return true;
118   }
119 
120   /**
121    * @dev called by the owner to unpause, returns to normal state
122    */
123   function unpause() public onlyOwner whenPaused returns (bool) {
124     paused = false;
125     emit Unpause();
126     return true;
127   }
128 }
129 
130 // File: contracts/Controllable.sol
131 
132 pragma solidity ^0.5.0;
133 
134 
135 /**
136  * @title Controllable
137  * @dev The Controllable contract has an controller address, and provides basic authorization control
138  * functions, this simplifies the implementation of "user permissions".
139  */
140 contract Controllable {
141   address public controller;
142 
143 
144   /**
145    * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
146    */
147   constructor() public {
148     controller = msg.sender;
149   }
150 
151   /**
152    * @dev Throws if called by any account other than the owner.
153    */
154   modifier onlyController() {
155     require(msg.sender == controller);
156     _;
157   }
158 
159   /**
160    * @dev Allows the current owner to transfer control of the contract to a newOwner.
161    * @param newController The address to transfer ownership to.
162    */
163   function transferControl(address newController) public onlyController {
164     if (newController != address(0)) {
165       controller = newController;
166     }
167   }
168 
169 }
170 
171 // File: contracts/TokenInterface.sol
172 
173 pragma solidity ^0.5.0;
174 
175 
176 /**
177  * @title Token (WIRA)
178  * Standard Mintable ERC20 Token
179  * https://github.com/ethereum/EIPs/issues/20
180  * Based on code by FirstBlood:
181  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
182  */
183 contract TokenInterface is Controllable {
184 
185   event Mint(address indexed to, uint256 amount);
186   event MintFinished();
187   event ClaimedTokens(address indexed _token, address indexed _owner, uint _amount);
188   event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
189   event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
190   event Transfer(address indexed from, address indexed to, uint256 value);
191 
192   function totalSupply() public view returns (uint);
193   function totalSupplyAt(uint _blockNumber) public view returns(uint);
194   function balanceOf(address _owner) public view returns (uint256 balance);
195   function balanceOfAt(address _owner, uint _blockNumber) public view returns (uint);
196   function transfer(address _to, uint256 _amount) public returns (bool success);
197   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);
198   function approve(address _spender, uint256 _amount) public returns (bool success);
199   function allowance(address _owner, address _spender) public view returns (uint256 remaining);
200   function mint(address _owner, uint _amount) public returns (bool);
201   function enableTransfers() public returns (bool);
202   function finishMinting() public returns (bool);
203 }
204 
205 // File: contracts/WiraTokenSale.sol
206 
207 pragma solidity ^0.5.0;
208 
209 
210 
211 /**
212  * @title WiraTokenSale
213  * Tokensale allows investors to make token purchases and assigns them tokens based
214 
215  * on a token per ETH rate. Funds collected are forwarded to a wallet as they arrive.
216  */
217  contract WiraTokenSale is Pausable {
218    using SafeMath for uint256;
219 
220    TokenInterface public token;
221    uint256 public totalWeiRaised;
222    uint256 public tokensMinted;
223    uint256 public contributors;
224 
225    bool public teamTokensMinted = false;
226    bool public finalized = false;
227 
228    address payable tokenSaleWalletAddress;
229    address public tokenWalletAddress;
230    uint256 public constant FIRST_ROUND_CAP = 20000000 * 10 ** 18;
231    uint256 public constant SECOND_ROUND_CAP = 70000000 * 10 ** 18;
232    uint256 public constant TOKENSALE_CAP = 122500000 * 10 ** 18;
233    uint256 public constant TOTAL_CAP = 408333334 * 10 ** 18;
234    uint256 public constant TEAM_TOKENS = 285833334 * 10 ** 18; //TOTAL_CAP - TOKENSALE_CAP
235 
236    uint256 public conversionRateInCents = 15000; // 1ETH = 15000 cents by default - can be updated
237    uint256 public firstRoundStartDate;
238    uint256 public firstRoundEndDate;
239    uint256 public secondRoundStartDate;
240    uint256 public secondRoundEndDate;
241    uint256 public thirdRoundStartDate;
242    uint256 public thirdRoundEndDate;
243 
244    event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
245    event Finalized();
246 
247    constructor(
248      address _tokenAddress,
249      uint256 _startDate,
250      address _tokenSaleWalletAddress,
251      address _tokenWalletAddress
252    ) public {
253      require(_tokenAddress != address(0));
254 
255       token = TokenInterface(_tokenAddress);
256 
257       //Hardcoded to conform to the current tokensale plan with firstRoundStartDate = _startDate = 1556668800
258       //firstRoundStartDate = 1556668800;  //1st May 2019 @ 00:00 GMT
259       //firstRoundEndDate = 1557187200; // 7th May 2019 @ 00:00 GMT
260       //secondRoundStartDate = 1557273600; // 8th May 2019 @ 00:00 GMT
261       //secondRoundEndDate = 1557792000; // 14th May 2019 @ 00:00 GMT
262       //thirdRoundStartDate = 1557878400; // 15th May 2019 @ 00:00 GMT
263       //thirdRoundEndDate = 1561939200; // 1st July 2019 @ 00:00 GMT
264       firstRoundStartDate = _startDate;
265       firstRoundEndDate = _startDate + 518400;
266       secondRoundStartDate = _startDate + 604800;
267       secondRoundEndDate = _startDate + 1123200;
268       thirdRoundStartDate = _startDate + 1209600;
269       thirdRoundEndDate = _startDate + 5270400;
270 
271       tokenSaleWalletAddress = address(uint160(_tokenSaleWalletAddress));
272       tokenWalletAddress = _tokenWalletAddress;
273    }
274 
275    /**
276     * High level token purchase function
277     */
278    function() external payable {
279      buyTokens(msg.sender);
280    }
281 
282 
283    /**
284     * Mint team tokens
285     */
286    function mintTeamTokens() public onlyOwner {
287      require(!teamTokensMinted);
288      token.mint(tokenWalletAddress, TEAM_TOKENS);
289      teamTokensMinted = true;
290    }
291 
292    /**
293     * Low level token purchase function
294     * @param _beneficiary will receive the tokens.
295     */
296    function buyTokens(address _beneficiary) public payable whenNotPaused whenNotFinalized {
297      require(_beneficiary != address(0));
298      validatePurchase();
299 
300      uint256 current = now;
301      uint256 tokens;
302 
303      totalWeiRaised = totalWeiRaised.add(msg.value);
304 
305      if (now >= firstRoundStartDate && now <= firstRoundEndDate) {
306       tokens = (msg.value * conversionRateInCents) / 10;
307      } else if (now >= secondRoundStartDate && now <= secondRoundEndDate) {
308        tokens = (msg.value * conversionRateInCents) / 15;
309      } else if (now >= thirdRoundStartDate && now <= thirdRoundEndDate) {
310        tokens = (msg.value * conversionRateInCents) / 20;
311      }
312 
313     contributors = contributors.add(1);
314     tokensMinted = tokensMinted.add(tokens);
315 
316     /*
317     *@info: msg.value can stay in Wei as long as decimals for the tokens are the same as Ethereum (18 decimals)
318     */
319     bool earlyBirdSale = (current >= firstRoundStartDate && current <= firstRoundEndDate);
320     bool prelaunchSale = (current >= secondRoundStartDate && current <= secondRoundEndDate);
321     bool mainSale = (current >= thirdRoundStartDate && current <= thirdRoundEndDate);
322 
323     if (earlyBirdSale) require(tokensMinted < FIRST_ROUND_CAP);
324     if (prelaunchSale) require(tokensMinted < SECOND_ROUND_CAP);
325     if (mainSale) require(tokensMinted < TOKENSALE_CAP);
326 
327     token.mint(_beneficiary, tokens);
328     emit TokenPurchase(msg.sender, _beneficiary, msg.value, tokens);
329     forwardFunds();
330    }
331 
332    function updateConversionRate(uint256 _conversionRateInCents) onlyOwner public {
333      conversionRateInCents = _conversionRateInCents;
334    }
335 
336    /**
337    * Forwards funds to the tokensale wallet
338    */
339    function forwardFunds() internal {
340      address(tokenSaleWalletAddress).transfer(msg.value);
341    }
342 
343    function currentDate() public view returns (uint256) {
344      return now;
345    }
346 
347    /**
348    * Validates the purchase (period, minimum amount, within cap)
349    * @return {bool} valid
350    */
351    function validatePurchase() internal returns (bool) {
352      uint256 current = now;
353      bool duringFirstRound = (current >= firstRoundStartDate && current <= firstRoundEndDate);
354      bool duringSecondRound = (current >= secondRoundStartDate && current <= secondRoundEndDate);
355      bool duringThirdRound = (current >= thirdRoundStartDate && current <= thirdRoundEndDate);
356      bool nonZeroPurchase = msg.value != 0;
357 
358      require(duringFirstRound || duringSecondRound || duringThirdRound);
359      require(nonZeroPurchase);
360    }
361 
362    /**
363    * Returns the total WIRA token supply
364    * @return totalSupply {uint256} WIRA Token Total Supply
365    */
366    function totalSupply() public view returns (uint256) {
367      return token.totalSupply();
368    }
369 
370    /**
371    * Returns token holder WIRA Token balance
372    * @param _owner {address} Token holder address
373    * @return balance {uint256} Corresponding token holder balance
374    */
375    function balanceOf(address _owner) public view returns (uint256) {
376      return token.balanceOf(_owner);
377    }
378 
379    /**
380    * Change the WIRA Token controller
381    * @param _newController {address} New WIRA Token controller
382    */
383    function changeController(address _newController) public onlyOwner {
384      require(isContract(_newController));
385      token.transferControl(_newController);
386    }
387 
388    function finalize() public onlyOwner {
389      require(paused);
390      emit Finalized();
391 
392     uint256 remainingTokens = TOKENSALE_CAP - tokensMinted;
393     token.mint(tokenWalletAddress, remainingTokens);
394 
395      finalized = true;
396    }
397 
398    function enableTransfers() public onlyOwner {
399      token.enableTransfers();
400    }
401 
402 
403    function isContract(address _addr) view internal returns(bool) {
404      uint size;
405      if (_addr == address(0))
406        return false;
407      assembly {
408          size := extcodesize(_addr)
409      }
410      return size>0;
411    }
412 
413    modifier whenNotFinalized() {
414      require(!finalized);
415      _;
416    }
417 
418  }