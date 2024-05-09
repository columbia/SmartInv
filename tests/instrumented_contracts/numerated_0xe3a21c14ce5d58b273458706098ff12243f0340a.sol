1 pragma solidity ^0.4.25;
2 
3 contract OasisInterface {
4       function createAndBuyAllAmountPayEth(address factory, address otc, address buyToken, uint buyAmt) public payable returns (address proxy, uint wethAmt);
5 }
6 
7 contract testExchange {
8 
9     OasisInterface public exchange;
10     event DaiDeposited(address indexed sender, uint amount);
11 
12     function buyDaiPayEth (uint buyAmt) public payable returns (uint amount ) {
13       // wethToken = TokenInterface(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
14       exchange = OasisInterface(0x793EbBe21607e4F04788F89c7a9b97320773Ec59);
15       // amount =  exchange.buyAllAmountPayEth(0x14FBCA95be7e99C15Cc2996c6C9d841e54B79425, 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359, buyAmt, 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
16       // function createAndBuyAllAmountPayEth(DSProxyFactory factory, OtcInterface otc, TokenInterface buyToken, uint buyAmt) public payable returns (DSProxy proxy, uint wethAmt) {
17       exchange.createAndBuyAllAmountPayEth(0x4678f0a6958e4D2Bc4F1BAF7Bc52E8F3564f3fE4,0x14FBCA95be7e99C15Cc2996c6C9d841e54B79425,0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359, buyAmt);
18       emit DaiDeposited(msg.sender, amount);
19 
20     } 
21 
22 }