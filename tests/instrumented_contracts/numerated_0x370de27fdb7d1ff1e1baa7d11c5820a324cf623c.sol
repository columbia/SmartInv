1 pragma solidity ^0.5.0;
2 
3 
4 /**
5  * @title ERC20FeeProxy
6  * @notice This contract performs an ERC20 token transfer, with a Fee sent to a third address and stores a reference
7  */
8 contract ERC20FeeProxy {
9   // Event to declare a transfer with a reference
10   event TransferWithReferenceAndFee(
11     address tokenAddress,
12     address to,
13     uint256 amount,
14     bytes indexed paymentReference,
15     uint256 feeAmount,
16     address feeAddress
17   );
18 
19   // Fallback function returns funds to the sender
20   function() external payable {
21     revert("not payable fallback");
22   }
23 
24   /**
25     * @notice Performs a ERC20 token transfer with a reference and a transfer to a second address for the payment of a fee
26     * @param _tokenAddress Address of the ERC20 token smart contract
27     * @param _to Transfer recipient
28     * @param _amount Amount to transfer
29     * @param _paymentReference Reference of the payment related
30     * @param _feeAmount The amount of the payment fee
31     * @param _feeAddress The fee recipient
32     */
33   function transferFromWithReferenceAndFee(
34     address _tokenAddress,
35     address _to,
36     uint256 _amount,
37     bytes calldata _paymentReference,
38     uint256 _feeAmount,
39     address _feeAddress
40     ) external
41     {
42     require(safeTransferFrom(_tokenAddress, _to, _amount), "payment transferFrom() failed");
43     if (_feeAmount > 0 && _feeAddress != address(0)) {
44       require(safeTransferFrom(_tokenAddress, _feeAddress, _feeAmount), "fee transferFrom() failed");
45     }
46     emit TransferWithReferenceAndFee(
47       _tokenAddress,
48       _to,
49       _amount,
50       _paymentReference,
51       _feeAmount,
52       _feeAddress
53     );
54   }
55 
56   /**
57    * @notice Call transferFrom ERC20 function and validates the return data of a ERC20 contract call.
58    * @dev This is necessary because of non-standard ERC20 tokens that don't have a return value.
59    * @return The return value of the ERC20 call, returning true for non-standard tokens
60    */
61   function safeTransferFrom(address _tokenAddress, address _to, uint256 _amount) internal returns (bool result) {
62     /* solium-disable security/no-inline-assembly */
63     // check if the address is a contract
64     assembly {
65       if iszero(extcodesize(_tokenAddress)) { revert(0, 0) }
66     }
67     
68     // solium-disable-next-line security/no-low-level-calls
69     (bool success, ) = _tokenAddress.call(abi.encodeWithSignature(
70       "transferFrom(address,address,uint256)",
71       msg.sender,
72       _to,
73       _amount
74     ));
75 
76     assembly {
77         switch returndatasize()
78         case 0 { // not a standard erc20
79             result := 1
80         }
81         case 32 { // standard erc20
82             returndatacopy(0, 0, 32)
83             result := mload(0)
84         }
85         default { // anything else, should revert for safety
86             revert(0, 0)
87         }
88     }
89 
90     require(success, "transferFrom() has been reverted");
91 
92     /* solium-enable security/no-inline-assembly */
93     return result;
94   }
95 }