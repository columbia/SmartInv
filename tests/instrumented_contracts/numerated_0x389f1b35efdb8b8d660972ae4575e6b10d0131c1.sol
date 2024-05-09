1 pragma solidity ^0.4.24;
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
57 contract StarxCoin is owned,IERC20{
58     
59     using SafeMath for uint256;
60     
61     uint256 public constant _totalSupply = 2000000000000000000000000000;
62  
63     string public symbol = 'STRX';
64 
65     string public name = 'Starx Coin';
66     
67     uint8 public constant decimals = 18;
68     
69     mapping(address => uint256) public balances;
70     mapping (address => mapping (address => uint256)) allowed;
71   
72 
73     function StarxCoin() {
74        // owner = msg.sender;
75         balances[msg.sender] = _totalSupply;
76     }
77     
78    function rebrand(string _symbol, string _name) onlyOwner {
79         symbol = _symbol;
80         name   = _name;
81     }
82     
83     function totalSupply() constant returns (uint256 totalSupply) {
84         return _totalSupply;
85     }
86    
87     function balanceOf(address _owner) constant returns (uint256 balance) {
88         return balances[_owner];
89     }
90     
91     function transfer(address _to, uint256 _value) returns (bool success) {
92         require(
93             balances[msg.sender] >= _value
94             && _value > 0
95         );
96 
97         balances[msg.sender] = balances[msg.sender].sub(_value);
98         balances[_to] = balances[_to].add(_value);
99         Transfer(msg.sender, _to, _value);
100         return true;
101     }
102 
103     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
104         require(
105             allowed[_from][msg.sender] >= _value  // Check allowance
106             && balances[_from] >= _value    // Check if the sender has enough
107             && _value > 0    // Don't allow 0value transfer
108         );
109         balances[_from] = balances[_from].sub(_value);
110         balances[_to] = balances[_to].add(_value);
111         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
112         Transfer(_from, _to, _value);
113         return true;
114     }
115 
116     function approve(address _spender, uint256 _value) returns (bool success) {
117         allowed[msg.sender][_spender] = _value;
118         Approval(msg.sender, _spender, _value);
119         return true;
120     }
121 
122     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
123         return allowed[_owner][_spender];
124     }
125 
126     
127     event Transfer(address indexed _from, address indexed _to, uint256 _value);
128     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
129 
130 }