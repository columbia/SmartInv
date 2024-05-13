1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 import "@openzeppelin/contracts/access/Ownable.sol";
6 import "@openzeppelin/contracts/proxy/Clones.sol";
7 import "./interfaces/ISwapV1.sol";
8 
9 contract SwapDeployerV1 is Ownable {
10     event NewSwapPool(
11         address indexed deployer,
12         address swapAddress,
13         IERC20[] pooledTokens
14     );
15 
16     constructor() public Ownable() {}
17 
18     function deploy(
19         address swapAddress,
20         IERC20[] memory _pooledTokens,
21         uint8[] memory decimals,
22         string memory lpTokenName,
23         string memory lpTokenSymbol,
24         uint256 _a,
25         uint256 _fee,
26         uint256 _adminFee,
27         uint256 _withdrawFee,
28         address lpTokenTargetAddress
29     ) external returns (address) {
30         address swapClone = Clones.clone(swapAddress);
31         ISwapV1(swapClone).initialize(
32             _pooledTokens,
33             decimals,
34             lpTokenName,
35             lpTokenSymbol,
36             _a,
37             _fee,
38             _adminFee,
39             _withdrawFee,
40             lpTokenTargetAddress
41         );
42         Ownable(swapClone).transferOwnership(owner());
43         emit NewSwapPool(msg.sender, swapClone, _pooledTokens);
44         return swapClone;
45     }
46 }
