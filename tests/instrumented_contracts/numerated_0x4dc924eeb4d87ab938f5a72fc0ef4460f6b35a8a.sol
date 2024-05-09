1 pragma solidity ^0.4.11;
2 
3 contract mortal
4 {
5     address owner;
6 
7     function mortal() { owner = msg.sender; }
8     function kill() { if(msg.sender == owner) selfdestruct(owner); }
9 }
10 
11 contract SandwichShop is mortal
12 {
13 
14     struct Sandwich
15     {
16         uint sandwichID;
17         string sandwichName;
18         string sandwichDesc;
19         string calories;
20         uint price;
21         uint availableQuantity;
22     }
23 
24     struct OrderedSandwich
25     {
26         uint sandID;
27         string notes;
28         uint price;
29     }
30 
31     Sandwich[5] shopSandwich;
32     mapping( address => OrderedSandwich[] ) public cart; 
33 
34     function SandwichShop() public
35     {
36         shopSandwich[0].sandwichID = 0;
37         shopSandwich[0].sandwichName = "100: Ham & Swiss";
38         shopSandwich[0].sandwichDesc = "Ham Swiss Mustard Rye";
39         shopSandwich[0].calories = "450 calories";
40         shopSandwich[0].price = 5;
41         shopSandwich[0].availableQuantity = 200;
42 
43         shopSandwich[1].sandwichID = 1;
44         shopSandwich[1].sandwichName = "101: Turkey & Pepperjack";
45         shopSandwich[1].sandwichDesc = "Turkey Pepperjack Mayo White Bread";
46         shopSandwich[1].calories = "500 calories";
47         shopSandwich[1].price = 5;
48         shopSandwich[1].availableQuantity = 200;
49 
50         shopSandwich[2].sandwichID = 2;
51         shopSandwich[2].sandwichName = "102: Roast Beef & American";
52         shopSandwich[2].sandwichDesc = "Roast Beef Havarti Horseradish White Bread";
53         shopSandwich[2].calories = "600 calories";
54         shopSandwich[2].price = 5;
55         shopSandwich[2].availableQuantity = 200;
56 
57         shopSandwich[3].sandwichID = 3;
58         shopSandwich[3].sandwichName = "103: Reuben";
59         shopSandwich[3].sandwichDesc = "Corned Beef Sauerkraut Swiss Rye";
60         shopSandwich[3].calories = "550 calories";
61         shopSandwich[3].price = 5;
62         shopSandwich[3].availableQuantity = 200;
63 
64         shopSandwich[4].sandwichID = 4;
65         shopSandwich[4].sandwichName = "104: Italian";
66         shopSandwich[4].sandwichDesc = "Salami Peppers Provolone Oil Vinegar White";
67         shopSandwich[4].calories = "500 calories";
68         shopSandwich[4].price = 5;
69         shopSandwich[4].availableQuantity = 200;
70     }
71 
72     function getMenu() constant returns (string, string, string, string, string)
73     {
74         return (shopSandwich[0].sandwichName, shopSandwich[1].sandwichName,
75                 shopSandwich[2].sandwichName, shopSandwich[3].sandwichName,
76                 shopSandwich[4].sandwichName );
77     }
78 
79     function getSandwichInfoCaloriesPrice(uint _sandwich) constant returns (string, string, string, uint)
80     {
81         if( _sandwich > 4 )
82         {
83             return ( "wrong ID", "wrong ID", "zero", 0);
84         }
85         else
86         {
87             return (shopSandwich[_sandwich].sandwichName, shopSandwich[_sandwich].sandwichDesc,
88                 shopSandwich[_sandwich].calories, shopSandwich[_sandwich].price);
89         }
90     }
91 
92     function addToCart(uint _orderID, string _notes) returns (uint)
93     {
94         OrderedSandwich memory newOrder;
95         newOrder.sandID = _orderID;
96         newOrder.notes = _notes;
97         newOrder.price = shopSandwich[_orderID].price;
98 
99         return cart[msg.sender].push(newOrder);
100     }
101 
102     function getCartLength(address _curious) constant returns (uint)
103     {
104         return cart[_curious].length;
105     }
106 
107     function readFromCart(address _curious, uint _spot) constant returns (string)
108     {
109         return cart[_curious][_spot].notes;
110     }
111 
112     function emptyCart() public
113     {
114         delete cart[msg.sender];
115     }
116 
117 }