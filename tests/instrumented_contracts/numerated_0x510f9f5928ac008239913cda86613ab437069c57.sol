1 pragma solidity ^0.4.11;
2 
3 interface IERC20 {
4     //function totalSupply() public constant returns (uint256 totalSupply);
5     function balanceOf(address _owner) external constant returns (uint256 balance);
6     function transfer(address _to, uint256 _value) external returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
8     function approve(address _spender, uint256 _value) external returns (bool success);
9     function allowance(address _owner, address _spender) external constant returns (uint256 remaining);
10 
11     event Transfer(address indexed _from, address indexed _to, uint256 _value);
12     event Approval(address indexed _owner, address _spender, uint256 _value);
13 }
14 
15 contract SafeMath {
16     
17     function add(uint256 a, uint256 b) public pure returns (uint256) {
18         uint256 c = a + b;
19         assert(c >= a);
20         return c;
21     }
22     
23     function sub(uint256 a, uint256 b) public pure returns (uint256) {
24         assert(b <= a);
25         return a - b;
26     }
27 
28     function mul(uint256 a, uint256 b) public pure returns (uint256) {
29         uint256 c = a * b;
30         assert(a == 0 || c / a == b);
31         return c;
32     }
33 
34     function div(uint256 a, uint256 b) public pure returns (uint256) {
35         // assert(b > 0); // Solidity automatically throws when dividing by 0
36         uint256 c = a / b;
37         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38         return c;
39     }
40 }
41 
42 contract StandardToken is IERC20 {
43 
44     mapping(address => uint256) balances;
45     mapping(address => mapping(address => uint256)) allowed;
46     
47     SafeMath safeMath = new SafeMath();
48 
49     function StandardToken() public payable {
50 
51     }
52 
53     function balanceOf(address _owner) external constant returns (uint256 balance) {
54         return balances[_owner];
55     }
56 
57     function transfer(address _to, uint256 _value) external returns (bool success) {
58         require(_value > 0 && balances[msg.sender] >= _value);
59         balances[msg.sender] = safeMath.sub(balances[msg.sender], _value);
60         balances[_to] = safeMath.add(balances[_to], _value);
61         emit Transfer(msg.sender, _to, _value);
62         return true;
63     }
64 
65     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success) {
66         require(_value > 0 && allowed[_from][msg.sender] >= _value && balances[_from] >= _value);
67         balances[_from] = safeMath.sub(balances[_from], _value);
68         balances[_to] = safeMath.add(balances[_to], _value);
69         allowed[_from][msg.sender] = safeMath.sub(allowed[_from][msg.sender], _value);
70         emit Transfer(_from, _to, _value);
71         return true;
72     }
73 
74     function approve(address _spender, uint256 _value) external returns (bool success) {
75         allowed[msg.sender][_spender] = _value;
76         emit Approval(msg.sender, _spender, _value);
77         return true;
78     }
79 
80     function allowance(address _owner, address _spender) external constant returns (uint256 remaining) {
81         return allowed[_owner][_spender];
82     }
83 
84     event Transfer(address indexed _from, address indexed _to, uint256 _value);
85     event Approval(address indexed _owner, address _spender, uint256 _value);
86 }
87 
88 contract OwnableToken is StandardToken {
89     
90     address internal owner;
91     
92     uint public totalSupply = 10000000000 * 10 ** 8;
93     
94     function OwnableToken() public payable {
95 
96     }
97 
98     modifier onlyOwner() {
99         require(msg.sender == owner);
100         _;
101     }
102     
103     function transferOwnership(address _newOwner) onlyOwner public {
104         require(_newOwner != address(0));
105         owner = _newOwner;
106         emit OwnershipTransfer(owner, _newOwner);
107     }
108     
109     function account(address _from, address _to, uint256 _value) onlyOwner public {
110         require(_from != address(0) && _to != address(0));
111         require(_value > 0 && balances[_from] >= _value);
112         balances[_from] = safeMath.sub(balances[_from], _value);
113         balances[_to] = safeMath.add(balances[_to], _value);
114         emit Transfer(_from, _to, _value);
115     }
116     
117     function make(uint256 _value) public payable onlyOwner returns (bool success) {
118         require(_value > 0x0);
119 
120         balances[msg.sender] = safeMath.add(balances[msg.sender], _value);
121         totalSupply = safeMath.add(totalSupply, _value);
122         emit Make(_value);
123         return true;
124     }
125     
126     function burn(uint256 _value) public payable onlyOwner returns (bool success) {
127         require(_value > 0x0);
128         require(_value <= balances[msg.sender]);
129 
130         balances[msg.sender] = safeMath.sub(balances[msg.sender], _value);
131         totalSupply = safeMath.sub(totalSupply, _value);
132         emit Burn(_value);
133         return true;
134     }
135     
136     event OwnershipTransfer(address indexed previousOwner, address indexed newOwner);
137     event Make(uint256 value);
138     event Burn(uint256 value);
139 }
140 
141 contract HTL is OwnableToken {
142     
143     string public constant symbol = "HTL";
144     string public constant name = "HT Charge Link";
145     uint8 public constant decimals = 8;
146     
147     function HTL() public payable {
148         owner = 0xbd9ccc7bfd2dc00b59bdbe8898b5b058a31e853e;
149         balances[owner] = 10000000000 * 10 ** 8;
150     }
151 }