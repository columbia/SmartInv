1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 //    /######            /#######  /##          
5 //   /##__  ##          | ##__  ##|__/          
6 //  | ##  \ ## /##   /##| ##  \ ## /##  /###### 
7 //  | ##  | ##|  ## /##/| ####### | ## /##__  ##
8 //  | ##  | ## \  ####/ | ##__  ##| ##| ##  \ ##
9 //  | ##  | ##  >##  ## | ##  \ ##| ##| ##  | ##
10 //  |  ######/ /##/\  ##| #######/| ##|  ######/
11 //   \______/ |__/  \__/|_______/ |__/ \______/ 
12 //                                              
13 // 
14 // Deployed to contract : 0x0c259e7c073c81188917c700a179818f18c5d6f8
15 // Symbol               : OXB
16 // Name                 : OxBio
17 // Total supply         : 500000000 of which 200M available.
18 // Decimals             : 18
19 //
20 // ----------------------------------------------------------------------------
21 
22 
23 // ----------------------------------------------------------------------------
24 // Safe maths
25 // ----------------------------------------------------------------------------
26 library SafeMath {
27     function add(uint a, uint b) internal pure returns (uint c) {
28         c = a + b;
29         require(c >= a);
30     }
31     function sub(uint a, uint b) internal pure returns (uint c) {
32         require(b <= a);
33         c = a - b;
34     }
35     function mul(uint a, uint b) internal pure returns (uint c) {
36         c = a * b;
37         require(a == 0 || c / a == b);
38     }
39     function div(uint a, uint b) internal pure returns (uint c) {
40         require(b > 0);
41         c = a / b;
42     }
43 }
44 
45 // ----------------------------------------------------------------------------
46 // ERC Token Standard #20 Interface
47 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
48 // ----------------------------------------------------------------------------
49 contract ERC20Interface {
50     function totalSupply() public constant returns (uint);
51     function balanceOf(address tokenOwner) public constant returns (uint balance);
52     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
53     function transfer(address to, uint tokens) public returns (bool success);
54     function approve(address spender, uint tokens) public returns (bool success);
55     function transferFrom(address from, address to, uint tokens) public returns (bool success);
56 
57     event Transfer(address indexed from, address indexed to, uint tokens);
58     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
59 }
60 
61 // ----------------------------------------------------------------------------
62 // Contract function to receive approval and execute function in one call
63 // ----------------------------------------------------------------------------
64 contract ApproveAndCallFallBack {
65     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
66 }
67 
68 // ----------------------------------------------------------------------------
69 // Owned contract
70 // ----------------------------------------------------------------------------
71 contract Owned {
72     address public owner;
73     address public newOwner;
74 
75     event OwnershipTransferred(address indexed _from, address indexed _to);
76 
77     function Owned() public {
78         owner = msg.sender;
79     }
80 
81     modifier onlyOwner {
82         require(msg.sender == owner);
83         _;
84     }
85 
86     function transferOwnership(address _newOwner) public onlyOwner {
87         newOwner = _newOwner;
88     }
89     
90     function acceptOwnership() public {
91         require(msg.sender == newOwner);
92         OwnershipTransferred(owner, newOwner);
93         owner = newOwner;
94         newOwner = address(0);
95     }
96 }
97 
98 // ----------------------------------------------------------------------------
99 // ERC20 compliant token, with the addition of symbol, name and decimals and an
100 // initial fixed supply
101 // ----------------------------------------------------------------------------
102 contract OxBioToken is ERC20Interface, Owned {
103     using SafeMath for uint;
104 
105     string  public symbol;
106     string  public  name;
107     uint8   public decimals;
108     uint256 public _totalSupply;
109     uint256 public USDETH;                                 // price of 1 ether in USD
110     
111     mapping(address => uint) balances;
112     mapping(address => mapping(address => uint)) allowed;
113 
114     // ------------------------------------------------------------------------
115     // Constructor
116     // ------------------------------------------------------------------------
117     function OxBioToken() public {
118       
119         symbol = "OXB";
120         name = "OxBio";
121         decimals = 18;
122         USDETH = 530;                                      // 1 ETH = USD 530 
123 
124         _totalSupply = 500000000 * 10**uint(decimals);     // 200M out of 500M 
125         balances[owner] = _totalSupply;
126         Transfer(address(0), owner, _totalSupply);
127     }
128 
129     // ------------------------------------------------------------------------
130     // Total supply
131     // ------------------------------------------------------------------------
132     function totalSupply() public constant returns (uint) {
133         return _totalSupply  - balances[address(0)];
134     }
135 
136     // ------------------------------------------------------------------------
137     // Get the token balance for account `tokenOwner`
138     // ------------------------------------------------------------------------
139     function balanceOf(address tokenOwner) public constant returns (uint balance) {
140         return balances[tokenOwner];
141     }
142 
143     // ------------------------------------------------------------------------
144     // Transfer the balance from token owner's account to `to` account
145     // - Owner's account must have sufficient balance to transfer
146     // - 0 value transfers are allowed
147     // - prevent sending tokens to contracts
148     // - max transaction size: 1M 
149     // ------------------------------------------------------------------------
150     function transfer(address to, uint tokens) public returns (bool success) {
151         require( to != address(0) );
152         require( tokens <= balances[msg.sender] );
153         require( tokens <= 1000000 * 10**18 );
154         require( !isContract(to) );                                   
155         
156         balances[msg.sender] = balances[msg.sender].sub(tokens);
157         balances[to] = balances[to].add(tokens);
158         Transfer(msg.sender, to, tokens);
159         return true;
160     }
161 
162     // ------------------------------------------------------------------------
163     // Token owner can approve for `spender` to transferFrom(...) `tokens`
164     // from the token owner's account
165     //
166     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
167     // recommends that there are no checks for the approval double-spend attack
168     // as this should be implemented in user interfaces 
169     // ------------------------------------------------------------------------
170     function approve(address spender, uint tokens) public returns (bool success) {
171         allowed[msg.sender][spender] = tokens;
172         Approval(msg.sender, spender, tokens);
173         return true;
174     }
175 
176     // ------------------------------------------------------------------------
177     // Transfer `tokens` from the `from` account to the `to` account
178     // 
179     // The calling account must already have sufficient tokens approve(...)-d
180     // for spending from the `from` account and
181     // - From account must have sufficient balance to transfer
182     // - Spender must have sufficient allowance to transfer
183     // - 0 value transfers are allowed
184     // ------------------------------------------------------------------------
185     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
186         balances[from] = balances[from].sub(tokens);
187         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
188         balances[to] = balances[to].add(tokens);
189         Transfer(from, to, tokens);
190         return true;
191     }
192 
193     // ------------------------------------------------------------------------
194     // Returns the amount of tokens approved by the owner that can be
195     // transferred to the spender's account
196     // ------------------------------------------------------------------------
197     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
198         return allowed[tokenOwner][spender];
199     }
200 
201     // ------------------------------------------------------------------------
202     // Token owner can approve for `spender` to transferFrom(...) `tokens`
203     // from the token owner's account. The `spender` contract function
204     // `receiveApproval(...)` is then executed
205     // ------------------------------------------------------------------------
206     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
207         allowed[msg.sender][spender] = tokens;
208         Approval(msg.sender, spender, tokens);
209         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
210         return true;
211     }
212 
213     // ------------------------------------------------------------------------
214     // Accept ETH and convert this into OxBio tokens at a ETH:OxBio respectively 1:XXXX ratio (not in this version of the contract)
215     // ------------------------------------------------------------------------
216     function () public payable {
217         revert();
218     }
219 
220     // ------------------------------------------------------------------------
221     // Owner can transfer out any accidentally sent ERC20 tokens
222     // ------------------------------------------------------------------------
223     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
224         return ERC20Interface(tokenAddress).transfer(owner, tokens);
225     }
226     
227     // ------------------------------------------------------------------------
228     // Owner can change the USDETH rate
229     // ------------------------------------------------------------------------
230     function updateUSDETH(uint256 _USDETH) public onlyOwner {
231       require(_USDETH > 0);
232       USDETH = _USDETH;
233     }
234     
235     // ------------------------------------------------------------------------
236     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
237     // ------------------------------------------------------------------------
238     function isContract(address _addr) private view returns (bool is_contract) {
239       uint length;
240       assembly {
241             //retrieve the size of the code on target address, this needs assembly
242             length := extcodesize(_addr)
243       }
244       return (length>0);
245     }    
246 }