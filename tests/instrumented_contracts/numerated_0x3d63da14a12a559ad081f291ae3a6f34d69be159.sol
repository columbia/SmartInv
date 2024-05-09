1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55   address public owner;
56 
57 
58   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60 
61   /**
62    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63    * account.
64    */
65   constructor() public {
66     owner = msg.sender;
67   }
68 
69   /**
70    * @dev Throws if called by any account other than the owner.
71    */
72   modifier onlyOwner() {
73     require(msg.sender == owner);
74     _;
75   }
76 
77   /**
78    * @dev Allows the current owner to transfer control of the contract to a newOwner.
79    * @param newOwner The address to transfer ownership to.
80    */
81   function transferOwnership(address newOwner) public onlyOwner {
82     require(newOwner != address(0));
83     emit OwnershipTransferred(owner, newOwner);
84     owner = newOwner;
85   }
86 
87 }
88 
89 interface GACR {
90     function transfer(address to, uint256 value) external returns (bool);
91     function mint(address _to, uint256 _amount) external returns (bool);
92     function finishMinting() external returns (bool);
93     function totalSupply() external view returns (uint256);
94     function setTeamAddress(address _teamFund) external;
95     function transferOwnership(address newOwner) external;
96 }
97 
98 contract Crowdsale is Ownable {
99     using SafeMath for uint256;
100 
101     // ICO stage
102     enum CrowdsaleStage { PreICO, ICO }
103     CrowdsaleStage public stage = CrowdsaleStage.PreICO; // By default it's Pre Sale
104 
105     // Token distribution
106     uint256 public constant maxTokens           = 50000000*1e18;    // max of GACR tokens
107     uint256 public constant tokensForSale       = 28500000*1e18;    // 57%
108     uint256 public constant tokensForBounty     = 1500000*1e18;     // 3%
109     uint256 public constant tokensForAdvisors   = 3000000*1e18;     // 6%
110     uint256 public constant tokensForTeam       = 9000000*1e18;     // 18%
111     uint256 public tokensForEcosystem           = 8000000*1e18;     // 16%
112 
113     // Start & End time of Crowdsale
114     uint256 startTime   = 1522494000;   // 2018-03-31T11:00:00
115     uint256 endTime     = 1539169200;   // 2018-10-10T11:00:00
116 
117     // The token being sold
118     GACR public token;
119 
120     // Address where funds are collected
121     address public wallet;
122 
123     // How many token units a buyer gets per wei
124     uint256 public rate;
125 
126     // Amount of wei raised
127     uint256 public weiRaised;
128 
129     // Limit for total contributions
130     uint256 public cap;
131 
132     // KYC for ICO
133     mapping(address => bool) public whitelist;
134 
135     /**
136      * Event for token purchase logging
137      * @param purchaser who paid for the tokens
138      * @param beneficiary who got the tokens
139      * @param value weis paid for purchase
140      * @param amount amount of tokens purchased
141      */
142     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
143 
144     /**
145      * @dev Event for whitelist update
146      * @param purchaser who add to whitelist
147      * @param status of purchased for whitelist
148      */
149     event WhitelistUpdate(address indexed purchaser, bool status);
150 
151     /**
152      * @dev Event for crowdsale finalize
153      */
154     event Finalized();
155 
156     /**
157      * @param _cap ether cap for Crowdsale
158      * @param _rate Number of token units a buyer gets per wei
159      * @param _wallet Address where collected funds will be forwarded to
160      */
161     constructor(uint256 _cap, uint256 _rate, address _wallet, address _token) public {
162         require(_cap > 0);
163         require(_rate > 0);
164         require(_wallet != address(0));
165 
166         cap = _cap;
167         rate = _rate;
168         wallet = _wallet;
169         token = GACR(_token);
170     }
171 
172     /**
173      * @dev Check that sale is on
174      */
175     modifier saleIsOn() {
176         require(now > startTime && now < endTime);
177         _;
178     }
179 
180     //note: only for test
181     //function setNowTime(uint value) public onlyOwner {
182     //    require(value != 0);
183     //    _nowTime = value;
184     //}
185 
186     /**
187      * @dev Buy tokens
188      */
189     function buyTokens(address _beneficiary) saleIsOn public payable {
190         uint256 _weiAmount = msg.value;
191 
192         require(_beneficiary != address(0));
193         require(_weiAmount != 0);
194         require(weiRaised.add(_weiAmount) <= cap);
195 
196         require(stage==CrowdsaleStage.PreICO ||
197                (stage==CrowdsaleStage.ICO && isWhitelisted(_beneficiary)));
198 
199         // calculate token amount to be created
200         uint256 _tokenAmount = _weiAmount.mul(rate);
201 
202         // bonus calculation
203         uint256 bonusTokens = 0;
204         if (stage == CrowdsaleStage.PreICO) {
205             if (_tokenAmount >= 50e18 && _tokenAmount < 3000e18) {
206                 bonusTokens = _tokenAmount.mul(23).div(100);
207             } else if (_tokenAmount >= 3000e18 && _tokenAmount < 15000e18) {
208                 bonusTokens = _tokenAmount.mul(27).div(100);
209             } else if (_tokenAmount >= 15000e18 && _tokenAmount < 30000e18) {
210                 bonusTokens = _tokenAmount.mul(30).div(100);
211             } else if (_tokenAmount >= 30000e18) {
212                 bonusTokens = _tokenAmount.mul(35).div(100);
213             }
214         } else if (stage == CrowdsaleStage.ICO) {
215             uint256 _nowTime = now;
216 
217             if (_nowTime >= 1531486800 && _nowTime < 1532696400) {
218                 bonusTokens = _tokenAmount.mul(18).div(100);
219             } else if (_nowTime >= 1532696400 && _nowTime < 1533906000) {
220                 bonusTokens = _tokenAmount.mul(15).div(100);
221             } else if (_nowTime >= 1533906000 && _nowTime < 1535115600) {
222                 bonusTokens = _tokenAmount.mul(12).div(100);
223             } else if (_nowTime >= 1535115600 && _nowTime < 1536325200) {
224                 bonusTokens = _tokenAmount.mul(9).div(100);
225             } else if (_nowTime >= 1536325200 && _nowTime < 1537534800) {
226                 bonusTokens = _tokenAmount.mul(6).div(100);
227             } else if (_nowTime >= 1537534800 && _nowTime < endTime) {
228                 bonusTokens = _tokenAmount.mul(3).div(100);
229             }
230         }
231         _tokenAmount += bonusTokens;
232 
233         // check limit for sale
234         require(tokensForSale >= (token.totalSupply() + _tokenAmount));
235 
236         // update state
237         weiRaised = weiRaised.add(_weiAmount);
238         token.mint(_beneficiary, _tokenAmount);
239 
240         emit TokenPurchase(msg.sender, _beneficiary, _weiAmount, _tokenAmount);
241 
242         wallet.transfer(_weiAmount);
243     }
244 
245     /**
246      * @dev Payable function
247      */
248     function () external payable {
249         buyTokens(msg.sender);
250     }
251 
252     /**
253      * @dev Change Crowdsale Stage.
254      * Options: PreICO, ICO
255      */
256     function setCrowdsaleStage(uint value) public onlyOwner {
257 
258         CrowdsaleStage _stage;
259 
260         if (uint256(CrowdsaleStage.PreICO) == value) {
261             _stage = CrowdsaleStage.PreICO;
262         } else if (uint256(CrowdsaleStage.ICO) == value) {
263             _stage = CrowdsaleStage.ICO;
264         }
265 
266         stage = _stage;
267     }
268 
269     /**
270      * @dev Set new rate (protection from strong volatility)
271      */
272     function setNewRate(uint _newRate) public onlyOwner {
273         require(_newRate > 0);
274         rate = _newRate;
275     }
276 
277     /**
278      * @dev Set hard cap (protection from strong volatility)
279      */
280     function setHardCap(uint256 _newCap) public onlyOwner {
281         require(_newCap > 0);
282         cap = _newCap;
283     }
284 
285     /**
286      * @dev Set new wallet
287      */
288     function changeWallet(address _newWallet) public onlyOwner {
289         require(_newWallet != address(0));
290         wallet = _newWallet;
291     }
292 
293     /**
294      * @dev Add/Remove to whitelist array of addresses based on boolean status
295      */
296     function updateWhitelist(address[] addresses, bool status) public onlyOwner {
297         for (uint256 i = 0; i < addresses.length; i++) {
298             address contributorAddress = addresses[i];
299             whitelist[contributorAddress] = status;
300             emit WhitelistUpdate(contributorAddress, status);
301         }
302     }
303 
304     /**
305      * @dev Check that address is exist in whitelist
306      */
307     function isWhitelisted(address contributor) public constant returns (bool) {
308         return whitelist[contributor];
309     }
310 
311     /**
312      * @dev Function to mint tokens
313      */
314     function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
315         return token.mint(_to, _amount);
316     }
317 
318     /**
319      * @dev Return ownership to previous owner
320      */
321     function returnOwnership() onlyOwner public returns (bool) {
322         token.transferOwnership(owner);
323     }
324 
325     /**
326      * @dev Finish Crowdsale
327      */
328     function finish(address _bountyFund, address _advisorsFund, address _ecosystemFund, address _teamFund) public onlyOwner {
329         require(_bountyFund != address(0));
330         require(_advisorsFund != address(0));
331         require(_ecosystemFund != address(0));
332         require(_teamFund != address(0));
333 
334         emit Finalized();
335 
336         // unsold tokens to ecosystem (perhaps further they will be burnt)
337         uint256 unsoldTokens = tokensForSale - token.totalSupply();
338         if (unsoldTokens > 0) {
339             tokensForEcosystem = tokensForEcosystem + unsoldTokens;
340         }
341 
342         // distribute
343         token.mint(_bountyFund,tokensForBounty);
344         token.mint(_advisorsFund,tokensForAdvisors);
345         token.mint(_ecosystemFund,tokensForEcosystem);
346         token.mint(_teamFund,tokensForTeam);
347 
348         // finish
349         token.finishMinting();
350 
351         // freeze team tokens
352         token.setTeamAddress(_teamFund);
353     }
354 }