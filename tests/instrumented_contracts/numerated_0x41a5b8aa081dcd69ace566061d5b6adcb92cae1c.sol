1 pragma solidity ^0.4.23;
2 
3 // Authored by Radek Ostrowski and Maciek Zielinski
4 // http://startonchain.com
5 // And Alex George
6 // https://dexbrokerage.com
7 
8 pragma solidity ^0.4.23;
9 
10 
11 /**
12  * @title SafeMath
13  * @dev Math operations with safety checks that throw on error
14  */
15 library SafeMath {
16 
17   /**
18   * @dev Multiplies two numbers, throws on overflow.
19   */
20   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21     if (a == 0) {
22       return 0;
23     }
24     uint256 c = a * b;
25     require(c / a == b);
26     return c;
27   }
28 
29   /**
30   * @dev Integer division of two numbers, truncating the quotient.
31   */
32   function div(uint256 a, uint256 b) internal pure returns (uint256) {
33     // require(b > 0); // Solidity automatically throws when dividing by 0
34     uint256 c = a / b;
35     // require(a == b * c + a % b); // There is no case in which this doesn't hold
36     return c;
37   }
38 
39   /**
40   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
41   */
42   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43     require(b <= a);
44     return a - b;
45   }
46 
47   /**
48   * @dev Adds two numbers, throws on overflow.
49   */
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     require(c >= a);
53     return c;
54   }
55 
56   /**
57   * @dev a to power of b, throws on overflow.
58   */
59   function pow(uint256 a, uint256 b) internal pure returns (uint256) {
60     uint256 c = a ** b;
61     require(c >= a);
62     return c;
63   }
64 
65 }
66 
67 /**
68  * @title Ownable
69  * @dev The Ownable contract has an owner address, and provides basic authorization control
70  * functions, this simplifies the implementation of "user permissions".
71  */
72 contract Ownable {
73   address public owner;
74 
75 
76   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
77 
78 
79   /**
80    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
81    * account.
82    */
83   constructor() public {
84     owner = msg.sender;
85   }
86 
87   /**
88    * @dev Throws if called by any account other than the owner.
89    */
90   modifier onlyOwner() {
91     require(msg.sender == owner);
92     _;
93   }
94 
95   /**
96    * @dev Allows the current owner to transfer control of the contract to a newOwner.
97    * @param newOwner The address to transfer ownership to.
98    */
99   function transferOwnership(address newOwner) public onlyOwner {
100     require(newOwner != address(0));
101     emit OwnershipTransferred(owner, newOwner);
102     owner = newOwner;
103   }
104 
105 }
106 
107 /**
108  * @title ERC20Basic
109  * @dev Simpler version of ERC20 interface
110  * @dev see https://github.com/ethereum/EIPs/issues/179
111  */
112 contract ERC20Basic {
113   function totalSupply() public view returns (uint256);
114   function balanceOf(address who) public view returns (uint256);
115   function transfer(address to, uint256 value) public returns (bool);
116   event Transfer(address indexed from, address indexed to, uint256 value);
117 }
118 
119 /**
120  * @title ERC20 interface
121  * @dev see https://github.com/ethereum/EIPs/issues/20
122  */
123 contract ERC20 is ERC20Basic {
124   function allowance(address owner, address spender) public view returns (uint256);
125   function transferFrom(address from, address to, uint256 value) public returns (bool);
126   function approve(address spender, uint256 value) public returns (bool);
127   event Approval(address indexed owner, address indexed spender, uint256 value);
128 }
129 
130 contract DexBrokerage is Ownable {
131   using SafeMath for uint256;
132 
133   address public feeAccount;
134   uint256 public makerFee;
135   uint256 public takerFee;
136   uint256 public inactivityReleasePeriod;
137   mapping (address => bool) public approvedCurrencyTokens;
138   mapping (address => uint256) public invalidOrder;
139   mapping (address => mapping (address => uint256)) public tokens;
140   mapping (address => bool) public admins;
141   mapping (address => uint256) public lastActiveTransaction;
142   mapping (bytes32 => uint256) public orderFills;
143   mapping (bytes32 => bool) public withdrawn;
144 
145   event Trade(address tokenBuy, uint256 amountBuy, address tokenSell, uint256 amountSell, address maker, address taker);
146   event Deposit(address token, address user, uint256 amount, uint256 balance);
147   event Withdraw(address token, address user, uint256 amount, uint256 balance);
148   event MakerFeeUpdated(uint256 oldFee, uint256 newFee);
149   event TakerFeeUpdated(uint256 oldFee, uint256 newFee);
150 
151   modifier onlyAdmin {
152     require(msg.sender == owner || admins[msg.sender]);
153     _;
154   }
155 
156   constructor(uint256 _makerFee, uint256 _takerFee , address _feeAccount, uint256 _inactivityReleasePeriod) public {
157     owner = msg.sender;
158     makerFee = _makerFee;
159     takerFee = _takerFee;
160     feeAccount = _feeAccount;
161     inactivityReleasePeriod = _inactivityReleasePeriod;
162   }
163 
164   function approveCurrencyTokenAddress(address currencyTokenAddress, bool isApproved) onlyAdmin public {
165     approvedCurrencyTokens[currencyTokenAddress] = isApproved;
166   }
167 
168   function invalidateOrdersBefore(address user, uint256 nonce) onlyAdmin public {
169     require(nonce >= invalidOrder[user]);
170     invalidOrder[user] = nonce;
171   }
172 
173   function setMakerFee(uint256 _makerFee) onlyAdmin public {
174     //market maker fee will never be more than 1%
175     uint256 oldFee = makerFee;
176     if (_makerFee > 10 finney) {
177       _makerFee = 10 finney;
178     }
179     require(makerFee != _makerFee);
180     makerFee = _makerFee;
181     emit MakerFeeUpdated(oldFee, makerFee);
182   }
183 
184   function setTakerFee(uint256 _takerFee) onlyAdmin public {
185     //market taker fee will never be more than 2%
186     uint256 oldFee = takerFee;
187     if (_takerFee > 20 finney) {
188       _takerFee = 20 finney;
189     }
190     require(takerFee != _takerFee);
191     takerFee = _takerFee;
192     emit TakerFeeUpdated(oldFee, takerFee);
193   }
194 
195   function setInactivityReleasePeriod(uint256 expire) onlyAdmin public returns (bool) {
196     require(expire <= 50000);
197     inactivityReleasePeriod = expire;
198     return true;
199   }
200 
201   function setAdmin(address admin, bool isAdmin) onlyOwner public {
202     admins[admin] = isAdmin;
203   }
204 
205   function depositToken(address token, uint256 amount) public {
206     receiveTokenDeposit(token, msg.sender, amount);
207   }
208 
209   function receiveTokenDeposit(address token, address from, uint256 amount) public {
210     tokens[token][from] = tokens[token][from].add(amount);
211     lastActiveTransaction[from] = block.number;
212     require(ERC20(token).transferFrom(from, address(this), amount));
213     emit Deposit(token, from, amount, tokens[token][from]);
214   }
215 
216   function deposit() payable public {
217     tokens[address(0)][msg.sender] = tokens[address(0)][msg.sender].add(msg.value);
218     lastActiveTransaction[msg.sender] = block.number;
219     emit Deposit(address(0), msg.sender, msg.value, tokens[address(0)][msg.sender]);
220   }
221 
222   function withdraw(address token, uint256 amount) public returns (bool) {
223     require(block.number.sub(lastActiveTransaction[msg.sender]) >= inactivityReleasePeriod);
224     require(tokens[token][msg.sender] >= amount);
225     tokens[token][msg.sender] = tokens[token][msg.sender].sub(amount);
226     if (token == address(0)) {
227       msg.sender.transfer(amount);
228     } else {
229       require(ERC20(token).transfer(msg.sender, amount));
230     }
231     emit Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
232     return true;
233   }
234 
235   function adminWithdraw(address token, uint256 amount, address user, uint256 nonce, uint8 v, bytes32 r, bytes32 s, uint256 gasCost) onlyAdmin public returns (bool) {
236     //gasCost will never be more than 30 finney
237     if (gasCost > 30 finney) gasCost = 30 finney;
238 
239     if(token == address(0)){
240       require(tokens[address(0)][user] >= gasCost.add(amount));
241     } else {
242       require(tokens[address(0)][user] >= gasCost);
243       require(tokens[token][user] >= amount);
244     }
245 
246     bytes32 hash = keccak256(address(this), token, amount, user, nonce);
247     require(!withdrawn[hash]);
248     withdrawn[hash] = true;
249     require(ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash), v, r, s) == user);
250 
251     if(token == address(0)){
252       tokens[address(0)][user] = tokens[address(0)][user].sub(gasCost.add(amount));
253       tokens[address(0)][feeAccount] = tokens[address(0)][feeAccount].add(gasCost);
254       user.transfer(amount);
255     } else {
256       tokens[token][user] = tokens[token][user].sub(amount);
257       tokens[address(0)][user] = tokens[address(0)][user].sub(gasCost);
258       tokens[address(0)][feeAccount] = tokens[address(0)][feeAccount].add(gasCost);
259       require(ERC20(token).transfer(user, amount));
260     }
261     lastActiveTransaction[user] = block.number;
262     emit Withdraw(token, user, amount, tokens[token][user]);
263     return true;
264   }
265 
266   function balanceOf(address token, address user) view public returns (uint256) {
267     return tokens[token][user];
268   }
269 
270     /* tradeValues
271        [0] amountBuy
272        [1] amountSell
273        [2] makerNonce
274        [3] takerAmountBuy
275        [4] takerAmountSell
276        [5] takerExpires
277        [6] takerNonce
278        [7] makerAmountBuy
279        [8] makerAmountSell
280        [9] makerExpires
281        [10] gasCost
282      tradeAddressses
283        [0] tokenBuy
284        [1] tokenSell
285        [2] maker
286        [3] taker
287      */
288 
289 
290   function trade(uint256[11] tradeValues, address[4] tradeAddresses, uint8[2] v, bytes32[4] rs) onlyAdmin public returns (bool) {
291     uint256 price = tradeValues[0].mul(1 ether).div(tradeValues[1]);
292     require(price >= tradeValues[7].mul(1 ether).div(tradeValues[8]).sub(100000 wei));
293     require(price <= tradeValues[4].mul(1 ether).div(tradeValues[3]).add(100000 wei));
294     require(block.number < tradeValues[9]);
295     require(block.number < tradeValues[5]);
296     require(invalidOrder[tradeAddresses[2]] <= tradeValues[2]);
297     require(invalidOrder[tradeAddresses[3]] <= tradeValues[6]);
298     bytes32 orderHash = keccak256(address(this), tradeAddresses[0], tradeValues[7], tradeAddresses[1], tradeValues[8], tradeValues[9], tradeValues[2], tradeAddresses[2]);
299     bytes32 tradeHash = keccak256(address(this), tradeAddresses[1], tradeValues[3], tradeAddresses[0], tradeValues[4], tradeValues[5], tradeValues[6], tradeAddresses[3]);
300     require(ecrecover(keccak256("\x19Ethereum Signed Message:\n32", orderHash), v[0], rs[0], rs[1]) == tradeAddresses[2]);
301     require(ecrecover(keccak256("\x19Ethereum Signed Message:\n32", tradeHash), v[1], rs[2], rs[3]) == tradeAddresses[3]);
302     require(tokens[tradeAddresses[0]][tradeAddresses[3]] >= tradeValues[0]);
303     require(tokens[tradeAddresses[1]][tradeAddresses[2]] >= tradeValues[1]);
304     if ((tradeAddresses[0] == address(0) || tradeAddresses[1] == address(0)) && tradeValues[10] > 30 finney) tradeValues[10] = 30 finney;
305     if ((approvedCurrencyTokens[tradeAddresses[0]] == true || approvedCurrencyTokens[tradeAddresses[1]] == true) && tradeValues[10] > 10 ether) tradeValues[10] = 10 ether;
306 
307     if(tradeAddresses[0] == address(0) || approvedCurrencyTokens[tradeAddresses[0]] == true){
308 
309       require(orderFills[orderHash].add(tradeValues[1]) <= tradeValues[8]);
310       require(orderFills[tradeHash].add(tradeValues[1]) <= tradeValues[3]);
311 
312       //tradeAddresses[0] is ether
313       uint256 valueInTokens = tradeValues[1];
314 
315       //move tokens
316       tokens[tradeAddresses[1]][tradeAddresses[2]] = tokens[tradeAddresses[1]][tradeAddresses[2]].sub(valueInTokens);
317       tokens[tradeAddresses[1]][tradeAddresses[3]] = tokens[tradeAddresses[1]][tradeAddresses[3]].add(valueInTokens);
318 
319       //from taker, take ether payment, fee and gasCost
320       tokens[tradeAddresses[0]][tradeAddresses[3]] = tokens[tradeAddresses[0]][tradeAddresses[3]].sub(tradeValues[0]);
321       tokens[tradeAddresses[0]][tradeAddresses[3]] = tokens[tradeAddresses[0]][tradeAddresses[3]].sub(takerFee.mul(tradeValues[0]).div(1 ether));
322       tokens[tradeAddresses[0]][tradeAddresses[3]] = tokens[tradeAddresses[0]][tradeAddresses[3]].sub(tradeValues[10]);
323 
324       //to maker add ether payment, take fee
325       tokens[tradeAddresses[0]][tradeAddresses[2]] = tokens[tradeAddresses[0]][tradeAddresses[2]].add(tradeValues[0]);
326       tokens[tradeAddresses[0]][tradeAddresses[2]] = tokens[tradeAddresses[0]][tradeAddresses[2]].sub(makerFee.mul(tradeValues[0]).div(1 ether));
327 
328       // take maker fee, taker fee and gasCost
329       tokens[tradeAddresses[0]][feeAccount] = tokens[tradeAddresses[0]][feeAccount].add(makerFee.mul(tradeValues[0]).div(1 ether));
330       tokens[tradeAddresses[0]][feeAccount] = tokens[tradeAddresses[0]][feeAccount].add(takerFee.mul(tradeValues[0]).div(1 ether));
331       tokens[tradeAddresses[0]][feeAccount] = tokens[tradeAddresses[0]][feeAccount].add(tradeValues[10]);
332 
333       orderFills[orderHash] = orderFills[orderHash].add(tradeValues[1]);
334       orderFills[tradeHash] = orderFills[tradeHash].add(tradeValues[1]);
335 
336     } else {
337 
338       require(orderFills[orderHash].add(tradeValues[0]) <= tradeValues[7]);
339       require(orderFills[tradeHash].add(tradeValues[0]) <= tradeValues[4]);
340 
341       //tradeAddresses[0] is token
342       uint256 valueInEth = tradeValues[1];
343 
344       //move tokens //changed tradeValues to 0
345       tokens[tradeAddresses[0]][tradeAddresses[3]] = tokens[tradeAddresses[0]][tradeAddresses[3]].sub(tradeValues[0]);
346       tokens[tradeAddresses[0]][tradeAddresses[2]] = tokens[tradeAddresses[0]][tradeAddresses[2]].add(tradeValues[0]);
347 
348       //from maker, take ether payment and fee
349       tokens[tradeAddresses[1]][tradeAddresses[2]] = tokens[tradeAddresses[1]][tradeAddresses[2]].sub(valueInEth);
350       tokens[tradeAddresses[1]][tradeAddresses[2]] = tokens[tradeAddresses[1]][tradeAddresses[2]].sub(makerFee.mul(valueInEth).div(1 ether));
351 
352       //add ether payment to taker, take fee, take gasCost
353       tokens[tradeAddresses[1]][tradeAddresses[3]] = tokens[tradeAddresses[1]][tradeAddresses[3]].add(valueInEth);
354       tokens[tradeAddresses[1]][tradeAddresses[3]] = tokens[tradeAddresses[1]][tradeAddresses[3]].sub(takerFee.mul(valueInEth).div(1 ether));
355       tokens[tradeAddresses[1]][tradeAddresses[3]] = tokens[tradeAddresses[1]][tradeAddresses[3]].sub(tradeValues[10]);
356 
357       //take maker fee, taker fee and gasCost
358       tokens[tradeAddresses[1]][feeAccount] = tokens[tradeAddresses[1]][feeAccount].add(makerFee.mul(valueInEth).div(1 ether));
359       tokens[tradeAddresses[1]][feeAccount] = tokens[tradeAddresses[1]][feeAccount].add(takerFee.mul(valueInEth).div(1 ether));
360       tokens[tradeAddresses[1]][feeAccount] = tokens[tradeAddresses[1]][feeAccount].add(tradeValues[10]);
361 
362       orderFills[orderHash] = orderFills[orderHash].add(tradeValues[0]);
363       orderFills[tradeHash] = orderFills[tradeHash].add(tradeValues[0]);
364     }
365 
366     lastActiveTransaction[tradeAddresses[2]] = block.number;
367     lastActiveTransaction[tradeAddresses[3]] = block.number;
368 
369     emit Trade(tradeAddresses[0], tradeValues[0], tradeAddresses[1], tradeValues[1], tradeAddresses[2], tradeAddresses[3]);
370     return true;
371   }
372 
373 }