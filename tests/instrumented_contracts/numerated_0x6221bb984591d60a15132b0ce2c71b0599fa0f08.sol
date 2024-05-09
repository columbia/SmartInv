1 pragma solidity ^0.4.18;
2 
3 // Math operations with safety checks that throw on error
4 
5 library SafeMath {
6 
7     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
8         uint256 c = a * b;
9         assert(a == 0 || c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal constant returns (uint256) {
14         uint256 c = a / b;
15         return c;
16     }
17 
18     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal constant returns (uint256) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 }
29 
30 // Simpler version of ERC20 interface
31 
32 contract ERC20Basic {
33     uint256 _totalSupply;
34     function balanceOf(address who) public constant returns (uint256);
35     function transfer(address to, uint256 value) public returns (bool);
36     event Transfer(address indexed from, address indexed to, uint256 value);
37 }
38 
39 // Basic version of StandardToken, with no allowances
40 
41 contract BasicToken is ERC20Basic {
42 
43     using SafeMath for uint256;
44 
45     mapping(address => uint256) balances;
46 
47     function transfer(address _to, uint256 _value) public returns (bool) {
48         require(_to != address(0));
49         require(_value <= balances[msg.sender]);
50         balances[msg.sender] = balances[msg.sender].sub(_value);
51         balances[_to] = balances[_to].add(_value);
52         Transfer(msg.sender, _to, _value);
53         return true;
54     }
55 
56     function balanceOf(address _owner) public constant returns (uint256 balance) {
57         return balances[_owner];
58     }
59 }
60 
61 // ERC20 interface
62 
63 contract ERC20 is ERC20Basic {
64     function allowance(address owner, address spender) public constant returns (uint256);
65     function transferFrom(address from, address to, uint256 value) public returns (bool);
66     function approve(address spender, uint256 value) public returns (bool);
67     event Approval(address indexed owner, address indexed spender, uint256 value);
68 }
69 
70 // Standard ERC20 token - Implementation of the basic standard token
71 
72 contract StandardToken is ERC20, BasicToken {
73 
74     mapping (address => mapping (address => uint256)) internal allowed;
75 
76     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
77         require(_to != address(0));
78         require(_value <= balances[_from]);
79         require(_value <= allowed[_from][msg.sender]);
80         balances[_from] = balances[_from].sub(_value);
81         balances[_to] = balances[_to].add(_value);
82         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
83         Transfer(_from, _to, _value);
84         return true;
85     }
86 
87     function approve(address _spender, uint256 _value) public returns (bool) {
88         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
89         allowed[msg.sender][_spender] = _value;
90         Approval(msg.sender, _spender, _value);
91         return true;
92     }
93 
94     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
95         return allowed[_owner][_spender];
96     }
97 }
98 
99 // Burnable contract
100 
101 contract Burnable is StandardToken {
102 
103     event Burn(address indexed burner, uint256 value);
104 
105     function burn(uint256 _value) public {
106 
107         require(_value > 0);
108         require(_value <= balances[msg.sender]);
109 
110         address burner = msg.sender;
111 
112         balances[burner] = balances[burner].sub(_value);
113         _totalSupply = _totalSupply.sub(_value);
114 
115         Burn(burner, _value);
116     }
117 }
118 
119 // Ownable contract
120 
121 contract Ownable {
122 
123     address public owner;
124 
125     function Ownable() public {
126         owner = msg.sender;
127     }
128 
129     modifier onlyOwner() {
130         require(msg.sender == owner);
131         _;
132     }
133 
134     function transferOwnership(address newOwner) public onlyOwner {
135         require(newOwner != address(0));
136         owner = newOwner;
137     }
138 }
139 
140 // Carblox Token
141 
142 contract CarbloxToken is StandardToken, Ownable, Burnable {
143 
144     string public constant name = "Carblox Token";
145     string public constant symbol = "CRX";
146     uint256 public constant decimals = 3;
147     uint256 public constant initialSupply = 100000000 * 10**3;
148 
149     function CarbloxToken() public {
150         _totalSupply = initialSupply;
151         balances[msg.sender] = initialSupply;
152     }
153     
154     function totalSupply() public constant returns (uint256) {
155         return _totalSupply;
156     }
157 }