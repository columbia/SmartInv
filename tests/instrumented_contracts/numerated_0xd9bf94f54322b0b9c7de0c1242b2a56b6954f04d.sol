1 pragma solidity ^0.4.24;
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
58   event OwnershipRenounced(address indexed previousOwner);
59   event OwnershipTransferred(
60     address indexed previousOwner,
61     address indexed newOwner
62   );
63 
64 
65   /**
66    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
67    * account.
68    */
69   constructor() public {
70     owner = msg.sender;
71   }
72 
73   /**
74    * @dev Throws if called by any account other than the owner.
75    */
76   modifier onlyOwner() {
77     require(msg.sender == owner);
78     _;
79   }
80 
81   /**
82    * @dev Allows the current owner to relinquish control of the contract.
83    * @notice Renouncing to ownership will leave the contract without an owner.
84    * It will not be possible to call the functions with the `onlyOwner`
85    * modifier anymore.
86    */
87   function renounceOwnership() public onlyOwner {
88     emit OwnershipRenounced(owner);
89     owner = address(0);
90   }
91 
92   /**
93    * @dev Allows the current owner to transfer control of the contract to a newOwner.
94    * @param _newOwner The address to transfer ownership to.
95    */
96   function transferOwnership(address _newOwner) public onlyOwner {
97     _transferOwnership(_newOwner);
98   }
99 
100   /**
101    * @dev Transfers control of the contract to a newOwner.
102    * @param _newOwner The address to transfer ownership to.
103    */
104   function _transferOwnership(address _newOwner) internal {
105     require(_newOwner != address(0));
106     emit OwnershipTransferred(owner, _newOwner);
107     owner = _newOwner;
108   }
109 }
110 
111 contract YLKWallet is Ownable {
112     using SafeMath for uint256;
113 
114     // Address where funds are collected
115     address public wallet = 0xd238dB886c3F4981D80270270Db85861B358E004;
116   
117     // How many token units a buyer gets per wei
118     uint256 public rate = 1500;
119 
120     // Minimum investment total in wei
121     uint256 public minInvestment = 2E17;
122 
123     // Maximum investment total in wei
124     uint256 public investmentUpperBounds = 9E21;
125 
126     // Hard cap in wei
127     uint256 public hardcap = 2E23;
128 
129     // Amount of wei raised
130     uint256 public weiRaised;
131 
132     event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
133     event Whitelist(address whiteaddress);
134     event Blacklist(address blackaddress);
135     event ChangeRate(uint256 newRate);
136     event ChangeMin(uint256 newMin);
137     event ChangeMax(uint256 newMax);
138     event ChangeHardCap(uint256 newHardCap);
139 
140     // -----------------------------------------
141     // Crowdsale external interface
142     // -----------------------------------------
143 
144     /**
145      * @dev fallback function ***DO NOT OVERRIDE***
146      */
147     function () external payable {
148         buyTokens(msg.sender);
149     }
150 
151     /** Whitelist an address and set max investment **/
152     mapping (address => bool) public whitelistedAddr;
153     mapping (address => uint256) public totalInvestment;
154   
155     /** @dev whitelist an Address */
156     function whitelistAddress(address[] buyer) external onlyOwner {
157         for (uint i = 0; i < buyer.length; i++) {
158             whitelistedAddr[buyer[i]] = true;
159             address whitelistedbuyer = buyer[i];
160         }
161         emit Whitelist(whitelistedbuyer);
162     }
163   
164     /** @dev black list an address **/
165     function blacklistAddr(address[] buyer) external onlyOwner {
166         for (uint i = 0; i < buyer.length; i++) {
167             whitelistedAddr[buyer[i]] = false;
168             address blacklistedbuyer = buyer[i];
169         }
170         emit Blacklist(blacklistedbuyer);
171     }
172 
173     /**
174      * @dev low level token purchase ***DO NOT OVERRIDE***
175      * @param _beneficiary Address performing the token purchase
176      */
177     function buyTokens(address _beneficiary) public payable {
178 
179         uint256 weiAmount = msg.value;
180         _preValidatePurchase(_beneficiary, weiAmount);
181 
182         // calculate token amount to be created
183         uint256 tokens = _getTokenAmount(weiAmount);
184 
185         // update state
186         weiRaised = weiRaised.add(weiAmount);
187 
188         emit TokenPurchase(msg.sender, weiAmount, tokens);
189 
190         _updatePurchasingState(_beneficiary, weiAmount);
191 
192         _forwardFunds();
193     }
194 
195     /**
196      * @dev Set the rate of how many units a buyer gets per wei
197     */
198     function setRate(uint256 newRate) external onlyOwner {
199         rate = newRate;
200         emit ChangeRate(rate);
201     }
202 
203     /**
204      * @dev Set the minimum investment in wei
205     */
206     function changeMin(uint256 newMin) external onlyOwner {
207         minInvestment = newMin;
208         emit ChangeMin(minInvestment);
209     }
210 
211     /**
212      * @dev Set the maximum investment in wei
213     */
214     function changeMax(uint256 newMax) external onlyOwner {
215         investmentUpperBounds = newMax;
216         emit ChangeMax(investmentUpperBounds);
217     }
218 
219     /**
220      * @dev Set the maximum investment in wei
221     */
222     function changeHardCap(uint256 newHardCap) external onlyOwner {
223         hardcap = newHardCap;
224         emit ChangeHardCap(hardcap);
225     }
226 
227     // -----------------------------------------
228     // Internal interface (extensible)
229     // -----------------------------------------
230 
231     /**
232      * @dev Validation of an incoming purchase. Use require statemens to revert state when conditions are not met. Use super to concatenate validations.
233      * @param _beneficiary Address performing the token purchase
234      * @param _weiAmount Value in wei involved in the purchase
235      */
236     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal view {
237         require(_beneficiary != address(0)); 
238         require(_weiAmount != 0);
239     
240         require(_weiAmount >= minInvestment); // Revert if payment is less than minInvestment
241         require(whitelistedAddr[_beneficiary]); // Revert if investor is not whitelisted
242         require(totalInvestment[_beneficiary].add(_weiAmount) <= investmentUpperBounds); // Revert if the investor already
243         // spent over investmentUpperBounds ETH investment or payment is greater than investmentUpperBounds
244         require(weiRaised.add(_weiAmount) <= hardcap); // Revert if ICO campaign reached Hard Cap
245     }
246 
247 
248     /**
249      * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
250      * @param _beneficiary Address receiving the tokens
251      * @param _weiAmount Value in wei involved in the purchase
252      */
253     function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
254         totalInvestment[_beneficiary] = totalInvestment[_beneficiary].add(_weiAmount);
255     }
256 
257     /**
258      * @dev Override to extend the way in which ether is converted to tokens.
259      * @param _weiAmount Value in wei to be converted into tokens
260      * @return Number of tokens that can be purchased with the specified _weiAmount
261      */
262     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
263         return _weiAmount.mul(rate);
264     }
265 
266     /**
267      * @dev Determines how ETH is stored/forwarded on purchases.
268      */
269     function _forwardFunds() internal {
270         wallet.transfer(msg.value);
271     }
272 }