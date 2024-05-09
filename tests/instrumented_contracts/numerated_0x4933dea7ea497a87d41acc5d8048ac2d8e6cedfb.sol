1 pragma solidity ^0.4.18;
2 
3 /**
4  *
5  * Version: C
6  * @author  Pratyush Bhatt <MysticMonsoon@protonmail.com>
7  *
8  * Overview:
9  * Divides all incoming funds among various `activity` accounts. The division cannot be changed
10  * after the contract is locked.
11  */
12 
13 contract OrganizeFunds {
14 
15   struct ActivityAccount {
16     uint credited;   // total funds credited to this account
17     uint balance;    // current balance = credited - amount withdrawn
18     uint pctx10;     // percent allocation times ten
19     address addr;    // payout addr of this acct
20     string name;
21   }
22 
23   uint constant TENHUNDWEI = 1000;                     // need gt. 1000 wei to distribute
24   uint constant MAX_ACCOUNTS = 10;                     // max accounts this contract can handle
25 
26   event MessageEvent(string message);
27   event MessageEventI(string message, uint val);
28 
29 
30   bool public isLocked;
31   string public name;
32   address public owner;                                // deployer executor
33   mapping (uint => ActivityAccount) activityAccounts;  // accounts by index
34   uint public activityCount;                           // how many activity accounts
35   uint public totalFundsReceived;                      // amount received since begin of time
36   uint public totalFundsDistributed;                   // amount distributed since begin of time
37   uint public totalFundsWithdrawn;                     // amount withdrawn since begin of time
38   uint public withdrawGas = 100000;                    // gas for withdrawals
39 
40   modifier ownerOnly {
41     require(msg.sender == owner);
42     _;
43   }
44 
45   modifier unlockedOnly {
46     require(!isLocked);
47     _;
48   }
49 
50 
51 
52   //
53   // constructor
54   //
55   function OrganizeFunds() public {
56     owner = msg.sender;
57   }
58 
59   function lock() public ownerOnly {
60     isLocked = true;
61   }
62 
63   function setName(string _name) public ownerOnly {
64     name = _name;
65   }
66 
67   //
68   // reset
69   // reset all activity accounts
70   // in case we have any funds that have not been withdrawn, they become  newly received and undistributed.
71   //
72   function reset() public ownerOnly unlockedOnly {
73     totalFundsReceived = this.balance;
74     totalFundsDistributed = 0;
75     totalFundsWithdrawn = 0;
76     activityCount = 0;
77     MessageEvent("ok: all accts reset");
78   }
79 
80 
81   //
82   // set withdrawal gas
83   // nonstandard gas is necessary to support push-withdrawals to other contract
84   //
85   function setWitdrawGas(uint256 _withdrawGas) public ownerOnly {
86     withdrawGas = _withdrawGas;
87     MessageEventI("ok: withdraw gas set", withdrawGas);
88   }
89 
90 
91   //
92   // add a new activity account
93   //
94   function addActivityAccount(address _addr, uint256 _pctx10, string _name) public ownerOnly unlockedOnly {
95     if (activityCount >= MAX_ACCOUNTS) {
96       MessageEvent("err: max accounts");
97       return;
98     }
99     activityAccounts[activityCount].addr = _addr;
100     activityAccounts[activityCount].pctx10 = _pctx10;
101     activityAccounts[activityCount].credited = 0;
102     activityAccounts[activityCount].balance = 0;
103     activityAccounts[activityCount].name = _name;
104     ++activityCount;
105     MessageEvent("ok: acct added");
106   }
107 
108 
109   // ----------------------------
110   // get acct info
111   // ----------------------------
112   function getActivityAccountInfo(address _addr) public constant returns(uint _idx, uint _pctx10, string _name, uint _credited, uint _balance) {
113     for (uint i = 0; i < activityCount; i++ ) {
114       address addr = activityAccounts[i].addr;
115       if (addr == _addr) {
116         _idx = i;
117         _pctx10 = activityAccounts[i].pctx10;
118         _name = activityAccounts[i].name;
119         _credited = activityAccounts[i].credited;
120         _balance = activityAccounts[i].balance;
121         return;
122       }
123     }
124   }
125 
126 
127   //
128   // get total percentages x10
129   //
130   function getTotalPctx10() public constant returns(uint _totalPctx10) {
131     _totalPctx10 = 0;
132     for (uint i = 0; i < activityCount; i++ ) {
133       _totalPctx10 += activityAccounts[i].pctx10;
134     }
135   }
136 
137 
138   //
139   // default payable function.
140   // call us with plenty of gas, or catastrophe will ensue
141   //
142   function () public payable {
143     totalFundsReceived += msg.value;
144     MessageEventI("ok: received", msg.value);
145   }
146 
147 
148   //
149   // distribute funds to all activities
150   //
151   function distribute() public {
152     //only payout if we have more than 1000 wei
153     if (this.balance < TENHUNDWEI) {
154       return;
155     }
156     //each account gets their prescribed percentage of this holdover.
157     uint i;
158     uint pctx10;
159     uint acctDist;
160     for (i = 0; i < activityCount; i++ ) {
161       pctx10 = activityAccounts[i].pctx10;
162       acctDist = totalFundsReceived * pctx10 / TENHUNDWEI;
163       //we also double check to ensure that the amount credited cannot exceed the total amount due to this acct
164       if (activityAccounts[i].credited >= acctDist) {
165         acctDist = 0;
166       } else {
167         acctDist = acctDist - activityAccounts[i].credited;
168       }
169       activityAccounts[i].credited += acctDist;
170       activityAccounts[i].balance += acctDist;
171       totalFundsDistributed += acctDist;
172     }
173     MessageEvent("ok: distributed funds");
174   }
175 
176 
177   //
178   // withdraw actvity balance
179   // can be called by owner to push funds to another contract
180   //
181   function withdraw() public {
182     for (uint i = 0; i < activityCount; i++ ) {
183       address addr = activityAccounts[i].addr;
184       if (addr == msg.sender || msg.sender == owner) {
185         uint amount = activityAccounts[i].balance;
186         if (amount > 0) {
187           activityAccounts[i].balance = 0;
188           totalFundsWithdrawn += amount;
189           if (!addr.call.gas(withdrawGas).value(amount)()) {
190             //put back funds in case of err
191             activityAccounts[i].balance = amount;
192             totalFundsWithdrawn -= amount;
193             MessageEvent("err: error sending funds");
194             return;
195           }
196         }
197       }
198     }
199   }
200 
201 
202   //
203   // suicide
204   //
205   function hariKari() public ownerOnly unlockedOnly {
206     selfdestruct(owner);
207   }
208 
209 }