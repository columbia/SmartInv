1 // SPDX-License-Identifier: GPL-2.0-or-later
2 
3 pragma solidity ^0.8.0;
4 
5 import "../Interfaces.sol";
6 
7 contract FlashLoanAdaptorTest is IERC3156FlashBorrower {
8 
9     event BorrowResult(address token, uint balance, uint fee, uint borrowIndex, address sender, address initiator);
10 
11     function setMaxAllowance(address token, address to) public returns (bool success) {
12         (success,) = token.call(abi.encodeWithSelector(IERC20.approve.selector, to, type(uint).max));
13     }
14 
15     function testFlashBorrow(address lender, address[] calldata receivers, address[] calldata tokens, uint[] calldata amounts) external {
16         bytes memory data = abi.encode(receivers, tokens, amounts, 0);
17         
18         _borrow(lender, receivers[0], tokens[0], amounts[0], data);
19 
20         for (uint i = 0; i < receivers.length; ++i) {
21             for (uint j = 0; j < tokens.length; ++j) {
22                 assert(IERC20(tokens[j]).balanceOf(receivers[i]) == 0);
23             }
24         }
25     }
26 
27     function onFlashLoan(address initiator, address token, uint256, uint256 fee, bytes calldata data) override external returns(bytes32) {
28         (address[] memory receivers, address[] memory tokens, uint[] memory amounts, uint borrowIndex) = 
29             abi.decode(data, (address[], address[], uint[], uint));
30             
31         setMaxAllowance(token, msg.sender);
32 
33         _emitBorrowResult(token, fee, borrowIndex, initiator);
34 
35         if(tokens.length > 0 && borrowIndex < tokens.length - 1) {
36             uint nextBorrowIndex = borrowIndex + 1;
37             _borrow(
38                 msg.sender,
39                 receivers[nextBorrowIndex],
40                 tokens[nextBorrowIndex],
41                 amounts[nextBorrowIndex],
42                 abi.encode(receivers, tokens, amounts, nextBorrowIndex)
43             );
44         }
45 
46         return keccak256("ERC3156FlashBorrower.onFlashLoan");
47     }
48 
49     function _borrow(address lender, address receiver, address token, uint amount, bytes memory data) internal {
50         IERC3156FlashLender(lender).flashLoan(IERC3156FlashBorrower(receiver), token, amount, data);
51     }
52 
53     function _emitBorrowResult(address token, uint fee, uint borrowIndex, address initiator) internal {
54         emit BorrowResult(
55             token,
56             IERC20(token).balanceOf(address(this)),
57             fee,
58             borrowIndex,
59             msg.sender,
60             initiator
61         );
62     }
63 }
