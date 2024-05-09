1 pragma solidity 0.5.5;
2 /**
3  * @title OMNIS-BIT ICO CONTRACT
4  * @dev ERC-20 Token Standard Compliant
5  * Official OMNIS-BIT SmartContract
6  * website: www.cryptohunters.club
7  */
8 
9 // ----------------------------------------------------------------------------
10 // Safe maths
11 // ----------------------------------------------------------------------------
12 library SafeMath {
13     function add(uint a, uint b) internal pure returns(uint c) {
14         c = a + b;
15         require(c >= a);
16     }
17 
18     function sub(uint a, uint b) internal pure returns(uint c) {
19         require(b <= a);
20         c = a - b;
21     }
22 
23     function mul(uint a, uint b) internal pure returns(uint c) {
24         c = a * b;
25         require(a == 0 || c / a == b);
26     }
27 
28     function div(uint a, uint b) internal pure returns(uint c) {
29         require(b > 0);
30         c = a / b;
31     }
32 }
33 
34 // ----------------------------------------------------------------------------
35 // ERC20 Token Standard Interface
36 // ----------------------------------------------------------------------------
37 interface ERC20Interface {
38     function totalSupply() external returns(uint);
39 
40     function balanceOf(address tokenOwner) external returns(uint balance);
41 
42     function allowance(address tokenOwner, address spender) external returns(uint remaining);
43 
44     function transfer(address to, uint tokens) external returns(bool success);
45 
46     function approve(address spender, uint tokens) external returns(bool success);
47 
48     function transferFrom(address from, address to, uint tokens) external returns(bool success);
49 
50     event Transfer(address indexed from, address indexed to, uint tokens);
51     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
52 }
53 
54 // ----------------------------------------------------------------------------
55 // DateTime API Interface
56 // ----------------------------------------------------------------------------
57 interface DateTimeAPI {
58 
59     function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute) external returns(uint timestamp);
60 
61 }
62 
63 // ----------------------------------------------------------------------------
64 // Main Contract definition
65 // ----------------------------------------------------------------------------
66 contract ICO {
67 
68 // ----------------------------------------------------------------------------
69 // DateTime API Contract Addresses for each network
70 // ----------------------------------------------------------------------------
71     DateTimeAPI dateTimeContract = DateTimeAPI(0x1a6184CD4C5Bea62B0116de7962EE7315B7bcBce);//Main
72     //DateTimeAPI dateTimeContract = DateTimeAPI(0x71b6e049E78c75fC61480357CD5aA1B81E1b16E0);//Kovan
73     //DateTimeAPI dateTimeContract = DateTimeAPI(0x670b2B167e13b131C491D87bA745dA41f07ecbc3);//Rinkeby
74     //DateTimeAPI dateTimeContract = DateTimeAPI(0x1F0a2ba4B115bd3e4007533C52BBd30C17E8B222); //Ropsten
75 
76     using SafeMath
77     for uint256;
78 
79     enum State {
80         //This ico have these states
81         preSale,
82         ICO,
83         finishing,
84         extended,
85         successful
86     }
87 
88     //public variables
89 
90     //state related
91     State public state = State.preSale; //Set initial stage
92     
93 
94     //time related
95     uint256 public startTime = dateTimeContract.toTimestamp(2019, 3, 20, 0, 0);
96     uint256 public ICOdeadline = dateTimeContract.toTimestamp(2019, 6, 5, 23, 59);
97     uint256 public completedAt;
98 
99     //token related
100     ERC20Interface public tokenReward;
101     uint256 public presaleLimit = 200000000 * 10 ** 18; //200.000.000 Tokens
102     uint256 public ICOLimit = 360000000 * 10 ** 18; //360.000.000 Tokens
103 
104     //funding related
105     uint256 public totalRaised; //eth in wei
106     uint256 public totalDistributed; //tokens distributed
107     uint256 public totalReferral; //total tokens for referrals
108     mapping(address => uint256) public referralBalance; //referral ledger
109     uint256[7] public rates = [1000, 800, 750, 700, 650, 600, 500];
110     
111     //info
112     address public creator;
113     address payable public beneficiary;
114     string public version = '0.3';
115 
116     //events for log
117     event LogFundingReceived(address _addr, uint _amount, uint _currentTotal);
118     event LogBeneficiaryPaid(address _beneficiaryAddress);
119     event LogFundingSuccessful(uint _totalRaised);
120     event LogFunderInitialized(
121         address _creator,
122         uint256 _ICOdeadline);
123     event LogContributorsPayout(address _addr, uint _amount);
124     event LogStateCheck(State current);
125 
126     modifier notFinished() {
127         require(state != State.successful);
128         _;
129     }
130 
131     /**
132      * @notice ICO constructor
133      * @param _addressOfTokenUsedAsReward is the token to distributed
134      * @param _beneficiary is the address that will receive funds collected
135      */
136     constructor(ERC20Interface _addressOfTokenUsedAsReward, address payable _beneficiary) public {
137 
138         creator = msg.sender;
139         tokenReward = _addressOfTokenUsedAsReward;
140         beneficiary = _beneficiary;
141 
142         emit LogFunderInitialized(
143             creator,
144             ICOdeadline);
145 
146     }
147 
148     /**
149      * @notice contribution handler
150      * @param referralAddress is the address of the referral for this purchase
151      */
152     function contribute(address referralAddress) public notFinished payable {
153 
154         //require that the ico start date is reached
155         require(now >= startTime,"Too early for the sale begin");
156 
157         uint256 tokenBought = 0;
158 
159         totalRaised = totalRaised.add(msg.value); //Track funds received
160 
161         //Rate of exchange depends on stage
162         if (state == State.preSale) {
163 
164             if (now <= dateTimeContract.toTimestamp(2019, 3, 22, 23, 59)) { //>start date <22/3/2019 23:59 GMT
165 
166                 tokenBought = msg.value.mul(rates[0]);
167 
168             } else if (now <= dateTimeContract.toTimestamp(2019, 3, 28, 23, 59)) { //>22/3/2019 23:59 GMT <28/3/2019 23:59 GMT
169 
170                 tokenBought = msg.value.mul(rates[1]);
171 
172             } else { //>28/3/2019 23:59 GMT <11/4/2019 23:59 GMT
173 
174                 tokenBought = msg.value.mul(rates[2]);
175 
176             }
177 
178         } else if (state == State.ICO) {
179 
180             //require ico stage has begin
181             require(now > dateTimeContract.toTimestamp(2019, 4, 20, 0, 0),"Too early for the ICO begin"); 
182 
183             if (now <= dateTimeContract.toTimestamp(2019, 4, 22, 23, 59)) { //>20/4/2019 00:00 GMT <22/4/2019 23:59 GMT
184 
185                 tokenBought = msg.value.mul(rates[3]);
186 
187             } else if (now <= dateTimeContract.toTimestamp(2019, 4, 28, 23, 59)) { //>22/4/2019 23:59 GMT <28/4/2019 23:59 GMT
188 
189                 tokenBought = msg.value.mul(rates[4]);
190 
191             } else if (now <= dateTimeContract.toTimestamp(2019, 5, 4, 23, 59)) { //>28/4/2019 23:59 GMT <5/5/2019 23:59 GMT
192 
193                 tokenBought = msg.value.mul(rates[5]);
194 
195             } else { //>5/5/2019 23:59 GMT <5/6/2019 23:59 GMT
196 
197                 tokenBought = msg.value.mul(rates[6]);
198 
199             }
200 
201         } else if (state == State.finishing) { //Poll being made
202 
203             revert("Purchases disabled while extension Poll");
204 
205         } else { //extension approved, 30 more days from approval
206 
207             tokenBought = msg.value.mul(rates[6]);
208 
209         }
210 
211         //+10% Bonus for high contributor
212         if (msg.value >= 100 ether) {
213             tokenBought = tokenBought.mul(11);
214             tokenBought = tokenBought.div(10);
215         }
216 
217         //3% for referral
218         //Can be claimed at the end of ICO
219         if (referralAddress != address(0) && referralAddress != msg.sender) {
220             uint256 bounty = tokenBought.mul(3);
221             bounty = bounty.div(100);
222             totalReferral = totalReferral.add(bounty);
223             referralBalance[referralAddress] = referralBalance[referralAddress].add(bounty);
224         }
225 
226         if (state == State.preSale) {
227 
228             require(totalDistributed.add(tokenBought.add(totalReferral)) <= presaleLimit, "Presale Limit exceded");
229 
230         } else {
231 
232             require(totalDistributed.add(tokenBought.add(totalReferral)) <= ICOLimit, "ICO Limit exceded");
233 
234         }
235 
236         //Automatic retrieve only after a trust threshold
237         if (totalRaised >= 4000 ether) {
238 
239             beneficiary.transfer(address(this).balance);
240 
241             emit LogBeneficiaryPaid(beneficiary);
242         }
243 
244         totalDistributed = totalDistributed.add(tokenBought); //update total token distribution
245 
246         require(tokenReward.transfer(msg.sender, tokenBought), "Transfer could not be made");
247 
248         emit LogFundingReceived(msg.sender, msg.value, totalRaised);
249         emit LogContributorsPayout(msg.sender, tokenBought);
250 
251         checkIfFundingCompleteOrExpired();
252     }
253 
254     /**
255      * @notice check status
256      */
257     function checkIfFundingCompleteOrExpired() public {
258 
259         //If we reach presale time limit 11/4/2019 23:59 GMT
260         if (state == State.preSale && now > dateTimeContract.toTimestamp(2019, 4, 11, 23, 59)) {
261 
262             //change state to ICO
263             state = State.ICO;
264 
265         } else if (state == State.ICO && now > ICOdeadline) { //If we reach the ICO deadline
266 
267             //change state to finishing for extension poll
268             state = State.finishing;
269 
270         } else if (state == State.extended && now > ICOdeadline) { //If it was extended, check until extension expires
271 
272             state = State.successful; //ico becomes Successful
273             completedAt = now; //ICO is complete
274 
275             emit LogFundingSuccessful(totalRaised); //we log the finish
276             finished(); //and execute closure
277 
278         }
279 
280         emit LogStateCheck(state);
281 
282     }
283 
284     /**
285      * @notice closure handler
286      */
287     function finished() public { //When finished, eth are transfered to beneficiary
288 
289         //Only on sucess
290         require(state == State.successful, "Wrong Stage");
291 
292         beneficiary.transfer(address(this).balance);
293 
294         emit LogBeneficiaryPaid(beneficiary);
295 
296     }
297 
298     /**
299      * @notice referral bounty claim
300      */
301     function claimReferral() public {
302 
303         //Only on sucess
304         require(state == State.successful, "Wrong Stage");
305 
306         uint256 bounty = referralBalance[msg.sender]; //check, get balance
307         referralBalance[msg.sender] = 0; //effect, clear balance
308 
309         //interact
310         require(tokenReward.transfer(msg.sender, bounty), "Transfer could not be made");
311 
312         //log
313         emit LogContributorsPayout(msg.sender, bounty);
314     }
315 
316     /**
317      * @notice remaining tokens retrieve
318      */
319     function retrieveTokens() public {
320 
321         //Only creator
322         require(msg.sender == creator,"You are not the creator");
323         //Only on success
324         require(state == State.successful, "Wrong Stage");
325         //Only after 30 days claim period for referrals
326         require(now >= completedAt.add(30 days), "Too early to retrieve");
327 
328         uint256 remanent = tokenReward.balanceOf(address(this));
329 
330         require(tokenReward.transfer(beneficiary, remanent), "Transfer could not be made");
331     }
332 
333     /**
334      * @notice extension poll result handler
335      * @param pollResult a boolean value of approved(true) or denied(false)
336      */
337     function extension(bool pollResult) public {
338 
339         //Only creator
340         require(msg.sender == creator,"You are not the creator");
341         //Only on poll stage
342         require(state == State.finishing, "Wrong Stage");
343 
344         //poll results
345         if (pollResult == true) { //Approved
346             //extended stage
347             state = State.extended;
348             //extension is 30Days
349             ICOdeadline = now.add(30 days);
350         } else { //Denied
351             //ico becomes Successful
352             state = State.successful;
353             //ICO is complete, stamp it
354             completedAt = now;
355 
356             emit LogFundingSuccessful(totalRaised); //we log the finish
357             finished(); //and execute closure
358 
359         }
360     }
361 
362     /*
363      * @notice direct payments handler
364      */
365     function() external payable {
366 
367         contribute(address(0)); //no referral
368 
369     }
370 }