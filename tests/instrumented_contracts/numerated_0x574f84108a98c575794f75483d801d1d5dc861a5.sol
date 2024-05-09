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
52 
53 contract Lockable is Owned {
54 
55     uint256 public lockedUntilBlock;
56 
57     event ContractLocked(uint256 _untilBlock, string _reason);
58 
59     modifier lockAffected {
60         require(block.number > lockedUntilBlock);
61         _;
62     }
63 
64     function lockFromSelf(uint256 _untilBlock, string _reason) internal {
65         lockedUntilBlock = _untilBlock;
66         ContractLocked(_untilBlock, _reason);
67     }
68 
69 
70     function lockUntil(uint256 _untilBlock, string _reason) onlyOwner public {
71         lockedUntilBlock = _untilBlock;
72         ContractLocked(_untilBlock, _reason);
73     }
74 }
75 
76 
77 contract ERC20PrivateInterface {
78     uint256 supply;
79     mapping (address => uint256) balances;
80     mapping (address => mapping (address => uint256)) allowances;
81 
82     event Transfer(address indexed _from, address indexed _to, uint256 _value);
83     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
84 }
85 
86 contract tokenRecipientInterface {
87   function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
88 }
89 
90 contract OwnedInterface {
91     address public owner;
92     address public newOwner;
93 
94     modifier onlyOwner {
95         _;
96     }
97 }
98 
99 contract ERC20TokenInterface {
100   function totalSupply() public constant returns (uint256 _totalSupply);
101   function balanceOf(address _owner) public constant returns (uint256 balance);
102   function transfer(address _to, uint256 _value) public returns (bool success);
103   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
104   function approve(address _spender, uint256 _value) public returns (bool success);
105   function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
106 
107   event Transfer(address indexed _from, address indexed _to, uint256 _value);
108   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
109 }
110 
111 
112 
113 
114 
115 
116 
117 contract ERC20Token is ERC20TokenInterface, SafeMath, Owned, Lockable {
118 
119     string public standard;
120     string public name;
121     string public symbol;
122     uint8 public decimals;
123 
124     address public mintingContractAddress;
125 
126     uint256 supply = 0;
127     mapping (address => uint256) balances;
128     mapping (address => mapping (address => uint256)) allowances;
129 
130     event Mint(address indexed _to, uint256 _value);
131     event Burn(address indexed _from, uint _value);
132 
133     function totalSupply() constant public returns (uint256) {
134         return supply;
135     }
136 
137     function balanceOf(address _owner) constant public returns (uint256 balance) {
138         return balances[_owner];
139     }
140 
141     function transfer(address _to, uint256 _value) lockAffected public returns (bool success) {
142         require(_to != 0x0 && _to != address(this));
143         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
144         balances[_to] = safeAdd(balanceOf(_to), _value);
145         emit Transfer(msg.sender, _to, _value);
146         return true;
147     }
148 
149     function approve(address _spender, uint256 _value) lockAffected public returns (bool success) {
150         allowances[msg.sender][_spender] = _value;
151         emit Approval(msg.sender, _spender, _value);
152         return true;
153     }
154 
155     function approveAndCall(address _spender, uint256 _value, bytes _extraData) lockAffected public returns (bool success) {
156         tokenRecipientInterface spender = tokenRecipientInterface(_spender);
157         approve(_spender, _value);
158         spender.receiveApproval(msg.sender, _value, this, _extraData);
159         return true;
160     }
161 
162     function transferFrom(address _from, address _to, uint256 _value) lockAffected public returns (bool success) {
163         require(_to != 0x0 && _to != address(this));
164         balances[_from] = safeSub(balanceOf(_from), _value);
165         balances[_to] = safeAdd(balanceOf(_to), _value);
166         allowances[_from][msg.sender] = safeSub(allowances[_from][msg.sender], _value);
167         emit Transfer(_from, _to, _value);
168         return true;
169     }
170 
171     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
172         return allowances[_owner][_spender];
173     }
174 
175     function mint(address _to, uint256 _amount) public {
176         require(msg.sender == mintingContractAddress);
177         supply = safeAdd(supply, _amount);
178         balances[_to] = safeAdd(balances[_to], _amount);
179         emit Mint(_to, _amount);
180         emit Transfer(0x0, _to, _amount);
181     }
182 
183     function burn(uint _amount) public {
184         balances[msg.sender] = safeSub(balanceOf(msg.sender), _amount);
185         supply = safeSub(supply, _amount);
186         emit Burn(msg.sender, _amount);
187         emit Transfer(msg.sender, 0x0, _amount);
188     }
189 
190     function salvageTokensFromContract(address _tokenAddress, address _to, uint _amount) onlyOwner public {
191         ERC20TokenInterface(_tokenAddress).transfer(_to, _amount);
192     }
193 
194     function killContract() public onlyOwner {
195         selfdestruct(owner);
196     }
197 }
198 
199 
200 
201 contract RoxToken is ERC20Token {
202 
203     constructor() public {
204         name = "Robotina token";
205         symbol = "ROX";
206         decimals = 18;
207         mintingContractAddress = 0x9532014DAdb2C980e43fE4665C86c2c0B1b4603D;
208         lockFromSelf(0, "Lock before crowdsale starts");
209     }
210 }