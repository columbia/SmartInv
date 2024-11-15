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
15 contract ThirdBountyWPTpayoutPart2 {
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
78     addressOfBountyMembers.push(0x7f4FFCa375aD8c913734D1429Ca2EA904f80fc71);
79     addressOfBountyMembers.push(0x7Fe3E3F1346a7ebF2e57477213e46866858B6ce9);
80     addressOfBountyMembers.push(0x80234D0DA2A3B5159c6988Ab068c2b99a90F0d2B);
81     addressOfBountyMembers.push(0x80259f4f3f840BcaB9F9507a1E9B297BeCdD2acd);
82     addressOfBountyMembers.push(0x80A68661B77Ef51BF66fBf52720D0C0e3d9B0424);
83     addressOfBountyMembers.push(0x82208F0dF1EB060C6a6A8cc094E37ff203B9C0a1);
84     addressOfBountyMembers.push(0x82AF599aE8a62842dA38be6E5d4b14cD5882bddb);
85     addressOfBountyMembers.push(0x8460B752D49De926C8C623b4A836Eb7Bd402930C);
86     addressOfBountyMembers.push(0x8965C5Db7f9BD3ffd1084aF569843bBbBE54fB4e);
87     addressOfBountyMembers.push(0x8A2C390eA9cd3F62edc2a470a1186FDE9568811e);
88     addressOfBountyMembers.push(0x8A3A160decF48fD70d99Fda9F386DD1eA41d17DF);
89     addressOfBountyMembers.push(0x8Ac2aB28EB4a1fdFa94EE9B22E4c8Fc1e2683AA2);
90     addressOfBountyMembers.push(0x8B02E442f44A70cF0f9495e10a37f89F941af818);
91     addressOfBountyMembers.push(0x8cAdca5cfB103078e45ec2b3D94EA0dA62159F17);
92     addressOfBountyMembers.push(0x8de44B84Ab791Dde8C2f186B40Ff9A2390dAa0f7);
93     addressOfBountyMembers.push(0x8E65d5bEB7e1A34d73Caa44cC4632BE7C9d2619a);
94     addressOfBountyMembers.push(0x8f6f9a2BA2130989F51D08138bfb72c4bfe873bd);
95     addressOfBountyMembers.push(0x912126dAeb9940c3EB2f22351b4277C5896CE08d);
96     addressOfBountyMembers.push(0x9278dc8aee744C7356cE19b7E7c7386183d38Be7);
97     addressOfBountyMembers.push(0x928Fb44829B702Dcc0092839d6e0E45af0EA9BD6);
98     addressOfBountyMembers.push(0x92F38bbcE12d72DCcdD1439bD721Cc5CDc6628b1);
99     addressOfBountyMembers.push(0x967dd204a6b5deA11005f2e3487668DFA36Bb270);
100     addressOfBountyMembers.push(0x987bCBfc67d0E93Ba1acAc1dac71F708d41340f6);
101     addressOfBountyMembers.push(0x9a8e2538f8270d252db6e759e297f5f3646188e5);
102     addressOfBountyMembers.push(0x9BB10788173fD71Dd8786955a33Ae619Bd962028);
103     addressOfBountyMembers.push(0x9eE59c11458D564f83c056aF679da378a1f990a2);
104     addressOfBountyMembers.push(0x9f8f632Cb8789941386556636b4f9d2AA9ef919A);
105     addressOfBountyMembers.push(0x9feDa8bDe70E5da9A3709b735ae1dE7d39c7BB75);
106     addressOfBountyMembers.push(0xa150b70e7ad9De723517b3c807e57A9705519848);
107     addressOfBountyMembers.push(0xa2F4849cc20f4413c3B2249932973a0a561927E8);
108     addressOfBountyMembers.push(0xA55c85283fEeb8DcA42DB31cF2DBA5d3C69380A3);
109     addressOfBountyMembers.push(0xA631Ec94Edce1Fe78cD7344A029b6C37c0df7dCA);
110     addressOfBountyMembers.push(0xa649bef582858CcFBfa5b428e004Ce4eCeBF0aA1);
111     addressOfBountyMembers.push(0xA68faEe5FbAE0dBb776f030ACd515261b51f6748);
112     addressOfBountyMembers.push(0xaaBd86831c4d847458b560CC04382B381B54db7D);
113     addressOfBountyMembers.push(0xAb7149391d1f620aBB415eb9f2f48d211235Bc96);
114     addressOfBountyMembers.push(0xAf6b49Da2fA9fde960Ba5C106499AC5D11b73Cc9);
115     addressOfBountyMembers.push(0xB1DD246A67E4a842C9d302e650727edd3E435982);
116     addressOfBountyMembers.push(0xb39d88c936b409d1e29e558bd71041e15d2cc465);
117     addressOfBountyMembers.push(0xb547cE18BA9b8A38F9c48030Fe05373Ea727Fe41);
118     addressOfBountyMembers.push(0xB7F412Bd4939A0553065aEd20c7834b944C48cD5);
119     addressOfBountyMembers.push(0xb89502c1BA64Ab238AeaEE70E3760e9ab8320bC2);
120     addressOfBountyMembers.push(0xBaF6f2FE0A5450Df724c47e340bB38e9507A9D4e);
121     addressOfBountyMembers.push(0xBDb3eA0c16cF1C6a4A2e1731925eA44318752F91);
122     addressOfBountyMembers.push(0xbE766945999eFeF404803BF987cE223fd94a625A);
123     addressOfBountyMembers.push(0xBEcB68270916158135FB5AE6a9dbF19DEe1f5445);
124     addressOfBountyMembers.push(0xBeE6E6B078b48ba5AAcb98D7f57Dd78496Af38dF);
125     addressOfBountyMembers.push(0xBF4e91282b9016c90022Cb5Da41B9f186A082725);
126     addressOfBountyMembers.push(0xc04107121ABD5c4aDbA8Fe1E5e8F6C3eB4Dc943a);
127     addressOfBountyMembers.push(0xc31879f273cdb467C228Ac6e28B1610F42724F15);
128     addressOfBountyMembers.push(0xc4C73C0a9A56445980fA2a6B1F693f823e48Bd5C);
129     addressOfBountyMembers.push(0xc60C6cAee3c74017b95703B981DDf62083e8c813);
130     addressOfBountyMembers.push(0xc6934E0Cc0e6c97F7Fadb37A6428C84CF8dfA3BD);
131     addressOfBountyMembers.push(0xC7E265977e7C52C605A80C734A1F862C70F8d410);
132     addressOfBountyMembers.push(0xc8200a3e8576E5f779E845D7e168FD2463b7CeD1);
133     addressOfBountyMembers.push(0xC8fdF66fa1C2B1873076b3abe9A8275A2D84db60);
134     addressOfBountyMembers.push(0xCD471F89dDca2d95c2846148a3CE0c906009cAD1);
135     addressOfBountyMembers.push(0xCd78D7D6131B92D5aB0ad89921A0F066b2A2d724);
136     addressOfBountyMembers.push(0xcf8e4a35e8BBc386bBBDe31DEa66D261Fb8F2199);
137     addressOfBountyMembers.push(0xD00f86dB90a09576c3886087f885e938E1E03cd2);
138     addressOfBountyMembers.push(0xd25CF60C943b530157333b93CAA4F9799cb6F781);
139     addressOfBountyMembers.push(0xd3dE61685BAa88Ed9b9dd6d96d1Ac4E6209669D5);
140     addressOfBountyMembers.push(0xD45C240cB9FCa7760b65AFF93dd0082Fe6794ea0);
141     addressOfBountyMembers.push(0xd4e31aEfFd260C5E1a6a2cc6Ee53Ab7644FE9FA3);
142     addressOfBountyMembers.push(0xD567194101D48E47d6A6db93aF5c12CB55B27849);
143     addressOfBountyMembers.push(0xd64c06210CA12697974E86Dd0C072D7E8e5CAD08);
144     addressOfBountyMembers.push(0xD748a3fE50368D47163b3b1fDa780798970d99C1);
145     addressOfBountyMembers.push(0xd8A321513f1fdf6EE58f599159f3C2ea80349243);
146     addressOfBountyMembers.push(0xd902741d04432Db4021Ea7AF20687C0536FeeB69);
147     addressOfBountyMembers.push(0xd9Da4D60cf149CC8Ed6F74Fb730551e238e364DD);
148     addressOfBountyMembers.push(0xDA852caEDAC919c32226E1cF6Bb8F835302ce5D3);
149     addressOfBountyMembers.push(0xDB0B75883aB0AdbeF158b02687A7b049067Fd725);
150     addressOfBountyMembers.push(0xDD142453213080E90a2849353E72401e8A5313Cb);
151     addressOfBountyMembers.push(0xdE361C58D32465DFD17434127a37145c29d16C54);
152     addressOfBountyMembers.push(0xDecC61Ac36960bFDc323e22D4a0336d8a95F38BC);
153     addressOfBountyMembers.push(0xdF7D5b661630B183f7FE9f46f7DEE8CF618ccDe8);
154     addressOfBountyMembers.push(0xe0E76db2eBB19f3c56a7d1542482F8B968E03703);
155     addressOfBountyMembers.push(0xE1D36B1Aee32F79B36EE9B8C5a31DDa01A743f57);
156     addressOfBountyMembers.push(0xe2ce954168541195d258a4Cb0637d8fEe7Be60b1);
157     addressOfBountyMembers.push(0xe37664311f6c3D564ac2c5A620A45fCC87865a7b);
158     addressOfBountyMembers.push(0xe482884B5C7a1BC8dD4168e48E2615a754A57aF1);
159     addressOfBountyMembers.push(0xE4a8Ad37af7a670F342a345a0E4c1EC7659ba718);
160     addressOfBountyMembers.push(0xE692256D270946A407f8Ba9885D62e883479F0b8);
161     addressOfBountyMembers.push(0xE7087b479Ff98B32E15Ef1E02e0AE41016754552);
162     addressOfBountyMembers.push(0xeA8c13c2a9998F18A656344847bD9Cbb1989cf14);
163     addressOfBountyMembers.push(0xEB9fc0cDe4B30Bd5aAB11d1fb0fa1a6f104af825);
164     addressOfBountyMembers.push(0xF0c47E2c8d87869FaDc3959414263b53DB3b16fF);
165     addressOfBountyMembers.push(0xf2418654Dd2e239EcBCF00aA2BC18aD8AF9bad52);
166     addressOfBountyMembers.push(0xF3F227870A13923d58411cB16E17F615B025Eb3a);
167     addressOfBountyMembers.push(0xF5EF0715693B5332b39c0Cc2f1F680c987869482);
168     addressOfBountyMembers.push(0xF6168297046Ca6fa514834c30168e63A47256AF4);
169     addressOfBountyMembers.push(0xF62c52F593eF801594d7280b9f31F5127d57d682);
170     addressOfBountyMembers.push(0xf72736881fb6bbafbbceb9cdc3ecd600fdb0a7a1);
171     addressOfBountyMembers.push(0xf99eE39427a0F5f66aBff8118af81D82114c18FD);
172     addressOfBountyMembers.push(0xFA4937670686c09F180C71a9b93e2FfCC3A79F47);
173     addressOfBountyMembers.push(0xfbaEb96CD0aaAc60fa238aa8e5Fd6A62D7a785Dc);
174     addressOfBountyMembers.push(0xFC0ad210dB03B28eeb2f1D719045eb4132Aa3Da1);
175     addressOfBountyMembers.push(0xfc6ed1944c6f8ab954b60604632ace1e2f55b8cd);
176     addressOfBountyMembers.push(0xfD8e8C10e9253b4ecBc65CAe2d155e5c936b5f4c);
177   }
178 
179   function setBountyAmounts() internal { 
180     bountyMembersAmounts[0x7f4FFCa375aD8c913734D1429Ca2EA904f80fc71] =   139000000000000000000;
181     bountyMembersAmounts[0x7Fe3E3F1346a7ebF2e57477213e46866858B6ce9] =   116000000000000000000;
182     bountyMembersAmounts[0x80234D0DA2A3B5159c6988Ab068c2b99a90F0d2B] =   106000000000000000000;
183     bountyMembersAmounts[0x80259f4f3f840BcaB9F9507a1E9B297BeCdD2acd] =   119000000000000000000;
184     bountyMembersAmounts[0x80A68661B77Ef51BF66fBf52720D0C0e3d9B0424] =    90000000000000000000;
185     bountyMembersAmounts[0x82208F0dF1EB060C6a6A8cc094E37ff203B9C0a1] =   106000000000000000000;
186     bountyMembersAmounts[0x82AF599aE8a62842dA38be6E5d4b14cD5882bddb] =   100000000000000000000;
187     bountyMembersAmounts[0x8460B752D49De926C8C623b4A836Eb7Bd402930C] =   142000000000000000000;
188     bountyMembersAmounts[0x8965C5Db7f9BD3ffd1084aF569843bBbBE54fB4e] =   498000000000000000000;
189     bountyMembersAmounts[0x8A2C390eA9cd3F62edc2a470a1186FDE9568811e] =   490000000000000000000;
190     bountyMembersAmounts[0x8A3A160decF48fD70d99Fda9F386DD1eA41d17DF] =    10000000000000000000;
191     bountyMembersAmounts[0x8Ac2aB28EB4a1fdFa94EE9B22E4c8Fc1e2683AA2] =    12000000000000000000;
192     bountyMembersAmounts[0x8B02E442f44A70cF0f9495e10a37f89F941af818] = 11194000000000000000000;
193     bountyMembersAmounts[0x8cAdca5cfB103078e45ec2b3D94EA0dA62159F17] =    12000000000000000000;
194     bountyMembersAmounts[0x8de44B84Ab791Dde8C2f186B40Ff9A2390dAa0f7] =   920000000000000000000;
195     bountyMembersAmounts[0x8E65d5bEB7e1A34d73Caa44cC4632BE7C9d2619a] =   574000000000000000000;
196     bountyMembersAmounts[0x8f6f9a2BA2130989F51D08138bfb72c4bfe873bd] =   766000000000000000000;
197     bountyMembersAmounts[0x912126dAeb9940c3EB2f22351b4277C5896CE08d] =   103000000000000000000;
198     bountyMembersAmounts[0x9278dc8aee744C7356cE19b7E7c7386183d38Be7] =  9213600000000000000000;
199     bountyMembersAmounts[0x928Fb44829B702Dcc0092839d6e0E45af0EA9BD6] =   383000000000000000000;
200     bountyMembersAmounts[0x92F38bbcE12d72DCcdD1439bD721Cc5CDc6628b1] =   322000000000000000000;
201     bountyMembersAmounts[0x967dd204a6b5deA11005f2e3487668DFA36Bb270] =   149000000000000000000;
202     bountyMembersAmounts[0x987bCBfc67d0E93Ba1acAc1dac71F708d41340f6] =    10000000000000000000;
203     bountyMembersAmounts[0x9a8e2538f8270d252db6e759e297f5f3646188e5] =   105000000000000000000;
204     bountyMembersAmounts[0x9BB10788173fD71Dd8786955a33Ae619Bd962028] =   178000000000000000000;
205     bountyMembersAmounts[0x9eE59c11458D564f83c056aF679da378a1f990a2] =   322000000000000000000;
206     bountyMembersAmounts[0x9f8f632Cb8789941386556636b4f9d2AA9ef919A] =   658000000000000000000;
207     bountyMembersAmounts[0x9feDa8bDe70E5da9A3709b735ae1dE7d39c7BB75] =   149000000000000000000;
208     bountyMembersAmounts[0xa150b70e7ad9De723517b3c807e57A9705519848] =   796800000000000000000;
209     bountyMembersAmounts[0xa2F4849cc20f4413c3B2249932973a0a561927E8] =  1021550000000000000000;
210     bountyMembersAmounts[0xA55c85283fEeb8DcA42DB31cF2DBA5d3C69380A3] =   100000000000000000000;
211     bountyMembersAmounts[0xA631Ec94Edce1Fe78cD7344A029b6C37c0df7dCA] =   208000000000000000000;
212     bountyMembersAmounts[0xa649bef582858CcFBfa5b428e004Ce4eCeBF0aA1] =   106000000000000000000;
213     bountyMembersAmounts[0xA68faEe5FbAE0dBb776f030ACd515261b51f6748] =   101000000000000000000;
214     bountyMembersAmounts[0xaaBd86831c4d847458b560CC04382B381B54db7D] =   110000000000000000000;
215     bountyMembersAmounts[0xAb7149391d1f620aBB415eb9f2f48d211235Bc96] =   112000000000000000000;
216     bountyMembersAmounts[0xAf6b49Da2fA9fde960Ba5C106499AC5D11b73Cc9] =    13000000000000000000;
217     bountyMembersAmounts[0xB1DD246A67E4a842C9d302e650727edd3E435982] =   178000000000000000000;
218     bountyMembersAmounts[0xb39d88c936b409d1e29e558bd71041e15d2cc465] =  1200000000000000000000;
219     bountyMembersAmounts[0xb547cE18BA9b8A38F9c48030Fe05373Ea727Fe41] =   730100000000000000000;
220     bountyMembersAmounts[0xB7F412Bd4939A0553065aEd20c7834b944C48cD5] =   931700000000000000000;
221     bountyMembersAmounts[0xb89502c1BA64Ab238AeaEE70E3760e9ab8320bC2] =    12000000000000000000;
222     bountyMembersAmounts[0xBaF6f2FE0A5450Df724c47e340bB38e9507A9D4e] =   137000000000000000000;
223     bountyMembersAmounts[0xBDb3eA0c16cF1C6a4A2e1731925eA44318752F91] =   568000000000000000000;
224     bountyMembersAmounts[0xbE766945999eFeF404803BF987cE223fd94a625A] =  5089730000000000000000;
225     bountyMembersAmounts[0xBEcB68270916158135FB5AE6a9dbF19DEe1f5445] =    12000000000000000000;
226     bountyMembersAmounts[0xBeE6E6B078b48ba5AAcb98D7f57Dd78496Af38dF] =   105000000000000000000;
227     bountyMembersAmounts[0xBF4e91282b9016c90022Cb5Da41B9f186A082725] =   125000000000000000000;
228     bountyMembersAmounts[0xc04107121ABD5c4aDbA8Fe1E5e8F6C3eB4Dc943a] =   190000000000000000000;
229     bountyMembersAmounts[0xc31879f273cdb467C228Ac6e28B1610F42724F15] =   107000000000000000000;
230     bountyMembersAmounts[0xc4C73C0a9A56445980fA2a6B1F693f823e48Bd5C] =   178000000000000000000;
231     bountyMembersAmounts[0xc60C6cAee3c74017b95703B981DDf62083e8c813] =   202000000000000000000;
232     bountyMembersAmounts[0xc6934E0Cc0e6c97F7Fadb37A6428C84CF8dfA3BD] =   211000000000000000000;
233     bountyMembersAmounts[0xC7E265977e7C52C605A80C734A1F862C70F8d410] =   142000000000000000000;
234     bountyMembersAmounts[0xc8200a3e8576E5f779E845D7e168FD2463b7CeD1] =   129000000000000000000;
235     bountyMembersAmounts[0xC8fdF66fa1C2B1873076b3abe9A8275A2D84db60] =   128000000000000000000;
236     bountyMembersAmounts[0xCD471F89dDca2d95c2846148a3CE0c906009cAD1] =   475000000000000000000;
237     bountyMembersAmounts[0xCd78D7D6131B92D5aB0ad89921A0F066b2A2d724] =  5367200000000000000000;
238     bountyMembersAmounts[0xcf8e4a35e8BBc386bBBDe31DEa66D261Fb8F2199] =    22000000000000000000;
239     bountyMembersAmounts[0xD00f86dB90a09576c3886087f885e938E1E03cd2] =  2020000000000000000000;
240     bountyMembersAmounts[0xd25CF60C943b530157333b93CAA4F9799cb6F781] =    10000000000000000000;
241     bountyMembersAmounts[0xd3dE61685BAa88Ed9b9dd6d96d1Ac4E6209669D5] =  5974000000000000000000;
242     bountyMembersAmounts[0xD45C240cB9FCa7760b65AFF93dd0082Fe6794ea0] =   120000000000000000000;
243     bountyMembersAmounts[0xd4e31aEfFd260C5E1a6a2cc6Ee53Ab7644FE9FA3] =   157000000000000000000;
244     bountyMembersAmounts[0xD567194101D48E47d6A6db93aF5c12CB55B27849] =  9622000000000000000000;
245     bountyMembersAmounts[0xd64c06210CA12697974E86Dd0C072D7E8e5CAD08] =   138000000000000000000;
246     bountyMembersAmounts[0xD748a3fE50368D47163b3b1fDa780798970d99C1] =   310000000000000000000;
247     bountyMembersAmounts[0xd8A321513f1fdf6EE58f599159f3C2ea80349243] =   106000000000000000000;
248     bountyMembersAmounts[0xd902741d04432Db4021Ea7AF20687C0536FeeB69] =  3980000000000000000000;
249     bountyMembersAmounts[0xd9Da4D60cf149CC8Ed6F74Fb730551e238e364DD] =  1002600000000000000000;
250     bountyMembersAmounts[0xDA852caEDAC919c32226E1cF6Bb8F835302ce5D3] =   192000000000000000000;
251     bountyMembersAmounts[0xDB0B75883aB0AdbeF158b02687A7b049067Fd725] =   178000000000000000000;
252     bountyMembersAmounts[0xDD142453213080E90a2849353E72401e8A5313Cb] =   378320000000000000000;
253     bountyMembersAmounts[0xdE361C58D32465DFD17434127a37145c29d16C54] =   230000000000000000000;
254     bountyMembersAmounts[0xDecC61Ac36960bFDc323e22D4a0336d8a95F38BC] =   131000000000000000000;
255     bountyMembersAmounts[0xdF7D5b661630B183f7FE9f46f7DEE8CF618ccDe8] =   153000000000000000000;
256     bountyMembersAmounts[0xe0E76db2eBB19f3c56a7d1542482F8B968E03703] =  2880000000000000000000;
257     bountyMembersAmounts[0xE1D36B1Aee32F79B36EE9B8C5a31DDa01A743f57] = 16130110000000000000000;
258     bountyMembersAmounts[0xe2ce954168541195d258a4Cb0637d8fEe7Be60b1] =  2227000000000000000000;
259     bountyMembersAmounts[0xe37664311f6c3D564ac2c5A620A45fCC87865a7b] =   112000000000000000000;
260     bountyMembersAmounts[0xe482884B5C7a1BC8dD4168e48E2615a754A57aF1] =   104000000000000000000;
261     bountyMembersAmounts[0xE4a8Ad37af7a670F342a345a0E4c1EC7659ba718] =   100000000000000000000;
262     bountyMembersAmounts[0xE692256D270946A407f8Ba9885D62e883479F0b8] =   108000000000000000000;
263     bountyMembersAmounts[0xE7087b479Ff98B32E15Ef1E02e0AE41016754552] =   125000000000000000000;
264     bountyMembersAmounts[0xeA8c13c2a9998F18A656344847bD9Cbb1989cf14] =   101000000000000000000;
265     bountyMembersAmounts[0xEB9fc0cDe4B30Bd5aAB11d1fb0fa1a6f104af825] =   181000000000000000000;
266     bountyMembersAmounts[0xF0c47E2c8d87869FaDc3959414263b53DB3b16fF] =   502000000000000000000;
267     bountyMembersAmounts[0xf2418654Dd2e239EcBCF00aA2BC18aD8AF9bad52] =   104000000000000000000;
268     bountyMembersAmounts[0xF3F227870A13923d58411cB16E17F615B025Eb3a] =   787000000000000000000;
269     bountyMembersAmounts[0xF5EF0715693B5332b39c0Cc2f1F680c987869482] =   110000000000000000000;
270     bountyMembersAmounts[0xF6168297046Ca6fa514834c30168e63A47256AF4] =   970000000000000000000;
271     bountyMembersAmounts[0xF62c52F593eF801594d7280b9f31F5127d57d682] =   122000000000000000000;
272     bountyMembersAmounts[0xf72736881fb6bbafbbceb9cdc3ecd600fdb0a7a1] =   100000000000000000000;
273     bountyMembersAmounts[0xf99eE39427a0F5f66aBff8118af81D82114c18FD] =   101000000000000000000;
274     bountyMembersAmounts[0xFA4937670686c09F180C71a9b93e2FfCC3A79F47] =  9701800000000000000000;
275     bountyMembersAmounts[0xfbaEb96CD0aaAc60fa238aa8e5Fd6A62D7a785Dc] =   116000000000000000000;
276     bountyMembersAmounts[0xFC0ad210dB03B28eeb2f1D719045eb4132Aa3Da1] =  1893270000000000000000;
277     bountyMembersAmounts[0xfc6ed1944c6f8ab954b60604632ace1e2f55b8cd] =   112000000000000000000;
278     bountyMembersAmounts[0xfD8e8C10e9253b4ecBc65CAe2d155e5c936b5f4c] =   445000000000000000000;
279   } 
280 }