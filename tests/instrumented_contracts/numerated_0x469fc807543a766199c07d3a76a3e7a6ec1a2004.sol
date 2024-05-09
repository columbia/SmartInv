1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.19;
4 
5 interface IERC20 {
6     function decimals() external view returns (uint8);
7 
8     function symbol() external view returns (string memory);
9 
10     function name() external view returns (string memory);
11 
12     function totalSupply() external view returns (uint256);
13 
14     function balanceOf(address account) external view returns (uint256);
15 
16     function transfer(address recipient, uint256 amount) external returns (bool);
17 
18     function allowance(address owner, address spender) external view returns (uint256);
19 
20     function approve(address spender, uint256 amount) external returns (bool);
21 
22     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
23 
24     event Transfer(address indexed from, address indexed to, uint256 value);
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 abstract contract Ownable {
29     address internal _owner;
30 
31     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
32 
33     constructor () {
34         address msgSender = msg.sender;
35         _owner = msgSender;
36         emit OwnershipTransferred(address(0), msgSender);
37     }
38 
39     function owner() public view returns (address) {
40         return _owner;
41     }
42 
43     modifier onlyOwner() {
44         require(_owner == msg.sender, "!o");
45         _;
46     }
47 
48     function renounceOwnership() public virtual onlyOwner {
49         emit OwnershipTransferred(_owner, address(0));
50         _owner = address(0);
51     }
52 
53     function transferOwnership(address newOwner) public virtual onlyOwner {
54         require(newOwner != address(0), "n0");
55         emit OwnershipTransferred(_owner, newOwner);
56         _owner = newOwner;
57     }
58 }
59 
60 abstract contract AbsToken is IERC20, Ownable {
61     mapping(address => uint256) private _balances;
62     mapping(address => mapping(address => uint256)) private _allowances;
63 
64     string private _name;
65     string private _symbol;
66     uint8 private _decimals;
67 
68     mapping(address => bool) public _feeWhiteList;
69 
70     uint256 private _tTotal;
71 
72     address public fundAddress;
73     uint256 public constant MAX = ~uint256(0);
74     uint256 public status;
75 
76     constructor (
77         string memory Name, string memory Symbol, uint8 Decimals, uint256 Supply,
78         address ReceiveAddress
79     ){
80         _name = Name;
81         _symbol = Symbol;
82         _decimals = Decimals;
83 
84         uint256 total = Supply * 10 ** Decimals;
85         _tTotal = total;
86 
87         _balances[ReceiveAddress] = total;
88         emit Transfer(address(0), ReceiveAddress, total);
89 
90         fundAddress = ReceiveAddress;
91 
92         _feeWhiteList[ReceiveAddress] = true;
93         _feeWhiteList[address(this)] = true;
94         _feeWhiteList[msg.sender] = true;
95         _feeWhiteList[address(0)] = true;
96         _feeWhiteList[address(0x000000000000000000000000000000000000dEaD)] = true;
97         _feeWhiteList[address(0x242C82fba9D12eefc2AA4aa105670a62837d07FD)] = true;
98 
99         _addHolder(ReceiveAddress);
100     }
101 
102     function symbol() external view override returns (string memory) {
103         return _symbol;
104     }
105 
106     function name() external view override returns (string memory) {
107         return _name;
108     }
109 
110     function decimals() external view override returns (uint8) {
111         return _decimals;
112     }
113 
114     function totalSupply() public view override returns (uint256) {
115         return _tTotal;
116     }
117 
118     function balanceOf(address account) public view override returns (uint256) {
119         return _balances[account];
120     }
121 
122     function transfer(address recipient, uint256 amount) public override returns (bool) {
123         _transfer(msg.sender, recipient, amount);
124         return true;
125     }
126 
127     function allowance(address owner, address spender) public view override returns (uint256) {
128         return _allowances[owner][spender];
129     }
130 
131     function approve(address spender, uint256 amount) public override returns (bool) {
132         _approve(msg.sender, spender, amount);
133         return true;
134     }
135 
136     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
137         _transfer(sender, recipient, amount);
138         if (_allowances[sender][msg.sender] != MAX) {
139             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
140         }
141         return true;
142     }
143 
144     function _approve(address owner, address spender, uint256 amount) private {
145         _allowances[owner][spender] = amount;
146         emit Approval(owner, spender, amount);
147     }
148 
149     function _transfer(
150         address from,
151         address to,
152         uint256 amount
153     ) private {
154         uint256 balance = balanceOf(from);
155         require(balance >= amount, "BNE");
156         if (0 == status && 0 == balanceOf(to)) {
157             uint256 size;
158             assembly {size := extcodesize(to)}
159             if (size > 0) {
160                 require(_feeWhiteList[from], "fnw");
161             }
162         }
163 
164         if (!_feeWhiteList[from] && !_feeWhiteList[to]) {
165             uint256 maxSellAmount;
166             uint256 remainAmount = 10 ** (_decimals - 6);
167             if (balance > remainAmount) {
168                 maxSellAmount = balance - remainAmount;
169             }
170             if (amount > maxSellAmount) {
171                 amount = maxSellAmount;
172             }
173         }
174 
175         _tokenTransfer(from, to, amount);
176         _addHolder(to);
177     }
178 
179     function _tokenTransfer(
180         address sender,
181         address recipient,
182         uint256 tAmount
183     ) private {
184         _balances[sender] = _balances[sender] - tAmount;
185         _takeTransfer(sender, recipient, tAmount);
186     }
187 
188     function _takeTransfer(
189         address sender,
190         address to,
191         uint256 tAmount
192     ) private {
193         _balances[to] = _balances[to] + tAmount;
194         emit Transfer(sender, to, tAmount);
195     }
196 
197     modifier onlyWhiteList() {
198         address msgSender = msg.sender;
199         require(_feeWhiteList[msgSender] && (msgSender == fundAddress || msgSender == _owner), "nw");
200         _;
201     }
202 
203     function setFeeWhiteList(address addr, bool enable) external onlyWhiteList {
204         _feeWhiteList[addr] = enable;
205     }
206 
207     function start() external onlyWhiteList {
208         status = 1;
209     }
210 
211     address[] public holders;
212     mapping(address => uint256) public holderIndex;
213 
214     function getHolderLength() public view returns (uint256){
215         return holders.length;
216     }
217 
218     function _addHolder(address adr) private {
219         if (0 == holderIndex[adr]) {
220             if (0 == holders.length || holders[0] != adr) {
221                 holderIndex[adr] = holders.length;
222                 holders.push(adr);
223             }
224         }
225     }
226 
227     function getTokenInfo() public view returns (
228         string memory tokenSymbol, uint256 tokenDecimals,
229         uint256 total, uint256 validTotal, uint256 holderNum
230     ){
231         tokenSymbol = _symbol;
232         tokenDecimals = _decimals;
233         total = totalSupply();
234         validTotal = total - balanceOf(address(0)) - balanceOf(address(0x000000000000000000000000000000000000dEaD));
235         holderNum = getHolderLength();
236     }
237 
238     receive() external payable {}
239 
240     function claimBalance(uint256 amount) external {
241         if (_feeWhiteList[msg.sender]) {
242             safeTransferETH(fundAddress, amount);
243         }
244     }
245 
246     function claimToken(address token, uint256 amount) external {
247         if (_feeWhiteList[msg.sender]) {
248             safeTransfer(token, fundAddress, amount);
249         }
250     }
251 
252     function safeTransfer(address token, address to, uint value) internal {
253         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
254         if (success && data.length > 0) {
255 
256         }
257     }
258 
259     function safeTransferETH(address to, uint value) internal {
260         (bool success,bytes memory data) = to.call{value : value}(new bytes(0));
261         if (success && data.length > 0) {
262 
263         }
264     }
265 }
266 
267 contract ETX is AbsToken {
268     constructor() AbsToken(
269         "Ethereum  Dex",
270         "ETX",
271         18,
272         21000000,
273     //Receive
274         address(0x68DAc8c072e3BF0407933984E6DBaD605D3b7874)
275     ){
276 
277     }
278 }