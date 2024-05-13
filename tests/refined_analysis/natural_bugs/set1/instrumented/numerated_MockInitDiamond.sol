1 /*
2  SPDX-License-Identifier: MIT
3 */
4 
5 pragma solidity =0.7.6;
6 pragma experimental ABIEncoderV2;
7 
8 import {IBean} from "../interfaces/IBean.sol";
9 import {IWETH} from "../interfaces/IWETH.sol";
10 import {MockToken} from "../mocks/MockToken.sol";
11 import {AppStorage, Storage} from "../beanstalk/AppStorage.sol";
12 import {C} from "../C.sol";
13 import {InitWhitelist} from "contracts/beanstalk/init/InitWhitelist.sol";
14 import {InitWhitelistStatuses} from "contracts/beanstalk/init/InitWhitelistStatuses.sol";
15 import {LibDiamond} from "../libraries/LibDiamond.sol";
16 import {LibCases} from "../libraries/LibCases.sol";
17 import {LibGauge} from "contracts/libraries/LibGauge.sol";
18 import {Weather} from "contracts/beanstalk/sun/SeasonFacet/Weather.sol";
19 
20 /**
21  * @author Publius
22  * @title Mock Init Diamond
23 **/
24 contract MockInitDiamond is InitWhitelist, InitWhitelistStatuses, Weather {
25 
26     function init() external {
27         LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
28 
29         C.bean().approve(C.CURVE_BEAN_METAPOOL, type(uint256).max);
30         C.bean().approve(C.curveZapAddress(), type(uint256).max);
31         C.usdc().approve(C.curveZapAddress(), type(uint256).max);
32         ds.supportedInterfaces[0xd9b67a26] = true; // ERC1155
33         ds.supportedInterfaces[0x0e89341c] = true; // ERC1155Metadata
34 
35         LibCases.setCasesV2();
36         s.w.t = 1;
37 
38         s.w.thisSowTime = type(uint32).max;
39         s.w.lastSowTime = type(uint32).max;
40 
41         s.season.current = 1;
42         s.season.withdrawSeasons = 25;
43         s.season.period = C.getSeasonPeriod();
44         s.season.timestamp = block.timestamp;
45         s.season.start = s.season.period > 0 ?
46             (block.timestamp / s.season.period) * s.season.period :
47             block.timestamp;
48         s.isFarm = 1;
49         s.usdTokenPrice[C.BEAN_ETH_WELL] = 1;
50         s.twaReserves[C.BEAN_ETH_WELL].reserve0 = 1;
51         s.twaReserves[C.BEAN_ETH_WELL].reserve1 = 1;
52 
53         s.season.stemStartSeason = uint16(s.season.current);
54         s.season.stemScaleSeason = uint16(s.season.current);
55         s.seedGauge.beanToMaxLpGpPerBdvRatio = 50e18; // 50%
56         s.seedGauge.averageGrownStalkPerBdvPerSeason = 3e6;
57 
58         s.u[C.UNRIPE_LP].underlyingToken = C.BEAN_WSTETH_WELL;
59 
60         emit BeanToMaxLpGpPerBdvRatioChange(s.season.current, type(uint256).max, int80(s.seedGauge.beanToMaxLpGpPerBdvRatio));
61         emit LibGauge.UpdateAverageStalkPerBdvPerSeason(s.seedGauge.averageGrownStalkPerBdvPerSeason);
62 
63         whitelistPools();
64         addWhitelistStatuses(false);
65     }
66 
67 }