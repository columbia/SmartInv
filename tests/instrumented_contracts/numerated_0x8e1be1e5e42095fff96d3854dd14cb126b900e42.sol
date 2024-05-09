1 /**
2  *Submitted for verification at Etherscan.io on 2021-03-12
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-01-13
7 */
8 
9 // SPDX-License-Identifier: MIT
10 pragma solidity ^0.6.2;
11 
12 abstract contract Context {
13     function _msgSender() internal virtual view returns (address payable) {
14         return msg.sender;
15     }
16 
17     function _msgData() internal virtual view returns (bytes memory) {
18         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
19         return msg.data;
20     }
21 }
22 
23 contract Ownable is Context {
24     address private _owner;
25 
26     event OwnershipTransferred(
27         address indexed previousOwner,
28         address indexed newOwner
29     );
30 
31     /**
32      * @dev Initializes the contract setting the deployer as the initial owner.
33      */
34     constructor() internal {
35         address msgSender = _msgSender();
36         _owner = msgSender;
37         emit OwnershipTransferred(address(0), msgSender);
38     }
39 
40     /**
41      * @dev Returns the address of the current owner.
42      */
43     function owner() public view returns (address) {
44         return _owner;
45     }
46 
47     /**
48      * @dev Throws if called by any account other than the owner.
49      */
50     modifier onlyOwner() {
51         require(_owner == _msgSender(), "Ownable: caller is not the owner");
52         _;
53     }
54 
55     /**
56      * @dev Leaves the contract without owner. It will not be possible to call
57      * `onlyOwner` functions anymore. Can only be called by the current owner.
58      *
59      * NOTE: Renouncing ownership will leave the contract without an owner,
60      * thereby removing any functionality that is only available to the owner.
61      */
62     function renounceOwnership() public virtual onlyOwner {
63         emit OwnershipTransferred(_owner, address(0));
64         _owner = address(0);
65     }
66 
67     /**
68      * @dev Transfers ownership of the contract to a new account (`newOwner`).
69      * Can only be called by the current owner.
70      */
71     function transferOwnership(address newOwner) public virtual onlyOwner {
72         require(
73             newOwner != address(0),
74             "Ownable: new owner is the zero address"
75         );
76         emit OwnershipTransferred(_owner, newOwner);
77         _owner = newOwner;
78     }
79 }
80 
81 // import ierc20 & safemath & non-standard
82 interface IERC20 {
83     function totalSupply() external view returns (uint256);
84 
85     function balanceOf(address account) external view returns (uint256);
86 
87     function allowance(address owner, address spender)
88         external
89         view
90         returns (uint256);
91 
92     function transfer(address recipient, uint256 amount)
93         external
94         returns (bool);
95 
96     function approve(address spender, uint256 amount) external returns (bool);
97 
98     function transferFrom(
99         address sender,
100         address recipient,
101         uint256 amount
102     ) external returns (bool);
103 
104     event Transfer(address indexed from, address indexed to, uint256 value);
105     event Approval(
106         address indexed owner,
107         address indexed spender,
108         uint256 value
109     );
110 }
111 
112 library SafeMath {
113     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
114         assert(b <= a);
115         return a - b;
116     }
117 
118     function add(uint256 a, uint256 b) internal pure returns (uint256) {
119         uint256 c = a + b;
120         assert(c >= a);
121         return c;
122     }
123 
124     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
125         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
126         // benefit is lost if 'b' is also tested.
127         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
128         if (a == 0) {
129             return 0;
130         }
131 
132         uint256 c = a * b;
133         require(c / a == b, "SafeMath: multiplication overflow");
134 
135         return c;
136     }
137 
138     function div(uint256 a, uint256 b) internal pure returns (uint256) {
139         return div(a, b, "SafeMath: division by zero");
140     }
141 
142     function div(
143         uint256 a,
144         uint256 b,
145         string memory errorMessage
146     ) internal pure returns (uint256) {
147         // Solidity only automatically asserts when dividing by 0
148         require(b > 0, errorMessage);
149         uint256 c = a / b;
150         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
151 
152         return c;
153     }
154 }
155 
156 interface INonStandardERC20 {
157     function totalSupply() external view returns (uint256);
158 
159     function balanceOf(address owner) external view returns (uint256 balance);
160 
161     ///
162     /// !!!!!!!!!!!!!!
163     /// !!! NOTICE !!! transfer does not return a value, in violation of the ERC-20 specification
164     /// !!!!!!!!!!!!!!
165     ///
166 
167     function transfer(address dst, uint256 amount) external;
168 
169     ///
170     /// !!!!!!!!!!!!!!
171     /// !!! NOTICE !!! transferFrom does not return a value, in violation of the ERC-20 specification
172     /// !!!!!!!!!!!!!!
173     ///
174 
175     function transferFrom(
176         address src,
177         address dst,
178         uint256 amount
179     ) external;
180 
181     function approve(address spender, uint256 amount)
182         external
183         returns (bool success);
184 
185     function allowance(address owner, address spender)
186         external
187         view
188         returns (uint256 remaining);
189 
190     event Transfer(address indexed from, address indexed to, uint256 amount);
191     event Approval(
192         address indexed owner,
193         address indexed spender,
194         uint256 amount
195     );
196 }
197 
198 contract Launchpad  is Ownable {
199     using SafeMath for uint256;
200 
201     event ClaimableAmount(address _user, uint256 _claimableAmount);
202 
203     // address public owner;
204 
205     uint256 public rate;
206     
207     uint256 public allowedUserBalance;
208     
209     bool public presaleOver;
210     IERC20 public usdt;
211     mapping(address => uint256) public claimable;
212 
213     uint256 public hardcap;
214 
215     constructor(uint256 _rate, address _usdt, uint256 _hardcap, uint256 _allowedUserBalance) public {
216         rate = _rate;
217         usdt = IERC20(_usdt);
218         presaleOver = true;
219         // owner = msg.sender;
220         hardcap = _hardcap; 
221         allowedUserBalance = _allowedUserBalance;
222     }
223 
224     modifier isPresaleOver() {
225         require(presaleOver == true, "The presale is not over");
226         _;
227     }
228     
229     function changeHardCap(uint256 _hardcap) onlyOwner public {
230         hardcap = _hardcap;
231     }
232     
233     function changeAllowedUserBalance(uint256 _allowedUserBalance) onlyOwner public {
234         allowedUserBalance = _allowedUserBalance;
235     }
236 
237     function endPresale() external onlyOwner returns (bool) {
238         presaleOver = true;
239         return presaleOver;
240     }
241 
242     function startPresale() external onlyOwner returns (bool) {
243         presaleOver = false;
244         return presaleOver;
245     }
246 
247     function buyTokenWithUSDT(uint256 _amount) external {
248         // user enter amount of ether which is then transfered into the smart contract and tokens to be given is saved in the mapping
249         require(presaleOver == false, "presale is over you cannot buy now");
250         
251         uint256 tokensPurchased = _amount.mul(rate);
252         
253         uint256 userUpdatedBalance = claimable[msg.sender].add(tokensPurchased);
254 
255         require( _amount.add(usdt.balanceOf(address(this))) <= hardcap, "Hardcap for the tokens reached");
256 
257         // for USDT
258         require(userUpdatedBalance.div(rate) <= allowedUserBalance, "Exceeded allowed user balance");
259         
260         // usdt.transferFrom(msg.sender, address(this), _amount);
261         
262         doTransferIn(address(usdt), msg.sender, _amount);
263 
264         claimable[msg.sender] = userUpdatedBalance;
265         
266         emit ClaimableAmount(msg.sender, tokensPurchased);
267     }
268     
269     // function claim() external isPresaleOver {
270     //     // it checks for user msg.sender claimable amount and transfer them to msg.sender
271     //     require(claimable[msg.sender] > 0, "NO tokens left to be claim");
272     //     usdc.transfer(msg.sender, claimable[msg.sender]);
273     //     claimable[msg.sender] = 0;
274     // }
275     
276     function doTransferIn(
277         address tokenAddress,
278         address from,
279         uint256 amount
280     ) internal returns (uint256) {
281         INonStandardERC20 _token = INonStandardERC20(tokenAddress);
282         uint256 balanceBefore = INonStandardERC20(tokenAddress).balanceOf(address(this));
283         _token.transferFrom(from, address(this), amount);
284 
285         bool success;
286         assembly {
287             switch returndatasize()
288                 case 0 {
289                     // This is a non-standard ERC-20
290                     success := not(0) // set success to true
291                 }
292                 case 32 {
293                     // This is a compliant ERC-20
294                     returndatacopy(0, 0, 32)
295                     success := mload(0) // Set success = returndata of external call
296                 }
297                 default {
298                     // This is an excessively non-compliant ERC-20, revert.
299                     revert(0, 0)
300                 }
301         }
302         require(success, "TOKEN_TRANSFER_IN_FAILED");
303 
304         // Calculate the amount that was actually transferred
305         uint256 balanceAfter = INonStandardERC20(tokenAddress).balanceOf(address(this));
306         require(balanceAfter >= balanceBefore, "TOKEN_TRANSFER_IN_OVERFLOW");
307         return balanceAfter.sub(balanceBefore); // underflow already checked above, just subtract
308     }
309     
310     function doTransferOut(
311         address tokenAddress,
312         address to,
313         uint256 amount
314     ) internal {
315         INonStandardERC20 _token = INonStandardERC20(tokenAddress);
316         _token.transfer(to, amount);
317 
318         bool success;
319         assembly {
320             switch returndatasize()
321                 case 0 {
322                     // This is a non-standard ERC-20
323                     success := not(0) // set success to true
324                 }
325                 case 32 {
326                     // This is a complaint ERC-20
327                     returndatacopy(0, 0, 32)
328                     success := mload(0) // Set success = returndata of external call
329                 }
330                 default {
331                     // This is an excessively non-compliant ERC-20, revert.
332                     revert(0, 0)
333                 }
334         }
335         require(success, "TOKEN_TRANSFER_OUT_FAILED");
336     }
337     
338     
339     function fundsWithdrawal(uint256 _value) external onlyOwner isPresaleOver {
340         // claimable[owner] = claimable[owner].sub(_value);
341         // usdt.transfer(_msgSender(), _value);
342         doTransferOut(address(usdt), _msgSender(), _value);
343     }
344 
345 }