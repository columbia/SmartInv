1 pragma solidity ^0.4.15;
2 
3 contract TokenInterface {
4     mapping (address => uint256) balances;
5     mapping (address => mapping (address => uint256)) allowed;
6     uint256 public totalSupply;
7     function balanceOf(address _owner) constant returns (uint256 balance);
8     function transfer(address _to, uint256 _amount) returns (bool success);
9     function transferFrom(address _from, address _to, uint256 _amount) returns (bool success);
10     function approve(address _spender, uint256 _amount) returns (bool success);
11     function allowance(
12         address _owner,
13         address _spender
14     ) constant returns (uint256 remaining);
15 
16     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
17     event Approval(
18         address indexed _owner,
19         address indexed _spender,
20         uint256 _amount
21     );
22 }
23 
24 contract DynamicToken is TokenInterface {
25   bool public isClosed;
26   bool public isMaxSupplyLocked;
27   bool public isLockedOpen;
28   bool public isContractOwnerLocked;
29 
30   uint256 public maxSupply;
31 
32   address public upgradedContract;
33   address public contractOwner;
34   address[] public accounts;
35 
36   string[] public proofIds;
37 
38   mapping (address => bool) public accountExists;
39   mapping (string => bool) proofIdExists;
40 
41   string public name;
42   string public symbol;
43   uint8 public constant decimals = 0;
44 
45   event TransferFrom(address indexed _from, address indexed _to,  address indexed _spender, uint256 _amount);
46   event Burn(address indexed _burnFrom, uint256 _amount);
47   event Close(address indexed _closedBy);
48   event Upgrade(address indexed _upgradedContract);
49   event LockOpen(address indexed _by);
50   event LockContractOwner(address indexed _by);
51   event TransferContractOwnership(address indexed _by, address indexed _to);
52   event MaxSupply(address indexed _by, uint256 _newMaxSupply, bool _isMaxSupplyLocked);
53 
54   function DynamicToken() {
55     contractOwner = msg.sender;     // contract owner is contract creator
56     maxSupply = 10**7;
57     totalSupply = 0;
58 
59     isClosed = false;
60     isMaxSupplyLocked = false;
61     isLockedOpen = false;
62     isContractOwnerLocked = false;
63     name = "Vevue Pre";
64     symbol = "VEVP";
65   }
66 
67   // restrict usage to only the owner
68   modifier onlyContractOwner {
69     if (msg.sender != contractOwner) revert();
70     _;
71   }
72 
73   // check if the contract has been closed
74   modifier notClosed {
75     if (isClosed) revert();
76     _;
77   }
78 
79   modifier notLockedOpen {
80     if (isLockedOpen) revert();
81     _;
82   }
83 
84   // no ether should be transferred to this contract
85   modifier noEther() {if (msg.value > 0) revert(); _;}
86 
87   // accessors
88 
89   function getAccounts() noEther constant returns (address[] _accounts) {
90     return accounts;
91   }
92 
93   function balanceOf(address _owner) noEther constant returns(uint256 balance) {
94     return balances[_owner];
95   }
96 
97   function allowance(address _owner, address _spender) noEther constant returns (uint256 remaining) {
98     return allowed[_owner][_spender];
99   }
100 
101   // TOKEN MUTATORS
102 
103   // tokens are only issued in exchange for a unique proof of contribution
104   function issue(address _to, uint256 _amount, string _proofId) notClosed onlyContractOwner noEther returns (bool success) {
105     if (balances[_to] + _amount < balances[_to]) revert(); // Guard against overflow
106     if (totalSupply + _amount < totalSupply) revert();     // Guard against overflow  (this should never happen)
107 
108     if (proofIdExists[_proofId]) return false;
109     if (totalSupply + _amount > maxSupply) return false;
110 
111     balances[msg.sender] += _amount;
112     totalSupply += _amount;
113 
114     transfer(_to, _amount);
115     _indexAccount(_to);
116     _indexProofId(_proofId);
117     return true;
118   }
119 
120   function setMaxSupply(uint256 _maxSupply) notClosed onlyContractOwner noEther returns (bool success) {
121     if (_maxSupply < totalSupply) revert();
122     if (isMaxSupplyLocked) return false;
123 
124     maxSupply = _maxSupply;
125     MaxSupply(msg.sender, _maxSupply, isMaxSupplyLocked);
126     return true;
127   }
128 
129   // lock the maxSupply to its current value forever
130   function lockMaxSupply() notClosed onlyContractOwner noEther returns(bool success) {
131     isMaxSupplyLocked = true;
132     MaxSupply(msg.sender, maxSupply, isMaxSupplyLocked);
133     return true;
134   }
135 
136   function transfer(address _to, uint256 _amount) notClosed noEther returns (bool success) {
137     return _transfer(msg.sender, _to, _amount);
138   }
139 
140   function approve(address _spender, uint256 _amount) notClosed noEther returns (bool success) {
141     allowed[msg.sender][_spender] = _amount;
142     Approval(msg.sender, _spender, _amount);
143     return true;
144   }
145 
146   function transferFrom(address _from, address _to, uint256 _amount) notClosed noEther returns (bool success) {
147     if (_amount > allowed[_from][msg.sender]) return false;
148 
149     if (allowed[_from][msg.sender] - _amount > allowed[_from][msg.sender]) revert();  // Guard against underflow
150 
151     if (_transfer(_from, _to, _amount)) {
152       allowed[_from][msg.sender] -= _amount;
153       TransferFrom(_from, _to, msg.sender, _amount);
154       return true;
155     } else {
156       return false;
157     }
158   }
159 
160   function burn(uint256 _amount) notClosed noEther returns (bool success) {
161     if (_amount > balances[msg.sender]) return false;
162 
163     if (_amount > totalSupply) revert();
164     if (balances[msg.sender] - _amount > balances[msg.sender]) revert();     // Guard against underflow
165     if (totalSupply - _amount > totalSupply) revert();                     // Guard against underflow
166 
167     balances[msg.sender] -= _amount;
168     totalSupply -= _amount;
169     Burn(msg.sender, _amount);
170     return true;
171   }
172 
173   // CONTRACT MUTATORS
174 
175   // Lock the contract owner forever
176   function lockContractOwner() notClosed onlyContractOwner noEther returns(bool success) {
177     isContractOwnerLocked = true;
178     LockContractOwner(msg.sender);
179     return true;
180   }
181 
182   function transferContractOwnership(address _newOwner) notClosed onlyContractOwner noEther returns (bool success) {
183     if(isContractOwnerLocked) revert();
184 
185     contractOwner = _newOwner;
186     TransferContractOwnership(msg.sender, _newOwner);
187     return true;
188   }
189 
190   // Block the contract from ever being upgraded, closed, or destroyed
191   function lockOpen() notClosed onlyContractOwner noEther returns (bool success) {
192     isLockedOpen = true;
193     LockOpen(msg.sender);
194     return true;
195   }
196 
197   function upgrade(address _upgradedContract) notLockedOpen notClosed onlyContractOwner noEther returns (bool success) {
198     upgradedContract = _upgradedContract;
199     close();
200     Upgrade(_upgradedContract);
201     return true;
202   }
203 
204   function close() notLockedOpen notClosed onlyContractOwner noEther returns (bool success) {
205     isClosed = true;
206     Close(msg.sender);
207     return true;
208   }
209 
210   function destroyContract() notLockedOpen onlyContractOwner noEther {
211     selfdestruct(contractOwner);
212   }
213 
214   // PRIVATE MUTATORS
215 
216   function _transfer(address _from, address _to, uint256 _amount) notClosed private returns (bool success) {
217     if (_amount > balances[_from]) return false;
218 
219     if (balances[_to] + _amount < balances[_to]) revert();      // Guard against overflow
220     if (balances[_from] - _amount > balances[_from]) revert();  // Guard against underflow
221 
222     balances[_to] += _amount;
223     balances[_from] -= _amount;
224     _indexAccount(_to);
225     Transfer(_from, _to, _amount);
226     return true;
227   }
228 
229   function _indexAccount(address _account) notClosed private returns (bool success) {
230     if (accountExists[_account]) return;
231     accountExists[_account] = true;
232     accounts.push(_account);
233     return true;
234   }
235 
236   function _indexProofId(string _proofId) notClosed private returns (bool success) {
237     if (proofIdExists[_proofId]) return;
238     proofIdExists[_proofId] = true;
239     proofIds.push(_proofId);
240     return true;
241   }
242 
243   // revert() on malformed calls
244   function () {
245     revert();
246   }
247 }