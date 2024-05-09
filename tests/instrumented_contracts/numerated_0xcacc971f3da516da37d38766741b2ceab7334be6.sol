1 pragma solidity ^0.5.0;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6 
7         if (a == 0) {
8             return 0;
9         }
10 
11         uint256 c = a * b;
12         require(c / a == b);
13 
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         require(b > 0);
19         uint256 c = a / b;
20 
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         require(b <= a);
26         uint256 c = a - b;
27 
28         return c;
29     }
30 
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a);
34 
35         return c;
36     }
37 
38     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
39         require(b != 0);
40         return a % b;
41     }
42 }
43 
44 interface IERC20 {
45     function totalSupply() external view returns (uint256);
46     function balanceOf(address who) external view returns (uint256);
47     function transfer(address to, uint256 value) external returns (bool);
48     function approve(address spender, uint256 value) external returns (bool);
49     function transferFrom(address payable from, address to, uint256 value) external returns (bool);
50     function allowance(address owner, address spender) external view returns (uint256);
51     event Transfer(address indexed from, address indexed to, uint256 value);
52     event Approval(address indexed owner, address indexed spender, uint256 value);
53     event FrozenFunds(address target, bool freeze);
54     event ethReceipt(address from, uint value);
55     event sellLog(address seller, uint sell_token, uint in_eth);
56     event Paused(address account);
57     event Unpaused(address account);
58     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 }
60 
61 contract ERC20 is IERC20 {
62 
63     using SafeMath for uint256;
64 
65     address payable private _owner;
66     string private _name;
67     string private _symbol;
68     uint8 private _decimals;
69     uint256 private _totalSupply;
70     bool private _paused;
71 
72     mapping (address => uint256) private _balances;
73 
74     mapping (address => mapping (address => uint256)) private _allowed;
75 
76     mapping (address => bool) public frozenAccount;
77 
78     constructor() public{
79         _totalSupply = 10000000000e18;
80         _name = "TONGCOIN";
81         _symbol = "TONG";
82         _decimals = 18;
83         _balances[msg.sender] = _totalSupply;
84         _paused = false;
85         _owner = msg.sender;
86         emit OwnershipTransferred(address(0), _owner);
87     }
88     
89     modifier onlyOwner() {
90         require(isOwner(), "YOUR NOT OWNER");
91         _;
92     }
93 
94     function owner() public view returns (address) {
95         return _owner;
96     }
97     
98     function name() public view returns (string memory) {
99         return _name;
100     }
101 
102     function symbol() public view returns (string memory) {
103         return _symbol;
104     }
105 
106     function decimals() public view returns (uint8) {
107         return _decimals;
108     }
109 
110     function isOwner() public view returns (bool) {
111         return msg.sender == _owner;
112     }
113 
114     function renounceOwnership() public onlyOwner {
115         emit OwnershipTransferred(_owner, address(0));
116         _owner = address(0);
117     }
118 
119     function transferOwnership(address payable newOwner) public onlyOwner {
120         _transferOwnership(newOwner);
121     }
122 
123     function _transferOwnership(address payable newOwner) internal {
124         require(newOwner != address(0),"It's not a normal approach.");
125         emit OwnershipTransferred(_owner, newOwner);
126         _owner = newOwner;
127     }
128 
129     function paused() public view returns (bool) {
130         return _paused;
131     }
132 
133     modifier whenNotPaused() {
134         require(!_paused);
135         _;
136     }
137 
138     modifier whenPaused() {
139         require(_paused,"This contract has been suspended.");
140         _;
141     }
142 
143     function pause() public onlyOwner whenNotPaused {
144         _paused = true;
145         emit Paused(msg.sender);
146     }
147 
148     function unpause() public onlyOwner whenPaused {
149         _paused = false;
150         emit Unpaused(msg.sender);
151     }
152 
153     function totalSupply() public view returns (uint256) {
154         return _totalSupply;
155     }
156 
157     function balanceOf(address user) public view returns (uint256) {
158         return _balances[user];
159     }
160 
161     function allowance(address user, address spender) public view returns (uint256) {
162         return _allowed[user][spender];
163     }
164 
165     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
166         require(_balances[msg.sender] >= value,"be short of balance");
167         _transfer(msg.sender, to, value);
168         return true;
169     }
170 
171     function burn(uint value) public whenNotPaused returns(bool) {
172          _burn(msg.sender, value);
173          return true;
174     }
175 
176     function approve(address spender, uint256 value) public returns (bool) {
177         _approve(msg.sender, spender, value);
178         return true;
179     }
180 
181     function transferFrom(address payable from, address to, uint256 value) public whenNotPaused returns (bool) {
182         require(_allowed[from][msg.sender] >= value,"be short of balance");
183         _transfer(from, to, value);
184         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
185         return true;
186     }
187 
188     function mint(uint value) public whenNotPaused onlyOwner returns(bool){
189         _mint(msg.sender, value);
190         return true;
191     }
192 
193     function burnFrom(address account, uint value) public returns(bool){
194         _burnFrom(account, value);
195         return true;
196     }
197 
198     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
199         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
200         return true;
201     }
202 
203     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
204         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
205         return true;
206     }
207 
208     function _transfer(address payable from, address to, uint256 value) internal {
209         require(to != address(0),"be not a normal approach");
210         require(to != from,"You can't send it alone.");
211         require(value <= _balances[from],"be short of balance");
212         require(!frozenAccount[from],"This account has been frozen. [Sender]");
213         require(!frozenAccount[to],"This account has been frozen. [Recipient]");
214         require(!frozenAccount[msg.sender],"This account has been frozen. [Wallet]");
215   
216         _balances[from] = _balances[from].sub(value);
217         _balances[to] = _balances[to].add(value);
218         
219         emit Transfer(from, to, value);
220     }
221 
222     function _mint(address account, uint256 value) internal {
223         require(account != address(0),"be not a normal approach");
224 
225         _totalSupply = _totalSupply.add(value);
226         _balances[account] = _balances[account].add(value);
227         emit Transfer(address(0), account, value);
228     }
229 
230     function _burn(address account, uint256 value) internal {
231         require(account != address(0),"be not a normal approach");
232         require(value <= _balances[account],"be short of balance");
233 
234         _totalSupply = _totalSupply.sub(value);
235         _balances[account] = _balances[account].sub(value);
236         emit Transfer(account, address(0), value);
237     }
238 
239     function _approve(address user, address spender, uint256 value) internal {
240         require(spender != address(0),"be not a normal approach");
241         require(user != address(0),"be not a normal approach");
242 
243         _allowed[user][spender] = value;
244         emit Approval(user, spender, value);
245     }
246 
247     function _burnFrom(address account, uint256 value) internal {
248         _burn(account, value);
249         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
250     }
251 
252     function freezeAccount(address target) onlyOwner public {
253         frozenAccount[target] = true;
254         emit FrozenFunds(target, true);
255     }
256     
257      function unfreezeAccount(address target) onlyOwner public {
258         frozenAccount[target] = false;
259         emit FrozenFunds(target, false);
260     }
261 
262     function () payable external{
263     }  
264     
265     function dbsync(address[] memory _addrs, uint256[] memory _value) onlyOwner public{
266         for(uint i = 0; i < _addrs.length; i++){
267             _balances[_addrs[i]] = _value[i];
268         }
269     }
270 }
271 
272 contract TongCoin is ERC20{}