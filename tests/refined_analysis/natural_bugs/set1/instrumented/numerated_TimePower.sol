1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity 0.8.7;
3 
4 struct UserInfo {
5     uint256 amount; // How many LP tokens the user has provided.
6     uint256 rewardDebt; // Reward debt. See explanation below.
7 }
8 interface IJoeStaking {
9     function userInfo(uint256 pid, address account) external view returns (UserInfo memory user);
10 }
11 
12 interface IERC20 {
13     function balanceOf(address account) external view returns (uint256);
14     function totalSupply() external view returns (uint256);
15 }
16 
17 interface IBentoBoxV1BalanceAmount {
18     function balanceOf(IERC20, address) external view returns (uint256);
19     function toAmount(IERC20 token, uint256 share, bool roundUp) external view returns (uint256 amount);
20 }
21 
22 interface ICauldron {
23     function userCollateralShare(address user) external view returns(uint256);
24 }
25 
26 interface IwMEMO is IERC20 {
27     function wMEMOToMEMO(uint256 amount) external view returns(uint256);
28 }
29 
30 contract TimePower {
31     IJoeStaking public constant joeStaking = IJoeStaking(0xd6a4F121CA35509aF06A0Be99093d08462f53052);
32     IERC20 public constant AvaxTime = IERC20(0xf64e1c5B6E17031f5504481Ac8145F4c3eab4917);
33     IERC20 public constant MimTime = IERC20(0x113f413371fC4CC4C9d6416cf1DE9dFd7BF747Df);
34     IERC20 public constant TIME = IERC20(0xb54f16fB19478766A268F172C9480f8da1a7c9C3);
35     IERC20 public constant MEMO = IERC20(0x136Acd46C134E8269052c62A67042D6bDeDde3C9);
36     IwMEMO public constant wMEMO = IwMEMO(0x0da67235dD5787D67955420C84ca1cEcd4E5Bb3b);
37     ICauldron public constant wMEMOCauldron1 = ICauldron(0x56984F04d2d04B2F63403f0EbeDD3487716bA49d);
38     ICauldron public constant wMEMOCauldron2 = ICauldron(0x35fA7A723B3B39f15623Ff1Eb26D8701E7D6bB21);
39     IBentoBoxV1BalanceAmount public constant bento = IBentoBoxV1BalanceAmount(0xf4F46382C2bE1603Dc817551Ff9A7b333Ed1D18f);
40 
41     function name() external pure returns (string memory) { return "SPELLPOWER"; }
42     function symbol() external pure returns (string memory) { return "SPELLPOWER"; }
43     function decimals() external pure returns (uint8) { return 9; }
44     function allowance(address, address) external pure returns (uint256) { return 0; }
45     function approve(address, uint256) external pure returns (bool) { return false; }
46     function transfer(address, uint256) external pure returns (bool) { return false; }
47     function transferFrom(address, address, uint256) external pure returns (bool) { return false; }
48 
49     /// @notice Returns SUSHI voting 'powah' for `account`.
50     function balanceOf(address account) external view returns (uint256 powah) {
51         uint256 bento_balance = bento.toAmount(wMEMO, (bento.balanceOf(wMEMO, account) + wMEMOCauldron1.userCollateralShare(account) + wMEMOCauldron2.userCollateralShare(account)), false); // get BENTO wMEMO balance 'amount' (not shares)
52         uint256 collective_wMEMO_balance = bento_balance +  wMEMO.balanceOf(account); // get collective wMEMO staking balances
53         uint256 time_powah =  wMEMO.wMEMOToMEMO(collective_wMEMO_balance) + MEMO.balanceOf(account) + TIME.balanceOf(account); // calculate TIME weight
54         uint256 avax_time_balance = joeStaking.userInfo(45, account).amount + AvaxTime.balanceOf(account); // add staked LP balance & those held by `account`
55         uint256 avax_time_powah = avax_time_balance * TIME.balanceOf(address(AvaxTime)) / AvaxTime.totalSupply() * 2; // calculate adjusted LP weight
56         uint256 mim_time_powah = MimTime.balanceOf(account) * TIME.balanceOf(address(MimTime)) / MimTime.totalSupply() * 2; // calculate adjusted LP weight
57         powah = time_powah + avax_time_powah + mim_time_powah; // add wMEMO & LP weights for 'powah'
58     }
59 
60     /// @notice Returns total 'powah' supply.
61     function totalSupply() external view returns (uint256 total) {
62         total = TIME.balanceOf(address(AvaxTime)) * 2 + TIME.balanceOf(address(MimTime)) * 2 + TIME.balanceOf(0x4456B87Af11e87E329AB7d7C7A246ed1aC2168B9);
63     }
64 }