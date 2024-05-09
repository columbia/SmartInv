1 pragma solidity ^0.4.23;
2 
3 contract SmartContractWorkshop {
4 	
5 	struct Person {
6 		string name;
7 		string email;
8 		bool attendsInPerson;
9 		bool purchased;
10 	}
11 
12 	uint256 baseprice = 0.03 ether;
13 	uint256 priceIncrease = 0.002 ether;
14 	uint256 maxPrice = 0.07 ether;
15 	address owner;
16 	uint256 faceToFaceLimit = 24;
17 	uint256 public ticketsSold;
18 	uint256 public ticketsFaceToFaceSold;
19 
20 	string public eventWebsite;
21 
22 	mapping(address=>Person) public attendants;
23 
24 	address[] allAttendants;
25 	address[] faceToFaceAttendants;
26 
27 	function SmartContractWorkshop (string _eventWebsite) {
28 		owner = msg.sender;
29 		eventWebsite = _eventWebsite;
30 	}
31 	
32 
33 	function register(string _name, string _email, bool _attendsInPerson) payable {
34 
35 		require (msg.value == currentPrice() && attendants[msg.sender].purchased == false);
36 
37 		if(_attendsInPerson == true ) {
38 			ticketsFaceToFaceSold++;
39 			require (ticketsFaceToFaceSold <= faceToFaceLimit);
40 
41 			addAttendantAndTransfer(_name, _email, _attendsInPerson);
42 			faceToFaceAttendants.push(msg.sender);
43 		} else {
44 			addAttendantAndTransfer(_name, _email, _attendsInPerson);
45 		}
46 		allAttendants.push(msg.sender);
47 	}
48 
49 	function addAttendantAndTransfer(string _name, string _email, bool _attendsInPerson) internal {
50 				attendants[msg.sender] = Person({
51 				name: _name,
52 				email: _email,
53 				attendsInPerson: _attendsInPerson,
54 				purchased: true
55 		});
56 		ticketsSold++;
57 		owner.transfer(this.balance);
58 	}
59 
60 	function listAllAttendants() external view returns(address[]){
61         return allAttendants;
62     }
63 
64     function listFaceToFaceAttendants() external view returns(address[]){
65         return faceToFaceAttendants;
66     }
67 
68     function hasPurchased() public view returns (bool) {
69     	return attendants[msg.sender].purchased;
70     }
71 
72 	function currentPrice() public view returns (uint256) {
73 		if(baseprice + (ticketsSold * priceIncrease) >= maxPrice) {
74 			return maxPrice;
75 		} else {
76 			return baseprice + (ticketsSold * priceIncrease);
77 		}
78     }
79 
80     modifier onlyOwner() {
81 		if(owner != msg.sender) {
82 			revert();
83 		} else {
84 			_;
85 		}
86 	}
87 }