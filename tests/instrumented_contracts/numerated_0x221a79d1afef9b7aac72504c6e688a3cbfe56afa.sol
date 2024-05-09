1 pragma solidity 0.5.8;
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
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17             return 0;
18         }
19 
20         c = a * b;
21         assert(c / a == b);
22         return c;
23     }
24 
25     /**
26     * @dev Integer division of two numbers, truncating the quotient.
27     */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // assert(b > 0); // Solidity automatically throws when dividing by 0
30         // uint256 c = a / b;
31         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32         return a / b;
33     }
34 
35     /**
36     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37     */
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         assert(b <= a);
40         return a - b;
41     }
42 
43     /**
44     * @dev Adds two numbers, throws on overflow.
45     */
46     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47         c = a + b;
48         assert(c >= a);
49         return c;
50     }
51 }
52 
53 /**
54  * @title ERC20 interface
55  * @dev see https://eips.ethereum.org/EIPS/eip-20
56  */
57 interface IERC20 {
58     function transfer(address to, uint256 value) external returns (bool);
59     function approve(address spender, uint256 value) external returns (bool);
60     function transferFrom(address from, address to, uint256 value) external returns (bool);
61     function totalSupply() external view returns (uint256);
62     function balanceOf(address who) external view returns (uint256);
63     function allowance(address owner, address spender) external view returns (uint256);
64 
65     event Transfer(address indexed from, address indexed to, uint256 value);
66     event Approval(address indexed owner, address indexed spender, uint256 value);
67 }
68 
69 
70 /**
71  * @title SafeERC20
72  * @dev Wrappers around ERC20 operations that throw on failure.
73  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
74  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
75  */
76 library SafeERC20 {
77     function safeTransfer(IERC20 token, address to, uint256 value) internal {
78         require(token.transfer(to, value));
79     }
80 
81     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
82         require(token.transferFrom(from, to, value));
83     }
84 
85     function safeApprove(IERC20 token, address spender, uint256 value) internal {
86         require(token.approve(spender, value));
87     }
88 }
89 
90 
91 /**
92  * @title Ownable
93  * @dev The Ownable contract has an owner address, and provides basic authorization control
94  * functions, this simplifies the implementation of "user permissions".
95  */
96 contract Ownable {
97     address payable public owner;
98 
99     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
100 
101     /**
102      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
103      * account.
104      */
105     constructor () internal {
106         owner = msg.sender;
107         emit OwnershipTransferred(address(0), owner);
108     }
109 
110 
111     /**
112      * @dev Throws if called by any account other than the owner.
113      */
114     modifier onlyOwner() {
115         require(isOwner());
116         _;
117     }
118 
119     /**
120      * @return true if `msg.sender` is the owner of the contract.
121      */
122     function isOwner() public view returns (bool) {
123         return msg.sender == owner;
124     }
125 
126     /**
127      * @dev Allows the current owner to transfer control of the contract to a newOwner.
128      * @param newOwner The address to transfer ownership to.
129      */
130     function transferOwnership(address payable newOwner) public onlyOwner {
131         _transferOwnership(newOwner);
132     }
133 
134     /**
135      * @dev Transfers control of the contract to a newOwner.
136      * @param newOwner The address to transfer ownership to.
137      */
138     function _transferOwnership(address payable newOwner) internal {
139         require(newOwner != address(0));
140         emit OwnershipTransferred(owner, newOwner);
141         owner = newOwner;
142     }
143 }
144 
145 contract sellTokens is Ownable {
146     using SafeMath for uint256;
147     using SafeERC20 for IERC20;
148 
149     IERC20 public token;
150 
151 
152     uint256 public rate;
153 
154 
155     constructor(uint256 _rate, address _token) public {
156         require(_token != address(0) );
157 
158         token = IERC20(_token);
159         rate = _rate;
160     }
161 
162 
163     function() payable external {
164         buyTokens();
165     }
166 
167 
168     function buyTokens() payable public {
169         uint256 weiAmount = msg.value;
170         _preValidatePurchase(msg.sender, weiAmount);
171 
172         uint256 tokens = _getTokenAmount(weiAmount);
173 
174         if (tokens > token.balanceOf(address(this))) {
175             tokens = token.balanceOf(address(this));
176 
177             uint price = tokens.div(rate);
178 
179             uint _diff =  weiAmount.sub(price);
180 
181             if (_diff > 0) {
182                 msg.sender.transfer(_diff);
183             }
184         }
185 
186         _processPurchase(msg.sender, tokens);
187     }
188 
189 
190     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal view {
191         require(token.balanceOf(address(this)) > 0);
192         require(_beneficiary != address(0));
193         require(_weiAmount != 0);
194     }
195 
196 
197     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
198         return _weiAmount.mul(rate);
199     }
200 
201 
202     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
203         token.safeTransfer(_beneficiary, _tokenAmount);
204     }
205 
206 
207     function setRate(uint256 _rate) onlyOwner external {
208         rate = _rate;
209     }
210 
211 
212     function withdrawETH() onlyOwner external{
213         owner.transfer(address(this).balance);
214     }
215 
216     
217     function withdrawTokens(address _t) onlyOwner external {
218         IERC20 _token = IERC20(_t);
219         uint balance = _token.balanceOf(address(this));
220         _token.safeTransfer(owner, balance);
221     }
222 
223 }
224 
225 
226 contract ReentrancyGuard {
227 
228     /// @dev counter to allow mutex lock with only one SSTORE operation
229     uint256 private _guardCounter;
230 
231     constructor() internal {
232         // The counter starts at one to prevent changing it from zero to a non-zero
233         // value, which is a more expensive operation.
234         _guardCounter = 1;
235     }
236 
237     /**
238      * @dev Prevents a contract from calling itself, directly or indirectly.
239      * Calling a `nonReentrant` function from another `nonReentrant`
240      * function is not supported. It is possible to prevent this from happening
241      * by making the `nonReentrant` function external, and make it call a
242      * `private` function that does the actual work.
243      */
244     modifier nonReentrant() {
245         _guardCounter += 1;
246         uint256 localCounter = _guardCounter;
247         _;
248         require(localCounter == _guardCounter);
249     }
250 
251 }
252 
253 
254 contract buyTokens is Ownable, ReentrancyGuard {
255     using SafeMath for uint256;
256     using SafeERC20 for IERC20;
257 
258     IERC20 public token;
259 
260     uint256 public rate;
261 
262     constructor(uint256 _rate, address _token) public {
263         require(_token != address(0) );
264 
265         token = IERC20(_token);
266         rate = _rate;
267     }
268 
269 
270     function() external payable{
271     }
272 
273 
274     function sellToken(uint _amount) public {
275         _sellTokens(msg.sender, _amount);
276     }
277 
278 
279     function _sellTokens(address payable _from, uint256 _amount) nonReentrant  internal {
280         require(_amount > 0);
281         token.safeTransferFrom(_from, address(this), _amount);
282 
283         uint256 tokensAmount = _amount;
284 
285         uint weiAmount = tokensAmount.div(rate);
286 
287         if (weiAmount > address(this).balance) {
288             tokensAmount = address(this).balance.mul(rate);
289             weiAmount = address(this).balance;
290 
291             uint _diff =  _amount.sub(tokensAmount);
292 
293             if (_diff > 0) {
294                 token.safeTransfer(_from, _diff);
295             }
296         }
297 
298         _from.transfer(weiAmount);
299     }
300 
301 
302     function receiveApproval(address payable _from, uint256 _value, address _token, bytes memory _extraData) public {
303         require(_token == address(token));
304         require(msg.sender == address(token));
305 
306         _extraData;
307         _sellTokens(_from, _value);
308     }
309 
310 
311     function setRate(uint256 _rate) onlyOwner external {
312         rate = _rate;
313     }
314 
315 
316     function withdrawETH() onlyOwner external{
317         owner.transfer(address(this).balance);
318     }
319 
320 
321     function withdrawTokens(address _t) onlyOwner external {
322         IERC20 _token = IERC20(_t);
323         uint balance = _token.balanceOf(address(this));
324         _token.safeTransfer(owner, balance);
325     }
326 
327 }