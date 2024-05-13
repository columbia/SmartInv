1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "./ITribeMinter.sol";
5 import "../utils/RateLimited.sol";
6 import "../Constants.sol";
7 import "@openzeppelin/contracts/utils/math/Math.sol";
8 import "@openzeppelin/contracts/access/Ownable.sol";
9 
10 /** 
11   @title implementation for a TRIBE Minter Contract
12   @author Fei Protocol
13 
14   This contract will be the unique TRIBE minting contract. 
15   All minting is subject to an annual inflation rate limit.
16   For example if circulating supply is 1m and inflation is capped at 10%, then no more than 100k TRIBE can enter circulation in the following year.
17 
18   The contract will increase (decrease) the rate limit proportionally as supply increases (decreases)
19 
20   Governance and admins can only lower the max inflation %. 
21   They can also exclude (unexclude) addresses' TRIBE balances from the circulating supply. 
22   The minter's balance is excluded by default.
23 
24   ACCESS_CONTROL:
25   This contract follows a somewhat unique access control pattern. 
26   It has a contract admin which is NOT intended for optimistic approval, but rather for contracts such as the TribeReserveStabilizer.
27   An additional potential contract admin is one which automates the inclusion and removal of excluded deposits from on-chain timelocks.
28 
29   Additionally, the ability to transfer the tribe minter role is held by the contract *owner* rather than governor or admin.
30   The owner will intially be the DAO timelock.
31   This keeps the power to transfer or burn TRIBE minting rights isolated.
32 */
33 contract TribeMinter is ITribeMinter, RateLimited, Ownable {
34     /// @notice the max inflation in TRIBE circulating supply per year in basis points (1/10000)
35     uint256 public override annualMaxInflationBasisPoints;
36 
37     /// @notice the tribe treasury address used to exclude from circulating supply
38     address public override tribeTreasury;
39 
40     /// @notice the tribe rewards dripper address used to exclude from circulating supply
41     address public override tribeRewardsDripper;
42 
43     /// @notice Tribe Reserve Stabilizer constructor
44     /// @param _core Fei Core to reference
45     /// @param _annualMaxInflationBasisPoints the max inflation in TRIBE circulating supply per year in basis points (1/10000)
46     /// @param _owner the owner, capable of changing the tribe minter address.
47     /// @param _tribeTreasury the tribe treasury address used to exclude from circulating supply
48     /// @param _tribeRewardsDripper the tribe rewards dripper address used to exclude from circulating supply
49     constructor(
50         address _core,
51         uint256 _annualMaxInflationBasisPoints,
52         address _owner,
53         address _tribeTreasury,
54         address _tribeRewardsDripper
55     ) RateLimited(0, 0, 0, false) CoreRef(_core) {
56         _setAnnualMaxInflationBasisPoints(_annualMaxInflationBasisPoints);
57         poke();
58 
59         // start with a full buffer
60         _resetBuffer();
61 
62         transferOwnership(_owner);
63 
64         if (_tribeTreasury != address(0)) {
65             tribeTreasury = _tribeTreasury;
66             emit TribeTreasuryUpdate(address(0), _tribeTreasury);
67         }
68 
69         if (_tribeRewardsDripper != address(0)) {
70             tribeRewardsDripper = _tribeRewardsDripper;
71             emit TribeRewardsDripperUpdate(address(0), _tribeRewardsDripper);
72         }
73     }
74 
75     /// @notice update the rate limit per second and buffer cap
76     function poke() public override {
77         uint256 newBufferCap = idealBufferCap();
78         uint256 oldBufferCap = bufferCap;
79         require(newBufferCap != oldBufferCap, "TribeMinter: No rate limit change needed");
80 
81         _setBufferCap(newBufferCap);
82         _setRateLimitPerSecond(newBufferCap / Constants.ONE_YEAR);
83     }
84 
85     /// @dev no-op, reverts. Prevent admin or governor from overwriting ideal rate limit
86     function setRateLimitPerSecond(uint256) external pure override {
87         revert("no-op");
88     }
89 
90     /// @dev no-op, reverts. Prevent admin or governor from overwriting ideal buffer cap
91     function setBufferCap(uint256) external pure override {
92         revert("no-op");
93     }
94 
95     /// @notice mints TRIBE to the target address, subject to rate limit
96     /// @param to the address to send TRIBE to
97     /// @param amount the amount of TRIBE to send
98     function mint(address to, uint256 amount) external override onlyGovernorOrAdmin {
99         // first apply rate limit
100         _depleteBuffer(amount);
101 
102         // then mint
103         _mint(to, amount);
104     }
105 
106     /// @notice sets the new TRIBE treasury address
107     function setTribeTreasury(address newTribeTreasury) external override onlyGovernorOrAdmin {
108         address oldTribeTreasury = tribeTreasury;
109         tribeTreasury = newTribeTreasury;
110         emit TribeTreasuryUpdate(oldTribeTreasury, newTribeTreasury);
111     }
112 
113     /// @notice sets the new TRIBE treasury rewards dripper
114     function setTribeRewardsDripper(address newTribeRewardsDripper) external override onlyGovernorOrAdmin {
115         address oldTribeRewardsDripper = tribeRewardsDripper;
116         tribeRewardsDripper = newTribeRewardsDripper;
117         emit TribeTreasuryUpdate(oldTribeRewardsDripper, newTribeRewardsDripper);
118     }
119 
120     /// @notice changes the TRIBE minter address
121     /// @param newMinter the new minter address
122     function setMinter(address newMinter) external override onlyOwner {
123         require(newMinter != address(0), "TribeReserveStabilizer: zero address");
124         ITribe _tribe = ITribe(address(tribe()));
125         _tribe.setMinter(newMinter);
126     }
127 
128     /// @notice sets the max annual inflation relative to current supply
129     /// @param newAnnualMaxInflationBasisPoints the new max inflation % denominated in basis points (1/10000)
130     function setAnnualMaxInflationBasisPoints(uint256 newAnnualMaxInflationBasisPoints)
131         external
132         override
133         onlyGovernorOrAdmin
134     {
135         _setAnnualMaxInflationBasisPoints(newAnnualMaxInflationBasisPoints);
136     }
137 
138     /// @notice return the ideal buffer cap based on TRIBE circulating supply
139     function idealBufferCap() public view override returns (uint256) {
140         return (tribeCirculatingSupply() * annualMaxInflationBasisPoints) / Constants.BASIS_POINTS_GRANULARITY;
141     }
142 
143     /// @notice return the TRIBE supply, subtracting locked TRIBE
144     function tribeCirculatingSupply() public view override returns (uint256) {
145         IERC20 _tribe = tribe();
146 
147         // Remove all locked TRIBE from total supply calculation
148         uint256 lockedTribe = _tribe.balanceOf(address(this));
149 
150         if (tribeTreasury != address(0)) {
151             lockedTribe += _tribe.balanceOf(tribeTreasury);
152         }
153 
154         if (tribeRewardsDripper != address(0)) {
155             lockedTribe += _tribe.balanceOf(tribeRewardsDripper);
156         }
157 
158         return _tribe.totalSupply() - lockedTribe;
159     }
160 
161     /// @notice alias for tribeCirculatingSupply
162     /// @dev for compatibility with ERC-20 standard for off-chain 3rd party sites
163     function totalSupply() public view override returns (uint256) {
164         return tribeCirculatingSupply();
165     }
166 
167     /// @notice return whether a poke is needed or not i.e. is buffer cap != ideal cap
168     function isPokeNeeded() external view override returns (bool) {
169         return idealBufferCap() != bufferCap;
170     }
171 
172     // Transfer held TRIBE first, then mint to cover remainder
173     function _mint(address to, uint256 amount) internal {
174         ITribe _tribe = ITribe(address(tribe()));
175 
176         uint256 _tribeBalance = _tribe.balanceOf(address(this));
177         uint256 mintAmount = amount;
178 
179         // First transfer maximum amount of held TRIBE
180         if (_tribeBalance != 0) {
181             uint256 transferAmount = Math.min(_tribeBalance, amount);
182 
183             _tribe.transfer(to, transferAmount);
184 
185             mintAmount = mintAmount - transferAmount;
186             assert(mintAmount + transferAmount == amount);
187         }
188 
189         // Then mint if any more is needed
190         if (mintAmount != 0) {
191             _tribe.mint(to, mintAmount);
192         }
193     }
194 
195     function _setAnnualMaxInflationBasisPoints(uint256 newAnnualMaxInflationBasisPoints) internal {
196         uint256 oldAnnualMaxInflationBasisPoints = annualMaxInflationBasisPoints;
197         require(newAnnualMaxInflationBasisPoints != 0, "TribeMinter: cannot have 0 inflation");
198 
199         // make sure the new inflation is strictly lower, unless the old inflation is 0 (which is only true upon construction)
200         require(
201             newAnnualMaxInflationBasisPoints < oldAnnualMaxInflationBasisPoints ||
202                 oldAnnualMaxInflationBasisPoints == 0,
203             "TribeMinter: cannot increase max inflation"
204         );
205 
206         annualMaxInflationBasisPoints = newAnnualMaxInflationBasisPoints;
207 
208         emit AnnualMaxInflationUpdate(oldAnnualMaxInflationBasisPoints, newAnnualMaxInflationBasisPoints);
209     }
210 }
