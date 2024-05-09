1 pragma solidity ^0.4.13;
2 
3 contract ItokenRecipient {
4   function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
5 }
6 
7 contract IERC20Token {
8   function totalSupply() public constant returns (uint256 totalSupply);
9   function balanceOf(address _owner) public constant returns (uint256 balance) {}
10   function transfer(address _to, uint256 _value) public returns (bool success) {}
11   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {}
12   function approve(address _spender, uint256 _value) public returns (bool success) {}
13   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {}
14 
15   event Transfer(address indexed _from, address indexed _to, uint256 _value);
16   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
17 }
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
25     uint256 c = a * b;
26     assert(a == 0 || c / a == b);
27     return c;
28   }
29 
30   function div(uint256 a, uint256 b) internal constant returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return c;
35   }
36 
37   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   function add(uint256 a, uint256 b) internal constant returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 contract Owned {
50     address public owner;
51     address public newOwner;
52 
53     function Owned() public{
54         owner = msg.sender;
55     }
56 
57     modifier onlyOwner {
58         assert(msg.sender == owner);
59         _;
60     }
61 
62     function transferOwnership(address _newOwner) public onlyOwner {
63         require(_newOwner != owner);
64         newOwner = _newOwner;
65     }
66 
67     function acceptOwnership() public {
68         require(msg.sender == newOwner);
69         OwnerUpdate(owner, newOwner);
70         owner = newOwner;
71         newOwner = 0x0;
72     }
73 
74     event OwnerUpdate(address _prevOwner, address _newOwner);
75 }
76 
77 
78 contract LockableOwned is Owned{
79 
80   uint256 public lockedUntilTime;
81 
82   event ContractLocked(uint256 _untilTime, string _reason);
83 
84   modifier lockAffected {
85       require(block.timestamp > lockedUntilTime);
86       _;
87   }
88 
89   function lockFromSelf(uint256 _untilTime, string _reason) internal {
90     lockedUntilTime = _untilTime;
91     ContractLocked(_untilTime, _reason);
92   }
93 
94 
95   function lockUntil(uint256 _untilTime, string _reason) onlyOwner {
96     lockedUntilTime = _untilTime;
97     ContractLocked(_untilTime, _reason);
98   }
99 }
100 
101 
102 contract Token is IERC20Token, LockableOwned {
103 
104   using SafeMath for uint256;
105 
106   /* Public variables of the token */
107   string public standard;
108   string public name;
109   string public symbol;
110   uint8 public decimals;
111 
112   address public crowdsaleContractAddress;
113 
114   /* Private variables of the token */
115   uint256 supply = 0;
116   mapping (address => uint256) balances;
117   mapping (address => mapping (address => uint256)) allowances;
118 
119   /* Events */
120   event Mint(address indexed _to, uint256 _value);
121 
122   /* Returns total supply of issued tokens */
123   function totalSupply() constant returns (uint256) {
124     return supply;
125   }
126 
127   /* Returns balance of address */
128   function balanceOf(address _owner) constant returns (uint256 balance) {
129     return balances[_owner];
130   }
131 
132   /* Transfers tokens from your address to other */
133   function transfer(address _to, uint256 _value) lockAffected returns (bool success) {
134     require(_to != 0x0 && _to != address(this));
135     balances[msg.sender] = balances[msg.sender].sub(_value); // Deduct senders balance
136     balances[_to] = balances[_to].add(_value);               // Add receivers balance
137     Transfer(msg.sender, _to, _value);                       // Raise Transfer event
138     return true;
139   }
140 
141   /* Approve other address to spend tokens on your account */
142   function approve(address _spender, uint256 _value) lockAffected returns (bool success) {
143     allowances[msg.sender][_spender] = _value;        // Set allowance
144     Approval(msg.sender, _spender, _value);           // Raise Approval event
145     return true;
146   }
147 
148   /* Approve and then communicate the approved contract in a single tx */
149   function approveAndCall(address _spender, uint256 _value, bytes _extraData) lockAffected returns (bool success) {
150     ItokenRecipient spender = ItokenRecipient(_spender);            // Cast spender to tokenRecipient contract
151     approve(_spender, _value);                                      // Set approval to contract for _value
152     spender.receiveApproval(msg.sender, _value, this, _extraData);  // Raise method on _spender contract
153     return true;
154   }
155 
156   /* A contract attempts to get the coins */
157   function transferFrom(address _from, address _to, uint256 _value) lockAffected returns (bool success) {
158     require(_to != 0x0 && _to != address(this));
159     balances[_from] = balances[_from].sub(_value);                              // Deduct senders balance
160     balances[_to] = balances[_to].add(_value);                                  // Add recipient balance
161     allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_value);  // Deduct allowance for this address
162     Transfer(_from, _to, _value);                                               // Raise Transfer event
163     return true;
164   }
165 
166   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
167     return allowances[_owner][_spender];
168   }
169 
170   function mintTokens(address _to, uint256 _amount) {
171     require(msg.sender == crowdsaleContractAddress);
172 
173     supply = supply.add(_amount);
174     balances[_to] = balances[_to].add(_amount);
175     Mint(_to, _amount);
176     Transfer(0x0, _to, _amount);
177   }
178 
179   function salvageTokensFromContract(address _tokenAddress, address _to, uint _amount) onlyOwner{
180     IERC20Token(_tokenAddress).transfer(_to, _amount);
181   }
182 }
183 
184 
185 contract FutouristToken is Token {
186 
187   /* Initializes contract */
188   function FutouristToken() {
189     standard = " v1.0";
190     name = "FutouristToken";
191     symbol = "FTR";
192     decimals = 18;
193     crowdsaleContractAddress = 0x642CE99AaD0cCc6fEd7930117b217A18ce4B4229;
194     lockFromSelf(1521561600, "Lock before crowdsale starts");
195   }
196 }