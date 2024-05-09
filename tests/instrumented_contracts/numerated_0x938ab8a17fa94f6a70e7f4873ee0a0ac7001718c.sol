1 pragma solidity ^0.4.18;
2 
3 contract Token {
4 
5     // ERC20 standard
6 
7     function balanceOf(address _owner) constant public returns (uint256 balance);
8     function transfer(address _to, uint256 _value) public returns (bool success);
9     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
10     function approve(address _spender, uint256 _value) public returns (bool success);
11     function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
12     function totalSupply() constant public returns (uint256 supply);
13     event Transfer(address indexed _from, address indexed _to, uint256 _value);
14     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
15 
16 }
17 
18 contract SafeMath {
19 
20   function safeMul(uint a, uint b) internal pure returns (uint) {
21     uint c = a * b;
22     assert(a == 0 || c / a == b);
23     return c;
24   }
25 
26   function safeSub(uint a, uint b) internal pure returns (uint) {
27     assert(b <= a);
28     return a - b;
29   }
30   function safeAdd(uint a, uint b) internal pure returns (uint) {
31     uint c = a + b;
32     assert(c >= a && c >= b);
33     return c;
34   }
35 
36   modifier onlyPayloadSize(uint numWords) {
37      assert(msg.data.length >= numWords * 32 + 4);
38      _;
39   }
40 
41 }
42 
43 contract StandardToken is Token, SafeMath {
44     
45     mapping (address => uint256) balances;
46     mapping (address => mapping (address => uint256)) allowed;
47     uint256 public totalSupply;
48 
49     function transfer(address _to, uint256 _value) onlyPayloadSize(2) public returns (bool success) {
50         require(_to != address(0));
51         require(balances[msg.sender] >= _value && _value > 0);
52         balances[msg.sender] = safeSub(balances[msg.sender], _value);
53         balances[_to] = safeAdd(balances[_to], _value);
54         Transfer(msg.sender, _to, _value);
55         return true;
56     }
57 
58     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
59         require(_to != address(0));
60         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);
61         balances[_from] = safeSub(balances[_from], _value);
62         balances[_to] = safeAdd(balances[_to], _value);
63         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
64         Transfer(_from, _to, _value);
65         return true;
66     }
67 
68     function balanceOf(address _owner) constant public returns (uint256 balance) {
69         return balances[_owner];
70     }
71 
72     function approve(address _spender, uint256 _value) onlyPayloadSize(2) public returns (bool success) {
73         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
74         allowed[msg.sender][_spender] = _value;
75         Approval(msg.sender, _spender, _value);
76         return true;
77     }
78 
79     function changeApproval(address _spender, uint256 _oldValue, uint256 _newValue) onlyPayloadSize(3) public returns (bool success) {
80         require(allowed[msg.sender][_spender] == _oldValue);
81         allowed[msg.sender][_spender] = _newValue;
82         Approval(msg.sender, _spender, _newValue);
83         return true;
84     }
85 
86     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
87       return allowed[_owner][_spender];
88     }
89     
90     
91     function totalSupply() constant public returns (uint256 supply) {
92         supply = totalSupply;
93     }
94     
95 }
96 
97 
98 
99 contract TabarniaCoin is StandardToken {
100 
101     string public name = "Tabarnia Coin";
102     string public motto = "Acta est fabula";
103     uint8 public decimals = 18;
104     string public symbol = "TAB";
105     string public version = '1.0';
106     string public author = "Lord Cid";
107     string public mission = "Somos Anonimos. Somos Legion. No perdonamos. No olvidamos.";
108     uint256 public tabsOneEthCanBuyICO = 1000;
109     bool public halted = false;
110     bool public tradeable = true;
111     address public fundsWallet;
112 
113     struct Proposal {
114         uint voteCount;
115     }
116     
117     struct Voter {
118         uint8 vote;
119         bool voted;
120     }
121     
122     mapping(address => Voter) voters;
123     
124     Proposal[] proposals;
125 
126     event Burn(address indexed from, uint256 value);
127 
128     modifier onlyFundsWallet {
129         require(msg.sender == fundsWallet);
130         _;
131     }
132 
133     modifier isTradeable {
134         require(tradeable || msg.sender == fundsWallet);
135         _;
136     }
137 
138     function TabarniaCoin() public {
139         totalSupply = 1000000 * 1000000000000000000;
140         balances[msg.sender] = totalSupply;
141         fundsWallet = msg.sender;
142     }
143 
144     function() payable public {
145         require(!halted);
146         uint256 amount = safeMul(msg.value,tabsOneEthCanBuyICO);
147 
148         if (balances[fundsWallet] < amount) {
149             return;
150         }
151 
152         balances[fundsWallet] = safeSub(balances[fundsWallet], amount);
153         balances[msg.sender] = safeAdd(balances[msg.sender], amount);
154 
155         Transfer(fundsWallet, msg.sender, amount);
156 
157         fundsWallet.transfer(msg.value);                               
158     }
159 
160     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
161         allowed[msg.sender][_spender] = _value;
162         Approval(msg.sender, _spender, _value);
163         if (!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
164         return true;
165     }
166 
167     function burn(uint256 _value) public returns (bool success) {
168         require(balanceOf(msg.sender) >= _value);
169         balances[msg.sender] = safeSub(balances[msg.sender], _value);
170         totalSupply = safeSub(totalSupply, _value); 
171         Burn(msg.sender, _value);
172         return true;
173     }
174 
175     function halt() external onlyFundsWallet {
176         halted = true;
177     }
178 
179     function unhalt() external onlyFundsWallet {
180         halted = false;
181     }
182 
183 
184     function enableTrading() external onlyFundsWallet {
185         tradeable = true;
186     }
187 
188     function disableTrading() external onlyFundsWallet {
189         tradeable = false;
190     }
191 
192     function transfer(address _to, uint256 _value) isTradeable public returns (bool success) {
193         return super.transfer(_to, _value);
194     }
195 
196     function transferFrom(address _from, address _to, uint256 _value) isTradeable public returns (bool success) {
197         return super.transferFrom(_from, _to, _value);
198     }
199     
200     function claimVotingRight() public {
201         require(tradeable);
202         voters[msg.sender].voted = false;
203         voters[msg.sender].vote = 0;
204     }
205 
206     function newVoting(uint8 _numProposals) public onlyFundsWallet {
207         require(!tradeable);
208         proposals.length = _numProposals;
209         for (uint8 prop = 0; prop < proposals.length; prop++) {
210             proposals[prop].voteCount = 0;
211         }
212 
213     }
214 
215     function vote(uint8 toProposal) public {
216         require(!tradeable);
217         require(toProposal < proposals.length);
218         require(balances[msg.sender] > 0);
219         require(!voters[msg.sender].voted);
220         voters[msg.sender].voted = true;
221         voters[msg.sender].vote = toProposal;
222         proposals[toProposal].voteCount = safeAdd(proposals[toProposal].voteCount,balances[msg.sender]);
223     }
224 
225     function winningProposal() public constant returns (uint8 _winningProposal) {
226         uint256 winningVoteCount = 0;
227         for (uint8 prop = 0; prop < proposals.length; prop++)
228             if (proposals[prop].voteCount > winningVoteCount) {
229                 winningVoteCount = proposals[prop].voteCount;
230                 _winningProposal = prop;
231             }
232     }
233 
234     function changeFundsWallet(address newFundsWallet) external onlyFundsWallet {
235         require(newFundsWallet != address(0));
236         fundsWallet = newFundsWallet;
237     }
238     
239 
240 }