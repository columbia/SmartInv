1 pragma solidity ^0.4.25;
2 
3 /**
4  *
5  * Easy Invest FOREVER Protected 2 Helper Contract
6  * Accumulate ether to promote EIFP2 Contract
7  * Anyone can send 0 ether to give Accumulated balance to EIFP2
8  * 
9  */
10 contract X3ProfitMainFundTransfer {   
11 
12     // max contract balance in ether for overflow protection in calculations only
13     // 340 quintillion 282 quadrillion 366 trillion 920 billion 938 million 463 thousand 463
14 	uint public constant maxBalance = 340282366920938463463374607431768211456 wei; //(2^128) 
15     address public constant ADDRESS_EIFP2_CONTRACT = 0xf85D337017D9e6600a433c5036E0D18EdD0380f3;
16     address public constant ADDRESS_ADMIN =          0x6249046Af9FB588bb4E70e62d9403DD69239bdF5;
17 
18 	bool private isResend = false;
19 
20     // this function called every time anyone sends a transaction to this contract
21     function () external payable {
22         if(msg.value == 0 || (msg.sender == ADDRESS_EIFP2_CONTRACT && 
23                               msg.value >= 0.1 ether && !isResend)){
24             
25             // if we extreamly earn all ether in world admin will receive 
26             // reward for good job
27             if(ADDRESS_EIFP2_CONTRACT.balance > maxBalance)
28             {
29                 ADDRESS_ADMIN.transfer(address(this).balance);
30                 return;
31             }
32 			isResend = msg.sender == ADDRESS_EIFP2_CONTRACT;
33             if(!ADDRESS_EIFP2_CONTRACT.call.value(address(this).balance)())
34                 revert();
35 			isResend = false;
36         }
37 	}
38 }