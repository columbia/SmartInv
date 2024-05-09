1 // File: contracts/lib/CloneFactory.sol
2 
3 /*
4 
5     Copyright 2020 DODO ZOO.
6     SPDX-License-Identifier: Apache-2.0
7 
8 */
9 
10 pragma solidity 0.6.9;
11 pragma experimental ABIEncoderV2;
12 
13 interface ICloneFactory {
14     function clone(address prototype) external returns (address proxy);
15 }
16 
17 // introduction of proxy mode design: https://docs.openzeppelin.com/upgrades/2.8/
18 // minimum implementation of transparent proxy: https://eips.ethereum.org/EIPS/eip-1167
19 
20 contract CloneFactory is ICloneFactory {
21     function clone(address prototype) external override returns (address proxy) {
22         bytes20 targetBytes = bytes20(prototype);
23         assembly {
24             let clone := mload(0x40)
25             mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
26             mstore(add(clone, 0x14), targetBytes)
27             mstore(
28                 add(clone, 0x28),
29                 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000
30             )
31             proxy := create(0, clone, 0x37)
32         }
33         return proxy;
34     }
35 }
36 
37 // File: contracts/lib/SafeMath.sol
38 
39 
40 
41 /**
42  * @title SafeMath
43  * @author DODO Breeder
44  *
45  * @notice Math operations with safety checks that revert on error
46  */
47 library SafeMath {
48     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
49         if (a == 0) {
50             return 0;
51         }
52 
53         uint256 c = a * b;
54         require(c / a == b, "MUL_ERROR");
55 
56         return c;
57     }
58 
59     function div(uint256 a, uint256 b) internal pure returns (uint256) {
60         require(b > 0, "DIVIDING_ERROR");
61         return a / b;
62     }
63 
64     function divCeil(uint256 a, uint256 b) internal pure returns (uint256) {
65         uint256 quotient = div(a, b);
66         uint256 remainder = a - quotient * b;
67         if (remainder > 0) {
68             return quotient + 1;
69         } else {
70             return quotient;
71         }
72     }
73 
74     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75         require(b <= a, "SUB_ERROR");
76         return a - b;
77     }
78 
79     function add(uint256 a, uint256 b) internal pure returns (uint256) {
80         uint256 c = a + b;
81         require(c >= a, "ADD_ERROR");
82         return c;
83     }
84 
85     function sqrt(uint256 x) internal pure returns (uint256 y) {
86         uint256 z = x / 2 + 1;
87         y = x;
88         while (z < y) {
89             y = z;
90             z = (x / z + z) / 2;
91         }
92     }
93 }
94 
95 // File: contracts/external/ERC20/InitializableERC20.sol
96 
97 
98 
99 contract InitializableERC20 {
100     using SafeMath for uint256;
101 
102     string public name;
103     uint256 public decimals;
104     string public symbol;
105     uint256 public totalSupply;
106 
107     bool public initialized;
108 
109     mapping(address => uint256) balances;
110     mapping(address => mapping(address => uint256)) internal allowed;
111 
112     event Transfer(address indexed from, address indexed to, uint256 amount);
113     event Approval(address indexed owner, address indexed spender, uint256 amount);
114 
115     function init(
116         address _creator,
117         uint256 _totalSupply,
118         string memory _name,
119         string memory _symbol,
120         uint256 _decimals
121     ) public {
122         require(!initialized, "TOKEN_INITIALIZED");
123         initialized = true;
124         totalSupply = _totalSupply;
125         balances[_creator] = _totalSupply;
126         name = _name;
127         symbol = _symbol;
128         decimals = _decimals;
129         emit Transfer(address(0), _creator, _totalSupply);
130     }
131 
132     function transfer(address to, uint256 amount) public returns (bool) {
133         require(to != address(0), "TO_ADDRESS_IS_EMPTY");
134         require(amount <= balances[msg.sender], "BALANCE_NOT_ENOUGH");
135 
136         balances[msg.sender] = balances[msg.sender].sub(amount);
137         balances[to] = balances[to].add(amount);
138         emit Transfer(msg.sender, to, amount);
139         return true;
140     }
141 
142     function balanceOf(address owner) public view returns (uint256 balance) {
143         return balances[owner];
144     }
145 
146     function transferFrom(
147         address from,
148         address to,
149         uint256 amount
150     ) public returns (bool) {
151         require(to != address(0), "TO_ADDRESS_IS_EMPTY");
152         require(amount <= balances[from], "BALANCE_NOT_ENOUGH");
153         require(amount <= allowed[from][msg.sender], "ALLOWANCE_NOT_ENOUGH");
154 
155         balances[from] = balances[from].sub(amount);
156         balances[to] = balances[to].add(amount);
157         allowed[from][msg.sender] = allowed[from][msg.sender].sub(amount);
158         emit Transfer(from, to, amount);
159         return true;
160     }
161 
162     function approve(address spender, uint256 amount) public returns (bool) {
163         allowed[msg.sender][spender] = amount;
164         emit Approval(msg.sender, spender, amount);
165         return true;
166     }
167 
168     function allowance(address owner, address spender) public view returns (uint256) {
169         return allowed[owner][spender];
170     }
171 }
172 
173 // File: contracts/lib/InitializableOwnable.sol
174 
175 /**
176  * @title Ownable
177  * @author DODO Breeder
178  *
179  * @notice Ownership related functions
180  */
181 contract InitializableOwnable {
182     address public _OWNER_;
183     address public _NEW_OWNER_;
184     bool internal _INITIALIZED_;
185 
186     // ============ Events ============
187 
188     event OwnershipTransferPrepared(address indexed previousOwner, address indexed newOwner);
189 
190     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
191 
192     // ============ Modifiers ============
193 
194     modifier notInitialized() {
195         require(!_INITIALIZED_, "DODO_INITIALIZED");
196         _;
197     }
198 
199     modifier onlyOwner() {
200         require(msg.sender == _OWNER_, "NOT_OWNER");
201         _;
202     }
203 
204     // ============ Functions ============
205 
206     function initOwner(address newOwner) public notInitialized {
207         _INITIALIZED_ = true;
208         _OWNER_ = newOwner;
209     }
210 
211     function transferOwnership(address newOwner) public onlyOwner {
212         emit OwnershipTransferPrepared(_OWNER_, newOwner);
213         _NEW_OWNER_ = newOwner;
214     }
215 
216     function claimOwnership() public {
217         require(msg.sender == _NEW_OWNER_, "INVALID_CLAIM");
218         emit OwnershipTransferred(_OWNER_, _NEW_OWNER_);
219         _OWNER_ = _NEW_OWNER_;
220         _NEW_OWNER_ = address(0);
221     }
222 }
223 
224 // File: contracts/external/ERC20/InitializableMintableERC20.sol
225 
226 
227 
228 
229 contract InitializableMintableERC20 is InitializableOwnable {
230     using SafeMath for uint256;
231 
232     string public name;
233     uint256 public decimals;
234     string public symbol;
235     uint256 public totalSupply;
236 
237     mapping(address => uint256) balances;
238     mapping(address => mapping(address => uint256)) internal allowed;
239 
240     event Transfer(address indexed from, address indexed to, uint256 amount);
241     event Approval(address indexed owner, address indexed spender, uint256 amount);
242     event Mint(address indexed user, uint256 value);
243     event Burn(address indexed user, uint256 value);
244 
245     function init(
246         address _creator,
247         uint256 _initSupply,
248         string memory _name,
249         string memory _symbol,
250         uint256 _decimals
251     ) public {
252         initOwner(_creator);
253         name = _name;
254         symbol = _symbol;
255         decimals = _decimals;
256         totalSupply = _initSupply;
257         balances[_creator] = _initSupply;
258         emit Transfer(address(0), _creator, _initSupply);
259     }
260 
261     function transfer(address to, uint256 amount) public returns (bool) {
262         require(to != address(0), "TO_ADDRESS_IS_EMPTY");
263         require(amount <= balances[msg.sender], "BALANCE_NOT_ENOUGH");
264 
265         balances[msg.sender] = balances[msg.sender].sub(amount);
266         balances[to] = balances[to].add(amount);
267         emit Transfer(msg.sender, to, amount);
268         return true;
269     }
270 
271     function balanceOf(address owner) public view returns (uint256 balance) {
272         return balances[owner];
273     }
274 
275     function transferFrom(
276         address from,
277         address to,
278         uint256 amount
279     ) public returns (bool) {
280         require(to != address(0), "TO_ADDRESS_IS_EMPTY");
281         require(amount <= balances[from], "BALANCE_NOT_ENOUGH");
282         require(amount <= allowed[from][msg.sender], "ALLOWANCE_NOT_ENOUGH");
283 
284         balances[from] = balances[from].sub(amount);
285         balances[to] = balances[to].add(amount);
286         allowed[from][msg.sender] = allowed[from][msg.sender].sub(amount);
287         emit Transfer(from, to, amount);
288         return true;
289     }
290 
291     function approve(address spender, uint256 amount) public returns (bool) {
292         allowed[msg.sender][spender] = amount;
293         emit Approval(msg.sender, spender, amount);
294         return true;
295     }
296 
297     function allowance(address owner, address spender) public view returns (uint256) {
298         return allowed[owner][spender];
299     }
300 
301     function mint(address user, uint256 value) external onlyOwner {
302         balances[user] = balances[user].add(value);
303         totalSupply = totalSupply.add(value);
304         emit Mint(user, value);
305         emit Transfer(address(0), user, value);
306     }
307 
308     function burn(address user, uint256 value) external onlyOwner {
309         balances[user] = balances[user].sub(value);
310         totalSupply = totalSupply.sub(value);
311         emit Burn(user, value);
312         emit Transfer(user, address(0), value);
313     }
314 }
315 
316 // File: contracts/Factory/ERC20Factory.sol
317 
318 
319 
320 
321 
322 /**
323  * @title DODO ERC20Factory
324  * @author DODO Breeder
325  *
326  * @notice Help user to create erc20 token
327  */
328 contract ERC20Factory {
329     // ============ Templates ============
330 
331     address public immutable _CLONE_FACTORY_;
332     address public immutable _ERC20_TEMPLATE_;
333     address public immutable _MINTABLE_ERC20_TEMPLATE_;
334 
335     // ============ Events ============
336 
337     event NewERC20(address erc20, address creator, bool isMintable);
338 
339     // ============ Functions ============
340 
341     constructor(
342         address cloneFactory,
343         address erc20Template,
344         address mintableErc20Template
345     ) public {
346         _CLONE_FACTORY_ = cloneFactory;
347         _ERC20_TEMPLATE_ = erc20Template;
348         _MINTABLE_ERC20_TEMPLATE_ = mintableErc20Template;
349     }
350 
351     function createStdERC20(
352         uint256 totalSupply,
353         string memory name,
354         string memory symbol,
355         uint256 decimals
356     ) external returns (address newERC20) {
357         newERC20 = ICloneFactory(_CLONE_FACTORY_).clone(_ERC20_TEMPLATE_);
358         InitializableERC20(newERC20).init(msg.sender, totalSupply, name, symbol, decimals);
359         emit NewERC20(newERC20, msg.sender, false);
360     }
361 
362     function createMintableERC20(
363         uint256 initSupply,
364         string memory name,
365         string memory symbol,
366         uint256 decimals
367     ) external returns (address newMintableERC20) {
368         newMintableERC20 = ICloneFactory(_CLONE_FACTORY_).clone(_MINTABLE_ERC20_TEMPLATE_);
369         InitializableMintableERC20(newMintableERC20).init(
370             msg.sender,
371             initSupply,
372             name,
373             symbol,
374             decimals
375         );
376         emit NewERC20(newMintableERC20, msg.sender, true);
377     }
378 }