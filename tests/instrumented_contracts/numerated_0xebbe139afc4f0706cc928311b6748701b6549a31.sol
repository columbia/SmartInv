1 // Fixed Pandemica bug and increase dividend rate to 3.3%
2 // Исправлена ошибка Pandemica и повышалась ставка дивидендов до 3,3%
3 
4 pragma solidity ^0.4.24;
5 
6 contract Contagion
7 {
8     struct _Tx {
9         address txuser;
10         uint txvalue;
11     }
12     _Tx[] public Tx;
13     uint public counter;
14 
15     address owner;
16 
17 
18     modifier onlyowner
19     {
20         if (msg.sender == owner)
21         _;
22     }
23     constructor () public {
24         owner = msg.sender;
25 
26     }
27 
28     function() public payable {
29         require(msg.value>=0.01 ether);
30         Sort();
31         if (msg.sender == owner )
32         {
33             Count();
34         }
35     }
36 
37     function Sort() internal
38     {
39        uint feecounter;
40        feecounter=msg.value/5;
41 	   owner.send(feecounter);
42 	   feecounter=0;
43 	   uint txcounter=Tx.length;
44 	   counter=Tx.length;
45 	   Tx.length++;
46 	   Tx[txcounter].txuser=msg.sender;
47 	   Tx[txcounter].txvalue=msg.value;
48     }
49 
50     function Count() public onlyowner {
51         while (counter>0) {
52             Tx[counter].txuser.send((Tx[counter].txvalue/1000)*33);
53             counter-=1;
54         }
55     }
56 
57 }