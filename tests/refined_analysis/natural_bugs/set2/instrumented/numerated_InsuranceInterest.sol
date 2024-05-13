1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.8.4;
3 
4 import {IClaim} from './interfaces/IClaim.sol';
5 import {IConvenience} from './interfaces/IConvenience.sol';
6 import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';
7 import {IPair} from '@timeswap-labs/timeswap-v1-core/contracts/interfaces/IPair.sol';
8 import {ERC20Permit} from './base/ERC20Permit.sol';
9 import {SafeMetadata} from './libraries/SafeMetadata.sol';
10 import {Strings} from '@openzeppelin/contracts/utils/Strings.sol';
11 
12 contract InsuranceInterest is IClaim, ERC20Permit {
13     using SafeMetadata for IERC20;
14     using Strings for uint256;
15 
16     IConvenience public immutable override convenience;
17     IPair public immutable override pair;
18     uint256 public immutable override maturity;
19 
20     function name() external view override returns (string memory) {
21         string memory assetName = pair.asset().safeName();
22         string memory collateralName = pair.collateral().safeName();
23         return
24             string(
25                 abi.encodePacked(
26                     'Timeswap Insurance Interest- ',
27                     assetName,
28                     ' - ',
29                     collateralName,
30                     ' - ',
31                     maturity.toString()
32                 )
33             );
34     }
35 
36     function symbol() external view override returns (string memory) {
37         string memory assetSymbol = pair.asset().safeSymbol();
38         string memory collateralSymbol = pair.collateral().safeSymbol();
39         return string(abi.encodePacked('TS-INS-INT-', assetSymbol, '-', collateralSymbol, '-', maturity.toString()));
40     }
41 
42     function decimals() external view override returns (uint8) {
43         return pair.collateral().safeDecimals();
44     }
45 
46     function totalSupply() external view override returns (uint256) {
47         return pair.claimsOf(maturity, address(convenience)).insuranceInterest;
48     }
49 
50     constructor(
51         IConvenience _convenience,
52         IPair _pair,
53         uint256 _maturity
54     ) ERC20Permit('Timeswap Insurance Interest') {
55         convenience = _convenience;
56         pair = _pair;
57         maturity = _maturity;
58     }
59 
60     modifier onlyConvenience() {
61         require(msg.sender == address(convenience), 'E403');
62         _;
63     }
64 
65     function mint(address to, uint128 amount) external override onlyConvenience {
66         _mint(to, amount);
67     }
68 
69     function burn(address from, uint128 amount) external override onlyConvenience {
70         _burn(from, amount);
71     }
72 }
