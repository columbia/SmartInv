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
15 contract FifthBountyWPTpayoutPart01 {
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
42     addrPerStep = 25;
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
56   function setCountPerStep(uint _newValue) public onlyOwner {
57 	addrPerStep = _newValue;
58   }
59 
60   function setOwner(address _owner) 
61     public 
62     onlyOwner 
63   {
64     require(_owner != 0);
65     
66     owner = _owner;
67     emit OwnerChanged(owner);
68   }
69 
70   
71   
72   function makePayout() public onlyOwner {
73     uint startIndex = currentBatch * addrPerStep;
74     uint endIndex = (currentBatch + 1 ) * addrPerStep;
75     for (uint i = startIndex; (i < endIndex && i < addressOfBountyMembers.length); i++)
76     {
77       company_token.mint(addressOfBountyMembers[i], bountyMembersAmounts[addressOfBountyMembers[i]]);
78     }
79     currentBatch++;
80   }
81 
82   function setBountyAddresses() internal {
83     addressOfBountyMembers.push(0xfd5f3f3ad276e48D3728C72C26727c177D1aA09b);
84     addressOfBountyMembers.push(0xFD4a4Ea486c8294E89207Ecf4cf21a3886de37e1);
85     addressOfBountyMembers.push(0xFc7a64183f49f71A1D604496E62c08f20aF5b5d6);
86     addressOfBountyMembers.push(0xfbd40d775c29c36f56f7c340891c1484fd4b9944);
87     addressOfBountyMembers.push(0xfb86Ef5E076e37f723A2e65a0113BC66e7dA5e12);
88     addressOfBountyMembers.push(0xf9c4292AE2944452c7F56e8bb4fB63ddF830f034);
89     addressOfBountyMembers.push(0xF7e0AeE36D0170AB5f66e5d76515ae4B147c64dd);
90     addressOfBountyMembers.push(0xF7De64DeC2e3c8CEF47836A2FB904bE979139D8a);
91     addressOfBountyMembers.push(0xf72736881fb6bbafbbceb9cdc3ecd600fdb0a7a1);
92     addressOfBountyMembers.push(0xf6583Aab5d48903F6308157155c11ed087831C57);
93     addressOfBountyMembers.push(0xF62c52F593eF801594d7280b9f31F5127d57d682);
94     addressOfBountyMembers.push(0xF6168297046Ca6fa514834c30168e63A47256AF4);
95     addressOfBountyMembers.push(0xf5FA944b459b308B01f7ce2D350Dcc1F522d5a7c);
96     addressOfBountyMembers.push(0xf551395d6bBA0b984C3d91F476E32558c88Ba3a7);
97     addressOfBountyMembers.push(0xf53430F1cc2F899D29eAe1bC2E52b4192c0Ea4de);
98     addressOfBountyMembers.push(0xf431662d1Cd14c96b80eaaB5aF242fC1be7E4b62);
99     addressOfBountyMembers.push(0xF37955134Dda37eaC7380f5eb42bce10796bD224);
100     addressOfBountyMembers.push(0xF360ABbDEA1283d342AD9CB3770e10597217d4b2);
101     addressOfBountyMembers.push(0xf24eC0497d02eb793A946e3fa51297FA1Aec329f);
102     addressOfBountyMembers.push(0xf2418654Dd2e239EcBCF00aA2BC18aD8AF9bad52);
103     addressOfBountyMembers.push(0xf13f88cC201bffc81DC9a280790Ad567d99ff6FD);
104     addressOfBountyMembers.push(0xf117a07F02Da56696E8875F63b2c3BF906df0EEE);
105     addressOfBountyMembers.push(0xF0E7E4BD129d30440A695333A32DA777a7D948b9);
106     addressOfBountyMembers.push(0xF0d708b4A342A2F18e513BF8145A0c1454bc2108);
107     addressOfBountyMembers.push(0xf0593428298Db8F92818DF6F4FEEB639d84D6C9E);
108     addressOfBountyMembers.push(0xf04E88adbc5BC328135Fc20038b962b0201FFB27);
109     addressOfBountyMembers.push(0xeEf3DE554EF8DCf34b4DF193572EEA6D75622b21);
110     addressOfBountyMembers.push(0xEd6E237B32e15d27A4FBF6502099F765F18353f9);
111     addressOfBountyMembers.push(0xEd55F63701b023696Ac92bE695Ef1421a7095D9A);
112     addressOfBountyMembers.push(0xecB40E29C0Ce2108305890BBdD6082D47a9Ddb5F);
113     addressOfBountyMembers.push(0xEB057C509CF30cc45b0f52c8e507Ac3Cf8E78777);
114     addressOfBountyMembers.push(0xe8B400c93B829d2B46d2fe8B730412373a4822Bf);
115     addressOfBountyMembers.push(0xe8a718296Edcd56132A2de6045965dDDA8f7176B);
116     addressOfBountyMembers.push(0xE798b74f193A942a6d5dFAC9dD3816ee45B434BC);
117     addressOfBountyMembers.push(0xe7195DEc1D02cDC2180feaD59bC8E61cab343E13);
118     addressOfBountyMembers.push(0xE6F9b6bB035e3F982a484091496cF7B43ea0e7De);
119     addressOfBountyMembers.push(0xe64643E2f0340c9e7C2E01fdb99667f6f55200DA);
120     addressOfBountyMembers.push(0xe60A9ab929514848d5100a67677BebA09b9E0dA7);
121     addressOfBountyMembers.push(0xe54AbAADd0FDbF41cC1EB7da616AdAB517b372d1);
122     addressOfBountyMembers.push(0xe53Dc4cb2209C244eb6C62Cf1F9901359233f690);
123     addressOfBountyMembers.push(0xe47bd26318de067366eeda3ce62a475829907d40);
124     addressOfBountyMembers.push(0xE27C464Cec75CEeFD49485ed77C177D5e225362a);
125     addressOfBountyMembers.push(0xe0293D2cFa95C5362F678F347e09a59FB6fa802c);
126     addressOfBountyMembers.push(0xdd8804E408a21dc344e2A480DD207dEa38F325Ce);
127     addressOfBountyMembers.push(0xdC935D60137AA8Dfd513Ad790217cD5faDF9101a);
128     addressOfBountyMembers.push(0xda76c50E43912fB5A764b966915c270B9a637487);
129     addressOfBountyMembers.push(0xD93b45FfBF6Dc05A588f97230cd7F52595888308);
130     addressOfBountyMembers.push(0xd92bed42045a01e2fe1ab91751e0d3aa615642cf);
131     addressOfBountyMembers.push(0xD902cCb411E6B576Ed567159e8e32e0dd7902488);
132     addressOfBountyMembers.push(0xd8A321513f1fdf6EE58f599159f3C2ea80349243);
133     addressOfBountyMembers.push(0xD86BaD70373083e842faa85Bc0ed9812fEDc8875);
134     addressOfBountyMembers.push(0xD6DD581efeabff08bfaf6abF4A621e5263b93794);
135     addressOfBountyMembers.push(0xd5ccf1c632d7448cd9335cf78F2448e23b0003bF);
136     addressOfBountyMembers.push(0xd568cA92ee7fF3AbEef1E32ca31931843bed4758);
137     addressOfBountyMembers.push(0xD4709f13192EC20D65883981F52CFe0543756E19);
138     addressOfBountyMembers.push(0xD3e7C204D9Fa3A6E195c3B1216a77BB60923f945);
139     addressOfBountyMembers.push(0xd3dE61685BAa88Ed9b9dd6d96d1Ac4E6209669D5);
140     addressOfBountyMembers.push(0xD384FF0dC552e89a9729974AB1CcA3d580DBA30f);
141     addressOfBountyMembers.push(0xd193466c05aae45f1C341447e8ee95BdBEa8297e);
142     addressOfBountyMembers.push(0xd0000Ec17F5A68ee862b5673Fe32C39C600A138E);
143     addressOfBountyMembers.push(0xCF62a5497A642ab55E139ca05CBbC67076b51685);
144     addressOfBountyMembers.push(0xCe091A4D706c333bC6651B20A3Cae1686890CdE8);
145     addressOfBountyMembers.push(0xcCFA388A36C36a8Bd4ad504236dDa9A3536583aB);
146     addressOfBountyMembers.push(0xCcD74647cD44758d892D607FAeA791460A239039);
147     addressOfBountyMembers.push(0xcc023e9f32b4CbED3d57aa53C706cd9c692AB8cd);
148     addressOfBountyMembers.push(0xcb74E4cc30fdEbBE93E30410989C2e053cbC5dF9);
149     addressOfBountyMembers.push(0xC9214510BE987d18A53ea329Bc6E1f4310097E99);
150     addressOfBountyMembers.push(0xc8200a3e8576E5f779E845D7e168FD2463b7CeD1);
151     addressOfBountyMembers.push(0xc6934E0Cc0e6c97F7Fadb37A6428C84CF8dfA3BD);
152     addressOfBountyMembers.push(0xC68AD4fdbb11891e1E3C28c24dED3fC2D3724669);
153     addressOfBountyMembers.push(0xC64C17A136f9faa600a111ad10f59Cb6574f4396);
154     addressOfBountyMembers.push(0xc6375c620dF0b0D20B92f6652460fbDacAb5Ad28);
155     addressOfBountyMembers.push(0xc604563839f0e5D890FFc3BbfDBa6062d8D3b58D);
156     addressOfBountyMembers.push(0xC4f8e336911da71Fb49bF754F27A4D1bCceA0BB0);
157     addressOfBountyMembers.push(0xC4acD6308Fab3077d19FE4457191A15E44d131e3);
158     addressOfBountyMembers.push(0xc44F60af8Bf4F4F4c13C1Ba3e12F637956c69935);
159     addressOfBountyMembers.push(0xc3C2bB09D094579dCFe705971f8Fbf164A6523B5);
160     addressOfBountyMembers.push(0xc2C6869Ff474C656a56e7E0ed9dCfE6BEB6999A3);
161     addressOfBountyMembers.push(0xC18f70cf0fE4d22C3725159b899DF987846D1AA7);
162     addressOfBountyMembers.push(0xbFeEB695Eda630CA27534ecFbe7B915F500378C2);
163     addressOfBountyMembers.push(0xBF98422620fB97C5DB514F2eE2c33765C226E8eC);
164     addressOfBountyMembers.push(0xbF81C43910e09C9A5339B2C15C59A7844DE36eAa);
165     addressOfBountyMembers.push(0xBF2bf97b7fBD319c849D4cB6540fA9974b7c578e);
166     addressOfBountyMembers.push(0xbF1FdaC65b7D366b6Cb9BDE7d9ebf338A11D5EA0);
167     addressOfBountyMembers.push(0xBF1593D47c094efc32e39BBA951dE5B9902eEaA5);
168     addressOfBountyMembers.push(0xbeD4AD5d3dAF23a4567fedD66174849ba9Ee374d);
169     addressOfBountyMembers.push(0xBEd0868BE655d244292A2945f6c1C82af97628dD);
170     addressOfBountyMembers.push(0xbea37D67eF2979942fcd5e8715892F98901427ba);
171     addressOfBountyMembers.push(0xBE96BACe8f6fa27a1441902E805CF5B026F7ea7d);
172     addressOfBountyMembers.push(0xBD46eAccfF870A03CC541b13af90157feFd77243);
173     addressOfBountyMembers.push(0xBC5a08fd609fBEaeF15DC36860052B01fE889Def);
174     addressOfBountyMembers.push(0xbb04b1fff91E930F18675759ffE650cff9B15605);
175     addressOfBountyMembers.push(0xb9ae7Be5d750A85AfedDc2732EBe88540c5BF9F3);
176     addressOfBountyMembers.push(0xb94229396B9166ED549a080c3103c36D2bCA63e1);
177     addressOfBountyMembers.push(0xb929d51980d4018b7b3fF84BEE63fAf8B3eABce6);
178     addressOfBountyMembers.push(0xB73F5d6fED57ef3b6A624c918882010B38d6FeF5);
179     addressOfBountyMembers.push(0xB632265DEFd4e8B84Bf4fD78DACbc6c26DF3314e);
180     addressOfBountyMembers.push(0xb4Bfc94095dCcD357680eDCc0144768B2E98BAd2);
181     addressOfBountyMembers.push(0xb465Df34B5B13a52F696236e836922Aee4B358E9);
182     addressOfBountyMembers.push(0xb1887D27105647d2860DFc19A587007359278604);
183   }
184 
185   function setBountyAmounts() internal { 
186     bountyMembersAmounts[0xfd5f3f3ad276e48D3728C72C26727c177D1aA09b] =   116000000000000000000;
187     bountyMembersAmounts[0xFD4a4Ea486c8294E89207Ecf4cf21a3886de37e1] =  3100000000000000000000;
188     bountyMembersAmounts[0xFc7a64183f49f71A1D604496E62c08f20aF5b5d6] =   130000000000000000000;
189     bountyMembersAmounts[0xfbd40d775c29c36f56f7c340891c1484fd4b9944] =   123000000000000000000;
190     bountyMembersAmounts[0xfb86Ef5E076e37f723A2e65a0113BC66e7dA5e12] =   128000000000000000000;
191     bountyMembersAmounts[0xf9c4292AE2944452c7F56e8bb4fB63ddF830f034] =   115000000000000000000;
192     bountyMembersAmounts[0xF7e0AeE36D0170AB5f66e5d76515ae4B147c64dd] =   164000000000000000000;
193     bountyMembersAmounts[0xF7De64DeC2e3c8CEF47836A2FB904bE979139D8a] =   101000000000000000000;
194     bountyMembersAmounts[0xf72736881fb6bbafbbceb9cdc3ecd600fdb0a7a1] =   100000000000000000000;
195     bountyMembersAmounts[0xf6583Aab5d48903F6308157155c11ed087831C57] =   104000000000000000000;
196     bountyMembersAmounts[0xF62c52F593eF801594d7280b9f31F5127d57d682] =   243000000000000000000;
197     bountyMembersAmounts[0xF6168297046Ca6fa514834c30168e63A47256AF4] =   160000000000000000000;
198     bountyMembersAmounts[0xf5FA944b459b308B01f7ce2D350Dcc1F522d5a7c] =   159000000000000000000;
199     bountyMembersAmounts[0xf551395d6bBA0b984C3d91F476E32558c88Ba3a7] =   972000000000000000000;
200     bountyMembersAmounts[0xf53430F1cc2F899D29eAe1bC2E52b4192c0Ea4de] =   114000000000000000000;
201     bountyMembersAmounts[0xf431662d1Cd14c96b80eaaB5aF242fC1be7E4b62] =   104000000000000000000;
202     bountyMembersAmounts[0xF37955134Dda37eaC7380f5eb42bce10796bD224] =   100000000000000000000;
203     bountyMembersAmounts[0xF360ABbDEA1283d342AD9CB3770e10597217d4b2] =   371000000000000000000;
204     bountyMembersAmounts[0xf24eC0497d02eb793A946e3fa51297FA1Aec329f] =   101000000000000000000;
205     bountyMembersAmounts[0xf2418654Dd2e239EcBCF00aA2BC18aD8AF9bad52] =  2000000000000000000000;
206     bountyMembersAmounts[0xf13f88cC201bffc81DC9a280790Ad567d99ff6FD] =   120000000000000000000;
207     bountyMembersAmounts[0xf117a07F02Da56696E8875F63b2c3BF906df0EEE] =   217000000000000000000;
208     bountyMembersAmounts[0xF0E7E4BD129d30440A695333A32DA777a7D948b9] =   200000000000000000000;
209     bountyMembersAmounts[0xF0d708b4A342A2F18e513BF8145A0c1454bc2108] =  1712000000000000000000;
210     bountyMembersAmounts[0xf0593428298Db8F92818DF6F4FEEB639d84D6C9E] =   217000000000000000000;
211     bountyMembersAmounts[0xf04E88adbc5BC328135Fc20038b962b0201FFB27] =   102000000000000000000;
212     bountyMembersAmounts[0xeEf3DE554EF8DCf34b4DF193572EEA6D75622b21] =   154000000000000000000;
213     bountyMembersAmounts[0xEd6E237B32e15d27A4FBF6502099F765F18353f9] =   216000000000000000000;
214     bountyMembersAmounts[0xEd55F63701b023696Ac92bE695Ef1421a7095D9A] =   102000000000000000000;
215     bountyMembersAmounts[0xecB40E29C0Ce2108305890BBdD6082D47a9Ddb5F] =   115000000000000000000;
216     bountyMembersAmounts[0xEB057C509CF30cc45b0f52c8e507Ac3Cf8E78777] =   102000000000000000000;
217     bountyMembersAmounts[0xe8B400c93B829d2B46d2fe8B730412373a4822Bf] =   157000000000000000000;
218     bountyMembersAmounts[0xe8a718296Edcd56132A2de6045965dDDA8f7176B] =   100000000000000000000;
219     bountyMembersAmounts[0xE798b74f193A942a6d5dFAC9dD3816ee45B434BC] =   140000000000000000000;
220     bountyMembersAmounts[0xe7195DEc1D02cDC2180feaD59bC8E61cab343E13] =   121000000000000000000;
221     bountyMembersAmounts[0xE6F9b6bB035e3F982a484091496cF7B43ea0e7De] =   199000000000000000000;
222     bountyMembersAmounts[0xe64643E2f0340c9e7C2E01fdb99667f6f55200DA] =   245000000000000000000;
223     bountyMembersAmounts[0xe60A9ab929514848d5100a67677BebA09b9E0dA7] =   229000000000000000000;
224     bountyMembersAmounts[0xe54AbAADd0FDbF41cC1EB7da616AdAB517b372d1] =   116000000000000000000;
225     bountyMembersAmounts[0xe53Dc4cb2209C244eb6C62Cf1F9901359233f690] =   182000000000000000000;
226     bountyMembersAmounts[0xe47bd26318de067366eeda3ce62a475829907d40] =   105000000000000000000;
227     bountyMembersAmounts[0xE27C464Cec75CEeFD49485ed77C177D5e225362a] =   618000000000000000000;
228     bountyMembersAmounts[0xe0293D2cFa95C5362F678F347e09a59FB6fa802c] =   187000000000000000000;
229     bountyMembersAmounts[0xdd8804E408a21dc344e2A480DD207dEa38F325Ce] =   124000000000000000000;
230     bountyMembersAmounts[0xdC935D60137AA8Dfd513Ad790217cD5faDF9101a] =   143000000000000000000;
231     bountyMembersAmounts[0xda76c50E43912fB5A764b966915c270B9a637487] =   124000000000000000000;
232     bountyMembersAmounts[0xD93b45FfBF6Dc05A588f97230cd7F52595888308] =   180000000000000000000;
233     bountyMembersAmounts[0xd92bed42045a01e2fe1ab91751e0d3aa615642cf] =   100000000000000000000;
234     bountyMembersAmounts[0xD902cCb411E6B576Ed567159e8e32e0dd7902488] =   113000000000000000000;
235     bountyMembersAmounts[0xd8A321513f1fdf6EE58f599159f3C2ea80349243] =   107000000000000000000;
236     bountyMembersAmounts[0xD86BaD70373083e842faa85Bc0ed9812fEDc8875] =   122000000000000000000;
237     bountyMembersAmounts[0xD6DD581efeabff08bfaf6abF4A621e5263b93794] =   110000000000000000000;
238     bountyMembersAmounts[0xd5ccf1c632d7448cd9335cf78F2448e23b0003bF] =   126000000000000000000;
239     bountyMembersAmounts[0xd568cA92ee7fF3AbEef1E32ca31931843bed4758] =   140000000000000000000;
240     bountyMembersAmounts[0xD4709f13192EC20D65883981F52CFe0543756E19] =   103000000000000000000;
241     bountyMembersAmounts[0xD3e7C204D9Fa3A6E195c3B1216a77BB60923f945] =   275000000000000000000;
242     bountyMembersAmounts[0xd3dE61685BAa88Ed9b9dd6d96d1Ac4E6209669D5] =   178000000000000000000;
243     bountyMembersAmounts[0xD384FF0dC552e89a9729974AB1CcA3d580DBA30f] =   230000000000000000000;
244     bountyMembersAmounts[0xd193466c05aae45f1C341447e8ee95BdBEa8297e] =   102000000000000000000;
245     bountyMembersAmounts[0xd0000Ec17F5A68ee862b5673Fe32C39C600A138E] =   100000000000000000000;
246     bountyMembersAmounts[0xCF62a5497A642ab55E139ca05CBbC67076b51685] =   128000000000000000000;
247     bountyMembersAmounts[0xCe091A4D706c333bC6651B20A3Cae1686890CdE8] =   151000000000000000000;
248     bountyMembersAmounts[0xcCFA388A36C36a8Bd4ad504236dDa9A3536583aB] =   198000000000000000000;
249     bountyMembersAmounts[0xCcD74647cD44758d892D607FAeA791460A239039] =   536000000000000000000;
250     bountyMembersAmounts[0xcc023e9f32b4CbED3d57aa53C706cd9c692AB8cd] =   246000000000000000000;
251     bountyMembersAmounts[0xcb74E4cc30fdEbBE93E30410989C2e053cbC5dF9] =   150000000000000000000;
252     bountyMembersAmounts[0xC9214510BE987d18A53ea329Bc6E1f4310097E99] =   112000000000000000000;
253     bountyMembersAmounts[0xc8200a3e8576E5f779E845D7e168FD2463b7CeD1] =   104000000000000000000;
254     bountyMembersAmounts[0xc6934E0Cc0e6c97F7Fadb37A6428C84CF8dfA3BD] =   193000000000000000000;
255     bountyMembersAmounts[0xC68AD4fdbb11891e1E3C28c24dED3fC2D3724669] =   194000000000000000000;
256     bountyMembersAmounts[0xC64C17A136f9faa600a111ad10f59Cb6574f4396] =   144000000000000000000;
257     bountyMembersAmounts[0xc6375c620dF0b0D20B92f6652460fbDacAb5Ad28] =   130000000000000000000;
258     bountyMembersAmounts[0xc604563839f0e5D890FFc3BbfDBa6062d8D3b58D] =   156000000000000000000;
259     bountyMembersAmounts[0xC4f8e336911da71Fb49bF754F27A4D1bCceA0BB0] =   444000000000000000000;
260     bountyMembersAmounts[0xC4acD6308Fab3077d19FE4457191A15E44d131e3] =   195000000000000000000;
261     bountyMembersAmounts[0xc44F60af8Bf4F4F4c13C1Ba3e12F637956c69935] =   102000000000000000000;
262     bountyMembersAmounts[0xc3C2bB09D094579dCFe705971f8Fbf164A6523B5] =   103000000000000000000;
263     bountyMembersAmounts[0xc2C6869Ff474C656a56e7E0ed9dCfE6BEB6999A3] =   110000000000000000000;
264     bountyMembersAmounts[0xC18f70cf0fE4d22C3725159b899DF987846D1AA7] =   104000000000000000000;
265     bountyMembersAmounts[0xbFeEB695Eda630CA27534ecFbe7B915F500378C2] =   128000000000000000000;
266     bountyMembersAmounts[0xBF98422620fB97C5DB514F2eE2c33765C226E8eC] =   103000000000000000000;
267     bountyMembersAmounts[0xbF81C43910e09C9A5339B2C15C59A7844DE36eAa] =   152000000000000000000;
268     bountyMembersAmounts[0xBF2bf97b7fBD319c849D4cB6540fA9974b7c578e] =  1118000000000000000000;
269     bountyMembersAmounts[0xbF1FdaC65b7D366b6Cb9BDE7d9ebf338A11D5EA0] =   112000000000000000000;
270     bountyMembersAmounts[0xBF1593D47c094efc32e39BBA951dE5B9902eEaA5] =   362000000000000000000;
271     bountyMembersAmounts[0xbeD4AD5d3dAF23a4567fedD66174849ba9Ee374d] =   103000000000000000000;
272     bountyMembersAmounts[0xBEd0868BE655d244292A2945f6c1C82af97628dD] =   122000000000000000000;
273     bountyMembersAmounts[0xbea37D67eF2979942fcd5e8715892F98901427ba] =   110000000000000000000;
274     bountyMembersAmounts[0xBE96BACe8f6fa27a1441902E805CF5B026F7ea7d] =   171000000000000000000;
275     bountyMembersAmounts[0xBD46eAccfF870A03CC541b13af90157feFd77243] =   100000000000000000000;
276     bountyMembersAmounts[0xBC5a08fd609fBEaeF15DC36860052B01fE889Def] =   124000000000000000000;
277     bountyMembersAmounts[0xbb04b1fff91E930F18675759ffE650cff9B15605] =   700000000000000000000;
278     bountyMembersAmounts[0xb9ae7Be5d750A85AfedDc2732EBe88540c5BF9F3] =   228000000000000000000;
279     bountyMembersAmounts[0xb94229396B9166ED549a080c3103c36D2bCA63e1] =   114000000000000000000;
280     bountyMembersAmounts[0xb929d51980d4018b7b3fF84BEE63fAf8B3eABce6] =   120000000000000000000;
281     bountyMembersAmounts[0xB73F5d6fED57ef3b6A624c918882010B38d6FeF5] =   115000000000000000000;
282     bountyMembersAmounts[0xB632265DEFd4e8B84Bf4fD78DACbc6c26DF3314e] =   110000000000000000000;
283     bountyMembersAmounts[0xb4Bfc94095dCcD357680eDCc0144768B2E98BAd2] =   101000000000000000000;
284     bountyMembersAmounts[0xb465Df34B5B13a52F696236e836922Aee4B358E9] =   105000000000000000000;
285     bountyMembersAmounts[0xb1887D27105647d2860DFc19A587007359278604] =   182000000000000000000;
286   } 
287 }