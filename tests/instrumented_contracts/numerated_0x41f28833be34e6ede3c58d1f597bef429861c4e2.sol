1 pragma solidity ^0.4.2;
2 
3 // This is a revised version of the original EtherRock contract 0x37504ae0282f5f334ed29b4548646f887977b7cc with all the rock owners and rock properties the same at the time this new contract is being deployed.
4 // The original contract at 0x37504ae0282f5f334ed29b4548646f887977b7cc had a simple mistake in the buyRock() function. The line:
5 // require(rocks[rockNumber].currentlyForSale = true);
6 // Had to have double equals, as follows:
7 // require(rocks[rockNumber].currentlyForSale == true);
8 // Therefore in the original contract, anyone could buy anyone elses rock for the same price the owner purchased it for (regardless of whether the owner chose to sell it or not)
9 
10 contract EtherRock {
11     
12     struct Rock {
13         address owner;
14         bool currentlyForSale;
15         uint price;
16         uint timesSold;
17     }
18     
19     mapping (uint => Rock) public rocks;
20     
21     mapping (address => uint[]) public rockOwners;
22 
23     uint public latestNewRockForSale;
24     
25     address owner;
26     
27     modifier onlyOwner {
28         require(msg.sender == owner);
29         _;
30     }
31     
32     function EtherRock() {
33         
34         latestNewRockForSale = 11;
35         
36         rocks[0].owner = 0x789c778b340f17eb046a5a8633e362468aceeff6;
37         rocks[0].currentlyForSale = true;
38         rocks[0].price = 10000000000000000000;
39         rocks[0].timesSold = 2;
40         rockOwners[0x789c778b340f17eb046a5a8633e362468aceeff6].push(0);
41         
42         rocks[1].owner = 0x9a643a42748243f80243a65666146a2e1bd5c6aa;
43         rocks[1].currentlyForSale = false;
44         rocks[1].price = 2000000000000000;
45         rocks[1].timesSold = 3;
46         rockOwners[0x9a643a42748243f80243a65666146a2e1bd5c6aa].push(1);
47         
48         rocks[2].owner = 0x5d5d6543d73066e69424ce2756cc34cbfe4c368c;
49         rocks[2].currentlyForSale = false;
50         rocks[2].price = 5000000000000000;
51         rocks[2].timesSold = 1;
52         rockOwners[0x5d5d6543d73066e69424ce2756cc34cbfe4c368c].push(2);
53         
54         rocks[3].owner = 0xe34501580dc9591211afc7c13f16ddf591c87cde;
55         rocks[3].currentlyForSale = true;
56         rocks[3].price = 1000000000000000000;
57         rocks[3].timesSold = 1;
58         rockOwners[0xe34501580dc9591211afc7c13f16ddf591c87cde].push(3);
59         
60         rocks[4].owner = 0x93cdb0a93fc36f6a53ed21ecf6305ab80d06beca;
61         rocks[4].currentlyForSale = true;
62         rocks[4].price = 1000000000000000000;
63         rocks[4].timesSold = 1;
64         rockOwners[0x93cdb0a93fc36f6a53ed21ecf6305ab80d06beca].push(4);
65         
66         rocks[5].owner = 0x9467d05ee1c90010a657e244f626194168596583;
67         rocks[5].currentlyForSale = true;
68         rocks[5].price = 42000000000000000000;
69         rocks[5].timesSold = 1;
70         rockOwners[0x9467d05ee1c90010a657e244f626194168596583].push(5);
71         
72         rocks[6].owner = 0xb6e2e5e06397dc522db58faa064f74c95322b58e;
73         rocks[6].currentlyForSale = true;
74         rocks[6].price = 60000000000000000;
75         rocks[6].timesSold = 1;
76         rockOwners[0xb6e2e5e06397dc522db58faa064f74c95322b58e].push(6);
77         
78         rocks[7].owner = 0xbcddcf35880443b6a1f32f07009097e95c327716;
79         rocks[7].currentlyForSale = true;
80         rocks[7].price = 100000000000000000;
81         rocks[7].timesSold = 1;
82         rockOwners[0xbcddcf35880443b6a1f32f07009097e95c327716].push(7);
83         
84         rocks[8].owner = 0xf7007f39a41d87c669bd9beadc3d5cc2ef5a32be;
85         rocks[8].currentlyForSale = false;
86         rocks[8].price = 65000000000000000;
87         rocks[8].timesSold = 1;
88         rockOwners[0xf7007f39a41d87c669bd9beadc3d5cc2ef5a32be].push(8);
89         
90         rocks[9].owner = 0xf7007f39a41d87c669bd9beadc3d5cc2ef5a32be;
91         rocks[9].currentlyForSale = true;
92         rocks[9].price = 10000000000000000000;
93         rocks[9].timesSold = 1;
94         rockOwners[0xf7007f39a41d87c669bd9beadc3d5cc2ef5a32be].push(9);
95         
96         rocks[10].owner = 0xd17e2bfe196470a9fefb567e8f5992214eb42f24;
97         rocks[10].currentlyForSale = true;
98         rocks[10].price = 200000000000000000;
99         rocks[10].timesSold = 1;
100         rockOwners[0xd17e2bfe196470a9fefb567e8f5992214eb42f24].push(10);
101         
102         rocks[11].currentlyForSale = true;
103         rocks[11].price = 122000000000000000;
104         
105         owner = msg.sender;
106     }
107     
108     function getRockInfo (uint rockNumber) returns (address, bool, uint, uint) {
109         return (rocks[rockNumber].owner, rocks[rockNumber].currentlyForSale, rocks[rockNumber].price, rocks[rockNumber].timesSold);
110     }
111     
112     function rockOwningHistory (address _address) returns (uint[]) {
113         return rockOwners[_address];
114     }
115     
116     function buyRock (uint rockNumber) payable {
117         require(rocks[rockNumber].currentlyForSale == true);
118         require(msg.value == rocks[rockNumber].price);
119         rocks[rockNumber].currentlyForSale = false;
120         rocks[rockNumber].timesSold++;
121         if (rockNumber != latestNewRockForSale) {
122             rocks[rockNumber].owner.transfer(rocks[rockNumber].price);
123         }
124         rocks[rockNumber].owner = msg.sender;
125         rockOwners[msg.sender].push(rockNumber);
126         if (rockNumber == latestNewRockForSale) {
127             if (rockNumber != 99) {
128                 latestNewRockForSale++;
129                 rocks[latestNewRockForSale].price = 10**15 + (latestNewRockForSale**2 * 10**15);
130                 rocks[latestNewRockForSale].currentlyForSale = true;
131             }
132         }
133     }
134     
135     function sellRock (uint rockNumber, uint price) {
136         require(msg.sender == rocks[rockNumber].owner);
137         require(price > 0);
138         rocks[rockNumber].price = price;
139         rocks[rockNumber].currentlyForSale = true;
140     }
141     
142     function dontSellRock (uint rockNumber) {
143         require(msg.sender == rocks[rockNumber].owner);
144         rocks[rockNumber].currentlyForSale = false;
145     }
146     
147     function giftRock (uint rockNumber, address receiver) {
148         require(msg.sender == rocks[rockNumber].owner);
149         rocks[rockNumber].owner = receiver;
150         rockOwners[receiver].push(rockNumber);
151     }
152     
153     function() payable {
154         
155     }
156     
157     function withdraw() onlyOwner {
158         owner.transfer(this.balance);
159     }
160     
161 }