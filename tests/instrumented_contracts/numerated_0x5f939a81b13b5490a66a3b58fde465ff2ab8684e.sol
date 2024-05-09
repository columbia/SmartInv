1 pragma solidity ^0.4.11;
2 
3 contract SandwichShop
4 {
5     address owner;
6 
7     modifier onlyOwner()
8     {
9         require(msg.sender == owner);
10         _;
11     }
12 
13     struct Sandwich
14     {
15         uint sandwichID;
16         string sandwichName;
17         string sandwichDesc;
18         string calories;
19         uint price;
20         uint quantity;
21     }
22 
23     struct OrderedSandwich
24     {
25         uint sandwichIdNumber;
26         string notes;
27         uint price;
28     }
29     
30     event NewSandwichTicket( string name, address customer, string sandName, string sandChanges );
31 
32     Sandwich[5] shopSandwich;
33     mapping( address => OrderedSandwich[] ) public cart;
34     mapping( address => uint ) public subtotal;
35 
36     function SandwichShop() public
37     {
38         owner = msg.sender;
39 
40         shopSandwich[0].sandwichID = 0;
41         shopSandwich[0].sandwichName = "00:  Ham & Swiss";
42         shopSandwich[0].sandwichDesc = "Ham Swiss Mustard Rye";
43         shopSandwich[0].calories = "450 calories";
44         shopSandwich[0].price = 40 finney;
45         shopSandwich[0].quantity = 200;
46 
47         shopSandwich[1].sandwichID = 1;
48         shopSandwich[1].sandwichName = "01:  Turkey & Pepperjack";
49         shopSandwich[1].sandwichDesc = "Turkey Pepperjack Mayo White Bread";
50         shopSandwich[1].calories = "500 calories";
51         shopSandwich[1].price = 45 finney;
52         shopSandwich[1].quantity = 200;
53 
54         shopSandwich[2].sandwichID = 2;
55         shopSandwich[2].sandwichName = "02:  Roast Beef & American";
56         shopSandwich[2].sandwichDesc = "Roast Beef Havarti Horseradish White Bread";
57         shopSandwich[2].calories = "600 calories";
58         shopSandwich[2].price = 50 finney;
59         shopSandwich[2].quantity = 200;
60 
61         shopSandwich[3].sandwichID = 3;
62         shopSandwich[3].sandwichName = "03:  Reuben";
63         shopSandwich[3].sandwichDesc = "Corned Beef Sauerkraut Swiss Rye";
64         shopSandwich[3].calories = "550 calories";
65         shopSandwich[3].price = 50 finney;
66         shopSandwich[3].quantity = 200;
67 
68         shopSandwich[4].sandwichID = 4;
69         shopSandwich[4].sandwichName = "04:  Italian";
70         shopSandwich[4].sandwichDesc = "Salami Peppers Provolone Oil Vinegar White";
71         shopSandwich[4].calories = "500 calories";
72         shopSandwich[4].price = 40 finney;
73         shopSandwich[4].quantity = 200;
74     }
75 
76     function getMenu() constant returns (string, string, string, string, string)
77     {
78         return (shopSandwich[0].sandwichName, shopSandwich[1].sandwichName,
79                 shopSandwich[2].sandwichName, shopSandwich[3].sandwichName,
80                 shopSandwich[4].sandwichName );
81     }
82 
83     function getSandwichInfo(uint _sandwichId) constant returns (string, string, string, uint, uint)
84     {
85         if( _sandwichId > 4 )
86         {
87             return ( "wrong ID", "wrong ID", "zero", 0, 0);
88         }
89         else
90         {
91             return (shopSandwich[_sandwichId].sandwichName, shopSandwich[_sandwichId].sandwichDesc,
92                     shopSandwich[_sandwichId].calories, shopSandwich[_sandwichId].price, shopSandwich[_sandwichId].quantity);
93 
94         }
95     }
96 
97     function addToCart(uint _sandwichID, string _notes) returns (uint)
98     {
99         if( shopSandwich[_sandwichID].quantity > 0 )
100         {
101             OrderedSandwich memory newOrder;
102             newOrder.sandwichIdNumber = _sandwichID;
103             newOrder.notes = _notes;
104             newOrder.price = shopSandwich[_sandwichID].price;
105             subtotal[msg.sender] += newOrder.price;
106 
107             return cart[msg.sender].push(newOrder);
108         }
109         else
110         {
111             return cart[msg.sender].length;
112         }
113     }
114 
115 
116     function getCartLength(address _curious) constant returns (uint)
117     {
118         return cart[_curious].length;
119     }
120 
121     function getCartItemInfo(address _curious, uint _slot) constant returns (uint, string)
122     {
123         return (cart[_curious][_slot].sandwichIdNumber, cart[_curious][_slot].notes);
124     }
125 
126     function emptyCart() public
127     {
128         delete cart[msg.sender];
129         subtotal[msg.sender] = 0;
130     }
131 
132     function getCartSubtotal(address _curious) constant returns (uint)
133     {
134         return subtotal[_curious];
135     }
136 
137     function checkoutCart(string _firstname) payable returns (uint)
138     {
139         if( msg.value < subtotal[msg.sender] ){ revert(); }
140 
141         for( uint x = 0; x < cart[msg.sender].length; x++ )
142         {
143             if( shopSandwich[ cart[msg.sender][x].sandwichIdNumber ].quantity > 0 )
144             {
145                 NewSandwichTicket( _firstname, msg.sender, 
146                                    shopSandwich[ cart[msg.sender][x].sandwichIdNumber ].sandwichName,
147                                    cart[msg.sender][x].notes );
148                 decrementQuantity( cart[msg.sender][x].sandwichIdNumber );
149             }
150             else
151             {
152                 revert();
153             }
154         }
155         subtotal[msg.sender] = 0;
156         delete cart[msg.sender];
157         return now;
158     }
159 
160     function transferFundsAdminOnly(address addr, uint amount) onlyOwner
161     {
162         if( amount <= this.balance )
163         {
164             addr.transfer(amount);
165         }
166     }
167 
168     function decrementQuantity(uint _sandnum) private
169     {
170         shopSandwich[_sandnum].quantity--;
171     }
172 
173     function setQuantityAdminOnly(uint _sandnum, uint _quantity) onlyOwner
174     {
175         shopSandwich[_sandnum].quantity = _quantity;
176     }
177 
178     function killAdminOnly() onlyOwner
179     {
180         selfdestruct(owner);
181     }
182 
183 }