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
72 
73 contract tokenRecipientInterface {
74   function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
75 }
76 contract OwnedInterface {
77     address public owner;
78     address public newOwner;
79 
80     modifier onlyOwner {
81         _;
82     }
83 }
84 contract ERC20TokenInterface {
85   function totalSupply() public constant returns (uint256 _totalSupply);
86   function balanceOf(address _owner) public constant returns (uint256 balance);
87   function transfer(address _to, uint256 _value) public returns (bool success);
88   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
89   function approve(address _spender, uint256 _value) public returns (bool success);
90   function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
91 
92   event Transfer(address indexed _from, address indexed _to, uint256 _value);
93   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
94 }
95 
96 contract ERC20PrivateInterface {
97     uint256 supply;
98     mapping (address => uint256) balances;
99     mapping (address => mapping (address => uint256)) allowances;
100 
101     event Transfer(address indexed _from, address indexed _to, uint256 _value);
102     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
103 }
104 
105 contract ERC20Token is ERC20TokenInterface, SafeMath, Owned, Lockable {
106 
107     /* Public variables of the token */
108     string public standard;
109     string public name;
110     string public symbol;
111     uint8 public decimals;
112 
113     /* Private variables of the token */
114     uint256 supply = 0;
115     mapping (address => uint256) balances;
116     mapping (address => mapping (address => uint256)) allowances;
117 
118     event Mint(address indexed _to, uint256 _value);
119     event Burn(address indexed _from, uint _value);
120 
121     /* Returns total supply of issued tokens */
122     function totalSupply() constant returns (uint256) {
123         return supply;
124     }
125 
126     /* Returns balance of address */
127     function balanceOf(address _owner) constant returns (uint256 balance) {
128         return balances[_owner];
129     }
130 
131     /* Transfers tokens from your address to other */
132     function transfer(address _to, uint256 _value) lockAffected returns (bool success) {
133         require(_to != 0x0 && _to != address(this));
134         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);  // Deduct senders balance
135         balances[_to] = safeAdd(balanceOf(_to), _value);                // Add recivers blaance
136         Transfer(msg.sender, _to, _value);                              // Raise Transfer event
137         return true;
138     }
139 
140     /* Approve other address to spend tokens on your account */
141     function approve(address _spender, uint256 _value) lockAffected returns (bool success) {
142         allowances[msg.sender][_spender] = _value;        // Set allowance
143         Approval(msg.sender, _spender, _value);           // Raise Approval event
144         return true;
145     }
146 
147     /* Approve and then communicate the approved contract in a single tx */
148     function approveAndCall(address _spender, uint256 _value, bytes _extraData) lockAffected returns (bool success) {
149         tokenRecipientInterface spender = tokenRecipientInterface(_spender);    // Cast spender to tokenRecipient contract
150         approve(_spender, _value);                                              // Set approval to contract for _value
151         spender.receiveApproval(msg.sender, _value, this, _extraData);          // Raise method on _spender contract
152         return true;
153     }
154 
155     /* A contract attempts to get the coins */
156     function transferFrom(address _from, address _to, uint256 _value) lockAffected returns (bool success) {
157         require(_to != 0x0 && _to != address(this));
158         balances[_from] = safeSub(balanceOf(_from), _value);                            // Deduct senders balance
159         balances[_to] = safeAdd(balanceOf(_to), _value);                                // Add recipient blaance
160         allowances[_from][msg.sender] = safeSub(allowances[_from][msg.sender], _value); // Deduct allowance for this address
161         Transfer(_from, _to, _value);                                                   // Raise Transfer event
162         return true;
163     }
164 
165     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
166         return allowances[_owner][_spender];
167     }
168 
169     function mint(address _to, uint256 _amount) onlyOwner {
170         supply = safeAdd(supply, _amount);
171         balances[_to] = safeAdd(balances[_to], _amount);
172         Mint(_to, _amount);
173         Transfer(0x0, _to, _amount);
174     }
175 
176     function burn(uint _amount) lockAffected {
177         balances[msg.sender] = safeSub(balanceOf(msg.sender), _amount);
178         supply = safeSub(supply, _amount);
179         Burn(msg.sender, _amount);
180         Transfer(msg.sender, 0x0, _amount);
181     }
182 
183     function salvageTokensFromContract(address _tokenAddress, address _to, uint _amount) onlyOwner {
184         ERC20TokenInterface(_tokenAddress).transfer(_to, _amount);
185     }
186 }
187 
188 contract XaurumGammaToken is ERC20Token {
189 
190     /* Initializes contract */
191     function XaurumGammaToken() {
192         standard = "XGM token v1.0";
193         name = "XaurumGamma";
194         symbol = "XGM";
195         decimals = 8;
196         lockFromSelf(4352535, "Lock before distribution");
197     }
198 }