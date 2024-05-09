1 pragma solidity ^0.4.0;
2 contract SolarSystem {
3 
4     address public owner;
5 
6     //planet object
7     struct Planet {
8         string name;
9         address owner;
10         uint price;
11         uint ownerPlanet;
12     }
13     
14     function SolarSystem() public {
15         owner = msg.sender;
16     }
17     
18     //initiate
19     function bigBang() public {
20         if(msg.sender == owner){
21             planets[0]  = Planet("The Sun",         msg.sender, 10000000000000000000, 0);
22             planets[1]  = Planet("Mercury",         msg.sender,     1500000000000000, 0);
23             planets[2]  = Planet("Venus",           msg.sender,     1000000000000000, 0);
24             planets[3]  = Planet("Earth",           msg.sender,    50000000000000000, 0);
25             planets[4]  = Planet("ISS",             msg.sender,    50000000000000000, 0);
26             planets[5]  = Planet("The Moon",        msg.sender,      700000000000000, 3);
27             planets[6]  = Planet("Mars",            msg.sender,    30000000000000000, 0);
28             planets[7]  = Planet("Curiosity",       msg.sender,    10000000000000000, 6);
29             planets[8]  = Planet("Tesla Roadster",  msg.sender,   500000000000000000, 0);
30             planets[9]  = Planet("Jupiter",         msg.sender,   300000000000000000, 0);
31             planets[10] = Planet("Callisto",        msg.sender,      900000000000000, 8);
32             planets[11] = Planet("IO",              msg.sender,     1000000000000000, 8);
33             planets[12] = Planet("Europa",          msg.sender,     2000000000000000, 8);
34             planets[13] = Planet("Saturn",          msg.sender,   200000000000000000, 0);
35             planets[14] = Planet("Titan",           msg.sender,      800000000000000, 13);
36             planets[15] = Planet("Tethys",          msg.sender,      500000000000000, 13);
37             planets[16] = Planet("Uranus",          msg.sender,   150000000000000000, 0);
38             planets[17] = Planet("Titania",         msg.sender,       80000000000000, 16);
39             planets[18] = Planet("Ariel",           msg.sender,     1000000000000000, 16);
40             planets[19] = Planet("Neptune",         msg.sender,    50000000000000000, 0);
41             planets[20] = Planet("Triton",          msg.sender,        9000000000000, 19);
42             planets[21] = Planet("Pluto",           msg.sender,      800000000000000, 0);
43         }
44     }
45     
46     //list the current sale price of a planet
47     function listSales(uint id) public{
48         if(msg.sender == owner){
49             Sale(planets[id].name, planets[id].price, msg.sender);
50         }
51     }
52     
53     //list of planets
54     mapping (uint => Planet) planets;
55     
56     //register when a planet is offered for sale
57     event Sale(string name, uint price, address new_owner);
58     
59     //register price increase
60     event PriceIncrease(string name, uint price, address new_owner);
61     
62     //register price decrease
63     event PriceDecrease(string name, uint price, address new_owner);
64     
65     //change message
66     event ChangeMessage(string name, string message);
67     
68     //buy a planet
69     function buyPlanet(uint id) public payable {
70         if(msg.value >= planets[id].price){
71             //distribute the money
72             uint cut = (msg.value*2)/100;
73             planets[id].owner.transfer(msg.value-cut);
74             planets[planets[id].ownerPlanet].owner.transfer(cut);
75             //change owner
76             planets[id].owner = msg.sender;
77             planets[id].price += (msg.value*5)/100;
78             Sale(planets[id].name, planets[id].price, msg.sender);
79             if(msg.value > planets[id].price){
80                 msg.sender.transfer(msg.value-planets[id].price);
81             }
82         }
83         else{
84             msg.sender.transfer(msg.value);
85         }
86     }
87     
88     //increase price with 5%
89     function increasePrice(uint id) public {
90         if(planets[id].owner == msg.sender){
91             uint inc = (planets[id].price*5)/100;
92             planets[id].price += inc;
93             PriceIncrease(planets[id].name, planets[id].price, msg.sender);
94         }
95     }
96     
97     //decrease price with 5%
98     function decreasePrice(uint id) public {
99         if(planets[id].owner == msg.sender){
100             uint dec = (planets[id].price*5)/100;
101             planets[id].price -= dec;
102             PriceDecrease(planets[id].name, planets[id].price, msg.sender);
103         }
104     }
105     
106     function changeMessage(uint id, string message) public {
107          if(planets[id].owner == msg.sender){
108             ChangeMessage(planets[id].name, message);
109         }
110     }
111 }