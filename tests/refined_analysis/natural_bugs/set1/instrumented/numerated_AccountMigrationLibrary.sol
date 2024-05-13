1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 
3 pragma solidity ^0.8.0;
4 
5 import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
6 import "@openzeppelin/contracts/utils/cryptography/SignatureChecker.sol";
7 import "@openzeppelin/contracts/utils/Strings.sol";
8 
9 error AccountMigrationLibrary_Cannot_Migrate_Account_To_Itself();
10 error AccountMigrationLibrary_Signature_Verification_Failed();
11 
12 /**
13  * @title A library which confirms account migration signatures.
14  * @notice Checks for a valid signature authorizing the migration of an account to a new address.
15  * @dev This is shared by both the NFT contracts and FNDNFTMarket, and the same signature authorizes both.
16  */
17 library AccountMigrationLibrary {
18   using ECDSA for bytes;
19   using SignatureChecker for address;
20   using Strings for uint256;
21 
22   /**
23    * @notice Confirms the msg.sender is a Foundation operator and that the signature provided is valid.
24    * @param originalAddress The address of the account to be migrated.
25    * @param newAddress The new address representing this account.
26    * @param signature Message `I authorize Foundation to migrate my account to ${newAccount.address.toLowerCase()}`
27    * signed by the original account.
28    */
29   function requireAuthorizedAccountMigration(
30     address originalAddress,
31     address newAddress,
32     bytes memory signature
33   ) internal view {
34     if (originalAddress == newAddress) {
35       revert AccountMigrationLibrary_Cannot_Migrate_Account_To_Itself();
36     }
37     bytes32 hash = abi
38       .encodePacked("I authorize Foundation to migrate my account to ", _toAsciiString(newAddress))
39       .toEthSignedMessageHash();
40     if (!originalAddress.isValidSignatureNow(hash, signature)) {
41       revert AccountMigrationLibrary_Signature_Verification_Failed();
42     }
43   }
44 
45   /**
46    * @notice Converts an address into a string.
47    * @dev From https://ethereum.stackexchange.com/questions/8346/convert-address-to-string
48    */
49   function _toAsciiString(address x) private pure returns (string memory) {
50     unchecked {
51       bytes memory s = new bytes(42);
52       s[0] = "0";
53       s[1] = "x";
54       for (uint256 i = 0; i < 20; ++i) {
55         bytes1 b = bytes1(uint8(uint256(uint160(x)) / (2**(8 * (19 - i)))));
56         bytes1 hi = bytes1(uint8(b) / 16);
57         bytes1 lo = bytes1(uint8(b) - 16 * uint8(hi));
58         s[2 * i + 2] = _char(hi);
59         s[2 * i + 3] = _char(lo);
60       }
61       return string(s);
62     }
63   }
64 
65   /**
66    * @notice Converts a byte to a UTF-8 character.
67    */
68   function _char(bytes1 b) private pure returns (bytes1 c) {
69     unchecked {
70       if (uint8(b) < 10) return bytes1(uint8(b) + 0x30);
71       else return bytes1(uint8(b) + 0x57);
72     }
73   }
74 }
