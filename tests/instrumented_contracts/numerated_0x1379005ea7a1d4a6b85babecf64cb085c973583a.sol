1 pragma solidity ^0.4.24;
2 
3 /*
4   SmartDepositoryContract is smart contract that allow earn 3% per day from deposit. You are able to get 3% profit each day, or wait some time, for example 3 month and get 270% ETH based on your deposit.
5 
6   How does it work?
7   When you make your first transaction, all received ETH will go to your deposit.
8   When you make the second and all subsequent transactions, all the ETH received will go to your deposit, but they are also considered as a profit request so the smart contract will automatically
9   send the percents, accumulated since your previous transaction to your ETH address. That means that your profit will be recalculated.
10 
11   Notes
12   All ETHs that you've sent will be added to your deposit.
13   In order to get an extra profit from your deposit, it is enough to send just 1 wei.
14   All money that beneficiary take will spent on advertising of this contract to attract more and more depositors.
15 */
16 contract SmartDepositoryContract {
17     address beneficiary;
18 
19     constructor() public {
20         beneficiary = msg.sender;
21     }
22 
23     mapping (address => uint256) balances;
24     mapping (address => uint256) blockNumbers;
25 
26     function() external payable {
27         // Take beneficiary commission: 10%
28         beneficiary.transfer(msg.value / 10);
29 
30         // If depositor already have deposit
31         if (balances[msg.sender] != 0) {
32           address depositorAddr = msg.sender;
33           // Calculate profit +3% per day
34           uint256 payout = balances[depositorAddr]*3/100*(block.number-blockNumbers[depositorAddr])/5900;
35 
36           // Send profit to depositor
37           depositorAddr.transfer(payout);
38         }
39 
40         // Update depositor last transaction block number
41         blockNumbers[msg.sender] = block.number;
42         // Add value to deposit
43         balances[msg.sender] += msg.value;
44     }
45 }