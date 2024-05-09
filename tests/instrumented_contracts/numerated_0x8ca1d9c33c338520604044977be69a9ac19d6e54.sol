1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'PREVE' 'Presale EVE Tokens' token contract
5 //
6 // Deployed to : {TBA}
7 // Symbol      : PREVE
8 // Name        : Presale EVE Tokens
9 // Total supply: Minted
10 // Decimals    : 18
11 //
12 // Enjoy.
13 //
14 // (c) BokkyPooBah / Bok Consulting Pty Ltd for Devery 2017. The MIT Licence.
15 // ----------------------------------------------------------------------------
16 
17 
18 // ----------------------------------------------------------------------------
19 // Devery Presale Whitelist Interface
20 // ----------------------------------------------------------------------------
21 contract DeveryPresaleWhitelist {
22     mapping(address => uint) public whitelist;
23 }
24 
25 
26 // ----------------------------------------------------------------------------
27 // Parity PICOPS Whitelist Interface
28 // ----------------------------------------------------------------------------
29 contract PICOPSCertifier {
30     function certified(address) public constant returns (bool);
31 }
32 
33 
34 // ----------------------------------------------------------------------------
35 // Safe maths
36 // ----------------------------------------------------------------------------
37 library SafeMath {
38     function add(uint a, uint b) internal pure returns (uint c) {
39         c = a + b;
40         require(c >= a);
41     }
42     function sub(uint a, uint b) internal pure returns (uint c) {
43         require(b <= a);
44         c = a - b;
45     }
46     function mul(uint a, uint b) internal pure returns (uint c) {
47         c = a * b;
48         require(a == 0 || c / a == b);
49     }
50     function div(uint a, uint b) internal pure returns (uint c) {
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
62     function totalSupply() public constant returns (uint);
63     function balanceOf(address tokenOwner) public constant returns (uint balance);
64     function transfer(address to, uint tokens) public returns (bool success);
65     function approve(address spender, uint tokens) public returns (bool success);
66     function transferFrom(address from, address to, uint tokens) public returns (bool success);
67 
68     event Transfer(address indexed from, address indexed to, uint tokens);
69     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
70 }
71 
72 
73 // ----------------------------------------------------------------------------
74 // Owned contract
75 // ----------------------------------------------------------------------------
76 contract Owned {
77     address public owner;
78     address public newOwner;
79 
80     event OwnershipTransferred(address indexed _from, address indexed _to);
81 
82     modifier onlyOwner {
83         require(msg.sender == owner);
84         _;
85     }
86 
87     function Owned() public {
88         owner = msg.sender;
89     }
90     function transferOwnership(address _newOwner) public onlyOwner {
91         newOwner = _newOwner;
92     }
93     function acceptOwnership() public {
94         require(msg.sender == newOwner);
95         OwnershipTransferred(owner, newOwner);
96         owner = newOwner;
97         newOwner = address(0);
98     }
99 }
100 
101 
102 // ----------------------------------------------------------------------------
103 // ERC20 Token, with the addition of symbol, name and decimals, minting and
104 // transferable flag. See:
105 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
106 // ----------------------------------------------------------------------------
107 contract ERC20Token is ERC20Interface, Owned {
108     using SafeMath for uint;
109 
110     string public symbol;
111     string public  name;
112     uint8 public decimals;
113     uint public _totalSupply;
114 
115     bool public transferable;
116     bool public mintable = true;
117 
118     mapping(address => uint) balances;
119     mapping(address => mapping(address => uint)) allowed;
120 
121     event MintingDisabled();
122     event TransfersEnabled();
123 
124     function ERC20Token(string _symbol, string _name, uint8 _decimals) public {
125         symbol = _symbol;
126         name = _name;
127         decimals = _decimals;
128     }
129 
130     // --- ERC20 standard functions ---
131     function totalSupply() public constant returns (uint) {
132         return _totalSupply  - balances[address(0)];
133     }
134     function balanceOf(address tokenOwner) public constant returns (uint balance) {
135         return balances[tokenOwner];
136     }
137     function transfer(address to, uint tokens) public returns (bool success) {
138         require(transferable);
139         balances[msg.sender] = balances[msg.sender].sub(tokens);
140         balances[to] = balances[to].add(tokens);
141         Transfer(msg.sender, to, tokens);
142         return true;
143     }
144     function approve(address spender, uint tokens) public returns (bool success) {
145         require(transferable);
146         allowed[msg.sender][spender] = tokens;
147         Approval(msg.sender, spender, tokens);
148         return true;
149     }
150     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
151         require(transferable);
152         balances[from] = balances[from].sub(tokens);
153         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
154         balances[to] = balances[to].add(tokens);
155         Transfer(from, to, tokens);
156         return true;
157     }
158     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
159         return allowed[tokenOwner][spender];
160     }
161 
162     // --- Additions over ERC20 ---
163     function disableMinting() internal {
164         require(mintable);
165         mintable = false;
166         MintingDisabled();
167     }
168     function enableTransfers() public onlyOwner {
169         require(!transferable);
170         transferable = true;
171         TransfersEnabled();
172     }
173     function mint(address tokenOwner, uint tokens) internal {
174         require(mintable);
175         balances[tokenOwner] = balances[tokenOwner].add(tokens);
176         _totalSupply = _totalSupply.add(tokens);
177         Transfer(address(0), tokenOwner, tokens);
178     }
179     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
180         return ERC20Interface(tokenAddress).transfer(owner, tokens);
181     }
182 }
183 
184 
185 // ----------------------------------------------------------------------------
186 // Devery Presale Token Contract
187 // ----------------------------------------------------------------------------
188 contract DeveryPresale is ERC20Token {
189     address public wallet;
190     // 9:00pm, 14 December GMT-5 => 02:00 15 December UTC => 13:00 15 December AEST => 1513303200
191     // new Date(1513303200 * 1000).toUTCString() =>  "Fri, 15 Dec 2017 02:00:00 UTC"
192     uint public constant START_DATE = 1513303200;
193     bool public closed;
194     uint public ethMinContribution = 20 ether;
195     uint public constant TEST_CONTRIBUTION = 0.01 ether;
196     uint public usdCap = 2000000;
197     // ETH/USD 14 Dec 2017 ~ 16:40 AEST => 730 from CMC
198     uint public usdPerKEther = 730000;
199     uint public contributedEth;
200     uint public contributedUsd;
201     DeveryPresaleWhitelist public whitelist;
202     PICOPSCertifier public picopsCertifier;
203 
204     event WalletUpdated(address indexed oldWallet, address indexed newWallet);
205     event EthMinContributionUpdated(uint oldEthMinContribution, uint newEthMinContribution);
206     event UsdCapUpdated(uint oldUsdCap, uint newUsdCap);
207     event UsdPerKEtherUpdated(uint oldUsdPerKEther, uint newUsdPerKEther);
208     event WhitelistUpdated(address indexed oldWhitelist, address indexed newWhitelist);
209     event PICOPSCertifierUpdated(address indexed oldPICOPSCertifier, address indexed newPICOPSCertifier);
210     event Contributed(address indexed addr, uint ethAmount, uint ethRefund, uint usdAmount, uint contributedEth, uint contributedUsd);
211 
212     function DeveryPresale() public ERC20Token("PREVE", "Presale EVE Tokens", 18) {
213         wallet = owner;
214     }
215     function setWallet(address _wallet) public onlyOwner {
216         // require(now <= START_DATE);
217         WalletUpdated(wallet, _wallet);
218         wallet = _wallet;
219     } 
220     function setEthMinContribution(uint _ethMinContribution) public onlyOwner {
221         // require(now <= START_DATE);
222         EthMinContributionUpdated(ethMinContribution, _ethMinContribution);
223         ethMinContribution = _ethMinContribution;
224     } 
225     function setUsdCap(uint _usdCap) public onlyOwner {
226         // require(now <= START_DATE);
227         UsdCapUpdated(usdCap, _usdCap);
228         usdCap = _usdCap;
229     } 
230     function setUsdPerKEther(uint _usdPerKEther) public onlyOwner {
231         // require(now <= START_DATE);
232         UsdPerKEtherUpdated(usdPerKEther, _usdPerKEther);
233         usdPerKEther = _usdPerKEther;
234     }
235     function setWhitelist(address _whitelist) public onlyOwner {
236         // require(now <= START_DATE);
237         WhitelistUpdated(address(whitelist), _whitelist);
238         whitelist = DeveryPresaleWhitelist(_whitelist);
239     }
240     function setPICOPSCertifier(address _picopsCertifier) public onlyOwner {
241         // require(now <= START_DATE);
242         PICOPSCertifierUpdated(address(picopsCertifier), _picopsCertifier);
243         picopsCertifier = PICOPSCertifier(_picopsCertifier);
244     }
245     function addressCanContribute(address _addr) public view returns (bool) {
246         return whitelist.whitelist(_addr) > 0 || picopsCertifier.certified(_addr);
247     }
248     function ethCap() public view returns (uint) {
249         return usdCap * 10**uint(3 + 18) / usdPerKEther;
250     }
251     function closeSale() public onlyOwner {
252         require(!closed);
253         closed = true;
254         disableMinting();
255     }
256     function () public payable {
257         require(now >= START_DATE || (msg.sender == owner && msg.value == TEST_CONTRIBUTION));
258         require(!closed);
259         require(addressCanContribute(msg.sender));
260         require(msg.value >= ethMinContribution || (msg.sender == owner && msg.value == TEST_CONTRIBUTION));
261         uint ethAmount = msg.value;
262         uint ethRefund = 0;
263         if (contributedEth.add(ethAmount) > ethCap()) {
264             ethAmount = ethCap().sub(contributedEth);
265             ethRefund = msg.value.sub(ethAmount);
266         }
267         require(ethAmount > 0);
268         uint usdAmount = ethAmount * usdPerKEther / 10**uint(3 + 18);
269         contributedEth = contributedEth.add(ethAmount);
270         contributedUsd = contributedUsd.add(usdAmount);
271         mint(msg.sender, ethAmount);
272         wallet.transfer(ethAmount);
273         Contributed(msg.sender, ethAmount, ethRefund, usdAmount, contributedEth, contributedUsd);
274         if (ethRefund > 0) {
275             msg.sender.transfer(ethRefund);
276         }
277     }
278 }