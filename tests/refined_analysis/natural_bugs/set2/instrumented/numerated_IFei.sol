1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
5 
6 /// @title FEI stablecoin interface
7 /// @author Fei Protocol
8 interface IFei is IERC20 {
9     // ----------- Events -----------
10 
11     event Minting(address indexed _to, address indexed _minter, uint256 _amount);
12 
13     event Burning(address indexed _to, address indexed _burner, uint256 _amount);
14 
15     event IncentiveContractUpdate(address indexed _incentivized, address indexed _incentiveContract);
16 
17     // ----------- State changing api -----------
18 
19     function burn(uint256 amount) external;
20 
21     function permit(
22         address owner,
23         address spender,
24         uint256 value,
25         uint256 deadline,
26         uint8 v,
27         bytes32 r,
28         bytes32 s
29     ) external;
30 
31     // ----------- Burner only state changing api -----------
32 
33     function burnFrom(address account, uint256 amount) external;
34 
35     // ----------- Minter only state changing api -----------
36 
37     function mint(address account, uint256 amount) external;
38 
39     // ----------- Governor only state changing api -----------
40 
41     function setIncentiveContract(address account, address incentive) external;
42 
43     // ----------- Getters -----------
44 
45     function incentiveContract(address account) external view returns (address);
46 }
