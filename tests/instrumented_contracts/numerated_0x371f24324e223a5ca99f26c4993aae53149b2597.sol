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
31     function totalSupply() public view returns (uint);
32     function balanceOf(address tokenOwner) public view returns (uint balance);
33     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
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
95     
96     function sendFunds(address receiver, uint amount) public {
97         receiver.transfer(amount);
98     }    
99 }
100 
101 // ----------------------------------------------------------------------------
102 // ERC20 Default Token
103 // ----------------------------------------------------------------------------
104 contract DeaultERC20 is ERC20Interface, Owned {
105     using SafeMath for uint;
106 
107     string public symbol;
108     string public  name;
109     uint8 public decimals;
110     uint public _totalSupply;
111 
112     mapping(address => uint) balances;
113     mapping(address => mapping(address => uint)) allowed;
114 
115 
116     // ------------------------------------------------------------------------
117     // Constructor
118     // ------------------------------------------------------------------------
119     constructor() public {
120         symbol = "DFLT";
121         name = "Default";
122         decimals = 18;
123     }
124 
125     // ------------------------------------------------------------------------
126     // Total supply
127     // ---------------------------------------------------------allowance---------------
128     function totalSupply() public view returns (uint) {
129         return _totalSupply  - balances[address(0)];
130     }
131 
132     // ------------------------------------------------------------------------
133     // Get the token balance for account `tokenOwner`
134     // ------------------------------------------------------------------------
135     function balanceOf(address tokenOwner) public view returns (uint balance) {
136         return balances[tokenOwner];
137     }
138 
139     // ------------------------------------------------------------------------
140     // Transfer the balance from token owner's account to `to` account
141     // - Owner's account must have sufficient balance to transfer
142     // - 0 value transfers are allowed
143     // ------------------------------------------------------------------------
144     function transfer(address to, uint tokens) public returns (bool success) {
145         balances[msg.sender] = balances[msg.sender].sub(tokens);
146         balances[to] = balances[to].add(tokens);
147         emit Transfer(msg.sender, to, tokens);
148         return true;
149     }
150 
151     // ------------------------------------------------------------------------
152     // Token owner can approve for `spender` to transferFrom(...) `tokens`
153     // from the token owner's account
154     //
155     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
156     // recommends that there are no checks for the approval double-spend attack
157     // as this should be implemented in user interfaces 
158     // ------------------------------------------------------------------------
159     function approve(address spender, uint tokens) public returns (bool success) {
160         allowed[msg.sender][spender] = tokens;
161         emit Approval(msg.sender, spender, tokens);
162         return true;
163     }
164 
165     // ------------------------------------------------------------------------
166     // Transfer `tokens` from the `from` account to the `to` account
167     // 
168     // The calling account must already have sufficient tokens approve(...)-d
169     // for spending from the `from` account and
170     // - From account must have sufficient balance to transfer
171     // - Spender must have sufficient allowance to transfer
172     // - 0 value transfers are allowed
173     // ------------------------------------------------------------------------
174     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
175         balances[from] = balances[from].sub(tokens);
176         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
177         balances[to] = balances[to].add(tokens);
178         emit Transfer(from, to, tokens);
179         return true;
180     }
181 
182     // ------------------------------------------------------------------------
183     // Returns the amount of tokens approved by the owner that can be
184     // transferred to the spender's account
185     // ------------------------------------------------------------------------
186     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
187         return allowed[tokenOwner][spender];
188     }
189 
190     // ------------------------------------------------------------------------
191     // Token owner can approve for `spender` to transferFrom(...) `tokens`
192     // from the token owner's account. The `spender` contract function
193     // `receiveApproval(...)` is then executed
194     // ------------------------------------------------------------------------
195     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
196         allowed[msg.sender][spender] = tokens;
197         emit Approval(msg.sender, spender, tokens);
198         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
199         return true;
200     }
201 
202     // ------------------------------------------------------------------------
203     // Don't accept ETH
204     // ------------------------------------------------------------------------
205     function () public payable {
206         revert();
207     }
208 }
209 
210 // ----------------------------------------------------------------------------
211 // IGCoin
212 // ----------------------------------------------------------------------------
213 contract IGCoin is DeaultERC20 {
214     using SafeMath for uint;
215 
216     address public reserveAddress; // wei
217     uint256 public ask;
218     uint256 public bid;
219     uint16 public constant reserveRate = 10;
220     bool public initialSaleComplete;
221     uint256 constant private ICOAmount = 2e0*1e16; // in aToken
222     uint256 constant private ICOask = 1e0*1e16; // in wei per Token
223     uint256 constant private ICObid = 0; // in wei per Token
224     uint256 constant private InitialSupply = 1e0 * 1e16; // Number of tokens (aToken) minted when contract created
225 /*    uint256 public debugVal;
226     uint256 public debugVal2;
227     uint256 public debugVal3;
228     uint256 public debugVal4;*/
229     uint256 constant private R = 125000;  // matlab R=1.000008, this R=1/(1.000008-1)
230     uint256 constant private P = 10; // precision
231     uint256 constant private lnR = R; // 1/ln(R)   (matlab R)
232     uint256 constant private S = 1e8; // s.t. S*R = integer
233     uint256 constant private RS = 800; // 1.000008*S-S=8
234     uint256 constant private lnS = 18; // ln(S) = 18
235     uint256 constant private lnRS = 391764552740441533402669241351723684867125000;// FIXED_3 * ln(S)/ln(R) // ln(S)/ln(R) (matlab R)
236     uint256 private refund = 0;
237     uint256 constant SU = 1e15; 
238     
239     /* Constants to support ln() */
240     uint256 private constant ONE = 1;
241     uint8 private constant MAX_PRECISION = 127;
242     uint256 private constant FIXED_1 = 0x080000000000000000000000000000000;
243     uint256 private constant FIXED_2 = 0x100000000000000000000000000000000;
244     uint256 private constant MAX_NUM = 0x1ffffffffffffffffffffffffffffffff;
245     uint256 private constant FIXED_3 = 0x07fffffffffffffffffffffffffffffff;//0x03fffffffffffffffffffffffffffffff;//0x07fffffffffffffffffffffffffffffff;
246     uint256 private constant LN2_MANTISSA = 0x2c5c85fdf473de6af278ece600fcbda;
247     uint8   private constant LN2_EXPONENT = 122;
248     
249     /**
250         Auto-generated via 'PrintFunctionBancorFormula.py'
251     */
252     uint256[128] private maxExpArray;    
253     
254     
255     
256     
257     uint32 private constant MAX_WEIGHT = 1000000;
258     uint8 private constant MIN_PRECISION = 120;
259 
260     /**
261         Auto-generated via 'PrintLn2ScalingFactors.py'
262     */
263     uint256 private constant LN2_NUMERATOR   = 0x3f80fe03f80fe03f80fe03f80fe03f8;
264     uint256 private constant LN2_DENOMINATOR = 0x5b9de1d10bf4103d647b0955897ba80;
265 
266     /**
267         Auto-generated via 'PrintFunctionOptimalLog.py' and 'PrintFunctionOptimalExp.py'
268     */
269     uint256 private constant OPT_LOG_MAX_VAL = 0x15bf0a8b1457695355fb8ac404e7a79e3; // 462491687273110168575455517921668397539
270     uint256 private constant OPT_EXP_MAX_VAL = 0x800000000000000000000000000000000; // 2722258935367507707706996859454145691648 2^131
271 
272 
273     mapping (address => bool) public frozenAccount;
274     event FrozenFunds(address target, bool frozen); 
275 
276     // ------------------------------------------------------------------------
277     // Constructor
278     // ------------------------------------------------------------------------
279     constructor() public {
280         symbol = "IG17";
281         name = "theTestToken002";
282         decimals = 18;
283         initialSaleComplete = false;
284         _totalSupply = InitialSupply;  // Keep track of all IG Coins created, ever
285         balances[owner] = _totalSupply;  // Give the creator all initial IG coins
286         emit Transfer(address(0), owner, _totalSupply);
287 
288         reserveAddress = new Contract("Reserve");  // Create contract to hold reserve
289         quoteAsk();
290         quoteBid();        
291 
292         
293         
294         
295     //  maxExpArray[  0] = 0x6bffffffffffffffffffffffffffffffff;
296     //  maxExpArray[  1] = 0x67ffffffffffffffffffffffffffffffff;
297     //  maxExpArray[  2] = 0x637fffffffffffffffffffffffffffffff;
298     //  maxExpArray[  3] = 0x5f6fffffffffffffffffffffffffffffff;
299     //  maxExpArray[  4] = 0x5b77ffffffffffffffffffffffffffffff;
300     //  maxExpArray[  5] = 0x57b3ffffffffffffffffffffffffffffff;
301     //  maxExpArray[  6] = 0x5419ffffffffffffffffffffffffffffff;
302     //  maxExpArray[  7] = 0x50a2ffffffffffffffffffffffffffffff;
303     //  maxExpArray[  8] = 0x4d517fffffffffffffffffffffffffffff;
304     //  maxExpArray[  9] = 0x4a233fffffffffffffffffffffffffffff;
305     //  maxExpArray[ 10] = 0x47165fffffffffffffffffffffffffffff;
306     //  maxExpArray[ 11] = 0x4429afffffffffffffffffffffffffffff;
307     //  maxExpArray[ 12] = 0x415bc7ffffffffffffffffffffffffffff;
308     //  maxExpArray[ 13] = 0x3eab73ffffffffffffffffffffffffffff;
309     //  maxExpArray[ 14] = 0x3c1771ffffffffffffffffffffffffffff;
310     //  maxExpArray[ 15] = 0x399e96ffffffffffffffffffffffffffff;
311     //  maxExpArray[ 16] = 0x373fc47fffffffffffffffffffffffffff;
312     //  maxExpArray[ 17] = 0x34f9e8ffffffffffffffffffffffffffff;
313     //  maxExpArray[ 18] = 0x32cbfd5fffffffffffffffffffffffffff;
314     //  maxExpArray[ 19] = 0x30b5057fffffffffffffffffffffffffff;
315     //  maxExpArray[ 20] = 0x2eb40f9fffffffffffffffffffffffffff;
316     //  maxExpArray[ 21] = 0x2cc8340fffffffffffffffffffffffffff;
317     //  maxExpArray[ 22] = 0x2af09481ffffffffffffffffffffffffff;
318     //  maxExpArray[ 23] = 0x292c5bddffffffffffffffffffffffffff;
319     //  maxExpArray[ 24] = 0x277abdcdffffffffffffffffffffffffff;
320     //  maxExpArray[ 25] = 0x25daf6657fffffffffffffffffffffffff;
321     //  maxExpArray[ 26] = 0x244c49c65fffffffffffffffffffffffff;
322     //  maxExpArray[ 27] = 0x22ce03cd5fffffffffffffffffffffffff;
323     //  maxExpArray[ 28] = 0x215f77c047ffffffffffffffffffffffff;
324     //  maxExpArray[ 29] = 0x1fffffffffffffffffffffffffffffffff;
325     //  maxExpArray[ 30] = 0x1eaefdbdabffffffffffffffffffffffff;
326     //  maxExpArray[ 31] = 0x1d6bd8b2ebffffffffffffffffffffffff;
327     /*    maxExpArray[ 32] = 0x1c35fedd14ffffffffffffffffffffffff;
328         maxExpArray[ 33] = 0x1b0ce43b323fffffffffffffffffffffff;
329         maxExpArray[ 34] = 0x19f0028ec1ffffffffffffffffffffffff;
330         maxExpArray[ 35] = 0x18ded91f0e7fffffffffffffffffffffff;
331         maxExpArray[ 36] = 0x17d8ec7f0417ffffffffffffffffffffff;
332         maxExpArray[ 37] = 0x16ddc6556cdbffffffffffffffffffffff;
333         maxExpArray[ 38] = 0x15ecf52776a1ffffffffffffffffffffff;
334         maxExpArray[ 39] = 0x15060c256cb2ffffffffffffffffffffff;
335         maxExpArray[ 40] = 0x1428a2f98d72ffffffffffffffffffffff;
336         maxExpArray[ 41] = 0x13545598e5c23fffffffffffffffffffff;
337         maxExpArray[ 42] = 0x1288c4161ce1dfffffffffffffffffffff;
338         maxExpArray[ 43] = 0x11c592761c666fffffffffffffffffffff;
339         maxExpArray[ 44] = 0x110a688680a757ffffffffffffffffffff;
340         maxExpArray[ 45] = 0x1056f1b5bedf77ffffffffffffffffffff;
341         maxExpArray[ 46] = 0x0faadceceeff8bffffffffffffffffffff;
342         maxExpArray[ 47] = 0x0f05dc6b27edadffffffffffffffffffff;
343         maxExpArray[ 48] = 0x0e67a5a25da4107fffffffffffffffffff;
344         maxExpArray[ 49] = 0x0dcff115b14eedffffffffffffffffffff;
345         maxExpArray[ 50] = 0x0d3e7a392431239fffffffffffffffffff;
346         maxExpArray[ 51] = 0x0cb2ff529eb71e4fffffffffffffffffff;
347         maxExpArray[ 52] = 0x0c2d415c3db974afffffffffffffffffff;
348         maxExpArray[ 53] = 0x0bad03e7d883f69bffffffffffffffffff;
349         maxExpArray[ 54] = 0x0b320d03b2c343d5ffffffffffffffffff;
350         maxExpArray[ 55] = 0x0abc25204e02828dffffffffffffffffff;
351         maxExpArray[ 56] = 0x0a4b16f74ee4bb207fffffffffffffffff;
352         maxExpArray[ 57] = 0x09deaf736ac1f569ffffffffffffffffff;
353         maxExpArray[ 58] = 0x0976bd9952c7aa957fffffffffffffffff;
354         maxExpArray[ 59] = 0x09131271922eaa606fffffffffffffffff;
355         maxExpArray[ 60] = 0x08b380f3558668c46fffffffffffffffff;
356         maxExpArray[ 61] = 0x0857ddf0117efa215bffffffffffffffff;
357         maxExpArray[ 62] = 0x07ffffffffffffffffffffffffffffffff;
358         maxExpArray[ 63] = 0x07abbf6f6abb9d087fffffffffffffffff;
359         maxExpArray[ 64] = 0x075af62cbac95f7dfa7fffffffffffffff;
360         maxExpArray[ 65] = 0x070d7fb7452e187ac13fffffffffffffff;
361         maxExpArray[ 66] = 0x06c3390ecc8af379295fffffffffffffff;
362         maxExpArray[ 67] = 0x067c00a3b07ffc01fd6fffffffffffffff;
363         maxExpArray[ 68] = 0x0637b647c39cbb9d3d27ffffffffffffff;
364         maxExpArray[ 69] = 0x05f63b1fc104dbd39587ffffffffffffff;
365         maxExpArray[ 70] = 0x05b771955b36e12f7235ffffffffffffff;
366         maxExpArray[ 71] = 0x057b3d49dda84556d6f6ffffffffffffff;
367         maxExpArray[ 72] = 0x054183095b2c8ececf30ffffffffffffff;
368         maxExpArray[ 73] = 0x050a28be635ca2b888f77fffffffffffff;
369         maxExpArray[ 74] = 0x04d5156639708c9db33c3fffffffffffff;
370         maxExpArray[ 75] = 0x04a23105873875bd52dfdfffffffffffff;
371         maxExpArray[ 76] = 0x0471649d87199aa990756fffffffffffff;
372         maxExpArray[ 77] = 0x04429a21a029d4c1457cfbffffffffffff;
373         maxExpArray[ 78] = 0x0415bc6d6fb7dd71af2cb3ffffffffffff;
374         maxExpArray[ 79] = 0x03eab73b3bbfe282243ce1ffffffffffff;
375         maxExpArray[ 80] = 0x03c1771ac9fb6b4c18e229ffffffffffff;
376         maxExpArray[ 81] = 0x0399e96897690418f785257fffffffffff;
377         maxExpArray[ 82] = 0x0373fc456c53bb779bf0ea9fffffffffff;
378         maxExpArray[ 83] = 0x034f9e8e490c48e67e6ab8bfffffffffff;
379         maxExpArray[ 84] = 0x032cbfd4a7adc790560b3337ffffffffff;
380         maxExpArray[ 85] = 0x030b50570f6e5d2acca94613ffffffffff;
381         maxExpArray[ 86] = 0x02eb40f9f620fda6b56c2861ffffffffff;
382         maxExpArray[ 87] = 0x02cc8340ecb0d0f520a6af58ffffffffff;
383         maxExpArray[ 88] = 0x02af09481380a0a35cf1ba02ffffffffff;
384         maxExpArray[ 89] = 0x0292c5bdd3b92ec810287b1b3fffffffff;
385         maxExpArray[ 90] = 0x0277abdcdab07d5a77ac6d6b9fffffffff;
386         maxExpArray[ 91] = 0x025daf6654b1eaa55fd64df5efffffffff;
387         maxExpArray[ 92] = 0x0244c49c648baa98192dce88b7ffffffff;
388         maxExpArray[ 93] = 0x022ce03cd5619a311b2471268bffffffff;
389         maxExpArray[ 94] = 0x0215f77c045fbe885654a44a0fffffffff;
390         maxExpArray[ 95] = 0x01ffffffffffffffffffffffffffffffff;
391         maxExpArray[ 96] = 0x01eaefdbdaaee7421fc4d3ede5ffffffff;
392         maxExpArray[ 97] = 0x01d6bd8b2eb257df7e8ca57b09bfffffff;
393         maxExpArray[ 98] = 0x01c35fedd14b861eb0443f7f133fffffff;
394         maxExpArray[ 99] = 0x01b0ce43b322bcde4a56e8ada5afffffff;
395         maxExpArray[100] = 0x019f0028ec1fff007f5a195a39dfffffff;
396         maxExpArray[101] = 0x018ded91f0e72ee74f49b15ba527ffffff;
397         maxExpArray[102] = 0x017d8ec7f04136f4e5615fd41a63ffffff;
398         maxExpArray[103] = 0x016ddc6556cdb84bdc8d12d22e6fffffff;
399         maxExpArray[104] = 0x015ecf52776a1155b5bd8395814f7fffff;
400         maxExpArray[105] = 0x015060c256cb23b3b3cc3754cf40ffffff;
401         maxExpArray[106] = 0x01428a2f98d728ae223ddab715be3fffff;
402         maxExpArray[107] = 0x013545598e5c23276ccf0ede68034fffff;
403         maxExpArray[108] = 0x01288c4161ce1d6f54b7f61081194fffff;
404         maxExpArray[109] = 0x011c592761c666aa641d5a01a40f17ffff;
405         maxExpArray[110] = 0x0110a688680a7530515f3e6e6cfdcdffff;
406         maxExpArray[111] = 0x01056f1b5bedf75c6bcb2ce8aed428ffff;
407         maxExpArray[112] = 0x00faadceceeff8a0890f3875f008277fff;
408         maxExpArray[113] = 0x00f05dc6b27edad306388a600f6ba0bfff;
409         maxExpArray[114] = 0x00e67a5a25da41063de1495d5b18cdbfff;
410         maxExpArray[115] = 0x00dcff115b14eedde6fc3aa5353f2e4fff;
411         maxExpArray[116] = 0x00d3e7a3924312399f9aae2e0f868f8fff;
412         maxExpArray[117] = 0x00cb2ff529eb71e41582cccd5a1ee26fff;
413         maxExpArray[118] = 0x00c2d415c3db974ab32a51840c0b67edff;
414         maxExpArray[119] = 0x00bad03e7d883f69ad5b0a186184e06bff;*/
415         maxExpArray[120] = 0x00b320d03b2c343d4829abd6075f0cc5ff;
416         maxExpArray[121] = 0x00abc25204e02828d73c6e80bcdb1a95bf;
417         maxExpArray[122] = 0x00a4b16f74ee4bb2040a1ec6c15fbbf2df;
418         maxExpArray[123] = 0x009deaf736ac1f569deb1b5ae3f36c130f;
419         maxExpArray[124] = 0x00976bd9952c7aa957f5937d790ef65037;
420         maxExpArray[125] = 0x009131271922eaa6064b73a22d0bd4f2bf;
421         maxExpArray[126] = 0x008b380f3558668c46c91c49a2f8e967b9;
422         maxExpArray[127] = 0x00857ddf0117efa215952912839f6473e6;       
423     }
424     
425 
426     /// @notice Deposits '_value' in wei to the reserve address
427     /// @param _value The number of wei to be transferred to the 
428     /// reserve address
429     function deposit(uint256 _value) private {
430         reserveAddress.transfer(_value);
431         balances[reserveAddress] += _value;
432     }
433   
434     /// @notice Withdraws '_value' in wei from the reserve address
435     /// @param _value The number of wei to be transferred from the 
436     /// reserve address    
437     function withdraw(uint256 _value) private pure {
438         // TODO
439          _value = _value;
440     }
441     
442     /// @notice Transfers '_value' in aToken to the '_to' address
443     /// @param _to The recipient address
444     /// @param _value The amount of wei to transfer
445     function transfer(address _to, uint256 _value) public returns (bool success) {
446         /* Check if sender has balance and for overflows */
447         require(balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]);
448         
449         /* Check if amount is nonzero */
450         require(_value > 0);
451 
452         /* Add and subtract new balances */
453         balances[msg.sender] -= _value;
454         balances[_to] += _value;
455     
456         /* Notify anyone listening that this transfer took place */
457         emit Transfer(msg.sender, _to, _value);
458         
459         return true;
460     }
461     
462     /// @notice `freeze? Prevent | Allow` `target` from sending 
463     /// & receiving tokens
464     /// @param _target Address to be frozen
465     /// @param _freeze either to freeze it or not
466     function freezeAccount(address _target, bool _freeze) public onlyOwner {
467         frozenAccount[_target] = _freeze;
468         emit FrozenFunds(_target, _freeze);
469     }    
470  
471     /// @notice Calculates the ask price in wei per aToken based on the 
472     /// current reserve amount
473     /// @return Price of aToken in wei
474     function quoteAsk() private returns (uint256) {
475         if(initialSaleComplete)
476         {
477             ask = fracExp(1e16, R, (_totalSupply/1e16)+1, P);
478         }
479         else
480         {
481             ask = ICOask;
482         }
483         
484         return ask;
485     }
486     
487     /// @notice Calculates the bid price in wei per aToken based on the 
488     /// current reserve amount
489     /// @return Price of aToken in wei    
490     function quoteBid() private returns (uint256) {
491         if(initialSaleComplete)
492         {
493             bid = fracExp(1e16, R, (_totalSupply/1e16)-1, P);
494         }
495         else
496         {
497             bid = ICObid;
498         }
499 
500         return bid;
501     }
502 
503     /// @notice Buys aToken in exchnage for wei at the current ask price
504     /// @return refunds remainder of wei from purchase   
505     function buy() public payable returns (uint256 amount){
506 
507         if(initialSaleComplete)
508         {
509             uint256 b = 0;
510             uint256 p = 0;
511             uint8 ps = 0;
512 
513             (p, ps) = power(1000008,1000000,(uint32)(1+_totalSupply/SU),1); // Calculate exponent
514             p=(S*p)>>ps;
515             
516             //b = ((ln_fixed3_lnr_18( RS*msg.value/SU + fracExp(S, R, (1+_totalSupply/1e16),P),1))-1e18*lnRS-1e18*FIXED_3)/FIXED_3;
517             b = (ln_fixed3_lnr_18(RS*msg.value/SU + p,1)-1e18*lnRS-1e18*FIXED_3)/FIXED_3; // b * 1e18
518 
519             refund = msg.value - (msg.value/SU)*SU;
520             amount = b*SU/1e18-_totalSupply;
521             //debugVal = b;
522             //debugVal2 = (msg.value/SU)*SU;
523             //debugVal3 = refund;
524             //debugVal4 = amount;
525 
526             reserveAddress.transfer((msg.value/SU)*SU);     // send the ask amount to the reserve
527             balances[reserveAddress] += msg.value-refund;   // All other addresses hold Token Coin, reserveAddress represents ether
528             mintToken(msg.sender, amount);                  // Mint the coin
529             msg.sender.transfer(refund);                    // Issue refund
530             quoteAsk();
531             quoteBid();
532         }
533         else
534         {
535             // TODO don't sell more than the ICO amount if one transaction is huge
536             //debugVal = msg.value;
537             ask = ICOask;                                   // ICO sale price (wei/Token)
538             amount = 1e16*msg.value / ask;                  // calculates the amount of aToken (1e18*wei/(wei/Token))
539             refund = msg.value - (amount*ask/1e16);         // calculate refund (wei)
540 
541             // TODO test for overflow attack
542             reserveAddress.transfer(msg.value - refund);    // send the full amount of the sale to reserve
543             msg.sender.transfer(refund);                    // Issue refund
544             balances[reserveAddress] += msg.value-refund;   // All other addresses hold Token Coin, reserveAddress represents ether
545             mintToken(msg.sender, amount);                  // Mint the coin (aToken)
546 
547             if(_totalSupply >= ICOAmount)
548             {
549                 initialSaleComplete = true;
550             }             
551         }
552         
553         
554         return amount;                                    // ends function and returns
555     }
556 
557     /// @notice Sells aToken in exchnage for wei at the current bid 
558     /// price, reduces resreve
559     /// @return Proceeds of wei from sale of aToken
560     function sell(uint256 amount) public returns (uint256 revenue){
561         uint256 a = 0;
562         
563         require(initialSaleComplete);
564         require(balances[msg.sender] >= amount);        // checks if the sender has enough to sell
565         
566         a = _totalSupply - amount;
567 
568         uint256 p = 0;
569         uint8 ps = 0;
570 
571         (p, ps) = power(1000008,1000000,(uint32)(1e5+1e5*_totalSupply/SU),1e5); // Calculate exponent
572         p=(S*p)>>ps;
573 
574         uint256 p2 = 0;
575         uint8 ps2 = 0;
576 
577         (p2, ps2) = power(1000008,1000000,(uint32)(1e5+1e5*a/SU),1e5); // Calculate exponent
578         p2=(S*p2)>>ps2;
579 
580             
581 
582         revenue = (SU*p-SU*p2)*R/S;
583         
584        // debugVal2 = revenue;
585         //debugVal3 = p;
586         //debugVal4 = p2;
587         
588         _totalSupply -= amount;                 // burn the tokens
589         require(balances[reserveAddress] >= revenue);
590         balances[reserveAddress] -= revenue;             // adds the amount to owner's balance
591         balances[msg.sender] -= amount;                 // subtracts the amount from seller's balance
592         Contract reserve = Contract(reserveAddress);
593         reserve.sendFunds(msg.sender, revenue);
594         
595         emit Transfer(msg.sender, reserveAddress, amount);               // executes an event reflecting on the change
596 
597         quoteAsk();
598         quoteBid();  
599 
600         return revenue;                                 // ends function and returns
601     }    
602     
603     /// @notice Create `mintedAmount` tokens and send it to `target`
604     /// @param target Address to receive the tokens
605     /// @param mintedAmount the amount of tokens it will receive
606     function mintToken(address target, uint256 mintedAmount) public {
607         balances[target] += mintedAmount;
608         _totalSupply += mintedAmount;
609         
610         emit Transfer(address(0), this, mintedAmount);
611         emit Transfer(this, target, mintedAmount);
612     }    
613     
614 
615     /// @notice Compute '_k * (1+1/_q) ^ _n', with precision '_p'
616     /// @dev The higher the precision, the higher the gas cost. It should be
617     /// something around the log of 'n'. When 'p == n', the
618     /// precision is absolute (sans possible integer overflows).
619     /// Much smaller values are sufficient to get a great approximation.
620     /// @param _k input param k
621     /// @param _q input param q
622     /// @param _n input param n
623     /// @param _p input param p
624     /// @return '_k * (1+1/_q) ^ _n'   
625     function fracExp(uint256 _k, uint256 _q, uint256 _n, uint256 _p) internal pure returns (uint256) {
626       uint256 s = 0;
627       uint256 N = 1;
628       uint256 B = 1;
629       for (uint256 i = 0; i < _p; ++i){
630         s += _k * N / B / (_q**i);
631         N  = N * (_n-i);
632         B  = B * (i+1);
633       }
634       return s;
635     }
636     
637     /// @notice Compute the natural logarithm
638     /// @dev This functions assumes that the numerator is larger than or equal 
639     /// to the denominator, because the output would be negative otherwise.
640     /// @param _numerator is a value between 1 and 2 ^ (256 - MAX_PRECISION) - 1
641     /// @param _denominator is a value between 1 and 2 ^ (256 - MAX_PRECISION) - 1
642     /// @return is a value between 0 and floor(ln(2 ^ (256 - MAX_PRECISION) - 1) * 2 ^ MAX_PRECISION)
643 /*    function ln(uint256 _numerator, uint256 _denominator) internal pure returns (uint256) {
644         assert(_numerator <= MAX_NUM);
645 
646         uint256 res = 0;
647         uint256 x = _numerator * FIXED_1 / _denominator;
648 
649         // If x >= 2, then we compute the integer part of log2(x), which is larger than 0.
650         if (x >= FIXED_2) {
651             uint8 count = floorLog2(x / FIXED_1);
652             x >>= count; // now x < 2
653             res = count * FIXED_1;
654         }
655 
656         // If x > 1, then we compute the fraction part of log2(x), which is larger than 0.
657         if (x > FIXED_1) {
658             for (uint8 i = MAX_PRECISION; i > 0; --i) {
659                 x = (x * x) / FIXED_1; // now 1 < x < 4
660                 if (x >= FIXED_2) {
661                     x >>= 1; // now 1 < x < 2
662                     res += ONE << (i - 1);
663                 }
664             }
665         }
666 
667         return ((res * LN2_MANTISSA) >> LN2_EXPONENT) / FIXED_3;
668     }
669 */    
670     /// @notice Compute the natural logarithm
671     /// @notice outputs ln()*FIXED_3
672     /// @dev This functions assumes that the numerator is larger than or equal 
673     /// to the denominator, because the output would be negative otherwise.
674     /// @param _numerator is a value between 1 and 2 ^ (256 - MAX_PRECISION) - 1
675     /// @param _denominator is a value between 1 and 2 ^ (256 - MAX_PRECISION) - 1
676     /// @return is a value between 0 and floor(ln(2 ^ (256 - MAX_PRECISION) - 1) * 2 ^ MAX_PRECISION)
677 /*    function ln_fixed3(uint256 _numerator, uint256 _denominator) private pure returns (uint256) {
678         assert(_numerator <= MAX_NUM);
679 
680         uint256 res = 0;
681         uint256 x = _numerator * FIXED_1 / _denominator;
682 
683         // If x >= 2, then we compute the integer part of log2(x), which is larger than 0.
684         if (x >= FIXED_2) {
685             uint8 count = floorLog2(x / FIXED_1);
686             x >>= count; // now x < 2
687             res = count * FIXED_1;
688         }
689 
690         // If x > 1, then we compute the fraction part of log2(x), which is larger than 0.
691         if (x > FIXED_1) {
692             for (uint8 i = MAX_PRECISION; i > 0; --i) {
693                 x = (x * x) / FIXED_1; // now 1 < x < 4
694                 if (x >= FIXED_2) {
695                     x >>= 1; // now 1 < x < 2
696                     res += ONE << (i - 1);
697                 }
698             }
699         }
700 
701         return ((res * LN2_MANTISSA) >> LN2_EXPONENT);
702     }
703 */    
704     /// @notice Compute the natural logarithm
705     /// @notice outputs ln()*FIXED_3*lnr
706     /// @dev This functions assumes that the numerator is larger than or equal 
707     /// to the denominator, because the output would be negative otherwise.
708     /// @param _numerator is a value between 1 and 2 ^ (256 - MAX_PRECISION) - 1
709     /// @param _denominator is a value between 1 and 2 ^ (256 - MAX_PRECISION) - 1
710     /// @return is a value between 0 and floor(ln(2 ^ (256 - MAX_PRECISION) - 1) * 2 ^ MAX_PRECISION)
711 /*    function ln_fixed3_lnr(uint256 _numerator, uint256 _denominator) internal pure returns (uint256) {
712         assert(_numerator <= MAX_NUM);
713 
714         uint256 res = 0;
715         uint256 x = _numerator * FIXED_1 / _denominator;
716 
717         // If x >= 2, then we compute the integer part of log2(x), which is larger than 0.
718         if (x >= FIXED_2) {
719             uint8 count = floorLog2(x / FIXED_1);
720             x >>= count; // now x < 2
721             res = count * FIXED_1;
722         }
723 
724         // If x > 1, then we compute the fraction part of log2(x), which is larger than 0.
725         if (x > FIXED_1) {
726             for (uint8 i = MAX_PRECISION; i > 0; --i) {
727                 x = (x * x) / FIXED_1; // now 1 < x < 4
728                 if (x >= FIXED_2) {
729                     x >>= 1; // now 1 < x < 2
730                     res += ONE << (i - 1);
731                 }
732             }
733         }
734 
735         return (((res * LN2_MANTISSA) >> LN2_EXPONENT)*lnR);
736     }    
737 */    
738     /// @notice Compute the natural logarithm
739     /// @notice outputs ln()*FIXED_3*lnr*1e18
740     /// @dev This functions assumes that the numerator is larger than or equal 
741     /// to the denominator, because the output would be negative otherwise.
742     /// @param _numerator is a value between 1 and 2 ^ (256 - MAX_PRECISION) - 1
743     /// @param _denominator is a value between 1 and 2 ^ (256 - MAX_PRECISION) - 1
744     /// @return is a value between 0 and floor(ln(2 ^ (256 - MAX_PRECISION) - 1) * 2 ^ MAX_PRECISION)
745     function ln_fixed3_lnr_18(uint256 _numerator, uint256 _denominator) internal pure returns (uint256) {
746         assert(_numerator <= MAX_NUM);
747 
748         uint256 res = 0;
749         uint256 x = _numerator * FIXED_1 / _denominator;
750 
751         // If x >= 2, then we compute the integer part of log2(x), which is larger than 0.
752         if (x >= FIXED_2) {
753             uint8 count = floorLog2(x / FIXED_1);
754             x >>= count; // now x < 2
755             res = count * FIXED_1;
756         }
757 
758         // If x > 1, then we compute the fraction part of log2(x), which is larger than 0.
759         if (x > FIXED_1) {
760             for (uint8 i = MAX_PRECISION; i > 0; --i) {
761                 x = (x * x) / FIXED_1; // now 1 < x < 4
762                 if (x >= FIXED_2) {
763                     x >>= 1; // now 1 < x < 2
764                     res += ONE << (i - 1);
765                 }
766             }
767         }
768 
769         return (((res * LN2_MANTISSA) >> LN2_EXPONENT)*lnR*1e18);
770     }       
771 
772     /// @notice Compute the largest integer smaller than or equal to 
773     /// the binary logarithm of the input
774     /// @param _n Operand of the function
775     /// @return Floor(Log2(_n))
776     function floorLog2(uint256 _n) internal pure returns (uint8) {
777         uint8 res = 0;
778 
779         if (_n < 256) {
780             // At most 8 iterations
781             while (_n > 1) {
782                 _n >>= 1;
783                 res += 1;
784             }
785         }
786         else {
787             // Exactly 8 iterations
788             for (uint8 s = 128; s > 0; s >>= 1) {
789                 if (_n >= (ONE << s)) {
790                     _n >>= s;
791                     res |= s;
792                 }
793             }
794         }
795 
796         return res;
797     }    
798     
799     /// @notice Round the operand to one decimal place
800     /// @param _n Operand to be rounded
801     /// @param _m Divisor
802     /// @return ROUND(_n/_m)
803     function round(uint256 _n, uint256 _m) internal pure returns (uint256) {
804         uint256 res = 0;
805         
806         uint256 p =_n/_m;
807         res = _n-(_m*p);
808         
809         if(res >= 1)
810         {
811             res = p+1;
812         }
813         else
814         {
815             res = p;
816         }
817 
818         return res;
819     }      
820   
821   
822     // ***********************************************************
823     // BANCOR STUFF
824     // ***********************************************************
825 
826     /**
827         General Description:
828             Determine a value of precision.
829             Calculate an integer approximation of (_baseN / _baseD) ^ (_expN / _expD) * 2 ^ precision.
830             Return the result along with the precision used.
831         Detailed Description:
832             Instead of calculating "base ^ exp", we calculate "e ^ (log(base) * exp)".
833             The value of "log(base)" is represented with an integer slightly smaller than "log(base) * 2 ^ precision".
834             The larger "precision" is, the more accurately this value represents the real value.
835             However, the larger "precision" is, the more bits are required in order to store this value.
836             And the exponentiation function, which takes "x" and calculates "e ^ x", is limited to a maximum exponent (maximum value of "x").
837             This maximum exponent depends on the "precision" used, and it is given by "maxExpArray[precision] >> (MAX_PRECISION - precision)".
838             Hence we need to determine the highest precision which can be used for the given input, before calling the exponentiation function.
839             This allows us to compute "base ^ exp" with maximum accuracy and without exceeding 256 bits in any of the intermediate computations.
840             This functions assumes that "_expN < 2 ^ 256 / log(MAX_NUM - 1)", otherwise the multiplication should be replaced with a "safeMul".
841     */
842     function power(uint256 _baseN, uint256 _baseD, uint32 _expN, uint32 _expD) internal view returns (uint256, uint8) {
843         assert(_baseN < MAX_NUM);
844 
845         uint256 baseLog;
846         uint256 base = _baseN * FIXED_1 / _baseD;
847         if (base < OPT_LOG_MAX_VAL) {
848             baseLog = optimalLog(base);
849         }
850         else {
851             baseLog = generalLog(base);
852         }
853 
854         uint256 baseLogTimesExp = baseLog * _expN / _expD;
855         if (baseLogTimesExp < OPT_EXP_MAX_VAL) {
856             //debugVal = 123;
857             return (optimalExp(baseLogTimesExp), MAX_PRECISION);
858         }
859         else {
860             uint8 precision = findPositionInMaxExpArray(baseLogTimesExp);
861             return (generalExp(baseLogTimesExp >> (MAX_PRECISION - precision), precision), precision);
862         }
863     }
864 
865     /**
866         Compute log(x / FIXED_1) * FIXED_1.
867         This functions assumes that "x >= FIXED_1", because the output would be negative otherwise.
868     */
869     function generalLog(uint256 x) internal pure returns (uint256) {
870         uint256 res = 0;
871 
872         // If x >= 2, then we compute the integer part of log2(x), which is larger than 0.
873         if (x >= FIXED_2) {
874             uint8 count = floorLog2(x / FIXED_1);
875             x >>= count; // now x < 2
876             res = count * FIXED_1;
877         }
878 
879         // If x > 1, then we compute the fraction part of log2(x), which is larger than 0.
880         if (x > FIXED_1) {
881             for (uint8 i = MAX_PRECISION; i > 0; --i) {
882                 x = (x * x) / FIXED_1; // now 1 < x < 4
883                 if (x >= FIXED_2) {
884                     x >>= 1; // now 1 < x < 2
885                     res += ONE << (i - 1);
886                 }
887             }
888         }
889 
890         return res * LN2_NUMERATOR / LN2_DENOMINATOR;
891     }
892 
893     /**
894         The global "maxExpArray" is sorted in descending order, and therefore the following statements are equivalent:
895         - This function finds the position of [the smallest value in "maxExpArray" larger than or equal to "x"]
896         - This function finds the highest position of [a value in "maxExpArray" larger than or equal to "x"]
897     */
898     function findPositionInMaxExpArray(uint256 _x) internal view returns (uint8) {
899         uint8 lo = MIN_PRECISION;
900         uint8 hi = MAX_PRECISION;
901 
902         while (lo + 1 < hi) {
903             uint8 mid = (lo + hi) / 2;
904             if (maxExpArray[mid] >= _x)
905                 lo = mid;
906             else
907                 hi = mid;
908         }
909         
910         if (maxExpArray[hi] >= _x){
911             //debugVal = hi;
912             return hi;
913         }
914         if (maxExpArray[lo] >= _x){
915             //debugVal = lo;
916             return lo;
917         }
918             
919         
920 
921         assert(false);
922         return 0;
923     }
924 
925     /**
926         This function can be auto-generated by the script 'PrintFunctionGeneralExp.py'.
927         It approximates "e ^ x" via maclaurin summation: "(x^0)/0! + (x^1)/1! + ... + (x^n)/n!".
928         It returns "e ^ (x / 2 ^ precision) * 2 ^ precision", that is, the result is upshifted for accuracy.
929         The global "maxExpArray" maps each "precision" to "((maximumExponent + 1) << (MAX_PRECISION - precision)) - 1".
930         The maximum permitted value for "x" is therefore given by "maxExpArray[precision] >> (MAX_PRECISION - precision)".
931     */
932     function generalExp(uint256 _x, uint8 _precision) internal pure returns (uint256) {
933         uint256 xi = _x;
934         uint256 res = 0;
935 
936         xi = (xi * _x) >> _precision; res += xi * 0x3442c4e6074a82f1797f72ac0000000; // add x^02 * (33! / 02!)
937         xi = (xi * _x) >> _precision; res += xi * 0x116b96f757c380fb287fd0e40000000; // add x^03 * (33! / 03!)
938         xi = (xi * _x) >> _precision; res += xi * 0x045ae5bdd5f0e03eca1ff4390000000; // add x^04 * (33! / 04!)
939         xi = (xi * _x) >> _precision; res += xi * 0x00defabf91302cd95b9ffda50000000; // add x^05 * (33! / 05!)
940         xi = (xi * _x) >> _precision; res += xi * 0x002529ca9832b22439efff9b8000000; // add x^06 * (33! / 06!)
941         xi = (xi * _x) >> _precision; res += xi * 0x00054f1cf12bd04e516b6da88000000; // add x^07 * (33! / 07!)
942         xi = (xi * _x) >> _precision; res += xi * 0x0000a9e39e257a09ca2d6db51000000; // add x^08 * (33! / 08!)
943         xi = (xi * _x) >> _precision; res += xi * 0x000012e066e7b839fa050c309000000; // add x^09 * (33! / 09!)
944         xi = (xi * _x) >> _precision; res += xi * 0x000001e33d7d926c329a1ad1a800000; // add x^10 * (33! / 10!)
945         xi = (xi * _x) >> _precision; res += xi * 0x0000002bee513bdb4a6b19b5f800000; // add x^11 * (33! / 11!)
946         xi = (xi * _x) >> _precision; res += xi * 0x00000003a9316fa79b88eccf2a00000; // add x^12 * (33! / 12!)
947         xi = (xi * _x) >> _precision; res += xi * 0x0000000048177ebe1fa812375200000; // add x^13 * (33! / 13!)
948         xi = (xi * _x) >> _precision; res += xi * 0x0000000005263fe90242dcbacf00000; // add x^14 * (33! / 14!)
949         xi = (xi * _x) >> _precision; res += xi * 0x000000000057e22099c030d94100000; // add x^15 * (33! / 15!)
950         xi = (xi * _x) >> _precision; res += xi * 0x0000000000057e22099c030d9410000; // add x^16 * (33! / 16!)
951         xi = (xi * _x) >> _precision; res += xi * 0x00000000000052b6b54569976310000; // add x^17 * (33! / 17!)
952         xi = (xi * _x) >> _precision; res += xi * 0x00000000000004985f67696bf748000; // add x^18 * (33! / 18!)
953         xi = (xi * _x) >> _precision; res += xi * 0x000000000000003dea12ea99e498000; // add x^19 * (33! / 19!)
954         xi = (xi * _x) >> _precision; res += xi * 0x00000000000000031880f2214b6e000; // add x^20 * (33! / 20!)
955         xi = (xi * _x) >> _precision; res += xi * 0x000000000000000025bcff56eb36000; // add x^21 * (33! / 21!)
956         xi = (xi * _x) >> _precision; res += xi * 0x000000000000000001b722e10ab1000; // add x^22 * (33! / 22!)
957         xi = (xi * _x) >> _precision; res += xi * 0x0000000000000000001317c70077000; // add x^23 * (33! / 23!)
958         xi = (xi * _x) >> _precision; res += xi * 0x00000000000000000000cba84aafa00; // add x^24 * (33! / 24!)
959         xi = (xi * _x) >> _precision; res += xi * 0x00000000000000000000082573a0a00; // add x^25 * (33! / 25!)
960         xi = (xi * _x) >> _precision; res += xi * 0x00000000000000000000005035ad900; // add x^26 * (33! / 26!)
961         xi = (xi * _x) >> _precision; res += xi * 0x000000000000000000000002f881b00; // add x^27 * (33! / 27!)
962         xi = (xi * _x) >> _precision; res += xi * 0x0000000000000000000000001b29340; // add x^28 * (33! / 28!)
963         xi = (xi * _x) >> _precision; res += xi * 0x00000000000000000000000000efc40; // add x^29 * (33! / 29!)
964         xi = (xi * _x) >> _precision; res += xi * 0x0000000000000000000000000007fe0; // add x^30 * (33! / 30!)
965         xi = (xi * _x) >> _precision; res += xi * 0x0000000000000000000000000000420; // add x^31 * (33! / 31!)
966         xi = (xi * _x) >> _precision; res += xi * 0x0000000000000000000000000000021; // add x^32 * (33! / 32!)
967         xi = (xi * _x) >> _precision; res += xi * 0x0000000000000000000000000000001; // add x^33 * (33! / 33!)
968 
969         return res / 0x688589cc0e9505e2f2fee5580000000 + _x + (ONE << _precision); // divide by 33! and then add x^1 / 1! + x^0 / 0!
970     }
971 
972     /**
973         Return log(x / FIXED_1) * FIXED_1
974         Input range: FIXED_1 <= x <= LOG_EXP_MAX_VAL - 1
975         Auto-generated via 'PrintFunctionOptimalLog.py'
976     */
977     function optimalLog(uint256 x) internal pure returns (uint256) {
978         uint256 res = 0;
979 
980         uint256 y;
981         uint256 z;
982         uint256 w;
983 
984         if (x >= 0xd3094c70f034de4b96ff7d5b6f99fcd8) {res += 0x40000000000000000000000000000000; x = x * FIXED_1 / 0xd3094c70f034de4b96ff7d5b6f99fcd8;}
985         if (x >= 0xa45af1e1f40c333b3de1db4dd55f29a7) {res += 0x20000000000000000000000000000000; x = x * FIXED_1 / 0xa45af1e1f40c333b3de1db4dd55f29a7;}
986         if (x >= 0x910b022db7ae67ce76b441c27035c6a1) {res += 0x10000000000000000000000000000000; x = x * FIXED_1 / 0x910b022db7ae67ce76b441c27035c6a1;}
987         if (x >= 0x88415abbe9a76bead8d00cf112e4d4a8) {res += 0x08000000000000000000000000000000; x = x * FIXED_1 / 0x88415abbe9a76bead8d00cf112e4d4a8;}
988         if (x >= 0x84102b00893f64c705e841d5d4064bd3) {res += 0x04000000000000000000000000000000; x = x * FIXED_1 / 0x84102b00893f64c705e841d5d4064bd3;}
989         if (x >= 0x8204055aaef1c8bd5c3259f4822735a2) {res += 0x02000000000000000000000000000000; x = x * FIXED_1 / 0x8204055aaef1c8bd5c3259f4822735a2;}
990         if (x >= 0x810100ab00222d861931c15e39b44e99) {res += 0x01000000000000000000000000000000; x = x * FIXED_1 / 0x810100ab00222d861931c15e39b44e99;}
991         if (x >= 0x808040155aabbbe9451521693554f733) {res += 0x00800000000000000000000000000000; x = x * FIXED_1 / 0x808040155aabbbe9451521693554f733;}
992 
993         z = y = x - FIXED_1;
994         w = y * y / FIXED_1;
995         res += z * (0x100000000000000000000000000000000 - y) / 0x100000000000000000000000000000000; z = z * w / FIXED_1;
996         res += z * (0x0aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa - y) / 0x200000000000000000000000000000000; z = z * w / FIXED_1;
997         res += z * (0x099999999999999999999999999999999 - y) / 0x300000000000000000000000000000000; z = z * w / FIXED_1;
998         res += z * (0x092492492492492492492492492492492 - y) / 0x400000000000000000000000000000000; z = z * w / FIXED_1;
999         res += z * (0x08e38e38e38e38e38e38e38e38e38e38e - y) / 0x500000000000000000000000000000000; z = z * w / FIXED_1;
1000         res += z * (0x08ba2e8ba2e8ba2e8ba2e8ba2e8ba2e8b - y) / 0x600000000000000000000000000000000; z = z * w / FIXED_1;
1001         res += z * (0x089d89d89d89d89d89d89d89d89d89d89 - y) / 0x700000000000000000000000000000000; z = z * w / FIXED_1;
1002         res += z * (0x088888888888888888888888888888888 - y) / 0x800000000000000000000000000000000;
1003 
1004         return res;
1005     }
1006 
1007     /**
1008         Return e ^ (x / FIXED_1) * FIXED_1
1009         Input range: 0 <= x <= OPT_EXP_MAX_VAL - 1
1010         Auto-generated via 'PrintFunctionOptimalExp.py'
1011     */
1012     function optimalExp(uint256 x) internal pure returns (uint256) {
1013         uint256 res = 0;
1014 
1015         uint256 y;
1016         uint256 z;
1017 
1018         z = y = x % 0x10000000000000000000000000000000;
1019         z = z * y / FIXED_1; res += z * 0x10e1b3be415a0000; // add y^02 * (20! / 02!)
1020         z = z * y / FIXED_1; res += z * 0x05a0913f6b1e0000; // add y^03 * (20! / 03!)
1021         z = z * y / FIXED_1; res += z * 0x0168244fdac78000; // add y^04 * (20! / 04!)
1022         z = z * y / FIXED_1; res += z * 0x004807432bc18000; // add y^05 * (20! / 05!)
1023         z = z * y / FIXED_1; res += z * 0x000c0135dca04000; // add y^06 * (20! / 06!)
1024         z = z * y / FIXED_1; res += z * 0x0001b707b1cdc000; // add y^07 * (20! / 07!)
1025         z = z * y / FIXED_1; res += z * 0x000036e0f639b800; // add y^08 * (20! / 08!)
1026         z = z * y / FIXED_1; res += z * 0x00000618fee9f800; // add y^09 * (20! / 09!)
1027         z = z * y / FIXED_1; res += z * 0x0000009c197dcc00; // add y^10 * (20! / 10!)
1028         z = z * y / FIXED_1; res += z * 0x0000000e30dce400; // add y^11 * (20! / 11!)
1029         z = z * y / FIXED_1; res += z * 0x000000012ebd1300; // add y^12 * (20! / 12!)
1030         z = z * y / FIXED_1; res += z * 0x0000000017499f00; // add y^13 * (20! / 13!)
1031         z = z * y / FIXED_1; res += z * 0x0000000001a9d480; // add y^14 * (20! / 14!)
1032         z = z * y / FIXED_1; res += z * 0x00000000001c6380; // add y^15 * (20! / 15!)
1033         z = z * y / FIXED_1; res += z * 0x000000000001c638; // add y^16 * (20! / 16!)
1034         z = z * y / FIXED_1; res += z * 0x0000000000001ab8; // add y^17 * (20! / 17!)
1035         z = z * y / FIXED_1; res += z * 0x000000000000017c; // add y^18 * (20! / 18!)
1036         z = z * y / FIXED_1; res += z * 0x0000000000000014; // add y^19 * (20! / 19!)
1037         z = z * y / FIXED_1; res += z * 0x0000000000000001; // add y^20 * (20! / 20!)
1038         res = res / 0x21c3677c82b40000 + y + FIXED_1; // divide by 20! and then add y^1 / 1! + y^0 / 0!
1039 
1040         if ((x & 0x010000000000000000000000000000000) != 0) res = res * 0x1c3d6a24ed82218787d624d3e5eba95f9 / 0x18ebef9eac820ae8682b9793ac6d1e776;
1041         if ((x & 0x020000000000000000000000000000000) != 0) res = res * 0x18ebef9eac820ae8682b9793ac6d1e778 / 0x1368b2fc6f9609fe7aceb46aa619baed4;
1042         if ((x & 0x040000000000000000000000000000000) != 0) res = res * 0x1368b2fc6f9609fe7aceb46aa619baed5 / 0x0bc5ab1b16779be3575bd8f0520a9f21f;
1043         if ((x & 0x080000000000000000000000000000000) != 0) res = res * 0x0bc5ab1b16779be3575bd8f0520a9f21e / 0x0454aaa8efe072e7f6ddbab84b40a55c9;
1044         if ((x & 0x100000000000000000000000000000000) != 0) res = res * 0x0454aaa8efe072e7f6ddbab84b40a55c5 / 0x00960aadc109e7a3bf4578099615711ea;
1045         if ((x & 0x200000000000000000000000000000000) != 0) res = res * 0x00960aadc109e7a3bf4578099615711d7 / 0x0002bf84208204f5977f9a8cf01fdce3d;
1046         if ((x & 0x400000000000000000000000000000000) != 0) res = res * 0x0002bf84208204f5977f9a8cf01fdc307 / 0x0000003c6ab775dd0b95b4cbee7e65d11;
1047 
1048         return res;
1049     }  
1050 }