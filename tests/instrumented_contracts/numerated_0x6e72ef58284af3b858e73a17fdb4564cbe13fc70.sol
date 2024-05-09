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
28     contract Alycoin {
29         
30         string public constant name = "Alycoin";
31         string public constant symbol = "ALY";
32         uint8 public constant decimals = 4;
33         uint public _totalSupply = 823540000000;
34         uint256 public RATE = 1;
35         bool public isMinting = true;
36         string public constant generatedBy  = "Togen.io by Proof Suite";
37         
38         using SafeMath for uint256;
39         address public owner;
40         
41          // Functions with this modifier can only be executed by the owner
42          modifier onlyOwner() {
43             if (msg.sender != owner) {
44                 throw;
45             }
46              _;
47          }
48      
49         // Balances for each account
50         mapping(address => uint256) balances;
51         // Owner of account approves the transfer of an amount to another account
52         mapping(address => mapping(address=>uint256)) allowed;
53 
54         // Its a payable function works as a token factory.
55         function () payable{
56             createTokens();
57         }
58 
59         // Constructor
60         constructor() public {
61             owner = 0xa84545111cee1a303886430fc5b53507371878d2; 
62             balances[owner] = _totalSupply;
63         }
64 
65         //allows owner to burn tokens that are not sold in a crowdsale
66         function burnTokens(uint256 _value) onlyOwner {
67 
68              require(balances[msg.sender] >= _value && _value > 0 );
69              _totalSupply = _totalSupply.sub(_value);
70              balances[msg.sender] = balances[msg.sender].sub(_value);
71              
72         }
73 
74 
75 
76         // This function creates Tokens  
77          function createTokens() payable {
78             if(isMinting == true){
79                 require(msg.value > 0);
80                 uint256  tokens = msg.value.div(100000000000000).mul(RATE);
81                 balances[msg.sender] = balances[msg.sender].add(tokens);
82                 _totalSupply = _totalSupply.add(tokens);
83                 owner.transfer(msg.value);
84             }
85             else{
86                 throw;
87             }
88         }
89 
90 
91         function endCrowdsale() onlyOwner {
92             isMinting = false;
93         }
94 
95         function changeCrowdsaleRate(uint256 _value) onlyOwner {
96             RATE = _value;
97         }
98 
99 
100         
101         function totalSupply() constant returns(uint256){
102             return _totalSupply;
103         }
104         // What is the balance of a particular account?
105         function balanceOf(address _owner) constant returns(uint256){
106             return balances[_owner];
107         }
108 
109          // Transfer the balance from owner's account to another account   
110         function transfer(address _to, uint256 _value)  returns(bool) {
111             require(balances[msg.sender] >= _value && _value > 0 );
112             balances[msg.sender] = balances[msg.sender].sub(_value);
113             balances[_to] = balances[_to].add(_value);
114             Transfer(msg.sender, _to, _value);
115             return true;
116         }
117         
118     // Send _value amount of tokens from address _from to address _to
119     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
120     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
121     // fees in sub-currencies; the command should fail unless the _from account has
122     // deliberately authorized the sender of the message via some mechanism; we propose
123     // these standardized APIs for approval:
124     function transferFrom(address _from, address _to, uint256 _value)  returns(bool) {
125         require(allowed[_from][msg.sender] >= _value && balances[_from] >= _value && _value > 0);
126         balances[_from] = balances[_from].sub(_value);
127         balances[_to] = balances[_to].add(_value);
128         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
129         Transfer(_from, _to, _value);
130         return true;
131     }
132     
133     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
134     // If this function is called again it overwrites the current allowance with _value.
135     function approve(address _spender, uint256 _value) returns(bool){
136         allowed[msg.sender][_spender] = _value; 
137         Approval(msg.sender, _spender, _value);
138         return true;
139     }
140     
141     // Returns the amount which _spender is still allowed to withdraw from _owner
142     function allowance(address _owner, address _spender) constant returns(uint256){
143         return allowed[_owner][_spender];
144     }
145     
146     event Transfer(address indexed _from, address indexed _to, uint256 _value);
147     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
148 }