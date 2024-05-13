1 //SPDX-License-Identifier: Unlicense
2 
3 pragma solidity 0.6.12;
4 
5 import "@openzeppelin/contracts-upgradeable/proxy/Initializable.sol";
6 
7 contract BaseUpgradeableStrategyStorage {
8 
9   bytes32 internal constant _UNDERLYING_SLOT = 0xa1709211eeccf8f4ad5b6700d52a1a9525b5f5ae1e9e5f9e5a0c2fc23c86e530;
10   bytes32 internal constant _VAULT_SLOT = 0xefd7c7d9ef1040fc87e7ad11fe15f86e1d11e1df03c6d7c87f7e1f4041f08d41;
11 
12   bytes32 internal constant _REWARD_TOKEN_SLOT = 0xdae0aafd977983cb1e78d8f638900ff361dc3c48c43118ca1dd77d1af3f47bbf;
13   bytes32 internal constant _REWARD_POOL_SLOT = 0x3d9bb16e77837e25cada0cf894835418b38e8e18fbec6cfd192eb344bebfa6b8;
14   bytes32 internal constant _SELL_FLOOR_SLOT = 0xc403216a7704d160f6a3b5c3b149a1226a6080f0a5dd27b27d9ba9c022fa0afc;
15   bytes32 internal constant _SELL_SLOT = 0x656de32df98753b07482576beb0d00a6b949ebf84c066c765f54f26725221bb6;
16   bytes32 internal constant _PAUSED_INVESTING_SLOT = 0xa07a20a2d463a602c2b891eb35f244624d9068572811f63d0e094072fb54591a;
17 
18   bytes32 internal constant _PROFIT_SHARING_NUMERATOR_SLOT = 0xe3ee74fb7893020b457d8071ed1ef76ace2bf4903abd7b24d3ce312e9c72c029;
19   bytes32 internal constant _PROFIT_SHARING_DENOMINATOR_SLOT = 0x0286fd414602b432a8c80a0125e9a25de9bba96da9d5068c832ff73f09208a3b;
20 
21   bytes32 internal constant _NEXT_IMPLEMENTATION_SLOT = 0x29f7fcd4fe2517c1963807a1ec27b0e45e67c60a874d5eeac7a0b1ab1bb84447;
22   bytes32 internal constant _NEXT_IMPLEMENTATION_TIMESTAMP_SLOT = 0x414c5263b05428f1be1bfa98e25407cc78dd031d0d3cd2a2e3d63b488804f22e;
23   bytes32 internal constant _NEXT_IMPLEMENTATION_DELAY_SLOT = 0x82b330ca72bcd6db11a26f10ce47ebcfe574a9c646bccbc6f1cd4478eae16b31;
24 
25   constructor() public {
26     assert(_UNDERLYING_SLOT == bytes32(uint256(keccak256("eip1967.strategyStorage.underlying")) - 1));
27     assert(_VAULT_SLOT == bytes32(uint256(keccak256("eip1967.strategyStorage.vault")) - 1));
28     assert(_REWARD_TOKEN_SLOT == bytes32(uint256(keccak256("eip1967.strategyStorage.rewardToken")) - 1));
29     assert(_REWARD_POOL_SLOT == bytes32(uint256(keccak256("eip1967.strategyStorage.rewardPool")) - 1));
30     assert(_SELL_FLOOR_SLOT == bytes32(uint256(keccak256("eip1967.strategyStorage.sellFloor")) - 1));
31     assert(_SELL_SLOT == bytes32(uint256(keccak256("eip1967.strategyStorage.sell")) - 1));
32     assert(_PAUSED_INVESTING_SLOT == bytes32(uint256(keccak256("eip1967.strategyStorage.pausedInvesting")) - 1));
33 
34     assert(_PROFIT_SHARING_NUMERATOR_SLOT == bytes32(uint256(keccak256("eip1967.strategyStorage.profitSharingNumerator")) - 1));
35     assert(_PROFIT_SHARING_DENOMINATOR_SLOT == bytes32(uint256(keccak256("eip1967.strategyStorage.profitSharingDenominator")) - 1));
36 
37     assert(_NEXT_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.strategyStorage.nextImplementation")) - 1));
38     assert(_NEXT_IMPLEMENTATION_TIMESTAMP_SLOT == bytes32(uint256(keccak256("eip1967.strategyStorage.nextImplementationTimestamp")) - 1));
39     assert(_NEXT_IMPLEMENTATION_DELAY_SLOT == bytes32(uint256(keccak256("eip1967.strategyStorage.nextImplementationDelay")) - 1));
40   }
41 
42   function _setUnderlying(address _address) internal {
43     setAddress(_UNDERLYING_SLOT, _address);
44   }
45 
46   function underlying() public virtual view returns (address) {
47     return getAddress(_UNDERLYING_SLOT);
48   }
49 
50   function _setRewardPool(address _address) internal {
51     setAddress(_REWARD_POOL_SLOT, _address);
52   }
53 
54   function rewardPool() public view returns (address) {
55     return getAddress(_REWARD_POOL_SLOT);
56   }
57 
58   function _setRewardToken(address _address) internal {
59     setAddress(_REWARD_TOKEN_SLOT, _address);
60   }
61 
62   function rewardToken() public view returns (address) {
63     return getAddress(_REWARD_TOKEN_SLOT);
64   }
65 
66   function _setVault(address _address) internal {
67     setAddress(_VAULT_SLOT, _address);
68   }
69 
70   function vault() public virtual view returns (address) {
71     return getAddress(_VAULT_SLOT);
72   }
73 
74   // a flag for disabling selling for simplified emergency exit
75   function _setSell(bool _value) internal {
76     setBoolean(_SELL_SLOT, _value);
77   }
78 
79   function sell() public view returns (bool) {
80     return getBoolean(_SELL_SLOT);
81   }
82 
83   function _setPausedInvesting(bool _value) internal {
84     setBoolean(_PAUSED_INVESTING_SLOT, _value);
85   }
86 
87   function pausedInvesting() public view returns (bool) {
88     return getBoolean(_PAUSED_INVESTING_SLOT);
89   }
90 
91   function _setSellFloor(uint256 _value) internal {
92     setUint256(_SELL_FLOOR_SLOT, _value);
93   }
94 
95   function sellFloor() public view returns (uint256) {
96     return getUint256(_SELL_FLOOR_SLOT);
97   }
98 
99   function _setProfitSharingNumerator(uint256 _value) internal {
100     setUint256(_PROFIT_SHARING_NUMERATOR_SLOT, _value);
101   }
102 
103   function profitSharingNumerator() public view returns (uint256) {
104     return getUint256(_PROFIT_SHARING_NUMERATOR_SLOT);
105   }
106 
107   function _setProfitSharingDenominator(uint256 _value) internal {
108     setUint256(_PROFIT_SHARING_DENOMINATOR_SLOT, _value);
109   }
110 
111   function profitSharingDenominator() public view returns (uint256) {
112     return getUint256(_PROFIT_SHARING_DENOMINATOR_SLOT);
113   }
114 
115   // upgradeability
116 
117   function _setNextImplementation(address _address) internal {
118     setAddress(_NEXT_IMPLEMENTATION_SLOT, _address);
119   }
120 
121   function nextImplementation() public view returns (address) {
122     return getAddress(_NEXT_IMPLEMENTATION_SLOT);
123   }
124 
125   function _setNextImplementationTimestamp(uint256 _value) internal {
126     setUint256(_NEXT_IMPLEMENTATION_TIMESTAMP_SLOT, _value);
127   }
128 
129   function nextImplementationTimestamp() public view returns (uint256) {
130     return getUint256(_NEXT_IMPLEMENTATION_TIMESTAMP_SLOT);
131   }
132 
133   function _setNextImplementationDelay(uint256 _value) internal {
134     setUint256(_NEXT_IMPLEMENTATION_DELAY_SLOT, _value);
135   }
136 
137   function nextImplementationDelay() public view returns (uint256) {
138     return getUint256(_NEXT_IMPLEMENTATION_DELAY_SLOT);
139   }
140 
141   function setBoolean(bytes32 slot, bool _value) internal {
142     setUint256(slot, _value ? 1 : 0);
143   }
144 
145   function getBoolean(bytes32 slot) internal view returns (bool) {
146     return (getUint256(slot) == 1);
147   }
148 
149   function setAddress(bytes32 slot, address _address) internal {
150     // solhint-disable-next-line no-inline-assembly
151     assembly {
152       sstore(slot, _address)
153     }
154   }
155 
156   function setUint256(bytes32 slot, uint256 _value) internal {
157     // solhint-disable-next-line no-inline-assembly
158     assembly {
159       sstore(slot, _value)
160     }
161   }
162 
163   function getAddress(bytes32 slot) internal view returns (address str) {
164     // solhint-disable-next-line no-inline-assembly
165     assembly {
166       str := sload(slot)
167     }
168   }
169 
170   function getUint256(bytes32 slot) internal view returns (uint256 str) {
171     // solhint-disable-next-line no-inline-assembly
172     assembly {
173       str := sload(slot)
174     }
175   }
176 }
