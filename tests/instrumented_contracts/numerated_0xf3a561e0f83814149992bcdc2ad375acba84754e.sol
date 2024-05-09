1 /*
2 ABN = AutoBurn token
3 Deflationary. Low gas. Made simple.
4 
5 This token has decreasing supply and increasing price achieved by 3% burn and 3% added 
6 to liquidity on each transaction except wallet to wallet transactions (non-contract).
7 This is done by direct balance adjustments which are much cheaper than calling external 
8 methods for sell, add liquidity and mint LP tokens functions on each trade. The pool 
9 is verified to stay in sync despite no additional LP tokens are minted or burned, 
10 proportionally rewarding any additional liquidity providers.
11 
12 Price is driven up every day by burning 3% of ABN from liquidity pool while keeping WETH there
13 intact. Wallet and other pool balances are not daily burn, only WETH-ABN pool is affected.
14 
15 Net size of a single transaction is limited to 1% of available supply, no limit on balances
16 and no limit for wallet to wallet transactions (non-contract).
17 
18 If you get "error:undefined" on swap or "confirm" button is dead:
19 Check slippage, increase to 7%.
20 Set exact amount for ABN, not for the counterparty.
21 Check token available supply, 1% bought at once may be later sold in 2 or more transactions if
22 some supply was burn in meantime.
23 
24 Tip to remove liquidity: Save one transaction fee by removing liquidity to WETH instead of ETH.
25 
26 Disclaimer: This is an experimental project. DYOR and read contract code thoroughly before trading.
27 Check liquidity distribution and lock duration.
28 Deployer has no liability, direct or indirectly implied, of any loss or damage caused by bugs in
29 code or EVM, Solidity vulnerabilities, bot activity or malicious behavior of token holders.
30 
31 */
32 
33 
34 //SPDX-License-Identifier: UNLICENSED
35 // License: Parts different from open-zeppelin implementations are copyrighted. Any clones should send a 0.3% of tx value to deployer of this contract provided the tx is not considered feeless here.
36 pragma solidity =0.7.6;
37 
38 abstract contract Context {
39     function _msgSender() internal view virtual returns (address payable) {
40         return msg.sender;
41     }
42 
43     function _msgData() internal view virtual returns (bytes memory) {
44         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
45         return msg.data;
46     }
47 }
48 
49 interface IERC20 {
50     function totalSupply() external view returns (uint256);
51     function balanceOf(address account) external view returns (uint256);
52     function transfer(address recipient, uint256 amount) external returns (bool);
53     function allowance(address owner, address spender) external view returns (uint256);
54     function approve(address spender, uint256 amount) external returns (bool);
55     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
56     function increaseAllowance(address spender, uint256 addedValue) external returns (bool);
57     function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool);
58     event Transfer(address indexed from, address indexed to, uint256 value);
59     event Approval(address indexed owner, address indexed spender, uint256 value);
60     function burn(uint256 amount) external returns (bool);
61     function burnFrom(address account, uint256 amount) external returns (bool);
62 }
63 
64 interface UNIV2Sync {
65     function sync() external;
66 }
67 
68 interface IWETH {
69     function deposit() external payable;
70     function balanceOf(address _owner) external returns (uint256);
71     function transfer(address _to, uint256 _value) external returns (bool);
72     function withdraw(uint256 _amount) external;
73 }
74 
75 
76 
77 library SafeMath {
78     function add(uint256 a, uint256 b) internal pure returns (uint256) {
79         uint256 c = a + b;
80         require(c >= a, "SafeMath: addition overflow");
81         return c;
82     }
83     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
84         return sub(a, b, "SafeMath: subtraction overflow");
85     }
86     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
87         require(b <= a, errorMessage);
88         uint256 c = a - b;
89         return c;
90     }
91     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
92         if (a == 0) {
93             return 0;
94         }
95         uint256 c = a * b;
96         require(c / a == b, "SafeMath: multiplication overflow");
97         return c;
98     }
99     function div(uint256 a, uint256 b) internal pure returns (uint256) {
100         return div(a, b, "SafeMath: division by zero");
101     }
102     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
103         require(b > 0, errorMessage);
104         uint256 c = a / b;
105         return c;
106     }
107     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
108         return mod(a, b, "SafeMath: modulo by zero");
109     }
110     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
111         require(b != 0, errorMessage);
112         return a % b;
113     }
114 }
115 
116 
117 library Address {
118     function isContract(address account) internal view returns (bool) {
119         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
120         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
121         // for accounts without code, i.e. `keccak256('')`
122         bytes32 codehash;
123         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
124         // solhint-disable-next-line no-inline-assembly
125         assembly { codehash := extcodehash(account) }
126         return (codehash != accountHash && codehash != 0x0);
127     }
128     function sendValue(address payable recipient, uint256 amount) internal {
129         require(address(this).balance >= amount, "Address: insufficient balance");
130         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
131         (bool success, ) = recipient.call{ value: amount }("");
132         require(success, "Address: unable to send value, recipient may have reverted");
133     }
134     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
135       return functionCall(target, data, "Address: low-level call failed");
136     }
137     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
138         return _functionCallWithValue(target, data, 0, errorMessage);
139     }
140     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
141         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
142     }
143     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
144         require(address(this).balance >= value, "Address: insufficient balance for call");
145         return _functionCallWithValue(target, data, value, errorMessage);
146     }
147     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
148         require(isContract(target), "Address: call to non-contract");
149         // solhint-disable-next-line avoid-low-level-calls
150         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
151         if (success) {
152             return returndata;
153         } else {
154             // Look for revert reason and bubble it up if present
155             if (returndata.length > 0) {
156                 // The easiest way to bubble the revert reason is using memory via assembly
157                 // solhint-disable-next-line no-inline-assembly
158                 assembly {
159                     let returndata_size := mload(returndata)
160                     revert(add(32, returndata), returndata_size)
161                 }
162             } else {
163                 revert(errorMessage);
164             }
165         }
166     }
167 }
168 
169 
170 /*
171  * An {Approval} event is emitted on calls to {transferFrom}.
172  * This allows applications to reconstruct the allowance for all accounts just
173  * by listening to said events. Other implementations of the EIP may not emit
174  * these events, as it isn't required by the specification.
175  *
176  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
177  * functions have been added to mitigate the well-known issues around setting
178  * allowances. See {IERC20-approve}.
179  */
180 contract DeflationaryERC20 is Context, IERC20 {
181     using SafeMath for uint256;
182     using Address for address;
183 
184     mapping (address => uint256) private _balances;
185     mapping (address => mapping (address => uint256)) private _allowances;
186 
187     uint256 private _totalSupply;
188 
189     string private _name;
190     string private _symbol;
191     uint8 private _decimals;
192     address private _deployer;
193     uint256 public lastPoolBurnTime;
194     uint256 public epoch;
195 
196     // Transaction Fees:
197     uint8 public txFee = 6; // total in %, half will burn and half adds to liquidity
198     address public feeDistributor; // fees are sent to fee distributor = uniswap pool
199     address public wethContract; // wrap ethers sent to contract to increase liquidity
200 
201     constructor (string memory __name, string memory __symbol)  {
202         _name = __name;
203         _symbol = __symbol;
204         _decimals = 6;
205         _deployer = tx.origin;
206         epoch = 86400;
207         wethContract=0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
208         lastPoolBurnTime = block.timestamp.div(epoch).mul(epoch); //set time part to midnight UTC
209     }
210     function name() public view returns (string memory) {
211         return _name;
212     }
213     function symbol() public view returns (string memory) {
214         return _symbol;
215     }
216     function decimals() public view returns (uint8) {
217         return _decimals;
218     }
219     function totalSupply() public view override returns (uint256) {
220         return _totalSupply;
221     }
222     function balanceOf(address account) public view override returns (uint256) {
223         return _balances[account];
224     }
225     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
226         _transfer(_msgSender(), recipient, amount);
227         return true;
228     }
229     function allowance(address owner, address spender) public view virtual override returns (uint256) {
230         return _allowances[owner][spender];
231     }
232     function approve(address spender, uint256 amount) public virtual override returns (bool) {
233         _approve(_msgSender(), spender, amount);
234         return true;
235     }
236     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
237         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
238         _transfer(sender, recipient, amount);
239         return true;
240     }
241     function increaseAllowance(address spender, uint256 addedValue) public virtual override returns (bool) {
242         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
243         return true;
244     }
245     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual override returns (bool) {
246         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
247         return true;
248     }
249     function countdownPoolBurnDue() public view returns (uint256) {
250           return ((lastPoolBurnTime.add(epoch))>block.timestamp?(lastPoolBurnTime.add(epoch).sub(block.timestamp)):0);
251     }
252 
253     //Important: Due to checks made during swap process avoid calling this method inside a swap transaction.
254     function PoolBurnAndSync() public virtual returns (bool) {
255         // Burns any token balance donated to the contract (always)
256         if (_balances[address(this)] > 0) {
257             _burn(address(this),_balances[address(this)]);
258         }
259         //Convert any ETH to WETH (always).
260         uint256 amountETH = address(this).balance;
261         if (amountETH > 0) {
262             IWETH(wethContract).deposit{value : amountETH}();
263         }
264         //Checks pool address and time since last pool burn
265         if (countdownPoolBurnDue() == 0 && feeDistributor != address(0)) {
266             lastPoolBurnTime = lastPoolBurnTime.add(epoch);
267             //Burns 3% from pool address
268             if (_balances[feeDistributor] > 100) {
269                 _burn(feeDistributor,_balances[feeDistributor].mul(3).div(100));
270             }
271         }
272         //Calls sync anytime it's not a swap. Swaps sync at the end automatically.
273         if(feeDistributor != address(0)) {
274             //Gets weth balance
275             uint256 amountWETH =  IWETH(wethContract).balanceOf(address(this));
276             //Sends weth to pool
277             if (amountWETH > 0) {
278                 IWETH(wethContract).transfer(feeDistributor, amountWETH);
279             }
280             UNIV2Sync(feeDistributor).sync(); //important to reflect updated price
281         }
282         return true;
283     }
284 
285     // assign a new pool address, enforce deflationary features and renounce ownership
286     function setFeeDistributor(address _distributor) public {
287         require(tx.origin == _deployer, "Not from deployer");
288         require(feeDistributor == address(0), "Pool: Address immutable once set");
289         feeDistributor = _distributor;
290     }
291 
292     // to caclulate the amounts for recipient and distributer after fees have been applied
293     function calculateAmountsAfterFee(
294         address sender,
295         address recipient,
296         uint256 amount
297     ) public view returns (uint256 transferToAmount, uint256 transferToFeeDistributorAmount, uint256 burnAmount) {
298         // check if fees should apply to this transaction
299         if (sender.isContract() || recipient.isContract()) {
300             // calculate fees and amounts if any address is an active contract
301             uint256 fee = amount.mul(txFee).div(100);
302             uint256 burnFee = fee.div(2);
303             return (amount.sub(fee), fee.sub(burnFee),burnFee);
304         }
305         return (amount, 0, 0);
306     }
307 
308     function burnFrom(address account,uint256 amount) public virtual override returns (bool) {
309         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
310         _burn(account, amount);
311         return true;
312     }
313 
314     function burn(uint256 amount) public virtual override returns (bool) {
315         _burn(_msgSender(), amount);
316         return true;
317     }
318 
319     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
320         require(sender != address(0), "ERC20: transfer from the zero address");
321         require(recipient != address(0), "ERC20: transfer to the zero address");
322         require(amount >= 100, "amount below 100 base units, avoiding underflows");
323         _beforeTokenTransfer(sender, recipient, amount);
324         // calculate fee:
325         (uint256 transferToAmount, uint256 transferToFeeDistributorAmount,uint256 burnAmount) = calculateAmountsAfterFee(sender, recipient, amount);
326         // subtract net amount, keep amount for fees to be subtracted later
327         _balances[sender] = _balances[sender].sub(transferToAmount, "ERC20: transfer amount exceeds balance");
328         // update recipients balance:
329         _balances[recipient] = _balances[recipient].add(transferToAmount);
330         emit Transfer(sender, recipient, transferToAmount);
331         // update pool balance, limit max tx once pool contract is known and funded
332         if(transferToFeeDistributorAmount > 0 && feeDistributor != address(0)){
333             require(_totalSupply.div(transferToAmount) >= 99, "max single trade 1% of current total supply");
334             _burn(sender,burnAmount);
335             _balances[sender] = _balances[sender].sub(transferToFeeDistributorAmount, "ERC20: fee transfer amount exceeds remaining balance");
336             _balances[feeDistributor] = _balances[feeDistributor].add(transferToFeeDistributorAmount);
337             emit Transfer(sender, feeDistributor, transferToFeeDistributorAmount);
338             //Sync is made automatically at the end of swap transaction,  doing it earlier reverts the swap
339         } else {
340             //Since there may be relayers like 1inch allow sync on feeless txs only
341             PoolBurnAndSync();
342         }
343     }
344 
345     function _mint(address account, uint256 amount) internal virtual {
346         require(_totalSupply == 0, "Mint: Not an initial supply mint");
347         require(account != address(0), "ERC20: mint to the zero address");
348         _beforeTokenTransfer(address(0), account, amount);
349         _totalSupply = _totalSupply.add(amount);
350         _balances[account] = _balances[account].add(amount);
351         emit Transfer(address(0), account, amount);
352     }
353 
354     function _burn(address account, uint256 amount) internal virtual {
355         require(account != address(0), "ERC20: burn from the zero address");
356         _beforeTokenTransfer(account, address(0), amount);
357         if(amount != 0) {
358             _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
359             _totalSupply = _totalSupply.sub(amount);
360             emit Transfer(account, address(0), amount);
361         }
362     }
363 
364     function _approve(address owner, address spender, uint256 amount) internal virtual {
365         require(owner != address(0), "ERC20: approve from the zero address");
366         require(spender != address(0), "ERC20: approve to the zero address");
367         _allowances[owner][spender] = amount;
368         emit Approval(owner, spender, amount);
369     }
370 
371     /**
372      * Hook that is called before any transfer of tokens. This includes minting and burning.
373      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
374      */
375     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
376     //Before sennding ether to this contract ensure gas cost is estimated properly
377     receive() external payable {
378        PoolBurnAndSync();
379     }
380 }
381 
382 /**
383  * ABN is a token designed to implement pool inflation and supply deflation using simplified way of transferring or burning 
384  * fees manually and then forcing Uniswap pool to resync balances instead of costly sell, add liquidity and mint LP tokens.
385  * The ABN Token itself is just a standard ERC20, with:
386  * No minting.
387  * Public burning.
388  * Transfer fee applied. Fixed to 3% into pool + 3% burn.
389  */
390 contract AutoBurnToken is DeflationaryERC20 {
391     constructor()  DeflationaryERC20("AutoBurn", "ABN") {
392         // maximum supply   = 100000 whole units with decimals = 6
393         _mint(msg.sender, 100000e6);
394     }
395 }