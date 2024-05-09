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
27     function Owned() public {
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
50 
51 contract Lockable is Owned {
52 
53     uint256 public lockedUntilBlock;
54 
55     event ContractLocked(uint256 _untilBlock, string _reason);
56 
57     modifier lockAffected {
58         require(block.number > lockedUntilBlock);
59         _;
60     }
61 
62     function lockFromSelf(uint256 _untilBlock, string _reason) internal {
63         lockedUntilBlock = _untilBlock;
64         ContractLocked(_untilBlock, _reason);
65     }
66 
67 
68     function lockUntil(uint256 _untilBlock, string _reason) onlyOwner public {
69         lockedUntilBlock = _untilBlock;
70         ContractLocked(_untilBlock, _reason);
71     }
72 }
73 contract ERC20TokenInterface {
74   function totalSupply() public constant returns (uint256 _totalSupply);
75   function balanceOf(address _owner) public constant returns (uint256 balance);
76   function transfer(address _to, uint256 _value) public returns (bool success);
77   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
78   function approve(address _spender, uint256 _value) public returns (bool success);
79   function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
80 
81   event Transfer(address indexed _from, address indexed _to, uint256 _value);
82   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
83 }
84 contract TokenRecipientInterface {
85   function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
86 }
87 
88 contract ERC20Token is ERC20TokenInterface, SafeMath, Owned, Lockable {
89 
90     /* Public variables of the token */
91     string public name;
92     string public symbol;
93     uint8 public decimals;
94 
95     bool mintingEnabled = true;
96 
97     /* Private variables of the token */
98     uint256 supply = 0;
99     mapping (address => uint256) balances;
100     mapping (address => mapping (address => uint256)) allowances;
101 
102     event Mint(address indexed _to, uint256 _value);
103     event Burn(address indexed _from, uint _value);
104 
105     /* Returns total supply of issued tokens */
106     function totalSupply() constant public returns (uint256) {
107         return supply;
108     }
109 
110     /* Returns balance of address */
111     function balanceOf(address _owner) constant public returns (uint256 balance) {
112         return balances[_owner];
113     }
114 
115     /* Transfers tokens from your address to other */
116     function transfer(address _to, uint256 _value) lockAffected public returns (bool success) {
117         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);  // Deduct senders balance
118         balances[_to] = safeAdd(balanceOf(_to), _value);                // Add recivers blaance
119         Transfer(msg.sender, _to, _value);                              // Raise Transfer event
120         return true;
121     }
122 
123     /* Approve other address to spend tokens on your account */
124     function approve(address _spender, uint256 _value) lockAffected public returns (bool success) {
125         allowances[msg.sender][_spender] = _value;        // Set allowance
126         Approval(msg.sender, _spender, _value);           // Raise Approval event
127         return true;
128     }
129 
130     /* Approve and then communicate the approved contract in a single tx */
131     function approveAndCall(address _spender, uint256 _value, bytes _extraData) lockAffected public returns (bool success) {
132         TokenRecipientInterface spender = TokenRecipientInterface(_spender);    // Cast spender to tokenRecipient contract
133         approve(_spender, _value);                                              // Set approval to contract for _value
134         spender.receiveApproval(msg.sender, _value, this, _extraData);          // Raise method on _spender contract
135         return true;
136     }
137 
138     /* A contract attempts to get the coins */
139     function transferFrom(address _from, address _to, uint256 _value) lockAffected public returns (bool success) {
140         balances[_from] = safeSub(balanceOf(_from), _value);                            // Deduct senders balance
141         balances[_to] = safeAdd(balanceOf(_to), _value);                                // Add recipient blaance
142         allowances[_from][msg.sender] = safeSub(allowances[_from][msg.sender], _value); // Deduct allowance for this address
143         Transfer(_from, _to, _value);                                                   // Raise Transfer event
144         return true;
145     }
146 
147     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
148         return allowances[_owner][_spender];
149     }
150 
151     function mint(address _to, uint256 _amount) onlyOwner public {
152         require(mintingEnabled);
153         supply = safeAdd(supply, _amount);
154         balances[_to] = safeAdd(balances[_to], _amount);
155         Mint(_to, _amount);
156         Transfer(0x0, _to, _amount);
157     }
158 
159     function disableMinting() onlyOwner public {
160         mintingEnabled = false;
161     }
162 
163     function burn(uint _amount) public {
164         balances[msg.sender] = safeSub(balanceOf(msg.sender), _amount);
165         supply = safeSub(supply, _amount);
166         Burn(msg.sender, _amount);
167         Transfer(msg.sender, 0x0, _amount);
168     }
169 
170     function salvageTokensFromContract(address _tokenAddress, address _to, uint _amount) onlyOwner public {
171         ERC20TokenInterface(_tokenAddress).transfer(_to, _amount);
172     }
173     
174     function killContract() onlyOwner public {
175         selfdestruct(owner);
176     }
177 }
178 
179 
180 
181 contract NewsTokenContract is ERC20Token {
182 
183   /* Initializes contract */
184   function NewsTokenContract() public {
185     name = "NewsToken";
186     symbol = "NWS";
187     decimals = 18;
188     lockFromSelf(5170000, "Lock before crowdsale starts");
189   }
190 }