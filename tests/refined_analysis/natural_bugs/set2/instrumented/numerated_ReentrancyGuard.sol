1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 /**
6  * @dev Contract module that helps prevent reentrant calls to a function.
7  *
8  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
9  * available, which can be applied to functions to make sure there are no nested
10  * (reentrant) calls to them.
11  *
12  * Note that because there is a single `nonReentrant` guard, functions marked as
13  * `nonReentrant` may not call one another. This can be worked around by making
14  * those functions `private`, and then adding `external` `nonReentrant` entry
15  * points to them.
16  *
17  * TIP: If you would like to learn more about reentrancy and alternative ways
18  * to protect against it, check out our blog post
19  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
20  *
21  * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
22  * metering changes introduced in the Istanbul hardfork.
23  */
24 contract ReentrancyGuard {
25     bool private _notEntered;
26 
27     constructor () internal {
28         // Storing an initial non-zero value makes deployment a bit more
29         // expensive, but in exchange the refund on every call to nonReentrant
30         // will be lower in amount. Since refunds are capped to a percetange of
31         // the total transaction's gas, it is best to keep them low in cases
32         // like this one, to increase the likelihood of the full refund coming
33         // into effect.
34         _notEntered = true;
35     }
36 
37     /**
38      * @dev Prevents a contract from calling itself, directly or indirectly.
39      * Calling a `nonReentrant` function from another `nonReentrant`
40      * function is not supported. It is possible to prevent this from happening
41      * by making the `nonReentrant` function external, and make it call a
42      * `private` function that does the actual work.
43      */
44     modifier nonReentrant() {
45         // On the first call to nonReentrant, _notEntered will be true
46         require(_notEntered, "ReentrancyGuard: reentrant call");
47 
48         // Any calls to nonReentrant after this point will fail
49         _notEntered = false;
50 
51         _;
52 
53         // By storing the original value once again, a refund is triggered (see
54         // https://eips.ethereum.org/EIPS/eip-2200)
55         _notEntered = true;
56     }
57 }
