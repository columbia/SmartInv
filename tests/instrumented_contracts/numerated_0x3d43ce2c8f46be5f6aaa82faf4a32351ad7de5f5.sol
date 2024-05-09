1 pragma solidity ^0.4.13;
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
41   event TransferFrom(address indexed _from, address indexed _to,  address indexed _spender, uint256 _amount);
42   event Issue(address indexed _from, address indexed _to, uint256 _amount, string _proofId);
43   event Burn(address indexed _burnFrom, uint256 _amount);
44   event Close(address indexed _closedBy);
45   event Upgrade(address indexed _upgradedContract);
46   event LockOpen(address indexed _by);
47   event LockContractOwner(address indexed _by);
48   event TransferContractOwnership(address indexed _by, address indexed _to);
49   event MaxSupply(address indexed _by, uint256 _newMaxSupply, bool _isMaxSupplyLocked);
50 
51   function DynamicToken() {
52     contractOwner = msg.sender;     // contract owner is contract creator
53     maxSupply = 10**7;
54     totalSupply = 0;
55 
56     isClosed = false;
57     isMaxSupplyLocked = false;
58     isLockedOpen = false;
59     isContractOwnerLocked = false;
60   }
61 
62   // restrict usage to only the owner
63   modifier onlyContractOwner {
64     if (msg.sender != contractOwner) revert();
65     _;
66   }
67 
68   // check if the contract has been closed
69   modifier notClosed {
70     if (isClosed) revert();
71     _;
72   }
73 
74   modifier notLockedOpen {
75     if (isLockedOpen) revert();
76     _;
77   }
78 
79   // no ether should be transferred to this contract
80   modifier noEther() {if (msg.value > 0) revert(); _;}
81 
82   // accessors
83 
84   function getAccounts() noEther constant returns (address[] _accounts) {
85     return accounts;
86   }
87 
88   function balanceOf(address _owner) noEther constant returns(uint256 balance) {
89     return balances[_owner];
90   }
91 
92   function allowance(address _owner, address _spender) noEther constant returns (uint256 remaining) {
93     return allowed[_owner][_spender];
94   }
95 
96   // TOKEN MUTATORS
97 
98   // tokens are only issued in exchange for a unique proof of contribution
99   function issue(address _to, uint256 _amount, string _proofId) notClosed onlyContractOwner noEther returns (bool success) {
100     if (balances[_to] + _amount < balances[_to]) revert(); // Guard against overflow
101     if (totalSupply + _amount < totalSupply) revert();     // Guard against overflow  (this should never happen)
102 
103     if (proofIdExists[_proofId]) return false;
104     if (totalSupply + _amount > maxSupply) return false;
105 
106     balances[_to] += _amount;
107     totalSupply += _amount;
108     _indexAccount(_to);
109     _indexProofId(_proofId);
110     Issue(msg.sender, _to, _amount, _proofId);
111     return true;
112   }
113 
114   function setMaxSupply(uint256 _maxSupply) notClosed onlyContractOwner noEther returns (bool success) {
115     if (_maxSupply < totalSupply) revert();
116     if (isMaxSupplyLocked) return false;
117 
118     maxSupply = _maxSupply;
119     MaxSupply(msg.sender, _maxSupply, isMaxSupplyLocked);
120     return true;
121   }
122 
123   // lock the maxSupply to its current value forever
124   function lockMaxSupply() notClosed onlyContractOwner noEther returns(bool success) {
125     isMaxSupplyLocked = true;
126     MaxSupply(msg.sender, maxSupply, isMaxSupplyLocked);
127     return true;
128   }
129 
130   function transfer(address _to, uint256 _amount) notClosed noEther returns (bool success) {
131     return _transfer(msg.sender, _to, _amount);
132   }
133 
134   function approve(address _spender, uint256 _amount) notClosed noEther returns (bool success) {
135     allowed[msg.sender][_spender] = _amount;
136     Approval(msg.sender, _spender, _amount);
137     return true;
138   }
139 
140   function transferFrom(address _from, address _to, uint256 _amount) notClosed noEther returns (bool success) {
141     if (_amount > allowed[_from][msg.sender]) return false;
142 
143     if (allowed[_from][msg.sender] - _amount > allowed[_from][msg.sender]) revert();  // Guard against underflow
144 
145     if (_transfer(_from, _to, _amount)) {
146       allowed[_from][msg.sender] -= _amount;
147       TransferFrom(_from, _to, msg.sender, _amount);
148       return true;
149     } else {
150       return false;
151     }
152   }
153 
154   function burn(uint256 _amount) notClosed noEther returns (bool success) {
155     if (_amount > balances[msg.sender]) return false;
156 
157     if (_amount > totalSupply) revert();
158     if (balances[msg.sender] - _amount > balances[msg.sender]) revert();     // Guard against underflow
159     if (totalSupply - _amount > totalSupply) revert();                     // Guard against underflow
160 
161     balances[msg.sender] -= _amount;
162     totalSupply -= _amount;
163     Burn(msg.sender, _amount);
164     return true;
165   }
166 
167   // CONTRACT MUTATORS
168 
169   // Lock the contract owner forever
170   function lockContractOwner() notClosed onlyContractOwner noEther returns(bool success) {
171     isContractOwnerLocked = true;
172     LockContractOwner(msg.sender);
173     return true;
174   }
175 
176   function transferContractOwnership(address _newOwner) notClosed onlyContractOwner noEther returns (bool success) {
177     if(isContractOwnerLocked) revert();
178 
179     contractOwner = _newOwner;
180     TransferContractOwnership(msg.sender, _newOwner);
181     return true;
182   }
183 
184   // Block the contract from ever being upgraded, closed, or destroyed
185   function lockOpen() notClosed onlyContractOwner noEther returns (bool success) {
186     isLockedOpen = true;
187     LockOpen(msg.sender);
188     return true;
189   }
190 
191   function upgrade(address _upgradedContract) notLockedOpen notClosed onlyContractOwner noEther returns (bool success) {
192     upgradedContract = _upgradedContract;
193     close();
194     Upgrade(_upgradedContract);
195     return true;
196   }
197 
198   function close() notLockedOpen notClosed onlyContractOwner noEther returns (bool success) {
199     isClosed = true;
200     Close(msg.sender);
201     return true;
202   }
203 
204   function destroyContract() notLockedOpen onlyContractOwner noEther {
205     selfdestruct(contractOwner);
206   }
207 
208   // PRIVATE MUTATORS
209 
210   function _transfer(address _from, address _to, uint256 _amount) notClosed private returns (bool success) {
211     if (_amount > balances[_from]) return false;
212 
213     if (balances[_to] + _amount < balances[_to]) revert();      // Guard against overflow
214     if (balances[_from] - _amount > balances[_from]) revert();  // Guard against underflow
215 
216     balances[_to] += _amount;
217     balances[_from] -= _amount;
218     _indexAccount(_to);
219     Transfer(_from, _to, _amount);
220     return true;
221   }
222 
223   function _indexAccount(address _account) notClosed private returns (bool success) {
224     if (accountExists[_account]) return;
225     accountExists[_account] = true;
226     accounts.push(_account);
227     return true;
228   }
229 
230   function _indexProofId(string _proofId) notClosed private returns (bool success) {
231     if (proofIdExists[_proofId]) return;
232     proofIdExists[_proofId] = true;
233     proofIds.push(_proofId);
234     return true;
235   }
236 
237   // revert() on malformed calls
238   function () {
239     revert();
240   }
241 }