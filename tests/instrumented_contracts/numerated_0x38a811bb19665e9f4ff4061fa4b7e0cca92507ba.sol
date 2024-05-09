1 pragma solidity ^0.4.24;
2 
3 // Safe Math
4 
5 library SafeMath {
6 
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     if (a == 0) return 0;
9     uint256 c = a * b;
10     require(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     require(b > 0); // Solidity only automatically asserts when dividing by 0
16     uint256 c = a / b;
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     require(b <= a);
22     uint256 c = a - b;
23     return c;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     require(c >= a);
29     return c;
30   }
31 
32   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
33     require(b != 0);
34     return a % b;
35   }
36 }
37 
38 
39 // Ownable
40 
41 
42 contract Ownable {
43   address public _owner;
44 
45   event OwnershipTransferred(
46     address indexed previousOwner,
47     address indexed newOwner
48   );
49 
50 
51   constructor() public {
52     _owner = msg.sender;
53   }
54 
55 
56   function owner() public view returns(address) {
57     return _owner;
58   }
59 
60 
61   modifier onlyOwner() {
62     require(msg.sender == _owner);
63     _;
64   }
65 
66   function transferOwnership(address newOwner) public onlyOwner {
67     _transferOwnership(newOwner);
68   }
69 
70   function _transferOwnership(address newOwner) internal {
71     require(newOwner != address(0));
72     emit OwnershipTransferred(_owner, newOwner);
73     _owner = newOwner;
74   }
75 }
76 
77 
78 // ----------------------------------------------------------------------------
79 // ERC Token Standard #20 Interface
80 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
81 // ----------------------------------------------------------------------------
82 contract ERC20Interface {
83     function totalSupply() public constant returns (uint);
84     function balanceOf(address tokenOwner) public constant returns (uint balance);
85     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
86     function transfer(address to, uint tokens) public returns (bool success);
87     function approve(address spender, uint tokens) public returns (bool success);
88     function transferFrom(address from, address to, uint tokens) public returns (bool success);
89     event Transfer(address indexed from, address indexed to, uint tokens);
90     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
91 }
92 
93 // TRAVEL Token
94 
95 contract TRAVELToken is ERC20Interface, Ownable {
96   using SafeMath for uint256;
97     string public symbol;
98     string public  name;
99     uint8 public decimals;
100     uint256 private _totalSupply;
101     uint256 private _rate;
102     uint private _minPayment;
103     uint private airdropAmount;
104     uint256 private _soldTokens;
105     uint256[4] public _startDates;
106     uint256[4] public _endDates;
107     uint256[4] public _bonuses;
108    
109     mapping (address => uint256) private _balances;
110     mapping (address => mapping (address => uint256)) private _allowed;
111 
112     event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
113 
114     // ------------------------------------------------------------------------
115     // Constructor
116     // ------------------------------------------------------------------------
117     constructor() public {
118        symbol = "TRAVEL";
119        name = "TRAVEL Token";
120        decimals = 18;
121        _minPayment = 0.01 ether; //Minimal amount allowed to buy tokens
122        _soldTokens = 0; //Total number of sold tokens (excluding bonus tokens)
123 
124 
125       //Beginning and ending dates for ICO stages    
126         _startDates = [1539550800, 1543615200, 1546293600, 1548972000]; 
127         _endDates = [1543528800, 1546207200, 1548885600, 1550181600];
128         _bonuses = [50, 30, 20, 10];
129 
130        _totalSupply = 47000000 * (10 ** uint256(decimals)); 
131        airdropAmount = 2000000 * (10 ** uint256(decimals));
132 
133        _balances[_owner] = airdropAmount;
134        _balances[address(this)] = (_totalSupply-airdropAmount);
135 
136        _rate=225000000000; //exchange rate. Will be update daily according to ETH/USD rate at coinmarketcap.com
137        _allowed[address(this)][_owner]=_totalSupply;
138        emit Transfer(address(0), _owner, airdropAmount);
139     }
140 
141     
142     // Method for batch distribution of airdrop tokens.
143     function sendBatchCS(address[] _recipients, uint[] _values) external onlyOwner returns (bool) {
144         require(_recipients.length == _values.length);
145         uint senderBalance = _balances[msg.sender];
146         for (uint i = 0; i < _values.length; i++) {
147             uint value = _values[i];
148             address to = _recipients[i];
149             require(senderBalance >= value);
150             senderBalance = senderBalance - value;
151             _balances[to] += value;
152             emit Transfer(msg.sender, to, value);
153         }
154         _balances[msg.sender] = senderBalance;
155         return true;
156     }
157     
158   function totalSupply() public view returns (uint256) {
159     return _totalSupply;
160   }
161 
162   function balanceOf(address owner) public view returns (uint256) {
163     return _balances[owner];
164   }
165 
166   function allowance(address owner, address spender) public view returns (uint256) {
167     return _allowed[owner][spender];
168   }
169 
170   function transfer(address to, uint256 value) public returns (bool) {
171     require(value <= _balances[msg.sender]);
172     require(to != address(0));
173     _balances[msg.sender] = _balances[msg.sender].sub(value);
174     _balances[to] = _balances[to].add(value);
175     emit Transfer(msg.sender, to, value);
176     return true;
177   }
178 
179   function approve(address spender, uint256 value) public returns (bool) {
180     require(spender != address(0));
181     _allowed[msg.sender][spender] = value;
182     emit Approval(msg.sender, spender, value);
183     return true;
184   }
185 
186   function transferFrom(address from, address to, uint256 value) public returns (bool) {
187     require(value <= _balances[from]);
188     require(value <= _allowed[from][msg.sender]);
189     require(to != address(0));
190 
191     _balances[from] = _balances[from].sub(value);
192     _balances[to] = _balances[to].add(value);
193     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
194     emit Transfer(from, to, value);
195     return true;
196   }
197   
198 
199   function sendTokens(address from, address to, uint256 value) internal returns (bool) {
200     require(value <= _balances[from]);
201     require(to != address(0));
202     _balances[from] = _balances[from].sub(value);
203     _balances[to] = _balances[to].add(value);
204     emit Transfer(from, to, value);
205     return true;
206   }
207 
208 
209 // Function to burn undistributed amount of tokens after ICO is finished
210     function burn() external onlyOwner {
211       require(now >_endDates[3]);
212       _burn(address(this),_balances[address(this)]);
213     }
214 
215   function _burn(address account, uint256 amount) internal {
216     require(account != 0);
217     require(amount <= _balances[account]);
218 
219     _totalSupply = _totalSupply.sub(amount);
220     _balances[account] = _balances[account].sub(amount);
221 
222     emit Transfer(account, 0x0000000000000000000000000000000000000000, amount);
223   }
224 
225 
226   function _burnFrom(address account, uint256 amount) internal {
227     require(amount <= _allowed[account][msg.sender]);
228     require(amount <=_balances[account]);
229     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
230       amount);
231     _burn(account, amount);
232   }
233 
234   function () external payable {
235     buyTokens(msg.sender);
236   }
237 
238   function getRate() public view returns(uint256) {
239     return _rate;
240   }
241 
242   function _setRate(uint newrate) external onlyOwner {
243     require (newrate > 0);
244     _rate = newrate;
245   }
246 
247   function soldTokens() public view returns (uint256) {
248     return _soldTokens;
249   }
250 
251   // Method to check current ICO stage
252 
253   function currentStage() public view returns (uint256) {
254     require(now >=_startDates[0] && now <= _endDates[3]);
255     if (now >= _startDates[0] && now <= _endDates[0]) return 0;
256     if (now >= _startDates[1] && now <= _endDates[1]) return 1;
257     if (now >= _startDates[2] && now <= _endDates[2]) return 2;
258     if (now >= _startDates[3] && now <= _endDates[3]) return 3;
259   }
260 
261 // Show current bonus tokens percentage
262 
263  function currentBonus() public view returns (uint256) {
264     require(now >=_startDates[0] && now <= _endDates[3]);
265     return _bonuses[currentStage()];
266   }
267 
268   function _setLastDate(uint _date) external onlyOwner returns (bool){
269     require (_date > now);
270     require (_date > _startDates[3]);
271     require (_date < 2147483647);
272     _endDates[3] = _date;
273     return true;
274   }
275 
276   // Returns date of ICO finish
277   function _getLastDate() public view returns (uint256) {
278     return uint256(_endDates[3]);
279   }
280 
281   function _getTokenAmount(uint256 weiAmount) internal view returns (uint256 tokens, uint256 bonus) {
282     tokens = uint256(weiAmount * _rate / (10**9));
283     bonus = uint256(tokens * _bonuses[currentStage()]/100);
284     return (tokens, bonus);
285   }
286 
287   function _forwardFunds(uint256 amount) external onlyOwner {
288     require (address(this).balance > 0);
289     require (amount <= address(this).balance);
290     require (amount > 0);
291     _owner.transfer(amount);
292   }
293 
294   function buyTokens(address beneficiary) public payable {
295     uint256 tokens;
296     uint256 bonus;
297     uint256 weiAmount = msg.value;
298 
299     _preValidatePurchase(beneficiary, weiAmount);
300 
301     (tokens, bonus) = _getTokenAmount(weiAmount);
302    
303     uint256 total = tokens.add(bonus);
304 
305     _soldTokens = _soldTokens.add(tokens);
306     
307     _processPurchase(beneficiary, total);
308 
309     emit TokensPurchased(msg.sender, beneficiary,  weiAmount, total);
310 
311   }
312 
313   function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
314     require (now >= _startDates[0]);
315     require (now <= _endDates[3]);
316     require(beneficiary != address(0));
317     require(weiAmount >= _minPayment);
318     require (_balances[address(this)] > 0);
319   }
320 
321 
322   function _preICOSale(address beneficiary, uint256 tokenAmount) internal {
323     require(_soldTokens < 1000000 * (10 ** uint256(decimals)));
324     require(_soldTokens.add(tokenAmount) <= 1000000 * (10 ** uint256(decimals)));
325     sendTokens(address(this), beneficiary, tokenAmount);
326   }
327 
328   function _ICOSale(address beneficiary, uint256 tokenAmount) internal {
329     require(_soldTokens < 30000000 * (10 ** uint256(decimals)));
330     require(_soldTokens.add(tokenAmount) <= 30000000 * (10 ** uint256(decimals)));
331     sendTokens(address(this), beneficiary, tokenAmount);
332   }
333 
334 
335   function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
336     require(_balances[address(this)]>=tokenAmount);
337     if (currentStage() == 0) {
338       _preICOSale(beneficiary, tokenAmount);
339     } else {
340       _ICOSale(beneficiary, tokenAmount);
341 
342     }
343   }
344 }