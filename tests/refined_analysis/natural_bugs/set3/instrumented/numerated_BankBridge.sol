1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.12;
3 
4 import "@openzeppelin/contracts/math/Math.sol";
5 import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/IBEP20.sol";
6 import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/SafeBEP20.sol";
7 
8 import "../library/SafeToken.sol";
9 import "../library/PausableUpgradeable.sol";
10 import "../library/WhitelistUpgradeable.sol";
11 import "../interfaces/IPancakeRouter02.sol";
12 import "../interfaces/IBank.sol";
13 
14 
15 contract BankBridge is IBankBridge, PausableUpgradeable, WhitelistUpgradeable {
16     using SafeMath for uint;
17     using SafeBEP20 for IBEP20;
18     using SafeToken for address;
19 
20     /* ========== CONSTANTS ============= */
21 
22     uint private constant RESERVE_RATIO_UNIT = 10000;
23     uint private constant RESERVE_RATIO_LIMIT = 5000;
24 
25     address private constant WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
26     address private constant ETH = 0x2170Ed0880ac9A755fd29B2688956BD959F933F8;
27     IPancakeRouter02 private constant ROUTER = IPancakeRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
28 
29     /* ========== STATE VARIABLES ========== */
30 
31     address public bank;
32 
33     uint public reserveRatio;
34     uint public reserved;
35 
36     /* ========== INITIALIZER ========== */
37 
38     receive() external payable {}
39 
40     function initialize() external initializer {
41         __PausableUpgradeable_init();
42         __WhitelistUpgradeable_init();
43 
44         reserveRatio = 1000;
45     }
46 
47     /* ========== VIEW FUNCTIONS ========== */
48 
49     function balance() public view returns (uint) {
50         return IBEP20(ETH).balanceOf(address(this));
51     }
52 
53     /* ========== RESTRICTED FUNCTIONS ========== */
54 
55     function setReserveRatio(uint newReserveRatio) external onlyOwner {
56         require(newReserveRatio <= RESERVE_RATIO_LIMIT, "BankBridge: invalid reserve ratio");
57         reserveRatio = newReserveRatio;
58     }
59 
60     function setBank(address payable newBank) external onlyOwner {
61         require(address(bank) == address(0), "BankBridge: bank exists");
62         bank = newBank;
63     }
64 
65     function approveETH() external onlyOwner {
66         IBEP20(ETH).approve(address(ROUTER), uint(-1));
67     }
68 
69     /* ========== MUTATIVE FUNCTIONS ========== */
70 
71     function realizeProfit() external override payable onlyWhitelisted returns (uint profitInETH) {
72         if (msg.value == 0) return 0;
73 
74         uint reserve = msg.value.mul(reserveRatio).div(RESERVE_RATIO_UNIT);
75         reserved = reserved.add(reserve);
76 
77         address[] memory path = new address[](2);
78         path[0] = WBNB;
79         path[1] = ETH;
80 
81         return ROUTER.swapExactETHForTokens{value : msg.value.sub(reserve)}(0, path, address(this), block.timestamp)[1];
82     }
83 
84     function realizeLoss(uint loss) external override onlyWhitelisted returns (uint lossInETH) {
85         if (loss == 0) return 0;
86 
87         address[] memory path = new address[](2);
88         path[0] = ETH;
89         path[1] = WBNB;
90 
91         lossInETH = ROUTER.getAmountsIn(loss, path)[0];
92         uint ethBalance = IBEP20(ETH).balanceOf(address(this));
93         if (ethBalance >= lossInETH) {
94             uint bnbOut = ROUTER.swapTokensForExactETH(loss, lossInETH, path, address(this), block.timestamp)[1];
95             SafeToken.safeTransferETH(bank, bnbOut);
96             return 0;
97         } else {
98             if (ethBalance > 0) {
99                 uint bnbOut = ROUTER.swapExactTokensForETH(ethBalance, 0, path, address(this), block.timestamp)[1];
100                 SafeToken.safeTransferETH(bank, bnbOut);
101             }
102             lossInETH = lossInETH.sub(ethBalance);
103         }
104     }
105 
106     function bridgeETH(address to, uint amount) external onlyWhitelisted {
107         if (IBEP20(ETH).allowance(address(this), address(to)) == 0) {
108             IBEP20(ETH).safeApprove(address(to), uint(- 1));
109         }
110         IBEP20(ETH).safeTransfer(to, amount);
111     }
112 }
