1 //StrongCapital v1.2.2
2 
3 
4 
5 pragma solidity ^0.4.24;
6 
7 
8 contract Capital {
9   uint constant public CASH_BACK_PERCENT = 3;
10   uint constant public PROJECT_FEE_PERCENT = 20;
11   uint constant public PER_BLOCK = 48;
12   uint constant public MINIMUM_INVEST = 10000000000000000 wei;
13   uint public wave;
14   
15   address public owner;
16   address public admin;
17   address[] public addresses;
18 
19   bool public pause;
20 
21   mapping(address => Investor) public investors;
22   TheStrongest public boss;
23   
24   modifier onlyOwner {
25     require(owner == msg.sender);
26     _;
27   }
28 
29   struct Investor {
30     uint ID;
31     uint deposit;
32     uint depositCount;
33     uint blockNumber;
34     address referrer;
35   }
36 
37   struct TheStrongest {
38     address addr;
39     uint deposit;
40   }
41 
42   constructor () public {
43     owner = msg.sender;
44     admin = msg.sender;
45     addresses.length = 1;
46     wave = 1;
47   }
48 
49   function() payable public {
50     if(owner == msg.sender){
51       return;
52     }
53 
54     require(pause == false);
55     require(msg.value == 0 || msg.value >= MINIMUM_INVEST);
56 
57     Investor storage user = investors[msg.sender];
58     
59     if(user.ID == 0){
60       msg.sender.transfer(0 wei);
61       user.ID = addresses.push(msg.sender);
62 
63       address referrer = bytesToAddress(msg.data);
64       if (investors[referrer].deposit > 0 && referrer != msg.sender) {
65         user.referrer = referrer;
66       }
67     }
68 
69     if(user.deposit != 0) {
70       uint amount = getInvestorDividendsAmount(msg.sender);
71       if(address(this).balance < amount){
72         pause = true;
73         return;
74       }
75 
76       msg.sender.transfer(amount);
77     }
78 
79     admin.transfer(msg.value * PROJECT_FEE_PERCENT / 100);
80 
81     user.deposit += msg.value;
82     user.depositCount += 1;
83     user.blockNumber = block.number;
84 
85     uint bonusAmount = msg.value * CASH_BACK_PERCENT / 100;
86 
87     if (user.referrer != 0x0) {
88       user.referrer.transfer(bonusAmount);
89       if (user.depositCount == 1) {
90         msg.sender.transfer(bonusAmount);
91       }
92     } else if (boss.addr > 0x0) {
93       if(msg.sender != boss.addr){
94         if(user.deposit < boss.deposit){
95           boss.addr.transfer(bonusAmount);
96         }
97       }
98     }
99 
100     if(user.deposit > boss.deposit) {
101       boss = TheStrongest(msg.sender, user.deposit);
102     }
103   }
104 
105   function getInvestorCount() public view returns (uint) {
106     return addresses.length - 1;
107   }
108 
109   function getInvestorDividendsAmount(address addr) public view returns (uint) {
110     uint amount = ((investors[addr].deposit * ((block.number - investors[addr].blockNumber) * PER_BLOCK)) / 10000000);
111     return amount;
112   }
113 
114   function Restart() private {
115     address addr;
116 
117     for (uint256 i = addresses.length - 1; i > 0; i--) {
118       addr = addresses[i];
119       addresses.length -= 1;
120       delete investors[addr];
121     }
122 
123     pause = false;
124     wave += 1;
125 
126     delete boss;
127   }
128 
129   function payout() public {
130     if (pause) {
131       Restart();
132       return;
133     }
134 
135     uint amount;
136 
137     for(uint256 i = addresses.length - 1; i >= 1; i--){
138       address addr = addresses[i];
139 
140       amount = getInvestorDividendsAmount(addr);
141       investors[addr].blockNumber = block.number;
142 
143       if (address(this).balance < amount) {
144         pause = true;
145         return;
146       }
147 
148       addr.transfer(amount);
149     }
150   }
151   
152   function transferOwnership(address addr) onlyOwner public {
153     owner = addr;
154   }
155 
156   function bytesToAddress(bytes bys) private pure returns (address addr) {
157     assembly {
158       addr := mload(add(bys, 20))
159     }
160   }
161 }