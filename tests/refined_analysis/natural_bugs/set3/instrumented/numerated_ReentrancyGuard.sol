1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.5.0;
3 
4 /**
5  * @dev Contract module that helps prevent reentrant calls to a function.
6  *
7  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
8  * available, which can be applied to functions to make sure there are no nested
9  * (reentrant) calls to them.
10  *
11  * Note that because there is a single `nonReentrant` guard, functions marked as
12  * `nonReentrant` may not call one another. This can be worked around by making
13  * those functions `private`, and then adding `external` `nonReentrant` entry
14  * points to them.
15  *
16  * TIP: If you would like to learn more about reentrancy and alternative ways
17  * to protect against it, check out our blog post
18  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
19  *
20  * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
21  * metering changes introduced in the Istanbul hardfork.
22  */
23 contract ReentrancyGuard {
24     bool private _notEntered;
25 
26     constructor () internal {
27         // Storing an initial non-zero value makes deployment a bit more
28         // expensive, but in exchange the refund on every call to nonReentrant
29         // will be lower in amount. Since refunds are capped to a percetange of
30         // the total transaction's gas, it is best to keep them low in cases
31         // like this one, to increase the likelihood of the full refund coming
32         // into effect.
33         _notEntered = true;
34     }
35 
36     /**
37      * @dev Prevents a contract from calling itself, directly or indirectly.
38      * Calling a `nonReentrant` function from another `nonReentrant`
39      * function is not supported. It is possible to prevent this from happening
40      * by making the `nonReentrant` function external, and make it call a
41      * `private` function that does the actual work.
42      */
43     modifier nonReentrant() {
44         // On the first call to nonReentrant, _notEntered will be true
45         require(_notEntered, "ReentrancyGuard: reentrant call");
46 
47         // Any calls to nonReentrant after this point will fail
48         _notEntered = false;
49 
50         _;
51 
52         // By storing the original value once again, a refund is triggered (see
53         // https://eips.ethereum.org/EIPS/eip-2200)
54         _notEntered = true;
55     }
56 }