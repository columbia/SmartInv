1 /**
2  *Submitted for verification at BscScan.com on 2022-11-10
3 */
4 
5 // SPDX-License-Identifier: GPL-3.0-or-later
6 
7 pragma solidity ^0.8.10;
8 
9 // helper methods for interacting with ERC20 tokens and sending NATIVE that do not consistently return true/false
10 library TransferHelper {
11     function safeTransferNative(address to, uint value) internal {
12         (bool success,) = to.call{value:value}(new bytes(0));
13         require(success, 'TransferHelper: NATIVE_TRANSFER_FAILED');
14     }
15 }
16 
17 interface IwNATIVE {
18     function deposit() external payable;
19     function transfer(address to, uint value) external returns (bool);
20     function withdraw(uint) external;
21 }
22 
23 interface AnyswapV1ERC20 {
24     function mint(address to, uint256 amount) external returns (bool);
25     function burn(address from, uint256 amount) external returns (bool);
26     function setMinter(address _auth) external;
27     function applyMinter() external;
28     function revokeMinter(address _auth) external;
29     function changeVault(address newVault) external returns (bool);
30     function depositVault(uint amount, address to) external returns (uint);
31     function withdrawVault(address from, uint amount, address to) external returns (uint);
32     function underlying() external view returns (address);
33     function deposit(uint amount, address to) external returns (uint);
34     function withdraw(uint amount, address to) external returns (uint);
35 }
36 
37 /**
38  * @dev Interface of the ERC20 standard as defined in the EIP.
39  */
40 interface IERC20 {
41     function totalSupply() external view returns (uint256);
42     function balanceOf(address account) external view returns (uint256);
43     function transfer(address recipient, uint256 amount) external returns (bool);
44     function allowance(address owner, address spender) external view returns (uint256);
45     function approve(address spender, uint256 amount) external returns (bool);
46     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
47 
48     event Transfer(address indexed from, address indexed to, uint256 value);
49     event Approval(address indexed owner, address indexed spender, uint256 value);
50 }
51 
52 library Address {
53     function isContract(address account) internal view returns (bool) {
54         return account.code.length > 0;
55     }
56 }
57 
58 library SafeERC20 {
59     using Address for address;
60 
61     function safeTransfer(IERC20 token, address to, uint value) internal {
62         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
63     }
64 
65     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
66         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
67     }
68 
69     function safeApprove(IERC20 token, address spender, uint value) internal {
70         require((value == 0) || (token.allowance(address(this), spender) == 0),
71             "SafeERC20: approve from non-zero to non-zero allowance"
72         );
73         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
74     }
75 
76     function callOptionalReturn(IERC20 token, bytes memory data) private {
77         require(address(token).isContract(), "SafeERC20: call to non-contract");
78 
79         // solhint-disable-next-line avoid-low-level-calls
80         (bool success, bytes memory returndata) = address(token).call(data);
81         require(success, "SafeERC20: low-level call failed");
82 
83         if (returndata.length > 0) { // Return data is optional
84             // solhint-disable-next-line max-line-length
85             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
86         }
87     }
88 }
89 
90 contract AnyswapV6Router {
91     using SafeERC20 for IERC20;
92 
93     address public constant factory = address(0);
94     address public immutable wNATIVE;
95 
96     // delay for timelock functions
97     uint public constant DELAY = 2 days;
98 
99     constructor(address _wNATIVE, address _mpc) {
100         _newMPC = _mpc;
101         _newMPCEffectiveTime = block.timestamp;
102         wNATIVE = _wNATIVE;
103     }
104 
105     receive() external payable {
106         assert(msg.sender == wNATIVE); // only accept Native via fallback from the wNative contract
107     }
108 
109     address private _oldMPC;
110     address private _newMPC;
111     uint256 private _newMPCEffectiveTime;
112 
113     event LogChangeMPC(address indexed oldMPC, address indexed newMPC, uint indexed effectiveTime, uint chainID);
114     event LogAnySwapIn(bytes32 indexed txhash, address indexed token, address indexed to, uint amount, uint fromChainID, uint toChainID);
115     event LogAnySwapOut(address indexed token, address indexed from, address indexed to, uint amount, uint fromChainID, uint toChainID);
116     event LogAnySwapOut(address indexed token, address indexed from, string to, uint amount, uint fromChainID, uint toChainID);
117 
118     modifier onlyMPC() {
119         require(msg.sender == mpc(), "AnyswapV6Router: FORBIDDEN");
120         _;
121     }
122 
123     function mpc() public view returns (address) {
124         if (block.timestamp >= _newMPCEffectiveTime) {
125             return _newMPC;
126         }
127         return _oldMPC;
128     }
129 
130     function cID() public view returns (uint) {
131         return block.chainid;
132     }
133 
134     function changeMPC(address newMPC) external onlyMPC returns (bool) {
135         require(newMPC != address(0), "AnyswapV6Router: address(0)");
136         _oldMPC = mpc();
137         _newMPC = newMPC;
138         _newMPCEffectiveTime = block.timestamp + DELAY;
139         emit LogChangeMPC(_oldMPC, _newMPC, _newMPCEffectiveTime, cID());
140         return true;
141     }
142 
143     function changeVault(address token, address newVault) external onlyMPC returns (bool) {
144         return AnyswapV1ERC20(token).changeVault(newVault);
145     }
146 
147     function setMinter(address token, address _auth) external onlyMPC {
148         return AnyswapV1ERC20(token).setMinter(_auth);
149     }
150 
151     function applyMinter(address token) external onlyMPC {
152         return AnyswapV1ERC20(token).applyMinter();
153     }
154 
155     function revokeMinter(address token, address _auth) external onlyMPC {
156         return AnyswapV1ERC20(token).revokeMinter(_auth);
157     }
158 
159     function _anySwapOut(address from, address token, address to, uint amount, uint toChainID) internal {
160         AnyswapV1ERC20(token).burn(from, amount);
161         emit LogAnySwapOut(token, from, to, amount, cID(), toChainID);
162     }
163 
164     // Swaps `amount` `token` from this chain to `toChainID` chain with recipient `to`
165     function anySwapOut(address token, address to, uint amount, uint toChainID) external {
166         _anySwapOut(msg.sender, token, to, amount, toChainID);
167     }
168 
169     // Swaps `amount` `token` from this chain to `toChainID` chain with recipient `to` by minting with `underlying`
170     function anySwapOutUnderlying(address token, address to, uint amount, uint toChainID) external {
171         address _underlying = AnyswapV1ERC20(token).underlying();
172         require(_underlying != address(0), "AnyswapV6Router: no underlying");
173         IERC20(_underlying).safeTransferFrom(msg.sender, token, amount);
174         emit LogAnySwapOut(token, msg.sender, to, amount, cID(), toChainID);
175     }
176 
177     function anySwapOutNative(address token, address to, uint toChainID) external payable {
178         require(wNATIVE != address(0), "AnyswapV6Router: zero wNATIVE");
179         require(AnyswapV1ERC20(token).underlying() == wNATIVE, "AnyswapV6Router: underlying is not wNATIVE");
180         IwNATIVE(wNATIVE).deposit{value: msg.value}();
181         assert(IwNATIVE(wNATIVE).transfer(token, msg.value));
182         emit LogAnySwapOut(token, msg.sender, to, msg.value, cID(), toChainID);
183     }
184 
185     function anySwapOut(address[] calldata tokens, address[] calldata to, uint[] calldata amounts, uint[] calldata toChainIDs) external {
186         for (uint i = 0; i < tokens.length; i++) {
187             _anySwapOut(msg.sender, tokens[i], to[i], amounts[i], toChainIDs[i]);
188         }
189     }
190 
191     function anySwapOut(address token, string memory to, uint amount, uint toChainID) external {
192         AnyswapV1ERC20(token).burn(msg.sender, amount);
193         emit LogAnySwapOut(token, msg.sender, to, amount, cID(), toChainID);
194     }
195 
196     function anySwapOutUnderlying(address token, string memory to, uint amount, uint toChainID) external {
197         address _underlying = AnyswapV1ERC20(token).underlying();
198         require(_underlying != address(0), "AnyswapV6Router: no underlying");
199         IERC20(_underlying).safeTransferFrom(msg.sender, token, amount);
200         emit LogAnySwapOut(token, msg.sender, to, amount, cID(), toChainID);
201     }
202 
203     function anySwapOutNative(address token, string memory to, uint toChainID) external payable {
204         require(wNATIVE != address(0), "AnyswapV6Router: zero wNATIVE");
205         require(AnyswapV1ERC20(token).underlying() == wNATIVE, "AnyswapV6Router: underlying is not wNATIVE");
206         IwNATIVE(wNATIVE).deposit{value: msg.value}();
207         assert(IwNATIVE(wNATIVE).transfer(token, msg.value));
208         emit LogAnySwapOut(token, msg.sender, to, msg.value, cID(), toChainID);
209     }
210 
211     // swaps `amount` `token` in `fromChainID` to `to` on this chainID
212     function _anySwapIn(bytes32 txs, address token, address to, uint amount, uint fromChainID) internal {
213         AnyswapV1ERC20(token).mint(to, amount);
214         emit LogAnySwapIn(txs, token, to, amount, fromChainID, cID());
215     }
216 
217     // swaps `amount` `token` in `fromChainID` to `to` on this chainID
218     // triggered by `anySwapOut`
219     function anySwapIn(bytes32 txs, address token, address to, uint amount, uint fromChainID) external onlyMPC {
220         _anySwapIn(txs, token, to, amount, fromChainID);
221     }
222 
223     // swaps `amount` `token` in `fromChainID` to `to` on this chainID with `to` receiving `underlying`
224     function anySwapInUnderlying(bytes32 txs, address token, address to, uint amount, uint fromChainID) external onlyMPC {
225         _anySwapIn(txs, token, to, amount, fromChainID);
226         AnyswapV1ERC20(token).withdrawVault(to, amount, to);
227     }
228 
229     // swaps `amount` `token` in `fromChainID` to `to` on this chainID with `to` receiving `underlying` if possible
230     function anySwapInAuto(bytes32 txs, address token, address to, uint amount, uint fromChainID) external onlyMPC {
231         _anySwapIn(txs, token, to, amount, fromChainID);
232         AnyswapV1ERC20 _anyToken = AnyswapV1ERC20(token);
233         address _underlying = _anyToken.underlying();
234         if (_underlying != address(0) && IERC20(_underlying).balanceOf(token) >= amount) {
235             if (_underlying == wNATIVE) {
236                 _anyToken.withdrawVault(to, amount, address(this));
237                 IwNATIVE(wNATIVE).withdraw(amount);
238                 TransferHelper.safeTransferNative(to, amount);
239             } else {
240                 _anyToken.withdrawVault(to, amount, to);
241             }
242         }
243     }
244 
245     function depositNative(address token, address to) external payable returns (uint) {
246         require(wNATIVE != address(0), "AnyswapV6Router: zero wNATIVE");
247         require(AnyswapV1ERC20(token).underlying() == wNATIVE, "AnyswapV6Router: underlying is not wNATIVE");
248         IwNATIVE(wNATIVE).deposit{value: msg.value}();
249         assert(IwNATIVE(wNATIVE).transfer(token, msg.value));
250         AnyswapV1ERC20(token).depositVault(msg.value, to);
251         return msg.value;
252     }
253 
254     function withdrawNative(address token, uint amount, address to) external returns (uint) {
255         require(wNATIVE != address(0), "AnyswapV6Router: zero wNATIVE");
256         require(AnyswapV1ERC20(token).underlying() == wNATIVE, "AnyswapV6Router: underlying is not wNATIVE");
257 
258         uint256 old_balance = IERC20(wNATIVE).balanceOf(address(this));
259         AnyswapV1ERC20(token).withdrawVault(msg.sender, amount, address(this));
260         uint256 new_balance = IERC20(wNATIVE).balanceOf(address(this));
261         assert(new_balance == old_balance + amount);
262 
263         IwNATIVE(wNATIVE).withdraw(amount);
264         TransferHelper.safeTransferNative(to, amount);
265         return amount;
266     }
267 
268     // extracts mpc fee from bridge fees
269     function anySwapFeeTo(address token, uint amount) external onlyMPC {
270         address _mpc = mpc();
271         AnyswapV1ERC20(token).mint(_mpc, amount);
272         AnyswapV1ERC20(token).withdrawVault(_mpc, amount, _mpc);
273     }
274 
275     function anySwapIn(bytes32[] calldata txs, address[] calldata tokens, address[] calldata to, uint256[] calldata amounts, uint[] calldata fromChainIDs) external onlyMPC {
276         for (uint i = 0; i < tokens.length; i++) {
277             _anySwapIn(txs[i], tokens[i], to[i], amounts[i], fromChainIDs[i]);
278         }
279     }
280 }