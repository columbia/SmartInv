1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9     * @dev Multiplies two numbers, reverts on overflow.
10     */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         if (a == 0) {
13             return 0;
14         }
15 
16         uint256 c = a * b;
17         require(c / a == b);
18 
19         return c;
20     }
21 
22     /**
23     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
24     */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         require(b > 0);
27         uint256 c = a / b;
28 
29 
30         return c;
31     }
32 
33     /**
34     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
35     */
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         require(b <= a);
38         uint256 c = a - b;
39 
40         return c;
41     }
42 
43     /**
44     * @dev Adds two numbers, reverts on overflow.
45     */
46     function add(uint256 a, uint256 b) internal pure returns (uint256) {
47         uint256 c = a + b;
48         require(c >= a);
49 
50         return c;
51     }
52 }
53 
54 
55 contract ERC20Interface {
56     function totalSupply() public view returns (uint);
57     function balanceOf(address tokenOwner) public view returns (uint balance);
58     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
59     function transfer(address to, uint tokens) public returns (bool success);
60     function approve(address spender, uint tokens) public returns (bool success);
61     function transferFrom(address from, address to, uint tokens) public returns (bool success);
62 
63     event Transfer(address indexed from, address indexed to, uint tokens);
64     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
65 }
66 
67 
68 contract ApproveAndCallFallBack {
69     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
70 }
71 
72 
73 
74 contract Owned {
75     address public owner;
76     address public newOwner;
77 
78     event OwnershipTransferred(address indexed _from, address indexed _to);
79 
80     constructor() public {
81         owner = 0xD8df475E76844ea9F3bbb56D72EE5fD8F137787F;
82     }
83 
84     /**
85      * @dev Throws if called by any account other than the owner.
86      */
87     modifier onlyOwner {
88         require(msg.sender == owner);
89         _;
90     }
91 
92     function transferOwnership(address _newOwner) public onlyOwner {
93         newOwner = _newOwner;
94     }
95     function acceptOwnership() public {
96         require(msg.sender == newOwner);
97         emit OwnershipTransferred(owner, newOwner);
98         owner = newOwner;
99         newOwner = address(0);
100     }
101 }
102 
103 
104 contract Token is ERC20Interface, Owned {
105     using SafeMath for uint;
106 
107     string public name = "amazonblockchaintokens";   
108     string public symbol = "AMZN";   
109     uint8 public decimals = 10;    
110     uint public _totalSupply;   
111 
112 
113     mapping(address => uint) balances;  
114     mapping(address => mapping(address => uint)) allowed;   
115 
116 
117     constructor() public {   
118         name = "amazonblockchaintokens";
119         symbol = "AMZN";
120         decimals = 10;
121         _totalSupply = 100000000 * 10**uint(decimals); //100 million
122         balances[owner] = _totalSupply;
123         emit Transfer(address(0), owner, _totalSupply);
124     }
125 
126     function totalSupply() public view returns (uint) { 
127         return _totalSupply - balances[address(0)];
128     }
129 
130     // Extra function
131     function totalSupplyWithZeroAddress() public view returns (uint) { 
132         return _totalSupply;
133     }
134 
135     // Extra function
136     function totalSupplyWithoutDecimals() public view returns (uint) {
137         return _totalSupply / (10**uint(decimals));
138     }
139 
140 
141     function balanceOf(address tokenOwner) public view returns (uint balance) { 
142         return balances[tokenOwner];
143     }
144 
145     // Extra function
146     function myBalance() public view returns (uint balance) {
147         return balances[msg.sender];
148     }
149 
150 
151     function transfer(address to, uint tokens) public returns (bool success) {  
152         balances[msg.sender] = balances[msg.sender].sub(tokens);
153         balances[to] = balances[to].add(tokens);
154         emit Transfer(msg.sender, to, tokens);
155         return true;
156     }
157 
158     function approve(address spender, uint tokens) public returns (bool success) {  
159         allowed[msg.sender][spender] = tokens;
160         emit Approval(msg.sender, spender, tokens);
161         return true;
162     }
163 
164     function transferFrom(address from, address to, uint tokens) public returns (bool success) {    
165         balances[from] = balances[from].sub(tokens);
166         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
167         balances[to] = balances[to].add(tokens);
168         emit Transfer(from, to, tokens);
169         return true;
170     }
171 
172     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {  
173         return allowed[tokenOwner][spender];
174     }
175 
176     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
177         allowed[msg.sender][spender] = tokens;
178         emit Approval(msg.sender, spender, tokens);
179         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
180         return true;
181     }
182 
183     function () public payable {  
184         revert();
185     }
186 
187     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) { 
188         return ERC20Interface(tokenAddress).transfer(owner, tokens);        
189     }
190 
191     /*
192         Administrator functions
193     */
194 
195     // change symbol and name
196     function reconfig(string newName, string newSymbol) external onlyOwner {
197         symbol = newSymbol;
198         name = newName;
199     }
200 
201     // increase supply and send newly added tokens to owner
202     function increaseSupply(uint256 increase) external onlyOwner {
203         _totalSupply = _totalSupply.add(increase);
204         balances[owner] = balances[owner].add(increase);
205         emit Transfer(address(0), owner, increase);
206     }
207 
208     // decrease/burn supply
209     function burnTokens(uint256 decrease) external onlyOwner {
210         balances[owner] = balances[owner].sub(decrease);
211         _totalSupply = _totalSupply.sub(decrease);
212     }
213     
214     // deactivate the contract
215     function deactivate() external onlyOwner {
216         selfdestruct(owner);
217     }
218 }