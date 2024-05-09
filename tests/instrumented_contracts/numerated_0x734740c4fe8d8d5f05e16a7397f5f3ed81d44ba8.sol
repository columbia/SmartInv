1 pragma solidity ^0.4.17;
2 
3 library SafeMath {
4 
5   function mul(uint a, uint b) internal pure returns (uint) {
6     uint c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10 
11   function div(uint a, uint b) internal pure returns (uint) {
12     uint c = a / b;
13     return c;
14   }
15 
16   function sub(uint a, uint b) internal pure returns (uint) {
17     assert(b <= a);
18     return a - b;
19   }
20 
21   function add(uint a, uint b) internal pure returns (uint) {
22     uint c = a + b;
23     assert(c >= a);
24     return c;
25   }
26 }
27 
28 
29 contract Ownable {
30     
31     address public owner;
32 
33     event OwnershipTransferred(address from, address to);
34 
35     /**
36      * The address whcih deploys this contrcat is automatically assgined ownership.
37      * */
38     function Ownable() public {
39         owner = msg.sender;
40     }
41 
42     /**
43      * Functions with this modifier can only be executed by the owner of the contract. 
44      * */
45     modifier onlyOwner {
46         require(msg.sender == owner);
47         _;
48     }
49 
50     /**
51      * Transfers ownership provided that a valid address is given. This function can 
52      * only be called by the owner of the contract. 
53      */
54     function transferOwnership(address _newOwner) public onlyOwner {
55         require(_newOwner != 0x0);
56         OwnershipTransferred(owner, _newOwner);
57         owner = _newOwner;
58     }
59 
60 }
61 
62 
63 contract ERC20Basic {
64   uint public totalSupply;
65   function balanceOf(address who) public constant returns (uint);
66   function transfer(address to, uint value) public;
67   event Transfer(address indexed from, address indexed to, uint value);
68 }
69 
70 
71 contract ERC20 is ERC20Basic {
72   function allowance(address owner, address spender) public constant returns (uint);
73   function transferFrom(address from, address to, uint value) public;
74   function approve(address spender, uint value) public;
75   event Approval(address indexed owner, address indexed spender, uint value);
76 }
77 
78 
79 contract BasicToken is ERC20Basic, Ownable {
80   using SafeMath for uint;
81 
82   mapping(address => uint) balances;
83 
84   modifier onlyPayloadSize(uint size) {
85      if (msg.data.length < size + 4) {
86        revert();
87      }
88      _;
89   }
90 
91   /**
92   * @dev transfer token for a specified address
93   * @param _to The address to transfer to.
94   * @param _value The amount to be transferred.
95   */
96   function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) {
97     balances[msg.sender] = balances[msg.sender].sub(_value);
98     balances[_to] = balances[_to].add(_value);
99     Transfer(msg.sender, _to, _value);
100   }
101 
102   /**
103   * @dev Gets the balance of the specified address.
104   * @param _owner The address to query the the balance of. 
105   * @return An uint representing the amount owned by the passed address.
106   */
107   function balanceOf(address _owner) public constant returns (uint balance) {
108     return balances[_owner];
109   }
110 
111 }
112 
113 
114 contract StandardToken is BasicToken, ERC20 {
115 
116     mapping (address => mapping (address => uint256)) allowances;
117 
118     /**
119      * Transfers tokens from the account of the owner by an approved spender. 
120      * The spender cannot spend more than the approved amount. 
121      * 
122      * @param _from The address of the owners account.
123      * @param _amount The amount of tokens to transfer.
124      * */
125     function transferFrom(address _from, address _to, uint256 _amount) public onlyPayloadSize(3 * 32) {
126         require(allowances[_from][msg.sender] >= _amount && balances[_from] >= _amount);
127         allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_amount);
128         balances[_from] = balances[_from].sub(_amount);
129         balances[_to] = balances[_to].add(_amount);
130         Transfer(_from, _to, _amount);
131     }
132 
133     /**
134      * Allows another account to spend a given amount of tokens on behalf of the 
135      * owner's account. If the owner has previously allowed a spender to spend
136      * tokens on his or her behalf and would like to change the approval amount,
137      * he or she will first have to set the allowance back to 0 and then update
138      * the allowance.
139      * 
140      * @param _spender The address of the spenders account.
141      * @param _amount The amount of tokens the spender is allowed to spend.
142      * */
143     function approve(address _spender, uint256 _amount) public {
144         require((_amount == 0) || (allowances[msg.sender][_spender] == 0));
145         allowances[msg.sender][_spender] = _amount;
146         Approval(msg.sender, _spender, _amount);
147     }
148 
149 
150     /**
151      * Returns the approved allowance from an owners account to a spenders account.
152      * 
153      * @param _owner The address of the owners account.
154      * @param _spender The address of the spenders account.
155      **/
156     function allowance(address _owner, address _spender) public constant returns (uint256) {
157         return allowances[_owner][_spender];
158     }
159 
160 }
161 
162 
163 contract MintableToken is StandardToken {
164   event Mint(address indexed to, uint256 amount);
165   event MintFinished();
166 
167   bool public mintingFinished = false;
168 
169 
170   modifier canMint() {
171     require(!mintingFinished);
172     _;
173   }
174 
175   /**
176    * Mints a given amount of tokens to the provided address. This function can only be called by the contract's
177    * owner, which in this case is the ICO contract itself. From there, the founders of the ICO contract will be
178    * able to invoke this function. 
179    *
180    * @param _to The address which will receive the tokens.
181    * @param _amount The total amount of ETCL tokens to be minted.
182    */
183   function mint(address _to, uint256 _amount) public onlyOwner canMint onlyPayloadSize(2 * 32) returns (bool) {
184     totalSupply = totalSupply.add(_amount);
185     balances[_to] = balances[_to].add(_amount);
186     Mint(_to, _amount);
187     Transfer(0x0, _to, _amount);
188     return true;
189   }
190 
191   /**
192    * Terminates the minting period permanently. This function can only be called by the owner of the contract.
193    */
194   function finishMinting() public onlyOwner returns (bool) {
195     mintingFinished = true;
196     MintFinished();
197     return true;
198   }
199 
200 }
201 
202 
203 contract Ethercloud is MintableToken {
204     
205     uint8 public decimals;
206     string public name;
207     string public symbol;
208 
209     function Ethercloud() public {
210        totalSupply = 0;
211        decimals = 18;
212        name = "Ethercloud";
213        symbol = "ETCL";
214     }
215 }
216 
217 
218 contract ICO is Ownable {
219 
220     using SafeMath for uint256;
221 
222     Ethercloud public ETCL;
223 
224     bool       public success;
225     uint256    public rate;
226     uint256    public rateWithBonus;
227     uint256    public bountiesIssued;
228     uint256    public tokensSold;
229     uint256    public tokensForSale;
230     uint256    public tokensForBounty;
231     uint256    public maxTokens;
232     uint256    public startTime;
233     uint256    public endTime;
234     uint256    public softCap;
235     uint256    public hardCap;
236     uint256[3] public bonusStages;
237 
238     mapping (address => uint256) investments;
239 
240     event TokensPurchased(address indexed by, uint256 amount);
241     event RefundIssued(address indexed by, uint256 amount);
242     event FundsWithdrawn(address indexed by, uint256 amount);
243     event BountyIssued(address indexed to, uint256 amount);
244     event IcoSuccess();
245     event CapReached();
246 
247     function ICO() public {
248         ETCL = new Ethercloud();
249         success = false;
250         rate = 1288; 
251         rateWithBonus = 1674;
252         bountiesIssued = 0;
253         tokensSold = 0;
254         tokensForSale = 78e24;              //78 million ETCL for sale
255         tokensForBounty = 2e24;             //2 million ETCL for bounty
256         maxTokens = 100e24;                 //100 million ETCL
257         startTime = now.add(15 days);       //ICO starts 15 days after deployment
258         endTime = startTime.add(30 days);   //30 days end time
259         softCap = 6212530674370205e6;       //6212.530674370205 ETH
260         hardCap = 46594980057776535e6;      //46594.980057776535 ETH
261 
262         bonusStages[0] = startTime.add(7 days);
263 
264         for (uint i = 1; i < bonusStages.length; i++) {
265             bonusStages[i] = bonusStages[i - 1].add(7 days);
266         }
267     }
268 
269     /**
270      * When ETH is sent to the contract, the fallback function calls the buy tokens function.
271      */
272     function() public payable {
273         buyTokens(msg.sender);
274     }
275 
276     /**
277      * Allows investors to buy ETCL tokens by sending ETH and automatically receiving tokens
278      * to the provided address.
279      *
280      * @param _beneficiary The address which will receive the tokens. 
281      */
282     function buyTokens(address _beneficiary) public payable {
283         require(_beneficiary != 0x0 && validPurchase() && this.balance.sub(msg.value) < hardCap);
284         if (this.balance >= softCap && !success) {
285             success = true;
286             IcoSuccess();
287         }
288         uint256 weiAmount = msg.value;
289         if (this.balance > hardCap) {
290             CapReached();
291             uint256 toRefund = this.balance.sub(hardCap);
292             msg.sender.transfer(toRefund);
293             weiAmount = weiAmount.sub(toRefund);
294         }
295         uint256 tokens = weiAmount.mul(getCurrentRateWithBonus());
296         if (tokensSold.add(tokens) > tokensForSale) {
297             revert();
298         }
299         ETCL.mint(_beneficiary, tokens);
300         tokensSold = tokensSold.add(tokens);
301         investments[_beneficiary] = investments[_beneficiary].add(weiAmount);
302         TokensPurchased(_beneficiary, tokens);
303     }
304 
305     /**
306      * Returns the current rate with bonus percentage of the tokens. 
307      */
308     function getCurrentRateWithBonus() internal returns (uint256) {
309         rateWithBonus = (rate.mul(getBonusPercentage()).div(100)).add(rate);
310         return rateWithBonus;
311     }
312 
313     /**
314      * Returns the current bonus percentage. 
315      */
316     function getBonusPercentage() internal view returns (uint256 bonusPercentage) {
317         uint256 timeStamp = now;
318         if (timeStamp > bonusStages[2]) {
319             bonusPercentage = 0; 
320         }
321         if (timeStamp <= bonusStages[2]) {
322             bonusPercentage = 5;
323         }
324         if (timeStamp <= bonusStages[1]) {
325             bonusPercentage = 15;
326         }
327         if (timeStamp <= bonusStages[0]) {
328             bonusPercentage = 30;
329         } 
330         return bonusPercentage;
331     }
332 
333     /**
334      * Mints a given amount of new tokens to the provided address. This function can only be
335      * called by the owner of the contract.
336      *
337      * @param _beneficiary The address which will receive the tokens.
338      * @param _amount The total amount of tokens to be minted.
339      */
340     function issueTokens(address _beneficiary, uint256 _amount) public onlyOwner {
341         require(_beneficiary != 0x0 && _amount > 0 && tokensSold.add(_amount) <= tokensForSale); 
342         ETCL.mint(_beneficiary, _amount);
343         tokensSold = tokensSold.add(_amount);
344         TokensPurchased(_beneficiary, _amount);
345     }
346 
347     /**
348      * Checks whether or not a purchase is valid. If not, then the buy tokens function will 
349      * not execute.
350      */
351     function validPurchase() internal constant returns (bool) {
352         bool withinPeriod = now >= startTime && now <= endTime;
353         bool nonZeroPurchase = msg.value != 0;
354         return withinPeriod && nonZeroPurchase;
355     }
356 
357     /**
358      * Allows investors to claim refund in the case that the soft cap has not been reached and
359      * the duration of the ICO has passed. 
360      *
361      * @param _addr The address to be refunded. If no address is provided, the _addr will default
362      * to the message sender. 
363      */
364     function getRefund(address _addr) public {
365         if (_addr == 0x0) {
366             _addr = msg.sender;
367         }
368         require(!isSuccess() && hasEnded() && investments[_addr] > 0);
369         uint256 toRefund = investments[_addr];
370         investments[_addr] = 0;
371         _addr.transfer(toRefund);
372         RefundIssued(_addr, toRefund);
373     }
374 
375     /**
376      * Mints new tokens for the bounty campaign. This function can only be called by the owner 
377      * of the contract. 
378      *
379      * @param _beneficiary The address which will receive the tokens. 
380      * @param _amount The total amount of tokens that will be minted. 
381      */
382     function issueBounty(address _beneficiary, uint256 _amount) public onlyOwner {
383         require(bountiesIssued.add(_amount) <= tokensForBounty && _beneficiary != 0x0);
384         ETCL.mint(_beneficiary, _amount);
385         bountiesIssued = bountiesIssued.add(_amount);
386         BountyIssued(_beneficiary, _amount);
387     }
388 
389     /**
390      * Withdraws the total amount of ETH raised to the owners address. This function can only be
391      * called by the owner of the contract given that the ICO is a success and the duration has 
392      * passed.
393      */
394     function withdraw() public onlyOwner {
395         uint256 inCirculation = tokensSold.add(bountiesIssued);
396         ETCL.mint(owner, inCirculation.mul(25).div(100));
397         owner.transfer(this.balance);
398     }
399 
400     /**
401      * Returns true if the ICO is a success, false otherwise.
402      */
403     function isSuccess() public constant returns (bool) {
404         return success;
405     }
406 
407     /**
408      * Returns true if the duration of the ICO has passed, false otherwise. 
409      */
410     function hasEnded() public constant returns (bool) {
411         return now > endTime;
412     }
413 
414     /**
415      * Returns the end time of the ICO.
416      */
417     function endTime() public constant returns (uint256) {
418         return endTime;
419     }
420 
421     /**
422      * Returns the total investment of a given ETH address. 
423      *
424      * @param _addr The address being queried.
425      */
426     function investmentOf(address _addr) public constant returns (uint256) {
427         return investments[_addr];
428     }
429 
430     /**
431      * Finishes the minting period. This function can only be called by the owner of the 
432      * contract given that the duration of the ICO has ended. 
433      */
434     function finishMinting() public onlyOwner {
435         require(hasEnded());
436         ETCL.finishMinting();
437     }
438 }