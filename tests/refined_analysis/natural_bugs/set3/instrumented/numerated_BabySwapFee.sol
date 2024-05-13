1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.5.16;
4 
5 import './BabyPair.sol';
6 import '../libraries/BabyLibrary.sol';
7 import '../interfaces/IBabyRouter.sol';
8 import '../interfaces/IBabyFactory.sol';
9 import '../interfaces/IBabyPair.sol';
10 import '../libraries/SafeMath.sol';
11 import '../token/SafeBEP20.sol';
12 import 'hardhat/console.sol';
13 import '@openzeppelin/contracts/access/Ownable.sol';
14 import '../libraries/Address.sol';
15 
16 contract BabySwapFee is Ownable {
17     using SafeMath for uint;
18     using Address for address;
19 
20     address public constant hole = 0x000000000000000000000000000000000000dEaD;
21     address public immutable bottle;
22     address public immutable vault;
23     IBabyRouter public immutable router;
24     IBabyFactory public immutable factory;
25     address public immutable WBNB;
26     address public immutable BABY;
27     address public immutable USDT;
28     address public immutable receiver;
29     address public caller;
30 
31     constructor(address bottle_, address vault_, IBabyRouter router_, IBabyFactory factory_, address WBNB_, address BABY_, address USDT_, address receiver_, address caller_) {
32         bottle = bottle_; 
33         vault = vault_;
34         router = router_;
35         factory = factory_;
36         WBNB = WBNB_;
37         BABY = BABY_;
38         USDT = USDT_;
39         receiver = receiver_;
40         caller = caller_;
41     }
42 
43     function setCaller(address newCaller_) external onlyOwner {
44         require(newCaller_ != address(0), "caller is zero");
45         caller = newCaller_;
46     }
47 
48     function transferToVault(IBabyPair pair, uint balance) internal returns (uint balanceRemained) {
49         uint balanceUsed = balance.div(3);
50         balanceRemained = balance.sub(balanceUsed);
51         SafeBEP20.safeTransfer(IBEP20(address(pair)), vault, balanceUsed);
52     }
53 
54     function transferToBottle(address token, uint balance) internal returns (uint balanceRemained) {
55         uint balanceUsed = balance.div(2);
56         balanceRemained = balance.sub(balanceUsed);
57         SafeBEP20.safeTransfer(IBEP20(token), bottle, balanceUsed);
58     }
59 
60     function doHardwork(address[] calldata pairs, uint minAmount) external {
61         require(msg.sender == caller, "illegal caller");
62         for (uint i = 0; i < pairs.length; i ++) {
63             IBabyPair pair = IBabyPair(pairs[i]);
64             if (pair.token0() != USDT && pair.token1() != USDT) {
65                 continue;
66             }
67             uint balance = pair.balanceOf(address(this));
68             if (balance == 0) {
69                 continue;
70             }
71             if (balance < minAmount) {
72                 continue;
73             }
74             balance = transferToVault(pair, balance);
75             address token = pair.token0() != USDT ? pair.token0() : pair.token1();
76             pair.approve(address(router), balance);
77             router.removeLiquidity(
78                 token,
79                 USDT,
80                 balance,
81                 0,
82                 0,
83                 address(this),
84                 block.timestamp
85             );
86             address[] memory path = new address[](2);
87             path[0] = token;path[1] = USDT;
88             balance = IBEP20(token).balanceOf(address(this));
89             IBEP20(token).approve(address(router), balance);
90             router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
91                 balance,
92                 0,
93                 path,
94                 address(this),
95                 block.timestamp
96             );
97         }
98     }
99 
100     function destroyAll() external onlyOwner {
101         uint balance = IBEP20(USDT).balanceOf(address(this));
102         balance = transferToBottle(USDT, balance);
103         address[] memory path = new address[](2);
104         path[0] = USDT;path[1] = BABY;
105         balance = IBEP20(USDT).balanceOf(address(this));
106         IBEP20(USDT).approve(address(router), balance);
107         router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
108             balance,
109             0,
110             path,
111             address(this),
112             block.timestamp
113         );
114         balance = IBEP20(BABY).balanceOf(address(this));
115         SafeBEP20.safeTransfer(IBEP20(BABY), hole, balance);
116     }
117 
118     function transferOut(address token, uint amount) external {
119         IBEP20 bep20 = IBEP20(token);
120         uint balance = bep20.balanceOf(address(this));
121         if (balance < amount) {
122             amount = balance;
123         }
124         SafeBEP20.safeTransfer(bep20, receiver, amount);
125     }
126 }
