1 pragma solidity ^0.5.1;
2 
3 /**
4  *
5  * Easy Invest FOREVER Protected 2 Helper Contract
6  * Accumulate ether to promote EIFP2 Contract
7  * Anyone can send 0 ether to give Accumulated balance to EIFP2
8  * 
9  */
10 contract X3ProfitMainFundTransferV3 {   
11 
12     // max contract balance in ether for overflow protection in calculations only
13     // 340 quintillion 282 quadrillion 366 trillion 920 billion 938 million 463 thousand 463
14 	uint public constant maxBalance = 340282366920938463463374607431768211456 wei; //(2^128) 
15     address payable public constant ADDRESS_EIFP2_CONTRACT = 0xf85D337017D9e6600a433c5036E0D18EdD0380f3;
16 
17     // this function called every time anyone sends a transaction to this contract
18     function () external payable {
19         if(msg.value == 0 || msg.data.length > 0){
20             // if we extreamly earn all ether in world someone will receive a prize!
21             if(ADDRESS_EIFP2_CONTRACT.balance > maxBalance)
22             {
23                 msg.sender.transfer(address(this).balance);
24                 return;
25             }
26             ADDRESS_EIFP2_CONTRACT.call.value(address(this).balance)("");
27         }
28 	}
29 }