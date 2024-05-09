1 /**
2  *Submitted for verification at Etherscan.io on 2020-10-21
3 */
4 
5 //SPDX-License-Identifier: UNLICENSED
6 
7 pragma solidity ^0.6.12;
8 
9 interface IERC20 {
10     function totalSupply() external view returns (uint);
11     function balanceOf(address account) external view returns (uint);
12     function transfer(address recipient, uint amount) external returns (bool);
13     function allowance(address owner, address spender) external view returns (uint);
14     function approve(address spender, uint amount) external returns (bool);
15     function transferFrom(address sender, address recipient, uint amount) external returns (bool);
16     event Transfer(address indexed from, address indexed to, uint value);
17     event Approval(address indexed owner, address indexed spender, uint value);
18 }
19 library SafeMath {
20     function add(uint a, uint b) internal pure returns (uint) {
21         uint c = a + b;
22         require(c >= a, "SafeMath: addition overflow");
23 
24         return c;
25     }
26     function sub(uint a, uint b) internal pure returns (uint) {
27         return sub(a, b, "SafeMath: subtraction overflow");
28     }
29     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
30         require(b <= a, errorMessage);
31         uint c = a - b;
32 
33         return c;
34     }
35     function mul(uint a, uint b) internal pure returns (uint) {
36         if (a == 0) {
37             return 0;
38         }
39 
40         uint c = a * b;
41         require(c / a == b, "SafeMath: multiplication overflow");
42 
43         return c;
44     }
45     function div(uint a, uint b) internal pure returns (uint) {
46         return div(a, b, "SafeMath: division by zero");
47     }
48     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
49         // Solidity only automatically asserts when dividing by 0
50         require(b > 0, errorMessage);
51         uint c = a / b;
52 
53         return c;
54     }
55 }
56 
57 contract Context {
58     constructor () internal { }
59     // solhint-disable-previous-line no-empty-blocks
60 
61     function _msgSender() internal view returns (address payable) {
62         return msg.sender;
63     }
64 }
65 
66 contract ERC20 is Context, IERC20 {
67     using SafeMath for uint;
68 
69     mapping (address => uint) internal _balances;
70 
71     mapping (address => mapping (address => uint)) internal _allowances;
72 
73     uint internal _totalSupply;
74    
75     
76     function totalSupply() public view override returns (uint) {
77         return _totalSupply;
78     }
79     function balanceOf(address account) public view override returns (uint) {
80         return _balances[account];
81     }
82     function transfer(address recipient, uint amount) public override  returns (bool) {
83         _transfer(_msgSender(), recipient, amount);
84         return true;
85     }
86     function allowance(address owner, address spender) public view override returns (uint) {
87         return _allowances[owner][spender];
88     }
89     function approve(address spender, uint amount) public override returns (bool) {
90         _approve(_msgSender(), spender, amount);
91         return true;
92     }
93     function transferFrom(address sender, address recipient, uint amount) public override returns (bool) {
94         _transfer(sender, recipient, amount);
95         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
96         return true;
97     }
98     function increaseAllowance(address spender, uint addedValue) public returns (bool) {
99         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
100         return true;
101     }
102     function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
103         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
104         return true;
105     }
106     function _transfer(address sender, address recipient, uint amount) internal {
107         require(sender != address(0), "ERC20: transfer from the zero address");
108         require(recipient != address(0), "ERC20: transfer to the zero address");
109 
110         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
111         _balances[recipient] = _balances[recipient].add(amount);
112         emit Transfer(sender, recipient, amount);
113     }
114    
115  
116     function _approve(address owner, address spender, uint amount) internal {
117         require(owner != address(0), "ERC20: approve from the zero address");
118         require(spender != address(0), "ERC20: approve to the zero address");
119 
120         _allowances[owner][spender] = amount;
121         emit Approval(owner, spender, amount);
122     }
123 }
124 
125 contract ERC20Detailed is ERC20 {
126     string private _name;
127     string private _symbol;
128     uint8 private _decimals;
129 
130     constructor (string memory name, string memory symbol, uint8 decimals) public {
131         _name = name;
132         _symbol = symbol;
133         _decimals = decimals;
134         
135     }
136     function name() public view returns (string memory) {
137         return _name;
138     }
139     function symbol() public view returns (string memory) {
140         return _symbol;
141     }
142     function decimals() public view returns (uint8) {
143         return _decimals;
144     }
145 }
146 
147 
148 
149 library Address {
150     function isContract(address account) internal view returns (bool) {
151         bytes32 codehash;
152         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
153         // solhint-disable-next-line no-inline-assembly
154         assembly { codehash := extcodehash(account) }
155         return (codehash != 0x0 && codehash != accountHash);
156     }
157 }
158 
159 library SafeERC20 {
160     using SafeMath for uint;
161     using Address for address;
162 
163     function safeTransfer(IERC20 token, address to, uint value) internal {
164         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
165     }
166 
167     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
168         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
169     }
170 
171     function safeApprove(IERC20 token, address spender, uint value) internal {
172         require((value == 0) || (token.allowance(address(this), spender) == 0),
173             "SafeERC20: approve from non-zero to non-zero allowance"
174         );
175         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
176     }
177     function callOptionalReturn(IERC20 token, bytes memory data) private {
178         require(address(token).isContract(), "SafeERC20: call to non-contract");
179 
180         // solhint-disable-next-line avoid-low-level-calls
181         (bool success, bytes memory returndata) = address(token).call(data);
182         require(success, "SafeERC20: low-level call failed");
183 
184         if (returndata.length > 0) { // Return data is optional
185             // solhint-disable-next-line max-line-length
186             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
187         }
188     }
189 }
190 
191 contract TRILL is ERC20, ERC20Detailed {
192   using SafeERC20 for IERC20;
193   using Address for address;
194   using SafeMath for uint;
195   
196   
197   address public owner;
198     /* Price of a TRILL token, in 'wei' denomination */
199     uint constant private TOKEN_PRICE_IN_WEI = 50;
200     
201      /* Address of the wallet holding the token funds when they are first created */
202     address payable wallet;
203     
204       /* Keep track of ETH funds raised */
205     uint public amountRaised;
206 
207      event FundsRaised(address indexed from, uint fundsReceivedInWei, uint tokensIssued);
208        event ETHFundsWithdrawn(address indexed recipient, uint fundsWithdrawnInWei);
209      
210   constructor () public ERC20Detailed("Trill", "TRILL", 18) {
211       owner = msg.sender;
212     _totalSupply = 6969 *(10**uint256(18));
213     
214 	_balances[msg.sender] = _totalSupply;
215   }
216   
217   modifier onlyOwner()
218   {
219       require(msg.sender == owner);
220       _;
221   }
222 
223     
224      function buyTokensWithEther() public payable {
225         // calculate # of tokens to give based on 
226         // amount of Ether received and the token's fixed price
227         uint numTokens = msg.value / TOKEN_PRICE_IN_WEI;
228         
229         // take funds out of our token holdings
230         _balances[wallet] -= numTokens;
231         
232         // deposit those tokens into the buyer's account
233         _balances[msg.sender] += numTokens;
234         
235         // update our tracker of total ETH raised
236         // during this crowdsale
237         amountRaised += msg.value;
238 
239         emit FundsRaised(msg.sender, msg.value, numTokens);
240     }
241     
242     function withdrawRaisedFunds() public {
243         
244         // verify that the account requesting the funds
245         // is the approved beneficiary
246         if (msg.sender != owner)
247             return;
248         
249         // transfer ETH from this contract's balance
250         // to the rightful recipient
251         wallet.transfer(amountRaised);
252         
253         emit ETHFundsWithdrawn(owner, amountRaised);
254         
255     }
256   
257 
258 }