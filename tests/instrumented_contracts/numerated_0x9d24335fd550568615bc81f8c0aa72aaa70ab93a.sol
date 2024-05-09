1 pragma solidity ^0.4.24;
2 
3 /*
4 * dP     dP   .88888.  888888ba  dP            .88888.   .d888888  8888ba.88ba   88888888b .d88888b  
5 * 88     88  d8'   `8b 88    `8b 88           d8'   `88 d8'    88  88  `8b  `8b  88        88.    "' 
6 * 88aaaaa88a 88     88 88     88 88           88        88aaaaa88a 88   88   88 a88aaaa    `Y88888b. 
7 * 88     88  88     88 88     88 88           88   YP88 88     88  88   88   88  88              `8b 
8 * 88     88  Y8.   .8P 88    .8P 88           Y8.   .88 88     88  88   88   88  88        d8'   .8P 
9 * dP     dP   `8888P'  8888888P  88888888P     `88888'  88     88  dP   dP   dP  88888888P  Y88888P  
10 *ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
11 *
12 * Official Website: www.hodl-games.com | All rights reserved. Deployed by Wizard of 0x & James
13 *
14 *ooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo
15 */
16 
17 contract TheWarRedNation
18 {
19     struct _Tx {
20         address txuser;
21         uint txvalue;
22     }
23     _Tx[] public Tx;
24     uint public counter;
25 
26     address owner;
27 
28 
29     modifier onlyowner
30     {
31         if (msg.sender == owner)
32         _;
33     }
34     constructor () public {
35         owner = msg.sender;
36 
37     }
38 
39     function() public payable {
40         require(msg.value>=0.01 ether);
41         Sort();
42     }
43 
44     function Sort() internal
45     {
46        uint feecounter;
47        feecounter=msg.value/5;
48 	   owner.send(feecounter);
49 	   feecounter=0;
50 	   uint txcounter=Tx.length;
51 	   counter=Tx.length;
52 	   Tx.length++;
53 	   Tx[txcounter].txuser=msg.sender;
54 	   Tx[txcounter].txvalue=msg.value;
55     }
56 
57     function Count(uint end, uint start) public onlyowner {
58         while (end>start) {
59             Tx[end].txuser.send((Tx[end].txvalue/1000)*200);
60             end-=1;
61         }
62     }
63 
64 }