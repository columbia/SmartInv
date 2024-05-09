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
84 contract RtcTokenCrowdsale is Ownable, AddressWhitelist {
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
103     uint256 public p1_start;
104     uint256 public p2_start;
105     uint256 public white_duration;
106 
107     // loop control, ICO startup and limiters
108     uint256 public fundingStartTime;                           // crowdsale start time#
109     uint256 public fundingEndTime;                             // crowdsale end time#
110     bool    public isCrowdSaleClosed               = false;     // crowdsale completion boolean
111     bool    public areFundsReleasedToBeneficiary   = false;     // boolean for founder to receive Eth or not
112     bool    public isCrowdSaleSetup                = false;     // boolean for crowdsale setup
113 
114     // Gas price limit
115     uint256 maxGasPrice = 50000000000;
116 
117     event Buy(address indexed _sender, uint256 _eth, uint256 _RTC);
118     event Refund(address indexed _refunder, uint256 _value);
119     mapping(address => uint256) fundValue;
120 
121 
122     // convert tokens to decimals
123     function toSmallrtc(uint256 amount) public constant returns (uint256) {
124         return amount.mul(10**decimals);
125     }
126 
127     // convert tokens to whole
128     function toRtc(uint256 amount) public constant returns (uint256) {
129         return amount.div(10**decimals);
130     }
131 
132     function updateMaxGasPrice(uint256 _newGasPrice) public onlyOwner {
133         require(_newGasPrice != 0);
134         maxGasPrice = _newGasPrice;
135     }
136 
137     // setup the CrowdSale parameters
138     function setupCrowdsale(uint256 _fundingStartTime) external onlyOwner {
139         if ((!(isCrowdSaleSetup))
140             && (!(beneficiaryWallet > 0))){
141             // init addresses
142             tokenReward                             = PausableToken(0x7c5c5F763274FC2f5bb86877815675B5dfB6FE3a);
143             beneficiaryWallet                       = 0xf07bd63C5cf404c2f17ab4F9FA1e13fCCEbc5255;
144             tokensPerEthPrice                       = 10000;                  // 1 ETH = 10,000 RTC
145 
146             // funding targets
147             fundingMinCapInWei                      = 1 ether;                          //350 Eth (min cap) (test = 15) - crowdsale is considered success after this value
148 
149             // update values
150             decimals                                = 18;
151             amountRaisedInWei                       = 0;
152             initialSupply                           = toSmallrtc(35000000);                  //   35 million * 18 decimal
153             tokensRemaining                         = initialSupply;
154 
155             fundingStartTime                        = _fundingStartTime;
156 
157             white_duration                          = 2 hours;                        // 2 week (test = 2 hour)
158             p1_duration                             = 4 hours;                       // 4 week (test = 2 hour)
159 
160             p1_start                                = fundingStartTime + white_duration;
161             p2_start                                = p1_start + p1_duration + 4 hours;   // + 4 week after p1 ends (test = 4 hour)
162 
163             fundingEndTime                          = p2_start + 4 hours; // + 4 week (test = 4 hour)
164 
165             // configure crowdsale
166             isCrowdSaleSetup                        = true;
167             isCrowdSaleClosed                       = false;
168         }
169     }
170 
171     function setBonusPrice() public constant returns (uint256 bonus) {
172         require(isCrowdSaleSetup);
173         require(p1_start + p1_duration <= p2_start);
174         if (now >= fundingStartTime && now <= p1_start) { // Private sale Bonus 40% = 5,000 RTC  = 1 ETH (test = 50 RTC)
175             bonus = 4000;
176         } else if (now > p1_start && now <= p1_start + p1_duration) { // Phase-1 Bonus 30% = 3,000 RTC  = 1 ETH
177             bonus = 3000;
178         } else if (now > p2_start && now <= p2_start + 10 minutes ) { // Phase-2 1st day Bonus 25% = 2,500 RTC = 1 ETH (test = +10 minute)
179             bonus = 2500;
180         } else if (now > p2_start + 10 minutes && now <= p2_start + 1 hours ) { // Phase-2 week-1 Bonus 20% = 2,000 RTC = 1 ETH (test <= p2_start +1 hour)
181             bonus = 2000;
182         } else if (now > p2_start + 1 hours && now <= p2_start + 2 hours ) { // Phase-2 week-2 Bonus +15% = 1,500 RTC = 1 ETH (test <= p2_start +2 hour)
183             bonus = 1500;
184         } else if (now > p2_start + 2 hours && now <= p2_start + 3 hours ) { // Phase-2 week-3 Bonus +10% = 1,000 RTC = 1 ETH (test <= p2_start +3 hour)
185             bonus = 1000;
186         } else if (now > p2_start + 3 hours && now <= fundingEndTime ) { // Phase-2 final week Bonus 5% = 500 RTC = 1 ETH
187             bonus = 500;
188         } else {
189             revert();
190         }
191     }
192 
193     // p1_duration constant. Only p2 start changes. p2 start cannot be greater than 1 month from p1 end
194     function updateDuration(uint256 _newP2Start) external onlyOwner { // function to update the duration of phase-1 and adjust the start time of phase-2
195         require(isCrowdSaleSetup
196             && !(p2_start == _newP2Start)
197             && !(_newP2Start > p1_start + p1_duration + 30 hours)
198             && (now < p2_start)
199             && (fundingStartTime + p1_duration < _newP2Start));
200         p2_start = _newP2Start;
201         fundingEndTime = p2_start.add(4 hours);   // 4 week (test = add(4 hours))
202     }
203 
204     // default payable function when sending ether to this contract
205     function () external payable {
206         require(tx.gasprice <= maxGasPrice);
207         require(msg.data.length == 0);
208         
209         BuyRTCtokens();
210     }
211 
212     function BuyRTCtokens() public payable {
213         // conditions (length, crowdsale setup, zero check, exceed funding contrib check, contract valid check, within funding block range check, balance overflow check etc)
214         require(!(msg.value == 0)
215         && (isCrowdSaleSetup)
216         && (now >= fundingStartTime)
217         && (now <= fundingEndTime)
218         && (tokensRemaining > 0));
219 
220         // only whitelisted addresses are allowed during the first day of phase 1
221         if (now <= p1_start) {
222             assert(isWhitelisted(msg.sender));
223         }
224         uint256 rewardTransferAmount        = 0;
225         uint256 rewardBaseTransferAmount    = 0;
226         uint256 rewardBonusTransferAmount   = 0;
227         uint256 contributionInWei           = msg.value;
228         uint256 refundInWei                 = 0;
229 
230         rewardBonusTransferAmount       = setBonusPrice();
231         rewardBaseTransferAmount        = (msg.value.mul(tokensPerEthPrice)); // Since both ether and RTC have 18 decimals, No need of conversion
232         rewardBonusTransferAmount       = (msg.value.mul(rewardBonusTransferAmount)); // Since both ether and RTC have 18 decimals, No need of conversion
233         rewardTransferAmount            = rewardBaseTransferAmount.add(rewardBonusTransferAmount);
234 
235         if (rewardTransferAmount > tokensRemaining) {
236             uint256 partialPercentage;
237             partialPercentage = tokensRemaining.mul(10**18).div(rewardTransferAmount);
238             contributionInWei = contributionInWei.mul(partialPercentage).div(10**18);
239             rewardBonusTransferAmount = rewardBonusTransferAmount.mul(partialPercentage).div(10**18);
240             rewardTransferAmount = tokensRemaining;
241             refundInWei = msg.value.sub(contributionInWei);
242         }
243 
244         amountRaisedInWei               = amountRaisedInWei.add(contributionInWei);
245         tokensRemaining                 = tokensRemaining.sub(rewardTransferAmount);  // will cause throw if attempt to purchase over the token limit in one tx or at all once limit reached
246         fundValue[msg.sender]           = fundValue[msg.sender].add(contributionInWei);
247         assert(tokenReward.increaseFrozen(msg.sender, rewardBonusTransferAmount));
248         tokenReward.transfer(msg.sender, rewardTransferAmount);
249         Buy(msg.sender, contributionInWei, rewardTransferAmount);
250         if (refundInWei > 0) {
251             msg.sender.transfer(refundInWei);
252         }
253     }
254 
255     function beneficiaryMultiSigWithdraw() external onlyOwner {
256         checkGoalReached();
257         require(areFundsReleasedToBeneficiary && (amountRaisedInWei >= fundingMinCapInWei));
258         beneficiaryWallet.transfer(this.balance);
259     }
260 
261     function checkGoalReached() public returns (bytes32 response) { // return crowdfund status to owner for each result case, update public constant
262         // update state & status variables
263         require (isCrowdSaleSetup);
264         if ((amountRaisedInWei < fundingMinCapInWei) && (block.timestamp <= fundingEndTime && block.timestamp >= fundingStartTime)) { // ICO in progress, under softcap
265             areFundsReleasedToBeneficiary = false;
266             isCrowdSaleClosed = false;
267             return "In progress (Eth < Softcap)";
268         } else if ((amountRaisedInWei < fundingMinCapInWei) && (block.timestamp < fundingStartTime)) { // ICO has not started
269             areFundsReleasedToBeneficiary = false;
270             isCrowdSaleClosed = false;
271             return "Crowdsale is setup";
272         } else if ((amountRaisedInWei < fundingMinCapInWei) && (block.timestamp > fundingEndTime)) { // ICO ended, under softcap
273             areFundsReleasedToBeneficiary = false;
274             isCrowdSaleClosed = true;
275             return "Unsuccessful (Eth < Softcap)";
276         } else if ((amountRaisedInWei >= fundingMinCapInWei) && (tokensRemaining == 0)) { // ICO ended, all tokens gone
277             areFundsReleasedToBeneficiary = true;
278             isCrowdSaleClosed = true;
279             return "Successful (RTC >= Hardcap)!";
280         } else if ((amountRaisedInWei >= fundingMinCapInWei) && (block.timestamp > fundingEndTime) && (tokensRemaining > 0)) { // ICO ended, over softcap!
281             areFundsReleasedToBeneficiary = true;
282             isCrowdSaleClosed = true;
283             return "Successful (Eth >= Softcap)!";
284         } else if ((amountRaisedInWei >= fundingMinCapInWei) && (tokensRemaining > 0) && (block.timestamp <= fundingEndTime)) { // ICO in progress, over softcap!
285             areFundsReleasedToBeneficiary = true;
286             isCrowdSaleClosed = false;
287             return "In progress (Eth >= Softcap)!";
288         }
289     }
290 
291     function refund() external { // any contributor can call this to have their Eth returned. user's purchased RTC tokens are burned prior refund of Eth.
292         checkGoalReached();
293         //require minCap not reached
294         require ((amountRaisedInWei < fundingMinCapInWei)
295         && (isCrowdSaleClosed)
296         && (now > fundingEndTime)
297         && (fundValue[msg.sender] > 0));
298 
299         //refund Eth sent
300         uint256 ethRefund = fundValue[msg.sender];
301         fundValue[msg.sender] = 0;
302 
303         //send Eth back, burn tokens
304         msg.sender.transfer(ethRefund);
305         Refund(msg.sender, ethRefund);
306     }
307 
308     function burnRemainingTokens() onlyOwner external {
309         require(now > fundingEndTime);
310         uint256 tokensToBurn = tokenReward.balanceOf(this);
311         tokenReward.burn(tokensToBurn);
312     }
313 }
314 
315 library SafeMath {
316   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
317     if (a == 0) {
318       return 0;
319     }
320     uint256 c = a * b;
321     assert(c / a == b);
322     return c;
323   }
324 
325   function div(uint256 a, uint256 b) internal pure returns (uint256) {
326     // assert(b > 0); // Solidity automatically throws when dividing by 0
327     uint256 c = a / b;
328     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
329     return c;
330   }
331 
332   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
333     assert(b <= a);
334     return a - b;
335   }
336 
337   function add(uint256 a, uint256 b) internal pure returns (uint256) {
338     uint256 c = a + b;
339     assert(c >= a);
340     return c;
341   }
342 }