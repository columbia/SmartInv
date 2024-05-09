1 pragma solidity 0.6.0;
2 
3 /*
4 
5                                        https://UniGraph.app
6 
7       ___           ___                       ___           ___           ___           ___           ___     
8      /\__\         /\__\          ___        /\  \         /\  \         /\  \         /\  \         /\__\    
9     /:/  /        /::|  |        /\  \      /::\  \       /::\  \       /::\  \       /::\  \       /:/  /    
10    /:/  /        /:|:|  |        \:\  \    /:/\:\  \     /:/\:\  \     /:/\:\  \     /:/\:\  \     /:/__/     
11   /:/  /  ___   /:/|:|  |__      /::\__\  /:/  \:\  \   /::\~\:\  \   /::\~\:\  \   /::\~\:\  \   /::\  \ ___ 
12  /:/__/  /\__\ /:/ |:| /\__\  __/:/\/__/ /:/__/_\:\__\ /:/\:\ \:\__\ /:/\:\ \:\__\ /:/\:\ \:\__\ /:/\:\  /\__\
13  \:\  \ /:/  / \/__|:|/:/  / /\/:/  /    \:\  /\ \/__/ \/_|::\/:/  / \/__\:\/:/  / \/__\:\/:/  / \/__\:\/:/  /
14   \:\  /:/  /      |:/:/  /  \::/__/      \:\ \:\__\      |:|::/  /       \::/  /       \::/  /       \::/  / 
15    \:\/:/  /       |::/  /    \:\__\       \:\/:/  /      |:|\/__/        /:/  /         \/__/        /:/  /  
16     \::/  /        /:/  /      \/__/        \::/  /       |:|  |         /:/  /                      /:/  /   
17      \/__/         \/__/                     \/__/         \|__|         \/__/                       \/__/    
18 
19 
20 */
21 
22 library SafeMath {
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         require(c >= a, "SafeMath: addition overflow");
26 
27         return c;
28     }
29 
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         return sub(a, b, "SafeMath: subtraction overflow");
32     }
33 
34     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
35         require(b <= a, errorMessage);
36         uint256 c = a - b;
37 
38         return c;
39     }
40 
41     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
42         if (a == 0) {
43             return 0;
44         }
45 
46         uint256 c = a * b;
47         require(c / a == b, "SafeMath: multiplication overflow");
48 
49         return c;
50     }
51 
52     function div(uint256 a, uint256 b) internal pure returns (uint256) {
53         return div(a, b, "SafeMath: division by zero");
54     }
55 
56     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
57         require(b > 0, errorMessage);
58         uint256 c = a / b;
59 
60         return c;
61     }
62 
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         return mod(a, b, "SafeMath: modulo by zero");
65     }
66 
67     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
68         require(b != 0, errorMessage);
69         return a % b;
70     }
71 }
72 
73 contract Ownable {
74     address public _owner;
75 
76     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
77 
78     constructor () public {
79         _owner = msg.sender;
80         emit OwnershipTransferred(address(0), msg.sender);
81     }
82 
83     function owner() public view returns (address) {
84         return _owner;
85     }
86 
87     modifier onlyOwner() {
88         require(_owner == msg.sender, "Ownable: caller is not the owner");
89         _;
90     }
91 
92     function transferOwnership(address newOwner) public virtual onlyOwner {
93         require(newOwner != address(0), "Ownable: new owner is the zero address");
94         emit OwnershipTransferred(_owner, newOwner);
95         _owner = newOwner;
96     }
97 }
98 
99 // Uniswap v2 interfaces
100 interface IUniswapV2Pair {
101     function sync() external;
102 }
103 
104 interface IUniswapV2Factory {
105     function createPair(address tokenA, address tokenB) external returns (address pair);
106 }
107 
108 contract Graph is Ownable {
109     string public name = "UniGraph";
110     string public symbol = "GRAPH";
111     uint256 public constant decimals = 18;
112     
113     using SafeMath for uint256;
114 
115     event LogRebase(uint256 indexed epoch, uint256 totalSupply);
116 
117     modifier validRecipient(address to) {
118         require(to != address(0x0));
119         require(to != address(this));
120         _;
121     }
122     
123     event Transfer(address indexed from, address indexed to, uint256 value);
124     event Approval(address indexed owner, address indexed spender, uint256 value);
125     
126     constructor() public override {
127         _owner = msg.sender;
128         _feeTaker = msg.sender;
129         
130         _totalSupply = INITIAL_FRAGMENTS_SUPPLY;
131         _gonBalances[_owner] = TOTAL_GONS;
132         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
133         lastPoolFeeTime = now;
134         
135         emit Transfer(address(0x0), _owner, _totalSupply);
136     }
137 
138     function updateBranding(string memory newName, string memory newSymbol) public onlyOwner {
139         name = newName;
140         symbol = newSymbol;
141     }
142 
143     uint256 private constant DECIMALS = 18;
144     uint256 private constant MAX_UINT256 = ~uint256(0);
145     uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 100_000 * 10**DECIMALS;
146 
147     uint256 private constant TOTAL_GONS = MAX_UINT256 - (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);
148 
149     uint256 private constant MAX_SUPPLY = ~uint128(0);  // (2^128) - 1
150 
151     uint256 private _totalSupply;
152     uint256 private _gonsPerFragment;
153     mapping(address => uint256) private _gonBalances;
154 
155     mapping (address => mapping (address => uint256)) private _allowedFragments;
156     
157     address public _feeTaker;
158     event FeeTakerTransferred(address indexed previousFeeTaker, address indexed newFeeTaker);
159     function transferFeeTaker(address newFeeTaker) public virtual onlyOwner {
160         emit FeeTakerTransferred(_feeTaker, newFeeTaker);
161         _feeTaker = newFeeTaker;
162     }
163     function feeTaker() public view returns (address) {
164         return _feeTaker;
165     }
166     
167     uint256 epoch = 0;
168     
169     function rebasePer(uint256 supplyPercent) external onlyOwner returns (uint256) {
170         epoch = epoch.add(1);
171         if(supplyPercent <= 50 || supplyPercent >= 100) {
172             revert();
173         }
174         uint256 absSupplyPercent = uint256(supplyPercent);
175         _totalSupply = _totalSupply.mul(absSupplyPercent).div(100);
176         
177         if (_totalSupply > MAX_SUPPLY) {
178             _totalSupply = MAX_SUPPLY;
179         }
180 
181         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
182 
183         emit LogRebase(epoch, _totalSupply);
184         return _totalSupply;
185     }
186 
187     function rebase(int256 supplyDelta) external onlyOwner returns (uint256) {
188         epoch = epoch.add(1);
189         if (supplyDelta == 0) {
190             emit LogRebase(epoch, _totalSupply);
191             return _totalSupply;
192         }
193 
194         uint256 absSupplyDelta = uint256(supplyDelta);
195         if(supplyDelta < 0) {
196             absSupplyDelta = uint256(-supplyDelta);
197         }
198         if(supplyDelta < 0) {
199             _totalSupply = _totalSupply.sub(absSupplyDelta);
200         }
201         else {
202             _totalSupply = _totalSupply.add(absSupplyDelta);
203         }
204 
205         
206         if (_totalSupply > MAX_SUPPLY) {
207             _totalSupply = MAX_SUPPLY;
208         }
209 
210         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
211 
212         emit LogRebase(epoch, _totalSupply);
213         return _totalSupply;
214     }
215 
216     function totalSupply()
217         public
218         view
219         returns (uint256)
220     {
221         return _totalSupply;
222     }
223 
224     function balanceOf(address who)
225         public
226         view
227         returns (uint256)
228     {
229         return _gonBalances[who].div(_gonsPerFragment);
230     }
231 
232     function transfer(address to, uint256 value)
233         public
234         validRecipient(to)
235         returns (bool)
236     {
237         uint256 gonValue = value.mul(_gonsPerFragment);
238         _gonBalances[msg.sender] = _gonBalances[msg.sender].sub(gonValue);
239         _gonBalances[to] = _gonBalances[to].add(gonValue);
240         emit Transfer(msg.sender, to, value);
241         return true;
242     }
243 
244     function allowance(address owner_, address spender)
245         public
246         view
247         returns (uint256)
248     {
249         return _allowedFragments[owner_][spender];
250     }
251 
252     function transferFrom(address from, address to, uint256 value)
253         public
254         validRecipient(to)
255         returns (bool)
256     {
257         _allowedFragments[from][msg.sender] = _allowedFragments[from][msg.sender].sub(value);
258 
259         uint256 gonValue = value.mul(_gonsPerFragment);
260         _gonBalances[from] = _gonBalances[from].sub(gonValue);
261         _gonBalances[to] = _gonBalances[to].add(gonValue);
262         emit Transfer(from, to, value);
263 
264         return true;
265     }
266 
267     function approve(address spender, uint256 value)
268         public
269         returns (bool)
270     {
271         _allowedFragments[msg.sender][spender] = value;
272         emit Approval(msg.sender, spender, value);
273         return true;
274     }
275 
276     function increaseAllowance(address spender, uint256 addedValue)
277         public
278         returns (bool)
279     {
280         _allowedFragments[msg.sender][spender] =
281             _allowedFragments[msg.sender][spender].add(addedValue);
282         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
283         return true;
284     }
285 
286     function decreaseAllowance(address spender, uint256 subtractedValue)
287         public
288         returns (bool)
289     {
290         uint256 oldValue = _allowedFragments[msg.sender][spender];
291         if (subtractedValue >= oldValue) {
292             _allowedFragments[msg.sender][spender] = 0;
293         } else {
294             _allowedFragments[msg.sender][spender] = oldValue.sub(subtractedValue);
295         }
296         emit Approval(msg.sender, spender, _allowedFragments[msg.sender][spender]);
297         return true;
298     }
299     
300     // Uniswap Pool Methods
301     IUniswapV2Factory public uniswapFactory = IUniswapV2Factory(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);
302     
303     uint256 public POOL_FEE_DAILY_PERCENT = 1;
304     
305     function setPoolFeePercent(uint256 newPer) public onlyOwner {
306         require(newPer >= 0);
307         require(newPer < 5);
308         POOL_FEE_DAILY_PERCENT = newPer;
309     }
310     
311     function poolFeeAvailable() public view returns (uint256) {
312         uint256 timeBetweenLastPoolBurn = now - lastPoolFeeTime;
313         uint256 tokensInUniswapPool = balanceOf(uniswapPool);
314         uint256 dayInSeconds = 1 days;
315         return (tokensInUniswapPool.mul(POOL_FEE_DAILY_PERCENT)
316             .mul(timeBetweenLastPoolBurn))
317             .div(dayInSeconds)
318             .div(100);
319     }
320     
321     function pretty() public view returns (uint256) {
322         return _totalSupply.div(1e18);
323     }
324 
325     address public uniswapPool;
326     uint256 public lastPoolFeeTime;
327     event PoolFeeDropped(uint256 amount, uint256 poolBalance);
328     function processFeePool() external onlyOwner {
329         // Reset last fee time
330         lastPoolFeeTime = now;
331 
332         uint256 feeQty = poolFeeAvailable();
333 
334         _totalSupply = _totalSupply.sub(feeQty);
335         
336         uint256 burnQtyInGons = _gonsPerFragment  * feeQty;
337         
338         _gonBalances[uniswapPool] = _gonBalances[uniswapPool].sub(burnQtyInGons);
339         _gonBalances[_owner] = _gonBalances[_owner].add(burnQtyInGons);
340 
341         IUniswapV2Pair(uniswapPool).sync();
342 
343         emit PoolFeeDropped(feeQty, balanceOf(uniswapPool));
344     }
345     
346 }