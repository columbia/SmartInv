1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract Token {
34     function issue(address _recipient, uint256 _value) returns (bool success) {}
35     function issueAtIco(address _recipient, uint256 _value, uint256 _icoNumber) returns (bool success) {}
36     function totalSupply() constant returns (uint256 supply) {}
37     function unlock() returns (bool success) {}
38     function transferOwnership(address _newOwner) {}
39 }
40 
41 
42 contract CryptoCopyCrowdsale {
43 
44     using SafeMath for uint256;
45 
46     // Crowdsale addresses
47     address public creator;
48     address public buyBackFund;
49     address public bountyPool;
50     address public advisoryPool;
51 
52     uint256 public minAcceptedEthAmount = 100 finney; // 0.1 ether
53 
54     // ICOs specification
55     uint256 public maxTotalSupply = 1000000 * 10**8; // 1 mil. tokens
56     uint256 public tokensForInvestors = 900000 * 10**8; // 900.000 tokens
57     uint256 public tokensForBounty = 50000 * 10**8; // 50.000 tokens
58     uint256 public tokensForAdvisory = 50000 * 10**8; // 50.000 tokens
59 
60     uint256 public totalTokenIssued; // Total of issued tokens
61 
62     uint256 public bonusFirstTwoDaysPeriod = 2 days;
63     uint256 public bonusFirstWeekPeriod = 9 days;
64     uint256 public bonusSecondWeekPeriod = 16 days;
65     uint256 public bonusThirdWeekPeriod = 23 days;
66     uint256 public bonusFourthWeekPeriod = 30 days;
67     
68     uint256 public bonusFirstTwoDays = 20;
69     uint256 public bonusFirstWeek = 15;
70     uint256 public bonusSecondWeek = 10;
71     uint256 public bonusThirdWeek = 5;
72     uint256 public bonusFourthWeek = 5;
73     uint256 public bonusSubscription = 5;
74     
75     uint256 public bonusOver3ETH = 10;
76     uint256 public bonusOver10ETH = 20;
77     uint256 public bonusOver30ETH = 30;
78     uint256 public bonusOver100ETH = 40;
79 
80     // Balances
81     mapping (address => uint256) balancesETH;
82     mapping (address => uint256) balancesETHWithBonuses;
83     mapping (address => uint256) balancesETHForSubscriptionBonus;
84     mapping (address => uint256) tokenBalances;
85     
86     uint256 public totalInvested;
87     uint256 public totalInvestedWithBonuses;
88 
89     uint256 public hardCap = 100000 ether; // 100k ethers
90     uint256 public softCap = 175 ether; // 175 ethers
91     
92     enum Stages {
93         Countdown,
94         Ico,
95         Ended
96     }
97 
98     Stages public stage = Stages.Countdown;
99 
100     // Crowdsale times
101     uint public start;
102     uint public end;
103 
104     // CryptoCopy token
105     Token public CryptoCopyToken;
106     
107     function setToken(address newToken) public onlyCreator {
108         CryptoCopyToken = Token(newToken);
109     }
110     
111     function returnOwnershipOfToken() public onlyCreator {
112         CryptoCopyToken.transferOwnership(creator);
113     }
114     
115     /**
116      * Change creator address
117      */
118     function setCreator(address _creator) public onlyCreator {
119         creator = _creator;
120     }
121 
122     /**
123      * Throw if at stage other than current stage
124      *
125      * @param _stage expected stage to test for
126      */
127     modifier atStage(Stages _stage) {
128         updateState();
129 
130         if (stage != _stage) {
131             throw;
132         }
133         _;
134     }
135 
136 
137     /**
138      * Throw if sender is not creator
139      */
140     modifier onlyCreator() {
141         if (creator != msg.sender) {
142             throw;
143         }
144         _;
145     }
146 
147     /**
148      * Get ethereum balance of `_investor`
149      *
150      * @param _investor The address from which the balance will be retrieved
151      * @return The balance
152      */
153     function balanceOf(address _investor) constant returns (uint256 balance) {
154         return balancesETH[_investor];
155     }
156 
157     /**
158      * Construct
159      *
160      * @param _tokenAddress Address of the token
161      * @param _start Start of ICO
162      * @param _end End of ICO
163      */
164     function CryptoCopyCrowdsale(address _tokenAddress, uint256 _start, uint256 _end) {
165         CryptoCopyToken = Token(_tokenAddress);
166         creator = msg.sender;
167         start = _start;
168         end = _end;
169     }
170     
171     /**
172      * Withdraw for bounty and advisory pools
173      */
174     function withdrawBountyAndAdvisory() onlyCreator {
175         if (!CryptoCopyToken.issue(bountyPool, tokensForBounty)) {
176             throw;
177         }
178         
179         if (!CryptoCopyToken.issue(advisoryPool, tokensForAdvisory)) {
180             throw;
181         }
182     }
183     
184     /**
185      * Set up end date
186      */
187     function setEnd(uint256 _end) onlyCreator {
188         end = _end;
189     }
190     
191     /**
192      * Set up bounty pool
193      *
194      * @param _bountyPool Bounty pool address
195      */
196     function setBountyPool(address _bountyPool) onlyCreator {
197         bountyPool = _bountyPool;
198     }
199     
200     /**
201      * Set up advisory pool
202      *
203      * @param _advisoryPool Bounty pool address
204      */
205     function setAdvisoryPool(address _advisoryPool) onlyCreator {
206         advisoryPool = _advisoryPool;
207     }
208     
209     /**
210      * Set buy back fund address
211      *
212      * @param _buyBackFund Bay back fund address
213      */
214     function setBuyBackFund(address _buyBackFund) onlyCreator {
215         buyBackFund = _buyBackFund;
216     }
217 
218     /**
219      * Update crowd sale stage based on current time
220      */
221     function updateState() {
222         uint256 timeBehind = now - start;
223 
224         if (totalInvested >= hardCap || now > end) {
225             stage = Stages.Ended;
226             return;
227         }
228         
229         if (now < start) {
230             stage = Stages.Countdown;
231             return;
232         }
233 
234         stage = Stages.Ico;
235     }
236 
237     /**
238      * Release tokens after the ICO
239      */
240     function releaseTokens(address investorAddress) onlyCreator {
241         if (stage != Stages.Ended) {
242             return;
243         }
244         
245         uint256 tokensToBeReleased = tokensForInvestors * balancesETHWithBonuses[investorAddress] / totalInvestedWithBonuses;
246 
247         if (tokenBalances[investorAddress] == tokensToBeReleased) {
248             return;
249         }
250         
251         if (!CryptoCopyToken.issue(investorAddress, tokensToBeReleased - tokenBalances[investorAddress])) {
252             throw;
253         }
254         
255         tokenBalances[investorAddress] = tokensToBeReleased;
256     }
257 
258     /**
259      * Transfer raised amount to the company address
260      */
261     function withdraw() onlyCreator {
262         uint256 ethBalance = this.balance;
263         
264         if (stage != Stages.Ended) {
265             throw;
266         }
267         
268         if (!creator.send(ethBalance)) {
269             throw;
270         }
271     }
272     
273 
274     /**
275      * Add additional bonus for subscribed investors
276      *
277      * @param investorAddress Address of investor
278      */
279     function addSubscriptionBonus(address investorAddress) onlyCreator {
280         uint256 alreadyIncludedSubscriptionBonus = balancesETHForSubscriptionBonus[investorAddress];
281         
282         uint256 subscriptionBonus = balancesETH[investorAddress] * bonusSubscription / 100;
283         
284         balancesETHForSubscriptionBonus[investorAddress] = subscriptionBonus;
285         
286         totalInvestedWithBonuses = totalInvestedWithBonuses.add(subscriptionBonus - alreadyIncludedSubscriptionBonus);
287         balancesETHWithBonuses[investorAddress] = balancesETHWithBonuses[investorAddress].add(subscriptionBonus - alreadyIncludedSubscriptionBonus);
288     }
289 
290     /**
291      * Receives Eth
292      */
293     function () payable atStage(Stages.Ico) {
294         uint256 receivedEth = msg.value;
295         uint256 totalBonuses = 0;
296 
297         if (receivedEth < minAcceptedEthAmount) {
298             throw;
299         }
300         
301         if (now < start + bonusFirstTwoDaysPeriod) {
302             totalBonuses += bonusFirstTwoDays;
303         } else if (now < start + bonusFirstWeekPeriod) {
304             totalBonuses += bonusFirstWeek;
305         } else if (now < start + bonusSecondWeekPeriod) {
306             totalBonuses += bonusSecondWeek;
307         } else if (now < start + bonusThirdWeekPeriod) {
308             totalBonuses += bonusThirdWeek;
309         } else if (now < start + bonusFourthWeekPeriod) {
310             totalBonuses += bonusFourthWeek;
311         }
312         
313         if (receivedEth >= 100 ether) {
314             totalBonuses += bonusOver100ETH;
315         } else if (receivedEth >= 30 ether) {
316             totalBonuses += bonusOver30ETH;
317         } else if (receivedEth >= 10 ether) {
318             totalBonuses += bonusOver10ETH;
319         } else if (receivedEth >= 3 ether) {
320             totalBonuses += bonusOver3ETH;
321         }
322         
323         uint256 receivedEthWithBonuses = receivedEth + (receivedEth * totalBonuses / 100);
324         
325         totalInvested = totalInvested.add(receivedEth);
326         totalInvestedWithBonuses = totalInvestedWithBonuses.add(receivedEthWithBonuses);
327         balancesETH[msg.sender] = balancesETH[msg.sender].add(receivedEth);
328         balancesETHWithBonuses[msg.sender] = balancesETHWithBonuses[msg.sender].add(receivedEthWithBonuses);
329     }
330 }