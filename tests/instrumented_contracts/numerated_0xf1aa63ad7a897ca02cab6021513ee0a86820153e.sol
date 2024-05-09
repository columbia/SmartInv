1 // EthVenture plugin
2 // TESTING CONTRACT
3 
4 contract EthVenturePlugin {
5 
6 address public owner;
7 
8 
9 function EthVenturePlugin() {
10 owner = 0xEe462A6717f17C57C826F1ad9b4d3813495296C9;  //this contract is an attachment to EthVentures
11 }
12 
13 
14 function() {
15     
16 uint Fees = msg.value;    
17 
18 //********************************EthVenturesFinal Fee Plugin
19     // payout fees to the owner
20      if (Fees != 0) 
21      {
22 	uint minimal= 1999 finney;
23 	if(Fees<minimal)
24 	{
25       	owner.send(Fees);		//send fee to owner
26 	}
27 	else
28 	{
29 	uint Times= Fees/minimal;
30 
31 	for(uint i=0; i<Times;i++)   // send the fees out in packets compatible to EthVentures dividend function
32 	if(Fees>0)
33 	{
34 	owner.send(minimal);		//send fee to owner
35 	Fees-=minimal;
36 	}
37 	}
38      }
39 //********************************End Plugin 
40 
41 }
42 
43 // AAAAAAAAAAAAAND IT'S STUCK!
44 
45 }