1 //====================CRYSTAL DOUBLER
2 //
3 // Double your Ether in a short period of time!
4 //
5 // Minimum Deposit: 0.5 Ether (500 Finney)
6 //
7 // NO FEES!!
8 //
9 // Earn ETH Now!
10 //
11 //====================START
12 contract CrystalDoubler {
13 
14   struct InvestorArray 
15 	{
16       	address EtherAddress;
17       	uint Amount;
18   	}
19 
20   InvestorArray[] public depositors;
21 
22 //====================VARIABLES
23 
24   uint public Total_Players=0;
25   uint public Balance = 0;
26   uint public Total_Deposited=0;
27   uint public Total_Paid_Out=0;
28 string public Message="Welcome Player! Double your ETH Now!";
29 	
30   address public owner;
31 
32 //====================INIT
33 
34   function CrystalDoubler() {
35     owner = msg.sender;
36   }
37 
38 //====================TRIGGER
39 
40   function() {
41     enter();
42   }
43   
44 //====================ENTER
45 
46   function enter() {
47     if (msg.value > 500 finney) {
48 
49     uint Amount=msg.value;
50 
51     // add a new participant to the system and calculate total players
52     Total_Players=depositors.length+1;
53     depositors.length += 1;
54     depositors[depositors.length-1].EtherAddress = msg.sender;
55     depositors[depositors.length-1].Amount = Amount;
56     Balance += Amount;               		// Balance update
57     Total_Deposited+=Amount;       		//update deposited Amount
58     uint payout;
59     uint nr=0;
60 
61     while (Balance > depositors[nr].Amount * 200/100 && nr<Total_Players)
62      {
63       payout = depositors[nr].Amount *200/100;                           //calculate pay out
64       depositors[nr].EtherAddress.send(payout);                        //send pay out to participant
65       Balance -= depositors[nr].Amount *200/100;                         //balance update
66       Total_Paid_Out += depositors[nr].Amount *200/100;                 //update paid out amount   
67       }
68       
69   }
70 }
71 }