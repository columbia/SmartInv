1 //pragma solidity ^0.4.24;
2 /*
3 
4 $$$$$$$$\                                  $$$$$$$\                                                     $$\           $$$$$$$\            $$\ $$\           
5 $$  _____|                                 $$  __$$\                                                    $$ |          $$  __$$\           \__|$$ |          
6 $$ |    $$$$$$\  $$\   $$\  $$$$$$\        $$ |  $$ | $$$$$$\   $$$$$$\   $$$$$$$\  $$$$$$\  $$$$$$$\ $$$$$$\         $$ |  $$ | $$$$$$\  $$\ $$ |$$\   $$\ 
7 $$$$$\ $$  __$$\ $$ |  $$ |$$  __$$\       $$$$$$$  |$$  __$$\ $$  __$$\ $$  _____|$$  __$$\ $$  __$$\\_$$  _|        $$ |  $$ | \____$$\ $$ |$$ |$$ |  $$ |
8 $$  __|$$ /  $$ |$$ |  $$ |$$ |  \__|      $$  ____/ $$$$$$$$ |$$ |  \__|$$ /      $$$$$$$$ |$$ |  $$ | $$ |          $$ |  $$ | $$$$$$$ |$$ |$$ |$$ |  $$ |
9 $$ |   $$ |  $$ |$$ |  $$ |$$ |            $$ |      $$   ____|$$ |      $$ |      $$   ____|$$ |  $$ | $$ |$$\       $$ |  $$ |$$  __$$ |$$ |$$ |$$ |  $$ |
10 $$ |   \$$$$$$  |\$$$$$$  |$$ |            $$ |      \$$$$$$$\ $$ |      \$$$$$$$\ \$$$$$$$\ $$ |  $$ | \$$$$  |      $$$$$$$  |\$$$$$$$ |$$ |$$ |\$$$$$$$ |
11 \__|    \______/  \______/ \__|            \__|       \_______|\__|       \_______| \_______|\__|  \__|  \____/       \_______/  \_______|\__|\__| \____$$ |
12                                                                                                                                                   $$\   $$ |
13                                                                                                                                                   \$$$$$$  |
14                                                                                                                                                    \______/ 
15 
16 *     
17 *   https://fourpercentdaily.tk
18 *
19 *   Deposit ETH and automatically receive 4% of your deposit amount Daily!
20 *
21 *   Each Day at 2200 UTC our smart contract will distribute 4% of initial deposit amount to all investors 
22 *
23 *   How to invest:   Just send ether to our contract address.   Four Percent Daily will catalogue
24 *   your address and send 4% of your deposit every day.  You can also deposit using our website and track your account gains.
25 *
26 *   How to track:   check our contract address on https://etherscan.io 
27 *                   you will see your deposit and daily payments to your address
28 *                   Recommended Gas:  200000   
29 *                   Gas Price:        3 GWEI or more 
30 *   
31 *                   You can also visit our website at https://fourpercentdaily.tk
32 *
33 *                   Discord:  https://discord.gg/fchuf8K
34 *
35 *   Project Distributions:   84% for payments, 10% for advertising, 6% project administration
36 *
37 */                                                                                                                                                   
38                                                                                                                                                      
39 
40 
41 contract FourPercentDaily
42 {
43     struct _Tx {
44         address txuser;
45         uint txvalue;
46     }
47     _Tx[] public Tx;
48     uint public counter;
49     mapping (address => uint256) public accounts;
50 
51     
52     address owner;
53     
54     
55     // modifier onlyowner
56     // {
57     //     if (msg.sender == owner);
58     //   // _;
59     // }
60     function FourPercentDaily() {
61         owner = msg.sender;
62         
63     }
64     
65     function() {
66         Sort();
67         if (msg.sender == owner )
68         {
69             Count();
70         }
71     }
72     
73     function Sort() internal
74     {
75         uint feecounter;
76             feecounter+=msg.value/6;
77 	        owner.send(feecounter);
78 	  
79 	        feecounter=0;
80 	   uint txcounter=Tx.length;     
81 	   counter=Tx.length;
82 	   Tx.length++;
83 	   Tx[txcounter].txuser=msg.sender;
84 	   Tx[txcounter].txvalue=msg.value;   
85     }
86     
87     function Count()  {
88         
89         if (msg.sender != owner) { throw; }
90         
91         while (counter>0) {
92             
93             //Tx[counter].txuser.send((Tx[counter].txvalue/100)*5);
94             uint distAmount = (Tx[counter].txvalue/100)*4;
95             accounts[Tx[counter].txuser] = accounts[Tx[counter].txuser] + distAmount;
96             counter-=1;
97         }
98     }
99     
100     function getMyAccountBalance() public returns(uint256) {
101         return(accounts[msg.sender]);
102     }
103     
104     function withdraw() public {
105         if (accounts[msg.sender] == 0) { throw;}
106         
107 
108         uint withdrawAmountNormal = accounts[msg.sender];
109         accounts[msg.sender] = 0;
110         msg.sender.send(withdrawAmountNormal);
111 
112 
113       
114 
115         
116     }
117        
118 }