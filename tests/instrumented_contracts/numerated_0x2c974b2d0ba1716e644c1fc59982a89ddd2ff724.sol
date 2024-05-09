1 library SafeMath {
2   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
3     uint256 c = a * b;
4     assert(a == 0 || c / a == b);
5     return c;
6   }
7 
8   function div(uint256 a, uint256 b) internal constant returns (uint256) {
9     // assert(b > 0); // Solidity automatically throws when dividing by 0
10     uint256 c = a / b;
11     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal constant returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 contract Owned {
28     address public owner;
29     address public newOwner;
30 
31     function Owned() {
32         owner = msg.sender;
33     }
34 
35     modifier onlyOwner {
36         assert(msg.sender == owner);
37         _;
38     }
39 
40     function transferOwnership(address _newOwner) public onlyOwner {
41         require(_newOwner != owner);
42         newOwner = _newOwner;
43     }
44 
45     function acceptOwnership() public {
46         require(msg.sender == newOwner);
47         OwnerUpdate(owner, newOwner);
48         owner = newOwner;
49         newOwner = 0x0;
50     }
51 
52     event OwnerUpdate(address _prevOwner, address _newOwner);
53 }
54 
55 contract Lockable is Owned{
56 
57   uint256 public lockedUntilBlock;
58 
59   event ContractLocked(uint256 _untilBlock, string _reason);
60 
61   modifier lockAffected {
62       require(block.number > lockedUntilBlock);
63       _;
64   }
65 
66   function lockFromSelf(uint256 _untilBlock, string _reason) internal {
67     lockedUntilBlock = _untilBlock;
68     ContractLocked(_untilBlock, _reason);
69   }
70 
71 
72   function lockUntil(uint256 _untilBlock, string _reason) onlyOwner {
73     lockedUntilBlock = _untilBlock;
74     ContractLocked(_untilBlock, _reason);
75   }
76 }
77 
78 contract ReentrancyHandlingContract{
79 
80     bool locked;
81 
82     modifier noReentrancy() {
83         require(!locked);
84         locked = true;
85         _;
86         locked = false;
87     }
88 }
89 contract IMintableToken {
90   function mintTokens(address _to, uint256 _amount){}
91 }
92 contract IERC20Token {
93   function totalSupply() constant returns (uint256 totalSupply);
94   function balanceOf(address _owner) constant returns (uint256 balance) {}
95   function transfer(address _to, uint256 _value) returns (bool success) {}
96   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
97   function approve(address _spender, uint256 _value) returns (bool success) {}
98   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
99 
100   event Transfer(address indexed _from, address indexed _to, uint256 _value);
101   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
102 }
103 contract ItokenRecipient {
104   function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
105 }
106 contract IToken {
107   function totalSupply() constant returns (uint256 totalSupply);
108   function mintTokens(address _to, uint256 _amount) {}
109 }
110 
111 
112 
113 contract Token is IERC20Token, Owned, Lockable{
114 
115   using SafeMath for uint256;
116 
117   /* Public variables of the token */
118   string public standard;
119   string public name;
120   string public symbol;
121   uint8 public decimals;
122 
123   address public crowdsaleContractAddress;
124 
125   /* Private variables of the token */
126   uint256 supply = 0;
127   mapping (address => uint256) balances;
128   mapping (address => mapping (address => uint256)) allowances;
129 
130   /* Events */
131   event Mint(address indexed _to, uint256 _value);
132 
133   /* Returns total supply of issued tokens */
134   function totalSupply() constant returns (uint256) {
135     return supply;
136   }
137 
138   /* Returns balance of address */
139   function balanceOf(address _owner) constant returns (uint256 balance) {
140     return balances[_owner];
141   }
142 
143   /* Transfers tokens from your address to other */
144   function transfer(address _to, uint256 _value) lockAffected returns (bool success) {
145     require(_to != 0x0 && _to != address(this));
146     balances[msg.sender] = balances[msg.sender].sub(_value); // Deduct senders balance
147     balances[_to] = balances[_to].add(_value);               // Add recivers blaance
148     Transfer(msg.sender, _to, _value);                       // Raise Transfer event
149     return true;
150   }
151 
152   /* Approve other address to spend tokens on your account */
153   function approve(address _spender, uint256 _value) lockAffected returns (bool success) {
154     allowances[msg.sender][_spender] = _value;        // Set allowance
155     Approval(msg.sender, _spender, _value);           // Raise Approval event
156     return true;
157   }
158 
159   /* Approve and then communicate the approved contract in a single tx */
160   function approveAndCall(address _spender, uint256 _value, bytes _extraData) lockAffected returns (bool success) {
161     ItokenRecipient spender = ItokenRecipient(_spender);            // Cast spender to tokenRecipient contract
162     approve(_spender, _value);                                      // Set approval to contract for _value
163     spender.receiveApproval(msg.sender, _value, this, _extraData);  // Raise method on _spender contract
164     return true;
165   }
166 
167   /* A contract attempts to get the coins */
168   function transferFrom(address _from, address _to, uint256 _value) lockAffected returns (bool success) {
169     require(_to != 0x0 && _to != address(this));
170     balances[_from] = balances[_from].sub(_value);                              // Deduct senders balance
171     balances[_to] = balances[_to].add(_value);                                  // Add recipient blaance
172     allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_value);  // Deduct allowance for this address
173     Transfer(_from, _to, _value);                                               // Raise Transfer event
174     return true;
175   }
176 
177   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
178     return allowances[_owner][_spender];
179   }
180 
181   function mintTokens(address _to, uint256 _amount) {
182     require(msg.sender == crowdsaleContractAddress);
183 
184     supply = supply.add(_amount);
185     balances[_to] = balances[_to].add(_amount);
186     Mint(_to, _amount);
187     Transfer(0x0, _to, _amount);
188   }
189 
190   function salvageTokensFromContract(address _tokenAddress, address _to, uint _amount) onlyOwner{
191     IERC20Token(_tokenAddress).transfer(_to, _amount);
192   }
193 }
194 
195 
196 
197 
198 
199 
200 contract VibeToken is Token {
201 
202   /* Initializes contract */
203   function VibeToken() {
204     standard = "Viberate token v1.0";
205     name = "Vibe";
206     symbol = "VIB";
207     decimals = 18;
208     crowdsaleContractAddress = 0x91C94BEe75786fBBFdCFefBa1102b68f48A002F4;   
209     lockFromSelf(4352535, "Lock before crowdsale starts");
210   }
211 }