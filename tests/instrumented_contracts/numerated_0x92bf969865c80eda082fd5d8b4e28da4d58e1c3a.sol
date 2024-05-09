1 pragma solidity ^0.5.2;
2 
3 // File: contracts/math/SafeMath.sol
4 
5 library SafeMath {
6   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
7     c = a + b;
8     require(c >= a);
9   }
10 
11   function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
12     require(b <= a);
13     return a - b;
14   }
15 
16   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
17     if (a == 0) {
18       return 0;
19     }
20 
21     c = a * b;
22     require(c / a == b);
23   }
24 
25   function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
26     // Since Solidity automatically asserts when dividing by 0,
27     // but we only need it to revert.
28     require(b > 0);
29     return a / b;
30   }
31 
32   function mod(uint256 a, uint256 b) internal pure returns (uint256 c) {
33     // Same reason as `div`.
34     require(b > 0);
35     return a % b;
36   }
37 
38   function ceilingDiv(uint256 a, uint256 b) internal pure returns (uint256 c) {
39     return add(div(a, b), mod(a, b) > 0 ? 1 : 0);
40   }
41 
42   function subU64(uint64 a, uint64 b) internal pure returns (uint64 c) {
43     require(b <= a);
44     return a - b;
45   }
46 
47   function addU8(uint8 a, uint8 b) internal pure returns (uint8 c) {
48     c = a + b;
49     require(c >= a);
50   }
51 }
52 
53 // File: contracts/token/erc20/IERC20.sol
54 
55 interface IERC20 {
56   event Transfer(address indexed _from, address indexed _to, uint256 _value);
57   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
58 
59   function totalSupply() external view returns (uint256 _supply);
60   function balanceOf(address _owner) external view returns (uint256 _balance);
61 
62   function approve(address _spender, uint256 _value) external returns (bool _success);
63   function allowance(address _owner, address _spender) external view returns (uint256 _value);
64 
65   function transfer(address _to, uint256 _value) external returns (bool _success);
66   function transferFrom(address _from, address _to, uint256 _value) external returns (bool _success);
67 }
68 
69 // File: contracts/token/erc20/ERC20.sol
70 
71 contract ERC20 is IERC20 {
72   using SafeMath for uint256;
73 
74   uint256 public totalSupply;
75   mapping (address => uint256) public balanceOf;
76   mapping (address => mapping (address => uint256)) public allowance;
77 
78   function approve(address _spender, uint256 _value) public returns (bool _success) {
79     allowance[msg.sender][_spender] = _value;
80     emit Approval(msg.sender, _spender, _value);
81     return true;
82   }
83 
84   function transfer(address _to, uint256 _value) public returns (bool _success) {
85     require(_to != address(0));
86     balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
87     balanceOf[_to] = balanceOf[_to].add(_value);
88     emit Transfer(msg.sender, _to, _value);
89     return true;
90   }
91 
92   function transferFrom(address _from, address _to, uint256 _value) public returns (bool _success) {
93     require(_to != address(0));
94     balanceOf[_from] = balanceOf[_from].sub(_value);
95     balanceOf[_to] = balanceOf[_to].add(_value);
96     allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
97     emit Transfer(_from, _to, _value);
98     return true;
99   }
100 }
101 
102 // File: contracts/token/erc20/IERC20Burnable.sol
103 
104 interface IERC20Burnable {
105   function burn(uint256 _value) external returns (bool _success);
106   function burnFrom(address _from, uint256 _value) external returns (bool _success);
107 }
108 
109 // File: contracts/token/erc20/ERC20Burnable.sol
110 
111 contract ERC20Burnable is ERC20, IERC20Burnable {
112   function burn(uint256 _value) public returns (bool _success) {
113     totalSupply = totalSupply.sub(_value);
114     balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
115     emit Transfer(msg.sender, address(0), _value);
116     return true;
117   }
118 
119   function burnFrom(address _from, uint256 _value) public returns (bool _success) {
120     totalSupply = totalSupply.sub(_value);
121     balanceOf[_from] = balanceOf[_from].sub(_value);
122     allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
123     emit Transfer(_from, address(0), _value);
124     return true;
125   }
126 }
127 
128 // File: contracts/access/HasAdmin.sol
129 
130 contract HasAdmin {
131   event AdminChanged(address indexed _oldAdmin, address indexed _newAdmin);
132   event AdminRemoved(address indexed _oldAdmin);
133 
134   address public admin;
135 
136   modifier onlyAdmin {
137     require(msg.sender == admin);
138     _;
139   }
140 
141   constructor() internal {
142     admin = msg.sender;
143     emit AdminChanged(address(0), admin);
144   }
145 
146   function changeAdmin(address _newAdmin) external onlyAdmin {
147     require(_newAdmin != address(0));
148     emit AdminChanged(admin, _newAdmin);
149     admin = _newAdmin;
150   }
151 
152   function removeAdmin() external onlyAdmin {
153     emit AdminRemoved(admin);
154     admin = address(0);
155   }
156 }
157 
158 // File: contracts/access/HasMinters.sol
159 
160 contract HasMinters is HasAdmin {
161   event MinterAdded(address indexed _minter);
162   event MinterRemoved(address indexed _minter);
163 
164   address[] public minters;
165   mapping (address => bool) public minter;
166 
167   modifier onlyMinter {
168     require(minter[msg.sender]);
169     _;
170   }
171 
172   function addMinters(address[] memory _addedMinters) public onlyAdmin {
173     address _minter;
174 
175     for (uint256 i = 0; i < _addedMinters.length; i++) {
176       _minter = _addedMinters[i];
177 
178       if (!minter[_minter]) {
179         minters.push(_minter);
180         minter[_minter] = true;
181         emit MinterAdded(_minter);
182       }
183     }
184   }
185 
186   function removeMinters(address[] memory _removedMinters) public onlyAdmin {
187     address _minter;
188 
189     for (uint256 i = 0; i < _removedMinters.length; i++) {
190       _minter = _removedMinters[i];
191 
192       if (minter[_minter]) {
193         minter[_minter] = false;
194         emit MinterRemoved(_minter);
195       }
196     }
197 
198     uint256 i = 0;
199 
200     while (i < minters.length) {
201       _minter = minters[i];
202 
203       if (!minter[_minter]) {
204         minters[i] = minters[minters.length - 1];
205         delete minters[minters.length - 1];
206         minters.length--;
207       } else {
208         i++;
209       }
210     }
211   }
212 }
213 
214 // File: contracts/token/erc20/ERC20Mintable.sol
215 
216 contract ERC20Mintable is HasMinters, ERC20 {
217   function mint(address _to, uint256 _value) public onlyMinter returns (bool _success) {
218     totalSupply = totalSupply.add(_value);
219     balanceOf[_to] = balanceOf[_to].add(_value);
220     emit Transfer(address(0), _to, _value);
221     return true;
222   }
223 }
224 
225 // File: contracts/token/erc20/ERC20Capped.sol
226 
227 contract ERC20Capped is ERC20Mintable, ERC20Burnable {
228   uint256 public cappedSupply;
229 
230   constructor(uint256 _cappedSupply) public {
231     cappedSupply = _cappedSupply;
232   }
233 
234   function mint(address _to, uint256 _value) public returns (bool _success) {
235     require(totalSupply.add(_value) <= cappedSupply);
236     return super.mint(_to, _value);
237   }
238 
239   function burn(uint256 _value) public returns (bool _success) {
240     cappedSupply = cappedSupply.sub(_value);
241     return super.burn(_value);
242   }
243 
244   function burnFrom(address _from, uint256 _value) public returns (bool _success) {
245     cappedSupply = cappedSupply.sub(_value);
246     return super.burnFrom(_from, _value);
247   }
248 }
249 
250 // File: contracts/token/erc20/IERC20Detailed.sol
251 
252 interface IERC20Detailed {
253   function name() external view returns (string memory _name);
254   function symbol() external view returns (string memory _symbol);
255   function decimals() external view returns (uint8 _decimals);
256 }
257 
258 // File: contracts/token/erc20/ERC20Detailed.sol
259 
260 contract ERC20Detailed is ERC20, IERC20Detailed {
261   string public name;
262   string public symbol;
263   uint8 public decimals;
264 
265   constructor(string memory _name, string memory _symbol, uint8 _decimals) public {
266     name = _name;
267     symbol = _symbol;
268     decimals = _decimals;
269   }
270 }
271 
272 // File: contracts/token/erc20/IERC20Receiver.sol
273 
274 interface IERC20Receiver {
275   function receiveApproval(
276     address _from,
277     uint256 _value,
278     address _tokenAddress,
279     bytes calldata _data
280   )
281     external;
282 }
283 
284 // File: contracts/token/erc20/ERC20Extended.sol
285 
286 contract ERC20Extended is ERC20 {
287   function approveAndCall(
288     IERC20Receiver _spender,
289     uint256 _value,
290     bytes calldata _data
291   )
292     external
293     returns (bool _success)
294   {
295     require(approve(address(_spender), _value));
296     _spender.receiveApproval(msg.sender, _value, address(this), _data);
297     return true;
298   }
299 }
300 
301 // File: contracts/token/erc20/ERC20Full.sol
302 
303 contract LUNA is ERC20Detailed, ERC20Extended, ERC20Capped {
304   constructor(
305     string memory _name,
306     string memory _symbol,
307     uint8 _decimals,
308     uint256 _cappedSupply
309   )
310     public
311     ERC20Detailed(_name, _symbol, _decimals)
312     ERC20Capped(_cappedSupply.mul(uint256(10)**_decimals))
313   {
314   }
315 }