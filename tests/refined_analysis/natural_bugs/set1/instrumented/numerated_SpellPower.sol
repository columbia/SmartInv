1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity 0.8.6;
3 
4 struct UserInfo {
5     uint256 amount; // How many LP tokens the user has provided.
6     uint256 rewardDebt; // Reward debt. See explanation below.
7     uint256 remainingIceTokenReward;  // ICE Tokens that weren't distributed for user per pool.
8 }
9 interface ISorbettiere {
10     function userInfo(uint256 pid, address account) external view returns (UserInfo memory user);
11 }
12 
13 interface IERC20 {
14     function balanceOf(address account) external view returns (uint256);
15     function totalSupply() external view returns (uint256);
16 }
17 
18 interface IBentoBoxV1BalanceAmount {
19     function balanceOf(IERC20, address) external view returns (uint256);
20     function toAmount(IERC20 token, uint256 share, bool roundUp) external view returns (uint256 amount);
21 }
22 
23 interface ICauldron {
24     function userCollateralShare(address user) external view returns(uint256);
25 }
26 
27 contract SpellPower {
28     ISorbettiere public constant sorbettiere = ISorbettiere(0xF43480afE9863da4AcBD4419A47D9Cc7d25A647F);
29     IERC20 public constant pair = IERC20(0xb5De0C3753b6E1B4dBA616Db82767F17513E6d4E);
30     IERC20 public constant spell = IERC20(0x090185f2135308BaD17527004364eBcC2D37e5F6);
31     IERC20 public constant sspell = IERC20(0x26FA3fFFB6EfE8c1E69103aCb4044C26B9A106a9);
32     ICauldron public constant sspellCauldron = ICauldron(0xC319EEa1e792577C319723b5e60a15dA3857E7da);
33     IBentoBoxV1BalanceAmount public constant bento = IBentoBoxV1BalanceAmount(0xF5BCE5077908a1b7370B9ae04AdC565EBd643966);
34 
35     function name() external pure returns (string memory) { return "SPELLPOWER"; }
36     function symbol() external pure returns (string memory) { return "SPELLPOWER"; }
37     function decimals() external pure returns (uint8) { return 18; }
38     function allowance(address, address) external pure returns (uint256) { return 0; }
39     function approve(address, uint256) external pure returns (bool) { return false; }
40     function transfer(address, uint256) external pure returns (bool) { return false; }
41     function transferFrom(address, address, uint256) external pure returns (bool) { return false; }
42 
43     /// @notice Returns SUSHI voting 'powah' for `account`.
44     function balanceOf(address account) external view returns (uint256 powah) {
45         uint256 bento_balance = bento.toAmount(sspell, (bento.balanceOf(sspell, account) + sspellCauldron.userCollateralShare(account)), false); // get BENTO sSpell balance 'amount' (not shares)
46         uint256 collective_sSpell_balance = bento_balance +  sspell.balanceOf(account); // get collective sSpell staking balances
47         uint256 sSpell_powah = collective_sSpell_balance * spell.balanceOf(address(sspell)) / sspell.totalSupply(); // calculate sSpell weight
48         uint256 lp_stakedBalance = sorbettiere.userInfo(0, account).amount; // get LP balance staked in Sorbettiere
49         uint256 lp_balance = lp_stakedBalance + pair.balanceOf(account); // add staked LP balance & those held by `account`
50         uint256 lp_powah = lp_balance * spell.balanceOf(address(pair)) / pair.totalSupply() * 2; // calculate adjusted LP weight
51         powah = sSpell_powah + lp_powah; // add sSpell & LP weights for 'powah'
52     }
53 
54     /// @notice Returns total 'powah' supply.
55     function totalSupply() external view returns (uint256 total) {
56         total = spell.balanceOf(address(sspell)) + spell.balanceOf(address(pair)) * 2;
57     }
58 }