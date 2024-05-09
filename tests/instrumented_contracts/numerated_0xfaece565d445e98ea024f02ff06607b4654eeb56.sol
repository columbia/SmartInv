1 pragma solidity ^0.5.4;
2 
3 // ----------------------------------------------------------------------------
4 // BokkyPooBah's Fixed Supply Token 👊 + Factory v1.00
5 //
6 // A factory to convieniently deploy your own source verified fixed supply
7 // token contracts
8 //
9 // Factory deployment address: 0xfAEcE565D445e98Ea024f02FF06607B4654eEb56
10 //
11 // https://github.com/bokkypoobah/FixedSupplyTokenFactory
12 //
13 // Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2019. The MIT Licence.
14 // ----------------------------------------------------------------------------
15 
16 
17 // ----------------------------------------------------------------------------
18 // Safe maths
19 // ----------------------------------------------------------------------------
20 library SafeMath {
21     function add(uint a, uint b) internal pure returns (uint c) {
22         c = a + b;
23         require(c >= a);
24     }
25     function sub(uint a, uint b) internal pure returns (uint c) {
26         require(b <= a);
27         c = a - b;
28     }
29 }
30 
31 
32 // ----------------------------------------------------------------------------
33 // Owned contract
34 // ----------------------------------------------------------------------------
35 contract Owned {
36     address public owner;
37     address public newOwner;
38 
39     event OwnershipTransferred(address indexed _from, address indexed _to);
40 
41     modifier onlyOwner {
42         require(msg.sender == owner);
43         _;
44     }
45 
46     constructor(address _owner) public {
47         owner = _owner;
48     }
49     function transferOwnership(address _newOwner) public onlyOwner {
50         newOwner = _newOwner;
51     }
52     function acceptOwnership() public {
53         require(msg.sender == newOwner);
54         emit OwnershipTransferred(owner, newOwner);
55         owner = newOwner;
56         newOwner = address(0);
57     }
58 }
59 
60 
61 // ----------------------------------------------------------------------------
62 // ApproveAndCall Fallback
63 // ----------------------------------------------------------------------------
64 contract ApproveAndCallFallback {
65     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
66 }
67 
68 
69 // ----------------------------------------------------------------------------
70 // ERC Token Standard #20 Interface
71 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
72 // ----------------------------------------------------------------------------
73 contract ERC20Interface {
74     event Transfer(address indexed from, address indexed to, uint tokens);
75     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
76 
77     function totalSupply() public view returns (uint);
78     function balanceOf(address tokenOwner) public view returns (uint balance);
79     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
80     function transfer(address to, uint tokens) public returns (bool success);
81     function approve(address spender, uint tokens) public returns (bool success);
82     function transferFrom(address from, address to, uint tokens) public returns (bool success);
83 }
84 
85 
86 // ----------------------------------------------------------------------------
87 // Token Interface = ERC20 + symbol + name + decimals + approveAndCall
88 // ----------------------------------------------------------------------------
89 contract TokenInterface is ERC20Interface {
90     function symbol() public view returns (string memory);
91     function name() public view returns (string memory);
92     function decimals() public view returns (uint8);
93     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success);
94 }
95 
96 
97 // ----------------------------------------------------------------------------
98 // FixedSupplyToken 👊 = ERC20 + symbol + name + decimals + approveAndCall
99 // ----------------------------------------------------------------------------
100 contract FixedSupplyToken is TokenInterface, Owned {
101     using SafeMath for uint;
102 
103     string _symbol;
104     string  _name;
105     uint8 _decimals;
106     uint _totalSupply;
107 
108     mapping(address => uint) balances;
109     mapping(address => mapping(address => uint)) allowed;
110 
111     constructor(address tokenOwner, string memory symbol, string memory name, uint8 decimals, uint fixedSupply) public Owned(tokenOwner) {
112         _symbol = symbol;
113         _name = name;
114         _decimals = decimals;
115         _totalSupply = fixedSupply;
116         balances[tokenOwner] = _totalSupply;
117         emit Transfer(address(0), tokenOwner, _totalSupply);
118     }
119     function symbol() public view returns (string memory) {
120         return _symbol;
121     }
122     function name() public view returns (string memory) {
123         return _name;
124     }
125     function decimals() public view returns (uint8) {
126         return _decimals;
127     }
128     function totalSupply() public view returns (uint) {
129         return _totalSupply.sub(balances[address(0)]);
130     }
131     function balanceOf(address tokenOwner) public view returns (uint balance) {
132         return balances[tokenOwner];
133     }
134     function transfer(address to, uint tokens) public returns (bool success) {
135         balances[msg.sender] = balances[msg.sender].sub(tokens);
136         balances[to] = balances[to].add(tokens);
137         emit Transfer(msg.sender, to, tokens);
138         return true;
139     }
140     function approve(address spender, uint tokens) public returns (bool success) {
141         allowed[msg.sender][spender] = tokens;
142         emit Approval(msg.sender, spender, tokens);
143         return true;
144     }
145     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
146         balances[from] = balances[from].sub(tokens);
147         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
148         balances[to] = balances[to].add(tokens);
149         emit Transfer(from, to, tokens);
150         return true;
151     }
152     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
153         return allowed[tokenOwner][spender];
154     }
155     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
156         allowed[msg.sender][spender] = tokens;
157         emit Approval(msg.sender, spender, tokens);
158         ApproveAndCallFallback(spender).receiveApproval(msg.sender, tokens, address(this), data);
159         return true;
160     }
161     function recoverTokens(address token, uint tokens) public onlyOwner {
162         if (token == address(0)) {
163             address(uint160(owner)).transfer((tokens == 0 ? address(this).balance : tokens));
164         } else {
165             ERC20Interface(token).transfer(owner, tokens == 0 ? ERC20Interface(token).balanceOf(address(this)) : tokens);
166         }
167     }
168     function () external payable {
169         revert();
170     }
171 }
172 
173 
174 // ----------------------------------------------------------------------------
175 // BokkyPooBah's Fixed Supply Token 👊 Factory
176 //
177 // Notes:
178 //   * The `newContractAddress` deprecation is just advisory
179 //   * The minimum fee must be sent with the `deployTokenContract(...)` call
180 //   * Any excess over the fee will be refunded to the sending account
181 //
182 // Execute `deployTokenContract(...)` with the following parameters
183 // to deploy your very own FixedSupplyToken contract:
184 //   symbol         symbol
185 //   name           name
186 //   decimals       number of decimal places for the token contract
187 //   totalSupply    the fixed token total supply
188 //
189 // For example, deploying a FixedSupplyToken contract with a
190 // `totalSupply` of 1,000.000000000000000000 tokens:
191 //   symbol         "ME"
192 //   name           "My Token"
193 //   decimals       18
194 //   initialSupply  10000000000000000000000 = 1,000.000000000000000000 tokens
195 //
196 // The FixedSupplyTokenListing() event is logged with the following
197 // parameters:
198 //   owner          the account that execute this transaction
199 //   tokenAddress   the newly deployed FixedSupplyToken address
200 //   symbol         symbol
201 //   name           name
202 //   decimals       number of decimal places for the token contract
203 //   totalSupply    the fixed token total supply
204 // ----------------------------------------------------------------------------
205 contract BokkyPooBahsFixedSupplyTokenFactory is Owned {
206     using SafeMath for uint;
207 
208     address public newAddress;
209     uint public minimumFee = 0.1 ether;
210     mapping(address => bool) public isChild;
211     address[] public children;
212 
213     event FactoryDeprecated(address _newAddress);
214     event MinimumFeeUpdated(uint oldFee, uint newFee);
215     event TokenDeployed(address indexed owner, address indexed token, string symbol, string name, uint8 decimals, uint totalSupply);
216 
217     constructor() public Owned(msg.sender) {
218         // Initial contract for source code verification
219         _deployTokenContract(msg.sender, "FIST", "Fixed Supply Token 👊 v1.00", 18, 10**24);
220     }
221     function numberOfChildren() public view returns (uint) {
222         return children.length;
223     }
224     function deprecateFactory(address _newAddress) public onlyOwner {
225         require(newAddress == address(0));
226         emit FactoryDeprecated(_newAddress);
227         newAddress = _newAddress;
228     }
229     function setMinimumFee(uint _minimumFee) public onlyOwner {
230         emit MinimumFeeUpdated(minimumFee, _minimumFee);
231         minimumFee = _minimumFee;
232     }
233     function deployTokenContract(string memory symbol, string memory name, uint8 decimals, uint totalSupply) public payable returns (address token) {
234         require(msg.value >= minimumFee);
235         require(decimals <= 27);
236         require(totalSupply > 0);
237         token = _deployTokenContract(msg.sender, symbol, name, decimals, totalSupply);
238         if (msg.value > 0) {
239             address(uint160(owner)).transfer(msg.value);
240         }
241     }
242     function recoverTokens(address token, uint tokens) public onlyOwner {
243         if (token == address(0)) {
244             address(uint160(owner)).transfer((tokens == 0 ? address(this).balance : tokens));
245         } else {
246             ERC20Interface(token).transfer(owner, tokens == 0 ? ERC20Interface(token).balanceOf(address(this)) : tokens);
247         }
248     }
249     function () external payable {
250         revert();
251     }
252     function _deployTokenContract(address owner, string memory symbol, string memory name, uint8 decimals, uint totalSupply) internal returns (address token) {
253         token = address(new FixedSupplyToken(owner, symbol, name, decimals, totalSupply));
254         isChild[token] = true;
255         children.push(token);
256         emit TokenDeployed(owner, token, symbol, name, decimals, totalSupply);
257     }
258 }