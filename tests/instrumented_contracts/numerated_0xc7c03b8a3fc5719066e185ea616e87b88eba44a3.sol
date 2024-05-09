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
23 contract ERC20TokenInterface {
24     function totalSupply() public constant returns (uint256 _totalSupply);
25     function balanceOf(address _owner) public constant returns (uint256 balance);
26     function transfer(address _to, uint256 _value) public returns (bool success);
27     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
28     function approve(address _spender, uint256 _value) public returns (bool success);
29     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
30 
31     event Transfer(address indexed _from, address indexed _to, uint256 _value);
32     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
33 }
34 contract tokenRecipientInterface {
35     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
36 }
37 contract Owned {
38     address public owner;
39     address public newOwner;
40 
41     function Owned() public {
42         owner = msg.sender;
43     }
44 
45     modifier onlyOwner {
46         assert(msg.sender == owner);
47         _;
48     }
49 
50     function transferOwnership(address _newOwner) public onlyOwner {
51         require(_newOwner != owner);
52         newOwner = _newOwner;
53     }
54 
55     function acceptOwnership() public {
56         require(msg.sender == newOwner);
57         emit OwnerUpdate(owner, newOwner);
58         owner = newOwner;
59         newOwner = 0x0;
60     }
61 
62     event OwnerUpdate(address _prevOwner, address _newOwner);
63 }
64 
65 contract MintableTokenInterface {
66     function mint(address _to, uint256 _amount) public;
67 }
68 contract ReentrancyHandlingContract{
69 
70     bool locked;
71 
72     modifier noReentrancy() {
73         require(!locked);
74         locked = true;
75         _;
76         locked = false;
77     }
78 }
79 contract KycContractInterface {
80     function isAddressVerified(address _address) public view returns (bool);
81 }
82 contract MintingContractInterface {
83 
84     address public crowdsaleContractAddress;
85     address public tokenContractAddress;
86     uint public tokenTotalSupply;
87 
88     event MintMade(address _to, uint _ethAmount, uint _tokensMinted, string _message);
89 
90     function doPresaleMinting(address _destination, uint _tokensAmount, uint _ethAmount) public;
91     function doCrowdsaleMinting(address _destination, uint _tokensAmount, uint _ethAmount) public;
92     function doTeamMinting(address _destination) public;
93     function setTokenContractAddress(address _newAddress) public;
94     function setCrowdsaleContractAddress(address _newAddress) public;
95     function killContract() public;
96 }
97 contract Lockable is Owned {
98 
99     uint256 public lockedUntilBlock;
100 
101     event ContractLocked(uint256 _untilBlock, string _reason);
102 
103     modifier lockAffected {
104         require(block.number > lockedUntilBlock);
105         _;
106     }
107 
108     function lockFromSelf(uint256 _untilBlock, string _reason) internal {
109         lockedUntilBlock = _untilBlock;
110         emit ContractLocked(_untilBlock, _reason);
111     }
112 
113 
114     function lockUntil(uint256 _untilBlock, string _reason) onlyOwner public {
115         lockedUntilBlock = _untilBlock;
116         emit ContractLocked(_untilBlock, _reason);
117     }
118 }
119 
120 contract ERC20Token is ERC20TokenInterface, SafeMath, Owned, Lockable {
121 
122     string public standard;
123     string public name;
124     string public symbol;
125     uint8 public decimals;
126 
127     address public mintingContractAddress;
128 
129     uint256 supply = 0;
130     mapping (address => uint256) balances;
131     mapping (address => mapping (address => uint256)) allowances;
132 
133     event Mint(address indexed _to, uint256 _value);
134     event Burn(address indexed _from, uint _value);
135 
136     function totalSupply() constant public returns (uint256) {
137         return supply;
138     }
139 
140     function balanceOf(address _owner) constant public returns (uint256 balance) {
141         return balances[_owner];
142     }
143 
144     function transfer(address _to, uint256 _value) lockAffected public returns (bool success) {
145         require(_to != 0x0 && _to != address(this));
146         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
147         balances[_to] = safeAdd(balanceOf(_to), _value);
148         emit Transfer(msg.sender, _to, _value);
149         return true;
150     }
151 
152     function approve(address _spender, uint256 _value) lockAffected public returns (bool success) {
153         allowances[msg.sender][_spender] = _value;
154         emit Approval(msg.sender, _spender, _value);
155         return true;
156     }
157 
158     function approveAndCall(address _spender, uint256 _value, bytes _extraData) lockAffected public returns (bool success) {
159         tokenRecipientInterface spender = tokenRecipientInterface(_spender);
160         approve(_spender, _value);
161         spender.receiveApproval(msg.sender, _value, this, _extraData);
162         return true;
163     }
164 
165     function transferFrom(address _from, address _to, uint256 _value) lockAffected public returns (bool success) {
166         require(_to != 0x0 && _to != address(this));
167         balances[_from] = safeSub(balanceOf(_from), _value);
168         balances[_to] = safeAdd(balanceOf(_to), _value);
169         allowances[_from][msg.sender] = safeSub(allowances[_from][msg.sender], _value);
170         emit Transfer(_from, _to, _value);
171         return true;
172     }
173 
174     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
175         return allowances[_owner][_spender];
176     }
177 
178     function mint(address _to, uint256 _amount) public {
179         require(msg.sender == mintingContractAddress);
180         supply = safeAdd(supply, _amount);
181         balances[_to] = safeAdd(balances[_to], _amount);
182         emit Mint(_to, _amount);
183         emit Transfer(0x0, _to, _amount);
184     }
185 
186     function burn(uint _amount) public {
187         balances[msg.sender] = safeSub(balanceOf(msg.sender), _amount);
188         supply = safeSub(supply, _amount);
189         emit Burn(msg.sender, _amount);
190         emit Transfer(msg.sender, 0x0, _amount);
191     }
192 
193     function salvageTokensFromContract(address _tokenAddress, address _to, uint _amount) onlyOwner public {
194         ERC20TokenInterface(_tokenAddress).transfer(_to, _amount);
195     }
196 
197     function killContract() public onlyOwner {
198         selfdestruct(owner);
199     }
200 }
201 
202 
203 
204 contract EligmaTokenContract is ERC20Token {
205 
206   function EligmaTokenContract() public {
207     name = "EligmaToken";
208     symbol = "ELI";
209     decimals = 18;
210     mintingContractAddress = 0xB72Fc3f647C9Bb4FdA13EA2A1Ba9b779EB786770;
211     lockFromSelf(5584081, "Lock before crowdsale starts");
212   }
213 }