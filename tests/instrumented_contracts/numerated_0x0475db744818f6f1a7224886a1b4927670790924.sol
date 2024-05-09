1 pragma solidity ^0.4.24;
2 /*
3                                                                               
4     //   ) )                                                                  
5    //         __      ___       __      ___   / ( )  ___      ___      ___    
6   //  ____  //  ) ) //   ) ) //   ) ) //   ) / / / //   ) ) ((   ) ) //___) ) 
7  //    / / //      //   / / //   / / //   / / / / //   / /   \ \    //        
8 ((____/ / //      ((___( ( //   / / ((___/ / / / ((___/ / //   ) ) ((____   
9 
10 http://Grandiose.tech
11 
12 */
13 
14 contract Grandiose {
15     address public owner;
16     address public adminAddr;
17     uint constant public MASS_TRANSACTION_LIMIT = 150;
18     uint constant public MINIMUM_INVEST = 10000000000000000 wei;
19     uint constant public INTEREST = 4;
20     uint public depositAmount;
21     uint public round;
22     uint public lastPaymentDate;
23     GorgonaKiller public gorgonaKiller;
24     address[] public addresses;
25     mapping(address => Investor) public investors;
26     bool public pause;
27 
28     struct Investor
29     {
30         uint id;
31         uint deposit;
32         uint deposits;
33         uint date;
34         address referrer;
35     }
36 
37     struct GorgonaKiller
38     {
39         address addr;
40         uint deposit;
41     }
42 
43     event Invest(address addr, uint amount, address referrer);
44     event Payout(address addr, uint amount, string eventType, address from);
45     event NextRoundStarted(uint round, uint date, uint deposit);
46     event GorgonaKillerChanged(address addr, uint deposit);
47 
48     modifier onlyOwner {if (msg.sender == owner) _;}
49 
50     constructor() public {
51         owner = msg.sender;
52         adminAddr = msg.sender;
53         addresses.length = 1;
54         round = 1;
55     }
56 
57     function transferOwnership(address addr) onlyOwner public {
58         owner = addr;
59     }
60 
61     function addInvestors(address[] _addr, uint[] _deposit, uint[] _date, address[] _referrer) onlyOwner public {
62         // add initiated investors
63         for (uint i = 0; i < _addr.length; i++) {
64             uint id = addresses.length;
65             if (investors[_addr[i]].deposit == 0) {
66                 addresses.push(_addr[i]);
67                 depositAmount += _deposit[i];
68             }
69 
70             investors[_addr[i]] = Investor(id, _deposit[i], 1, _date[i], _referrer[i]);
71             emit Invest(_addr[i], _deposit  [i], _referrer[i]);
72 
73             if (investors[_addr[i]].deposit > gorgonaKiller.deposit) {
74                 gorgonaKiller = GorgonaKiller(_addr[i], investors[_addr[i]].deposit);
75             }
76         }
77         lastPaymentDate = now;
78     }
79 
80     function() payable public {
81         if (owner == msg.sender) {
82             return;
83         }
84 
85         if (0 == msg.value) {
86             payoutSelf();
87             return;
88         }
89 
90         require(false == pause, "Gorgona is restarting. Please wait.");
91         require(msg.value >= MINIMUM_INVEST, "Too small amount, minimum 0.01 ether");
92         Investor storage user = investors[msg.sender];
93 
94         if (user.id == 0) {
95             // ensure that payment not from hacker contract
96             msg.sender.transfer(0 wei);
97             addresses.push(msg.sender);
98             user.id = addresses.length;
99             user.date = now;
100 
101             // referrer
102             address referrer = bytesToAddress(msg.data);
103             if (investors[referrer].deposit > 0 && referrer != msg.sender) {
104                 user.referrer = referrer;
105             }
106         } else {
107             payoutSelf();
108         }
109 
110         // save investor
111         user.deposit += msg.value;
112         user.deposits += 1;
113 
114         emit Invest(msg.sender, msg.value, user.referrer);
115 
116         depositAmount += msg.value;
117         lastPaymentDate = now;
118 
119         adminAddr.transfer(msg.value / 5); // project fee
120         uint bonusAmount = (msg.value / 100) * INTEREST; // referrer commission for all deposits
121 
122         if (user.referrer > 0x0) {
123             if (user.referrer.send(bonusAmount)) {
124                 emit Payout(user.referrer, bonusAmount, "referral", msg.sender);
125             }
126 
127             if (user.deposits == 1) { // cashback only for the first deposit
128                 if (msg.sender.send(bonusAmount)) {
129                     emit Payout(msg.sender, bonusAmount, "cash-back", 0);
130                 }
131             }
132         } else if (gorgonaKiller.addr > 0x0) {
133             if (gorgonaKiller.addr.send(bonusAmount)) {
134                 emit Payout(gorgonaKiller.addr, bonusAmount, "killer", msg.sender);
135             }
136         }
137 
138         if (user.deposit > gorgonaKiller.deposit) {
139             gorgonaKiller = GorgonaKiller(msg.sender, user.deposit);
140             emit GorgonaKillerChanged(msg.sender, user.deposit);
141         }
142     }
143 
144     function payout(uint offset) public
145     {
146         if (pause == true) {
147             doRestart();
148             return;
149         }
150 
151         uint txs;
152         uint amount;
153 
154         for (uint idx = addresses.length - offset - 1; idx >= 1 && txs < MASS_TRANSACTION_LIMIT; idx--) {
155             address addr = addresses[idx];
156             if (investors[addr].date + 20 hours > now) {
157                 continue;
158             }
159 
160             amount = getInvestorDividendsAmount(addr);
161             investors[addr].date = now;
162 
163             if (address(this).balance < amount) {
164                 pause = true;
165                 return;
166             }
167 
168             if (addr.send(amount)) {
169                 emit Payout(addr, amount, "bulk-payout", 0);
170             }
171 
172             txs++;
173         }
174     }
175 
176     function payoutSelf() private {
177         require(investors[msg.sender].id > 0, "Investor not found.");
178         uint amount = getInvestorDividendsAmount(msg.sender);
179 
180         investors[msg.sender].date = now;
181         if (address(this).balance < amount) {
182             pause = true;
183             return;
184         }
185 
186         msg.sender.transfer(amount);
187         emit Payout(msg.sender, amount, "self-payout", 0);
188     }
189 
190     function doRestart() private {
191         uint txs;
192         address addr;
193 
194         for (uint i = addresses.length - 1; i > 0; i--) {
195             addr = addresses[i];
196             addresses.length -= 1;
197             delete investors[addr];
198             if (txs++ == MASS_TRANSACTION_LIMIT) {
199                 return;
200             }
201         }
202 
203         emit NextRoundStarted(round, now, depositAmount);
204         pause = false;
205         round += 1;
206         depositAmount = 0;
207         lastPaymentDate = now;
208 
209         delete gorgonaKiller;
210     }
211 
212     function getInvestorCount() public view returns (uint) {
213         return addresses.length - 1;
214     }
215 
216     function getInvestorDividendsAmount(address addr) public view returns (uint) {
217         return investors[addr].deposit / 100 * INTEREST * (now - investors[addr].date) / 1 days;
218     }
219 
220     function bytesToAddress(bytes bys) private pure returns (address addr) {
221         assembly {
222             addr := mload(add(bys, 20))
223         }
224     }
225 }