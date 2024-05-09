1 /*
2 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
3 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
4 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
5 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
6 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
7 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
8 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
9 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ .@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
10 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ : @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     @@@@@@@@@@@@@@       @@@@@@           @@@@@@                 @
11 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.: @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@              @@@@@@@@@@@@  ....                                       .   
12 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ :  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    .:--------          @@@  ---: .--------------:  --------------: :--.--: 
13 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.:. @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  .-------:---     .: : @@@  ---: .--------------- :--------------- :-----. 
14 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ::. @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  -------- ---:  :--- : @@@  ---: :--------------- :--------------- .-----. 
15 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ .:.  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   ----    ---  .---.: @@@  ---: ------           :-----            -----  
16 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@..:. :@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   ---- @  ----  ---:- @@@ .---:    --- @@@@@@@@@    --- @@@@@@@@@  -----  
17 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.:::..@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ---- @  -:--   ---- @@@ :---:- @ --- @@@@@@@@@@@@ --- @@@@@@@@@  -----  
18 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.:-:. @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ---- @  -----  ---- @@@ ------ @ --- @@@@@@@@@@@@ --- @@@@@@@@@  -----  
19 @@@@@@@@@@@@@@@@@ @@@@@@@@@@@@@@@@@@@:--:. .@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ----    ----   ---- @@@ ------ @ ---           @@ ---            -----  
20 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ @@@@:--:.... @ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ----    ---- @ ---- @@@ -:---- @ ---     ....  @@ ---     .....  -----  
21 @@@@@@@@@@@@@@@@ @@@@@@@@@@  : ::::..:--::::-..... @@@@@@@@@@@@@@@@@@@@@@@@@@ -----------  @ ---- @@@ -.---- @ ------------. @@ ------------.  -----  
22 @@@@@@@@@@@@@@@@@@@@@@@@@ :.::-+===-=:==---=+-:-:.:.@@@@@@@@@@@@@@@@@@@@@@@@@ ----------: @@ ----  @@ - ---- @ ------------. @@ ------------.  -----  
23 @@@@@@@@@@@@@@@@@@@@ .. ::---=-#*=+-=-=+==-+++=-::-:.  @@@@@@@@@@@@@@@@@@@@@@ ----------  @@ ----  @@ - ---- @ ------------. @@ ------------.  -----  
24 @@@@@@@@@@@@@@@@@@  :::::++*+#+#===++-++++=-=+++=:-=:.. @@@@@@@@@@@@@@@@@@@@  -----------    ----  @@ -.---- @ ------        @  ------         -----  
25 @@@@@@@@@@@@@@@@@@::-=+**=**+###****==+==+-:+++*#*-+++::. @@@@@@@@@@@@@@@@@@  ----  .:----   ----  @  -.----   ------ @@@@@ @@  ------ @@@@@ @ -----  
26 @@@@@@@@@@@@@@@@@.===#*##++#++*##*#+-++=++=:=*=*#++++++:.. @@@@@@@@@@@@@@@@@  ----    :--- : ----  @  -.----   ------ @@@@@@@@  ------ @@@@@@@ -----  
27 @@@@@@@@@@@@@@@ :-++++#%*=++#+#*#*++-*+*-+--+==*++-*==*+-:.. @@@@@@@@@@@@@@@  ----  @ ----.: ----  @  -.----   ------ @@@@@@@@  ------ @@@@@@@ :----  
28 @@@@@@@@@@@@@@ :-==%#%%*+*+*#***+*%=++#*=*--===+=-====*++=:..  @@@@@@@@@@@@@  :---  @ -----. ----.    -.----   ------ @@@@@@@@  ------ @@@@@@@ :----  
29 @@@@@@@@@@@@@ :-#*+****#*#+%#***+***#++*+#--=+*=:-::=+==-*==-. @@@@@@@@@@@@@  .---    -----  ----:    ------   ------ @@@@@@@@  ------ @@@@@@@ .---- @
30 @ @@@@    :---=+*++##+######***+**+*#%%**+=+++++==--:#*==**+=::. @@@@@@@@@@@  .---    -----  ---------------   ------ @@@@@@@@  ------ @@@@@@@  ---- @
31 @.-:-:-==****+*+###+#*#%####*+***++*******+==++++=----#**+%**=:: @@@@@@@@@@@  :------------  ---------------   ------ @@@@@@@@  :----- @@@@@@@  ---- @
32 @ -+-==%=*###+#*####*##%##***##****#*++++-====++++==---%*=*#++--: @@@@@@@@@@  -.-----------  ---------------   :-----  @@@@@@@  :----- @@@@@@@  ---- @
33 @ -*++*##**#%##*#%*#%*###****#####***+++=====--+++++=---*++*+*--: @@@@@@@@@@  - -----------   .------------    .-----  @@@@@@@  :-----  @@@@@@  --:- @
34 @@.=**####*#%###*#*##**#***##***##*****++++==-:-@%+**=--%**+%+---. @@@@@@@@@    :------::   @     .-------  @  .-----  @@@@@@@  .-----  @@@@@@  --:- @
35 @  :+###*###%%*#%*+##*#*******#@###*++++++=+==:-#%==*=--%**%+*==+:  @@@@@@@@@@@    :-:    @@@@@@@     .:   @@   .:::-  @@@@@@@   .:::-  @@@@@@@ :::- @
36 @@@ @-+#**##%%##+####+#*******#@%*#***+++=+===:-=%==+==-=***++++=::-.   @@@@@@@@@@     @@@@@@@@@@@@@@    @@@@@        @@@@@@@@@        @@@@@@@@      @
37 @@@@@@  =#*%%%##*+%**#*******#*@%***+++++=++==---%+==-===%*#**-=--:+---: @@@@@@@      @@@@@@@@@@@@       @@@@@@@@@@@@@@       @@@@         @@@@       
38 @@@@@@@==+##%##%%*#*#*********#@%*****+++++==---=%#-=-===+#**+*=-:++*+++-:: @@@@ ::        @@@      .:-:    @@@          .::-  @@@ -------  @@  :--:: 
39 @@@@@@@ -**%%+%#%#*#*****#***##@%##***+++++++---=+===---==***%#=-+==++#*-=+::@@  -----:-:      :----------.   @   :-----.----  @@@    :---. @@  ----- 
40 @@@@@@@:**###*+*+###*********#%#####****++*+=+##**+==---===%**+==-*+-*+-===:. @  -----:-----   --------------   -------------- @@@ :-------  @@ ----: 
41 @@@@@@@=+*%%%****#********##%%%%%%###***#*###*###***=-----==***++-*+**#+*==:@@@ ------------   ---------------: .:------------  @@  :------  @@ ----. 
42 @@@@@@@-*##%#****#******###%%%%%%%%%%%%###%%###*##%*=-----=+%+***+=-+%+#++:@@@  ---.--------   --------:------. :.:---   -----: @@  ..:----.  @ ----  
43 @@@@@@@=*#**#*+**#******###%%%%%@@%%%%%##########%%#+------=+**+*#+=+**+-:@@@@ .--- -  -----  .----:.    -----:   .---    ----- @@    :----:-   ----  
44 @@@@@@@-*+#*##*+*******####%%%%%%%@%%%%%%#######%##*+:-----=+++*=+==*==@@@@@@@ ----    --:--. .----      -----: @ :--- @@ .----  @@@@ :------   ----  
45 @@@@@@@***#####%**********#%%%%%%%%%%%%%%%%%#####%**+:::---+++=#+=+-+:@@@@@@@  ---- @@ --.--: :----  @@@ -----: @ -:--  @  ----: @@@@ --------  ----  
46 @@@@@@@-=*#%++*##*******#@%#%%%%%%%%%%%%%%%%#######*+:=----+#*#+====:@@@@@@@@  -:-- @@ -- -:. :--:-  @@@ :----- @ -:--  @  -----  @@@ --------. ----  
47 @@ @@@@-**#%*+***#******@@@@@@@%%%%%%%%%%%%#%%%####-=%@----=#*#%++++- @@@@@@@  -:-- @@ .      :--:-  @@@ :----- @ -:--  @  -----  @@@ --------- ----  
48 @@@@@@ -**#%#*+*%#*#****#@@@@@@@@%%%%%%%%%%%%%%%%%=##%@----=%**===+* @@@@@@@   -:-- @@    @@@ ---:-  @@@ .----- @ -:--     -----: @@@ ----:----:----  
49 @@@@@@@:*+####+*%*****#**@@@@@@@@@%@%%%%%@%%%%%%%@%%%%@----+#=+*-==*:@@@@@@@ :.-.-: @@@@@@@@@ ---.-  @@@ .----- @ -:--.--.------- @@@ ----: --------  
50 @@@@@@@-+=##%***#****#****@@@@@@@+@@@@@@@@@@@@@@@=%%#%%---+*#+#++-++@@@@@@@  -.-.-. @@@@@@@@@ --- -  @@@  ----- @ -:-----:----:   @@@ ----: .------- @
51 @@@@@@@.-**#%%%#***##*####*@@@@@@..:+@@@@@@@@@ ...%%%@----=****#-=--@@@@@@@  -:-.-  @@@@@@@@@ ---.-  @@@  ----- @ -----:-:--:   @@@@@ ----:  :----:- @
52 @@@@@@@@-*#####*##########**@@@@@#*+@@@@@@@@%@  . %%%+=====#**++#-=-@@@@@@@ ----:-  @@@@@@@@@ ---:-  @@@  ----- @ -----.----:   @@@@@ ----:   ----:- @
53 @@@@@@@@@=+*#%#****#########*@@@@@%::::+@@-..-@@@%%##=====*=*#*+==-@@@@@@@  ----:-  @@@@@@@@@ -----  @@@  ----- @ -----.------  @@@@@ ----: @  ---:- @
54 @@@@@@@@@@=***%%#*##*########*@@@%::.:::=:.::::-@%%+=====*+*##*=+-:@@@@@@@ .----:-  @@@@@ @@  -----  @@@  ----- @ ----- ------- @@  @ ----: @@ :--:- @
55 @@@@@@@@@@ :%*%%###%#%*%#######**%@#--:...::... %#====+=#+==##==--@@@@@@@@  ------  @@@@      -----       ----- @ -----    ----       ----: @@  --:: @
56 @@@@@@@@@@@:#*%#%###*##**##########**%%*=*#%%%*=++++==+%*+*+#*+=-@@@@@@@@@@ ------  @@@@ --:  ------ --:  ----- @ ----- @  ----    -. ----: @@@  -:: @
57 @@@@@@@@@@@@:*%##%+###%#**#%%########*#******++*+*+****+**#++#*=@@@@@@@@@@@ .-----       ---. ------.---------- @ ----- @  ----:   -. ----: @@@@  -. @
58 @@@@@@@@@@@@@+#+#*%*#**#**##*##%%%#####*****+++****==##+*+***+*:@@@@@@@@@@@  -----     ..---. ------:---------- @ ----- @  ---:-  :-. ----- @@@@  :. @
59 @@@@@@@@@@@@@@=+##+**####****##%#%%#%%###******=###*=**-#*#*+*+@@@@@@@@@@@@@ ------:--------. ----------------- @ ----- @  ---:-::--. ----- @@@@@    @
60 @@@@@@@@@@@@@@@@++#%#%%%**#*#####**#%***##+*****-**=+#+=**%#++@@@@@@@@@@@@@@  ------------:-  ----------------- @ ----- @  ---.-----. ----- @@@@@@   @
61 @@@@@@@@@@@@@@@@@@*###%%%%%#%#%##%#%#%%+*#+**#%****++#%+####=@@@@@@@@@@@@@@@@ ------------.-:   :------------   @ ---:- @  :--.-----. ----- @@@@@@@@@@
62 @@@@@@@@@@@@@@@@@@@++##%#%#%#%##%%%%%%%%%%%#*##*#%##%%%**%%@@@@@@@@@@@@@@@@@@    .:---:--- -. @    :------:   @@@ ---:- @@   : ----   ----- @@@@@@@@@@
63 @@@@@@@@@@@@@@@@@@@@@@@#*%%%%%%@@@%@%%%%%%%++**##@%@%%@@@@@@@@@@@@@@@@@@@@@@@@          :- -. @@@     --:   @@@@@   ::- @@@@   :-     ----- @@@@@@@@@@
64 @@@@@@@@@@@@@@@@@@@@@@@@@@@%%%%@%%%%@%%##%%%**## @@@@@@@@@@@@@ @@@@@@@@@@@@@@@@@@@@@@         @@@@@@      @@@@@@@       @@@@@@     @        @@@@@@@@@@
65 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%%%%%%%%####+@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@@ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    @@@@@@@@@@@
66 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
67 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
68 */
69 // Website: https://bufficorn.org/
70 // SPDX-License-Identifier: MIT
71 
72 pragma solidity 0.8.17;
73 
74 abstract contract Context {
75     function _msgSender() internal view virtual returns (address payable) {
76         return payable(msg.sender);
77     }
78 
79     function _msgData() internal view virtual returns (bytes memory) {
80         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
81         return msg.data;
82     }
83 }
84 
85 abstract contract Ownable is Context {
86     address private _owner;
87 
88     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
89 
90     constructor () {
91         address msgSender = _msgSender();
92         _owner = msgSender;
93         emit OwnershipTransferred(address(0), msgSender);
94     }
95 
96     function owner() public view returns (address) {
97         return _owner;
98     }
99 
100     modifier onlyOwner() {
101         require(_owner == _msgSender(), "Ownable: caller is not the owner");
102         _;
103     }
104 
105     function renounceOwnership() public virtual onlyOwner {
106         emit OwnershipTransferred(_owner, address(0));
107         _owner = address(0);
108     }
109 
110     function transferOwnership(address newOwner) public virtual onlyOwner {
111         require(newOwner != address(0), "Ownable: new owner is the zero address");
112         emit OwnershipTransferred(_owner, newOwner);
113         _owner = newOwner;
114     }
115 }
116 
117 interface IERC20 {
118     function totalSupply() external view returns (uint256);
119     function balanceOf(address account) external view returns (uint256);
120     function transfer(address recipient, uint256 amount) external returns (bool);
121     function allowance(address owner, address spender) external view returns (uint256);
122     function approve(address spender, uint256 amount) external returns (bool);
123     function transferFrom(
124         address sender,
125         address recipient,
126         uint256 amount
127     ) external returns (bool);
128    
129     event Transfer(address indexed from, address indexed to, uint256 value);
130     event Approval(address indexed owner, address indexed spender, uint256 value);
131 }
132 
133 library Address {
134     function isContract(address account) internal view returns (bool) {
135         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
136         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
137         // for accounts without code, i.e. `keccak256('')`
138         bytes32 codehash;
139         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
140         // solhint-disable-next-line no-inline-assembly
141         assembly { codehash := extcodehash(account) }
142         return (codehash != accountHash && codehash != 0x0);
143     }
144 
145     function sendValue(address payable recipient, uint256 amount) internal {
146         require(address(this).balance >= amount, "Address: insufficient balance");
147 
148         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
149         (bool success, ) = recipient.call{ value: amount }("");
150         require(success, "Address: unable to send value, recipient may have reverted");
151     }
152 
153     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
154       return functionCall(target, data, "Address: low-level call failed");
155     }
156 
157     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
158         return _functionCallWithValue(target, data, 0, errorMessage);
159     }
160 
161     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
162         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
163     }
164 
165     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
166         require(address(this).balance >= value, "Address: insufficient balance for call");
167         return _functionCallWithValue(target, data, value, errorMessage);
168     }
169 
170     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
171         require(isContract(target), "Address: call to non-contract");
172 
173         // solhint-disable-next-line avoid-low-level-calls
174         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
175         if (success) {
176             return returndata;
177         } else {
178             // Look for revert reason and bubble it up if present
179             if (returndata.length > 0) {
180                 // The easiest way to bubble the revert reason is using memory via assembly
181 
182                 // solhint-disable-next-line no-inline-assembly
183                 assembly {
184                     let returndata_size := mload(returndata)
185                     revert(add(32, returndata), returndata_size)
186                 }
187             } else {
188                 revert(errorMessage);
189             }
190         }
191     }
192 }
193 
194 interface IUniswapV2Factory {
195     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
196 
197     function feeTo() external view returns (address);
198     function feeToSetter() external view returns (address);
199 
200     function getPair(address tokenA, address tokenB) external view returns (address pair);
201     function allPairs(uint) external view returns (address pair);
202     function allPairsLength() external view returns (uint);
203 
204     function createPair(address tokenA, address tokenB) external returns (address pair);
205 
206     function setFeeTo(address) external;
207     function setFeeToSetter(address) external;
208 }
209 
210 interface IUniswapV2Pair {
211     event Approval(address indexed owner, address indexed spender, uint value);
212     event Transfer(address indexed from, address indexed to, uint value);
213 
214     function name() external pure returns (string memory);
215     function symbol() external pure returns (string memory);
216     function decimals() external pure returns (uint8);
217     function totalSupply() external view returns (uint);
218     function balanceOf(address owner) external view returns (uint);
219     function allowance(address owner, address spender) external view returns (uint);
220 
221     function approve(address spender, uint value) external returns (bool);
222     function transfer(address to, uint value) external returns (bool);
223     function transferFrom(address from, address to, uint value) external returns (bool);
224 
225     function DOMAIN_SEPARATOR() external view returns (bytes32);
226     function PERMIT_TYPEHASH() external pure returns (bytes32);
227     function nonces(address owner) external view returns (uint);
228 
229     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
230 
231     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
232     event Swap(
233         address indexed sender,
234         uint amount0In,
235         uint amount1In,
236         uint amount0Out,
237         uint amount1Out,
238         address indexed to
239     );
240     event Sync(uint112 reserve0, uint112 reserve1);
241 
242     function MINIMUM_LIQUIDITY() external pure returns (uint);
243     function factory() external view returns (address);
244     function token0() external view returns (address);
245     function token1() external view returns (address);
246     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
247     function price0CumulativeLast() external view returns (uint);
248     function price1CumulativeLast() external view returns (uint);
249     function kLast() external view returns (uint);
250 
251     function burn(address to) external returns (uint amount0, uint amount1);
252     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
253     function skim(address to) external;
254     function sync() external;
255 
256     function initialize(address, address) external;
257 }
258 
259 interface IUniswapV2Router01 {
260     function factory() external pure returns (address);
261     function WETH() external pure returns (address);
262 
263     function addLiquidity(
264         address tokenA,
265         address tokenB,
266         uint amountADesired,
267         uint amountBDesired,
268         uint amountAMin,
269         uint amountBMin,
270         address to,
271         uint deadline
272     ) external returns (uint amountA, uint amountB, uint liquidity);
273     function addLiquidityETH(
274         address token,
275         uint amountTokenDesired,
276         uint amountTokenMin,
277         uint amountETHMin,
278         address to,
279         uint deadline
280     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
281     function removeLiquidity(
282         address tokenA,
283         address tokenB,
284         uint liquidity,
285         uint amountAMin,
286         uint amountBMin,
287         address to,
288         uint deadline
289     ) external returns (uint amountA, uint amountB);
290     function removeLiquidityETH(
291         address token,
292         uint liquidity,
293         uint amountTokenMin,
294         uint amountETHMin,
295         address to,
296         uint deadline
297     ) external returns (uint amountToken, uint amountETH);
298     function removeLiquidityWithPermit(
299         address tokenA,
300         address tokenB,
301         uint liquidity,
302         uint amountAMin,
303         uint amountBMin,
304         address to,
305         uint deadline,
306         bool approveMax, uint8 v, bytes32 r, bytes32 s
307     ) external returns (uint amountA, uint amountB);
308     function removeLiquidityETHWithPermit(
309         address token,
310         uint liquidity,
311         uint amountTokenMin,
312         uint amountETHMin,
313         address to,
314         uint deadline,
315         bool approveMax, uint8 v, bytes32 r, bytes32 s
316     ) external returns (uint amountToken, uint amountETH);
317     function swapExactTokensForTokens(
318         uint amountIn,
319         uint amountOutMin,
320         address[] calldata path,
321         address to,
322         uint deadline
323     ) external returns (uint[] memory amounts);
324     function swapTokensForExactTokens(
325         uint amountOut,
326         uint amountInMax,
327         address[] calldata path,
328         address to,
329         uint deadline
330     ) external returns (uint[] memory amounts);
331     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
332         external
333         payable
334         returns (uint[] memory amounts);
335     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
336         external
337         returns (uint[] memory amounts);
338     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
339         external
340         returns (uint[] memory amounts);
341     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
342         external
343         payable
344         returns (uint[] memory amounts);
345 
346     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
347     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
348     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
349     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
350     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
351 }
352 
353 interface IUniswapV2Router02 is IUniswapV2Router01 {
354     function removeLiquidityETHSupportingFeeOnTransferTokens(
355         address token,
356         uint liquidity,
357         uint amountTokenMin,
358         uint amountETHMin,
359         address to,
360         uint deadline
361     ) external returns (uint amountETH);
362     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
363         address token,
364         uint liquidity,
365         uint amountTokenMin,
366         uint amountETHMin,
367         address to,
368         uint deadline,
369         bool approveMax, uint8 v, bytes32 r, bytes32 s
370     ) external returns (uint amountETH);
371 
372     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
373         uint amountIn,
374         uint amountOutMin,
375         address[] calldata path,
376         address to,
377         uint deadline
378     ) external;
379     function swapExactETHForTokensSupportingFeeOnTransferTokens(
380         uint amountOutMin,
381         address[] calldata path,
382         address to,
383         uint deadline
384     ) external payable;
385     function swapExactTokensForETHSupportingFeeOnTransferTokens(
386         uint amountIn,
387         uint amountOutMin,
388         address[] calldata path,
389         address to,
390         uint deadline
391     ) external;
392 }
393 
394 contract Bufficorn is Context, IERC20, Ownable {
395     using Address for address;
396     using Address for address payable;
397 
398     mapping (address => uint256) private _rOwned;
399     mapping (address => uint256) private _tOwned;
400     mapping (address => mapping (address => uint256)) private _allowances;
401 
402     mapping (address => bool) private _isExcludedFromFees;
403     mapping (address => bool) private _isExcluded;
404     address[] private _excluded;
405 
406     string private _name     = "BUFFICORN";
407     string private _symbol   = "BUFFI";
408     uint8  private _decimals = 9;
409    
410     uint256 private constant MAX = type(uint256).max;
411     uint256 private _tTotal = 227_000_000_000_000_000 * (10 ** _decimals);
412     uint256 private _rTotal = (MAX - (MAX % _tTotal));
413     uint256 private _tFeeTotal;
414 
415     uint256 private taxFeeonBuy; 
416     uint256 private taxFeeonSell; // Reflection
417 
418     uint256 private liquidityFeeonBuy;
419     uint256 private liquidityFeeonSell; // Add Liquidity
420 
421     uint256 private marketingFeeonBuy;
422     uint256 private marketingFeeonSell;
423 
424     uint256 private _taxFee;
425     uint256 private _liquidityFee;
426     uint256 private _marketingFee;
427 
428     uint256 public totalBuyFees = taxFeeonBuy + liquidityFeeonBuy + marketingFeeonBuy;
429     uint256 public totalSellFees = taxFeeonSell + liquidityFeeonSell + marketingFeeonSell;
430 
431     address private mk;
432     address private mkTwo;
433     
434     address private DEAD = 0x000000000000000000000000000000000000dEaD;
435     address private DEV;
436 
437     IUniswapV2Router02 public  uniswapV2Router;
438     address public  uniswapV2Pair;
439 
440     bool private inSwapAndLiquify;
441     bool public swapEnabled;
442     uint256 public swapTokensAtAmount;
443     
444     event ExcludeFromFees(address indexed account, bool isExcluded);
445     event mkChanged(address mk);
446     event SwapEnabledUpdated(bool enabled);
447     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiqudity);
448     event SwapAndSendMarketing(uint256 tokensSwapped, uint256 ethSend);
449     event SwapTokensAtAmountUpdated(uint256 amount);
450     event BuyFeesChanged(uint256 taxFee, uint256 liquidityFee, uint256 marketingFee);
451     event SellFeesChanged(uint256 taxFee, uint256 liquidityFee, uint256 marketingFee);
452     event WalletToWalletTransferWithoutFeeEnabled(bool enabled);
453     
454 	event SetStakingAddress(address _address, bool _type);
455 	event LockToken(uint256 _amount, address _user, address _contract);
456 	event UnLockToken(uint256 _amount, address _user, address _contract);
457     
458     mapping (address => uint256) balances;
459     mapping (address => bool) public isStakingAddress;
460     mapping (address => uint256) public lockedAmount;
461     mapping (address => mapping(address => uint256)) public lockedAmountPerContract;
462 
463     struct Checkpoint {
464         uint32 fromBlock;
465         uint256 votes;
466     }
467     
468     constructor(
469         address _addressOne,
470         address _addressTwo,
471         address _owner
472     ){
473         DEV = _owner;
474 
475         address router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // uniswap v2
476 
477         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);
478         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
479             .createPair(address(this), _uniswapV2Router.WETH());
480         uniswapV2Router = _uniswapV2Router;
481 
482         _approve(address(this), address(uniswapV2Router), MAX);
483 
484         taxFeeonBuy = 0;
485         taxFeeonSell = 0;
486 
487         liquidityFeeonBuy = 0;
488         liquidityFeeonSell = 0;
489 
490         marketingFeeonBuy = 0;
491         marketingFeeonSell = 0;
492 
493         mk = _addressOne;
494         mkTwo = _addressTwo;
495         
496         swapEnabled = true;
497         swapTokensAtAmount = _tTotal / 5000;
498         
499         _isExcludedFromFees[owner()] = true;
500         _isExcludedFromFees[mk] = true;
501         _isExcludedFromFees[mkTwo] = true;
502         _isExcludedFromFees[address(this)] = true;
503 
504         _isExcluded[address(this)] = true;
505         _isExcluded[address(0x407993575c91ce7643a4d4cCACc9A98c36eE1BBE)] = true; //pinklock
506         _isExcluded[address(0xdead)] = true;
507 
508         _rOwned[owner()] = _rTotal;
509         _tOwned[owner()] = _tTotal;
510 
511         emit Transfer(address(0), owner(), _tTotal);
512     }
513 
514     function name() public view returns (string memory) {
515         return _name;
516     }
517 
518     function symbol() public view returns (string memory) {
519         return _symbol;
520     }
521 
522     function decimals() public view returns (uint8) {
523         return _decimals;
524     }
525 
526     function totalSupply() public view override returns (uint256) {
527         return _tTotal;
528     }
529 
530     function balanceOf(address account) public view override returns (uint256) {
531         if (_isExcluded[account]) return _tOwned[account];
532         return tokenFromReflection(_rOwned[account]);
533     }
534 
535     function transfer(address recipient, uint256 amount) public override returns (bool) {
536         _transfer(_msgSender(), recipient, amount);
537         return true;
538     }
539 
540     function allowance(address owner, address spender) public view override returns (uint256) {
541         return _allowances[owner][spender];
542     }
543 
544     function approve(address spender, uint256 amount) public override returns (bool) {
545         _approve(_msgSender(), spender, amount);
546         return true;
547     }
548 
549     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
550         _transfer(sender, recipient, amount);
551         _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);
552         return true;
553     }
554 
555     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
556         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
557         return true;
558     }
559 
560     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
561         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
562         return true;
563     }
564 
565     function isExcludedFromReward(address account) public view returns (bool) {
566         return _isExcluded[account];
567     }
568 
569     function totalReflectionDistributed() public view returns (uint256) {
570         return _tFeeTotal;
571     }
572 
573     function deliver(uint256 tAmount) public {
574         address sender = _msgSender();
575         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
576         (uint256 rAmount,,,,,,) = _getValues(tAmount);
577         _rOwned[sender] = _rOwned[sender] - rAmount;
578         _rTotal = _rTotal - rAmount;
579         _tFeeTotal = _tFeeTotal + tAmount;
580     }
581 
582     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
583         require(tAmount <= _tTotal, "Amount must be less than supply");
584         if (!deductTransferFee) {
585             (uint256 rAmount,,,,,,) = _getValues(tAmount);
586             return rAmount;
587         } else {
588             (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
589             return rTransferAmount;
590         }
591     }
592 
593     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
594         require(rAmount <= _rTotal, "Amount must be less than total reflections");
595         uint256 currentRate =  _getRate();
596         return rAmount / currentRate;
597     }
598 
599     function excludeFromReward(address account) public onlyOwner() {
600         require(!_isExcluded[account], "Account is already excluded");
601         if(_rOwned[account] > 0) {
602             _tOwned[account] = tokenFromReflection(_rOwned[account]);
603         }
604         _isExcluded[account] = true;
605         _excluded.push(account);
606     }
607 
608     function includeInReward(address account) external onlyOwner() {
609         require(_isExcluded[account], "Account is already included");
610         for (uint256 i = 0; i < _excluded.length; i++) {
611             if (_excluded[i] == account) {
612                 _excluded[i] = _excluded[_excluded.length - 1];
613                 _tOwned[account] = 0;
614                 _isExcluded[account] = false;
615                 _excluded.pop();
616                 break;
617             }
618         }
619     }
620 
621     receive() external payable {}
622 
623     function claimStuckTokens(address token) external {
624         require(msg.sender == DEV, "You do not have access to this function");
625 
626         if (token == address(0x0)) {
627             payable(msg.sender).transfer(address(this).balance);
628             return;
629         }
630 
631         IERC20 ERC20token = IERC20(token);
632         uint256 balance = ERC20token.balanceOf(address(this));
633         ERC20token.transfer(msg.sender, balance);
634     }
635 
636     function setStakingAddress(address stakingAddress, bool _value) external onlyOwner {
637         require(isStakingAddress[stakingAddress] != _value, "account is already the value of '_value'");
638         require(isContract(stakingAddress), "call to non-contract");
639         
640         isStakingAddress[stakingAddress] = _value;
641         emit SetStakingAddress(stakingAddress, _value);
642     }
643 
644     function lockToken(uint256 amount, address user) public {
645 	   require(isStakingAddress[msg.sender], "sender not allowed");
646 	   
647 	   uint256 unlockBalance = balances[user] - lockedAmount[user];
648 	   require(unlockBalance >= amount, "locking amount exceeds balance");
649 	   lockedAmount[user] = lockedAmount[user] + amount;
650 	   
651 	   lockedAmountPerContract[user][msg.sender] = lockedAmountPerContract[user][msg.sender] + amount;
652 	   
653 	   emit LockToken(amount, user, msg.sender);
654     }
655 	
656 	function unlockToken(address user) public {
657 	   require(isStakingAddress[msg.sender], "sender not allowed");
658 	   require(lockedAmountPerContract[user][msg.sender] > 0, "staking amount not found");
659 	   
660 	   lockedAmount[user] = lockedAmount[user] - lockedAmountPerContract[user][msg.sender];
661 	   lockedAmountPerContract[user][msg.sender] = 0;
662 	   
663 	   emit UnLockToken(lockedAmountPerContract[user][msg.sender], user, msg.sender);
664     }
665 
666     function updateFeeBuy(uint256 _taxFeeonBuyFee, uint256 _liquidityFeeonBuyFee, uint256 _marketingFeeonBuy) public onlyOwner{
667         require(_taxFeeonBuyFee + _liquidityFeeonBuyFee + _marketingFeeonBuy <= 6,"Total fee must be less than 6");
668 
669         taxFeeonBuy = _taxFeeonBuyFee;
670         liquidityFeeonBuy = _liquidityFeeonBuyFee;
671         marketingFeeonBuy = _marketingFeeonBuy;
672     }
673 
674     function updateFeeSell(uint256 _taxFeeonSell, uint256 _liquidityFeeonSell, uint256 _marketingFeeonSell) public onlyOwner{
675         require(_taxFeeonSell + _liquidityFeeonSell + _marketingFeeonSell <= 6,"Total fee must be less than 6");
676         
677         taxFeeonSell = _taxFeeonSell;
678         liquidityFeeonSell = _liquidityFeeonSell;
679         marketingFeeonSell = _marketingFeeonSell;
680     }
681 
682 //------------------Private Reflection Token Mechanism------------------//
683 
684     function _reflectFee(uint256 rFee, uint256 tFee) private {
685         _rTotal = _rTotal - rFee;
686         _tFeeTotal = _tFeeTotal + tFee;
687     }
688 
689     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
690         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing) = _getTValues(tAmount);
691         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, tMarketing, _getRate());
692         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity, tMarketing);
693     }
694 
695     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
696         uint256 tFee = calculateTaxFee(tAmount);
697         uint256 tLiquidity = calculateLiquidityFee(tAmount);
698         uint256 tMarketing = calculateMarketingFee(tAmount);
699         uint256 tTransferAmount = tAmount - tFee - tLiquidity - tMarketing;
700         return (tTransferAmount, tFee, tLiquidity, tMarketing);
701     }
702 
703     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
704         uint256 rAmount = tAmount * currentRate;
705         uint256 rFee = tFee * currentRate;
706         uint256 rLiquidity = tLiquidity * currentRate;
707         uint256 rMarketing = tMarketing * currentRate;
708         uint256 rTransferAmount = rAmount - rFee - rLiquidity - rMarketing;
709         return (rAmount, rTransferAmount, rFee);
710     }
711 
712     function _getRate() private view returns(uint256) {
713         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
714         return rSupply / tSupply;
715     }
716 
717     function _getCurrentSupply() private view returns(uint256, uint256) {
718         uint256 rSupply = _rTotal;
719         uint256 tSupply = _tTotal;      
720         for (uint256 i = 0; i < _excluded.length; i++) {
721             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
722             rSupply = rSupply - _rOwned[_excluded[i]];
723             tSupply = tSupply - _tOwned[_excluded[i]];
724         }
725         if (rSupply < _rTotal / _tTotal) return (_rTotal, _tTotal);
726         return (rSupply, tSupply);
727     }
728     
729     function _takeLiquidity(uint256 tLiquidity) private {
730         if (tLiquidity > 0) {
731             uint256 currentRate =  _getRate();
732             uint256 rLiquidity = tLiquidity * currentRate;
733             _rOwned[address(this)] = _rOwned[address(this)] + rLiquidity;
734             if(_isExcluded[address(this)])
735                 _tOwned[address(this)] = _tOwned[address(this)] + tLiquidity;
736         }
737     }
738 
739     function _takeMarketing(uint256 tMarketing) private {
740         if (tMarketing > 0) {
741             uint256 currentRate =  _getRate();
742             uint256 rMarketing = tMarketing * currentRate;
743             _rOwned[address(this)] = _rOwned[address(this)] + rMarketing;
744             if(_isExcluded[address(this)])
745                 _tOwned[address(this)] = _tOwned[address(this)] + tMarketing;
746         }
747     }
748     
749     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
750         return _amount * _taxFee / 100;
751     }
752 
753     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
754         return _amount * _liquidityFee / 100;
755     }
756     
757     function calculateMarketingFee(uint256 _amount) private view returns (uint256) {
758         return _amount * _marketingFee / 100;
759     }
760     
761     function removeAllFee() private {
762         if(_taxFee == 0 && _liquidityFee == 0 && _marketingFee == 0) return;
763         
764         _taxFee = 0;
765         _marketingFee = 0;
766         _liquidityFee = 0;
767     }
768     
769     function setBuyFee() private{
770         if(_taxFee == taxFeeonBuy && _liquidityFee == liquidityFeeonBuy && _marketingFee == marketingFeeonBuy) return;
771 
772         _taxFee = taxFeeonBuy;
773         _marketingFee = marketingFeeonBuy;
774         _liquidityFee = liquidityFeeonBuy;
775     }
776 
777     function setSellFee() private{
778         if(_taxFee == taxFeeonSell && _liquidityFee == liquidityFeeonSell && _marketingFee == marketingFeeonSell) return;
779 
780         _taxFee = taxFeeonSell;
781         _marketingFee = marketingFeeonSell;
782         _liquidityFee = liquidityFeeonSell;
783     }
784     
785     function isExcludedFromFee(address account) public view returns(bool) {
786         return _isExcludedFromFees[account];
787     }
788 
789     function _approve(address owner, address spender, uint256 amount) private {
790         require(owner != address(0), "ERC20: approve from the zero address");
791         require(spender != address(0), "ERC20: approve to the zero address");
792 
793         _allowances[owner][spender] = amount;
794         emit Approval(owner, spender, amount);
795     }
796 
797     function _transfer(
798         address from,
799         address to,
800         uint256 amount
801     ) private {
802         require(from != address(0), "ERC20: transfer from the zero address");
803         require(amount > 0, "Transfer amount must be greater than zero");
804 
805         uint256 contractTokenBalance = balanceOf(address(this));        
806         bool overMinTokenBalance = contractTokenBalance >= swapTokensAtAmount;
807         if (
808             overMinTokenBalance &&
809             !inSwapAndLiquify &&
810             to == uniswapV2Pair &&
811             swapEnabled
812         ) {
813             inSwapAndLiquify = true;
814             
815             uint256 marketingShare = marketingFeeonBuy + marketingFeeonSell;
816             uint256 liquidityShare = liquidityFeeonBuy + liquidityFeeonSell;
817             uint256 totalShare = marketingShare + liquidityShare;
818 
819             if(totalShare > 0) {
820                 if(liquidityShare > 0) {
821                     uint256 liquidityTokens = (contractTokenBalance * liquidityShare) / totalShare;
822                     swapAndLiquify(liquidityTokens);
823                 }
824                 
825                 if(marketingShare > 0) {
826                     uint256 marketingTokens = (contractTokenBalance * marketingShare) / totalShare;
827                     swapAndSendMarketing(marketingTokens);
828                 } 
829             }
830 
831             inSwapAndLiquify = false;
832         }
833         
834         //transfer amount, it will take tax, burn, liquidity fee
835         _tokenTransfer(from,to,amount);
836     }
837 
838     function swapAndLiquify(uint256 tokens) private {
839         uint256 half = tokens / 2;
840         uint256 otherHalf = tokens - half;
841 
842         uint256 initialBalance = address(this).balance;
843 
844         address[] memory path = new address[](2);
845         path[0] = address(this);
846         path[1] = uniswapV2Router.WETH();
847 
848         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
849             half,
850             0, // accept any amount of ETH
851             path,
852             address(this),
853             block.timestamp);
854         
855         uint256 newBalance = address(this).balance - initialBalance;
856 
857         uniswapV2Router.addLiquidityETH{value: newBalance}(
858             address(this),
859             otherHalf,
860             0, // slippage is unavoidable
861             0, // slippage is unavoidable
862             DEAD,
863             block.timestamp
864         );
865 
866         emit SwapAndLiquify(half, newBalance, otherHalf);
867     }
868 
869     function swapAndSendMarketing(uint256 tokenAmount) private {
870         uint256 initialBalance = address(this).balance;
871 
872         address[] memory path = new address[](2);
873         path[0] = address(this);
874         path[1] = uniswapV2Router.WETH();
875 
876         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
877             tokenAmount,
878             0, // accept any amount of ETH
879             path,
880             address(this),
881             block.timestamp);
882 
883         uint256 newBalance = address(this).balance - initialBalance;
884 
885         uint256 amountOne = newBalance * 2 / 5;
886 
887         payable(mk).sendValue(amountOne);
888         payable(mkTwo).sendValue(address(this).balance - initialBalance);
889 
890 
891         emit SwapAndSendMarketing(tokenAmount, newBalance);
892     }
893 
894     function setSwapTokensAtAmount(uint256 newAmount) external onlyOwner() {
895         require(newAmount > totalSupply() / 1e5, "SwapTokensAtAmount must be greater than 0.001% of total supply");
896         swapTokensAtAmount = newAmount;
897         emit SwapTokensAtAmountUpdated(newAmount);
898     }
899     
900     function setSwapEnabled(bool _enabled) external onlyOwner {
901         swapEnabled = _enabled;
902         emit SwapEnabledUpdated(_enabled);
903     }
904 
905     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
906          if (_isExcludedFromFees[sender] || 
907             _isExcludedFromFees[recipient] 
908             ) {
909             removeAllFee();
910         }else if(recipient == uniswapV2Pair){
911             setSellFee();
912         }else if(sender == uniswapV2Pair){
913             setBuyFee();
914         }else{
915             removeAllFee();
916         }
917 
918         if (_isExcluded[sender] && !_isExcluded[recipient]) {
919             _transferFromExcluded(sender, recipient, amount);
920         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
921             _transferToExcluded(sender, recipient, amount);
922         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
923             _transferStandard(sender, recipient, amount);
924         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
925             _transferBothExcluded(sender, recipient, amount);
926         } else {
927             _transferStandard(sender, recipient, amount);
928         }
929 
930     }
931 
932     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
933         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing) = _getValues(tAmount);
934         _rOwned[sender] = _rOwned[sender] - rAmount;
935         _rOwned[recipient] = _rOwned[recipient] + rTransferAmount;
936         _takeMarketing(tMarketing);
937         _takeLiquidity(tLiquidity);
938         _reflectFee(rFee, tFee);
939         emit Transfer(sender, recipient, tTransferAmount);
940     }
941 
942     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
943         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing) = _getValues(tAmount);
944         _rOwned[sender] = _rOwned[sender] - rAmount;
945         _tOwned[recipient] = _tOwned[recipient] + tTransferAmount;
946         _rOwned[recipient] = _rOwned[recipient] + rTransferAmount;
947         _takeMarketing(tMarketing);           
948         _takeLiquidity(tLiquidity);
949         _reflectFee(rFee, tFee);
950         emit Transfer(sender, recipient, tTransferAmount);
951     }
952 
953     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
954         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing) = _getValues(tAmount);
955         _tOwned[sender] = _tOwned[sender] - tAmount;
956         _rOwned[sender] = _rOwned[sender] - rAmount;
957         _rOwned[recipient] = _rOwned[recipient] + rTransferAmount; 
958         _takeMarketing(tMarketing);  
959         _takeLiquidity(tLiquidity);
960         _reflectFee(rFee, tFee);
961         emit Transfer(sender, recipient, tTransferAmount);
962     }
963 
964     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
965         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing) = _getValues(tAmount);
966         _tOwned[sender] = _tOwned[sender] - tAmount;
967         _rOwned[sender] = _rOwned[sender] - rAmount;
968         _tOwned[recipient] = _tOwned[recipient] + tTransferAmount;
969         _rOwned[recipient] = _rOwned[recipient] + rTransferAmount;
970         _takeMarketing(tMarketing);        
971         _takeLiquidity(tLiquidity);
972         _reflectFee(rFee, tFee);
973         emit Transfer(sender, recipient, tTransferAmount);
974     }
975 
976     function excludeFromFees(address account, bool excluded) external onlyOwner {
977         require(_isExcludedFromFees[account] != excluded, "Account is already the value of 'excluded'");
978         _isExcludedFromFees[account] = excluded;
979 
980         emit ExcludeFromFees(account, excluded);
981     }
982 
983     function isContract(address account) internal view returns (bool) {
984         return account.code.length > 0;
985     }
986 }