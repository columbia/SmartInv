1 /**
2  *Submitted for verification at Etherscan.io on 2021-03-29
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-03-23
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2021-03-12
11 */
12 
13 /**
14  *Submitted for verification at Etherscan.io on 2021-01-13
15 */
16 
17 // SPDX-License-Identifier: MIT
18 pragma solidity ^0.6.2;
19 
20 abstract contract Context {
21     function _msgSender() internal virtual view returns (address payable) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal virtual view returns (bytes memory) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 contract Ownable is Context {
32     address private _owner;
33 
34     event OwnershipTransferred(
35         address indexed previousOwner,
36         address indexed newOwner
37     );
38 
39     /**
40      * @dev Initializes the contract setting the deployer as the initial owner.
41      */
42     constructor() internal {
43         address msgSender = _msgSender();
44         _owner = msgSender;
45         emit OwnershipTransferred(address(0), msgSender);
46     }
47 
48     /**
49      * @dev Returns the address of the current owner.
50      */
51     function owner() public view returns (address) {
52         return _owner;
53     }
54 
55     /**
56      * @dev Throws if called by any account other than the owner.
57      */
58     modifier onlyOwner() {
59         require(_owner == _msgSender(), "Ownable: caller is not the owner");
60         _;
61     }
62 
63     /**
64      * @dev Leaves the contract without owner. It will not be possible to call
65      * `onlyOwner` functions anymore. Can only be called by the current owner.
66      *
67      * NOTE: Renouncing ownership will leave the contract without an owner,
68      * thereby removing any functionality that is only available to the owner.
69      */
70     function renounceOwnership() public virtual onlyOwner {
71         emit OwnershipTransferred(_owner, address(0));
72         _owner = address(0);
73     }
74 
75     /**
76      * @dev Transfers ownership of the contract to a new account (`newOwner`).
77      * Can only be called by the current owner.
78      */
79     function transferOwnership(address newOwner) public virtual onlyOwner {
80         require(
81             newOwner != address(0),
82             "Ownable: new owner is the zero address"
83         );
84         emit OwnershipTransferred(_owner, newOwner);
85         _owner = newOwner;
86     }
87 }
88 
89 // import ierc20 & safemath & non-standard
90 interface IERC20 {
91     function totalSupply() external view returns (uint256);
92 
93     function balanceOf(address account) external view returns (uint256);
94 
95     function allowance(address owner, address spender)
96         external
97         view
98         returns (uint256);
99 
100     function transfer(address recipient, uint256 amount)
101         external
102         returns (bool);
103 
104     function approve(address spender, uint256 amount) external returns (bool);
105 
106     function transferFrom(
107         address sender,
108         address recipient,
109         uint256 amount
110     ) external returns (bool);
111 
112     event Transfer(address indexed from, address indexed to, uint256 value);
113     event Approval(
114         address indexed owner,
115         address indexed spender,
116         uint256 value
117     );
118 }
119 
120 library SafeMath {
121     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
122         assert(b <= a);
123         return a - b;
124     }
125 
126     function add(uint256 a, uint256 b) internal pure returns (uint256) {
127         uint256 c = a + b;
128         assert(c >= a);
129         return c;
130     }
131 
132     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
133         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
134         // benefit is lost if 'b' is also tested.
135         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
136         if (a == 0) {
137             return 0;
138         }
139 
140         uint256 c = a * b;
141         require(c / a == b, "SafeMath: multiplication overflow");
142 
143         return c;
144     }
145 
146     function div(uint256 a, uint256 b) internal pure returns (uint256) {
147         return div(a, b, "SafeMath: division by zero");
148     }
149 
150     function div(
151         uint256 a,
152         uint256 b,
153         string memory errorMessage
154     ) internal pure returns (uint256) {
155         // Solidity only automatically asserts when dividing by 0
156         require(b > 0, errorMessage);
157         uint256 c = a / b;
158         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
159 
160         return c;
161     }
162 }
163 
164 interface INonStandardERC20 {
165     function totalSupply() external view returns (uint256);
166 
167     function balanceOf(address owner) external view returns (uint256 balance);
168 
169     ///
170     /// !!!!!!!!!!!!!!
171     /// !!! NOTICE !!! transfer does not return a value, in violation of the ERC-20 specification
172     /// !!!!!!!!!!!!!!
173     ///
174 
175     function transfer(address dst, uint256 amount) external;
176 
177     ///
178     /// !!!!!!!!!!!!!!
179     /// !!! NOTICE !!! transferFrom does not return a value, in violation of the ERC-20 specification
180     /// !!!!!!!!!!!!!!
181     ///
182 
183     function transferFrom(
184         address src,
185         address dst,
186         uint256 amount
187     ) external;
188 
189     function approve(address spender, uint256 amount)
190         external
191         returns (bool success);
192 
193     function allowance(address owner, address spender)
194         external
195         view
196         returns (uint256 remaining);
197 
198     event Transfer(address indexed from, address indexed to, uint256 amount);
199     event Approval(
200         address indexed owner,
201         address indexed spender,
202         uint256 amount
203     );
204 }
205 
206 contract Launchpad  is Ownable {
207     using SafeMath for uint256;
208 
209     event ClaimableAmount(address _user, uint256 _claimableAmount);
210 
211     // address public owner;
212 
213     uint256 public rate;
214     
215     uint256 public allowedUserBalance;
216     
217     bool public presaleOver;
218     IERC20 public usdt;
219     mapping(address => uint256) public claimable;
220 
221     uint256 public hardcap;
222 
223     constructor(uint256 _rate, address _usdt, uint256 _hardcap, uint256 _allowedUserBalance) public {
224         rate = _rate;
225         usdt = IERC20(_usdt);
226         presaleOver = true;
227         // owner = msg.sender;
228         hardcap = _hardcap; 
229         allowedUserBalance = _allowedUserBalance;
230     }
231 
232     modifier isPresaleOver() {
233         require(presaleOver == true, "The presale is not over");
234         _;
235     }
236     
237     function changeHardCap(uint256 _hardcap) onlyOwner public {
238         hardcap = _hardcap;
239     }
240     
241     function changeAllowedUserBalance(uint256 _allowedUserBalance) onlyOwner public {
242         allowedUserBalance = _allowedUserBalance;
243     }
244 
245     function endPresale() external onlyOwner returns (bool) {
246         presaleOver = true;
247         return presaleOver;
248     }
249 
250     function startPresale() external onlyOwner returns (bool) {
251         presaleOver = false;
252         return presaleOver;
253     }
254 
255     function buyTokenWithUSDT(uint256 _amount) external {
256         // user enter amount of ether which is then transfered into the smart contract and tokens to be given is saved in the mapping
257         require(presaleOver == false, "presale is over you cannot buy now");
258         
259         uint256 tokensPurchased = _amount.mul(rate);
260         
261         uint256 userUpdatedBalance = claimable[msg.sender].add(tokensPurchased);
262 
263         require( _amount.add(usdt.balanceOf(address(this))) <= hardcap, "Hardcap for the tokens reached");
264 
265         // for USDT
266         require(userUpdatedBalance.div(rate) <= allowedUserBalance, "Exceeded allowed user balance");
267         
268         // usdt.transferFrom(msg.sender, address(this), _amount);
269         
270         doTransferIn(address(usdt), msg.sender, _amount);
271 
272         claimable[msg.sender] = userUpdatedBalance;
273         
274         emit ClaimableAmount(msg.sender, tokensPurchased);
275     }
276     
277     // function claim() external isPresaleOver {
278     //     // it checks for user msg.sender claimable amount and transfer them to msg.sender
279     //     require(claimable[msg.sender] > 0, "NO tokens left to be claim");
280     //     usdc.transfer(msg.sender, claimable[msg.sender]);
281     //     claimable[msg.sender] = 0;
282     // }
283     
284     function doTransferIn(
285         address tokenAddress,
286         address from,
287         uint256 amount
288     ) internal returns (uint256) {
289         INonStandardERC20 _token = INonStandardERC20(tokenAddress);
290         uint256 balanceBefore = INonStandardERC20(tokenAddress).balanceOf(address(this));
291         _token.transferFrom(from, address(this), amount);
292 
293         bool success;
294         assembly {
295             switch returndatasize()
296                 case 0 {
297                     // This is a non-standard ERC-20
298                     success := not(0) // set success to true
299                 }
300                 case 32 {
301                     // This is a compliant ERC-20
302                     returndatacopy(0, 0, 32)
303                     success := mload(0) // Set success = returndata of external call
304                 }
305                 default {
306                     // This is an excessively non-compliant ERC-20, revert.
307                     revert(0, 0)
308                 }
309         }
310         require(success, "TOKEN_TRANSFER_IN_FAILED");
311 
312         // Calculate the amount that was actually transferred
313         uint256 balanceAfter = INonStandardERC20(tokenAddress).balanceOf(address(this));
314         require(balanceAfter >= balanceBefore, "TOKEN_TRANSFER_IN_OVERFLOW");
315         return balanceAfter.sub(balanceBefore); // underflow already checked above, just subtract
316     }
317     
318     function doTransferOut(
319         address tokenAddress,
320         address to,
321         uint256 amount
322     ) internal {
323         INonStandardERC20 _token = INonStandardERC20(tokenAddress);
324         _token.transfer(to, amount);
325 
326         bool success;
327         assembly {
328             switch returndatasize()
329                 case 0 {
330                     // This is a non-standard ERC-20
331                     success := not(0) // set success to true
332                 }
333                 case 32 {
334                     // This is a complaint ERC-20
335                     returndatacopy(0, 0, 32)
336                     success := mload(0) // Set success = returndata of external call
337                 }
338                 default {
339                     // This is an excessively non-compliant ERC-20, revert.
340                     revert(0, 0)
341                 }
342         }
343         require(success, "TOKEN_TRANSFER_OUT_FAILED");
344     }
345     
346     
347     function fundsWithdrawal(uint256 _value) external onlyOwner isPresaleOver {
348         // claimable[owner] = claimable[owner].sub(_value);
349         // usdt.transfer(_msgSender(), _value);
350         doTransferOut(address(usdt), _msgSender(), _value);
351     }
352 
353 }