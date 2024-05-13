1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
5 import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
6 import {PCVDeposit} from "../pcv/PCVDeposit.sol";
7 import {CTokenFuse, CEtherFuse} from "../external/fuse/CToken.sol";
8 import {CoreRef} from "../refs/CoreRef.sol";
9 import {TribeRoles} from "../core/TribeRoles.sol";
10 
11 /// @title Utility contract for repaying the bad debt in fuse
12 /// @author Fei Protocol
13 contract FuseFixer is PCVDeposit {
14     address public constant DEBTOR = address(0x32075bAd9050d4767018084F0Cb87b3182D36C45);
15 
16     address[] public UNDERLYINGS = [
17         address(0x0000000000000000000000000000000000000000), // ETH
18         address(0x956F47F50A910163D8BF957Cf5846D573E7f87CA), // FEI
19         address(0x853d955aCEf822Db058eb8505911ED77F175b99e), // FRAX
20         address(0x03ab458634910AaD20eF5f1C8ee96F1D6ac54919), // RAI
21         address(0x6B175474E89094C44Da98b954EedeAC495271d0F), // DAI
22         address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48), // USDC
23         address(0x5f98805A4E8be255a32880FDeC7F6728C6568bA0), // LUSD
24         address(0x7f39C581F595B53c5cb19bD0b3f8dA6c935E2Ca0), // wstETH
25         address(0xa693B19d2931d498c5B318dF961919BB4aee87a5), // USTw
26         address(0xdAC17F958D2ee523a2206206994597C13D831ec7) // USDT
27     ];
28 
29     address[] public CTOKENS = [
30         address(0xd8553552f8868C1Ef160eEdf031cF0BCf9686945), // Pool 8: FEI
31         address(0xbB025D470162CC5eA24daF7d4566064EE7f5F111), // Pool 8: ETH
32         address(0x7e9cE3CAa9910cc048590801e64174957Ed41d43), // Pool 8: DAI
33         address(0x7259eE19D6B5e755e7c65cECfd2466C09E251185), // Pool 8: wstETH
34         address(0x647A36d421183a0a9Fa62717a64B664a24E469C7), // Pool 8: LUSD
35         address(0xFA1057d02A0C1a4885851e3F4fD496Ee7D38F56e), // Pool 18: ETH
36         address(0x8E4E0257A4759559B4B1AC087fe8d80c63f20D19), // Pool 18: DAI
37         address(0x6f95d4d251053483f41c8718C30F4F3C404A8cf2), // Pool 18: USDC
38         address(0x3E5C122Ffa75A9Fe16ec0c69F7E9149203EA1A5d), // Pool 18: FRAX
39         address(0x17b1A2E012cC4C31f83B90FF11d3942857664efc), // Pool 18: FEI
40         address(0x51fF03410a0dA915082Af444274C381bD1b4cDB1), // Pool 18: RAI
41         address(0xB7FE5f277058b3f9eABf6e0655991f10924BFA54), // Pool 18: USTw
42         address(0x9de558FCE4F289b305E38ABe2169b75C626c114e), // Pool 27: FRAX
43         address(0xda396c927e3e6BEf77A98f372CE431b49EdEc43D), // Pool 27: FEI
44         address(0xF148cDEc066b94410d403aC5fe1bb17EC75c5851), // Pool 27: ETH
45         address(0x0C402F06C11c6e6A6616C98868A855448d4CfE65), // Pool 27: USTw
46         address(0x26267e41CeCa7C8E0f143554Af707336f27Fa051), // Pool 127: ETH
47         address(0xEbE0d1cb6A0b8569929e062d67bfbC07608f0A47), // Pool 127: USDC
48         address(0x4B68ef5AB32261082DF1A6C9C6a89FFD5eF168B1), // Pool 127: DAI
49         address(0xe097783483D1b7527152eF8B150B99B9B2700c8d), // Pool 127: USDT
50         address(0x0F0d710911FB37038b3AD88FC43DDAd4Edbe16A5), // Pool 127: USTw
51         address(0x8922C1147E141C055fdDfc0ED5a119f3378c8ef8), // Pool 127: FRAX
52         address(0x7DBC3aF9251756561Ce755fcC11c754184Af71F7), // Pool 144: ETH
53         address(0x3a2804ec0Ff521374aF654D8D0daA1d1aE1ee900), // Pool 144: FEI
54         address(0xA54c548d11792b3d26aD74F5f899e12CDfD64Fd6), // Pool 144: FRAX
55         address(0xA6C25548dF506d84Afd237225B5B34F2Feb1aa07), // Pool 144: DAI
56         address(0xfbD8Aaf46Ab3C2732FA930e5B343cd67cEA5054C), // Pool 146: ETH
57         address(0x49dA42a1EcA4AC6cA0C6943d9E5dc64e4641e0E3), // Pool 146: wstETH
58         address(0xe14c2e156A3f310d41240Ce8760eB3cb8a0dDBE3), // Pool 156: USTw
59         address(0x001E407f497e024B9fb1CB93ef841F43D645CA4F), // Pool 156: FEI
60         address(0x5CaDc2a04921213DE60B237688776e0F1A7155E6), // Pool 156: FRAX
61         address(0x9CD060A4855290bf0c5aeD266aBe119FF3b01966), // Pool 156: DAI
62         address(0x74897C0061ADeec84D292e8900c7BDD00b3388e4), // Pool 156: LUSD
63         address(0x88d3557eB6280CC084cA36e425d6BC52d0A04429), // Pool 156: USDC
64         address(0xe92a3db67e4b6AC86114149F522644b34264f858) // Pool 156: ETH
65     ];
66 
67     mapping(address => address[]) public underlyingsToCTokens;
68 
69     constructor(address core) CoreRef(core) {
70         _buildCTokenMapping();
71 
72         // check mappings lengths - hand calculated
73         assert(underlyingsToCTokens[UNDERLYINGS[0]].length == 7);
74         assert(underlyingsToCTokens[UNDERLYINGS[1]].length == 5);
75         assert(underlyingsToCTokens[UNDERLYINGS[2]].length == 5);
76         assert(underlyingsToCTokens[UNDERLYINGS[3]].length == 1);
77         assert(underlyingsToCTokens[UNDERLYINGS[4]].length == 5);
78         assert(underlyingsToCTokens[UNDERLYINGS[5]].length == 3);
79         assert(underlyingsToCTokens[UNDERLYINGS[6]].length == 2);
80         assert(underlyingsToCTokens[UNDERLYINGS[7]].length == 2);
81         assert(underlyingsToCTokens[UNDERLYINGS[8]].length == 4);
82         assert(underlyingsToCTokens[UNDERLYINGS[9]].length == 1);
83 
84         // send out token approvals
85         _approveCTokens();
86     }
87 
88     /// @dev Repay all debt
89     function repayAll() public hasAnyOfTwoRoles(TribeRoles.PCV_SAFE_MOVER_ROLE, TribeRoles.GUARDIAN) {
90         _repayETH();
91 
92         // we skip index 0 because that's ETH
93         for (uint256 i = 1; i < UNDERLYINGS.length; i++) {
94             _repayERC20(UNDERLYINGS[i]);
95         }
96     }
97 
98     /// @dev Repay the underlying asset on all ctokens up to the maximum provide
99     /// @notice reverts if the total bad debt is beyond the provided maximum
100     /// @param underlying the asset to repay in
101     /// @param maximum the maximum amount of underlying asset to repay
102     function repay(address underlying, uint256 maximum)
103         public
104         hasAnyOfTwoRoles(TribeRoles.PCV_SAFE_MOVER_ROLE, TribeRoles.GUARDIAN)
105     {
106         require(getTotalDebt(underlying) < maximum, "Total debt is greater than maximum");
107 
108         if (underlying == address(0)) {
109             _repayETH();
110         } else {
111             _repayERC20(underlying);
112         }
113     }
114 
115     /// @dev Gets the total debt for the provided underlying asset
116     /// @notice This is not a view function! Use .staticcall in ethers to get the return value
117     /// @param underlying the asset to get the debt for; pass in 0x0 for ETH
118     /// @return debt the total debt for the asset
119     function getTotalDebt(address underlying) public returns (uint256 debt) {
120         for (uint256 i = 0; i < CTOKENS.length; i++) {
121             CTokenFuse token = CTokenFuse(CTOKENS[i]);
122             if (token.underlying() == underlying) {
123                 debt += CTokenFuse(CTOKENS[i]).borrowBalanceCurrent(DEBTOR);
124             }
125         }
126     }
127 
128     /* Helper Functions */
129 
130     // Creates mappings of underlyings to all applicable ctokens
131     function _buildCTokenMapping() internal {
132         for (uint256 i = 0; i < CTOKENS.length; i++) {
133             address token = CTOKENS[i];
134             address underlying = CTokenFuse(token).underlying();
135             underlyingsToCTokens[underlying].push(token);
136         }
137     }
138 
139     // Approves all underlyings to their respective ctokens
140     function _approveCTokens() internal {
141         for (uint256 i = 0; i < UNDERLYINGS.length; i++) {
142             address underlying = UNDERLYINGS[i];
143 
144             // Don't approve to the 0x0 address
145             if (underlying == address(0)) continue;
146 
147             address[] memory ctokens = underlyingsToCTokens[underlying];
148 
149             for (uint256 j = 0; j < ctokens.length; j++) {
150                 address ctoken = ctokens[j];
151                 SafeERC20.safeApprove(IERC20(underlying), ctoken, type(uint256).max);
152             }
153         }
154     }
155 
156     // Repays ETH to all cether-tokens
157     function _repayETH() internal {
158         address[] memory cEtherTokens = underlyingsToCTokens[address(0)];
159 
160         for (uint256 i = 0; i < cEtherTokens.length; i++) {
161             CEtherFuse token = CEtherFuse(cEtherTokens[i]);
162             uint256 debtAmount = token.borrowBalanceCurrent(DEBTOR);
163             if (debtAmount > 0) {
164                 token.repayBorrowBehalf{value: debtAmount}(DEBTOR);
165             }
166         }
167     }
168 
169     // Repays the provided erc20 to the applicable ctokens
170     function _repayERC20(address underlying) internal {
171         address[] memory cERC20Tokens = underlyingsToCTokens[underlying];
172 
173         for (uint256 i = 0; i < cERC20Tokens.length; i++) {
174             CTokenFuse token = CTokenFuse(cERC20Tokens[i]);
175             uint256 debtAmount = token.borrowBalanceCurrent(DEBTOR);
176             token.repayBorrowBehalf(DEBTOR, debtAmount);
177         }
178     }
179 
180     /* Required Functions from PCVDeposit */
181 
182     function deposit() external override {
183         // no-op
184     }
185 
186     function withdraw(address to, uint256 amount) external override {
187         // no-op, use withdrawERC20 or withdrawETH
188     }
189 
190     function balance() public view virtual override returns (uint256) {
191         return 0;
192     }
193 
194     function balanceReportedIn() public view virtual override returns (address) {
195         return address(0);
196     }
197 
198     /* Make this contract able to receive ETH */
199 
200     receive() external payable {}
201 
202     fallback() external payable {}
203 }
