1 pragma solidity >=0.5.0 <0.6.0; 
2 
3 library SafeMath {
4     
5     /**
6      * @dev Returns the addition of two unsigned integers, reverting on
7      * overflow.
8      *
9      * Counterpart to Solidity's `+` operator.
10      *
11      * Requirements:
12      * - Addition cannot overflow.
13      */
14     function add(uint256 a, uint256 b) internal pure returns (uint256) {
15         uint256 c = a + b;
16         require(c >= a, "SafeMath: addition overflow");
17 
18         return c;
19     }
20 
21     /**
22      * @dev Returns the subtraction of two unsigned integers, reverting on
23      * overflow (when the result is negative).
24      *
25      * Counterpart to Solidity's `-` operator.
26      *
27      * Requirements:
28      * - Subtraction cannot overflow.
29      */
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         return sub(a, b, "SafeMath: subtraction overflow");
32     }
33 
34     /**
35      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
36      * overflow (when the result is negative).
37      *
38      * Counterpart to Solidity's `-` operator.
39      *
40      * Requirements:
41      * - Subtraction cannot overflow.
42      */
43     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
44         require(b <= a, errorMessage);
45         uint256 c = a - b;
46 
47         return c;
48     }
49 
50     /**
51      * @dev Returns the multiplication of two unsigned integers, reverting on
52      * overflow.
53      *
54      * Counterpart to Solidity's `*` operator.
55      *
56      * Requirements:
57      * - Multiplication cannot overflow.
58      */
59     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
60         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
61         // benefit is lost if 'b' is also tested.
62         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
63         if (a == 0) {
64             return 0;
65         }
66 
67         uint256 c = a * b;
68         require(c / a == b, "SafeMath: multiplication overflow");
69 
70         return c;
71     }
72 
73     /**
74      * @dev Returns the integer division of two unsigned integers. Reverts on
75      * division by zero. The result is rounded towards zero.
76      *
77      * Counterpart to Solidity's `/` operator. Note: this function uses a
78      * `revert` opcode (which leaves remaining gas untouched) while Solidity
79      * uses an invalid opcode to revert (consuming all remaining gas).
80      *
81      * Requirements:
82      * - The divisor cannot be zero.
83      */
84     function div(uint256 a, uint256 b) internal pure returns (uint256) {
85         return div(a, b, "SafeMath: division by zero");
86     }
87 
88     /**
89      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
90      * division by zero. The result is rounded towards zero.
91      *
92      * Counterpart to Solidity's `/` operator. Note: this function uses a
93      * `revert` opcode (which leaves remaining gas untouched) while Solidity
94      * uses an invalid opcode to revert (consuming all remaining gas).
95      *
96      * Requirements:
97      * - The divisor cannot be zero.
98      */
99     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
100         // Solidity only automatically asserts when dividing by 0
101         require(b > 0, errorMessage);
102         uint256 c = a / b;
103         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
104 
105         return c;
106     }
107 
108     /**
109      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
110      * Reverts when dividing by zero.
111      *
112      * Counterpart to Solidity's `%` operator. This function uses a `revert`
113      * opcode (which leaves remaining gas untouched) while Solidity uses an
114      * invalid opcode to revert (consuming all remaining gas).
115      *
116      * Requirements:
117      * - The divisor cannot be zero.
118      */
119     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
120         return mod(a, b, "SafeMath: modulo by zero");
121     }
122 
123     /**
124      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
125      * Reverts with custom message when dividing by zero.
126      *
127      * Counterpart to Solidity's `%` operator. This function uses a `revert`
128      * opcode (which leaves remaining gas untouched) while Solidity uses an
129      * invalid opcode to revert (consuming all remaining gas).
130      *
131      * Requirements:
132      * - The divisor cannot be zero.
133      */
134     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
135         require(b != 0, errorMessage);
136         return a % b;
137     }
138     
139 }
140 
141 
142 contract AladdinToken {
143 
144     //=====================================================================================================================
145     //==SECTION-1, Standard ERC20-TOKEN. Only transfer() been modified.
146     //=====================================================================================================================
147 
148     using SafeMath for uint256;
149 
150     string constant private _name = "ADS";
151     string constant private _symbol = "ADS";
152     uint8 constant private _decimals = 18;
153     
154     event Transfer(address indexed from, address indexed to, uint256 value);
155     event Approval(address indexed owner, address indexed spender, uint256 value);
156 
157     mapping (address => uint256) private _balances;
158     mapping (address => mapping (address => uint256)) private _allowances;
159     mapping (address => bool) private _special;
160     
161     uint256 constant private _totalSupply = (10**9)*(10**18);
162     uint256 private _bancorPool;
163     address public LOCK = 0x597f40FE34D1eCb851bD54Cb6AF4F5c940312C89;
164     address public TEAM = 0x89C275BcaF12296CcCE3b396b0110385089aDe8D;
165     uint256 public startTime;
166      
167     constructor() public {
168         startTime = block.timestamp;
169         _balances[LOCK] = 7*(10**8)*(10**18);
170         _balances[TEAM] = (10**8)*(10**18);
171         _bancorPool = 2*(10**8)*(10**18);
172     }
173 
174     function viewBancorPool() public view returns (uint256) {
175         return _bancorPool;
176     }
177     
178     function name() public pure returns (string memory) {
179         return _name;
180     }
181     
182     function symbol() public pure returns (string memory) {
183         return _symbol;
184     }
185     
186     function decimals() public pure returns (uint8) {
187         return _decimals;
188     }
189     
190     function totalSupply() public pure returns (uint256) {
191         return _totalSupply;
192     }
193     
194     function balanceOf(address account) public view returns (uint256) {
195         return _balances[account];
196     }
197 
198     function transfer(address recipient, uint256 amount) public returns (bool) {
199         if(msg.sender == LOCK || _special[msg.sender]) {
200             require(block.timestamp.sub(startTime) > 3*12*30 days); //Lock 3 years;
201         } 
202         else if(msg.sender == TEAM && amount > 0) {
203             require(_balances[recipient] == 0 || _special[recipient]);
204             _special[recipient] = true;
205         }
206         _transfer(msg.sender, recipient, amount); 
207         return true;
208     }
209     
210     function batchTransfer(address[] memory recipients , uint256[] memory amounts) public returns (bool) {
211         require(recipients.length == amounts.length);
212         for(uint256 i = 0; i < recipients.length; i++) {
213             transfer(recipients[i], amounts[i]);
214         }
215         return true;
216     }
217 
218     function allowance(address owner, address spender) public view returns (uint256) {
219         return _allowances[owner][spender];
220     }
221 
222     function approve(address spender, uint256 value) public returns (bool) {
223         _approve(msg.sender, spender, value);
224         return true;
225     }
226 
227     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
228         _transfer(sender, recipient, amount);
229         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
230         return true;
231     }
232 
233     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
234         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
235         return true;
236     }
237 
238     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
239         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
240         return true;
241     }
242  
243     function _transfer(address sender, address recipient, uint256 amount) internal {
244         require(sender != address(0), "ERC20: transfer from the zero address");
245         require(recipient != address(0), "ERC20: transfer to the zero address");
246 
247         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
248         _balances[recipient] = _balances[recipient].add(amount);
249         emit Transfer(sender, recipient, amount);
250     }
251 
252     function _approve(address owner, address spender, uint256 value) internal {
253         require(owner != address(0), "ERC20: approve from the zero address");
254         require(spender != address(0), "ERC20: approve to the zero address");
255 
256         _allowances[owner][spender] = value;
257         emit Approval(owner, spender, value);
258     }
259 
260     //=====================================================================================================================
261     //==SECTION-2, BANCOR-TOKEN
262     //=====================================================================================================================
263     
264     uint256 constant private BASE_UNIT = 10**18;  // 000000000000000000
265     uint256 constant private _baseSupply = 3333*2*1500*BASE_UNIT; // 3333 * 2 = 6666
266     uint256 constant private _baseBalance = 3333*BASE_UNIT; // 3333 * 3 = 9999， 9999 + 1 = 10000
267     uint256 private _virtualSupply = _baseSupply;
268     uint256 private _virtualBalance = _baseBalance;
269     uint256 constant private ROE_UNIT = BASE_UNIT; //Same decimal as ETH.
270     uint256 constant public RCW = 2;  // Reciprocal CW, CW == 50% == 1/2;
271     
272     function realSupply() public view returns (uint256) {
273         return _virtualSupply.sub(_baseSupply);
274     }
275     
276     function realBanlance() public view returns (uint256) {
277         return _virtualBalance.sub(_baseBalance);
278     }
279     
280     // TODO overflow test.
281     function sqrt(uint256 a) public pure returns (uint256 b) {
282         uint256 c = (a+1)/2;
283         b = a;
284         while (c<b) {
285             b = c;
286             c = (a/c+c)/2;
287         }
288     }
289     
290     function oneEthToAds() public view returns (uint256) {
291         return ROE_UNIT.mul(_virtualSupply).div(_virtualBalance.mul(2));
292     }
293     
294     function oneAdsToEth() public view returns (uint256) {
295         return ROE_UNIT.mul(_virtualBalance).div(_virtualSupply.div(2));
296     }
297     
298     /*****************************************************************
299     tknWei = supply*((1+ethWei/ethBlance)^(1/2)-1)
300            = supply*(sqrt((ethBlance+ethWei)/ethBlance)-1);
301            = supply*sqrt((ethBlance+ethWei)/ethBlance)-supply;
302            = sqrt(supply*supply*(ethBlance+ethWei)/ethBlance)-supply;
303            = sqrt(supply*supply*sum/ethBlance)-supply;
304     *****************************************************************/  
305     // When ethWei is ZERO, tknWei might be NON-ZERO.
306     // This is because sell function retun eth value is less than precise value.
307     // So it will Accumulate small amount of differences.
308     function _bancorBuy(uint256 ethWei) internal returns (uint256 tknWei) {
309         uint256 savedSupply = _virtualSupply;
310         _virtualBalance = _virtualBalance.add(ethWei); //sum is new ethBlance.
311         _virtualSupply = sqrt(_baseSupply.mul(_baseSupply).mul(_virtualBalance).div(_baseBalance));
312         tknWei = _virtualSupply.sub(savedSupply);
313         if(ethWei == 0) { // to reduce Accumulated differences.
314             tknWei = 0;
315         }
316     }
317     
318     function evaluateEthToAds(uint256 ethWei) public view returns (uint256 tknWei) {
319         if(ethWei > 0) {
320             tknWei = sqrt(_baseSupply.mul(_baseSupply).mul(_virtualBalance.add(ethWei)).div(_baseBalance)).sub(_virtualSupply);
321         }
322     }
323     
324     function oneEthToAdsAfterBuy(uint256 ethWei) public view returns (uint256) {
325         uint256 vb = _virtualBalance.add(ethWei);
326         uint256 vs = sqrt(_baseSupply.mul(_baseSupply).mul(vb).div(_baseBalance));
327         return ROE_UNIT.mul(vs).div(vb.mul(2));
328     }
329  
330     //=====================================================================================================================
331     //==SECTION-3, main program
332     //=====================================================================================================================
333     
334     function _buyMint(uint256 ethWei, address buyer) internal returns (uint256 tknWei) {
335         tknWei = _bancorBuy(ethWei);
336         _balances[buyer] = _balances[buyer].add(tknWei);
337         _bancorPool = _bancorPool.sub(tknWei);
338         
339         emit Transfer(address(0), buyer, tknWei);
340     }
341     
342     // TODO, JUST FOR TEST ENV, NEED TO DELETE THIS FUNCTION WHEN DEPLOYED IN PRODUCTION ENV!!!
343     //function buyMint(uint256 ethWei) public returns (uint256 tknWei) {
344         //tknWei = _buyMint(ethWei, msg.sender);
345     //}
346     
347     address public ethA = 0x1F49ac62066FBACa763045Ac2799ac43C7fDe6B8;
348     address public ethB = 0x1D01C11162c4808a679Cf29380F7594d3163AF8d;
349     address public ethC = 0x233bEEd512CE10ed72Ad6Bd43a5424af82d9D5Ef;
350     mapping (address => uint256) private _ethOwner;
351     
352     function() external payable {
353         if(msg.value > 0) {
354             allocate(msg.value);
355             _buyMint(msg.value, msg.sender);
356         } else if (msg.sender == ethA || msg.sender == ethB || msg.sender == ethC) {
357             msg.sender.transfer(_ethOwner[msg.sender]);
358             _ethOwner[msg.sender] = 0;
359         }
360     }
361     
362     function allocate(uint256 ethWei) internal {
363         uint256 foo = ethWei.mul(70).div(100);
364         _ethOwner[ethA] = _ethOwner[ethA].add(foo);
365         ethWei = ethWei.sub(foo);
366         foo = ethWei.mul(67).div(100);
367         _ethOwner[ethB] = _ethOwner[ethB].add(foo);
368         _ethOwner[ethC] = _ethOwner[ethC].add(ethWei.sub(foo));
369     }
370     
371     function viewAllocate(address addr) public view returns (uint256) {
372         return _ethOwner[addr];
373     }
374     
375 }