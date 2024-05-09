1 pragma solidity 0.4.19;
2 
3 // File: contracts\MultiOwnable.sol
4 
5 /**
6  * FEATURE 2): MultiOwnable implementation
7  * Transactions approved by _multiRequires of _multiOwners' addresses will be executed. 
8 
9  * All functions needing unit-tests cannot be INTERNAL
10  */
11 contract MultiOwnable {
12 
13     address[8] m_owners;
14     uint m_numOwners;
15     uint m_multiRequires;
16 
17     mapping (bytes32 => uint) internal m_pendings;
18 
19     event AcceptConfirm(bytes32 operation, address indexed who, uint confirmTotal);
20     
21     // constructor is given number of sigs required to do protected "multiOwner" transactions
22     function MultiOwnable (address[] _multiOwners, uint _multiRequires) public {
23         require(0 < _multiRequires && _multiRequires <= _multiOwners.length);
24         m_numOwners = _multiOwners.length;
25         require(m_numOwners <= 8);   // Bigger then 8 co-owners, not support !
26         for (uint i = 0; i < _multiOwners.length; ++i) {
27             m_owners[i] = _multiOwners[i];
28             require(m_owners[i] != address(0));
29         }
30         m_multiRequires = _multiRequires;
31     }
32 
33     // Any one of the owners, will approve the action
34     modifier anyOwner {
35         if (isOwner(msg.sender)) {
36             _;
37         }
38     }
39 
40     // Requiring num > m_multiRequires owners, to approve the action
41     modifier mostOwner(bytes32 operation) {
42         if (checkAndConfirm(msg.sender, operation)) {
43             _;
44         }
45     }
46 
47     function isOwner(address currentUser) public view returns (bool) {
48         for (uint i = 0; i < m_numOwners; ++i) {
49             if (m_owners[i] == currentUser) {
50                 return true;
51             }
52         }
53         return false;
54     }
55 
56     function checkAndConfirm(address currentUser, bytes32 operation) public returns (bool) {
57         uint ownerIndex = m_numOwners;
58         uint i;
59         for (i = 0; i < m_numOwners; ++i) {
60             if (m_owners[i] == currentUser) {
61                 ownerIndex = i;
62             }
63         }
64         if (ownerIndex == m_numOwners) {
65             return false;  // Not Owner
66         }
67         
68         uint newBitFinger = (m_pendings[operation] | (2 ** ownerIndex));
69 
70         uint confirmTotal = 0;
71         for (i = 0; i < m_numOwners; ++i) {
72             if ((newBitFinger & (2 ** i)) > 0) {
73                 confirmTotal ++;
74             }
75         }
76         
77         AcceptConfirm(operation, currentUser, confirmTotal);
78 
79         if (confirmTotal >= m_multiRequires) {
80             delete m_pendings[operation];
81             return true;
82         }
83         else {
84             m_pendings[operation] = newBitFinger;
85             return false;
86         }
87     }
88 }
89 
90 // File: contracts\Pausable.sol
91 
92 /**
93  * FEATURE 3): Pausable implementation
94  */
95 contract Pausable is MultiOwnable {
96     event Pause();
97     event Unpause();
98 
99     bool paused = false;
100 
101     // Modifier to make a function callable only when the contract is not paused.
102     modifier whenNotPaused() {
103         require(!paused);
104         _;
105     }
106 
107     // Modifier to make a function callable only when the contract is paused.
108     modifier whenPaused() {
109         require(paused);
110         _;
111     }
112 
113     // called by the owner to pause, triggers stopped state
114     function pause() mostOwner(keccak256(msg.data)) whenNotPaused public {
115         paused = true;
116         Pause();
117     }
118 
119     // called by the owner to unpause, returns to normal state
120     function unpause() mostOwner(keccak256(msg.data)) whenPaused public {
121         paused = false;
122         Unpause();
123     }
124 
125     function isPause() view public returns(bool) {
126         return paused;
127     }
128 }
129 
130 // File: contracts\SafeMath.sol
131 
132 /**
133 * Standard SafeMath Library: zeppelin-solidity/contracts/math/SafeMath.sol
134 */
135 library SafeMath {
136     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
137         if (a == 0) {
138             return 0;
139         }
140         uint256 c = a * b;
141         assert(c / a == b);
142         return c;
143     }
144 
145     function div(uint256 a, uint256 b) internal pure returns (uint256) {
146         // assert(b > 0); // Solidity automatically throws when dividing by 0
147         uint256 c = a / b;
148         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
149         return c;
150     }
151 
152     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
153         assert(b <= a);
154         return a - b;
155     }
156 
157     function add(uint256 a, uint256 b) internal pure returns (uint256) {
158         uint256 c = a + b;
159         assert(c >= a);
160         return c;
161     }
162 }
163 
164 // File: contracts\AdvisorGPX.sol
165 
166 /**
167  * The updated body of smart contract.
168  * %6 fund will be transferred to ParcelX advisors automatically. 
169  */
170 contract AdvisorGPX is MultiOwnable, Pausable {
171 
172     using SafeMath for uint256;
173     
174     address internal advisor = 0xd173bdd2f4ccd88b35b83a8bc35dd05a3b5a3c79;
175     uint internal payAdvisorFlag = 0;
176 
177     function AdvisorGPX(address[] _multiOwners, uint _multiRequires) 
178         MultiOwnable(_multiOwners, _multiRequires) public {
179     }
180     
181     event Deposit(address indexed who, uint256 value);
182     event Withdraw(address indexed who, uint256 value, address indexed lastApprover, string extra);
183     event AdviseFee(address advisor, uint256 advfee);
184 
185     function getTime() public view returns (uint256) {
186         return now;
187     }
188 
189     function getBalance() public view returns (uint256) {
190         return this.balance;
191     }
192     
193     /**
194      * FEATURE : Buyable
195      * minimum of 0.001 ether for purchase in the public, pre-ico, and private sale
196      * Code caculates the endtime via python: 
197      *   d1 = datetime.datetime.strptime("2018-10-31 23:59:59", '%Y-%m-%d %H:%M:%S')
198      *   t = time.mktime(d1.timetuple())
199      *   d2 = datetime.datetime.fromtimestamp(t)
200      *   assert (d1 == d2)  # print d2.strftime('%Y-%m-%d %H:%M:%S')
201      *   print t # = 1541001599
202      */
203     function buy() payable whenNotPaused public returns (bool) {
204         Deposit(msg.sender, msg.value);
205         require(msg.value >= 0.001 ether);
206         
207         // Fee to advisors
208         if (now > 1541001599 && payAdvisorFlag == 0) {
209             payAdvisorFlag = payAdvisorFlag + 1;
210             uint256 advfee = this.balance.div(20) + this.balance.div(100);  // = 6.0 %, Not float in Solidity, So use INT/div to approach. 
211             if (advfee > 0) {
212                 advisor.transfer(advfee);   // Prevent using call() or send()
213             }
214             AdviseFee(advisor, advfee);
215             return true;
216         }
217         else {
218             return false;
219         }
220     }
221 
222     // gets called when no other function matches
223     function () payable public {
224         if (msg.value > 0) {
225             buy();
226         }
227     }
228 
229     function execute(address _to, uint256 _value, string _extra) mostOwner(keccak256(msg.data)) external returns (bool){
230         require(_to != address(0));
231         _to.transfer(_value);   // Prevent using call() or send()
232         Withdraw(_to, _value, msg.sender, _extra);
233         return true;
234     }
235 
236 }