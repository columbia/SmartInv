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
89 contract VaultbankToken is ERC20, Regulated, Nonpayable {
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
100   function VaultbankToken() public {
101     symbol = "VB";
102     name = "Vaultbank Token";
103     decimals = 8;
104     _totalSupply = 45624002 * 10**uint(decimals);
105     balances[owner] = _totalSupply;
106     Transfer(address(0), owner, _totalSupply);
107 
108     regulationStatus[owner] = true;
109     Whitelisted(owner);
110   }
111 
112   function issue(address recipient, uint tokens) public onlyOwner returns (bool success) {
113     require(recipient != address(0));
114     require(recipient != owner);
115     
116     whitelist(recipient);
117     transfer(recipient, tokens);
118     return true;
119   }
120 
121   function transferOwnership(address newOwner) public onlyOwner {
122     require(newOwner != address(0));
123     require(newOwner != owner);
124    
125     whitelist(newOwner);
126     transfer(newOwner, balances[owner]);
127     owner = newOwner;
128   }
129 
130   function totalSupply() public constant returns (uint supply) {
131     return _totalSupply - balances[address(0)];
132   }
133 
134   function balanceOf(address tokenOwner) public constant returns (uint balance) {
135     return balances[tokenOwner];
136   }
137 
138   function transfer(address to, uint tokens) public returns (bool success) {
139     ensureRegulated(msg.sender);
140     ensureRegulated(to);
141     
142     balances[msg.sender] = balances[msg.sender].sub(tokens);
143     balances[to] = balances[to].add(tokens);
144     Transfer(msg.sender, to, tokens);
145     return true;
146   }
147 
148   function approve(address spender, uint tokens) public returns (bool success) {
149     // Put a check for race condition issue with approval workflow of ERC20
150     require((tokens == 0) || (allowed[msg.sender][spender] == 0));
151     
152     allowed[msg.sender][spender] = tokens;
153     Approval(msg.sender, spender, tokens);
154     return true;
155   }
156 
157   function transferFrom(address from, address to, uint tokens) public returns (bool success) {
158     ensureRegulated(from);
159     ensureRegulated(to);
160 
161     balances[from] = balances[from].sub(tokens);
162     allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
163     balances[to] = balances[to].add(tokens);
164     Transfer(from, to, tokens);
165     return true;
166   }
167 
168   function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
169     return allowed[tokenOwner][spender];
170   }
171 }