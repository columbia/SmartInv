1 contract SafeMath {
2   //internals
3 
4   function safeMul(uint a, uint b) internal returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function safeSub(uint a, uint b) internal returns (uint) {
11     assert(b <= a);
12     return a - b;
13   }
14 
15   function safeAdd(uint a, uint b) internal returns (uint) {
16     uint c = a + b;
17     assert(c>=a && c>=b);
18     return c;
19   }
20 
21   function assert(bool assertion) internal {
22     if (!assertion) throw;
23   }
24 }
25 
26 contract Token {
27     function totalSupply() constant returns (uint256 supply) {}
28     function balanceOf(address _owner) constant returns (uint256 balance) {}
29     function transfer(address _to, uint256 _value) returns (bool success) {}
30     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
31     function approve(address _spender, uint256 _value) returns (bool success) {}
32     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
33     event Transfer(address indexed _from, address indexed _to, uint256 _value);
34     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
35 }
36 contract StandardToken is Token {
37     function transfer(address _to, uint256 _value) returns (bool success) {
38         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
39         //if (balances[msg.sender] >= _value && _value > 0) {
40             balances[msg.sender] -= _value;
41             balances[_to] += _value;
42             Transfer(msg.sender, _to, _value);
43             return true;
44         } else { return false; }
45     }
46 
47     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
48         //same as above. Replace this line with the following if you want to protect against wrapping uints.
49         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
50         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
51             balances[_to] += _value;
52             balances[_from] -= _value;
53             allowed[_from][msg.sender] -= _value;
54             Transfer(_from, _to, _value);
55             return true;
56         } else { return false; }
57     }
58 
59     function balanceOf(address _owner) constant returns (uint256 balance) {
60         return balances[_owner];
61     }
62 
63     function approve(address _spender, uint256 _value) returns (bool success) {
64         allowed[msg.sender][_spender] = _value;
65         Approval(msg.sender, _spender, _value);
66         return true;
67     }
68 
69     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
70       return allowed[_owner][_spender];
71     }
72 
73     mapping(address => uint256) balances;
74 
75     mapping (address => mapping (address => uint256)) allowed;
76 
77     uint256 public totalSupply;
78 
79 }
80 
81 contract GooglierToken is StandardToken, SafeMath {
82 
83     string public name = "Googlier Token";
84     string public symbol = "googlier";
85     uint public decimals = 18;
86     uint public startBlock;
87     uint public endBlock;
88     address public founder = 0x0e0b9d8c9930e7cff062dd4a2b26bce95a0defee;
89     address public signer = 0x0e0b9d8c9930e7cff062dd4a2b26bce95a0defee;
90 
91     uint public etherCap = 500000 * 10**18;
92     uint public transferLockup = 370285;
93     uint public founderLockup = 2252571;
94     uint public bountyAllocation = 2500000 * 10**18;
95     uint public ecosystemAllocation = 5 * 10**16;
96     uint public founderAllocation = 10 * 10**16;
97     bool public bountyAllocated = true;
98     bool public ecosystemAllocated = true;
99     bool public founderAllocated = true;
100     uint public presaleTokenSupply = 0;
101     uint public presaleEtherRaised = 0;
102     bool public halted = false;
103     event Buy(address indexed sender, uint eth, uint fbt);
104     event Withdraw(address indexed sender, address to, uint eth);
105     event AllocateFounderTokens(address indexed sender);
106     event AllocateBountyAndEcosystemTokens(address indexed sender);
107 
108     function FirstBloodToken(address founderInput, address signerInput, uint startBlockInput, uint endBlockInput) {
109         founder = founderInput;
110         signer = signerInput;
111         startBlock = startBlockInput;
112         endBlock = endBlockInput;
113     }
114     function price() constant returns(uint) {
115         if (block.number>=startBlock && block.number<startBlock+250) return 170; //power hour
116         if (block.number<startBlock || block.number>endBlock) return 100; //default price
117         return 100 + 4*(endBlock - block.number)/(endBlock - startBlock + 1)*67/4; //crowdsale price
118     }
119 
120     // price() exposed for unit tests
121     function testPrice(uint blockNumber) constant returns(uint) {
122         if (blockNumber>=startBlock && blockNumber<startBlock+250) return 170; //power hour
123         if (blockNumber<startBlock || blockNumber>endBlock) return 100; //default price
124         return 100 + 4*(endBlock - blockNumber)/(endBlock - startBlock + 1)*67/4; //crowdsale price
125     }
126 
127     // Buy entry point
128     function buy(uint8 v, bytes32 r, bytes32 s) {
129         buyRecipient(msg.sender, v, r, s);
130     }
131     function buyRecipient(address recipient, uint8 v, bytes32 r, bytes32 s) {
132         bytes32 hash = sha256(msg.sender);
133         if (ecrecover(hash,v,r,s) != signer) throw;
134         if (block.number<startBlock || block.number>endBlock || safeAdd(presaleEtherRaised,msg.value)>etherCap || halted) throw;
135         uint tokens = safeMul(msg.value, price());
136         balances[recipient] = safeAdd(balances[recipient], tokens);
137         totalSupply = safeAdd(totalSupply, tokens);
138         presaleEtherRaised = safeAdd(presaleEtherRaised, msg.value);
139     if (!founder.call.value(msg.value)()) throw; //immediately send Ether to founder address
140 
141         Buy(recipient, msg.value, tokens);
142     }
143     function allocateFounderTokens() {
144         if (msg.sender!=founder) throw;
145         if (block.number <= endBlock + founderLockup) throw;
146         if (founderAllocated) throw;
147         if (!bountyAllocated || !ecosystemAllocated) throw;
148         balances[founder] = safeAdd(balances[founder], presaleTokenSupply * founderAllocation / (1 ether));
149         totalSupply = safeAdd(totalSupply, presaleTokenSupply * founderAllocation / (1 ether));
150         founderAllocated = true;
151         AllocateFounderTokens(msg.sender);
152     }
153 
154 
155     function allocateBountyAndEcosystemTokens() {
156         if (msg.sender!=founder) throw;
157         if (block.number <= endBlock) throw;
158         if (bountyAllocated || ecosystemAllocated) throw;
159         presaleTokenSupply = totalSupply;
160         balances[founder] = safeAdd(balances[founder], presaleTokenSupply * ecosystemAllocation / (1 ether));
161         totalSupply = safeAdd(totalSupply, presaleTokenSupply * ecosystemAllocation / (1 ether));
162         balances[founder] = safeAdd(balances[founder], bountyAllocation);
163         totalSupply = safeAdd(totalSupply, bountyAllocation);
164         bountyAllocated = true;
165         ecosystemAllocated = true;
166         AllocateBountyAndEcosystemTokens(msg.sender);
167     }
168     function halt() {
169         if (msg.sender!=founder) throw;
170         halted = true;
171     }
172 
173     function unhalt() {
174         if (msg.sender!=founder) throw;
175         halted = false;
176     }
177     function changeFounder(address newFounder) {
178         if (msg.sender!=founder) throw;
179         founder = newFounder;
180     }
181     function transfer(address _to, uint256 _value) returns (bool success) {
182         if (block.number <= endBlock + transferLockup && msg.sender!=founder) throw;
183         return super.transfer(_to, _value);
184     }
185     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
186         if (block.number <= endBlock + transferLockup && msg.sender!=founder) throw;
187         return super.transferFrom(_from, _to, _value);
188     }
189 
190     function() {
191         throw;
192     }
193 
194 }