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
29 // ERC20 Token Smart Contract
30 contract Kentkoin {
31     
32     string public constant name = "Kentkoin";
33     string public constant symbol = "Kk";
34     uint8 public constant decimals = 18;
35     uint public _totalSupply = 10000000000;
36     uint256 public RATE = 500;
37     bool public isMinting = true;
38     
39     using SafeMath for uint256;
40     address public owner;
41     
42      // Functions with this modifier can only be executed by the owner
43      modifier onlyOwner() {
44         if (msg.sender != owner) {
45             throw;
46         }
47          _;
48      }
49      
50     // Balances for each account
51     mapping(address => uint256) balances;
52     // Owner of account approves the transfer of an amount to another account
53     mapping(address => mapping(address=>uint256)) allowed;
54 
55     // Its a payable function works as a token factory.
56     function () payable{
57         createTokens();
58     }
59 
60     // Contructor
61 function Kentkoin(){
62         owner = 0xee1e4c65f234e98c8d398fabfc80579e23a8a04e; 
63     }
64 
65 
66 
67     // This function creates Tokens  
68      function createTokens() payable {
69         if(isMinting == true){
70             require(msg.value > 0);
71             uint256  tokens = msg.value.mul(RATE);
72             balances[msg.sender] = balances[msg.sender].add(tokens);
73             owner.transfer(msg.value);
74         }
75         else{
76             throw;
77         }
78     }
79 
80 
81     function endCrowdsale() onlyOwner {
82         isMinting = false;
83     }
84 
85     function changeCrowdsaleRate(uint256 _value) onlyOwner {
86         RATE = _value;
87     }
88 
89 
90     
91     function totalSupply() constant returns(uint256){
92         return _totalSupply;
93     }
94     // What is the balance of a particular account?
95     function balanceOf(address _owner) constant returns(uint256){
96         return balances[_owner];
97     }
98 
99      // Transfer the balance from owner's account to another account   
100     function transfer(address _to, uint256 _value)  returns(bool) {
101         require(balances[msg.sender] >= _value && _value > 0 );
102         balances[msg.sender] = balances[msg.sender].sub(_value);
103         balances[_to] = balances[_to].add(_value);
104         Transfer(msg.sender, _to, _value);
105         return true;
106     }
107     
108     // Send _value amount of tokens from address _from to address _to
109     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
110     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
111     // fees in sub-currencies; the command should fail unless the _from account has
112     // deliberately authorized the sender of the message via some mechanism; we propose
113     // these standardized APIs for approval:
114     function transferFrom(address _from, address _to, uint256 _value)  returns(bool) {
115         require(allowed[_from][msg.sender] >= _value && balances[_from] >= _value && _value > 0);
116         balances[_from] = balances[_from].sub(_value);
117         balances[_to] = balances[_to].add(_value);
118         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
119         Transfer(_from, _to, _value);
120         return true;
121     }
122     
123     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
124     // If this function is called again it overwrites the current allowance with _value.
125     function approve(address _spender, uint256 _value) returns(bool){
126         allowed[msg.sender][_spender] = _value; 
127         Approval(msg.sender, _spender, _value);
128         return true;
129     }
130     
131     // Returns the amount which _spender is still allowed to withdraw from _owner
132     function allowance(address _owner, address _spender) constant returns(uint256){
133         return allowed[_owner][_spender];
134     }
135     
136     event Transfer(address indexed _from, address indexed _to, uint256 _value);
137     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
138 }