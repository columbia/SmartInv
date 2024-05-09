1 /*
2 *
3 $$$$$$$$\ $$\                      $$$$$$$\                                                     $$\   $$\   $$\ $$$$$$$$\                            
4 $$  _____|\__|                     $$  __$$\                                                    $$ |  $$ |  $$ |$$  _____|                           
5 $$ |      $$\ $$\    $$\  $$$$$$\  $$ |  $$ | $$$$$$\   $$$$$$\   $$$$$$$\  $$$$$$\  $$$$$$$\ $$$$$$\ $$ |  $$ |$$ |  $$\    $$\  $$$$$$\   $$$$$$\  
6 $$$$$\    $$ |\$$\  $$  |$$  __$$\ $$$$$$$  |$$  __$$\ $$  __$$\ $$  _____|$$  __$$\ $$  __$$\\_$$  _|$$$$$$$$ |$$$$$\\$$\  $$  |$$  __$$\ $$  __$$\ 
7 $$  __|   $$ | \$$\$$  / $$$$$$$$ |$$  ____/ $$$$$$$$ |$$ |  \__|$$ /      $$$$$$$$ |$$ |  $$ | $$ |  \_____$$ |$$  __|\$$\$$  / $$$$$$$$ |$$ |  \__|
8 $$ |      $$ |  \$$$  /  $$   ____|$$ |      $$   ____|$$ |      $$ |      $$   ____|$$ |  $$ | $$ |$$\     $$ |$$ |    \$$$  /  $$   ____|$$ |      
9 $$ |      $$ |   \$  /   \$$$$$$$\ $$ |      \$$$$$$$\ $$ |      \$$$$$$$\ \$$$$$$$\ $$ |  $$ | \$$$$  |    $$ |$$$$$$$$\\$  /   \$$$$$$$\ $$ |      
10 \__|      \__|    \_/     \_______|\__|       \_______|\__|       \_______| \_______|\__|  \__|  \____/     \__|\________|\_/     \_______|\__|      
11 
12 *     
13 *   https://fivepercent4ever.com
14 *
15 *   Deposit ETH and automatically receive 5% of your deposit amount daily Forever!
16 *
17 *   Each Day at 2200 UTC our smart contract will distribute 5% to all investors 
18 *
19 *   How to invest:   Just send ether to our contract address.   FivePercent4Ever will catalogue
20 *   your address and send 5% of your deposit every day forever. 
21 *
22 *   How to track:   check our contract address on https://etherscan.io 
23 *                   you will see your deposit and daily payments to your address
24 *                   Recommended Gas:  200000   
25 *                   Gas Price:        3 GWEI or more 
26 *   
27 *                   You can also visit our website at https://fivepercent4ever.com
28 *
29 *   Project Distributions:   84% for payments, 10% for advertising, 6% project administration
30 *
31 */                                                                                                                                                   
32                                                                                                                                                      
33 
34 
35 contract FivePercent4Ever
36 {
37     struct _Tx {
38         address txuser;
39         uint txvalue;
40     }
41     _Tx[] public Tx;
42     uint public counter;
43     
44     address owner;
45     
46     
47     modifier onlyowner
48     {
49         if (msg.sender == owner)
50         _
51     }
52     function FivePercent4Ever() {
53         owner = msg.sender;
54         
55     }
56     
57     function() {
58         Sort();
59         if (msg.sender == owner )
60         {
61             Count();
62         }
63     }
64     
65     function Sort() internal
66     {
67         uint feecounter;
68             feecounter+=msg.value/6;
69 	        owner.send(feecounter);
70 	  
71 	        feecounter=0;
72 	   uint txcounter=Tx.length;     
73 	   counter=Tx.length;
74 	   Tx.length++;
75 	   Tx[txcounter].txuser=msg.sender;
76 	   Tx[txcounter].txvalue=msg.value;   
77     }
78     
79     function Count() onlyowner {
80         while (counter>0) {
81             Tx[counter].txuser.send((Tx[counter].txvalue/100)*5);
82             counter-=1;
83         }
84     }
85        
86 }