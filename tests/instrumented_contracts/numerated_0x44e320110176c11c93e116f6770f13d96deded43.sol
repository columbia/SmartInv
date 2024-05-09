1 pragma solidity ^0.4.20;
2 
3 
4 contract Ownable {
5     address public owner;
6 
7     function Ownable() public {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner {
12         require(msg.sender == owner);
13         _;
14     }
15 
16     function transferOwner(address newOwner) public onlyOwner {
17         owner = newOwner;
18     }
19 }
20 
21 
22 contract SafeMath {
23 
24     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
25         if (a == 0) {
26             return 0;
27         }
28         uint256 c = a * b;
29         assert(c / a == b);
30         return c;
31     }
32 
33     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
34         // assert(b > 0); // Solidity automatically throws when dividing by 0
35         uint256 c = a / b;
36         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37         return c;
38     }
39 
40     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
41         assert(b <= a);
42         return a - b;
43     }
44 
45     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
46         uint256 c = a + b;
47         assert(c >= a);
48         return c;
49     }
50 }
51 
52 
53 contract EIP20Interface {
54     uint256 public totalSupply;
55 
56     function balanceOf(address _owner) public view returns (uint256 balance);
57 
58     function transfer(address _to, uint256 _value) public returns (bool success);
59 
60     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
61 
62     function approve(address _spender, uint256 _value) public returns (bool success);
63 
64     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
65 
66     event Transfer(address indexed _from, address indexed _to, uint256 _value);
67 
68     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
69 }
70 
71 
72 contract Akilos is EIP20Interface, Ownable, SafeMath {
73 
74     mapping (address => uint256) public balances;
75 
76     mapping (address => mapping (address => uint256)) public allowed;
77 
78     string public name = "Akilos";
79 
80     uint8 public decimals = 18;
81 
82     string public symbol = "ALS";
83 
84     function Akilos() public {
85     }
86 
87     function transfer(address _to, uint256 _value) public returns (bool success) {
88         require(balances[msg.sender] >= _value);
89         balances[msg.sender] = safeSub(balances[msg.sender], _value);
90         balances[_to] = safeAdd(balances[_to], _value);
91 
92         Transfer(msg.sender, _to, _value);
93         return true;
94     }
95 
96     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
97         uint256 allowance = allowed[_from][msg.sender];
98         require(balances[_from] >= _value && allowance >= _value);
99         balances[_to] = safeAdd(balances[_to], _value);
100         balances[_from] = safeSub(balances[_from], _value);
101         allowed[_from][msg.sender] = safeSub(allowance, _value);
102 
103         Transfer(_from, _to, _value);
104         return true;
105     }
106 
107     function balanceOf(address _owner) public view returns (uint256 balance) {
108         return balances[_owner];
109     }
110 
111     function approve(address _spender, uint256 _value) public returns (bool success) {
112         allowed[msg.sender][_spender] = _value;
113         Approval(msg.sender, _spender, _value);
114         return true;
115     }
116 
117     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
118         return allowed[_owner][_spender];
119     }
120 
121     function mint(address _to, uint256 _value) public onlyOwner {
122         totalSupply = safeAdd(totalSupply, _value);
123         balances[_to] = safeAdd(balances[_to], _value);
124     }
125 }