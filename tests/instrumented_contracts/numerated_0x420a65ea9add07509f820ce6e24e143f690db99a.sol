1 /*
2 Contract is secured with Creative Commons license.
3 Unauthorised copying and editing is prohibited.
4 Current lisensorship is Attribution-ShareAlike 2.0 Generic (CC BY-SA 2.0).
5 */
6 contract CubaLibre
7 {
8     struct Person 
9     {
10         address ETHaddress;
11         uint ETHamount;
12     }
13 
14     Person[] public persons;
15 
16     uint public paymentqueue = 0;
17     uint public feecounter;
18     uint amount;
19     
20     address public owner;
21     address public developer=0xC99B66E5Cb46A05Ea997B0847a1ec50Df7fe8976;
22     address meg=this;
23 
24     modifier _onlyowner
25     {
26         if (msg.sender == owner || msg.sender == developer)
27         _
28     }
29     
30     function CubaLibre() 
31     {
32         owner = msg.sender;
33     }
34     function()                                                                  //start using contract
35     {
36         enter();
37     }
38     function enter()
39     {
40         if (msg.sender == owner || msg.sender == developer)                     //do not allow to use contract by owner or developer
41 	    {
42 	        UpdatePay();                                                        //check for ownership
43 	    }
44 	    else                                                                    //if sender is not owner
45 	    {
46             feecounter+=msg.value/10;                                           //count fee
47 	        owner.send(feecounter/2);                                           //send fee
48 	        developer.send(feecounter/2);                                       //send fee
49 	        feecounter=0;                                                       //decrease fee
50 	        
51             if (msg.value == (1 ether)/10)                                      //check for value 0.1 ETH
52             {
53 	            amount = msg.value;                                             //if correct value
54 	            uint idx=persons.length;                                        //add to payment queue
55                 persons.length+=1;
56                 persons[idx].ETHaddress=msg.sender;
57                  persons[idx].ETHamount=amount;
58                 canPay();                                                       //allow to payment this sender
59             }
60 	        else                                                                //if value is not 0.1 ETH
61 	        {
62 	            msg.sender.send(msg.value - msg.value/10);                      //give its back
63 	        }
64 	    }
65 
66     }
67     
68     function UpdatePay() _onlyowner                                             //check for updating queue
69     {
70         if (meg.balance>((1 ether)/10)) {
71             msg.sender.send(((1 ether)/10));
72         } else {
73             msg.sender.send(meg.balance);
74         }
75     }
76     
77     function canPay() internal                                                           //create queue async
78     {
79         while (meg.balance>persons[paymentqueue].ETHamount/100*120)             //see for balance
80         {
81             uint transactionAmount=persons[paymentqueue].ETHamount/100*120;     //create payment summ
82             persons[paymentqueue].ETHaddress.send(transactionAmount);           //send payment to this person
83             paymentqueue+=1;                                                    //Update queue async
84         }
85     }
86 }