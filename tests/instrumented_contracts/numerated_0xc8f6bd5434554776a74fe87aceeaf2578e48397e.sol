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
89 contract WestrendWallet is Ownable {
90     using SafeMath for uint256;
91 
92     // Address where funds are collected
93     address public wallet = 0xe3de74151CbDFB47d214F7E6Bcb8F5EfDCf99636;
94   
95     // How many token units a buyer gets per wei
96     uint256 public rate = 1100;
97 
98     // Minimum investment in wei (.20 ETH)
99     uint256 public minInvestment = 2E17;
100 
101     // Maximum investment in wei  (2,000 ETH)
102     uint256 public investmentUpperBounds = 2E21;
103 
104     // Hard cap in wei (100,000 ETH)
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
116     // -----------------------------------------
117     // Crowdsale external interface
118     // -----------------------------------------
119 
120     /**
121      * @dev fallback function ***DO NOT OVERRIDE***
122      */
123     function () external payable {
124         buyTokens(msg.sender);
125     }
126 
127     /** Whitelist an address and set max investment **/
128     mapping (address => bool) public whitelistedAddr;
129     mapping (address => uint256) public totalInvestment;
130   
131     /** @dev whitelist an Address */
132     function whitelistAddress(address[] buyer) external onlyOwner {
133         for (uint i = 0; i < buyer.length; i++) {
134             whitelistedAddr[buyer[i]] = true;
135             address whitelistedbuyer = buyer[i];
136         }
137         emit Whitelist(whitelistedbuyer);
138     }
139   
140     /** @dev black list an address **/
141     function blacklistAddr(address[] buyer) external onlyOwner {
142         for (uint i = 0; i < buyer.length; i++) {
143             whitelistedAddr[buyer[i]] = false;
144             address blacklistedbuyer = buyer[i];
145         }
146         emit Blacklist(blacklistedbuyer);
147     }
148 
149     /**
150      * @dev low level token purchase ***DO NOT OVERRIDE***
151      * @param _beneficiary Address performing the token purchase
152      */
153     function buyTokens(address _beneficiary) public payable {
154 
155         uint256 weiAmount = msg.value;
156         _preValidatePurchase(_beneficiary, weiAmount);
157 
158         // calculate token amount to be created
159         uint256 tokens = _getTokenAmount(weiAmount);
160 
161         // update state
162         weiRaised = weiRaised.add(weiAmount);
163 
164         emit TokenPurchase(msg.sender, weiAmount, tokens);
165 
166         _updatePurchasingState(_beneficiary, weiAmount);
167 
168         _forwardFunds();
169     }
170 
171     /**
172      * @dev Set the rate of how many units a buyer gets per wei
173     */
174     function setRate(uint256 newRate) external onlyOwner {
175         rate = newRate;
176         emit ChangeRate(rate);
177     }
178 
179     /**
180      * @dev Set the minimum investment in wei
181     */
182     function changeMin(uint256 newMin) external onlyOwner {
183         minInvestment = newMin;
184         emit ChangeMin(minInvestment);
185     }
186 
187     /**
188      * @dev Set the maximum investment in wei
189     */
190     function changeMax(uint256 newMax) external onlyOwner {
191         investmentUpperBounds = newMax;
192         emit ChangeMax(investmentUpperBounds);
193     }
194 
195     // -----------------------------------------
196     // Internal interface (extensible)
197     // -----------------------------------------
198 
199     /**
200      * @dev Validation of an incoming purchase. Use require statemens to revert state when conditions are not met. Use super to concatenate validations.
201      * @param _beneficiary Address performing the token purchase
202      * @param _weiAmount Value in wei involved in the purchase
203      */
204     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal view {
205         require(_beneficiary != address(0)); 
206         require(_weiAmount != 0);
207     
208         require(_weiAmount > minInvestment); // Revert if payment is less than 0.40 ETH
209         require(whitelistedAddr[_beneficiary]); // Revert if investor is not whitelisted
210         require(totalInvestment[_beneficiary].add(_weiAmount) <= investmentUpperBounds); // Revert if the investor already
211         // spent over 2k ETH investment or payment is greater than 2k ETH
212         require(weiRaised.add(_weiAmount) <= hardcap); // Revert if ICO campaign reached Hard Cap
213     }
214 
215 
216     /**
217      * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
218      * @param _beneficiary Address receiving the tokens
219      * @param _weiAmount Value in wei involved in the purchase
220      */
221     function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
222         totalInvestment[_beneficiary] = totalInvestment[_beneficiary].add(_weiAmount);
223     }
224 
225     /**
226      * @dev Override to extend the way in which ether is converted to tokens.
227      * @param _weiAmount Value in wei to be converted into tokens
228      * @return Number of tokens that can be purchased with the specified _weiAmount
229      */
230     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
231         return _weiAmount.mul(rate);
232     }
233 
234     /**
235      * @dev Determines how ETH is stored/forwarded on purchases.
236      */
237     function _forwardFunds() internal {
238         wallet.transfer(msg.value);
239     }
240 }