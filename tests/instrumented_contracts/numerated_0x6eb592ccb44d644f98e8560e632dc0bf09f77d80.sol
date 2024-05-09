1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'SmartContractFactory' token contract
5 // ----------------------------------------------------------------------------
6 
7 // ----------------------------------------------------------------------------
8 // Safe maths
9 // ----------------------------------------------------------------------------
10 contract SafeMath
11 {
12     function safeAdd(uint a, uint b) public pure returns (uint c) {
13         c = a + b;
14         require(c >= a);
15     }
16     function safeSub(uint a, uint b) public pure returns (uint c) {
17         require(b <= a);
18         c = a - b;
19     }
20     function safeMul(uint a, uint b) public pure returns (uint c) {
21         c = a * b;
22         require(a == 0 || c / a == b);
23     }
24     function safeDiv(uint a, uint b) public pure returns (uint c) {
25         require(b > 0);
26         c = a / b;
27     }
28 }
29 
30 // ----------------------------------------------------------------------------
31 // ERC20 Interface
32 // ----------------------------------------------------------------------------
33 contract ERC20Basic
34 {
35     uint public totalSupply;
36     function balanceOf(address who) public constant returns (uint);
37     function transfer(address to, uint value) public returns (bool success);
38     event Transfer(address indexed from, address indexed to, uint value);
39 }
40 
41 contract ERC20 is ERC20Basic
42 {
43     function allowance(address owner, address spender) public constant returns (uint);
44     function transferFrom(address from, address to, uint value) public returns (bool success);
45     function approve(address spender, uint value) public returns (bool success);
46     event Approval(address indexed owner, address indexed spender, uint value);
47 }
48 
49 contract BasicToken is ERC20Basic, SafeMath
50 {
51     mapping(address => uint) balances;
52 
53     function transfer(address to, uint value) public returns (bool success)
54     {
55         require(value <= balances[msg.sender]);
56         require(to != address(0));
57 
58         balances[msg.sender] = safeSub(balances[msg.sender], value);
59         balances[to] = safeAdd(balances[to], value);
60         emit Transfer(msg.sender, to, value);
61         return true;
62     }
63 
64     function balanceOf(address owner) public constant returns (uint balance)
65     {
66         return balances[owner];
67     }
68 }
69 
70 contract StandardToken is BasicToken, ERC20
71 {
72     mapping (address => mapping (address => uint)) allowed;
73 
74     function transferFrom(address from, address to, uint value) public returns (bool success)
75     {
76         require(value <= balances[from]);
77         require(value <= allowed[from][msg.sender]);
78         require(to != address(0));
79 
80         uint allowance = allowed[from][msg.sender];
81         balances[to] = safeAdd(balances[to], value);
82         balances[from] = safeSub(balances[from], value);
83         allowed[from][msg.sender] = safeSub(allowance, value);
84         emit Transfer(from, to, value);
85         return true;
86     }
87 
88     function approve(address spender, uint value) public returns (bool success)
89     {
90         require(spender != address(0));
91         require(!((value != 0) && (allowed[msg.sender][spender] != 0)));
92 
93         allowed[msg.sender][spender] = value;
94         emit Approval(msg.sender, spender, value);
95         return true;
96     }
97 
98     function allowance(address owner, address spender) public constant returns (uint remaining)
99     {
100         return allowed[owner][spender];
101     }
102 }
103 
104 // ----------------------------------------------------------------------------
105 // Owned contract
106 // ----------------------------------------------------------------------------
107 contract Owned {
108     address public owner;
109     address public newOwner;
110 
111     event OwnershipTransferred(address indexed _from, address indexed _to);
112 
113     constructor() public {
114         owner = msg.sender;
115     }
116 
117     modifier onlyOwner {
118         require(msg.sender == owner);
119         _;
120     }
121 
122     function transferOwnership(address _newOwner) public onlyOwner {
123         newOwner = _newOwner;
124     }
125 
126     function acceptOwnership() public {
127         require(msg.sender == newOwner);
128         emit OwnershipTransferred(owner, newOwner);
129         owner = newOwner;
130         newOwner = address(0);
131     }
132 }
133 
134 // ----------------------------------------------------------------------------
135 // SmartContractFactory contract
136 // ----------------------------------------------------------------------------
137 contract SmartContractFactory is StandardToken, Owned
138 {
139     string public name = "SmartContractFactory";
140     string public symbol = "SCF";
141     uint public decimals = 8 ;
142     uint public totalSupply =  1000000000000000000;
143 
144     constructor() public {
145         owner = msg.sender;
146         balances[owner] = totalSupply;
147         emit Transfer(address(0), owner, totalSupply);
148     }
149 
150      function burn(address account, uint256 amount) public onlyOwner returns (bool success){
151        require(account != 0);
152        require(amount <= balances[account]);
153 
154        totalSupply = safeSub(totalSupply, amount);
155        balances[account] = safeSub(balances[account], amount);
156        emit Transfer(account, address(0), amount);
157        return true;
158      }
159 
160     function burnFrom(address account, uint256 amount) public onlyOwner returns (bool success){
161       require(amount <= allowed[account][msg.sender]);
162 
163       // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
164       // this function needs to emit an event with the updated approval.
165       allowed[account][msg.sender] = safeSub(allowed[account][msg.sender], amount);
166       burn(account, amount);
167       return true;
168     }
169 }