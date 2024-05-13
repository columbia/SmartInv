1 /*
2 
3     Copyright 2020 DODO ZOO.
4     SPDX-License-Identifier: Apache-2.0
5 
6 */
7 
8 pragma solidity 0.6.9;
9 pragma experimental ABIEncoderV2;
10 
11 import {Types} from "./lib/Types.sol";
12 import {IERC20} from "./intf/IERC20.sol";
13 import {Storage} from "./impl/Storage.sol";
14 import {Trader} from "./impl/Trader.sol";
15 import {LiquidityProvider} from "./impl/LiquidityProvider.sol";
16 import {Admin} from "./impl/Admin.sol";
17 import {DODOLpToken} from "./impl/DODOLpToken.sol";
18 
19 
20 /**
21  * @title DODO
22  * @author DODO Breeder
23  *
24  * @notice Entrance for users
25  */
26 contract DODO is Admin, Trader, LiquidityProvider {
27     function init(
28         address owner,
29         address supervisor,
30         address maintainer,
31         address baseToken,
32         address quoteToken,
33         address oracle,
34         uint256 lpFeeRate,
35         uint256 mtFeeRate,
36         uint256 k,
37         uint256 gasPriceLimit
38     ) external {
39         require(!_INITIALIZED_, "DODO_INITIALIZED");
40         _INITIALIZED_ = true;
41 
42         // constructor
43         _OWNER_ = owner;
44         emit OwnershipTransferred(address(0), _OWNER_);
45 
46         _SUPERVISOR_ = supervisor;
47         _MAINTAINER_ = maintainer;
48         _BASE_TOKEN_ = baseToken;
49         _QUOTE_TOKEN_ = quoteToken;
50         _ORACLE_ = oracle;
51 
52         _DEPOSIT_BASE_ALLOWED_ = false;
53         _DEPOSIT_QUOTE_ALLOWED_ = false;
54         _TRADE_ALLOWED_ = false;
55         _GAS_PRICE_LIMIT_ = gasPriceLimit;
56 
57         // Advanced controls are disabled by default
58         _BUYING_ALLOWED_ = true;
59         _SELLING_ALLOWED_ = true;
60         uint256 MAX_INT = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
61         _BASE_BALANCE_LIMIT_ = MAX_INT;
62         _QUOTE_BALANCE_LIMIT_ = MAX_INT;
63 
64         _LP_FEE_RATE_ = lpFeeRate;
65         _MT_FEE_RATE_ = mtFeeRate;
66         _K_ = k;
67         _R_STATUS_ = Types.RStatus.ONE;
68 
69         _BASE_CAPITAL_TOKEN_ = address(new DODOLpToken(_BASE_TOKEN_));
70         _QUOTE_CAPITAL_TOKEN_ = address(new DODOLpToken(_QUOTE_TOKEN_));
71 
72         _checkDODOParameters();
73     }
74 }
