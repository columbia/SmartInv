1 pragma solidity ^0.4.21;
2 
3 
4 /**
5  * An interface providing the necessary Beercoin functionality
6  */
7 interface Beercoin {
8     function transfer(address _to, uint256 _amount) external;
9     function balanceOf(address _owner) external view returns (uint256);
10     function decimals() external pure returns (uint8);
11 }
12 
13 
14 /**
15  * A contract that defines owner and guardians of the ICO
16  */
17 contract GuardedBeercoinICO {
18     address public owner;
19 
20     address public constant guardian1 = 0x7d54aD7DA2DE1FD3241e1c5e8B5Ac9ACF435070A;
21     address public constant guardian2 = 0x065a6D3c1986E608354A8e7626923816734fc468;
22     address public constant guardian3 = 0x1c387D6FDCEF351Fc0aF5c7cE6970274489b244B;
23 
24     address public guardian1Vote = 0x0;
25     address public guardian2Vote = 0x0;
26     address public guardian3Vote = 0x0;
27 
28     /**
29      * Restrict to the owner only
30      */
31     modifier onlyOwner() {
32         require(msg.sender == owner);
33         _;
34     }
35 
36     /**
37      * Restrict to guardians only
38      */
39     modifier onlyGuardian() {
40         require(msg.sender == guardian1 || msg.sender == guardian2 || msg.sender == guardian3);
41         _;
42     }
43 
44     /**
45      * Construct the GuardedBeercoinICO contract
46      * and make the sender the owner
47      */
48     function GuardedBeercoinICO() public {
49         owner = msg.sender;
50     }
51 
52     /**
53      * Declare a new owner
54      *
55      * @param newOwner the new owner's address
56      */
57     function setOwner(address newOwner) onlyGuardian public {
58         if (msg.sender == guardian1) {
59             if (newOwner == guardian2Vote || newOwner == guardian3Vote) {
60                 owner = newOwner;
61                 guardian1Vote = 0x0;
62                 guardian2Vote = 0x0;
63                 guardian3Vote = 0x0;
64             } else {
65                 guardian1Vote = newOwner;
66             }
67         } else if (msg.sender == guardian2) {
68             if (newOwner == guardian1Vote || newOwner == guardian3Vote) {
69                 owner = newOwner;
70                 guardian1Vote = 0x0;
71                 guardian2Vote = 0x0;
72                 guardian3Vote = 0x0;
73             } else {
74                 guardian2Vote = newOwner;
75             }
76         } else if (msg.sender == guardian3) {
77             if (newOwner == guardian1Vote || newOwner == guardian2Vote) {
78                 owner = newOwner;
79                 guardian1Vote = 0x0;
80                 guardian2Vote = 0x0;
81                 guardian3Vote = 0x0;
82             } else {
83                 guardian3Vote = newOwner;
84             }
85         }
86     }
87 }
88 
89 
90 /**
91  * A contract that defines the Beercoin ICO
92  */
93 contract BeercoinICO is GuardedBeercoinICO {
94     Beercoin internal beercoin = Beercoin(0x7367A68039d4704f30BfBF6d948020C3B07DFC59);
95 
96     uint public constant price = 0.000006 ether;
97     uint public constant softCap = 48 ether;
98     uint public constant begin = 1526637600; // 2018-05-18 12:00:00 (UTC+01:00)
99     uint public constant end = 1530395999;   // 2018-06-30 23:59:59 (UTC+01:00)
100     
101     event FundTransfer(address backer, uint amount, bool isContribution);
102    
103     mapping(address => uint256) public balanceOf;
104     uint public soldBeercoins = 0;
105     uint public raisedEther = 0 ether;
106 
107     bool public paused = false;
108 
109     /**
110      * Restrict to the time when the ICO is open
111      */
112     modifier isOpen {
113         require(now >= begin && now <= end && !paused);
114         _;
115     }
116 
117     /**
118      * Restrict to the state of enough Ether being gathered
119      */
120     modifier goalReached {
121         require(raisedEther >= softCap);
122         _;
123     }
124 
125     /**
126      * Restrict to the state of not enough Ether
127      * being gathered after the time is up
128      */
129     modifier goalNotReached {
130         require(raisedEther < softCap && now > end);
131         _;
132     }
133 
134     /**
135      * Transfer Beercoins to a user who sent Ether to this contract
136      */
137     function() payable isOpen public {
138         uint etherAmount = msg.value;
139         balanceOf[msg.sender] += etherAmount;
140 
141         uint beercoinAmount = (etherAmount * 10**uint(beercoin.decimals())) / price;
142         beercoin.transfer(msg.sender, beercoinAmount);
143 
144         soldBeercoins += beercoinAmount;        
145         raisedEther += etherAmount;
146         emit FundTransfer(msg.sender, etherAmount, true);
147     }
148 
149     /**
150      * Transfer Beercoins to a user who purchased via other payment methods
151      *
152      * @param to the address of the recipient
153      * @param beercoinAmount the amount of Beercoins to send
154      */
155     function transfer(address to, uint beercoinAmount) isOpen onlyOwner public {        
156         beercoin.transfer(to, beercoinAmount);
157 
158         uint etherAmount = beercoinAmount * price;        
159         raisedEther += etherAmount;
160 
161         emit FundTransfer(msg.sender, etherAmount, true);
162     }
163 
164     /**
165      * Withdraw the sender's contributed Ether in case the goal has not been reached
166      */
167     function withdraw() goalNotReached public {
168         uint amount = balanceOf[msg.sender];
169         require(amount > 0);
170 
171         balanceOf[msg.sender] = 0;
172         msg.sender.transfer(amount);
173 
174         emit FundTransfer(msg.sender, amount, false);
175     }
176 
177     /**
178      * Withdraw the contributed Ether stored in this contract
179      * if the funding goal has been reached.
180      */
181     function claimFunds() onlyOwner goalReached public {
182         uint etherAmount = address(this).balance;
183         owner.transfer(etherAmount);
184 
185         emit FundTransfer(owner, etherAmount, false);
186     }
187 
188     /**
189      * Withdraw the remaining Beercoins in this contract
190      */
191     function claimBeercoins() onlyOwner public {
192         uint beercoinAmount = beercoin.balanceOf(address(this));
193         beercoin.transfer(owner, beercoinAmount);
194     }
195 
196     /**
197      * Pause the token sale
198      */
199     function pause() onlyOwner public {
200         paused = true;
201     }
202 
203     /**
204      * Resume the token sale
205      */
206     function resume() onlyOwner public {
207         paused = false;
208     }
209 }