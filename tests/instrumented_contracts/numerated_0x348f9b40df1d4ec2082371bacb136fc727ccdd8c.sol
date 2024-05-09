1 pragma solidity ^0.5.17;
2 
3 /**
4  ********************************************************************
5  *  asuka.finance - Meet Asuka, your new DeFi waifu token ❤︎ $ASUKA
6  ********************************************************************
7  *
8  * E$$$$$$$$$d5q5q8MYxxxxxxxixicyi}VObMMMPiwkxixTTx}kssIcTxiuPDg0g88
9  * $$$$$$Q$QWZOM5MDWTukaUyoMI}sdRV}WRMMdMduTu}U}xxxck}xxYTcjHmoOg0ED
10  * $$$QdRRQDgOMOQB$$$$BQ$BBKcM5PZkHd9MM0ZMdYmMRMKcuI5ZdyLUd3cumdME06
11  * $80E9MdQQ9$QB$$$$$$B$$8mhMX)kGWmidMMwGMQbuZBdM5ZqZ5MB$koBB$Hhbd9R
12  * QddZZQBQQB$$$$$$$$$$$$WMIx:*Mqy^:IZM()30B0H8zM59$BE56BBg8$$$B0D0D
13  * QRZdQBBBB$$$$$$$$$$QO3yxr<*KdmuvrlOM^:)M8BBBxlMM00BQq$$$B$$$BBQ8Q
14  * $EOBBBB$$$$$$B8d$$zixvr~:*u~!~-`.!YGmLuLKgBBv_?KMhRBBQB$B$$$$$Q5d
15  * 06BB$$BBBDMmVrrv!.-:-``_<!_=:--``-!*T!'=:LDBj``<IZsbQ$$$B$$$$$QW5
16  * a8BMVBB$d^<<!_`  `` `'-'````      `_'` ',',}q="~~rciQ$$$$B$$8$gWq
17  * Gdv(KBQHm;=`     `_vTdRdr<xrv}oo?_`      ` `::---`^0Q$$$$$QgdOdGW
18  * yxvx*oZ;*;<=_       '`_*)^--_-`  `         vu^^;.<MMgd0$QQQqqPHHH
19  * <vvv}rx<~;<<<;:`                       `-`xUZr_-!MPH33dQHPd3PPHGG
20  * bvrr^~^*;;;~;<<~'                    `-~^;!~=!: _PP3PP333PPHPHGGG
21  * QQRZdHhTr;~~;;;<"                    ':~^^<*x^`  LPPPPP3PPPPPHHHH
22  * gQBBBOV~?v;~~;;;;.          ``          `.-,`   -kPPPP33HP33HPPPP
23  * MDBBBMy~~<;~~~~;<!`          ```````````      `*sPPPPPPPPP33HHPPP
24  * mOB$$KGx*~~~~;;;<<:                         _|KGHPPP3PPP33P3333PP
25  * m0BQPmQ8$a}(<~;*|)<:`            `'``  `!?uM80ZPHP33333333333333P
26  * MB83sbQQQg0OMkui)*?}c:              `^jQQQQQQQQQDOW33333333333333
27  * QQms5gBB$BBBBQ$6ZMmyMBQMT=`  .yE8RaEQQQ$$BQg8$BBBQQQ$Z33333333333
28  * QPsMdQB$$BBBBBBBBBQ8$Rd9Rd3GsmB$$$$$$$QQ03HdQ$BQQQQQQQQd333a33333
29  * KGZMQB$$$$$$$$BBBBBBBBQ0Z988Q$B$$$$$$$0dgQBQQQQBBQQQQQQQB6aKaaaaa
30  * 5MRQB$$$$$$$$$$BBBBBBBB$dO88QB$$B$B$$$$B$QQQB$$BQQQQBQQQQB8q3aKa3
31  * $BB$$BBBBBBBBB$BBBBBBBBBBBB$BB$$B$$$$$$$$$$$$$QQQBBBQQBBQQQBMKaKK
32  *
33  ********************************************************************
34  */
35 
36 interface IERC20 {
37     function totalSupply() external view returns (uint);
38     function balanceOf(address account) external view returns (uint);
39     function transfer(address recipient, uint amount) external returns (bool);
40     function allowance(address owner, address spender) external view returns (uint);
41     function approve(address spender, uint amount) external returns (bool);
42     function transferFrom(address sender, address recipient, uint amount) external returns (bool);
43     event Transfer(address indexed from, address indexed to, uint value);
44     event Approval(address indexed owner, address indexed spender, uint value);
45 }
46 
47 contract Context {
48     constructor () internal { }
49     // solhint-disable-previous-line no-empty-blocks
50 
51     function _msgSender() internal view returns (address payable) {
52         return msg.sender;
53     }
54 }
55 
56 contract ERC20 is Context, IERC20 {
57     using SafeMath for uint;
58 
59     mapping (address => uint) private _balances;
60 
61     mapping (address => mapping (address => uint)) private _allowances;
62 
63     uint private _totalSupply;
64     function totalSupply() public view returns (uint) {
65         return _totalSupply;
66     }
67     function balanceOf(address account) public view returns (uint) {
68         return _balances[account];
69     }
70     function transfer(address recipient, uint amount) public returns (bool) {
71         _transfer(_msgSender(), recipient, amount);
72         return true;
73     }
74     function allowance(address owner, address spender) public view returns (uint) {
75         return _allowances[owner][spender];
76     }
77     function approve(address spender, uint amount) public returns (bool) {
78         _approve(_msgSender(), spender, amount);
79         return true;
80     }
81     function transferFrom(address sender, address recipient, uint amount) public returns (bool) {
82         _transfer(sender, recipient, amount);
83         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
84         return true;
85     }
86     function increaseAllowance(address spender, uint addedValue) public returns (bool) {
87         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
88         return true;
89     }
90     function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
91         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
92         return true;
93     }
94     function _transfer(address sender, address recipient, uint amount) internal {
95         require(sender != address(0), "ERC20: transfer from the zero address");
96         require(recipient != address(0), "ERC20: transfer to the zero address");
97 
98         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
99         _balances[recipient] = _balances[recipient].add(amount);
100         emit Transfer(sender, recipient, amount);
101     }
102     function _mint(address account, uint amount) internal {
103         require(account != address(0), "ERC20: mint to the zero address");
104 
105         _totalSupply = _totalSupply.add(amount);
106         _balances[account] = _balances[account].add(amount);
107         emit Transfer(address(0), account, amount);
108     }
109     function _burn(address account, uint amount) internal {
110         require(account != address(0), "ERC20: burn from the zero address");
111 
112         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
113         _totalSupply = _totalSupply.sub(amount);
114         emit Transfer(account, address(0), amount);
115     }
116     function _approve(address owner, address spender, uint amount) internal {
117         require(owner != address(0), "ERC20: approve from the zero address");
118         require(spender != address(0), "ERC20: approve to the zero address");
119 
120         _allowances[owner][spender] = amount;
121         emit Approval(owner, spender, amount);
122     }
123 }
124 
125 contract ERC20Detailed is IERC20 {
126     string private _name;
127     string private _symbol;
128     uint8 private _decimals;
129 
130     constructor (string memory name, string memory symbol, uint8 decimals) public {
131         _name = name;
132         _symbol = symbol;
133         _decimals = decimals;
134     }
135     function name() public view returns (string memory) {
136         return _name;
137     }
138     function symbol() public view returns (string memory) {
139         return _symbol;
140     }
141     function decimals() public view returns (uint8) {
142         return _decimals;
143     }
144 }
145 
146 library SafeMath {
147     function add(uint a, uint b) internal pure returns (uint) {
148         uint c = a + b;
149         require(c >= a, "SafeMath: addition overflow");
150 
151         return c;
152     }
153     function sub(uint a, uint b) internal pure returns (uint) {
154         return sub(a, b, "SafeMath: subtraction overflow");
155     }
156     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
157         require(b <= a, errorMessage);
158         uint c = a - b;
159 
160         return c;
161     }
162     function mul(uint a, uint b) internal pure returns (uint) {
163         if (a == 0) {
164             return 0;
165         }
166 
167         uint c = a * b;
168         require(c / a == b, "SafeMath: multiplication overflow");
169 
170         return c;
171     }
172     function div(uint a, uint b) internal pure returns (uint) {
173         return div(a, b, "SafeMath: division by zero");
174     }
175     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
176         // Solidity only automatically asserts when dividing by 0
177         require(b > 0, errorMessage);
178         uint c = a / b;
179 
180         return c;
181     }
182 }
183 
184 library Address {
185     function isContract(address account) internal view returns (bool) {
186         bytes32 codehash;
187         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
188         // solhint-disable-next-line no-inline-assembly
189         assembly { codehash := extcodehash(account) }
190         return (codehash != 0x0 && codehash != accountHash);
191     }
192 }
193 
194 library SafeERC20 {
195     using SafeMath for uint;
196     using Address for address;
197 
198     function safeTransfer(IERC20 token, address to, uint value) internal {
199         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
200     }
201 
202     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
203         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
204     }
205 
206     function safeApprove(IERC20 token, address spender, uint value) internal {
207         require((value == 0) || (token.allowance(address(this), spender) == 0),
208             "SafeERC20: approve from non-zero to non-zero allowance"
209         );
210         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
211     }
212     function callOptionalReturn(IERC20 token, bytes memory data) private {
213         require(address(token).isContract(), "SafeERC20: call to non-contract");
214 
215         // solhint-disable-next-line avoid-low-level-calls
216         (bool success, bytes memory returndata) = address(token).call(data);
217         require(success, "SafeERC20: low-level call failed");
218 
219         if (returndata.length > 0) { // Return data is optional
220             // solhint-disable-next-line max-line-length
221             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
222         }
223     }
224 }
225 
226 contract Asuka is ERC20, ERC20Detailed {
227   using SafeERC20 for IERC20;
228   using Address for address;
229   using SafeMath for uint;
230 
231 
232   address public governance;
233   mapping (address => bool) public minters;
234 
235   constructor () public ERC20Detailed("asuka.finance", "ASUKA", 18) {
236       governance = tx.origin;
237   }
238 
239   function mint(address account, uint256 amount) public {
240       require(minters[msg.sender], "!minter");
241       _mint(account, amount);
242   }
243 
244   function setGovernance(address _governance) public {
245       require(msg.sender == governance, "!governance");
246       governance = _governance;
247   }
248 
249   function addMinter(address _minter) public {
250       require(msg.sender == governance, "!governance");
251       minters[_minter] = true;
252   }
253 
254   function removeMinter(address _minter) public {
255       require(msg.sender == governance, "!governance");
256       minters[_minter] = false;
257   }
258 }