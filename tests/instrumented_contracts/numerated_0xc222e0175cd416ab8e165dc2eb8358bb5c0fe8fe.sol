1 pragma solidity ^0.4.25;
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
89 contract BONAWallet is Ownable {
90     using SafeMath for uint256;
91 
92     // Address where funds are collected
93     address public wallet = 0xeb949f18f5FF3c5175baA7EDc3412225a1d6A02C;
94   
95     // How many token units a buyer gets per wei
96     uint256 public rate = 1100;
97 
98     // Minimum investment total in wei
99     uint256 public minInvestment = 2E17;
100 
101     // Maximum investment total in wei
102     uint256 public investmentUpperBounds = 2E21;
103 
104     // Hard cap in wei
105     uint256 public hardcap = 1E23;
106 
107     // Amount of wei raised
108     uint256 public weiRaised;
109 
110     event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
111     event Whitelist(address whiteaddress);
112     event Blacklist(address blackaddress);
113     event ChangeRate(uint256 newRate);
114     event ChangeMin(uint256 newMin);
115     event ChangeMax(uint256 newMax);
116     event ChangeHardCap(uint256 newHardCap);
117     
118     // -----------------------------------------
119     // Crowdsale external interface
120     // -----------------------------------------
121 
122     /**
123      * @dev fallback function ***DO NOT OVERRIDE***
124      */
125     function () external payable {
126         buyTokens(msg.sender);
127     }
128 
129     /** Whitelist an address and set max investment **/
130     mapping (address => bool) public whitelistedAddr;
131     mapping (address => uint256) public totalInvestment;
132   
133     /** @dev whitelist an Address */
134     function whitelistAddress(address[] buyer) external onlyOwner {
135         for (uint i = 0; i < buyer.length; i++) {
136             whitelistedAddr[buyer[i]] = true;
137             address whitelistedbuyer = buyer[i];
138         }
139         emit Whitelist(whitelistedbuyer);
140     }
141   
142     /** @dev black list an address **/
143     function blacklistAddr(address[] buyer) external onlyOwner {
144         for (uint i = 0; i < buyer.length; i++) {
145             whitelistedAddr[buyer[i]] = false;
146             address blacklistedbuyer = buyer[i];
147         }
148         emit Blacklist(blacklistedbuyer);
149     }
150 
151     /**
152      * @dev low level token purchase ***DO NOT OVERRIDE***
153      * @param _beneficiary Address performing the token purchase
154      */
155     function buyTokens(address _beneficiary) public payable {
156 
157         uint256 weiAmount = msg.value;
158         _preValidatePurchase(_beneficiary, weiAmount);
159 
160         // calculate token amount to be created
161         uint256 tokens = _getTokenAmount(weiAmount);
162 
163         // update state
164         weiRaised = weiRaised.add(weiAmount);
165 
166         emit TokenPurchase(msg.sender, weiAmount, tokens);
167 
168         _updatePurchasingState(_beneficiary, weiAmount);
169 
170         _forwardFunds();
171     }
172 
173     /**
174      * @dev Set the rate of how many units a buyer gets per wei
175     */
176     function setRate(uint256 newRate) external onlyOwner {
177         rate = newRate;
178         emit ChangeRate(rate);
179     }
180 
181     /**
182      * @dev Set the minimum investment in wei
183     */
184     function changeMin(uint256 newMin) external onlyOwner {
185         minInvestment = newMin;
186         emit ChangeMin(minInvestment);
187     }
188 
189     /**
190      * @dev Set the maximum investment in wei
191     */
192     function changeMax(uint256 newMax) external onlyOwner {
193         investmentUpperBounds = newMax;
194         emit ChangeMax(investmentUpperBounds);
195     }
196 
197     /**
198      * @dev Set the maximum investment in wei
199     */
200     function changeHardCap(uint256 newHardCap) external onlyOwner {
201         hardcap = newHardCap;
202         emit ChangeHardCap(hardcap);
203     }
204 
205     // -----------------------------------------
206     // Internal interface (extensible)
207     // -----------------------------------------
208 
209     /**
210      * @dev Validation of an incoming purchase. Use require statemens to revert state when conditions are not met. Use super to concatenate validations.
211      * @param _beneficiary Address performing the token purchase
212      * @param _weiAmount Value in wei involved in the purchase
213      */
214     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal view {
215         require(_beneficiary != address(0)); 
216         require(_weiAmount != 0);
217     
218         require(_weiAmount >= minInvestment); // Revert if payment is less than minInvestment
219         require(whitelistedAddr[_beneficiary]); // Revert if investor is not whitelisted
220         require(totalInvestment[_beneficiary].add(_weiAmount) <= investmentUpperBounds); // Revert if the investor already
221         // spent over investmentUpperBounds ETH investment or payment is greater than investmentUpperBounds
222         require(weiRaised.add(_weiAmount) <= hardcap); // Revert if ICO campaign reached Hard Cap
223     }
224 
225 
226     /**
227      * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
228      * @param _beneficiary Address receiving the tokens
229      * @param _weiAmount Value in wei involved in the purchase
230      */
231     function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
232         totalInvestment[_beneficiary] = totalInvestment[_beneficiary].add(_weiAmount);
233     }
234 
235     /**
236      * @dev Override to extend the way in which ether is converted to tokens.
237      * @param _weiAmount Value in wei to be converted into tokens
238      * @return Number of tokens that can be purchased with the specified _weiAmount
239      */
240     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
241         return _weiAmount.mul(rate);
242     }
243 
244     /**
245      * @dev Determines how ETH is stored/forwarded on purchases.
246      */
247     function _forwardFunds() internal {
248         wallet.transfer(msg.value);
249     }
250 }