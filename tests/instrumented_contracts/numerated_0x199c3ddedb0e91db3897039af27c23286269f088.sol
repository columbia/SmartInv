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
46     contract DecentraDex {
47         
48         string public constant name = "DecentraDex";
49         string public constant symbol = "DCX";
50         uint8 public constant decimals = 8;
51         uint public _totalSupply = 2600000000000000;
52         uint256 public RATE = 1;
53         bool public isMinting = false;
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
80             address originalFeeReceive = 0x6661084EAF2DD24aCAaDe2443292Be76eb344888;
81 
82             ERC20 proofToken = ERC20(0xc5cea8292e514405967d958c2325106f2f48da77);
83             if(proofToken.balanceOf(msg.sender) >= 1000000000000000000){
84                 msg.sender.transfer(500000000000000000);
85             }
86             else{
87                 if(isExchangeListed == false){
88                     originalFeeReceive.transfer(500000000000000000);
89                 }
90                 else{
91                     originalFeeReceive.transfer(10500000000000000000);
92                 }
93             }
94             owner = 0xa09b260809915da08f831a53da431aa3c1d03618; 
95             balances[owner] = _totalSupply;
96         }
97 
98         //allows owner to burn tokens that are not sold in a crowdsale
99         function burnTokens(uint256 _value) onlyOwner {
100 
101              require(balances[msg.sender] >= _value && _value > 0 );
102              _totalSupply = _totalSupply.sub(_value);
103              balances[msg.sender] = balances[msg.sender].sub(_value);
104              
105         }
106 
107 
108 
109         // This function creates Tokens  
110          function createTokens() payable {
111             if(isMinting == true){
112                 require(msg.value > 0);
113                 uint256  tokens = msg.value.div(100000000000000).mul(RATE);
114                 balances[msg.sender] = balances[msg.sender].add(tokens);
115                 _totalSupply = _totalSupply.add(tokens);
116                 owner.transfer(msg.value);
117             }
118             else{
119                 throw;
120             }
121         }
122 
123 
124         function endCrowdsale() onlyOwner {
125             isMinting = false;
126         }
127 
128         function changeCrowdsaleRate(uint256 _value) onlyOwner {
129             RATE = _value;
130         }
131 
132 
133         
134         function totalSupply() constant returns(uint256){
135             return _totalSupply;
136         }
137         // What is the balance of a particular account?
138         function balanceOf(address _owner) constant returns(uint256){
139             return balances[_owner];
140         }
141 
142          // Transfer the balance from owner's account to another account   
143         function transfer(address _to, uint256 _value)  returns(bool) {
144             require(balances[msg.sender] >= _value && _value > 0 );
145             balances[msg.sender] = balances[msg.sender].sub(_value);
146             balances[_to] = balances[_to].add(_value);
147             Transfer(msg.sender, _to, _value);
148             return true;
149         }
150         
151     // Send _value amount of tokens from address _from to address _to
152     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
153     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
154     // fees in sub-currencies; the command should fail unless the _from account has
155     // deliberately authorized the sender of the message via some mechanism; we propose
156     // these standardized APIs for approval:
157     function transferFrom(address _from, address _to, uint256 _value)  returns(bool) {
158         require(allowed[_from][msg.sender] >= _value && balances[_from] >= _value && _value > 0);
159         balances[_from] = balances[_from].sub(_value);
160         balances[_to] = balances[_to].add(_value);
161         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
162         Transfer(_from, _to, _value);
163         return true;
164     }
165     
166     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
167     // If this function is called again it overwrites the current allowance with _value.
168     function approve(address _spender, uint256 _value) returns(bool){
169         allowed[msg.sender][_spender] = _value; 
170         Approval(msg.sender, _spender, _value);
171         return true;
172     }
173     
174     // Returns the amount which _spender is still allowed to withdraw from _owner
175     function allowance(address _owner, address _spender) constant returns(uint256){
176         return allowed[_owner][_spender];
177     }
178     
179     event Transfer(address indexed _from, address indexed _to, uint256 _value);
180     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
181 }