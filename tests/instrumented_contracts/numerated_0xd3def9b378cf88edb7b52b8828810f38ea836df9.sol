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
30     contract Whim {
31         
32         string public constant name = "Whim";
33         string public constant symbol = "EWC";
34         uint8 public constant decimals = 10;
35         uint public _totalSupply = 120000000000000000;
36         uint256 public RATE = 1;
37         bool public isMinting = false;
38         string public constant generatedBy  = "Togen.io by Proof Suite";
39         
40         using SafeMath for uint256;
41         address public owner;
42         
43          // Functions with this modifier can only be executed by the owner
44          modifier onlyOwner() {
45             if (msg.sender != owner) {
46                 throw;
47             }
48              _;
49          }
50      
51         // Balances for each account
52         mapping(address => uint256) balances;
53         // Owner of account approves the transfer of an amount to another account
54         mapping(address => mapping(address=>uint256)) allowed;
55 
56         // Its a payable function works as a token factory.
57         function () payable{
58             createTokens();
59         }
60 
61         // Constructor
62         constructor() public {
63             owner = 0xac6e8508321153d3c767a5d783138dcb9764e621; 
64             balances[owner] = _totalSupply;
65         }
66 
67         //allows owner to burn tokens that are not sold in a crowdsale
68         function burnTokens(uint256 _value) onlyOwner {
69 
70              require(balances[msg.sender] >= _value && _value > 0 );
71              _totalSupply = _totalSupply.sub(_value);
72              balances[msg.sender] = balances[msg.sender].sub(_value);
73              
74         }
75 
76 
77 
78         // This function creates Tokens  
79          function createTokens() payable {
80             if(isMinting == true){
81                 require(msg.value > 0);
82                 uint256  tokens = msg.value.div(100000000000000).mul(RATE);
83                 balances[msg.sender] = balances[msg.sender].add(tokens);
84                 _totalSupply = _totalSupply.add(tokens);
85                 owner.transfer(msg.value);
86             }
87             else{
88                 throw;
89             }
90         }
91 
92 
93         function endCrowdsale() onlyOwner {
94             isMinting = false;
95         }
96 
97         function changeCrowdsaleRate(uint256 _value) onlyOwner {
98             RATE = _value;
99         }
100 
101 
102         
103         function totalSupply() constant returns(uint256){
104             return _totalSupply;
105         }
106         // What is the balance of a particular account?
107         function balanceOf(address _owner) constant returns(uint256){
108             return balances[_owner];
109         }
110 
111          // Transfer the balance from owner's account to another account   
112         function transfer(address _to, uint256 _value)  returns(bool) {
113             require(balances[msg.sender] >= _value && _value > 0 );
114             balances[msg.sender] = balances[msg.sender].sub(_value);
115             balances[_to] = balances[_to].add(_value);
116             Transfer(msg.sender, _to, _value);
117             return true;
118         }
119         
120     // Send _value amount of tokens from address _from to address _to
121     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
122     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
123     // fees in sub-currencies; the command should fail unless the _from account has
124     // deliberately authorized the sender of the message via some mechanism; we propose
125     // these standardized APIs for approval:
126     function transferFrom(address _from, address _to, uint256 _value)  returns(bool) {
127         require(allowed[_from][msg.sender] >= _value && balances[_from] >= _value && _value > 0);
128         balances[_from] = balances[_from].sub(_value);
129         balances[_to] = balances[_to].add(_value);
130         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
131         Transfer(_from, _to, _value);
132         return true;
133     }
134     
135     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
136     // If this function is called again it overwrites the current allowance with _value.
137     function approve(address _spender, uint256 _value) returns(bool){
138         allowed[msg.sender][_spender] = _value; 
139         Approval(msg.sender, _spender, _value);
140         return true;
141     }
142     
143     // Returns the amount which _spender is still allowed to withdraw from _owner
144     function allowance(address _owner, address _spender) constant returns(uint256){
145         return allowed[_owner][_spender];
146     }
147     
148     event Transfer(address indexed _from, address indexed _to, uint256 _value);
149     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
150 }