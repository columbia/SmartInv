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
15 contract FourthBountyWPTpayoutPart2 {
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
83     addressOfBountyMembers.push(0x791590abb95c197ea9591Dfaced984Ed0f664DE3);
84     addressOfBountyMembers.push(0x7A3c9Eb1F276d08A326962b1582008d057b51932);
85     addressOfBountyMembers.push(0x7A5E69fd60B3CA26061e5a967dC750C4112793d0);
86     addressOfBountyMembers.push(0x8025CE2efE37e68b1496Cb08A2Cc49Db36E57eCd);
87     addressOfBountyMembers.push(0x80E068E463BE9867E2b63823a516BfDe82aFaFeC);
88     addressOfBountyMembers.push(0x8152E9E1b7408B5f7c02cA54f85f245E7D013B5d);
89     addressOfBountyMembers.push(0x834997EEAD7B42445fc7A8e8c2139C8263e74b4E);
90     addressOfBountyMembers.push(0x8617A519B2AD3e45a667B1773c16D7e1c6f06b39);
91     addressOfBountyMembers.push(0x86c28d49da97c65dc672f36b7176eaa24b8daa49);
92     addressOfBountyMembers.push(0x8965C5Db7f9BD3ffd1084aF569843bBbBE54fB4e);
93     addressOfBountyMembers.push(0x8bDcdbA236161FEf354b854dCCcbD462e6C1e634);
94     addressOfBountyMembers.push(0x8DBCbb91d0955DE114A99E801bC70C86DFC68016);
95     addressOfBountyMembers.push(0x8e65028a1b1f35bcfff35f97cb59c272a48012cf);
96     addressOfBountyMembers.push(0x8F0BC0B7c6bA6b7058760a11Ced07a1990a8ebCA);
97     addressOfBountyMembers.push(0x8f6f9a2BA2130989F51D08138bfb72c4bfe873bd);
98     addressOfBountyMembers.push(0x915cee02bd1551c0e1555dfba83eb0117532b49a);
99     addressOfBountyMembers.push(0x9278dc8aee744C7356cE19b7E7c7386183d38Be7);
100     addressOfBountyMembers.push(0x928Fb44829B702Dcc0092839d6e0E45af0EA9BD6);
101     addressOfBountyMembers.push(0x94c30dBB7EA6df4FCAd8c8864Edfc9c59cB8Db14);
102     addressOfBountyMembers.push(0x9604Fd1F86b9DA08A20DbA9306B5021CF3689bB7);
103     addressOfBountyMembers.push(0x96Ad6E2103f6eCF8b93d7552eafaEdC91317c931);
104     addressOfBountyMembers.push(0x9725274C250ba4A1294ee21710ACF963d46FD65F);
105     addressOfBountyMembers.push(0x9804381AfeCf83fa8B0E7Ad1B023d84d89269bA5);
106     addressOfBountyMembers.push(0x98219CF8479cE2D8529d5D0F4d78784fc5dbcAfe);
107     addressOfBountyMembers.push(0x9a8e2538f8270d252db6e759e297f5f3646188e5);
108     addressOfBountyMembers.push(0x9b1a9dc875C4c94C80C66acb8eaaD86d1c11EB9f);
109     addressOfBountyMembers.push(0x9c8eE3ABaf15fb94828b66b4B88B6da3aCBC4314);
110     addressOfBountyMembers.push(0x9eE59c11458D564f83c056aF679da378a1f990a2);
111     addressOfBountyMembers.push(0x9f41fed399e5734cae683323aA9da9ED01b80B19);
112     addressOfBountyMembers.push(0xA2BFda9c4E7942825A15D099080eA5BE922787C7);
113     addressOfBountyMembers.push(0xA40768CDdF64ba0D1A866a80EF62faC1FBa1992D);
114     addressOfBountyMembers.push(0xa49eeFb65F935910A8352002b74423862D75747b);
115     addressOfBountyMembers.push(0xA9d61BAB323503F0A42d4bFD7497934aFec316db);
116     addressOfBountyMembers.push(0xac39e59F403Fb4d7A02dd6E7251481fa17f37518);
117     addressOfBountyMembers.push(0xac4c9c0d2931Fa5e29Baafbcaf4e5dB1cE8A1758);
118     addressOfBountyMembers.push(0xAEbC205C50399a7EDf248f17e188E3EcB6a4911a);
119     addressOfBountyMembers.push(0xB0f07308B6bd41Ac47B756dB61eEBaeF57ae8CCC);
120     addressOfBountyMembers.push(0xB41CDf4Dc95870B4A662cB6b8A51B8AABcb16F58);
121     addressOfBountyMembers.push(0xb5752D9e772411B2C1D449F5C38B2Be703181281);
122     addressOfBountyMembers.push(0xB5b97e673Fc89aD0a4D58660FbE0ADEa8cc4f71a);
123     addressOfBountyMembers.push(0xB73F5d6fED57ef3b6A624c918882010B38d6FeF5);
124     addressOfBountyMembers.push(0xB7f6584D898Efa6487Df14bE91abe871f9bf3038);
125     addressOfBountyMembers.push(0xb929d51980d4018b7b3fF84BEE63fAf8B3eABce6);
126     addressOfBountyMembers.push(0xb95da9acee36B95A8f8748c378f3aF39b8AE7087);
127     addressOfBountyMembers.push(0xB969085589eBAb0b0Ac190528720a2E2b5ec7af8);
128     addressOfBountyMembers.push(0xbB829cD884c75c2539A0A7Baa5574a4CE0658426);
129     addressOfBountyMembers.push(0xbBd4da3e86f610aDCF555fF3b2F51869eD5C7Cca);
130     addressOfBountyMembers.push(0xbDaaF43a9e7bd46B9a0902Ac6B197A8665fB240C);
131     addressOfBountyMembers.push(0xbea37D67eF2979942fcd5e8715892F98901427ba);
132     addressOfBountyMembers.push(0xBeE6E6B078b48ba5AAcb98D7f57Dd78496Af38dF);
133     addressOfBountyMembers.push(0xBF0dcf8af2F8695dB49c7cF4C587635003BBBafB);
134     addressOfBountyMembers.push(0xC0f321feed4B3ccAD81E4ECB8b5589d0baeBF710);
135     addressOfBountyMembers.push(0xC158394aF351906e21Dc78d8a840ce8e2AF2F827);
136     addressOfBountyMembers.push(0xC1945c4872062CD0Dc7c59D5744C276d09a59a99);
137     addressOfBountyMembers.push(0xc1ee59265efa7d13f8592cddae514a5be4cdf4a8);
138     addressOfBountyMembers.push(0xc53167E7dFB4E98a98c193627C622680F6291ab5);
139     addressOfBountyMembers.push(0xc81e5886AbDE2D4664e8A4F215F032E0d10F7114);
140     addressOfBountyMembers.push(0xc8200a3e8576E5f779E845D7e168FD2463b7CeD1);
141     addressOfBountyMembers.push(0xC8fdF66fa1C2B1873076b3abe9A8275A2D84db60);
142     addressOfBountyMembers.push(0xcac5e66ac94D8BF511d9D6e840fd7c7Ed077D07f);
143     addressOfBountyMembers.push(0xCe241cb7ac5Aa67fd679EFffFF815E8A818B9319);
144     addressOfBountyMembers.push(0xcec52F799C80D75D4cEA2e281DA884c4129C67aA);
145     addressOfBountyMembers.push(0xd193466c05aae45f1C341447e8ee95BdBEa8297e);
146     addressOfBountyMembers.push(0xD382c8F5CFdfD9fd0246B1B6b4eb57249A567a74);
147     addressOfBountyMembers.push(0xD3E86478bF653C77f83737d831d1003ed447958c);
148     addressOfBountyMembers.push(0xD52c8572c1b7d831F4438d93DEF4b153bd221a79);
149     addressOfBountyMembers.push(0xD54C589E166D8A75374E985A580C00cA7936C7Be);
150     addressOfBountyMembers.push(0xd568cA92ee7fF3AbEef1E32ca31931843bed4758);
151     addressOfBountyMembers.push(0xD748a3fE50368D47163b3b1fDa780798970d99C1);
152     addressOfBountyMembers.push(0xd7879a4662A2a397B1937FB6954cAffae0ee6a0d);
153     addressOfBountyMembers.push(0xd8A321513f1fdf6EE58f599159f3C2ea80349243);
154     addressOfBountyMembers.push(0xd9fE06e655699EF67f47DaF4067E21700182E3Dc);
155     addressOfBountyMembers.push(0xdE361C58D32465DFD17434127a37145c29d16C54);
156     addressOfBountyMembers.push(0xe18848EA4f7dF1d2861312932ccB28fCF5453707);
157     addressOfBountyMembers.push(0xE26BDb9e61070b5d0816b1F027eB2D105B675093);
158     addressOfBountyMembers.push(0xE27C464Cec75CEeFD49485ed77C177D5e225362a);
159     addressOfBountyMembers.push(0xe50817e5b1b36df3c9ad896a7548dce7ab52f6b3);
160     addressOfBountyMembers.push(0xe54AbAADd0FDbF41cC1EB7da616AdAB517b372d1);
161     addressOfBountyMembers.push(0xe67464a674666e39E3EdB461549d4b91Ee430593);
162     addressOfBountyMembers.push(0xe8a718296Edcd56132A2de6045965dDDA8f7176B);
163     addressOfBountyMembers.push(0xe8B400c93B829d2B46d2fe8B730412373a4822Bf);
164     addressOfBountyMembers.push(0xeA46A6BEb7CdA737dc49204424406cE6046297a6);
165     addressOfBountyMembers.push(0xecB40E29C0Ce2108305890BBdD6082D47a9Ddb5F);
166     addressOfBountyMembers.push(0xecdd6b136b186c0e59a159504eb6afbc8ab03fed);
167     addressOfBountyMembers.push(0xed3d95daB05B502a75Ed7b7e8485FE81A193Ef2C);
168     addressOfBountyMembers.push(0xeEB9b9B40CCD80Fa3cCa2F2E3158482671f4D425);
169     addressOfBountyMembers.push(0xeFfdA5F2B388aCF369D642C34406C498BE1c9a14);
170     addressOfBountyMembers.push(0xf0e02baD9b0d9bF5b64b19752FD018073CC60E72);
171     addressOfBountyMembers.push(0xf22ca30049b37dc1b6650600549b0cd2bf5f3c64);
172     addressOfBountyMembers.push(0xf2418654Dd2e239EcBCF00aA2BC18aD8AF9bad52);
173     addressOfBountyMembers.push(0xf3415a0b9D0D1Ed2e666a07E090BE60957751832);
174     addressOfBountyMembers.push(0xF37bD5c2908ba069940a190b048E90696A91d89b);
175     addressOfBountyMembers.push(0xf3ff4BC6CB99cD72E59c15144fF141d2a323D70b);
176     addressOfBountyMembers.push(0xF70F9512C3D1739BD09623B68Ed89a9b1dBb5f3B);
177     addressOfBountyMembers.push(0xF7De64DeC2e3c8CEF47836A2FB904bE979139D8a);
178     addressOfBountyMembers.push(0xF7e0AeE36D0170AB5f66e5d76515ae4B147c64dd);
179     addressOfBountyMembers.push(0xf96A5f15d602bC332F33439e6845CC4218EF2e59);
180     addressOfBountyMembers.push(0xf9c4292AE2944452c7F56e8bb4fB63ddF830f034);
181     addressOfBountyMembers.push(0xFc7a64183f49f71A1D604496E62c08f20aF5b5d6);
182   }
183 
184   function setBountyAmounts() internal {
185     bountyMembersAmounts[0x791590abb95c197ea9591Dfaced984Ed0f664DE3] =   107000000000000000000;	  
186     bountyMembersAmounts[0x7A3c9Eb1F276d08A326962b1582008d057b51932] =   134000000000000000000;
187     bountyMembersAmounts[0x7A5E69fd60B3CA26061e5a967dC750C4112793d0] =   102000000000000000000;
188     bountyMembersAmounts[0x8025CE2efE37e68b1496Cb08A2Cc49Db36E57eCd] =   105000000000000000000;
189     bountyMembersAmounts[0x80E068E463BE9867E2b63823a516BfDe82aFaFeC] =   152000000000000000000;
190     bountyMembersAmounts[0x8152E9E1b7408B5f7c02cA54f85f245E7D013B5d] =   127000000000000000000;
191     bountyMembersAmounts[0x834997EEAD7B42445fc7A8e8c2139C8263e74b4E] =   146000000000000000000;
192     bountyMembersAmounts[0x8617A519B2AD3e45a667B1773c16D7e1c6f06b39] =   102000000000000000000;
193     bountyMembersAmounts[0x86c28d49da97c65dc672f36b7176eaa24b8daa49] =   415000000000000000000;
194     bountyMembersAmounts[0x8965C5Db7f9BD3ffd1084aF569843bBbBE54fB4e] =   102000000000000000000;
195     bountyMembersAmounts[0x8bDcdbA236161FEf354b854dCCcbD462e6C1e634] =   102000000000000000000;
196     bountyMembersAmounts[0x8DBCbb91d0955DE114A99E801bC70C86DFC68016] =   111000000000000000000;
197     bountyMembersAmounts[0x8e65028a1b1f35bcfff35f97cb59c272a48012cf] =   208000000000000000000;
198     bountyMembersAmounts[0x8F0BC0B7c6bA6b7058760a11Ced07a1990a8ebCA] =   102000000000000000000;
199     bountyMembersAmounts[0x8f6f9a2BA2130989F51D08138bfb72c4bfe873bd] =   896000000000000000000;
200     bountyMembersAmounts[0x915cee02bd1551c0e1555dfba83eb0117532b49a] =   129000000000000000000;
201     bountyMembersAmounts[0x9278dc8aee744C7356cE19b7E7c7386183d38Be7] =   100000000000000000000;
202     bountyMembersAmounts[0x928Fb44829B702Dcc0092839d6e0E45af0EA9BD6] =   136000000000000000000;
203     bountyMembersAmounts[0x94c30dBB7EA6df4FCAd8c8864Edfc9c59cB8Db14] =   176000000000000000000;
204     bountyMembersAmounts[0x9604Fd1F86b9DA08A20DbA9306B5021CF3689bB7] =   104000000000000000000;
205     bountyMembersAmounts[0x96Ad6E2103f6eCF8b93d7552eafaEdC91317c931] =   596000000000000000000;
206     bountyMembersAmounts[0x9725274C250ba4A1294ee21710ACF963d46FD65F] =   102000000000000000000;
207     bountyMembersAmounts[0x9804381AfeCf83fa8B0E7Ad1B023d84d89269bA5] =   103000000000000000000;
208     bountyMembersAmounts[0x98219CF8479cE2D8529d5D0F4d78784fc5dbcAfe] =   100000000000000000000;
209     bountyMembersAmounts[0x9a8e2538f8270d252db6e759e297f5f3646188e5] =   276000000000000000000;
210     bountyMembersAmounts[0x9b1a9dc875C4c94C80C66acb8eaaD86d1c11EB9f] =   109000000000000000000;
211     bountyMembersAmounts[0x9c8eE3ABaf15fb94828b66b4B88B6da3aCBC4314] =   100000000000000000000;
212     bountyMembersAmounts[0x9eE59c11458D564f83c056aF679da378a1f990a2] =   139000000000000000000;
213     bountyMembersAmounts[0x9f41fed399e5734cae683323aA9da9ED01b80B19] =   548000000000000000000;
214     bountyMembersAmounts[0xA2BFda9c4E7942825A15D099080eA5BE922787C7] =  1382000000000000000000;
215     bountyMembersAmounts[0xA40768CDdF64ba0D1A866a80EF62faC1FBa1992D] =   126000000000000000000;
216     bountyMembersAmounts[0xa49eeFb65F935910A8352002b74423862D75747b] =   142000000000000000000;
217     bountyMembersAmounts[0xA9d61BAB323503F0A42d4bFD7497934aFec316db] =   147000000000000000000;
218     bountyMembersAmounts[0xac39e59F403Fb4d7A02dd6E7251481fa17f37518] =   117000000000000000000;
219     bountyMembersAmounts[0xac4c9c0d2931Fa5e29Baafbcaf4e5dB1cE8A1758] =   115000000000000000000;
220     bountyMembersAmounts[0xAEbC205C50399a7EDf248f17e188E3EcB6a4911a] =   111000000000000000000;
221     bountyMembersAmounts[0xB0f07308B6bd41Ac47B756dB61eEBaeF57ae8CCC] =   114000000000000000000;
222     bountyMembersAmounts[0xB41CDf4Dc95870B4A662cB6b8A51B8AABcb16F58] =   100000000000000000000;
223     bountyMembersAmounts[0xb5752D9e772411B2C1D449F5C38B2Be703181281] =   104000000000000000000;
224     bountyMembersAmounts[0xB5b97e673Fc89aD0a4D58660FbE0ADEa8cc4f71a] =   104000000000000000000;
225     bountyMembersAmounts[0xB73F5d6fED57ef3b6A624c918882010B38d6FeF5] =   100000000000000000000;
226     bountyMembersAmounts[0xB7f6584D898Efa6487Df14bE91abe871f9bf3038] =   111000000000000000000;
227     bountyMembersAmounts[0xb929d51980d4018b7b3fF84BEE63fAf8B3eABce6] =   586000000000000000000;
228     bountyMembersAmounts[0xb95da9acee36B95A8f8748c378f3aF39b8AE7087] =   606000000000000000000;
229     bountyMembersAmounts[0xB969085589eBAb0b0Ac190528720a2E2b5ec7af8] =   110000000000000000000;
230     bountyMembersAmounts[0xbB829cD884c75c2539A0A7Baa5574a4CE0658426] =   100000000000000000000;
231     bountyMembersAmounts[0xbBd4da3e86f610aDCF555fF3b2F51869eD5C7Cca] =   132000000000000000000;
232     bountyMembersAmounts[0xbDaaF43a9e7bd46B9a0902Ac6B197A8665fB240C] =   120000000000000000000;
233     bountyMembersAmounts[0xbea37D67eF2979942fcd5e8715892F98901427ba] =   230000000000000000000;
234     bountyMembersAmounts[0xBeE6E6B078b48ba5AAcb98D7f57Dd78496Af38dF] =   132000000000000000000;
235     bountyMembersAmounts[0xBF0dcf8af2F8695dB49c7cF4C587635003BBBafB] =   116000000000000000000;
236     bountyMembersAmounts[0xC0f321feed4B3ccAD81E4ECB8b5589d0baeBF710] =   102000000000000000000;
237     bountyMembersAmounts[0xC158394aF351906e21Dc78d8a840ce8e2AF2F827] =   104000000000000000000;
238     bountyMembersAmounts[0xC1945c4872062CD0Dc7c59D5744C276d09a59a99] =   112000000000000000000;
239     bountyMembersAmounts[0xc1ee59265efa7d13f8592cddae514a5be4cdf4a8] =   161000000000000000000;
240     bountyMembersAmounts[0xc53167E7dFB4E98a98c193627C622680F6291ab5] =   138000000000000000000;
241     bountyMembersAmounts[0xc81e5886AbDE2D4664e8A4F215F032E0d10F7114] =   252000000000000000000;
242     bountyMembersAmounts[0xc8200a3e8576E5f779E845D7e168FD2463b7CeD1] = 35382326000000000000000;
243     bountyMembersAmounts[0xC8fdF66fa1C2B1873076b3abe9A8275A2D84db60] =   308000000000000000000;
244     bountyMembersAmounts[0xcac5e66ac94D8BF511d9D6e840fd7c7Ed077D07f] =   100000000000000000000;
245     bountyMembersAmounts[0xCe241cb7ac5Aa67fd679EFffFF815E8A818B9319] =   101000000000000000000;
246     bountyMembersAmounts[0xcec52F799C80D75D4cEA2e281DA884c4129C67aA] =   141000000000000000000;
247     bountyMembersAmounts[0xd193466c05aae45f1C341447e8ee95BdBEa8297e] =   128000000000000000000;
248     bountyMembersAmounts[0xD382c8F5CFdfD9fd0246B1B6b4eb57249A567a74] =   106000000000000000000;
249     bountyMembersAmounts[0xD3E86478bF653C77f83737d831d1003ed447958c] =   128000000000000000000;
250     bountyMembersAmounts[0xD52c8572c1b7d831F4438d93DEF4b153bd221a79] =   102000000000000000000;
251     bountyMembersAmounts[0xD54C589E166D8A75374E985A580C00cA7936C7Be] =   104000000000000000000;
252     bountyMembersAmounts[0xd568cA92ee7fF3AbEef1E32ca31931843bed4758] =   112000000000000000000;
253     bountyMembersAmounts[0xD748a3fE50368D47163b3b1fDa780798970d99C1] =   200000000000000000000;
254     bountyMembersAmounts[0xd7879a4662A2a397B1937FB6954cAffae0ee6a0d] =   167000000000000000000;
255     bountyMembersAmounts[0xd8A321513f1fdf6EE58f599159f3C2ea80349243] =   104000000000000000000;
256     bountyMembersAmounts[0xd9fE06e655699EF67f47DaF4067E21700182E3Dc] =   200000000000000000000;
257     bountyMembersAmounts[0xdE361C58D32465DFD17434127a37145c29d16C54] =  1193000000000000000000;
258     bountyMembersAmounts[0xe18848EA4f7dF1d2861312932ccB28fCF5453707] =   211000000000000000000;
259     bountyMembersAmounts[0xE26BDb9e61070b5d0816b1F027eB2D105B675093] =   333000000000000000000;
260     bountyMembersAmounts[0xE27C464Cec75CEeFD49485ed77C177D5e225362a] =   116000000000000000000;
261     bountyMembersAmounts[0xe50817e5b1b36df3c9ad896a7548dce7ab52f6b3] =   106000000000000000000;
262     bountyMembersAmounts[0xe54AbAADd0FDbF41cC1EB7da616AdAB517b372d1] =   120000000000000000000;
263     bountyMembersAmounts[0xe67464a674666e39E3EdB461549d4b91Ee430593] =   100000000000000000000;
264     bountyMembersAmounts[0xe8a718296Edcd56132A2de6045965dDDA8f7176B] =  4398000000000000000000;
265     bountyMembersAmounts[0xe8B400c93B829d2B46d2fe8B730412373a4822Bf] =   430000000000000000000;
266     bountyMembersAmounts[0xeA46A6BEb7CdA737dc49204424406cE6046297a6] =   176000000000000000000;
267     bountyMembersAmounts[0xecB40E29C0Ce2108305890BBdD6082D47a9Ddb5F] =   117000000000000000000;
268     bountyMembersAmounts[0xecdd6b136b186c0e59a159504eb6afbc8ab03fed] =   130000000000000000000;
269     bountyMembersAmounts[0xed3d95daB05B502a75Ed7b7e8485FE81A193Ef2C] =   110000000000000000000;
270     bountyMembersAmounts[0xeEB9b9B40CCD80Fa3cCa2F2E3158482671f4D425] =   102000000000000000000;
271     bountyMembersAmounts[0xeFfdA5F2B388aCF369D642C34406C498BE1c9a14] =   155000000000000000000;
272     bountyMembersAmounts[0xf0e02baD9b0d9bF5b64b19752FD018073CC60E72] =   146000000000000000000;
273     bountyMembersAmounts[0xf22ca30049b37dc1b6650600549b0cd2bf5f3c64] =   110000000000000000000;
274     bountyMembersAmounts[0xf2418654Dd2e239EcBCF00aA2BC18aD8AF9bad52] =   124000000000000000000;
275     bountyMembersAmounts[0xf3415a0b9D0D1Ed2e666a07E090BE60957751832] =   108000000000000000000;
276     bountyMembersAmounts[0xF37bD5c2908ba069940a190b048E90696A91d89b] =   106000000000000000000;
277     bountyMembersAmounts[0xf3ff4BC6CB99cD72E59c15144fF141d2a323D70b] =  1000000000000000000000;
278     bountyMembersAmounts[0xF70F9512C3D1739BD09623B68Ed89a9b1dBb5f3B] =   144000000000000000000;
279     bountyMembersAmounts[0xF7De64DeC2e3c8CEF47836A2FB904bE979139D8a] =   106000000000000000000;
280     bountyMembersAmounts[0xF7e0AeE36D0170AB5f66e5d76515ae4B147c64dd] =   214000000000000000000;
281     bountyMembersAmounts[0xf96A5f15d602bC332F33439e6845CC4218EF2e59] =   190000000000000000000;
282     bountyMembersAmounts[0xf9c4292AE2944452c7F56e8bb4fB63ddF830f034] =   171000000000000000000;
283     bountyMembersAmounts[0xFc7a64183f49f71A1D604496E62c08f20aF5b5d6] =   170000000000000000000;
284   } 
285 }