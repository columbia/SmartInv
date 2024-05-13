1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 import "@openzeppelin/contracts/access/Ownable.sol";
6 import "@openzeppelin/contracts/proxy/Clones.sol";
7 import "./interfaces/ISwap.sol";
8 import "./interfaces/IMetaSwap.sol";
9 
10 contract SwapDeployer is Ownable {
11     event NewSwapPool(
12         address indexed deployer,
13         address swapAddress,
14         IERC20[] pooledTokens
15     );
16     event NewClone(address indexed target, address cloneAddress);
17 
18     constructor() public Ownable() {}
19 
20     function clone(address target) external returns (address) {
21         address newClone = _clone(target);
22         emit NewClone(target, newClone);
23 
24         return newClone;
25     }
26 
27     function _clone(address target) internal returns (address) {
28         return Clones.clone(target);
29     }
30 
31     function deploy(
32         address swapAddress,
33         IERC20[] memory _pooledTokens,
34         uint8[] memory decimals,
35         string memory lpTokenName,
36         string memory lpTokenSymbol,
37         uint256 _a,
38         uint256 _fee,
39         uint256 _adminFee,
40         address lpTokenTargetAddress
41     ) external returns (address) {
42         address swapClone = _clone(swapAddress);
43         ISwap(swapClone).initialize(
44             _pooledTokens,
45             decimals,
46             lpTokenName,
47             lpTokenSymbol,
48             _a,
49             _fee,
50             _adminFee,
51             lpTokenTargetAddress
52         );
53         Ownable(swapClone).transferOwnership(owner());
54         emit NewSwapPool(msg.sender, swapClone, _pooledTokens);
55         return swapClone;
56     }
57 
58     function deployMetaSwap(
59         address metaSwapAddress,
60         IERC20[] memory _pooledTokens,
61         uint8[] memory decimals,
62         string memory lpTokenName,
63         string memory lpTokenSymbol,
64         uint256 _a,
65         uint256 _fee,
66         uint256 _adminFee,
67         address lpTokenTargetAddress,
68         ISwap baseSwap
69     ) external returns (address) {
70         address metaSwapClone = _clone(metaSwapAddress);
71         IMetaSwap(metaSwapClone).initializeMetaSwap(
72             _pooledTokens,
73             decimals,
74             lpTokenName,
75             lpTokenSymbol,
76             _a,
77             _fee,
78             _adminFee,
79             lpTokenTargetAddress,
80             baseSwap
81         );
82         Ownable(metaSwapClone).transferOwnership(owner());
83         emit NewSwapPool(msg.sender, metaSwapClone, _pooledTokens);
84         return metaSwapClone;
85     }
86 }
