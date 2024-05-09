1 contract CafeMakerT3 {
2 
3 	//CafeMaker Counters..
4 	uint public payed;
5 	uint public delivered;
6 
7 	uint public PricePerCafe = 50000000000000000; //0.05 eth
8 	address public Owner = msg.sender;
9 
10 //	function CafeMaker(){
11 //		PricePerCafe = 50000000000000000;
12 //		Owner = msg.sender; //"0x43e7948F4A71da12f6b79a82bf1C478E9eDB062a";
13 //	}
14 
15 	function GetFreeCnt() returns (uint cnt) {
16 		return payed - delivered;
17 	}
18 
19 	function CafeDelivered(){
20 		delivered += 1;
21 	}
22 
23 
24 	function CollectMoney(uint amount){
25        if (!Owner.send(amount))
26             throw;
27 		
28 	}
29 
30 
31 	//ProcessIncomingPayment
32     function () {
33 
34 		uint addedcafe = msg.value / PricePerCafe;
35 		payed += addedcafe;
36 
37     }
38 }