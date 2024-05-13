1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity 0.7.6;
3 
4 // ============ Internal Imports ============
5 import {IEventAccountant} from "../interfaces/IEventAccountant.sol";
6 // ============ External Imports ============
7 import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
8 
9 /// @title EventAccountant
10 abstract contract EventAccountant is IEventAccountant {
11     /// @notice the address of the bridgeRouter that is allowed to record here
12     address public immutable bridgeRouter;
13 
14     /// @notice token address => amount of affected tokens
15     mapping(address => uint256) public totalAffected;
16 
17     // ============ Upgrade Gap ============
18 
19     // gap for upgrade safety
20     uint256[49] private __GAP;
21 
22     /// ============ Constructor ============
23     constructor(address _bridgeRouter) {
24         // configure bridgeRouter
25         bridgeRouter = _bridgeRouter;
26     }
27 
28     /// ============ Initializer ============
29     function __EventAccountant_init() internal {
30         // set affected token amounts in mapping
31         totalAffected[
32             0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599
33         ] = 102_829_072_399;
34         totalAffected[
35             0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
36         ] = 22_868_595_330_591_440_628_473;
37         totalAffected[
38             0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48
39         ] = 87_250_743_982_016;
40         totalAffected[
41             0x853d955aCEf822Db058eb8505911ED77F175b99e
42         ] = 6_683_295_726_936_365_174_269_341;
43         totalAffected[
44             0xdAC17F958D2ee523a2206206994597C13D831ec7
45         ] = 8_626_248_974_867;
46         totalAffected[
47             0x6B175474E89094C44Da98b954EedeAC495271d0F
48         ] = 4_533_681_025_522_997_592_670_853;
49         totalAffected[
50             0xD417144312DbF50465b1C641d016962017Ef6240
51         ] = 113_403_891_487_223_872_600_000_000;
52         totalAffected[
53             0x3d6F0DEa3AC3C607B3998e6Ce14b6350721752d9
54         ] = 736_498_134_676_753_019_950_000;
55         totalAffected[
56             0x40EB746DEE876aC1E78697b7Ca85142D178A1Fc8
57         ] = 516_231_512_011_105_000_000_000_000;
58         totalAffected[
59             0xf1a91C7d44768070F711c68f33A7CA25c8D30268
60         ] = 7_221_941_652_919_222_278_900_000;
61         totalAffected[
62             0x3432B6A60D23Ca0dFCa7761B7ab56459D9C964D0
63         ] = 106_595_122_254_787_950_000_000;
64         totalAffected[
65             0x3431F91b3a388115F00C5Ba9FdB899851D005Fb5
66         ] = 58_808_241_561_215_147_129_400_000;
67         totalAffected[
68             0xE5097D9baeAFB89f9bcB78C9290d545dB5f9e9CB
69         ] = 11_802_082_723_892_000_000_000_000;
70         totalAffected[
71             0xf1Dc500FdE233A4055e25e5BbF516372BC4F6871
72         ] = 322_589_324_798_359_784_835_428;
73     }
74 
75     /**
76      * @notice Returns true if the asset was affected, false otherwise
77      * @param _asset The asset to be checked
78      * @return True if the asset is in the affected list. False otherwise
79      */
80     function isAffectedAsset(address _asset)
81         public
82         view
83         override
84         returns (bool)
85     {
86         return totalAffected[_asset] != 0;
87     }
88 
89     /**
90      * @notice Returns a list of affected assets
91      */
92     function affectedAssets()
93         public
94         pure
95         override
96         returns (address payable[14] memory)
97     {
98         return [
99             0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599,
100             0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2,
101             0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48,
102             0x853d955aCEf822Db058eb8505911ED77F175b99e,
103             0xdAC17F958D2ee523a2206206994597C13D831ec7,
104             0x6B175474E89094C44Da98b954EedeAC495271d0F,
105             0xD417144312DbF50465b1C641d016962017Ef6240,
106             0x3d6F0DEa3AC3C607B3998e6Ce14b6350721752d9,
107             0x40EB746DEE876aC1E78697b7Ca85142D178A1Fc8,
108             0xf1a91C7d44768070F711c68f33A7CA25c8D30268,
109             0x3432B6A60D23Ca0dFCa7761B7ab56459D9C964D0,
110             0x3431F91b3a388115F00C5Ba9FdB899851D005Fb5,
111             0xE5097D9baeAFB89f9bcB78C9290d545dB5f9e9CB,
112             0xf1Dc500FdE233A4055e25e5BbF516372BC4F6871
113         ];
114     }
115 
116     /**
117      * @notice record an attempted process for an affected asset
118      * @param _asset  The asset
119      * @param _user   The recipient
120      * @param _amount The amount
121      */
122     function record(
123         address _asset,
124         address _user,
125         uint256 _amount
126     ) external override {
127         require(msg.sender == bridgeRouter, "only BridgeRouter");
128         _record(_asset, _user, _amount);
129     }
130 
131     /**
132      * @notice Internal logic for recording an attempted process for an
133      *         affected asset
134      * @dev Override this method to implement specific accounting logic.
135      * @param _asset  The asset
136      * @param _user   The recipient
137      * @param _amount The amount
138      */
139     function _record(
140         address _asset,
141         address _user,
142         uint256 _amount
143     ) internal virtual;
144 }
