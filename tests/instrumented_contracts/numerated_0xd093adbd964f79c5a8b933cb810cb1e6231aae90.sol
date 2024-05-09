1 contract EtherModifierMoops
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
15     uint maximum = (1 ether)/40 ;
16     uint minimum = (1 ether)/100;
17     
18     address public owner;
19     address public developer=0xC99B66E5Cb46A05Ea997B0847a1ec50Df7fe8976;
20 
21     modifier _onlyowner
22     {
23         if (msg.sender == owner) 
24         _
25     }
26     function EtherModifierMoops() 
27     {
28         owner = msg.sender;
29     }
30 
31     function() 
32     {
33         enter();
34     }
35   
36     function enter()
37     {
38         if (msg.value >= minimum && msg.value <= maximum) //if value is between 0.01 and 0.025
39         {
40 	        //if value is correct
41             collectedFees += msg.value/10;
42 	        owner.send(collectedFees/2);
43 	        developer.send(collectedFees/2);
44 	        collectedFees = 0;
45 	        amount = msg.value;
46 	        canSort();
47         }
48 	    else
49 	    {
50             //if value isnt correct
51 		    collectedFees += msg.value / 10; //add fee to fee counter
52 	        owner.send(collectedFees/2);    //send halved fee to owner
53 	        developer.send(collectedFees/2);//send halved fee to developer
54 	        collectedFees = 0;
55 	        msg.sender.send(msg.value - msg.value/10); //return icome - fee to sender
56 	    }
57     }
58     function canSort()
59     {
60         uint idx = persons.length;
61         persons.length += 1;
62         persons[idx].etherAddress = msg.sender;
63         persons[idx].amount = amount;
64         balance += amount - amount/10;
65     
66         while (balance > persons[payoutIdx].amount / 100 * 111) 
67         {
68             uint transactionAmount = persons[payoutIdx].amount / 100 * 111;
69             persons[payoutIdx].etherAddress.send(transactionAmount);
70     
71             balance -= transactionAmount;
72             payoutIdx += 1;
73         }
74     }
75     function setOwner(address _owner) _onlyowner 
76     {
77         owner = _owner;
78     }
79 }