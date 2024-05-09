1 pragma solidity ^0.4.25;
2 
3 contract FairExchange {
4     function buy(address _referredBy) public payable returns(uint256);
5     function exit() public;
6 }
7 
8 contract FairProfit {
9     FairExchange fairContract = FairExchange(0xdE2b11b71AD892Ac3e47ce99D107788d65fE764e);
10     
11     /// @notice Any funds sent here are for dividend payment.
12     function () public payable {
13     }
14     
15     /// @notice Distribute dividends to the FairExchange contract. Can be called
16     ///     repeatedly until practically all dividends have been distributed.
17     /// @param rounds How many rounds of dividend distribution do we want?
18     function distribute(uint256 rounds) external {
19         for (uint256 i = 0; i < rounds; i++) {
20             if (address(this).balance < 0.001 ether) {
21                 // Balance is very low. Not worth the gas to distribute.
22                 break;
23             }
24             
25             fairContract.buy.value(address(this).balance)(0x0);
26             fairContract.exit();
27         }
28     }
29 }