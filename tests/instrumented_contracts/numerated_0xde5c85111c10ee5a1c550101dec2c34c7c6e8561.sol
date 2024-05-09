1 // JHE 20190617
2 // File: openzeppelin-solidity\contracts\math\SafeMath.sol
3 
4 pragma solidity ^0.5.0;
5 
6 /**
7  * @title SafeMath
8  * @dev Unsigned math operations with safety checks that revert on error
9  */
10 library SafeMath {
11     /**
12     * @dev Multiplies two unsigned integers, reverts on overflow.
13     */
14     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
16         // benefit is lost if 'b' is also tested.
17         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18         if (a == 0) {
19             return 0;
20         }
21 
22         uint256 c = a * b;
23         require(c / a == b);
24 
25         return c;
26     }
27 
28     /**
29     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
30     */
31     function div(uint256 a, uint256 b) internal pure returns (uint256) {
32         // Solidity only automatically asserts when dividing by 0
33         require(b > 0);
34         uint256 c = a / b;
35         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
36 
37         return c;
38     }
39 
40     /**
41     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
42     */
43     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44         require(b <= a);
45         uint256 c = a - b;
46 
47         return c;
48     }
49 
50     /**
51     * @dev Adds two unsigned integers, reverts on overflow.
52     */
53     function add(uint256 a, uint256 b) internal pure returns (uint256) {
54         uint256 c = a + b;
55         require(c >= a);
56 
57         return c;
58     }
59 
60     /**
61     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
62     * reverts when dividing by zero.
63     */
64     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
65         require(b != 0);
66         return a % b;
67     }
68 }
69 
70 // File: src\contracts\Token.sol
71 
72 pragma solidity ^0.5.0;
73 
74 
75 contract Token {
76     using SafeMath for uint;
77 
78     // Variables
79     string public name = "Yasuda Takahashi coin";
80     string public symbol = "YATA";
81     uint256 public decimals = 18;
82     uint256 public totalSupply;
83     mapping(address => uint256) public balanceOf;
84     mapping(address => mapping(address => uint256)) public allowance;
85 
86     // Events
87     event Transfer(address indexed from, address indexed to, uint256 value);
88     event Approval(address indexed owner, address indexed spender, uint256 value);
89 
90     constructor() public {
91         // totalSupply = 1000000000000 * (10 ** decimals);  // REAL
92         totalSupply = 1000000 * (10 ** decimals);
93         balanceOf[msg.sender] = totalSupply;
94     }
95 
96     function transfer(address _to, uint256 _value) public returns (bool success) {
97         require(balanceOf[msg.sender] >= _value);
98         _transfer(msg.sender, _to, _value);
99         return true;
100     }
101 
102     function _transfer(address _from, address _to, uint256 _value) internal {
103         require(_to != address(0));
104         balanceOf[_from] = balanceOf[_from].sub(_value);
105         balanceOf[_to] = balanceOf[_to].add(_value);
106         emit Transfer(_from, _to, _value);
107     }
108 
109     function approve(address _spender, uint256 _value) public returns (bool success) {
110         require(_spender != address(0));
111         allowance[msg.sender][_spender] = _value;
112         emit Approval(msg.sender, _spender, _value);
113         return true;
114     }
115 
116     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
117         require(_value <= balanceOf[_from]);
118         require(_value <= allowance[_from][msg.sender]);
119         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
120         _transfer(_from, _to, _value);
121         return true;
122     }
123 }
124 
125 // File: src\contracts\Exchange.sol
126 
127 pragma solidity ^0.5.0;
128 
129 
130 
131 contract Exchange {
132     using SafeMath for uint;
133 
134     // Variables
135     address constant ETHER = address(0); // store Ether in tokens mapping with blank address
136     mapping(address => mapping(address => uint256)) public tokens; // balance of user's token
137     mapping(uint256 => _Order) public orders;
138     uint256 public orderCount;
139     mapping(uint256 => bool) public orderCancelled;
140     mapping(uint256 => bool) public orderFilled;
141 
142     address public owner; // the account that receives exchange fees
143     address internal ercToken;
144     mapping(address => _Fee[]) public feeDistributions;   // tokenAddr=>[_Fee]
145     _Fee[] public feeDetails;
146 
147 
148     // Events
149     event Deposit(address token, address user, uint256 amount, uint256 balance);
150     event Withdraw(address token, address user, uint256 amount, uint256 balance);
151     event Order(
152         uint256 id,
153         address user,
154         address ercToken,
155         address tokenGet,
156         uint256 amountGet,
157         address tokenGive,
158         uint256 amountGive,
159         uint256 timestamp
160     );
161     event Cancel(
162         uint256 id,
163         address user,
164         address ercToken,
165         address tokenGet,
166         uint256 amountGet,
167         address tokenGive,
168         uint256 amountGive,
169         uint256 timestamp
170     );
171     event Trade(
172         uint256 id,
173         address user,
174         address ercToken,
175         address tokenGet,
176         uint256 amountGet,
177         address tokenGive,
178         uint256 amountGive,
179         address userFill,
180         uint256 timestamp
181     );
182 
183     event OwnershipTransferred(
184         address indexed previousOwner,
185         address indexed newOwner
186     );
187 
188     // Structs
189     struct _Order {
190         uint256 id;
191         address user;
192         address tokenGet;
193         uint256 amountGet;
194         address tokenGive;
195         uint256 amountGive;
196         uint256 timestamp;
197     }
198 
199     struct _Fee {
200         uint256 id;
201         string name;
202         address wallet;
203         uint256 percent;
204         bool active;
205     }
206 
207     constructor () public {
208         owner = msg.sender;
209     }    
210 
211     // Fallback: reverts if Ether is sent to this smart contract by mistake
212     function() external {
213         revert();
214     }
215 
216     // Modifier
217     modifier onlyOwner() {
218         require(msg.sender == owner, "owner only");
219         _;
220     }
221 
222     function depositEther() payable public {
223         tokens[ETHER][msg.sender] = tokens[ETHER][msg.sender].add(msg.value);
224         emit Deposit(ETHER, msg.sender, msg.value, tokens[ETHER][msg.sender]);
225     }
226 
227     function withdrawEther(uint _amount) public {
228         require(tokens[ETHER][msg.sender] >= _amount);
229         tokens[ETHER][msg.sender] = tokens[ETHER][msg.sender].sub(_amount);
230         msg.sender.transfer(_amount);
231         emit Withdraw(ETHER, msg.sender, _amount, tokens[ETHER][msg.sender]);
232     }
233 
234     function depositToken(address _token, uint _amount) public {
235         require(_token != ETHER);
236         require(Token(_token).transferFrom(msg.sender, address(this), _amount));
237         tokens[_token][msg.sender] = tokens[_token][msg.sender].add(_amount);
238         emit Deposit(_token, msg.sender, _amount, tokens[_token][msg.sender]);
239     }
240 
241     function withdrawToken(address _token, uint256 _amount) public {
242         require(_token != ETHER);
243         require(tokens[_token][msg.sender] >= _amount);
244         tokens[_token][msg.sender] = tokens[_token][msg.sender].sub(_amount);
245         require(Token(_token).transfer(msg.sender, _amount));
246         emit Withdraw(_token, msg.sender, _amount, tokens[_token][msg.sender]);
247     }
248 
249     function balanceOf(address _token, address _user) public view returns (uint256) {
250         return tokens[_token][_user];
251     }
252 
253     function makeOrder(address _tokenGet, uint256 _amountGet, address _tokenGive, uint256 _amountGive) public {
254         orderCount = orderCount.add(1);
255         orders[orderCount] = _Order(orderCount, msg.sender, _tokenGet, _amountGet, _tokenGive, _amountGive, now);
256 
257         ercToken = _getErcTokenAddress(_tokenGet, _tokenGive);
258 
259         emit Order(orderCount, msg.sender, ercToken, _tokenGet, _amountGet, _tokenGive, _amountGive, now);
260     }
261 
262     function cancelOrder(uint256 _id) public {
263         _Order storage _order = orders[_id];
264         require(address(_order.user) == msg.sender);
265         require(_order.id == _id); // The order must exist
266         orderCancelled[_id] = true;
267 
268         ercToken = _getErcTokenAddress(_order.tokenGet, _order.tokenGive);
269 
270         emit Cancel(_order.id, msg.sender, ercToken, _order.tokenGet, _order.amountGet, _order.tokenGive, _order.amountGive, now);
271     }
272 
273     function fillOrder(uint256 _id) public {
274         require(_id > 0 && _id <= orderCount);
275         require(!orderFilled[_id]);
276         require(!orderCancelled[_id]);
277         _Order storage _order = orders[_id];
278         _trade(_order.id, _order.user, _order.tokenGet, _order.amountGet, _order.tokenGive, _order.amountGive);
279         orderFilled[_order.id] = true;
280     }
281 
282     function _trade(uint256 _orderId, address _user, address _tokenGet, uint256 _amountGet, address _tokenGive, uint256 _amountGive) internal {
283         ercToken = _getErcTokenAddress(_tokenGet, _tokenGive);
284         uint totalFeePercent = getTotalFeePercent (ercToken);
285 
286         uint256 _feeAmount = _amountGet.mul(totalFeePercent).div(100000);  // FEE: 100000 = 100%
287 
288         tokens[_tokenGet][msg.sender] = tokens[_tokenGet][msg.sender].sub(_amountGet.add(_feeAmount));
289         tokens[_tokenGet][_user] = tokens[_tokenGet][_user].add(_amountGet);
290         tokens[_tokenGive][_user] = tokens[_tokenGive][_user].sub(_amountGive);
291         tokens[_tokenGive][msg.sender] = tokens[_tokenGive][msg.sender].add(_amountGive);       
292 
293         // distribute fees
294         uint256 feesCount = getFeeDistributionsCount(ercToken);
295         _Fee[] storage fees = feeDistributions[ercToken];
296 
297         for (uint i = 0; i < feesCount; i++){
298             if (fees[i].active){
299                 uint feeValue = _amountGet.mul(fees[i].percent).div(100000);  // FEE: 100000 = 100%
300                 tokens[_tokenGet][fees[i].wallet] = tokens[_tokenGet][fees[i].wallet].add(feeValue);
301             }
302         }
303 
304 
305         emit Trade(_orderId, _user, ercToken, _tokenGet, _amountGet, _tokenGive, _amountGive, msg.sender, now);
306     }
307 
308     // Transfer
309     function transferOwnership(address _newOwner) public onlyOwner {
310         _transferOwnership(_newOwner);
311     }
312     function _transferOwnership(address _newOwner) internal {
313         require(_newOwner != address(0), "address not valid");
314         emit OwnershipTransferred(owner, _newOwner);
315         owner = _newOwner;
316     }
317 
318 
319     function _getErcTokenAddress(address tokenGet, address tokenGive) internal returns (address){
320         if (tokenGet == ETHER){
321             ercToken = tokenGive;
322         } else {
323             ercToken = tokenGet;
324         }
325         return ercToken;
326     }
327 
328     function getFeeDistributionsCount(address _token) public view returns(uint) {
329         _Fee[] storage fees = feeDistributions[_token];
330         return fees.length;
331     }
332 
333     function getTotalFeePercent (address _ercToken) public view returns (uint){
334         require(_ercToken != address(0), "address not valid");
335         uint256 totalFeePercent = 0;
336         uint256 feesCount = getFeeDistributionsCount(_ercToken);
337         _Fee[] storage fees = feeDistributions[_ercToken];
338 
339         for (uint i = 0; i < feesCount; i++){
340             if (fees[i].active){
341                 totalFeePercent = totalFeePercent.add(fees[i].percent);
342             }
343         }
344 
345         return totalFeePercent;
346     }
347 
348     /*
349     *       FEE: 
350     *              1 = 0.001%
351     *           1000 = 1%
352     *         100000 = 100%
353     */
354     function setFeeDistributions(address _token, address _feeWallet, string memory _name, uint256 _percent) public  onlyOwner {
355         require(_token != address(0), "address not valid");
356         require(_feeWallet != address(0), "address not valid");
357 
358         _Fee[] storage fees = feeDistributions[_token];
359         // uint256 feesCount = fees.length;
360         uint256 feesCount = getFeeDistributionsCount(_token);
361 
362         bool feeExiste = false;
363 
364         uint totalFeePercent = getTotalFeePercent (_token);
365         totalFeePercent = totalFeePercent.add(_percent);
366         require(totalFeePercent <= 100000, "total fee cannot exceed 100");
367 
368         for (uint i = 0; i < feesCount; i++){
369             if (fees[i].wallet == _feeWallet){
370                 fees[i].name    = _name;
371                 fees[i].percent = _percent;
372                 fees[i].active  = true;
373 
374                 feeExiste = true;
375                 break;
376             }
377         }
378 
379         // fee not found => add as new fee
380         if (!feeExiste){
381             _Fee memory fee;
382 
383             fee.id = (feesCount + 1);
384             fee.name = _name;
385             fee.wallet = _feeWallet;
386             fee.percent = _percent;
387             fee.active = true;
388 
389             fees.push(fee);
390         }
391     }
392 
393     function deActivateFeeWallet(address _token, address _feeWallet) public onlyOwner {
394         require(_token != address(0), "address not valid");
395         require(_feeWallet != address(0), "address not valid");
396 
397         _Fee[] storage fees = feeDistributions[_token];
398         uint256 feesCount = getFeeDistributionsCount(_token);
399         for (uint i = 0; i < feesCount; i++){
400             if (fees[i].wallet == _feeWallet){
401                 fees[i].active = false;
402                 break;
403             }
404         }
405     }
406 
407 }