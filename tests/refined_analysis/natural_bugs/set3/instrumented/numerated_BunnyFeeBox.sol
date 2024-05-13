1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.12;
3 pragma experimental ABIEncoderV2;
4 
5 /*
6   ___                      _   _
7  | _ )_  _ _ _  _ _ _  _  | | | |
8  | _ \ || | ' \| ' \ || | |_| |_|
9  |___/\_,_|_||_|_||_\_, | (_) (_)
10                     |__/
11 
12 *
13 * MIT License
14 * ===========
15 *
16 * Copyright (c) 2020 BunnyFinance
17 *
18 * Permission is hereby granted, free of charge, to any person obtaining a copy
19 * of this software and associated documentation files (the "Software"), to deal
20 * in the Software without restriction, including without limitation the rights
21 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
22 * copies of the Software, and to permit persons to whom the Software is
23 * furnished to do so, subject to the following conditions:
24 *
25 * The above copyright notice and this permission notice shall be included in all
26 * copies or substantial portions of the Software.
27 *
28 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
29 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
30 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
31 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
32 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
33 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
34 * SOFTWARE.
35 */
36 
37 import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/SafeBEP20.sol";
38 
39 import "../library/WhitelistUpgradeable.sol";
40 import "../library/SafeToken.sol";
41 
42 import "../interfaces/IBunnyPool.sol";
43 import "../interfaces/ISafeSwapBNB.sol";
44 import "../interfaces/IZap.sol";
45 
46 
47 contract BunnyFeeBox is WhitelistUpgradeable {
48     using SafeBEP20 for IBEP20;
49     using SafeMath for uint;
50     using SafeToken for address;
51 
52     /* ========== CONSTANT ========== */
53 
54     ISafeSwapBNB public constant safeSwapBNB = ISafeSwapBNB(0x8D36CB4C0aEa63ca095d9E26aeFb360D279176B0);
55     IZap public constant zapBSC = IZap(0xdC2bBB0D33E0e7Dea9F5b98F46EDBaC823586a0C);
56 
57     address private constant WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
58     address private constant BUNNY = 0xC9849E6fdB743d08fAeE3E34dd2D1bc69EA11a51;
59     address private constant CAKE = 0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82;
60     address private constant USDT = 0x55d398326f99059fF775485246999027B3197955;
61     address private constant BUSD = 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56;
62     address private constant VAI = 0x4BD17003473389A42DAF6a0a729f6Fdb328BbBd7;
63     address private constant ETH = 0x2170Ed0880ac9A755fd29B2688956BD959F933F8;
64     address private constant BTCB = 0x7130d2A12B9BCbFAe4f2634d864A1Ee1Ce3Ead9c;
65     address private constant DOT = 0x7083609fCE4d1d8Dc0C979AAb8c869Ea2C873402;
66     address private constant USDC = 0x8AC76a51cc950d9822D68b83fE1Ad97B32Cd580d;
67     address private constant DAI = 0x1AF3F329e8BE154074D8769D1FFa4eE058B1DBc3;
68 
69     address private constant BUNNY_BNB = 0x5aFEf8567414F29f0f927A0F2787b188624c10E2;
70     address private constant CAKE_BNB = 0x0eD7e52944161450477ee417DE9Cd3a859b14fD0;
71     address private constant USDT_BNB = 0x16b9a82891338f9bA80E2D6970FddA79D1eb0daE;
72     address private constant BUSD_BNB = 0x58F876857a02D6762E0101bb5C46A8c1ED44Dc16;
73     address private constant USDT_BUSD = 0x7EFaEf62fDdCCa950418312c6C91Aef321375A00;
74     address private constant VAI_BUSD = 0x133ee93FE93320e1182923E1a640912eDE17C90C;
75     address private constant ETH_BNB = 0x74E4716E431f45807DCF19f284c7aA99F18a4fbc;
76     address private constant BTCB_BNB = 0x61EB789d75A95CAa3fF50ed7E47b96c132fEc082;
77     address private constant DOT_BNB = 0xDd5bAd8f8b360d76d12FdA230F8BAF42fe0022CF;
78     address private constant BTCB_BUSD = 0xF45cd219aEF8618A92BAa7aD848364a158a24F33;
79     address private constant DAI_BUSD = 0x66FDB2eCCfB58cF098eaa419e5EfDe841368e489;
80     address private constant USDC_BUSD = 0x2354ef4DF11afacb85a5C7f98B624072ECcddbB1;
81 
82 
83     /* ========== STATE VARIABLES ========== */
84 
85     address public keeper;
86     address public bunnyPool;
87 
88     /* ========== MODIFIERS ========== */
89 
90     modifier onlyKeeper {
91         require(msg.sender == keeper || msg.sender == owner(), "BunnyFeeBox: caller is not the owner or keeper");
92         _;
93     }
94 
95     /* ========== INITIALIZER ========== */
96 
97     receive() external payable {}
98 
99     function initialize() external initializer {
100         __WhitelistUpgradeable_init();
101     }
102 
103     /* ========== VIEWS ========== */
104 
105     function redundantTokens() public pure returns (address[8] memory) {
106         return [USDT, BUSD, VAI, ETH, BTCB, USDC, DAI, DOT];
107     }
108 
109     function flips() public pure returns (address[12] memory) {
110         return [BUNNY_BNB, CAKE_BNB, USDT_BNB, BUSD_BNB, USDT_BUSD, VAI_BUSD, ETH_BNB, BTCB_BNB, DOT_BNB, BTCB_BUSD, DAI_BUSD, USDC_BUSD];
111     }
112 
113     function pendingRewards() public view returns (uint bnb, uint cake, uint bunny) {
114         bnb = address(this).balance;
115         cake = IBEP20(CAKE).balanceOf(address(this));
116         bunny = IBEP20(BUNNY).balanceOf(address(this));
117     }
118 
119     /* ========== RESTRICTED FUNCTIONS ========== */
120 
121     function setKeeper(address _keeper) external onlyOwner {
122         keeper = _keeper;
123     }
124 
125     function setBunnyPool(address _bunnyPool) external onlyOwner {
126         bunnyPool = _bunnyPool;
127     }
128 
129     function swapToRewards() public onlyKeeper {
130         require(bunnyPool != address(0), "BunnyFeeBox: BunnyPool must be set");
131 
132         address[] memory _tokens = IBunnyPool(bunnyPool).rewardTokens();
133         uint[] memory _amounts = new uint[](_tokens.length);
134         for (uint i = 0; i < _tokens.length; i++) {
135             uint _amount = _tokens[i] == WBNB ? address(this).balance : IBEP20(_tokens[i]).balanceOf(address(this));
136             if (_amount > 0) {
137                 if (_tokens[i] == WBNB) {
138                     SafeToken.safeTransferETH(bunnyPool, _amount);
139                 } else {
140                     IBEP20(_tokens[i]).safeTransfer(bunnyPool, _amount);
141                 }
142             }
143             _amounts[i] = _amount;
144         }
145 
146         IBunnyPool(bunnyPool).notifyRewardAmounts(_amounts);
147     }
148 
149     function harvest() external onlyKeeper {
150         splitPairs();
151 
152         address[8] memory _tokens = redundantTokens();
153         for (uint i = 0; i < _tokens.length; i++) {
154             _convertToken(_tokens[i], IBEP20(_tokens[i]).balanceOf(address(this)));
155         }
156 
157         swapToRewards();
158     }
159 
160     function splitPairs() public onlyKeeper {
161         address[12] memory _flips = flips();
162         for (uint i = 0; i < _flips.length; i++) {
163             _convertToken(_flips[i], IBEP20(_flips[i]).balanceOf(address(this)));
164         }
165     }
166 
167     function covertTokensPartial(address[] memory _tokens, uint[] memory _amounts) external onlyKeeper {
168         for (uint i = 0; i < _tokens.length; i++) {
169             _convertToken(_tokens[i], _amounts[i]);
170         }
171     }
172 
173     /* ========== PRIVATE FUNCTIONS ========== */
174 
175     function _convertToken(address token, uint amount) private {
176         uint balance = IBEP20(token).balanceOf(address(this));
177         if (amount > 0 && balance >= amount) {
178             if (IBEP20(token).allowance(address(this), address(zapBSC)) == 0) {
179                 IBEP20(token).approve(address(zapBSC), uint(- 1));
180             }
181             zapBSC.zapOut(token, amount);
182         }
183     }
184 
185     // @dev use when WBNB received from minter
186     function _unwrap(uint amount) private {
187         uint balance = IBEP20(WBNB).balanceOf(address(this));
188         if (amount > 0 && balance >= amount) {
189             if (IBEP20(WBNB).allowance(address(this), address(safeSwapBNB)) == 0) {
190                 IBEP20(WBNB).approve(address(safeSwapBNB), uint(-1));
191             }
192 
193             safeSwapBNB.withdraw(amount);
194         }
195     }
196 
197 }