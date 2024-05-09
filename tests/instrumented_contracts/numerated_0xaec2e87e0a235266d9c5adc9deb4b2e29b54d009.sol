1 /// Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
2 
3 /// @title Abstract token contract - Functions to be implemented by token contracts.
4 /// @author Stefan George - <stefan.george@consensys.net>
5 contract Token {
6     // This is not an abstract function, because solc won't recognize generated getter functions for public variables as functions
7     function totalSupply() constant returns (uint256 supply) {}
8     function balanceOf(address owner) constant returns (uint256 balance);
9     function transfer(address to, uint256 value) returns (bool success);
10     function transferFrom(address from, address to, uint256 value) returns (bool success);
11     function approve(address spender, uint256 value) returns (bool success);
12     function allowance(address owner, address spender) constant returns (uint256 remaining);
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     event Approval(address indexed owner, address indexed spender, uint256 value);
16 }
17 
18 
19 
20 contract StandardToken is Token {
21 
22     /*
23      *  Data structures
24      */
25     mapping (address => uint256) balances;
26     mapping (address => mapping (address => uint256)) allowed;
27     uint256 public totalSupply;
28 
29     /*
30      *  Read and write storage functions
31      */
32     /// @dev Transfers sender's tokens to a given address. Returns success.
33     /// @param _to Address of token receiver.
34     /// @param _value Number of tokens to transfer.
35     function transfer(address _to, uint256 _value) returns (bool success) {
36         if (balances[msg.sender] >= _value && _value > 0) {
37             balances[msg.sender] -= _value;
38             balances[_to] += _value;
39             Transfer(msg.sender, _to, _value);
40             return true;
41         }
42         else {
43             return false;
44         }
45     }
46 
47     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
48     /// @param _from Address from where tokens are withdrawn.
49     /// @param _to Address to where tokens are sent.
50     /// @param _value Number of tokens to transfer.
51     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
52         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
53             balances[_to] += _value;
54             balances[_from] -= _value;
55             allowed[_from][msg.sender] -= _value;
56             Transfer(_from, _to, _value);
57             return true;
58         }
59         else {
60             return false;
61         }
62     }
63 
64     /// @dev Returns number of tokens owned by given address.
65     /// @param _owner Address of token owner.
66     function balanceOf(address _owner) constant returns (uint256 balance) {
67         return balances[_owner];
68     }
69 
70     /// @dev Sets approved amount of tokens for spender. Returns success.
71     /// @param _spender Address of allowed account.
72     /// @param _value Number of approved tokens.
73     function approve(address _spender, uint256 _value) returns (bool success) {
74         allowed[msg.sender][_spender] = _value;
75         Approval(msg.sender, _spender, _value);
76         return true;
77     }
78 
79     /*
80      * Read storage functions
81      */
82     /// @dev Returns number of allowed tokens for given address.
83     /// @param _owner Address of token owner.
84     /// @param _spender Address of token spender.
85     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
86       return allowed[_owner][_spender];
87     }
88 
89 }
90 
91 contract SingularDTVFund {
92     function workshop() returns (address);
93     function softWithdrawRevenueFor(address forAddress) returns (uint);
94 }
95 contract SingularDTVCrowdfunding {
96     function twoYearsPassed() returns (bool);
97     function startDate() returns (uint);
98     function CROWDFUNDING_PERIOD() returns (uint);
99     function TOKEN_TARGET() returns (uint);
100     function valuePerShare() returns (uint);
101     function fundBalance() returns (uint);
102     function campaignEndedSuccessfully() returns (bool);
103 }
104 
105 
106 /// @title Token contract - Implements token issuance.
107 /// @author Stefan George - <stefan.george@consensys.net>
108 contract SingularDTVToken is StandardToken {
109 
110     /*
111      *  External contracts
112      */
113     SingularDTVFund constant singularDTVFund = SingularDTVFund(0xe736091fc36f1ad476f5e4e03e4425940822d3ba);
114     SingularDTVCrowdfunding constant singularDTVCrowdfunding = SingularDTVCrowdfunding(0xbdf5c4f1c1a9d7335a6a68d9aa011d5f40cf5520);
115 
116     /*
117      *  Token meta data
118      */
119     string constant public name = "SingularDTV";
120     string constant public symbol = "SNGLS";
121     uint8 constant public decimals = 0;
122 
123     /*
124      *  Modifiers
125      */
126     modifier noEther() {
127         if (msg.value > 0) {
128             throw;
129         }
130         _
131     }
132 
133     modifier workshopWaitedTwoYears() {
134         // Workshop can only transfer tokens after a two years period.
135         if (msg.sender == singularDTVFund.workshop() && !singularDTVCrowdfunding.twoYearsPassed()) {
136             throw;
137         }
138         _
139     }
140 
141     modifier isCrowdfundingContract () {
142         // Only crowdfunding contract is allowed to proceed.
143         if (msg.sender != address(singularDTVCrowdfunding)) {
144             throw;
145         }
146         _
147     }
148 
149     /*
150      *  Contract functions
151      */
152     /// @dev Crowdfunding contract issues new tokens for address. Returns success.
153     /// @param _for Address of receiver.
154     /// @param tokenCount Number of tokens to issue.
155     function issueTokens(address _for, uint tokenCount)
156         external
157         isCrowdfundingContract
158         returns (bool)
159     {
160         if (tokenCount == 0) {
161             return false;
162         }
163         balances[_for] += tokenCount;
164         totalSupply += tokenCount;
165         return true;
166     }
167 
168     /// @dev Transfers sender's tokens to a given address. Returns success.
169     /// @param to Address of token receiver.
170     /// @param value Number of tokens to transfer.
171     function transfer(address to, uint256 value)
172         noEther
173         workshopWaitedTwoYears
174         returns (bool)
175     {
176         // Both parties withdraw their revenue first
177         singularDTVFund.softWithdrawRevenueFor(msg.sender);
178         singularDTVFund.softWithdrawRevenueFor(to);
179         return super.transfer(to, value);
180     }
181 
182     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success.
183     /// @param from Address from where tokens are withdrawn.
184     /// @param to Address to where tokens are sent.
185     /// @param value Number of tokens to transfer.
186     function transferFrom(address from, address to, uint256 value)
187         noEther
188         workshopWaitedTwoYears
189         returns (bool)
190     {
191         // Both parties withdraw their revenue first
192         singularDTVFund.softWithdrawRevenueFor(from);
193         singularDTVFund.softWithdrawRevenueFor(to);
194         return super.transferFrom(from, to, value);
195     }
196 
197     /// @dev Contract constructor function sets initial token balances.
198     function SingularDTVToken() noEther {
199         // Set token creation for workshop
200         balances[singularDTVFund.workshop()] = 400000000; // ~400M
201         // Set token creation for core
202         balances[0x0196b712a0459cbee711e7c1d34d2c85a9910379] = 5000000;
203         balances[0x0f94dc84ce0f5fa2a8cc8d27a6969e25b5a39273] = 200000;
204         balances[0x122b7eb5f629d806c8adb0baa0560266abb3ec80] = 450000;
205         balances[0x13870d30fcdb7d7ae875668f2a1219225295d57c] = 50000;
206         balances[0x26640e826547bc700b8c7a9cc2c1c39a4ab3cbb3] = 900000;
207         balances[0x26bbfc6b23bc36e84447f061c6804f3a8b1a3698] = 250000;
208         balances[0x2d37383a45b5122a27efade69f7180eee4d965da] = 1270000;
209         balances[0x2e79b81121193d55c4934c0f32ad3d0474ca7b9c] = 4200000;
210         balances[0x3114844fc0e3de03963bbd1d983ba17ca89ad010] = 5000000;
211         balances[0x378e6582e4e3723f7076c7769eef6febf51258e1] = 680000;
212         balances[0x3e18530a4ee49a0357ffc8e74c08bfdee3915482] = 2490000;
213         balances[0x43fed1208d25ca0ef5681a5c17180af50c19f826] = 100000;
214         balances[0x4f183b18302c0ac5804b8c455018efc51af15a56] = 10000;
215         balances[0x55a886834658ccb6f26c39d5fdf6d833df3a276a] = 100000;
216         balances[0x5faa1624422db662c654ab35ce57bf3242888937] = 5000000;
217         balances[0x6407b662b306e2353b627488da952337a5a0bbaa] = 5000000;
218         balances[0x66c334fff8c8b8224b480d8da658ca3b032fe625] = 10000000;
219         balances[0x6c24991c6a40cd5ad6fab78388651fb324b35458] = 250000;
220         balances[0x781ba492f786b2be48c2884b733874639f50022c] = 500000;
221         balances[0x79b48f6f1ac373648c509b74a2c04a3281066457] = 2000000;
222         balances[0x835898804ed30e20aa29f2fe35c9f225175b049f] = 100000;
223         balances[0x93c56ea8848150389e0917de868b0a23c87cf7b1] = 2790000;
224         balances[0x93f959df3df3c6ee01ee9748327b881b2137bf2a] = 450000;
225         balances[0x9adc0215372e4ffd8c89621a6bd9cfddf230349f] = 550000;
226         balances[0xae4dbd3dae66722315541d66fe9457b342ac76d9] = 500000;
227         balances[0xbae02fe006f115e45b372f2ddc053eedca2d6fff] = 1800000;
228         balances[0xcc835821f643e090d8157de05451b416cd1202c4] = 300000;
229         balances[0xce75342b92a7d0b1a2c6e9835b6b85787e12e585] = 670000;
230         balances[0xd2b388467d9d0c30bab0a68070c6f49c473583a0] = 990000;
231         balances[0xdca0724ddde95bbace1b557cab4375d9a813da49] = 3500000;
232         balances[0xe3ef62165b60cac0fcbe9c2dc6a03aab4c5c8462] = 150000;
233         balances[0xe4f7d5083baeea7810b6d816581bb0ee7cd4b6f4] = 10560000;
234         balances[0xef08eb55d3482973c178b02bd4d5f2cea420325f] = 80000;
235         balances[0xfdecc9f2ee374cedc94f72ab4da2de896ce58c19] = 5000000;
236         balances[0xe5ff71dc1dea8cd2552eec59e9a5e8813da9bb01] = 29110000;
237         totalSupply = 500000000; // 500M
238     }
239 }