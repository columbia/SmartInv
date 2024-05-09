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
30     event NewSandwichTicket( string _name, address _orderer, string _sandName, string _sandChanges );
31     event testSandwichOrder( uint _sandwichId, address _addr );
32 
33     Sandwich[5] shopSandwich;
34     mapping( address => OrderedSandwich[] ) public cart;
35     mapping( address => uint ) public subtotal;
36 
37     function SandwichShop() public
38     {
39         owner = msg.sender;
40 
41         shopSandwich[0].sandwichID = 0;
42         shopSandwich[0].sandwichName = "100: Ham & Swiss";
43         shopSandwich[0].sandwichDesc = "Ham Swiss Mustard Rye";
44         shopSandwich[0].calories = "450 calories";
45         shopSandwich[0].price = 40 finney;
46         shopSandwich[0].quantity = 200;
47 
48         shopSandwich[1].sandwichID = 1;
49         shopSandwich[1].sandwichName = "101: Turkey & Pepperjack";
50         shopSandwich[1].sandwichDesc = "Turkey Pepperjack Mayo White Bread";
51         shopSandwich[1].calories = "500 calories";
52         shopSandwich[1].price = 45 finney;
53         shopSandwich[1].quantity = 200;
54 
55         shopSandwich[2].sandwichID = 2;
56         shopSandwich[2].sandwichName = "102: Roast Beef & American";
57         shopSandwich[2].sandwichDesc = "Roast Beef Havarti Horseradish White Bread";
58         shopSandwich[2].calories = "600 calories";
59         shopSandwich[2].price = 50 finney;
60         shopSandwich[2].quantity = 200;
61 
62         shopSandwich[3].sandwichID = 3;
63         shopSandwich[3].sandwichName = "103: Reuben";
64         shopSandwich[3].sandwichDesc = "Corned Beef Sauerkraut Swiss Rye";
65         shopSandwich[3].calories = "550 calories";
66         shopSandwich[3].price = 50 finney;
67         shopSandwich[3].quantity = 200;
68 
69         shopSandwich[4].sandwichID = 4;
70         shopSandwich[4].sandwichName = "104: Italian";
71         shopSandwich[4].sandwichDesc = "Salami Peppers Provolone Oil Vinegar White";
72         shopSandwich[4].calories = "500 calories";
73         shopSandwich[4].price = 40 finney;
74         shopSandwich[4].quantity = 200;
75     }
76 
77     function getMenu() constant returns (string, string, string, string, string)
78     {
79         return (shopSandwich[0].sandwichName, shopSandwich[1].sandwichName,
80                 shopSandwich[2].sandwichName, shopSandwich[3].sandwichName,
81                 shopSandwich[4].sandwichName );
82     }
83 
84     function getSandwichInfo(uint _sandwich) constant returns (string, string, string, uint, uint)
85     {
86         if( _sandwich > 4 )
87         {
88             return ( "wrong ID", "wrong ID", "zero", 0, 0);
89         }
90         else
91         {
92             return (shopSandwich[_sandwich].sandwichName, shopSandwich[_sandwich].sandwichDesc,
93                 shopSandwich[_sandwich].calories, shopSandwich[_sandwich].price, shopSandwich[_sandwich].quantity);
94         }
95     }
96 
97     function decrementQuantity(uint _sandnum) private
98     {
99         shopSandwich[_sandnum].quantity--;
100     }
101 
102     function setQuantity(uint _sandnum, uint _quantity) onlyOwner
103     {
104         shopSandwich[_sandnum].quantity = _quantity;
105     }
106 
107     function addToCart(uint _sandwichID, string _notes) returns (uint)
108     {
109         if( shopSandwich[_sandwichID].quantity > 0 )
110         {
111             OrderedSandwich memory newOrder;
112             newOrder.sandwichIdNumber = _sandwichID;
113             newOrder.notes = _notes;
114             newOrder.price = shopSandwich[_sandwichID].price;
115             subtotal[msg.sender] += newOrder.price;
116             testSandwichOrder(newOrder.sandwichIdNumber, msg.sender);
117 
118             return cart[msg.sender].push(newOrder);
119         }
120         else
121         {
122             return cart[msg.sender].length;
123         }
124     }
125 
126 
127     function getCartLength(address _curious) constant returns (uint)
128     {
129         return cart[_curious].length;
130     }
131 
132     function getCartItemInfo(address _curious, uint _slot) constant returns (string)
133     {
134         return cart[_curious][_slot].notes;
135     }
136 
137     function emptyCart() public
138     {
139         delete cart[msg.sender];
140         subtotal[msg.sender] = 0;
141     }
142 
143     function getCartSubtotal(address _curious) constant returns (uint)
144     {
145         return subtotal[_curious];
146     }
147 
148     function checkoutCart(string _firstname) payable returns (uint)
149     {
150         if( msg.value < subtotal[msg.sender] ){ revert(); }
151 
152         for( uint x = 0; x < cart[msg.sender].length; x++ )
153         {
154             if( shopSandwich[ cart[msg.sender][x].sandwichIdNumber ].quantity > 0 )
155             {
156                 NewSandwichTicket( _firstname, msg.sender, 
157                                    shopSandwich[ cart[msg.sender][x].sandwichIdNumber ].sandwichName,
158                                    cart[msg.sender][x].notes );
159                 decrementQuantity( cart[msg.sender][x].sandwichIdNumber );
160             }
161             else
162             {
163                 revert();
164             }
165         }
166         subtotal[msg.sender] = 0;
167         delete cart[msg.sender];
168     }
169 
170     function transferFromRegister(address addr, uint amount) onlyOwner
171     {
172         if( amount <= this.balance )
173         {
174             addr.transfer(amount);
175         }
176     }
177 
178     function kill() onlyOwner
179     {
180         selfdestruct(owner);
181     }
182 
183 }