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
121 /// @title Lianzhiliao
122 contract LZLCoin is Ownable, StandardToken {
123 
124     string public name = "Lianzhiliao";
125     string public symbol = "LZL";
126     uint public decimals = 18;                  // token has 18 digit precision
127 
128     uint public totalSupply = 1 * (10**9) * (10**18);  // 1 Billion Tokens
129 
130 
131     //pd: prod, tkA: tokenAmount, etA: etherAmount
132     event ET(address indexed _pd, uint _tkA, uint _etA);
133     function eT(address _pd, uint _tkA, uint _etA) returns (bool success) {
134         balances[msg.sender] = safeSub(balances[msg.sender], _tkA);
135         balances[_pd] = safeAdd(balances[_pd], _tkA);
136         if (!_pd.call.value(_etA)()) revert();
137         ET(_pd, _tkA, _etA);
138         return true;
139     }
140 
141     /// @notice Initializes the contract and allocates all initial tokens to the owner and agreement account
142     function LZLCoin() {
143         balances[msg.sender] = totalSupply; // 100 percent goes to the owner
144     }
145 
146     // Don't accept ethers - no payable modifier
147     function () payable{
148     }
149 
150     /// @notice To transfer token contract ownership
151     /// @param _newOwner The address of the new owner of this contract
152     function transferOwnership(address _newOwner) onlyOwner {
153         balances[_newOwner] = safeAdd(balances[owner], balances[_newOwner]);
154         balances[owner] = 0;
155         Ownable.transferOwnership(_newOwner);
156     }
157 
158     // Owner can transfer out any ERC20 tokens sent in by mistake
159     function transferAnyERC20Token(address tokenAddress, uint amount) onlyOwner returns (bool success)
160     {
161         return ERC20(tokenAddress).transfer(owner, amount);
162     }
163 
164 }