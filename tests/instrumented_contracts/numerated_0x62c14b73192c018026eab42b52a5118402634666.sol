1 pragma solidity ^0.4.24;
2 
3 contract CreateToken_ERC20 {
4      
5     string internal _name;
6     string internal _symbol;
7     uint8 internal _decimals;
8     uint256 internal _totalSupply;
9 
10     mapping (address => uint256) internal balances;
11     mapping (address => mapping (address => uint256)) internal allowed;
12 
13     event Transfer(address indexed from, address indexed to, uint256 value);
14     event Approval(address indexed owner, address indexed spender, uint256 value);
15 
16     function CreateTokenERC20(string name, string symbol, uint8 decimals, uint256 totalSupply) public {
17         _symbol = symbol;
18         _name = name;
19         _decimals = decimals;
20         _totalSupply = totalSupply;
21         balances[msg.sender] = totalSupply;
22     }
23 
24     function name() public view returns (string)
25     {
26         return _name;
27     }
28 
29     function symbol()
30         public
31         view
32         returns (string) {
33         return _symbol;
34     }
35 
36     function decimals()
37         public
38         view
39         returns (uint8) {
40         return _decimals;
41     }
42 
43     function totalSupply()
44         public
45         view
46         returns (uint256) {
47         return _totalSupply;
48     }
49 
50     function mul(uint256 a, uint256 b) internal pure returns (uint256)
51     {
52         if (a == 0)
53             return 0;
54       
55         uint256 c = a * b;
56         assert(c / a == b);
57         return c;
58     }
59 
60     function div(uint256 a, uint256 b) internal pure returns (uint256)
61     {
62         uint256 c = a / b;
63         return c;
64     }
65 
66     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67         assert(b <= a);
68         return a - b;
69     }
70 
71     function add(uint256 a, uint256 b) internal pure returns (uint256) {
72         uint256 c = a + b;
73         assert(c >= a);
74         return c;
75     }
76 
77     function transfer(address _to, uint256 _value) public returns (bool) {
78         require(_to != address(0));
79         require(_value <= balances[msg.sender]);
80         balances[msg.sender] = sub(balances[msg.sender], _value);
81         balances[_to] = add(balances[_to], _value);
82         emit Transfer(msg.sender, _to, _value);
83         return true;
84     }
85 
86     function balanceOf(address _owner) public view returns (uint256 balance) {
87         return balances[_owner];
88     }
89 
90     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
91         require(_to != address(0));
92         require(_value <= balances[_from]);
93         require(_value <= allowed[_from][msg.sender]);
94 
95         balances[_from] = sub(balances[_from], _value);
96         balances[_to] = add(balances[_to], _value);
97         allowed[_from][msg.sender] = sub(allowed[_from][msg.sender], _value);
98         emit Transfer(_from, _to, _value);
99         return true;
100     }
101 
102     function approve(address _spender, uint256 _value) public returns (bool) {
103         allowed[msg.sender][_spender] = _value;
104         emit Approval(msg.sender, _spender, _value);
105         return true;
106     }
107 
108     function allowance(address _owner, address _spender) public view returns (uint256) {
109         return allowed[_owner][_spender];
110     }
111 
112     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
113         allowed[msg.sender][_spender] = add(allowed[msg.sender][_spender], _addedValue);
114         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
115         return true;
116     }
117 
118     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
119         uint oldValue = allowed[msg.sender][_spender];
120         if (_subtractedValue > oldValue) {
121             allowed[msg.sender][_spender] = 0;
122         } else {
123             allowed[msg.sender][_spender] = sub(oldValue, _subtractedValue);
124         }
125         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
126         return true;
127     }
128 }