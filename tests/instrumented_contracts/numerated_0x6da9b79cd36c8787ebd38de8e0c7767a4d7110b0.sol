1 pragma solidity ^0.4.23;
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
29 
30     function minimumGasPriceForRefund() public view returns (uint256) {
31         uint256 len = gasRefundPool.length;
32         if (len > 0) {
33           return gasRefundPool[len - 1] + 1;
34         }
35         return uint256(-1);
36     }
37 
38     /**  
39     @dev refund 45,000 gas for functions with gasRefund modifier.
40     */
41     function gasRefund() public {
42         uint256 len = gasRefundPool.length;
43         if (len > 2 && tx.gasprice > gasRefundPool[len-1]) {
44             gasRefundPool[--len] = 0;
45             gasRefundPool[--len] = 0;
46             gasRefundPool[--len] = 0;
47             gasRefundPool.length = len;
48         }   
49     }
50     
51 
52     /**  
53     *@dev Return the remaining sponsored gas slots
54     */
55     function remainingGasRefundPool() public view returns (uint) {
56         return gasRefundPool.length;
57     }
58 
59     function remainingSponsoredTransactions() public view returns (uint) {
60         return gasRefundPool.length / 3;
61     }
62 }