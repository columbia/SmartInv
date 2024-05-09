1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.18;
3 
4 //        |-----------------------------------------------------------------------------------------------------------|
5 //        |                                                                        %################.                 |
6 //        |                                                                       #####################@              |
7 //        |                                                         |           ######    @#####    &####             |
8 //        |                                                         |           ###%        ,         ###%            |
9 //        |                                                         |          &###,  /&@@     @(@@   ####            |
10 //        |                                                         |           ###@       &..%      *####            |
11 //        |  $$$$$$$\  $$$$$$$$\ $$\   $$\  $$$$$$\ $$\     $$\     |           @####     .,,,,@    #####             |
12 //        |  $$  __$$\ $$  _____|$$$\  $$ |$$  __$$\\$$\   $$  |    |            %##(       ,*      @##(@             |
13 //        |  $$ |  $$ |$$ |      $$$$\ $$ |$$ /  \__|\$$\ $$  /     |        /#&##@                    ##&#&          |
14 //        |  $$$$$$$  |$$$$$\    $$ $$\$$ |$$ |$$$$\  \$$$$  /      |       ######                        #(###       |
15 //        |  $$  ____/ $$  __|   $$ \$$$$ |$$ |\_$$ |  \$$  /       |    #######                          ######.     |
16 //        |  $$ |      $$ |      $$ |\$$$ |$$ |  $$ |   $$ |        |  &#######@                          ##(#####    |
17 //        |  $$ |      $$$$$$$$\ $$ | \$$ |\$$$$$$  |   $$ |        |        ###                           &##        |
18 //        |  \__|      \________|\__|  \__| \______/    \__|        |        &##%                          ###        |
19 //        |                                                         |         %###                        @##@        |
20 //        |                                                         |           %###@                  &###&          |
21 //        |                                                                    &,,,,,&################@,,,,,%         |
22 //        |                                                                  ,.,,,.*%@               /(.,,,,/@        |
23 //        |-----------------------------------------------------------------------------------------------------------|
24 //                                -----> Ken and the community makes penguins fly! 🚀  <-----     */
25 
26 interface IERC20 {
27     function totalSupply() external view returns (uint256);
28 
29     function decimals() external view returns (uint8);
30 
31     function symbol() external view returns (string memory);
32 
33     function name() external view returns (string memory);
34 
35     function balanceOf(address account) external view returns (uint256);
36 
37     function transfer(
38         address recipient,
39         uint256 amount
40     ) external returns (bool);
41 
42     function allowance(
43         address _owner,
44         address spender
45     ) external view returns (uint256);
46 
47     function approve(address spender, uint256 amount) external returns (bool);
48 
49     function transferFrom(
50         address sender,
51         address recipient,
52         uint256 amount
53     ) external returns (bool);
54 
55     event Transfer(address indexed from, address indexed to, uint256 value);
56     event Approval(
57         address indexed owner,
58         address indexed spender,
59         uint256 value
60     );
61 }
62 
63 interface IDEXRouter {
64     function factory() external pure returns (address);
65 
66     function WETH() external pure returns (address);
67 }
68 
69 interface IDEXFactory {
70     function createPair(
71         address tokenA,
72         address tokenB
73     ) external returns (address pair);
74 }
75 
76 contract Pengy is IERC20 {
77     string private _name;
78     string private _symbol;
79     uint8 private constant _decimals = 18;
80     uint256 private _totalSupply;
81 
82     mapping(address => bool) public isExcludedFromFees;
83     mapping(address => uint256) private _balances;
84     mapping(address => mapping(address => uint256)) private _allowances;
85 
86     address public owner;
87     address public constant feeWallet = 0xe7bE0E9c3a5650dB004E306FC9D9cCE97eEe7166; 
88     address public immutable pair;
89     address public immutable router;
90     address public constant DEAD = 0x000000000000000000000000000000000000dEaD;
91     address public immutable WETH;
92 
93     modifier onlyDeployer() {
94         require(msg.sender == owner, "Only the owner can do that");
95         _;
96     }
97 
98     constructor() {
99         owner = msg.sender;
100         _name = "PENGY";
101         _symbol = "PENGY";
102         _totalSupply = 3_000_000_000 * (10 ** _decimals);
103         router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // Uniswap V2 router
104 
105         WETH = IDEXRouter(router).WETH();
106 
107         pair = IDEXFactory(IDEXRouter(router).factory()).createPair(
108             address(this),
109             WETH
110         );
111 
112         isExcludedFromFees[owner] = true;
113         
114 
115         _balances[owner] = _totalSupply;
116         emit Transfer(address(0), owner, _totalSupply);
117     }
118 
119     receive() external payable {}
120 
121     function name() public view override returns (string memory) {
122         return _name;
123     }
124 
125     function totalSupply() public view override returns (uint256) {
126         return _totalSupply - _balances[DEAD];
127     }
128 
129     function decimals() public pure override returns (uint8) {
130         return _decimals;
131     }
132 
133     function symbol() public view override returns (string memory) {
134         return _symbol;
135     }
136 
137     function balanceOf(address account) public view override returns (uint256) {
138         return _balances[account];
139     }
140 
141     function rescueEth(uint256 amount) external onlyDeployer {
142         (bool success, ) = address(owner).call{value: amount}("");
143         success = true;
144     }
145 
146     function rescueToken(address token, uint256 amount) external onlyDeployer {
147         IERC20(token).transfer(owner, amount);
148     }
149 
150     function allowance(
151         address holder,
152         address spender
153     ) public view override returns (uint256) {
154         return _allowances[holder][spender];
155     }
156 
157     function transfer(
158         address recipient,
159         uint256 amount
160     ) external override returns (bool) {
161         return _transferFrom(msg.sender, recipient, amount);
162     }
163 
164     function approveMax(address spender) external returns (bool) {
165         return approve(spender, type(uint256).max);
166     }
167 
168     function approve(
169         address spender,
170         uint256 amount
171     ) public override returns (bool) {
172         require(spender != address(0), "Can't use zero address here");
173         _allowances[msg.sender][spender] = amount;
174         emit Approval(msg.sender, spender, amount);
175         return true;
176     }
177 
178     function increaseAllowance(
179         address spender,
180         uint256 addedValue
181     ) public returns (bool) {
182         require(spender != address(0), "Can't use zero address here");
183         _allowances[msg.sender][spender] =
184             allowance(msg.sender, spender) +
185             addedValue;
186         emit Approval(msg.sender, spender, _allowances[msg.sender][spender]);
187         return true;
188     }
189 
190     function decreaseAllowance(
191         address spender,
192         uint256 subtractedValue
193     ) public returns (bool) {
194         require(spender != address(0), "Can't use zero address here");
195         require(
196             allowance(msg.sender, spender) >= subtractedValue,
197             "Can't subtract more than current allowance"
198         );
199         _allowances[msg.sender][spender] =
200             allowance(msg.sender, spender) -
201             subtractedValue;
202         emit Approval(msg.sender, spender, _allowances[msg.sender][spender]);
203         return true;
204     }
205 
206     function transferFrom(
207         address sender,
208         address recipient,
209         uint256 amount
210     ) external override returns (bool) {
211         if (_allowances[sender][msg.sender] != type(uint256).max) {
212             require(
213                 _allowances[sender][msg.sender] >= amount,
214                 "Insufficient Allowance"
215             );
216             _allowances[sender][msg.sender] -= amount;
217             emit Approval(sender, msg.sender, _allowances[sender][msg.sender]);
218         }
219         return _transferFrom(sender, recipient, amount);
220     }
221 
222     function _transferFrom(
223         address sender,
224         address recipient,
225         uint256 amount
226     ) internal returns (bool) {
227         if (!checkTaxFree(sender, recipient)) {
228             _lowGasTransfer(sender, feeWallet, amount / 100);
229             amount = (amount * 99) / 100;
230         }
231         return _lowGasTransfer(sender, recipient, amount);
232     }
233 
234     function checkTaxFree(
235         address sender,
236         address recipient
237     ) internal view returns (bool) {
238         if (isExcludedFromFees[sender] || isExcludedFromFees[recipient])
239             return true;
240         if (sender == pair || recipient == pair) return false;
241         return true;
242     }
243 
244     function _lowGasTransfer(
245         address sender,
246         address recipient,
247         uint256 amount
248     ) internal returns (bool) {
249         require(sender != address(0), "Can't use zero addresses here");
250         require(
251             amount <= _balances[sender],
252             "Can't transfer more than you own"
253         );
254         if (amount == 0) return true;
255         _balances[sender] -= amount;
256         _balances[recipient] += amount;
257         emit Transfer(sender, recipient, amount);
258         return true;
259     }
260 
261     function excludeFromFees(
262         address excludedWallet,
263         bool status
264     ) external onlyDeployer {
265         isExcludedFromFees[excludedWallet] = status;
266     }
267 
268     function renounceOwnership() external onlyDeployer {
269         owner = address(0);
270     }
271 }
272 
273 /*
274 
275 The topics and opinions discussed by Ken the Crypto and the PENGY community are intended to convey general information only. All opinions expressed by Ken or the community should be treated as such.
276 
277 This contract does not provide legal, investment, financial, tax, or any other type of similar advice.
278 
279 As with all alternative currencies, Do Your Own Research (DYOR) before purchasing. Ken and the rest of the PENGY community are working to increase coin adoption, but no individual or community shall be held responsible for any financial losses or gains that may be incurred as a result of trading PENGY.
280 
281 If you’re with us — Hop In, We’re Going Places 🚀
282 
283 */