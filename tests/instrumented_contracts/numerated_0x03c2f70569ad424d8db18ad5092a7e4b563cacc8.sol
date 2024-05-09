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
94     using SafeMath for uint;
95 
96     constructor(){
97         transferOwnership(0xC889dFBDc9C1D0FC3E77e46c3b82A3903b2D919c);
98     }
99 
100     // Address where funds are collected
101     address public wallet = 0xbee44A7b93509270dbe90000f7ff31268D8F075e;
102 
103     // how much one token is worth
104     uint public weiPerToken = 0.0007 ether;
105 
106     // should be the same as in the TraxionToken contract
107     uint public decimals = 18;
108 
109     // Minimum investment in wei
110     uint public minInvestment = 0.4 ether;
111 
112     // Maximum investment in wei
113     uint public investmentUpperBounds = 2000 ether;
114 
115     // Hard cap in wei
116     uint public hardcap = 45000 ether;
117 
118     // Amount of wei raised
119     uint public weiRaised = 0;
120 
121     event TokenPurchase(address indexed beneficiary, uint value, uint amount);
122 
123     /** Whitelist an address and set max investment **/
124     mapping (address => bool) public whitelistedAddr;
125     mapping (address => uint) public totalInvestment;
126 
127     // -----------------------------------------
128     // Crowdsale external interface
129     // -----------------------------------------
130 
131     /**
132      * @dev fallback function ***DO NOT OVERRIDE***
133      */
134     function () external payable {
135         buyTokens(msg.sender);
136     }
137 
138     /** @dev whitelist an Address */
139     function whitelistAddress(address[] buyer) external onlyOwner {
140         for (uint i = 0; i < buyer.length; i++) {
141             whitelistedAddr[buyer[i]] = true;
142         }
143     }
144 
145     /** @dev black list an address **/
146     function blacklistAddr(address[] buyer) external onlyOwner {
147         for (uint i = 0; i < buyer.length; i++) {
148             whitelistedAddr[buyer[i]] = false;
149         }
150     }
151 
152     /**
153      * @dev low level token purchase ***DO NOT OVERRIDE***
154      * @param _beneficiary Address performing the token purchase
155      */
156     function buyTokens(address _beneficiary) public payable {
157 
158         uint weiAmount = msg.value;
159         _preValidatePurchase(_beneficiary, weiAmount);
160 
161         // calculate token amount to be created
162         uint tokens = _getTokenAmount(weiAmount);
163 
164         assert(tokens != 0);
165 
166         // update state
167         weiRaised = weiRaised.add(weiAmount);
168 
169         emit TokenPurchase(msg.sender, weiAmount, tokens);
170 
171         _updatePurchasingState(_beneficiary, weiAmount);
172 
173         _forwardFunds();
174     }
175 
176     // -----------------------------------------
177     // Internal interface
178     // -----------------------------------------
179 
180     /**
181      * @dev Validation of an incoming purchase. Use require statemens to revert state when conditions are not met. Use super to concatenate validations.
182      * @param _beneficiary Address performing the token purchase
183      * @param _weiAmount Value in wei involved in the purchase
184      */
185     function _preValidatePurchase(address _beneficiary, uint _weiAmount) internal view {
186         require(_beneficiary != address(0));
187         require(_weiAmount != 0);
188 
189         require(_weiAmount >= minInvestment);
190         require(whitelistedAddr[_beneficiary]);
191         require(totalInvestment[_beneficiary].add(_weiAmount) <= investmentUpperBounds);
192         require(weiRaised.add(_weiAmount) <= hardcap);
193     }
194 
195 
196     /**
197      * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
198      * @param _beneficiary Address receiving the tokens
199      * @param _weiAmount Value in wei involved in the purchase
200      */
201     function _updatePurchasingState(address _beneficiary, uint _weiAmount) internal {
202         totalInvestment[_beneficiary] = totalInvestment[_beneficiary].add(_weiAmount);
203     }
204 
205     /**
206      * @dev Override to extend the way in which ether is converted to tokens.
207      * @param _weiAmount Value in wei to be converted into tokens
208      * @return Number of tokens that can be purchased with the specified _weiAmount
209      */
210     function _getTokenAmount(uint _weiAmount) internal view returns (uint) {
211         return _weiAmount.mul(10 ** decimals).div(weiPerToken);
212     }
213 
214     /**
215      * @dev Determines how ETH is stored/forwarded on purchases.
216      */
217     function _forwardFunds() internal {
218         wallet.transfer(msg.value);
219     }
220 }