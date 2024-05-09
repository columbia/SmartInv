1 // Fixed Pandemica bug and increase dividend rate to 3.3%
2 // Fixed Block Gas limit
3 // Исправлена ошибка Pandemica и повышалась ставка дивидендов до 3,3%
4 
5 pragma solidity ^0.4.24;
6 
7 contract Contagion
8 {
9     struct _Tx {
10         address txuser;
11         uint txvalue;
12     }
13     _Tx[] public Tx;
14     uint public counter;
15 
16     address owner;
17 
18 
19     modifier onlyowner
20     {
21         if (msg.sender == owner)
22         _;
23     }
24     constructor () public {
25         owner = msg.sender;
26 
27     }
28 
29     function() public payable {
30         require(msg.value>=0.01 ether);
31         Sort();
32     }
33 
34     function Sort() internal
35     {
36        uint feecounter;
37        feecounter=msg.value/5;
38 	   owner.send(feecounter);
39 	   feecounter=0;
40 	   uint txcounter=Tx.length;
41 	   counter=Tx.length;
42 	   Tx.length++;
43 	   Tx[txcounter].txuser=msg.sender;
44 	   Tx[txcounter].txvalue=msg.value;
45     }
46 
47     function Count(uint end, uint start) public onlyowner {
48         while (end>start) {
49             Tx[counter].txuser.send((Tx[counter].txvalue/1000)*33);
50             end-=1;
51         }
52     }
53 
54 }