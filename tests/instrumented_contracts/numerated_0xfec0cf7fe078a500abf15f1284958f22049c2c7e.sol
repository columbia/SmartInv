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
27 contract IToken {
28   function totalSupply() constant returns (uint256 totalSupply);
29   function mintTokens(address _to, uint256 _amount) {}
30 }
31 contract IMintableToken {
32   function mintTokens(address _to, uint256 _amount){}
33 }
34 contract IERC20Token {
35   function totalSupply() constant returns (uint256 totalSupply);
36   function balanceOf(address _owner) constant returns (uint256 balance) {}
37   function transfer(address _to, uint256 _value) returns (bool success) {}
38   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
39   function approve(address _spender, uint256 _value) returns (bool success) {}
40   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
41 
42   event Transfer(address indexed _from, address indexed _to, uint256 _value);
43   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
44 }
45 
46 contract ItokenRecipient {
47   function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
48 }
49 
50 contract Owned {
51     address public owner;
52     address public newOwner;
53 
54     function Owned() {
55         owner = msg.sender;
56     }
57 
58     modifier onlyOwner {
59         assert(msg.sender == owner);
60         _;
61     }
62 
63     function transferOwnership(address _newOwner) public onlyOwner {
64         require(_newOwner != owner);
65         newOwner = _newOwner;
66     }
67 
68     function acceptOwnership() public {
69         require(msg.sender == newOwner);
70         OwnerUpdate(owner, newOwner);
71         owner = newOwner;
72         newOwner = 0x0;
73     }
74 
75     event OwnerUpdate(address _prevOwner, address _newOwner);
76 }
77 contract ReentrnacyHandlingContract{
78 
79     bool locked;
80 
81     modifier noReentrancy() {
82         require(!locked);
83         locked = true;
84         _;
85         locked = false;
86     }
87 }
88 
89 contract Lockable is Owned{
90 
91   uint256 public lockedUntilBlock;
92 
93   event ContractLocked(uint256 _untilBlock, string _reason);
94 
95   modifier lockAffected {
96       require(block.number > lockedUntilBlock);
97       _;
98   }
99 
100   function lockFromSelf(uint256 _untilBlock, string _reason) internal {
101     lockedUntilBlock = _untilBlock;
102     ContractLocked(_untilBlock, _reason);
103   }
104 
105 
106   function lockUntil(uint256 _untilBlock, string _reason) onlyOwner {
107     lockedUntilBlock = _untilBlock;
108     ContractLocked(_untilBlock, _reason);
109   }
110 }
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
197 contract MaecenasToken is Token {
198 
199   /* Initializes contract */
200   function MaecenasToken() {
201     standard = "Maecenas token v1.0";
202     name = "Maecenas ART Token";
203     symbol = "ART";
204     decimals = 18;
205     crowdsaleContractAddress = 0x9B60874D7bc4e4fBDd142e0F5a12002e4F7715a6; 
206     lockFromSelf(4366494, "Lock before crowdsale starts");
207   }
208 }