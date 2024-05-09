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
15 contract SecondBountyWPTpayout_part3 {
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
78     addressOfBountyMembers.push(0xA8513A556B2d408a15b28AF9509F4219d9D759BD);
79     addressOfBountyMembers.push(0xa9CEaF2b628fFEe4c8DAa945972c6395f08d2791);
80     addressOfBountyMembers.push(0xaBaEF4cB77ddB7Ddd1Ed9Ec55aE3f4071d90FfC2);
81     addressOfBountyMembers.push(0xae513e138CCFFF4D6576E949f4551dc1094E3381);
82     addressOfBountyMembers.push(0xb08C4238c1eC7E05DE8EB4CDD80C9FDc3Fa832BA);
83     addressOfBountyMembers.push(0xB1d5A2FaEEA58dCeE20Ea42Baf63688C14652B97);
84     addressOfBountyMembers.push(0xb2eB45F66d0c4c6Fa2b36629bb625108f2eee44C);
85     addressOfBountyMembers.push(0xb393fd52a7e688e40462d87b9c6b61e8fdee458d);
86     addressOfBountyMembers.push(0xb3c16193d4b8a0f3b3bad0956199213897672029);
87     addressOfBountyMembers.push(0xb62295AB5c3A46051d2b63b046707EaFcc94797d);
88     addressOfBountyMembers.push(0xB785bB546bE675c76f9E4Ca4BfbB047465621174);
89     addressOfBountyMembers.push(0xB7CC436233e2237bD8A9235C2f7185e82bB3bAfa);
90     addressOfBountyMembers.push(0xB82E3Cec9255fdc8dFC01e1a648f414D9CAd213C);
91     addressOfBountyMembers.push(0xb85b6a635F97aaBc7e1Be9d4fBf72c0039f04881);
92     addressOfBountyMembers.push(0xB8f412210002594b71A058cB26F4a9CcB3488c65);
93     addressOfBountyMembers.push(0xb9b744F4b204e036DD00D59f9670eed2db162814);
94     addressOfBountyMembers.push(0xb9Cf4A1CCAFDcCD08B3a5D329922c88dEF80F56B);
95     addressOfBountyMembers.push(0xBa0Beaf2C73d7882ad1562A3F07F249E87D47aa0);
96     addressOfBountyMembers.push(0xBB5B0e8D5dc060e0f9c7291c896157e7B3880317);
97     addressOfBountyMembers.push(0xbBac285eAce15ACBa136F0Bb54f88c5e98b8EBe4);
98     addressOfBountyMembers.push(0xbBDeeA2457E77D6D6f63C2C02000e8bd5af0c513);
99     addressOfBountyMembers.push(0xBBF268DB73a76D07aFF331F815E189DC1F9bc5B6);
100     addressOfBountyMembers.push(0xBC8fF0f24F8967C063367EDBE922c48E4abb2A85);
101     addressOfBountyMembers.push(0xbD3E04A43360Ac3A723980681a5A24835CE2C746);
102     addressOfBountyMembers.push(0xBD9AD25AF57aB5E74081E3F1A0dCbc6FE52B7FC8);
103     addressOfBountyMembers.push(0xbe13Cf151f0aCB6545ea1211CC43E31D25Fb954e);
104     addressOfBountyMembers.push(0xBF1593D47c094efc32e39BBA951dE5B9902eEaA5);
105     addressOfBountyMembers.push(0xBf9951eeF974c9fE8c7C522122358EB3777a5c8C);
106     addressOfBountyMembers.push(0xc0c77D00Bc2464DcD7DC9161c49B2509cC700aEd);
107     addressOfBountyMembers.push(0xC2DF47568805bd16EB7a4f0CC7015862D46226bd);
108     addressOfBountyMembers.push(0xc333C16bbfd0BA06545323204eB773ce7BE04E49);
109     addressOfBountyMembers.push(0xC3eb9D31F30EeD986402B68a70e30FB194169038);
110     addressOfBountyMembers.push(0xc451219677F52F8c2c98538aC4F2f8B9cC90E095);
111     addressOfBountyMembers.push(0xc4B61dF08b6CB6C98d0F37adfCB5d968eCc51e61);
112     addressOfBountyMembers.push(0xC4Be8FD7826fD63aE3fd9b4493327C492690D747);
113     addressOfBountyMembers.push(0xc50E4f63de1Cc99E506a765219C951161aBcA075);
114     addressOfBountyMembers.push(0xc6375c620dF0b0D20B92f6652460fbDacAb5Ad28);
115     addressOfBountyMembers.push(0xc697F60E7c6b325FA0485a37E535fE2185c97A82);
116     addressOfBountyMembers.push(0xC8783c7252a21C9Cf588f703Bb6dc000935447a3);
117     addressOfBountyMembers.push(0xC8EF8E565DBE2fCabC9E03518c7bAba2c76dc7d4);
118     addressOfBountyMembers.push(0xCB114d7F5e9f6C51EF500ef98Fe8132390Fc136e);
119     addressOfBountyMembers.push(0xcc023e9f32b4CbED3d57aa53C706cd9c692AB8cd);
120     addressOfBountyMembers.push(0xcc5Df7D489F55EDaB52da8481828ad332855eC66);
121     addressOfBountyMembers.push(0xcd7233b3d00dbac1805d733c4507b49ab74e246e);
122     addressOfBountyMembers.push(0xCdc464a8cdCeA65426092254C425CC30B3950813);
123     addressOfBountyMembers.push(0xcE18755068C88EF85526969A8ddB3c7BBB12d4AE);
124     addressOfBountyMembers.push(0xCE4BdDcD1251d99752f116608b9C756254d5E012);
125     addressOfBountyMembers.push(0xD06021e55a3E293DCb99ddB98467234F866F9Ec3);
126     addressOfBountyMembers.push(0xd23cb30C6510ad1a8E080c3c580365f886a3Fc6D);
127     addressOfBountyMembers.push(0xD382c8F5CFdfD9fd0246B1B6b4eb57249A567a74);
128     addressOfBountyMembers.push(0xd3d3F77669734F32bEd1f57d1A85011AB7687A0E);
129     addressOfBountyMembers.push(0xd3D6f9328006290F963676868E087d18c07d23a6);
130     addressOfBountyMembers.push(0xD7938FA601153537c03842Ed1e328630437B1FCD);
131     addressOfBountyMembers.push(0xd7bc5ec6a64ec88193d89b8564085cc363c30e80);
132     addressOfBountyMembers.push(0xd7DEC97cf9e412637a3F40bBdcAa7746f88cced1);
133     addressOfBountyMembers.push(0xd8C7b05A523683De2AE8fbacDf8C00F06b0E5B8d);
134     addressOfBountyMembers.push(0xd8d252a3d9F78cb0Dc7D84DBb26Ec1c985Ca1708);
135     addressOfBountyMembers.push(0xd9613A75671E43D8bDd0aE885979F77C3861889f);
136     addressOfBountyMembers.push(0xd97159dee2a2910728B9C5E969A2f7B0c75A6A58);
137     addressOfBountyMembers.push(0xda2574CFeB7De808c08E542000E62C4949ee3233);
138     addressOfBountyMembers.push(0xdA5c5dB1B98676512e44b410dBaE10569a243c80);
139     addressOfBountyMembers.push(0xDAE160453E5EEB4B434B26fEF80eD066186ee81C);
140     addressOfBountyMembers.push(0xDbA629F96797dd8f7eC582248C55Cef0Bb012571);
141     addressOfBountyMembers.push(0xdC1954625516A98007D91f7b79B15ac8232621eA);
142     addressOfBountyMembers.push(0xdC435eAA1409b62c7aCFC3a0EAE3ccA017aC01E0);
143     addressOfBountyMembers.push(0xDc448c748eFf181525c940c56bF69114e4Bd14FC);
144     addressOfBountyMembers.push(0xdD70fc7959a24335b8Ee1a072C3d9B0dDAD07540);
145     addressOfBountyMembers.push(0xdfA1E881fF9DbE73dE1735eCE093d3d0731f151F);
146     addressOfBountyMembers.push(0xdfb2e5082DB6651774C76F4EA6a7a7c02E403Db6);
147     addressOfBountyMembers.push(0xE0a762Ed5EB38D64a8DB5514E94b5b80ef255A54);
148     addressOfBountyMembers.push(0xe1950cB15faacAEA071b5CFD2e47BD343D166348);
149     addressOfBountyMembers.push(0xe1c455a5BE9e80fB7B66C8F37508B885082d8125);
150     addressOfBountyMembers.push(0xe2ce954168541195d258a4Cb0637d8fEe7Be60b1);
151     addressOfBountyMembers.push(0xe32928fDd23c1729d08874b64BfE441952f05b01);
152     addressOfBountyMembers.push(0xE45DAc759792b027647aD065aef6305327EF06D7);
153     addressOfBountyMembers.push(0xE692256D270946A407f8Ba9885D62e883479F0b8);
154     addressOfBountyMembers.push(0xe8033547581fE9D65a70D78B5e082bFB1aC2d1a9);
155     addressOfBountyMembers.push(0xE828c9894a7AaB9E855078CA42f92D950A9d8A9e);
156     addressOfBountyMembers.push(0xe85b1551e27Fa6D3004C858d73C5ff8E6128E8F5);
157     addressOfBountyMembers.push(0xEA0122F53DF01a0c160B4723d71e70F16b7376cF);
158     addressOfBountyMembers.push(0xeb699cd5e3c87baa79b5f1b9c52a18bfb62958df);
159     addressOfBountyMembers.push(0xEB8b8C5A22ADfc5339b56f0164eE35Ed5E9F53aB);
160     addressOfBountyMembers.push(0xeD4f7d1B35bE7773f1ee12c2Df2416b5fFa4D885);
161     addressOfBountyMembers.push(0xeEf3DE554EF8DCf34b4DF193572EEA6D75622b21);
162     addressOfBountyMembers.push(0xeFEdb29042F4845CE51807aEF60e5e2E8480100A);
163     addressOfBountyMembers.push(0xF0Bc249650555fb4d5cCC4D80939121BA238b7Df);
164     addressOfBountyMembers.push(0xF2338833abCCC416Ba7e73b1Ac38b24230928BaE);
165     addressOfBountyMembers.push(0xf2D26822fB5B87AC63D75F2e0067590C15c2EC87);
166     addressOfBountyMembers.push(0xf3bA1d7996F4D2E777d408bb4d59D2665B9361cc);
167     addressOfBountyMembers.push(0xF49bbCEC7940283EaFcfC97b191fef51baC03382);
168     addressOfBountyMembers.push(0xF4dd4FD3AD475A7BB35eE471817E7D6886cd663e);
169     addressOfBountyMembers.push(0xF54fAb200604ddDf868f3e397034F8c6d85BfA15);
170     addressOfBountyMembers.push(0xf5FF12b77601b7a4Efd6b3B0c5Dd8B3EC87c3b8f);
171     addressOfBountyMembers.push(0xF6168297046Ca6fa514834c30168e63A47256AF4);
172     addressOfBountyMembers.push(0xF68160A41e0fE12BD47c85dC7115DB160E45643C);
173     addressOfBountyMembers.push(0xF79685d7Ace7BCcE55eEbfE6EC0961a0D04EC93D);
174     addressOfBountyMembers.push(0xf7c28e2140fd84e1c0e4390bdceed6cc8fbda018);
175     addressOfBountyMembers.push(0xF9d8007df5bF04D5648e207b14Db6e4e318566a7);
176     addressOfBountyMembers.push(0xFB8337e9469968f4BEBdf9471C52F0AF8dAea7d2);
177     addressOfBountyMembers.push(0xfbaEb96CD0aaAc60fa238aa8e5Fd6A62D7a785Dc);
178     addressOfBountyMembers.push(0xfc6ea5d8e773d891503de0d2dc89ee86da130157);
179     addressOfBountyMembers.push(0xfc6ed1944c6f8ab954b60604632ace1e2f55b8cd);
180     addressOfBountyMembers.push(0xFCdB99C6f3c4bc0b492e68c0635089a92951e28A);
181     addressOfBountyMembers.push(0xFf168D1151BC1aA09B8f36fba3706410Efb22d44);
182     addressOfBountyMembers.push(0xfF90d4946fDc2Ffa2608345d10e17CCFa063A662);
183   }
184 
185   function setBountyAmounts() internal { 
186     bountyMembersAmounts[0xA8513A556B2d408a15b28AF9509F4219d9D759BD] =    13000000000000000000;
187     bountyMembersAmounts[0xa9CEaF2b628fFEe4c8DAa945972c6395f08d2791] =    12000000000000000000;
188     bountyMembersAmounts[0xaBaEF4cB77ddB7Ddd1Ed9Ec55aE3f4071d90FfC2] =  7884510000000000000000;
189     bountyMembersAmounts[0xae513e138CCFFF4D6576E949f4551dc1094E3381] =    30000000000000000000;
190     bountyMembersAmounts[0xb08C4238c1eC7E05DE8EB4CDD80C9FDc3Fa832BA] =    10000000000000000000;
191     bountyMembersAmounts[0xB1d5A2FaEEA58dCeE20Ea42Baf63688C14652B97] =    10000000000000000000;
192     bountyMembersAmounts[0xb2eB45F66d0c4c6Fa2b36629bb625108f2eee44C] =  1954000000000000000000;
193     bountyMembersAmounts[0xb393fd52a7e688e40462d87b9c6b61e8fdee458d] =  2634050000000000000000;
194     bountyMembersAmounts[0xb3c16193d4b8a0f3b3bad0956199213897672029] =    16000000000000000000;
195     bountyMembersAmounts[0xb62295AB5c3A46051d2b63b046707EaFcc94797d] =    10000000000000000000;
196     bountyMembersAmounts[0xB785bB546bE675c76f9E4Ca4BfbB047465621174] =    12000000000000000000;
197     bountyMembersAmounts[0xB7CC436233e2237bD8A9235C2f7185e82bB3bAfa] =    56000000000000000000;
198     bountyMembersAmounts[0xB82E3Cec9255fdc8dFC01e1a648f414D9CAd213C] =    13000000000000000000;
199     bountyMembersAmounts[0xb85b6a635F97aaBc7e1Be9d4fBf72c0039f04881] =  2110000000000000000000;
200     bountyMembersAmounts[0xB8f412210002594b71A058cB26F4a9CcB3488c65] =    10000000000000000000;
201     bountyMembersAmounts[0xb9b744F4b204e036DD00D59f9670eed2db162814] =   682390000000000000000;
202     bountyMembersAmounts[0xb9Cf4A1CCAFDcCD08B3a5D329922c88dEF80F56B] =   288000000000000000000;
203     bountyMembersAmounts[0xBa0Beaf2C73d7882ad1562A3F07F249E87D47aa0] =    20000000000000000000;
204     bountyMembersAmounts[0xBB5B0e8D5dc060e0f9c7291c896157e7B3880317] =    12000000000000000000;
205     bountyMembersAmounts[0xbBac285eAce15ACBa136F0Bb54f88c5e98b8EBe4] =    22000000000000000000;
206     bountyMembersAmounts[0xbBDeeA2457E77D6D6f63C2C02000e8bd5af0c513] =  2194000000000000000000;
207     bountyMembersAmounts[0xBBF268DB73a76D07aFF331F815E189DC1F9bc5B6] =   416000000000000000000;
208     bountyMembersAmounts[0xBC8fF0f24F8967C063367EDBE922c48E4abb2A85] =    52000000000000000000;
209     bountyMembersAmounts[0xbD3E04A43360Ac3A723980681a5A24835CE2C746] =    12000000000000000000;
210     bountyMembersAmounts[0xBD9AD25AF57aB5E74081E3F1A0dCbc6FE52B7FC8] =     8000000000000000000;
211     bountyMembersAmounts[0xbe13Cf151f0aCB6545ea1211CC43E31D25Fb954e] =  1018000000000000000000;
212     bountyMembersAmounts[0xBF1593D47c094efc32e39BBA951dE5B9902eEaA5] =   730000000000000000000;
213     bountyMembersAmounts[0xBf9951eeF974c9fE8c7C522122358EB3777a5c8C] =   144000000000000000000;
214     bountyMembersAmounts[0xc0c77D00Bc2464DcD7DC9161c49B2509cC700aEd] =  2339400000000000000000;
215     bountyMembersAmounts[0xC2DF47568805bd16EB7a4f0CC7015862D46226bd] =    12000000000000000000;
216     bountyMembersAmounts[0xc333C16bbfd0BA06545323204eB773ce7BE04E49] =    10000000000000000000;
217     bountyMembersAmounts[0xC3eb9D31F30EeD986402B68a70e30FB194169038] = 13469280000000000000000;
218     bountyMembersAmounts[0xc451219677F52F8c2c98538aC4F2f8B9cC90E095] =  2026000000000000000000;
219     bountyMembersAmounts[0xc4B61dF08b6CB6C98d0F37adfCB5d968eCc51e61] =    19000000000000000000;
220     bountyMembersAmounts[0xC4Be8FD7826fD63aE3fd9b4493327C492690D747] =    29000000000000000000;
221     bountyMembersAmounts[0xc50E4f63de1Cc99E506a765219C951161aBcA075] =    32000000000000000000;
222     bountyMembersAmounts[0xc6375c620dF0b0D20B92f6652460fbDacAb5Ad28] =    22000000000000000000;
223     bountyMembersAmounts[0xc697F60E7c6b325FA0485a37E535fE2185c97A82] =  2074000000000000000000;
224     bountyMembersAmounts[0xC8783c7252a21C9Cf588f703Bb6dc000935447a3] =  2038000000000000000000;
225     bountyMembersAmounts[0xC8EF8E565DBE2fCabC9E03518c7bAba2c76dc7d4] =    10000000000000000000;
226     bountyMembersAmounts[0xCB114d7F5e9f6C51EF500ef98Fe8132390Fc136e] =    10000000000000000000;
227     bountyMembersAmounts[0xcc023e9f32b4CbED3d57aa53C706cd9c692AB8cd] =    10000000000000000000;
228     bountyMembersAmounts[0xcc5Df7D489F55EDaB52da8481828ad332855eC66] =    10000000000000000000;
229     bountyMembersAmounts[0xcd7233b3d00dbac1805d733c4507b49ab74e246e] =    10000000000000000000;
230     bountyMembersAmounts[0xCdc464a8cdCeA65426092254C425CC30B3950813] =    22000000000000000000;
231     bountyMembersAmounts[0xcE18755068C88EF85526969A8ddB3c7BBB12d4AE] =    12000000000000000000;
232     bountyMembersAmounts[0xCE4BdDcD1251d99752f116608b9C756254d5E012] =  2218000000000000000000;
233     bountyMembersAmounts[0xD06021e55a3E293DCb99ddB98467234F866F9Ec3] =    10000000000000000000;
234     bountyMembersAmounts[0xd23cb30C6510ad1a8E080c3c580365f886a3Fc6D] =    10000000000000000000;
235     bountyMembersAmounts[0xD382c8F5CFdfD9fd0246B1B6b4eb57249A567a74] =    90000000000000000000;
236     bountyMembersAmounts[0xd3d3F77669734F32bEd1f57d1A85011AB7687A0E] =  1942000000000000000000;
237     bountyMembersAmounts[0xd3D6f9328006290F963676868E087d18c07d23a6] =  2750150000000000000000;
238     bountyMembersAmounts[0xD7938FA601153537c03842Ed1e328630437B1FCD] =  3651300000000000000000;
239     bountyMembersAmounts[0xd7bc5ec6a64ec88193d89b8564085cc363c30e80] =   957800000000000000000;
240     bountyMembersAmounts[0xd7DEC97cf9e412637a3F40bBdcAa7746f88cced1] =  1930000000000000000000;
241     bountyMembersAmounts[0xd8C7b05A523683De2AE8fbacDf8C00F06b0E5B8d] =    22000000000000000000;
242     bountyMembersAmounts[0xd8d252a3d9F78cb0Dc7D84DBb26Ec1c985Ca1708] =  1224000000000000000000;
243     bountyMembersAmounts[0xd9613A75671E43D8bDd0aE885979F77C3861889f] =  4066950000000000000000;
244     bountyMembersAmounts[0xd97159dee2a2910728B9C5E969A2f7B0c75A6A58] =    10000000000000000000;
245     bountyMembersAmounts[0xda2574CFeB7De808c08E542000E62C4949ee3233] =  5681400000000000000000;
246     bountyMembersAmounts[0xdA5c5dB1B98676512e44b410dBaE10569a243c80] =    12000000000000000000;
247     bountyMembersAmounts[0xDAE160453E5EEB4B434B26fEF80eD066186ee81C] =   210550000000000000000;
248     bountyMembersAmounts[0xDbA629F96797dd8f7eC582248C55Cef0Bb012571] =    12000000000000000000;
249     bountyMembersAmounts[0xdC1954625516A98007D91f7b79B15ac8232621eA] =   762000000000000000000;
250     bountyMembersAmounts[0xdC435eAA1409b62c7aCFC3a0EAE3ccA017aC01E0] =    22000000000000000000;
251     bountyMembersAmounts[0xDc448c748eFf181525c940c56bF69114e4Bd14FC] =   929950000000000000000;
252     bountyMembersAmounts[0xdD70fc7959a24335b8Ee1a072C3d9B0dDAD07540] =    19000000000000000000;
253     bountyMembersAmounts[0xdfA1E881fF9DbE73dE1735eCE093d3d0731f151F] =    10000000000000000000;
254     bountyMembersAmounts[0xdfb2e5082DB6651774C76F4EA6a7a7c02E403Db6] = 47963000000000000000000;
255     bountyMembersAmounts[0xE0a762Ed5EB38D64a8DB5514E94b5b80ef255A54] =    18000000000000000000;
256     bountyMembersAmounts[0xe1950cB15faacAEA071b5CFD2e47BD343D166348] =    22000000000000000000;
257     bountyMembersAmounts[0xe1c455a5BE9e80fB7B66C8F37508B885082d8125] =   470000000000000000000;
258     bountyMembersAmounts[0xe2ce954168541195d258a4Cb0637d8fEe7Be60b1] =   746000000000000000000;
259     bountyMembersAmounts[0xe32928fDd23c1729d08874b64BfE441952f05b01] =    19000000000000000000;
260     bountyMembersAmounts[0xE45DAc759792b027647aD065aef6305327EF06D7] =  1102000000000000000000;
261     bountyMembersAmounts[0xE692256D270946A407f8Ba9885D62e883479F0b8] =    89000000000000000000;
262     bountyMembersAmounts[0xe8033547581fE9D65a70D78B5e082bFB1aC2d1a9] =    18000000000000000000;
263     bountyMembersAmounts[0xE828c9894a7AaB9E855078CA42f92D950A9d8A9e] =    16000000000000000000;
264     bountyMembersAmounts[0xe85b1551e27Fa6D3004C858d73C5ff8E6128E8F5] =  2062000000000000000000;
265     bountyMembersAmounts[0xEA0122F53DF01a0c160B4723d71e70F16b7376cF] =  2098000000000000000000;
266     bountyMembersAmounts[0xeb699cd5e3c87baa79b5f1b9c52a18bfb62958df] =    22000000000000000000;
267     bountyMembersAmounts[0xEB8b8C5A22ADfc5339b56f0164eE35Ed5E9F53aB] =    33000000000000000000;
268     bountyMembersAmounts[0xeD4f7d1B35bE7773f1ee12c2Df2416b5fFa4D885] =   100000000000000000000;
269     bountyMembersAmounts[0xeEf3DE554EF8DCf34b4DF193572EEA6D75622b21] =    31000000000000000000;
270     bountyMembersAmounts[0xeFEdb29042F4845CE51807aEF60e5e2E8480100A] =    33000000000000000000;
271     bountyMembersAmounts[0xF0Bc249650555fb4d5cCC4D80939121BA238b7Df] =  1349300000000000000000;
272     bountyMembersAmounts[0xF2338833abCCC416Ba7e73b1Ac38b24230928BaE] =    10000000000000000000;
273     bountyMembersAmounts[0xf2D26822fB5B87AC63D75F2e0067590C15c2EC87] =    13000000000000000000;
274     bountyMembersAmounts[0xf3bA1d7996F4D2E777d408bb4d59D2665B9361cc] =  1978000000000000000000;
275     bountyMembersAmounts[0xF49bbCEC7940283EaFcfC97b191fef51baC03382] =    19000000000000000000;
276     bountyMembersAmounts[0xF4dd4FD3AD475A7BB35eE471817E7D6886cd663e] =    22000000000000000000;
277     bountyMembersAmounts[0xF54fAb200604ddDf868f3e397034F8c6d85BfA15] =   972500000000000000000;
278     bountyMembersAmounts[0xf5FF12b77601b7a4Efd6b3B0c5Dd8B3EC87c3b8f] =   442000000000000000000;
279     bountyMembersAmounts[0xF6168297046Ca6fa514834c30168e63A47256AF4] =  3994000000000000000000;
280     bountyMembersAmounts[0xF68160A41e0fE12BD47c85dC7115DB160E45643C] =    50000000000000000000;
281     bountyMembersAmounts[0xF79685d7Ace7BCcE55eEbfE6EC0961a0D04EC93D] =    13000000000000000000;
282     bountyMembersAmounts[0xf7c28e2140fd84e1c0e4390bdceed6cc8fbda018] =    16000000000000000000;
283     bountyMembersAmounts[0xF9d8007df5bF04D5648e207b14Db6e4e318566a7] =   136000000000000000000;
284     bountyMembersAmounts[0xFB8337e9469968f4BEBdf9471C52F0AF8dAea7d2] =   846650000000000000000;
285     bountyMembersAmounts[0xfbaEb96CD0aaAc60fa238aa8e5Fd6A62D7a785Dc] =   100000000000000000000;
286     bountyMembersAmounts[0xfc6ea5d8e773d891503de0d2dc89ee86da130157] =    10000000000000000000;
287     bountyMembersAmounts[0xfc6ed1944c6f8ab954b60604632ace1e2f55b8cd] =   428000000000000000000;
288     bountyMembersAmounts[0xFCdB99C6f3c4bc0b492e68c0635089a92951e28A] =   546000000000000000000;
289     bountyMembersAmounts[0xFf168D1151BC1aA09B8f36fba3706410Efb22d44] =  2005200000000000000000;
290     bountyMembersAmounts[0xfF90d4946fDc2Ffa2608345d10e17CCFa063A662] =   171000000000000000000;
291   } 
292 }