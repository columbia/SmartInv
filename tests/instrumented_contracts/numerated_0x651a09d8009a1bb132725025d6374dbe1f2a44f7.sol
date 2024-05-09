1 pragma solidity ^0.5.4;
2 
3 // ----------------------------------------------------------------------------
4 // BokkyPooBah's Fixed Supply Token 👊 + Factory v1.10
5 //
6 // A factory to conveniently deploy your own source code verified fixed supply
7 // token contracts
8 //
9 // Factory deployment address: 0xA550114ee3688601006b8b9f25e64732eF774934
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
33 // Owned contract, with token recovery
34 // ----------------------------------------------------------------------------
35 contract Owned {
36     address payable public owner;
37     address public newOwner;
38 
39     event OwnershipTransferred(address indexed _from, address indexed _to);
40 
41     modifier onlyOwner {
42         require(msg.sender == owner);
43         _;
44     }
45 
46     function init(address _owner) public {
47         require(owner == address(0));
48         owner = address(uint160(_owner));
49     }
50     function transferOwnership(address _newOwner) public onlyOwner {
51         newOwner = _newOwner;
52     }
53     function acceptOwnership() public {
54         require(msg.sender == newOwner);
55         emit OwnershipTransferred(owner, newOwner);
56         owner = address(uint160(newOwner));
57         newOwner = address(0);
58     }
59     function recoverTokens(address token, uint tokens) public onlyOwner {
60         if (token == address(0)) {
61             owner.transfer((tokens == 0 ? address(this).balance : tokens));
62         } else {
63             ERC20Interface(token).transfer(owner, tokens == 0 ? ERC20Interface(token).balanceOf(address(this)) : tokens);
64         }
65     }
66 }
67 
68 
69 // ----------------------------------------------------------------------------
70 // ApproveAndCall Fallback
71 // NOTE for contracts implementing this interface:
72 // 1. An error must be thrown if there are errors executing `transferFrom(...)`
73 // 2. The calling token contract must be checked to prevent malicious behaviour
74 // ----------------------------------------------------------------------------
75 contract ApproveAndCallFallback {
76     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
77 }
78 
79 
80 // ----------------------------------------------------------------------------
81 // ERC Token Standard #20 Interface
82 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
83 // ----------------------------------------------------------------------------
84 contract ERC20Interface {
85     event Transfer(address indexed from, address indexed to, uint tokens);
86     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
87 
88     function totalSupply() public view returns (uint);
89     function balanceOf(address tokenOwner) public view returns (uint balance);
90     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
91     function transfer(address to, uint tokens) public returns (bool success);
92     function approve(address spender, uint tokens) public returns (bool success);
93     function transferFrom(address from, address to, uint tokens) public returns (bool success);
94 }
95 
96 
97 // ----------------------------------------------------------------------------
98 // Token Interface = ERC20 + symbol + name + decimals + approveAndCall
99 // ----------------------------------------------------------------------------
100 contract TokenInterface is ERC20Interface {
101     function symbol() public view returns (string memory);
102     function name() public view returns (string memory);
103     function decimals() public view returns (uint8);
104     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success);
105 }
106 
107 
108 // ----------------------------------------------------------------------------
109 // FixedSupplyToken 👊 = ERC20 + symbol + name + decimals + approveAndCall
110 // ----------------------------------------------------------------------------
111 contract FixedSupplyToken is TokenInterface, Owned {
112     using SafeMath for uint;
113 
114     string _symbol;
115     string  _name;
116     uint8 _decimals;
117     uint _totalSupply;
118 
119     mapping(address => uint) balances;
120     mapping(address => mapping(address => uint)) allowed;
121 
122     function init(address tokenOwner, string memory symbol, string memory name, uint8 decimals, uint fixedSupply) public {
123         super.init(tokenOwner);
124         _symbol = symbol;
125         _name = name;
126         _decimals = decimals;
127         _totalSupply = fixedSupply;
128         balances[tokenOwner] = _totalSupply;
129         emit Transfer(address(0), tokenOwner, _totalSupply);
130     }
131     function symbol() public view returns (string memory) {
132         return _symbol;
133     }
134     function name() public view returns (string memory) {
135         return _name;
136     }
137     function decimals() public view returns (uint8) {
138         return _decimals;
139     }
140     function totalSupply() public view returns (uint) {
141         return _totalSupply.sub(balances[address(0)]);
142     }
143     function balanceOf(address tokenOwner) public view returns (uint balance) {
144         return balances[tokenOwner];
145     }
146     function transfer(address to, uint tokens) public returns (bool success) {
147         balances[msg.sender] = balances[msg.sender].sub(tokens);
148         balances[to] = balances[to].add(tokens);
149         emit Transfer(msg.sender, to, tokens);
150         return true;
151     }
152     function approve(address spender, uint tokens) public returns (bool success) {
153         allowed[msg.sender][spender] = tokens;
154         emit Approval(msg.sender, spender, tokens);
155         return true;
156     }
157     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
158         balances[from] = balances[from].sub(tokens);
159         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
160         balances[to] = balances[to].add(tokens);
161         emit Transfer(from, to, tokens);
162         return true;
163     }
164     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
165         return allowed[tokenOwner][spender];
166     }
167     // NOTE Only use this call with a trusted spender contract
168     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
169         allowed[msg.sender][spender] = tokens;
170         emit Approval(msg.sender, spender, tokens);
171         ApproveAndCallFallback(spender).receiveApproval(msg.sender, tokens, address(this), data);
172         return true;
173     }
174     function () external payable {
175         revert();
176     }
177 }
178 
179 
180 // ----------------------------------------------------------------------------
181 // BokkyPooBah's Fixed Supply Token 👊 Factory
182 //
183 // Notes:
184 //   * The `newContractAddress` deprecation is just advisory
185 //   * A fee equal to or above `minimumFee` must be sent with the
186 //   `deployTokenContract(...)` call
187 //
188 // Execute `deployTokenContract(...)` with the following parameters to deploy
189 // your very own FixedSupplyToken contract:
190 //   symbol         symbol
191 //   name           name
192 //   decimals       number of decimal places for the token contract
193 //   totalSupply    the fixed token total supply
194 //
195 // For example, deploying a FixedSupplyToken contract with a `totalSupply`
196 // of 1,000.000000000000000000 tokens:
197 //   symbol         "ME"
198 //   name           "My Token"
199 //   decimals       18
200 //   initialSupply  10000000000000000000000 = 1,000.000000000000000000 tokens
201 //
202 // The TokenDeployed() event is logged with the following parameters:
203 //   owner          the account that execute this transaction
204 //   token          the newly deployed FixedSupplyToken address
205 //   symbol         symbol
206 //   name           name
207 //   decimals       number of decimal places for the token contract
208 //   totalSupply    the fixed token total supply
209 // ----------------------------------------------------------------------------
210 contract BokkyPooBahsFixedSupplyTokenFactory is Owned {
211     using SafeMath for uint;
212 
213     address public newAddress;
214     uint public minimumFee = 0.1 ether;
215     mapping(address => bool) public isChild;
216     address[] public children;
217 
218     event FactoryDeprecated(address _newAddress);
219     event MinimumFeeUpdated(uint oldFee, uint newFee);
220     event TokenDeployed(address indexed owner, address indexed token, string symbol, string name, uint8 decimals, uint totalSupply);
221 
222     constructor () public {
223         super.init(msg.sender);
224     }
225     function numberOfChildren() public view returns (uint) {
226         return children.length;
227     }
228     function deprecateFactory(address _newAddress) public onlyOwner {
229         require(newAddress == address(0));
230         emit FactoryDeprecated(_newAddress);
231         newAddress = _newAddress;
232     }
233     function setMinimumFee(uint _minimumFee) public onlyOwner {
234         emit MinimumFeeUpdated(minimumFee, _minimumFee);
235         minimumFee = _minimumFee;
236     }
237     function deployTokenContract(string memory symbol, string memory name, uint8 decimals, uint totalSupply) public payable returns (FixedSupplyToken token) {
238         require(msg.value >= minimumFee);
239         require(decimals <= 27);
240         require(totalSupply > 0);
241         token = new FixedSupplyToken();
242         token.init(msg.sender, symbol, name, decimals, totalSupply);
243         isChild[address(token)] = true;
244         children.push(address(token));
245         emit TokenDeployed(owner, address(token), symbol, name, decimals, totalSupply);
246         if (msg.value > 0) {
247             owner.transfer(msg.value);
248         }
249     }
250     function () external payable {
251         revert();
252     }
253 }