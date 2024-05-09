1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10     /**
11     * @dev Multiplies two numbers, throws on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14         if (a == 0) {
15             return 0;
16         }
17 
18         c = a * b;
19         assert(c / a == b);
20         return c;
21     }
22 
23     /**
24     * @dev Integer division of two numbers, truncating the quotient.
25     */
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {
27         return a / b;
28     }
29 
30     /**
31     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32     */
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         assert(b <= a);
35         return a - b;
36     }
37 
38     /**
39     * @dev Adds two numbers, throws on overflow.
40     */
41     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
42         c = a + b;
43         assert(c >= a);
44         return c;
45     }
46 
47 }
48 
49 
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, ownership can be transferred in 2 steps (transfer-accept).
54  */
55 contract Ownable {
56     address public owner;
57     address public pendingOwner;
58     bool isOwnershipTransferActive = false;
59 
60     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62     /**
63      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64      * account.
65      */
66     constructor() public {
67         owner = msg.sender;
68     }
69 
70     /**
71      * @dev Throws if called by any account other than the owner.
72      */
73     modifier onlyOwner() {
74         require(msg.sender == owner, "Only owner can do that.");
75         _;
76     }
77 
78     /**
79      * @dev Modifier throws if called by any account other than the pendingOwner.
80      */
81     modifier onlyPendingOwner() {
82         require(isOwnershipTransferActive);
83         require(msg.sender == pendingOwner, "Only nominated pretender can do that.");
84         _;
85     }
86 
87     /**
88      * @dev Allows the current owner to set the pendingOwner address.
89      * @param _newOwner The address to transfer ownership to.
90      */
91     function transferOwnership(address _newOwner) public onlyOwner {
92         pendingOwner = _newOwner;
93         isOwnershipTransferActive = true;
94     }
95 
96     /**
97      * @dev Allows the pendingOwner address to finalize the transfer.
98      */
99     function acceptOwnership() public onlyPendingOwner {
100         emit OwnershipTransferred(owner, pendingOwner);
101         owner = pendingOwner;
102         isOwnershipTransferActive = false;
103         pendingOwner = address(0);
104     }
105 }
106 
107 
108 /**
109  * @title ERC20 Token Standard Interface
110  * @dev see https://github.com/ethereum/EIPs/issues/20
111  */
112 contract ERC20 {
113     function totalSupply() public view returns (uint256);
114     function balanceOf(address _owner) public view returns (uint256);
115     function transfer(address _to, uint256 _value) public returns (bool);
116 
117     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
118     function approve(address _spender, uint256 _value) public returns (bool);
119     function allowance(address _owner, address _spender) public view returns (uint256);
120 
121     event Transfer(address indexed _from, address indexed _to, uint256 _value);
122     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
123 }
124 
125 
126 /**
127  * @title Aurum Services Presale Contract
128  * @author Igor Dëmin
129  * @dev Presale accepting contributions only within a time frame and capped to specific amount.
130  */
131 contract AurumPresale is Ownable {
132     using SafeMath for uint256;
133 
134     // How many minimal token units a buyer gets per wei, presale rate (1:5000 x 1.5)
135     uint256 public constant RATE = 7500;
136 
137     // presale cap, 7.5M tokens to be sold
138     uint256 public constant CAP = 1000 ether;
139 
140     // The token being sold
141     ERC20 public token;
142 
143     // Crowdsale opening time
144     uint256 public openingTime;
145 
146     // Crowdsale closing time
147     uint256 public closingTime;
148 
149     // Amount of wei raised
150     uint256 public totalWeiRaised;
151 
152     // address which can be specified by owner for service purposes
153     address controller;
154     bool isControllerSpecified = false;
155 
156     /**
157      * Event for token purchase logging
158      * @param purchaser who paid for the tokens
159      * @param beneficiary who got the tokens
160      * @param value wei paid for purchase
161      * @param amount amount of tokens purchased
162      */
163     event TokenPurchase(
164         address indexed purchaser,
165         address indexed beneficiary,
166         uint256 value,
167         uint256 amount
168     );
169 
170     constructor(ERC20 _token, uint256 _openingTime, uint256 _closingTime) public {
171         require(_token != address(0));
172         require(_openingTime >= now);
173         require(_closingTime > _openingTime);
174 
175         token = _token;
176         openingTime = _openingTime;
177         closingTime = _closingTime;
178 
179         require(token.balanceOf(msg.sender) >= RATE.mul(CAP));
180     }
181 
182 
183     modifier onlyWhileActive() {
184         require(isActive(), "Presale has closed.");
185         _;
186     }
187 
188     /**
189      * @dev Sets minimal participation threshold
190      */
191     modifier minThreshold(uint256 _amount) {
192         require(msg.value >= _amount, "Not enough Ether provided.");
193         _;
194     }
195 
196     modifier onlyController() {
197         require(isControllerSpecified);
198         require(msg.sender == controller, "Only controller can do that.");
199         _;
200     }
201 
202     /**
203      * @dev fallback function
204      */
205     function () external payable {
206         buyTokens(msg.sender);
207     }
208 
209     /**
210      * @dev Reclaim all ERC20 compatible tokens
211      * @param _token ERC20 The address of the token contract
212      */
213     function reclaimToken(ERC20 _token) external onlyOwner {
214         require(!isActive());
215         uint256 tokenBalance = _token.balanceOf(this);
216         require(_token.transfer(owner, tokenBalance));
217     }
218 
219     /**
220      * @dev Transfer all Ether held by the contract to the owner.
221      */
222     function reclaimEther() external onlyOwner {
223         owner.transfer(address(this).balance);
224     }
225 
226     /**
227      * @dev Specifies service account
228      */
229     function specifyController(address _controller) external onlyOwner {
230         controller = _controller;
231         isControllerSpecified = true;
232     }
233 
234     /**
235      * @dev Controller can mark the receipt of funds attracted in other cryptocurrencies,
236      * in equivalent of ether.
237      */
238     function markFunding(address _beneficiary, uint256 _weiRaised)
239         external
240         onlyController
241         onlyWhileActive
242     {
243         require(_beneficiary != address(0));
244         require(_weiRaised >= 20 finney);
245 
246         enroll(controller, _beneficiary, _weiRaised);
247     }
248 
249     /**
250      * @dev Checks whether the period in which the pre-sale is open has already elapsed and
251      * whether pre-sale cap has been reached.
252      */
253     function isActive() public view returns (bool) {
254         return now >= openingTime && now <= closingTime && !capReached();
255     }
256 
257     /**
258      * @dev Token purchase
259      * @param _beneficiary Address performing the token purchase
260      */
261     function buyTokens(address _beneficiary)
262         public
263         payable
264         onlyWhileActive
265         minThreshold(20 finney)
266     {
267         require(_beneficiary != address(0));
268 
269         uint256 newWeiRaised = msg.value;
270         uint256 newTotalWeiRaised = totalWeiRaised.add(newWeiRaised);
271 
272         uint256 refundValue = 0;
273         if (newTotalWeiRaised > CAP) {
274             newWeiRaised = CAP.sub(totalWeiRaised);
275             refundValue = newTotalWeiRaised.sub(CAP);
276         }
277 
278         enroll(msg.sender, _beneficiary, newWeiRaised);
279 
280         if (refundValue > 0) {
281             msg.sender.transfer(refundValue);
282         }
283     }
284 
285     /**
286      * @dev Checks whether the cap has been reached.
287      * @return Whether the cap was reached
288      */
289     function capReached() internal view returns (bool) {
290         return totalWeiRaised >= CAP;
291     }
292 
293     /**
294      * @dev Calculate amount of tokens.
295      * @param _weiAmount Value in wei to be converted into tokens
296      * @return Number of tokens that can be purchased with the specified _weiAmount
297      */
298     function getTokenAmount(uint256 _weiAmount) internal pure returns (uint256) {
299         return _weiAmount.mul(RATE);
300     }
301 
302     /**
303      * @dev common logic for enroll funds
304      */
305     function enroll(address _purchaser, address _beneficiary, uint256 _value) private {
306         // update sale progress
307         totalWeiRaised = totalWeiRaised.add(_value);
308 
309         // calculate token amount
310         uint256 tokenAmount = getTokenAmount(_value);
311 
312         require(token.transfer(_beneficiary, tokenAmount));
313         emit TokenPurchase(_purchaser, _beneficiary, _value, tokenAmount);
314     }
315 
316 }