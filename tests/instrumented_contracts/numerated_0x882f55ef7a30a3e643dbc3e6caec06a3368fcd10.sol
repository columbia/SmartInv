1 pragma solidity ^0.4.24;
2 
3 contract Ownable {}
4 contract AddressesFilterFeature is Ownable {}
5 contract ERC20Basic {}
6 contract BasicToken is ERC20Basic {}
7 contract ERC20 {}
8 contract StandardToken is ERC20, BasicToken {}
9 contract MintableToken is AddressesFilterFeature, StandardToken {}
10 
11 contract Token is MintableToken {
12   function mint(address, uint256) public returns (bool);
13 }
14 
15 contract SecondBountyWPTpayout_part1 {
16   //storage
17   address public owner;
18   Token public company_token;
19   address[] public addressOfBountyMembers;
20   mapping(address => uint256) bountyMembersAmounts;
21   uint currentBatch;
22   uint addrPerStep;
23 
24   //modifiers
25   modifier onlyOwner
26   {
27     require(owner == msg.sender);
28     _;
29   }
30   
31   
32   //Events
33   event Transfer(address indexed to, uint indexed value);
34   event OwnerChanged(address indexed owner);
35 
36 
37   //constructor
38   constructor (Token _company_token) public {
39     owner = msg.sender;
40     company_token = _company_token;
41     currentBatch = 0;
42     addrPerStep = 20;
43     setBountyAddresses();
44     setBountyAmounts();
45   }
46 
47 
48   /// @dev Fallback function: don't accept ETH
49   function()
50     public
51     payable
52   {
53     revert();
54   }
55 
56 
57   function setOwner(address _owner) 
58     public 
59     onlyOwner 
60   {
61     require(_owner != 0);
62     
63     owner = _owner;
64     emit OwnerChanged(owner);
65   }
66   
67   function makePayout() public onlyOwner {
68     uint startIndex = currentBatch * addrPerStep;
69     uint endIndex = (currentBatch + 1 ) * addrPerStep;
70     for (uint i = startIndex; (i < endIndex && i < addressOfBountyMembers.length); i++)
71     {
72       company_token.mint(addressOfBountyMembers[i], bountyMembersAmounts[addressOfBountyMembers[i]]);
73     }
74     currentBatch++;
75   }
76 
77   function setBountyAddresses() internal {
78     addressOfBountyMembers.push(0x0003b04850e595c8068d703fd17085eb0dc14589);
79     addressOfBountyMembers.push(0x004D9C456b5A8f3AD9ff1F524e416663040c995A);
80     addressOfBountyMembers.push(0x01139e28b2a050e0E6Bdb3b86cd022DF86229493);
81     addressOfBountyMembers.push(0x0187A422b4faD439Fbfcf20f21F32159fd2a4f97);
82     addressOfBountyMembers.push(0x02286c00c0a0412ced30b267546e75faf3610c67);
83     addressOfBountyMembers.push(0x03103Dc3704B1BCE98d9B0FD771e08c546940Ac3);
84     addressOfBountyMembers.push(0x05c85d4875A57eB216FEb706bEe457d8BFF5342b);
85     addressOfBountyMembers.push(0x06136C784a19da76b61719FFEbD83fd66C356443);
86     addressOfBountyMembers.push(0x06604091b3ed6228295d3F8643178256AD7064e7);
87     addressOfBountyMembers.push(0x066717Fe835a81FEC0DCB2262Aa3929fC34eBD48);
88     addressOfBountyMembers.push(0x07D67c25B39AE55A0ea116d4020c0263cf0B8bc2);
89     addressOfBountyMembers.push(0x0832c548114c2B9B3cdf04b3B466e8c71F2f3Dd0);
90     addressOfBountyMembers.push(0x0b9ac492a2fDcf27f4287502199694BbABcDf230);
91     addressOfBountyMembers.push(0x0Bc0ECCdF94C99F80e5a4908Dae8404D1Ff0b172);
92     addressOfBountyMembers.push(0x0D268b405A4aB54bAFE785D7735373C13b2118d1);
93     addressOfBountyMembers.push(0x0d2973098B21B626dFB3141178FA70f2929d745c);
94     addressOfBountyMembers.push(0x0d681d40eAa80B213E0f60d305aC1A8b71C5614E);
95     addressOfBountyMembers.push(0x0e2d1073f08b51b17f1a86b36f939a84d484e2e3);
96     addressOfBountyMembers.push(0x0f2922D94a663074D7Ce4Fa86cB37E4F7D0b6D69);
97     addressOfBountyMembers.push(0x0f2Bf92c30F9202f473c90eA15Fc6113A7cafD04);
98     addressOfBountyMembers.push(0x0FB9C104C7dc61CBc5fDe6De7E07e2b5A851a09a);
99     addressOfBountyMembers.push(0x10D370a992385028230AfDAA71f368A9856b2fE2);
100     addressOfBountyMembers.push(0x1293AAD8357Ed922632419b8B02EC13013b41DC1);
101     addressOfBountyMembers.push(0x14Ec0A3E8be71443E7bC3e801f9aCe758E973A16);
102     addressOfBountyMembers.push(0x1514Cd1d63d304D40574Fc33a61E8A2a202c1EeB);
103     addressOfBountyMembers.push(0x1591C0d65168C3214e8c7b1cA3887cbbEC05e1d7);
104     addressOfBountyMembers.push(0x1608cFee55beAD1fe9405d18260690249196BB37);
105     addressOfBountyMembers.push(0x160e27387Db02A92d0BabAdE78b2Dc9aDea235d7);
106     addressOfBountyMembers.push(0x1657d0411318F4f477BA95e4436ff8b95DdBC5C1);
107     addressOfBountyMembers.push(0x173a3df49a4e00c43febf955124b058c947cdbed);
108     addressOfBountyMembers.push(0x18f76Ea4e6B3c67c440F82c18714143952d5A487);
109     addressOfBountyMembers.push(0x196df9e60D5fB266e2E3Ecc424339E4B74E5049f);
110     addressOfBountyMembers.push(0x1A8a06eaC94DBF7eb30fe6780A6404c33938750E);
111     addressOfBountyMembers.push(0x1c52C56439a7F8690C4D6a0225aE5B24D83013cA);
112     addressOfBountyMembers.push(0x1F186a132F280c7cD2B11b09448863931ADED4e0);
113     addressOfBountyMembers.push(0x1Fde313CF9415CeeEd489DCeC607b6316fF16d65);
114     addressOfBountyMembers.push(0x2010d100ddebff781130d0e046936a3ee98727f1);
115     addressOfBountyMembers.push(0x2074689c9B27472887828c2650313F184a55Ed8c);
116     addressOfBountyMembers.push(0x207dF9263Ffd9Bd1C785D760C277B8aDc3Bb538D);
117     addressOfBountyMembers.push(0x20B8989E89B9EF181c7B764c2efe95F48289D7aa);
118     addressOfBountyMembers.push(0x220981B55fFF489948e2F6A3E419ef37faDf9B83);
119     addressOfBountyMembers.push(0x24d9f17d7d0CC8DAA7A889c4baFdEf55B73e3C8e);
120     addressOfBountyMembers.push(0x27457e296214F60b3Dc04e4F4b9e62f9EFba6623);
121     addressOfBountyMembers.push(0x2B7fa6C81a759B4F75a8Da54C771bBCbfD6D6eFe);
122     addressOfBountyMembers.push(0x2Ee4840fF7baAc2f59E39cfCD91EC4443c2BC722);
123     addressOfBountyMembers.push(0x2F52EF8F73Bd5b5596f3270c79D25696AAC3DC79);
124     addressOfBountyMembers.push(0x2F96c2F5183c1a4D1AB2da19E3595F909e602aBb);
125     addressOfBountyMembers.push(0x315b476e3068Cdad5095370Bd9002aa2E5E9D801);
126     addressOfBountyMembers.push(0x319C9f308E5B8069b4cDAA6F6d64dF9e56780Bbc);
127     addressOfBountyMembers.push(0x3210C023B44B33FeD106A6c9E762596D54400f2A);
128     addressOfBountyMembers.push(0x3219D1AA165E46Fbd5dA976a358dC2052FB142a8);
129     addressOfBountyMembers.push(0x32C235751A2C9C7f472d6eC6068E1608b6a35aD9);
130     addressOfBountyMembers.push(0x345F4e88905cfA1605b5f56167aF7D0Caa59AE74);
131     addressOfBountyMembers.push(0x34f420C3d8FfB21930Bf60Ea7723e327Bb20393E);
132     addressOfBountyMembers.push(0x3679ea85968df04bebd6c69e1fcb21d7095a3c15);
133     addressOfBountyMembers.push(0x36A3A19b64b795a3572Ad89b82502D6c856d7000);
134     addressOfBountyMembers.push(0x36d48C3D1340C46996BC2Ca2A2b9614230429B6D);
135     addressOfBountyMembers.push(0x381AD376e361cF663b077E40D4aa30B412C8BBF8);
136     addressOfBountyMembers.push(0x38f6951095f324a9afC6da259A3fed5445A3Eed4);
137     addressOfBountyMembers.push(0x3a28a66D41a70db4bCE133b47315041c1B078d1A);
138     addressOfBountyMembers.push(0x3A3379a90Cd4805eF37E839BD18C96A21Fb6D167);
139     addressOfBountyMembers.push(0x3a3531Be01950b1AfD3b248fd5716081a76ca611);
140     addressOfBountyMembers.push(0x3b09F73927eAd9480D19024776E3D1189a76a261);
141     addressOfBountyMembers.push(0x3bDbDc1Cd6aaa1f26B74ad678b7CB5FDf6E99956);
142     addressOfBountyMembers.push(0x3c7Bb8F3A697C09059EC64140Eb1E341a015F0A2);
143     addressOfBountyMembers.push(0x3D42b248F9ba14366943d1336380C343ceA3d400);
144     addressOfBountyMembers.push(0x3d841A6a31450DC32359d6a6cb91eB0b68b543b9);
145     addressOfBountyMembers.push(0x3D8D4105D805D65eEA7F7d585A181c1E9f6F122F);
146     addressOfBountyMembers.push(0x3df08f4a0d59553e5bcba1d0c53aec0d6ae6ec56);
147     addressOfBountyMembers.push(0x3EE7FF5cd8D3d4b27fead92e8f859debBd578e4c);
148     addressOfBountyMembers.push(0x3F2Da3f89Db799125Db9639DE72a4209Cf1c40Ea);
149     addressOfBountyMembers.push(0x3FDb9BBB1D6f9ac12d091DC0907dFdEFd391D0D7);
150     addressOfBountyMembers.push(0x4006b0Eba9305ffD8ADFA1c00Fc6D8958b5F1D23);
151     addressOfBountyMembers.push(0x428afff243967aeccec8c2ad60a44b294f0a9326);
152     addressOfBountyMembers.push(0x429c747c294B82027bDc62dE26faA8A6D10D9E19);
153     addressOfBountyMembers.push(0x4312006E30A82664F5b7EF51B2cE5c864F54cb1f);
154     addressOfBountyMembers.push(0x43a81239a7dc180dec1ced577509c97081a3de26);
155     addressOfBountyMembers.push(0x43cd2Ca403EB03A4A3288c3162c458d099a7038E);
156     addressOfBountyMembers.push(0x4524E960BE984eD3C20ACF66642693b8d87BB2E3);
157     addressOfBountyMembers.push(0x460BAA28e768d0C9D1BFc885ad91B253C3373048);
158     addressOfBountyMembers.push(0x46115812Fd32D98e349A3C8C5617DfC8922d1553);
159     addressOfBountyMembers.push(0x462f5Ea4f1C6b83c40Ed3E923a7ef0f902eCca63);
160     addressOfBountyMembers.push(0x49B175691322bD0b79526ca620d21A650789AfeA);
161     addressOfBountyMembers.push(0x49f4B1EAC2a0FeD5a7E58CEf8af576C77495d6bf);
162     addressOfBountyMembers.push(0x4a73D6ab83926E2b76eb2aAFdc5923042BE711fe);
163     addressOfBountyMembers.push(0x4AB9a9Bb91f045152Ba867489A14B54eb5f9bE8f);
164     addressOfBountyMembers.push(0x4BD50151918c18D8864a0518eC553b6392C4E099);
165     addressOfBountyMembers.push(0x4BDD83db1eBf11a4D342bD5AC6e5e4d4d589981f);
166     addressOfBountyMembers.push(0x4cd8bF0abC384185Aba223a8ddD5bf5b8a055a31);
167     addressOfBountyMembers.push(0x4D2CA39C850619bB9a6D78396bBeD7Ba152DeE7f);
168     addressOfBountyMembers.push(0x4EeCcAAAe00d3E9329476e6e43d40E5895ec8497);
169     addressOfBountyMembers.push(0x4F2dED30C27C4A7926B34c697Edd726aE379c3cE);
170     addressOfBountyMembers.push(0x4fBC0d16dAa175B11cBcB6687fC423D0F94f60a5);
171     addressOfBountyMembers.push(0x519abedcaecb4887bda17f9174d1a737ca34695b);
172     addressOfBountyMembers.push(0x522aB87522A15A7004DFaa4b358d4f2c8b9f2fAE);
173     addressOfBountyMembers.push(0x528619Ca62dD1a65D103aeb2301bfC1B2e9582f2);
174     addressOfBountyMembers.push(0x52F916cD4C0d668a14B281a653057FD857796A89);
175     addressOfBountyMembers.push(0x542963aB9b1537A0e601B64Be86807b435F8b17b);
176     addressOfBountyMembers.push(0x547134707ee75D52DFF8Fc6de3717053328E96dB);
177     addressOfBountyMembers.push(0x555d181c062C64CCcF1d61C22bCD72f0796Fa2E4);
178     addressOfBountyMembers.push(0x559e557411523b8420C9d254C84fa350688D1999);
179   }
180 
181   function setBountyAmounts() internal { 
182     bountyMembersAmounts[0x0003b04850e595c8068d703fd17085eb0dc14589] =    16000000000000000000;
183     bountyMembersAmounts[0x004D9C456b5A8f3AD9ff1F524e416663040c995A] =  1107250000000000000000;
184     bountyMembersAmounts[0x01139e28b2a050e0E6Bdb3b86cd022DF86229493] =    10000000000000000000;
185     bountyMembersAmounts[0x0187A422b4faD439Fbfcf20f21F32159fd2a4f97] =    22000000000000000000;
186     bountyMembersAmounts[0x02286c00c0a0412ced30b267546e75faf3610c67] =    28000000000000000000;
187     bountyMembersAmounts[0x03103Dc3704B1BCE98d9B0FD771e08c546940Ac3] =    10000000000000000000;
188     bountyMembersAmounts[0x05c85d4875A57eB216FEb706bEe457d8BFF5342b] =   617000000000000000000;
189     bountyMembersAmounts[0x06136C784a19da76b61719FFEbD83fd66C356443] =    10000000000000000000;
190     bountyMembersAmounts[0x06604091b3ed6228295d3F8643178256AD7064e7] =  1966000000000000000000;
191     bountyMembersAmounts[0x066717Fe835a81FEC0DCB2262Aa3929fC34eBD48] =    12000000000000000000;
192     bountyMembersAmounts[0x07D67c25B39AE55A0ea116d4020c0263cf0B8bc2] =   895000000000000000000;
193     bountyMembersAmounts[0x0832c548114c2B9B3cdf04b3B466e8c71F2f3Dd0] =   100000000000000000000;
194     bountyMembersAmounts[0x0b9ac492a2fDcf27f4287502199694BbABcDf230] =    89000000000000000000;
195     bountyMembersAmounts[0x0Bc0ECCdF94C99F80e5a4908Dae8404D1Ff0b172] = 34775000000000000000000;
196     bountyMembersAmounts[0x0D268b405A4aB54bAFE785D7735373C13b2118d1] =    52000000000000000000;
197     bountyMembersAmounts[0x0d2973098B21B626dFB3141178FA70f2929d745c] =   295810000000000000000;
198     bountyMembersAmounts[0x0d681d40eAa80B213E0f60d305aC1A8b71C5614E] = 13068100000000000000000;
199     bountyMembersAmounts[0x0e2d1073f08b51b17f1a86b36f939a84d484e2e3] =    34000000000000000000;
200     bountyMembersAmounts[0x0f2922D94a663074D7Ce4Fa86cB37E4F7D0b6D69] =    22000000000000000000;
201     bountyMembersAmounts[0x0f2Bf92c30F9202f473c90eA15Fc6113A7cafD04] =    12000000000000000000;
202     bountyMembersAmounts[0x0FB9C104C7dc61CBc5fDe6De7E07e2b5A851a09a] =    12000000000000000000;
203     bountyMembersAmounts[0x10D370a992385028230AfDAA71f368A9856b2fE2] =    22000000000000000000;
204     bountyMembersAmounts[0x1293AAD8357Ed922632419b8B02EC13013b41DC1] =    13000000000000000000;
205     bountyMembersAmounts[0x14Ec0A3E8be71443E7bC3e801f9aCe758E973A16] =    16000000000000000000;
206     bountyMembersAmounts[0x1514Cd1d63d304D40574Fc33a61E8A2a202c1EeB] =  3350000000000000000000;
207     bountyMembersAmounts[0x1591C0d65168C3214e8c7b1cA3887cbbEC05e1d7] =   100550000000000000000;
208     bountyMembersAmounts[0x1608cFee55beAD1fe9405d18260690249196BB37] =    13000000000000000000;
209     bountyMembersAmounts[0x160e27387Db02A92d0BabAdE78b2Dc9aDea235d7] =  2026000000000000000000;
210     bountyMembersAmounts[0x1657d0411318F4f477BA95e4436ff8b95DdBC5C1] =    22000000000000000000;
211     bountyMembersAmounts[0x173a3df49a4e00c43febf955124b058c947cdbed] =  1165000000000000000000;
212     bountyMembersAmounts[0x18f76Ea4e6B3c67c440F82c18714143952d5A487] =   120000000000000000000;
213     bountyMembersAmounts[0x196df9e60D5fB266e2E3Ecc424339E4B74E5049f] =    34000000000000000000;
214     bountyMembersAmounts[0x1A8a06eaC94DBF7eb30fe6780A6404c33938750E] =    13000000000000000000;
215     bountyMembersAmounts[0x1c52C56439a7F8690C4D6a0225aE5B24D83013cA] = 19688000000000000000000;
216     bountyMembersAmounts[0x1F186a132F280c7cD2B11b09448863931ADED4e0] =  2170000000000000000000;
217     bountyMembersAmounts[0x1Fde313CF9415CeeEd489DCeC607b6316fF16d65] =  6734640000000000000000;
218     bountyMembersAmounts[0x2010d100ddebff781130d0e046936a3ee98727f1] =    34000000000000000000;
219     bountyMembersAmounts[0x2074689c9B27472887828c2650313F184a55Ed8c] =    12000000000000000000;
220     bountyMembersAmounts[0x207dF9263Ffd9Bd1C785D760C277B8aDc3Bb538D] =    19000000000000000000;
221     bountyMembersAmounts[0x20B8989E89B9EF181c7B764c2efe95F48289D7aa] =    10000000000000000000;
222     bountyMembersAmounts[0x220981B55fFF489948e2F6A3E419ef37faDf9B83] = 12867040000000000000000;
223     bountyMembersAmounts[0x24d9f17d7d0CC8DAA7A889c4baFdEf55B73e3C8e] =    35360000000000000000;
224     bountyMembersAmounts[0x27457e296214F60b3Dc04e4F4b9e62f9EFba6623] =   997200000000000000000;
225     bountyMembersAmounts[0x2B7fa6C81a759B4F75a8Da54C771bBCbfD6D6eFe] =    20000000000000000000;
226     bountyMembersAmounts[0x2Ee4840fF7baAc2f59E39cfCD91EC4443c2BC722] =  1810000000000000000000;
227     bountyMembersAmounts[0x2F52EF8F73Bd5b5596f3270c79D25696AAC3DC79] =  1966000000000000000000;
228     bountyMembersAmounts[0x2F96c2F5183c1a4D1AB2da19E3595F909e602aBb] =   100000000000000000000;
229     bountyMembersAmounts[0x315b476e3068Cdad5095370Bd9002aa2E5E9D801] =  2273000000000000000000;
230     bountyMembersAmounts[0x319C9f308E5B8069b4cDAA6F6d64dF9e56780Bbc] =    10000000000000000000;
231     bountyMembersAmounts[0x3210C023B44B33FeD106A6c9E762596D54400f2A] =    32000000000000000000;
232     bountyMembersAmounts[0x3219D1AA165E46Fbd5dA976a358dC2052FB142a8] =    10000000000000000000;
233     bountyMembersAmounts[0x32C235751A2C9C7f472d6eC6068E1608b6a35aD9] =    36000000000000000000;
234     bountyMembersAmounts[0x345F4e88905cfA1605b5f56167aF7D0Caa59AE74] =    18000000000000000000;
235     bountyMembersAmounts[0x34f420C3d8FfB21930Bf60Ea7723e327Bb20393E] =  3290970000000000000000;
236     bountyMembersAmounts[0x3679ea85968df04bebd6c69e1fcb21d7095a3c15] =    16000000000000000000;
237     bountyMembersAmounts[0x36A3A19b64b795a3572Ad89b82502D6c856d7000] =   861980000000000000000;
238     bountyMembersAmounts[0x36d48C3D1340C46996BC2Ca2A2b9614230429B6D] =    10000000000000000000;
239     bountyMembersAmounts[0x381AD376e361cF663b077E40D4aa30B412C8BBF8] =    19000000000000000000;
240     bountyMembersAmounts[0x38f6951095f324a9afC6da259A3fed5445A3Eed4] =  6558640000000000000000;
241     bountyMembersAmounts[0x3a28a66D41a70db4bCE133b47315041c1B078d1A] =    29000000000000000000;
242     bountyMembersAmounts[0x3A3379a90Cd4805eF37E839BD18C96A21Fb6D167] =    10000000000000000000;
243     bountyMembersAmounts[0x3a3531Be01950b1AfD3b248fd5716081a76ca611] =  1336800000000000000000;
244     bountyMembersAmounts[0x3b09F73927eAd9480D19024776E3D1189a76a261] =    27000000000000000000;
245     bountyMembersAmounts[0x3bDbDc1Cd6aaa1f26B74ad678b7CB5FDf6E99956] =    20000000000000000000;
246     bountyMembersAmounts[0x3c7Bb8F3A697C09059EC64140Eb1E341a015F0A2] =  1194800000000000000000;
247     bountyMembersAmounts[0x3D42b248F9ba14366943d1336380C343ceA3d400] =    30000000000000000000;
248     bountyMembersAmounts[0x3d841A6a31450DC32359d6a6cb91eB0b68b543b9] =  2038000000000000000000;
249     bountyMembersAmounts[0x3D8D4105D805D65eEA7F7d585A181c1E9f6F122F] =    10000000000000000000;
250     bountyMembersAmounts[0x3df08f4a0d59553e5bcba1d0c53aec0d6ae6ec56] =   142000000000000000000;
251     bountyMembersAmounts[0x3EE7FF5cd8D3d4b27fead92e8f859debBd578e4c] =    10000000000000000000;
252     bountyMembersAmounts[0x3F2Da3f89Db799125Db9639DE72a4209Cf1c40Ea] =    19000000000000000000;
253     bountyMembersAmounts[0x3FDb9BBB1D6f9ac12d091DC0907dFdEFd391D0D7] =    12000000000000000000;
254     bountyMembersAmounts[0x4006b0Eba9305ffD8ADFA1c00Fc6D8958b5F1D23] = 20050000000000000000000;
255     bountyMembersAmounts[0x428afff243967aeccec8c2ad60a44b294f0a9326] =    19000000000000000000;
256     bountyMembersAmounts[0x429c747c294B82027bDc62dE26faA8A6D10D9E19] =  1405000000000000000000;
257     bountyMembersAmounts[0x4312006E30A82664F5b7EF51B2cE5c864F54cb1f] =  6684000000000000000000;
258     bountyMembersAmounts[0x43a81239a7dc180dec1ced577509c97081a3de26] =   490000000000000000000;
259     bountyMembersAmounts[0x43cd2Ca403EB03A4A3288c3162c458d099a7038E] =    10000000000000000000;
260     bountyMembersAmounts[0x4524E960BE984eD3C20ACF66642693b8d87BB2E3] =   270000000000000000000;
261     bountyMembersAmounts[0x460BAA28e768d0C9D1BFc885ad91B253C3373048] =   222000000000000000000;
262     bountyMembersAmounts[0x46115812Fd32D98e349A3C8C5617DfC8922d1553] =    10000000000000000000;
263     bountyMembersAmounts[0x462f5Ea4f1C6b83c40Ed3E923a7ef0f902eCca63] =   851850000000000000000;
264     bountyMembersAmounts[0x49B175691322bD0b79526ca620d21A650789AfeA] =   827830000000000000000;
265     bountyMembersAmounts[0x49f4B1EAC2a0FeD5a7E58CEf8af576C77495d6bf] =    13000000000000000000;
266     bountyMembersAmounts[0x4a73D6ab83926E2b76eb2aAFdc5923042BE711fe] =   608400000000000000000;
267     bountyMembersAmounts[0x4AB9a9Bb91f045152Ba867489A14B54eb5f9bE8f] =  3342000000000000000000;
268     bountyMembersAmounts[0x4BD50151918c18D8864a0518eC553b6392C4E099] =  2074000000000000000000;
269     bountyMembersAmounts[0x4BDD83db1eBf11a4D342bD5AC6e5e4d4d589981f] =    10000000000000000000;
270     bountyMembersAmounts[0x4cd8bF0abC384185Aba223a8ddD5bf5b8a055a31] =    22000000000000000000;
271     bountyMembersAmounts[0x4D2CA39C850619bB9a6D78396bBeD7Ba152DeE7f] =   409000000000000000000;
272     bountyMembersAmounts[0x4EeCcAAAe00d3E9329476e6e43d40E5895ec8497] =   162000000000000000000;
273     bountyMembersAmounts[0x4F2dED30C27C4A7926B34c697Edd726aE379c3cE] =    16000000000000000000;
274     bountyMembersAmounts[0x4fBC0d16dAa175B11cBcB6687fC423D0F94f60a5] =   110000000000000000000;
275     bountyMembersAmounts[0x519abedcaecb4887bda17f9174d1a737ca34695b] =    13000000000000000000;
276     bountyMembersAmounts[0x522aB87522A15A7004DFaa4b358d4f2c8b9f2fAE] = 27897000000000000000000;
277     bountyMembersAmounts[0x528619Ca62dD1a65D103aeb2301bfC1B2e9582f2] =    22000000000000000000;
278     bountyMembersAmounts[0x52F916cD4C0d668a14B281a653057FD857796A89] =    22000000000000000000;
279     bountyMembersAmounts[0x542963aB9b1537A0e601B64Be86807b435F8b17b] =    31000000000000000000;
280     bountyMembersAmounts[0x547134707ee75D52DFF8Fc6de3717053328E96dB] =    16000000000000000000;
281     bountyMembersAmounts[0x555d181c062C64CCcF1d61C22bCD72f0796Fa2E4] = 23506050000000000000000;
282     bountyMembersAmounts[0x559e557411523b8420C9d254C84fa350688D1999] =  9031400000000000000000;
283   } 
284 }