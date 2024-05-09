1 pragma solidity ^0.4.24;
2 // ----------------------------------------------------------------------------
3 // 'Bitway' 'ERC20 Token'
4 // 
5 // Name        : Bitway
6 // Symbol      : BTWX
7 // Max supply  : 21m
8 // Decimals    : 18
9 //
10 // Bitway "BTWX"
11 // ----------------------------------------------------------------------------
12 //
13 // ----------------------------------------------------------------------------
14 // Safe maths
15 // ----------------------------------------------------------------------------
16 library SafeMath {
17     function add(uint a, uint b) internal pure returns (uint c) {
18         c = a + b;
19         require(c >= a);
20     }
21     function sub(uint a, uint b) internal pure returns (uint c) {
22         require(b <= a);
23         c = a - b;
24     }
25     function mul(uint a, uint b) internal pure returns (uint c) {
26         c = a * b;
27         require(a == 0 || c / a == b);
28     }
29     function div(uint a, uint b) internal pure returns (uint c) {
30         require(b > 0);
31         c = a / b;
32     }
33 }
34 // ----------------------------------------------------------------------------
35 // ERC20 Token Standard
36 // ----------------------------------------------------------------------------
37 contract ERC20 {
38     function totalSupply() public constant returns (uint);
39     function balanceOf(address tokenOwner) public constant returns (uint balance);
40     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
41     function transfer(address to, uint tokens) public returns (bool success);
42     function approve(address spender, uint tokens) public returns (bool success);
43     function transferFrom(address from, address to, uint tokens) public returns (bool success);
44 
45     event Transfer(address indexed from, address indexed to, uint tokens);
46     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
47 }
48 
49 // ----------------------------------------------------------------------------
50 // ERC20 Token, with the addition of symbol, name, decimals and totalSupply
51 // ----------------------------------------------------------------------------
52 contract Bitway is ERC20 {
53     
54     using SafeMath for uint;
55 
56     string public name = "Bitway";
57     string public symbol = "BTWX";
58     uint public totalSupply = 0;
59     uint8 public decimals = 18;
60     uint public RATE = 1000;
61     
62     uint multiplier = 10 ** uint(decimals);
63     uint million = 10 ** 6;
64     uint millionTokens = 1 * million * multiplier;
65     
66     uint constant stageTotal = 5;
67     uint stage = 0;
68     uint [stageTotal] targetSupply = [
69          1 * millionTokens,
70          2 * millionTokens,
71          5 * millionTokens,
72          10 * millionTokens,
73          21 * millionTokens
74     ];
75     
76     address public owner;
77     bool public completed = true;
78     mapping(address => uint) balances;
79     mapping(address => mapping(address => uint)) allowed;
80     
81     constructor() public {
82     owner = msg.sender;
83     supplyTokens(millionTokens);
84     }
85     
86     // ------------------------------------------------------------------------
87     // Payable token creation
88     // ------------------------------------------------------------------------
89     function () public payable {
90         createTokens();
91     }
92     
93     // ------------------------------------------------------------------------
94     // Returns currentStage
95     // ------------------------------------------------------------------------
96     function currentStage() public constant returns (uint) {
97         return stage + 1;
98     }
99     
100     // ------------------------------------------------------------------------
101     // Returns maxSupplyReached True / False
102     // ------------------------------------------------------------------------
103     function maxSupplyReached() public constant returns (bool) {
104         return stage >= stageTotal;
105     }
106     
107     // ------------------------------------------------------------------------
108     // Token creation
109     // ------------------------------------------------------------------------
110     function createTokens() public payable {
111         require(!completed);
112         supplyTokens(msg.value.mul((15 - stage) * RATE / 10)); 
113         owner.transfer(msg.value);
114     }
115     
116     // ------------------------------------------------------------------------
117     // Complete token sale
118     // ------------------------------------------------------------------------
119     function setComplete(bool _completed) public {
120         require(msg.sender == owner);
121         completed = _completed;
122     }
123     
124     // ------------------------------------------------------------------------
125     // Check totalSupply
126     // ------------------------------------------------------------------------
127     function totalSupply() public view returns (uint) {
128         return totalSupply;
129     }
130 
131     // ------------------------------------------------------------------------
132     // Get the token balance for account `tokenOwner`
133     // ------------------------------------------------------------------------
134     function balanceOf(address tokenOwner) public view returns (uint) {
135         return balances[tokenOwner];
136     }
137 
138     // ------------------------------------------------------------------------
139     // Transfer the balance from token owner's account to `to` account
140     // ------------------------------------------------------------------------
141     function transfer(address to, uint tokens) public returns (bool success) {
142         balances[msg.sender] = balances[msg.sender].sub(tokens);
143         balances[to] = balances[to].add(tokens);
144         emit Transfer(msg.sender, to, tokens);
145         return true;
146     }
147 
148     // ------------------------------------------------------------------------
149     // Token owner can approve for `spender` to transferFrom(...) `tokens` from the token owner's account
150     // ------------------------------------------------------------------------
151     function approve(address spender, uint tokens) public returns (bool success) {
152         allowed[msg.sender][spender] = tokens;
153         emit Approval(msg.sender, spender, tokens);
154         return true;
155     }
156 
157     // ------------------------------------------------------------------------
158     // Transfer `tokens` from the `from` account to the `to` account
159     // ------------------------------------------------------------------------
160     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
161         balances[from] = balances[from].sub(tokens);
162         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
163         balances[to] = balances[to].add(tokens);
164         emit Transfer(from, to, tokens);
165         return true;
166     }
167 
168     // ------------------------------------------------------------------------
169     // Returns the amount of tokens approved by the owner that can be transferred to the spender's account
170     // ------------------------------------------------------------------------
171     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
172         return allowed[tokenOwner][spender];
173     }
174     
175     // ------------------------------------------------------------------------
176     // Create tokens and supply to msg.sender balances
177     // ------------------------------------------------------------------------
178     function supplyTokens(uint tokens) private {
179         require(!maxSupplyReached());
180         balances[msg.sender] = balances[msg.sender].add(tokens);
181         totalSupply = totalSupply.add(tokens);
182         if (totalSupply >= targetSupply[stage]) {
183             stage += 1;
184         }
185         emit Transfer(address(0), msg.sender, tokens);
186     }
187 
188     event Transfer(address indexed from, address indexed to, uint tokens);
189     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
190 }