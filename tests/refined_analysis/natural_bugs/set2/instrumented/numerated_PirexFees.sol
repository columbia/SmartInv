1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.19;
3 
4 import {Ownable2Step} from "openzeppelin-contracts/contracts/access/Ownable2Step.sol";
5 import {ERC20} from "solmate/tokens/ERC20.sol";
6 import {SafeTransferLib} from "solmate/utils/SafeTransferLib.sol";
7 import {DataTypes} from "./libraries/DataTypes.sol";
8 import {Errors} from "./libraries/Errors.sol";
9 
10 /**
11  * @title  PirexFees
12  * @notice Handling protocol fees distributions
13  * @dev    This contract manages the distribution of protocol fees to assigned recipient.
14  * @author redactedcartel.finance
15  */
16 contract PirexFees is Ownable2Step {
17     /**
18      * @dev Library: SafeTransferLib - Provides safe transfer functions for ERC20 tokens.
19      */
20     using SafeTransferLib for ERC20;
21 
22     /**
23      * @notice The address designated as the recipient for fees distribution.
24      * @dev    This address is configurable and determines where fees is directed.
25      */
26     address public recipient;
27 
28     // Events
29     /**
30      * @notice Emitted when a fee recipient address is set.
31      * @dev    Signals changes to fee recipient addresses.
32      * @param  recipient  address  The new address set as the new fee recipient.
33      */
34     event SetRecipient(address recipient);
35 
36     /**
37      * @notice Emitted when fees are distributed.
38      * @dev    Signals the distribution of fees.
39      * @param  token   address  The token address for which fees are distributed.
40      * @param  amount  uint256  The amount of fees being distributed.
41      */
42     event DistributeFees(address token, uint256 amount);
43 
44     /**
45      * @notice Constructor to initialize the fee recipient addresses.
46      * @dev    Initializes the contract with the provided recipient address.
47      * @param  _recipient  address  The address of the fee recipient.
48      */
49     constructor(address _recipient) {
50         if (_recipient == address(0)) revert Errors.ZeroAddress();
51 
52         recipient = _recipient;
53     }
54 
55     /**
56      * @notice Set a fee recipient address.
57      * @dev    Allows the owner to set the fee recipient address.
58      * @param  _recipient  address  Fee recipient address.
59      */
60     function setRecipient(address _recipient) external onlyOwner {
61         if (_recipient == address(0)) revert Errors.ZeroAddress();
62 
63         emit SetRecipient(_recipient);
64 
65         recipient = _recipient;
66     }
67 
68     /**
69      * @notice Distribute fees.
70      * @param  from    address  Fee source address.
71      * @param  token   address  Fee token address.
72      * @param  amount  uint256  Fee token amount.
73      */
74     function distributeFees(
75         address from,
76         address token,
77         uint256 amount
78     ) external {
79         emit DistributeFees(token, amount);
80 
81         ERC20 t = ERC20(token);
82 
83         // Favoring push over pull to reduce accounting complexity for different tokens
84         t.safeTransferFrom(from, recipient, amount);
85     }
86 }
