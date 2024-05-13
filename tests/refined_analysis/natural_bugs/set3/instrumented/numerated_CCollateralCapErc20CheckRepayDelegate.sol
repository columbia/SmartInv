1 pragma solidity ^0.5.16;
2 
3 import "./CCollateralCapErc20CheckRepay.sol";
4 
5 /**
6  * @title Cream's CCollateralCapErc20CheckRepayDelegate Contract
7  * @notice CTokens which wrap an EIP-20 underlying and are delegated to
8  * @author Cream
9  */
10 contract CCollateralCapErc20CheckRepayDelegate is CCollateralCapErc20CheckRepay {
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
31         // Set internal cash when becoming implementation
32         internalCash = getCashOnChain();
33 
34         // Set CToken version in comptroller
35         ComptrollerInterfaceExtension(address(comptroller)).updateCTokenVersion(
36             address(this),
37             ComptrollerV2Storage.Version.COLLATERALCAP
38         );
39     }
40 
41     /**
42      * @notice Called by the delegator on a delegate to forfeit its responsibility
43      */
44     function _resignImplementation() public {
45         // Shh -- we don't ever want this hook to be marked pure
46         if (false) {
47             implementation = address(0);
48         }
49 
50         require(msg.sender == admin, "admin only");
51     }
52 }
