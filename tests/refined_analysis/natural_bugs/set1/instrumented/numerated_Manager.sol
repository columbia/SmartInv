1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity 0.8.10;
3 
4 /******************************************************************************\
5 * Author: Evert Kors <dev@sherlock.xyz> (https://twitter.com/evert0x)
6 * Sherlock Protocol: https://sherlock.xyz
7 /******************************************************************************/
8 
9 import '@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol';
10 import '@openzeppelin/contracts/access/Ownable.sol';
11 import '@openzeppelin/contracts/security/Pausable.sol';
12 
13 import '../interfaces/managers/IManager.sol';
14 
15 abstract contract Manager is IManager, Ownable, Pausable {
16   using SafeERC20 for IERC20;
17 
18   address private constant DEPLOYER = 0x1C11bE636415973520DdDf1b03822b4e2930D94A;
19   ISherlock internal sherlockCore;
20 
21   modifier onlySherlockCore() {
22     if (msg.sender != address(sherlockCore)) revert InvalidSender();
23     _;
24   }
25 
26   /// @notice Set sherlock core address
27   /// @param _sherlock Current core contract
28   /// @dev Only deployer is able to set core address on all chains except Hardhat network
29   /// @dev One time function, will revert once `sherlock` != address(0)
30   /// @dev This contract will be deployed first, passed on as argument in core constuctor
31   /// @dev emits `SherlockCoreSet`
32   function setSherlockCoreAddress(ISherlock _sherlock) external override {
33     if (address(_sherlock) == address(0)) revert ZeroArgument();
34     // 31337 is of the Hardhat network blockchain
35     if (block.chainid != 31337 && msg.sender != DEPLOYER) revert InvalidSender();
36 
37     if (address(sherlockCore) != address(0)) revert InvalidConditions();
38     sherlockCore = _sherlock;
39 
40     emit SherlockCoreSet(_sherlock);
41   }
42 
43   // Internal function to send tokens remaining in a contract to the receiver address
44   function _sweep(address _receiver, IERC20[] memory _extraTokens) internal {
45     // Loops through the extra tokens (ERC20) provided and sends all of them to the receiver address
46     for (uint256 i; i < _extraTokens.length; i++) {
47       IERC20 token = _extraTokens[i];
48       token.safeTransfer(_receiver, token.balanceOf(address(this)));
49     }
50     // Sends any remaining ETH to the receiver address (as long as receiver address is payable)
51     (bool success, ) = _receiver.call{ value: address(this).balance }('');
52     if (success == false) revert InvalidConditions();
53   }
54 
55   function pause() external virtual onlySherlockCore {
56     _pause();
57   }
58 
59   function unpause() external virtual onlySherlockCore {
60     _unpause();
61   }
62 }
