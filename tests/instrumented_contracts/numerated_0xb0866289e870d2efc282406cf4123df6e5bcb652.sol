1 pragma solidity ^0.4.11;
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
27         assert(a == 0 || c / a == b);
28         return c;
29     }
30 
31     function safeDiv(uint a, uint b) internal returns (uint) {
32         assert(b > 0);
33         uint c = a / b;
34         assert(a == b * c + a % b);
35         return c;
36     }
37 
38     function safeSub(uint a, uint b) internal returns (uint) {
39         assert(b <= a);
40         return a - b;
41     }
42 
43     function safeAdd(uint a, uint b) internal returns (uint) {
44         uint c = a + b;
45         assert(c>=a && c>=b);
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
65     function assert(bool assertion) internal {
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
98 
99         // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met
100         // if (_value > _allowance) throw;
101 
102         balances[_to] = safeAdd(balances[_to], _value);
103         balances[_from] = safeSub(balances[_from], _value);
104         allowed[_from][msg.sender] = safeSub(_allowance, _value);
105         Transfer(_from, _to, _value);
106         return true;
107     }
108 
109     function balanceOf(address _owner) constant returns (uint balance) {
110         return balances[_owner];
111     }
112 
113     function approve(address _spender, uint _value) returns (bool success) {
114         allowed[msg.sender][_spender] = _value;
115         Approval(msg.sender, _spender, _value);
116         return true;
117     }
118 
119     function allowance(address _owner, address _spender) constant returns (uint remaining) {
120         return allowed[_owner][_spender];
121     }
122 
123 }
124 
125 /// @title No Fake Coin
126 /// @author Leon Huang <NoFakeToday@gmail.com>
127 contract NoFakeCoin is Ownable, StandardToken {
128 
129     string public name = "NoFakeCoin";
130     string public symbol = "NFC";
131     uint public decimals = 18;                  // token has 18 digit precision
132 
133     uint public totalSupply = 450 * (10**6) * (10**18);  // 450 Million Tokens
134 
135     /// @notice Initializes the contract and allocates all initial tokens to the owner and agreement account
136     function NoFakeCoin() {
137         balances[msg.sender] = 360 * (10**6) * (10**18); // 80 percent goes to the public sale
138         balances[0x8895dc78dcd0310c862e8aeacc5daa3faa3b7239] = 90 * (10**6) * (10**18); // remaining goes to the foundation account
139     }
140 
141     // Don't accept ethers - no payable modifier
142     function () {
143     }
144 
145     /// @notice To transfer token contract ownership
146     /// @param _newOwner The address of the new owner of this contract
147     function transferOwnership(address _newOwner) onlyOwner {
148         balances[_newOwner] = safeAdd(balances[owner], balances[_newOwner]);
149         balances[owner] = 0;
150         Ownable.transferOwnership(_newOwner);
151     }
152 
153     // Owner can transfer out any ERC20 tokens sent in by mistake
154     function transferAnyERC20Token(address tokenAddress, uint amount) onlyOwner returns (bool success)
155     {
156         return ERC20(tokenAddress).transfer(owner, amount);
157     }
158 
159 }