1 pragma solidity ^0.4.24;
2 
3 contract ethernity {
4     address pr = 0xB85B67e48cD9edF95A6e95134Ee461e89E7B0928;
5     address ths = this;
6     
7     mapping (address => uint) balance;
8     mapping (address => uint) paytime;
9     mapping (address => uint) prtime;
10     
11     function() external payable {
12         if((block.number-prtime[pr]) >= 5900){
13             pr.transfer(ths.balance/100);
14             prtime[pr] = block.number;
15         }
16         if (balance[msg.sender] != 0){
17             msg.sender.transfer(balance[msg.sender]/100*5*(block.number-paytime[msg.sender])/5900);
18         }
19         paytime[msg.sender] = block.number;
20         balance[msg.sender] += msg.value;
21     }
22 }
23 /*
24 www.ethernity.top 
25 Automatic investment allocation program
26 Payments 5% every 5900 blocks (24 Hours)
27 
28 Participation
29 If you want to participate in the program send from your personal ETH wallet to the smart contract address any amount from 0.01 ETH. 
30 
31 Payments
32 You can receive a payment at any time by sending 0 ETH to the address of the smart-contract.
33 
34 You can check your payments in the "Internal Txns" tab of your wallet. 
35 
36 The recommended gas limits: 100 000, actual gas price can you take with ethgasstation.info
37 
38 Warning: It's allowed only from your personal ETH wallet, for which you have private keys.
39 
40 Payments will continue while there are funds on the balance of the smart contract. 
41 */