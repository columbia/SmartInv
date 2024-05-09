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
27     // ERC20 Token Smart Contract
28     contract TOTLEToken {
29         
30         string public constant name = "TOTLEToken";
31         string public constant symbol = "TOT";
32         uint8 public constant decimals = 1;
33         uint public _totalSupply = 100000000;
34         uint256 public RATE = 1;
35         bool public isMinting = false;
36         bool public isExchangeListed = false;
37         string public constant generatedBy  = "Togen.io by Proof Suite";
38         
39         using SafeMath for uint256;
40         address public owner;
41         
42          // Functions with this modifier can only be executed by the owner
43          modifier onlyOwner() {
44             if (msg.sender != owner) {
45                 throw;
46             }
47              _;
48          }
49      
50         // Balances for each account
51         mapping(address => uint256) balances;
52         // Owner of account approves the transfer of an amount to another account
53         mapping(address => mapping(address=>uint256)) allowed;
54 
55         // Its a payable function works as a token factory.
56         function () payable{
57             createTokens();
58         }
59 
60         // Constructor
61         constructor() public payable {
62             address originalFeeReceive = 0x6661084EAF2DD24aCAaDe2443292Be76eb344888;
63             if(isExchangeListed == false){
64                 originalFeeReceive.transfer(500000000000000000);
65             }
66             else{
67                 originalFeeReceive.transfer(3500000000000000000);
68             }
69             
70             owner = 0xfc970041ecd3c8d98eff714783f026b7e013ec7b; 
71             balances[owner] = _totalSupply;
72         }
73 
74         //allows owner to burn tokens that are not sold in a crowdsale
75         function burnTokens(uint256 _value) onlyOwner {
76 
77              require(balances[msg.sender] >= _value && _value > 0 );
78              _totalSupply = _totalSupply.sub(_value);
79              balances[msg.sender] = balances[msg.sender].sub(_value);
80              
81         }
82 
83 
84 
85         // This function creates Tokens  
86          function createTokens() payable {
87             if(isMinting == true){
88                 require(msg.value > 0);
89                 uint256  tokens = msg.value.div(100000000000000).mul(RATE);
90                 balances[msg.sender] = balances[msg.sender].add(tokens);
91                 _totalSupply = _totalSupply.add(tokens);
92                 owner.transfer(msg.value);
93             }
94             else{
95                 throw;
96             }
97         }
98 
99 
100         function endCrowdsale() onlyOwner {
101             isMinting = false;
102         }
103 
104         function changeCrowdsaleRate(uint256 _value) onlyOwner {
105             RATE = _value;
106         }
107 
108 
109         
110         function totalSupply() constant returns(uint256){
111             return _totalSupply;
112         }
113         // What is the balance of a particular account?
114         function balanceOf(address _owner) constant returns(uint256){
115             return balances[_owner];
116         }
117 
118          // Transfer the balance from owner's account to another account   
119         function transfer(address _to, uint256 _value)  returns(bool) {
120             require(balances[msg.sender] >= _value && _value > 0 );
121             balances[msg.sender] = balances[msg.sender].sub(_value);
122             balances[_to] = balances[_to].add(_value);
123             Transfer(msg.sender, _to, _value);
124             return true;
125         }
126         
127     // Send _value amount of tokens from address _from to address _to
128     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
129     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
130     // fees in sub-currencies; the command should fail unless the _from account has
131     // deliberately authorized the sender of the message via some mechanism; we propose
132     // these standardized APIs for approval:
133     function transferFrom(address _from, address _to, uint256 _value)  returns(bool) {
134         require(allowed[_from][msg.sender] >= _value && balances[_from] >= _value && _value > 0);
135         balances[_from] = balances[_from].sub(_value);
136         balances[_to] = balances[_to].add(_value);
137         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
138         Transfer(_from, _to, _value);
139         return true;
140     }
141     
142     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
143     // If this function is called again it overwrites the current allowance with _value.
144     function approve(address _spender, uint256 _value) returns(bool){
145         allowed[msg.sender][_spender] = _value; 
146         Approval(msg.sender, _spender, _value);
147         return true;
148     }
149     
150     // Returns the amount which _spender is still allowed to withdraw from _owner
151     function allowance(address _owner, address _spender) constant returns(uint256){
152         return allowed[_owner][_spender];
153     }
154     
155     event Transfer(address indexed _from, address indexed _to, uint256 _value);
156     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
157 }