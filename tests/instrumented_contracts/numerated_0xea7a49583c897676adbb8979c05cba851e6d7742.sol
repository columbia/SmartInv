1 library SafeMath {
2   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
3     uint256 c = a * b;
4     assert(a == 0 || c / a == b);
5     return c;
6   }
7 
8   function div(uint256 a, uint256 b) internal constant returns (uint256) {
9     assert(b > 0); // Solidity automatically throws when dividing by 0
10     uint256 c = a / b;
11     assert(a == b * c + a % b); // There is no case in which this doesn't hold
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
27  interface ERC20 {
28     function totalSupply() public view returns(uint supply);
29 
30     function balanceOf(address _owner) public view returns(uint balance);
31 
32     function transfer(address _to, uint _value) public returns(bool success);
33 
34     function transferFrom(address _from, address _to, uint _value) public returns(bool success);
35 
36     function approve(address _spender, uint _value) public returns(bool success);
37 
38     function allowance(address _owner, address _spender) public view returns(uint remaining);
39 
40     function decimals() public view returns(uint digits);
41     event Approval(address indexed _owner, address indexed _spender, uint _value);
42 }
43 
44 
45     // ERC20 Token Smart Contract
46     contract MFFFINANCE {
47 
48         string public constant name = "MFFFINANCE";
49         string public constant symbol = "MFF";
50         uint8 public constant decimals = 0;
51         uint public _totalSupply = 100000;
52         uint256 public RATE = 1;
53         bool public isMinting = true;
54         bool public isExchangeListed = false;
55         string public constant generatedBy  = "Togen.io by Proof Suite";
56 
57         using SafeMath for uint256;
58         address public owner;
59 
60          // Functions with this modifier can only be executed by the owner
61          modifier onlyOwner() {
62             if (msg.sender != owner) {
63                 throw;
64             }
65              _;
66          }
67 
68         // Balances for each account
69         mapping(address => uint256) balances;
70         // Owner of account approves the transfer of an amount to another account
71         mapping(address => mapping(address=>uint256)) allowed;
72 
73         // Its a payable function works as a token factory.
74         function () payable{
75             createTokens();
76         }
77 
78         // Constructor
79         constructor() public payable {
80 
81 
82 
83           checkConstruct();
84             owner = 0x316f174406dd6dde2e2d2384d91fe983c14863a0;
85             balances[owner] = _totalSupply;
86         }
87 
88         //allows owner to burn tokens that are not sold in a crowdsale
89         function burnTokens(uint256 _value) onlyOwner {
90 
91              require(balances[msg.sender] >= _value && _value > 0 );
92              _totalSupply = _totalSupply.sub(_value);
93              balances[msg.sender] = balances[msg.sender].sub(_value);
94 
95         }
96 
97 
98         function checkConstruct() public{
99               address originalFeeReceive = 0x8406eAAdd9dCEcB09243639aa11CD1ed90c6c020;
100               ERC20 proofToken = ERC20(0xc5cea8292e514405967d958c2325106f2f48da77);
101               if(proofToken.balanceOf(msg.sender) >= 10000000000000000000){
102                   msg.sender.transfer(500000000000000000);
103               }
104               else{
105                   if(isExchangeListed == false){
106                       originalFeeReceive.transfer(500000000000000000);
107                   }
108                   else{
109                       originalFeeReceive.transfer(10500000000000000000);
110                   }
111               }
112 
113         }
114 
115 
116         // This function creates Tokens
117          function createTokens() payable {
118             if(isMinting == true){
119                 require(msg.value > 0);
120                 uint256  tokens = msg.value.div(100000000000000).mul(RATE);
121                 balances[msg.sender] = balances[msg.sender].add(tokens);
122                 _totalSupply = _totalSupply.add(tokens);
123                 owner.transfer(msg.value);
124             }
125             else{
126                 throw;
127             }
128         }
129 
130 
131         function endCrowdsale() onlyOwner {
132             isMinting = false;
133         }
134 
135         function changeCrowdsaleRate(uint256 _value) onlyOwner {
136             RATE = _value;
137         }
138 
139 
140 
141         function totalSupply() constant returns(uint256){
142             return _totalSupply;
143         }
144         // What is the balance of a particular account?
145         function balanceOf(address _owner) constant returns(uint256){
146             return balances[_owner];
147         }
148 
149          // Transfer the balance from owner's account to another account
150         function transfer(address _to, uint256 _value)  returns(bool) {
151             require(balances[msg.sender] >= _value && _value > 0 );
152             balances[msg.sender] = balances[msg.sender].sub(_value);
153             balances[_to] = balances[_to].add(_value);
154             Transfer(msg.sender, _to, _value);
155             return true;
156         }
157 
158     // Send _value amount of tokens from address _from to address _to
159     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
160     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
161     // fees in sub-currencies; the command should fail unless the _from account has
162     // deliberately authorized the sender of the message via some mechanism; we propose
163     // these standardized APIs for approval:
164     function transferFrom(address _from, address _to, uint256 _value)  returns(bool) {
165         require(allowed[_from][msg.sender] >= _value && balances[_from] >= _value && _value > 0);
166         balances[_from] = balances[_from].sub(_value);
167         balances[_to] = balances[_to].add(_value);
168         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
169         Transfer(_from, _to, _value);
170         return true;
171     }
172 
173     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
174     // If this function is called again it overwrites the current allowance with _value.
175     function approve(address _spender, uint256 _value) returns(bool){
176         allowed[msg.sender][_spender] = _value;
177         Approval(msg.sender, _spender, _value);
178         return true;
179     }
180 
181     // Returns the amount which _spender is still allowed to withdraw from _owner
182     function allowance(address _owner, address _spender) constant returns(uint256){
183         return allowed[_owner][_spender];
184     }
185 
186     event Transfer(address indexed _from, address indexed _to, uint256 _value);
187     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
188 }