1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.8.4;
3 
4 import {ILiquidity} from './interfaces/ILiquidity.sol';
5 import {IConvenience} from './interfaces/IConvenience.sol';
6 import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';
7 import {IPair} from '@timeswap-labs/timeswap-v1-core/contracts/interfaces/IPair.sol';
8 import {ERC20Permit} from './base/ERC20Permit.sol';
9 import {SafeMetadata} from './libraries/SafeMetadata.sol';
10 import {Strings} from '@openzeppelin/contracts/utils/Strings.sol';
11 
12 contract Liquidity is ILiquidity, ERC20Permit {
13     using SafeMetadata for IERC20;
14     using Strings for uint256;
15 
16     IConvenience public immutable override convenience;
17     IPair public immutable override pair;
18     uint256 public immutable override maturity;
19 
20     uint8 public constant override decimals = 18;
21 
22     function name() external view override returns (string memory) {
23         string memory assetName = pair.asset().safeName();
24         string memory collateralName = pair.collateral().safeName();
25         return
26             string(
27                 abi.encodePacked('Timeswap Liquidity - ', assetName, ' - ', collateralName, ' - ', maturity.toString())
28             );
29     }
30 
31     function symbol() external view override returns (string memory) {
32         string memory assetSymbol = pair.asset().safeSymbol();
33         string memory collateralSymbol = pair.collateral().safeSymbol();
34         return string(abi.encodePacked('TS-LIQ-', assetSymbol, '-', collateralSymbol, '-', maturity.toString()));
35     }
36 
37     function totalSupply() external view override returns (uint256) {
38         return pair.liquidityOf(maturity, address(this));
39     }
40 
41     constructor(
42         IConvenience _convenience,
43         IPair _pair,
44         uint256 _maturity
45     ) ERC20Permit('Timeswap Liquidity') {
46         convenience = _convenience;
47         pair = _pair;
48         maturity = _maturity;
49     }
50 
51     modifier onlyConvenience() {
52         require(msg.sender == address(convenience), 'E403');
53         _;
54     }
55 
56     function mint(address to, uint256 amount) external override onlyConvenience {
57         _mint(to, amount);
58     }
59 
60     function burn(address from, uint256 amount) external override onlyConvenience {
61         _burn(from, amount);
62     }
63 }
