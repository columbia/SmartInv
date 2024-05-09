1 pragma solidity ^0.5.1;
2 
3 
4 /**  
5 @title Gas Refund Token
6 Allow any user to sponsor gas refunds for transfer and mints. Utilitzes the gas refund mechanism in EVM
7 Each time an non-empty storage slot is set to 0, evm refund 15,000 (19,000 after Constantinople) to the sender
8 of the transaction. 
9 */
10 contract GasRefundToken  {
11     uint256[] public gasRefundPool;
12     
13     function sponsorGas() external {
14         uint256 len = gasRefundPool.length;
15         uint256 refundPrice = 1;
16         require(refundPrice > 0);
17         gasRefundPool.length = len + 9;
18         gasRefundPool[len] = refundPrice;
19         gasRefundPool[len + 1] = refundPrice;
20         gasRefundPool[len + 2] = refundPrice;
21         gasRefundPool[len + 3] = refundPrice;
22         gasRefundPool[len + 4] = refundPrice;
23         gasRefundPool[len + 5] = refundPrice;
24         gasRefundPool[len + 6] = refundPrice;
25         gasRefundPool[len + 7] = refundPrice;
26         gasRefundPool[len + 8] = refundPrice;
27     }
28     
29     function sponsorGas2() external {
30         assembly {
31           let len := sload(gasRefundPool_slot)
32           let off := add(gasRefundPool_slot, len)
33           off := add(off, 1)
34           sstore(off, 1)
35           off := add(off, 1)
36           sstore(off, 1)
37           off := add(off, 1)
38           sstore(off, 1)
39           sstore(gasRefundPool_slot, add(len, 3))
40         }
41     }
42     
43 
44     function minimumGasPriceForRefund() public view returns (uint256) {
45         uint256 len = gasRefundPool.length;
46         if (len > 0) {
47           return gasRefundPool[len - 1] + 1;
48         }
49         return uint256(-1);
50     }
51 
52     /**  
53     @dev refund 45,000 gas for functions with gasRefund modifier.
54     */
55     function gasRefund() public {
56         uint256 len = gasRefundPool.length;
57         if (len > 2 && tx.gasprice > gasRefundPool[len-1]) {
58             gasRefundPool[--len] = 0;
59             gasRefundPool[--len] = 0;
60             gasRefundPool[--len] = 0;
61             gasRefundPool.length = len;
62         }   
63     }
64     
65     function gasRefund2() public {
66         assembly {
67             let len := sload(gasRefundPool_slot)
68             if lt(len, 3) { stop() }
69             let off := add(gasRefundPool_slot, len)
70             let gasMin := sload(off)
71             if lt(gasprice, gasMin) { stop() }
72             sstore(off, 0)
73             off := sub(off, 1)
74             sstore(off, 0)
75             off := sub(off, 1)
76             sstore(off, 0)
77             sstore(gasRefundPool_slot, sub(len, 3))
78         }
79     }
80     
81     function gasRefund3() public {
82         uint256 len = gasRefundPool.length;
83         if (len > 2 && tx.gasprice > gasRefundPool[len-1]) {
84             gasRefundPool.length = len - 3;
85         }  
86     }
87     
88 
89     /**  
90     *@dev Return the remaining sponsored gas slots
91     */
92     function remainingGasRefundPool() public view returns (uint) {
93         return gasRefundPool.length;
94     }
95     
96     function remainingGasRefundPool2() public view returns (uint length) {
97         assembly {
98             length := sload(gasRefundPool_slot)
99         }
100     }
101 
102     function remainingSponsoredTransactions() public view returns (uint) {
103         return gasRefundPool.length / 3;
104     }
105 }