1 pragma solidity ^0.4.16;
2 
3 
4 
5 // ----------------------------------------------------------------------------
6 // Currency contract
7 // ----------------------------------------------------------------------------
8 contract ERC20Interface {
9     function totalSupply() public constant returns (uint);
10     function balanceOf(address tokenOwner) public constant returns (uint balance);
11     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
12     function transfer(address to, uint tokens) public returns (bool success);
13     function approve(address spender, uint tokens) public returns (bool success);
14     function transferFrom(address from, address to, uint tokens) public returns (bool success);
15 
16     event Transfer(address from, address to, uint tokens);
17     event Approval(address tokenOwner, address spender, uint tokens);
18 }
19 
20 // ----------------------------------------------------------------------------
21 // CNT Currency contract extended API
22 // ----------------------------------------------------------------------------
23 contract PRE_SALE_Token is ERC20Interface {
24     function ico_distribution(address to, uint tokens) public;
25     function init(address _sale) public;
26 }
27 
28 // ----------------------------------------------------------------------------
29 // NRB_Contract User Contract API
30 // ----------------------------------------------------------------------------
31 contract NRB_Contract {
32     function registerUserOnToken(address _token, address _user, uint _value, uint _flc, string _json) public returns (uint);
33 }
34 
35 
36 // ----------------------------------------------------------------------------
37 // contract WhiteListAccess
38 // ----------------------------------------------------------------------------
39 contract WhiteListAccess { 
40     
41     function WhiteListAccess() public {
42         owner = msg.sender;
43         whitelist[owner] = true;
44         whitelist[address(this)] = true;
45     }
46     
47     address public owner;
48     mapping (address => bool) whitelist;
49 
50     modifier onlyOwner {require(msg.sender == owner); _;}
51     modifier onlyWhitelisted {require(whitelist[msg.sender]); _;}
52 
53     function addToWhiteList(address trusted) public onlyOwner() {
54         whitelist[trusted] = true;
55     }
56 
57     function removeFromWhiteList(address untrusted) public onlyOwner() {
58         whitelist[untrusted] = false;
59     }
60 
61 }
62 // ----------------------------------------------------------------------------
63 // CNT_Common contract
64 // ----------------------------------------------------------------------------
65 contract CNT_Common is WhiteListAccess {
66     string  public name;
67     function CNT_Common() public { ETH_address = 0x1; }
68 
69     // Deployment
70     bool public _init;
71     address public ETH_address;    // representation of Ether as Token (0x1)
72     address public EOS_address;    // EOS Tokens
73     address public NRB_address;    // New Rich on The Block Contract
74     
75     address public CNT_address;    // Chip
76     address public BGB_address;    // BG Coin
77     address public VPE_address;    // Vapaee Token
78     address public GVPE_address;   // Golden Vapaee Token
79     
80 
81 }
82 
83 
84 // ----------------------------------------------------------------------------
85 // CNT_Crowdsale
86 // ----------------------------------------------------------------------------
87 contract CNT_Crowdsale is CNT_Common {
88 
89     uint public raised;
90     uint public remaining;
91     uint public cnt_per_eos;
92     uint public bgb_per_eos;
93     uint public vpe_per_eos;
94     uint public gvpe_per_eos;
95     mapping(address => uint) public paid;
96 
97     event Sale(address from, uint eos_tokens, address to, uint cnt_tokens, uint mana_tokens, uint vpe_tokens, uint gvpe_tokens);
98     // --------------------------------------------------------------------------------
99 
100     function CNT_Crowdsale() public {
101         cnt_per_eos = 300;
102         bgb_per_eos = 300;
103         vpe_per_eos = 100;
104         gvpe_per_eos = 1;
105         name = "CNT_Crowdsale";
106         remaining = 1000000 * 10**18; // 1 million
107     }
108 
109     function init(address _eos, address _cnt, address _bgb, address _vpe, address _gvpe, address _nrb) public {
110         require(!_init);
111         EOS_address = _eos;
112         CNT_address = _cnt;
113         BGB_address = _bgb;
114         VPE_address = _vpe;
115         GVPE_address = _gvpe;
116         NRB_address = _nrb;
117         PRE_SALE_Token(CNT_address).init(address(this));
118         PRE_SALE_Token(BGB_address).init(address(this));
119         PRE_SALE_Token(VPE_address).init(address(this));
120         PRE_SALE_Token(GVPE_address).init(address(this));
121         _init = true;
122     }
123 
124     function isInit() constant public returns (bool) {
125         return _init;
126     }
127 
128     function calculateTokens(uint _eos_amount) constant public returns (uint, uint, uint, uint) {
129         return (
130             _eos_amount * cnt_per_eos,
131             _eos_amount * bgb_per_eos,
132             _eos_amount * vpe_per_eos,
133             _eos_amount * gvpe_per_eos
134         );
135     }
136 
137     function buy(uint _eos_amount) public {
138         // calculate how much of each token must be sent
139         require(remaining >= _eos_amount);
140 
141         uint cnt_amount  = 0;
142         uint bgb_amount = 0;
143         uint vpe_amount  = 0;
144         uint gvpe_amount = 0;
145 
146         (cnt_amount, bgb_amount, vpe_amount, gvpe_amount) = calculateTokens(_eos_amount);
147 
148         // send the tokens
149         PRE_SALE_Token(CNT_address) .ico_distribution(msg.sender, cnt_amount);
150         PRE_SALE_Token(BGB_address) .ico_distribution(msg.sender, bgb_amount);
151         PRE_SALE_Token(VPE_address) .ico_distribution(msg.sender, vpe_amount);
152         PRE_SALE_Token(GVPE_address).ico_distribution(msg.sender, gvpe_amount);
153 
154         // registro la compra
155         Sale(address(this), _eos_amount, msg.sender, cnt_amount, bgb_amount, vpe_amount, gvpe_amount);
156         paid[msg.sender] = paid[msg.sender] + _eos_amount;
157 
158         // envío los eos al owner
159         ERC20Interface(EOS_address).transferFrom(msg.sender, owner, _eos_amount);
160 
161         raised = raised + _eos_amount;
162         remaining = remaining - _eos_amount;
163     }
164 
165     function registerUserOnToken(string _json) public {
166         NRB_Contract(CNT_address).registerUserOnToken(EOS_address, msg.sender, paid[msg.sender], 0, _json);
167     }
168 
169     function finishPresale() public onlyOwner() {
170         uint cnt_amount  = 0;
171         uint bgb_amount = 0;
172         uint vpe_amount  = 0;
173         uint gvpe_amount = 0;
174 
175         (cnt_amount, bgb_amount, vpe_amount, gvpe_amount) = calculateTokens(remaining);
176 
177         // send the tokens
178         PRE_SALE_Token(CNT_address) .ico_distribution(owner, cnt_amount);
179         PRE_SALE_Token(BGB_address) .ico_distribution(owner, bgb_amount);
180         PRE_SALE_Token(VPE_address) .ico_distribution(owner, vpe_amount);
181         PRE_SALE_Token(GVPE_address).ico_distribution(owner, gvpe_amount);
182 
183         // registro la compra
184         Sale(address(this), remaining, owner, cnt_amount, bgb_amount, vpe_amount, gvpe_amount);
185         paid[owner] = paid[owner] + remaining;
186 
187         raised = raised + remaining;
188         remaining = 0;        
189     }
190 
191     // ------------------------------------------------------------------------
192     // Don't accept ETH
193     // ------------------------------------------------------------------------
194     function () public payable {
195         revert();
196     }
197 
198     // ------------------------------------------------------------------------
199     // Owner can transfer out any accidentally sent ERC20 tokens
200     // ------------------------------------------------------------------------
201     function transferAnyERC20Token(address tokenAddress, uint tokens) public returns (bool success) {
202         return ERC20Interface(tokenAddress).transfer(owner, tokens);
203     }
204 
205 
206 }