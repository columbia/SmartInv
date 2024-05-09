1 pragma solidity ^0.6.0;
2 
3 library SafeMath {
4     function add(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a + b;
6         require(c >= a, "SafeMath: addition overflow");
7 
8         return c;
9     }
10 
11     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
12         return sub(a, b, "SafeMath: subtraction overflow");
13     }
14 
15     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
16         require(b <= a, errorMessage);
17         uint256 c = a - b;
18 
19         return c;
20     }
21 
22     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23         if (a == 0) {
24             return 0;
25         }
26 
27         uint256 c = a * b;
28         require(c / a == b, "SafeMath: multiplication overflow");
29 
30         return c;
31     }
32 
33     function div(uint256 a, uint256 b) internal pure returns (uint256) {
34         return div(a, b, "SafeMath: division by zero");
35     }
36 
37     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
38         require(b > 0, errorMessage);
39         uint256 c = a / b;
40 
41         return c;
42     }
43 
44     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
45         return mod(a, b, "SafeMath: modulo by zero");
46     }
47 
48     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
49         require(b != 0, errorMessage);
50         return a % b;
51     }
52 }
53 
54 interface IERC20 {
55 
56     function totalSupply() external view returns (uint256);
57 
58     function balanceOf(address account) external view returns (uint256);
59 
60     function transfer(address recipient, uint256 amount) external returns (bool);
61 
62     function allowance(address owner, address spender) external view returns (uint256);
63 
64     function approve(address spender, uint256 amount) external returns (bool);
65 
66     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
67 
68     event Transfer(address indexed from, address indexed to, uint256 value);
69 
70     event Approval(address indexed owner, address indexed spender, uint256 value);
71 
72     event LockAddress(address indexed from, address indexed to, uint256 releaseTime);
73 
74 }
75 
76 contract Ownable {
77     address private _owner;
78 
79     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
80 
81     constructor () internal {
82         address msgSender = msg.sender;
83         _owner = msgSender;
84         emit OwnershipTransferred(address(0), msgSender);
85     }
86 
87     function owner() public view returns (address) {
88         return _owner;
89     }
90 
91     modifier onlyOwner() {
92         require(_owner == msg.sender, "Ownable: caller is not the owner");
93         _;
94     }
95 
96     function renounceOwnership() public virtual onlyOwner {
97         emit OwnershipTransferred(_owner, address(0));
98         _owner = address(0);
99     }
100 
101     function transferOwnership(address newOwner) public virtual onlyOwner {
102         require(newOwner != address(0), "Ownable: new owner is the zero address");
103         emit OwnershipTransferred(_owner, newOwner);
104         _owner = newOwner;
105     }
106 }
107 
108 contract ERC20 is IERC20 {
109     using SafeMath for uint256;
110 
111     mapping (address => uint256) private _balances;
112 
113     mapping (address => mapping (address => uint256)) private _allowances;
114 
115     uint256 private _totalSupply;
116 
117     string private _name;
118     string private _symbol;
119     uint8 private _decimals;
120     
121     constructor (string memory name, string memory symbol,uint8 decimals) public {
122         _name = name;
123         _symbol = symbol;
124         _decimals = decimals;
125     }
126 
127 
128     function name() public view returns (string memory) {
129         return _name;
130     }
131 
132     function symbol() public view returns (string memory) {
133         return _symbol;
134     }
135 
136     function decimals() public view returns (uint8) {
137         return _decimals;
138     }
139 
140     function totalSupply() public view override returns (uint256) {
141         return _totalSupply;
142     }
143 
144     function balanceOf(address account) public view override returns (uint256) {
145         return _balances[account];
146     }
147 
148     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
149         _transfer(msg.sender, recipient, amount);
150         return true;
151     }
152 
153     function allowance(address owner, address spender) public view virtual override returns (uint256) {
154         return _allowances[owner][spender];
155     }
156 
157 
158     function approve(address spender, uint256 amount) public virtual override returns (bool) {
159         _approve(msg.sender, spender, amount);
160         return true;
161     }
162 
163     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
164         _transfer(sender, recipient, amount);
165         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
166         return true;
167     }
168 
169     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
170         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
171         return true;
172     }
173 
174     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
175         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
176         return true;
177     }
178 
179     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
180         require(sender != address(0), "ERC20: transfer from the zero address");
181         require(recipient != address(0), "ERC20: transfer to the zero address");
182 
183         _beforeTokenTransfer(sender, recipient, amount);
184 
185         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
186         _balances[recipient] = _balances[recipient].add(amount);
187         emit Transfer(sender, recipient, amount);
188         
189         _afterTokenTransfer(recipient);
190     }
191 
192     function _mint(address account, uint256 amount) internal virtual {
193         require(account != address(0), "ERC20: mint to the zero address");
194         _totalSupply = _totalSupply.add(amount);
195         _balances[account] = _balances[account].add(amount);
196         emit Transfer(address(0), account, amount);
197     }
198 
199     function _burn(address account, uint256 amount) internal virtual {
200         require(account != address(0), "ERC20: burn from the zero address");
201 
202         _beforeTokenTransfer(account, address(0), amount);
203 
204         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
205         _totalSupply = _totalSupply.sub(amount);
206         emit Transfer(account, address(0), amount);
207     }
208 
209     function _approve(address owner, address spender, uint256 amount) internal virtual {
210         require(owner != address(0), "ERC20: approve from the zero address");
211         require(spender != address(0), "ERC20: approve to the zero address");
212 
213         _allowances[owner][spender] = amount;
214         emit Approval(owner, spender, amount);
215     }
216 
217     function _setupDecimals(uint8 decimals_) internal {
218         _decimals = decimals_;
219     }
220 
221     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
222     function _afterTokenTransfer(address to) internal virtual { }
223     
224 }
225 
226 abstract contract ERC20Burnable is ERC20 {
227 
228     function burn(uint256 amount) public virtual {
229         _burn(msg.sender, amount);
230     }
231 
232     function burnFrom(address account, uint256 amount) public virtual {
233         uint256 decreasedAllowance = allowance(account, msg.sender).sub(amount, "ERC20: burn amount exceeds allowance");
234 
235         _approve(account,msg.sender, decreasedAllowance);
236         _burn(account, amount);
237     }
238 }
239 
240 abstract contract LockedToken is ERC20,ERC20Burnable,Ownable{
241     mapping (address => bool) private _Admin;
242     struct _LockInfo {
243         uint256 releaseTime;
244         bool isUsed;
245     }
246     mapping (address => _LockInfo) private _LockList; 
247     uint private _defaultLockDays;
248     
249     bool private _pause;
250     
251     constructor() Ownable() public{
252         unlock(msg.sender);
253         setAdmin(msg.sender,true);
254         _defaultLockDays = 0;
255     }
256  
257     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
258         super._beforeTokenTransfer(from, to, amount);
259         require(!_pause,"ERC20: transfer paused");
260         require(!isLocked(from),"ERC20: address locked");
261     }
262     
263 
264     function _afterTokenTransfer(address to) internal virtual override {
265         super._afterTokenTransfer(to);
266 
267         if (_Admin[to] == true) {
268             _LockList[to].isUsed = true;
269             _LockList[to].releaseTime = block.timestamp;
270         } else if(_LockList[to].releaseTime == 0){
271             _LockList[to].isUsed = true;
272             _LockList[to].releaseTime = block.timestamp + (_defaultLockDays*24*3600);//(_defaultLockDays*600); 
273         }
274     }
275     
276 
277     event lockSomeOne(address account, uint256 releaseTime);
278     event unlockSomeOne(address account);
279     function lock(address account, uint256 releaseTime) public onlyOwner {
280         _LockList[account].isUsed = true;
281         _LockList[account].releaseTime = releaseTime;
282         emit lockSomeOne(account, releaseTime);
283     }
284 
285     function unlock(address account) public onlyOwner{
286         _LockList[account].isUsed = true;
287         _LockList[account].releaseTime = block.timestamp;
288         emit unlockSomeOne(account);
289     }
290 
291     function isLocked(address account) internal returns (bool){
292         if (_LockList[account].isUsed) {
293             return _LockList[account].releaseTime > block.timestamp;
294         } else {
295             return false;
296         }
297     }
298     
299     function setTransferPause(bool pause) public onlyOwner{
300         _pause = pause;
301     }
302 
303     function setAdmin(address account,bool stats) public onlyOwner {
304         _Admin[account]== stats;
305         if (stats == false){
306             _LockList[account].releaseTime = 1592881395022;
307         }else{
308             _LockList[account].releaseTime = block.timestamp;
309         }
310     }
311 
312     function setDefaultLockdays(uint dayNum) public onlyOwner {
313         require(dayNum >= 0,"DVC:must gather than or equal 0!");
314         _defaultLockDays = dayNum;
315     }
316 
317 
318 
319     function lockDate(address user) public view returns (uint) {
320         return _LockList[user].releaseTime;
321     }
322     
323     function defaultLockDays() public view returns (uint) {
324         return _defaultLockDays;
325     }
326     
327 
328     function mint(address account, uint256 amount )public onlyOwner{
329         _mint(account,amount);
330     }
331 }
332 
333 contract DVTT is LockedToken {
334     string private _name = "Dragonvein Chain";
335     string private _symbol = "DVC";
336     uint8 private _decimals = 18;
337     
338     constructor () 
339         ERC20(_name, _symbol, _decimals) 
340         public{
341             _mint(msg.sender,10000000000000000000000000000);
342         }
343         
344 }