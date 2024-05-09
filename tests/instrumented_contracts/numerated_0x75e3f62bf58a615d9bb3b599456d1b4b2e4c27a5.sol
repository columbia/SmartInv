1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 library SafeMath {
7     function add(uint a, uint b) internal pure returns (uint c) {
8         c = a + b;
9         require(c >= a);
10     }
11     function sub(uint a, uint b) internal pure returns (uint c) {
12         require(b <= a);
13         c = a - b;
14     }
15     function mul(uint a, uint b) internal pure returns (uint c) {
16         c = a * b;
17         require(a == 0 || c / a == b);
18     }
19     function div(uint a, uint b) internal pure returns (uint c) {
20         require(b > 0);
21         c = a / b;
22     }
23 }
24 
25 
26 // ----------------------------------------------------------------------------
27 // ERC Token Standard #20 Interface
28 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
29 // ----------------------------------------------------------------------------
30 contract ERC20Interface {
31     function totalSupply() public constant returns (uint);
32     function balanceOf(address tokenOwner) public constant returns (uint balance);
33     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
34     function transfer(address to, uint tokens) public returns (bool success);
35     function approve(address spender, uint tokens) public returns (bool success);
36     function transferFrom(address from, address to, uint tokens) public returns (bool success);
37 
38     event Transfer(address indexed from, address indexed to, uint tokens);
39     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
40 }
41 
42 
43 // ----------------------------------------------------------------------------
44 // Contract function to receive approval and execute function in one call
45 //
46 // Borrowed from MiniMeToken
47 // ----------------------------------------------------------------------------
48 contract ApproveAndCallFallBack {
49     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
50 }
51 
52 
53 // ----------------------------------------------------------------------------
54 // Owned contract
55 // ----------------------------------------------------------------------------
56 contract Owned {
57     address public owner;
58     address public newOwner;
59 
60     event OwnershipTransferred(address indexed _from, address indexed _to);
61 
62     constructor() public {
63         owner = msg.sender;
64     }
65 
66     modifier onlyOwner {
67         require(msg.sender == owner);
68         _;
69     }
70 
71     function transferOwnership(address _newOwner) public onlyOwner {
72         newOwner = _newOwner;
73     }
74     function acceptOwnership() public {
75         require(msg.sender == newOwner);
76         emit OwnershipTransferred(owner, newOwner);
77         owner = newOwner;
78         newOwner = address(0);
79     }
80 }
81 
82 /// @title Contract class
83 /// @author Infinigon Group
84 /// @notice Contract class defines the name of the contract
85 contract Contract {
86     bytes32 public Name;
87 
88     /// @notice Initializes contract with contract name
89     /// @param _contractName The name to be given to the contract
90     constructor(bytes32 _contractName) public {
91         Name = _contractName;
92     }
93 
94     function() public payable { }
95 }
96 
97 // ----------------------------------------------------------------------------
98 // ERC20 Default Token
99 // ----------------------------------------------------------------------------
100 contract DeaultERC20 is ERC20Interface, Owned {
101     using SafeMath for uint;
102 
103     string public symbol;
104     string public  name;
105     uint8 public decimals;
106     uint public _totalSupply;
107 
108     mapping(address => uint) balances;
109     mapping(address => mapping(address => uint)) allowed;
110 
111 
112     // ------------------------------------------------------------------------
113     // Constructor
114     // ------------------------------------------------------------------------
115     constructor() public {
116         symbol = "DFLT";
117         name = "Default";
118         decimals = 18;
119     }
120 
121     // ------------------------------------------------------------------------
122     // Total supply
123     // ---------------------------------------------------------allowance---------------
124     function totalSupply() public constant returns (uint) {
125         return _totalSupply  - balances[address(0)];
126     }
127 
128     // ------------------------------------------------------------------------
129     // Get the token balance for account `tokenOwner`
130     // ------------------------------------------------------------------------
131     function balanceOf(address tokenOwner) public constant returns (uint balance) {
132         return balances[tokenOwner];
133     }
134 
135     // ------------------------------------------------------------------------
136     // Transfer the balance from token owner's account to `to` account
137     // - Owner's account must have sufficient balance to transfer
138     // - 0 value transfers are allowed
139     // ------------------------------------------------------------------------
140     function transfer(address to, uint tokens) public returns (bool success) {
141         balances[msg.sender] = balances[msg.sender].sub(tokens);
142         balances[to] = balances[to].add(tokens);
143         emit Transfer(msg.sender, to, tokens);
144         return true;
145     }
146 
147     // ------------------------------------------------------------------------
148     // Token owner can approve for `spender` to transferFrom(...) `tokens`
149     // from the token owner's account
150     //
151     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
152     // recommends that there are no checks for the approval double-spend attack
153     // as this should be implemented in user interfaces 
154     // ------------------------------------------------------------------------
155     function approve(address spender, uint tokens) public returns (bool success) {
156         allowed[msg.sender][spender] = tokens;
157         emit Approval(msg.sender, spender, tokens);
158         return true;
159     }
160 
161     // ------------------------------------------------------------------------
162     // Transfer `tokens` from the `from` account to the `to` account
163     // 
164     // The calling account must already have sufficient tokens approve(...)-d
165     // for spending from the `from` account and
166     // - From account must have sufficient balance to transfer
167     // - Spender must have sufficient allowance to transfer
168     // - 0 value transfers are allowed
169     // ------------------------------------------------------------------------
170     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
171         balances[from] = balances[from].sub(tokens);
172         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
173         balances[to] = balances[to].add(tokens);
174         emit Transfer(from, to, tokens);
175         return true;
176     }
177 
178     // ------------------------------------------------------------------------
179     // Returns the amount of tokens approved by the owner that can be
180     // transferred to the spender's account
181     // ------------------------------------------------------------------------
182     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
183         return allowed[tokenOwner][spender];
184     }
185 
186     // ------------------------------------------------------------------------
187     // Token owner can approve for `spender` to transferFrom(...) `tokens`
188     // from the token owner's account. The `spender` contract function
189     // `receiveApproval(...)` is then executed
190     // ------------------------------------------------------------------------
191     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
192         allowed[msg.sender][spender] = tokens;
193         emit Approval(msg.sender, spender, tokens);
194         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
195         return true;
196     }
197 
198     // ------------------------------------------------------------------------
199     // Don't accept ETH
200     // ------------------------------------------------------------------------
201     function () public payable {
202         revert();
203     }
204 }
205 
206 // ----------------------------------------------------------------------------
207 // IGCoin
208 // ----------------------------------------------------------------------------
209 contract IGCoin is DeaultERC20 {
210     using SafeMath for uint;
211 
212     address public reserveAddress; // wei
213     uint256 public ask;
214     uint256 public bid;
215     uint16 public constant reserveRate = 10;
216     bool public initialSaleComplete;
217     uint256 constant private ICOAmount = 2e6*1e18; // in aToken
218     uint256 constant private ICOask = 1*1e18; // in wei per Token
219     uint256 constant private ICObid = 0; // in wei per Token
220     uint256 constant private InitialSupply = 1e6 * 1e18; // Number of tokens (aToken) minted when contract created
221     uint256 public debugVal;
222     uint256 public debugVal2;
223     uint256 public debugVal3;
224     uint256 public debugVal4;
225     uint256 constant private R = 12500000;  // matlab R=1.00000008, this R=1/(1.00000008-1)
226     uint256 constant private P = 50; // precision
227     uint256 constant private lnR = 12500001; // 1/ln(R)   (matlab R)
228     uint256 constant private S = 1e8; // s.t. S*R = integer
229     uint256 constant private RS = 8; // 1.00000008*S-S=8
230     uint256 constant private lnS = 18; // ln(S) = 18
231     
232     /* Constants to support ln() */
233     uint256 private constant ONE = 1;
234     uint32 private constant MAX_WETokenHT = 1000000;
235     uint8 private constant MIN_PRECISION = 32;
236     uint8 private constant MAX_PRECISION = 127;
237     uint256 private constant FIXED_1 = 0x080000000000000000000000000000000;
238     uint256 private constant FIXED_2 = 0x100000000000000000000000000000000;
239     uint256 private constant MAX_NUM = 0x1ffffffffffffffffffffffffffffffff;
240     uint256 private constant FIXED_3 = 0x07fffffffffffffffffffffffffffffff;
241     uint256 private constant LN2_MANTISSA = 0x2c5c85fdf473de6af278ece600fcbda;
242     uint8   private constant LN2_EXPONENT = 122;
243 
244     mapping (address => bool) public frozenAccount;
245     event FrozenFunds(address target, bool frozen); 
246 
247     // ------------------------------------------------------------------------
248     // Constructor
249     // ------------------------------------------------------------------------
250     constructor() public {
251         symbol = "IG17";
252         name = "theTestToken001";
253         decimals = 18;
254         initialSaleComplete = false;
255         _totalSupply = InitialSupply;  // Keep track of all IG Coins created, ever
256         balances[owner] = _totalSupply;  // Give the creator all initial IG coins
257         emit Transfer(address(0), owner, _totalSupply);
258 
259         reserveAddress = new Contract("Reserve");  // Create contract to hold reserve
260         quoteAsk();
261         quoteBid();        
262     }
263 
264     /// @notice Deposits '_value' in wei to the reserve address
265     /// @param _value The number of wei to be transferred to the 
266     /// reserve address
267     function deposit(uint256 _value) private {
268         reserveAddress.transfer(_value);
269         balances[reserveAddress] += _value;
270     }
271   
272     /// @notice Withdraws '_value' in wei from the reserve address
273     /// @param _value The number of wei to be transferred from the 
274     /// reserve address    
275     function withdraw(uint256 _value) private pure {
276         // TODO
277          _value = _value;
278     }
279     
280     /// @notice Transfers '_value' in wei to the '_to' address
281     /// @param _to The recipient address
282     /// @param _value The amount of wei to transfer
283     function transfer(address _to, uint256 _value) public returns (bool success) {
284         /* Check if sender has balance and for overflows */
285         require(balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]);
286         
287         /* Check if amount is nonzero */
288         require(_value > 0);
289 
290         /* Add and subtract new balances */
291         balances[msg.sender] -= _value;
292         balances[_to] += _value;
293     
294         /* Notify anyone listening that this transfer took place */
295         emit Transfer(msg.sender, _to, _value);
296         
297         return true;
298     }
299     
300     /// @notice `freeze? Prevent | Allow` `target` from sending 
301     /// & receiving tokens
302     /// @param _target Address to be frozen
303     /// @param _freeze either to freeze it or not
304     function freezeAccount(address _target, bool _freeze) public onlyOwner {
305         frozenAccount[_target] = _freeze;
306         emit FrozenFunds(_target, _freeze);
307     }    
308  
309     /// @notice Calculates the ask price in wei per aToken based on the 
310     /// current reserve amount
311     /// @return Price of aToken in wei
312     function quoteAsk() public returns (uint256) {
313         if(initialSaleComplete)
314         {
315             ask = fracExp(1e18, R, (_totalSupply/1e18)+1, P);
316         }
317         else
318         {
319             ask = ICOask;
320         }
321 
322         return ask;
323     }
324     
325     /// @notice Calculates the bid price in wei per aToken based on the 
326     /// current reserve amount
327     /// @return Price of aToken in wei    
328     function quoteBid() public returns (uint256) {
329         if(initialSaleComplete)
330         {
331             bid = fracExp(1e18, R, (_totalSupply/1e18)-1, P);
332         }
333         else
334         {
335             bid = ICObid;
336         }
337 
338         return bid;
339     }
340 
341     /// @notice Buys aToken in exchnage for wei at the current ask price
342     /// @return refunds remainder of wei from purchase   
343     function buy() public payable returns (uint256 amount){
344         uint256 refund = 0;
345         debugVal = 0;
346         
347         if(initialSaleComplete)
348         {
349             uint256 units_to_buy = 0;
350 
351             uint256 etherRemaining = msg.value;             // (wei)
352             uint256 etherToReserve = 0;                     // (wei)
353 
354             debugVal = fracExp(S, R, (_totalSupply/1e18),P);
355             debugVal2 = RS*msg.value;
356             debugVal3 = RS*msg.value/1e18 + fracExp(S, R, (_totalSupply/1e18),P);
357             debugVal4 = (ln(debugVal3,1)-lnS);//*lnR-1;
358             units_to_buy = debugVal4;
359 
360 
361             reserveAddress.transfer(etherToReserve);        // send the ask amount to the reserve
362             mintToken(msg.sender, amount);                  // Mint the coin
363             refund = etherRemaining;
364             msg.sender.transfer(refund);                    // Issue refund            
365         }
366         else
367         {
368             // TODO don't sell more than the ICO amount if one transaction is huge
369             ask = ICOask;                                   // ICO sale price (wei/Token)
370             amount = 1e18*msg.value / ask;                  // calculates the amount of aToken (1e18*wei/(wei/Token))
371             refund = msg.value - (amount*ask/1e18);         // calculate refund (wei)
372 
373             // TODO test for overflow attack
374             reserveAddress.transfer(msg.value - refund);    // send the full amount of the sale to reserve
375             msg.sender.transfer(refund);                    // Issue refund
376             balances[reserveAddress] += msg.value-refund;  // All other addresses hold Token Coin, reserveAddress represents ether
377             mintToken(msg.sender, amount);                  // Mint the coin (aToken)
378 
379             if(_totalSupply >= ICOAmount)
380             {
381                 initialSaleComplete = true;
382             }             
383         }
384         
385         
386         return amount;                                    // ends function and returns
387     }
388 
389     /// @notice Sells aToken in exchnage for wei at the current bid 
390     /// price, reduces resreve
391     /// @return Proceeds of wei from sale of aToken
392     function sell(uint amount) public returns (uint revenue){
393         require(initialSaleComplete);
394         require(balances[msg.sender] >= bid);            // checks if the sender has enough to sell
395         balances[reserveAddress] += amount;                        // adds the amount to owner's balance
396         balances[msg.sender] -= amount;                  // subtracts the amount from seller's balance
397         revenue = amount * bid;
398         require(msg.sender.send(revenue));                // sends ether to the seller: it's important to do this last to prevent recursion attacks
399         emit Transfer(msg.sender, reserveAddress, amount);               // executes an event reflecting on the change
400         return revenue;                                   // ends function and returns
401     }    
402     
403     /// @notice Create `mintedAmount` tokens and send it to `target`
404     /// @param target Address to receive the tokens
405     /// @param mintedAmount the amount of tokens it will receive
406     function mintToken(address target, uint256 mintedAmount) public {
407         balances[target] += mintedAmount;
408         _totalSupply += mintedAmount;
409         emit Transfer(0, this, mintedAmount);
410         emit Transfer(this, target, mintedAmount);
411     }    
412     
413 
414     /// @notice Compute '_k * (1+1/_q) ^ _n', with precision '_p'
415     /// @dev The higher the precision, the higher the gas cost. It should be
416     /// something around the log of 'n'. When 'p == n', the
417     /// precision is absolute (sans possible integer overflows).
418     /// Much smaller values are sufficient to get a great approximation.
419     /// @param _k input param k
420     /// @param _q input param q
421     /// @param _n input param n
422     /// @param _p input param p
423     /// @return '_k * (1+1/_q) ^ _n'   
424     function fracExp(uint256 _k, uint256 _q, uint256 _n, uint256 _p) public pure returns (uint256) {
425       uint256 s = 0;
426       uint256 N = 1;
427       uint256 B = 1;
428       for (uint256 i = 0; i < _p; ++i){
429         s += _k * N / B / (_q**i);
430         N  = N * (_n-i);
431         B  = B * (i+1);
432       }
433       return s;
434     }
435     
436     /// @notice Compute the natural logarithm
437     /// @dev This functions assumes that the numerator is larger than or equal 
438     /// to the denominator, because the output would be negative otherwise.
439     /// @param _numerator is a value between 1 and 2 ^ (256 - MAX_PRECISION) - 1
440     /// @param _denominator is a value between 1 and 2 ^ (256 - MAX_PRECISION) - 1
441     /// @return is a value between 0 and floor(ln(2 ^ (256 - MAX_PRECISION) - 1) * 2 ^ MAX_PRECISION)
442     function ln(uint256 _numerator, uint256 _denominator) internal pure returns (uint256) {
443         assert(_numerator <= MAX_NUM);
444 
445         uint256 res = 0;
446         uint256 x = _numerator * FIXED_1 / _denominator;
447 
448         // If x >= 2, then we compute the integer part of log2(x), which is larger than 0.
449         if (x >= FIXED_2) {
450             uint8 count = floorLog2(x / FIXED_1);
451             x >>= count; // now x < 2
452             res = count * FIXED_1;
453         }
454 
455         // If x > 1, then we compute the fraction part of log2(x), which is larger than 0.
456         if (x > FIXED_1) {
457             for (uint8 i = MAX_PRECISION; i > 0; --i) {
458                 x = (x * x) / FIXED_1; // now 1 < x < 4
459                 if (x >= FIXED_2) {
460                     x >>= 1; // now 1 < x < 2
461                     res += ONE << (i - 1);
462                 }
463             }
464         }
465         
466         return ((res * LN2_MANTISSA) >> LN2_EXPONENT) / FIXED_3;
467     }
468 
469     /// @notice Compute the largest integer smaller than or equal to 
470     /// the binary logarithm of the input
471     /// @param _n Operand of the function
472     /// @return Floor(Log2(_n))
473     function floorLog2(uint256 _n) internal pure returns (uint8) {
474         uint8 res = 0;
475 
476         if (_n < 256) {
477             // At most 8 iterations
478             while (_n > 1) {
479                 _n >>= 1;
480                 res += 1;
481             }
482         }
483         else {
484             // Exactly 8 iterations
485             for (uint8 s = 128; s > 0; s >>= 1) {
486                 if (_n >= (ONE << s)) {
487                     _n >>= s;
488                     res |= s;
489                 }
490             }
491         }
492 
493         return res;
494     }    
495   
496 }