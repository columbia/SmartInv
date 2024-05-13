1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 /**
6  * Utility library of inline functions on addresses
7  *
8  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/utils/Address.sol
9  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
10  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
11  * build/artifacts folder) as well as the vanilla Address implementation from an openzeppelin version.
12  */
13 library OpenZeppelinUpgradesAddress {
14     /**
15      * Returns whether the target address is a contract
16      * @dev This function will return false if invoked during the constructor of a contract,
17      * as the code is not actually created until after the constructor finishes.
18      * @param account address of the account to check
19      * @return whether the target address is a contract
20      */
21     function isContract(address account) internal view returns (bool) {
22         uint256 size;
23         // XXX Currently there is no better way to check if there is a contract in an address
24         // than to check the size of the code at that address.
25         // See https://ethereum.stackexchange.com/a/14016/36603
26         // for more details about how this works.
27         // TODO Check this again before the Serenity release, because all addresses will be
28         // contracts then.
29         // solhint-disable-next-line no-inline-assembly
30         assembly { size := extcodesize(account) }
31         return size > 0;
32     }
33 }
