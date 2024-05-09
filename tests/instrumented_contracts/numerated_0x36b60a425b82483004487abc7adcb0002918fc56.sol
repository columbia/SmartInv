1 pragma solidity ^0.4.25;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29     // ERC20 Token Smart Contract
30     contract TICOEXToken {
31         
32         string public constant name = "TICOEX Token";
33         string public constant symbol = "TICO";
34         uint8 public constant decimals = 8;
35         uint public _totalSupply = 10110110100000000;
36         uint256 public RATE = 0;
37         bool public isMinting = false;
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
61         constructor() public {
62             owner = 0x1850363833e923c99e555710f889716c5bb46bb1; 
63             balances[owner] = _totalSupply;
64         }
65 
66         //allows owner to burn tokens that are not sold in a crowdsale
67         function burnTokens(uint256 _value) onlyOwner {
68 
69              require(balances[msg.sender] >= _value && _value > 0 );
70              _totalSupply = _totalSupply.sub(_value);
71              balances[msg.sender] = balances[msg.sender].sub(_value);
72              
73         }
74 
75 
76 
77         // This function creates Tokens  
78          function createTokens() payable {
79             if(isMinting == true){
80                 require(msg.value > 0);
81                 uint256  tokens = msg.value.mul(RATE);
82                 balances[msg.sender] = balances[msg.sender].add(tokens);
83                 _totalSupply = _totalSupply.add(tokens);
84                 owner.transfer(msg.value);
85             }
86             else{
87                 throw;
88             }
89         }
90 
91 
92         function endCrowdsale() onlyOwner {
93             isMinting = false;
94         }
95 
96         function changeCrowdsaleRate(uint256 _value) onlyOwner {
97             RATE = _value;
98         }
99 
100 
101         
102         function totalSupply() constant returns(uint256){
103             return _totalSupply;
104         }
105         // What is the balance of a particular account?
106         function balanceOf(address _owner) constant returns(uint256){
107             return balances[_owner];
108         }
109 
110          // Transfer the balance from owner's account to another account   
111         function transfer(address _to, uint256 _value)  returns(bool) {
112             require(balances[msg.sender] >= _value && _value > 0 );
113             balances[msg.sender] = balances[msg.sender].sub(_value);
114             balances[_to] = balances[_to].add(_value);
115             Transfer(msg.sender, _to, _value);
116             return true;
117         }
118         
119     // Send _value amount of tokens from address _from to address _to
120     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
121     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
122     // fees in sub-currencies; the command should fail unless the _from account has
123     // deliberately authorized the sender of the message via some mechanism; we propose
124     // these standardized APIs for approval:
125     function transferFrom(address _from, address _to, uint256 _value)  returns(bool) {
126         require(allowed[_from][msg.sender] >= _value && balances[_from] >= _value && _value > 0);
127         balances[_from] = balances[_from].sub(_value);
128         balances[_to] = balances[_to].add(_value);
129         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
130         Transfer(_from, _to, _value);
131         return true;
132     }
133     
134     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
135     // If this function is called again it overwrites the current allowance with _value.
136     function approve(address _spender, uint256 _value) returns(bool){
137         allowed[msg.sender][_spender] = _value; 
138         Approval(msg.sender, _spender, _value);
139         return true;
140     }
141     
142     // Returns the amount which _spender is still allowed to withdraw from _owner
143     function allowance(address _owner, address _spender) constant returns(uint256){
144         return allowed[_owner][_spender];
145     }
146     
147     event Transfer(address indexed _from, address indexed _to, uint256 _value);
148     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
149 }