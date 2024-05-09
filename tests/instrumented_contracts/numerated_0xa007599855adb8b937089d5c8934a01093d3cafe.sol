1 /**
2 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
3 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
4 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
5 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
6 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
7 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
8 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
9 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
10 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!!!!!!!!!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!!!!!!!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
11 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!!!!!~^^^~!!!!!!!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!!!!!!!~^^~!!!!!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
12 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!!!!7^.^?J?7~::~!7!!!!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!!!!77~^:^!??~.^!!!!!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
13 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!!!7!.:5BY?7JY5Y7^:^!77!!!!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!!!!7!^:~J55J7JPP~.~7!!!!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
14 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!!!!7~ 7#5^:::::^!J55?^:^!77!!!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!!!!77~::?PP?~^~!77JBJ.^77!!!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
15 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!!!77^ J#7^^^^~^^^^::~?557^:~77!!!!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!!!!77^.~YPJ!~~!7??J?77PP:.77!!!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
16 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!!!77~ YB~^^~~7?J~^^^^^^^~?5Y!:^!77!!!!~~~~!!!!!!!!!!!!!!!!!!!!!!!!!!!!777^.!P57~~~!7?7?5Y7??7JG~ !7!!!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
17 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!!77~ JB~^~~~!!!J57^^^^^^^^:^?5?::!777!!!!77777!!!!!!!!!!!!!!!!!!!!!7777^.!P5!~~~~7??7?PY777??7?G! !7!!!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
18 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!!!7! 7#!^~~~!!^~!?P?^^~~^^^^^^:!YJ^:!7!!~~^^::::....................:::.~P5~~!!~!7??7?GY?777???7?B~ !7!!!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
19 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!!!77.:#7^~~~~!~^^~7?GJ^~~~~~^^~!~:^JJ^..........:::::::::::::::::::::::~P5~^!!~~!????7G5J7777777?7?B^.77!!!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
20 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!!77~ 55^~~~^~~^^^^~7?GJ^~~~~~~^^~7~:^JY~.::::::::^^^^^^^^^^^^^^^^^^^:^YP!^!!~~~!????7PPJ?77777!!!7!JB.:77!!!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
21 ~~~~~~~~~~~~~~~^^^::^^~~~~~~~~~~~~~~~~~~!!!77.^#~^^^^^~~^^^^^77?B7^~~~~~~~^~77~^75Y~^~!7??JYYYYYYYYYYYYYYJJ??7JBJ:!7~~~~!?????JBJJ777777!!!!!~PY ~77!!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
22 ~~~~~~~~~~~^:.         .:~~~~~~~~~~~~~~~!!77! YP:^^^^^~~^^^^^!77JG~~~~~~~~~~~!777?PB5YYJ?7!!~~^^^^^^^^~~~!!77?Y5YYY7!~~!?????7G5JJ777777!!!!!~!#^.77!!!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
23 ~~~~~~~~^.               .:~~~~~~~~~~~~~!!7?^ B?:^^^::~^^^^~^~77755^~~~~~~~~~77???!~^^:::::^^^^^^^^^^^^^^^^^^^^^^~!777!7??????BJJJ7777777~~!~^:GJ !77!!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
24 ~~~~~^:                    .~~~~~~~~~~~!!!7?:.#~:^^:..~^^^^^^~77?JG~~~~~~~~~~~~~~~~~^^^^^^^^^~~~~~~~~~~~~~~^^^^^^~~~!7???????JGYYY?777777!^^^^:5P ~?7!!!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
25 ~~~^.                       .~~~~~~~~~~!!!7?::#^ ..  :~^^^^^^~75Y?Y!~~~~~~~~~~~~~~^^^~~^^^^^^^^^~~~~~~~~~~~^^^^^~~!7??????????YJ?PJ7!!!7!7^^^^:PP ^7?7!!!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
26 ~^.                          .~~~~~~~~~!!!7?:.#!     :~^^^^^^~7G7^~~~~~~~~~~~~^^^^~~^~~~^^^^^^^^^^^~~~~~~~~^^^~~!7??????????????7PY??????7^^^:!&7...:!77!!!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
27 .                             ^~~~~~~~~!!!7?! P5     .~^~~~^~!7PG~~~~~~~~~~~^^^^~~~~~~~~~~~^^^^^^^~77777777~~~~!7????????????????PGYYYYJJ!^^:~#P^:.....~77!!!!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
28                               ^~~~~~~~!!!7??~ ~&7     :!77777?JB?~~~~~~~~~~^^^^^^^^^~~~~~~~~~~~~~~^~777777!~~~!??????????????????JJYJJ?7~^::?#5^^^^:..:..^77!!!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
29                              .~~~~~~~!!!77!. :.7&J     ^!7?JYYJ!~~~~~~~~~^^^^^~^.  ...:^^~~~~~~~~~~~~?JJJ7~~~!???????7!~^::.:!?????????7!^!PB?^~~^^^^^:::..~77!!!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
30                             .~~~~~~~!!!7!: .:..:!GG!    :^~~~~~~~~~~~~~~^^^^^^~^^:.      :~~~~~~~~~~~!JY?~~~!??????~.     .:~7??????????JGGY~^~~~~~^^^~^:::.:!7!!!!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
31                            :~~~~~~!!!77~..::.:^:::7PP7:^!!~~~~~~~~~~~~~^^~~^^~~^^^^^^:....^~~~~~~~~~~~!7~~~!??????!....^~!7??77??????7??YP^^^~~~~~~~~^^^~:.::.^77!!!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
32                          :~~~~~~~!!!77: ::..^:::::::!YPPJ!~~~~~~~~~~~~^^^~~^^^^~7?JJJ7~~~~~~~~~~~~~~~~~~~~~7???????777???JY5PPYJ?7?????JPP^^^^^~~~~~~~~^^~^:::..!7!!!!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
33                        .^~~~~~~~!!!7!. ::.:^::::::::::^#?^7!~~~~~~~~~~~~~~^^^7P#######B5!~~~~~~~~~~~~~~~~~!????????????YG#Y7!7G#BY7?????PP::^^^^^^^^~~~~~^^~:::. ~77!!!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
34                      .^~~~~~~~!!!!7!..::.:::::::::::^^^5BY?~~~~~~~~~~~~~~~^^J5~?B##BB##&B!~~~~~~~~~~~~~~~~7???????????5###P?7JG##&57????7YY^:::^^^^^^^^^~~^^~^::: ^77!!!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
35                     :~~~~~~~~!!!77~ .^..^::^::::::^^^^^!#?^~~~~~~~~~~~~~~~^?P  :GPPYP5BB#G~~~~~~~~~~~~~~~!???????????Y#BBGPP5PPBBB&Y7????7Y5^:^^^^^^^^^^^^^^^~~::^ :77!!!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
36                   .^~~~~~~~~!!!77~ .^..^::^::::^^^^^^^!B?^~~~~~~~~~~~~~~~~~G5~!PBP?YPYYPB&7~~~~~~~~~~~~~~!???????????PBGBGYJPPYYGB#P7?????7YP^^^^^^^^^^^^^^^^:~~::^ :77!!!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
37                  .~~~~~~~~~~!!!7! .^..^::^:::^^^^^^^^~BY^~~~~~~~~~~~~~~~~^~BBGBBG5Y5P5Y5B#!~~~~~~~!!!!!!!!77?????????PBGGGYYPPYYGG#P7??????7Y5^^^^^^^^^^^^^^^^:~~::^ :77!!!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
38                 .~~~~~~~~~~!!!77..^:.:::^^:^^~~~~~~~^5B^~~~~~~~~~~~~~~~~~!?BBGGGGPPGGPPG#P!~~~~~~^:.. ...:::^^!7????J5#BGPPGGPPPGB#PYJ?????J7PJ^^^^^^^^^^^^^^~^:^^::^ :77!!!~~~~~~~~~~~~~~~~~~~~~~~~~~~~
39                .~~~~~~~~~~!!!77: ^:.:::^^^^~~~~~~~~~!&?^~~~~~~~~~~~~~~~~!775GGGGGGGGGGBG5?!~~^:.   .!?J5PPGGG5?^^!7?Y55GGGGGGGGBBG5J?????????7B!^^^^^^^^^^^^~~~^:^^:^: ^77!!!~~~~~~~~~~~~~~~~~~~~~~~~~~~
40                ^~~~~~~~~~~!!77~ :^.:::^^^~~~~~~~~~^^J#^~~~~~~~~~~~~~~~~~~~~~?JY5PPP5YJ?!~~~:.     ^#&#&&&&&&&&@P::^~7?JY55PPPPP5YJ?????77!7??!YP^~^^^^^^^^^~~~~~::^::^. !77!!~~~~~~~~~~~~~~~~~~~~~~~~~~~
41               :~~~~~~~~~~!!!77..^:.::^^^~~~~~~~~^^::PP^~~~~~^^^^^^^^^^~~~~~~~~!!!!!~~~^:..        ^B&&&&&&&&&&B7:^^:^~~~!?JJJJ???????7!!!!7777!#!~~~~~~~~~~~~~~~~::^::^ .77!!!~~~~~~~~~~~~~~~~~~~~~~~~~~
42               ^~~~~~~~~~!!!7?^ :^.:::^^~~~~~~~^^::::G5^~~^^::....::^^^^^^~~~~~~~~~~^:.             .7P#&&&&#P?^:^^:::::::^~7??????77!!!!!~~~~~^BJ~~~~~~~~~~~~~~~~^:^^:^: ~?7!!!~~~~~~~~~~~~~~~~~~~~~~~~~
43              .~~~~~~~~~~!!!77..^:.^:^^^~~~~~^^::::::PP^~^.          ..:^^^^~~~~~~~:       :.          .^!5~::::::~?!^^^^^^:^!77777777!!^^:~~~~^BY~~~~~~~~~~~~~~~~~:^^::~..77!!!~~~~~~~~~~~~~~~~~~~~~~~~~
44              .~~~~~~~~~~!!77~ :^.:::^^~~~~^^::^:::::J#^^.              ..:^^^^^^:.   ^77?JY:           .~5^:::::::!J5PJ!:^^::^~!777!~^:::^~!~~^#J^~~~~~~~~~~~~~~~~::^^:~: ~?7!!!~~~~~~~~~~~~~~~~~~~~~~~~
45              .~~~~~~~~~!!!7?: ^^.^:^^^~~~^^^^^^^^^^^~#?:                              :~5&Y7~:......::~?G#J~^^^^^~75P?^:^^^^^:::^^^^::^^:~!!!~!&!^^^^^^~~~~~~~~~~~^:^^:^^ .77!!!~~~~~~~~~~~~~~~~~~~~~~~~
46              .~~~~~~~~~!!!77..^:.^:^^^^^^^^^^^^^^^^^:J#^                                :B&#BPYJ????J5B&&&&BP5Y5PB&B!^:^^^^^^^^^^:^^^^^:^!!!!^5G:^^^^^^^^^^^~~~~~~~:^^:^~. !77!!~~~~~~~~~~~~~~~~~~~~~~~~
47               ^~~~~~~~~!!777 .~::^:^^^^^^^^^^^^^^^^^^^5B:                                !#&&&&#GPP555555PB&&&&&&&&J^:^^^^^^^^^^^^^^^^:^!!!!^7#^:^^^^^^^^^^^^^^^~~~:^^^:~. ~?7!!~~~~~~~~~~~~~~~~~~~~~~~~
48               :~~~~~~~~!!77! .~::^:^^^^^^^^^^^^^^^^^^^^PB^                               .7#&&BJ???????????G#####&Y~:^^^^^^^^^^^^^^^:^~!!!!^!#7.:^^^^^^^^^^^^^^^^~~:^^^:~: ^?7!!!~~~~~~~~~~~~~~~~~~~~~~~
49               .~~~~~~~~!!77! :~::^^^^^^^^^^^^^^^^^^^^~^^YB7                               .!G&G7777?????????B&#&#J~^^^^^^^^^^^^^^^:^^~!!!!^?B?..:^^^^^^^^^^^^^^^~~~:^^^:~: :?7!!!~~~~~~~~~~~~~~~~~~~~~~~
50                ~~~~~~~~!!77! .~::^^^^^^^^^^^^^^^^~~~~~~~^~PP^                               ^YG7^^^~!???????Y##P7~^^^^^^^^^^^^^:^^~~!!!!~~YG7^..^^^^^^^^^~~~~~~~~~~:^^^:~: :?7!!!~~~~~~~~~~~~~~~~~~~~~~~
51                ^~~~~~~~!!777 .~^.^^^^^^^^^^^^^~~~~~~~~~^^..7P5~.                             .~JJ7~^^^7???JY55?!^:^^::^^^:::^^^~~!!!!!~~?GY~~^..^^^~~~~~~~~~~~~~~~^:^^^^~: ^?7!!!~~~~~~~~~~~~~~~~~~~~~~~
52                :~~~~~~~!!777..~~.^^^~~~~~~^^~~~~~~~~~~~^^:..:?PP?^.                            .~7JJJ??JYYYJ?!^::::::::^^^^~~!!!!!!!~~JPY~^~~:.:^^~~~~~~~~~~~~~~~~^:~~^^~: ~?7!!!~~~~~~~~~~~~~~~~~~~~~~~
53                .~~~~~~~!!!7?^ ^~::^^~~~~~~~~~~~~~~~~~~~^^^:..:~75P57~:.                          .:^!7777!~^:..^~!777!~~!!!!!!!!!~~7Y5J~^^^~^..^^~~~~~~~~~~~~~~~~~:^~~^~~. !77!!~~~~~~~~~~~~~~~~~~~~~~~~
54                 ~~~~~~~!!!7?! :~^:^^^~~~~~~~~~~~~~^^^^^^^^^...~~~~?YP5J!~^::..                        .....:^?5PP5P5PBGY7!!!!~~!7Y5Y7^^^^^^~..:^^^^^^^~~~~~~~~~~~~:~~~^~^ .?77!!~~~~~~~~~~~~~~~~~~~~~~~:
55                 ^~~~~~~~!!77?: ^~:^^^~~~~~~~~~~^^^^^^^^^^^^:..:~~~^^^!BBP5J?!~~^^^^:::::........::::^^^~~~!JGP7: ...^!?PPJ?77YP5J7~^~~~~^^~:.:^^^^^^^^^^^~~~~~~~~:^~~^^~: ~?7!!!~~~~~~~~~~~~~~~~~~~~~~..
56                 .~~~~~~~!!!7?! :~^:~^^~~~~~~~^^^^^^^^^^~~~~~^..:~^^^^^BPJY5PPP5YJ?7!!!!~~~~~~!!!!!!!!!!!!JGG7:.       :^GGYJJ5PYJ?!~~~~~~~:..^^^^^^^^^^^^^~~~~~~~:~~~^~~..777!!~~~~~~~~~~~~~~~~~~~~~~: .
57                 .~~~~~~~~!!77?^ ^~^:~^~~~~~~^^^^^^^^~~~~~~~~~^..:^^^^!#J7???JJY55PPPP55YYJ???777777777?JGP7^^^^^:.    ^^Y#~~^. .^7J5Y7~~~:..^^^^~~~~^^^^^^^~~~~~:~~~^~~: ~?7!!!~~~~~~~~~~~~~~~~~~~~~^  .
58                  ^~~~~~~~!!!77?..~~:^~~~~~~~^^^^^^^~~~~~~~~~~~^:..^~~?#~^^~~~~~!!!777?JJYYY55555PP5PG##57^^~~~^^~~.  :^^GB7~.      ^J5P5!..^^~~~~~~~~~~~~~~~~~~:^~~~~~~ .?77!!!~~~~~~~~~~~~~~~~~~~~~.  .
59                  :~~~~~~~~!!!7?7 :~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~:..^~5P:^^^~~~^^^^~~~~~~~~~~~~~!~!?5PJ~^^~~~~~~~~: .:^^?&57~     .^!777J5PJ~^~~~~~~~~~~~~~~~~~:^~~~~~~. !?7!!!~~~~~~~~~~~~~~~~~~~~~.   .
60                   ~~~~~~~~~!!!7?! :~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~^..:B?^^^~~~~^^^^^^^^^~~~~~~~~!7J?!^^^~~~~~~~~~~:^^^^7&G?7!^. .!77777777?5G7^~~~~~~~~~~~~~~~:^~~~~~~: ~?77!!~~~~~~~~~~~~~~~~~~~~~:    .
61                   ^~~~~~~~~~!!77?! :~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~:!#^^^^~~~~~^^^^^^^^^^^^^^~~~~^^^^~~~~~~~~~~~!^^^^7&BJY?!~~^.:~7777777?7?#7~~~~~~~~~~~~~~:^~~~~~~^ ^?77!!!~~~~~~~~~~~~~~~~~~~~:     .
62                   .~~~~~~~~~!!!77?! :~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~P5:^^^^~~~~~~^^^^^~~~~~^^^^^^^~~~~~~~~~~~~~!?7!~J&G?77PPJ7!~^^7777777?J7B5~~~~~~~~~~~~^:^~~~~~~^ :?77!!!~~~~~~~~~~~~~~~~~~~~:      .
63                    ^~~~~~~~~~!!!!7?!..~~~~~~~~~~~~~~~~~~~~~!7?JJYYYY#~^^^^~~~~~~~~~~~~^^~~^^^^^^^~~~~~~~~~~~~~!???75&GJ?7!JG5P5Y??J????????J&J~~~~~~~~~~~^:~~~~~~~^ ^?77!!!~~~~~~~~~~~~~~~~~~~~:       .
64                    :~~~~~~~~~~!!!!7?7:.~~~~~~~~~~~~~~~~~7JYYJ?7!!!~5P:^^^^~~~~7!~~~~~~~~~~~~~~~~~~~~~~~~~~~~!!7??7P#GP#PJ7!PY?JYYYJJJJJJJ?J#P~~~~~~~~~~^:^~~~~~~~: ^?77!!!~~~~~~~~~~~~~~~~~~~~.        .
65                     ~~~~~~~~~~~~!!!7??^ ^~~~~~~~~~~~~7Y5Y7!~^~~~!!?#7^^^^^^~~!7?7!~~~~~~~~~~~~~~~~~~~~~~~~!!!7?7?BGJ7?BGJ7~75Y???JJJJ???J5B5~~~~~~~~~~^^~~~~~~~~. ~?77!!!~~~~~~~~~~~~~~~~~~~^.         .
66                     :~~~~~~~~~~~~!!!77?!.:~~~~~~~~~7PGJ!~^^^~~~!7?PB:^^^^^^~~~7JYJ7!!~~~~~~~~~~~~~~~~~~~!!!7??7YGBG7!YBJ7!!!7YYJ??JJJJYPG57~~~~~~~~~^^~~~~~~~~^ :7?7!!!!~~~~~~~~~~~~~~~~~~^.           .
67                      ~~~~~~~~~~~~~!!!77?7:.^~~~~~~5#Y~~~^^^~!!!?JY#Y~!!~~^^^~~~!?Y5Y??7!!~~~~~~~~~~~!!!!77??7?5P77JYYY7!!!!!!!?5BG55555Y?77?7???77~^~~~~~~~~^. ~??7!!!!~~~~~~~~~~~~~~~~~^:             .
68                      :~~~~~~~~~~~~~!!!!7??~..~~~~P#7~!^^^~~!!!?YY5&5???JJYJ!YYYY555GP5555Y7?JJJJ?7777?JJJJ7?YPJ7!~^^~^^~~~~~~!!7YBP??7!~~~~~~~~~!!7??!~~~~~: ^7?77!!!~~~~~~~~~~~~~~~~^:.               .
69                       ^~~~~~~~~~~~~~~!!!77??^.:^P&!~!~^^~!!!!?Y55G&!^~7!~!J##~^~G!^~~~~~!#PPJ!!7JPY?5PYJ?Y5GJY5JYY5JJY?!JYYY?!!7Y5J!~~~~~~~~~~~~~~~~!?J7^:.:7??7!!!!~~~~~~~~~~~~~^:..                  .
70                       .~~~~~~~~~~~~~~~~!!!7?J7 ~&J~!~^^~!!!!7YYPPB&7^7P?~!7&G:~7#5PY~!YP5&J^^7Y7^7#BJ^^~!^~JG#7^^5G^^~PBB~~7B??PJ!~~~^^^^^~~~~~^^^~~~~!J! ~J?77!!~~~~~^^^^:::..                        .
71                        :~~~~~~~~~~~~~~~~!!77?7 J&~!!~^~!!!!!?J5PPB&!^7!~!!P&5:!?#?GY^!G5YG:^?BYPY5&J:^JGP5~~Y&~^~GP:~~~GG:^!#JG?~~^^^^^~~~~~~~~^^^^^~~~~J7 ~!^^:...                                    .
72                         ^~~~~~~~~~~~~~~~!!!7?! 5B^!!~~~!!!!!?JYPGG#~~?BY!77#J^!JB7B?^!BYPY:~5G7555#~^!BY?#~^?B^^~BY:~~~!?^^7#GY~~~^^::::~~^~~~~^^~^^^~~~~5:.^:..                                       .
73                         .~~~~~~~~~~~~~~~~!!77! Y#~!!~~!!!!77?JJY5G#^~?!^~7Y&7^!YB7#!^7BJYG^!7P5J^!#?^!YPPJ:^GG^~!#7^~P!^~^~?#B7~^~^::^^^~~~~~~~^~~^^^^~~~J7 ^::..                                      .
74                          .~~~~~~~~~~~~~~~!!!77 ~&?!!!!!77????JJJJYGYY5555P5GY?JG57B7!JB?7P5?7!~~7PPG?!~!~^!5&5:~7#~^~B#7^~~JBB7~~~^^^^^^~~^~~~~^^^~^^^^~~?? ^::..                                      .
75                           .~~~~~~~~~~~~~~!!!7?~ 5B!7777????????JJJJYP!!!~~~~7??!:^PGGG5YYJJY5GGP5J?J555YY5PJJP??5#77?BYB7!!5GP5^~~^^^^~~~~~~~~~~^^~^^~~!^5:.^::..                                      .
76                            :~~~~~~~~~~~~~~!!!7?^ PP!7?????????????JJG7^^^~~~~~^. PJ~!PG!7JGYGJ?YB5JYPY?YG5Y5^.^^^^!?J7!7JYYJ?JGJ~~^^^^^^^~~~~~^^^^^^~~~~Y7 ^^:..                                       .
77                             :~~~~~~~~~~~~~!!!77?^ JG?7????????????JJGY!~^~~~~~: :B~~7B5:!!J&P:~7B^^~5G7P5^^Y5 .:^~~~~~~~~~~~!?JPY!^~~~^^^^^^^^^^^^~~~^!Y! :^:...                                       .
78                              .~~~~~~~~~~~~~!!!!7?!.^YY?77????????JJJ5B?7~~~~~^  ^B^!?#J^777YY:!JG^!7G57GY^!YG~!!!!!!!!!!!!!!!~?J5PY7~~~~~^^^^^~~~~~~7J7:.^^:...                                        .
79                               .^~~~~~~~~~~~~!!!!77?!.~JYJ?77???JJJJJJGP77!~~~:  7G:!?#7^?Y77!^7YG:!7#J7B7^!5P~!!!!!!!!!!!!!!~.^7?JY55Y?7!!!!!!!!77??!:.^^^:...                                         .
80                                 :~~~~~~~~~~~~~!!!!7??!^^!JYYJJJJJJJJJY#Y7?!~~:  J5:7J#~~?#5!7775#^!7PPP5^~7B?~!!!!!!!!!!!!!~.  .^7??JY?BP77??77!~^:::^^::...                                           .
81                                  .^~~~~~~~~~~~~~!!!!77?7!^^~?JY5555555P#Y7?7!.  Y5~?5B^!J#PY~77P&Y!77!~^~?G5~!!!!!!!!!!!!!^       ^!7?!&! ^^::::^^^^^::...                                             .
82                                    :^~~~~~~~~~~~~~!!!!!77??7~^^^~!7?JYY5B57?7^. :J?JJJPY55^BP55P?J5YYJJY5P?~~!!!!!!!!!!!^. .^    ! .7~GP ^!~~^^::::....                                                .
83                                      :^~~~~~~~~~~~~~~!!!!!777???77!!~~~^.YGJ^^^:?7.::7J:JPP#GPPYJYY5PGGP5YYYYYYYYYYYYY5Y7~:?7   ~5~5#PJ.:~^::......                                                    .
84                                        .^~~~~~~~~~~~~~~~!!!!!!!7777????J!.~YYJ?5577?PGY5GJ~^~~~~~~~~^^^^^^^^^^^^^^^^^:^7Y55G555PB55Y7:.^^::...                                                         .
85                                           .^~~~~~~~~~~~~~~~~~!!!!!!!!777??!^^~7?7??77~^^::^~~~~~~^^^^^^~~~~~~~~~~~~~~~~^::::^^^^^::::^^::...                                                           .
86                                              .::^~~~~~~~~~~~~~~~~~!!!!!!~~~~~^::::^^^^^^^^^^:::::::::::::::::::::::::::^^^^^^^^^^^^^::....                                                             .
87                                                   ...:::^^^^^^^^::::.........:::::::::::...................................::::::......                                                                .
88                                                                             ............                                                                                                               .
89                                                                                                                                                                                                        .
90                                                                                                                                                                                                        .
91                                                                                                                                                                                                        .
92                                                                                                                                                                                                        .
93                                                                                                                                                                                                        .
94                                                                                                                                                                                                        .
95                                                                                                                                                                                                        .
96                                                                                                                                                                                                        
97 https://btc-inu.com/
98 
99 https://t.me/BitcoinInuERC
100 
101 https://twitter.com/Bitcoin_Inu_
102 
103 */
104 
105 // SPDX-License-Identifier: MIT
106 
107 pragma solidity 0.8.15;
108 
109 abstract contract Context {
110     function _msgSender() internal view virtual returns (address) {
111         return msg.sender;
112     }
113 
114     function _msgData() internal view virtual returns (bytes calldata) {
115         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
116         return msg.data;
117     }
118 }
119 
120 interface IERC20 {
121     /**
122      * @dev Returns the amount of tokens in existence.
123      */
124     function totalSupply() external view returns (uint256);
125 
126     /**
127      * @dev Returns the amount of tokens owned by `account`.
128      */
129     function balanceOf(address account) external view returns (uint256);
130 
131     /**
132      * @dev Moves `amount` tokens from the caller's account to `recipient`.
133      *
134      * Returns a boolean value indicating whether the operation succeeded.
135      *
136      * Emits a {Transfer} event.
137      */
138     function transfer(address recipient, uint256 amount) external returns (bool);
139 
140     /**
141      * @dev Returns the remaining number of tokens that `spender` will be
142      * allowed to spend on behalf of `owner` through {transferFrom}. This is
143      * zero by default.
144      *
145      * This value changes when {approve} or {transferFrom} are called.
146      */
147     function allowance(address owner, address spender) external view returns (uint256);
148 
149     /**
150      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
151      *
152      * Returns a boolean value indicating whether the operation succeeded.
153      *
154      * IMPORTANT: Beware that changing an allowance with this method brings the risk
155      * that someone may use both the old and the new allowance by unfortunate
156      * transaction ordering. One possible solution to mitigate this race
157      * condition is to first reduce the spender's allowance to 0 and set the
158      * desired value afterwards:
159      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
160      *
161      * Emits an {Approval} event.
162      */
163     function approve(address spender, uint256 amount) external returns (bool);
164 
165     /**
166      * @dev Moves `amount` tokens from `sender` to `recipient` using the
167      * allowance mechanism. `amount` is then deducted from the caller's
168      * allowance.
169      *
170      * Returns a boolean value indicating whether the operation succeeded.
171      *
172      * Emits a {Transfer} event.
173      */
174     function transferFrom(
175         address sender,
176         address recipient,
177         uint256 amount
178     ) external returns (bool);
179 
180     /**
181      * @dev Emitted when `value` tokens are moved from one account (`from`) to
182      * another (`to`).
183      *
184      * Note that `value` may be zero.
185      */
186     event Transfer(address indexed from, address indexed to, uint256 value);
187 
188     /**
189      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
190      * a call to {approve}. `value` is the new allowance.
191      */
192     event Approval(address indexed owner, address indexed spender, uint256 value);
193 }
194 
195 interface IERC20Metadata is IERC20 {
196     /**
197      * @dev Returns the name of the token.
198      */
199     function name() external view returns (string memory);
200 
201     /**
202      * @dev Returns the symbol of the token.
203      */
204     function symbol() external view returns (string memory);
205 
206     /**
207      * @dev Returns the decimals places of the token.
208      */
209     function decimals() external view returns (uint8);
210 }
211 
212 contract ERC20 is Context, IERC20, IERC20Metadata {
213     mapping(address => uint256) private _balances;
214 
215     mapping(address => mapping(address => uint256)) private _allowances;
216 
217     uint256 private _totalSupply;
218 
219     string private _name;
220     string private _symbol;
221 
222     constructor(string memory name_, string memory symbol_) {
223         _name = name_;
224         _symbol = symbol_;
225     }
226 
227     function name() public view virtual override returns (string memory) {
228         return _name;
229     }
230 
231     function symbol() public view virtual override returns (string memory) {
232         return _symbol;
233     }
234 
235     function decimals() public view virtual override returns (uint8) {
236         return 18;
237     }
238 
239     function totalSupply() public view virtual override returns (uint256) {
240         return _totalSupply;
241     }
242 
243     function balanceOf(address account) public view virtual override returns (uint256) {
244         return _balances[account];
245     }
246 
247     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
248         _transfer(_msgSender(), recipient, amount);
249         return true;
250     }
251 
252     function allowance(address owner, address spender) public view virtual override returns (uint256) {
253         return _allowances[owner][spender];
254     }
255 
256     function approve(address spender, uint256 amount) public virtual override returns (bool) {
257         _approve(_msgSender(), spender, amount);
258         return true;
259     }
260 
261     function transferFrom(
262         address sender,
263         address recipient,
264         uint256 amount
265     ) public virtual override returns (bool) {
266         _transfer(sender, recipient, amount);
267 
268         uint256 currentAllowance = _allowances[sender][_msgSender()];
269         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
270         unchecked {
271             _approve(sender, _msgSender(), currentAllowance - amount);
272         }
273 
274         return true;
275     }
276 
277     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
278         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
279         return true;
280     }
281 
282     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
283         uint256 currentAllowance = _allowances[_msgSender()][spender];
284         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
285         unchecked {
286             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
287         }
288 
289         return true;
290     }
291 
292     function _transfer(
293         address sender,
294         address recipient,
295         uint256 amount
296     ) internal virtual {
297         require(sender != address(0), "ERC20: transfer from the zero address");
298         require(recipient != address(0), "ERC20: transfer to the zero address");
299 
300         uint256 senderBalance = _balances[sender];
301         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
302         unchecked {
303             _balances[sender] = senderBalance - amount;
304         }
305         _balances[recipient] += amount;
306 
307         emit Transfer(sender, recipient, amount);
308     }
309 
310     function _createInitialSupply(address account, uint256 amount) internal virtual {
311         require(account != address(0), "ERC20: mint to the zero address");
312 
313         _totalSupply += amount;
314         _balances[account] += amount;
315         emit Transfer(address(0), account, amount);
316     }
317 
318     function _burn(address account, uint256 amount) internal virtual {
319         require(account != address(0), "ERC20: burn from the zero address");
320         uint256 accountBalance = _balances[account];
321         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
322         unchecked {
323             _balances[account] = accountBalance - amount;
324             // Overflow not possible: amount <= accountBalance <= totalSupply.
325             _totalSupply -= amount;
326         }
327 
328         emit Transfer(account, address(0), amount);
329     }
330 
331     function _approve(
332         address owner,
333         address spender,
334         uint256 amount
335     ) internal virtual {
336         require(owner != address(0), "ERC20: approve from the zero address");
337         require(spender != address(0), "ERC20: approve to the zero address");
338 
339         _allowances[owner][spender] = amount;
340         emit Approval(owner, spender, amount);
341     }
342 }
343 
344 contract Ownable is Context {
345     address private _owner;
346 
347     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
348 
349     constructor () {
350         address msgSender = _msgSender();
351         _owner = msgSender;
352         emit OwnershipTransferred(address(0), msgSender);
353     }
354 
355     function owner() public view returns (address) {
356         return _owner;
357     }
358 
359     modifier onlyOwner() {
360         require(_owner == _msgSender(), "Ownable: caller is not the owner");
361         _;
362     }
363 
364     function renounceOwnership() external virtual onlyOwner {
365         emit OwnershipTransferred(_owner, address(0));
366         _owner = address(0);
367     }
368 
369     function transferOwnership(address newOwner) public virtual onlyOwner {
370         require(newOwner != address(0), "Ownable: new owner is the zero address");
371         emit OwnershipTransferred(_owner, newOwner);
372         _owner = newOwner;
373     }
374 }
375 
376 interface IDexRouter {
377     function factory() external pure returns (address);
378     function WETH() external pure returns (address);
379 
380     function swapExactTokensForETHSupportingFeeOnTransferTokens(
381         uint amountIn,
382         uint amountOutMin,
383         address[] calldata path,
384         address to,
385         uint deadline
386     ) external;
387 
388     function swapExactETHForTokensSupportingFeeOnTransferTokens(
389         uint amountOutMin,
390         address[] calldata path,
391         address to,
392         uint deadline
393     ) external payable;
394 
395     function addLiquidityETH(
396         address token,
397         uint256 amountTokenDesired,
398         uint256 amountTokenMin,
399         uint256 amountETHMin,
400         address to,
401         uint256 deadline
402     )
403         external
404         payable
405         returns (
406             uint256 amountToken,
407             uint256 amountETH,
408             uint256 liquidity
409         );
410 }
411 
412 interface IDexFactory {
413     function createPair(address tokenA, address tokenB)
414         external
415         returns (address pair);
416 }
417 
418 contract BitcoinInu is ERC20, Ownable {
419 
420     uint256 public maxBuyAmount;
421     uint256 public maxSellAmount;
422     uint256 public maxWalletAmount;
423 
424     IDexRouter public dexRouter;
425     address public lpPair;
426 
427     bool private swapping;
428     uint256 public swapTokensAtAmount;
429 
430     address operationsAddress;
431     address devAddress;
432 
433     uint256 public tradingActiveBlock = 0; // 0 means trading is not active
434     uint256 public blockForPenaltyEnd;
435     mapping (address => bool) public boughtEarly;
436     uint256 public botsCaught;
437 
438     bool public limitsInEffect = true;
439     bool public tradingActive = false;
440     bool public swapEnabled = false;
441 
442      // Anti-bot and anti-whale mappings and variables
443     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
444     bool public transferDelayEnabled = true;
445 
446     uint256 public buyTotalFees;
447     uint256 public buyOperationsFee;
448     uint256 public buyLiquidityFee;
449     uint256 public buyDevFee;
450     uint256 public buyBurnFee;
451 
452     uint256 public sellTotalFees;
453     uint256 public sellOperationsFee;
454     uint256 public sellLiquidityFee;
455     uint256 public sellDevFee;
456     uint256 public sellBurnFee;
457 
458     uint256 public tokensForOperations;
459     uint256 public tokensForLiquidity;
460     uint256 public tokensForDev;
461     uint256 public tokensForBurn;
462 
463     /******************/
464 
465     // exlcude from fees and max transaction amount
466     mapping (address => bool) private _isExcludedFromFees;
467     mapping (address => bool) public _isExcludedMaxTransactionAmount;
468 
469     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
470     // could be subject to a maximum transfer amount
471     mapping (address => bool) public automatedMarketMakerPairs;
472 
473     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
474 
475     event EnabledTrading();
476 
477     event RemovedLimits();
478 
479     event ExcludeFromFees(address indexed account, bool isExcluded);
480 
481     event UpdatedMaxBuyAmount(uint256 newAmount);
482 
483     event UpdatedMaxSellAmount(uint256 newAmount);
484 
485     event UpdatedMaxWalletAmount(uint256 newAmount);
486 
487     event UpdatedOperationsAddress(address indexed newWallet);
488 
489     event MaxTransactionExclusion(address _address, bool excluded);
490 
491     event BuyBackTriggered(uint256 amount);
492 
493     event OwnerForcedSwapBack(uint256 timestamp);
494  
495     event CaughtEarlyBuyer(address sniper);
496 
497     event SwapAndLiquify(
498         uint256 tokensSwapped,
499         uint256 ethReceived,
500         uint256 tokensIntoLiquidity
501     );
502 
503     event TransferForeignToken(address token, uint256 amount);
504 
505     constructor() ERC20("Bitcoin Inu", "BTCINU") {
506 
507         address newOwner = msg.sender; // can leave alone if owner is deployer.
508 
509         IDexRouter _dexRouter = IDexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
510         dexRouter = _dexRouter;
511 
512         // create pair
513         lpPair = IDexFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
514         _excludeFromMaxTransaction(address(lpPair), true);
515         _setAutomatedMarketMakerPair(address(lpPair), true);
516 
517         uint256 totalSupply = 1 * 1e9 * 1e18;
518 
519         maxBuyAmount = totalSupply * 1 / 100;
520         maxSellAmount = totalSupply * 1 / 100;
521         maxWalletAmount = totalSupply * 1 / 100;
522         swapTokensAtAmount = totalSupply * 5 / 10000;
523 
524         buyOperationsFee = 8;
525         buyLiquidityFee = 0;
526         buyDevFee = 0;
527         buyBurnFee = 0;
528         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
529 
530         sellOperationsFee = 8;
531         sellLiquidityFee = 0;
532         sellDevFee = 0;
533         sellBurnFee = 0;
534         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
535 
536         _excludeFromMaxTransaction(newOwner, true);
537         _excludeFromMaxTransaction(address(this), true);
538         _excludeFromMaxTransaction(address(0xdead), true);
539 
540         excludeFromFees(newOwner, true);
541         excludeFromFees(address(this), true);
542         excludeFromFees(address(0xdead), true);
543 
544         operationsAddress = address(newOwner);
545         devAddress = address(newOwner);
546 
547         _createInitialSupply(newOwner, totalSupply);
548         transferOwnership(newOwner);
549     }
550 
551     receive() external payable {}
552 
553     // only enable if no plan to airdrop
554 
555     function enableTrading(uint256 deadBlocks) external onlyOwner {
556         require(!tradingActive, "Cannot reenable trading");
557         tradingActive = true;
558         swapEnabled = true;
559         tradingActiveBlock = block.number;
560         blockForPenaltyEnd = tradingActiveBlock + deadBlocks;
561         emit EnabledTrading();
562     }
563 
564     // remove limits after token is stable
565     function removeLimits() external onlyOwner {
566         limitsInEffect = false;
567         transferDelayEnabled = false;
568         emit RemovedLimits();
569     }
570 
571     function manageBoughtEarly(address wallet, bool flag) external onlyOwner {
572         boughtEarly[wallet] = flag;
573     }
574 
575     function massManageBoughtEarly(address[] calldata wallets, bool flag) external onlyOwner {
576         for(uint256 i = 0; i < wallets.length; i++){
577             boughtEarly[wallets[i]] = flag;
578         }
579     }
580 
581     // disable Transfer delay - cannot be reenabled
582     function disableTransferDelay() external onlyOwner {
583         transferDelayEnabled = false;
584     }
585 
586     function updateMaxBuyAmount(uint256 newNum) external onlyOwner {
587         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max buy amount lower than 0.2%");
588         maxBuyAmount = newNum * (10**18);
589         emit UpdatedMaxBuyAmount(maxBuyAmount);
590     }
591 
592     function updateMaxSellAmount(uint256 newNum) external onlyOwner {
593         require(newNum >= (totalSupply() * 2 / 1000)/1e18, "Cannot set max sell amount lower than 0.2%");
594         maxSellAmount = newNum * (10**18);
595         emit UpdatedMaxSellAmount(maxSellAmount);
596     }
597 
598     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
599         require(newNum >= (totalSupply() * 3 / 1000)/1e18, "Cannot set max wallet amount lower than 0.3%");
600         maxWalletAmount = newNum * (10**18);
601         emit UpdatedMaxWalletAmount(maxWalletAmount);
602     }
603 
604     // change the minimum amount of tokens to sell from fees
605     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner {
606   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
607   	    require(newAmount <= totalSupply() * 1 / 1000, "Swap amount cannot be higher than 0.1% total supply.");
608   	    swapTokensAtAmount = newAmount;
609   	}
610 
611     function _excludeFromMaxTransaction(address updAds, bool isExcluded) private {
612         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
613         emit MaxTransactionExclusion(updAds, isExcluded);
614     }
615 
616     function airdropToWallets(address[] memory wallets, uint256[] memory amountsInTokens) external onlyOwner {
617         require(wallets.length == amountsInTokens.length, "arrays must be the same length");
618         require(wallets.length < 600, "Can only airdrop 600 wallets per txn due to gas limits"); // allows for airdrop + launch at the same exact time, reducing delays and reducing sniper input.
619         for(uint256 i = 0; i < wallets.length; i++){
620             address wallet = wallets[i];
621             uint256 amount = amountsInTokens[i];
622             super._transfer(msg.sender, wallet, amount);
623         }
624     }
625 
626     function excludeFromMaxTransaction(address updAds, bool isEx) external onlyOwner {
627         if(!isEx){
628             require(updAds != lpPair, "Cannot remove uniswap pair from max txn");
629         }
630         _isExcludedMaxTransactionAmount[updAds] = isEx;
631     }
632 
633     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
634         require(pair != lpPair, "The pair cannot be removed from automatedMarketMakerPairs");
635 
636         _setAutomatedMarketMakerPair(pair, value);
637         emit SetAutomatedMarketMakerPair(pair, value);
638     }
639 
640     function _setAutomatedMarketMakerPair(address pair, bool value) private {
641         automatedMarketMakerPairs[pair] = value;
642 
643         _excludeFromMaxTransaction(pair, value);
644 
645         emit SetAutomatedMarketMakerPair(pair, value);
646     }
647 
648     function updateBuyFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _devFee, uint256 _burnFee) external onlyOwner {
649         buyOperationsFee = _operationsFee;
650         buyLiquidityFee = _liquidityFee;
651         buyDevFee = _devFee;
652         buyBurnFee = _burnFee;
653         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
654         require(buyTotalFees <= 30, "Must keep fees at 30% or less");
655     }
656 
657     function updateSellFees(uint256 _operationsFee, uint256 _liquidityFee, uint256 _devFee, uint256 _burnFee) external onlyOwner {
658         sellOperationsFee = _operationsFee;
659         sellLiquidityFee = _liquidityFee;
660         sellDevFee = _devFee;
661         sellBurnFee = _burnFee;
662         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
663         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
664     }
665 
666     function returnToNormalTax() external onlyOwner {
667         sellOperationsFee = 0;
668         sellLiquidityFee = 0;
669         sellDevFee = 0;
670         sellBurnFee = 0;
671         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee + sellBurnFee;
672         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
673 
674         buyOperationsFee = 0;
675         buyLiquidityFee = 0;
676         buyDevFee = 0;
677         buyBurnFee = 0;
678         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee + buyBurnFee;
679         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
680     }
681 
682     function excludeFromFees(address account, bool excluded) public onlyOwner {
683         _isExcludedFromFees[account] = excluded;
684         emit ExcludeFromFees(account, excluded);
685     }
686 
687     function _transfer(address from, address to, uint256 amount) internal override {
688 
689         require(from != address(0), "ERC20: transfer from the zero address");
690         require(to != address(0), "ERC20: transfer to the zero address");
691         require(amount > 0, "amount must be greater than 0");
692 
693         if(!tradingActive){
694             require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
695         }
696 
697         if(blockForPenaltyEnd > 0){
698             require(!boughtEarly[from] || to == owner() || to == address(0xdead), "Bots cannot transfer tokens in or out except to owner or dead address.");
699         }
700 
701         if(limitsInEffect){
702             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]){
703 
704                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
705                 if (transferDelayEnabled){
706                     if (to != address(dexRouter) && to != address(lpPair)){
707                         require(_holderLastTransferTimestamp[tx.origin] < block.number - 2 && _holderLastTransferTimestamp[to] < block.number - 2, "_transfer:: Transfer Delay enabled.  Try again later.");
708                         _holderLastTransferTimestamp[tx.origin] = block.number;
709                         _holderLastTransferTimestamp[to] = block.number;
710                     }
711                 }
712     
713                 //when buy
714                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
715                         require(amount <= maxBuyAmount, "Buy transfer amount exceeds the max buy.");
716                         require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
717                 }
718                 //when sell
719                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
720                         require(amount <= maxSellAmount, "Sell transfer amount exceeds the max sell.");
721                 }
722                 else if (!_isExcludedMaxTransactionAmount[to]){
723                     require(amount + balanceOf(to) <= maxWalletAmount, "Cannot Exceed max wallet");
724                 }
725             }
726         }
727 
728         uint256 contractTokenBalance = balanceOf(address(this));
729 
730         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
731 
732         if(canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
733             swapping = true;
734 
735             swapBack();
736 
737             swapping = false;
738         }
739 
740         bool takeFee = true;
741         // if any account belongs to _isExcludedFromFee account then remove the fee
742         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
743             takeFee = false;
744         }
745 
746         uint256 fees = 0;
747         // only take fees on buys/sells, do not take on wallet transfers
748         if(takeFee){
749             // bot/sniper penalty.
750             if(earlyBuyPenaltyInEffect() && automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to] && buyTotalFees > 0){
751 
752                 if(!boughtEarly[to]){
753                     boughtEarly[to] = true;
754                     botsCaught += 1;
755                     emit CaughtEarlyBuyer(to);
756                 }
757 
758                 fees = amount * 99 / 100;
759         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
760                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
761                 tokensForDev += fees * buyDevFee / buyTotalFees;
762                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
763             }
764 
765             // on sell
766             else if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
767                 fees = amount * sellTotalFees / 100;
768                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
769                 tokensForOperations += fees * sellOperationsFee / sellTotalFees;
770                 tokensForDev += fees * sellDevFee / sellTotalFees;
771                 tokensForBurn += fees * sellBurnFee / sellTotalFees;
772             }
773 
774             // on buy
775             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
776         	    fees = amount * buyTotalFees / 100;
777         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
778                 tokensForOperations += fees * buyOperationsFee / buyTotalFees;
779                 tokensForDev += fees * buyDevFee / buyTotalFees;
780                 tokensForBurn += fees * buyBurnFee / buyTotalFees;
781             }
782 
783             if(fees > 0){
784                 super._transfer(from, address(this), fees);
785             }
786 
787         	amount -= fees;
788         }
789 
790         super._transfer(from, to, amount);
791     }
792 
793     function earlyBuyPenaltyInEffect() public view returns (bool){
794         return block.number < blockForPenaltyEnd;
795     }
796 
797     function swapTokensForEth(uint256 tokenAmount) private {
798 
799         // generate the uniswap pair path of token -> weth
800         address[] memory path = new address[](2);
801         path[0] = address(this);
802         path[1] = dexRouter.WETH();
803 
804         _approve(address(this), address(dexRouter), tokenAmount);
805 
806         // make the swap
807         dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
808             tokenAmount,
809             0, // accept any amount of ETH
810             path,
811             address(this),
812             block.timestamp
813         );
814     }
815 
816     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
817         // approve token transfer to cover all possible scenarios
818         _approve(address(this), address(dexRouter), tokenAmount);
819 
820         // add the liquidity
821         dexRouter.addLiquidityETH{value: ethAmount}(
822             address(this),
823             tokenAmount,
824             0, // slippage is unavoidable
825             0, // slippage is unavoidable
826             address(0xdead),
827             block.timestamp
828         );
829     }
830 
831     function swapBack() private {
832 
833         if(tokensForBurn > 0 && balanceOf(address(this)) >= tokensForBurn) {
834             _burn(address(this), tokensForBurn);
835         }
836         tokensForBurn = 0;
837 
838         uint256 contractBalance = balanceOf(address(this));
839         uint256 totalTokensToSwap = tokensForLiquidity + tokensForOperations + tokensForDev;
840 
841         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
842 
843         if(contractBalance > swapTokensAtAmount * 60){
844             contractBalance = swapTokensAtAmount * 60;
845         }
846 
847         bool success;
848 
849         // Halve the amount of liquidity tokens
850         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
851 
852         swapTokensForEth(contractBalance - liquidityTokens);
853 
854         uint256 ethBalance = address(this).balance;
855         uint256 ethForLiquidity = ethBalance;
856 
857         uint256 ethForOperations = ethBalance * tokensForOperations / (totalTokensToSwap - (tokensForLiquidity/2));
858         uint256 ethForDev = ethBalance * tokensForDev / (totalTokensToSwap - (tokensForLiquidity/2));
859 
860         ethForLiquidity -= ethForOperations + ethForDev;
861 
862         tokensForLiquidity = 0;
863         tokensForOperations = 0;
864         tokensForDev = 0;
865         tokensForBurn = 0;
866 
867         if(liquidityTokens > 0 && ethForLiquidity > 0){
868             addLiquidity(liquidityTokens, ethForLiquidity);
869         }
870 
871         (success,) = address(devAddress).call{value: ethForDev}("");
872 
873         (success,) = address(operationsAddress).call{value: address(this).balance}("");
874     }
875 
876     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
877         require(_token != address(0), "_token address cannot be 0");
878         require(_token != address(this), "Can't withdraw native tokens");
879         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
880         _sent = IERC20(_token).transfer(_to, _contractBalance);
881         emit TransferForeignToken(_token, _contractBalance);
882     }
883 
884     // withdraw ETH if stuck or someone sends to the address
885     function withdrawStuckETH() external onlyOwner {
886         bool success;
887         (success,) = address(msg.sender).call{value: address(this).balance}("");
888     }
889 
890     function setOperationsAddress(address _operationsAddress) external onlyOwner {
891         require(_operationsAddress != address(0), "_operationsAddress address cannot be 0");
892         operationsAddress = payable(_operationsAddress);
893     }
894 
895     function setDevAddress(address _devAddress) external onlyOwner {
896         require(_devAddress != address(0), "_devAddress address cannot be 0");
897         devAddress = payable(_devAddress);
898     }
899 
900     // force Swap back if slippage issues.
901     function forceSwapBack() external onlyOwner {
902         require(balanceOf(address(this)) >= swapTokensAtAmount, "Can only swap when token amount is at or higher than restriction");
903         swapping = true;
904         swapBack();
905         swapping = false;
906         emit OwnerForcedSwapBack(block.timestamp);
907     }
908 
909     // useful for buybacks or to reclaim any ETH on the contract in a way that helps holders.
910     function buyBackTokens(uint256 amountInWei) external onlyOwner {
911         require(amountInWei <= 10 ether, "May not buy more than 10 ETH in a single buy to reduce sandwich attacks");
912 
913         address[] memory path = new address[](2);
914         path[0] = dexRouter.WETH();
915         path[1] = address(this);
916 
917         // make the swap
918         dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amountInWei}(
919             0, // accept any amount of Ethereum
920             path,
921             address(0xdead),
922             block.timestamp
923         );
924         emit BuyBackTriggered(amountInWei);
925     }
926 }