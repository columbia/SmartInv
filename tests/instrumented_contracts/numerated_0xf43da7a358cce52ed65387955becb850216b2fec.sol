1 pragma solidity ^0.5.2;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two unsigned integers, reverts on overflow.
10      */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27      */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48      * @dev Adds two unsigned integers, reverts on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59      * reverts when dividing by zero.
60      */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 
68 pragma solidity ^0.5.2;
69 
70 /**
71  * @title Helps contracts guard against reentrancy attacks.
72  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
73  * @dev If you mark a function `nonReentrant`, you should also
74  * mark it `external`.
75  */
76 contract ReentrancyGuard {
77     /// @dev counter to allow mutex lock with only one SSTORE operation
78     uint256 private _guardCounter;
79 
80     constructor () internal {
81         // The counter starts at one to prevent changing it from zero to a non-zero
82         // value, which is a more expensive operation.
83         _guardCounter = 1;
84     }
85 
86     /**
87      * @dev Prevents a contract from calling itself, directly or indirectly.
88      * Calling a `nonReentrant` function from another `nonReentrant`
89      * function is not supported. It is possible to prevent this from happening
90      * by making the `nonReentrant` function external, and make it call a
91      * `private` function that does the actual work.
92      */
93     modifier nonReentrant() {
94         _guardCounter += 1;
95         uint256 localCounter = _guardCounter;
96         _;
97         require(localCounter == _guardCounter);
98     }
99 }
100 
101 pragma solidity ^0.5.2;
102 
103 
104 contract ERC20Interface {
105     function totalSupply() public view returns (uint);
106     function balanceOf(address tokenOwner) public view returns (uint balance);
107     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
108     function transfer(address to, uint tokens) public returns (bool success);
109     function approve(address spender, uint tokens) public returns (bool success);
110     function transferFrom(address from, address to, uint tokens) public returns (bool success);
111 
112     event Transfer(address indexed from, address indexed to, uint tokens);
113     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
114 }
115 
116 
117 
118 contract Crowdsale is ReentrancyGuard {
119     using SafeMath for uint256;
120     
121     address public manager;
122     address payable public returnWallet;
123     uint256 public etherEuroRate;
124     uint256 public safetyLimit = 300000*10**18;
125     ERC20Interface private _token;
126     uint256 public minWeiValue = 10**17;
127 
128     constructor (
129             uint256 rate, 
130             address payable wallet, 
131             address contractManager, 
132             ERC20Interface token
133                 ) public {
134         require(rate > 0);
135         require(wallet != address(0));
136         require(contractManager != address(0));
137         require(address(token) != address(0));
138 
139         manager = contractManager;
140         etherEuroRate = rate;
141         returnWallet = wallet;
142         _token = token;
143     }
144     
145     modifier restricted(){
146         require(msg.sender == manager );
147         _;
148     }
149 
150     
151     function buyTokens(address beneficiary) public nonReentrant payable {
152         uint256 weiAmount = msg.value;
153         _preValidatePurchase(beneficiary, weiAmount);
154         uint256 tokens = (weiAmount.div(2)).mul(etherEuroRate);
155         require(tokens>0);
156         require(weiAmount>minWeiValue);
157         _forwardFunds();
158         _token.transfer(beneficiary,tokens);
159     }
160 
161     function () external payable {
162         buyTokens(msg.sender);
163     }
164 
165     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
166         require(beneficiary != address(0));
167         require(weiAmount != 0);
168         require(weiAmount < safetyLimit);
169     }
170 
171     function setManager(address newManager) public restricted {
172         require(msg.sender == manager);
173         require(newManager != address(0));
174         manager=newManager;
175     }
176     
177     function updateRate(uint256 newEtherEuroRate) public restricted{
178         require(newEtherEuroRate > 0);
179         etherEuroRate=newEtherEuroRate;
180     }
181     
182     /**
183      * set the limiti in ether
184     */
185     function setSafeLimit(uint256 limitEther) public restricted{
186         require(limitEther>0);
187         safetyLimit=limitEther.mul(10**18);
188     }
189     
190     function getNumberOfWeiTokenPerWei(uint256 weiToConvert) public view returns(uint256){
191         require(weiToConvert > 0);
192         require(weiToConvert < safetyLimit);
193         return weiToConvert.mul(etherEuroRate.div(2));
194     }
195     
196     function setMinWeiValue(uint256 minWei) public restricted{
197         require(minWei > 10);
198         minWeiValue = minWei;
199     }
200     
201     function _forwardFunds() internal {
202         returnWallet.transfer(msg.value);
203     }
204     
205     function setReturnWallet(address payable _wallet) public restricted{
206         require(_wallet != address(0));
207         returnWallet=_wallet;
208     }
209     
210     function reclaimToken() public restricted{
211         require(manager!=address(0));
212         _token.transfer(manager,_token.balanceOf(address(this)));
213     }
214     
215     function getContractBalance() public view returns(uint256){
216         return (_token.balanceOf(address(this)));
217     }
218     
219     function getCurrentTokenContract() public view returns(address){
220         return address(_token);
221     }
222     
223 }