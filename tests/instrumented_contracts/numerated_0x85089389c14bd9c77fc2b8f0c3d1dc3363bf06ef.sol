1 contract SafeMath {
2     
3     uint256 constant MAX_UINT256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
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
23 contract Owned {
24     address public owner;
25     address public newOwner;
26 
27     function Owned() {
28         owner = msg.sender;
29     }
30 
31     modifier onlyOwner {
32         assert(msg.sender == owner);
33         _;
34     }
35 
36     function transferOwnership(address _newOwner) public onlyOwner {
37         require(_newOwner != owner);
38         newOwner = _newOwner;
39     }
40 
41     function acceptOwnership() public {
42         require(msg.sender == newOwner);
43         OwnerUpdate(owner, newOwner);
44         owner = newOwner;
45         newOwner = 0x0;
46     }
47 
48     event OwnerUpdate(address _prevOwner, address _newOwner);
49 }
50 contract Lockable is Owned {
51 
52     uint256 public lockedUntilBlock;
53 
54     event ContractLocked(uint256 _untilBlock, string _reason);
55 
56     modifier lockAffected {
57         require(block.number > lockedUntilBlock);
58         _;
59     }
60 
61     function lockFromSelf(uint256 _untilBlock, string _reason) internal {
62         lockedUntilBlock = _untilBlock;
63         ContractLocked(_untilBlock, _reason);
64     }
65 
66 
67     function lockUntil(uint256 _untilBlock, string _reason) onlyOwner public {
68         lockedUntilBlock = _untilBlock;
69         ContractLocked(_untilBlock, _reason);
70     }
71 }
72 contract ReentrancyHandlingContract{
73 
74     bool locked;
75 
76     modifier noReentrancy() {
77         require(!locked);
78         locked = true;
79         _;
80         locked = false;
81     }
82 }
83 contract tokenRecipientInterface {
84   function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
85 }
86 contract ERC20TokenInterface {
87   function totalSupply() public constant returns (uint256 _totalSupply);
88   function balanceOf(address _owner) public constant returns (uint256 balance);
89   function transfer(address _to, uint256 _value) public returns (bool success);
90   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
91   function approve(address _spender, uint256 _value) public returns (bool success);
92   function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
93 
94   event Transfer(address indexed _from, address indexed _to, uint256 _value);
95   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
96 }
97 contract SportifyTokenInterface {
98     function mint(address _to, uint256 _amount) public;
99 }
100 
101 contract ERC20Token is ERC20TokenInterface, SafeMath, Owned, Lockable {
102 
103     /* Public variables of the token */
104     string public standard;
105     string public name;
106     string public symbol;
107     uint8 public decimals;
108 
109     address public crowdsaleContractAddress;
110 
111     /* Private variables of the token */
112     uint256 supply = 0;
113     mapping (address => uint256) balances;
114     mapping (address => mapping (address => uint256)) allowances;
115 
116     event Mint(address indexed _to, uint256 _value);
117     event Burn(address indexed _from, uint _value);
118 
119     /* Returns total supply of issued tokens */
120     function totalSupply() constant public returns (uint256) {
121         return supply;
122     }
123 
124     /* Returns balance of address */
125     function balanceOf(address _owner) constant public returns (uint256 balance) {
126         return balances[_owner];
127     }
128 
129     /* Transfers tokens from your address to other */
130     function transfer(address _to, uint256 _value) lockAffected public returns (bool success) {
131         require(_to != 0x0 && _to != address(this));
132         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);  // Deduct senders balance
133         balances[_to] = safeAdd(balanceOf(_to), _value);                // Add recivers blaance
134         Transfer(msg.sender, _to, _value);                              // Raise Transfer event
135         return true;
136     }
137 
138     /* Approve other address to spend tokens on your account */
139     function approve(address _spender, uint256 _value) lockAffected public returns (bool success) {
140         allowances[msg.sender][_spender] = _value;        // Set allowance
141         Approval(msg.sender, _spender, _value);           // Raise Approval event
142         return true;
143     }
144 
145     /* Approve and then communicate the approved contract in a single tx */
146     function approveAndCall(address _spender, uint256 _value, bytes _extraData) lockAffected public returns (bool success) {
147         tokenRecipientInterface spender = tokenRecipientInterface(_spender);    // Cast spender to tokenRecipient contract
148         approve(_spender, _value);                                              // Set approval to contract for _value
149         spender.receiveApproval(msg.sender, _value, this, _extraData);          // Raise method on _spender contract
150         return true;
151     }
152 
153     /* A contract attempts to get the coins */
154     function transferFrom(address _from, address _to, uint256 _value) lockAffected public returns (bool success) {
155         require(_to != 0x0 && _to != address(this));
156         balances[_from] = safeSub(balanceOf(_from), _value);                            // Deduct senders balance
157         balances[_to] = safeAdd(balanceOf(_to), _value);                                // Add recipient blaance
158         allowances[_from][msg.sender] = safeSub(allowances[_from][msg.sender], _value); // Deduct allowance for this address
159         Transfer(_from, _to, _value);                                                   // Raise Transfer event
160         return true;
161     }
162 
163     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
164         return allowances[_owner][_spender];
165     }
166 
167     function mint(address _to, uint256 _amount) public {
168         require(msg.sender == crowdsaleContractAddress);
169         supply = safeAdd(supply, _amount);
170         balances[_to] = safeAdd(balances[_to], _amount);
171         Mint(_to, _amount);
172         Transfer(0x0, _to, _amount);
173     }
174 
175     function burn(uint _amount) public {
176         balances[msg.sender] = safeSub(balanceOf(msg.sender), _amount);
177         supply = safeSub(supply, _amount);
178         Burn(msg.sender, _amount);
179         Transfer(msg.sender, 0x0, _amount);
180     }
181 
182     function salvageTokensFromContract(address _tokenAddress, address _to, uint _amount) onlyOwner public {
183         ERC20TokenInterface(_tokenAddress).transfer(_to, _amount);
184     }
185 }
186 
187 contract SportifyToken is ERC20Token {
188 
189   /* Initializes contract */
190   function SportifyToken() { 
191     standard = "Sportify token v1.0";
192     name = "SPFToken";
193     symbol = "SPF";
194     decimals = 18;
195     crowdsaleContractAddress = 0x53151A85EA7b82a4b43903427953efBA067cDe92;  
196     lockFromSelf(4708120, "Lock before crowdsale starts"); 
197   }
198 }