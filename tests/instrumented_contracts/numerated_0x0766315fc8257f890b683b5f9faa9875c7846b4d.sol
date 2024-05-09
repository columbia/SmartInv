1 pragma solidity ^0.4.10;
2  
3 
4 contract Burner {
5     function burnILF(address , uint ) {}
6 }
7 
8 contract StandardToken {
9 
10     /* *  Data structures */
11     mapping (address => uint256) balances;
12     mapping (address => mapping (address => uint256)) allowed;
13     uint256 public totalSupply;
14 
15     /* *  Events */
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     event Approval(address indexed owner, address indexed spender, uint256 value);
18 
19     /* *  Read and write storage functions */
20     /// @dev Transfers sender's tokens to a given address. Returns success.
21     /// @param _to Address of token receiver.
22     /// @param _value Number of tokens to transfer.
23     function transfer(address _to, uint256 _value) returns (bool success) {
24         if (balances[msg.sender] >= _value && _value > 0) {
25             balances[msg.sender] -= _value;
26             balances[_to] += _value;
27             Transfer(msg.sender, _to, _value);
28             return true;
29         }
30         else {
31             return false;
32         }
33     }
34 
35     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
36     /// @param _from Address from where tokens are withdrawn.
37     /// @param _to Address to where tokens are sent.
38     /// @param _value Number of tokens to transfer.
39     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
40         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
41             balances[_to] += _value;
42             balances[_from] -= _value;
43             allowed[_from][msg.sender] -= _value;
44             Transfer(_from, _to, _value);
45             return true;
46         }
47         else {
48             return false;
49         }
50     }
51 
52     /// @dev Returns number of tokens owned by given address.
53     /// @param _owner Address of token owner.
54     function balanceOf(address _owner) constant returns (uint256 balance) {
55         return balances[_owner];
56     }
57 
58     /// @dev Sets approved amount of tokens for spender. Returns success.
59     /// @param _spender Address of allowed account.
60     /// @param _value Number of approved tokens.
61     function approve(address _spender, uint256 _value) returns (bool success) {
62         allowed[msg.sender][_spender] = _value;
63         Approval(msg.sender, _spender, _value);
64         return true;
65     }
66 
67     /* * Read storage functions */
68     /// @dev Returns number of allowed tokens for given address.
69     /// @param _owner Address of token owner.
70     /// @param _spender Address of token spender.
71     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
72       return allowed[_owner][_spender];
73     }
74 
75 }
76 
77 contract ILF is StandardToken {
78 
79     mapping(address => bool) public previousMinters;
80     mapping(address => bool) public previousBurners;
81     bool public minterChangeable = true;
82     bool public burnerChangeable = true;
83     bool public manualEmissionEnabled = true;
84     string public constant symbol = "ILF";
85     string public constant name = "ICO Lab Fund Token";
86     uint8 public constant decimals = 8;
87     address public burnerAddress;
88     address public minterAddress;
89     address public ILFManager;
90     address public ILFManagerCandidate;   
91     bytes32 public ILFManagerCandidateKeyHash; 
92     Burner burner;
93                                            
94     event Emission(address indexed emitTo, uint amount);
95     event Burn(address indexed burnFrom, uint amount);
96 
97     // @dev Create token.
98     // @param _ILFManager ILF manager address.
99     function ILF(address _ILFManager){
100         ILFManager = _ILFManager;
101     }
102 
103     /// @dev Emit new tokens for an address. Only usable by minter or manager.
104     /// @param emitTo Emission destination address.
105     /// @param amount Amount to emit.
106     function emitToken(address emitTo, uint amount) {
107         assert(amount>0);
108         assert(msg.sender == minterAddress || (msg.sender == ILFManager && manualEmissionEnabled));
109         balances[emitTo] += amount;
110         totalSupply += amount;
111         Emission(emitTo, amount);
112     }
113 
114     /// @dev Burn tokens from an address. Only usable by burner.
115     /// @param burnFrom Address to burn tokens from.
116     /// @param amount Amount to burn.
117     function burnToken(address burnFrom, uint amount) external onlyBurner {
118         assert(amount <= balances[burnFrom] && amount <= totalSupply);
119         balances[burnFrom] -= amount;
120         totalSupply -= amount;
121         Burn(burnFrom, amount);
122     }
123 
124     //Overloading the original ERC20 transfer function to handle token burn
125     /// @dev Transfers sender's tokens to a given address. Returns success.
126     /// @param _to Address of token receiver.
127     /// @param _value Number of tokens to transfer.
128     function transfer(address _to, uint256 _value) returns (bool success) {
129         assert(!previousBurners[_to] && !previousMinters[_to] && _to != minterAddress);
130         
131         if (balances[msg.sender] >= _value && _value > 0 && _to != address(0) && _to != address(this)) {//The last two checks are done for preventing sending tokens to zero address or token address (this contract).
132             if (_to == burnerAddress) {
133                 burner.burnILF(msg.sender, _value);
134             }
135             else {
136                 balances[msg.sender] -= _value;
137                 balances[_to] += _value;
138                 Transfer(msg.sender, _to, _value);
139             }
140             return true;
141         }
142         else {
143             return false;
144         }
145     }
146 
147     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
148         assert(!previousBurners[_to] && !previousMinters[_to] && _to != minterAddress);
149 
150         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0 && _to != address(0) && _to != address(this)) {
151             if (_to == burnerAddress) {
152                 burner.burnILF(_from, _value);
153             }
154             else {
155                 balances[_to] += _value;
156                 balances[_from] -= _value;
157                 allowed[_from][msg.sender] -= _value;
158                 Transfer(_from, _to, _value);
159             }
160             return true;
161         }
162         else {
163             return false;
164         }
165     }
166 
167     /// @dev Change minter manager. Only usable by manager.
168     /// @param candidate New manager address.
169     /// @param keyHash Hash of secret key possessed by candidate.
170     function changeILFManager(address candidate, bytes32 keyHash) external onlyILFManager {
171         ILFManagerCandidate = candidate;
172         ILFManagerCandidateKeyHash = keyHash;
173     }
174 
175     /// @dev Accept taking manager role. Only usable by manager candidate.
176     /// @param key Hash of the secret key from the current manager.
177     function acceptManagement(string key) external onlyManagerCandidate(key) {
178         ILFManager = ILFManagerCandidate;
179     }
180 
181     /// @dev Change minter address. Only usable by manager.
182     /// @param _minterAddress New minter address.
183     function changeMinter(address _minterAddress) external onlyILFManager {
184         assert(minterChangeable);
185         previousMinters[minterAddress]=true;
186         minterAddress = _minterAddress;
187     }
188 
189     /// @dev Seals minter. After this procedure minter is no longer changeable.
190     /// @param _hash SHA3 hash of current minter address.
191     function sealMinter(bytes32 _hash) onlyILFManager {
192         assert(sha3(minterAddress)==_hash);
193         minterChangeable = false; 
194     }
195     
196     /// @dev Change burner address. Only usable by manager.
197     /// @param _burnerAddress New burner address.
198     function changeBurner(address _burnerAddress) external onlyILFManager {
199         assert(burnerChangeable);
200         burner = Burner(_burnerAddress);
201         previousBurners[burnerAddress]=true;
202         burnerAddress = _burnerAddress;
203     }
204 
205     /// @dev Seals burner. After this procedure burner is no longer changeable.
206     /// @param _hash SHA3 hash of current burner address.
207     function sealBurner(bytes32 _hash) onlyILFManager {
208         assert(sha3(burnerAddress)==_hash);
209         burnerChangeable = false; 
210     }
211 
212     /// @dev Disable calling emitToken by manager needed for initial token distribution. Only usable by manager.
213     /// @param _hash SHA3 Hash of current manager address.
214     function disableManualEmission(bytes32 _hash) onlyILFManager {
215         assert(sha3(ILFManager)==_hash);
216         manualEmissionEnabled = false; 
217     }
218 
219     modifier onlyILFManager() {
220         assert(msg.sender == ILFManager);
221         _;
222     }
223 
224     modifier onlyMinter() {
225         assert(msg.sender == minterAddress);
226         _;
227     }
228 
229     modifier onlyBurner() {
230         assert(msg.sender == burnerAddress);
231         _;
232     }
233 
234     modifier onlyManagerCandidate(string key) {
235         assert(msg.sender == ILFManagerCandidate);
236         assert(sha3(key) == ILFManagerCandidateKeyHash);
237         _;
238     }
239 
240 }