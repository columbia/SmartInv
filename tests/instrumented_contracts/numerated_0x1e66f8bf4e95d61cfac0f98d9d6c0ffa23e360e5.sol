1 pragma solidity ^0.4.23;
2 
3 contract SafeMath {
4     function safeAdd(uint a, uint b) public pure returns (uint c) {
5         c = a + b;
6         require(c >= a);
7     }
8     function safeSub(uint a, uint b) public pure returns (uint c) {
9         require(b <= a);
10         c = a - b;
11     }
12     function safeMul(uint a, uint b) public pure returns (uint c) {
13         c = a * b;
14         require(a == 0 || c / a == b);
15     }
16     function safeDiv(uint a, uint b) public pure returns (uint c) {
17         require(b > 0);
18         c = a / b;
19     }
20 }
21 
22 contract ERC20Interface {
23     function totalSupply() public constant returns (uint);
24     function balanceOf(address tokenOwner) public constant returns (uint balance);
25     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
26     function transfer(address to, uint tokens) public returns (bool success);
27     function approve(address spender, uint tokens) public returns (bool success);
28     function transferFrom(address from, address to, uint tokens) public returns (bool success);
29 
30     event Transfer(address indexed from, address indexed to, uint tokens);
31     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
32 }
33 
34 
35 // ----------------------------------------------------------------------------
36 // Owned contract
37 // ----------------------------------------------------------------------------
38 contract Owned {
39     address public owner;
40     address public newOwner;
41 
42     event OwnershipTransferred(address indexed _from, address indexed _to);
43 
44     constructor() public {
45         owner = msg.sender;
46     }
47 
48     modifier onlyOwner {
49         require(msg.sender == owner);
50         _;
51     }
52 
53     function transferOwnership(address _newOwner) public onlyOwner {
54         newOwner = _newOwner;
55     }
56     function acceptOwnership() public {
57         require(msg.sender == newOwner);
58         emit OwnershipTransferred(owner, newOwner);
59         owner = newOwner;
60         newOwner = address(0);
61     }
62 }
63 
64 contract MamaToken is ERC20Interface, Owned, SafeMath {
65     string public constant name = "MamaMutua";
66     string public constant symbol = "M2M";
67     uint32 public constant decimals = 18;
68     uint public _rate = 600;
69     uint256 public _totalSupply = 60000000 * (10 ** 18);
70     address owner;
71 
72     // amount of raised money in Wei
73     uint256 public weiRaised;
74 
75     mapping(address => uint) balances;
76     mapping(address => mapping(address => uint)) allowed;
77 
78     uint public openingTime = 1527638401; // 30 May 2018 00:01
79     uint public closingTime = 1546214399; // 30 Dec 2018 23:59
80 
81     constructor() public {
82         balances[msg.sender] = _totalSupply;
83         owner = msg.sender;
84 
85         emit Transfer(address(0), msg.sender, _totalSupply);
86     }
87 
88     function burn(uint256 _amount) public onlyOwner returns (bool) {
89         require(_amount <= balances[msg.sender]);
90 
91         balances[msg.sender] = safeSub(balances[msg.sender], _amount);
92         _totalSupply = safeSub(_totalSupply, _amount);
93         emit Transfer(msg.sender, address(0), _amount);
94         return true;
95     }
96 
97     function mint(address _to, uint256 _amount) public onlyOwner returns (bool) {
98         require(_totalSupply + _amount >= _totalSupply); // Overflow check
99 
100         _totalSupply = safeAdd(_totalSupply, _amount);
101         balances[_to] = safeAdd(balances[_to], _amount);
102         emit Transfer(address(0), _to, _amount);
103         return true;
104     }
105 
106     function totalSupply() public constant returns (uint) {
107         return _totalSupply - balances[address(0)];
108     }
109 
110     function balanceOf(address tokenOwner) public constant returns (uint balance) {
111         return balances[tokenOwner];
112     }
113 
114     function transfer(address to, uint256 tokens) public returns (bool success) {
115         /* Check if sender has balance and for overflows */
116         require(balances[msg.sender] >= tokens && balances[to] + tokens >= balances[to]);
117         // mitigates the ERC20 short address attack
118         if(msg.data.length < (2 * 32) + 4) { revert(); }
119 
120         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
121         balances[to] = safeAdd(balances[to], tokens);
122         emit Transfer(msg.sender, to, tokens);
123         return true;
124     }
125 
126     function approve(address spender, uint tokens) public returns (bool success) {
127         // mitigates the ERC20 spend/approval race condition
128         if (tokens != 0 && allowed[msg.sender][spender] != 0) { return false; }
129 
130         allowed[msg.sender][spender] = tokens;
131         emit Approval(msg.sender, spender, tokens);
132         return true;
133     }
134 
135     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
136         // mitigates the ERC20 short address attack
137         if(msg.data.length < (3 * 32) + 4) { revert(); }
138 
139         balances[from] = safeSub(balances[from], tokens);
140         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
141         balances[to] = safeAdd(balances[to], tokens);
142         emit Transfer(from, to, tokens);
143         return true;
144     }
145 
146     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
147         return allowed[tokenOwner][spender];
148     }
149 
150     function () external payable {
151         // Check ICO period
152         require(block.timestamp >= openingTime && block.timestamp <= closingTime);
153         buyTokens(msg.sender);
154     }
155 
156     // low level token purchase function
157     function buyTokens(address beneficiary) public payable {
158         require(beneficiary != address(0));
159         require(beneficiary != 0x0);
160         require(msg.value > 1 finney);
161 
162         uint256 weiAmount = msg.value;
163 
164         // update state
165         weiRaised = safeAdd(weiRaised, weiAmount);
166 
167         // calculate token amount to be created
168         uint256 tokensIssued = safeMul(_rate, weiAmount);
169 
170         // transfer tokens
171         balances[owner] = safeSub(balances[owner], tokensIssued);
172         balances[beneficiary] = safeAdd(balances[beneficiary], tokensIssued);
173 
174         emit Transfer(owner, beneficiary, tokensIssued);
175         forwardFunds(weiAmount);
176     }
177 
178     function forwardFunds(uint256 _weiAmount) internal {
179         owner.transfer(_weiAmount);
180     }
181 
182     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
183         return ERC20Interface(tokenAddress).transfer(owner, tokens);
184     }
185 }