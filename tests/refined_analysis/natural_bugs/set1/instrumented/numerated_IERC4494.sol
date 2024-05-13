1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.7.6;
4 pragma experimental ABIEncoderV2;
5 
6 import "@openzeppelin/contracts/introspection/IERC165.sol";
7 
8 /// Implementation from https://eips.ethereum.org/EIPS/eip-4494
9 /// @dev Interface for token permits for ERC-721
10 ///
11 interface IERC4494 is IERC165{
12   /// ERC165 bytes to add to interface array - set in parent contract
13   ///
14   /// _INTERFACE_ID_ERC4494 = 0x5604e225
15 
16   /// @notice Function to approve by way of owner signature
17   /// @param spender the address to approve
18   /// @param tokenId the index of the NFT to approve the spender on
19   /// @param deadline a timestamp expiry for the permit
20   /// @param sig a traditional or EIP-2098 signature
21   function permit(address spender, uint256 tokenId, uint256 deadline, bytes memory sig) external;
22   /// @notice Returns the nonce of an NFT - useful for creating permits
23   /// @param tokenId the index of the NFT to get the nonce of
24   /// @return the uint256 representation of the nonce
25   function nonces(uint256 tokenId) external view returns(uint256);
26   /// @notice Returns the domain separator used in the encoding of the signature for permits, as defined by EIP-712
27   /// @return the bytes32 domain separator
28   function DOMAIN_SEPARATOR() external view returns(bytes32);
29 }