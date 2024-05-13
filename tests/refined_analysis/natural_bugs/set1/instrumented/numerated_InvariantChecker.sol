1 pragma solidity ^0.8.0;
2 // SPDX-License-Identifier: GPL-2.0-or-later
3 
4 import "hardhat/console.sol";
5 
6 import "../Constants.sol";
7 import "../Euler.sol";
8 import "../modules/Markets.sol";
9 import "../modules/EToken.sol";
10 import "../modules/DToken.sol";
11 
12 // This is a testing-only contract that verifies invariants of the Euler system.
13 
14 struct LocalVars {
15     uint eTokenBalances;
16     uint dTokenBalances;
17     uint dTokenBalancesExact;
18 
19     uint numUsersWithEtokens;
20     uint numUsersWithDtokens;
21 
22     uint eTokenTotalSupply;
23     uint reserveBalance;
24     uint dTokenTotalSupply;
25     uint dTokenTotalSupplyExact;
26 
27     uint poolSize;
28 }
29 
30 contract InvariantChecker is Constants {
31     function check(address eulerContract, address[] calldata markets, address[] calldata accounts, bool verbose) external view {
32         Euler eulerProxy = Euler(eulerContract);
33         Markets marketsProxy = Markets(eulerProxy.moduleIdToProxy(MODULEID__MARKETS));
34 
35         LocalVars memory v;
36 
37         for (uint i = 0; i < markets.length; ++i) {
38             IERC20 eToken = IERC20(marketsProxy.underlyingToEToken(markets[i]));
39             IERC20 dToken = IERC20(marketsProxy.eTokenToDToken(address(eToken)));
40 
41             v.eTokenBalances = 0;
42             v.dTokenBalances = 0;
43             v.dTokenBalancesExact = 0;
44 
45             v.numUsersWithEtokens = 0;
46             v.numUsersWithDtokens = 0;
47 
48             for (uint j = 0; j < accounts.length; ++j) {
49                 address account = accounts[j];
50 
51                 {
52                     uint bal = eToken.balanceOf(account);
53                     v.eTokenBalances += bal;
54                     if (bal != 0) v.numUsersWithEtokens++;
55                 }
56 
57                 {
58                     uint bal = dToken.balanceOf(account);
59                     v.dTokenBalances += bal;
60                     if (bal != 0) v.numUsersWithDtokens++;
61                 }
62 
63                 {
64                     uint bal = DToken(address(dToken)).balanceOfExact(account);
65                     v.dTokenBalancesExact += bal;
66                 }
67             }
68 
69             v.eTokenTotalSupply = eToken.totalSupply();
70             v.reserveBalance = EToken(address(eToken)).reserveBalance();
71             v.dTokenTotalSupply = dToken.totalSupply();
72             v.dTokenTotalSupplyExact = DToken(address(dToken)).totalSupplyExact();
73 
74             v.poolSize = IERC20(markets[i]).balanceOf(eulerContract);
75 
76             if (verbose) {
77                 console.log("--------------------------------------------------------------");
78                 console.log("MARKET = ", markets[i]);
79                 console.log("POOL SIZE           = ", v.poolSize);
80                 console.log("");
81                 console.log("USERS WITH ETOKENS  = ", v.numUsersWithEtokens);
82                 console.log("ETOKEN BALANCE SUM  = ", v.eTokenBalances);
83                 console.log("RESERVE BALANCE     = ", v.reserveBalance);
84                 console.log("ETOKEN TOTAL SUPPLY = ", v.eTokenTotalSupply);
85                 console.log("");
86                 console.log("USERS WITH DTOKENS  = ", v.numUsersWithDtokens);
87                 console.log("DTOKEN BALANCE SUM  = ", v.dTokenBalances);
88                 console.log("DTOKEN TOTAL SUPPLY = ", v.dTokenTotalSupply);
89                 console.log("DTOKEN BALEXACT SUM = ", v.dTokenBalancesExact);
90                 console.log("DTOKEN EXACT SUPPLY = ", v.dTokenTotalSupplyExact);
91             }
92 
93             require(v.eTokenBalances + v.reserveBalance == v.eTokenTotalSupply, "invariant checker: eToken balance mismatch");
94 
95             // Due to rounding, user debt balances can grow slightly faster than the total debt supply
96             require(v.dTokenBalancesExact >= v.dTokenTotalSupplyExact, "invariant checker: dToken exact balance mismatch");
97         }
98     }
99 }
