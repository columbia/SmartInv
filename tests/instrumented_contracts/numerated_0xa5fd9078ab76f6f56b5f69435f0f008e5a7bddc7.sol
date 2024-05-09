1 contract RGX {
2     function balanceOf(address _owner) public view returns (uint256 balance);
3 }
4 
5 contract RGE {
6     function balanceOf(address _owner) public view returns (uint256 balance);
7     function transfer(address _to, uint256 _value) public returns (bool success);
8 }
9 
10 contract RougeTGE {
11     
12     string public version = 'v1.1';
13     
14     address owner; 
15 
16     modifier onlyBy(address _account) {
17         require(msg.sender == _account);
18         _;
19     }
20 
21     bool public fundingActive = true;
22 
23     function toggleFunding(bool _flag) onlyBy(owner) public {
24         fundingActive = _flag;
25     }
26 
27     uint public fundingStart;
28     uint public fundingEnd;
29 
30     modifier beforeTGE() {
31         require(fundingStart > now);
32         _;
33     }
34 
35     modifier TGEOpen() {
36         require(fundingStart <= now && now < fundingEnd);
37         require(fundingActive);
38         _;
39     }
40     
41     modifier afterTGE() {
42         require(now >= fundingEnd);
43         _;
44     }
45 
46     function isFundingOpen() constant public returns (bool yes) {
47         return(fundingStart <= now && now < fundingEnd && fundingActive);
48     }
49 
50     mapping (address => bool) public kyc;
51     mapping (address => uint256) public tokens;
52     mapping (address => mapping (address => uint256)) public used;
53 
54     function tokensOf(address _who) public view returns (uint256 balance) {
55         return tokens[_who];
56     }
57 
58     uint8 public minFunding = 1; /* in finney */
59     uint8 public decimals = 6;
60     uint256 public total_distribution = 500000000 * 10**uint(decimals); /* Total RGE tokens to distribute during TGE (500m with 6 decimals) */
61 
62     struct Sale {
63         uint256 funding; // original contribution in finney
64         uint256 used;    // already used with bonus contribution in finney
65         uint256 tokens;  // RGE tokens distribution
66         bool presale;
67     }
68 
69     uint256 public tokenPrice; /* in wei */
70 
71     constructor(
72                 uint _fundingStart,
73                 uint _fundingEnd,
74                 uint _tokenPrice
75                 ) public {
76         owner = msg.sender;
77         fundingStart = _fundingStart;
78         fundingEnd = _fundingEnd;
79         tokenPrice = _tokenPrice;
80     }
81     
82     address rge; 
83 
84     address rgxa; 
85     address rgxb; 
86     address rgxd; 
87 
88     address rgx20; 
89     address rgx15; 
90     address rgx12; 
91     address rgx9; 
92     address rgx8; 
93     address rgx7; 
94     address rgx6; 
95     address rgx5; 
96     address rgx4; 
97     address rgx3; 
98 
99     function init (
100                    address _rge,
101                    address _rgxa, address _rgxb, address _rgxd,
102                    address _rgx20, address _rgx15, address _rgx12,
103                    address _rgx9, address _rgx8, address _rgx7, address _rgx6, address _rgx5, address _rgx4, address _rgx3
104                    ) onlyBy(owner) public {
105         rge = _rge;
106         rgxa = _rgxa; rgxb = _rgxb; rgxd = _rgxd; 
107         rgx20 = _rgx20; rgx15 = _rgx15; rgx12 = _rgx12;
108         rgx9 = _rgx9; rgx8 = _rgx8; rgx7 = _rgx7; rgx6 = _rgx6; rgx5 = _rgx5; rgx4 = _rgx4; rgx3 = _rgx3;
109     }
110     
111     event Distribute(address indexed buyer, uint256 value);
112 
113     function () payable TGEOpen() public { 
114 
115         require(msg.sender != owner);
116 
117         Sale memory _sale = Sale({
118             funding: msg.value / 1 finney, used: 0, tokens: 0, presale: false
119         });
120 
121         require(_sale.funding >= minFunding);
122 
123         /* distribution with RGX discounts */
124         
125         _sale = _with_RGXBonus(_sale, rgxa, 20, 1);
126         _sale = _with_RGXBonus(_sale, rgxb, 11, 1);
127         _sale = _with_RGXBonus(_sale, rgxd, 5, 4);
128 
129         _sale = _with_RGXToken(_sale, rgx20, 20, 1);
130         _sale = _with_RGXToken(_sale, rgx15, 15, 1);
131         _sale = _with_RGXToken(_sale, rgx12, 12, 1);
132         _sale = _with_RGXToken(_sale, rgx9, 9, 1);
133         _sale = _with_RGXToken(_sale, rgx8, 8, 1);
134         _sale = _with_RGXToken(_sale, rgx7, 7, 1);
135         _sale = _with_RGXToken(_sale, rgx6, 6, 1);
136         _sale = _with_RGXToken(_sale, rgx5, 5, 1);
137         _sale = _with_RGXToken(_sale, rgx4, 4, 1);
138         _sale = _with_RGXToken(_sale, rgx3, 3, 1);
139 
140         /* standard tokens distribution */
141         
142         if ( _sale.funding > _sale.used ) {
143 
144             uint256 _available = _sale.funding - _sale.used;
145             _sale.used += _available;
146             _sale.tokens += _available * 1 finney * 10**uint(decimals) / tokenPrice;
147             
148         }
149         
150         /* check if enough tokens and distribute tokens to buyer */
151         
152         require(total_distribution >= _sale.tokens); 
153 
154         total_distribution -= _sale.tokens;
155         tokens[msg.sender] += _sale.tokens;
156         emit Distribute(msg.sender, _sale.tokens);
157 
158     }
159     
160     function _with_RGXBonus(Sale _sale, address _a, uint8 _multiplier, uint8 _divisor) internal returns (Sale _result) {
161 
162         RGX _rgx = RGX(_a);
163 
164         uint256 rgxBalance = _rgx.balanceOf(msg.sender);
165 
166         if ( used[_a][msg.sender] < rgxBalance && _sale.funding > _sale.used ) {
167 
168             uint256 _available = rgxBalance - used[_a][msg.sender];
169 
170             if ( _available > _sale.funding - _sale.used ) {
171                 _available = _sale.funding - _sale.used;
172             }
173 
174             _sale.used += _available;
175             _sale.tokens += _available * 1 finney * 10**uint(decimals) / tokenPrice * _multiplier / _divisor;
176             used[_a][msg.sender] += _available;
177         }
178 
179         return _sale;
180     }
181 
182     function _with_RGXToken(Sale _sale, address _a, uint8 _multiplier, uint8 _divisor) internal returns (Sale _result) {
183 
184         if ( _sale.presale ) {
185             return _sale;
186         }
187         
188         RGX _rgx = RGX(_a);
189 
190         uint256 rgxBalance = _rgx.balanceOf(msg.sender);
191 
192         if ( used[_a][msg.sender] < rgxBalance ) {
193 
194             uint256 _available = rgxBalance - used[_a][msg.sender];
195 
196             _sale.tokens += _available * 1 finney * 10**uint(decimals) / tokenPrice * (_multiplier - 1) / _divisor;
197             used[_a][msg.sender] += _available;
198             _sale.presale = true;
199         }
200 
201         return _sale;
202     }
203 
204     function toggleKYC(address _who, bool _flag) onlyBy(owner) public {
205         kyc[_who]= _flag;
206     }
207     
208     function revertAML(address _who) onlyBy(owner) public {
209         total_distribution += tokens[_who];
210         tokens[_who] = 0;
211     }
212 
213     function withdraw() public returns (bool success) {
214 
215         require(msg.sender != owner); 
216         
217         // no verification if enough tokens => done in payable already
218         
219         require(tokens[msg.sender] > 0);
220         require(kyc[msg.sender]); 
221         
222         RGE _rge = RGE(rge);
223         
224         if ( _rge.transfer(msg.sender, tokens[msg.sender]) ) {
225             tokens[msg.sender] = 0;
226             return true;
227         } 
228         
229         return false;
230         
231     }
232     
233     function withdrawFunding() onlyBy(owner) public {
234         msg.sender.transfer(address(this).balance);
235     }
236     
237     function kill() onlyBy(owner) public {
238         selfdestruct(owner);
239     }
240 
241 }