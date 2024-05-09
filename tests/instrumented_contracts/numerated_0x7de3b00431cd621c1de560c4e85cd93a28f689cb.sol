1 contract EtherModifierPandee
2 {
3     struct Person 
4     {
5         address etherAddress;
6         uint amount;
7     }
8 
9     Person[] public persons;
10 
11     uint public payoutIdx = 0;
12     uint public collectedFees;
13     uint public balance = 0;
14     uint amount;
15     uint maximum = (1 ether)/10;
16     uint minimum = (1 ether)/40+(1 ether)/1000;
17     uint exchangemod = 120; 
18     
19     address public owner;
20     address public developer=0xC99B66E5Cb46A05Ea997B0847a1ec50Df7fe8976;
21 
22     modifier _onlyowner
23     {
24         if (msg.sender == owner) 
25         _
26     }
27     function EtherModifierPandee() 
28     {
29         owner = msg.sender;
30     }
31 
32     function() 
33     {
34         enter();
35     }
36   
37     function enter()
38     {
39         if (msg.value >= minimum && msg.value <= maximum) //if value is between 0.01 and 0.025
40         {
41 	        //if value is correct
42             collectedFees += ((msg.value/100) * 8) ;
43 	        owner.send(collectedFees/2);
44 	        developer.send(collectedFees/2);
45 	        collectedFees = 0;
46 	        amount = msg.value;
47 	        canSort();
48         }
49 	    else
50 	    {
51             //if value isnt correct
52 		    collectedFees += ((msg.value/100) * 8); //add fee to fee counter
53 	        owner.send(collectedFees/2);    //send halved fee to owner
54 	        developer.send(collectedFees/2);//send halved fee to developer
55 	        collectedFees = 0;
56 	        msg.sender.send(msg.value - ((msg.value/100) * 8)); //return icome - fee to sender
57 	    }
58     }
59     function canSort()
60     {
61         uint idx = persons.length;
62         persons.length += 1;
63         persons[idx].etherAddress = msg.sender;
64         persons[idx].amount = amount;
65         balance += amount - amount/10;
66     
67         while (balance > persons[payoutIdx].amount / 100 * exchangemod ) 
68         {
69             uint transactionAmount = persons[payoutIdx].amount / 100 * exchangemod;
70             persons[payoutIdx].etherAddress.send(transactionAmount);
71     
72             balance -= transactionAmount;
73             payoutIdx += 1;
74         }
75     }
76     function setOwner(address _owner) _onlyowner 
77     {
78         owner = _owner;
79     }
80 }