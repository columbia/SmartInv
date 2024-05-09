1 pragma solidity ^0.4.19;
2 
3 library SafeMath {
4   function add(uint a, uint b) internal pure returns (uint c) {
5     c = a + b;
6     require(c >= a);
7   }
8   
9   function sub(uint a, uint b) internal pure returns (uint c) {
10     require(b <= a);
11     c = a - b;
12   }
13 
14   function mul(uint a, uint b) internal pure returns (uint c) {
15     c = a * b;
16     require(a == 0 || c / a == b);
17   }
18 
19   function div(uint a, uint b) internal pure returns (uint c) {
20     require(b > 0);
21     c = a / b;
22   }
23 }
24 
25 contract Nonpayable {
26 
27   // ------------------------------------------------------------------------
28   // Don't accept ETH
29   // ------------------------------------------------------------------------
30   function () public payable {
31     revert();
32   }
33 }
34 
35 contract Ownable {
36   address public owner;
37 
38   function Ownable() public {
39     owner = msg.sender;
40   }
41 
42   modifier onlyOwner {
43     require(msg.sender == owner);
44     _;
45   }
46 
47   function destroy() public onlyOwner {
48     selfdestruct(owner);
49   }
50 }
51 
52 contract Regulated is Ownable {
53   event Whitelisted(address indexed customer);
54   event Blacklisted(address indexed customer);
55   
56   mapping(address => bool) regulationStatus;
57 
58   function whitelist(address customer) public onlyOwner {
59     regulationStatus[customer] = true;
60     Whitelisted(customer);
61   }
62 
63   function blacklist(address customer) public onlyOwner {
64     regulationStatus[customer] = false;
65     Blacklisted(customer);
66   }
67   
68   function ensureRegulated(address customer) public constant {
69     require(regulationStatus[customer] == true);
70   }
71 
72   function isRegulated(address customer) public constant returns (bool approved) { 
73     return regulationStatus[customer];
74   }
75 }
76 
77 contract ERC20 {
78   function totalSupply() public constant returns (uint);
79   function balanceOf(address tokenOwner) public constant returns (uint balance);
80   function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
81   function transfer(address to, uint tokens) public returns (bool success);
82   function approve(address spender, uint tokens) public returns (bool success);
83   function transferFrom(address from, address to, uint tokens) public returns (bool success);
84 
85   event Transfer(address indexed from, address indexed to, uint tokens);
86   event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
87 }
88 
89 contract VaultbankVotingToken is ERC20, Regulated, Nonpayable {
90   using SafeMath for uint;
91 
92   string public symbol;
93   string public  name;
94   uint8 public decimals;
95   uint public _totalSupply;
96 
97   mapping(address => uint) balances;
98   mapping(address => mapping(address => uint)) allowed;
99 
100   function VaultbankVotingToken() public {
101     symbol = "VBV";
102     name = "Vaultbank Voting Token";
103     decimals = 0;
104     _totalSupply = 1000;
105 
106     regulationStatus[address(0)] = true;
107     Whitelisted(address(0));
108     regulationStatus[owner] = true;
109     Whitelisted(owner);
110 
111     balances[owner] = _totalSupply;
112     Transfer(address(0), owner, _totalSupply);
113   }
114 
115   function issue(address recipient, uint tokens) public onlyOwner returns (bool success) {
116     require(recipient != address(0));
117     require(recipient != owner);
118     
119     whitelist(recipient);
120     transfer(recipient, tokens);
121     return true;
122   }
123 
124   function issueAndLock(address recipient, uint tokens) public onlyOwner returns (bool success) {
125     issue(recipient, tokens);
126     blacklist(recipient);
127     return true;
128   }
129 
130   function transferOwnership(address newOwner) public onlyOwner {
131     require(newOwner != address(0));
132     require(newOwner != owner);
133    
134     whitelist(newOwner);
135     transfer(newOwner, balances[owner]);
136     owner = newOwner;
137   }
138 
139   function totalSupply() public constant returns (uint supply) {
140     return _totalSupply - balances[address(0)];
141   }
142 
143   function balanceOf(address tokenOwner) public constant returns (uint balance) {
144     return balances[tokenOwner];
145   }
146 
147   function transfer(address to, uint tokens) public returns (bool success) {
148     ensureRegulated(msg.sender);
149     ensureRegulated(to);
150     
151     balances[msg.sender] = balances[msg.sender].sub(tokens);
152     balances[to] = balances[to].add(tokens);
153     Transfer(msg.sender, to, tokens);
154     return true;
155   }
156 
157   function approve(address spender, uint tokens) public returns (bool success) {
158     // Put a check for race condition issue with approval workflow of ERC20
159     require((tokens == 0) || (allowed[msg.sender][spender] == 0));
160     
161     allowed[msg.sender][spender] = tokens;
162     Approval(msg.sender, spender, tokens);
163     return true;
164   }
165 
166   function transferFrom(address from, address to, uint tokens) public returns (bool success) {
167     ensureRegulated(from);
168     ensureRegulated(to);
169 
170     balances[from] = balances[from].sub(tokens);
171     allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
172     balances[to] = balances[to].add(tokens);
173     Transfer(from, to, tokens);
174     return true;
175   }
176 
177   function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
178     return allowed[tokenOwner][spender];
179   }
180 }