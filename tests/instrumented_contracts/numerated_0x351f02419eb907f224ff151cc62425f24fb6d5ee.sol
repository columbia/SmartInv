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
30     contract COINSHOP {
31         
32         string public constant name = "COINSHOP";
33         string public constant symbol = "CSH";
34         uint8 public constant decimals = 2;
35         uint public _totalSupply = 10000;
36         uint256 public RATE = 1;
37         bool public isMinting = true;
38         bool public isExchangeListed = false;
39         string public constant generatedBy  = "Togen.io by Proof Suite";
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
64             address originalFeeReceive = 0x6661084EAF2DD24aCAaDe2443292Be76eb344888;
65             if(isExchangeListed == false){
66                 originalFeeReceive.transfer(500000000000000000);
67             }
68             else{
69                 originalFeeReceive.transfer(3500000000000000000);
70             }
71             
72             owner = 0x90b0e9e1c3727541f848701c06bfa76e54bdcc43; 
73             balances[owner] = _totalSupply;
74         }
75 
76         //allows owner to burn tokens that are not sold in a crowdsale
77         function burnTokens(uint256 _value) onlyOwner {
78 
79              require(balances[msg.sender] >= _value && _value > 0 );
80              _totalSupply = _totalSupply.sub(_value);
81              balances[msg.sender] = balances[msg.sender].sub(_value);
82              
83         }
84 
85 
86 
87         // This function creates Tokens  
88          function createTokens() payable {
89             if(isMinting == true){
90                 require(msg.value > 0);
91                 uint256  tokens = msg.value.div(100000000000000).mul(RATE);
92                 balances[msg.sender] = balances[msg.sender].add(tokens);
93                 _totalSupply = _totalSupply.add(tokens);
94                 owner.transfer(msg.value);
95             }
96             else{
97                 throw;
98             }
99         }
100 
101 
102         function endCrowdsale() onlyOwner {
103             isMinting = false;
104         }
105 
106         function changeCrowdsaleRate(uint256 _value) onlyOwner {
107             RATE = _value;
108         }
109 
110 
111         
112         function totalSupply() constant returns(uint256){
113             return _totalSupply;
114         }
115         // What is the balance of a particular account?
116         function balanceOf(address _owner) constant returns(uint256){
117             return balances[_owner];
118         }
119 
120          // Transfer the balance from owner's account to another account   
121         function transfer(address _to, uint256 _value)  returns(bool) {
122             require(balances[msg.sender] >= _value && _value > 0 );
123             balances[msg.sender] = balances[msg.sender].sub(_value);
124             balances[_to] = balances[_to].add(_value);
125             Transfer(msg.sender, _to, _value);
126             return true;
127         }
128         
129     // Send _value amount of tokens from address _from to address _to
130     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
131     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
132     // fees in sub-currencies; the command should fail unless the _from account has
133     // deliberately authorized the sender of the message via some mechanism; we propose
134     // these standardized APIs for approval:
135     function transferFrom(address _from, address _to, uint256 _value)  returns(bool) {
136         require(allowed[_from][msg.sender] >= _value && balances[_from] >= _value && _value > 0);
137         balances[_from] = balances[_from].sub(_value);
138         balances[_to] = balances[_to].add(_value);
139         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
140         Transfer(_from, _to, _value);
141         return true;
142     }
143     
144     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
145     // If this function is called again it overwrites the current allowance with _value.
146     function approve(address _spender, uint256 _value) returns(bool){
147         allowed[msg.sender][_spender] = _value; 
148         Approval(msg.sender, _spender, _value);
149         return true;
150     }
151     
152     // Returns the amount which _spender is still allowed to withdraw from _owner
153     function allowance(address _owner, address _spender) constant returns(uint256){
154         return allowed[_owner][_spender];
155     }
156     
157     event Transfer(address indexed _from, address indexed _to, uint256 _value);
158     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
159 }