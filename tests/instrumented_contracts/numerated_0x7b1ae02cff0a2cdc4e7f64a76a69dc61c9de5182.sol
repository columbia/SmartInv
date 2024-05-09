1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 /**
44  * @title SafeMath
45  * @dev Math operations with safety checks that throw on error
46  */
47 library SafeMath {
48 
49   /**
50   * @dev Multiplies two numbers, throws on overflow.
51   */
52   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
53     if (a == 0) {
54       return 0;
55     }
56     uint256 c = a * b;
57     assert(c / a == b);
58     return c;
59   }
60 
61   /**
62   * @dev Integer division of two numbers, truncating the quotient.
63   */
64   function div(uint256 a, uint256 b) internal pure returns (uint256) {
65     // assert(b > 0); // Solidity automatically throws when dividing by 0
66     uint256 c = a / b;
67     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
68     return c;
69   }
70 
71   /**
72   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
73   */
74   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75     assert(b <= a);
76     return a - b;
77   }
78 
79   /**
80   * @dev Adds two numbers, throws on overflow.
81   */
82   function add(uint256 a, uint256 b) internal pure returns (uint256) {
83     uint256 c = a + b;
84     assert(c >= a);
85     return c;
86   }
87 }
88 
89 
90 contract TraxionWallet is Ownable {
91     using SafeMath for uint;
92 
93     constructor(){
94         transferOwnership(0xdf4CF47303a3607732f9bF193771F54Bb288a2dF);
95     }
96 
97     // Address where funds are collected
98     address public wallet = 0xbee44A7b93509270dbe90000f7ff31268D8F075e;
99 
100     // how much one token is worth
101     uint public weiPerToken = 0.0007 ether;
102 
103     // should be the same as in the TraxionToken contract
104     uint public decimals = 18;
105 
106     // Minimum investment in wei
107     uint public minInvestment = 1.0 ether;
108 
109     // Maximum investment in wei
110     uint public investmentUpperBounds = 2000 ether;
111 
112     // Hard cap in wei
113     uint public hardcap = 45000 ether;
114 
115     // Amount of wei raised
116     uint public weiRaised = 0;
117 
118     event TokenPurchase(address indexed beneficiary, uint value, uint amount);
119 
120     /** Whitelist an address and set max investment **/
121     mapping (address => bool) public whitelistedAddr;
122     mapping (address => uint) public totalInvestment;
123 
124     // -----------------------------------------
125     // Crowdsale external interface
126     // -----------------------------------------
127 
128     /**
129      * @dev fallback function ***DO NOT OVERRIDE***
130      */
131     function () external payable {
132         buyTokens(msg.sender);
133     }
134 
135     /** @dev whitelist an Address */
136     function whitelistAddress(address[] buyer) external onlyOwner {
137         for (uint i = 0; i < buyer.length; i++) {
138             whitelistedAddr[buyer[i]] = true;
139         }
140     }
141 
142     /** @dev black list an address **/
143     function blacklistAddr(address[] buyer) external onlyOwner {
144         for (uint i = 0; i < buyer.length; i++) {
145             whitelistedAddr[buyer[i]] = false;
146         }
147     }
148 
149     /**
150      * @dev low level token purchase ***DO NOT OVERRIDE***
151      * @param _beneficiary Address performing the token purchase
152      */
153     function buyTokens(address _beneficiary) public payable {
154 
155         uint weiAmount = msg.value;
156         _preValidatePurchase(_beneficiary, weiAmount);
157 
158         // calculate token amount to be created
159         uint tokens = _getTokenAmount(weiAmount);
160 
161         assert(tokens != 0);
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
173     // -----------------------------------------
174     // Internal interface
175     // -----------------------------------------
176 
177     /**
178      * @dev Validation of an incoming purchase. Use require statemens to revert state when conditions are not met. Use super to concatenate validations.
179      * @param _beneficiary Address performing the token purchase
180      * @param _weiAmount Value in wei involved in the purchase
181      */
182     function _preValidatePurchase(address _beneficiary, uint _weiAmount) internal view {
183         require(_beneficiary != address(0));
184         require(_weiAmount != 0);
185 
186         require(_weiAmount >= minInvestment);
187         require(whitelistedAddr[_beneficiary]);
188         require(totalInvestment[_beneficiary].add(_weiAmount) <= investmentUpperBounds);
189         require(weiRaised.add(_weiAmount) <= hardcap);
190     }
191 
192 
193     /**
194      * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
195      * @param _beneficiary Address receiving the tokens
196      * @param _weiAmount Value in wei involved in the purchase
197      */
198     function _updatePurchasingState(address _beneficiary, uint _weiAmount) internal {
199         totalInvestment[_beneficiary] = totalInvestment[_beneficiary].add(_weiAmount);
200     }
201 
202     /**
203      * @dev Override to extend the way in which ether is converted to tokens.
204      * @param _weiAmount Value in wei to be converted into tokens
205      * @return Number of tokens that can be purchased with the specified _weiAmount
206      */
207     function _getTokenAmount(uint _weiAmount) internal view returns (uint) {
208         return _weiAmount.mul(10 ** decimals).div(weiPerToken);
209     }
210 
211     /**
212      * @dev Determines how ETH is stored/forwarded on purchases.
213      */
214     function _forwardFunds() internal {
215         wallet.transfer(msg.value);
216     }
217 }