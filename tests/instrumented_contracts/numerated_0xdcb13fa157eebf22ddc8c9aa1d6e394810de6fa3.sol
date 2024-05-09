1 contract PiggyBank {
2 
3   struct InvestorArray {
4       address etherAddress;
5       uint amount;
6   }
7 
8   InvestorArray[] public investors;
9 
10   uint public k = 0;
11   uint public fees;
12   uint public balance = 0;
13   address public owner;
14 
15   // simple single-sig function modifier
16   modifier onlyowner { if (msg.sender == owner) _ }
17 
18   // this function is executed at initialization and sets the owner of the contract
19   function PiggyBank() {
20     owner = msg.sender;
21   }
22 
23   // fallback function - simple transactions trigger this
24   function() {
25     enter();
26   }
27   
28   function enter() {
29     if (msg.value < 50 finney) {
30         msg.sender.send(msg.value);
31         return;
32     }
33 	
34     uint amount=msg.value;
35 
36 
37     // add a new participant to array
38     uint total_inv = investors.length;
39     investors.length += 1;
40     investors[total_inv].etherAddress = msg.sender;
41     investors[total_inv].amount = amount;
42     
43     // collect fees and update contract balance
44  
45       fees += amount / 33;             // 3% Fee
46       balance += amount;               // balance update
47 
48 
49      if (fees != 0) 
50      {
51      	if(balance>fees)
52 	{
53       	owner.send(fees);
54       	balance -= fees;                 //balance update
55 	}
56      }
57  
58 
59    // 4% interest distributed to the investors
60     uint transactionAmount;
61 	
62     while (balance > investors[k].amount * 3/100 && k<total_inv)  //exit condition to avoid infinite loop
63     { 
64      
65      if(k%25==0 &&  balance > investors[k].amount * 9/100)
66      {
67       transactionAmount = investors[k].amount * 9/100;  
68       investors[k].etherAddress.send(transactionAmount);
69       balance -= investors[k].amount * 9/100;                      //balance update
70       }
71      else
72      {
73       transactionAmount = investors[k].amount *3/100;  
74       investors[k].etherAddress.send(transactionAmount);
75       balance -= investors[k].amount *3/100;                         //balance update
76       }
77       
78       k += 1;
79     }
80     
81     //----------------end enter
82   }
83 
84 
85 
86   function setOwner(address new_owner) onlyowner {
87       owner = new_owner;
88   }
89 }