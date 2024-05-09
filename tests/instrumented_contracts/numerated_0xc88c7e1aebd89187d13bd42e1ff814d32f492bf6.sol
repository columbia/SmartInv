1 pragma solidity ^0.4.13;
2 contract IERC20Token {
3   function totalSupply() constant returns (uint256 totalSupply);
4   function balanceOf(address _owner) constant returns (uint256 balance) {}
5   function transfer(address _to, uint256 _value) returns (bool success) {}
6   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
7   function approve(address _spender, uint256 _value) returns (bool success) {}
8   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
9   event Transfer(address indexed _from, address indexed _to, uint256 _value);
10   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
11 }
12 contract IToken {
13   function totalSupply() constant returns (uint256 totalSupply);
14   function mintTokens(address _to, uint256 _amount) {}
15 }
16 contract Owned {
17     address public owner;
18     address public newOwner;
19     function Owned() {
20         owner = msg.sender;
21     }
22     modifier onlyOwner {
23         assert(msg.sender == owner);
24         _;
25     }
26     function transferOwnership(address _newOwner) public onlyOwner {
27         require(_newOwner != owner);
28         newOwner = _newOwner;
29     }
30     function acceptOwnership() public {
31         require(msg.sender == newOwner);
32         OwnerUpdate(owner, newOwner);
33         owner = newOwner;
34         newOwner = 0x0;
35     }
36     event OwnerUpdate(address _prevOwner, address _newOwner);
37 }
38 contract ReentrancyHandling {
39     bool locked;
40     modifier noReentrancy() {
41         require(!locked);
42         locked = true;
43         _;
44         locked = false;
45     }
46 }
47 /**
48  * @title SafeMath
49  * @dev Math operations with safety checks that throw on error
50  */
51 library SafeMath {
52   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
53     uint256 c = a * b;
54     assert(a == 0 || c / a == b);
55     return c;
56   }
57   function div(uint256 a, uint256 b) internal constant returns (uint256) {
58     // assert(b > 0); // Solidity automatically throws when dividing by 0
59     uint256 c = a / b;
60     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61     return c;
62   }
63   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
64     assert(b <= a);
65     return a - b;
66   }
67   function add(uint256 a, uint256 b) internal constant returns (uint256) {
68     uint256 c = a + b;
69     assert(c >= a);
70     return c;
71   }
72 }
73 contract Crowdsale is ReentrancyHandling, Owned {
74   using SafeMath for uint256;
75   
76   struct ContributorData {
77     bool isWhiteListed;
78     bool isCommunityRoundApproved;
79     uint256 contributionAmount;
80     uint256 tokensIssued;
81   }
82   mapping(address => ContributorData) public contributorList;
83   enum state { pendingStart, communityRound, crowdsaleStarted, crowdsaleEnded }
84   state crowdsaleState;
85   uint public communityRoundStartDate;
86   uint public crowdsaleStartDate;
87   uint public crowdsaleEndDate;
88   event CommunityRoundStarted(uint timestamp);
89   event CrowdsaleStarted(uint timestamp);
90   event CrowdsaleEnded(uint timestamp);
91   IToken token = IToken(0x0);
92   uint ethToTokenConversion;
93   uint256 maxCrowdsaleCap;
94   uint256 maxCommunityCap;
95   uint256 maxCommunityWithoutBonusCap;
96   uint256 maxContribution;
97   uint256 tokenSold = 0;
98   uint256 communityTokenSold = 0;
99   uint256 communityTokenWithoutBonusSold = 0;
100   uint256 crowdsaleTokenSold = 0;
101   uint256 public ethRaisedWithoutCompany = 0;
102   address companyAddress;   // company wallet address in cold/hardware storage 
103   uint maxTokenSupply;
104   uint companyTokens;
105   bool treasuryLocked = false;
106   bool ownerHasClaimedTokens = false;
107   bool ownerHasClaimedCompanyTokens = false;
108   // validates sender is whitelisted
109   modifier onlyWhiteListUser {
110     require(contributorList[msg.sender].isWhiteListed == true);
111     _;
112   }
113   // limit gas price to 50 Gwei (about 5-10x the normal amount)
114   modifier onlyLowGasPrice {
115 	  require(tx.gasprice <= 50*10**9 wei);
116 	  _;
117   }
118   //
119   // Unnamed function that runs when eth is sent to the contract
120   //
121   function() public noReentrancy onlyWhiteListUser onlyLowGasPrice payable {
122     require(msg.value != 0);                                         // Throw if value is 0
123     require(companyAddress != 0x0);
124     require(token != IToken(0x0));
125     checkCrowdsaleState();                                           // Calibrate crowdsale state
126     assert((crowdsaleState == state.communityRound && contributorList[msg.sender].isCommunityRoundApproved) ||
127             crowdsaleState == state.crowdsaleStarted);
128     
129     processTransaction(msg.sender, msg.value);                       // Process transaction and issue tokens
130     checkCrowdsaleState();                                           // Calibrate crowdsale state
131   }
132   // 
133   // return state of smart contract
134   //
135   function getState() public constant returns (uint256, uint256, uint) {
136     uint currentState = 0;
137     if (crowdsaleState == state.pendingStart) {
138       currentState = 1;
139     }
140     else if (crowdsaleState == state.communityRound) {
141       currentState = 2;
142     }
143     else if (crowdsaleState == state.crowdsaleStarted) {
144       currentState = 3;
145     }
146     else if (crowdsaleState == state.crowdsaleEnded) {
147       currentState = 4;
148     }
149     return (tokenSold, communityTokenSold, currentState);
150   }
151   //
152   // Check crowdsale state and calibrate it
153   //
154   function checkCrowdsaleState() internal {
155     if (now > crowdsaleEndDate || tokenSold >= maxTokenSupply) {  // end crowdsale once all tokens are sold or run out of time
156       if (crowdsaleState != state.crowdsaleEnded) {
157         crowdsaleState = state.crowdsaleEnded;
158         CrowdsaleEnded(now);
159       }
160     }
161     else if (now > crowdsaleStartDate) { // move into crowdsale round
162       if (crowdsaleState != state.crowdsaleStarted) {
163         uint256 communityTokenRemaining = maxCommunityCap.sub(communityTokenSold);  // apply any remaining tokens from community round to crowdsale round
164         maxCrowdsaleCap = maxCrowdsaleCap.add(communityTokenRemaining);
165         crowdsaleState = state.crowdsaleStarted;  // change state
166         CrowdsaleStarted(now);
167       }
168     }
169     else if (now > communityRoundStartDate) {
170       if (communityTokenSold < maxCommunityCap) {
171         if (crowdsaleState != state.communityRound) {
172           crowdsaleState = state.communityRound;
173           CommunityRoundStarted(now);
174         }
175       }
176       else {  // automatically start crowdsale when all community round tokens are sold out 
177         if (crowdsaleState != state.crowdsaleStarted) {
178           crowdsaleState = state.crowdsaleStarted;
179           CrowdsaleStarted(now);
180         }
181       }
182     }
183   }
184   //
185   // Issue tokens and return if there is overflow
186   //
187   function calculateCommunity(address _contributor, uint256 _newContribution) internal returns (uint256, uint256) {
188     uint256 communityEthAmount = 0;
189     uint256 communityTokenAmount = 0;
190     uint previousContribution = contributorList[_contributor].contributionAmount;  // retrieve previous contributions
191     // community round ONLY
192     if (crowdsaleState == state.communityRound && 
193         contributorList[_contributor].isCommunityRoundApproved && 
194         previousContribution < maxContribution) {
195         communityEthAmount = _newContribution;
196         uint256 availableEthAmount = maxContribution.sub(previousContribution);                 
197         // limit the contribution ETH amount to the maximum allowed for the community round
198         if (communityEthAmount > availableEthAmount) {
199           communityEthAmount = availableEthAmount;
200         }
201         // compute community tokens without bonus
202         communityTokenAmount = communityEthAmount.mul(ethToTokenConversion);
203         uint256 availableTokenAmount = maxCommunityWithoutBonusCap.sub(communityTokenWithoutBonusSold);
204         // verify community tokens do not go over the max cap for community round
205         if (communityTokenAmount > availableTokenAmount) {
206           // cap the tokens to the max allowed for the community round
207           communityTokenAmount = availableTokenAmount;
208           // recalculate the corresponding ETH amount
209           communityEthAmount = communityTokenAmount.div(ethToTokenConversion);
210         }
211         // track tokens sold during community round
212         communityTokenWithoutBonusSold = communityTokenWithoutBonusSold.add(communityTokenAmount);
213         // compute bonus tokens
214         uint256 bonusTokenAmount = communityTokenAmount.mul(15);
215         bonusTokenAmount = bonusTokenAmount.div(100);
216         // add bonus to community tokens
217         communityTokenAmount = communityTokenAmount.add(bonusTokenAmount);
218         // track tokens sold during community round
219         communityTokenSold = communityTokenSold.add(communityTokenAmount);
220     }
221     return (communityTokenAmount, communityEthAmount);
222   }
223   //
224   // Issue tokens and return if there is overflow
225   //
226   function calculateCrowdsale(uint256 _remainingContribution) internal returns (uint256, uint256) {
227     uint256 crowdsaleEthAmount = _remainingContribution;
228     // compute crowdsale tokens
229     uint256 crowdsaleTokenAmount = crowdsaleEthAmount.mul(ethToTokenConversion);
230     // determine crowdsale tokens remaining
231     uint256 availableTokenAmount = maxCrowdsaleCap.sub(crowdsaleTokenSold);
232     // verify crowdsale tokens do not go over the max cap for crowdsale round
233     if (crowdsaleTokenAmount > availableTokenAmount) {
234       // cap the tokens to the max allowed for the crowdsale round
235       crowdsaleTokenAmount = availableTokenAmount;
236       // recalculate the corresponding ETH amount
237       crowdsaleEthAmount = crowdsaleTokenAmount.div(ethToTokenConversion);
238     }
239     // track tokens sold during crowdsale round
240     crowdsaleTokenSold = crowdsaleTokenSold.add(crowdsaleTokenAmount);
241     return (crowdsaleTokenAmount, crowdsaleEthAmount);
242   }
243   //
244   // Issue tokens and return if there is overflow
245   //
246   function processTransaction(address _contributor, uint256 _amount) internal {
247     uint256 newContribution = _amount;
248     var (communityTokenAmount, communityEthAmount) = calculateCommunity(_contributor, newContribution);
249     // compute remaining ETH amount available for purchasing crowdsale tokens
250     var (crowdsaleTokenAmount, crowdsaleEthAmount) = calculateCrowdsale(newContribution.sub(communityEthAmount));
251     // add up crowdsale + community tokens
252     uint256 tokenAmount = crowdsaleTokenAmount.add(communityTokenAmount);
253     assert(tokenAmount > 0);
254     // Issue new tokens
255     token.mintTokens(_contributor, tokenAmount);                              
256     // log token issuance
257     contributorList[_contributor].tokensIssued = contributorList[_contributor].tokensIssued.add(tokenAmount);                
258     // Add contribution amount to existing contributor
259     newContribution = crowdsaleEthAmount.add(communityEthAmount);
260     contributorList[_contributor].contributionAmount = contributorList[_contributor].contributionAmount.add(newContribution);
261     ethRaisedWithoutCompany = ethRaisedWithoutCompany.add(newContribution);                              // Add contribution amount to ETH raised
262     tokenSold = tokenSold.add(tokenAmount);                                  // track how many tokens are sold
263     // compute any refund if applicable
264     uint256 refundAmount = _amount.sub(newContribution);
265     if (refundAmount > 0) {
266       _contributor.transfer(refundAmount);                                   // refund contributor amount behind the maximum ETH cap
267     }
268     companyAddress.transfer(newContribution);                                // send ETH to company
269   }
270   //
271   // whitelist validated participants.
272   //
273   function WhiteListContributors(address[] _contributorAddresses, bool[] _contributorCommunityRoundApproved) public onlyOwner {
274     require(_contributorAddresses.length == _contributorCommunityRoundApproved.length); // Check if input data is correct
275     for (uint cnt = 0; cnt < _contributorAddresses.length; cnt++) {
276       contributorList[_contributorAddresses[cnt]].isWhiteListed = true;
277       contributorList[_contributorAddresses[cnt]].isCommunityRoundApproved = _contributorCommunityRoundApproved[cnt];
278     }
279   }
280   //
281   // Method is needed for recovering tokens accidentally sent to token address
282   //
283   function salvageTokensFromContract(address _tokenAddress, address _to, uint _amount) public onlyOwner {
284     IERC20Token(_tokenAddress).transfer(_to, _amount);
285   }
286   //
287   // Owner can set multisig address for crowdsale
288   //
289   function setCompanyAddress(address _newAddress) public onlyOwner {
290     require(!treasuryLocked);                              // Check if owner has already claimed tokens
291     companyAddress = _newAddress;
292     treasuryLocked = true;
293   }
294   //
295   // Owner can set token address where mints will happen
296   //
297   function setToken(address _newAddress) public onlyOwner {
298     token = IToken(_newAddress);
299   }
300   function getToken() public constant returns (address) {
301     return address(token);
302   }
303   //
304   // Claims company tokens
305   //
306   function claimCompanyTokens() public onlyOwner {
307     require(!ownerHasClaimedCompanyTokens);                     // Check if owner has already claimed tokens
308     require(companyAddress != 0x0);
309     
310     tokenSold = tokenSold.add(companyTokens); 
311     token.mintTokens(companyAddress, companyTokens);            // Issue company tokens 
312     ownerHasClaimedCompanyTokens = true;                        // Block further mints from this method
313   }
314   //
315   // Claim remaining tokens when crowdsale ends
316   //
317   function claimRemainingTokens() public onlyOwner {
318     checkCrowdsaleState();                                        // Calibrate crowdsale state
319     require(crowdsaleState == state.crowdsaleEnded);              // Check crowdsale has ended
320     require(!ownerHasClaimedTokens);                              // Check if owner has already claimed tokens
321     require(companyAddress != 0x0);
322     uint256 remainingTokens = maxTokenSupply.sub(token.totalSupply());
323     token.mintTokens(companyAddress, remainingTokens);            // Issue tokens to company
324     ownerHasClaimedTokens = true;                                 // Block further mints from this method
325   }
326 }
327 contract StormCrowdsale is Crowdsale {
328     string public officialWebsite;
329     string public officialFacebook;
330     string public officialTelegram;
331     string public officialEmail;
332   function StormCrowdsale() public {
333     officialWebsite = "https://www.stormtoken.com";
334     officialFacebook = "https://www.facebook.com/stormtoken/";
335     officialTelegram = "https://t.me/joinchat/GHTZGQwsy9mZk0KFEEjGtg";
336     officialEmail = "info@stormtoken.com";
337     communityRoundStartDate = 1510063200;                       // Nov 7, 2017 @ 6am PST
338     crowdsaleStartDate = communityRoundStartDate + 24 hours;    // 24 hours later
339     crowdsaleEndDate = communityRoundStartDate + 30 days + 12 hours; // 30 days + 12 hours later: Dec 7th, 2017 @ 6pm PST [1512698400]
340     crowdsaleState = state.pendingStart;
341     ethToTokenConversion = 26950;                 // 1 ETH == 26,950 STORM tokens
342     maxTokenSupply = 10000000000 ether;           // 10,000,000,000
343     companyTokens = 8124766171 ether;             // allocation for company pool, private presale, user pool 
344                                                   // 2,325,649,071 tokens from the company pool are voluntarily locked for 2 years
345     maxCommunityWithoutBonusCap = 945000000 ether;
346     maxCommunityCap = 1086750000 ether;           // 945,000,000 with 15% bonus of 141,750,000
347     maxCrowdsaleCap = 788483829 ether;            // tokens allocated to crowdsale 
348     maxContribution = 100 ether;                  // maximum contribution during community round
349   }
350 }