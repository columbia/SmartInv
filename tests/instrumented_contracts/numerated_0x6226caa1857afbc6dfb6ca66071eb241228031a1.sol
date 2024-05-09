1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title IERC20Token - ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/20
7  */
8 contract IERC20Token {
9     string public name;
10     string public symbol;
11     uint8 public decimals;
12     uint256 public totalSupply;
13 
14     function balanceOf(address _owner) public constant returns (uint256 balance);
15 
16     function transfer(address _to, uint256 _value) public returns (bool success);
17 
18     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
19 
20     function approve(address _spender, uint256 _value) public returns (bool success);
21 
22     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
23 
24     event Transfer(address indexed _from, address indexed _to, uint256 _value);
25     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
26 }
27 
28 /**
29  * @title SafeMath
30  * @dev Math operations with safety checks that throw on error
31  */
32 contract SafeMath {
33     /**
34     * @dev constructor
35     */
36     constructor() public {
37     }
38 
39     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
40         uint256 c = a * b;
41         assert(a == 0 || c / a == b);
42         return c;
43     }
44 
45     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
46         uint256 c = a / b;
47         return c;
48     }
49 
50     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
51         assert(a >= b);
52         return a - b;
53     }
54 
55     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
56         uint256 c = a + b;
57         assert(c >= a);
58         return c;
59     }
60 }
61 
62 /**
63  * @title ERC20Token - ERC20 base implementation
64  * @dev see https://github.com/ethereum/EIPs/issues/20
65  */
66 contract ERC20Token is IERC20Token, SafeMath {
67     mapping(address => uint256) public balances;
68     mapping(address => mapping(address => uint256)) public allowed;
69 
70     function transfer(address _to, uint256 _value) public returns (bool) {
71         require(_to != address(0));
72         require(balances[msg.sender] >= _value);
73 
74         balances[msg.sender] = safeSub(balances[msg.sender], _value);
75         balances[_to] = safeAdd(balances[_to], _value);
76         emit Transfer(msg.sender, _to, _value);
77         return true;
78     }
79 
80     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
81         require(_to != address(0));
82         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
83 
84         balances[_to] = safeAdd(balances[_to], _value);
85         balances[_from] = safeSub(balances[_from], _value);
86         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
87         emit Transfer(_from, _to, _value);
88         return true;
89     }
90 
91     function balanceOf(address _owner) public constant returns (uint256) {
92         return balances[_owner];
93     }
94 
95     function approve(address _spender, uint256 _value) public returns (bool) {
96         allowed[msg.sender][_spender] = _value;
97         emit Approval(msg.sender, _spender, _value);
98         return true;
99     }
100 
101     function allowance(address _owner, address _spender) public constant returns (uint256) {
102         return allowed[_owner][_spender];
103     }
104 }
105 
106 contract Linkart is ERC20Token {
107 
108     uint256 public mintTotal;
109     address public owner;
110 
111     event Mint(address _toAddress, uint256 _amount);
112 
113     constructor(address _owner) public {
114         require(address(0) != _owner);
115 
116         name = "Linkart";
117         symbol = "LAR";
118         decimals = 18;
119         totalSupply = 10 * 1000 * 1000 * 1000 * 10 ** uint256(decimals);
120 
121         mintTotal = 0;
122         owner = _owner;
123     }
124 
125     function mint(address _toAddress, uint256 _amount) public returns (bool) {
126         require(msg.sender == owner);
127         require(address(0) != _toAddress);
128         require(_amount >= 0);
129         require(safeAdd(_amount, mintTotal) <= totalSupply);
130 
131         mintTotal = safeAdd(_amount, mintTotal);
132         balances[_toAddress] = safeAdd(balances[_toAddress], _amount);
133 
134         emit Mint(_toAddress, _amount);
135         return (true);
136     }
137 
138     function() public payable {
139         revert();
140     }
141 }