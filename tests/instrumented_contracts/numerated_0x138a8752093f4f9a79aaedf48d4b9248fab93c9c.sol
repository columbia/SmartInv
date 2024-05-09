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
27 contract IERC20Token {
28   function totalSupply() constant returns (uint256 totalSupply);
29   function balanceOf(address _owner) constant returns (uint256 balance) {}
30   function transfer(address _to, uint256 _value) returns (bool success) {}
31   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
32   function approve(address _spender, uint256 _value) returns (bool success) {}
33   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
34 
35   event Transfer(address indexed _from, address indexed _to, uint256 _value);
36   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
37 }
38 contract ItokenRecipient {
39   function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
40 }
41 contract IToken {
42   function totalSupply() constant returns (uint256 totalSupply);
43   function mintTokens(address _to, uint256 _amount) {}
44 }
45 contract IMintableToken {
46   function mintTokens(address _to, uint256 _amount){}
47 }
48 contract Owned {
49     address public owner;
50     address public newOwner;
51 
52     function Owned() {
53         owner = msg.sender;
54     }
55 
56     modifier onlyOwner {
57         assert(msg.sender == owner);
58         _;
59     }
60 
61     function transferOwnership(address _newOwner) public onlyOwner {
62         require(_newOwner != owner);
63         newOwner = _newOwner;
64     }
65 
66     function acceptOwnership() public {
67         require(msg.sender == newOwner);
68         OwnerUpdate(owner, newOwner);
69         owner = newOwner;
70         newOwner = 0x0;
71     }
72 
73     event OwnerUpdate(address _prevOwner, address _newOwner);
74 }
75 contract Lockable is Owned{
76 
77   uint256 public lockedUntilBlock;
78 
79   event ContractLocked(uint256 _untilBlock, string _reason);
80 
81   modifier lockAffected {
82       require(block.number > lockedUntilBlock);
83       _;
84   }
85 
86   function lockFromSelf(uint256 _untilBlock, string _reason) internal {
87     lockedUntilBlock = _untilBlock;
88     ContractLocked(_untilBlock, _reason);
89   }
90 
91 
92   function lockUntil(uint256 _untilBlock, string _reason) onlyOwner {
93     lockedUntilBlock = _untilBlock;
94     ContractLocked(_untilBlock, _reason);
95   }
96 }
97 contract ReentrnacyHandlingContract{
98 
99     bool locked;
100 
101     modifier noReentrancy() {
102         require(!locked);
103         locked = true;
104         _;
105         locked = false;
106     }
107 }
108 
109 
110 
111 
112 
113 
114 
115 
116 
117 
118 
119 
120 
121 
122 
123 
124 
125 
126 
127 
128 
129 
130 
131 
132 
133 
134 
135 contract MusiconomiToken is IERC20Token, Owned, Lockable{
136 
137   using SafeMath for uint256;
138 
139   /* Public variables of the token */
140   string public standard = "Musiconomi token v1.0";
141   string public name = "Musiconomi";
142   string public symbol = "MCI";
143   uint8 public decimals = 18;
144 
145   address public crowdsaleContractAddress;
146 
147   /* Private variables of the token */
148   uint256 supply = 0;
149   mapping (address => uint256) balances;
150   mapping (address => mapping (address => uint256)) allowances;
151 
152   /* Events */
153   event Mint(address indexed _to, uint256 _value);
154 
155   /* Initializes contract */
156   function MusiconomiToken() { // TO-DO: set block lock
157     crowdsaleContractAddress = 0xB9e0FC2a1C9d567Af555E07E72f27E686f2c6872;
158     lockFromSelf(4342900, "Lock before crowdsale starts");
159   }
160 
161   /* Returns total supply of issued tokens */
162   function totalSupply() constant returns (uint256) {
163     return supply;
164   }
165 
166   /* Returns balance of address */
167   function balanceOf(address _owner) constant returns (uint256 balance) {
168     return balances[_owner];
169   }
170 
171   /* Transfers tokens from your address to other */
172   function transfer(address _to, uint256 _value) lockAffected returns (bool success) {
173     require(_to != 0x0 && _to != address(this));
174     balances[msg.sender] = balances[msg.sender].sub(_value); // Deduct senders balance
175     balances[_to] = balances[_to].add(_value);               // Add recivers blaance
176     Transfer(msg.sender, _to, _value);                       // Raise Transfer event
177     return true;
178   }
179 
180   /* Approve other address to spend tokens on your account */
181   function approve(address _spender, uint256 _value) lockAffected returns (bool success) {
182     allowances[msg.sender][_spender] = _value;        // Set allowance
183     Approval(msg.sender, _spender, _value);           // Raise Approval event
184     return true;
185   }
186 
187   /* Approve and then communicate the approved contract in a single tx */
188   function approveAndCall(address _spender, uint256 _value, bytes _extraData) lockAffected returns (bool success) {
189     ItokenRecipient spender = ItokenRecipient(_spender);            // Cast spender to tokenRecipient contract
190     approve(_spender, _value);                                      // Set approval to contract for _value
191     spender.receiveApproval(msg.sender, _value, this, _extraData);  // Raise method on _spender contract
192     return true;
193   }
194 
195   /* A contract attempts to get the coins */
196   function transferFrom(address _from, address _to, uint256 _value) lockAffected returns (bool success) {
197     require(_to != 0x0 && _to != address(this));
198     balances[_from] = balances[_from].sub(_value);                              // Deduct senders balance
199     balances[_to] = balances[_to].add(_value);                                  // Add recipient blaance
200     allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_value);  // Deduct allowance for this address
201     Transfer(_from, _to, _value);                                               // Raise Transfer event
202     return true;
203   }
204 
205   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
206     return allowances[_owner][_spender];
207   }
208 
209   function mintTokens(address _to, uint256 _amount) {
210     require(msg.sender == crowdsaleContractAddress);
211 
212     supply = supply.add(_amount);
213     balances[_to] = balances[_to].add(_amount);
214     Mint(_to, _amount);
215     Transfer(0x0, _to, _amount);
216   }
217 
218   function salvageTokensFromContract(address _tokenAddress, address _to, uint _amount) onlyOwner{
219     IERC20Token(_tokenAddress).transfer(_to, _amount);
220   }
221 }