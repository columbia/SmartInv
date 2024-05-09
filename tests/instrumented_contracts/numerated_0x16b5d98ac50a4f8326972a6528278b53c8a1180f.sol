1 pragma solidity ^0.4.13;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   function Ownable() public {
15     owner = msg.sender;
16   }
17 
18 
19   /**
20    * @dev Throws if called by any account other than the owner.
21    */
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26 
27 
28   /**
29    * @dev Allows the current owner to transfer control of the contract to a newOwner.
30    * @param newOwner The address to transfer ownership to.
31    */
32   function transferOwnership(address newOwner) public onlyOwner {
33     require(newOwner != address(0));
34     OwnershipTransferred(owner, newOwner);
35     owner = newOwner;
36   }
37 
38 }
39 
40 contract PausableToken is Ownable {
41     function balanceOf(address who) public constant returns (uint256);
42     function transfer(address to, uint256 value) public returns (bool);
43     function increaseFrozen(address _owner,uint256 _incrementalAmount) public returns (bool);
44     function burn(uint256 _value) public;
45 }
46 
47 contract AddressWhitelist is Ownable {
48     // the addresses that are included in the whitelist
49     mapping (address => bool) whitelisted;
50     
51     function isWhitelisted(address addr) view public returns (bool) {
52         return whitelisted[addr];
53     }
54 
55     event LogWhitelistAdd(address indexed addr);
56 
57     // add these addresses to the whitelist
58     function addToWhitelist(address[] addresses) public onlyOwner returns (bool) {
59         for (uint i = 0; i < addresses.length; i++) {
60             if (!whitelisted[addresses[i]]) {
61                 whitelisted[addresses[i]] = true;
62                 LogWhitelistAdd(addresses[i]);
63             }
64         }
65 
66         return true;
67     }
68 
69     event LogWhitelistRemove(address indexed addr);
70 
71     // remove these addresses from the whitelist
72     function removeFromWhitelist(address[] addresses) public onlyOwner returns (bool) {
73         for (uint i = 0; i < addresses.length; i++) {
74             if (whitelisted[addresses[i]]) {
75                 whitelisted[addresses[i]] = false;
76                 LogWhitelistRemove(addresses[i]);
77             }
78         }
79 
80         return true;
81     }
82 }
83 
84 contract HorseTokenCrowdsale is Ownable, AddressWhitelist {
85     using SafeMath for uint256;
86     PausableToken  public tokenReward;                         // address of the token used as reward
87 
88     // deployment variables for static supply sale
89     uint256 public initialSupply;
90     uint256 public tokensRemaining;
91     uint256 public decimals;
92 
93     // multi-sig addresses and price variable
94     address public beneficiaryWallet;                           // beneficiaryMultiSig (founder group) or wallet account
95     uint256 public tokensPerEthPrice;                           // set initial value floating priceVar 10,000 tokens per Eth
96 
97     // uint256 values for min,max,caps,tracking
98     uint256 public amountRaisedInWei;
99     uint256 public fundingMinCapInWei;
100 
101     // pricing veriable
102     uint256 public p1_duration;
103     uint256 public p2_start;
104     uint256 public p1_white_duration;
105 
106     // loop control, ICO startup and limiters
107     uint256 public fundingStartTime;                           // crowdsale start time#
108     uint256 public fundingEndTime;                             // crowdsale end time#
109     bool    public isCrowdSaleClosed               = false;     // crowdsale completion boolean
110     bool    public areFundsReleasedToBeneficiary   = false;     // boolean for founder to receive Eth or not
111     bool    public isCrowdSaleSetup                = false;     // boolean for crowdsale setup
112 
113     // Gas price limit
114     uint256 maxGasPrice = 50000000000;
115 
116     event Buy(address indexed _sender, uint256 _eth, uint256 _HORSE);
117     event Refund(address indexed _refunder, uint256 _value);
118     mapping(address => uint256) fundValue;
119 
120 
121     // convert tokens to decimals
122     function toPony(uint256 amount) public constant returns (uint256) {
123         return amount.mul(10**decimals);
124     }
125 
126     // convert tokens to whole
127     function toHorse(uint256 amount) public constant returns (uint256) {
128         return amount.div(10**decimals);
129     }
130 
131     function updateMaxGasPrice(uint256 _newGasPrice) public onlyOwner {
132         require(_newGasPrice != 0);
133         maxGasPrice = _newGasPrice;
134     }
135 
136     // setup the CrowdSale parameters
137     function setupCrowdsale(uint256 _fundingStartTime) external onlyOwner {
138         if ((!(isCrowdSaleSetup))
139             && (!(beneficiaryWallet > 0))){
140             // init addresses
141             tokenReward                             = PausableToken(0x5B0751713b2527d7f002c0c4e2a37e1219610A6B);
142             beneficiaryWallet                       = 0xEb0B40a8bE19160Ca63076aE67357B1a10c8C31A;
143             tokensPerEthPrice                       = 12500;
144 
145             // funding targets
146             fundingMinCapInWei                      = 400 ether;                          //400 Eth (min cap) - crowdsale is considered success after this value
147 
148             // update values
149             decimals                                = 18;
150             amountRaisedInWei                       = 0;
151             initialSupply                           = toPony(100000000);                  //   100 million * 18 decimal
152             tokensRemaining                         = initialSupply;
153 
154             fundingStartTime                        = _fundingStartTime;
155             p1_duration                             = 7 days;
156             p1_white_duration                       = 1 days;
157             
158             p2_start                                = fundingStartTime + p1_duration + 6 days;
159 
160             fundingEndTime                          = p2_start + 4 weeks;
161 
162             // configure crowdsale
163             isCrowdSaleSetup                        = true;
164             isCrowdSaleClosed                       = false;
165         }
166     }
167 
168     function setBonusPrice() public constant returns (uint256 bonus) {
169         require(isCrowdSaleSetup);
170         require(fundingStartTime + p1_duration <= p2_start );
171         if (now >= fundingStartTime && now <= fundingStartTime + p1_duration) { // Phase-1 Bonus    +100% = 25,000 HORSE  = 1 ETH
172             bonus = 12500;
173         } else if (now > p2_start && now <= p2_start + 1 days ) { // Phase-2 day-1 Bonus +50% = 18,750 HORSE = 1 ETH
174             bonus = 6250;
175         } else if (now > p2_start + 1 days && now <= p2_start + 1 weeks ) { // Phase-2 week-1 Bonus +20% = 15,000 HORSE = 1 ETH
176             bonus = 2500;
177         } else if (now > p2_start + 1 weeks && now <= p2_start + 2 weeks ) { // Phase-2 week-2 Bonus +10% = 13,750 HORSE = 1 ETH
178             bonus = 1250;
179         } else if (now > p2_start + 2 weeks && now <= fundingEndTime ) { // Phase-2 week-3& week-4 Bonus +0% = 12,500 HORSE = 1 ETH
180             bonus = 0;
181         } else {
182             revert();
183         }
184     }
185 
186     // p1_duration constant. Only p2 start changes. p2 start cannot be greater than 1 month from p1 end
187     function updateDuration(uint256 _newP2Start) external onlyOwner { // function to update the duration of phase-1 and adjust the start time of phase-2
188         require( isCrowdSaleSetup
189             && !(p2_start == _newP2Start)
190             && !(_newP2Start > fundingStartTime + p1_duration + 30 days)
191             && (now < p2_start)
192             && (fundingStartTime + p1_duration < _newP2Start));
193         p2_start = _newP2Start;
194         fundingEndTime = p2_start.add(4 weeks);
195     }
196 
197     // default payable function when sending ether to this contract
198     function () external payable {
199         require(tx.gasprice <= maxGasPrice);
200         require(msg.data.length == 0);
201         
202         BuyHORSEtokens();
203     }
204 
205     function BuyHORSEtokens() public payable {
206         // conditions (length, crowdsale setup, zero check, exceed funding contrib check, contract valid check, within funding block range check, balance overflow check etc)
207         require(!(msg.value == 0)
208         && (isCrowdSaleSetup)
209         && (now >= fundingStartTime)
210         && (now <= fundingEndTime)
211         && (tokensRemaining > 0));
212 
213         // only whitelisted addresses are allowed during the first day of phase 1
214         if (now <= fundingStartTime + p1_white_duration) {
215             assert(isWhitelisted(msg.sender));
216         }
217         uint256 rewardTransferAmount        = 0;
218         uint256 rewardBaseTransferAmount    = 0;
219         uint256 rewardBonusTransferAmount   = 0;
220         uint256 contributionInWei           = msg.value;
221         uint256 refundInWei                 = 0;
222 
223         rewardBonusTransferAmount       = setBonusPrice();
224         rewardBaseTransferAmount        = (msg.value.mul(tokensPerEthPrice)); // Since both ether and HORSE have 18 decimals, No need of conversion
225         rewardBonusTransferAmount       = (msg.value.mul(rewardBonusTransferAmount)); // Since both ether and HORSE have 18 decimals, No need of conversion
226         rewardTransferAmount            = rewardBaseTransferAmount.add(rewardBonusTransferAmount);
227 
228         if (rewardTransferAmount > tokensRemaining) {
229             uint256 partialPercentage;
230             partialPercentage = tokensRemaining.mul(10**18).div(rewardTransferAmount);
231             contributionInWei = contributionInWei.mul(partialPercentage).div(10**18);
232             rewardBonusTransferAmount = rewardBonusTransferAmount.mul(partialPercentage).div(10**18);
233             rewardTransferAmount = tokensRemaining;
234             refundInWei = msg.value.sub(contributionInWei);
235         }
236 
237         amountRaisedInWei               = amountRaisedInWei.add(contributionInWei);
238         tokensRemaining                 = tokensRemaining.sub(rewardTransferAmount);  // will cause throw if attempt to purchase over the token limit in one tx or at all once limit reached
239         fundValue[msg.sender]           = fundValue[msg.sender].add(contributionInWei);
240         assert(tokenReward.increaseFrozen(msg.sender, rewardBonusTransferAmount));
241         tokenReward.transfer(msg.sender, rewardTransferAmount);
242         Buy(msg.sender, contributionInWei, rewardTransferAmount);
243         if (refundInWei > 0) {
244             msg.sender.transfer(refundInWei);
245         }
246     }
247 
248     function beneficiaryMultiSigWithdraw() external onlyOwner {
249         checkGoalReached();
250         require(areFundsReleasedToBeneficiary && (amountRaisedInWei >= fundingMinCapInWei));
251         beneficiaryWallet.transfer(this.balance);
252     }
253 
254     function checkGoalReached() public returns (bytes32 response) { // return crowdfund status to owner for each result case, update public constant
255         // update state & status variables
256         require (isCrowdSaleSetup);
257         if ((amountRaisedInWei < fundingMinCapInWei) && (block.timestamp <= fundingEndTime && block.timestamp >= fundingStartTime)) { // ICO in progress, under softcap
258             areFundsReleasedToBeneficiary = false;
259             isCrowdSaleClosed = false;
260             return "In progress (Eth < Softcap)";
261         } else if ((amountRaisedInWei < fundingMinCapInWei) && (block.timestamp < fundingStartTime)) { // ICO has not started
262             areFundsReleasedToBeneficiary = false;
263             isCrowdSaleClosed = false;
264             return "Crowdsale is setup";
265         } else if ((amountRaisedInWei < fundingMinCapInWei) && (block.timestamp > fundingEndTime)) { // ICO ended, under softcap
266             areFundsReleasedToBeneficiary = false;
267             isCrowdSaleClosed = true;
268             return "Unsuccessful (Eth < Softcap)";
269         } else if ((amountRaisedInWei >= fundingMinCapInWei) && (tokensRemaining == 0)) { // ICO ended, all tokens gone
270             areFundsReleasedToBeneficiary = true;
271             isCrowdSaleClosed = true;
272             return "Successful (HORSE >= Hardcap)!";
273         } else if ((amountRaisedInWei >= fundingMinCapInWei) && (block.timestamp > fundingEndTime) && (tokensRemaining > 0)) { // ICO ended, over softcap!
274             areFundsReleasedToBeneficiary = true;
275             isCrowdSaleClosed = true;
276             return "Successful (Eth >= Softcap)!";
277         } else if ((amountRaisedInWei >= fundingMinCapInWei) && (tokensRemaining > 0) && (block.timestamp <= fundingEndTime)) { // ICO in progress, over softcap!
278             areFundsReleasedToBeneficiary = true;
279             isCrowdSaleClosed = false;
280             return "In progress (Eth >= Softcap)!";
281         }
282     }
283 
284     function refund() external { // any contributor can call this to have their Eth returned. user's purchased HORSE tokens are burned prior refund of Eth.
285         checkGoalReached();
286         //require minCap not reached
287         require ((amountRaisedInWei < fundingMinCapInWei)
288         && (isCrowdSaleClosed)
289         && (now > fundingEndTime)
290         && (fundValue[msg.sender] > 0));
291 
292         //refund Eth sent
293         uint256 ethRefund = fundValue[msg.sender];
294         fundValue[msg.sender] = 0;
295 
296         //send Eth back, burn tokens
297         msg.sender.transfer(ethRefund);
298         Refund(msg.sender, ethRefund);
299     }
300 
301     function burnRemainingTokens() onlyOwner external {
302         require(now > fundingEndTime);
303         uint256 tokensToBurn = tokenReward.balanceOf(this);
304         tokenReward.burn(tokensToBurn);
305     }
306 }
307 
308 library SafeMath {
309   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
310     if (a == 0) {
311       return 0;
312     }
313     uint256 c = a * b;
314     assert(c / a == b);
315     return c;
316   }
317 
318   function div(uint256 a, uint256 b) internal pure returns (uint256) {
319     // assert(b > 0); // Solidity automatically throws when dividing by 0
320     uint256 c = a / b;
321     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
322     return c;
323   }
324 
325   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
326     assert(b <= a);
327     return a - b;
328   }
329 
330   function add(uint256 a, uint256 b) internal pure returns (uint256) {
331     uint256 c = a + b;
332     assert(c >= a);
333     return c;
334   }
335 }