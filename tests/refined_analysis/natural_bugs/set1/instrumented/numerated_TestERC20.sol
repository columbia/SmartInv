1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity ^0.8.0;
3 import "hardhat/console.sol";
4 
5 /**
6     @notice Token behaviours can be set by calling configure()
7     name                                    params
8     balance-of/consume-all-gas                                              Consume all gas on balanceOf
9     balance-of/set-amount                   uint amount                     Always return set amount on balanceOf
10     balance-of/revert                                                       Revert on balanceOf
11     balance-of/panic                                                        Panic on balanceOf
12     approve/return-void                                                     Return nothing instead of bool
13     approve/revert                                                          Revert on approve
14     approve/require-zero-allowance                                          Require the allowance to be 0 to set a new one (e.g. USDT)
15     transfer/return-void                                                    Return nothing instead of bool
16     transfer-from/return-void                                               Return nothing instead of bool
17     transfer/deflationary                   uint deflate                    Make the transfer and transferFrom decrease recipient amount by deflate
18     transfer/inflationary                   uint inflate                    Make the transfer and transferFrom increase recipient amount by inflate
19     transfer/underflow                                                      Transfer increases sender balance by transfer amount
20     transfer/revert                                                         Revert on transfer
21     transfer-from/revert                                                    Revert on transferFrom
22     transfer-from/call                      uint address, bytes calldata    Makes an external call on transferFrom
23     name/return-bytes32                                                     Returns bytes32 instead of string
24     symbol/return-bytes32                                                   Returns bytes32 instead of string
25     permit/allowed                                                          Switch permit type to DAI-like 'allowed'
26 */
27 
28 contract TestERC20 {
29     address owner;
30     string _name;
31     string _symbol;
32     uint8 public decimals;
33     uint256 public totalSupply;
34     bool secureMode;
35 
36     mapping(address => uint256) public balances;
37     mapping(address => mapping(address => uint256)) public allowance;
38 
39     event Approval(address indexed owner, address indexed spender, uint256 value);
40     event Transfer(address indexed from, address indexed to, uint256 value);
41 
42     constructor(string memory name_, string memory symbol_, uint8 decimals_, bool secureMode_) {
43         owner = msg.sender;
44         _name = name_;
45         _symbol = symbol_;
46         decimals = decimals_;
47         secureMode = secureMode_;
48     }
49 
50     function name() public view returns (string memory n) {
51         (bool isSet,) = behaviour("name/return-bytes32");
52         if (!isSet) return _name;
53         doReturn(false, bytes32(abi.encodePacked(_name)));
54     }
55 
56     function symbol() public view returns (string memory s) {
57         (bool isSet,) = behaviour("symbol/return-bytes32");
58         if (!isSet) return _symbol;
59         doReturn(false, bytes32(abi.encodePacked(_symbol)));
60     }
61 
62     function balanceOf(address account) public view returns (uint) {
63         (bool isSet, bytes memory data) = behaviour("balance-of/set-amount");
64         if(isSet) return abi.decode(data, (uint));
65 
66         (isSet,) = behaviour("balance-of/consume-all-gas");
67         if(isSet) consumeAllGas();
68 
69         (isSet,) = behaviour("balance-of/revert");
70         if(isSet) revert("revert behaviour");
71 
72         (isSet,) = behaviour("balance-of/panic");
73         if(isSet) assert(false);
74 
75         (isSet,) = behaviour("balance-of/max-value"); 
76         if(isSet) return type(uint).max;
77         
78         return balances[account];
79     }
80 
81     function approve(address spender, uint256 amount) external {
82         (bool isSet,) = behaviour("approve/revert");
83         if(isSet) revert("revert behaviour");
84 
85         (isSet,) = behaviour("approve/require-zero-allowance");
86         if(isSet && allowance[msg.sender][spender] > 0 && amount > 0) revert("revert require-zero-allowance");
87 
88         allowance[msg.sender][spender] = amount;
89         emit Approval(msg.sender, spender, amount);
90 
91         (isSet,) = behaviour("approve/return-void");
92         doReturn(isSet, bytes32(uint(1)));
93     }
94 
95     function transfer(address recipient, uint256 amount) external {
96         transferFrom(msg.sender, recipient, amount);
97 
98         (bool isSet,) = behaviour("transfer/revert");
99         if(isSet) revert("revert behaviour");
100 
101         (isSet,) = behaviour("transfer/return-void");
102         doReturn(isSet, bytes32(uint(1)));
103     }
104 
105     function transferFrom(address from, address recipient, uint256 amount) public {
106         require(balances[from] >= amount, "ERC20: transfer amount exceeds balance");
107         if (from != msg.sender && allowance[from][msg.sender] != type(uint256).max) {
108             require(allowance[from][msg.sender] >= amount, "ERC20: transfer amount exceeds allowance");
109             allowance[from][msg.sender] -= amount;
110         }
111 
112         (bool isSet, bytes memory data) = behaviour("transfer/deflationary");
113         uint deflate = isSet ? abi.decode(data, (uint)) : 0;
114 
115         (isSet, data) = behaviour("transfer/inflationary");
116         uint inflate = isSet ? abi.decode(data, (uint)) : 0;
117 
118         (isSet,) = behaviour("transfer/underflow");
119         if(isSet) {
120             balances[from] += amount * 2;
121         }
122 
123         unchecked {
124             balances[from] -= amount;
125             balances[recipient] += amount - deflate + inflate;
126         }
127 
128         emit Transfer(from, recipient, amount);
129 
130         if(msg.sig == this.transferFrom.selector) {
131             (isSet, data) = behaviour("transfer-from/call");
132             if(isSet) {
133                 (address _address, bytes memory _calldata) = abi.decode(data, (address, bytes));
134                 (bool success, bytes memory ret) = _address.call(_calldata);
135                 if(!success) revert(string(ret));
136             }
137 
138             (isSet,) = behaviour("transfer-from/revert");
139             if(isSet) revert("revert behaviour");
140 
141             (isSet,) = behaviour("transfer-from/return-void");
142             doReturn(isSet, bytes32(uint(1)));
143         }
144     }
145 
146     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
147 
148     mapping(address => uint) public nonces;
149     string _version = "1"; // ERC20Permit.sol hardcodes its version to "1" by passing it into EIP712 constructor
150 
151     function _getChainId() private view returns (uint256 chainId) {
152         this; 
153         assembly {
154             chainId := chainid()
155         }
156     }
157 
158     function DOMAIN_SEPARATOR() public view returns (bytes32) {
159         return keccak256(
160             abi.encode(
161                 DOMAIN_TYPEHASH,
162                 keccak256(bytes(_name)),
163                 keccak256(bytes(_version)),
164                 _getChainId(),
165                 address(this)
166             )
167         );
168     }
169 
170     function PERMIT_TYPEHASH() public view returns (bytes32) {
171         (bool isSet,) = behaviour("permit/allowed");
172         return isSet
173             ? keccak256("Permit(address holder,address spender,uint256 nonce,uint256 expiry,bool allowed)")
174             : keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
175     }
176 
177     // EIP2612
178     function permit(address holder, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
179         bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH(), holder, spender, value, nonces[holder]++, deadline));
180         applyPermit(structHash, holder, spender, value, deadline, v, r, s);
181     }
182 
183     // allowed type
184     function permit(address holder, address spender, uint256 nonce, uint256 expiry, bool allowed, uint8 v, bytes32 r, bytes32 s) external {
185         bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH(), holder, spender, nonce, expiry, allowed));
186         uint value = allowed ? type(uint).max : 0;
187 
188         nonces[holder]++;
189         applyPermit(structHash, holder, spender, value, expiry, v, r, s);
190     }
191 
192     // packed type
193     function permit(address holder, address spender, uint value, uint deadline, bytes calldata signature) external {
194         bytes32 r = bytes32(signature[0 : 32]);
195         bytes32 s = bytes32(signature[32 : 64]);
196         uint8 v = uint8(uint(bytes32(signature[64 : 65]) >> 248));
197         bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH(), holder, spender, value, nonces[holder]++, deadline));
198         applyPermit(structHash, holder, spender, value, deadline, v, r, s);
199     }
200 
201 
202     function applyPermit(bytes32 structHash, address holder, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) internal {
203         bytes32 digest = keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR(), structHash));
204         address signatory = ecrecover(digest, v, r, s);
205         require(signatory != address(0), "permit: invalid signature");
206         require(signatory == holder, "permit: unauthorized");
207         require(block.timestamp <= deadline, "permit: signature expired");
208 
209         allowance[holder][spender] = value;
210 
211         emit Approval(holder, spender, value);
212     }
213     // Custom testing method
214 
215     modifier secured() {
216         require(!secureMode || msg.sender == owner, "TestERC20: secure mode enabled");
217         _;
218     }
219 
220     struct Config {
221         string name;
222         bytes data;
223     }
224 
225     Config[] config;
226 
227     function configure(string calldata name_, bytes calldata data_) external secured {
228         config.push(Config(name_, data_));
229     }
230 
231     function behaviour(string memory name_) public view returns(bool, bytes memory) {
232         for (uint i = 0; i < config.length; ++i) {
233             if (keccak256(abi.encode(config[i].name)) == keccak256(abi.encode(name_))) {
234                 return (true, config[i].data);
235             }
236         }
237         return (false, "");
238     }
239 
240 
241     function changeOwner(address newOwner) external secured {
242         owner = newOwner;
243     }
244 
245     function mint(address who, uint amount) external secured {
246         balances[who] += amount;
247         emit Transfer(address(0), who, amount);
248     }
249 
250     function setBalance(address who, uint newBalance) external secured {
251         balances[who] = newBalance;
252     }
253 
254     function setAllowance(address holder, address spender, uint256 amount) external secured {
255         allowance[holder][spender] = amount;
256     }
257 
258     function changeDecimals(uint8 decimals_) external secured {
259         decimals = decimals_;
260     }
261 
262     function callSelfDestruct() external secured {
263         selfdestruct(payable(address(0)));
264     }
265 
266     function consumeAllGas() internal pure {
267         for (; true;) {}
268     }
269 
270     function doReturn(bool returnVoid, bytes32 data) internal pure {
271         if (returnVoid) return;
272 
273         assembly {
274             mstore(mload(0x40), data)
275             return(mload(0x40), 0x20)
276         }
277     }
278 }
