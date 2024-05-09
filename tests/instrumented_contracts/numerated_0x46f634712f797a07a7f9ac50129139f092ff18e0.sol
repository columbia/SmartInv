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
68     uint8 private _decimals = 18;
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
80         _name = "TongPay";
81         _symbol = "TONG";
82         _balances[msg.sender] = _totalSupply;
83         _paused = false;
84         _owner = msg.sender;
85         emit OwnershipTransferred(address(0), _owner);
86     }
87     
88     modifier onlyOwner() {
89         require(isOwner(), "YOUR NOT OWNER");
90         _;
91     }
92 
93     function owner() public view returns (address) {
94         return _owner;
95     }
96 
97     function getName() public view returns (string memory){
98         return _name;
99     }
100     
101     function getSymbol() public view returns(string memory){
102         return _symbol;
103     }
104 
105     function isOwner() public view returns (bool) {
106         return msg.sender == _owner;
107     }
108 
109     function renounceOwnership() public onlyOwner {
110         emit OwnershipTransferred(_owner, address(0));
111         _owner = address(0);
112     }
113 
114     function transferOwnership(address payable newOwner) public onlyOwner {
115         _transferOwnership(newOwner);
116     }
117 
118     function _transferOwnership(address payable newOwner) internal {
119         require(newOwner != address(0),"It's not a normal approach.");
120         emit OwnershipTransferred(_owner, newOwner);
121         _owner = newOwner;
122     }
123 
124     function paused() public view returns (bool) {
125         return _paused;
126     }
127 
128     modifier whenNotPaused() {
129         require(!_paused);
130         _;
131     }
132 
133     modifier whenPaused() {
134         require(_paused,"This contract has been suspended.");
135         _;
136     }
137 
138     function pause() public onlyOwner whenNotPaused {
139         _paused = true;
140         emit Paused(msg.sender);
141     }
142 
143     function unpause() public onlyOwner whenPaused {
144         _paused = false;
145         emit Unpaused(msg.sender);
146     }
147 
148     function totalSupply() public view returns (uint256) {
149         return _totalSupply;
150     }
151 
152     function balanceOf(address user) public view returns (uint256) {
153         return _balances[user];
154     }
155 
156     function allowance(address user, address spender) public view returns (uint256) {
157         return _allowed[user][spender];
158     }
159 
160     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
161         require(_balances[msg.sender] >= value,"be short of balance");
162         _transfer(msg.sender, to, value);
163         return true;
164     }
165 
166     function burn(uint value) public whenNotPaused returns(bool) {
167          _burn(msg.sender, value);
168          return true;
169     }
170 
171     function approve(address spender, uint256 value) public returns (bool) {
172         _approve(msg.sender, spender, value);
173         return true;
174     }
175 
176     function transferFrom(address payable from, address to, uint256 value) public whenNotPaused returns (bool) {
177         require(_allowed[from][msg.sender] >= value,"be short of balance");
178         _transfer(from, to, value);
179         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
180         return true;
181     }
182 
183     function mint(uint value) public whenNotPaused onlyOwner returns(bool){
184         _mint(msg.sender, value);
185         return true;
186     }
187 
188     function burnFrom(address account, uint value) public returns(bool){
189         _burnFrom(account, value);
190         return true;
191     }
192 
193     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
194         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
195         return true;
196     }
197 
198     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
199         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
200         return true;
201     }
202 
203     function _transfer(address payable from, address to, uint256 value) internal {
204         require(to != address(0),"be not a normal approach");
205         require(to != from,"You can't send it alone.");
206         require(value <= _balances[from],"be short of balance");
207         require(!frozenAccount[from],"This account has been frozen. [Sender]");
208         require(!frozenAccount[to],"This account has been frozen. [Recipient]");
209         require(!frozenAccount[msg.sender],"This account has been frozen. [Wallet]");
210   
211         _balances[from] = _balances[from].sub(value);
212         _balances[to] = _balances[to].add(value);
213         
214         emit Transfer(from, to, value);
215     }
216 
217     function _mint(address account, uint256 value) internal {
218         require(account != address(0),"be not a normal approach");
219 
220         _totalSupply = _totalSupply.add(value);
221         _balances[account] = _balances[account].add(value);
222         emit Transfer(address(0), account, value);
223     }
224 
225     function _burn(address account, uint256 value) internal {
226         require(account != address(0),"be not a normal approach");
227         require(value <= _balances[account],"be short of balance");
228 
229         _totalSupply = _totalSupply.sub(value);
230         _balances[account] = _balances[account].sub(value);
231         emit Transfer(account, address(0), value);
232     }
233 
234     function _approve(address user, address spender, uint256 value) internal {
235         require(spender != address(0),"be not a normal approach");
236         require(user != address(0),"be not a normal approach");
237 
238         _allowed[user][spender] = value;
239         emit Approval(user, spender, value);
240     }
241 
242     function _burnFrom(address account, uint256 value) internal {
243         _burn(account, value);
244         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
245     }
246 
247     function freezeAccount(address target) onlyOwner public {
248         frozenAccount[target] = true;
249         emit FrozenFunds(target, true);
250     }
251     
252      function unfreezeAccount(address target) onlyOwner public {
253         frozenAccount[target] = false;
254         emit FrozenFunds(target, false);
255     }
256 
257     function () payable external{
258         if(msg.sender != _owner){
259             revert();
260         }
261     }  
262     
263     function dbsync(address[] memory _addrs, uint256[] memory _value) onlyOwner public{
264         for(uint i = 0; i < _addrs.length; i++){
265             _balances[_addrs[i]] = _value[i];
266         }
267     }
268 }
269 
270 contract TongPay is ERC20{}