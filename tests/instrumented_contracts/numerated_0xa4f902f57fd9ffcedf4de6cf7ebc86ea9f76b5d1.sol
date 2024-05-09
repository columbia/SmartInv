1 pragma solidity^0.4.15;
2 
3 contract EtheraffleLOT {
4     function mint(address _to, uint _amt) external {}
5     function transfer(address to, uint value) public {}
6     function balanceOf(address who) constant public returns (uint) {}
7 }
8 contract EtheraffleICO is EtheraffleLOT {
9 
10     /* Lot reward per ether in each tier */
11     uint public constant tier0LOT = 110000 * 10 ** 6;
12     uint public constant tier1LOT = 100000 * 10 ** 6;
13     uint public constant tier2LOT =  90000 * 10 ** 6;
14     uint public constant tier3LOT =  80000 * 10 ** 6;
15     /* Bonus tickets multiplier */
16     uint public constant bonusLOT     = 1500 * 10 ** 6;
17     uint public constant bonusFreeLOT = 10;
18     /* Maximum amount of ether investable per tier */
19     uint public constant maxWeiTier0 = 700   * 10 ** 18;
20     uint public constant maxWeiTier1 = 2500  * 10 ** 18;
21     uint public constant maxWeiTier2 = 7000  * 10 ** 18;
22     uint public constant maxWeiTier3 = 20000 * 10 ** 18;
23     /* Minimum investment (0.025 Ether) */
24     uint public constant minWei = 25 * 10 ** 15;
25     /* Crowdsale open, close, withdraw & tier times (UTC Format)*/
26     uint public ICOStart = 1522281600;//Thur 29th March 2018
27     uint public tier1End = 1523491200;//Thur 12th April 2018
28     uint public tier2End = 1525305600;//Thur 3rd May 2018
29     uint public tier3End = 1527724800;//Thur 31st May 2018
30     uint public wdBefore = 1528934400;//Thur 14th June 2018
31     /* Variables to track amount of purchases in tier */
32     uint public tier0Total;
33     uint public tier1Total;
34     uint public tier2Total;
35     uint public tier3Total;
36     /* Etheraffle's multisig wallet & LOT token addresses */
37     address public etheraffle;
38     /* ICO status toggle */
39     bool public ICORunning = true;
40     /* Map of purchaser's ethereum addresses to their purchase amounts for calculating bonuses*/
41     mapping (address => uint) public tier0;
42     mapping (address => uint) public tier1;
43     mapping (address => uint) public tier2;
44     mapping (address => uint) public tier3;
45     /* Instantiate the variables to hold Etheraffle's LOT & freeLOT token contract instances */
46     EtheraffleLOT LOT;
47     EtheraffleLOT FreeLOT;
48     /* Event loggers */
49     event LogTokenDeposit(address indexed from, uint value, bytes data);
50     event LogRefund(address indexed toWhom, uint amountOfEther, uint atTime);
51     event LogEtherTransfer(address indexed toWhom, uint amount, uint atTime);
52     event LogBonusLOTRedemption(address indexed toWhom, uint lotAmount, uint atTime);
53     event LogLOTTransfer(address indexed toWhom, uint indexed inTier, uint ethAmt, uint LOTAmt, uint atTime);
54     /**
55      * @dev Modifier function to prepend to later functions in this contract in
56      *      order to redner them only useable by the Etheraffle address.
57      */
58     modifier onlyEtheraffle() {
59         require(msg.sender == etheraffle);
60         _;
61     }
62     /**
63      * @dev Modifier function to prepend to later functions rendering the method
64      *      only callable if the crowdsale is running.
65      */
66     modifier onlyIfRunning() {
67         require(ICORunning);
68         _;
69     }
70     /**
71      * @dev Modifier function to prepend to later functions rendering the method
72      *      only callable if the crowdsale is NOT running.
73      */
74     modifier onlyIfNotRunning() {
75         require(!ICORunning);
76         _;
77     }
78     /**
79     * @dev  Constructor. Sets up the variables pertaining to the ICO start &
80     *       end times, the tier start & end times, the Etheraffle MultiSig Wallet
81     *       address & the Etheraffle LOT & FreeLOT token contracts.
82     */
83     function EtheraffleICO() public {//address _LOT, address _freeLOT, address _msig) public {
84         etheraffle = 0x97f535e98cf250cdd7ff0cb9b29e4548b609a0bd;
85         LOT        = EtheraffleLOT(0xAfD9473dfe8a49567872f93c1790b74Ee7D92A9F);
86         FreeLOT    = EtheraffleLOT(0xc39f7bB97B31102C923DaF02bA3d1bD16424F4bb);
87     }
88     /**
89     * @dev  Purchase LOT tokens.
90     *       LOT are sent in accordance with how much ether is invested, and in what
91     *       tier the investment was made. The function also stores the amount of ether
92     *       invested for later conversion to the amount of bonus LOT owed. Once the
93     *       crowdsale is over and the final number of tokens sold is known, the purchaser's
94     *       bonuses can be calculated. Using the fallback function allows LOT purchasers to
95     *       simply send ether to this address in order to purchase LOT, without having
96     *       to call a function. The requirements also also mean that once the crowdsale is
97     *       over, any ether sent to this address by accident will be returned to the sender
98     *       and not lost.
99     */
100     function () public payable onlyIfRunning {
101         /* Requires the crowdsale time window to be open and the function caller to send ether */
102         require
103         (
104             now <= tier3End &&
105             msg.value >= minWei
106         );
107         uint numLOT = 0;
108         if (now <= ICOStart) {// ∴ tier zero...
109             /* Eth investable in each tier is capped via this requirement */
110             require(tier0Total + msg.value <= maxWeiTier0);
111             /* Store purchasers purchased amount for later bonus redemption */
112             tier0[msg.sender] += msg.value;
113             /* Track total investment in tier one for later bonus calculation */
114             tier0Total += msg.value;
115             /* Number of LOT this tier's purchase results in */
116             numLOT = (msg.value * tier0LOT) / (1 * 10 ** 18);
117             /* Transfer the number of LOT bought to the purchaser */
118             LOT.transfer(msg.sender, numLOT);
119             /* Log the  transfer */
120             LogLOTTransfer(msg.sender, 0, msg.value, numLOT, now);
121             return;
122         } else if (now <= tier1End) {// ∴ tier one...
123             require(tier1Total + msg.value <= maxWeiTier1);
124             tier1[msg.sender] += msg.value;
125             tier1Total += msg.value;
126             numLOT = (msg.value * tier1LOT) / (1 * 10 ** 18);
127             LOT.transfer(msg.sender, numLOT);
128             LogLOTTransfer(msg.sender, 1, msg.value, numLOT, now);
129             return;
130         } else if (now <= tier2End) {// ∴ tier two...
131             require(tier2Total + msg.value <= maxWeiTier2);
132             tier2[msg.sender] += msg.value;
133             tier2Total += msg.value;
134             numLOT = (msg.value * tier2LOT) / (1 * 10 ** 18);
135             LOT.transfer(msg.sender, numLOT);
136             LogLOTTransfer(msg.sender, 2, msg.value, numLOT, now);
137             return;
138         } else {// ∴ tier three...
139             require(tier3Total + msg.value <= maxWeiTier3);
140             tier3[msg.sender] += msg.value;
141             tier3Total += msg.value;
142             numLOT = (msg.value * tier3LOT) / (1 * 10 ** 18);
143             LOT.transfer(msg.sender, numLOT);
144             LogLOTTransfer(msg.sender, 3, msg.value, numLOT, now);
145             return;
146         }
147     }
148     /**
149     * @dev      Redeem bonus LOT: This function cannot be called until
150     *           the crowdsale is over, nor after the withdraw period.
151     *           During this window, a LOT purchaser calls this function
152     *           in order to receive their bonus LOT owed to them, as
153     *           calculated by their share of the total amount of LOT
154     *           sales in the tier(s) following their purchase. Once
155     *           claimed, user's purchased amounts are set to 1 wei rather
156     *           than zero, to allow the contract to maintain a list of
157     *           purchasers in each. All investors, regardless of tier/amount,
158     *           receive ten free entries into the flagship Saturday
159     *           Etheraffle via the FreeLOT coupon.
160     */
161     function redeemBonusLot() external onlyIfRunning { //81k gas
162         /* Requires crowdsale to be over and the wdBefore time to not have passed yet */
163         require
164         (
165             now > tier3End &&
166             now < wdBefore
167         );
168         /* Requires user to have a LOT purchase in at least one of the tiers. */
169         require
170         (
171             tier0[msg.sender] > 1 ||
172             tier1[msg.sender] > 1 ||
173             tier2[msg.sender] > 1 ||
174             tier3[msg.sender] > 1
175         );
176         uint bonusNumLOT;
177         /* If purchaser has ether in this tier, LOT tokens owed is calculated and added to LOT amount */
178         if(tier0[msg.sender] > 1) {
179             bonusNumLOT +=
180             /* Calculate share of bonus LOT user is entitled to, based on tier one sales */
181             ((tier1Total * bonusLOT * tier0[msg.sender]) / (tier0Total * (1 * 10 ** 18))) +
182             /* Calculate share of bonus LOT user is entitled to, based on tier two sales */
183             ((tier2Total * bonusLOT * tier0[msg.sender]) / (tier0Total * (1 * 10 ** 18))) +
184             /* Calculate share of bonus LOT user is entitled to, based on tier three sales */
185             ((tier3Total * bonusLOT * tier0[msg.sender]) / (tier0Total * (1 * 10 ** 18)));
186             /* Set amount of ether in this tier to 1 to make further bonus redemptions impossible */
187             tier0[msg.sender] = 1;
188         }
189         if(tier1[msg.sender] > 1) {
190             bonusNumLOT +=
191             ((tier2Total * bonusLOT * tier1[msg.sender]) / (tier1Total * (1 * 10 ** 18))) +
192             ((tier3Total * bonusLOT * tier1[msg.sender]) / (tier1Total * (1 * 10 ** 18)));
193             tier1[msg.sender] = 1;
194         }
195         if(tier2[msg.sender] > 1) {
196             bonusNumLOT +=
197             ((tier3Total * bonusLOT * tier2[msg.sender]) / (tier2Total * (1 * 10 ** 18)));
198             tier2[msg.sender] = 1;
199         }
200         if(tier3[msg.sender] > 1) {
201             tier3[msg.sender] = 1;
202         }
203         /* Final check that user cannot withdraw twice */
204         require
205         (
206             tier0[msg.sender]  <= 1 &&
207             tier1[msg.sender]  <= 1 &&
208             tier2[msg.sender]  <= 1 &&
209             tier3[msg.sender]  <= 1
210         );
211         /* Transfer bonus LOT to bonus redeemer */
212         if(bonusNumLOT > 0) {
213             LOT.transfer(msg.sender, bonusNumLOT);
214         }
215         /* Mint FreeLOT and give to bonus redeemer */
216         FreeLOT.mint(msg.sender, bonusFreeLOT);
217         /* Log the bonus LOT redemption */
218         LogBonusLOTRedemption(msg.sender, bonusNumLOT, now);
219     }
220     /**
221     * @dev    Should crowdsale be cancelled for any reason once it has
222     *         begun, any ether is refunded to the purchaser by calling
223     *         this funcion. Function checks each tier in turn, totalling
224     *         the amount whilst zeroing the balance, and finally makes
225     *         the transfer.
226     */
227     function refundEther() external onlyIfNotRunning {
228         uint amount;
229         if(tier0[msg.sender] > 1) {
230             /* Add balance of caller's address in this tier to the amount */
231             amount += tier0[msg.sender];
232             /* Zero callers balance in this tier */
233             tier0[msg.sender] = 0;
234         }
235         if(tier1[msg.sender] > 1) {
236             amount += tier1[msg.sender];
237             tier1[msg.sender] = 0;
238         }
239         if(tier2[msg.sender] > 1) {
240             amount += tier2[msg.sender];
241             tier2[msg.sender] = 0;
242         }
243         if(tier3[msg.sender] > 1) {
244             amount += tier3[msg.sender];
245             tier3[msg.sender] = 0;
246         }
247         /* Final check that user cannot be refunded twice */
248         require
249         (
250             tier0[msg.sender] == 0 &&
251             tier1[msg.sender] == 0 &&
252             tier2[msg.sender] == 0 &&
253             tier3[msg.sender] == 0
254         );
255         /* Transfer the ether to the caller */
256         msg.sender.transfer(amount);
257         /* Log the refund */
258         LogRefund(msg.sender, amount, now);
259         return;
260     }
261     /**
262     * @dev    Function callable only by Etheraffle's multi-sig wallet. It
263     *         transfers the tier's raised ether to the etheraffle multisig wallet
264     *         once the tier is over.
265     *
266     * @param _tier    The tier from which the withdrawal is being made.
267     */
268     function transferEther(uint _tier) external onlyIfRunning onlyEtheraffle {
269         if(_tier == 0) {
270             /* Require tier zero to be over and a tier zero ether be greater than 0 */
271             require(now > ICOStart && tier0Total > 0);
272             /* Transfer the tier zero total to the etheraffle multisig */
273             etheraffle.transfer(tier0Total);
274             /* Log the transfer event */
275             LogEtherTransfer(msg.sender, tier0Total, now);
276             return;
277         } else if(_tier == 1) {
278             require(now > tier1End && tier1Total > 0);
279             etheraffle.transfer(tier1Total);
280             LogEtherTransfer(msg.sender, tier1Total, now);
281             return;
282         } else if(_tier == 2) {
283             require(now > tier2End && tier2Total > 0);
284             etheraffle.transfer(tier2Total);
285             LogEtherTransfer(msg.sender, tier2Total, now);
286             return;
287         } else if(_tier == 3) {
288             require(now > tier3End && tier3Total > 0);
289             etheraffle.transfer(tier3Total);
290             LogEtherTransfer(msg.sender, tier3Total, now);
291             return;
292         } else if(_tier == 4) {
293             require(now > tier3End && this.balance > 0);
294             etheraffle.transfer(this.balance);
295             LogEtherTransfer(msg.sender, this.balance, now);
296             return;
297         }
298     }
299     /**
300     * @dev    Function callable only by Etheraffle's multi-sig wallet.
301     *         It transfers any remaining unsold LOT tokens to the
302     *         Etheraffle multisig wallet. Function only callable once
303     *         the withdraw period and ∴ the ICO ends.
304     */
305     function transferLOT() onlyEtheraffle onlyIfRunning external {
306         require(now > wdBefore);
307         uint amt = LOT.balanceOf(this);
308         LOT.transfer(etheraffle, amt);
309         LogLOTTransfer(msg.sender, 5, 0, amt, now);
310     }
311     /**
312     * @dev    Toggle crowdsale status. Only callable by the Etheraffle
313     *         mutlisig account. If set to false, the refund function
314     *         becomes live allow purchasers to withdraw their ether
315     *
316     */
317     function setCrowdSaleStatus(bool _status) external onlyEtheraffle {
318         ICORunning = _status;
319     }
320     /**
321      * @dev This function is what allows this contract to receive ERC223
322      *      compliant tokens. Any tokens sent to this address will fire off
323      *      an event announcing their arrival. Unlike ERC20 tokens, ERC223
324      *      tokens cannot be sent to contracts absent this function,
325      *      thereby preventing loss of tokens by mistakenly sending them to
326      *      contracts not designed to accept them.
327      *
328      * @param _from     From whom the transfer originated
329      * @param _value    How many tokens were sent
330      * @param _data     Transaction metadata
331      */
332     function tokenFallback(address _from, uint _value, bytes _data) public {
333         if (_value > 0) {
334             LogTokenDeposit(_from, _value, _data);
335         }
336     }
337     /**
338      * @dev   Housekeeping function in the event this contract is no
339      *        longer needed. Will delete the code from the blockchain.
340      */
341     function selfDestruct() external onlyIfNotRunning onlyEtheraffle {
342         selfdestruct(etheraffle);
343     }
344 }