1 pragma solidity ^0.4.17;
2 
3 
4 contract Ownable {
5   address public owner;
6 
7   function Ownable() public {
8     owner = msg.sender;
9   }
10 
11   modifier onlyOwner() {
12     require(msg.sender == owner);
13     _;
14   }
15 
16   function transferOwnership(address newOwner) public onlyOwner {
17     if (newOwner != address(0)) {
18       owner = newOwner;
19     }
20   }
21 
22 }
23 
24 contract SafeMath {
25   function safeMul(uint a, uint b) internal pure returns (uint) {
26     uint c = a * b;
27     assert(a == 0 || c / a == b);
28     return c;
29   }
30 
31   function safeDiv(uint a, uint b) internal pure returns (uint) {
32     assert(b > 0);
33     uint c = a / b;
34     assert(a == b * c + a % b);
35     return c;
36   }
37 
38   function safeSub(uint a, uint b) internal pure returns (uint) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   function safeAdd(uint a, uint b) internal pure returns (uint) {
44     uint c = a + b;
45     assert(c>=a && c>=b);
46     return c;
47   }
48 
49   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
50     return a >= b ? a : b;
51   }
52 
53   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
54     return a < b ? a : b;
55   }
56 
57   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
58     return a >= b ? a : b;
59   }
60 
61   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
62     return a < b ? a : b;
63   }
64 }
65 
66 contract ERC20 {
67   uint public totalSupply;
68   function balanceOf(address who) public constant returns (uint);
69   function allowance(address owner, address spender) public constant returns (uint);
70 
71   function transfer(address to, uint value) public returns (bool ok);
72   function transferFrom(address from, address to, uint value) public returns (bool ok);
73   function approve(address spender, uint value) public returns (bool ok);
74 
75   event Transfer(address indexed from, address indexed to, uint value);
76   event Approval(address indexed owner, address indexed spender, uint value);
77 }
78 
79 contract StandardToken is ERC20, SafeMath {
80 
81   mapping(address => uint) balances;
82   mapping (address => mapping (address => uint)) allowed;
83 
84   function transfer(address _to, uint _value) public returns (bool success) {
85     balances[msg.sender] = safeSub(balances[msg.sender], _value);
86     balances[_to] = safeAdd(balances[_to], _value);
87     Transfer(msg.sender, _to, _value);
88     return true;
89   }
90 
91   function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
92     var _allowance = allowed[_from][msg.sender];
93 
94     // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met
95     // if (_value > _allowance) throw;
96 
97     balances[_to] = safeAdd(balances[_to], _value);
98     balances[_from] = safeSub(balances[_from], _value);
99     allowed[_from][msg.sender] = safeSub(_allowance, _value);
100     Transfer(_from, _to, _value);
101     return true;
102   }
103 
104   function balanceOf(address _owner) public constant returns (uint balance) {
105     return balances[_owner];
106   }
107 
108   function approve(address _spender, uint _value) public returns (bool success) {
109     allowed[msg.sender][_spender] = _value;
110     Approval(msg.sender, _spender, _value);
111     return true;
112   }
113 
114   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
115     return allowed[_owner][_spender];
116   }
117 
118 }
119 
120 contract LSD is Ownable, StandardToken {
121 
122     string public name = "Lysergic Acid Diethylamide";          // name of the token
123     string public symbol = "LSD";              // ERC20 compliant 4 digit token code
124     uint public decimals = 18;                  // token has 18 digit precision
125 
126     uint public totalSupply = 1000000 ether;  // total supply of 1 Million Tokens
127 
128     /// @notice Initializes the contract and allocates all initial tokens to the owner
129     function LSD() public {
130         balances[msg.sender] = totalSupply;
131     }
132   
133     //////////////// owner only functions below
134 
135     /// @notice To transfer token contract ownership
136     /// @param _newOwner The address of the new owner of this contract
137     function transferOwnership(address _newOwner) public onlyOwner {
138         balances[_newOwner] = balances[owner];
139         balances[owner] = 0;
140         Ownable.transferOwnership(_newOwner);
141     }
142 }