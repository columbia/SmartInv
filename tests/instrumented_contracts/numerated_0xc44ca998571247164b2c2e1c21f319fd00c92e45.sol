1 pragma solidity ^0.4.18;
2 
3 // ---------------------------------------------------------------------------------------------------------------------------------------
4 //                                 ACLYD CENTRAL COMPANY IDENTITY (CCID) LISTING INDEX                                                   |
5 //      FULL NAME                             (CONTRACT ENTRY)              :         LISTED PUBLIC INFORMATION                          |                                |                             |
6 // Company Name                            (companyName)                    : The Aclyd Project LTD.                                     |
7 // Company Reg. Number                     (companyRegistrationgNum)        : No. 202470 B                                               |
8 // Jurisdiction                            (companyJurisdiction)            : Nassau, Island of New Providence, Common Wealth of Bahamas |
9 // Type of Organization                    (companyType)                    : International Business Company                             |
10 // Listed Manager                          (companyManager)                 : The Aclyd Group, Inc., Wyoming, USA                        |
11 // Reg. Agent Name                         (companyRegisteredAgent)         : KLA CORPORATE SERVICES LTD.                                |
12 // Reg. Agent Address                      (companyRegisteredAgentAddress)  : 48 Village Road (North) Nassau, New Providence, The Bahamas|
13 //                                                                          : P.O Box N-3747                                             |
14 // Company Address                         (companyAddress)                 : 48 Village Road (North) Nassau, New Providence, The Bahamas|
15 //                                                                          : P.O Box N-3747                                             |
16 // Company Official Website Domains        (companywebsites)                : https://aclyd.com | https://aclyd.io | https://aclydex.com |
17 // CID Third Party Verification Wallet     (cidThirdPartyVerificationWallet): 0x2bea96F65407cF8ed5CEEB804001837dBCDF8b23                 |
18 // CID Token Symbol                        (cidtokensymbol)                 : ACLYDcid                                                   |
19 // Total Number of CID tokens Issued       (totalCIDTokensIssued)           : 11                                                         |
20 // Central Company ID (CCID) Listing Wallet(ccidListingWallet)              : 0x893b9E12f0DA46C68607d69486afdECF709f2E6e                 |
21 //                                                                                                                                       |
22 // ---------------------------------------------------------------------------------------------------------------------------------------
23 // ---------------------------------------------------------------------------
24 //      ICO TOKEN DETAILS    :        TOKEN INFORMATION                      |
25 // ICO token Standard        : ERC20                                         |
26 // ICO token Symbol          : ACLYD                                         |
27 // ICO Total Token Supply    : 750,000,000                                   |
28 // ICO token Contract Address: 0x34B4af7C75342f01c072FA780443575BE5E20df1    |
29 //                                                                           |
30 // (c) by The ACLYD PROJECT'S CENTRAL COMPANY INDENTIY (CCID) LISTING INDEX  |  
31 // ---------------------------------------------------------------------------
32 
33 
34 // ----------------------------------------------------------------------------
35 // Safe maths
36 // ----------------------------------------------------------------------------
37 contract SafeMath {
38     function safeAdd(uint a, uint b) public pure returns (uint c) {
39         c = a + b;
40         require(c >= a);
41     }
42     function safeSub(uint a, uint b) public pure returns (uint c) {
43         require(b <= a);
44         c = a - b;
45     }
46     function safeMul(uint a, uint b) public pure returns (uint c) {
47         c = a * b;
48         require(a == 0 || c / a == b);
49     }
50     function safeDiv(uint a, uint b) public pure returns (uint c) {
51         require(b > 0);
52         c = a / b;
53     }
54 }
55 
56 
57 // ----------------------------------------------------------------------------
58 // ERC Token Standard #20 Interface
59 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
60 // ----------------------------------------------------------------------------
61 contract ERC20Interface {
62     function cidTokenSupply() public constant returns (uint);
63     function balanceOf(address tokenOwner) public constant returns (uint balance);
64     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
65     function transfer(address to, uint tokens) public returns (bool success);
66     function approve(address spender, uint tokens) public returns (bool success);
67     function transferFrom(address from, address to, uint tokens) public returns (bool success);
68 
69     event Transfer(address indexed from, address indexed to, uint tokens);
70     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
71 }
72 
73 
74 // ----------------------------------------------------------------------------
75 // Contract function to receive approval and execute function in one call
76 //
77 // Borrowed from ACLYDcid TOKEN
78 // ----------------------------------------------------------------------------
79 contract ApproveAndCallFallBack {
80     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
81 }
82 
83 
84 // ----------------------------------------------------------------------------
85 // Owned contract
86 // ----------------------------------------------------------------------------
87 contract Owned {
88     address public owner;
89     address public newOwner;
90 
91     event OwnershipTransferred(address indexed _from, address indexed _to);
92 
93     function Owned() public {
94         owner = msg.sender;
95     }
96 
97     modifier onlyOwner {
98         require(msg.sender == owner);
99         _;
100     }
101 
102     function transferOwnership(address _newOwner) public onlyOwner {
103         newOwner = _newOwner;
104     }
105     function acceptOwnership() public {
106         require(msg.sender == newOwner);
107         OwnershipTransferred(owner, newOwner);
108         owner = newOwner;
109         newOwner = address(0);
110     }
111 }
112 
113 
114 // ----------------------------------------------------------------------------
115 // ERC20 Token, with the addition of symbol, name and decimals and assisted
116 // token transfers
117 // ----------------------------------------------------------------------------
118 contract ACLYDcidTOKEN is ERC20Interface, Owned, SafeMath {
119     /* Public variables of the TheAclydProject */
120     string public companyName = "The Aclyd Project LTD.";
121     string public companyRegistrationgNum = "No. 202470 B";
122     string public companyJurisdiction =  "Nassau, Island of New Providence, Common Wealth of Bahamas";
123     string public companyType  = "International Business Company";
124     string public companyManager = "The Aclyd Group Inc., Wyoming, USA";
125     string public companyRegisteredAgent = "KLA CORPORATE SERVICES LTD.";
126     string public companyRegisteredAgentAddress = "48 Village Road (North) Nassau, New Providence, The Bahamas, P.O Box N-3747";
127     string public companyAddress = "48 Village Road (North) Nassau, New Providence, The Bahamas, P.O Box N-3747";
128     string public companywebsites = "https://aclyd.com | https://aclyd.io | https://aclydex.com";
129     string public cidThirdPartyVerificationWallet = "0x2bea96F65407cF8ed5CEEB804001837dBCDF8b23";
130     string public cidTokenSymbol = "ACLYDcid";
131     string public totalCIDTokensIssued = "11";
132     string public ccidListingWallet = "0x893b9E12f0DA46C68607d69486afdECF709f2E6e";
133     string public icoTokenStandard = "ERC20";
134     string public icoTokenSymbol = "ACLYD";
135     string public icoTotalTokenSupply ="750,000,000";
136     string public icoTokenContractAddress = "0x34B4af7C75342f01c072FA780443575BE5E20df1";
137     string public symbol = "ACLYDcid";
138     string public name = "ACLYDcid";
139     uint8 public decimals;
140     uint public _totalSupply = 11;
141 
142     mapping(address => uint) balances;
143     mapping(address => mapping(address => uint)) allowed;
144 
145 
146     // ------------------------------------------------------------------------
147     // Constructor
148     // ------------------------------------------------------------------------
149     function ACLYDcidTOKEN() public {
150         symbol = "ACLYDcid";
151         name = "ACLYDcid";
152         decimals = 0;
153         _totalSupply = 11;
154         balances[0x2bea96F65407cF8ed5CEEB804001837dBCDF8b23] = _totalSupply;
155         Transfer(address(0), 0x2bea96F65407cF8ed5CEEB804001837dBCDF8b23, _totalSupply);
156     }
157 
158 
159     // ------------------------------------------------------------------------
160     // Total supply
161     // ------------------------------------------------------------------------
162     function cidTokenSupply() public constant returns (uint) {
163         return _totalSupply  - balances[address(0)];
164     }
165 
166 
167     // ------------------------------------------------------------------------
168     // Get the token balance for account tokenOwner
169     // ------------------------------------------------------------------------
170     function balanceOf(address tokenOwner) public constant returns (uint balance) {
171         return balances[tokenOwner];
172     }
173 
174 
175     // ------------------------------------------------------------------------
176     // Transfer the balance from token owner's account to  account
177     // - Owner's account must have sufficient balance to transfer
178     // - 0 value transfers are allowed
179     // ------------------------------------------------------------------------
180     function transfer(address to, uint tokens) public returns (bool success) {
181         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
182         balances[to] = safeAdd(balances[to], tokens);
183         Transfer(msg.sender, to, tokens);
184         return true;
185     }
186 
187 
188     // ------------------------------------------------------------------------
189     // Token owner can approve for spender to transferFrom(...) tokens
190     // from the token owner's account
191     //
192     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
193     // recommends that there are no checks for the approval double-spend attack
194     // as this should be implemented in user interfaces 
195     // ------------------------------------------------------------------------
196     function approve(address spender, uint tokens) public returns (bool success) {
197         allowed[msg.sender][spender] = tokens;
198         Approval(msg.sender, spender, tokens);
199         return true;
200     }
201 
202 
203     // ------------------------------------------------------------------------
204     // Transfer tokens from the from account to the to account
205     // 
206     // The calling account must already have sufficient tokens approve(...)-d
207     // for spending from the from account and
208     // - From account must have sufficient balance to transfer
209     // - Spender must have sufficient allowance to transfer
210     // - 0 value transfers are allowed
211     // ------------------------------------------------------------------------
212     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
213         balances[from] = safeSub(balances[from], tokens);
214         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
215         balances[to] = safeAdd(balances[to], tokens);
216         Transfer(from, to, tokens);
217         return true;
218     }
219 
220 
221     // ------------------------------------------------------------------------
222     // Returns the amount of tokens approved by the owner that can be
223     // transferred to the spender's account
224     // ------------------------------------------------------------------------
225     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
226         return allowed[tokenOwner][spender];
227     }
228 
229 
230     // ------------------------------------------------------------------------
231     // Token owner can approve for spender to transferFrom(...) tokens
232     // from the token owner's account. The spender contract function
233     // receiveApproval(...) is then executed
234     // ------------------------------------------------------------------------
235     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
236         allowed[msg.sender][spender] = tokens;
237         Approval(msg.sender, spender, tokens);
238         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
239         return true;
240     }
241 
242 
243     // ------------------------------------------------------------------------
244     // Don't accept ETH
245     // ------------------------------------------------------------------------
246     function () public payable {
247         revert();
248     }
249 
250 
251     // ------------------------------------------------------------------------
252     // Owner can transfer out any accidentally sent ERC20 tokens
253     // ------------------------------------------------------------------------
254     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
255         return ERC20Interface(tokenAddress).transfer(owner, tokens);
256     }
257 }