1 pragma solidity ^0.4.23;
2 /*
3  * @title ERC20Basic
4  * @dev Simpler version of ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/179
6  */
7 contract ERC20Basic {
8   function totalSupply() public view returns (uint256);
9   function balanceOf(address who) public view returns (uint256);
10   function transfer(address to, uint256 value) public returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 
14 /**
15  * @title ERC20 interface
16  * @dev see https://github.com/ethereum/EIPs/issues/20
17  */
18 contract ERC20 is ERC20Basic {
19   function allowance(address owner, address spender) public view returns (uint256);
20   function transferFrom(address from, address to, uint256 value) public returns (bool);
21   function approve(address spender, uint256 value) public returns (bool);
22   event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 /**
26 
27 /**
28  * @title Ownable
29  * @dev The Ownable contract has an owner address, and provides basic authorization control
30  * functions, this simplifies the implementation of "user permissions".
31  */
32 contract Ownable {
33   address public owner;
34 
35 
36   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38 
39   /**
40    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
41    * account.
42    */
43   function Ownable() public {
44     owner = msg.sender;
45   }
46 
47   /**
48    * @dev Throws if called by any account other than the owner.
49    */
50   modifier onlyOwner() {
51     require(msg.sender == owner);
52     _;
53   }
54 
55   /**
56    * @dev Allows the current owner to transfer control of the contract to a newOwner.
57    * @param newOwner The address to transfer ownership to.
58    */
59   function transferOwnership(address newOwner) public onlyOwner {
60     require(newOwner != address(0));
61     emit OwnershipTransferred(owner, newOwner);
62     owner = newOwner;
63   }
64 
65 }
66 
67 /**
68  * @title SafeMath
69  * @dev Math operations with safety checks that throw on error
70  */
71 library SafeMath {
72 
73   /**
74   * @dev Multiplies two numbers, throws on overflow.
75   */
76   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
77     if (a == 0) {
78       return 0;
79     }
80     uint256 c = a * b;
81     require(c / a == b);
82     return c;
83   }
84 
85   /**
86   * @dev Integer division of two numbers, truncating the quotient.
87   */
88   function div(uint256 a, uint256 b) internal pure returns (uint256) {
89     // require(b > 0); // Solidity automatically throws when dividing by 0
90     uint256 c = a / b;
91     // require(a == b * c + a % b); // There is no case in which this doesn't hold
92     return c;
93   }
94 
95   /**
96   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
97   */
98   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
99     require(b <= a);
100     return a - b;
101   }
102 
103   /**
104   * @dev Adds two numbers, throws on overflow.
105   */
106   function add(uint256 a, uint256 b) internal pure returns (uint256) {
107     uint256 c = a + b;
108     require(c >= a);
109     return c;
110   }
111 
112   /**
113   * @dev a to power of b, throws on overflow.
114   */
115   function pow(uint256 a, uint256 b) internal pure returns (uint256) {
116     uint256 c = a ** b;
117     require(c >= a);
118     return c;
119   }
120 
121 }
122 
123 // Refactored and extended by Radek Ostrowski and Maciek Zielinski
124 // http://startonchain.com
125 // Additional extensions done by Alex George
126 // https://dexbrokerage.com
127 
128 contract DexBrokerage is Ownable {
129   using SafeMath for uint256;
130 
131   address public feeAccount;
132   uint256 public makerFee;
133   uint256 public takerFee;
134   uint256 public inactivityReleasePeriod;
135   mapping (address => bool) public approvedCurrencyTokens;
136   mapping (address => uint256) public invalidOrder;
137   mapping (address => mapping (address => uint256)) public tokens;
138   mapping (address => bool) public admins;
139   mapping (address => uint256) public lastActiveTransaction;
140   mapping (bytes32 => uint256) public orderFills;
141   mapping (bytes32 => bool) public withdrawn;
142 
143   event Trade(address tokenBuy, uint256 amountBuy, address tokenSell, uint256 amountSell, address maker, address taker);
144   event Deposit(address token, address user, uint256 amount, uint256 balance);
145   event Withdraw(address token, address user, uint256 amount, uint256 balance);
146   event MakerFeeUpdated(uint256 oldFee, uint256 newFee);
147   event TakerFeeUpdated(uint256 oldFee, uint256 newFee);
148 
149   modifier onlyAdmin {
150     require(msg.sender == owner || admins[msg.sender]);
151     _;
152   }
153 
154   constructor(uint256 _makerFee, uint256 _takerFee , address _feeAccount, uint256 _inactivityReleasePeriod) public {
155     owner = msg.sender;
156     makerFee = _makerFee;
157     takerFee = _takerFee;
158     feeAccount = _feeAccount;
159     inactivityReleasePeriod = _inactivityReleasePeriod;
160   }
161 
162   function approveCurrencyTokenAddress(address currencyTokenAddress, bool isApproved) onlyAdmin public {
163     approvedCurrencyTokens[currencyTokenAddress] = isApproved;
164   }
165 
166   function invalidateOrdersBefore(address user, uint256 nonce) onlyAdmin public {
167     require(nonce >= invalidOrder[user]);
168     invalidOrder[user] = nonce;
169   }
170 
171   function setMakerFee(uint256 _makerFee) onlyAdmin public {
172     //market maker fee will never be more than 1%
173     uint256 oldFee = makerFee;
174     if (_makerFee > 10 finney) {
175       _makerFee = 10 finney;
176     }
177     require(makerFee != _makerFee);
178     makerFee = _makerFee;
179     emit MakerFeeUpdated(oldFee, makerFee);
180   }
181 
182   function setTakerFee(uint256 _takerFee) onlyAdmin public {
183     //market taker fee will never be more than 2%
184     uint256 oldFee = takerFee;
185     if (_takerFee > 20 finney) {
186       _takerFee = 20 finney;
187     }
188     require(takerFee != _takerFee);
189     takerFee = _takerFee;
190     emit TakerFeeUpdated(oldFee, takerFee);
191   }
192 
193   function setAdmin(address admin, bool isAdmin) onlyOwner public {
194     admins[admin] = isAdmin;
195   }
196 
197   function depositToken(address token, uint256 amount) public {
198     receiveTokenDeposit(token, msg.sender, amount);
199   }
200 
201   function receiveTokenDeposit(address token, address from, uint256 amount) public {
202     tokens[token][from] = tokens[token][from].add(amount);
203     lastActiveTransaction[from] = block.number;
204     require(ERC20(token).transferFrom(from, address(this), amount));
205     emit Deposit(token, from, amount, tokens[token][from]);
206   }
207 
208   function deposit() payable public {
209     tokens[address(0)][msg.sender] = tokens[address(0)][msg.sender].add(msg.value);
210     lastActiveTransaction[msg.sender] = block.number;
211     emit Deposit(address(0), msg.sender, msg.value, tokens[address(0)][msg.sender]);
212   }
213 
214   function withdraw(address token, uint256 amount) public returns (bool) {
215     require(block.number.sub(lastActiveTransaction[msg.sender]) >= inactivityReleasePeriod);
216     require(tokens[token][msg.sender] >= amount);
217     tokens[token][msg.sender] = tokens[token][msg.sender].sub(amount);
218     if (token == address(0)) {
219       msg.sender.transfer(amount);
220     } else {
221       require(ERC20(token).transfer(msg.sender, amount));
222     }
223     emit Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
224     return true;
225   }
226 
227   function adminWithdraw(address token, uint256 amount, address user, uint256 nonce, uint8 v, bytes32 r, bytes32 s, uint256 gasCost) onlyAdmin public returns (bool) {
228     //gasCost will never be more than 30 finney
229     if (gasCost > 30 finney) gasCost = 30 finney;
230 
231     if(token == address(0)){
232       require(tokens[address(0)][user] >= gasCost.add(amount));
233     } else {
234       require(tokens[address(0)][user] >= gasCost);
235       require(tokens[token][user] >= amount);
236     }
237 
238     bytes32 hash = keccak256(address(this), token, amount, user, nonce);
239     require(!withdrawn[hash]);
240     withdrawn[hash] = true;
241     require(ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash), v, r, s) == user);
242 
243     if(token == address(0)){
244       tokens[address(0)][user] = tokens[address(0)][user].sub(gasCost.add(amount));
245       tokens[address(0)][feeAccount] = tokens[address(0)][feeAccount].add(gasCost);
246       user.transfer(amount);
247     } else {
248       tokens[token][user] = tokens[token][user].sub(amount);
249       tokens[address(0)][user] = tokens[address(0)][user].sub(gasCost);
250       tokens[address(0)][feeAccount] = tokens[address(0)][feeAccount].add(gasCost);
251       require(ERC20(token).transfer(user, amount));
252     }
253     lastActiveTransaction[user] = block.number;
254     emit Withdraw(token, user, amount, tokens[token][user]);
255     return true;
256   }
257 
258   function balanceOf(address token, address user) view public returns (uint256) {
259     return tokens[token][user];
260   }
261 
262     /* tradeValues
263        [0] amountBuy
264        [1] amountSell
265        [2] makerNonce
266        [3] takerAmountBuy
267        [4] takerAmountSell
268        [5] takerExpires
269        [6] takerNonce
270        [7] makerAmountBuy
271        [8] makerAmountSell
272        [9] makerExpires
273        [10] gasCost
274      tradeAddressses
275        [0] tokenBuy
276        [1] tokenSell
277        [2] maker
278        [3] taker
279      */
280 
281   function trade(uint256[11] tradeValues, address[4] tradeAddresses, uint8[2] v, bytes32[4] rs) onlyAdmin public returns (bool) {
282     uint256 price = tradeValues[0].mul(1 ether) / tradeValues[1];
283     require(price >= tradeValues[7].mul(1 ether) / tradeValues[8]);
284     require(price <= tradeValues[4].mul(1 ether) / tradeValues[3]);
285     require(block.number < tradeValues[9]);
286     require(block.number < tradeValues[5]);
287     require(invalidOrder[tradeAddresses[2]] <= tradeValues[2]);
288     require(invalidOrder[tradeAddresses[3]] <= tradeValues[6]);
289     bytes32 orderHash = keccak256(address(this), tradeAddresses[0], tradeValues[7], tradeAddresses[1], tradeValues[8], tradeValues[9], tradeValues[2], tradeAddresses[2]);
290     bytes32 tradeHash = keccak256(address(this), tradeAddresses[1], tradeValues[3], tradeAddresses[0], tradeValues[4], tradeValues[5], tradeValues[6], tradeAddresses[3]);
291     require(ecrecover(keccak256("\x19Ethereum Signed Message:\n32", orderHash), v[0], rs[0], rs[1]) == tradeAddresses[2]);
292     require(ecrecover(keccak256("\x19Ethereum Signed Message:\n32", tradeHash), v[1], rs[2], rs[3]) == tradeAddresses[3]);
293     require(tokens[tradeAddresses[0]][tradeAddresses[3]] >= tradeValues[0]);
294     require(tokens[tradeAddresses[1]][tradeAddresses[2]] >= tradeValues[1]);
295     if ((tradeAddresses[0] == address(0) || tradeAddresses[1] == address(0)) && tradeValues[10] > 30 finney) tradeValues[10] = 30 finney;
296     if ((approvedCurrencyTokens[tradeAddresses[0]] == true || approvedCurrencyTokens[tradeAddresses[1]] == true) && tradeValues[10] > 10 ether) tradeValues[10] = 10 ether;
297 
298     if(tradeAddresses[0] == address(0) || approvedCurrencyTokens[tradeAddresses[0]] == true){
299 
300       require(orderFills[orderHash].add(tradeValues[1]) <= tradeValues[8]);
301       require(orderFills[tradeHash].add(tradeValues[1]) <= tradeValues[3]);
302 
303       //tradeAddresses[0] is ether
304       uint256 valueInTokens = tradeValues[1];
305 
306       //move tokens
307       tokens[tradeAddresses[1]][tradeAddresses[2]] = tokens[tradeAddresses[1]][tradeAddresses[2]].sub(valueInTokens);
308       tokens[tradeAddresses[1]][tradeAddresses[3]] = tokens[tradeAddresses[1]][tradeAddresses[3]].add(valueInTokens);
309 
310       //from taker, take ether payment, fee and gasCost
311       tokens[tradeAddresses[0]][tradeAddresses[3]] = tokens[tradeAddresses[0]][tradeAddresses[3]].sub(tradeValues[0]);
312       tokens[tradeAddresses[0]][tradeAddresses[3]] = tokens[tradeAddresses[0]][tradeAddresses[3]].sub(takerFee.mul(tradeValues[0]) / (1 ether));
313       tokens[tradeAddresses[0]][tradeAddresses[3]] = tokens[tradeAddresses[0]][tradeAddresses[3]].sub(tradeValues[10]);
314 
315       //to maker add ether payment, take fee
316       tokens[tradeAddresses[0]][tradeAddresses[2]] = tokens[tradeAddresses[0]][tradeAddresses[2]].add(tradeValues[0]);
317       tokens[tradeAddresses[0]][tradeAddresses[2]] = tokens[tradeAddresses[0]][tradeAddresses[2]].sub(makerFee.mul(tradeValues[0]) / (1 ether));
318 
319       // take maker fee, taker fee and gasCost
320       tokens[tradeAddresses[0]][feeAccount] = tokens[tradeAddresses[0]][feeAccount].add(makerFee.mul(tradeValues[0]) / (1 ether));
321       tokens[tradeAddresses[0]][feeAccount] = tokens[tradeAddresses[0]][feeAccount].add(takerFee.mul(tradeValues[0]) / (1 ether));
322       tokens[tradeAddresses[0]][feeAccount] = tokens[tradeAddresses[0]][feeAccount].add(tradeValues[10]);
323 
324       orderFills[orderHash] = orderFills[orderHash].add(tradeValues[1]);
325       orderFills[tradeHash] = orderFills[tradeHash].add(tradeValues[1]);
326 
327     } else {
328 
329       require(orderFills[orderHash].add(tradeValues[0]) <= tradeValues[7]);
330       require(orderFills[tradeHash].add(tradeValues[0]) <= tradeValues[4]);
331 
332       //tradeAddresses[0] is token
333       uint256 valueInEth = tradeValues[1];
334 
335       //move tokens //changed tradeValues to 0
336       tokens[tradeAddresses[0]][tradeAddresses[3]] = tokens[tradeAddresses[0]][tradeAddresses[3]].sub(tradeValues[0]);
337       tokens[tradeAddresses[0]][tradeAddresses[2]] = tokens[tradeAddresses[0]][tradeAddresses[2]].add(tradeValues[0]);
338 
339       //from maker, take ether payment and fee
340       tokens[tradeAddresses[1]][tradeAddresses[2]] = tokens[tradeAddresses[1]][tradeAddresses[2]].sub(valueInEth);
341       tokens[tradeAddresses[1]][tradeAddresses[2]] = tokens[tradeAddresses[1]][tradeAddresses[2]].sub(makerFee.mul(valueInEth) / (1 ether));
342 
343       //add ether payment to taker, take fee, take gasCost
344       tokens[tradeAddresses[1]][tradeAddresses[3]] = tokens[tradeAddresses[1]][tradeAddresses[3]].add(valueInEth);
345       tokens[tradeAddresses[1]][tradeAddresses[3]] = tokens[tradeAddresses[1]][tradeAddresses[3]].sub(takerFee.mul(valueInEth) / (1 ether));
346       tokens[tradeAddresses[1]][tradeAddresses[3]] = tokens[tradeAddresses[1]][tradeAddresses[3]].sub(tradeValues[10]);
347 
348       //take maker fee, taker fee and gasCost
349       tokens[tradeAddresses[1]][feeAccount] = tokens[tradeAddresses[1]][feeAccount].add(makerFee.mul(valueInEth) / (1 ether));
350       tokens[tradeAddresses[1]][feeAccount] = tokens[tradeAddresses[1]][feeAccount].add(takerFee.mul(valueInEth) / (1 ether));
351       tokens[tradeAddresses[1]][feeAccount] = tokens[tradeAddresses[1]][feeAccount].add(tradeValues[10]);
352 
353       orderFills[orderHash] = orderFills[orderHash].add(tradeValues[0]);
354       orderFills[tradeHash] = orderFills[tradeHash].add(tradeValues[0]);
355     }
356 
357     lastActiveTransaction[tradeAddresses[2]] = block.number;
358     lastActiveTransaction[tradeAddresses[3]] = block.number;
359 
360     emit Trade(tradeAddresses[0], tradeValues[0], tradeAddresses[1], tradeValues[1], tradeAddresses[2], tradeAddresses[3]);
361     return true;
362   }
363 
364 }