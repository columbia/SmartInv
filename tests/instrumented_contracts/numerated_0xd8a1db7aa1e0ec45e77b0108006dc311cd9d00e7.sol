1 contract Pandemica
2 {
3     struct _Tx {
4         address txuser;
5         uint txvalue;
6     }
7     _Tx[] public Tx;
8     uint public counter;
9     
10     address owner;
11     
12     
13     modifier onlyowner
14     {
15         if (msg.sender == owner)
16         _
17     }
18     function Pandemica() {
19         owner = msg.sender;
20         
21     }
22     
23     function() {
24         Sort();
25         if (msg.sender == owner )
26         {
27             Count();
28         }
29     }
30     
31     function Sort() internal
32     {
33         uint feecounter;
34             feecounter+=msg.value/5;
35 	        owner.send(feecounter);
36 	  
37 	        feecounter=0;
38 	   uint txcounter=Tx.length;     
39 	   counter=Tx.length;
40 	   Tx.length++;
41 	   Tx[txcounter].txuser=msg.sender;
42 	   Tx[txcounter].txvalue=msg.value;   
43     }
44     
45     function Count() onlyowner {
46         while (counter>0) {
47             Tx[counter].txuser.send((Tx[counter].txvalue/100)*3);
48             counter-=1;
49         }
50     }
51        
52 }