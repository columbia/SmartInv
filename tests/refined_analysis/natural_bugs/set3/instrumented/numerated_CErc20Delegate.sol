1 pragma solidity ^0.5.16;
2 
3 import "./CErc20.sol";
4 
5 /**
6  * @title Compound's CErc20Delegate Contract
7  * @notice CTokens which wrap an EIP-20 underlying and are delegated to
8  * @author Compound
9  */
10 contract CErc20Delegate is CErc20, CDelegateInterface {
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
30     }
31 
32     /**
33      * @notice Called by the delegator on a delegate to forfeit its responsibility
34      */
35     function _resignImplementation() public {
36         // Shh -- we don't ever want this hook to be marked pure
37         if (false) {
38             implementation = address(0);
39         }
40 
41         require(msg.sender == admin, "admin only");
42     }
43 }
