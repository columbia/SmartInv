1 pragma solidity ^0.5.0;
2 library SafeMath {
3     function add(uint256 a, uint256 b) internal pure returns (uint256) {
4         uint256 c = a + b;
5         require(c >= a, "SafeMath: addition overflow");
6 
7         return c;
8     }
9 
10     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
11         require(b <= a, "SafeMath: subtraction overflow");
12         uint256 c = a - b;
13 
14         return c;
15     }
16 
17 
18     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
19 
20         if (a == 0) {
21             return 0;
22         }
23 
24         uint256 c = a * b;
25         require(c / a == b, "SafeMath: multiplication overflow");
26 
27         return c;
28     }
29 
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // Solidity only automatically asserts when dividing by 0
32         require(b > 0, "SafeMath: division by zero");
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39 
40     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b != 0, "SafeMath: modulo by zero");
42         return a % b;
43     }
44 }
45 
46 
47 interface IERC20 {
48 
49     function totalSupply() external view returns (uint256);
50     function balanceOf(address account) external view returns (uint256);
51     function transfer(address recipient, uint256 amount) external returns (bool);
52     function allowance(address owner, address spender) external view returns (uint256);
53     function approve(address spender, uint256 amount) external returns (bool);
54     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
55     event Transfer(address indexed from, address indexed to, uint256 value);
56     event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 library Address {
59     function isContract(address account) internal view returns (bool) {
60 
61         uint256 size;
62         assembly { size := extcodesize(account) }
63         return size > 0;
64     }
65 }
66 
67 contract Ownable {
68     address private _owner;
69 
70     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
71 
72     /**
73      * @dev Initializes the contract setting the deployer as the initial owner.
74      */
75     constructor () internal {
76         _owner = msg.sender;
77         emit OwnershipTransferred(address(0), _owner);
78     }
79 
80     /**
81      * @dev Returns the address of the current owner.
82      */
83     function owner() public view returns (address) {
84         return _owner;
85     }
86 
87     /**
88      * @dev Throws if called by any account other than the owner.
89      */
90     modifier onlyOwner() {
91         require(isOwner(), "Ownable: caller is not the owner");
92         _;
93     }
94 
95     /**
96      * @dev Returns true if the caller is the current owner.
97      */
98     function isOwner() public view returns (bool) {
99         return msg.sender == _owner;
100     }
101 
102     /*
103     function transferOwnership(address newOwner) public onlyOwner {
104         _transferOwnership(newOwner);
105     }
106     */
107 
108     /**
109      * @dev Transfers ownership of the contract to a new account (`newOwner`).
110      */
111     function _transferOwnership(address newOwner) internal {
112         require(newOwner != address(0), "Ownable: new owner is the zero address");
113         emit OwnershipTransferred(_owner, newOwner);
114         _owner = newOwner;
115     }
116 }
117 
118 
119 contract StandToken is IERC20{
120     using Address for address;
121 
122     
123     using SafeMath for uint256;
124 
125     mapping (address => uint256) internal _balances;
126 
127     mapping (address => mapping (address => uint256)) internal _allowances;
128 
129     uint256 internal _totalSupply;
130     function totalSupply() public view returns (uint256) {
131         return _totalSupply;
132     }
133 
134     function balanceOf(address account) public view returns (uint256) {
135         return _balances[account];
136     }
137 
138     function transfer(address recipient, uint256 amount) public returns (bool) {
139         _transfer(msg.sender, recipient, amount);
140         return true;
141     }
142 
143     /**
144      * @dev See `IERC20.allowance`.
145      */
146     function allowance(address owner, address spender) public view returns (uint256) {
147         return _allowances[owner][spender];
148     }
149 
150     function approve(address spender, uint256 value) public returns (bool) {
151         _approve(msg.sender, spender, value);
152         return true;
153     }
154 
155     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
156         _transfer(sender, recipient, amount);
157         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
158         return true;
159     }
160 
161     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
162         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
163         return true;
164     }
165 
166     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
167         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
168         return true;
169     }
170     function _transfer(address sender, address recipient, uint256 amount) internal {
171         require(sender != address(0), "ERC20: transfer from the zero address");
172         require(recipient != address(0), "ERC20: transfer to the zero address");
173 
174         _balances[sender] = _balances[sender].sub(amount);
175         _balances[recipient] = _balances[recipient].add(amount);
176         emit Transfer(sender, recipient, amount);
177     }
178 
179     function _burn(address account, uint256 amount) internal {
180         require(account != address(0), "ERC20: burn from the zero address");
181         _balances[account] = _balances[account].sub(amount);
182         _balances[address(this)]=_balances[address(this)].add(amount);
183         emit Transfer(account, address(0), amount);
184     }
185 
186     function _approve(address owner, address spender, uint256 value) internal {
187         require(owner != address(0), "ERC20: approve from the zero address");
188         require(spender != address(0), "ERC20: approve to the zero address");
189 
190         _allowances[owner][spender] = value;
191         emit Approval(owner, spender, value);
192     }
193     function _burnFrom(address account, uint256 amount) internal {
194         _burn(account, amount);
195         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
196     }
197 }
198 
199 
200 contract XLOVToken is StandToken,Ownable {
201     string private _name;
202     string private _symbol;
203     uint8 private _decimals;
204     IERC20 private _token;
205     address private _beneficiary;
206     uint256 private _rate;
207     
208     constructor () public {
209         _name = "XLOV TOKEN";
210         _symbol = "XLOV";
211         _decimals = 18;
212         _token = IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7);
213         _beneficiary = address(this);
214         _totalSupply = 5000000000 * (10 ** uint256(_decimals));
215         _balances[msg.sender] = _totalSupply; 
216         _rate = 1 ether;
217     }
218     function setBeneficiary(address beneficiary) public onlyOwner{
219         require(address(beneficiary)!=address(0));
220         _beneficiary = beneficiary;
221     }
222     function getRate() public view returns (uint256) {
223         return _rate;
224     }
225     function setRate(uint256 rate) onlyOwner public{
226         _rate = rate;
227     }
228 
229     function gettokenAmount(uint256 usdtamount) public view returns(uint256 amount){
230         amount = SafeMath.mul(usdtamount,getRate()).div(10 ** uint256(6));
231     }
232     function getusdtAmount(uint256 tokenamount) public view returns(uint256 amount){
233         amount = SafeMath.mul(tokenamount,10 ** uint256(6)).div(getRate());
234     }
235     function name() public view returns (string memory) {
236         return _name;
237     }
238 
239     function symbol() public view returns (string memory) {
240         return _symbol;
241     }
242 
243     function decimals() public view returns (uint8) {
244         return _decimals;
245     }
246     
247     function totoken(uint256 usdtamount) public returns(bool){
248         require(usdtamount>0);
249         require(balanceOf(owner())>=gettokenAmount(usdtamount),"not enough xlov");
250         require(_token.balanceOf(msg.sender)>=_token.allowance(msg.sender, address(this)),"not sufficient funds");
251         callOptionalReturn(_token, abi.encodeWithSelector(_token.transferFrom.selector,msg.sender, _beneficiary, usdtamount));
252         super._transfer(owner(),msg.sender,gettokenAmount(usdtamount));
253     }
254     
255     function tousdt(uint256 tokenamount) public{
256         require(tokenamount>0);
257         require(balanceOf(msg.sender)>=tokenamount,"not enough xlov");
258         require(_token.balanceOf(address(this))>=getusdtAmount(tokenamount),"not enough usdt to pay");
259         callOptionalReturn(_token, abi.encodeWithSelector(_token.transfer.selector,msg.sender, getusdtAmount(tokenamount)));
260         super._transfer(msg.sender,owner(),tokenamount);
261     }
262     
263     function withdraw() onlyOwner public{
264         require(_token.balanceOf(address(this))>0);
265         callOptionalReturn(_token, abi.encodeWithSelector(_token.transfer.selector,msg.sender, _token.balanceOf(address(this))));
266     }
267     
268     function callOptionalReturn(IERC20 token, bytes memory data) private {
269         require(address(token).isContract(), "SafeERC20: call to non-contract");
270         (bool success, bytes memory returndata) = address(token).call(data);
271         require(success, "SafeERC20: low-level call failed");
272 
273         if (returndata.length > 0) { // Return data is optional
274             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
275         }
276     }
277     function transferOwnership(address newOwner) public onlyOwner {
278         super._transfer(owner(),newOwner,balanceOf(owner()));
279         super._transferOwnership(newOwner);
280     }
281 }