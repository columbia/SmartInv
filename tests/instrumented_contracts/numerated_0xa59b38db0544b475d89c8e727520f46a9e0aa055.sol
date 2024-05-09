1 pragma solidity ^0.4.24;
2 
3 
4 // ----------------------------------------------------------------------------
5 // Eureka fixed supply token smart contract
6 //
7 // Symbol           : ERK
8 // Name             : Eureka
9 // Total Supply     : 150,000,000
10 // Decimals         : 18
11 // ----------------------------------------------------------------------------
12 
13 
14 // ----------------------------------------------------------------------------
15 // Safe math
16 // ----------------------------------------------------------------------------
17 library SafeMath {
18     function add(uint a, uint b) internal pure returns (uint c) {
19         c = a + b;
20         require(c >= a);
21     }
22     function sub(uint a, uint b) internal pure returns (uint c) {
23         require(b <= a);
24         c = a - b;
25     }
26     function mul(uint a, uint b) internal pure returns (uint c) {
27         c = a * b;
28         require(a == 0 || c / a == b);
29     }
30     function div(uint a, uint b) internal pure returns (uint c) {
31         require(b > 0);
32         c = a / b;
33     }
34 }
35 
36 
37 // ----------------------------------------------------------------------------
38 // ERC Token Standard #20 Interface
39 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
40 // ----------------------------------------------------------------------------
41 contract ERC20Interface {
42     function totalSupply() public view returns (uint);
43     function balanceOf(address tokenOwner) public view returns (uint balance);
44     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
45     function transfer(address to, uint tokens) public returns (bool success);
46     function approve(address spender, uint tokens) public returns (bool success);
47     function transferFrom(address from, address to, uint tokens) public returns (bool success);
48 
49     event Transfer(address indexed from, address indexed to, uint tokens);
50     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
51 }
52 
53 
54 // ----------------------------------------------------------------------------
55 // ERC20 Token, with the addition of symbol, name and decimals and an
56 // ----------------------------------------------------------------------------
57 contract Eureka is ERC20Interface {
58     
59     using SafeMath for uint;
60 
61     string public symbol;
62     string public  name;
63     uint8 public decimals;
64     uint public _totalSupply;
65 
66     mapping(address => uint) public balances;
67     mapping(address => mapping(address => uint)) public allowed;
68     
69     
70     // ------------------------------------------------------------------------
71     // Constructor
72     // ------------------------------------------------------------------------
73     constructor() public {
74         symbol = "ERK";
75         name = "Eureka";
76         decimals = 18;
77         _totalSupply = 150000000;
78         _totalSupply = _totalSupply.mul(10 ** uint(decimals));
79         balances[msg.sender] = _totalSupply;
80         emit Transfer(address(0), msg.sender, _totalSupply);
81     }
82     
83     
84     // ------------------------------------------------------------------------
85     // Reject when someone sends ethers to this contract
86     // ------------------------------------------------------------------------
87     function() public payable {
88         revert();
89     }
90     
91     
92     // ------------------------------------------------------------------------
93     // Total supply
94     // ------------------------------------------------------------------------
95     function totalSupply() public view returns (uint) {
96         return _totalSupply;
97     }
98 
99 
100     // ------------------------------------------------------------------------
101     // Get the token balance for account `tokenOwner`
102     // ------------------------------------------------------------------------
103     function balanceOf(address tokenOwner) public view returns (uint balance) {
104         return balances[tokenOwner];
105     }
106 
107 
108     // ------------------------------------------------------------------------
109     // Transfer the balance from token owner's account to `to` account
110     // - Owner's account must have sufficient balance to transfer
111     // - 0 value transfers are allowed
112     // ------------------------------------------------------------------------
113     function transfer(address to, uint tokens) public returns (bool success) {
114         require(to != address(0));
115         require(tokens > 0);
116         require(balances[msg.sender] >= tokens);
117         
118         balances[msg.sender] = balances[msg.sender].sub(tokens);
119         balances[to] = balances[to].add(tokens);
120         emit Transfer(msg.sender, to, tokens);
121         return true;
122     }
123 
124 
125     // ------------------------------------------------------------------------
126     // Token owner can approve for `spender` to transferFrom(...) `tokens`
127     // from the token owner's account
128     //
129     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
130     // recommends that there are no checks for the approval double-spend attack
131     // as this should be implemented in user interfaces 
132     // ------------------------------------------------------------------------
133     function approve(address spender, uint tokens) public returns (bool success) {
134         require(spender != address(0));
135         require(tokens > 0);
136         
137         allowed[msg.sender][spender] = tokens;
138         emit Approval(msg.sender, spender, tokens);
139         return true;
140     }
141 
142 
143     // ------------------------------------------------------------------------
144     // Transfer `tokens` from the `from` account to the `to` account
145     // 
146     // The calling account must already have sufficient tokens approve(...)-d
147     // for spending from the `from` account and
148     // - From account must have sufficient balance to transfer
149     // - Spender must have sufficient allowance to transfer
150     // ------------------------------------------------------------------------
151     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
152         require(from != address(0));
153         require(to != address(0));
154         require(tokens > 0);
155         require(balances[from] >= tokens);
156         require(allowed[from][msg.sender] >= tokens);
157         
158         balances[from] = balances[from].sub(tokens);
159         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
160         balances[to] = balances[to].add(tokens);
161         emit Transfer(from, to, tokens);
162         return true;
163     }
164 
165 
166     // ------------------------------------------------------------------------
167     // Returns the amount of tokens approved by the owner that can be
168     // transferred to the spender's account
169     // ------------------------------------------------------------------------
170     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
171         return allowed[tokenOwner][spender];
172     }
173     
174     
175     // ------------------------------------------------------------------------
176     // Increase the amount of tokens that an owner allowed to a spender.
177     //
178     // approve should be called when allowed[_spender] == 0. To increment
179     // allowed value is better to use this function to avoid 2 calls (and wait until
180     // the first transaction is mined)
181     // _spender The address which will spend the funds.
182     // _addedValue The amount of tokens to increase the allowance by.
183     // ------------------------------------------------------------------------
184     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
185         require(_spender != address(0));
186         
187         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
188         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
189         return true;
190     }
191     
192     
193     // ------------------------------------------------------------------------
194     // Decrease the amount of tokens that an owner allowed to a spender.
195     //
196     // approve should be called when allowed[_spender] == 0. To decrement
197     // allowed value is better to use this function to avoid 2 calls (and wait until
198     // the first transaction is mined)
199     // _spender The address which will spend the funds.
200     // _subtractedValue The amount of tokens to decrease the allowance by.
201     // ------------------------------------------------------------------------
202     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
203         require(_spender != address(0));
204         
205         uint oldValue = allowed[msg.sender][_spender];
206         if (_subtractedValue > oldValue) {
207             allowed[msg.sender][_spender] = 0;
208         } else {
209             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
210         }
211         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
212         return true;
213     }
214 
215 }