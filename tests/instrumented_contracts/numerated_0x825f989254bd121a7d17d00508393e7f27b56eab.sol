1 pragma solidity 0.4.25;
2 
3 // ----------------------------------------------------------------------------
4 // 'SmartContractFactory' token contract
5 // Version: 2.0 
6 // Date: 15 March 2019
7 // ----------------------------------------------------------------------------
8 
9 // ----------------------------------------------------------------------------
10 // Safe maths
11 // ----------------------------------------------------------------------------
12 contract SafeMath
13 {
14     function safeAdd(uint a, uint b) public pure returns (uint c) {
15         c = a + b;
16         require(c >= a);
17     }
18     function safeSub(uint a, uint b) public pure returns (uint c) {
19         require(b <= a);
20         c = a - b;
21     }
22     function safeMul(uint a, uint b) public pure returns (uint c) {
23         c = a * b;
24         require(a == 0 || c / a == b);
25     }
26     function safeDiv(uint a, uint b) public pure returns (uint c) {
27         require(b > 0);
28         c = a / b;
29     }
30 }
31 
32 // ----------------------------------------------------------------------------
33 // ERC20 Interface
34 // ----------------------------------------------------------------------------
35 contract ERC20Basic
36 {
37     uint public totalSupply;
38     function balanceOf(address who) public constant returns (uint);
39     function transfer(address to, uint value) public returns (bool success);
40     event Transfer(address indexed from, address indexed to, uint value);
41 }
42 
43 contract ERC20 is ERC20Basic
44 {
45     function allowance(address owner, address spender) public constant returns (uint);
46     function transferFrom(address from, address to, uint value) public returns (bool success);
47     function approve(address spender, uint value) public returns (bool success);
48     event Approval(address indexed owner, address indexed spender, uint value);
49 }
50 
51 contract BasicToken is ERC20Basic, SafeMath
52 {
53     mapping(address => uint) balances;
54 
55     function transfer(address to, uint value) public returns (bool success)
56     {
57         require(value <= balances[msg.sender]);
58         require(to != address(0));
59 
60         balances[msg.sender] = safeSub(balances[msg.sender], value);
61         balances[to] = safeAdd(balances[to], value);
62         emit Transfer(msg.sender, to, value);
63         return true;
64     }
65 
66     function balanceOf(address owner) public constant returns (uint balance)
67     {
68         return balances[owner];
69     }
70 }
71 
72 contract StandardToken is BasicToken, ERC20
73 {
74     mapping (address => mapping (address => uint)) allowed;
75 
76     function transferFrom(address from, address to, uint value) public returns (bool success)
77     {
78         require(value <= balances[from]);
79         require(value <= allowed[from][msg.sender]);
80         require(to != address(0));
81 
82         uint allowance = allowed[from][msg.sender];
83         balances[to] = safeAdd(balances[to], value);
84         balances[from] = safeSub(balances[from], value);
85         allowed[from][msg.sender] = safeSub(allowance, value);
86         emit Transfer(from, to, value);
87         return true;
88     }
89 
90     function approve(address spender, uint value) public returns (bool success)
91     {
92         require(spender != address(0));
93         require(!((value != 0) && (allowed[msg.sender][spender] != 0)));
94 
95         allowed[msg.sender][spender] = value;
96         emit Approval(msg.sender, spender, value);
97         return true;
98     }
99 
100     function allowance(address owner, address spender) public constant returns (uint remaining)
101     {
102         return allowed[owner][spender];
103     }
104 }
105 
106 // ----------------------------------------------------------------------------
107 // Owned contract
108 // ----------------------------------------------------------------------------
109 contract OwnedToken is StandardToken {
110     address public owner;
111     address public newOwner;
112 
113     event OwnershipTransferred(address indexed _from, address indexed _to);
114 
115     constructor() public {
116         owner = msg.sender;
117     }
118 
119     modifier onlyOwner {
120         require(msg.sender == owner);
121         _;
122     }
123 
124     function transferOwnership(address _newOwner) public onlyOwner {
125         newOwner = _newOwner;
126     }
127 
128     function acceptOwnership() public {
129         require(msg.sender == newOwner);
130         emit OwnershipTransferred(owner, newOwner);
131         owner = newOwner;
132         newOwner = address(0);
133     }
134 }
135 
136 // ----------------------------------------------------------------------------
137 // Burnable contract
138 // ----------------------------------------------------------------------------
139 contract BurnableToken is OwnedToken
140 {
141     event Burn(address account, uint256 amount);
142 
143     function burn(address account, uint256 amount) public onlyOwner returns (bool success)
144     {
145        require(account != 0);
146        require(amount <= balances[account]);
147 
148        totalSupply = safeSub(totalSupply, amount);
149        balances[account] = safeSub(balances[account], amount);
150        emit Burn(account, amount);
151        return true;
152      }
153 
154     function burnFrom(address account, uint256 amount) public onlyOwner returns (bool success)
155     {
156       require(amount <= allowed[account][msg.sender]);
157 
158       // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
159       // this function needs to emit an event with the updated approval.
160       allowed[account][msg.sender] = safeSub(allowed[account][msg.sender], amount);
161       burn(account, amount);
162       return true;
163     }
164 }
165 
166 // ----------------------------------------------------------------------------
167 // SmartContractFactory contract
168 // ----------------------------------------------------------------------------
169 contract SmartContractFactory is BurnableToken
170 {
171     string public name = "SmartContractFactory";
172     string public symbol = "SCF";
173     uint public decimals = 8 ;
174     uint public INITIAL_SUPPLY = 1000000000000000000;
175     uint public LOCKED_SUPPLY = 700000000000000000;
176     uint public LOCKUP_FINISH_TIMESTAMP =  1568541600; // 15 September 2019 10:00 AM GMT
177 
178     constructor() public {
179         owner = msg.sender;
180         totalSupply = INITIAL_SUPPLY;
181 
182         // Circulating supply
183         balances[owner] = totalSupply - LOCKED_SUPPLY;
184         // Locked supply 
185         // Lock up tokens by moving them to our contract address 
186         // Nobody has the key to access it, because address is created dynamically during deployment
187         balances[address(this)]= LOCKED_SUPPLY;
188 
189         emit Transfer(address(0), owner, totalSupply);
190     }
191     
192     function isLockupFinished() public view returns (bool success)
193     {
194       return (block.timestamp >= LOCKUP_FINISH_TIMESTAMP);
195     }
196         
197     function releaseLockup() public onlyOwner {
198         require(isLockupFinished());
199 
200         uint256 amount = balances[address(this)];
201         require(amount > 0);
202         
203         // Transfer tokens from contract address back to owner address
204         BasicToken(address(this)).transfer(owner, amount);
205     }
206 
207     // ------------------------------------------------------------------------
208     // Don't accept ETH
209     // ------------------------------------------------------------------------
210     function () public payable {
211         revert();
212     }
213 }