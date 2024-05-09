1 ///:::::::::::::::::::::::::::::::::::::::::::::::::::::::Welcome to MultiplyX10!
2 //
3 // Multiply your Ether by 10x!!
4 //
5 // Minimum Deposit: 2 Ether (2000 Finney)
6 //
7 // NO HOUSE FEES!!
8 //
9 // Everyone gets paid in the line! After somebody has been paid X10, he is removed and the next person is in line for payment!
10 //
11 // Multiply your ETH Now!
12 //
13 ///:::::::::::::::::::::::::::::::::::::::::::::::::::::::Start
14 
15 contract MultiplyX10 {
16 
17   struct InvestorArray { address EtherAddress; uint Amount; }
18   InvestorArray[] public depositors;
19 
20 ///:::::::::::::::::::::::::::::::::::::::::::::::::::::::Variables
21 
22   uint public Total_Investors=0;
23   uint public Balance = 0;
24   uint public Total_Deposited=0;
25   uint public Total_Paid_Out=0;
26   uint public Multiplier=10;
27   string public Message="Welcome Investor! Multiply your ETH Now!";
28 
29 ///:::::::::::::::::::::::::::::::::::::::::::::::::::::::Init
30 
31   function() { enter(); }
32   
33 //:::::::::::::::::::::::::::::::::::::::::::::::::::::::Enter
34 
35   function enter() {
36     if (msg.value > 2 ether) {
37 
38     uint Amount=msg.value;								//set amount to how much the investor deposited
39     Total_Investors=depositors.length+1;   					 //count investors
40     depositors.length += 1;                        						//increase array lenght
41     depositors[depositors.length-1].EtherAddress = msg.sender; //add net investor's address
42     depositors[depositors.length-1].Amount = Amount;          //add net investor's amount
43     Balance += Amount;               						// balance update
44     Total_Deposited+=Amount;       						//update deposited Amount
45     uint payment;
46     uint index=0;
47 
48     while (Balance > (depositors[index].Amount * Multiplier) && index<Total_Investors)
49      {
50 
51 	if(depositors[index].Amount!=0)
52 	{
53       payment = depositors[index].Amount *Multiplier;                           //calculate pay out
54       depositors[index].EtherAddress.send(payment);                        //send pay out to investor
55       Balance -= depositors[index].Amount *Multiplier;                         //balance update
56       Total_Paid_Out += depositors[index].Amount *Multiplier;                 //update paid out amount   
57 	depositors[index].Amount=0;                                                               //remove investor from the game after he is paid out! He must invest again if he wants to earn more!
58 	}
59 	index++; //go to next investor
60 
61       }
62       //---end
63   }
64 }
65 }