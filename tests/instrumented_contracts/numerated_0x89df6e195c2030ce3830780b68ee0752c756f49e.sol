1 pragma solidity ^0.4.24;
2 
3 contract Whiskey {
4     
5    event Selling(
6         address seller,
7         address buyer,
8         uint price
9     );
10 
11     uint public totalSupply = 201;
12     bool private initedCopper = false;
13     bool private initedBronze = false;
14     bool private initedSilver = false;
15     bool private initedGold = false;
16     bool private initedPlatinum = false;
17     
18     struct Bottle {
19         uint    id;
20         uint    price;
21         uint    sellPrice;
22         address owner;
23         string  name;
24         string  info;
25         bool    infoLocked;
26         bool    saleLocked;
27     }
28     
29     Bottle[202] public bottle;
30     
31     constructor() public {
32             bottle[1].id = 1;
33             bottle[1].price = 1 ether;
34             bottle[1].sellPrice = 1 ether;
35             bottle[1].owner = msg.sender;
36             bottle[1].infoLocked = false;
37             bottle[1].saleLocked = false;
38             bottle[201].id = 201;
39             bottle[201].price = 50000 ether;
40             bottle[201].sellPrice = 5000 ether;
41             bottle[201].owner = msg.sender;
42             bottle[201].infoLocked = false;
43             bottle[201].saleLocked = false;
44     }
45     
46     function initCopper() public {
47         if (initedCopper == false){
48             for (uint i = 2; i < 31; i++) {
49                 bottle[i].id = i;
50                 bottle[i].price = 15 ether;
51                 bottle[i].sellPrice = 15 ether;
52                 bottle[i].owner = msg.sender;
53                 bottle[i].infoLocked = false;
54                 bottle[i].saleLocked = false;
55             }
56             initedCopper = true;
57         }
58     }
59     
60     function initBronze() public {
61         if (initedBronze == false) {
62             for (uint i = 31; i < 71; i++) {
63                 bottle[i].id = i;
64                 bottle[i].price = 35 ether;
65                 bottle[i].sellPrice = 35 ether;
66                 bottle[i].owner = msg.sender;
67                 bottle[i].infoLocked = false;
68                 bottle[i].saleLocked = false;
69             }
70             initedBronze = true;
71         }
72     }
73     
74     function initSilver() public {
75          if (initedSilver == false) {
76              for (uint i = 71; i < 131; i++) {
77                 bottle[i].id = i;
78                 bottle[i].price = 50 ether;
79                 bottle[i].sellPrice = 50 ether;
80                 bottle[i].owner = msg.sender;
81                 bottle[i].infoLocked = false;
82                 bottle[i].saleLocked = false;
83             }
84             initedSilver = true;
85          }
86     }
87     
88     function initGold() public {
89          if (initedGold == false) {
90              for (uint i = 131; i < 171; i++) {
91                 bottle[i].id = i;
92                 bottle[i].price = 65 ether;
93                 bottle[i].sellPrice = 65 ether;
94                 bottle[i].owner = msg.sender;
95                 bottle[i].infoLocked = false;
96                 bottle[i].saleLocked = false;
97             }
98             initedGold = true;    
99         }
100     }
101     
102     function initPlatinum() public {
103         if (initedPlatinum == false) {
104             for (uint i = 171; i < 201; i++) {
105                 bottle[i].id = i;
106                 bottle[i].price = 85 ether;
107                 bottle[i].sellPrice = 85 ether;
108                 bottle[i].owner = msg.sender;
109                 bottle[i].infoLocked = false;
110                 bottle[i].saleLocked = false;
111             }
112             initedPlatinum = true;
113         }
114     }
115     
116     function sell(uint price, uint id) public {
117         if (bottle[id].owner == msg.sender && price > bottle[id].price){
118             bottle[id].sellPrice = price;
119             bottle[id].saleLocked = false;
120         }
121     }
122     
123     function cancelSell (uint id) public {
124         if (bottle[id].owner == msg.sender) {
125             bottle[id].sellPrice = 0;
126             bottle[id].saleLocked = true;
127         }
128     }
129     
130     function buy(uint id) public payable {
131         if(bottle[id].sellPrice != msg.value || bottle[id].saleLocked == true) {
132         	revert();
133         }
134         address seller = bottle[id].owner;
135         bottle[id].owner.transfer(msg.value);     
136         bottle[id].owner = msg.sender;
137         bottle[id].price = msg.value;
138         bottle[id].infoLocked = false;
139         bottle[id].saleLocked = true;
140         emit Selling(seller, msg.sender, msg.value);
141         
142     }
143     
144     function changeInfo(uint id, string name, string info) public {
145 
146         if(bottle[id].owner == msg.sender) {
147             bottle[id].name = name;
148             bottle[id].info = info;
149             bottle[id].infoLocked = true;    
150         }
151     }
152     
153     function gift(uint id, address newOwner) public {
154         if(bottle[id].owner == msg.sender) {
155             bottle[id].owner = newOwner;
156             bottle[id].infoLocked = false;
157         }
158     }
159 }