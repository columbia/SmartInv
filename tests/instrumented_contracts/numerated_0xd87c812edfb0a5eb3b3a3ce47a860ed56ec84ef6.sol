1 /**
2  *Submitted for verification at Etherscan.io on 2022-08-13
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity 0.8.16;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Emitted when `value` tokens are moved from one account (`from`) to
14      * another (`to`).
15      *
16      * Note that `value` may be zero.
17      */
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     /**
21      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
22      * a call to {approve}. `value` is the new allowance.
23      */
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 
26     /**
27      * @dev Returns the amount of tokens in existence.
28      */
29     function totalSupply() external view returns (uint256);
30 
31     /**
32      * @dev Returns the amount of tokens owned by `account`.
33      */
34     function balanceOf(address account) external view returns (uint256);
35 
36     /**
37      * @dev Moves `amount` tokens from the caller's account to `to`.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * Emits a {Transfer} event.
42      */
43     function transfer(address to, uint256 amount) external returns (bool);
44 
45     /**
46      * @dev Returns the remaining number of tokens that `spender` will be
47      * allowed to spend on behalf of `owner` through {transferFrom}. This is
48      * zero by default.
49      *
50      * This value changes when {approve} or {transferFrom} are called.
51      */
52     function allowance(address owner, address spender) external view returns (uint256);
53 
54     /**
55      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * IMPORTANT: Beware that changing an allowance with this method brings the risk
60      * that someone may use both the old and the new allowance by unfortunate
61      * transaction ordering. One possible solution to mitigate this race
62      * condition is to first reduce the spender's allowance to 0 and set the
63      * desired value afterwards:
64      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
65      *
66      * Emits an {Approval} event.
67      */
68     function approve(address spender, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Moves `amount` tokens from `from` to `to` using the
72      * allowance mechanism. `amount` is then deducted from the caller's
73      * allowance.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * Emits a {Transfer} event.
78      */
79     function transferFrom(
80         address from,
81         address to,
82         uint256 amount
83     ) external returns (bool);
84 }
85 
86 /**
87  * @dev Provides information about the current execution context, including the
88  * sender of the transaction and its data. While these are generally available
89  * via msg.sender and msg.data, they should not be accessed in such a direct
90  * manner, since when dealing with meta-transactions the account sending and
91  * paying for execution may not be the actual sender (as far as an application
92  * is concerned).
93  *
94  * This contract is only required for intermediate, library-like contracts.
95  */
96 abstract contract Context {
97     function _msgSender() internal view virtual returns (address) {
98         return msg.sender;
99     }
100 
101     function _msgData() internal view virtual returns (bytes calldata) {
102         return msg.data;
103     }
104 }
105 
106 /**
107  * @dev Contract module which provides a basic access control mechanism, where
108  * there is an account (an owner) that can be granted exclusive access to
109  * specific functions.
110  *
111  * By default, the owner account will be the one that deploys the contract. This
112  * can later be changed with {transferOwnership}.
113  *
114  * This module is used through inheritance. It will make available the modifier
115  * `onlyOwner`, which can be applied to your functions to restrict their use to
116  * the owner.
117  */
118 abstract contract Ownable is Context {
119     address private _owner;
120 
121     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
122 
123     /**
124      * @dev Initializes the contract setting the deployer as the initial owner.
125      */
126     constructor() {
127         _transferOwnership(_msgSender());
128     }
129 
130     /**
131      * @dev Returns the address of the current owner.
132      */
133     function owner() public view virtual returns (address) {
134         return _owner;
135     }
136 
137     /**
138      * @dev Throws if called by any account other than the owner.
139      */
140     modifier onlyOwner() {
141         require(owner() == _msgSender(), "Ownable: caller is not the owner");
142         _;
143     }
144 
145     /**
146      * @dev Leaves the contract without owner. It will not be possible to call
147      * `onlyOwner` functions anymore. Can only be called by the current owner.
148      *
149      * NOTE: Renouncing ownership will leave the contract without an owner,
150      * thereby removing any functionality that is only available to the owner.
151      */
152     function renounceOwnership() public virtual onlyOwner {
153         _transferOwnership(address(0));
154     }
155 
156     /**
157      * @dev Transfers ownership of the contract to a new account (`newOwner`).
158      * Can only be called by the current owner.
159      */
160     function transferOwnership(address newOwner) public virtual onlyOwner {
161         require(newOwner != address(0), "Ownable: new owner is the zero address");
162         _transferOwnership(newOwner);
163     }
164 
165     /**
166      * @dev Transfers ownership of the contract to a new account (`newOwner`).
167      * Internal function without access restriction.
168      */
169     function _transferOwnership(address newOwner) internal virtual {
170         address oldOwner = _owner;
171         _owner = newOwner;
172         emit OwnershipTransferred(oldOwner, newOwner);
173     }
174 }
175 
176 contract Router {
177   function swapExactTokensForTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts) {}
178 }
179 
180 contract MigrateERC20 is Ownable{    
181     
182     Router router; 
183     IERC20 token_old;
184     IERC20 token_new;            
185     address[] tokenPath;
186 
187     uint256 public balanceIn;
188     uint256 public balanceOut;
189     uint256 public exchangeRatio;    
190         
191     uint8 public migrationStage;
192 
193     /**
194     * @dev Constructor defines old, new, exchange ratio and the path to swap tokens on advanced migration stage.
195     * @param _token_old ERC20 token thats is no longer used. 
196     * @param _token_new ERC20 token that will be used from now.
197     **/ 
198     constructor(address _token_old, address _token_new, address _router){
199         token_old = IERC20(_token_old);
200         token_new = IERC20(_token_new);   
201 
202         exchangeRatio = 10000;        
203         
204         tokenPath = new address[](2);
205             tokenPath[0] = address(token_old);
206             tokenPath[1] = address(token_new);
207 
208         router = Router(_router);
209     }
210 
211     /**
212     * @dev Set tokens involved in the migration processed. 
213     * @param _token_old ERC20 token thats is no longer used.
214     * @param _token_new ERC20 token that will be used from now.
215     */
216     function setTokens(address _token_old, address _token_new) external onlyOwner {
217         token_old = IERC20(_token_old);
218         token_new = IERC20(_token_new);         
219         
220         tokenPath = new address[](2);
221             tokenPath[0] = address(token_old);
222             tokenPath[1] = address(token_new);
223     }    
224 
225     /**
226     * @dev Set exchange ratio.
227     * @param _exchangeRatio Qty of new tokens to be given per 1 old token received.
228     *   Note: as Solidity don't accept decimal numbers 100 = 1 token, 50 = 0.5 token, 1000 = 10 tokens. 
229     */
230     function setExchangeRatio(uint256 _exchangeRatio) external onlyOwner{
231         exchangeRatio = _exchangeRatio;
232     }
233 
234     /**
235     * @dev Set the migration stage to decide what path the smart contract should follow.
236     * @param _migrationStage 0: Disabled, 1: Simple, 2: Exchange on Uniswap.
237     */
238     function setMigrationStage(uint8 _migrationStage) external onlyOwner {
239         require(_migrationStage == 0 || _migrationStage == 1 || _migrationStage == 2, "Invalid migration stage");
240         migrationStage = _migrationStage;
241     }
242 
243     /**
244     * @dev Get the address of the old token.
245     */
246     function getTokenOld() public view returns (address) {
247         return address(token_old);
248     }
249 
250     /**
251     * @dev Get the address of the new token.
252     */
253     function getTokenNew() public view returns (address) {
254         return address(token_new);
255     }
256 
257     /**
258     * @dev Start the migration process.
259     * @param _amount amount of olds tokens to be exchanged for the new one.
260     */
261     function migrate(uint256 _amount) public {
262         require(migrationStage != 0, "Migration has not started or has ended.");        
263 
264         if(migrationStage == 1){
265             migrationSimple(_amount);
266         }else{
267             migrationAdvanced(_amount);
268         }
269     }
270 
271     function migrationSimple(uint256 _amount) internal {    
272 
273         uint256 _newAmount = ((_amount * 1e9) * exchangeRatio) / 100; 
274         require(_newAmount <= token_new.balanceOf(address(this)), "Contract does not have enough V2 funds.");
275 
276         token_old.transferFrom(msg.sender, address(this), _amount);          
277         token_new.transfer(msg.sender, _newAmount);
278         balanceIn += _amount;
279         balanceOut += _newAmount;
280     }
281 
282     function migrationAdvanced(uint256 _amount) internal {
283         token_old.transferFrom(msg.sender, address(this), _amount);   
284         token_old.approve(address(this), _amount);         
285         uint[] memory amounts = router.swapExactTokensForTokens(_amount, 0, tokenPath, address(this), block.timestamp + 6);
286         token_new.transfer(msg.sender, amounts[2]);
287         balanceIn += _amount;
288         balanceOut += amounts[2];
289     }
290 
291     function withdrawRaisedTokens() external onlyOwner {        
292         uint256 oldTokenBalance = token_old.balanceOf(address(this));
293         token_old.transfer(msg.sender, oldTokenBalance);
294     }
295 
296     function withdrawUnclaimedTokens() external onlyOwner {
297         uint256 newTokenBalance = token_new.balanceOf(address(this));
298         token_new.transfer(msg.sender, newTokenBalance);
299     }
300 
301     function withdrawEther() external onlyOwner {
302         uint256 etherBalance = address(this).balance;
303         payable(msg.sender).transfer(etherBalance);
304     }
305 
306 }