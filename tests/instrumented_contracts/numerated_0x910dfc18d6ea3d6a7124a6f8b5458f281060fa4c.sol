1 contract SafeMath {
2     
3     uint256 constant public MAX_UINT256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
4 
5     function safeAdd(uint256 x, uint256 y) constant internal returns (uint256 z) {
6         require(x <= MAX_UINT256 - y);
7         return x + y;
8     }
9 
10     function safeSub(uint256 x, uint256 y) constant internal returns (uint256 z) {
11         require(x >= y);
12         return x - y;
13     }
14 
15     function safeMul(uint256 x, uint256 y) constant internal returns (uint256 z) {
16         if (y == 0) {
17             return 0;
18         }
19         require(x <= (MAX_UINT256 / y));
20         return x * y;
21     }
22 }
23 
24 contract Owned {
25     address public owner;
26     address public newOwner;
27 
28     function Owned() {
29         owner = msg.sender;
30     }
31 
32     modifier onlyOwner {
33         assert(msg.sender == owner);
34         _;
35     }
36 
37     function transferOwnership(address _newOwner) public onlyOwner {
38         require(_newOwner != owner);
39         newOwner = _newOwner;
40     }
41 
42     function acceptOwnership() public {
43         require(msg.sender == newOwner);
44         OwnerUpdate(owner, newOwner);
45         owner = newOwner;
46         newOwner = 0x0;
47     }
48 
49     event OwnerUpdate(address _prevOwner, address _newOwner);
50 }
51 
52 contract Lockable is Owned {
53 
54     uint256 public lockedUntilBlock;
55 
56     event ContractLocked(uint256 _untilBlock, string _reason);
57 
58     modifier lockAffected {
59         require(block.number > lockedUntilBlock);
60         _;
61     }
62 
63     function lockFromSelf(uint256 _untilBlock, string _reason) internal {
64         lockedUntilBlock = _untilBlock;
65         ContractLocked(_untilBlock, _reason);
66     }
67 
68 
69     function lockUntil(uint256 _untilBlock, string _reason) onlyOwner public {
70         lockedUntilBlock = _untilBlock;
71         ContractLocked(_untilBlock, _reason);
72     }
73 }
74 
75 contract tokenRecipientInterface {
76   function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
77 }
78 
79 
80 contract OwnedInterface {
81     address public owner;
82     address public newOwner;
83 
84     modifier onlyOwner {
85         _;
86     }
87 }
88 
89 contract ERC20TokenInterface {
90   function totalSupply() public constant returns (uint256 _totalSupply);
91   function balanceOf(address _owner) public constant returns (uint256 balance);
92   function transfer(address _to, uint256 _value) public returns (bool success);
93   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
94   function approve(address _spender, uint256 _value) public returns (bool success);
95   function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
96 
97   event Transfer(address indexed _from, address indexed _to, uint256 _value);
98   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
99 }
100 
101 contract ERC20PrivateInterface {
102     uint256 supply;
103     mapping (address => uint256) balances;
104     mapping (address => mapping (address => uint256)) allowances;
105 
106     event Transfer(address indexed _from, address indexed _to, uint256 _value);
107     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
108 }
109 
110 contract MintableToken is SafeMath, Owned, ERC20PrivateInterface {
111 
112     uint public totalSupplyLimit;
113 
114     event Mint(address indexed _to, uint256 _value);
115 
116     function mintTokens(address _to, uint256 _amount) onlyOwner {
117         require(supply + _amount <= totalSupplyLimit);
118         supply = safeAdd(supply, _amount);
119         balances[_to] = safeAdd(balances[_to], _amount);
120         Mint(_to, _amount);
121         Transfer(0x0, _to, _amount);
122     }
123 }
124 
125 contract ERC20Token is ERC20TokenInterface, SafeMath, Owned, Lockable {
126 
127     /* Public variables of the token */
128     string public standard;
129     string public name;
130     string public symbol;
131     uint8 public decimals;
132     uint256 public totalSupplyLimit;
133 
134     /* Private variables of the token */
135     uint256 supply = 0;
136     mapping (address => uint256) balances;
137     mapping (address => mapping (address => uint256)) allowances;
138 
139     event Mint(address indexed _to, uint256 _value);
140 
141     /* Returns total supply of issued tokens */
142     function totalSupply() constant returns (uint256) {
143         return supply;
144     }
145 
146     /* Returns balance of address */
147     function balanceOf(address _owner) constant returns (uint256 balance) {
148         return balances[_owner];
149     }
150 
151     /* Transfers tokens from your address to other */
152     function transfer(address _to, uint256 _value) lockAffected returns (bool success) {
153         require(_to != 0x0 && _to != address(this));
154         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);  // Deduct senders balance
155         balances[_to] = safeAdd(balanceOf(_to), _value);                // Add recivers blaance
156         Transfer(msg.sender, _to, _value);                              // Raise Transfer event
157         return true;
158     }
159 
160     /* Approve other address to spend tokens on your account */
161     function approve(address _spender, uint256 _value) lockAffected returns (bool success) {
162         allowances[msg.sender][_spender] = _value;        // Set allowance
163         Approval(msg.sender, _spender, _value);           // Raise Approval event
164         return true; 
165     }
166 
167     /* Approve and then communicate the approved contract in a single tx */
168     function approveAndCall(address _spender, uint256 _value, bytes _extraData) lockAffected returns (bool success) {
169         tokenRecipientInterface spender = tokenRecipientInterface(_spender);    // Cast spender to tokenRecipient contract
170         approve(_spender, _value);                                              // Set approval to contract for _value
171         spender.receiveApproval(msg.sender, _value, this, _extraData);          // Raise method on _spender contract
172         return true;
173     }
174 
175     /* A contract attempts to get the coins */
176     function transferFrom(address _from, address _to, uint256 _value) lockAffected returns (bool success) {
177         require(_to != 0x0 && _to != address(this));
178         balances[_from] = safeSub(balanceOf(_from), _value);                            // Deduct senders balance
179         balances[_to] = safeAdd(balanceOf(_to), _value);                                // Add recipient blaance
180         allowances[_from][msg.sender] = safeSub(allowances[_from][msg.sender], _value); // Deduct allowance for this address
181         Transfer(_from, _to, _value);                                                   // Raise Transfer event
182         return true;
183     }
184 
185     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
186         return allowances[_owner][_spender];
187     }
188 
189     function mintTokens(address _to, uint256 _amount) onlyOwner {
190         require(supply + _amount <= totalSupplyLimit);
191         supply = safeAdd(supply, _amount);
192         balances[_to] = safeAdd(balances[_to], _amount);
193         Mint(_to, _amount);
194         Transfer(0x0, _to, _amount);
195     }
196 
197     function salvageTokensFromContract(address _tokenAddress, address _to, uint _amount) onlyOwner{
198         ERC20TokenInterface(_tokenAddress).transfer(_to, _amount);
199     }
200 }
201 
202 contract X8XToken is ERC20Token {
203 
204     /* Initializes contract */
205     function X8XToken() {
206         standard = "X8X token v1.0";
207         name = "X8XToken";
208         symbol = "X8X";
209         decimals = 18;
210         totalSupplyLimit = 100000000 * 10**18;
211         lockFromSelf(4894000, "Lock before crowdsale starts");
212     }
213 }