1 pragma solidity ^0.4.18;
2 library U256 {
3     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
4         if (a == 0) {
5             return 0;
6         }
7         uint256 c = a * b;
8         assert(c / a == b);
9         return c;
10     }
11     function div(uint256 a, uint256 b) internal pure returns (uint256) {
12         uint256 c = a / b;
13         return c;
14     }
15     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16         assert(b <= a);
17         return a - b;
18     }
19     function add(uint256 a, uint256 b) internal pure returns (uint256) {
20         uint256 c = a + b;
21         assert(c >= a);
22         return c;
23     }
24 } 
25 
26 contract Role {
27     address public addrAdmin = msg.sender; 
28     address public addrExecutor = msg.sender; 
29   
30     modifier _rA() {
31         require(msg.sender == addrAdmin);
32         _;
33     } 
34 
35     modifier _rC() {
36         require(msg.sender == addrAdmin || msg.sender == addrExecutor);
37         _;
38     }  
39 
40     function rSetA(address _newAdmin) public _rA {
41         require(_newAdmin != address(0));  
42         addrAdmin = _newAdmin; 
43     }
44 
45     function rSetE(address _newExecutor) public _rA {
46         require(_newExecutor != address(0));  
47         addrExecutor = _newExecutor; 
48     }   
49 
50     function myRole() constant public returns(uint8 _myRole) {
51         _myRole = 0;
52         if (msg.sender == addrAdmin) {
53             _myRole = 1;
54         } else if (msg.sender == addrExecutor) {
55             _myRole = 2;
56         }
57     } 
58 } 
59 
60 contract Fund is Role { 
61     uint funds; 
62 
63     function fundChecking() constant public returns (uint) {
64         return funds;
65     } 
66   
67     function fundWithdraw(address addr, uint value) payable public _rA {
68         require(value <= funds);
69         addr.transfer(value); 
70         funds -= value;
71     }    
72 
73     function fundMark(uint value) internal { 
74         funds += value;
75     }    
76 }
77 
78 contract Cryptoy is Fund {
79     bool public isAlive = true;
80     bool public isRunning = false;
81 
82     modifier gRunning(bool query) {
83         require(query == isRunning);
84         _;
85     } 
86 
87     modifier gAlive(bool query) {
88         require(query == isAlive);
89         _;
90     }  
91 
92     function gSetRunning(bool state) public _rC gRunning(!state) {
93         isRunning = state; 
94     }
95 
96     function gSetAlive(bool state) public _rC gAlive(!state) { 
97         isAlive = state; 
98     }
99 
100     function getSystemAvaliableState() constant public returns(uint8) {
101         if (!isAlive) {
102             return 1;
103         }
104         if (!isRunning) {
105             return 2;
106         } 
107         return 0; 
108     } 
109 }
110 
111 interface INewPrice { 
112     function getNewPrice(uint initial, uint origin) view public returns(uint);
113     function isNewPrice() view public returns(bool);
114 }
115 contract Planet is Cryptoy {
116     using U256 for uint256; 
117 
118     string public version = "1.0.0"; 
119     uint16 public admin_proportion = 200; // 千分位
120 
121     INewPrice public priceCounter;
122 
123     event OnBuy(uint refund);
124 
125     struct Item { 
126         address owner;
127         uint8   round;
128         uint    priceSell;
129         uint    priceOrg;
130         bytes   slogan;
131     }
132     Item[] public items; 
133     
134     function itemCount() view public returns(uint) {
135         return items.length;
136     }
137 
138     function aSetProportion(uint16 prop) _rC public returns(uint) {
139         admin_proportion = prop;
140         return admin_proportion;
141     } 
142 
143     function setNewPriceFuncAddress(address addrFunc) public _rC {
144         INewPrice counter = INewPrice(addrFunc); 
145         require(counter.isNewPrice()); 
146         priceCounter = counter;
147     }
148 
149     function newPrice(uint priceOrg, uint priceSell) view public returns(uint) {
150         return priceCounter.getNewPrice(priceOrg, priceSell);
151     }
152 
153     function realbuy(Item storage item) internal returns(uint finalRefund) {
154         uint total = item.priceSell; 
155         uint fee = total.sub(item.priceOrg).mul(admin_proportion).div(1000);
156         
157         fundMark(fee);
158         finalRefund = total.sub(fee); 
159 
160         item.owner.transfer(finalRefund); 
161         item.owner = msg.sender;
162         item.priceOrg = item.priceSell;
163         item.priceSell = newPrice(item.priceOrg, item.priceSell);
164         item.round = item.round + 1;
165     }
166 
167     function createItem(uint amount, uint priceWei) _rC gAlive(true) public {    
168         for (uint i = 0; i < amount; i ++) {
169             items.push(Item({
170                 owner: msg.sender, 
171                 round: 0,
172                 priceOrg: 0, 
173                 priceSell: priceWei,
174                 slogan: ""
175             }));
176         } 
177     }
178 
179     function buy(uint itemID) payable gAlive(true) gRunning(true) public {
180         address addrBuyer = msg.sender;  
181         require(itemID < items.length); 
182         Item storage item = items[itemID];
183         require(item.owner != addrBuyer);
184         require(item.priceSell == msg.value);
185         OnBuy(realbuy(item));
186     }
187 
188     function setSlogan(uint itemID, bytes slogan) gAlive(true) gRunning(true) public {
189         address addrBuyer = msg.sender; 
190         require(itemID < items.length); 
191         Item storage item = items[itemID];
192         require(addrAdmin == addrBuyer || addrExecutor == addrBuyer || item.owner == addrBuyer);
193         item.slogan = slogan;
194     }
195 }