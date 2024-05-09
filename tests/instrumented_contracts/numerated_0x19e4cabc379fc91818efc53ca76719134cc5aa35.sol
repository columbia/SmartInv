1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 	function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
5 		if (a == 0) {
6       		return 0;
7     	}
8 
9     	c = a * b;
10     	assert(c / a == b);
11     	return c;
12   	}
13 
14 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     	return a / b;
16 	}
17 
18 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     	assert(b <= a);
20     	return a - b;
21 	}
22 
23 	function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
24     	c = a + b;
25     	assert(c >= a);
26     	return c;
27 	}
28 	
29 	function mod(uint256 a, uint256 b) internal pure returns (uint256) {
30         require(b != 0);
31         return a % b;
32     }
33 }
34 
35 contract Ownable {
36     address internal _owner;
37     
38     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39     
40     constructor() public {
41         _owner = msg.sender;
42         emit OwnershipTransferred(address(0), _owner);
43     }
44     
45     function owner() public view returns (address) {
46         return _owner;
47     }
48 
49     modifier onlyOwner() {
50         require(isOwner(), "you are not the owner!");
51         _;
52     }
53 
54     function isOwner() public view returns (bool) {
55         return msg.sender == _owner;
56     }
57     
58     function transferOwnership(address newOwner) public onlyOwner {
59         _transferOwnership(newOwner);
60     }
61     
62     function _transferOwnership(address newOwner) internal {
63         require(newOwner != address(0), "cannot transfer ownership to ZERO address");
64         emit OwnershipTransferred(_owner, newOwner);
65         _owner = newOwner;
66     }
67 }
68 
69 interface IERC20 {
70     function totalSupply() external view returns (uint256);
71     function balanceOf(address who) external view returns (uint256);
72     function allowance(address owner, address spender) external view returns (uint256);
73     function transfer(address to, uint256 value) external returns (bool);
74     function approve(address spender, uint256 value) external returns (bool);
75     function transferFrom(address from, address to, uint256 value) external returns (bool);
76     
77     event Transfer(address indexed from, address indexed to, uint256 value);
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 contract ERC20 is IERC20 {
82     using SafeMath for uint256;
83     
84     mapping (address => uint256) private _balances;
85     mapping (address => mapping (address => uint256)) private _allowed;
86     uint256 private _totalSupply;
87     
88     function totalSupply() public view returns (uint256) {
89         return _totalSupply;
90     }
91     
92     function balanceOf(address owner) public view returns (uint256) {
93         return _balances[owner];
94     }
95     
96     function allowance(address owner, address spender) public view returns (uint256) {
97         return _allowed[owner][spender];
98     }
99 
100     function transfer(address to, uint256 value) public returns (bool) {
101         _transfer(msg.sender, to, value);
102         return true;
103     }
104     
105     function approve(address spender, uint256 value) public returns (bool) {
106         require(spender != address(0), "cannot approve to ZERO address");
107     
108         _allowed[msg.sender][spender] = value;
109         emit Approval(msg.sender, spender, value);
110         return true;
111     }
112     
113     function transferFrom(address from, address to, uint256 value) public returns (bool) {
114         require(value <= _allowed[from][msg.sender], "the balance is not enough");
115     
116         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
117         _transfer(from, to, value);
118         return true;
119     }
120     
121     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
122         require(spender != address(0), "cannot approve to ZERO address");
123     
124         _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
125         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
126         return true;
127     }
128     
129     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
130         require(spender != address(0), "cannot approve to ZERO address");
131     
132         _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
133         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
134         return true;
135     }
136     
137     function _transfer(address from, address to, uint256 value) internal {
138         require(value <= _balances[from], "the balance is not enough");
139         require(to != address(0), "cannot transfer to ZERO address");
140         
141         _balances[from] = _balances[from].sub(value);
142         _balances[to] = _balances[to].add(value);
143         emit Transfer(from, to, value);
144     }
145     
146     function _mint(address account, uint256 value) internal {
147         require(account != address(0), "cannot mint to ZERO address");
148         _totalSupply = _totalSupply.add(value);
149         _balances[account] = _balances[account].add(value);
150         emit Transfer(address(0), account, value);
151     }
152     
153     function _burn(address account, uint256 value) internal {
154         require(account != address(0), "cannot burn from ZERO address");
155         require(value <= _balances[account], "the balance is not enough");
156         
157         _totalSupply = _totalSupply.sub(value);
158         _balances[account] = _balances[account].sub(value);
159         emit Transfer(account, address(0), value);
160     }
161     
162     function _burnFrom(address account, uint256 value) internal {
163         require(value <= _allowed[account][msg.sender], "the allowance is not enough");
164         
165         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
166         _burn(account, value);
167     }
168 }
169 
170 contract GFToken is ERC20, Ownable {
171     string private _name;
172     string private _symbol;
173     uint8 private _decimals;
174     
175     mapping(address => bool) private _whiteList;
176     uint256[] private _tradingOpenTime;
177     mapping(address => bool) private _quitLock;
178     mapping(bytes32 => bool) private _batchRecord;
179     
180     constructor(string name, string symbol, uint8 decimals, uint256 _total) public {
181         _name = name;
182         _symbol = symbol;
183         _decimals = decimals;
184         
185         _mint(msg.sender, _total.mul(10 ** uint256(_decimals)));
186         _whiteList[msg.sender] = true;
187     }
188     
189     // detail info
190     function name() public view returns (string) {
191         return _name;
192     }
193     
194     function symbol() public view returns (string) {
195         return _symbol;
196     }
197     
198     function decimals() public view returns (uint8) {
199         return _decimals;
200     }
201     
202     // transfer ownership and balance
203     function transferOwnership(address newOwner) public onlyOwner {
204         _whiteList[newOwner] = true;
205         super.transfer(newOwner, balanceOf(msg.sender));
206         _whiteList[msg.sender] = false;
207         super.transferOwnership(newOwner);
208     }
209     
210     // whiteList
211     function inWhiteList(address addr) public view returns (bool) {
212         return _whiteList[addr];
213     }
214     
215     function setWhiteList(address[] addressArr, bool[] statusArr) public onlyOwner {
216         require(addressArr.length == statusArr.length, "The length of address array is not equal to the length of status array!");
217         
218         for(uint256 idx = 0; idx < addressArr.length; idx++) {
219             _whiteList[addressArr[idx]] = statusArr[idx];
220         }
221     }
222     
223     // trading open time
224     function setTradingTime(uint256[] times) public onlyOwner {
225         require(times.length.mod(2) == 0, "the length of times must be even number");
226         
227         for(uint256 idx = 0; idx < times.length; idx = idx+2) {
228             require(times[idx] < times[idx+1], "end time must be greater than start time");
229         }
230         _tradingOpenTime = times;
231     }
232     
233     function getTradingTime() public view returns (uint256[]) {
234         return _tradingOpenTime;
235     }
236     
237     function inTradingTime() public view returns (bool) {
238         for(uint256 idx = 0; idx < _tradingOpenTime.length; idx = idx+2) {
239             if(now > _tradingOpenTime[idx] && now < _tradingOpenTime[idx+1]) {
240                 return true;
241             }
242         }
243         return false;
244     }
245     
246     // quit
247     function inQuitLock(address account) public view returns (bool) {
248         return _quitLock[account];
249     }
250     
251     function setQuitLock(address account) public onlyOwner {
252         require(inWhiteList(account), "account is not in whiteList");
253         _quitLock[account] = true;
254     }
255     
256     function removeQuitAccount(address account) public onlyOwner {
257         require(inQuitLock(account), "the account is not in quit lock status");
258         
259         forceTransferBalance(account, _owner, balanceOf(account));
260         _whiteList[account] = false;
261         _quitLock[account] = false;
262     }
263     
264     // overwrite transfer and transferFrom
265     function transfer(address to, uint256 value) public returns (bool) {
266         require(inWhiteList(msg.sender), "caller is not in whiteList");
267         require(inWhiteList(to), "to address is not in whiteList");
268         
269         if(!inQuitLock(msg.sender) && !isOwner()) {
270             require(inTradingTime(), "now is not trading time");
271         }
272         return super.transfer(to, value);
273     }
274     
275     function transferFrom(address from, address to, uint256 value) public returns (bool) {
276         require(inWhiteList(from), "from address is not in whiteList");
277         require(inWhiteList(to), "to address is not in whiteList");
278         
279         if(!inQuitLock(msg.sender)) {
280             require(inTradingTime(), "now is not trading time");
281         }
282         return super.transferFrom(from, to, value);
283     }
284     
285     // force transfer balance
286     function forceTransferBalance(address from, address to, uint256 value) public onlyOwner {
287         require(inWhiteList(to), "to address is not in whiteList");
288         _transfer(from, to, value);
289     }
290     
291     // repalce account
292     function replaceAccount(address oldAccount, address newAccount) public onlyOwner {
293         require(inWhiteList(oldAccount), "old account is not in whiteList");
294         _whiteList[newAccount] = true;
295         forceTransferBalance(oldAccount, newAccount, balanceOf(oldAccount));
296         _whiteList[oldAccount] = false;
297     }
298     
299     // batch transfer
300     function batchTransfer(bytes32 batch, address[] addressArr, uint256[] valueArr) public onlyOwner {
301         require(addressArr.length == valueArr.length, "The length of address array is not equal to the length of value array!");
302         require(_batchRecord[batch] == false, "This batch number has already been used!");
303         
304         for(uint256 idx = 0; idx < addressArr.length; idx++) {
305             require(transfer(addressArr[idx], valueArr[idx]));
306         }
307         
308         _batchRecord[batch] = true;
309     }
310     
311     // mint and burn
312     function mint(address account, uint256 value) public onlyOwner returns (bool) {
313         require(inWhiteList(account), "account is not in whiteList");
314         _mint(account, value);
315     }
316     
317     function burn(address account, uint256 value) public onlyOwner returns (bool) {
318         _burn(account, value);
319         return true;
320     }
321 }