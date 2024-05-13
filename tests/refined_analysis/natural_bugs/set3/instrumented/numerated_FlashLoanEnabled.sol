1 // SPDX-License-Identifier: MIT WITH AGPL-3.0-only
2 
3 pragma solidity 0.6.12;
4 
5 import "./PermissionlessSwap.sol";
6 import "../interfaces/IFlashLoanReceiver.sol";
7 
8 abstract contract FlashLoanEnabled {
9     // Total fee that is charged on all flashloans in BPS. Borrowers must repay the amount plus the flash loan fee.
10     // This fee is split between the protocol and the pool.
11     uint256 public flashLoanFeeBPS;
12     // Share of the flash loan fee that goes to the protocol in BPS. A portion of each flash loan fee is allocated
13     // to the protocol rather than the pool.
14     uint256 public protocolFeeShareBPS;
15     // Max BPS for limiting flash loan fee settings.
16     uint256 public constant MAX_BPS = 10000;
17 
18     /*** EVENTS ***/
19     event FlashLoan(
20         address indexed receiver,
21         uint8 tokenIndex,
22         uint256 amount,
23         uint256 amountFee,
24         uint256 protocolFee
25     );
26 
27     /**
28      * @notice Borrow the specified token from this pool for this transaction only. This function will call
29      * `IFlashLoanReceiver(receiver).executeOperation` and the `receiver` must return the full amount of the token
30      * and the associated fee by the end of the callback transaction. If the conditions are not met, this call
31      * is reverted.
32      * @param receiver the address of the receiver of the token. This address must implement the IFlashLoanReceiver
33      * interface and the callback function `executeOperation`.
34      * @param token the protocol fee in bps to be applied on the total flash loan fee
35      * @param amount the total amount to borrow in this transaction
36      * @param params optional data to pass along to the callback function
37      */
38     function flashLoan(
39         address receiver,
40         IERC20 token,
41         uint256 amount,
42         bytes memory params
43     ) external payable virtual;
44 
45     /**
46      * @notice Updates the flash loan fee parameters.
47      * @dev This function should be overridden for permissions.
48      * @param newFlashLoanFeeBPS the total fee in bps to be applied on future flash loans
49      * @param newProtocolFeeShareBPS the protocol fee in bps to be applied on the total flash loan fee
50      */
51     function _setFlashLoanFees(
52         uint256 newFlashLoanFeeBPS,
53         uint256 newProtocolFeeShareBPS
54     ) internal {
55         require(
56             newFlashLoanFeeBPS > 0 &&
57                 newFlashLoanFeeBPS <= MAX_BPS &&
58                 newProtocolFeeShareBPS <= MAX_BPS,
59             "fees are not in valid range"
60         );
61         flashLoanFeeBPS = newFlashLoanFeeBPS;
62         protocolFeeShareBPS = newProtocolFeeShareBPS;
63     }
64 }
