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
15 contract FourthBountyWPTpayoutCorrection {
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
83     addressOfBountyMembers.push(0x00acB4E06Eb8F7ABcFfc1EC6384227cb206b5bd0);
84     addressOfBountyMembers.push(0x07f964aBfC00f9571B392d78D0E8D0a303f527E9);
85     addressOfBountyMembers.push(0x09e9811B51642049700D0900b5E5F909D6EaA978);
86     addressOfBountyMembers.push(0x17303918fF12fD503961EBa5db01848De658729d);
87     addressOfBountyMembers.push(0x17DEcde632980aB7a8FFC1bA698Da3b7719427E9);
88     addressOfBountyMembers.push(0x1981d82819C4d1acD3447ecbBaf7660c88a92F0F);
89     addressOfBountyMembers.push(0x1af50bD294BbDd99d6ac0e5CB1c067BfC7818CF3);
90     addressOfBountyMembers.push(0x1C2C923A8168b607276b422eC05bB101b5579b41);
91     addressOfBountyMembers.push(0x230a23A0756e7CC528021d2e4EFF54DCA2101427);
92     addressOfBountyMembers.push(0x239993c2d7F16a6F68bbbF398885ef92ec75C888);
93     addressOfBountyMembers.push(0x239F3F8f4f5BA293EE9e38308053FCaa43b37bC6);
94     addressOfBountyMembers.push(0x27561111Bb09D76368343a9c85339Db43D28Fc7D);
95     addressOfBountyMembers.push(0x2B61F3BcD23D37d962A707e231bF3C53d1E9cDA7);
96     addressOfBountyMembers.push(0x2ca0b69fc3f6d4286F70a3eEC55beF25c1018544);
97     addressOfBountyMembers.push(0x2e9f5bfb07067df44f31519a80799884431876e1);
98     addressOfBountyMembers.push(0x3077D925F4399514a3349b6e812e290CBD0a2154);
99     addressOfBountyMembers.push(0x309c76d1aD3d58D6eB77Ba6b573e0A5efA1d3323);
100     addressOfBountyMembers.push(0x34596458488dba489e4b56ddab91061c4850d29b);
101     addressOfBountyMembers.push(0x3AE92BC56A517cC7d378FF0e0714479A33C3a7BA);
102     addressOfBountyMembers.push(0x3D4Af5b6C97e16624981DB89300d3b32Be62f727);
103     addressOfBountyMembers.push(0x3ee870e86693703996e441f986caaac31d7a5181);
104     addressOfBountyMembers.push(0x42B4813d89c65683c8671Eccc5De1F9c3A122140);
105     addressOfBountyMembers.push(0x43D9dD1950a78a21c6E615ad7A739eCAbB2F6F23);
106     addressOfBountyMembers.push(0x45334470D78f87E2b6097Ef520cC949ef5d7573F);
107     addressOfBountyMembers.push(0x460BAA28e768d0C9D1BFc885ad91B253C3373048);
108     addressOfBountyMembers.push(0x4F2dED30C27C4A7926B34c697Edd726aE379c3cE);
109     addressOfBountyMembers.push(0x56ACb598e1B89CD6Ca7b10C214B9108C543B385e);
110     addressOfBountyMembers.push(0x5826fe6d87Bc3088EEaAA8687f8d3e4416e146E8);
111     addressOfBountyMembers.push(0x5843787775CF8320C79f9dd60Be228aB0FF51123);
112     addressOfBountyMembers.push(0x59C5c4b795E9DB078c74BAcC0Fcad5cee75D1050);
113     addressOfBountyMembers.push(0x5B3fE56B7cfC456A5E721Df4b2d4A6b7ce7e4710);
114     addressOfBountyMembers.push(0x5c50564cEEEb5B85CFeeC31572A748cC1185356c);
115     addressOfBountyMembers.push(0x60cf7c40148370579133Fcf4e2bAe9Deec18ffb2);
116     addressOfBountyMembers.push(0x6169852ed50B5E59E998279109dACF0882414A59);
117     addressOfBountyMembers.push(0x63515D455393dDc5F8F321dd084d1bd000545573);
118     addressOfBountyMembers.push(0x6e414d17eE6A80f9fAc326a0b79364Bde6Ae0B9f);
119     addressOfBountyMembers.push(0x6e9c261D10575c87fE8724c54ccD26e59F77101a);
120     addressOfBountyMembers.push(0x6ed8eb597f47079e03c5913f8a010c7dec4e9185);
121     addressOfBountyMembers.push(0x70141ba86851D8A611fA79718D088bbfE39C9954);
122     addressOfBountyMembers.push(0x73274282F25E91D0D1724e09e9fF9bd250e3377A);
123     addressOfBountyMembers.push(0x74Ee49Cd610553D3e7f83bEe1873020ae1ddB469);
124     addressOfBountyMembers.push(0x780e64F06c13525CD4F09d069622D95d4E82D66E);
125     addressOfBountyMembers.push(0x7A3c9Eb1F276d08A326962b1582008d057b51932);
126     addressOfBountyMembers.push(0x8025CE2efE37e68b1496Cb08A2Cc49Db36E57eCd);
127     addressOfBountyMembers.push(0x834997EEAD7B42445fc7A8e8c2139C8263e74b4E);
128     addressOfBountyMembers.push(0x8617A519B2AD3e45a667B1773c16D7e1c6f06b39);
129     addressOfBountyMembers.push(0x8965C5Db7f9BD3ffd1084aF569843bBbBE54fB4e);
130     addressOfBountyMembers.push(0x8bDcdbA236161FEf354b854dCCcbD462e6C1e634);
131     addressOfBountyMembers.push(0x8DBCbb91d0955DE114A99E801bC70C86DFC68016);
132     addressOfBountyMembers.push(0x8e65028a1b1f35bcfff35f97cb59c272a48012cf);
133     addressOfBountyMembers.push(0x8F0BC0B7c6bA6b7058760a11Ced07a1990a8ebCA);
134     addressOfBountyMembers.push(0x8f6f9a2BA2130989F51D08138bfb72c4bfe873bd);
135     addressOfBountyMembers.push(0x9278dc8aee744C7356cE19b7E7c7386183d38Be7);
136     addressOfBountyMembers.push(0x928Fb44829B702Dcc0092839d6e0E45af0EA9BD6);
137     addressOfBountyMembers.push(0x94c30dBB7EA6df4FCAd8c8864Edfc9c59cB8Db14);
138     addressOfBountyMembers.push(0x9725274C250ba4A1294ee21710ACF963d46FD65F);
139     addressOfBountyMembers.push(0x98219CF8479cE2D8529d5D0F4d78784fc5dbcAfe);
140     addressOfBountyMembers.push(0x9a8e2538f8270d252db6e759e297f5f3646188e5);
141     addressOfBountyMembers.push(0x9b1a9dc875C4c94C80C66acb8eaaD86d1c11EB9f);
142     addressOfBountyMembers.push(0xac39e59F403Fb4d7A02dd6E7251481fa17f37518);
143     addressOfBountyMembers.push(0xac4c9c0d2931Fa5e29Baafbcaf4e5dB1cE8A1758);
144     addressOfBountyMembers.push(0xAEbC205C50399a7EDf248f17e188E3EcB6a4911a);
145     addressOfBountyMembers.push(0xB0f07308B6bd41Ac47B756dB61eEBaeF57ae8CCC);
146     addressOfBountyMembers.push(0xB41CDf4Dc95870B4A662cB6b8A51B8AABcb16F58);
147     addressOfBountyMembers.push(0xb5752D9e772411B2C1D449F5C38B2Be703181281);
148     addressOfBountyMembers.push(0xB73F5d6fED57ef3b6A624c918882010B38d6FeF5);
149     addressOfBountyMembers.push(0xB7f6584D898Efa6487Df14bE91abe871f9bf3038);
150     addressOfBountyMembers.push(0xb95da9acee36B95A8f8748c378f3aF39b8AE7087);
151     addressOfBountyMembers.push(0xbB829cD884c75c2539A0A7Baa5574a4CE0658426);
152     addressOfBountyMembers.push(0xBeE6E6B078b48ba5AAcb98D7f57Dd78496Af38dF);
153     addressOfBountyMembers.push(0xC0f321feed4B3ccAD81E4ECB8b5589d0baeBF710); 
154     addressOfBountyMembers.push(0xC158394aF351906e21Dc78d8a840ce8e2AF2F827);
155     addressOfBountyMembers.push(0xC1945c4872062CD0Dc7c59D5744C276d09a59a99);
156     addressOfBountyMembers.push(0xc1ee59265efa7d13f8592cddae514a5be4cdf4a8);
157     addressOfBountyMembers.push(0xc53167E7dFB4E98a98c193627C622680F6291ab5);
158     addressOfBountyMembers.push(0xCe241cb7ac5Aa67fd679EFffFF815E8A818B9319);
159     addressOfBountyMembers.push(0xcec52F799C80D75D4cEA2e281DA884c4129C67aA);
160     addressOfBountyMembers.push(0xd193466c05aae45f1C341447e8ee95BdBEa8297e);
161     addressOfBountyMembers.push(0xD382c8F5CFdfD9fd0246B1B6b4eb57249A567a74);
162     addressOfBountyMembers.push(0xD3E86478bF653C77f83737d831d1003ed447958c);
163     addressOfBountyMembers.push(0xD52c8572c1b7d831F4438d93DEF4b153bd221a79);
164     addressOfBountyMembers.push(0xD54C589E166D8A75374E985A580C00cA7936C7Be);
165     addressOfBountyMembers.push(0xD748a3fE50368D47163b3b1fDa780798970d99C1);
166     addressOfBountyMembers.push(0xd8A321513f1fdf6EE58f599159f3C2ea80349243);
167     addressOfBountyMembers.push(0xE26BDb9e61070b5d0816b1F027eB2D105B675093);
168     addressOfBountyMembers.push(0xe50817e5b1b36df3c9ad896a7548dce7ab52f6b3);
169     addressOfBountyMembers.push(0xe67464a674666e39E3EdB461549d4b91Ee430593);
170     addressOfBountyMembers.push(0xeA46A6BEb7CdA737dc49204424406cE6046297a6);
171     addressOfBountyMembers.push(0xecB40E29C0Ce2108305890BBdD6082D47a9Ddb5F);
172     addressOfBountyMembers.push(0xecdd6b136b186c0e59a159504eb6afbc8ab03fed);
173     addressOfBountyMembers.push(0xeEB9b9B40CCD80Fa3cCa2F2E3158482671f4D425);
174     addressOfBountyMembers.push(0xf22ca30049b37dc1b6650600549b0cd2bf5f3c64);
175     addressOfBountyMembers.push(0xf2418654Dd2e239EcBCF00aA2BC18aD8AF9bad52);
176     addressOfBountyMembers.push(0xf3415a0b9D0D1Ed2e666a07E090BE60957751832);
177     addressOfBountyMembers.push(0xF37bD5c2908ba069940a190b048E90696A91d89b);
178   }
179 
180   function setBountyAmounts() internal { 
181     bountyMembersAmounts[0x00acB4E06Eb8F7ABcFfc1EC6384227cb206b5bd0] =    876950000000000000000;
182     bountyMembersAmounts[0x07f964aBfC00f9571B392d78D0E8D0a303f527E9] =   1072000000000000000000;
183     bountyMembersAmounts[0x09e9811B51642049700D0900b5E5F909D6EaA978] =    206000000000000000000;
184     bountyMembersAmounts[0x17303918fF12fD503961EBa5db01848De658729d] =      2000000000000000000;
185     bountyMembersAmounts[0x17DEcde632980aB7a8FFC1bA698Da3b7719427E9] =    118000000000000000000;
186     bountyMembersAmounts[0x1981d82819C4d1acD3447ecbBaf7660c88a92F0F] =    137000000000000000000;
187     bountyMembersAmounts[0x1af50bD294BbDd99d6ac0e5CB1c067BfC7818CF3] =     31000000000000000000;
188     bountyMembersAmounts[0x1C2C923A8168b607276b422eC05bB101b5579b41] =     52000000000000000000;
189     bountyMembersAmounts[0x230a23A0756e7CC528021d2e4EFF54DCA2101427] =    605000000000000000000;
190     bountyMembersAmounts[0x239993c2d7F16a6F68bbbF398885ef92ec75C888] =     18000000000000000000;
191     bountyMembersAmounts[0x239F3F8f4f5BA293EE9e38308053FCaa43b37bC6] =     24000000000000000000;
192     bountyMembersAmounts[0x27561111Bb09D76368343a9c85339Db43D28Fc7D] =     52000000000000000000;
193     bountyMembersAmounts[0x2B61F3BcD23D37d962A707e231bF3C53d1E9cDA7] =    152000000000000000000;
194     bountyMembersAmounts[0x2ca0b69fc3f6d4286F70a3eEC55beF25c1018544] =    764000000000000000000;
195     bountyMembersAmounts[0x2e9f5bfb07067df44f31519a80799884431876e1] =     21000000000000000000;
196     bountyMembersAmounts[0x3077D925F4399514a3349b6e812e290CBD0a2154] =    283000000000000000000;
197     bountyMembersAmounts[0x309c76d1aD3d58D6eB77Ba6b573e0A5efA1d3323] =     18000000000000000000;
198     bountyMembersAmounts[0x34596458488dba489e4b56ddab91061c4850d29b] =     31000000000000000000;
199     bountyMembersAmounts[0x3AE92BC56A517cC7d378FF0e0714479A33C3a7BA] =   4279000000000000000000;
200     bountyMembersAmounts[0x3D4Af5b6C97e16624981DB89300d3b32Be62f727] =    381000000000000000000;
201     bountyMembersAmounts[0x3ee870e86693703996e441f986caaac31d7a5181] =    170000000000000000000;
202     bountyMembersAmounts[0x42B4813d89c65683c8671Eccc5De1F9c3A122140] =     11000000000000000000;
203     bountyMembersAmounts[0x43D9dD1950a78a21c6E615ad7A739eCAbB2F6F23] =   1293000000000000000000;
204     bountyMembersAmounts[0x45334470D78f87E2b6097Ef520cC949ef5d7573F] =     96000000000000000000;
205     bountyMembersAmounts[0x460BAA28e768d0C9D1BFc885ad91B253C3373048] =   2651000000000000000000;
206     bountyMembersAmounts[0x4F2dED30C27C4A7926B34c697Edd726aE379c3cE] =     47000000000000000000;
207     bountyMembersAmounts[0x56ACb598e1B89CD6Ca7b10C214B9108C543B385e] =  40296000000000000000000;
208     bountyMembersAmounts[0x5826fe6d87Bc3088EEaAA8687f8d3e4416e146E8] =     16000000000000000000;
209     bountyMembersAmounts[0x5843787775CF8320C79f9dd60Be228aB0FF51123] =     35000000000000000000;
210     bountyMembersAmounts[0x59C5c4b795E9DB078c74BAcC0Fcad5cee75D1050] =     15000000000000000000;
211     bountyMembersAmounts[0x5B3fE56B7cfC456A5E721Df4b2d4A6b7ce7e4710] =      5000000000000000000;
212     bountyMembersAmounts[0x5c50564cEEEb5B85CFeeC31572A748cC1185356c] =     22000000000000000000;
213     bountyMembersAmounts[0x60cf7c40148370579133Fcf4e2bAe9Deec18ffb2] =     72000000000000000000;
214     bountyMembersAmounts[0x6169852ed50B5E59E998279109dACF0882414A59] =     16000000000000000000;
215     bountyMembersAmounts[0x63515D455393dDc5F8F321dd084d1bd000545573] =     96000000000000000000;
216     bountyMembersAmounts[0x6e414d17eE6A80f9fAc326a0b79364Bde6Ae0B9f] =    458000000000000000000;
217     bountyMembersAmounts[0x6e9c261D10575c87fE8724c54ccD26e59F77101a] =    422000000000000000000;
218     bountyMembersAmounts[0x6ed8eb597f47079e03c5913f8a010c7dec4e9185] =     12000000000000000000;
219     bountyMembersAmounts[0x70141ba86851D8A611fA79718D088bbfE39C9954] =     24000000000000000000;
220     bountyMembersAmounts[0x73274282F25E91D0D1724e09e9fF9bd250e3377A] =    137000000000000000000;
221     bountyMembersAmounts[0x74Ee49Cd610553D3e7f83bEe1873020ae1ddB469] =     51000000000000000000;
222     bountyMembersAmounts[0x780e64F06c13525CD4F09d069622D95d4E82D66E] =     42000000000000000000;
223     bountyMembersAmounts[0x7A3c9Eb1F276d08A326962b1582008d057b51932] =    179000000000000000000;
224     bountyMembersAmounts[0x8025CE2efE37e68b1496Cb08A2Cc49Db36E57eCd] =    702000000000000000000;
225     bountyMembersAmounts[0x834997EEAD7B42445fc7A8e8c2139C8263e74b4E] =     74000000000000000000;
226     bountyMembersAmounts[0x8617A519B2AD3e45a667B1773c16D7e1c6f06b39] =   1764000000000000000000;
227     bountyMembersAmounts[0x8965C5Db7f9BD3ffd1084aF569843bBbBE54fB4e] =   1280000000000000000000;
228     bountyMembersAmounts[0x8bDcdbA236161FEf354b854dCCcbD462e6C1e634] =    898000000000000000000;
229     bountyMembersAmounts[0x8DBCbb91d0955DE114A99E801bC70C86DFC68016] =     60000000000000000000;
230     bountyMembersAmounts[0x8e65028a1b1f35bcfff35f97cb59c272a48012cf] =  35174326000000000000000;
231     bountyMembersAmounts[0x8F0BC0B7c6bA6b7058760a11Ced07a1990a8ebCA] =    504000000000000000000;
232     bountyMembersAmounts[0x8f6f9a2BA2130989F51D08138bfb72c4bfe873bd] =     89000000000000000000;
233     bountyMembersAmounts[0x9278dc8aee744C7356cE19b7E7c7386183d38Be7] =    114000000000000000000;
234     bountyMembersAmounts[0x928Fb44829B702Dcc0092839d6e0E45af0EA9BD6] =    995000000000000000000;
235     bountyMembersAmounts[0x94c30dBB7EA6df4FCAd8c8864Edfc9c59cB8Db14] =      9000000000000000000;
236     bountyMembersAmounts[0x9725274C250ba4A1294ee21710ACF963d46FD65F] =    669000000000000000000;
237     bountyMembersAmounts[0x98219CF8479cE2D8529d5D0F4d78784fc5dbcAfe] =     90000000000000000000;
238     bountyMembersAmounts[0x9a8e2538f8270d252db6e759e297f5f3646188e5] =     57000000000000000000;
239     bountyMembersAmounts[0x9b1a9dc875C4c94C80C66acb8eaaD86d1c11EB9f] =     43000000000000000000;
240     bountyMembersAmounts[0xac39e59F403Fb4d7A02dd6E7251481fa17f37518] =     29000000000000000000;
241     bountyMembersAmounts[0xac4c9c0d2931Fa5e29Baafbcaf4e5dB1cE8A1758] =     69000000000000000000;
242     bountyMembersAmounts[0xAEbC205C50399a7EDf248f17e188E3EcB6a4911a] =     84000000000000000000;
243     bountyMembersAmounts[0xB0f07308B6bd41Ac47B756dB61eEBaeF57ae8CCC] =     26000000000000000000;
244     bountyMembersAmounts[0xB41CDf4Dc95870B4A662cB6b8A51B8AABcb16F58] =     61000000000000000000;
245     bountyMembersAmounts[0xb5752D9e772411B2C1D449F5C38B2Be703181281] =      7000000000000000000;
246     bountyMembersAmounts[0xB73F5d6fED57ef3b6A624c918882010B38d6FeF5] =     11000000000000000000;
247     bountyMembersAmounts[0xB7f6584D898Efa6487Df14bE91abe871f9bf3038] =   1527000000000000000000;
248     bountyMembersAmounts[0xb95da9acee36B95A8f8748c378f3aF39b8AE7087] =    476000000000000000000;
249     bountyMembersAmounts[0xbB829cD884c75c2539A0A7Baa5574a4CE0658426] =    904000000000000000000;
250     bountyMembersAmounts[0xBeE6E6B078b48ba5AAcb98D7f57Dd78496Af38dF] =    283000000000000000000;
251     bountyMembersAmounts[0xC0f321feed4B3ccAD81E4ECB8b5589d0baeBF710] =    300000000000000000000;
252     bountyMembersAmounts[0xC158394aF351906e21Dc78d8a840ce8e2AF2F827] =     41000000000000000000;
253     bountyMembersAmounts[0xC1945c4872062CD0Dc7c59D5744C276d09a59a99] =   4546000000000000000000;
254     bountyMembersAmounts[0xc1ee59265efa7d13f8592cddae514a5be4cdf4a8] =   1841725000000000000000;
255     bountyMembersAmounts[0xc53167E7dFB4E98a98c193627C622680F6291ab5] =     38000000000000000000;
256     bountyMembersAmounts[0xCe241cb7ac5Aa67fd679EFffFF815E8A818B9319] =      3000000000000000000;
257     bountyMembersAmounts[0xcec52F799C80D75D4cEA2e281DA884c4129C67aA] =    161000000000000000000;
258     bountyMembersAmounts[0xd193466c05aae45f1C341447e8ee95BdBEa8297e] =     11000000000000000000;
259     bountyMembersAmounts[0xD382c8F5CFdfD9fd0246B1B6b4eb57249A567a74] =      9000000000000000000;
260     bountyMembersAmounts[0xD3E86478bF653C77f83737d831d1003ed447958c] =   4353460000000000000000;
261     bountyMembersAmounts[0xD52c8572c1b7d831F4438d93DEF4b153bd221a79] =      2000000000000000000;
262     bountyMembersAmounts[0xD54C589E166D8A75374E985A580C00cA7936C7Be] =     63000000000000000000;
263     bountyMembersAmounts[0xD748a3fE50368D47163b3b1fDa780798970d99C1] =    601200000000000000000;
264     bountyMembersAmounts[0xd8A321513f1fdf6EE58f599159f3C2ea80349243] =     10000000000000000000;
265     bountyMembersAmounts[0xE26BDb9e61070b5d0816b1F027eB2D105B675093] =     97000000000000000000;
266     bountyMembersAmounts[0xe50817e5b1b36df3c9ad896a7548dce7ab52f6b3] =    158000000000000000000;
267     bountyMembersAmounts[0xe67464a674666e39E3EdB461549d4b91Ee430593] =    118000000000000000000;
268     bountyMembersAmounts[0xeA46A6BEb7CdA737dc49204424406cE6046297a6] =     24000000000000000000;
269     bountyMembersAmounts[0xecB40E29C0Ce2108305890BBdD6082D47a9Ddb5F] =     50000000000000000000;
270     bountyMembersAmounts[0xecdd6b136b186c0e59a159504eb6afbc8ab03fed] =      4000000000000000000;
271     bountyMembersAmounts[0xeEB9b9B40CCD80Fa3cCa2F2E3158482671f4D425] =     24000000000000000000;
272     bountyMembersAmounts[0xf22ca30049b37dc1b6650600549b0cd2bf5f3c64] =      1000000000000000000;
273     bountyMembersAmounts[0xf2418654Dd2e239EcBCF00aA2BC18aD8AF9bad52] =    772000000000000000000;
274     bountyMembersAmounts[0xf3415a0b9D0D1Ed2e666a07E090BE60957751832] =    100000000000000000000;
275     bountyMembersAmounts[0xF37bD5c2908ba069940a190b048E90696A91d89b] =      8000000000000000000;
276   } 
277 }