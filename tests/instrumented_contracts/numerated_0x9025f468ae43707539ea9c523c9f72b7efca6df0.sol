1 /*
2  * Project RESERVED
3  * Here you can see the code with comments
4  * Enjoy :)
5  **/
6 pragma solidity ^0.4.24;
7 contract RESERVED {
8    
9     address owner; //address of contract creator
10     address investor; //address of user who just invested money to the contract
11     mapping (address => uint256) balances; //amount of investment for each address
12     mapping (address => uint256) timestamp; //time from the last payment for each address
13     mapping (address => uint16) rate; //rate for each address 
14     mapping (address => uint256) referrers; //structure for checking whether investor had referrer or not
15     uint16 default_rate = 300; //default rate (minimal rate) for investors
16     uint16 max_rate = 1000; //maximal possible rate
17     uint256 eth = 1000000000000000000; //eth in wei
18     uint256 jackpot = 0; //amount of jackpot
19     uint256 random_number; //random number from 1 to 100
20     uint256 referrer_bonus; //amount of referrer bonus
21     uint256 deposit; //amount of investment
22     uint256 day = 86400; //seconds in 24 hours
23     bytes msg_data; //referrer address
24     
25     //Store owner as a person created that contract
26     constructor() public { owner = msg.sender;}
27     
28     //Function calls in the moment of investment
29     function() external payable{
30         
31         deposit = msg.value; //amount of investment
32         
33         investor = msg.sender; //address of investor
34         
35         msg_data = bytes(msg.data); //address of referrer
36         
37         owner.transfer(deposit / 10); //transfers 10% to the advertisement fund
38         
39         tryToWin(); //jackpot
40         
41         sendPayment(); //sends payment to investors
42         
43         updateRate(); //updates rates of investors depending on amount of investment
44         
45         upgradeReferrer(); //sends bonus to referrers and upgrates their rates, also increases the rate of referral
46         
47         
48     }
49     
50     //Collects jackpot and sends it to lucky investor
51     function tryToWin() internal{
52         random_number = uint(blockhash(block.number-1))%100 + 1;
53         if (deposit >= (eth / 10) && random_number<(deposit/(eth / 10) + 1) && jackpot>0) {
54             investor.transfer(jackpot);
55             jackpot = deposit / 20;
56         }
57         else jackpot += deposit / 20;
58     }
59     
60     //Sends payment to investor
61     function sendPayment() internal{
62         if (balances[investor] != 0){
63             uint256 paymentAmount = balances[investor]*rate[investor]/10000*(now-timestamp[investor])/day;
64             investor.transfer(paymentAmount);
65         }
66         timestamp[investor] = now;
67         balances[investor] += deposit;
68     }
69     
70     //Assigns a rate depending on the amount of the deposit
71     function updateRate() internal{
72         require (balances[investor]>0);
73         if (balances[investor]>=(10*eth) && rate[investor]<default_rate+75){
74                     rate[investor]=default_rate+75;
75                 }
76                 else if (balances[investor]>=(5*eth) && rate[investor]<default_rate+50){
77                         rate[investor]=default_rate+50;
78                     }
79                     else if (balances[investor]>=eth && rate[investor]<default_rate+25){
80                             rate[investor]=default_rate+25;
81                         }
82                         else if (rate[investor]<default_rate){
83                                 rate[investor]=default_rate;
84                             }
85     }
86     
87     //Sends bonus to referrers and upgrates their rates, also increases the rate of referral
88     function upgradeReferrer() internal{
89         if(msg_data.length == 20 && referrers[investor] == 0) {
90             address referrer = bytesToAddress(msg_data);
91             if(referrer != investor && balances[referrer]>0){
92                 referrers[investor] = 1;
93                 rate[investor] += 50; 
94                 referrer_bonus = deposit * rate[referrer] / 10000;
95                 referrer.transfer(referrer_bonus); 
96                 if(rate[referrer]<max_rate){
97                     if (deposit >= 10*eth){
98                         rate[referrer] = rate[referrer] + 100;
99                     }
100                     else if (deposit >= 3*eth){
101                             rate[referrer] = rate[referrer] + 50;
102                         }
103                         else if (deposit >= eth / 2){
104                                 rate[referrer] = rate[referrer] + 25;
105                             }
106                             else if (deposit >= eth / 10){
107                                     rate[referrer] = rate[referrer] + 10;
108                                 }
109                 }
110             }
111         }    
112         referrers[investor] = 1; //Protection from the writing referrer address with the next investment
113     }
114     
115     //Transmits bytes to address
116     function bytesToAddress(bytes source) internal pure returns(address) {
117         uint result;
118         uint mul = 1;
119         for(uint i = 20; i > 0; i--) {
120             result += uint8(source[i-1])*mul;
121             mul = mul*256;
122         }
123         return address(result);
124     }
125     
126 }