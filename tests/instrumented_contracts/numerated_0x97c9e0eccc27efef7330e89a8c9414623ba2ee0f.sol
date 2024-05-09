1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'extoke.com' DEX contract
5 //
6 // Admin       : 0xEd86f5216BCAFDd85E5875d35463Aca60925bF16
7 // fees        : zero (0)
8 //
9 //
10 // Copyright (c) ExToke.com. The MIT Licence.
11 // Contract crafted by: GDO Infotech Pvt Ltd (https://GDO.co.in) 
12 // ----------------------------------------------------------------------------
13 
14 interface transferToken {
15     function transfer(address receiver, uint amount) external;
16 }
17 /**
18  * @title SafeMath
19  * @dev Math operations with safety checks that throw on error
20  */
21 library SafeMath {
22   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23     if (a == 0) {
24       return 0;
25     }
26     uint256 c = a * b;
27     assert(c / a == b);
28     return c;
29   }
30 
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     // assert(b > 0); // Solidity automatically throws when dividing by 0
33     uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35     return c;
36   }
37 
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 contract Ownable {
50   address public owner;
51 
52 
53   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55 
56   /**
57    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
58    * account.
59    */
60   constructor() public {
61     owner = msg.sender;
62   }
63 
64 
65   /**
66    * @dev Throws if called by any account other than the owner.
67    */
68   modifier onlyOwner() {
69     require(msg.sender == owner);
70     _;
71   }
72 
73 
74   /**
75    * @dev Allows the current owner to transfer control of the contract to a newOwner.
76    * @param newOwner The address to transfer ownership to.
77    */
78   function transferOwnership(address newOwner) onlyOwner public {
79     require(newOwner != address(0));
80     emit OwnershipTransferred(owner, newOwner);
81     owner = newOwner;
82   }
83 
84 }
85 
86 /**
87  * @title ERC20Basic
88  * @dev Simpler version of ERC20 interface
89  * @dev see https://github.com/ethereum/EIPs/issues/179
90  */
91 contract ERC20Basic {
92     /// Total amount of tokens
93   uint256 public totalSupply;
94   
95   function balanceOf(address _owner) public view returns (uint256 balance);
96   
97   function transfer(address _to, uint256 _amount) public returns (bool success);
98   
99   event Transfer(address indexed from, address indexed to, uint256 value);
100 }
101 
102 /**
103  * @title ERC20 interface
104  * @dev see https://github.com/ethereum/EIPs/issues/20
105  */
106 contract ERC20 is ERC20Basic {
107   function allowance(address _owner, address _spender) public view returns (uint256 remaining);
108   
109   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);
110   
111   function approve(address _spender, uint256 _amount) public returns (bool success);
112   
113   event Approval(address indexed owner, address indexed spender, uint256 value);
114 }
115 
116 /**
117  * @title Basic token
118  * @dev Basic version of StandardToken, with no allowances.
119  */
120 contract BasicToken is ERC20Basic {
121   using SafeMath for uint256;
122 
123   //balance in each address account
124   mapping(address => uint256) balances;
125 
126   /**
127   * @dev transfer token for a specified address
128   * @param _to The address to transfer to.
129   * @param _amount The amount to be transferred.
130   */
131   function transfer(address _to, uint256 _amount) public returns (bool success) {
132     require(_to != address(0));
133     require(balances[msg.sender] >= _amount && _amount > 0
134         && balances[_to].add(_amount) > balances[_to]);
135 
136     // SafeMath.sub will throw if there is not enough balance.
137     balances[msg.sender] = balances[msg.sender].sub(_amount);
138     balances[_to] = balances[_to].add(_amount);
139     emit Transfer(msg.sender, _to, _amount);
140     return true;
141   }
142 
143   /**
144   * @dev Gets the balance of the specified address.
145   * @param _owner The address to query the the balance of.
146   * @return An uint256 representing the amount owned by the passed address.
147   */
148   function balanceOf(address _owner) public view returns (uint256 balance) {
149     return balances[_owner];
150   }
151 
152 }
153 
154 /**
155  * @title Standard ERC20 token
156  *
157  * @dev Implementation of the basic standard token.
158  * @dev https://github.com/ethereum/EIPs/issues/20
159  */
160 contract StandardToken is ERC20, BasicToken {
161   
162   
163   mapping (address => mapping (address => uint256)) internal allowed;
164 
165 
166   /**
167    * @dev Transfer tokens from one address to another
168    * @param _from address The address which you want to send tokens from
169    * @param _to address The address which you want to transfer to
170    * @param _amount uint256 the amount of tokens to be transferred
171    */
172   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
173     require(_to != address(0));
174     require(balances[_from] >= _amount);
175     require(allowed[_from][msg.sender] >= _amount);
176     require(_amount > 0 && balances[_to].add(_amount) > balances[_to]);
177 
178     balances[_from] = balances[_from].sub(_amount);
179     balances[_to] = balances[_to].add(_amount);
180     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
181     emit Transfer(_from, _to, _amount);
182     return true;
183   }
184 	
185 	function transfer(address _to, uint256 _amount) public returns (bool success) {
186     require(_to != address(0));
187     require(balances[msg.sender] >= _amount && _amount > 0
188         && balances[_to].add(_amount) > balances[_to]);
189 
190     // SafeMath.sub will throw if there is not enough balance.
191     balances[msg.sender] = balances[msg.sender].sub(_amount);
192     balances[_to] = balances[_to].add(_amount);
193     emit Transfer(msg.sender, _to, _amount);
194     return true;
195   }
196   /**
197    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
198    *
199    * Beware that changing an allowance with this method brings the risk that someone may use both the old
200    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
201    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
202    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
203    * @param _spender The address which will spend the funds.
204    * @param _amount The amount of tokens to be spent.
205    */
206   function approve(address _spender, uint256 _amount) public returns (bool success) {
207     allowed[msg.sender][_spender] = _amount;
208     emit Approval(msg.sender, _spender, _amount);
209     return true;
210   }
211 
212   /**
213    * @dev Function to check the amount of tokens that an owner allowed to a spender.
214    * @param _owner address The address which owns the funds.
215    * @param _spender address The address which will spend the funds.
216    * @return A uint256 specifying the amount of tokens still available for the spender.
217    */
218   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
219     return allowed[_owner][_spender];
220   }
221 
222 }
223 
224 contract ReserveToken is StandardToken {
225   using SafeMath for uint256;
226   address public minter;
227   constructor() public {
228     minter = msg.sender;
229   }
230   function create(address account, uint amount) public {
231     require(msg.sender == minter);
232     balances[account] = balances[account].add(amount);
233     totalSupply = totalSupply.add(amount);
234   }
235   function destroy(address account, uint amount) public {
236     require(msg.sender == minter);
237     require(balances[account] >= amount);
238     balances[account] = balances[account].add(amount);
239     totalSupply = totalSupply.sub(amount);
240   }
241 }
242 
243 contract AccountLevels {
244   mapping (address => uint) public accountLevels;
245   //given a user, returns an account level
246   //0 = regular user (pays take fee and make fee)
247   //1 = market maker silver (pays take fee, no make fee, gets rebate)
248   //2 = market maker gold (pays take fee, no make fee, gets entire counterparty's take fee as rebate)
249   function accountLevel(address user) public constant returns(uint) {
250       return accountLevels[user];
251   }
252 }
253 
254 contract AccountLevelsTest is AccountLevels {
255   //mapping (address => uint) public accountLevels;
256 
257   function setAccountLevel(address user, uint level) public {
258     accountLevels[user] = level;
259   }
260 }
261 
262 contract ExToke is Ownable {
263   using SafeMath for uint256;
264   address public admin; //the admin address
265   address public feeAccount; //the account that will receive fees
266   address public accountLevelsAddr; //the address of the AccountLevels contract
267   uint public feeMake; //percentage times (1 ether)
268   uint public feeTake; //percentage times (1 ether)
269   uint public feeRebate; //percentage times (1 ether)
270   mapping (address => mapping (address => uint)) public tokens; //mapping of token addresses to mapping of account balances (token=0 means Ether)
271   mapping (address => mapping (bytes32 => bool)) public orders; //mapping of user accounts to mapping of order hashes to booleans (true = submitted by user, equivalent to offchain signature)
272   mapping (address => mapping (bytes32 => uint)) public orderFills; //mapping of user accounts to mapping of order hashes to uints (amount of order that has been filled)
273   transferToken public tokenReward;  
274   
275   event Order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user);
276   event Cancel(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s);
277   event Trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give);
278   event Deposit(address token, address user, uint amount, uint balance);
279   event Withdraw(address token, address user, uint amount, uint balance);
280 
281 
282   constructor(address admin_, address feeAccount_, address accountLevelsAddr_, uint feeMake_, uint feeTake_, uint feeRebate_) public {
283     owner = admin_;
284     admin = admin_;
285     feeAccount = feeAccount_;
286     accountLevelsAddr = accountLevelsAddr_;
287     feeMake = feeMake_;
288     feeTake = feeTake_;
289     feeRebate = feeRebate_;
290   }
291 
292   function() public {
293     revert();
294   }
295 
296   function changeAdmin(address admin_) public onlyOwner {
297     admin = admin_;
298   }
299 
300   function changeAccountLevelsAddr(address accountLevelsAddr_) public onlyOwner {
301     accountLevelsAddr = accountLevelsAddr_;
302   }
303 
304   function changeFeeAccount(address feeAccount_) public onlyOwner {
305     feeAccount = feeAccount_;
306   }
307 
308   function changeFeeMake(uint feeMake_) public onlyOwner{
309     require(feeMake_ <= feeMake);
310     feeMake = feeMake_;
311   }
312 
313   function changeFeeTake(uint feeTake_) public onlyOwner {
314     require (feeTake_ <= feeTake && feeTake_ >= feeRebate);
315     feeTake = feeTake_;
316   }
317 
318   function changeFeeRebate(uint feeRebate_) public onlyOwner {
319     require(feeRebate_ >= feeRebate && feeRebate_ <=feeTake);
320     feeRebate = feeRebate_;
321   }
322 
323   function deposit() public payable {
324     tokens[0][msg.sender] = tokens[0][msg.sender].add(msg.value);
325     emit Deposit(0, msg.sender, msg.value, tokens[0][msg.sender]);
326   }
327 
328   function withdraw(uint amount) public {
329     require(tokens[0][msg.sender] >= amount);
330     tokens[0][msg.sender] = tokens[0][msg.sender].sub(amount);
331     msg.sender.transfer(amount);
332     emit Withdraw(0, msg.sender, amount, tokens[0][msg.sender]);
333   }
334 
335   function depositToken(address token, uint amount) public {
336     //remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
337     require(token!=0);
338     require(StandardToken(token).transferFrom(msg.sender, this, amount));
339     tokens[token][msg.sender] = tokens[token][msg.sender].add(amount);
340     emit Deposit(token, msg.sender, amount, tokens[token][msg.sender]);
341   }
342 	
343   function withdrawToken(address token, uint amount) public {
344     require(token!=0);
345     require(tokens[token][msg.sender] >= amount);
346     tokens[token][msg.sender] = tokens[token][msg.sender].sub(amount);
347     tokenReward = transferToken(token);
348 	tokenReward.transfer(msg.sender, amount);
349     emit Withdraw(token, msg.sender, amount, tokens[token][msg.sender]);
350   }
351 
352   function balanceOf(address token, address user) public constant returns (uint) {
353     return tokens[token][user];
354   }
355 
356   function order(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce) public {
357     bytes32 hash = keccak256(abi.encodePacked(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));
358     orders[msg.sender][hash] = true;
359     emit Order(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender);
360   }
361 
362   function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) public {
363     //amount is in amountGet terms
364     bytes32 hash = keccak256(abi.encodePacked(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));
365     require((
366       (orders[user][hash] || ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)),v,r,s) == user) &&
367       block.number <= expires &&
368       orderFills[user][hash].add(amount) <= amountGet
369     ));
370     tradeBalances(tokenGet, amountGet, tokenGive, amountGive, user, amount);
371     orderFills[user][hash] = orderFills[user][hash].add(amount);
372     emit Trade(tokenGet, amount, tokenGive, amountGive * amount / amountGet, user, msg.sender);
373   }
374 
375   function tradeBalances(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address user, uint amount) private {
376     uint feeMakeXfer = amount.mul(feeMake) / (1 ether);
377     uint feeTakeXfer = amount.mul(feeTake) / (1 ether);
378     uint feeRebateXfer = 0;
379     feeRebateXfer = feeTakeXfer; 
380     /*if (accountLevelsAddr != 0x0) {
381       uint accountLevel = AccountLevels(accountLevelsAddr).accountLevel(user);
382       if (accountLevel==1) feeRebateXfer = amount.mul(feeRebate) / (1 ether);
383       if (accountLevel==2) feeRebateXfer = feeTakeXfer;
384     }*/
385     tokens[tokenGet][msg.sender] = tokens[tokenGet][msg.sender].sub(amount.add(feeTakeXfer));
386     tokens[tokenGet][user] = tokens[tokenGet][user].add(amount.add(feeRebateXfer).sub(feeMakeXfer));
387     //tokens[tokenGet][feeAccount] = tokens[tokenGet][feeAccount].add(feeMakeXfer.add(feeTakeXfer).sub(feeRebateXfer));
388     tokens[tokenGive][user] = tokens[tokenGive][user].sub(amountGive.mul(amount) / amountGet);
389     tokens[tokenGive][msg.sender] = tokens[tokenGive][msg.sender].add(amountGive.mul(amount) / amountGet);
390   }
391 
392   function testTrade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount, address sender) public constant returns(bool) {
393     
394     if (!(
395       tokens[tokenGet][sender] >= amount &&
396       availableVolume(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, user, v, r, s) >= amount
397     )) return false;
398     return true;
399   }
400 
401   function availableVolume(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s) public constant returns(uint) {
402     bytes32 hash = keccak256(abi.encodePacked(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));
403     uint available1;
404     if (!(
405       (orders[user][hash] || ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)),v,r,s) == user) &&
406       block.number <= expires
407     )) return 0;
408     available1 = tokens[tokenGive][user].mul(amountGet) / amountGive;
409     
410     if (amountGet.sub(orderFills[user][hash])<available1) return amountGet.sub(orderFills[user][hash]);
411     return available1;
412     
413   }
414 
415   function amountFilled(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user) public constant returns(uint) {
416     bytes32 hash = keccak256(abi.encodePacked(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));
417     return orderFills[user][hash];
418   }
419 
420   function cancelOrder(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, uint8 v, bytes32 r, bytes32 s) public {
421     bytes32 hash = keccak256(abi.encodePacked(this, tokenGet, amountGet, tokenGive, amountGive, expires, nonce));
422     require((orders[msg.sender][hash] || ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)),v,r,s) == msg.sender));
423     orderFills[msg.sender][hash] = amountGet;
424     emit Cancel(tokenGet, amountGet, tokenGive, amountGive, expires, nonce, msg.sender, v, r, s);
425   }
426 }