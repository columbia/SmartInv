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
25     function ico_promo_reward(address to, uint tokens) public;
26     function init(address _sale) public;
27 }
28 
29 // ----------------------------------------------------------------------------
30 // NRB_Contract User Contract API
31 // ----------------------------------------------------------------------------
32 contract NRB_Contract {
33     function registerUserOnToken(address _token, address _user, uint _value, uint _flc, string _json) public returns (uint);
34 }
35 
36 
37 // ----------------------------------------------------------------------------
38 // contract WhiteListAccess
39 // ----------------------------------------------------------------------------
40 contract WhiteListAccess { 
41     
42     function WhiteListAccess() public {
43         owner = msg.sender;
44         whitelist[owner] = true;
45         whitelist[address(this)] = true;
46     }
47     
48     address public owner;
49     mapping (address => bool) whitelist;
50 
51     modifier onlyOwner {require(msg.sender == owner); _;}
52     modifier onlyWhitelisted {require(whitelist[msg.sender]); _;}
53 
54     function addToWhiteList(address trusted) public onlyOwner() {
55         whitelist[trusted] = true;
56     }
57 
58     function removeFromWhiteList(address untrusted) public onlyOwner() {
59         whitelist[untrusted] = false;
60     }
61 
62 }
63 // ----------------------------------------------------------------------------
64 // CNT_Common contract
65 // ----------------------------------------------------------------------------
66 contract CNT_Common is WhiteListAccess {
67     string  public name;
68     function CNT_Common() public { ETH_address = 0x1; }
69 
70     // Deployment
71     bool public initialized;
72     address public ETH_address;    // representation of Ether as Token (0x1)
73     address public EOS_address;    // EOS Tokens
74     address public NRB_address;    // New Rich on The Block Contract
75     
76     address public CNT_address;    // Chip
77     address public BGB_address;    // BG Coin
78     address public VPE_address;    // Vapaee Token
79     address public GVPE_address;   // Golden Vapaee Token
80     
81 
82 }
83 
84 
85 // ----------------------------------------------------------------------------
86 // CNT_Crowdsale
87 // ----------------------------------------------------------------------------
88 contract CNT_Crowdsale is CNT_Common {
89 
90     uint public raised;
91     uint public remaining;
92     uint public cnt_per_Keos;
93     uint public bgb_per_Keos;
94     uint public vpe_per_Keos;
95     uint public gvpe_per_Keos;
96     mapping(address => uint) public paid;
97     
98     // a global list of users (uniques ids across)
99     mapping(uint => Reward) public rewards;
100 
101     // length of prev list
102     uint public rewardslength;
103 
104     struct Reward {
105         uint cnt;
106         uint bgb;
107         uint timestamp;
108         address target;
109         string concept;
110     }
111 
112     event Sale(address from, uint eos_tokens, address to, uint cnt_tokens, uint mana_tokens, uint vpe_tokens, uint gvpe_tokens);
113     // --------------------------------------------------------------------------------
114 
115     function CNT_Crowdsale() public {
116         rewardslength = 0;
117         cnt_per_Keos  = 300000;
118         bgb_per_Keos  = 300000;
119         vpe_per_Keos  =    500;
120         gvpe_per_Keos =    100;
121         name = "CNT_Crowdsale";
122         remaining = 1000000 * 10**18; // 1 million
123     }
124 
125     function init(address _eos, address _cnt, address _bgb, address _vpe, address _gvpe, address _nrb) public {
126         require(!initialized);
127         EOS_address = _eos;
128         CNT_address = _cnt;
129         BGB_address = _bgb;
130         VPE_address = _vpe;
131         GVPE_address = _gvpe;
132         NRB_address = _nrb;
133         PRE_SALE_Token(CNT_address).init(address(this));
134         PRE_SALE_Token(BGB_address).init(address(this));
135         PRE_SALE_Token(VPE_address).init(address(this));
136         PRE_SALE_Token(GVPE_address).init(address(this));
137         initialized = true;
138     }
139 
140     function isInit() constant public returns (bool) {
141         return initialized;
142     }
143 
144     function calculateTokens(uint _Keos_amount) constant public returns (uint, uint, uint, uint) {
145         uint cnt  = _Keos_amount * cnt_per_Keos;
146         uint bgb  = _Keos_amount * bgb_per_Keos;
147         uint vpe  = _Keos_amount * vpe_per_Keos;
148         uint gvpe = _Keos_amount * gvpe_per_Keos;        
149         if (vpe % 1000000000000000000 > 0) {
150             vpe = vpe - vpe % 1000000000000000000;
151         }
152         if (gvpe % 1000000000000000000 > 0) {
153             gvpe = gvpe - gvpe % 1000000000000000000;
154         }
155         return (
156             cnt,
157             bgb,
158             vpe,
159             gvpe
160         );
161     }
162 
163     function buy(uint _Keos_amount) public {
164         // calculate how much of each token must be sent
165         uint _eos_amount = _Keos_amount * 1000;
166         require(remaining >= _eos_amount);
167 
168         uint cnt_amount  = 0;
169         uint bgb_amount = 0;
170         uint vpe_amount  = 0;
171         uint gvpe_amount = 0;
172 
173         (cnt_amount, bgb_amount, vpe_amount, gvpe_amount) = calculateTokens(_Keos_amount);
174 
175         // send the tokens
176         PRE_SALE_Token(CNT_address) .ico_distribution(msg.sender, cnt_amount);
177         PRE_SALE_Token(BGB_address) .ico_distribution(msg.sender, bgb_amount);
178         PRE_SALE_Token(VPE_address) .ico_distribution(msg.sender, vpe_amount);
179         PRE_SALE_Token(GVPE_address).ico_distribution(msg.sender, gvpe_amount);
180 
181         // registro la compra
182         Sale(address(this), _eos_amount, msg.sender, cnt_amount, bgb_amount, vpe_amount, gvpe_amount);
183         paid[msg.sender] = paid[msg.sender] + _eos_amount;
184 
185         // envío los eos al owner
186         ERC20Interface(EOS_address).transferFrom(msg.sender, owner, _eos_amount);
187 
188         raised = raised + _eos_amount;
189         remaining = remaining - _eos_amount;
190     }
191 
192     function registerUserOnToken(string _json) public {
193         NRB_Contract(CNT_address).registerUserOnToken(EOS_address, msg.sender, paid[msg.sender], 0, _json);
194     }
195 
196     function finishPresale() public onlyOwner() {
197         uint cnt_amount  = 0;
198         uint bgb_amount = 0;
199         uint vpe_amount  = 0;
200         uint gvpe_amount = 0;
201 
202         (cnt_amount, bgb_amount, vpe_amount, gvpe_amount) = calculateTokens(remaining);
203 
204         // send the tokens
205         PRE_SALE_Token(CNT_address) .ico_distribution(owner, cnt_amount);
206         PRE_SALE_Token(BGB_address) .ico_distribution(owner, bgb_amount);
207         PRE_SALE_Token(VPE_address) .ico_distribution(owner, vpe_amount);
208         PRE_SALE_Token(GVPE_address).ico_distribution(owner, gvpe_amount);
209 
210         // registro la compra
211         Sale(address(this), remaining, owner, cnt_amount, bgb_amount, vpe_amount, gvpe_amount);
212         paid[owner] = paid[owner] + remaining;
213 
214         raised = raised + remaining;
215         remaining = 0;        
216     }
217 
218     function reward(address _target, uint _cnt, uint _bgb,  string _concept) public onlyOwner() {
219         // register the reward
220         rewardslength++;
221         rewards[rewardslength] = Reward(_cnt, _bgb, block.timestamp, _target, _concept);
222 
223         // send the tokens
224         PRE_SALE_Token(CNT_address) .ico_promo_reward(_target, _cnt);
225         PRE_SALE_Token(BGB_address) .ico_promo_reward(_target, _bgb);        
226     }
227     // ------------------------------------------------------------------------
228     // Don't accept ETH
229     // ------------------------------------------------------------------------
230     function () public payable {
231         revert();
232     }
233 
234     // ------------------------------------------------------------------------
235     // Owner can transfer out any accidentally sent ERC20 tokens
236     // ------------------------------------------------------------------------
237     function transferAnyERC20Token(address tokenAddress, uint tokens) public returns (bool success) {
238         return ERC20Interface(tokenAddress).transfer(owner, tokens);
239     }
240 
241 
242 }