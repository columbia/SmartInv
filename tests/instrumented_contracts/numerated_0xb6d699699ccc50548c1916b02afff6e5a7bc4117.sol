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
30     contract DraperToken {
31         
32         string public constant name = "Draper Token";
33         string public constant symbol = "DRAPER";
34         uint8 public constant decimals = 10;
35         uint public _totalSupply = 10000000000000000;
36         uint256 public RATE = 1;
37         bool public isMinting = false;
38         bool public isExchangeListed = false;
39         string public constant generatedBy  = "drapersolutions.com";
40         
41         using SafeMath for uint256;
42         address public owner;
43         
44          // Functions with this modifier can only be executed by the owner
45          modifier onlyOwner() {
46             if (msg.sender != owner) {
47                 throw;
48             }
49              _;
50          }
51      
52         // Balances for each account
53         mapping(address => uint256) balances;
54         // Owner of account approves the transfer of an amount to another account
55         mapping(address => mapping(address=>uint256)) allowed;
56 
57         // Its a payable function works as a token factory.
58         function () payable{
59             createTokens();
60         }
61 
62         // Constructor
63         constructor() public payable {
64 
65             owner = 0xf1E6836b1355c5De3A66E57d8DD9C6D375D94df8; 
66             balances[owner] = _totalSupply;
67         }
68 
69         //allows owner to burn tokens that are not sold in a crowdsale
70         function burnTokens(uint256 _value) onlyOwner {
71 
72              require(balances[msg.sender] >= _value && _value > 0 );
73              _totalSupply = _totalSupply.sub(_value);
74              balances[msg.sender] = balances[msg.sender].sub(_value);
75              
76         }
77 
78 
79 
80         // This function creates Tokens  
81          function createTokens() payable {
82             if(isMinting == true){
83                 require(msg.value > 0);
84                 uint256  tokens = msg.value.div(100000000000000).mul(RATE);
85                 balances[msg.sender] = balances[msg.sender].add(tokens);
86                 _totalSupply = _totalSupply.add(tokens);
87                 owner.transfer(msg.value);
88             }
89             else{
90                 throw;
91             }
92         }
93 
94 
95         function endCrowdsale() onlyOwner {
96             isMinting = false;
97         }
98 
99         function changeCrowdsaleRate(uint256 _value) onlyOwner {
100             RATE = _value;
101         }
102 
103 
104         
105         function totalSupply() constant returns(uint256){
106             return _totalSupply;
107         }
108         // What is the balance of a particular account?
109         function balanceOf(address _owner) constant returns(uint256){
110             return balances[_owner];
111         }
112 
113          // Transfer the balance from owner's account to another account   
114         function transfer(address _to, uint256 _value)  returns(bool) {
115             require(balances[msg.sender] >= _value && _value > 0 );
116             balances[msg.sender] = balances[msg.sender].sub(_value);
117             balances[_to] = balances[_to].add(_value);
118             Transfer(msg.sender, _to, _value);
119             return true;
120         }
121         
122     // Send _value amount of tokens from address _from to address _to
123     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
124     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
125     // fees in sub-currencies; the command should fail unless the _from account has
126     // deliberately authorized the sender of the message via some mechanism; we propose
127     // these standardized APIs for approval:
128     function transferFrom(address _from, address _to, uint256 _value)  returns(bool) {
129         require(allowed[_from][msg.sender] >= _value && balances[_from] >= _value && _value > 0);
130         balances[_from] = balances[_from].sub(_value);
131         balances[_to] = balances[_to].add(_value);
132         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
133         Transfer(_from, _to, _value);
134         return true;
135     }
136     
137     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
138     // If this function is called again it overwrites the current allowance with _value.
139     function approve(address _spender, uint256 _value) returns(bool){
140         allowed[msg.sender][_spender] = _value; 
141         Approval(msg.sender, _spender, _value);
142         return true;
143     }
144     
145     // Returns the amount which _spender is still allowed to withdraw from _owner
146     function allowance(address _owner, address _spender) constant returns(uint256){
147         return allowed[_owner][_spender];
148     }
149     
150     event Transfer(address indexed _from, address indexed _to, uint256 _value);
151     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
152 }