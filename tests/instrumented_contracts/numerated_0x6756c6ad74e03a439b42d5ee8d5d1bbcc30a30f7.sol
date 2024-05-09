1 pragma solidity ^0.4.25;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     require(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     require(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     require(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     require(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     require(c >= a);
25     return c;
26   }
27 }
28 
29     // ERC20 Token Smart Contract
30     contract Savingcoin {
31         
32         string public constant name = "Savingcoin";
33         string public constant symbol = "SAC";
34         uint8 public constant decimals = 8;
35         uint public _totalSupply = 20000000000000000;
36         uint256 public RATE = 300;
37         bool public isMinting = true;
38         string public constant generatedBy  = "Savingcoin Devteam";
39         
40         using SafeMath for uint256;
41         address public owner;
42         
43          // Functions with this modifier can only be executed by the owner
44          modifier onlyOwner() {
45             require(msg.sender == owner);
46             _;
47          }
48 
49         // Balances for each account
50         mapping(address => uint256) balances;
51         // Owner of account approves the transfer of an amount to another account
52         mapping(address => mapping(address=>uint256)) allowed;
53 
54         // Its a payable function works as a token factory.
55         function () payable {
56             createTokens();
57         }
58 
59         // Constructor
60         constructor() public {
61             owner = 0x47281854D50bbFb81Da704c267ab9693F1054F40; 
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
77      function createTokens() payable {
78         if(isMinting == true){
79             require(msg.value > 0, "No funds");
80             uint256  tokens = msg.value.div(100000000000000).mul(RATE);
81             balances[msg.sender] = balances[msg.sender].add(tokens);
82             _totalSupply = _totalSupply.add(tokens);
83             owner.transfer(msg.value);
84         }
85         else{
86             revert();
87         }
88     }
89        function endCrowdsale() onlyOwner {
90        isMinting = false;
91         }
92 
93         function changeCrowdsaleRate(uint256 _value) onlyOwner {
94             RATE = _value;
95         }
96 
97 
98         
99         function totalSupply() constant returns(uint256){
100             return _totalSupply;
101         }
102         // What is the balance of a particular account?
103         function balanceOf(address _owner) constant returns(uint256){
104             return balances[_owner];
105         }
106 
107          // Transfer the balance from owner's account to another account   
108         function transfer(address _to, uint256 _value)  returns(bool) {
109             require(balances[msg.sender] >= _value && _value > 0 );
110             balances[msg.sender] = balances[msg.sender].sub(_value);
111             balances[_to] = balances[_to].add(_value);
112             emit Transfer(msg.sender, _to, _value);
113             return true;
114         }
115         
116     // Send _value amount of tokens from address _from to address _to
117     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
118     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
119     // fees in sub-currencies; the command should fail unless the _from account has
120     // deliberately authorized the sender of the message via some mechanism; we propose
121     // these standardized APIs for approval:
122     function transferFrom(address _from, address _to, uint256 _value)  returns(bool) {
123         require(allowed[_from][msg.sender] >= _value && balances[_from] >= _value && _value > 0);
124         balances[_from] = balances[_from].sub(_value);
125         balances[_to] = balances[_to].add(_value);
126         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
127         emit Transfer(_from, _to, _value);
128         return true;
129     }
130     
131     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
132     // If this function is called again it overwrites the current allowance with _value.
133     function approve(address _spender, uint256 _value) returns(bool){
134         allowed[msg.sender][_spender] = _value; 
135         emit Approval(msg.sender, _spender, _value);
136         return true;
137     }
138     
139     // Returns the amount which _spender is still allowed to withdraw from _owner
140     function allowance(address _owner, address _spender) constant returns(uint256){
141         return allowed[_owner][_spender];
142     }
143     
144     event Transfer(address indexed _from, address indexed _to, uint256 _value);
145     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
146 }