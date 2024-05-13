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
38 import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/BEP20.sol";
39 
40 import "../interfaces/IPancakeRouter02.sol";
41 import "../interfaces/IPancakePair.sol";
42 import "../interfaces/IStrategy.sol";
43 import "../interfaces/IMasterChef.sol";
44 import "../interfaces/IBunnyMinterV2.sol";
45 import "../interfaces/IBunnyChef.sol";
46 import "../library/PausableUpgradeable.sol";
47 import "../library/WhitelistUpgradeable.sol";
48 
49 
50 abstract contract VaultController is IVaultController, PausableUpgradeable, WhitelistUpgradeable {
51     using SafeBEP20 for IBEP20;
52 
53     /* ========== CONSTANT VARIABLES ========== */
54     BEP20 private constant BUNNY = BEP20(0xC9849E6fdB743d08fAeE3E34dd2D1bc69EA11a51);
55 
56     /* ========== STATE VARIABLES ========== */
57 
58     address public keeper;
59     IBEP20 internal _stakingToken;
60     IBunnyMinterV2 internal _minter;
61     IBunnyChef internal _bunnyChef;
62 
63     /* ========== VARIABLE GAP ========== */
64 
65     uint256[49] private __gap;
66 
67     /* ========== Event ========== */
68 
69     event Recovered(address token, uint amount);
70 
71 
72     /* ========== MODIFIERS ========== */
73 
74     modifier onlyKeeper {
75         require(msg.sender == keeper || msg.sender == owner(), 'VaultController: caller is not the owner or keeper');
76         _;
77     }
78 
79     /* ========== INITIALIZER ========== */
80 
81     function __VaultController_init(IBEP20 token) internal initializer {
82         __PausableUpgradeable_init();
83         __WhitelistUpgradeable_init();
84 
85         keeper = 0x793074D9799DC3c6039F8056F1Ba884a73462051;
86         _stakingToken = token;
87     }
88 
89     /* ========== VIEWS FUNCTIONS ========== */
90 
91     function minter() external view override returns (address) {
92         return canMint() ? address(_minter) : address(0);
93     }
94 
95     function canMint() internal view returns (bool) {
96         return address(_minter) != address(0) && _minter.isMinter(address(this));
97     }
98 
99     function bunnyChef() external view override returns (address) {
100         return address(_bunnyChef);
101     }
102 
103     function stakingToken() external view override returns (address) {
104         return address(_stakingToken);
105     }
106 
107     /* ========== RESTRICTED FUNCTIONS ========== */
108 
109     function setKeeper(address _keeper) external onlyKeeper {
110         require(_keeper != address(0), 'VaultController: invalid keeper address');
111         keeper = _keeper;
112     }
113 
114     function setMinter(address newMinter) virtual public onlyOwner {
115         // can zero
116         if (newMinter != address(0)) {
117             require(newMinter == BUNNY.getOwner(), 'VaultController: not bunny minter');
118             _stakingToken.safeApprove(newMinter, 0);
119             _stakingToken.safeApprove(newMinter, uint(- 1));
120         }
121         if (address(_minter) != address(0)) _stakingToken.safeApprove(address(_minter), 0);
122         _minter = IBunnyMinterV2(newMinter);
123     }
124 
125     function setBunnyChef(IBunnyChef newBunnyChef) virtual public onlyOwner {
126         require(address(_bunnyChef) == address(0), 'VaultController: setBunnyChef only once');
127         _bunnyChef = newBunnyChef;
128     }
129 
130     /* ========== SALVAGE PURPOSE ONLY ========== */
131 
132     function recoverToken(address _token, uint amount) virtual external onlyOwner {
133         require(_token != address(_stakingToken), 'VaultController: cannot recover underlying token');
134         IBEP20(_token).safeTransfer(owner(), amount);
135 
136         emit Recovered(_token, amount);
137     }
138 }
