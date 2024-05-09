1 /**
2  *Submitted for verification at Etherscan.io on 2021-01-13
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity ^0.6.2;
7 
8 abstract contract Context {
9     function _msgSender() internal virtual view returns (address payable) {
10         return msg.sender;
11     }
12 
13     function _msgData() internal virtual view returns (bytes memory) {
14         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
15         return msg.data;
16     }
17 }
18 
19 contract Ownable is Context {
20     address private _owner;
21 
22     event OwnershipTransferred(
23         address indexed previousOwner,
24         address indexed newOwner
25     );
26 
27     /**
28      * @dev Initializes the contract setting the deployer as the initial owner.
29      */
30     constructor() internal {
31         address msgSender = _msgSender();
32         _owner = msgSender;
33         emit OwnershipTransferred(address(0), msgSender);
34     }
35 
36     /**
37      * @dev Returns the address of the current owner.
38      */
39     function owner() public view returns (address) {
40         return _owner;
41     }
42 
43     /**
44      * @dev Throws if called by any account other than the owner.
45      */
46     modifier onlyOwner() {
47         require(_owner == _msgSender(), "Ownable: caller is not the owner");
48         _;
49     }
50 
51     /**
52      * @dev Leaves the contract without owner. It will not be possible to call
53      * `onlyOwner` functions anymore. Can only be called by the current owner.
54      *
55      * NOTE: Renouncing ownership will leave the contract without an owner,
56      * thereby removing any functionality that is only available to the owner.
57      */
58     function renounceOwnership() public virtual onlyOwner {
59         emit OwnershipTransferred(_owner, address(0));
60         _owner = address(0);
61     }
62 
63     /**
64      * @dev Transfers ownership of the contract to a new account (`newOwner`).
65      * Can only be called by the current owner.
66      */
67     function transferOwnership(address newOwner) public virtual onlyOwner {
68         require(
69             newOwner != address(0),
70             "Ownable: new owner is the zero address"
71         );
72         emit OwnershipTransferred(_owner, newOwner);
73         _owner = newOwner;
74     }
75 }
76 
77 // import ierc20 & safemath & non-standard
78 interface IERC20 {
79     function totalSupply() external view returns (uint256);
80 
81     function balanceOf(address account) external view returns (uint256);
82 
83     function allowance(address owner, address spender)
84         external
85         view
86         returns (uint256);
87 
88     function transfer(address recipient, uint256 amount)
89         external
90         returns (bool);
91 
92     function approve(address spender, uint256 amount) external returns (bool);
93 
94     function transferFrom(
95         address sender,
96         address recipient,
97         uint256 amount
98     ) external returns (bool);
99 
100     event Transfer(address indexed from, address indexed to, uint256 value);
101     event Approval(
102         address indexed owner,
103         address indexed spender,
104         uint256 value
105     );
106 }
107 
108 library SafeMath {
109     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
110         assert(b <= a);
111         return a - b;
112     }
113 
114     function add(uint256 a, uint256 b) internal pure returns (uint256) {
115         uint256 c = a + b;
116         assert(c >= a);
117         return c;
118     }
119 
120     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
121         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
122         // benefit is lost if 'b' is also tested.
123         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
124         if (a == 0) {
125             return 0;
126         }
127 
128         uint256 c = a * b;
129         require(c / a == b, "SafeMath: multiplication overflow");
130 
131         return c;
132     }
133 
134     function div(uint256 a, uint256 b) internal pure returns (uint256) {
135         return div(a, b, "SafeMath: division by zero");
136     }
137 
138     function div(
139         uint256 a,
140         uint256 b,
141         string memory errorMessage
142     ) internal pure returns (uint256) {
143         // Solidity only automatically asserts when dividing by 0
144         require(b > 0, errorMessage);
145         uint256 c = a / b;
146         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
147 
148         return c;
149     }
150 }
151 
152 interface INonStandardERC20 {
153     function totalSupply() external view returns (uint256);
154 
155     function balanceOf(address owner) external view returns (uint256 balance);
156 
157     ///
158     /// !!!!!!!!!!!!!!
159     /// !!! NOTICE !!! transfer does not return a value, in violation of the ERC-20 specification
160     /// !!!!!!!!!!!!!!
161     ///
162 
163     function transfer(address dst, uint256 amount) external;
164 
165     ///
166     /// !!!!!!!!!!!!!!
167     /// !!! NOTICE !!! transferFrom does not return a value, in violation of the ERC-20 specification
168     /// !!!!!!!!!!!!!!
169     ///
170 
171     function transferFrom(
172         address src,
173         address dst,
174         uint256 amount
175     ) external;
176 
177     function approve(address spender, uint256 amount)
178         external
179         returns (bool success);
180 
181     function allowance(address owner, address spender)
182         external
183         view
184         returns (uint256 remaining);
185 
186     event Transfer(address indexed from, address indexed to, uint256 amount);
187     event Approval(
188         address indexed owner,
189         address indexed spender,
190         uint256 amount
191     );
192 }
193 
194 contract Launchpad  is Ownable {
195     using SafeMath for uint256;
196 
197     event ClaimableAmount(address _user, uint256 _claimableAmount);
198 
199     // address public owner;
200 
201     uint256 public rate;
202     
203     uint256 public allowedUserBalance;
204     
205     bool public presaleOver;
206     IERC20 public usdt;
207     mapping(address => uint256) public claimable;
208 
209     uint256 public hardcap;
210 
211     constructor(uint256 _rate, address _usdt, uint256 _hardcap, uint256 _allowedUserBalance) public {
212         rate = _rate;
213         usdt = IERC20(_usdt);
214         presaleOver = false;
215         // owner = msg.sender;
216         hardcap = _hardcap; 
217         allowedUserBalance = _allowedUserBalance;
218     }
219 
220     modifier isPresaleOver() {
221         require(presaleOver == true, "The presale is not over");
222         _;
223     }
224     
225     function changeHardCap(uint256 _hardcap) onlyOwner public {
226         hardcap = _hardcap;
227     }
228     
229     function changeAllowedUserBalance(uint256 _allowedUserBalance) onlyOwner public {
230         allowedUserBalance = _allowedUserBalance;
231     }
232 
233     function endPresale() external onlyOwner returns (bool) {
234         presaleOver = true;
235         return presaleOver;
236     }
237 
238     function startPresale() external onlyOwner returns (bool) {
239         presaleOver = false;
240         return presaleOver;
241     }
242 
243     function buyTokenWithUSDT(uint256 _amount) external {
244         // user enter amount of ether which is then transfered into the smart contract and tokens to be given is saved in the mapping
245         require(presaleOver == false, "presale is over you cannot buy now");
246         
247         uint256 tokensPurchased = _amount.mul(rate);
248         
249         uint256 userUpdatedBalance = claimable[msg.sender].add(tokensPurchased);
250 
251         require( _amount.add(usdt.balanceOf(address(this))) <= hardcap, "Hardcap for the tokens reached");
252 
253         // for USDT
254         require(userUpdatedBalance.div(rate) <= allowedUserBalance, "Exceeded allowed user balance");
255         
256         // usdt.transferFrom(msg.sender, address(this), _amount);
257         
258         doTransferIn(address(usdt), msg.sender, _amount);
259 
260         claimable[msg.sender] = userUpdatedBalance;
261         
262         emit ClaimableAmount(msg.sender, tokensPurchased);
263     }
264     
265     // function claim() external isPresaleOver {
266     //     // it checks for user msg.sender claimable amount and transfer them to msg.sender
267     //     require(claimable[msg.sender] > 0, "NO tokens left to be claim");
268     //     usdc.transfer(msg.sender, claimable[msg.sender]);
269     //     claimable[msg.sender] = 0;
270     // }
271     
272     function doTransferIn(
273         address tokenAddress,
274         address from,
275         uint256 amount
276     ) internal returns (uint256) {
277         INonStandardERC20 _token = INonStandardERC20(tokenAddress);
278         uint256 balanceBefore = INonStandardERC20(tokenAddress).balanceOf(address(this));
279         _token.transferFrom(from, address(this), amount);
280 
281         bool success;
282         assembly {
283             switch returndatasize()
284                 case 0 {
285                     // This is a non-standard ERC-20
286                     success := not(0) // set success to true
287                 }
288                 case 32 {
289                     // This is a compliant ERC-20
290                     returndatacopy(0, 0, 32)
291                     success := mload(0) // Set success = returndata of external call
292                 }
293                 default {
294                     // This is an excessively non-compliant ERC-20, revert.
295                     revert(0, 0)
296                 }
297         }
298         require(success, "TOKEN_TRANSFER_IN_FAILED");
299 
300         // Calculate the amount that was actually transferred
301         uint256 balanceAfter = INonStandardERC20(tokenAddress).balanceOf(address(this));
302         require(balanceAfter >= balanceBefore, "TOKEN_TRANSFER_IN_OVERFLOW");
303         return balanceAfter.sub(balanceBefore); // underflow already checked above, just subtract
304     }
305     
306     function doTransferOut(
307         address tokenAddress,
308         address to,
309         uint256 amount
310     ) internal {
311         INonStandardERC20 _token = INonStandardERC20(tokenAddress);
312         _token.transfer(to, amount);
313 
314         bool success;
315         assembly {
316             switch returndatasize()
317                 case 0 {
318                     // This is a non-standard ERC-20
319                     success := not(0) // set success to true
320                 }
321                 case 32 {
322                     // This is a complaint ERC-20
323                     returndatacopy(0, 0, 32)
324                     success := mload(0) // Set success = returndata of external call
325                 }
326                 default {
327                     // This is an excessively non-compliant ERC-20, revert.
328                     revert(0, 0)
329                 }
330         }
331         require(success, "TOKEN_TRANSFER_OUT_FAILED");
332     }
333     
334     
335     function fundsWithdrawal(uint256 _value) external onlyOwner isPresaleOver {
336         // claimable[owner] = claimable[owner].sub(_value);
337         // usdt.transfer(_msgSender(), _value);
338         doTransferOut(address(usdt), _msgSender(), _value);
339     }
340 
341 }