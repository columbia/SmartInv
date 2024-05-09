1 pragma solidity ^0.4.11;
2 
3 interface IERC20 {
4     function totalSupply() constant returns (uint256 totalSupply);
5     function balanceOf(address _owner) constant returns (uint256 balance);
6     function transfer(address _to, uint256 _value) returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
8     function approve(address _spender, uint256 _value) returns (bool success);
9     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 library SafeMath {
15   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
16     uint256 c = a * b;
17     assert(a == 0 || c / a == b);
18     return c;
19   }
20 
21   function div(uint256 a, uint256 b) internal constant returns (uint256) {
22     // assert(b > 0); // Solidity automatically throws when dividing by 0
23     uint256 c = a / b;
24     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25     return c;
26   }
27 
28   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33   function add(uint256 a, uint256 b) internal constant returns (uint256) {
34     uint256 c = a + b;
35     assert(c >= a);
36     return c;
37   }
38 }
39 
40 contract owned {
41         address public owner;
42 
43         function owned() {
44             owner = msg.sender;
45         }
46 
47         modifier onlyOwner {
48             require(msg.sender == owner);
49             _;
50         }
51 
52         function transferOwnership(address newOwner) onlyOwner {
53             owner = newOwner;
54         }
55 }
56 
57 contract ApexCoin is owned,IERC20{
58     
59     using SafeMath for uint256;
60     
61     uint256 public constant _totalSupply = 28000000000000000000000000;
62  
63     string public symbol = 'APC';
64 
65     string public name = 'Apex Coin';
66     
67     uint8 public constant decimals = 18;
68     
69     // 1 ether equels to 1000 tokens
70     //uint256 public constant tokensPerEther = 1000;
71     
72     mapping(address => uint256) public balances;
73     mapping (address => mapping (address => uint256)) allowed;
74     
75    /* function () payable {
76         createTokens();
77     }*/
78     
79 
80     function ApexCoin() {
81        // owner = msg.sender;
82         balances[msg.sender] = _totalSupply;
83     }
84     
85    function rebrand(string _symbol, string _name) onlyOwner {
86         symbol = _symbol;
87         name   = _name;
88     }
89     
90   /* function createTokens() payable {
91         require(
92             msg.value > 0
93         );
94         uint256 baseTokens  = msg.value.mul(tokensPerEther);
95         balances[msg.sender] = balances[msg.sender].add(baseTokens);
96         _totalSupply      = _totalSupply.add(baseTokens);
97         
98         owner.transfer(msg.value);
99     }
100     */
101     
102     function totalSupply() constant returns (uint256 totalSupply) {
103         return _totalSupply;
104     }
105    
106     function balanceOf(address _owner) constant returns (uint256 balance) {
107         return balances[_owner];
108     }
109     
110     function transfer(address _to, uint256 _value) returns (bool success) {
111         require(
112             balances[msg.sender] >= _value
113             && _value > 0
114         );
115 
116         balances[msg.sender] = balances[msg.sender].sub(_value);
117         balances[_to] = balances[_to].add(_value);
118         Transfer(msg.sender, _to, _value);
119         return true;
120     }
121 
122     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
123         require(
124             allowed[_from][msg.sender] >= _value  // Check allowance
125             && balances[_from] >= _value    // Check if the sender has enough
126             && _value > 0    // Don't allow 0value transfer
127         );
128         balances[_from] = balances[_from].sub(_value);
129         balances[_to] = balances[_to].add(_value);
130         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
131         Transfer(_from, _to, _value);
132         return true;
133     }
134 
135     function approve(address _spender, uint256 _value) returns (bool success) {
136         allowed[msg.sender][_spender] = _value;
137         Approval(msg.sender, _spender, _value);
138         return true;
139     }
140 
141     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
142         return allowed[_owner][_spender];
143     }
144 
145     
146     event Transfer(address indexed _from, address indexed _to, uint256 _value);
147     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
148 
149 }