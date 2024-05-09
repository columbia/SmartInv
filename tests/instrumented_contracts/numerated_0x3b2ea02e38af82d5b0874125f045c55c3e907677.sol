1 pragma solidity ^0.4.18;
2 
3 
4 /*
5     SafeMath operations used for supporting contracts.
6 */
7 contract SafeMath {
8     function Add(uint a, uint b) public pure returns (uint c) {
9         c = a + b;
10         require(c >= a);
11     }
12     function Sub(uint a, uint b) public pure returns (uint c) {
13         require(b <= a);
14         c = a - b;
15     }
16     function Mul(uint a, uint b) public pure returns (uint c) {
17         c = a * b;
18         require(a == 0 || c / a == b);
19     }
20     function Div(uint a, uint b) public pure returns (uint c) {
21         require(b > 0);
22         c = a / b;
23     }
24 }
25 
26 
27 /*
28     Modified version of ERC20 interface supplied from https://github.com/ethereum.
29 */
30 contract ERC20 {
31     function approve(address spender, uint tokens) public returns (bool success);
32     function allowance(address fromAddress, address recipientAddress) public constant returns (uint remaining);
33     function totalSupply() public constant returns (uint);
34     function transfer(address recipientAddress, uint tokens) public returns (bool success);
35     function transferFrom(address fromAddress, address recipientAddress, uint tokens) public returns (bool success);
36     function balanceOf(address userAddress) public constant returns (uint balance);
37     
38     event Transfer(address indexed from, address indexed recipient, uint tokens);
39     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
40 }
41 
42 /*
43     Owner contract contains authorization functions to limit
44     access of some functions to the token owner.
45 */
46 contract Owned {
47     address public Owner;
48     address public newOwner;
49 
50     event OwnershipAltered(address indexed _from, address indexed _to);
51 
52     modifier onlyOwner {
53         require(msg.sender == Owner);
54         _;
55     }
56     
57     /*
58         Assigns the initial address to the owner.
59     */
60     function Owned() public {
61         Owner = msg.sender;
62     }
63 
64     function acceptOwnership() public {
65         require(msg.sender == newOwner);
66         OwnershipAltered(Owner, newOwner);
67         Owner = newOwner;
68         newOwner = address(0);
69     }
70 
71     /*
72         Allows the owner to designate a new owner
73     */
74     function transferOwnership(address _newOwner) public onlyOwner {
75         newOwner = _newOwner;
76     }
77     
78 }
79 
80 /*
81     BEAT Token contract with specifics.
82 */
83 contract BEAT is ERC20, Owned, SafeMath {
84     string public  name;
85     string public symbol;
86     uint public _totalSupply;
87     uint8 public decimals;
88     
89     mapping(address => uint) balances;
90     mapping(address => mapping(address => uint)) allowed;
91 
92 
93     /*
94         Constructor to create BEAT token.
95     */
96     function BEAT() public {
97         symbol = "BEAT";
98         name = "BEAT";
99         decimals = 8;
100         _totalSupply = 100000000000000000;
101         Owner = msg.sender;
102         balances[msg.sender] = _totalSupply;
103 
104     }
105 
106     /*
107         Returns the total token supply.
108     */
109     function totalSupply() public constant returns (uint) {
110         return _totalSupply;
111     }
112 
113     /*
114         Get the token balance for account tokenOwner.
115     */
116     function balanceOf(address userAddress) public constant returns (uint balance) {
117         return balances[userAddress];
118     }
119 
120     function transfer(address to, uint tokens) public returns (bool success) {
121         balances[msg.sender] = Sub(balances[msg.sender], tokens);
122         balances[to] = Add(balances[to], tokens);
123         Transfer(msg.sender, to, tokens);
124         return true;
125     }
126 
127     function approve(address spender, uint tokens) public returns (bool success) {
128         allowed[msg.sender][spender] = tokens;
129         Approval(msg.sender, spender, tokens);
130         return true;
131     }
132 
133 
134     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
135         balances[from] = Sub(balances[from], tokens);
136         allowed[from][msg.sender] = Sub(allowed[from][msg.sender], tokens);
137         balances[to] = Add(balances[to], tokens);
138         Transfer(from, to, tokens);
139         return true;
140     }
141     
142     /*
143         Owner can transfer any ERC20 tokens sent to contract.
144     */
145     function redeemContractSentTokens(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
146         return ERC20(tokenAddress).transfer(Owner, tokens);
147     }
148 
149     /*
150         Owner can distribute tokens
151     */
152     function airdrop(address[] addresses, uint256 _value) onlyOwner public {
153          for (uint j = 0; j < addresses.length; j++) {
154              balances[Owner] -= _value;
155              balances[addresses[j]] += _value;
156              emit Transfer(Owner, addresses[j], _value);
157          }
158     }
159 
160     /*
161         Returns the amount of tokens allowed by the owner that can be transferred
162     */
163     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
164         return allowed[tokenOwner][spender];
165     }
166 
167     
168     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
169         allowed[msg.sender][spender] = tokens;
170         Approval(msg.sender, spender, tokens);
171         return true;
172     }
173 
174 }