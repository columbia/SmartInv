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
26 contract IERC20Token {
27   function totalSupply() constant returns (uint256 totalSupply);
28   function balanceOf(address _owner) constant returns (uint256 balance) {}
29   function transfer(address _to, uint256 _value) returns (bool success) {}
30   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
31   function approve(address _spender, uint256 _value) returns (bool success) {}
32   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
33 
34   event Transfer(address indexed _from, address indexed _to, uint256 _value);
35   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
36 }
37 contract ItokenRecipient {
38   function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
39 }
40 contract IToken {
41   function totalSupply() constant returns (uint256 totalSupply);
42   function mintTokens(address _to, uint256 _amount) {}
43 }
44 contract IMintableToken {
45   function mintTokens(address _to, uint256 _amount){}
46 }
47 contract ReentrnacyHandlingContract{
48 
49     bool locked;
50 
51     modifier noReentrancy() {
52         require(!locked);
53         locked = true;
54         _;
55         locked = false;
56     }
57 }
58 
59 contract Owned {
60     address public owner;
61     address public newOwner;
62 
63     function Owned() {
64         owner = msg.sender;
65     }
66 
67     modifier onlyOwner {
68         assert(msg.sender == owner);
69         _;
70     }
71 
72     function transferOwnership(address _newOwner) public onlyOwner {
73         require(_newOwner != owner);
74         newOwner = _newOwner;
75     }
76 
77     function acceptOwnership() public {
78         require(msg.sender == newOwner);
79         OwnerUpdate(owner, newOwner);
80         owner = newOwner;
81         newOwner = 0x0;
82     }
83 
84     event OwnerUpdate(address _prevOwner, address _newOwner);
85 }
86 contract Lockable is Owned{
87 
88   uint256 public lockedUntilBlock;
89 
90   event ContractLocked(uint256 _untilBlock, string _reason);
91 
92   modifier lockAffected {
93       require(block.number > lockedUntilBlock);
94       _;
95   }
96 
97   function lockFromSelf(uint256 _untilBlock, string _reason) internal {
98     lockedUntilBlock = _untilBlock;
99     ContractLocked(_untilBlock, _reason);
100   }
101 
102 
103   function lockUntil(uint256 _untilBlock, string _reason) onlyOwner {
104     lockedUntilBlock = _untilBlock;
105     ContractLocked(_untilBlock, _reason);
106   }
107 }
108 
109 contract Token is IERC20Token, Owned, Lockable{
110 
111   using SafeMath for uint256;
112 
113   /* Public variables of the token */
114   string public standard;
115   string public name;
116   string public symbol;
117   uint8 public decimals;
118 
119   address public crowdsaleContractAddress;
120 
121   /* Private variables of the token */
122   uint256 supply = 0;
123   mapping (address => uint256) balances;
124   mapping (address => mapping (address => uint256)) allowances;
125 
126   /* Events */
127   event Mint(address indexed _to, uint256 _value);
128 
129   /* Returns total supply of issued tokens */
130   function totalSupply() constant returns (uint256) {
131     return supply;
132   }
133 
134   /* Returns balance of address */
135   function balanceOf(address _owner) constant returns (uint256 balance) {
136     return balances[_owner];
137   }
138 
139   /* Transfers tokens from your address to other */
140   function transfer(address _to, uint256 _value) lockAffected returns (bool success) {
141     require(_to != 0x0 && _to != address(this));
142     balances[msg.sender] = balances[msg.sender].sub(_value); // Deduct senders balance
143     balances[_to] = balances[_to].add(_value);               // Add recivers blaance
144     Transfer(msg.sender, _to, _value);                       // Raise Transfer event
145     return true;
146   }
147 
148   /* Approve other address to spend tokens on your account */
149   function approve(address _spender, uint256 _value) lockAffected returns (bool success) {
150     allowances[msg.sender][_spender] = _value;        // Set allowance
151     Approval(msg.sender, _spender, _value);           // Raise Approval event
152     return true;
153   }
154 
155   /* Approve and then communicate the approved contract in a single tx */
156   function approveAndCall(address _spender, uint256 _value, bytes _extraData) lockAffected returns (bool success) {
157     ItokenRecipient spender = ItokenRecipient(_spender);            // Cast spender to tokenRecipient contract
158     approve(_spender, _value);                                      // Set approval to contract for _value
159     spender.receiveApproval(msg.sender, _value, this, _extraData);  // Raise method on _spender contract
160     return true;
161   }
162 
163   /* A contract attempts to get the coins */
164   function transferFrom(address _from, address _to, uint256 _value) lockAffected returns (bool success) {
165     require(_to != 0x0 && _to != address(this));
166     balances[_from] = balances[_from].sub(_value);                              // Deduct senders balance
167     balances[_to] = balances[_to].add(_value);                                  // Add recipient blaance
168     allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_value);  // Deduct allowance for this address
169     Transfer(_from, _to, _value);                                               // Raise Transfer event
170     return true;
171   }
172 
173   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
174     return allowances[_owner][_spender];
175   }
176 
177   function mintTokens(address _to, uint256 _amount) {
178     require(msg.sender == crowdsaleContractAddress);
179 
180     supply = supply.add(_amount);
181     balances[_to] = balances[_to].add(_amount);
182     Mint(_to, _amount);
183     Transfer(0x0, _to, _amount);
184   }
185 
186   function salvageTokensFromContract(address _tokenAddress, address _to, uint _amount) onlyOwner{
187     IERC20Token(_tokenAddress).transfer(_to, _amount);
188   }
189 }
190 
191 
192 
193 
194 
195 
196 contract DPPToken is Token {
197 
198   /* Initializes contract */
199   function DPPToken() {
200     standard = "DA Power Play Token token v1.0";
201     name = "DA Power Play Token";
202     symbol = "DPP";
203     decimals = 18;
204     crowdsaleContractAddress = 0x6f0d792B540afA2c8772B9bA4805E7436ad8413e; 
205     lockFromSelf(4393122, "Lock before crowdsale starts");
206   }
207 }