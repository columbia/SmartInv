1 pragma solidity ^0.4.8;
2 
3 contract ERC20Interface {
4   function totalSupply() constant returns (uint256 totalSupply);
5   function balanceOf(address _owner) constant returns (uint256 balance);
6   function transfer(address _to, uint256 _value) returns (bool success);
7   function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
8   function approve(address _spender, uint256 _value) returns (bool success);
9   function allowance(address _owner, address _spender) constant returns (uint256 remaining);
10 
11   event Transfer(address indexed _from, address indexed _to, uint256 _value);
12   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
13 }
14 
15 contract AgoraToken is ERC20Interface {
16 
17   string public constant name = "Agora";
18   string public constant symbol = "AGO";
19   uint8  public constant decimals = 18;
20 
21   uint256 constant minimumToRaise = 500 ether;
22   uint256 constant icoStartBlock = 4116800;
23   uint256 constant icoPremiumEndBlock = icoStartBlock + 78776; // Two weeks
24   uint256 constant icoEndBlock = icoStartBlock + 315106; // Two months
25 
26   address owner;
27   uint256 raised = 0;
28   uint256 created = 0;
29 
30   struct BalanceSnapshot {
31     bool initialized;
32     uint256 value;
33   }
34 
35   mapping(address => uint256) shares;
36   mapping(address => uint256) balances;
37   mapping(address => mapping (address => uint256)) allowed;
38   mapping(uint256 => mapping (address => BalanceSnapshot)) balancesAtBlock;
39 
40   function AgoraToken() {
41     owner = msg.sender;
42   }
43 
44   // ==========================
45   // ERC20 Logic Implementation
46   // ==========================
47 
48   // Returns the balance of an address.
49   function balanceOf(address _owner) constant returns (uint256 balance) {
50     return balances[_owner];
51   }
52 
53   // Make a transfer of AGO between two addresses.
54   function transfer(address _to, uint256 _value) returns (bool success) {
55     // Freeze for dev team
56     require(msg.sender != owner && _to != owner);
57 
58     if (balances[msg.sender] >= _value &&
59         _value > 0 &&
60         balances[_to] + _value > balances[_to]) {
61       // We need to register the balance known for the last reference block.
62       // That way, we can be sure that when the Claimer wants to check the balance
63       // the system can be protected against double-spending AGO tokens claiming.
64       uint256 referenceBlockNumber = latestReferenceBlockNumber();
65       registerBalanceForReference(msg.sender, referenceBlockNumber);
66       registerBalanceForReference(_to, referenceBlockNumber);
67 
68       // Standard transfer stuff
69       balances[msg.sender] -= _value;
70       balances[_to] += _value;
71       Transfer(msg.sender, _to, _value);
72       return true;
73     } else { return false; }
74   }
75 
76   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
77     // Freeze for dev team
78     require(_to != owner);
79 
80     if(balances[_from] >= _value &&
81        _value > 0 &&
82        allowed[_from][msg.sender] >= _value &&
83        balances[_to] + _value > balances[_to]) {
84       // Same as `transfer` :
85       // We need to register the balance known for the last reference block.
86       // That way, we can be sure that when the Claimer wants to check the balance
87       // the system can be protected against double-spending AGO tokens claiming.
88       uint256 referenceBlockNumber = latestReferenceBlockNumber();
89       registerBalanceForReference(_from, referenceBlockNumber);
90       registerBalanceForReference(_to, referenceBlockNumber);
91 
92       // Standard transferFrom stuff
93       balances[_from] -= _value;
94       balances[_to] += _value;
95       allowed[_from][msg.sender] -= _value;
96       Transfer(msg.sender, _to, _value);
97       return true;
98     } else { return false; }
99   }
100 
101   // Approve a payment from msg.sender account to another one.
102   function approve(address _spender, uint256 _value) returns (bool success) {
103     // Freeze for dev team
104     require(msg.sender != owner);
105 
106     allowed[msg.sender][_spender] = _value;
107     Approval(msg.sender, _spender, _value);
108     return true;
109   }
110 
111   // Checks the allowance of an account against another one. (Works with approval).
112   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
113     return allowed[_owner][_spender];
114   }
115 
116   // Returns the total supply of token issued.
117   function totalSupply() constant returns (uint256 totalSupply) { return created; }
118 
119   // ========================
120   // ICO Logic Implementation
121   // ========================
122 
123   // ICO Status overview. Used for Agora landing page
124   function icoOverview() constant returns(
125     uint256 currentlyRaised,
126     uint256 tokensCreated,
127     uint256 developersTokens
128   ){
129     currentlyRaised = raised;
130     tokensCreated = created;
131     developersTokens = balances[owner];
132   }
133 
134   // Get Agora tokens with a Ether payment.
135   function buy() payable {
136     require(block.number > icoStartBlock && block.number < icoEndBlock && msg.sender != owner);
137 
138     uint256 tokenAmount = msg.value * ((block.number < icoPremiumEndBlock) ? 550 : 500);
139 
140     shares[msg.sender] += msg.value;
141     balances[msg.sender] += tokenAmount;
142     balances[owner] += tokenAmount / 6;
143 
144     raised += msg.value;
145     created += tokenAmount;
146   }
147 
148   // Method use by the creators. Requires the ICO to be a success.
149   // Used to retrieve the Ethers raised from the ICO.
150   // That way, Agora is becoming possible :).
151   function withdraw(uint256 amount) {
152     require(block.number > icoEndBlock && raised >= minimumToRaise && msg.sender == owner);
153     owner.transfer(amount);
154   }
155 
156   // Methods use by the ICO investors. Requires the ICO to be a fail.
157   function refill() {
158     require(block.number > icoEndBlock && raised < minimumToRaise);
159     uint256 share = shares[msg.sender];
160     shares[msg.sender] = 0;
161     msg.sender.transfer(share);
162   }
163 
164   // ============================
165   // Claimer Logic Implementation
166   // ============================
167   // This part is used by the claimer.
168   // The claimer can ask the balance of an user at a reference block.
169   // That way, the claimer is protected against double-spending AGO claimings.
170 
171   // This method is triggered by `transfer` and `transferFrom`.
172   // It saves the balance known at a reference block only if there is no balance
173   // saved for this block yet.
174   // Meaning that this is a the first transaction since the last reference block,
175   // so this balance can be uses as the reference.
176   function registerBalanceForReference(address _owner, uint256 referenceBlockNumber) private {
177     if (balancesAtBlock[referenceBlockNumber][_owner].initialized) { return; }
178     balancesAtBlock[referenceBlockNumber][_owner].initialized = true;
179     balancesAtBlock[referenceBlockNumber][_owner].value = balances[_owner];
180   }
181 
182   // What is the latest reference block number ?
183   function latestReferenceBlockNumber() constant returns (uint256 blockNumber) {
184     return (block.number - block.number % 157553);
185   }
186 
187   // What is the balance of an user at a block ?
188   // If the user have made (or received) a transfer of AGO token since the
189   // last reference block, its balance will be written in the `balancesAtBlock`
190   // mapping. So we can retrieve it from here.
191   // Otherwise, if the user havn't made a transaction since the last reference
192   // block, the balance of AGO token is still good.
193   function balanceAtBlock(address _owner, uint256 blockNumber) constant returns (uint256 balance) {
194     if(balancesAtBlock[blockNumber][_owner].initialized) {
195       return balancesAtBlock[blockNumber][_owner].value;
196     }
197     return balances[_owner];
198   }
199 }