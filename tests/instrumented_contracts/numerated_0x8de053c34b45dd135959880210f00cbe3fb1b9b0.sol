1 pragma solidity 0.4.21;
2 
3 
4 library SafeMath {
5 
6     /**
7     * @dev Multiplies two numbers, throws on overflow.
8     */
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         if (a == 0) {
11             return 0;
12         }
13         uint256 c = a * b;
14         assert(c / a == b);
15         return c;
16     }
17 
18     /**
19     * @dev Integer division of two numbers, truncating the quotient.
20     */
21     function div(uint256 a, uint256 b) internal pure returns (uint256) {
22         // assert(b > 0); // Solidity automatically throws when dividing by 0
23         uint256 c = a / b;
24         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25         return c;
26     }
27 
28     /**
29     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
30     */
31     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32         assert(b <= a);
33         return a - b;
34     }
35 
36     /**
37     * @dev Adds two numbers, throws on overflow.
38     */
39     function add(uint256 a, uint256 b) internal pure returns (uint256) {
40         uint256 c = a + b;
41         assert(c >= a);
42         return c;
43     }
44 }
45 
46 
47 /**
48  * @title Ownable
49  * @dev The Ownable contract has an owner address, and provides basic authorization control
50  * functions, this simplifies the implementation of "user permissions".
51  */
52 contract Ownable {
53     address public owner;
54 
55 
56     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
57 
58 
59     /**
60      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
61      * account.
62      */
63     function Ownable() public {
64         owner = msg.sender;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(msg.sender == owner);
72         _;
73     }
74 
75     /**
76      * @dev Allows the current owner to transfer control of the contract to a newOwner.
77      * @param newOwner The address to transfer ownership to.
78      */
79     function transferOwnership(address newOwner) public onlyOwner {
80         require(newOwner != address(0));
81         emit OwnershipTransferred(owner, newOwner);
82         owner = newOwner;
83     }
84 
85 }
86 
87 
88 
89 contract CryptoRoboticsToken {
90     uint256 public totalSupply;
91     function balanceOf(address who) public view returns (uint256);
92     function transfer(address to, uint256 value) public returns (bool);
93     event Transfer(address indexed from, address indexed to, uint256 value);
94     function allowance(address owner, address spender) public view returns (uint256);
95     function transferFrom(address from, address to, uint256 value) public returns (bool);
96     function approve(address spender, uint256 value) public returns (bool);
97     event Approval(address indexed owner, address indexed spender, uint256 value);
98     function burn(uint256 value) public;
99 }
100 
101 
102 contract ICOContract {
103     function setTokenCountFromPreIco(uint256 value) public;
104 }
105 
106 
107 contract Crowdsale is Ownable {
108     using SafeMath for uint256;
109 
110     // The token being sold
111     CryptoRoboticsToken public token;
112     ICOContract ico;
113 
114     // Address where funds are collected
115     address public wallet;
116 
117     // Amount of wei raised
118     uint256 public weiRaised;
119 
120     uint256 public openingTime;
121     uint256 public closingTime;
122 
123     bool public isFinalized = false;
124 
125     uint public tokenPriceInWei = 105 szabo;
126 
127     uint256 public cap = 1008 ether;
128 
129 
130     event Finalized();
131     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
132 
133     modifier onlyWhileOpen {
134         require(now >= openingTime && now <= closingTime);
135         _;
136     }
137 
138 
139     function Crowdsale(CryptoRoboticsToken _token) public
140     {
141         require(_token != address(0));
142 
143 
144         wallet = 0xeb6BD1436046b22Eb03f6b7c215A8537C9bed868;
145         token = _token;
146         openingTime = now;
147         closingTime = 1526601600;
148     }
149 
150 
151     function () external payable {
152         buyTokens(msg.sender);
153     }
154 
155 
156     function buyTokens(address _beneficiary) public payable {
157 
158         uint256 weiAmount = msg.value;
159         _preValidatePurchase(_beneficiary, weiAmount);
160 
161         // calculate token amount to be created
162         uint256 tokens = _getTokenAmount(weiAmount);
163 
164         uint _diff =  weiAmount % tokenPriceInWei;
165 
166         if (_diff > 0) {
167             msg.sender.transfer(_diff);
168             weiAmount = weiAmount.sub(_diff);
169         }
170 
171         // update state
172         weiRaised = weiRaised.add(weiAmount);
173 
174         _processPurchase(_beneficiary, tokens);
175         emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
176 
177 
178         _forwardFunds(weiAmount);
179     }
180 
181 
182     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal view onlyWhileOpen {
183         require(_beneficiary != address(0));
184         require(weiRaised.add(_weiAmount) <= cap);
185         require(_weiAmount >= 20 ether);
186     }
187 
188 
189     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
190         token.transfer(_beneficiary, _tokenAmount);
191     }
192 
193 
194     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
195         _tokenAmount = _tokenAmount * 1 ether;
196         _deliverTokens(_beneficiary, _tokenAmount);
197     }
198 
199 
200     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
201         uint _tokens = _weiAmount.div(tokenPriceInWei);
202         return _tokens;
203     }
204 
205 
206     function _forwardFunds(uint _weiAmount) internal {
207         wallet.transfer(_weiAmount);
208     }
209 
210 
211     function hasClosed() public view returns (bool) {
212         return now > closingTime;
213     }
214 
215     function capReached() public view returns (bool) {
216         return weiRaised >= cap;
217     }
218 
219     /**
220      * @dev Must be called after crowdsale ends, to do some extra finalization
221      * work. Calls the contract's finalization function.
222      */
223     function finalize() onlyOwner public {
224         require(!isFinalized);
225         require(hasClosed() || capReached());
226 
227         finalization();
228         emit Finalized();
229 
230         isFinalized = true;
231     }
232 
233 
234     function setIco(address _ico) onlyOwner public {
235         ico = ICOContract(_ico);
236     }
237 
238 
239     function finalization() internal {
240         uint _balance = token.balanceOf(this);
241         if (_balance > 0) {
242             token.transfer(address(ico), _balance);
243             ico.setTokenCountFromPreIco(_balance);
244         }
245     }
246 }