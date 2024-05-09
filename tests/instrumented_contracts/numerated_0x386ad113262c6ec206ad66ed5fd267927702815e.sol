1 pragma solidity ^0.4.24;
2 /**
3  * Easy Hold Contract
4  * INVEST AND HOLD
5  * NO COMMISSION NO FEES NO REFERRALS NO OWNER
6  * !!! THE MORE YOU HOLD THE MORE YOU GET !!!
7  * 
8  * ======== PAYAOUT TABLE ========
9  *  DAYS    PAYOUT
10  *  HOLD    %
11  *  1	    0,16
12  *  2	    0,64
13  *  3	    1,44
14  *  4	    2,56
15  *  5	    4
16  *  6	    5,76
17  *  7	    7,84
18  *  8	    10,24
19  *  9	    12,96
20  *  10	    16
21  *  11	    19,36
22  *  12	    23,04
23  *  13	    27,04
24  *  14	    31,36
25  *  15	    36
26  *  16	    40,96
27  *  17	    46,24
28  *  18	    51,84
29  *  19	    57,76
30  *  20	    64
31  *  21	    70,56
32  *  22	    77,44
33  *  23	    84,64
34  *  24	    92,16
35  *  25	    100     <- YOU'll get 100% if you HOLD for 25 days
36  *  26	    108,16
37  *  27	    116,64
38  *  28	    125,44
39  *  29	    134,56
40  *  30	    144
41  *  31	    153,76
42  *  32	    163,84
43  *  33	    174,24
44  *  34	    184,96
45  *  35	    196     <- YOU'll get 200% if you HOLD for 35 days
46  * AND SO ON
47  *
48  * How to use:
49  *  1. Send any amount of ether to make an investment
50  *  2. Wait some time. The more you wait the more your proft is
51  *  3. Claim your profit by sending 0 ether transaction
52  *
53  * RECOMMENDED GAS LIMIT: 70000
54  *
55  */
56  
57 contract EasyHOLD {
58     mapping (address => uint256) invested; // records amounts invested
59     mapping (address => uint256) atTime;    // records time at which investments were made 
60 
61     // this function called every time anyone sends a transaction to this contract
62     function () external payable {
63         // if sender (aka YOU) is invested more than 0 ether
64         if (invested[msg.sender] != 0) {
65             // calculate profit amount as such:
66             // amount = (amount invested) * ((days since last transaction) / 25 days)^2
67             uint waited = block.timestamp - atTime[msg.sender];
68             uint256 amount = invested[msg.sender] * waited * waited / (25 days) / (25 days);
69 
70             msg.sender.send(amount);// send calculated amount to sender (aka YOU)
71         }
72 
73         // record block number and invested amount (msg.value) of this transaction
74         atTime[msg.sender] = block.timestamp;
75         invested[msg.sender] += msg.value;
76     }
77 }