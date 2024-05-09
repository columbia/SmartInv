1 pragma solidity ^0.4.25;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         assert(b > 0);
16         uint256 c = a / b;
17         assert(a == b * c + a % b); 
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 
34 contract ERC20Basic {
35     function totalSupply() public view returns (uint256);
36     function balanceOf(address who) public view returns (uint256);
37     function transfer(address to, uint256 value) public returns (bool);
38     function transferFrom(address from, address to, uint256 value) public returns (bool);
39     function allowance(address owner, address spender) public view returns (uint256);
40     function approve(address spender, uint256 value) public returns (bool);
41     
42     event Approval(address indexed owner, address indexed spender, uint256 value);
43     event Transfer(address indexed from, address indexed to, uint256 value);
44 }
45 
46 
47 contract StandardToken is ERC20Basic {
48     mapping (address => mapping (address => uint256)) internal allowed;
49     mapping(address => uint256) balances;
50     uint256 _totalSupply;
51     
52     using SafeMath for uint256;
53 
54     function totalSupply() public view returns (uint256) {
55         return _totalSupply;
56     }
57 
58     function transfer(address _to, uint256 _value) public returns (bool) {
59         require(_to != address(0));
60         require(_value <= balances[msg.sender]);
61         require(balances[_to] + _value >= balances[ _to]);
62 
63         balances[msg.sender] = balances[msg.sender].sub(_value);
64         balances[_to] = balances[_to].add(_value);
65         emit Transfer(msg.sender, _to, _value);
66         return true;
67     }
68 
69     function balanceOf(address _owner) public view returns (uint256 balance) {
70         return balances[_owner];
71     }
72 
73     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
74         require(_to != address(0));
75         require(_value <= balances[_from]);
76         require(_value <= allowed[_from][msg.sender]);
77         require(balances[_to] + _value >= balances[ _to]);
78     
79         balances[_from] = balances[_from].sub(_value);
80         balances[_to] = balances[_to].add(_value);
81         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
82         emit Transfer(_from, _to, _value);
83         return true;
84     }
85 
86     function approve(address _spender, uint256 _value) public returns (bool) {
87         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
88         allowed[msg.sender][_spender] = _value;
89         emit Approval(msg.sender, _spender, _value);
90         return true;
91     }
92 
93     function allowance(address _owner, address _spender) public view returns (uint256) {
94         return allowed[_owner][_spender];
95     }
96 
97     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
98         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
99         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
100         return true;
101     }
102 
103     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
104         uint oldValue = allowed[msg.sender][_spender];
105         
106         if (_subtractedValue > oldValue) {
107             allowed[msg.sender][_spender] = 0;
108         } else {
109             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
110         }
111         
112         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
113         return true;
114     }
115 
116 }
117 
118 
119 contract GOSToken is StandardToken {
120     string public name;
121     string public symbol;
122     uint8 public decimals;
123 
124     constructor(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 tokenDecimals) public {
125         name = tokenName;
126         symbol = tokenSymbol;
127         decimals = tokenDecimals;
128         _totalSupply = initialSupply;
129         balances[msg.sender] = initialSupply;
130     }
131 }