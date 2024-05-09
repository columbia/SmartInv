1 pragma solidity 0.4.24;
2 
3 contract Ownable {
4     address public owner;
5     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
6 
7     function Ownable() {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner() {
12         require(msg.sender == owner);
13         _;
14     }
15 
16     function transferOwnership(address newOwner) onlyOwner public {
17         require(newOwner != address(0));
18         emit OwnershipTransferred(owner, newOwner);
19         owner = newOwner;
20     }
21 }
22 
23 library SafeMath {
24     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
25         uint256 c = a * b;
26         assert(a == 0 || c / a == b);
27         return c;
28     }
29 
30     function div(uint256 a, uint256 b) internal constant returns (uint256) {
31         uint256 c = a / b;
32         return c;
33     }
34 
35     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     function add(uint256 a, uint256 b) internal constant returns (uint256) {
41         uint256 c = a + b;
42         assert(c >= a);
43         return c;
44     }
45 }
46 
47 contract ERC20 {
48     uint256 public totalSupply;
49     function balanceOf(address who) public constant returns (uint256);
50     function transfer(address to, uint256 value) public returns (bool);
51     event Transfer(address indexed from, address indexed to, uint256 value);
52 
53     function allowance(address owner, address spender) public constant returns (uint256);
54     function transferFrom(address from, address to, uint256 value) public returns (bool);
55     function approve(address spender, uint256 value) public returns (bool);
56     event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 
59 contract StandardToken is ERC20 {
60     using SafeMath for uint256;
61 
62     mapping (address => uint256) balances;
63     mapping (address => mapping (address => uint256)) allowed;
64 
65     function transfer(address _to, uint256 _value) public returns (bool) {
66         require(_to != address(0));
67 
68         balances[msg.sender] = balances[msg.sender].sub(_value);
69         balances[_to] = balances[_to].add(_value);
70         Transfer(msg.sender, _to, _value);
71         return true;
72     }
73 
74     function balanceOf(address _owner) public constant returns (uint256 balance) {
75         return balances[_owner];
76     }
77 
78     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
79         require(_to != address(0));
80 
81         uint256 _allowance = allowed[_from][msg.sender];
82 
83         balances[_from] = balances[_from].sub(_value);
84         balances[_to] = balances[_to].add(_value);
85         allowed[_from][msg.sender] = _allowance.sub(_value);
86         Transfer(_from, _to, _value);
87         return true;
88     }
89 
90     function approve(address _spender, uint256 _value) public returns (bool) {
91         allowed[msg.sender][_spender] = _value;
92         Approval(msg.sender, _spender, _value);
93         return true;
94     }
95 
96     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
97         return allowed[_owner][_spender];
98     }
99 }
100 
101 contract Pausable is Ownable {
102     event Pause();
103     event Unpause();
104 
105     bool public paused = false;
106 
107     modifier whenNotPaused() {
108         require(!paused);
109         _;
110     }
111 
112     modifier whenPaused() {
113         require(paused);
114         _;
115     }
116 
117     function pause() onlyOwner whenNotPaused public {
118         paused = true;
119         emit Pause();
120     }
121 
122     function unpause() onlyOwner whenPaused public {
123         paused = false;
124         emit Unpause();
125     }
126 }
127 
128 contract DinoToken is StandardToken, Pausable {
129     string public constant name = "DINO Token";
130     string public constant symbol = "DINO";
131     uint8  public constant decimals = 18;
132 
133     address public  tokenSaleContract;
134 
135     modifier validDestination(address to) {
136         require(to != address(this));
137         _;
138     }
139 
140     function DinoToken(uint _tokenTotalAmount) public {
141         totalSupply = _tokenTotalAmount * (10 ** uint256(decimals));
142 
143         balances[msg.sender] = totalSupply;
144         Transfer(address(0x0), msg.sender, totalSupply);
145 
146         tokenSaleContract = msg.sender;
147     }
148 
149     function transfer(address _to, uint _value)
150         public
151         validDestination(_to)
152         whenNotPaused
153         returns (bool) 
154     {
155         return super.transfer(_to, _value);
156     }
157 
158     function transferFrom(address _from, address _to, uint _value)
159         public
160         validDestination(_to)
161         whenNotPaused
162         returns (bool) 
163     {
164         return super.transferFrom(_from, _to, _value);
165     }
166 }
167 
168 contract DinoTokenSale is Ownable {
169     using SafeMath for uint256;
170 
171 	// token allocation
172     uint public constant TOTAL_DINOTOKEN_SUPPLY  = 200000000;
173     uint public constant ALLOC_FOUNDATION       = 40000000e18; // 20%
174     uint public constant ALLOC_TEAM             = 30000000e18; // 15%
175     uint public constant ALLOC_MARKETING        = 30000000e18; // 15%
176     uint public constant ALLOC_ADVISOR          = 10000000e18; // 5%
177     uint public constant ALLOC_SALE             = 90000000e18; // 45%
178 
179     // sale stage
180     uint public constant STAGE1_TIME_END  = 9 days; 
181     uint public constant STAGE2_TIME_END  = 20 days; 
182     uint public constant STAGE3_TIME_END  = 35 days; 
183 
184     // Token sale rate from ETH to DINO
185     uint public constant RATE_PRESALE      = 4000; // +25%
186     uint public constant RATE_CROWDSALE_S1 = 3680; // +15%
187     uint public constant RATE_CROWDSALE_S2 = 3424; // +7%
188     uint public constant RATE_CROWDSALE_S3 = 3200; // +0%
189 
190 	// For token transfer
191     address public constant WALLET_FOUNDATION = 0x9bd5ae7400ce11b418a4ef9e9310fbd0c2f5e503; 
192     address public constant WALLET_TEAM       = 0x9bb148948a75a5b205b4d13efb9fe893c8c8fb7b; 
193     address public constant WALLET_MARKETING  = 0x83e5e7f8f90c90a0b8948dc2c1116f8c0dcf10d8; 
194     address public constant WALLET_ADVISOR    = 0x5c166aa48503fbec223fa06d2757af01850d60f7; 
195 
196     // For ether transfer
197     address private constant WALLET_ETH_DINO  = 0x191B29ADbCA5Ecb285005Cff15441F8411DF5f72; 
198     address private constant WALLET_ETH_ADMIN = 0xAba33f3a098f7f0AC9B60614e395A40406e97915; 
199 
200     DinoToken public dinoToken; 
201 
202     uint256 public presaleStartTime = 1528416000; // 2018-6-8 8:00 (UTC+8) 1528416000
203     uint256 public startTime        = 1528848000; // 2018-6-13 8:00 (UTC+8) 1528848000
204     uint256 public endTime          = 1531872000; // 2018-7-18 8:00 (UTC+8) 1531872000
205     bool public halted;
206 
207     mapping(address=>bool) public whitelisted_Presale;
208 
209     // stats
210     uint256 public totalDinoSold;
211     uint256 public weiRaised;
212     mapping(address => uint256) public weiContributions;
213 
214     // EVENTS
215     event updatedPresaleWhitelist(address target, bool isWhitelisted);
216     event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);
217 
218     function DinoTokenSale() public {
219         dinoToken = new DinoToken(TOTAL_DINOTOKEN_SUPPLY);
220         dinoToken.transfer(WALLET_FOUNDATION, ALLOC_FOUNDATION);
221         dinoToken.transfer(WALLET_TEAM, ALLOC_TEAM);
222         dinoToken.transfer(WALLET_MARKETING, ALLOC_MARKETING);
223         dinoToken.transfer(WALLET_ADVISOR, ALLOC_ADVISOR);
224 
225         dinoToken.transferOwnership(owner);
226     }
227 
228     function updatePresaleWhitelist(address[] _targets, bool _isWhitelisted)
229         public
230         onlyOwner
231     {
232         for (uint i = 0; i < _targets.length; i++) {
233             whitelisted_Presale[_targets[i]] = _isWhitelisted;
234             emit updatedPresaleWhitelist(_targets[i], _isWhitelisted);
235         }
236     }
237 
238     function validPurchase() 
239         internal 
240         returns(bool) 
241     {
242         bool withinPeriod = now >= presaleStartTime && now <= endTime;
243         bool nonZeroPurchase = msg.value != 0;
244         return withinPeriod && nonZeroPurchase && !halted;
245     }
246 
247     function getPriceRate()
248         public
249         view
250         returns (uint)
251     {
252         if (now <= startTime) return 0;
253         if (now <= startTime + STAGE1_TIME_END) return RATE_CROWDSALE_S1;
254         if (now <= startTime + STAGE2_TIME_END) return RATE_CROWDSALE_S2;
255         if (now <= startTime + STAGE3_TIME_END) return RATE_CROWDSALE_S3;
256         return 0;
257     }
258 
259     function ()
260         public 
261         payable 
262     {
263         require(validPurchase());
264 
265         uint256 weiAmount = msg.value;
266         uint256 purchaseTokens;
267 
268         if (whitelisted_Presale[msg.sender]) 
269             purchaseTokens = weiAmount.mul(RATE_PRESALE); 
270         else
271             purchaseTokens = weiAmount.mul(getPriceRate()); 
272 
273         require(purchaseTokens > 0 && ALLOC_SALE - totalDinoSold >= purchaseTokens); // supply check
274         require(dinoToken.transfer(msg.sender, purchaseTokens));
275         emit TokenPurchase(msg.sender, weiAmount, purchaseTokens);
276 
277         totalDinoSold = totalDinoSold.add(purchaseTokens); 
278         weiRaised = weiRaised.add(weiAmount);
279         weiContributions[msg.sender] = weiContributions[msg.sender].add(weiAmount);
280         
281         forwardFunds();
282     }
283 
284     function forwardFunds() 
285         internal 
286     {
287         WALLET_ETH_DINO.transfer((msg.value).mul(91).div(100));
288         WALLET_ETH_ADMIN.transfer((msg.value).mul(9).div(100));
289     }
290 
291     function hasEnded() 
292         public 
293         view
294         returns(bool) 
295     {
296         return now > endTime;
297     }
298 
299     function toggleHalt(bool _halted)
300         public
301         onlyOwner
302     {
303         halted = _halted;
304     }
305 
306     function drainToken(address _to, uint256 _amount) 
307         public
308         onlyOwner
309     {
310         require(dinoToken.balanceOf(this) >= _amount);
311         dinoToken.transfer(_to, _amount);
312     }
313 
314     function drainRemainingToken(address _to) 
315         public
316         onlyOwner
317     {
318         require(hasEnded());
319         dinoToken.transfer(_to, dinoToken.balanceOf(this));
320     }
321 
322     function safeDrain() 
323         public
324         onlyOwner
325     {
326         WALLET_ETH_ADMIN.transfer(this.balance);
327     }
328 }