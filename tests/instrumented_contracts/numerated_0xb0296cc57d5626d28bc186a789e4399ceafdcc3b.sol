1 pragma solidity ^0.4.24;
2 
3 contract Ownable {
4     address public owner;
5 
6     function Ownable() {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner() {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner {
16         if (newOwner != address(0)) {
17             owner = newOwner;
18         }
19     }
20 
21 }
22 
23 contract SafeMath {
24     function safeMul(uint a, uint b) internal returns (uint) {
25         uint c = a * b;
26         assert(a == 0 || c / a == b);
27         return c;
28     }
29 
30     function safeDiv(uint a, uint b) internal returns (uint) {
31         assert(b > 0);
32         uint c = a / b;
33         assert(a == b * c + a % b);
34         return c;
35     }
36 
37     function safeSub(uint a, uint b) internal returns (uint) {
38         assert(b <= a);
39         return a - b;
40     }
41 
42     function safeAdd(uint a, uint b) internal returns (uint) {
43         uint c = a + b;
44         assert(c>=a && c>=b);
45         return c;
46     }
47 
48     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
49         return a >= b ? a : b;
50     }
51 
52     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
53         return a < b ? a : b;
54     }
55 
56     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
57         return a >= b ? a : b;
58     }
59 
60     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
61         return a < b ? a : b;
62     }
63 
64     function assert(bool assertion) internal {
65         if (!assertion) {
66             throw;
67         }
68     }
69 }
70 
71 contract ERC20 {
72     uint public totalSupply;
73     function balanceOf(address who) constant returns (uint);
74     function allowance(address owner, address spender) constant returns (uint);
75 
76     function transfer(address to, uint value) returns (bool ok);
77     function transferFrom(address from, address to, uint value) returns (bool ok);
78     function approve(address spender, uint value) returns (bool ok);
79     event Transfer(address indexed from, address indexed to, uint value);
80     event Approval(address indexed owner, address indexed spender, uint value);
81 }
82 
83 contract StandardToken is ERC20, SafeMath {
84 
85     mapping(address => uint) balances;
86     mapping (address => mapping (address => uint)) allowed;
87 
88     function transfer(address _to, uint _value) returns (bool success) {
89         balances[msg.sender] = safeSub(balances[msg.sender], _value);
90         balances[_to] = safeAdd(balances[_to], _value);
91         Transfer(msg.sender, _to, _value);
92         return true;
93     }
94 
95     function transferFrom(address _from, address _to, uint _value) returns (bool success) {
96         var _allowance = allowed[_from][msg.sender];
97 
98         // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met
99         // if (_value > _allowance) throw;
100 
101         balances[_to] = safeAdd(balances[_to], _value);
102         balances[_from] = safeSub(balances[_from], _value);
103         allowed[_from][msg.sender] = safeSub(_allowance, _value);
104         Transfer(_from, _to, _value);
105         return true;
106     }
107 
108     function balanceOf(address _owner) constant returns (uint balance) {
109         return balances[_owner];
110     }
111 
112     function approve(address _spender, uint _value) returns (bool success) {
113         allowed[msg.sender][_spender] = _value;
114         Approval(msg.sender, _spender, _value);
115         return true;
116     }
117 
118     function allowance(address _owner, address _spender) constant returns (uint remaining) {
119         return allowed[_owner][_spender];
120     }
121 
122 }
123 
124 contract ViotToken is Ownable, StandardToken {
125     string public name = "VIOT Token";
126     string public symbol = "VIOT";
127     uint public decimals = 18;                  // token has 18 digit precision
128     uint public totalSupply = 1 * (10**9) * (10**18);  // 1 Billion Tokens
129 
130     /// @notice Initializes the contract and allocates all initial tokens to the owner and agreement account
131     function ViotToken() {
132         balances[msg.sender] = totalSupply;
133     }
134 
135     // Don't accept ethers - no payable modifier
136     function () {
137     }
138 
139     /// @notice To transfer token contract ownership
140     /// @param _newOwner The address of the new owner of this contract
141     function transferOwnership(address _newOwner) onlyOwner {
142         balances[_newOwner] = safeAdd(balances[owner], balances[_newOwner]);
143         balances[owner] = 0;
144         Ownable.transferOwnership(_newOwner);
145     }
146 
147     // Owner can transfer out any ERC20 tokens sent in by mistake
148     function transferAnyERC20Token(address tokenAddress, uint amount) onlyOwner returns (bool success)
149     {
150         return ERC20(tokenAddress).transfer(owner, amount);
151     }
152 
153 }