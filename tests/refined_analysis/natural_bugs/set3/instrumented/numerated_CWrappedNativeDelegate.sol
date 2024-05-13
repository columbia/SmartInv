1 pragma solidity ^0.5.16;
2 
3 import "./CWrappedNative.sol";
4 
5 /**
6  * @title Cream's CWrappedNativeDelegate Contract
7  * @notice CTokens which wrap an EIP-20 underlying and are delegated to
8  * @author Cream
9  */
10 contract CWrappedNativeDelegate is CWrappedNative {
11     /**
12      * @notice Construct an empty delegate
13      */
14     constructor() public {}
15 
16     /**
17      * @notice Called by the delegator on a delegate to initialize it for duty
18      * @param data The encoded bytes data for any initialization
19      */
20     function _becomeImplementation(bytes memory data) public {
21         // Shh -- currently unused
22         data;
23 
24         // Shh -- we don't ever want this hook to be marked pure
25         if (false) {
26             implementation = address(0);
27         }
28 
29         require(msg.sender == admin, "admin only");
30 
31         // Set CToken version in comptroller and convert native token to wrapped token.
32         ComptrollerInterfaceExtension(address(comptroller)).updateCTokenVersion(
33             address(this),
34             ComptrollerV2Storage.Version.WRAPPEDNATIVE
35         );
36         uint256 balance = address(this).balance;
37         if (balance > 0) {
38             WrappedNativeInterface(underlying).deposit.value(balance)();
39         }
40     }
41 
42     /**
43      * @notice Called by the delegator on a delegate to forfeit its responsibility
44      */
45     function _resignImplementation() public {
46         // Shh -- we don't ever want this hook to be marked pure
47         if (false) {
48             implementation = address(0);
49         }
50 
51         require(msg.sender == admin, "admin only");
52     }
53 }
