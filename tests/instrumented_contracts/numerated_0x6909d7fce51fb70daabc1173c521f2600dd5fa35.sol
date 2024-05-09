1 pragma solidity ^0.4.23;
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
89 contract TraxionWallet is Ownable {
90     using SafeMath for uint256;
91 
92     // Address where funds are collectedt
93     address public wallet = 0x6163286bA933d8a007c02DB6b0fd5A08629d23f8;
94   
95     // How many token units a buyer gets per wei
96     uint256 public rate = 1000;
97 
98     // Minimum investment in wei (0.40 ETH)
99     uint256 public minInvestment = 4E17;
100 
101     // Invesstment upper bound per investor in wei (2,000 ETH)
102     uint256 public investmentUpperBounds = 2E21;        
103 
104     // Hard cap in wei (100,000 ETH)
105     uint256 public hardcap = 1E23;    
106 
107     // Amount of wei raised
108     uint256 public weiRaised;
109 
110     event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
111   
112     // -----------------------------------------
113     // Crowdsale external interface
114     // -----------------------------------------
115 
116     /**
117      * @dev fallback function ***DO NOT OVERRIDE***
118      */
119     function () external payable {
120         buyTokens(msg.sender);
121     }
122 
123     /** Whitelist an address and set max investment **/
124     mapping (address => bool) public whitelistedAddr;
125     mapping (address => uint256) public totalInvestment;
126   
127     /** @dev whitelist an Address */
128     function whitelistAddress(address[] buyer) external onlyOwner {
129         for (uint i = 0; i < buyer.length; i++) {
130             whitelistedAddr[buyer[i]] = true;
131         }
132     }
133   
134     /** @dev black list an address **/
135     function blacklistAddr(address[] buyer) external onlyOwner {
136         for (uint i = 0; i < buyer.length; i++) {
137             whitelistedAddr[buyer[i]] = false;
138         }
139     }    
140 
141     /**
142      * @dev low level token purchase ***DO NOT OVERRIDE***
143      * @param _beneficiary Address performing the token purchase
144      */
145     function buyTokens(address _beneficiary) public payable {
146 
147         uint256 weiAmount = msg.value;
148         _preValidatePurchase(_beneficiary, weiAmount);
149 
150         // calculate token amount to be created
151         uint256 tokens = _getTokenAmount(weiAmount);
152 
153         // update state
154         weiRaised = weiRaised.add(weiAmount);
155 
156         emit TokenPurchase(msg.sender, weiAmount, tokens);
157 
158         _updatePurchasingState(_beneficiary, weiAmount);
159 
160         _forwardFunds();
161     }
162 
163     // -----------------------------------------
164     // Internal interface (extensible)
165     // -----------------------------------------
166 
167     /**
168      * @dev Validation of an incoming purchase. Use require statemens to revert state when conditions are not met. Use super to concatenate validations.
169      * @param _beneficiary Address performing the token purchase
170      * @param _weiAmount Value in wei involved in the purchase
171      */
172     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal view {
173         require(_beneficiary != address(0)); 
174         require(_weiAmount != 0);
175     
176         require(_weiAmount > minInvestment); // Revert if payment is less than 0.40 ETH
177         require(whitelistedAddr[_beneficiary]); // Revert if investor is not whitelisted
178         require(totalInvestment[_beneficiary].add(_weiAmount) <= investmentUpperBounds); // Revert if the investor already spent over 2k ETH investment or payment is greater than 2k ETH
179         require(weiRaised.add(_weiAmount) <= hardcap); // Revert if ICO campaign reached Hard Cap
180     }
181 
182 
183     /**
184      * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
185      * @param _beneficiary Address receiving the tokens
186      * @param _weiAmount Value in wei involved in the purchase
187      */
188     function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
189         totalInvestment[_beneficiary] = totalInvestment[_beneficiary].add(_weiAmount);
190     }
191 
192     /**
193      * @dev Override to extend the way in which ether is converted to tokens.
194      * @param _weiAmount Value in wei to be converted into tokens
195      * @return Number of tokens that can be purchased with the specified _weiAmount
196      */
197     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
198         return _weiAmount.mul(rate);
199     }
200 
201     /**
202      * @dev Determines how ETH is stored/forwarded on purchases.
203      */
204     function _forwardFunds() internal {
205         wallet.transfer(msg.value);
206     }
207 }
208 //Github: @AlvinVeroy