1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.8.4;
3 
4 import {IDue} from './interfaces/IDue.sol';
5 import {IERC721Receiver} from '@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol';
6 import {IConvenience} from './interfaces/IConvenience.sol';
7 import {IPair} from '@timeswap-labs/timeswap-v1-core/contracts/interfaces/IPair.sol';
8 import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';
9 import {ERC721Permit} from './base/ERC721Permit.sol';
10 import {SafeMetadata} from './libraries/SafeMetadata.sol';
11 import {Strings} from '@openzeppelin/contracts/utils/Strings.sol';
12 import {NFTTokenURIScaffold} from './libraries/NFTTokenURIScaffold.sol';
13 
14 contract CollateralizedDebt is IDue, ERC721Permit {
15     using Strings for uint256;
16     using SafeMetadata for IERC20;
17 
18     IConvenience public immutable override convenience;
19     IPair public immutable override pair;
20     uint256 public immutable override maturity;
21 
22     function name() external view override returns (string memory) {
23         string memory assetName = pair.asset().safeName();
24         string memory collateralName = pair.collateral().safeName();
25         return
26             string(
27                 abi.encodePacked(
28                     'Timeswap Collateralized Debt - ',
29                     assetName,
30                     ' - ',
31                     collateralName,
32                     ' - ',
33                     maturity.toString()
34                 )
35             );
36     }
37 
38     function symbol() external view override returns (string memory) {
39         string memory assetSymbol = pair.asset().safeSymbol();
40         string memory collateralSymbol = pair.collateral().safeSymbol();
41         return string(abi.encodePacked('TS-CDT-', assetSymbol, '-', collateralSymbol, '-', maturity.toString()));
42     }
43 
44     function tokenURI(uint256 id) external view override returns (string memory) {
45         require(_owners[id] != address(0), 'E404');
46         return NFTTokenURIScaffold.tokenURI(id, pair, pair.dueOf(maturity, address(convenience), id), maturity);
47     }
48 
49     function assetDecimals() external view override returns (uint8) {
50         return pair.asset().safeDecimals();
51     }
52 
53     function collateralDecimals() external view override returns (uint8) {
54         return pair.collateral().safeDecimals();
55     }
56 
57     function totalSupply() external view override returns (uint256) {
58         return pair.totalDuesOf(maturity, address(convenience));
59     }
60 
61     function tokenByIndex(uint256 id) external view override returns (uint256) {
62         require(id < pair.totalDuesOf(maturity, address(convenience)), 'E614');
63         return id;
64     }
65 
66     function dueOf(uint256 id) external view override returns (IPair.Due memory) {
67         return pair.dueOf(maturity, address(convenience), id);
68     }
69 
70     constructor(
71         IConvenience _convenience,
72         IPair _pair,
73         uint256 _maturity
74     ) ERC721Permit('Timeswap Collateralized Debt') {
75         convenience = _convenience;
76         pair = _pair;
77         maturity = _maturity;
78     }
79 
80     modifier onlyConvenience() {
81         require(msg.sender == address(convenience), 'E403');
82         _;
83     }
84 
85     function mint(address to, uint256 id) external override onlyConvenience {
86         _safeMint(to, id);
87     }
88 }
