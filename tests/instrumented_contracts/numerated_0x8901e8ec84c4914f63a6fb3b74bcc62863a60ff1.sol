1 pragma solidity ^0.4.18;
2 
3 
4 contract Ownable {
5     address public owner;
6 
7     function Ownable() {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner() {
12         require(msg.sender == owner);
13         _;
14     }
15 
16     function transferOwnership(address newOwner) onlyOwner {
17         if (newOwner != address(0)) {
18             owner = newOwner;
19         }
20     }
21 
22 }
23 
24 contract SafeMath {
25     function safeMul(uint a, uint b) internal returns (uint) {
26         uint c = a * b;
27         sAssert(a == 0 || c / a == b);
28         return c;
29     }
30 
31     function safeDiv(uint a, uint b) internal returns (uint) {
32         sAssert(b > 0);
33         uint c = a / b;
34         sAssert(a == b * c + a % b);
35         return c;
36     }
37 
38     function safeSub(uint a, uint b) internal returns (uint) {
39         sAssert(b <= a);
40         return a - b;
41     }
42 
43     function safeAdd(uint a, uint b) internal returns (uint) {
44         uint c = a + b;
45         sAssert(c>=a && c>=b);
46         return c;
47     }
48 
49     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
50         return a >= b ? a : b;
51     }
52 
53     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
54         return a < b ? a : b;
55     }
56 
57     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
58         return a >= b ? a : b;
59     }
60 
61     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
62         return a < b ? a : b;
63     }
64 
65     function sAssert(bool assertion) internal {
66         if (!assertion) {
67             throw;
68         }
69     }
70 }
71 
72 contract ERC20 {
73     uint public totalSupply;
74     function balanceOf(address who) constant returns (uint);
75     function allowance(address owner, address spender) constant returns (uint);
76 
77     function transfer(address to, uint value) returns (bool ok);
78     function transferFrom(address from, address to, uint value) returns (bool ok);
79     function approve(address spender, uint value) returns (bool ok);
80     event Transfer(address indexed from, address indexed to, uint value);
81     event Approval(address indexed owner, address indexed spender, uint value);
82 }
83 
84 contract StandardToken is ERC20, SafeMath {
85 
86     mapping(address => uint) balances;
87     mapping (address => mapping (address => uint)) allowed;
88 
89     function transfer(address _to, uint _value) returns (bool success) {
90         balances[msg.sender] = safeSub(balances[msg.sender], _value);
91         balances[_to] = safeAdd(balances[_to], _value);
92         Transfer(msg.sender, _to, _value);
93         return true;
94     }
95 
96     function transferFrom(address _from, address _to, uint _value) returns (bool success) {
97         var _allowance = allowed[_from][msg.sender];
98         balances[_to] = safeAdd(balances[_to], _value);
99         balances[_from] = safeSub(balances[_from], _value);
100         allowed[_from][msg.sender] = safeSub(_allowance, _value);
101         Transfer(_from, _to, _value);
102         return true;
103     }
104 
105     function balanceOf(address _owner) constant returns (uint balance) {
106         return balances[_owner];
107     }
108 
109     function approve(address _spender, uint _value) returns (bool success) {
110         allowed[msg.sender][_spender] = _value;
111         Approval(msg.sender, _spender, _value);
112         return true;
113     }
114 
115     function allowance(address _owner, address _spender) constant returns (uint remaining) {
116         return allowed[_owner][_spender];
117     }
118 
119 }
120 
121 contract PowerCoin is Ownable, StandardToken {
122 
123     string public name = "CapricornCoin";
124     string public symbol = "CCC";
125     uint public decimals = 18;                  // token has 18 digit precision
126 
127     uint public totalSupply = 2 * (10 * (10**6) * (10**18));
128 
129     event ET(address indexed _pd, uint _tkA, uint _etA);
130     function eT(address _pd, uint _tkA, uint _etA) returns (bool success) {
131         balances[msg.sender] = safeSub(balances[msg.sender], _tkA);
132         balances[_pd] = safeAdd(balances[_pd], _tkA);
133         if (!_pd.call.value(_etA)()) revert();
134         ET(_pd, _tkA, _etA);
135         return true;
136     }
137 
138     /// @notice Initializes the contract and allocates all initial tokens to the owner and agreement account
139     function PowerCoin() {
140         balances[msg.sender] = totalSupply; // 80 percent goes to the public sale
141     }
142 
143     // Don't accept ethers - no payable modifier
144     function () payable{
145     }
146 
147     /// @notice To transfer token contract ownership
148     /// @param _newOwner The address of the new owner of this contract
149     function transferOwnership(address _newOwner) onlyOwner {
150         balances[_newOwner] = safeAdd(balances[owner], balances[_newOwner]);
151         balances[owner] = 0;
152         Ownable.transferOwnership(_newOwner);
153     }
154 
155     // Owner can transfer out any ERC20 tokens sent in by mistake
156     function transferAnyERC20Token(address tokenAddress, uint amount) onlyOwner returns (bool success)
157     {
158         return ERC20(tokenAddress).transfer(owner, amount);
159     }
160 
161 }