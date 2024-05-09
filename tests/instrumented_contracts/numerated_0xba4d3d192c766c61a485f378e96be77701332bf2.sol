1 pragma solidity ^0.4.15;
2 
3 contract P4PDonationSplitter {
4     address public constant epicenter_works_addr = 0x883702a1b9B29119acBaaa0E7E0a2997FB8EBcd3;
5     address public constant max_schrems_addr = 0x9abd6265Eaca022c1ccF931a7E9150dA0E7Db7Ec;
6 
7     /** Empty fallback function in order to allow receiving Ether
8     Since internal send() (as used by P4PPool) has a budget of only 2300 gas -
9     which is not enough to do anything useful - nothing is done here.
10     */
11     function () payable public {}
12 
13     /** Payout function
14     Splits the funds currently hold by the contract between the two receivers.
15     No access restriction to this function needed.
16     The "payable" attribute is not needed, but doesn't harm -
17     it allows to make additional donations in a single transaction.
18     */
19     function payout() payable public {
20         var share = this.balance / 2;
21         epicenter_works_addr.transfer(share);
22         max_schrems_addr.transfer(share);
23     }
24 }