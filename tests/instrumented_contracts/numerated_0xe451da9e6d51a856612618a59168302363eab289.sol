1 pragma solidity ^0.4.18;
2 
3 
4 // ----------------------------------------------------------------------------
5 
6 // Simple Donate Contract 
7 
8 // This contract  facilitates management of simple fundraising.
9 // Any and all funds can be withdrawn by the contract owner at any time. 
10 
11 // ----------------------------------------------------------------------------
12 
13 
14 
15 // ----------------------------------------------------------------------------
16 
17 // Safe maths
18 
19 // ----------------------------------------------------------------------------
20 
21 library SafeMath {
22 
23     function add(uint a, uint b) internal pure returns (uint c) {
24 
25         c = a + b;
26 
27         require(c >= a);
28 
29     }
30 
31     function sub(uint a, uint b) internal pure returns (uint c) {
32 
33         require(b <= a);
34 
35         c = a - b;
36 
37     }
38 
39     function mul(uint a, uint b) internal pure returns (uint c) {
40 
41         c = a * b;
42 
43         require(a == 0 || c / a == b);
44 
45     }
46 
47     function div(uint a, uint b) internal pure returns (uint c) {
48 
49         require(b > 0);
50 
51         c = a / b;
52 
53     }
54 
55 }
56 
57  
58  contract ERC20Interface {
59 
60     function totalSupply() public constant returns (uint);
61 
62     function balanceOf(address tokenOwner) public constant returns (uint balance);
63 
64     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
65 
66     function transfer(address to, uint tokens) public returns (bool success);
67 
68     function approve(address spender, uint tokens) public returns (bool success);
69 
70     function transferFrom(address from, address to, uint tokens) public returns (bool success);
71 
72 
73     event Transfer(address indexed from, address indexed to, uint tokens);
74 
75     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
76 
77 }
78 
79 
80  
81 
82 
83 // ----------------------------------------------------------------------------
84 
85 // Owned contract
86 
87 // ----------------------------------------------------------------------------
88 
89 contract Owned {
90 
91     address public owner;
92 
93     address public newOwner;
94 
95 
96     event OwnershipTransferred(address indexed _from, address indexed _to);
97 
98 
99     constructor() public {
100 
101         owner = msg.sender;
102 
103     }
104 
105 
106     modifier onlyOwner {
107 
108         require(msg.sender == owner);
109 
110         _;
111 
112     }
113 
114 
115     function transferOwnership(address _newOwner) public onlyOwner {
116 
117         newOwner = _newOwner;
118 
119     }
120 
121     function acceptOwnership() public {
122 
123         require(msg.sender == newOwner);
124 
125         emit OwnershipTransferred(owner, newOwner);
126 
127         owner = newOwner;
128 
129         newOwner = address(0);
130 
131     }
132 
133 }
134 
135 
136 
137 // ----------------------------------------------------------------------------
138 
139 // ERC20 Token, with the addition of symbol, name and decimals and an
140 
141 // initial fixed supply
142 
143 // ----------------------------------------------------------------------------
144 
145 contract SimpleDonate is   Owned {
146 
147     using SafeMath for uint;  
148 
149     string public  name; 
150  
151 
152  
153  
154     // ------------------------------------------------------------------------
155 
156     // Constructor
157 
158     // ------------------------------------------------------------------------
159 
160     constructor(string contractName) public  { 
161         name = contractName; 
162     }
163 
164 
165 
166   
167 
168     
169      // ------------------------------------------------------------------------
170 
171     // Owner can transfer out any Ether
172 
173     // ------------------------------------------------------------------------
174 
175     
176      function withdrawEther(uint amount) public onlyOwner returns(bool) {
177         
178         require(amount < address(this).balance);
179         owner.transfer(amount);
180         return true;
181 
182     }
183     
184     // ------------------------------------------------------------------------
185 
186     // Owner can transfer out any ERC20 tokens
187 
188     // ------------------------------------------------------------------------
189 
190     function withdrawERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
191 
192         return ERC20Interface(tokenAddress).transfer(owner, tokens);
193 
194     }
195 
196 }