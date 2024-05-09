1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 /// @dev brief interface for entering SUSHI bar (xSUSHI).
6 interface ISushiBarEnter { 
7     function balanceOf(address account) external view returns (uint256);
8     function approve(address spender, uint256 amount) external returns (bool);
9     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
10     function enter(uint256 amount) external;
11 }
12 
13 /// @dev brief interface for depositing into AAVE lending pool.
14 interface IAaveDeposit {
15     function deposit(address asset, uint256 amount, address onBehalfOf, uint16 referralCode) external;
16 }
17 
18 /// @dev contract that batches SUSHI staking into AAVE xSUSHI (aXSUSHI).
19 contract Saave {
20     ISushiBarEnter constant sushiToken = ISushiBarEnter(0x6B3595068778DD592e39A122f4f5a5cF09C90fE2); // SUSHI token contract
21     ISushiBarEnter constant sushiBar = ISushiBarEnter(0x8798249c2E607446EfB7Ad49eC89dD1865Ff4272); // xSUSHI staking contract for SUSHI
22     IAaveDeposit constant aave = IAaveDeposit(0x7d2768dE32b0b80b7a3454c06BdAc94A69DDc7A9); // AAVE lending pool contract for xSUSHI staking into aXSUSHI
23     
24     constructor() public {
25         sushiToken.approve(address(sushiBar), type(uint256).max); // max approve `sushiBar` spender to stake SUSHI into xSUSHI from this contract
26         sushiBar.approve(address(aave), type(uint256).max); // max approve `aave` spender to stake xSUSHI into aXSUSHI from this contract
27     }
28     
29     /// @dev stake `amount` SUSHI into aXSUSHI by batching calls to `sushiBar` and `aave` lending pool.
30     function saave(uint256 amount) external {
31         sushiToken.transferFrom(msg.sender, address(this), amount); // deposit caller SUSHI `amount` into this contract
32         sushiBar.enter(amount); // stake deposited SUSHI `amount` into xSUSHI
33         aave.deposit(address(sushiBar), sushiBar.balanceOf(address(this)), msg.sender, 0); // stake resulting xSUSHI into aXSUSHI - send to caller
34     }
35     
36     /// @dev stake `amount` SUSHI into aXSUSHI for benefit of `to` by batching calls to `sushiBar` and `aave` lending pool.
37     function saaveTo(address to, uint256 amount) external {
38         sushiToken.transferFrom(msg.sender, address(this), amount); // deposit caller SUSHI `amount` into this contract
39         sushiBar.enter(amount); // stake deposited SUSHI `amount` into xSUSHI
40         aave.deposit(address(sushiBar), sushiBar.balanceOf(address(this)), to, 0); // stake resulting xSUSHI into aXSUSHI - send to `to`
41     }
42 }