1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
5         if (a == 0) {
6             return 0;
7         }
8         c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12     function div(uint256 a, uint256 b) internal pure returns (uint256) {
13         return a / b;
14     }
15     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16         assert(b <= a);
17         return a - b;
18     }
19     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
20         c = a + b;
21         assert(c >= a);
22         return c;
23     }
24 }
25 
26 contract Ownable {
27     address public owner;
28 
29     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
30 
31     constructor() public {
32         owner = msg.sender;
33     }
34 
35     modifier onlyOwner() {
36         require(msg.sender == owner);
37         _;
38     }
39 
40     function transferOwnership(address newOwner) public onlyOwner {
41         require(newOwner != address(0));
42         emit OwnershipTransferred(owner, newOwner);
43         owner = newOwner;
44     }
45 
46 }
47 
48 contract ERC20 {
49     function totalSupply() public view returns (uint256);
50     function balanceOf(address who) public view returns (uint256);
51     function transfer(address to, uint256 value) public;
52     function allowance(address owner, address spender) public view returns (uint256);
53     function transferFrom(address from, address to, uint256 value) public returns (bool);
54     function approve(address spender, uint256 value) public returns (bool);
55 
56     event Approval(address indexed owner, address indexed spender, uint256 value);
57     event Transfer(address indexed from, address indexed to, uint256 value);
58     event Burn(address indexed from, uint256 value);
59 }
60 
61 contract KNBaseToken is ERC20 {
62     using SafeMath for uint256;
63     
64     string public name;
65     string public symbol;
66     uint8 public decimals;
67     uint256 totalSupply_;
68 
69     mapping(address => uint256) balances;
70     mapping (address => mapping (address => uint256)) internal allowed;
71 
72     constructor(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply) public{
73         name = _name;
74         symbol = _symbol;
75         decimals = _decimals;
76         totalSupply_ = _totalSupply;
77     }
78 
79     function totalSupply() public view returns (uint256) {
80         return totalSupply_;
81     }
82 
83     function balanceOf(address _owner) public view returns (uint256) {
84         return balances[_owner];
85     }
86 
87     function _transfer(address _from, address _to, uint256 _value) internal {
88         require(_to != address(0));
89         require(balances[_from] >= _value);
90         require(balances[_to].add(_value) > balances[_to]);
91 
92 
93         uint256 previousBalances = balances[_from].add(balances[_to]);
94         balances[_from] = balances[_from].sub(_value);
95         balances[_to] = balances[_to].add(_value);
96         emit Transfer(_from, _to, _value);
97 
98         assert(balances[_from].add(balances[_to]) == previousBalances);
99     }
100 
101     function transfer(address _to, uint256 _value) public {
102         _transfer(msg.sender, _to, _value);
103     }
104 
105     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
106         require(_value <= allowed[_from][msg.sender]);     // Check allowance
107         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
108         _transfer(_from, _to, _value);
109         return true;
110     }
111 
112     function approve(address _spender, uint256 _value) public returns (bool) {
113         allowed[msg.sender][_spender] = _value;
114         emit Approval(msg.sender, _spender, _value);
115         return true;
116     }
117 
118     function allowance(address _owner, address _spender) public view returns (uint256) {
119         return allowed[_owner][_spender];
120     }
121 
122     function burn(uint256 _value) public returns (bool success) {
123         require(balances[msg.sender] >= _value);
124         balances[msg.sender] = balances[msg.sender].sub(_value);
125         totalSupply_ = totalSupply_.sub(_value);
126         emit Burn(msg.sender, _value);
127         return true;
128     }
129 
130     function burnFrom(address _from, uint256 _value) public returns (bool success) {
131         require(balances[_from] >= _value);
132         require(_value <= allowed[_from][msg.sender]);
133 
134         balances[_from] = balances[_from].sub(_value);
135         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
136         totalSupply_ = totalSupply_.sub(_value);
137         emit Burn(msg.sender, _value);
138         return true;
139     }
140 }
141 
142 contract KnowToken is KNBaseToken, Ownable {
143 
144     uint256 internal privateToken = 389774115000000000000000000;
145     uint256 internal preSaleToken = 1169322346000000000000000000;
146     uint256 internal crowdSaleToken = 3897741155000000000000000000;
147     uint256 internal bountyToken;
148     uint256 internal foundationToken;
149     address public founderAddress;
150     bool public unlockAllTokens;
151 
152     mapping (address => bool) public frozenAccount;
153 
154     event FrozenFunds(address target, bool unfrozen);
155     event UnLockAllTokens(bool unlock);
156 
157     constructor() public {
158         founderAddress = msg.sender;
159         balances[founderAddress] = totalSupply_;
160         emit Transfer(address(0), founderAddress, totalSupply_);
161     }
162 
163     function _transfer(address _from, address _to, uint _value) internal {
164         require (_to != address(0));                               
165         require (balances[_from] >= _value);               
166         require (balances[_to].add(_value) >= balances[_to]); 
167         require(!frozenAccount[_from] || unlockAllTokens);
168 
169         balances[_from] = balances[_from].sub(_value);                  
170         balances[_to] = balances[_to].add(_value);                  
171         emit Transfer(_from, _to, _value);
172     }
173 
174     function unlockAllTokens(bool _unlock) public onlyOwner {
175         unlockAllTokens = _unlock;
176         emit UnLockAllTokens(_unlock);
177     }
178 
179     function freezeAccount(address target, bool freeze) public onlyOwner {
180         frozenAccount[target] = freeze;
181         emit FrozenFunds(target, freeze);
182     }
183 }
184 
185 contract BountyKN {
186     using SafeMath for uint256;
187 
188     KnowToken public token;
189     mapping(address => uint256) tokens;
190 
191     constructor() public {
192         token = KnowToken(0xbfd18F20423694a69e35d65cB9c9D74396CC2c2d);// address of KN Token on main net
193         tokens[address(0x0941A88F7a6ee30E08498a580799Da5e6608124D)] = 1400;
194 tokens[address(0xfD207944B3F2a7eFE9f6272930A717E5075D55E9)] = 2100;
195 tokens[address(0xc720B97782D494AE64ff9E4Fe5c4A4Cb5e427Df0)] = 2700;
196 tokens[address(0xB9c2638f354008b89844A4e47998F25564a24cd5)] = 2100;
197 tokens[address(0xa0860bc693F2A531d65F6fFAb4aB551510971c37)] = 15400;
198 tokens[address(0xB44DA40daC4CcCb8F2b0198187ABE4FBc2623a2F)] = 2300;
199 tokens[address(0xd0FfEdE652D3453501463b3281973e1cB2cE30BC)] = 1100;
200 tokens[address(0x3D5d3555135A4c36817B971196e4e441e2e82E38)] = 1400;
201 tokens[address(0x95D52f953cDA1270F3BaB0c281bFeCCDB660515c)] = 4500;
202 tokens[address(0x41fa0945FbC3416895006aFE2a25174816a68673)] = 8600;
203 tokens[address(0xE646AFbbd439831Da07b7F7be8593D04a9b53C9D)] = 2800;
204 tokens[address(0xD78b69C011ff6C910428163bE64129C29bC88311)] = 2100;
205 tokens[address(0xE8d92Eb3F9Ee2e1e14453DA69ab91a3597DEdaBD)] = 2500;
206 tokens[address(0x8b4A92B9183fE94Ae2B6f5D52D207F59bBE8Ff72)] = 17700;
207 tokens[address(0x7Af4DdF725A3F2F1547518553d8A030B5Cf8323d)] = 600;
208 tokens[address(0xF360ABbDEA1283d342AD9CB3770e10597217d4b2)] = 5800;
209 tokens[address(0x7DaA87DE1d7C0C95FE47407480f50Bec45026D9F)] = 5400;
210 tokens[address(0xc546BdCBE2dca6a2539273CfFB0daF76488676aF)] = 1400;
211 tokens[address(0x3bA0A6942458c6e70cb08F1Cb836e778B44937Bc)] = 1200;
212 tokens[address(0xB4c370a2f3d1c8d3f512aD493DD1E5aAB31e845b)] = 35700;
213 tokens[address(0x28791A193f4f07F41A4bA1472362a899768564b9)] = 5900;
214 tokens[address(0xCd8543b68802dB509Bc90DBb93FcBdF22FDA2414)] = 2100;
215 tokens[address(0xD3489b36655faA8F9CD68AB6e7B96C93A31AA09B)] = 1900;
216 tokens[address(0xC9276d01EF0271189bc831eF2AE4a7830D9CC711)] = 20700;
217 tokens[address(0x4aDAecE33a542511FB9C075b6E197E560af0d260)] = 2300;
218 tokens[address(0x9FBE5Be513d11d3d4066648B35304722406d86e7)] = 1200;
219 tokens[address(0x83b7062779cC4E9fB2195EF643DFaf5a10940f55)] = 1600;
220 tokens[address(0xCFE0d265eF56be39a557Ca0788cC4C648aeD4256)] = 22100;
221 tokens[address(0xb61098608C21800a3DbEa92e45131a2059Fabe69)] = 3100;
222 tokens[address(0xF7fcA9a5A74E2b4ce80272D9A7AeBc3889CC38eA)] = 1600;
223 tokens[address(0x1cB9e7CCfc1C431eE711F40ecB8CfBE9DeDd2848)] = 1600;
224 tokens[address(0x4A11B358DC9Cd81f3532F19215B1d252d9aBA6f7)] = 5600;
225 tokens[address(0x406586B2683826fB8546f8cf91ba2d43b930f2dB)] = 1200;
226 tokens[address(0x4bD2096F27a7f29bF0D382753e5Aa8596adC3835)] = 1600;
227 tokens[address(0x16b06822E0354337ffa7E32438ACa8a58d8a71dA)] = 3100;
228 tokens[address(0x54Ff62E93f5801d423919aD2fD4b1b58D793C635)] = 6700;
229 tokens[address(0xe054C4795CDDc4a7616f5a5615ece5221d319431)] = 2700;
230 tokens[address(0x7E2081D632e7aC2554ED0Eb03f03F464b22CF1e2)] = 1700;
231 tokens[address(0x97a9ffbad5f34Fb83C090F38fEB0189BF43caD46)] = 1400;
232 tokens[address(0xA60655bc5C4C311bD56C93005C0C52bc52d7BA9c)] = 2100;
233 tokens[address(0xDE8AEd3c54805F3CD7E681a1f7C70aB5361f09d0)] = 2100;
234 tokens[address(0x03740abCf89dA53c5e331C48cbA61Fc4e1DA61bf)] = 1000;
235 tokens[address(0x3EB13628f4a7E76d87ca0EcfA8dad629f5eC7a85)] = 3900;
236 tokens[address(0xB38eae3fb6733b7DF9E1A8070F8060E586ca966e)] = 700;
237 tokens[address(0xdcaF58f7A3e91ad7a49aE42f9454c06891FB14b0)] = 2135;
238 tokens[address(0x612d9189D5442a54a5995d0bE8b1A7833Bb093d4)] = 1600;
239 tokens[address(0x8Eadd5c5DE68A9F1B3bA0D5862B2dD091E467288)] = 2200; 
240 tokens[address(0x4f4a5be801Cf09b94c1807d728fCc7a32608AdA1)] = 3600;
241 tokens[address(0x15bf03dDB2A547cda86F88273B4419D93A6b7191)] = 4700;
242 tokens[address(0x085dC96c98695edaE27866540B9B33df57567Fe9)] = 600;
243 tokens[address(0x9741bc612fB318a9a9475D11582564A71693f132)] = 50900;
244 tokens[address(0xc374E66ff5D6A6eA1f30Ce8e35A98f4705D10871)] = 1300;
245 tokens[address(0x0E1653D0dA5ffd5F4b59Abb08fbd2a5C9eD3A2D8)] = 4900;
246 tokens[address(0xEf9b4ECeB926d687e8421B47EdF90A3C61Cc4261)] = 4500;
247 tokens[address(0xC31702F684Ac4474E6892Cf1841d7762062b62b8)] = 1200;
248 tokens[address(0x3842828A77A670224b3296fF4F63482189cdEAFa)] = 2000;
249 tokens[address(0xF27AA919fB5f1B449fceDF58B8Ff2f25D9b3Bf4c)] = 1700;
250 tokens[address(0xa5BFE70F7f7F96329ebD60Ad527739ee1405F434)] = 600;
251 tokens[address(0xb74E15da83687E0A0237cE6ecbeFEbAAc9162e75)] = 2400;
252 tokens[address(0xF664E2C7c5126340058bB918d0a27a60a0938089)] = 8900;
253 tokens[address(0x40170aDAB40C78519e8606B200B1F7c30813fe20)] = 1600;
254 tokens[address(0xC2E0EE421ECeB9DeAa27B06F812035401A8fa249)] = 18800;
255 tokens[address(0x9d804ca277b9cc8Bec9eA42fdBc41eC17A3d4D40)] = 600;
256 tokens[address(0x63782B9465ed59Fed9bfC22321D066Dfa6901db5)] = 2000;
257 tokens[address(0xCa6d5bCaDb1b652Db568D7475faDB42c18Ef8702)] = 2400;
258 tokens[address(0x2A7f654a78632bbff061FAF0dD21B7DbAd9397Bb)] = 3000;
259 tokens[address(0xbcDc8c2f3939F9abcc72eac373c961147Cba0Ea4)] = 1300;
260 tokens[address(0x9806AAB9F61E28668B5925A7AF0aBC77C1d3118d)] = 600;
261 tokens[address(0xcd645307bf75d01b14d10Ceff74Eb5CEEf329Ba5)] = 9500;
262 tokens[address(0x5a247c15D4bdB05D90fcaA84C27B641B80C36166)] = 1900;
263 tokens[address(0x229d8D4872Ef6f3DC29E0243f8FAf219F746Ca4D)] = 600;
264 tokens[address(0x2B7fa6C81a759B4F75a8Da54C771bBCbfD6D6eFe)] = 2900;
265 tokens[address(0x187B702d7676BB27F8737a44A99a00C57F62ca8f)] = 1400;
266 tokens[address(0x1A5957480C03c220540eeb3752d81cA63D05eeB0)] = 1600;
267 tokens[address(0xEa40272571b523C87e67F392F942C28668201eBd)] = 1000;
268 tokens[address(0x03B501B00D5c1dEccAc462DED676C5d3b1e3B578)] = 2600;
269 tokens[address(0xA050EEeFb3a56bd08eA34c4664E9888Eda89f2Cb)] = 1000;
270 tokens[address(0x21501eb303490A9bd2E24d1e37974D9CAB3A1975)] = 4800;
271 tokens[address(0x823dde5b4b0068440bc6c4d5E96471447b8715BA)] = 1900;
272 tokens[address(0xD9Bc45A741ED2692436f4F9278eF5F764c7D4DAb)] = 3600;
273 tokens[address(0xE7A2d7ce01dB677efdd3bBbeae7ce02D49A847f0)] = 4100;
274 tokens[address(0xad497Fba56d915A37E2664c895C3762bdB91063F)] = 3100;
275 tokens[address(0x42F8D3d00569bAD0587Bc7c129D6AB2A02d38bb2)] = 2100;
276 tokens[address(0x34209Dd9B7b1791111DCFb4F2a5180B5302396A6)] = 6100;
277 tokens[address(0x6b67b5Daf8F736C7A4334575f621D78C57c8e8B0)] = 600;
278 tokens[address(0x0187A422b4faD439Fbfcf20f21F32159fd2a4f97)] = 14100;
279 tokens[address(0xDF489E9b14fA9140F1D061C2864153a3bF42d702)] = 1900;
280 tokens[address(0x5448eA30c16d94283468fFC78B56ca6Cf55627C9)] = 1400;
281 tokens[address(0x7863145782E3b68554f69169aCb78C49D53acA86)] = 15000;
282 tokens[address(0x516526B4F552bc28a2963460fcf2dEAF51379Ef3)] = 2200;
283 tokens[address(0x26bE30e807985aC821e752AB8BaAfB9e24ff5BF8)] = 2200;
284 tokens[address(0x1179f72F797E0b593A416D89213aa781Cb1d505b)] = 17400;
285 tokens[address(0x9be2cb8d5742e44A7f41Cae139731fc7B174c92F)] = 900;
286 tokens[address(0xaf15F8EEf5D408Af7f2A96a0bA43933394896fE8)] = 600;
287 tokens[address(0x3EF19882D6fdf524eF5806E96B2148f6E68f8765)] = 3100;
288 tokens[address(0xe1950cB15faacAEA071b5CFD2e47BD343D166348)] = 1600;
289 tokens[address(0xa1564b6DE580e3Fefe8b7511f9bEa3B016442cf8)] = 1600;
290 tokens[address(0xc04107121ABD5c4aDbA8Fe1E5e8F6C3eB4Dc943a)] = 3900;
291 tokens[address(0xA2bCCa90d554c0BeA7EF98514EAfAceBFabC7e01)] = 1600;
292 tokens[address(0x7f19e512b646e340c91212dA64d5c29ddfAB5A88)] = 1600;
293 tokens[address(0x49572b891f781C63C4c3d5f0369ff5848b10cC8A)] = 1900;
294 tokens[address(0x4E267850f9306d69D4E6924378dfBf6BddF92987)] = 1600;
295 tokens[address(0x1b2F2BA6076d5bD6016c3Ac6720B1b4eFe039ab0)] = 2100;
296 tokens[address(0xd13b82e701F36d07C8b305c03b0D22322AA07Eca)] = 4900;
297 tokens[address(0x10B37D101d52111c15e031c06693E4029ac16FB9)] = 5200;
298 tokens[address(0xc15D4Bc7B9144Bfc5465C663f7C850d262bEadA8)] = 21100;
299 tokens[address(0xc3FE5b76320E35356578B9cEa8380273eE1E1014)] = 1600;
300 tokens[address(0x605E23B31FeF49614f42119A385B5C6a25cBD197)] = 1600;
301 tokens[address(0x80131B1a904b4F93f17f5a2548F8BbD1Ea173a1B)] = 5600;
302 tokens[address(0x5898A9A31C418782308A1d794AcB36ebF5BF2366)] = 600;
303 tokens[address(0xB4631C95E026ad54AFA1655b7e61ae6B8796cc87)] = 2100;
304 tokens[address(0xcDa68c18d3DE67D0875AC5f1B0ecDa8013eAb402)] = 1200;
305 tokens[address(0xF375729a12bF1B3C4E67259DBE518995999be1c7)] = 1600;
306 tokens[address(0xbf5e8f557c14C8162977400FEE3Daf771713e0c4)] = 600;
307 tokens[address(0x3c37B9178969AF7d5D3B76C4454ec8483852c7b8)] = 1900;
308 tokens[address(0x5916Ef86dA9Bf7e80fCF424fF79Dbf130e3e61be)] = 1600;
309 tokens[address(0x9B96814F007C47ae421176B91520dDD55A5567e4)] = 13600;
310 tokens[address(0x29a696B5172BD2eFEA8db0D591f38636C970aAA3)] = 2000;
311 tokens[address(0x5FD14b0Dac21ed28f580b4f543B027B75E9D3a72)] = 2600;
312 tokens[address(0x6DAf093f0Aa4e94802b163110e4699551CEF5C32)] = 1600;
313 tokens[address(0x2F71C6BcFb2472732D845b7e7A8217E1f7E904ac)] = 4700;
314 tokens[address(0xF9F35534402F7277241dcC44BF36C13f1ca2f9e1)] = 1600;
315 tokens[address(0x2C393BC3550091D5e51941Ad822ebE15146e6bea)] = 29500;
316 tokens[address(0x71247234373524D6d0408ed58c4f26b8391222E1)] = 1700;
317 tokens[address(0x4608c18E751c5E9D4352f8b4A4B933531B8D9509)] = 1200;
318 tokens[address(0x1C62dad9cd2AcA923d7fb99ad83cCe601db2Ae02)] = 2100;
319 tokens[address(0xEE0407bd4F059aC2694E84aF4c6dcc862DAd0858)] = 3900;
320 tokens[address(0x96d07EB199655D506911b00d6243f3d990832CFE)] = 6000;
321 tokens[address(0x68CD10F06226CaefDc1996282AF8b11e15759008)] = 4300;
322 tokens[address(0x23cDE37A52C9c316b2941644Cf25431AF83B2C5E)] = 11900;
323 tokens[address(0x57Ffa87375932828D40016c8DaE9A081A12E9af0)] = 2200;
324 tokens[address(0x520744A635E930D0d731fb6114dab88037091A1F)] = 5600;
325 tokens[address(0x21950AAaBE932Af13E1b7dF2F7B838D9150289C4)] = 1600;
326 tokens[address(0x17c566E12Ee786c264dc90e057058BDE4EDc71a0)] = 2100;
327 tokens[address(0xF7A3da501EC53f5BF2E7BA7910330bC16f27d901)] = 11400;
328 tokens[address(0xEACB88D78723Cb3544870f53cbBABD3355e2231D)] = 4600;
329 tokens[address(0x14E28A9eF1618Ea4a86A06b42089526CA05b4e93)] = 3900;
330 tokens[address(0x2249d77A6f81fFc04A6f86171cC0eB07ebfC4CED)] = 1600;
331 tokens[address(0x344Af82a1Fb49AFB2e6d7E481Fb32cb2b739d22d)] = 1600;
332 tokens[address(0x45584187b4a88bDE98dcb374F310436E6D63a8e9)] = 1000;
333 tokens[address(0xD240B9ee1365081593C04da6CfC13191c8A0548c)] = 3200;
334 tokens[address(0x34Ba228704864D4627B290edF32486d2DA367Fd1)] = 1600;
335 tokens[address(0xa1435AcfC988489F5f32159901e07eCB5cdBfA45)] = 3400;
336 tokens[address(0xf42671e88257101d41AD302515E710cF23A89907)] = 1900;
337 tokens[address(0xc58C40D3C61cfCFE138eB7CF341533F55ABBF7fC)] = 1200;
338 tokens[address(0xC0eC438f7F6B666a462cC929CEfb03bc4a8e689a)] = 23900;
339 tokens[address(0x54FfC86Af4CfB17fd099C82bB4a5cE8Fa78AFC3d)] = 1400;
340 tokens[address(0x77A13176a13cC9577c081c12b4CB707C118D38Bb)] = 1600;
341 tokens[address(0x57a62c38307F7A1d8a5f2C607Ea02413c07B5EcC)] = 1400;
342 tokens[address(0x963BEd69835425a5c17a73e6130AA8D8F7F7d727)] = 2400;
343 tokens[address(0x74B96DCCA44f3cB6686B2c29EC96BDb537E54510)] = 1400;
344 tokens[address(0xE66F9a2d957b56782f6A80C036f01394551e1778)] = 13500;
345 tokens[address(0xF987941a8A9697DAb01492B15D62c97dCFFE2a2f)] = 1600;
346 tokens[address(0xb9ABBDEe6D9A7Ffd147C3ea38939c63183b9aEd3)] = 13900;
347 tokens[address(0xaA2DD7A80C4b5c8936F799F32a9F151bF7efA654)] = 1600;
348 tokens[address(0xBE73ea87464aD5CDCA3d42fe2617fa86F94D9533)] = 2100;
349 tokens[address(0x6168e8085bCE7267fBc9127b8497Fb40a5b48Dfe)] = 2100;
350 tokens[address(0x780452089042c21f9Ad835976eF5FA6ed3c99fe5)] = 1600;
351 tokens[address(0x3d5e74dEB0624Fe37eBfF8d8c90272Fb5F16f3C6)] = 1400;
352 tokens[address(0xE493A720c6D4F897535F3cE325E7D0b079734260)] = 4300;
353 tokens[address(0xaDa1F8A8a1f09CC4FB954B23Ca2ea6C3caaac95e)] = 8900;
354 tokens[address(0xF1843910b07Aa565e6Dcb95154F14B5e67e621C9)] = 1000;
355 tokens[address(0xA64922AF57b675eF3786BF9AE2B0a5600ddA673E)] = 1200;
356 tokens[address(0xECe17b1FB30F17f43D225e99892173d379A1518a)] = 1900;
357 tokens[address(0x97321F362f9D664ccfa78c761e7d0Ac4C9d0304c)] = 4200;
358 tokens[address(0x994Cf20f5084427d078dBE368eE9C5B6b9eC0755)] = 8400;
359 tokens[address(0x9971d04F33Bc2AD2FAb5f23A87D086DE018b2a3B)] = 1300;
360 tokens[address(0x6D343fBA3b1abC5f729bC14F5C83F0CAC5502342)] = 1200;
361 tokens[address(0x7f4FFCa375aD8c913734D1429Ca2EA904f80fc71)] = 1500;
362 tokens[address(0xab260c2BC5Bdbbf4100358D4Fea347847b9D61b4)] = 3500;
363 tokens[address(0x08F7895752716401999c23EBc18357Ac6dEFf6ed)] = 10400;
364 tokens[address(0x87CebfED9b92f41C68dd5f974AD2AdFa7a47813D)] = 900;
365 tokens[address(0x5d4A9af9DDeb4bc288c180FC7996075Db455d99b)] = 1600;
366 tokens[address(0x9339C376b2f6a816f5a3ED0027b3948c5d316386)] = 1600;
367 tokens[address(0x5379EDa35100e4944149C5852Adc08b360ab37d3)] = 1700;
368 tokens[address(0xe2ce954168541195d258a4Cb0637d8fEe7Be60b1)] = 32700;
369 tokens[address(0x2bA07Ab5648351d846D7b108e11be1f6Ec404099)] = 1600;
370 tokens[address(0xb28a184084971eC50366B47305afa103b9753f4b)] = 14200;
371 tokens[address(0xEF70cC46a9Abc185b3cED2bf99007Bb4f0cE91Ad)] = 1600;
372 tokens[address(0xB1846cE26e2A038AFE1B69eF7b100cfb7859d47C)] = 1200;
373 tokens[address(0x797981A22f3D8521EFA3fE505Cb69E47A36E9BAE)] = 2500;
374 tokens[address(0xfcFC8B51DBd5CB48b4a62ec247E5b219D78AD21D)] = 1700;
375 tokens[address(0xf8ab947c5CE3F3F5994e8e8e5aa7D701ED050f2d)] = 2000;
376 tokens[address(0x5F2EC1B8069BD871B60aD08fB717A69FcF3024b8)] = 3600;
377 tokens[address(0x120E2a1c39d418698D8E12A26F0Dd01304bdd1Ae)] = 1600;
378 tokens[address(0x7563A44dD5d4C22E602BE9851b36aF55a7547d16)] = 2500;
379 tokens[address(0x8A3a772BC27FCb580064D546eD01e61f7e2c4B7e)] = 1400;
380 tokens[address(0x903a2Aa7b6Fdd77B9595184DA8CF59dd11c68aCF)] = 1600;
381 tokens[address(0xc809746d20Ff840a7469fF343C7b6eFafEbE552A)] = 1400;
382 tokens[address(0x53299f326DFced4f9f99c5e5b77BE66D42B1c4Cd)] = 1100;
383 tokens[address(0xb04809441F04b845f3f1c3AB477D769545C50F4f)] = 2200;
384 tokens[address(0xd6aF3630a306388456C7759deF88Ab3c5e1a64aF)] = 2100;
385 tokens[address(0xe5FB492Bc55B5114D6C9D89A93310d2919ce6228)] = 1700;
386 tokens[address(0x715f8D35F9f6a3E0ac56D334343411C1Fa1440a4)] = 2100;
387 tokens[address(0x14d047E9452434c10aA5d619aB1371Cf2457B0e0)] = 1200;
388 tokens[address(0xB6dbd3F6835dd1adfF1dB32f4c46729Eb34Bb548)] = 1900;
389 tokens[address(0x4BDFD5982eE61a9fDAB565FA13ea22Fe72f16eAb)] = 1900;
390 tokens[address(0xD2C9e34a07fDC074B572d6B2CC5c0A264Ea9f1F0)] = 2600;
391 tokens[address(0xB780118A103ED52cA74F02958313F2BaA019d4f9)] = 3300;
392 tokens[address(0x175BCdE6CaC5060B534A3869b6A78A0C13957504)] = 1200;
393 tokens[address(0xdeB46B9160fAEcC3ba685087d6b56CAD60f7b8cE)] = 1600;
394 tokens[address(0x5Bc673937833106b00FCd5df7741ef39d2a49121)] = 1500;
395 tokens[address(0xFaFf103FbD7e44C75bcE019b827a31c53CAD94fc)] = 1200;
396 tokens[address(0x0c745112a5707381d9aF0D8BD9A490e5EcDA60B2)] = 52000;
397 tokens[address(0x05805a663aE51C9759CAde16c59fa783c1852239)] = 1700;
398 tokens[address(0xFff611555912490477349d2B3f4282643888656C)] = 1600;
399 tokens[address(0xeCef3237858FEd095B2F2488DEeF388fab420beE)] = 600;
400 tokens[address(0xcaCa7caF489541791434fCC9cba230C0B7e11CAD)] = 1600;
401 tokens[address(0x147013fb53eadE5F51121fabC7333dB5058a9fD6)] = 1600;
402 tokens[address(0xDD25550d692800B4b17Ce38221bE63E1507296b4)] = 1600;
403 tokens[address(0x289D3c421688D1534d8e80Fd0E3C3514c00dEa65)] = 2100;
404 tokens[address(0xD8d0f2195739fFE38c45f679b65C20DA81719658)] = 2100;
405 tokens[address(0x1a3fb44AEd947487837C08f2602682838768bc16)] = 1200;
406 tokens[address(0xa0f93EF12870A029917AE93884AcC6d935a2a4A0)] = 1600;
407 tokens[address(0x8758197ab1B659d35dDFFe2DA0eD35963Fce8d4a)] = 600;
408 tokens[address(0xcE142871CcE8422b7B2df046b7169E6F82C5A829)] = 53400;
409 tokens[address(0x916383707F0bFbAA8d68146E50829A797D34f10e)] = 1200;
410 tokens[address(0x7A4418cD2D619461F53d72F65c70a29A6a5D6a9b)] = 2100;
411 tokens[address(0x32C235751A2C9C7f472d6eC6068E1608b6a35aD9)] = 600;
412 tokens[address(0x9B205a6458D73591e934a41f21f81B83ddd010CE)] = 1400;
413 tokens[address(0xF59217418f02c5BBEe52734e6B1FE46879d1e8AA)] = 2500;
414 tokens[address(0xC40A0b2418D35B36E241F2555e813ACB6b172DFc)] = 4600;
415 tokens[address(0x120542afEa6F3E649Ec4782444011b9164A97502)] = 4700;
416 tokens[address(0x40a2a8B21c6f6A13476EA14501e5EA66780D3720)] = 3700;
417 tokens[address(0xbaD57334Bd686BA055DaD9063Cf4f6D40414ea2e)] = 2100;
418 tokens[address(0x1259253e0A90A454942F1924Ea16ca449f3bf714)] = 1600;
419 tokens[address(0xedB4dcE561956cA9F588a2668ffc1F24574Bbb31)] = 1600;
420 tokens[address(0xc3b7A1474e6146c0F27B8f8F73d682E1131Cef55)] = 1400;
421 tokens[address(0x2d4298debB0f9EAd6350667850B6bb76FcCafE26)] = 1200;
422 tokens[address(0x34353f65d4E625d356190764397D89188bD69B09)] = 1500;
423 tokens[address(0x020984eC66d672E64cb366285a7ADD76A65D8Eba)] = 24100;
424 tokens[address(0x1d35417Ac16fAcEc1766b951Bb832758Caef6F3c)] = 4200;
425 tokens[address(0x28Fa0e3521CCb4474479d4EfeA43895912ed21e7)] = 1600;
426 tokens[address(0xb0c7E1470E9Af9801c3b49fff94a2390976AbE9f)] = 2300;
427 tokens[address(0xA205CCD6F91eA72DcCFBAbeC5b285FB6822118b1)] = 1600;
428 tokens[address(0x278781A2FFB74c9dc29224bC4B70523b77545c63)] = 600;
429 tokens[address(0x19605FC09ffB842E0756d6bfA3521Df481e422fb)] = 2100;
430 tokens[address(0xFfe55FdACE48C6e7a2939E2EDE0D8A853814ACac)] = 900;
431 tokens[address(0x4ADFFc3c5A3e47104E09E7F00C98727459040446)] = 2100;
432 tokens[address(0xae31168bE5f76463fFb5a72512674e809C5a9822)] = 2100;
433 tokens[address(0x9b65dAd0cdEba4A82bbCCdf72A1D7bf7E4C55F6B)] = 4200;
434 tokens[address(0x5D75eA765186b5cE8Fe4aC440e68d37Ff19944B6)] = 700;
435 tokens[address(0xCd06583715F23340d2b58781B820F005c8A57486)] = 9600;
436 tokens[address(0xE7C81522a0A20a01a45383F3B7e2df884E777D39)] = 1400;
437 tokens[address(0x42af94da5Eb7E3416E7dF3F3FbB6e44351ecfe57)] = 13700;
438 tokens[address(0xdA2C38D482B363D70E995C77FBDE11C032c97BCe)] = 2000;
439 tokens[address(0x14e291DE4D5210c7d9158684471586507905d5B2)] = 2500;
440 tokens[address(0x05105c9FaC9B17f832CC77886a7dC7BE908A354c)] = 1600;
441 tokens[address(0xF907556fE8B43D255Cc68aDaFb746b361C7A8DD5)] = 4600;
442 tokens[address(0xE1C926C2C3634d245F5Bcad11fF08D0902bFE579)] = 1200;
443 tokens[address(0xb34770c1903e2aA6b0FFC320cD7c26c97c9afddc)] = 1500;
444 tokens[address(0xbaF2F9426521C8b4e955DC9e8f888095DD1322B5)] = 4800;
445 tokens[address(0xd9322dE0Ef3f3651cE8ccd509b3a58aB04D3e6F3)] = 1700;
446 tokens[address(0x8CEd8d3eF7d4E0116456cc6c9CE3d2F82b2C81f6)] = 600;
447 tokens[address(0xDf76810EeF6A90F85128a38b74efFB7A2C0b1956)] = 4100;
448 tokens[address(0xA619e5Eb2fAAc9d6EBcaC4fE5387C7dc419Ebe8C)] = 5900;
449 tokens[address(0x7a1aac634a73547320afD03E09571b9c0842A002)] = 11600;
450 tokens[address(0xdA5c5dB1B98676512e44b410dBaE10569a243c80)] = 1700;
451 tokens[address(0x77DCBbA8dfF597b9F21bc443138F925831536Fcd)] = 4100;
452 tokens[address(0x1aE6E1b318584b15679B84340EFad09D9ACdA954)] = 2200;
453 tokens[address(0x93445A1205aB423Ce1d72f7E7c08fD720cf3413C)] = 8400;
454 tokens[address(0xc518e4B67D9360321c2B6a023E57E4A85a0463A6)] = 2600;
455 tokens[address(0x761c95Be69A29b487B2388896FCebb231263f1Ba)] = 1800;
456 tokens[address(0xf572b9aDCe5de63a45aCBc5B317828d5CF4066e6)] = 8500;
457 tokens[address(0x9492D8894C12142cCA8f6752c284c71036B6aCE0)] = 1400;
458 tokens[address(0x2f828e0c48cBee0C36fb743344c6b8d579C6a6e2)] = 2600;
459 tokens[address(0xd2716630d67dce0489aD7A254db4079c7F70fc80)] = 2500;
460 tokens[address(0xb8025B514480a68e5B60741F9B2a3B4302d4cDf5)] = 4100;
461 tokens[address(0x25112a6363D8a75f7325Dcba279b791936d52592)] = 3400;
462 tokens[address(0x5878e7697d45d4AFc10CceDD7a7A89334215AE83)] = 1200;
463 tokens[address(0x26d91d8028130dB3eFAD83Cdb9eCE392F19177ac)] = 3200;
464 tokens[address(0xd1f543544c720417D69c0C8C46f468c357Dc10aB)] = 1400;
465 tokens[address(0x2eEFfb0905b631A3b30b39C4E0B846803ff4AC80)] = 3900;
466 tokens[address(0x6EedF082d9EEB45b7C0fcb640041824C2Dc88cbE)] = 1600;
467 tokens[address(0x25740C74401eAb76b939DcD41d7BC22757bF0862)] = 1900;
468 tokens[address(0xB02848986D468429EAfc9e66bB2c302ebd1CB216)] = 4600;
469 tokens[address(0xd4E49644CA87faCf616a2a3a3784bf35a51aEE0E)] = 4100;
470 tokens[address(0x36e7b69af795A9b563c5987D848c934833375F96)] = 1200;
471 tokens[address(0x25B8165D74192B97a078722f0FA46cf4c8387bBF)] = 3700;
472 tokens[address(0xe247205aC4E448fF05c6f0d536C7309Baf9A1Fc5)] = 2100;
473     }
474     
475     function getTotalPossibleTokens(address _who) public view returns(uint256) {
476         return tokens[_who];
477     }
478 
479     function () public payable {
480         require(msg.value == 0 ether, "Contract do not recieve ether!");
481         require(tokens[msg.sender] > 0, "Tokens must be greater than 0!");
482         
483         uint256 toks = tokens[msg.sender].mul(1000000000000000000);
484         token.transfer(msg.sender, toks);
485         tokens[msg.sender] = tokens[msg.sender].sub(tokens[msg.sender]);
486     }  
487 }