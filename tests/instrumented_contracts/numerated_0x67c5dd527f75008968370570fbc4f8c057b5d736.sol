1 pragma solidity 0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 library SafeMath {
7     function add(uint a, uint b) internal pure returns (uint c) {
8         c = a + b;
9         require(c >= a);
10     }
11     function sub(uint a, uint b) internal pure returns (uint c) {
12         require(b <= a);
13         c = a - b;
14     }
15     function mul(uint a, uint b) internal pure returns (uint c) {
16         c = a * b;
17         require(a == 0 || c / a == b);
18     }
19     function div(uint a, uint b) internal pure returns (uint c) {
20         require(b > 0);
21         c = a / b;
22     }
23 }
24 
25 // ----------------------------------------------------------------------------
26 // ERC Token Standard #20 Interface
27 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
28 // ----------------------------------------------------------------------------
29 contract ERC20Interface {
30     function totalSupply() public view returns (uint);
31     function balanceOf(address tokenOwner) public view returns (uint balance);
32     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
33     function transfer(address to, uint tokens) public returns (bool success);
34     function approve(address spender, uint tokens) public returns (bool success);
35     function transferFrom(address from, address to, uint tokens) public returns (bool success);
36 
37     event Transfer(address indexed from, address indexed to, uint tokens);
38     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
39 }
40 
41 // ----------------------------------------------------------------------------
42 // Owned contract
43 // ----------------------------------------------------------------------------
44 contract Owned {
45     address public owner;
46 
47     constructor() public {
48         owner = msg.sender;
49     }
50 
51     modifier onlyOwner {
52         require(msg.sender == owner);
53         _;
54     }
55 }
56 
57 contract CasperToken is ERC20Interface, Owned {
58     using SafeMath for uint;
59 
60     string public constant name = "Csper Token";
61     string public constant symbol = "CST";
62     uint8 public constant decimals = 18;
63 
64     uint constant public cstToMicro = uint(10) ** decimals;
65 
66     // This constants reflects CST token distribution
67     uint constant public _totalSupply    = 440000000 * cstToMicro;
68     uint constant public preICOSupply    = 13000000 * cstToMicro;
69     uint constant public presaleSupply   = 183574716 * cstToMicro;
70     uint constant public crowdsaleSupply = 19750000 * cstToMicro;
71     uint constant public communitySupply = 66000000 * cstToMicro;
72     uint constant public systemSupply    = 35210341 * cstToMicro;
73     uint constant public investorSupply  = 36714943 * cstToMicro;
74     uint constant public teamSupply      = 66000000 * cstToMicro;
75     uint constant public adviserSupply   = 7000000 * cstToMicro;
76     uint constant public bountySupply    = 8800000 * cstToMicro;
77     uint constant public referralSupply  = 3950000 * cstToMicro;
78 
79     // This variables accumulate amount of sold CST during
80     // presale, crowdsale, or given to investors as bonus.
81     uint public presaleSold = 0;
82     uint public crowdsaleSold = 0;
83     uint public investorGiven = 0;
84 
85     // Amount of ETH received during ICO
86     uint public ethSold = 0;
87 
88     uint constant public softcapUSD = 4500000;
89     uint constant public preicoUSD  = 1040000;
90 
91     // Presale lower bound in dollars.
92     uint constant public crowdsaleMinUSD = cstToMicro * 10 * 100 / 12;
93     uint constant public bonusLevel0 = cstToMicro * 10000 * 100 / 12; // 10000$
94     uint constant public bonusLevel100 = cstToMicro * 100000 * 100 / 12; // 100000$
95 
96     // Tokens are unlocked in 5 stages, by 20% (see doc to checkTransfer)
97     // All dates are stored as timestamps.
98     uint constant public unlockDate1 = 1538179199; // 28.09.2018 23:59:59
99     uint constant public unlockDate2 = 1543622399; // 30.11.2018 23:59:59
100     uint constant public unlockDate3 = 1548979199; // 31.01.2019 23:59:59
101     uint constant public unlockDate4 = 1553903999; // 29.03.2019 23:59:59
102     uint constant public unlockDate5 = 1559347199; // 31.05.2019 23:59:59
103 
104     uint constant public teamUnlock1 = 1549065600; // 2.02.2019 
105     uint constant public teamUnlock2 = 1564704000; // 2.08.2019
106     uint constant public teamUnlock3 = 1580601600; // 2.02.2020
107     uint constant public teamUnlock4 = 1596326400; // 2.08.2020
108 
109     uint constant public teamETHUnlock1 = 1535846400; // 2.09.2018
110     uint constant public teamETHUnlock2 = 1538438400; // 2.10.2018
111     uint constant public teamETHUnlock3 = 1541116800; // 2.11.2018
112 
113     //https://casperproject.atlassian.net/wiki/spaces/PROD/pages/277839878/Smart+contract+ICO
114     // Presale 10.06.2018 - 22.07.2018
115     // Crowd-sale 23.07.2018 - 2.08.2018 (16.08.2018)
116     uint constant public presaleStartTime     = 1528588800;
117     uint constant public crowdsaleStartTime   = 1532304000;
118     uint          public crowdsaleEndTime     = 1533168000;
119     uint constant public crowdsaleHardEndTime = 1534377600;
120     //address constant CsperWallet = 0x6A5e633065475393211aB623286200910F465d02;
121     constructor() public {
122         admin = owner;
123         balances[owner] = _totalSupply;
124         emit Transfer(address(0), owner, _totalSupply);
125     }
126 
127     modifier onlyAdmin {
128         require(msg.sender == admin);
129         _;
130     }
131 
132     modifier onlyOwnerAndDirector {
133         require(msg.sender == owner || msg.sender == director);
134         _;
135     }
136 
137     address admin;
138     function setAdmin(address _newAdmin) public onlyOwnerAndDirector {
139         admin = _newAdmin;
140     }
141 
142     address director;
143     function setDirector(address _newDirector) public onlyOwner {
144         director = _newDirector;
145     }
146 
147     bool assignedPreico = false;
148     /// @notice assignPreicoTokens transfers 10x tokens to pre-ICO participants
149     function assignPreicoTokens() public onlyOwnerAndDirector {
150         require(!assignedPreico);
151         assignedPreico = true;
152 
153         _freezeTransfer(0xb424958766e736827Be5A441bA2A54bEeF54fC7C, 10 * 19514560000000000000000);
154         _freezeTransfer(0xF5dF9C2aAe5118b64Cda30eBb8d85EbE65A03990, 10 * 36084880000000000000000);
155         _freezeTransfer(0x5D8aCe48970dce4bcD7f985eDb24f5459Ef184Ec, 10 * 2492880000000000000000);
156         _freezeTransfer(0xcD6d5b09a34562a1ED7857B19b32bED77417655b, 10 * 1660880000000000000000);
157         _freezeTransfer(0x50f73AC8435E4e500e37FAb8802bcB840bf4b8B8, 10 * 94896880000000000000000);
158         _freezeTransfer(0x65Aa068590216cb088f4da28190d8815C31aB330, 10 * 16075280000000000000000);
159         _freezeTransfer(0x2046838D148196a5117C4026E21C165785bD3982, 10 * 5893680000000000000000);
160         _freezeTransfer(0x458e1f1050C34f5D125437fcEA0Df0aA9212EDa2, 10 * 32772040882120167215360);
161         _freezeTransfer(0x12B687E19Cef53b2A709e9b98C4d1973850cA53F, 10 * 70956080000000000000000);
162         _freezeTransfer(0x1Cf5daAB09155aaC1716Aa92937eC1c6D45720c7, 10 * 3948880000000000000000);
163         _freezeTransfer(0x32fAAdFdC7938E7FbC7386CcF546c5fc382ed094, 10 * 88188880000000000000000);
164         _freezeTransfer(0xC4eA6C0e9d95d957e75D1EB1Fbe15694CD98336c, 10 * 81948880000000000000000);
165         _freezeTransfer(0xB97D3d579d35a479c20D28988A459E3F35692B05, 10 * 121680000000000000000);
166         _freezeTransfer(0x65AD745047633C3402d4BC5382f72EA3A9eCFe47, 10 * 5196880000000000000000);
167         _freezeTransfer(0xd0BEF2Fb95193f429f0075e442938F5d829a33c8, 10 * 223388880000000000000000);
168         _freezeTransfer(0x9Fc87C3d44A6374D48b2786C46204F673b0Ae236, 10 * 28284880000000000000000);
169         _freezeTransfer(0x42C73b8945a82041B06428359a94403a2e882406, 10 * 13080080000000000000000);
170         _freezeTransfer(0xa4c9595b90BBa7B4d805e555E477200C61711F3a, 10 * 6590480000000000000000);
171         _freezeTransfer(0xb93b8ceD7CD86a667E12104831b4d514365F9DF8, 10 * 116358235759665569280);
172         _freezeTransfer(0xa94F999b3f76EB7b2Ba7B17fC37E912Fa2538a87, 10 * 10389600000000000000000);
173         _freezeTransfer(0xD65B9b98ca08024C3c19868d42C88A3E47D67120, 10 * 25892880000000000000000);
174         _freezeTransfer(0x3a978a9Cc36f1FE5Aab6D31E41c08d8380ad0ACB, 10 * 548080000000000000000);
175         _freezeTransfer(0xBD46d909D55d760E2f79C5838c5C42E45c0a853A, 10 * 7526480000000000000000);
176         _freezeTransfer(0xdD9d289d4699fDa518cf91EaFA029710e3Cbb7AA, 10 * 3324880000000000000000);
177         _freezeTransfer(0x8671B362902C3839ae9b4bc099fd24CdeFA026F4, 10 * 21836880000000000000000);
178         _freezeTransfer(0xf3C25Ee648031B28ADEBDD30c91056c2c5cd9C6b, 10 * 132284880000000000000000);
179         _freezeTransfer(0x1A2392fB72255eAe19BB626678125A506a93E363, 10 * 61772880000000000000000);
180         _freezeTransfer(0xCE2cEa425f7635557CFC00E18bc338DdE5B16C9A, 10 * 105360320000000000000000);
181         _freezeTransfer(0x952AD1a2891506AC442D95DA4C0F1AE70A27b677, 10 * 100252880000000000000000);
182         _freezeTransfer(0x5eE1fC4D251143Da96db2a5cD61507f2203bf7b7, 10 * 80492880000000000000000);
183     }
184 
185     bool assignedTeam = false;
186     /// @notice assignTeamTokens assigns tokens to team members
187     /// @notice tokens for team have their own supply
188     function assignTeamTokens() public onlyOwnerAndDirector {
189         require(!assignedTeam);
190         assignedTeam = true;
191 
192         _teamTransfer(0x1E21f744d91994D19f2a61041CD7cCA571185dfc, 13674375 * cstToMicro); // ArK
193         _teamTransfer(0x4CE4Ea57c40bBa26B7b799d5e0b4cd063B034c8A,  9920625 * cstToMicro); // Vi4
194         _teamTransfer(0xdCd8a8e561d23Ca710f23E7612F1D4E0dE9bde83,  1340625 * cstToMicro); // Se4
195         _teamTransfer(0x0dFFA8624A1f512b8dcDE807F8B0Eab68672e5D5, 13406250 * cstToMicro); // AnD
196         _teamTransfer(0xE091180bB0C284AA0Bd15C6888A41aba45c54AF0, 13138125 * cstToMicro); // VlM
197         _teamTransfer(0xcdB7A51bA9af93a7BFfe08a31E4C6c5f9068A051,  3960000 * cstToMicro); // NuT
198         _teamTransfer(0x57Bd10E12f789B74071d62550DaeB3765Ad83834,  3960000 * cstToMicro); // AlK
199         _teamTransfer(0xEE74922eaF503463a8b20aFaD83d42F28D59f45d,  3960000 * cstToMicro); // StK
200         _teamTransfer(0x58681a49A6f9D61eB368241a336628781afD5f87,  1320000 * cstToMicro); // DeP
201 
202         _teamTransfer(0x3C4662b4677dC81f16Bf3c823A7E6CE1fF7e94d7,  80000 * cstToMicro); // YuM
203         _teamTransfer(0x041A1e96E0C9d3957613071c104E44a9c9d43996, 150000 * cstToMicro); // IgK
204         _teamTransfer(0xD63d63D2ADAF87B0Edc38218b0a2D27FD909d8B1, 100000 * cstToMicro); // SeT
205         _teamTransfer(0xd0d49Da78BbCBb416152dC41cc7acAb559Fb8275,  80000 * cstToMicro); // ArM
206         _teamTransfer(0x75FdfAc64c27f5B5f0823863Fe0f2ddc660A376F, 100000 * cstToMicro); // Lera
207         _teamTransfer(0xb66AFf323d97EF52192F170fF0F16D0a05Ebe56C,  60000 * cstToMicro); // SaBuh
208         _teamTransfer(0xec6234E34477f7A19cD3D67401003675522a4Fad,  60000 * cstToMicro); // SaV
209         _teamTransfer(0x1be50e8337F99983ECd4A4b15a74a5a795B73dF9,  40000 * cstToMicro); // Olga
210         _teamTransfer(0x4c14DB011065e72C6E839bd826d101Ec09d3C530, 833000 * cstToMicro); // VaB
211         _teamTransfer(0x7891C07b20fFf1918fAD43CF6fc7E3f83900f06d,  50000 * cstToMicro); // Artur
212         _teamTransfer(0x27996b3c1EcF2e7cbc5f31dE7Bca17EFCb398617, 150000 * cstToMicro); // EvS
213     }
214 
215     /// @nptice kycPassed is executed by backend and tells SC
216     /// that particular client has passed KYC
217     mapping(address => bool) public kyc;
218     mapping(address => address) public referral;
219     function kycPassed(address _mem, address _ref) public onlyAdmin {
220         kyc[_mem] = true;
221         if (_ref == richardAddr || _ref == wuguAddr) {
222             referral[_mem] = _ref;
223         }
224     }
225 
226     // mappings for implementing ERC20
227     mapping(address => uint) balances;
228     mapping(address => mapping(address => uint)) allowed;
229 
230     // mapping for implementing unlock mechanic
231     mapping(address => uint) freezed;
232     mapping(address => uint) teamFreezed;
233 
234     // ERC20 standard functions
235     function totalSupply() public view returns (uint) {
236         return _totalSupply;
237     }
238     function balanceOf(address tokenOwner) public view returns (uint balance) {
239         return balances[tokenOwner];
240     }
241     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
242         return allowed[tokenOwner][spender];
243     }
244 
245     function _transfer(address _from, address _to, uint _tokens) private {
246         balances[_from] = balances[_from].sub(_tokens);
247         balances[_to] = balances[_to].add(_tokens);
248         emit Transfer(_from, _to, _tokens);
249     }
250     
251     function transfer(address _to, uint _tokens) public returns (bool success) {
252         checkTransfer(msg.sender, _tokens);
253         _transfer(msg.sender, _to, _tokens);
254         return true;
255     }
256 
257     function approve(address spender, uint tokens) public returns (bool success) {
258         allowed[msg.sender][spender] = tokens;
259         emit Approval(msg.sender, spender, tokens);
260         return true;
261     }
262     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
263         checkTransfer(from, tokens);
264         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
265         _transfer(from, to, tokens);
266         return true;
267     }
268 
269     /// @notice checkTransfer ensures that `from` can send only unlocked tokens
270     /// @notice this function is called for every transfer
271     /// We unlock PURCHASED and BONUS tokens in 5 stages:
272     /// after 28.09.2018 20% are unlocked
273     /// after 30.11.2018 40% are unlocked
274     /// after 31.01.2019 60% are unlocked
275     /// after 29.03.2019 80% are unlocked
276     /// after 31.05.2019 100% are unlocked
277     function checkTransfer(address from, uint tokens) public view {
278         uint newBalance = balances[from].sub(tokens);
279         uint total = 0;
280         if (now < unlockDate5) {
281             require(now >= unlockDate1);
282             uint frzdPercent = 0;
283             if (now < unlockDate2) {
284                 frzdPercent = 80;
285             } else if (now < unlockDate3) {
286                 frzdPercent = 60;
287             } else if (now < unlockDate4) {
288                 frzdPercent = 40;
289             } else {
290                 frzdPercent = 20;
291             }
292             total = freezed[from].mul(frzdPercent).div(100);
293             require(newBalance >= total);
294         }
295         
296         if (now < teamUnlock4 && teamFreezed[from] > 0) {
297             uint p = 0;
298             if (now < teamUnlock1) {
299                 p = 100;
300             } else if (now < teamUnlock2) {
301                 p = 75;
302             } else if (now < teamUnlock3) {
303                 p = 50;
304             } else if (now < teamUnlock4) {
305                 p = 25;
306             }
307             total = total.add(teamFreezed[from].mul(p).div(100));
308             require(newBalance >= total);
309         }
310     }
311 
312     /// @return ($ received, ETH received, CST sold)
313     function ICOStatus() public view returns (uint usd, uint eth, uint cst) {
314         usd = presaleSold.mul(12).div(10**20) + crowdsaleSold.mul(16).div(10**20);
315         usd = usd.add(preicoUSD); // pre-ico tokens
316 
317         return (usd, ethSold + preicoUSD.mul(10**8).div(ethRate), presaleSold + crowdsaleSold);
318     }
319 
320     function checkICOStatus() public view returns(bool) {
321         uint eth;
322         uint cst;
323 
324         (, eth, cst) = ICOStatus();
325 
326         uint dollarsRecvd = eth.mul(ethRate).div(10**8);
327 
328         // 26 228 800$
329         return dollarsRecvd >= 25228966 || (cst == presaleSupply + crowdsaleSupply) || now > crowdsaleEndTime;
330     }
331 
332     bool icoClosed = false;
333     function closeICO() public onlyOwner {
334         require(!icoClosed);
335         icoClosed = checkICOStatus();
336     }
337 
338     /// @notice by agreement, we can transfer $4.8M from bank
339     /// after softcap is reached.
340     /// @param _to wallet to send CST to
341     /// @param  _usd amount of dollars which is withdrawn
342     uint bonusTransferred = 0;
343     uint constant maxUSD = 4800000;
344     function transferBonus(address _to, uint _usd) public onlyOwner {
345         bonusTransferred = bonusTransferred.add(_usd);
346         require(bonusTransferred <= maxUSD);
347 
348         uint cst = _usd.mul(100).mul(cstToMicro).div(12); // presale tariff
349         presaleSold = presaleSold.add(cst);
350         require(presaleSold <= presaleSupply);
351         ethSold = ethSold.add(_usd.mul(10**8).div(ethRate));
352 
353         _freezeTransfer(_to, cst);
354     }
355 
356     /// @notice extend crowdsale for 2 weeks
357     function prolongCrowdsale() public onlyOwnerAndDirector {
358         require(now < crowdsaleEndTime);
359         crowdsaleEndTime = crowdsaleHardEndTime;
360     }
361 
362     // 100 000 000 Ether in dollars
363     uint public ethRate = 0;
364     uint public ethRateMax = 0;
365     uint public ethLastUpdate = 0;
366     function setETHRate(uint _rate) public onlyAdmin {
367         require(ethRateMax == 0 || _rate < ethRateMax);
368         ethRate = _rate;
369         ethLastUpdate = now;
370     }
371 
372     // 100 000 000 BTC in dollars
373     uint public btcRate = 0;
374     uint public btcRateMax = 0;
375     uint public btcLastUpdate;
376     function setBTCRate(uint _rate) public onlyAdmin {
377         require(btcRateMax == 0 || _rate < btcRateMax);
378         btcRate = _rate;
379         btcLastUpdate = now;
380     }
381 
382     /// @notice setMaxRate sets max rate for both BTC/ETH to soften
383     /// negative consequences in case our backend gots hacked.
384     function setMaxRate(uint ethMax, uint btcMax) public onlyOwnerAndDirector {
385         ethRateMax = ethMax;
386         btcRateMax = btcMax;
387     }
388 
389     /// @notice _sellPresale checks CST purchases during crowdsale
390     function _sellPresale(uint cst) private {
391         require(cst >= bonusLevel0.mul(9950).div(10000));
392         presaleSold = presaleSold.add(cst);
393         require(presaleSold <= presaleSupply);
394     }
395 
396     /// @notice _sellCrowd checks CST purchases during crowdsale
397     function _sellCrowd(uint cst, address _to) private {
398         require(cst >= crowdsaleMinUSD);
399 
400         if (crowdsaleSold.add(cst) <= crowdsaleSupply) {
401             crowdsaleSold = crowdsaleSold.add(cst);
402         } else {
403             presaleSold = presaleSold.add(crowdsaleSold).add(cst).sub(crowdsaleSupply);
404             require(presaleSold <= presaleSupply);
405             crowdsaleSold = crowdsaleSupply;
406         }
407 
408         if (now < crowdsaleStartTime + 3 days) {
409             if (whitemap[_to] >= cst) {
410                 whitemap[_to] -= cst;
411                 whitelistTokens -= cst;
412             } else {
413                 require(crowdsaleSupply.add(presaleSupply).sub(presaleSold) >= crowdsaleSold.add(whitelistTokens));
414             }
415         }
416     }
417 
418     /// @notice addInvestorBonusInPercent is used for sending bonuses for big investors in %
419     function addInvestorBonusInPercent(address _to, uint8 p) public onlyOwner {
420         require(p > 0 && p <= 5);
421         uint bonus = balances[_to].mul(p).div(100);
422 
423         investorGiven = investorGiven.add(bonus);
424         require(investorGiven <= investorSupply);
425 
426         _freezeTransfer(_to, bonus);
427     }
428  
429     /// @notice addInvestorBonusInTokens is used for sending bonuses for big investors in tokens
430     function addInvestorBonusInTokens(address _to, uint tokens) public onlyOwner {
431         _freezeTransfer(_to, tokens);
432         
433         investorGiven = investorGiven.add(tokens);
434         require(investorGiven <= investorSupply);
435     }
436 
437     function () payable public {
438         purchaseWithETH(msg.sender);
439     }
440 
441     /// @notice _freezeTranfer perform actual tokens transfer which
442     /// will be freezed (see also checkTransfer() )
443     function _freezeTransfer(address _to, uint cst) private {
444         _transfer(owner, _to, cst);
445         freezed[_to] = freezed[_to].add(cst);
446     }
447 
448     /// @notice _freezeTranfer perform actual tokens transfer which
449     /// will be freezed (see also checkTransfer() )
450     function _teamTransfer(address _to, uint cst) private {
451         _transfer(owner, _to, cst);
452         teamFreezed[_to] = teamFreezed[_to].add(cst);
453     }
454 
455     address public constant wuguAddr = 0x096ad02a48338CB9eA967a96062842891D195Af5;
456     address public constant richardAddr = 0x411fB4D77EDc659e9838C21be72f55CC304C0cB8;
457     mapping(address => address[]) promoterClients;
458     mapping(address => mapping(address => uint)) promoterBonus;
459 
460     /// @notice withdrawPromoter transfers back to promoter 
461     /// all bonuses accumulated to current moment
462     function withdrawPromoter() public {
463         address _to = msg.sender;
464         require(_to == wuguAddr || _to == richardAddr);
465 
466         uint usd;
467         (usd,,) = ICOStatus();
468 
469         // USD received - 5% must be more than softcap
470         require(usd.mul(95).div(100) >= softcapUSD);
471 
472         uint bonus = 0;
473         address[] memory clients = promoterClients[_to];
474         for(uint i = 0; i < clients.length; i++) {
475             if (kyc[clients[i]]) {
476                 uint num = promoterBonus[_to][clients[i]];
477                 delete promoterBonus[_to][clients[i]];
478                 bonus += num;
479             }
480         }
481         
482         _to.transfer(bonus);
483     }
484 
485     /// @notice cashBack will be used in case of failed ICO
486     /// All partitipants can receive their ETH back
487     function cashBack(address _to) public {
488         uint usd;
489         (usd,,) = ICOStatus();
490 
491         // ICO fails if crowd-sale is ended and we have not yet reached soft-cap
492         require(now > crowdsaleEndTime && usd < softcapUSD);
493         require(ethSent[_to] > 0);
494 
495         delete ethSent[_to];
496 
497         _to.transfer(ethSent[_to]);
498     }
499 
500     /// @notice stores amount of ETH received by SC
501     mapping(address => uint) ethSent;
502 
503     function purchaseWithETH(address _to) payable public {
504         purchaseWithPromoter(_to, referral[msg.sender]);
505     }
506 
507     /// @notice purchases tokens, which a send to `_to` with 5% returned to `_ref`
508     /// @notice 5% return must work only on crowdsale
509     function purchaseWithPromoter(address _to, address _ref) payable public {
510         require(now >= presaleStartTime && now <= crowdsaleEndTime);
511 
512         require(!icoClosed);
513     
514         uint _wei = msg.value;
515         uint cst;
516 
517         ethSent[msg.sender] = ethSent[msg.sender].add(_wei);
518         ethSold = ethSold.add(_wei);
519 
520         // accept payment on presale only if it is more than 9997$
521         // actual check is performed in _sellPresale
522         if (now < crowdsaleStartTime || approvedInvestors[msg.sender]) {
523             require(kyc[msg.sender]);
524             cst = _wei.mul(ethRate).div(12000000); // 1 CST = 0.12 $ on presale
525 
526             require(now < crowdsaleStartTime || cst >= bonusLevel100);
527 
528             _sellPresale(cst);
529 
530             /// we have only 2 recognized promoters
531             if (_ref == wuguAddr || _ref == richardAddr) {
532                 promoterClients[_ref].push(_to);
533                 promoterBonus[_ref][_to] = _wei.mul(5).div(100);
534             }
535         } else {
536             cst = _wei.mul(ethRate).div(16000000); // 1 CST = 0.16 $ on crowd-sale
537             _sellCrowd(cst, _to);
538         }
539 
540         _freezeTransfer(_to, cst);
541     }
542 
543     /// @notice purchaseWithBTC is called from backend, where we convert
544     /// BTC to ETH, and then assign tokens to purchaser, using BTC / $ exchange rate.
545     function purchaseWithBTC(address _to, uint _satoshi, uint _wei) public onlyAdmin {
546         require(now >= presaleStartTime && now <= crowdsaleEndTime);
547 
548         require(!icoClosed);
549 
550         ethSold = ethSold.add(_wei);
551 
552         uint cst;
553         // accept payment on presale only if it is more than 9997$
554         // actual check is performed in _sellPresale
555         if (now < crowdsaleStartTime || approvedInvestors[msg.sender]) {
556             require(kyc[msg.sender]);
557             cst = _satoshi.mul(btcRate.mul(10000)).div(12); // 1 CST = 0.12 $ on presale
558 
559             require(now < crowdsaleStartTime || cst >= bonusLevel100);
560 
561             _sellPresale(cst);
562         } else {
563             cst = _satoshi.mul(btcRate.mul(10000)).div(16); // 1 CST = 0.16 $ on presale
564             _sellCrowd(cst, _to);
565         }
566 
567         _freezeTransfer(_to, cst);
568     }
569 
570     /// @notice withdrawFunds is called to send team bonuses after
571     /// then end of the ICO
572     bool withdrawCalled = false;
573     function withdrawFunds() public onlyOwner {
574         require(icoClosed && now >= teamETHUnlock1);
575 
576         require(!withdrawCalled);
577         withdrawCalled = true;
578 
579         uint eth;
580         (,eth,) = ICOStatus();
581 
582         // pre-ico tokens are not in ethSold
583         uint minus = bonusTransferred.mul(10**8).div(ethRate);
584         uint team = ethSold.sub(minus);
585 
586         team = team.mul(15).div(100);
587 
588         uint ownerETH = 0;
589         uint teamETH = 0;
590         if (address(this).balance >= team) {
591             teamETH = team;
592             ownerETH = address(this).balance.sub(teamETH);
593         } else {
594             teamETH = address(this).balance;
595         }
596 
597         teamETH1 = teamETH.div(3);
598         teamETH2 = teamETH.div(3);
599         teamETH3 = teamETH.sub(teamETH1).sub(teamETH2);
600 
601         // TODO multisig
602         address(0x741A26104530998F625D15cbb9D58b01811d2CA7).transfer(ownerETH);
603     }
604 
605     uint teamETH1 = 0;
606     uint teamETH2 = 0;
607     uint teamETH3 = 0;
608     function withdrawTeam() public {
609         require(now >= teamETHUnlock1);
610 
611         uint amount = 0;
612         if (now < teamETHUnlock2) {
613             amount = teamETH1;
614             teamETH1 = 0;
615         } else if (now < teamETHUnlock3) {
616             amount = teamETH1 + teamETH2;
617             teamETH1 = 0;
618             teamETH2 = 0;
619         } else {
620             amount = teamETH1 + teamETH2 + teamETH3;
621             teamETH1 = 0;
622             teamETH2 = 0;
623             teamETH3 = 0;
624         }
625 
626         address(0xcdB7A51bA9af93a7BFfe08a31E4C6c5f9068A051).transfer(amount.mul(6).div(100)); // NuT
627         address(0x57Bd10E12f789B74071d62550DaeB3765Ad83834).transfer(amount.mul(6).div(100)); // AlK
628         address(0xEE74922eaF503463a8b20aFaD83d42F28D59f45d).transfer(amount.mul(6).div(100)); // StK
629         address(0x58681a49A6f9D61eB368241a336628781afD5f87).transfer(amount.mul(2).div(100)); // DeP
630         address(0x4c14DB011065e72C6E839bd826d101Ec09d3C530).transfer(amount.mul(2).div(100)); // VaB
631 
632         amount = amount.mul(78).div(100);
633 
634         address(0x1E21f744d91994D19f2a61041CD7cCA571185dfc).transfer(amount.mul(uint(255).mul(100).div(96)).div(1000)); // ArK
635         address(0x4CE4Ea57c40bBa26B7b799d5e0b4cd063B034c8A).transfer(amount.mul(uint(185).mul(100).div(96)).div(1000)); // ViT
636         address(0xdCd8a8e561d23Ca710f23E7612F1D4E0dE9bde83).transfer(amount.mul(uint(25).mul(100).div(96)).div(1000));  // SeT
637         address(0x0dFFA8624A1f512b8dcDE807F8B0Eab68672e5D5).transfer(amount.mul(uint(250).mul(100).div(96)).div(1000)); // AnD
638         address(0xE091180bB0C284AA0Bd15C6888A41aba45c54AF0).transfer(amount.mul(uint(245).mul(100).div(96)).div(1000)); // VlM
639     }
640 
641     /// @notice doAirdrop is called when we launch airdrop.
642     /// @notice airdrop tokens has their own supply.
643     uint dropped = 0;
644     function doAirdrop(address[] members, uint[] tokens) public onlyOwnerAndDirector {
645         require(members.length == tokens.length);
646     
647         for(uint i = 0; i < members.length; i++) {
648             _freezeTransfer(members[i], tokens[i]);
649             dropped = dropped.add(tokens[i]);
650         }
651         require(dropped <= bountySupply);
652     }
653 
654     mapping(address => uint) public whitemap;
655     uint public whitelistTokens = 0;
656     /// @notice addWhitelistMember is used to whitelist participant.
657     /// This means, that for the first 3 days of crowd-sale `_tokens` CST 
658     /// will be reserved for him.
659     function addWhitelistMember(address[] _mem, uint[] _tokens) public onlyAdmin {
660         require(_mem.length == _tokens.length);
661         for(uint i = 0; i < _mem.length; i++) {
662             whitelistTokens = whitelistTokens.sub(whitemap[_mem[i]]).add(_tokens[i]);
663             whitemap[_mem[i]] = _tokens[i];
664         }
665     }
666 
667     uint public adviserSold = 0;
668     /// @notice transferAdviser is called to send tokens to advisers.
669     /// @notice adviser tokens have their own supply
670     function transferAdviser(address[] _adv, uint[] _tokens) public onlyOwnerAndDirector {
671         require(_adv.length == _tokens.length);
672         for (uint i = 0; i < _adv.length; i++) {
673             adviserSold = adviserSold.add(_tokens[i]);
674             _freezeTransfer(_adv[i], _tokens[i]);
675         }
676         require(adviserSold <= adviserSupply);
677     }
678 
679     mapping(address => bool) approvedInvestors;
680     function approveInvestor(address _addr) public onlyOwner {
681         approvedInvestors[_addr] = true;
682     }
683 }