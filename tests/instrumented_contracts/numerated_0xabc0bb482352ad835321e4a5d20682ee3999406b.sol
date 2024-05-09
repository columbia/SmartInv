1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         if (a == 0) {
14             return 0;
15         }
16         uint256 c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return c;
29     }
30 
31     /**
32     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256) {
43         uint256 c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 /**
50  * @title ERC20Basic
51  * @dev Simpler version of ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/179
53  */
54 contract ERC20Basic {
55     function totalSupply() public view returns (uint256);
56     function balanceOf(address who) public view returns (uint256);
57     function transfer(address to, uint256 value) public returns (bool);
58     event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 
62 /**
63  * @title ERC20 interface
64  * @dev see https://github.com/ethereum/EIPs/issues/20
65  */
66 contract ERC20 is ERC20Basic {
67     function allowance(address owner, address spender) public view returns (uint256);
68     function transferFrom(address from, address to, uint256 value) public returns (bool);
69     function approve(address spender, uint256 value) public returns (bool);
70     event Approval(address indexed owner, address indexed spender, uint256 value);
71 }
72 
73 
74 /**
75  * @title Crowdsale
76  * @dev Crowdsale is a base contract for managing a token crowdsale,
77  * allowing investors to purchase tokens with ether. This contract implements
78  * such functionality in its most fundamental form and can be extended to provide additional
79  * functionality and/or custom behavior.
80  * The external interface represents the basic interface for purchasing tokens, and conform
81  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
82  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
83  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
84  * behavior.
85  */
86 
87 contract BitMilleCrowdsale {
88     using SafeMath for uint256;
89 
90     // The token being sold
91     ERC20 public token;
92 
93     // Address where funds are collected
94     address public wallet;
95 
96     // Amount of wei raised
97     uint256 public weiRaised;
98 
99     uint256 public openingTime;
100     uint256 public closingTime;
101 
102     /**
103      * @dev Reverts if not in crowdsale time range.
104      */
105     modifier onlyWhileOpen {
106         require(now >= openingTime && now <= closingTime);
107         _;
108     }
109 
110     /**
111      * @dev Reverts if not in crowdsale time range.
112      */
113     modifier onlyAfterClosing {
114         require(now > closingTime);
115         _;
116     }
117 
118     /**
119      * Event for token purchase logging
120      * @param purchaser who paid for the tokens
121      * @param beneficiary who got the tokens
122      * @param value weis paid for purchase
123      * @param amount amount of tokens purchased
124      */
125     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
126 
127     function BitMilleCrowdsale() public {
128         wallet = 0x468E9A02c233C3DBb0A1b7F8bd8F8E9f36cbA952;
129         token = ERC20(0xabb3148a39fb97af1295c5ee03e713d6ed54fd92);
130         openingTime = 1520946000;
131         closingTime = 1523970000;
132     }
133 
134     // -----------------------------------------
135     // Crowdsale external interface
136     // -----------------------------------------
137 
138     /**
139      * @dev fallback function ***DO NOT OVERRIDE***
140      */
141     function () external payable {
142         buyTokens(msg.sender);
143     }
144 
145     /**
146      * @dev low level token purchase ***DO NOT OVERRIDE***
147      * @param _beneficiary Address performing the token purchase
148      */
149     function buyTokens(address _beneficiary) public payable {
150 
151         uint256 weiAmount = msg.value;
152         _preValidatePurchase(_beneficiary, weiAmount);
153 
154         // calculate token amount to be created
155         uint256 tokens = _getTokenAmount(weiAmount);
156 
157         // update state
158         weiRaised = weiRaised.add(weiAmount);
159 
160         _processPurchase(_beneficiary, tokens);
161         TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
162 
163         _updatePurchasingState(_beneficiary, weiAmount);
164 
165         _forwardFunds();
166         _postValidatePurchase(_beneficiary, weiAmount);
167     }
168 
169     // -----------------------------------------
170     // Internal interface (extensible)
171     // -----------------------------------------
172 
173     /**
174      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
175      * @param _beneficiary Address performing the token purchase
176      * @param _weiAmount Value in wei involved in the purchase
177      */
178     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
179         require(_beneficiary != address(0));
180         require(_weiAmount != 0);
181     }
182 
183     /**
184      * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
185      * @param _beneficiary Address performing the token purchase
186      * @param _weiAmount Value in wei involved in the purchase
187      */
188     function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
189         // optional override
190     }
191 
192     /**
193      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
194      * @param _beneficiary Address performing the token purchase
195      * @param _tokenAmount Number of tokens to be emitted
196      */
197     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
198         token.transfer(_beneficiary, _tokenAmount);
199     }
200 
201     /**
202      * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
203      * @param _beneficiary Address receiving the tokens
204      * @param _tokenAmount Number of tokens to be purchased
205      */
206     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
207         _deliverTokens(_beneficiary, _tokenAmount);
208     }
209 
210     /**
211      * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
212      * @param _beneficiary Address receiving the tokens
213      * @param _weiAmount Value in wei involved in the purchase
214      */
215     function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
216         // optional override
217     }
218 
219     /**
220      * @dev Override to extend the way in which ether is converted to tokens.
221      * @param _weiAmount Value in wei to be converted into tokens
222      * @return Number of tokens that can be purchased with the specified _weiAmount
223      */
224     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
225 
226         uint256 period = 7 days;
227         uint256 perc;
228 
229         if ((now >= openingTime) && (now < openingTime + period)) {
230             perc = 10;
231         } else if ((now >= openingTime + period) && (now < openingTime + period * 2)) {
232             perc = 9;
233         } else if ((now >= openingTime + period * 2) && (now < openingTime + period * 3)) {
234             perc = 8;
235         } else {
236             perc = 7;
237         }
238 
239         return _weiAmount.mul(perc).div(100000);
240 
241     }
242 
243     /**
244        * @dev Determines how ETH is stored/forwarded on purchases.
245        */
246     function _forwardFunds() internal {
247         wallet.transfer(msg.value);
248     }
249 
250     /**
251      * @dev Checks whether the period in which the crowdsale is open has already elapsed.
252      * @return Whether crowdsale period has elapsed
253      */
254     function hasClosed() public view returns (bool) {
255         return now > closingTime;
256     }
257 
258     function withdrawTokens() public onlyAfterClosing returns (bool) {
259         token.transfer(wallet, token.balanceOf(this));
260         return true;
261     }
262 
263 }