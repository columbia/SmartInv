1 //Contract Adress: 0xb58b2b121128719204d1F813F8B4100F63511F50
2 //
3 //Query "CafeMaker.locked": https://api.etherscan.io/api?module=proxy&action=eth_getStorageAt&address=0xb58b2b121128719204d1F813F8B4100F63511F50&position=0x0&tag=latest&apikey=YourApiKeyToken
4 
5 contract CafeMaker{
6 
7 	bool public locked = true;
8 
9 	uint public CafePayed;
10 	uint public CafeDelivered;
11 
12 
13 	uint public PricePerCafe = 50000000000000000; //0.05 eth
14 	address public DeviceOwner = msg.sender;
15 	address public DeviceAddr;
16 
17 	function RegisterDevice() {
18 		DeviceAddr = msg.sender;
19 	}
20 
21 	function BookCafe(){
22 
23 		if(DeviceAddr != msg.sender)
24 			throw; //only the device can call this
25 
26 		CafeDelivered += 1;
27 
28 		if(CafePayed - CafeDelivered < 1)
29 			locked=true;
30 
31 	}
32 
33 
34 	function CollectMoney(uint amount){
35        if (!DeviceOwner.send(amount))
36             throw;
37 		
38 	}
39 
40 
41 	//ProcessIncomingPayment
42     function () {
43 
44 		CafePayed += (msg.value / PricePerCafe);
45 
46 		if(CafePayed - CafeDelivered < 1){
47 			locked=true;
48 		} else {
49 			locked=false;
50 		}
51 
52     }
53 }