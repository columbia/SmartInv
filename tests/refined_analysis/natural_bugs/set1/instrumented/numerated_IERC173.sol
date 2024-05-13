1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 /// @title ERC-173 Contract Ownership Standard
5 ///  Note: the ERC-165 identifier for this interface is 0x7f5828d0
6 /* is ERC165 */
7 interface IERC173 {
8     /// @dev This emits when ownership of a contract changes.
9     event OwnershipTransferred(
10         address indexed previousOwner,
11         address indexed newOwner
12     );
13 
14     /// @notice Get the address of the owner
15     /// @return owner_ The address of the owner.
16     function owner() external view returns (address owner_);
17 
18     /// @notice Set the address of the new owner of the contract
19     /// @dev Set _newOwner to address(0) to renounce any ownership.
20     /// @param _newOwner The address of the new owner of the contract
21     function transferOwnership(address _newOwner) external;
22 }
