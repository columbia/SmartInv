1 /**
2  *Submitted for verification at Etherscan.io on 2020-11-10
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2020-11-09
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2020-11-05
11 */
12 
13 //SPDX-License-Identifier: UNLICENSED
14 
15 pragma solidity ^0.7.4;
16 
17 interface IERC20 {
18     function totalSupply() external view returns (uint);
19     function balanceOf(address account) external view returns (uint);
20     function transfer(address recipient, uint amount) external returns (bool);
21     function allowance(address owner, address spender) external view returns (uint);
22     function approve(address spender, uint amount) external returns (bool);
23     function transferFrom(address sender, address recipient, uint amount) external returns (bool);
24     function transferFromStake(address sender, address recipient, uint amount) external returns (bool);
25     event Transfer(address indexed from, address indexed to, uint value);
26     event Approval(address indexed owner, address indexed spender, uint value);
27 }
28 
29 contract Ownable {
30     address public owner;
31 
32     /**
33       * @dev The Ownable constructor sets the original `owner` of the contract to the sender
34       * account.
35       */
36      constructor() {
37         owner = msg.sender;
38     }
39 
40     /**
41       * @dev Throws if called by any account other than the owner.
42       */
43     modifier onlyOwner() {
44         require(msg.sender == owner);
45         _;
46     }
47 
48     /**
49     * @dev Allows the current owner to transfer control of the contract to a newOwner.
50     * @param newOwner The address to transfer ownership to.
51     */
52     function transferOwnership(address newOwner) public onlyOwner {
53         if (newOwner != address(0)) {
54             owner = newOwner;
55         }
56     }
57 
58 }
59 
60 
61 library SafeMath {
62     function add(uint a, uint b) internal pure returns (uint) {
63         uint c = a + b;
64         require(c >= a, "SafeMath: addition overflow");
65 
66         return c;
67     }
68     function sub(uint a, uint b) internal pure returns (uint) {
69         return sub(a, b, "SafeMath: subtraction overflow");
70     }
71     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
72         require(b <= a, errorMessage);
73         uint c = a - b;
74 
75         return c;
76     }
77     function mul(uint a, uint b) internal pure returns (uint) {
78         if (a == 0) {
79             return 0;
80         }
81 
82         uint c = a * b;
83         require(c / a == b, "SafeMath: multiplication overflow");
84 
85         return c;
86     }
87     function div(uint a, uint b) internal pure returns (uint) {
88         return div(a, b, "SafeMath: division by zero");
89     }
90     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
91         // Solidity only automatically asserts when dividing by 0
92         require(b > 0, errorMessage);
93         uint c = a / b;
94 
95         return c;
96     }
97     function ceil(uint a, uint m) internal pure returns (uint r) {
98         return (a + m - 1) / m * m;
99     }
100 }
101 
102 contract Context {
103     constructor () { }
104     // solhint-disable-previous-line no-empty-blocks
105 
106     function _msgSender() internal view returns (address payable) {
107         return msg.sender;
108     }
109 }
110 
111 contract ERC20 is Context, IERC20, Ownable {
112     using SafeMath for uint;
113 
114     mapping (address => uint) internal _balances;
115 
116     mapping (address => mapping (address => uint)) internal _allowances;
117 
118     uint internal _totalSupply;
119     uint256 ownerFee = 20; // 2%
120     uint256 rewardMakerFee = 20; // 2% 
121    address exemptWallet;
122     
123     function totalSupply() public view override returns (uint) {
124         return _totalSupply;
125     }
126     function balanceOf(address account) public view override returns (uint) {
127         
128          require(account != address(0), "ERC20: checking balanceOf from the zero address");
129         return _balances[account];
130     }
131     function transfer(address recipient, uint amount) public override  returns (bool) {
132         require(amount > 0, "amount should be > 0");
133          require(recipient != address(0), "ERC20: recipient shoud not be the zero address");
134          
135         _transfer(_msgSender(), recipient, amount);
136         return true;
137     }
138     function allowance(address owner, address spender) public view override returns (uint) {
139         require(owner != address(0), "ERC20: owner from the zero address");
140         require(spender != address(0), "ERC20: spender to the zero address");
141         
142         return _allowances[owner][spender];
143     }
144     function approve(address spender, uint amount) public override returns (bool) {
145         require(amount > 0, "amount should be > 0");
146          require(spender != address(0), "ERC20: spender shoud not be the zero address");
147          
148         _approve(_msgSender(), spender, amount);
149         return true;
150     }
151     function transferFrom(address sender, address recipient, uint amount) public override returns (bool) {
152         require(recipient != address(0), "ERC20: recipient is set to the zero address");
153         require(sender != address(0), "ERC20: sending to the zero address");
154         require(amount > 0, "amount should be > 0");
155         
156         _transfer(sender, recipient, amount);
157         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
158         return true;
159     }
160     
161     function transferFromStake(address sender, address recipient, uint amount) public override returns (bool) {
162          require(recipient != address(0), "ERC20: recipient is set to the zero address");
163         require(sender != address(0), "ERC20: sending to the zero address");
164         
165         
166         _transferstake(sender, recipient, amount);
167         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
168         return true;
169     }
170     
171     function increaseAllowance(address spender, uint addedValue) public returns (bool) {
172         require(addedValue > 0, "Value should be > 0");
173         require(spender != address(0), "ERC20: increaseAllowance from the zero address");
174         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
175         return true;
176     }
177     function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
178         require(subtractedValue > 0, "Value should be > 0");
179         require(spender != address(0), "ERC20: decreaseAllowance from the zero address");
180         
181         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
182         return true;
183     }
184     
185     function setExemptWallet(address wallet_) external onlyOwner returns (address){
186         require(wallet_ != address(0), "ERC20: zero address cant be exempted");
187         
188         exemptWallet = wallet_;
189         return exemptWallet;
190     }
191     
192     function _transfer(address sender, address recipient, uint amount) internal {
193         address mainOwner = 0x7BB705FD59D2bA9D236eF8506d3B981f097ABb24;
194         address rewardMaker = 0x181b3a5c476fEecC97Cf7f31Ea51093f324B726f;
195        
196         require(sender != address(0), "ERC20: transfer from the zero address");
197         require(recipient != address(0), "ERC20: transfer to the zero address");
198         
199         
200        
201         uint256 burntAmount1 = (onePercent(amount).mul(ownerFee)).div(10); 
202         uint256 leftAfterBurn1 = amount.sub(burntAmount1);
203    
204         uint256 burntAmount2 = (onePercent(amount).mul(rewardMakerFee)).div(10); 
205         uint256 leftAfterBurn2 = leftAfterBurn1.sub(burntAmount2);
206         
207         
208         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
209         
210         if(sender != exemptWallet && sender != owner && sender != mainOwner && sender != rewardMaker){
211             
212             _balances[recipient] = _balances[recipient].add(leftAfterBurn2);
213     
214             _balances[mainOwner] = _balances[mainOwner].add(burntAmount1);       
215              _balances[rewardMaker] = _balances[rewardMaker].add(burntAmount2); 
216              
217              emit Transfer(sender, rewardMaker, burntAmount2);
218             emit Transfer(sender, mainOwner, burntAmount1);
219         }
220         else {
221             _balances[recipient] = _balances[recipient].add(amount);
222         }
223         
224         
225         emit Transfer(sender, recipient, amount);
226     }
227     
228     function onePercent(uint256 _tokens) private pure returns (uint256){
229         uint256 roundValue = _tokens.ceil(100);
230         uint onePercentofTokens = roundValue.mul(100).div(100 * 10**uint(2));
231         return onePercentofTokens;
232     }
233     
234     function _transferstake(address sender, address recipient, uint amount) internal {
235       
236         require(sender != address(0), "ERC20: transfer from the zero address");
237         require(recipient != address(0), "ERC20: transfer to the zero address");
238        
239       
240         
241         
242         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
243         _balances[recipient] = _balances[recipient].add(amount);
244 
245        
246         emit Transfer(sender, recipient, amount);
247     }
248    
249  
250     function _approve(address owner, address spender, uint amount) internal {
251         require(owner != address(0), "ERC20: approve from the zero address");
252         require(spender != address(0), "ERC20: approve to the zero address");
253 
254         _allowances[owner][spender] = amount;
255         emit Approval(owner, spender, amount);
256     }
257     
258     function _burn(address account, uint amount) internal {
259         require(account != address(0), "ERC20: burn from the zero address");
260         
261         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
262         _totalSupply = _totalSupply.sub(amount);
263        
264         emit Transfer(account, address(0), amount);
265 }
266 }
267 contract ERC20Detailed is ERC20 {
268     string private _name;
269     string private _symbol;
270     uint8 private _decimals;
271 
272     constructor (string memory name_, string memory symbol_, uint8 decimals_) {
273         _name = name_;
274         _symbol = symbol_;
275         _decimals = decimals_;
276         
277     }
278     function name() public view returns (string memory) {
279         return _name;
280     }
281     function symbol() public view returns (string memory) {
282         return _symbol;
283     }
284     function decimals() public view returns (uint8) {
285         return _decimals;
286     }
287 }
288 
289 
290 
291 library Address {
292     function isContract(address _addr) internal view returns (bool){
293       uint32 size;
294       assembly {
295         size := extcodesize(_addr)
296       }
297       return (size > 0);
298     }
299 }
300 
301 library SafeERC20 {
302     using SafeMath for uint;
303     using Address for address;
304 
305     function safeTransfer(IERC20 token, address to, uint value) internal {
306         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
307     }
308 
309     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
310         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
311     }
312 
313     function safeApprove(IERC20 token, address spender, uint value) internal {
314         require((value == 0) || (token.allowance(address(this), spender) == 0),
315             "SafeERC20: approve from non-zero to non-zero allowance"
316         );
317         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
318     }
319     function callOptionalReturn(IERC20 token, bytes memory data) private {
320         require(address(token).isContract(), "SafeERC20: call to non-contract");
321 
322         // solhint-disable-next-line avoid-low-level-calls
323         (bool success, bytes memory returndata) = address(token).call(data);
324         require(success, "SafeERC20: low-level call failed");
325 
326         if (returndata.length > 0) { // Return data is optional
327             // solhint-disable-next-line max-line-length
328             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
329         }
330     }
331 }
332 
333 
334 
335 contract HYPE_Finance is ERC20, ERC20Detailed {
336   using SafeERC20 for IERC20;
337   using Address for address;
338   using SafeMath for uint;
339   
340   
341   //address public owner;
342   
343   constructor () ERC20Detailed("HYPE-Finance", "HYPE", 18) {
344       owner = msg.sender;
345     _totalSupply = 10000 *(10**uint256(18));
346 
347     
348 	_balances[msg.sender] = _totalSupply;
349   }
350 }