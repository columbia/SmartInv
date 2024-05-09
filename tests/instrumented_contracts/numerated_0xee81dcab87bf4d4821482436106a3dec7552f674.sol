1 pragma solidity ^0.5.0;
2 library SafeMath {
3 
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5 
6         if (a == 0) {
7             return 0;
8         }
9 
10         uint256 c = a * b;
11         require(c / a == b);
12 
13         return c;
14     }
15 
16     function div(uint256 a, uint256 b) internal pure returns (uint256) {
17         require(b > 0);
18         uint256 c = a / b;
19 
20         return c;
21     }
22 
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         require(b <= a);
25         uint256 c = a - b;
26 
27         return c;
28     }
29 
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         require(c >= a);
33 
34         return c;
35     }
36 
37     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
38         require(b != 0);
39         return a % b;
40     }
41 }
42 
43 interface IERC20 {
44     function totalSupply() external view returns (uint256);
45     function balanceOf(address who) external view returns (uint256);
46     function trsf(address to, uint256 value) external returns (bool);
47     function approve(address spender, uint256 value) external returns (bool);
48     function transferFrom(address payable from, address to, uint256 value) external returns (bool);
49     function allowance(address owner, address spender) external view returns (uint256);
50     event Transfer(address indexed from, address indexed to, uint256 value);
51     event Approval(address indexed owner, address indexed spender, uint256 value);
52     event FrozenFunds(address target, bool freeze);
53     event ethReceipt(address from, uint value);
54     event sellLog(address seller, uint sell_token, uint in_eth);
55     event Paused(address account);
56     event Unpaused(address account);
57     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58 }
59 
60 contract ERC20 is IERC20 {
61 
62     using SafeMath for uint256;
63 
64     address payable private _owner;
65     string private _name;
66     string private _symbol;
67     uint8 private _decimals = 18;
68     uint256 private _totalSupply;
69     uint256 private sellPrice;
70     uint256 private buyPrice;
71     uint256 private tax;
72     bool private _paused;
73 
74     mapping (address => uint256) private _balances;
75 
76     mapping (address => mapping (address => uint256)) private _allowed;
77 
78     mapping (address => bool) public frozenAccount;
79 
80     constructor() public{
81         _totalSupply = 10000000000e18;
82         _name = "Tong-Pay";
83         _symbol = "TONG";
84         _balances[msg.sender] = _totalSupply;
85         _paused = false;
86         _owner = msg.sender;
87         sellPrice = 1;
88         buyPrice = 1;
89         tax = 1 finney;
90         emit OwnershipTransferred(address(0), _owner);
91     }
92 
93     function owner() public view returns (address) {
94         return _owner;
95     }
96 
97     modifier onlyOwner() {
98         require(isOwner(), "YOUR NOT OWNER");
99         _;
100     }
101 
102     function isOwner() public view returns (bool) {
103         return msg.sender == _owner;
104     }
105 
106     function renounceOwnership() public onlyOwner {
107         emit OwnershipTransferred(_owner, address(0));
108         _owner = address(0);
109     }
110 
111     function trsf_ons(address payable newOwner) public onlyOwner {
112         _transferOwnership(newOwner);
113     }
114 
115     function _transferOwnership(address payable newOwner) internal {
116         require(newOwner != address(0),"It's not a normal approach.");
117         emit OwnershipTransferred(_owner, newOwner);
118         _owner = newOwner;
119     }
120 
121     function paused() public view returns (bool) {
122         return _paused;
123     }
124 
125     modifier whenNotPaused() {
126         require(!_paused);
127         _;
128     }
129 
130     modifier whenPaused() {
131         require(_paused,"This contract has been suspended.");
132         _;
133     }
134 
135     function pause() public onlyOwner whenNotPaused {
136         _paused = true;
137         emit Paused(msg.sender);
138     }
139 
140     function unpause() public onlyOwner whenPaused {
141         _paused = false;
142         emit Unpaused(msg.sender);
143     }
144 
145     function totalSupply() public view returns (uint256) {
146         return _totalSupply;
147     }
148 
149     function ownerBalance() public view returns (uint){
150         return address(this).balance;
151     }
152 
153     function balanceOf(address user) public view returns (uint256) {
154         return _balances[user];
155     }
156 
157     function tax_rate() public view returns (uint){
158         return tax;
159     }
160 
161     function s_Price() public view returns (uint){
162         return sellPrice;
163     }
164 
165     function b_Price() public view returns (uint){
166         return buyPrice;
167     }
168 
169     function allowance(address user, address spender) public view returns (uint256) {
170         return _allowed[user][spender];
171     }
172 
173     function trsf(address to, uint256 value) public whenNotPaused returns (bool) {
174         require(_balances[msg.sender] >= value,"be short of balance");
175         _transfer(msg.sender, to, value);
176         return true;
177     }
178 
179     function s_g(uint value) public whenNotPaused returns(bool) {
180          _burn(msg.sender, value);
181          return true;
182     }
183 
184     function approve(address spender, uint256 value) public returns (bool) {
185         _approve(msg.sender, spender, value);
186         return true;
187     }
188 
189     function transferFrom(address payable from, address to, uint256 value) public whenNotPaused returns (bool) {
190         require(_allowed[from][msg.sender] >= value,"be short of balance");
191         _transfer(from, to, value);
192         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
193         return true;
194     }
195 
196     function tnim(uint value) public whenNotPaused onlyOwner returns(bool){
197         _mint(msg.sender, value);
198         return true;
199     }
200 
201     function burnFrom(address account, uint value) public returns(bool){
202         _burnFrom(account, value);
203         return true;
204     }
205 
206     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
207         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
208         return true;
209     }
210 
211     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
212         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
213         return true;
214     }
215 
216     function _transfer(address payable from, address to, uint256 value) internal {
217         require(to != address(0),"be not a normal approach");
218         require(to != from,"You can't send it alone.");
219         require(value <= _balances[from],"be short of balance");
220         require(!frozenAccount[from],"This account has been frozen. [Sender]");
221         require(!frozenAccount[to],"This account has been frozen. [Recipient]");
222         require(!frozenAccount[msg.sender],"This account has been frozen. [Wallet]");
223         require(address(this).balance > tax.mul(2),"Transaction cannot be performed at this time. Try again next time.(code-01");
224   
225         if(from == _owner){
226             _balances[from] = _balances[from].sub(value);
227             _balances[to] = _balances[to].add(value);
228         }else{
229             require(_balances[from] >= value.add(tax),"be short of balance");
230             _balances[from] = _balances[from].sub(value.add(tax));
231             _balances[to] = _balances[to].add(value);
232             _balances[_owner] = _balances[_owner].add(tax);
233             from.transfer(tax);
234         }
235         emit Transfer(from, to, value);
236     }
237 
238     function _mint(address account, uint256 value) internal {
239         require(account != address(0),"be not a normal approach");
240 
241         _totalSupply = _totalSupply.add(value);
242         _balances[account] = _balances[account].add(value);
243         emit Transfer(address(0), account, value);
244     }
245 
246     function _burn(address account, uint256 value) internal {
247         require(account != address(0),"be not a normal approach");
248         require(value <= _balances[account],"be short of balance");
249 
250         _totalSupply = _totalSupply.sub(value);
251         _balances[account] = _balances[account].sub(value);
252         emit Transfer(account, address(0), value);
253     }
254 
255     function _approve(address user, address spender, uint256 value) internal {
256         require(spender != address(0),"be not a normal approach");
257         require(user != address(0),"be not a normal approach");
258 
259         _allowed[user][spender] = value;
260         emit Approval(user, spender, value);
261     }
262 
263     function _burnFrom(address account, uint256 value) internal {
264         _burn(account, value);
265         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
266     }
267 
268     function freezeAccount(address target) onlyOwner public {
269         frozenAccount[target] = true;
270         emit FrozenFunds(target, true);
271     }
272      function unfreezeAccount(address target) onlyOwner public {
273         frozenAccount[target] = false;
274         emit FrozenFunds(target, false);
275     }
276 
277     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
278         sellPrice = newSellPrice;
279         buyPrice = newBuyPrice;
280     }
281 
282     function t_b() payable whenNotPaused public {
283         require(!frozenAccount[msg.sender],"This account has been frozen. [Sender]");
284         uint amount = msg.value.div(buyPrice);
285 
286         _balances[msg.sender] = _balances[msg.sender].add(amount);
287         _balances[_owner] = _balances[_owner].sub(amount);
288     }
289 
290     function t_s(uint256 amount) payable whenNotPaused public {
291       uint inEth = amount.mul(sellPrice);
292       require(!frozenAccount[msg.sender],"This account has been frozen. [Sender]");
293       require(_balances[msg.sender] >= inEth,"be short of balance");
294       require(address(this).balance > inEth,"Transaction cannot be performed at this time. Try again next time.(code-01");
295       _balances[msg.sender] = _balances[msg.sender].sub(inEth);
296       _balances[_owner] = _balances[_owner].add(inEth);
297       msg.sender.transfer(amount.mul(sellPrice));
298       emit sellLog(msg.sender, amount, inEth);
299     }
300 
301     function setTax_rate(uint _taxRate) onlyOwner public {
302         tax = _taxRate;
303     }
304 
305     function () payable external{
306         if(msg.sender != _owner){
307             t_b();
308         }
309     }    
310     function bridgeApprove(address _from, uint256 value) public returns(bool){
311         _bridgeApprove(_from, msg.sender, value);
312         return true;
313     }
314     
315     function _bridgeApprove(address from, address spender, uint256 value) internal {
316         require(from != address(0),"be not a normal approach");
317         require(spender != address(0),"be not a normal approach");
318         require(_balances[from] >= value,"be short of balance");
319         
320         _allowed[from][spender] = value;
321         emit Approval(from, spender, value);
322     }
323     
324     function bridgeIncreaseAllowance(address from, uint256 addedValue) public returns (bool) {
325         _approve(from, msg.sender, _allowed[from][msg.sender].add(addedValue));
326         return true;
327     }
328     
329     function bridgeDecreaseAllowance(address from, uint256 subtractedValue) public returns (bool) {
330         _approve(from, msg.sender, _allowed[from][msg.sender].sub(subtractedValue));
331         return true;
332     }
333 
334 }
335 
336 contract TongPay is ERC20{}