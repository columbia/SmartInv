1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.7.0;
3 
4 /**
5  *Submitted for verification at Etherscan.io on <date>
6  */
7 
8 /**
9  * Name: Behodler.io
10  * Symbol: EYE
11  * Max Supply: 10000000
12  * Deployed to: 
13  * Website: behodler.io | https://behodler.io
14  */
15 
16 library SafeMath {
17     function add(uint256 a, uint256 b) internal pure returns (uint256) {
18         uint256 c = a + b;
19         require(c >= a, "SafeMath: addition overflow");
20         return c;
21     }
22 
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         return sub(a, b, "SafeMath: subtraction overflow");
25     }
26 
27     function sub(
28         uint256 a,
29         uint256 b,
30         string memory errorMessage
31     ) internal pure returns (uint256) {
32         require(b <= a, errorMessage);
33         uint256 c = a - b;
34         return c;
35     }
36 }
37 
38 interface IERC20 {
39     function totalSupply() external view returns (uint256);
40 
41     function balanceOf(address account) external view returns (uint256);
42 
43     function transfer(address recipient, uint256 amount)
44         external
45         returns (bool);
46 
47     function allowance(address owner, address spender)
48         external
49         view
50         returns (uint256);
51 
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     function transferFrom(
55         address sender,
56         address recipient,
57         uint256 amount
58     ) external returns (bool);
59 
60     event Transfer(address indexed from, address indexed to, uint256 value);
61     event Approval(
62         address indexed owner,
63         address indexed spender,
64         uint256 value
65     );
66 }
67 
68 abstract contract Context {
69     function _msgSender() internal virtual view returns (address payable) {
70         return msg.sender;
71     }
72 
73     function _msgData() internal virtual view returns (bytes memory) {
74         this;
75         return msg.data;
76     }
77 }
78 
79 contract Ownable is Context {
80     address private _owner;
81 
82     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
83 
84     /**
85      * @dev Initializes the contract setting the deployer as the initial owner.
86      */
87     constructor () {
88         address msgSender = _msgSender();
89         _owner = msgSender;
90         emit OwnershipTransferred(address(0), msgSender);
91     }
92 
93     /**
94      * @dev Returns the address of the current owner.
95      */
96     function owner() public view returns (address) {
97         return _owner;
98     }
99 
100     /**
101      * @dev Throws if called by any account other than the owner.
102      */
103     modifier onlyOwner() {
104         require(_owner == _msgSender(), "Ownable: caller is not the owner");
105         _;
106     }
107 
108     /**
109      * @dev Leaves the contract without owner. It will not be possible to call
110      * `onlyOwner` functions anymore. Can only be called by the current owner.
111      *
112      * NOTE: Renouncing ownership will leave the contract without an owner,
113      * thereby removing any functionality that is only available to the owner.
114      */
115     function renounceOwnership() public virtual onlyOwner {
116         emit OwnershipTransferred(_owner, address(0));
117         _owner = address(0);
118     }
119 
120     /**
121      * @dev Transfers ownership of the contract to a new account (`newOwner`).
122      * Can only be called by the current owner.
123      */
124     function transferOwnership(address newOwner) public virtual onlyOwner {
125         require(newOwner != address(0), "Ownable: new owner is the zero address");
126         emit OwnershipTransferred(_owner, newOwner);
127         _owner = newOwner;
128     }
129 }
130 
131 
132 contract Eye is Context, Ownable, IERC20 {
133     uint256 public constant ONE = 1e18;
134     using SafeMath for uint256;
135     mapping(address => uint256) private _balances;
136     mapping(address => mapping(address => uint256)) private _allowances;
137     uint256 private _totalSupply = 10e6 * ONE;
138     bool private burnEnabled = false;
139 
140     constructor() {
141         _balances[msg.sender] = _totalSupply;
142     }
143 
144     function name() public pure returns (string memory) {
145         return "Behodler.io";
146     }
147 
148     function symbol() public pure returns (string memory) {
149         return "EYE";
150     }
151 
152     function decimals() public pure returns (uint8) {
153         return 18;
154     }
155 
156     function totalSupply() public view override returns (uint256) {
157         return _totalSupply;
158     }
159 
160     function balanceOf(address account) public override view returns (uint256) {
161         return _balances[account];
162     }
163 
164     function transfer(address recipient, uint256 amount)
165         public
166         virtual
167         override
168         returns (bool)
169     {
170         _transfer(_msgSender(), recipient, amount);
171         return true;
172     }
173 
174     function allowance(address owner, address spender)
175         public
176         virtual
177         override
178         view
179         returns (uint256)
180     {
181         return _allowances[owner][spender];
182     }
183 
184     function approve(address spender, uint256 amount)
185         public
186         virtual
187         override
188         returns (bool)
189     {
190         _approve(_msgSender(), spender, amount);
191         return true;
192     }
193 
194     function transferFrom(
195         address sender,
196         address recipient,
197         uint256 amount
198     ) public virtual override returns (bool) {
199         _transfer(sender, recipient, amount);
200         _approve(
201             sender,
202             _msgSender(),
203             _allowances[sender][_msgSender()].sub(
204                 amount,
205                 "ERC20: transfer amount exceeds allowance"
206             )
207         );
208         return true;
209     }
210 
211     function increaseAllowance(address spender, uint256 addedValue)
212         public
213         virtual
214         returns (bool)
215     {
216         _approve(
217             _msgSender(),
218             spender,
219             _allowances[_msgSender()][spender].add(addedValue)
220         );
221         return true;
222     }
223 
224     function decreaseAllowance(address spender, uint256 subtractedValue)
225         public
226         virtual
227         returns (bool)
228     {
229         _approve(
230             _msgSender(),
231             spender,
232             _allowances[_msgSender()][spender].sub(
233                 subtractedValue,
234                 "ERC20: decreased allowance below zero"
235             )
236         );
237         return true;
238     }
239 
240     function _transfer(
241         address sender,
242         address recipient,
243         uint256 amount
244     ) internal virtual {
245         require(sender != address(0), "ERC20: transfer from the zero address");
246         require(recipient != address(0), "ERC20: transfer to the zero address");
247 
248         _balances[sender] = _balances[sender].sub(
249             amount,
250             "ERC20: transfer amount exceeds balance"
251         );
252         _balances[recipient] = _balances[recipient].add(amount);
253         emit Transfer(sender, recipient, amount);
254     }
255 
256     function _approve(
257         address owner,
258         address spender,
259         uint256 amount
260     ) internal virtual {
261         require(owner != address(0), "ERC20: approve from the zero address");
262         require(spender != address(0), "ERC20: approve to the zero address");
263 
264         _allowances[owner][spender] = amount;
265         emit Approval(owner, spender, amount);
266     }
267 
268     function enableBurning(bool enabled) public onlyOwner {
269         burnEnabled = enabled;
270     }
271 
272     function burn (uint value) public {
273         require(burnEnabled,"burn feature not yet active.");
274         _burn(_msgSender(),value);
275     }
276 
277      function _burn(address account, uint256 value) internal {
278         require(account != address(0), "ERC20: burn from the zero address");
279 
280         _totalSupply = _totalSupply.sub(value);
281         _balances[account] = _balances[account].sub(value);
282         emit Transfer(account, address(0), value);
283     }
284 }