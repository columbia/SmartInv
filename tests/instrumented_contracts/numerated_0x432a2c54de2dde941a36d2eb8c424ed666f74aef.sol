1 pragma solidity >=0.4.22 <0.6.0;
2 
3 contract ERC20 {
4     uint256 public totalSupply;
5     function balanceOf(address _owner) view public  returns (uint256 balance);
6     function transfer(address _to, uint256 _value) public returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
8     function approve(address _spender, uint256 _value) public returns (bool success);
9     function allowance(address _owner, address _spender) view public returns (uint256 remaining);
10 
11     event Transfer(address indexed _from, address indexed _to, uint256 _value);
12     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
13 }
14 
15 library SafeMath {
16   function mul(uint a, uint b) internal pure returns (uint) {
17     uint c = a * b;
18     assert(a == 0 || c / a == b);
19     return c;
20   }
21 
22   function div(uint a, uint b) internal pure returns (uint) {
23     uint c = a / b;
24     return c;
25   }
26 
27   function sub(uint a, uint b) internal pure returns (uint) {
28     assert(b <= a);
29     return a - b;
30   }
31 
32   function add(uint a, uint b) internal pure returns (uint) {
33     uint c = a + b;
34     assert(c >= a);
35     return c;
36   }
37 
38   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
39     return a >= b ? a : b;
40   }
41 
42   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
43     return a < b ? a : b;
44   }
45 
46   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
47     return a >= b ? a : b;
48   }
49 
50   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
51     return a < b ? a : b;
52   }
53 
54 
55 }
56 
57 contract Token is ERC20 {
58 
59     using SafeMath for uint;
60     mapping (address => uint256) balances;
61     mapping (address => mapping (address => uint256)) allowed;
62     string public name;
63     uint8 public decimals;
64     string public symbol;
65 
66     constructor(uint256 _initialAmount, uint8 _decimalUnits, string memory _tokenName, string memory _tokenSymbol) public {
67         decimals = _decimalUnits;
68         totalSupply = _initialAmount * 10**uint(decimals);
69         balances[msg.sender] = totalSupply;
70         name = _tokenName;
71         symbol = _tokenSymbol;   
72     }
73 
74     function balanceOf(address _owner) view public returns (uint256 balance) {
75         return balances[_owner];
76     }
77 
78     function transfer(address _to, uint256 _value) public returns (bool success) {
79         require(balances[msg.sender] >= _value && _value > 0); 
80         balances[msg.sender] = balances[msg.sender].sub(_value);
81         balances[_to] = balances[_to].add(_value);
82         emit Transfer(msg.sender, _to, _value);
83         return true;
84         
85     }
86 
87     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
88         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0); 
89         uint256 _allowance = allowed[_from][msg.sender];
90         balances[_to] = balances[_to].add(_value);
91         balances[_from] = balances[_from].sub(_value);
92         allowed[_from][msg.sender] = _allowance.sub(_value);
93         emit Transfer(_from, _to, _value);
94         return true;
95     }
96 
97     function approve(address _spender, uint256 _value) public returns (bool success) {
98         require(_value >= 0); 
99         allowed[msg.sender][_spender] = _value;
100         emit Approval(msg.sender, _spender, _value);
101         return true;
102     }
103 
104     function allowance(address _owner, address _spender) view public returns (uint256 remaining) {
105       return allowed[_owner][_spender];
106     }
107 }
108 
109 contract MerculetToken is Token {
110 
111     string public version = 'v2.0';
112 
113     constructor () public Token(10000000000,18,'Merculet','MVP')  {
114 
115     }
116     
117 }