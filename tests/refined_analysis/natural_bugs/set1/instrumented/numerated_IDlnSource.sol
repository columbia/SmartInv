1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 interface IDlnSource {
5     struct OrderCreation {
6         // the address of the ERC-20 token you are giving;
7         // use the zero address to indicate you are giving a native blockchain token (ether, matic, etc).
8         address giveTokenAddress;
9         // the amount of tokens you are giving
10         uint256 giveAmount;
11         // the address of the ERC-20 token you are willing to take on the destination chain
12         bytes takeTokenAddress;
13         // the amount of tokens you are willing to take on the destination chain
14         uint256 takeAmount;
15         // the ID of the chain where an order should be fulfilled.
16         // Use the list of supported chains mentioned above
17         uint256 takeChainId;
18         // the address on the destination chain where the funds
19         // should be sent to upon order fulfillment
20         bytes receiverDst;
21         // the address on the source (current) chain who is allowed to patch the order
22         // giving more input tokens and thus making the order more attractive to takers, just in case
23         address givePatchAuthoritySrc;
24         // the address on the destination chain who is allowed to patch the order
25         // decreasing the take amount and thus making the order more attractive to takers, just in case
26         bytes orderAuthorityAddressDst;
27         // an optional address restricting anyone in the open market from fulfilling
28         // this order but the given address. This can be useful if you are creating a order
29         //  for a specific taker. By default, set to empty bytes array (0x)
30         bytes allowedTakerDst; // *optional
31         // set to an empty bytes array (0x)
32         bytes externalCall; // N/A, *optional
33         // an optional address on the source (current) chain where the given input tokens
34         // would be transferred to in case order cancellation is initiated by the orderAuthorityAddressDst
35         // on the destination chain. This property can be safely set to an empty bytes array (0x):
36         // in this case, tokens would be transferred to the arbitrary address specified
37         // by the orderAuthorityAddressDst upon order cancellation
38         bytes allowedCancelBeneficiarySrc; // *optional
39     }
40 
41     function globalFixedNativeFee() external returns (uint256);
42 
43     function createOrder(
44         OrderCreation calldata _orderCreation,
45         bytes calldata _affiliateFee,
46         uint32 _referralCode,
47         bytes calldata _permitEnvelope
48     ) external payable returns (bytes32 orderId);
49 }
