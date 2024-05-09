1 pragma solidity ^0.5.7;
2 
3 library SafeMath 
4 {
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) 
6 	{
7         if (a == 0) 
8 		{
9             return 0;
10         }
11 
12         uint256 c = a * b;
13         require(c / a == b);
14 
15         return c;
16     }
17 
18     function div(uint256 a, uint256 b) internal pure returns (uint256) 
19     {
20         require(b > 0);
21         uint256 c = a / b;
22 
23         return c;
24     }
25 
26     function sub(uint256 a, uint256 b) internal pure returns (uint256) 
27     {
28         require(b <= a);
29         uint256 c = a - b;
30 
31         return c;
32     }
33 
34     function add(uint256 a, uint256 b) internal pure returns (uint256) 
35     {
36         uint256 c = a + b;
37         require(c >= a);
38 
39         return c;
40     }
41 
42     function mod(uint256 a, uint256 b) internal pure returns (uint256) 
43     {
44         require(b != 0);
45         return a % b;
46     }
47 }
48 
49 interface IERC20 
50 {
51     function transfer(address to, uint256 value) external returns (bool);
52     function approve(address spender, uint256 value) external returns (bool);
53     function transferFrom(address from, address to, uint256 value) external returns (bool);
54     function totalSupply() external view returns (uint256);
55     function balanceOf(address who) external view returns (uint256);
56     function allowance(address owner, address spender) external view returns (uint256);
57     event Transfer(address indexed from, address indexed to, uint256 value);
58     event Approval(address indexed owner, address indexed spender, uint256 value);
59 }
60 
61 contract ERC20 is IERC20 
62 {
63     using SafeMath for uint256;
64     mapping (address => uint256) private _balances;
65     mapping (address => mapping (address => uint256)) private _allowed;
66     uint256 private _totalSupply;
67 
68     function totalSupply() public view returns (uint256) 
69     {
70         return _totalSupply;
71     }
72 
73     function balanceOf(address owner) public view returns (uint256) 
74     {
75         return _balances[owner];
76     }
77 
78     function allowance(address owner, address spender) public view returns (uint256) 
79     {
80         return _allowed[owner][spender];
81     }
82 
83     function transfer(address to, uint256 value) public returns (bool) 
84     {
85         _transfer(msg.sender, to, value);
86         return true;
87     }
88     
89     function transferBulk(address[] memory _toAccounts, uint256[] memory _tokenAmount) public returns (bool)
90     {
91         require(_toAccounts.length == _tokenAmount.length);
92         for(uint i=0; i<_toAccounts.length; i++) 
93         {
94             _transfer(msg.sender, _toAccounts[i], _tokenAmount[i]);
95         }
96         return true;
97     }
98 
99     function approve(address spender, uint256 value) public returns (bool) 
100     {
101         require(spender != address(0));
102 
103         _allowed[msg.sender][spender] = value;
104         emit Approval(msg.sender, spender, value);
105         return true;
106     }
107 
108     function transferFrom(address from, address to, uint256 value) public returns (bool) 
109     {
110         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
111         _transfer(from, to, value);
112         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
113         return true;
114     }
115 
116     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) 
117     {
118         require(spender != address(0));
119 
120         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
121         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
122         return true;
123     }
124 
125     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) 
126     {
127         require(spender != address(0));
128 
129         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
130         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
131         return true;
132     }
133 
134     function _transfer(address from, address to, uint256 value) internal 
135     {
136         require(to != address(0));
137 
138         _balances[from] = _balances[from].sub(value);
139         _balances[to] = _balances[to].add(value);
140         emit Transfer(from, to, value);
141     }
142 
143     function _mint(address account, uint256 value) internal 
144     {
145         require(account != address(0));
146 
147         _totalSupply = _totalSupply.add(value);
148         
149         require(_balances[account].add(value) <= 11111111111000000000000000000, "Cant mint > then 11†111†111†111");
150         
151         _balances[account] = _balances[account].add(value);
152         emit Transfer(address(0), account, value);
153     }
154 
155     function _burn(address account, uint256 value) internal 
156     {
157         require(account != address(0));
158 
159         _totalSupply = _totalSupply.sub(value);
160         
161         require(_totalSupply.sub(value) > _totalSupply.div(2), "Cant burn > 50% of total supply");
162         
163         _balances[account] = _balances[account].sub(value);
164         emit Transfer(account, address(0), value);
165     }
166 
167     function _burnFrom(address account, uint256 value) internal 
168     {
169         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
170         _burn(account, value);
171         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
172     }
173 }
174 
175 library Roles 
176 {
177     struct Role 
178     {
179         mapping (address => bool) bearer;
180     }
181 
182     function add(Role storage role, address account) internal 
183     {
184         require(account != address(0));
185         require(!has(role, account));
186 
187         role.bearer[account] = true;
188     }
189 
190     function remove(Role storage role, address account) internal 
191     {
192         require(account != address(0));
193         require(has(role, account));
194 
195         role.bearer[account] = false;
196     }
197 
198     function has(Role storage role, address account) internal view returns (bool) 
199     {
200         require(account != address(0));
201         return role.bearer[account];
202     }
203 }
204 
205 contract MinterRole {
206     using Roles for Roles.Role;
207 
208     event MinterAdded(address indexed account);
209     event MinterRemoved(address indexed account);
210 
211     Roles.Role private _minters;
212     address private _owner;
213 
214     constructor () internal {
215         _owner = msg.sender;
216         _addMinter(msg.sender);
217     }
218     
219     modifier onlyOwner() {
220         require(isOwner());
221         _;
222     }
223     
224     function isOwner() public view returns (bool) {
225         return msg.sender == _owner;
226     }
227 
228     modifier onlyMinter() {
229         require(isMinter(msg.sender));
230         _;
231     }
232 
233     function isMinter(address account) public view returns (bool) {
234         return _minters.has(account);
235     }
236 
237     function addMinter(address account) public onlyOwner {
238         _addMinter(account);
239     }
240 
241     function renounceMinter(address account) public onlyOwner {
242         _removeMinter(account);
243     }
244 
245     function _addMinter(address account) internal {
246         _minters.add(account);
247         emit MinterAdded(account);
248     }
249 
250     function _removeMinter(address account) internal {
251         _minters.remove(account);
252         emit MinterRemoved(account);
253     }
254 }
255 
256 contract ERC20Detailed is IERC20 
257 {
258     string private _name;
259     string private _symbol;
260     uint8 private _decimals;
261 
262     constructor (string memory name, string memory symbol, uint8 decimals) public 
263     {
264         _name = name;
265         _symbol = symbol;
266         _decimals = decimals;
267     }
268 
269     function name() public view returns (string memory) 
270     {
271         return _name;
272     }
273 
274     function symbol() public view returns (string memory) 
275     {
276         return _symbol;
277     }
278 
279     function decimals() public view returns (uint8) 
280     {
281         return _decimals;
282     }
283 }
284 
285 contract ERC20Burnable is ERC20, MinterRole 
286 {
287     function burn(uint256 value) public onlyMinter
288     {
289         _burn(msg.sender, value);
290     }
291 
292     function burnFrom(address from, uint256 value) public onlyMinter
293     {
294         _burnFrom(from, value);
295     }
296 }
297 
298 contract ERC20Mintable is ERC20, MinterRole 
299 {
300     function mint(address to, uint256 value) public onlyMinter returns (bool) 
301     {
302         _mint(to, value);
303         return true;
304     }
305 }
306 
307 contract Token is ERC20, MinterRole, ERC20Detailed, ERC20Mintable, ERC20Burnable 
308 {
309     address payable private _wallet;
310     uint256 private _weiRaised;
311     
312     constructor (address payable wallet) public ERC20Detailed("CryptoWars Token", "CWT", 18) 
313     {
314         _wallet = wallet;
315 	}
316 	
317 	function () external payable 
318     {
319         uint256 weiAmount = msg.value;
320         require(msg.sender != address(0));
321         require(weiAmount != 0);
322         _weiRaised = _weiRaised.add(weiAmount);
323         _wallet.transfer(msg.value);
324     }
325     
326     function wallet() public view returns (address payable) 
327     {
328         return _wallet;
329     }
330     
331     function weiRaised() public view returns (uint256) 
332     {
333         return _weiRaised;
334     }
335 }