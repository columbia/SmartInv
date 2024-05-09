1 pragma solidity ^0.4.21;
2 
3 
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 
46 /**
47  * @title SafeMath
48  * @dev Math operations with safety checks that throw on error
49  */
50 library SafeMath {
51 
52   /**
53   * @dev Multiplies two numbers, throws on overflow.
54   */
55   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
56     if (a == 0) {
57       return 0;
58     }
59     uint256 c = a * b;
60     assert(c / a == b);
61     return c;
62   }
63 
64   /**
65   * @dev Integer division of two numbers, truncating the quotient.
66   */
67   function div(uint256 a, uint256 b) internal pure returns (uint256) {
68     // assert(b > 0); // Solidity automatically throws when dividing by 0
69     uint256 c = a / b;
70     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
71     return c;
72   }
73 
74   /**
75   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
76   */
77   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78     assert(b <= a);
79     return a - b;
80   }
81 
82   /**
83   * @dev Adds two numbers, throws on overflow.
84   */
85   function add(uint256 a, uint256 b) internal pure returns (uint256) {
86     uint256 c = a + b;
87     assert(c >= a);
88     return c;
89   }
90 }
91 
92 
93 contract TraxionWallet is Ownable {
94     using SafeMath for uint256;
95 
96 
97     constructor(){
98         transferOwnership(0xC889dFBDc9C1D0FC3E77e46c3b82A3903b2D919c);
99     }
100 
101     // Address where funds are collectedt
102     address public wallet = 0xbee44A7b93509270dbe90000f7ff31268D8F075e;
103   
104     // How many token units a buyer gets per wei
105     uint256 public rate = 2857;
106 
107     // Minimum investment in wei (0.20 ETH)
108     uint256 public minInvestment = 2E17;
109 
110     // Maximum investment in wei (2,000 ETH)
111     uint256 public investmentUpperBounds = 2E21;        
112 
113     // Hard cap in wei (100,000 ETH)
114     uint256 public hardcap = 45E21;
115 
116     // Amount of wei raised
117     uint256 public weiRaised;
118 
119     event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
120   
121     // -----------------------------------------
122     // Crowdsale external interface
123     // -----------------------------------------
124 
125     /**
126      * @dev fallback function ***DO NOT OVERRIDE***
127      */
128     function () external payable {
129         buyTokens(msg.sender);
130     }
131 
132     /** Whitelist an address and set max investment **/
133     mapping (address => bool) public whitelistedAddr;
134     mapping (address => uint256) public totalInvestment;
135   
136     /** @dev whitelist an Address */
137     function whitelistAddress(address[] buyer) external onlyOwner {
138         for (uint i = 0; i < buyer.length; i++) {
139             whitelistedAddr[buyer[i]] = true;
140         }
141     }
142   
143     /** @dev black list an address **/
144     function blacklistAddr(address[] buyer) external onlyOwner {
145         for (uint i = 0; i < buyer.length; i++) {
146             whitelistedAddr[buyer[i]] = false;
147         }
148     }    
149 
150     /**
151      * @dev low level token purchase ***DO NOT OVERRIDE***
152      * @param _beneficiary Address performing the token purchase
153      */
154     function buyTokens(address _beneficiary) public payable {
155 
156         uint256 weiAmount = msg.value;
157         _preValidatePurchase(_beneficiary, weiAmount);
158 
159         // calculate token amount to be created
160         uint256 tokens = _getTokenAmount(weiAmount);
161 
162         // update state
163         weiRaised = weiRaised.add(weiAmount);
164 
165         emit TokenPurchase(msg.sender, weiAmount, tokens);
166 
167         _updatePurchasingState(_beneficiary, weiAmount);
168 
169         _forwardFunds();
170     }
171 
172     // -----------------------------------------
173     // Internal interface (extensible)
174     // -----------------------------------------
175 
176     /**
177      * @dev Validation of an incoming purchase. Use require statemens to revert state when conditions are not met. Use super to concatenate validations.
178      * @param _beneficiary Address performing the token purchase
179      * @param _weiAmount Value in wei involved in the purchase
180      */
181     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal view {
182         require(_beneficiary != address(0)); 
183         require(_weiAmount != 0);
184     
185         require(_weiAmount > minInvestment); // Revert if payment is less than 0.40 ETH
186         require(whitelistedAddr[_beneficiary]); // Revert if investor is not whitelisted
187         require(totalInvestment[_beneficiary].add(_weiAmount) <= investmentUpperBounds); // Revert if the investor already spent over 2k ETH investment or payment is greater than 2k ETH
188         require(weiRaised.add(_weiAmount) <= hardcap); // Revert if ICO campaign reached Hard Cap
189     }
190 
191 
192     /**
193      * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
194      * @param _beneficiary Address receiving the tokens
195      * @param _weiAmount Value in wei involved in the purchase
196      */
197     function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
198         totalInvestment[_beneficiary] = totalInvestment[_beneficiary].add(_weiAmount);
199     }
200 
201     /**
202      * @dev Override to extend the way in which ether is converted to tokens.
203      * @param _weiAmount Value in wei to be converted into tokens
204      * @return Number of tokens that can be purchased with the specified _weiAmount
205      */
206     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
207         return _weiAmount.mul(rate);
208     }
209 
210     /**
211      * @dev Determines how ETH is stored/forwarded on purchases.
212      */
213     function _forwardFunds() internal {
214         wallet.transfer(msg.value);
215     }
216 }