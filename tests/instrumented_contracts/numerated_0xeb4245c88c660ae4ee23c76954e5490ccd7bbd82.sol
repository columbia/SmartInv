1 pragma solidity ^0.4.15;
2 
3 /**
4  *
5  * @author  David Rosen <kaandoit@mcon.org>
6  *
7  * Version A
8  *
9  * Overview:
10  * This divides all incoming funds among various `activity` accounts. The division cannot be changed
11  * after the contract is locked.
12  */
13 
14 
15 // --------------------------
16 //  R Split Contract
17 // --------------------------
18 contract OrganizeFunds {
19 
20   struct ActivityAccount {
21     uint credited;   // total funds credited to this account
22     uint balance;    // current balance = credited - amount withdrawn
23     uint pctx10;     // percent allocation times ten
24     address addr;    // payout addr of this acct
25   }
26 
27   uint constant TENHUNDWEI = 1000;                     // need gt. 1000 wei to distribute
28   uint constant MAX_ACCOUNTS = 10;                     // max accounts this contract can handle
29 
30   event MessageEvent(string message);
31   event MessageEventI(string message, uint val);
32 
33 
34   bool public isLocked;
35   address public owner;                                // deployer executor
36   mapping (uint => ActivityAccount) activityAccounts;  // accounts by index
37   uint public activityCount;                           // how many activity accounts
38   uint public totalFundsReceived;                      // amount received since begin of time
39   uint public totalFundsDistributed;                   // amount distributed since begin of time
40   uint public totalFundsWithdrawn;                     // amount withdrawn since begin of time
41   uint public withdrawGas = 100000;                    // gas for withdrawals
42 
43 
44   modifier ownerOnly {
45     require(msg.sender == owner);
46     _;
47   }
48 
49   modifier unlockedOnly {
50     require(!isLocked);
51     _;
52   }
53 
54 
55 
56   //
57   // constructor
58   //
59   function OrganizeFunds() {
60     owner = msg.sender;
61   }
62 
63   function lock() public ownerOnly {
64     isLocked = true;
65   }
66 
67 
68   //
69   // reset
70   // reset all accounts
71   // in case we have any funds that have not been withdrawn, they become  newly received and undistributed.
72   //
73   function reset() public ownerOnly unlockedOnly {
74     totalFundsReceived = this.balance;
75     totalFundsDistributed = 0;
76     totalFundsWithdrawn = 0;
77     activityCount = 0;
78     MessageEvent("ok: all accts reset");
79   }
80 
81 
82   //
83   // set withdrawal gas
84   // nonstandard gas is necessary to support push-withdrawals to other contract
85   //
86   function setWitdrawGas(uint256 _withdrawGas) public ownerOnly unlockedOnly {
87     withdrawGas = _withdrawGas;
88     MessageEventI("ok: withdraw gas set", withdrawGas);
89   }
90 
91 
92   //
93   // add a new account
94   //
95   function addAccount(address _addr, uint256 _pctx10) public ownerOnly unlockedOnly {
96     if (activityCount >= MAX_ACCOUNTS) {
97       MessageEvent("err: max accounts");
98       return;
99     }
100     activityAccounts[activityCount].addr = _addr;
101     activityAccounts[activityCount].pctx10 = _pctx10;
102     activityAccounts[activityCount].credited = 0;
103     activityAccounts[activityCount].balance = 0;
104     ++activityCount;
105     MessageEvent("ok: acct added");
106   }
107 
108 
109   // ----------------------------
110   // get acct info
111   // ----------------------------
112   function getAccountInfo(address _addr) public constant returns(uint _idx, uint _pctx10, uint _credited, uint _balance) {
113     for (uint i = 0; i < activityCount; i++ ) {
114       address addr = activityAccounts[i].addr;
115       if (addr == _addr) {
116         _idx = i;
117         _pctx10 = activityAccounts[i].pctx10;
118         _credited = activityAccounts[i].credited;
119         _balance = activityAccounts[i].balance;
120         return;
121       }
122     }
123   }
124 
125 
126   //
127   // get total percentages x10
128   //
129   function getTotalPctx10() public constant returns(uint _totalPctx10) {
130     _totalPctx10 = 0;
131     for (uint i = 0; i < activityCount; i++ ) {
132       _totalPctx10 += activityAccounts[i].pctx10;
133     }
134   }
135 
136 
137   //
138   // default payable function.
139   // call us with plenty of gas, or catastrophe will ensue
140   //
141   function () payable {
142     totalFundsReceived += msg.value;
143     MessageEventI("ok: received", msg.value);
144   }
145 
146 
147   //
148   // distribute funds to all activities
149   //
150   function distribute() public {
151     //only payout if we have more than 1000 wei
152     if (this.balance < TENHUNDWEI) {
153       return;
154     }
155     //each account gets their prescribed percentage of this holdover.
156     uint i;
157     uint pctx10;
158     uint acctDist;
159     for (i = 0; i < activityCount; i++ ) {
160       pctx10 = activityAccounts[i].pctx10;
161       acctDist = totalFundsReceived * pctx10 / TENHUNDWEI;
162       //we also double check to ensure that the amount credited cannot exceed the total amount due to this acct
163       if (activityAccounts[i].credited >= acctDist) {
164         acctDist = 0;
165       } else {
166         acctDist = acctDist - activityAccounts[i].credited;
167       }
168       activityAccounts[i].credited += acctDist;
169       activityAccounts[i].balance += acctDist;
170       totalFundsDistributed += acctDist;
171     }
172     MessageEvent("ok: distributed funds");
173   }
174 
175 
176   //
177   // withdraw actvity balance
178   // can be called by owner to push funds to another contract
179   //
180   function withdraw() public {
181     for (uint i = 0; i < activityCount; i++ ) {
182       address addr = activityAccounts[i].addr;
183       if (addr == msg.sender || msg.sender == owner) {
184         uint amount = activityAccounts[i].balance;
185         if (amount > 0) {
186           activityAccounts[i].balance = 0;
187           totalFundsWithdrawn += amount;
188           if (!addr.call.gas(withdrawGas).value(amount)()) {
189             //put back funds in case of err
190             activityAccounts[i].balance = amount;
191             totalFundsWithdrawn -= amount;
192             MessageEvent("err: error sending funds");
193             return;
194           }
195         }
196       }
197     }
198   }
199 
200 
201   //
202   // suicide
203   //
204   function hariKari() public ownerOnly unlockedOnly {
205     selfdestruct(owner);
206   }
207 
208 }