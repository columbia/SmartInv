1 contract SafeMath {
2     
3     uint256 constant MAX_UINT256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
4 
5     function safeAdd(uint256 x, uint256 y) internal pure returns (uint256 z) {
6         require(x <= MAX_UINT256 - y);
7         return x + y;
8     }
9 
10     function safeSub(uint256 x, uint256 y) internal pure returns (uint256 z) {
11         require(x >= y);
12         return x - y;
13     }
14 
15     function safeMul(uint256 x, uint256 y) internal pure returns (uint256 z) {
16         if (y == 0) {
17             return 0;
18         }
19         require(x <= (MAX_UINT256 / y));
20         return x * y;
21     }
22 }
23 contract TokenRecipientInterface {
24   function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
25 }
26 contract ERC20TokenInterface {
27   function totalSupply() public constant returns (uint256 _totalSupply);
28   function balanceOf(address _owner) public constant returns (uint256 balance);
29   function transfer(address _to, uint256 _value) public returns (bool success);
30   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
31   function approve(address _spender, uint256 _value) public returns (bool success);
32   function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
33 
34   event Transfer(address indexed _from, address indexed _to, uint256 _value);
35   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
36 }
37 
38 contract Owned {
39     address public owner;
40     address public newOwner;
41 
42     function Owned() public {
43         owner = msg.sender;
44     }
45 
46     modifier onlyOwner {
47         assert(msg.sender == owner);
48         _;
49     }
50 
51     function transferOwnership(address _newOwner) public onlyOwner {
52         require(_newOwner != owner);
53         newOwner = _newOwner;
54     }
55 
56     function acceptOwnership() public {
57         require(msg.sender == newOwner);
58         OwnerUpdate(owner, newOwner);
59         owner = newOwner;
60         newOwner = 0x0;
61     }
62 
63     event OwnerUpdate(address _prevOwner, address _newOwner);
64 }
65 contract Lockable is Owned {
66 
67     uint256 public lockedUntilBlock;
68 
69     event ContractLocked(uint256 _untilBlock, string _reason);
70 
71     modifier lockAffected {
72         require(block.number > lockedUntilBlock);
73         _;
74     }
75 
76     function lockFromSelf(uint256 _untilBlock, string _reason) internal {
77         lockedUntilBlock = _untilBlock;
78         ContractLocked(_untilBlock, _reason);
79     }
80 
81 
82     function lockUntil(uint256 _untilBlock, string _reason) onlyOwner public {
83         lockedUntilBlock = _untilBlock;
84         ContractLocked(_untilBlock, _reason);
85     }
86 }
87 
88 
89 
90 
91 
92 
93 contract ERC20Token is ERC20TokenInterface, SafeMath, Owned, Lockable {
94 
95     /* Public variables of the token */
96     string public standard;
97     string public name;
98     string public symbol;
99     uint8 public decimals;
100 
101     bool mintingEnabled;
102 
103     /* Private variables of the token */
104     uint256 supply = 0;
105     mapping (address => uint256) balances;
106     mapping (address => mapping (address => uint256)) allowances;
107 
108     event Mint(address indexed _to, uint256 _value);
109     event Burn(address indexed _from, uint _value);
110 
111     /* Returns total supply of issued tokens */
112     function totalSupply() constant public returns (uint256) {
113         return supply;
114     }
115 
116     /* Returns balance of address */
117     function balanceOf(address _owner) constant public returns (uint256 balance) {
118         return balances[_owner];
119     }
120 
121     /* Transfers tokens from your address to other */
122     function transfer(address _to, uint256 _value) lockAffected public returns (bool success) {
123         require(_to != 0x0 && _to != address(this));
124         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);  // Deduct senders balance
125         balances[_to] = safeAdd(balanceOf(_to), _value);                // Add recivers blaance
126         Transfer(msg.sender, _to, _value);                              // Raise Transfer event
127         return true;
128     }
129 
130     /* Approve other address to spend tokens on your account */
131     function approve(address _spender, uint256 _value) lockAffected public returns (bool success) {
132         allowances[msg.sender][_spender] = _value;        // Set allowance
133         Approval(msg.sender, _spender, _value);           // Raise Approval event
134         return true;
135     }
136 
137     /* Approve and then communicate the approved contract in a single tx */
138     function approveAndCall(address _spender, uint256 _value, bytes _extraData) lockAffected public returns (bool success) {
139         TokenRecipientInterface spender = TokenRecipientInterface(_spender);    // Cast spender to tokenRecipient contract
140         approve(_spender, _value);                                              // Set approval to contract for _value
141         spender.receiveApproval(msg.sender, _value, this, _extraData);          // Raise method on _spender contract
142         return true;
143     }
144 
145     /* A contract attempts to get the coins */
146     function transferFrom(address _from, address _to, uint256 _value) lockAffected public returns (bool success) {
147         require(_to != 0x0 && _to != address(this));
148         balances[_from] = safeSub(balanceOf(_from), _value);                            // Deduct senders balance
149         balances[_to] = safeAdd(balanceOf(_to), _value);                                // Add recipient blaance
150         allowances[_from][msg.sender] = safeSub(allowances[_from][msg.sender], _value); // Deduct allowance for this address
151         Transfer(_from, _to, _value);                                                   // Raise Transfer event
152         return true;
153     }
154 
155     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
156         return allowances[_owner][_spender];
157     }
158 
159     /* Owner can mint new tokens while minting is enabled */
160     function mint(address _to, uint256 _amount) onlyOwner public {
161         require(mintingEnabled);                       // Check if minting is enabled
162         supply = safeAdd(supply, _amount);              // Add new token count to totalSupply
163         balances[_to] = safeAdd(balances[_to], _amount);// Add tokens to recipients wallet
164         Mint(_to, _amount);                             // Raise event that anyone can see
165         Transfer(0x0, _to, _amount);                    // Raise transfer event
166     }
167 
168     /* Anyone can destroy tokens on their walllet */
169     function burn(uint _amount) public {
170         balances[msg.sender] = safeSub(balanceOf(msg.sender), _amount);
171         supply = safeSub(supply, _amount);
172         Burn(msg.sender, _amount);
173         Transfer(msg.sender, 0x0, _amount);
174     }
175 
176     /* Owner can salvage tokens that were accidentally sent to the smart contract address */
177     function salvageTokensFromContract(address _tokenAddress, address _to, uint _amount) onlyOwner public {
178         ERC20TokenInterface(_tokenAddress).transfer(_to, _amount);
179     }
180     
181     /* Owner can wipe all the data from the contract and disable all the methods */
182     function killContract() onlyOwner public {
183         selfdestruct(owner);
184     }
185 
186     /* Owner can disable minting forever and ever */
187     function disableMinting() onlyOwner public {
188         mintingEnabled = false;
189     }
190 }
191 
192 
193 
194 
195 contract MrpToken is ERC20Token {
196 
197   /* Initializes contract */
198   function MrpToken() public {
199     standard = "MoneyRebel token v1.0";
200     name = "MrpToken";
201     symbol = "MRP";
202     decimals = 18;
203     mintingEnabled = true;
204     lockFromSelf(5010000, "Lock before crowdsale starts");
205   }
206 }