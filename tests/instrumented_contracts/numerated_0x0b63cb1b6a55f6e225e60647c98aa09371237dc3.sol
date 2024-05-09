1 pragma solidity ^0.4.18;
2 
3 // ---------------------------------------------------------------------------------------------------------------------------------------
4 //                                 ACLYD CENTRAL COMPANY IDENTITY (CCID) LISTING INDEX                                                   |
5 //      FULL NAME                             (CONTRACT ENTRY)              :         LISTED PUBLIC INFORMATION                          |                                |                             |
6 // Company Name                            (companyName)                    : Vinekross LLC                                              |
7 // Company Reg. Number                     (companyRegistrationgNum)        : No. L18958                                                 |
8 // Jurisdiction                            (companyJurisdiction)            : Saint Kitts and Nevis                                      |
9 // Type of Organization                    (companyType)                    : Limited Liability Company (LLC)                            |
10 // Listed Manager                          (companyManager)                 : Not Published                                              |
11 // Reg. Agent Name                         (companyRegisteredAgent)         : Morning Star Holdings Limited                              |
12 // Reg. Agent Address                      (companyRegisteredAgentAddress)  : Hunkins Waterfront Plaza, Ste 556, Main Street,            |
13 //                                                                          : Charlestown, Nevis                                         |
14 // Company Address                         (companyAddress)                 : Hunkins Waterfront Plaza, Ste 556, Main Street,            |
15 //                                                                          :  Charlestown, Nevis                                        |
16 // Company Official Website Domains        (companywebsites)                : Not Published                                              |
17 // CID Third Party Verification Wallet     (cidThirdPartyVerificationWallet): 0xC9Cd6d0801a51FdeF493E72155ba56e6B52f0E03                 |
18 // CID Token Symbol                        (cidtokensymbol)                 : KSScid                                                     |
19 // Total Number of CID tokens Issued       (totalCIDTokensIssued)           : 11                                                         |
20 // Central Company ID (CCID) Listing Wallet(ccidListingWallet)              : 0x893b9E12f0DA46C68607d69486afdECF709f2E6e                 |
21 //                                                                                                                                       |
22 // ---------------------------------------------------------------------------------------------------------------------------------------
23 // ---------------------------------------------------------------------------
24 //      ICO TOKEN DETAILS    :        TOKEN INFORMATION                      |
25 // ICO token Standard        :                                               |
26 // ICO token Symbol          :                                               |
27 // ICO Total Token Supply    :                                               |
28 // ICO token Contract Address:                                               |
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
77 // Borrowed from KSScid TOKEN
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
118 contract KSScidTOKEN is ERC20Interface, Owned, SafeMath {
119     /* Public variables of KSScidTOKEN */
120     string public companyName = "Vinekross LLC";
121     string public companyRegistrationgNum = "No. L18958";
122     string public companyJurisdiction =  "Saint Kitts and Nevis";
123     string public companyType  = "Limited Liability Company (LLC)";
124     string public companyManager = "Not Published";
125     string public companyRegisteredAgent = "Morning Star Holdings Limited";
126     string public companyRegisteredAgentAddress = "Hunkins Waterfront Plaza, Ste 556, Main Street, Charlestown, Nevis";
127     string public companyAddress = "Hunkins Waterfront Plaza, Ste 556, Main Street, Charlestown, Nevis";
128     string public companywebsites = "Not Published";
129     string public cidThirdPartyVerificationWallet = "0xc9cd6d0801a51fdef493e72155ba56e6b52f0e03";
130     string public cidTokenSymbol = "KSScid";
131     string public totalCIDTokensIssued = "11";
132     string public ccidListingWallet = "0x893b9E12f0DA46C68607d69486afdECF709f2E6e";
133     string public icoTokenStandard = "Not Published";
134     string public icoTokenSymbol = "Not Published";
135     string public icoTotalTokenSupply ="Not Published";
136     string public icoTokenContractAddress = "Not Published";
137     string public symbol = "KSScid";
138     string public name = "KSScid";
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
149     function KSScidTOKEN() public {
150         symbol = "KSScid";
151         name = "KSScid";
152         decimals = 0;
153         _totalSupply = 11;
154         balances[0xC9Cd6d0801a51FdeF493E72155ba56e6B52f0E03] = _totalSupply;
155         Transfer(address(0), 0xC9Cd6d0801a51FdeF493E72155ba56e6B52f0E03, _totalSupply);
156     }
157 
158     // ------------------------------------------------------------------------
159     // Total supply
160     // ------------------------------------------------------------------------
161     function cidTokenSupply() public constant returns (uint) {
162         return _totalSupply  - balances[address(0)];
163     }
164 
165 
166     // ------------------------------------------------------------------------
167     // Get the token balance for account tokenOwner
168     // ------------------------------------------------------------------------
169     function balanceOf(address tokenOwner) public constant returns (uint balance) {
170         return balances[tokenOwner];
171     }
172 
173 
174     // ------------------------------------------------------------------------
175     // Transfer the balance from token owner's account to  account
176     // - Owner's account must have sufficient balance to transfer
177     // - 0 value transfers are allowed
178     // ------------------------------------------------------------------------
179     function transfer(address to, uint tokens) public returns (bool success) {
180         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
181         balances[to] = safeAdd(balances[to], tokens);
182         Transfer(msg.sender, to, tokens);
183         return true;
184     }
185 
186 
187     // ------------------------------------------------------------------------
188     // Token owner can approve for spender to transferFrom(...) tokens
189     // from the token owner's account
190     //
191     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
192     // recommends that there are no checks for the approval double-spend attack
193     // as this should be implemented in user interfaces 
194     // ------------------------------------------------------------------------
195     function approve(address spender, uint tokens) public returns (bool success) {
196         allowed[msg.sender][spender] = tokens;
197         Approval(msg.sender, spender, tokens);
198         return true;
199     }
200 
201 
202     // ------------------------------------------------------------------------
203     // Transfer tokens from the from account to the to account
204     // 
205     // The calling account must already have sufficient tokens approve(...)-d
206     // for spending from the from account and
207     // - From account must have sufficient balance to transfer
208     // - Spender must have sufficient allowance to transfer
209     // - 0 value transfers are allowed
210     // ------------------------------------------------------------------------
211     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
212         balances[from] = safeSub(balances[from], tokens);
213         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
214         balances[to] = safeAdd(balances[to], tokens);
215         Transfer(from, to, tokens);
216         return true;
217     }
218 
219 
220     // ------------------------------------------------------------------------
221     // Returns the amount of tokens approved by the owner that can be
222     // transferred to the spender's account
223     // ------------------------------------------------------------------------
224     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
225         return allowed[tokenOwner][spender];
226     }
227 
228 
229     // ------------------------------------------------------------------------
230     // Token owner can approve for spender to transferFrom(...) tokens
231     // from the token owner's account. The spender contract function
232     // receiveApproval(...) is then executed
233     // ------------------------------------------------------------------------
234     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
235         allowed[msg.sender][spender] = tokens;
236         Approval(msg.sender, spender, tokens);
237         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
238         return true;
239     }
240 
241 
242     // ------------------------------------------------------------------------
243     // Don't accept ETH
244     // ------------------------------------------------------------------------
245     function () public payable {
246         revert();
247     }
248 
249 
250     // ------------------------------------------------------------------------
251     // Owner can transfer out any accidentally sent ERC20 tokens
252     // ------------------------------------------------------------------------
253     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
254         return ERC20Interface(tokenAddress).transfer(owner, tokens);
255     }
256 }