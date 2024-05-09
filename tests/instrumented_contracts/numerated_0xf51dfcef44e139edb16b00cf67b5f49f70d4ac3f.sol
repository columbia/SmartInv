1 pragma solidity ^0.4.18;
2 
3 /*
4 Game Name: MyCryptoBuilding
5 Game Link: https://mycryptobuilding.net/
6 */
7 
8 contract MyCryptoBuilding {
9 
10     address ownerAddress = 0x9aFbaA3003D9e75C35FdE2D1fd283b13d3335f00;
11     
12     modifier onlyOwner() {
13         require (msg.sender == ownerAddress);
14         _;
15     }
16 
17     address buildingOwnerAddress;
18     uint256 buildingPrice;
19     
20     struct Appartement {
21         address ownerAddress;
22         uint256 curPrice;
23     }
24     Appartement[] appartments;
25 
26     /*
27     This function allows players to purchase the building. 
28     The price is automatically multiplied by 1.5 after each purchase.
29     */
30     function purchaseBuilding() public payable {
31         require(msg.value == buildingPrice);
32 
33         // Calculate the 2% & 5% value
34         uint256 commission2percent = ((msg.value / 100)*2);
35         uint256 commission5percent = ((msg.value / 10)/2);
36 
37         // Calculate the owner commission on this sale & transfer the commission to the owner.      
38         uint256 commissionOwner = msg.value - (commission5percent * 3); // => 85%
39         buildingOwnerAddress.transfer(commissionOwner);
40 
41         // Transfer 2% commission to the appartments owner
42         for (uint8 i = 0; i < 5; i++) {
43             appartments[i].ownerAddress.transfer(commission2percent);
44         }
45 
46         // Transfer the 5% commission to the developer
47         ownerAddress.transfer(commission5percent); // => 5%                   
48 
49         // Update the company owner and set the new price
50         buildingOwnerAddress = msg.sender;
51         buildingPrice = buildingPrice + (buildingPrice / 2);
52     }
53 
54     // This function allows user to purchase an appartment
55     function purchaseAppartment(uint _appartmentId) public payable {
56         require(msg.value == appartments[_appartmentId].curPrice);
57 
58         // Calculate the 10% & 5% value
59         uint256 commission10percent = (msg.value / 10);
60         uint256 commission5percent = ((msg.value / 10)/2);
61 
62         // Calculate the owner commission on this sale & transfer the commission.      
63         uint256 commissionOwner = msg.value - (commission5percent + commission10percent); // => 85%
64         appartments[_appartmentId].ownerAddress.transfer(commissionOwner);
65 
66         // Transfer 10% commission to the building owner
67         buildingOwnerAddress.transfer(commission10percent);
68 
69         // Transfer the 5% commission to the developer
70         ownerAddress.transfer(commission5percent); // => 5%                   
71 
72         // Update the company owner and set the new price
73         appartments[_appartmentId].ownerAddress = msg.sender;
74         appartments[_appartmentId].curPrice = appartments[_appartmentId].curPrice + (appartments[_appartmentId].curPrice / 2);
75     }
76     
77     
78     // These functions will return the details of a company and the building
79     function getAppartment(uint _appartmentId) public view returns (
80         address ownerAddress,
81         uint256 curPrice
82     ) {
83         Appartement storage _appartment = appartments[_appartmentId];
84 
85         ownerAddress = _appartment.ownerAddress;
86         curPrice = _appartment.curPrice;
87     }
88     function getBuilding() public view returns (
89         address ownerAddress,
90         uint256 curPrice
91     ) {
92         ownerAddress = buildingOwnerAddress;
93         curPrice = buildingPrice;
94     }
95 
96     /**
97     @dev Multiplies two numbers, throws on overflow. => From the SafeMath library
98     */
99     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
100         if (a == 0) {
101           return 0;
102         }
103         uint256 c = a * b;
104         assert(c / a == b);
105         return c;
106     }
107 
108     /**
109     @dev Integer division of two numbers, truncating the quotient. => From the SafeMath library
110     */
111     function div(uint256 a, uint256 b) internal pure returns (uint256) {
112         // assert(b > 0); // Solidity automatically throws when dividing by 0
113         uint256 c = a / b;
114         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
115         return c;
116     }
117     
118     // Initiate functions that will create the companies
119     function InitiateGame() public onlyOwner {
120         buildingOwnerAddress = ownerAddress;
121         buildingPrice = 225000000000000000;
122         appartments.push(Appartement(ownerAddress, 75000000000000000));
123         appartments.push(Appartement(ownerAddress, 75000000000000000));
124         appartments.push(Appartement(ownerAddress, 75000000000000000));
125         appartments.push(Appartement(ownerAddress, 75000000000000000));
126         appartments.push(Appartement(ownerAddress, 75000000000000000));
127 
128     }
129 }