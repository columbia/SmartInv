1 pragma solidity ^0.5.0;
2 
3 // ----------------------------------------------------------------------------
4 // Symbol      : STON
5 // Name        : STONetwork
6 // Total supply: 100,000,0000.000000000000000000
7 // Decimals    : 18
8 // Copyright (c) 2018 <STONetwork>. The MIT Licence.
9 // ----------------------------------------------------------------------------
10 
11 
12 // ----------------------------------------------------------------------------
13 // Safe maths
14 // ----------------------------------------------------------------------------
15 library SafeMath {
16     function add(uint a, uint b) internal pure returns (uint c) {
17         c = a + b;
18         require(c >= a);
19     }
20     function sub(uint a, uint b) internal pure returns (uint c) {
21         require(b <= a);
22         c = a - b;
23     }
24     function mul(uint a, uint b) internal pure returns (uint c) {
25         c = a * b;
26         require(a == 0 || c / a == b);
27     }
28     function div(uint a, uint b) internal pure returns (uint c) {
29         require(b > 0);
30         c = a / b;
31     }
32 }
33 
34 
35 // ----------------------------------------------------------------------------
36 // ERC Token Standard #20 Interface
37 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
38 // ----------------------------------------------------------------------------
39 contract ERC20Interface {
40     function totalSupply() public view returns (uint);
41     function balanceOf(address tokenOwner) public view returns (uint balance);
42     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
43     function transfer(address to, uint _value) public returns (bool success);
44     function approve(address spender, uint _value) public returns (bool success);
45     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
46 
47     event Transfer(address indexed _from, address indexed _to, uint _value);
48     event Approval(address indexed tokenOwner, address indexed spender, uint _value);
49 }
50 
51 
52 // ----------------------------------------------------------------------------
53 // Contract function to receive approval and execute function in one call
54 //
55 // Borrowed from MiniMeToken
56 // ----------------------------------------------------------------------------
57 contract ApproveAndCallFallBack {
58     function receiveApproval(address _from, uint256 _value, address token, bytes memory data) public;
59 }
60 
61 
62 // ----------------------------------------------------------------------------
63 // Owned contract
64 // ----------------------------------------------------------------------------
65 contract Owned {
66     address public owner;
67     address public newOwner;
68 
69     event OwnershipTransferred(address indexed _from, address indexed _to);
70 
71     constructor() public {
72         owner = msg.sender;
73     }
74 
75     modifier onlyOwner {
76         require(msg.sender == owner);
77         _;
78     }
79 
80     function transferOwnership(address _newOwner) public onlyOwner {
81         newOwner = _newOwner;
82     }
83     function acceptOwnership() public {
84         require(msg.sender == newOwner);
85         emit OwnershipTransferred(owner, newOwner);
86         owner = newOwner;
87         newOwner = address(0);
88     }
89 }
90 
91 
92 // ----------------------------------------------------------------------------
93 // ERC20 Token, with the addition of symbol, name and decimals and a
94 // fixed supply
95 // ----------------------------------------------------------------------------
96 contract STONetwork is ERC20Interface, Owned {
97     using SafeMath for uint;
98 
99     string public symbol;
100     string public  name;
101     uint8 public decimals;
102     uint _initialTokenNumber;
103     uint _totalSupply;
104 
105     mapping(address => uint) balances;
106     mapping(address => mapping(address => uint)) allowed;
107 
108     uint exchangerToken;
109     uint reservedToken;
110     uint developedToken;
111     
112     address public constant developed1Address     = 0xcFCb491953Da1d10D037165dFa1298D00773fcA7;
113     address public constant developed2Address     = 0xA123BceDB9d2E4b09c8962C62924f091380E1Ad7;
114     address public constant developed3Address     = 0x51aeD4EDC28aad15C353D958c5A813aa21F351b6;
115     address public constant exchangedAddress     = 0x2630e8620d53C7f64f82DAEA50257E83297eE009;
116 
117     // ------------------------------------------------------------------------
118     // Constructor
119     // ------------------------------------------------------------------------
120     constructor() public {
121         symbol = "STON";
122         name = "STONetwork";
123         decimals = 18;
124         _initialTokenNumber = 1000000000;
125         _totalSupply = _initialTokenNumber * 10 ** uint(decimals);
126         
127         reservedToken = _totalSupply * 40 / 100;  // 40%
128         
129         developedToken = _totalSupply * 10 / 100; //30% 3 Address
130         
131         exchangerToken = _totalSupply * 30 / 100; // 30%
132 
133         balances[owner] = reservedToken;
134         emit Transfer(address(0), owner, reservedToken);
135 
136         balances[exchangedAddress] = exchangerToken;
137         emit Transfer(address(0), exchangedAddress, exchangerToken);
138         
139         balances[developed1Address] = developedToken;
140         emit Transfer(address(0), developed1Address, developedToken);
141         balances[developed2Address] = developedToken;
142         emit Transfer(address(0), developed2Address, developedToken);
143         balances[developed3Address] = developedToken;
144         emit Transfer(address(0), developed3Address, developedToken);
145         
146     }
147 
148 
149     // ------------------------------------------------------------------------
150     // Total supply
151     // ------------------------------------------------------------------------
152     function totalSupply() public view returns (uint) {
153         return _totalSupply;
154     }
155 
156 
157     // ------------------------------------------------------------------------
158     // Get the token balance for account `tokenOwner`
159     // ------------------------------------------------------------------------
160     function balanceOf(address _owner) public view returns (uint balance) {
161         return balances[_owner];
162     }
163 
164 
165     // ------------------------------------------------------------------------
166     // Transfer the balance from token owner's account to `to` account
167     // - Owner's account must have sufficient balance to transfer
168     // - 0 value transfers are allowed
169     // ------------------------------------------------------------------------
170     function transfer(address _to, uint _value) public returns (bool success) {
171         require(balances[msg.sender] >= _value);
172         require(_to != address(0));
173         balances[msg.sender] = balances[msg.sender].sub(_value);
174         balances[_to] = balances[_to].add(_value);
175         emit Transfer(msg.sender, _to, _value);
176         return true;
177     }
178 
179 
180     // ------------------------------------------------------------------------
181     // Token owner can approve for `spender` to transferFrom(...) `tokens`
182     // from the token owner's account
183     //
184     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
185     // recommends that there are no checks for the approval double-spend attack
186     // as this should be implemented in user interfaces
187     // ------------------------------------------------------------------------
188     function approve(address _spender, uint _value) public returns (bool success) {
189         require(_spender != address(0));
190         allowed[msg.sender][_spender] = _value;
191         emit Approval(msg.sender, _spender, _value);
192         return true;
193     }
194 
195 
196     // ------------------------------------------------------------------------
197     // Transfer `tokens` from the `from` account to the `to` account
198     //
199     // The calling account must already have sufficient tokens approve(...)-d
200     // for spending from the `from` account and
201     // - From account must have sufficient balance to transfer
202     // - Spender must have sufficient allowance to transfer
203     // - 0 value transfers are allowed
204     // ------------------------------------------------------------------------
205     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
206         require(_to != address(0)); 
207         require(balances[_from] >= _value);
208         require(allowed[_from][msg.sender] >= _value);
209         
210         balances[_from] = balances[_from].sub(_value);
211         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
212         balances[_to] = balances[_to].add(_value);
213         emit Transfer(_from, _to, _value);
214         return true;
215     }
216 
217 
218     // ------------------------------------------------------------------------
219     // Returns the amount of tokens approved by the owner that can be
220     // transferred to the spender's account
221     // ------------------------------------------------------------------------
222     function allowance(address _owner, address _spender) public view returns (uint remaining) {
223         return allowed[_owner][_spender];
224     }
225 
226 
227     // ------------------------------------------------------------------------
228     // Token owner can approve for `spender` to transferFrom(...) `tokens`
229     // from the token owner's account. The `spender` contract function
230     // `receiveApproval(...)` is then executed
231     // ------------------------------------------------------------------------
232     function approveAndCall(address _spender, uint _value, bytes memory data) public returns (bool success) {
233         allowed[msg.sender][_spender] = _value;
234         emit Approval(msg.sender, _spender, _value);
235         ApproveAndCallFallBack(_spender).receiveApproval(msg.sender, _value, address(this), data);
236         return true;
237     }
238 
239 
240     // ------------------------------------------------------------------------
241     // Don't accept ETH
242     // ------------------------------------------------------------------------
243     function () external payable {
244         revert();
245     }
246 
247 
248     // ------------------------------------------------------------------------
249     // Owner can transfer out any accidentally sent ERC20 tokens
250     // ------------------------------------------------------------------------
251     function transferAnyERC20Token(address _tokenAddress, uint _value) public onlyOwner returns (bool success) {
252         return ERC20Interface(_tokenAddress).transfer(owner, _value);
253     }
254 }