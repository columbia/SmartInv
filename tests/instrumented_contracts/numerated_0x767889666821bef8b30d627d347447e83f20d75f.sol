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
15 contract SixthBountyWPTpayoutPart03 {
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
83     addressOfBountyMembers.push(0xB2d532C47304ba2366797467E922CD31072a061c);
84     addressOfBountyMembers.push(0xB3cbB7a925277512AFeC79f13E6F9f822D398479);
85     addressOfBountyMembers.push(0xB41CDf4Dc95870B4A662cB6b8A51B8AABcb16F58);
86     addressOfBountyMembers.push(0xb465Df34B5B13a52F696236e836922Aee4B358E9);
87     addressOfBountyMembers.push(0xb54D8A95c93a1B15BFE497F02EF8f75c2e5d5295);
88     addressOfBountyMembers.push(0xB5Bc739B48cbE03B57f0E6c87b502081E072f419);
89     addressOfBountyMembers.push(0xB6Ad21a93b0EAef00Af1899a910997e09a3e001F);
90     addressOfBountyMembers.push(0xb7393ac5CD3F9458b2947C8A5dbcA5485FB268b4);
91     addressOfBountyMembers.push(0xB7CC436233e2237bD8A9235C2f7185e82bB3bAfa);
92     addressOfBountyMembers.push(0xb83a12bD3c49fC403C3a669E62C096f365De3AB7);
93     addressOfBountyMembers.push(0xB91A8589a9251f4b7fA78cFd5A777A5d91f03900);
94     addressOfBountyMembers.push(0xbb04b1fff91E930F18675759ffE650cff9B15605);
95     addressOfBountyMembers.push(0xBb98A03CF2111C7F8a4cf37EBc7289E0E97D44cD);
96     addressOfBountyMembers.push(0xBbc99606258562B15E0C75EA8347E68262620821);
97     addressOfBountyMembers.push(0xBc9D4b3B8F3b54f616d3dDe9fCf56794D756acfE);
98     addressOfBountyMembers.push(0xBD46eAccfF870A03CC541b13af90157feFd77243);
99     addressOfBountyMembers.push(0xBF2bf97b7fBD319c849D4cB6540fA9974b7c578e);
100     addressOfBountyMembers.push(0xbF9418A10d49709479F5841e1A601568c92681ca);
101     addressOfBountyMembers.push(0xbfE581D4c4f563439EF23A128E8FD1B9F5341716);
102     addressOfBountyMembers.push(0xC00446a90D07E9bd17f66A35199A5DF61960c3BF);
103     addressOfBountyMembers.push(0xc0327e1c7495d41115a3e09d8e7c0901f1bdda9a);
104     addressOfBountyMembers.push(0xc2C053fCBC0E9d6eeE87F5cB0FA6AF12D3453186);
105     addressOfBountyMembers.push(0xc2C6869Ff474C656a56e7E0ed9dCfE6BEB6999A3);
106     addressOfBountyMembers.push(0xC3672b9eA7afa2d1E6Ae927AE90Af02A5874ad2f);
107     addressOfBountyMembers.push(0xC427603116EeecA5f96294a8587CDAf343CE921C);
108     addressOfBountyMembers.push(0xC473abC200d5C70149dE0540DE8382C09C747F25);
109     addressOfBountyMembers.push(0xC57c155Ef431dEFe65350dA723DD26199c4d89Db);
110     addressOfBountyMembers.push(0xc604563839f0e5D890FFc3BbfDBa6062d8D3b58D);
111     addressOfBountyMembers.push(0xc6c7fef406598d0487272454cc57fee6d9824991);
112     addressOfBountyMembers.push(0xC6D18625Eb428408f73f89025F66F4ae062EEE9b);
113     addressOfBountyMembers.push(0xC973f3c57a7d30d987d38eD022138598b94B7155);
114     addressOfBountyMembers.push(0xcA0775AEbc5b2e87E1d14F165fEa8D7a3Df85670);
115     addressOfBountyMembers.push(0xCb7615D4DACce04499f9F0f4a563Ca9e2721bd0E);
116     addressOfBountyMembers.push(0xCC11Ea3aD41d12Db96e7873424A977F1DC15aC1e);
117     addressOfBountyMembers.push(0xCc4BA2Fc6BA57f6286E0310bC2d371c686f423A7);
118     addressOfBountyMembers.push(0xcc9e3b52af888BCeb3Ab7F82FDD7e09EbdB46116);
119     addressOfBountyMembers.push(0xCEB1dC7335Ce38993cc18D1cB1682Aa1c467700a);
120     addressOfBountyMembers.push(0xD036eb66F7454cE25870a4927E53962A94371F1a);
121     addressOfBountyMembers.push(0xD039B9f35f8745E6f7de4CF1557fdd71F3C9a1C4);
122     addressOfBountyMembers.push(0xd0fb200a245e44efd2faa8c3b207bab8e8c03aa2);
123     addressOfBountyMembers.push(0xD0fF20bCb48598eb2152D72368BD879eD2C605DE);
124     addressOfBountyMembers.push(0xd3dE61685BAa88Ed9b9dd6d96d1Ac4E6209669D5);
125     addressOfBountyMembers.push(0xD4709f13192EC20D65883981F52CFe0543756E19);
126     addressOfBountyMembers.push(0xd5C12EbCED576d53b2b560635D0D2f65Aa3976b1);
127     addressOfBountyMembers.push(0xd5f2C07C8F0D37e10e6Db95A7405490f16bb8792);
128     addressOfBountyMembers.push(0xD7B0844225264fe15EAabE052B1E1B423095CD9a);
129     addressOfBountyMembers.push(0xd7e946e49A8475dBDaf209680D31E5D8d11C41F7);
130     addressOfBountyMembers.push(0xD902cCb411E6B576Ed567159e8e32e0dd7902488);
131     addressOfBountyMembers.push(0xD908293869fff7FB3b793d06Bd885097DE65221F);
132     addressOfBountyMembers.push(0xD9Ba5e9747Fda803616a4c23e3791E85F9F6ca81);
133     addressOfBountyMembers.push(0xda23Bb2A72B3e6C09c1441a1620075Bc040caE6a);
134     addressOfBountyMembers.push(0xda76c50E43912fB5A764b966915c270B9a637487);
135     addressOfBountyMembers.push(0xDA852caEDAC919c32226E1cF6Bb8F835302ce5D3);
136     addressOfBountyMembers.push(0xdC6BBca8D85D21F7aDdF7e1397AB1c2AD2bFE47a);
137     addressOfBountyMembers.push(0xDCD6230E9fF0B5c1bF0467BECDAE9c6399a322cB);
138     addressOfBountyMembers.push(0xDd4f48F32315d4B304Ab6DB44252e137F40322ff);
139     addressOfBountyMembers.push(0xdEA2E1128189005D419D528f74c0F936239236AB);
140     addressOfBountyMembers.push(0xDecC61Ac36960bFDc323e22D4a0336d8a95F38BC);
141     addressOfBountyMembers.push(0xDFC2C11DF23630166Cf71989F924E201ACcB6FAf);
142     addressOfBountyMembers.push(0xe0f3Db74c81DE193D258817952560fa4f3391743);
143     addressOfBountyMembers.push(0xe29153418A1FB15C7BDD2CE59568e82592cF4Ca3);
144     addressOfBountyMembers.push(0xe2ce954168541195d258a4Cb0637d8fEe7Be60b1);
145     addressOfBountyMembers.push(0xe3C245Cc49846fB9A0748b3617A22Aa06F8B9fac);
146     addressOfBountyMembers.push(0xE466B1eED921636833A3F95F980b0D5A11Dc8187);
147     addressOfBountyMembers.push(0xE473e7036DF4D95915F56C28669E527a3033e272);
148     addressOfBountyMembers.push(0xE4fDfbeD1fd241883fB2a19f65Aa0fDDeCab8702);
149     addressOfBountyMembers.push(0xE57ff2BF11d0dC9382C4C9A47B1dbD5Ca629FcAf);
150     addressOfBountyMembers.push(0xe5b210e21E6fFcE6ddd79ad0da889C1a3bEC1e30);
151     addressOfBountyMembers.push(0xe5d1C6c9c74f8c9cb16F0b86499250258a6164e1);
152     addressOfBountyMembers.push(0xE5ddeEFE43E2518BA8b17aEd649fa509cB94de4a);
153     addressOfBountyMembers.push(0xe7C30E9123FD0431Be5b4801f5fa194E0b0370c8);
154     addressOfBountyMembers.push(0xe9c580fcED39f2A882A7EDecCf8a74b43BEf94C1);
155     addressOfBountyMembers.push(0xEB057C509CF30cc45b0f52c8e507Ac3Cf8E78777);
156     addressOfBountyMembers.push(0xeD4f7d1B35bE7773f1ee12c2Df2416b5fFa4D885);
157     addressOfBountyMembers.push(0xEee00Dd01Ece2c5EaC353c617718FAaeBc720b38);
158     addressOfBountyMembers.push(0xef7998d7739188955d08329918850F62e4Dd9327);
159     addressOfBountyMembers.push(0xf02C37cB21fA6f41aF7B4abDdE231508Da6A7D50);
160     addressOfBountyMembers.push(0xf2418654Dd2e239EcBCF00aA2BC18aD8AF9bad52);
161     addressOfBountyMembers.push(0xf2c8EfEFd613e060bd8070574D883a435bF451c7);
162     addressOfBountyMembers.push(0xf2fcA6600baBF47a472dd25112565249Ae44E2b2);
163     addressOfBountyMembers.push(0xf3415a0b9D0D1Ed2e666a07E090BE60957751832);
164     addressOfBountyMembers.push(0xF360ABbDEA1283d342AD9CB3770e10597217d4b2);
165     addressOfBountyMembers.push(0xf38F3cA375D6F42C62EaEB08847C59566Ab02223);
166     addressOfBountyMembers.push(0xf42F424beD57676ea41531184C2b365710154E60);
167     addressOfBountyMembers.push(0xf456816d4c977353ba4406c25227eb5fc9153dfd);
168     addressOfBountyMembers.push(0xF6168297046Ca6fa514834c30168e63A47256AF4);
169     addressOfBountyMembers.push(0xF76B0b20A00cd1317EeBb0E996dBa0AC4C695507);
170     addressOfBountyMembers.push(0xf7857Cff1950DAf91e66b9315C10789E7E4eAc05);
171     addressOfBountyMembers.push(0xF8c3bEe3731CE96d583581ab7Cae4E89d0Ea9674);
172     addressOfBountyMembers.push(0xfa94467513238a72A8C439dcd9c5732FB019532B);
173     addressOfBountyMembers.push(0xfB2D5BfB9505dDeFD155F5C382DA25F2b1a2aFd2);
174     addressOfBountyMembers.push(0xfbaEb96CD0aaAc60fa238aa8e5Fd6A62D7a785Dc);
175     addressOfBountyMembers.push(0xfbf500671e998b9d4686c28793b26d34475d1394);
176     addressOfBountyMembers.push(0xfD179C076030AdcA551d5f6f7712A1a3319Ea8c3);
177     addressOfBountyMembers.push(0xfF12b9A55a92a7C981a1dEeaD0137cd2e5A2Fbf3);
178     addressOfBountyMembers.push(0xFf19EcdDFD6EFD53fB5ccA4209086dA95aCd0892);
179   }
180 
181   function setBountyAmounts() internal { 
182     bountyMembersAmounts[0xB2d532C47304ba2366797467E922CD31072a061c] =  130000000000000000000;
183     bountyMembersAmounts[0xB3cbB7a925277512AFeC79f13E6F9f822D398479] =  102000000000000000000;
184     bountyMembersAmounts[0xB41CDf4Dc95870B4A662cB6b8A51B8AABcb16F58] =  123000000000000000000;
185     bountyMembersAmounts[0xb465Df34B5B13a52F696236e836922Aee4B358E9] =  113000000000000000000;
186     bountyMembersAmounts[0xb54D8A95c93a1B15BFE497F02EF8f75c2e5d5295] =  204000000000000000000;
187     bountyMembersAmounts[0xB5Bc739B48cbE03B57f0E6c87b502081E072f419] =  218000000000000000000;
188     bountyMembersAmounts[0xB6Ad21a93b0EAef00Af1899a910997e09a3e001F] =  200000000000000000000;
189     bountyMembersAmounts[0xb7393ac5CD3F9458b2947C8A5dbcA5485FB268b4] =  188000000000000000000;
190     bountyMembersAmounts[0xB7CC436233e2237bD8A9235C2f7185e82bB3bAfa] =  100000000000000000000;
191     bountyMembersAmounts[0xb83a12bD3c49fC403C3a669E62C096f365De3AB7] =  125000000000000000000;
192     bountyMembersAmounts[0xB91A8589a9251f4b7fA78cFd5A777A5d91f03900] =  106000000000000000000;
193     bountyMembersAmounts[0xbb04b1fff91E930F18675759ffE650cff9B15605] =  523000000000000000000;
194     bountyMembersAmounts[0xBb98A03CF2111C7F8a4cf37EBc7289E0E97D44cD] =  256000000000000000000;
195     bountyMembersAmounts[0xBbc99606258562B15E0C75EA8347E68262620821] = 1328000000000000000000;
196     bountyMembersAmounts[0xBc9D4b3B8F3b54f616d3dDe9fCf56794D756acfE] =  104000000000000000000;
197     bountyMembersAmounts[0xBD46eAccfF870A03CC541b13af90157feFd77243] =  171000000000000000000;
198     bountyMembersAmounts[0xBF2bf97b7fBD319c849D4cB6540fA9974b7c578e] = 1100000000000000000000;
199     bountyMembersAmounts[0xbF9418A10d49709479F5841e1A601568c92681ca] =  135000000000000000000;
200     bountyMembersAmounts[0xbfE581D4c4f563439EF23A128E8FD1B9F5341716] =  230000000000000000000;
201     bountyMembersAmounts[0xC00446a90D07E9bd17f66A35199A5DF61960c3BF] =  142000000000000000000;
202     bountyMembersAmounts[0xc0327e1c7495d41115a3e09d8e7c0901f1bdda9a] =  208000000000000000000;
203     bountyMembersAmounts[0xc2C053fCBC0E9d6eeE87F5cB0FA6AF12D3453186] =  191000000000000000000;
204     bountyMembersAmounts[0xc2C6869Ff474C656a56e7E0ed9dCfE6BEB6999A3] =  117000000000000000000;
205     bountyMembersAmounts[0xC3672b9eA7afa2d1E6Ae927AE90Af02A5874ad2f] =  100000000000000000000;
206     bountyMembersAmounts[0xC427603116EeecA5f96294a8587CDAf343CE921C] =  146000000000000000000;
207     bountyMembersAmounts[0xC473abC200d5C70149dE0540DE8382C09C747F25] =  141000000000000000000;
208     bountyMembersAmounts[0xC57c155Ef431dEFe65350dA723DD26199c4d89Db] =  105000000000000000000;
209     bountyMembersAmounts[0xc604563839f0e5D890FFc3BbfDBa6062d8D3b58D] =  118000000000000000000;
210     bountyMembersAmounts[0xc6c7fef406598d0487272454cc57fee6d9824991] =  224000000000000000000;
211     bountyMembersAmounts[0xC6D18625Eb428408f73f89025F66F4ae062EEE9b] =  210000000000000000000;
212     bountyMembersAmounts[0xC973f3c57a7d30d987d38eD022138598b94B7155] =  120000000000000000000;
213     bountyMembersAmounts[0xcA0775AEbc5b2e87E1d14F165fEa8D7a3Df85670] =  524000000000000000000;
214     bountyMembersAmounts[0xCb7615D4DACce04499f9F0f4a563Ca9e2721bd0E] =  266000000000000000000;
215     bountyMembersAmounts[0xCC11Ea3aD41d12Db96e7873424A977F1DC15aC1e] =  155000000000000000000;
216     bountyMembersAmounts[0xCc4BA2Fc6BA57f6286E0310bC2d371c686f423A7] =  285000000000000000000;
217     bountyMembersAmounts[0xcc9e3b52af888BCeb3Ab7F82FDD7e09EbdB46116] =  181000000000000000000;
218     bountyMembersAmounts[0xCEB1dC7335Ce38993cc18D1cB1682Aa1c467700a] =  133000000000000000000;
219     bountyMembersAmounts[0xD036eb66F7454cE25870a4927E53962A94371F1a] =  167000000000000000000;
220     bountyMembersAmounts[0xD039B9f35f8745E6f7de4CF1557fdd71F3C9a1C4] =  335000000000000000000;
221     bountyMembersAmounts[0xd0fb200a245e44efd2faa8c3b207bab8e8c03aa2] =  138000000000000000000;
222     bountyMembersAmounts[0xD0fF20bCb48598eb2152D72368BD879eD2C605DE] =  134000000000000000000;
223     bountyMembersAmounts[0xd3dE61685BAa88Ed9b9dd6d96d1Ac4E6209669D5] =  212000000000000000000;
224     bountyMembersAmounts[0xD4709f13192EC20D65883981F52CFe0543756E19] =  100000000000000000000;
225     bountyMembersAmounts[0xd5C12EbCED576d53b2b560635D0D2f65Aa3976b1] =  154000000000000000000;
226     bountyMembersAmounts[0xd5f2C07C8F0D37e10e6Db95A7405490f16bb8792] =  107000000000000000000;
227     bountyMembersAmounts[0xD7B0844225264fe15EAabE052B1E1B423095CD9a] =  135000000000000000000;
228     bountyMembersAmounts[0xd7e946e49A8475dBDaf209680D31E5D8d11C41F7] =  110000000000000000000;
229     bountyMembersAmounts[0xD902cCb411E6B576Ed567159e8e32e0dd7902488] =  168000000000000000000;
230     bountyMembersAmounts[0xD908293869fff7FB3b793d06Bd885097DE65221F] =  185000000000000000000;
231     bountyMembersAmounts[0xD9Ba5e9747Fda803616a4c23e3791E85F9F6ca81] =  100000000000000000000;
232     bountyMembersAmounts[0xda23Bb2A72B3e6C09c1441a1620075Bc040caE6a] =  100000000000000000000;
233     bountyMembersAmounts[0xda76c50E43912fB5A764b966915c270B9a637487] =  340000000000000000000;
234     bountyMembersAmounts[0xDA852caEDAC919c32226E1cF6Bb8F835302ce5D3] =  148000000000000000000;
235     bountyMembersAmounts[0xdC6BBca8D85D21F7aDdF7e1397AB1c2AD2bFE47a] =  141000000000000000000;
236     bountyMembersAmounts[0xDCD6230E9fF0B5c1bF0467BECDAE9c6399a322cB] =  155000000000000000000;
237     bountyMembersAmounts[0xDd4f48F32315d4B304Ab6DB44252e137F40322ff] =  119000000000000000000;
238     bountyMembersAmounts[0xdEA2E1128189005D419D528f74c0F936239236AB] =  103000000000000000000;
239     bountyMembersAmounts[0xDecC61Ac36960bFDc323e22D4a0336d8a95F38BC] =  152000000000000000000;
240     bountyMembersAmounts[0xDFC2C11DF23630166Cf71989F924E201ACcB6FAf] =  100000000000000000000;
241     bountyMembersAmounts[0xe0f3Db74c81DE193D258817952560fa4f3391743] =  114000000000000000000;
242     bountyMembersAmounts[0xe29153418A1FB15C7BDD2CE59568e82592cF4Ca3] =  102000000000000000000;
243     bountyMembersAmounts[0xe2ce954168541195d258a4Cb0637d8fEe7Be60b1] =  449000000000000000000;
244     bountyMembersAmounts[0xe3C245Cc49846fB9A0748b3617A22Aa06F8B9fac] =  143000000000000000000;
245     bountyMembersAmounts[0xE466B1eED921636833A3F95F980b0D5A11Dc8187] =  100000000000000000000;
246     bountyMembersAmounts[0xE473e7036DF4D95915F56C28669E527a3033e272] =  170000000000000000000;
247     bountyMembersAmounts[0xE4fDfbeD1fd241883fB2a19f65Aa0fDDeCab8702] =  397000000000000000000;
248     bountyMembersAmounts[0xE57ff2BF11d0dC9382C4C9A47B1dbD5Ca629FcAf] =  207000000000000000000;
249     bountyMembersAmounts[0xe5b210e21E6fFcE6ddd79ad0da889C1a3bEC1e30] =  227000000000000000000;
250     bountyMembersAmounts[0xe5d1C6c9c74f8c9cb16F0b86499250258a6164e1] =  156000000000000000000;
251     bountyMembersAmounts[0xE5ddeEFE43E2518BA8b17aEd649fa509cB94de4a] =  194000000000000000000;
252     bountyMembersAmounts[0xe7C30E9123FD0431Be5b4801f5fa194E0b0370c8] =  103000000000000000000;
253     bountyMembersAmounts[0xe9c580fcED39f2A882A7EDecCf8a74b43BEf94C1] =  164000000000000000000;
254     bountyMembersAmounts[0xEB057C509CF30cc45b0f52c8e507Ac3Cf8E78777] =  122000000000000000000;
255     bountyMembersAmounts[0xeD4f7d1B35bE7773f1ee12c2Df2416b5fFa4D885] =  189000000000000000000;
256     bountyMembersAmounts[0xEee00Dd01Ece2c5EaC353c617718FAaeBc720b38] =  115000000000000000000;
257     bountyMembersAmounts[0xef7998d7739188955d08329918850F62e4Dd9327] =  102000000000000000000;
258     bountyMembersAmounts[0xf02C37cB21fA6f41aF7B4abDdE231508Da6A7D50] =  123000000000000000000;
259     bountyMembersAmounts[0xf2418654Dd2e239EcBCF00aA2BC18aD8AF9bad52] = 3810000000000000000000;
260     bountyMembersAmounts[0xf2c8EfEFd613e060bd8070574D883a435bF451c7] =  249000000000000000000;
261     bountyMembersAmounts[0xf2fcA6600baBF47a472dd25112565249Ae44E2b2] =  126000000000000000000;
262     bountyMembersAmounts[0xf3415a0b9D0D1Ed2e666a07E090BE60957751832] =  105000000000000000000;
263     bountyMembersAmounts[0xF360ABbDEA1283d342AD9CB3770e10597217d4b2] =  206000000000000000000;
264     bountyMembersAmounts[0xf38F3cA375D6F42C62EaEB08847C59566Ab02223] =  102000000000000000000;
265     bountyMembersAmounts[0xf42F424beD57676ea41531184C2b365710154E60] =  104000000000000000000;
266     bountyMembersAmounts[0xf456816d4c977353ba4406c25227eb5fc9153dfd] =  103000000000000000000;
267     bountyMembersAmounts[0xF6168297046Ca6fa514834c30168e63A47256AF4] =  672000000000000000000;
268     bountyMembersAmounts[0xF76B0b20A00cd1317EeBb0E996dBa0AC4C695507] =  102000000000000000000;
269     bountyMembersAmounts[0xf7857Cff1950DAf91e66b9315C10789E7E4eAc05] =  202000000000000000000;
270     bountyMembersAmounts[0xF8c3bEe3731CE96d583581ab7Cae4E89d0Ea9674] =  150000000000000000000;
271     bountyMembersAmounts[0xfa94467513238a72A8C439dcd9c5732FB019532B] =  210000000000000000000;
272     bountyMembersAmounts[0xfB2D5BfB9505dDeFD155F5C382DA25F2b1a2aFd2] =  200000000000000000000;
273     bountyMembersAmounts[0xfbaEb96CD0aaAc60fa238aa8e5Fd6A62D7a785Dc] =  118000000000000000000;
274     bountyMembersAmounts[0xfbf500671e998b9d4686c28793b26d34475d1394] =  135000000000000000000;
275     bountyMembersAmounts[0xfD179C076030AdcA551d5f6f7712A1a3319Ea8c3] =  142000000000000000000;
276     bountyMembersAmounts[0xfF12b9A55a92a7C981a1dEeaD0137cd2e5A2Fbf3] =  108000000000000000000;
277     bountyMembersAmounts[0xFf19EcdDFD6EFD53fB5ccA4209086dA95aCd0892] =  135000000000000000000;
278   } 
279 }