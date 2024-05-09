1 // ----------------------------------------------------------------------------
2 // HNB Protocol Contract
3 // Name        : HNB Protocol
4 // Symbol      : HNB
5 // Decimals    : 18
6 // InitialSupply : 1,500,000,000 HNB
7 // ----------------------------------------------------------------------------
8 
9 pragma solidity 0.5.8;
10 
11 interface IERC20 {
12 
13     function totalSupply() external view returns (uint256);
14 
15     function balanceOf(address account) external view returns (uint256);
16 
17     function transfer(address recipient, uint256 amount) external returns (bool);
18 
19     function allowance(address owner, address spender) external view returns (uint256);
20 
21     function approve(address spender, uint256 amount) external returns (bool);
22 
23     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
24 
25     event Transfer(address indexed from, address indexed to, uint256 value);
26 
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 library SafeMath {
31 
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         require(c >= a, "SafeMath: addition overflow");
35 
36         return c;
37     }
38 
39     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40         require(b <= a, "SafeMath: subtraction overflow");
41         uint256 c = a - b;
42 
43         return c;
44     }
45 
46     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
47 
48         if (a == 0) {
49             return 0;
50         }
51 
52         uint256 c = a * b;
53         require(c / a == b, "SafeMath: multiplication overflow");
54 
55         return c;
56     }
57 
58     function div(uint256 a, uint256 b) internal pure returns (uint256) {
59         require(b > 0, "SafeMath: division by zero");
60         uint256 c = a / b;
61 
62         return c;
63     }
64 
65     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
66         require(b != 0, "SafeMath: modulo by zero");
67         return a % b;
68     }
69 }
70 
71 contract ERC20 is IERC20 {
72     using SafeMath for uint256;
73 
74     mapping (address => uint256) internal _balances;
75 
76     mapping (address => mapping (address => uint256)) private _allowances;
77 
78     uint256 private _totalSupply;
79 
80     function totalSupply() public view returns (uint256) {
81         return _totalSupply;
82     }
83 
84     function balanceOf(address account) public view returns (uint256) {
85         return _balances[account];
86     }
87 
88     function transfer(address recipient, uint256 amount) public returns (bool) {
89         _transfer(msg.sender, recipient, amount);
90         return true;
91     }
92 
93     function allowance(address owner, address spender) public view returns (uint256) {
94         return _allowances[owner][spender];
95     }
96 
97     function approve(address spender, uint256 value) public returns (bool) {
98         _approve(msg.sender, spender, value);
99         return true;
100     }
101 
102     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
103         _transfer(sender, recipient, amount);
104         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
105         return true;
106     }
107 
108     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
109         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
110         return true;
111     }
112 
113     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
114         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
115         return true;
116     }
117 
118     function _transfer(address sender, address recipient, uint256 amount) internal {
119         require(sender != address(0), "ERC20: transfer from the zero address");
120         require(recipient != address(0), "ERC20: transfer to the zero address");
121 
122         _balances[sender] = _balances[sender].sub(amount);
123         _balances[recipient] = _balances[recipient].add(amount);
124         emit Transfer(sender, recipient, amount);
125     }
126 
127     function _mint(address account, uint256 amount) internal {
128         require(account != address(0), "ERC20: mint to the zero address");
129 
130         _totalSupply = _totalSupply.add(amount);
131         _balances[account] = _balances[account].add(amount);
132         emit Transfer(address(0), account, amount);
133     }
134 
135     function _burn(address owner, uint256 value) internal {
136         require(owner != address(0), "ERC20: burn from the zero address");
137 
138         _totalSupply = _totalSupply.sub(value);
139         _balances[owner] = _balances[owner].sub(value);
140         emit Transfer(owner, address(0), value);
141     }
142 
143     function _approve(address owner, address spender, uint256 value) internal {
144         require(owner != address(0), "ERC20: approve from the zero address");
145         require(spender != address(0), "ERC20: approve to the zero address");
146 
147         _allowances[owner][spender] = value;
148         emit Approval(owner, spender, value);
149     }
150 
151     function _burnFrom(address owner, uint256 amount) internal {
152         _burn(owner, amount);
153         _approve(owner, msg.sender, _allowances[owner][msg.sender].sub(amount));
154     }
155 }
156 
157 contract HNBProtocol is ERC20 {
158     string public constant name = "HNB Protocol";
159     string public constant symbol = "HNB"; 
160     uint8 public constant decimals = 18; 
161     uint256 public constant initialSupply = 1500000000 * (10 ** uint256(decimals));
162     
163     constructor() public {
164         super._mint(msg.sender, initialSupply);
165         owner = msg.sender;
166     }
167 
168     address public owner;
169 
170     event OwnershipRenounced(address indexed previousOwner);
171     event OwnershipTransferred(
172     address indexed previousOwner,
173     address indexed newOwner
174     );
175 
176     modifier onlyOwner() {
177         require(msg.sender == owner, "Not owner");
178         _;
179     }
180 
181     function transferOwnership(address _newOwner) public onlyOwner {
182         _transferOwnership(_newOwner);
183     }
184 
185     function _transferOwnership(address _newOwner) internal {
186         require(_newOwner != address(0), "Already Owner");
187         emit OwnershipTransferred(owner, _newOwner);
188         owner = _newOwner;
189     }
190 
191     function transfer(
192         address _to,
193         uint256 _value
194     )
195       public
196 
197       returns (bool)
198     {
199         releaseLock(msg.sender);
200         return super.transfer(_to, _value);
201     }
202 
203     function transferFrom(
204         address _from,
205         address _to,
206         uint256 _value
207     )
208       public
209 
210       returns (bool)
211     {
212         releaseLock(_from);
213         return super.transferFrom(_from, _to, _value);
214     }
215 
216     event Burn(address indexed burner, uint256 value);
217 
218     function burn(uint256 _value) public onlyOwner {
219         require(_value <= super.balanceOf(owner), "Balance is too small.");
220 
221         _burn(owner, _value);
222         emit Burn(owner, _value);
223     }
224 
225     struct LockInfo {
226         uint256 releaseTime;
227         uint256 balance;
228     }
229     mapping(address => LockInfo[]) internal lockInfo;
230 
231     event Lock(address indexed holder, uint256 value, uint256 releaseTime);
232     event Unlock(address indexed holder, uint256 value);
233 
234     function balanceOf(address _holder) public view returns (uint256 balance) {
235         uint256 lockedBalance = 0;
236         for(uint256 i = 0; i < lockInfo[_holder].length ; i++ ) {
237             lockedBalance = lockedBalance.add(lockInfo[_holder][i].balance);
238         }
239         return super.balanceOf(_holder).add(lockedBalance);
240     }
241 
242     function releaseLock(address _holder) internal {
243 
244         for(uint256 i = 0; i < lockInfo[_holder].length ; i++ ) {
245             if (lockInfo[_holder][i].releaseTime <= now) {
246                 _balances[_holder] = _balances[_holder].add(lockInfo[_holder][i].balance);
247                 emit Unlock(_holder, lockInfo[_holder][i].balance);
248                 lockInfo[_holder][i].balance = 0;
249 
250                 if (i != lockInfo[_holder].length - 1) {
251                     lockInfo[_holder][i] = lockInfo[_holder][lockInfo[_holder].length - 1];
252                     i--;
253                 }
254                 lockInfo[_holder].length--;
255 
256             }
257         }
258     }
259     function lockCount(address _holder) public view returns (uint256) {
260         return lockInfo[_holder].length;
261     }
262     function lockState(address _holder, uint256 _idx) public view returns (uint256, uint256) {
263         return (lockInfo[_holder][_idx].releaseTime, lockInfo[_holder][_idx].balance);
264     }
265 
266     function lock(address _holder, uint256 _amount, uint256 _releaseTime) public onlyOwner {
267         require(super.balanceOf(_holder) >= _amount, "Balance is too small.");
268         require(block.timestamp <= _releaseTime, "TokenTimelock: release time is before current time");
269         
270         _balances[_holder] = _balances[_holder].sub(_amount);
271         lockInfo[_holder].push(
272             LockInfo(_releaseTime, _amount)
273         );
274         emit Lock(_holder, _amount, _releaseTime);
275     }
276 
277     function unlock(address _holder, uint256 i) public onlyOwner {
278         require(i < lockInfo[_holder].length, "No lock information.");
279 
280         _balances[_holder] = _balances[_holder].add(lockInfo[_holder][i].balance);
281         emit Unlock(_holder, lockInfo[_holder][i].balance);
282         lockInfo[_holder][i].balance = 0;
283 
284         if (i != lockInfo[_holder].length - 1) {
285             lockInfo[_holder][i] = lockInfo[_holder][lockInfo[_holder].length - 1];
286         }
287         lockInfo[_holder].length--;
288     }
289 
290     function transferWithLock(address _to, uint256 _value, uint256 _releaseTime) public onlyOwner returns (bool) {
291         require(_to != address(0), "wrong address");
292         require(_value <= super.balanceOf(owner), "Not enough balance");
293         require(block.timestamp <= _releaseTime, "TokenTimelock: release time is before current time");
294 
295         _balances[owner] = _balances[owner].sub(_value);
296         lockInfo[_to].push(
297             LockInfo(_releaseTime, _value)
298         );
299         emit Transfer(owner, _to, _value);
300         emit Lock(_to, _value, _releaseTime);
301 
302         return true;
303     }
304     
305 }