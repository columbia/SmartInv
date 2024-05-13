1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.9;
3 
4 import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
5 import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
6 import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
7 import "@openzeppelin/contracts/access/AccessControl.sol";
8 import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
9 
10 contract Melodity is ERC20, ERC20Permit, ERC20Capped, AccessControl, ERC20Burnable {
11     bytes32 public constant CROWDSALE_ROLE = 0x0000000000000000000000000000000000000000000000000000000000000001;
12 
13     event Bought(address account, uint256 amount);
14     event Locked(address account, uint256 amount);
15     event Released(address account, uint256 amount);
16 
17     struct Locks {
18         uint256 locked;
19         uint256 release_time;
20         bool released;
21     }
22 
23     uint256 public total_locked_amount = 0;
24 
25     mapping(address => Locks[]) private _locks;
26 
27 	uint256 ICO_START = 1642147200;
28 	uint256 ICO_END = 1648771199;
29 
30     constructor() ERC20("Melodity", "MELD") ERC20Permit("Melodity") ERC20Capped(1000000000 * 10 ** decimals()) {
31         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
32         
33 		uint256 pow = 10 ** decimals();
34 		uint256 five_million = 5000000 * pow;
35 		uint256 fifty_million = five_million * 10;
36 		uint256 six_months = 60 * 60 * 24 * 180;
37 		uint256 one_year = six_months * 2;
38 		
39 		// set default lock for devs
40 		// devs funds are unlocked one time per year in a range of 4 years starting from the end of the ICO
41 
42 		// Ebalo
43 		_mint(address(0xFC5dA6A95E0C2C2C23b8C0c387CDd3Af7E56FCC0), 4000000 * pow);
44 		insertLock(address(0xFC5dA6A95E0C2C2C23b8C0c387CDd3Af7E56FCC0), five_million, ICO_END - block.timestamp + one_year);
45 		insertLock(address(0xFC5dA6A95E0C2C2C23b8C0c387CDd3Af7E56FCC0), five_million, ICO_END - block.timestamp + one_year * 2);
46 		insertLock(address(0xFC5dA6A95E0C2C2C23b8C0c387CDd3Af7E56FCC0), five_million, ICO_END - block.timestamp + one_year * 3);
47 		insertLock(address(0xFC5dA6A95E0C2C2C23b8C0c387CDd3Af7E56FCC0), five_million, ICO_END - block.timestamp + one_year * 4);
48 
49 		// RG
50 		_mint(address(0x618E9F7bbbeF323019eEf457f3b94E9E7943633A), 2800000 * pow);
51 		insertLock(address(0x618E9F7bbbeF323019eEf457f3b94E9E7943633A), 2800000 * pow, ICO_END - block.timestamp + one_year);
52 		insertLock(address(0x618E9F7bbbeF323019eEf457f3b94E9E7943633A), 2800000 * pow, ICO_END - block.timestamp + one_year * 2);
53 		insertLock(address(0x618E9F7bbbeF323019eEf457f3b94E9E7943633A), 2800000 * pow, ICO_END - block.timestamp + one_year * 3);
54 		insertLock(address(0x618E9F7bbbeF323019eEf457f3b94E9E7943633A), 2800000 * pow, ICO_END - block.timestamp + one_year * 4);
55 
56 		// WG
57 		_mint(address(0x3198c11724024C9cE7F81816E6E6B69580fe5585), 2400000 * pow);
58 		insertLock(address(0x3198c11724024C9cE7F81816E6E6B69580fe5585), 2400000 * pow, ICO_END - block.timestamp + one_year);
59 		insertLock(address(0x3198c11724024C9cE7F81816E6E6B69580fe5585), 2400000 * pow, ICO_END - block.timestamp + one_year * 2);
60 		insertLock(address(0x3198c11724024C9cE7F81816E6E6B69580fe5585), 2400000 * pow, ICO_END - block.timestamp + one_year * 3);
61 		insertLock(address(0x3198c11724024C9cE7F81816E6E6B69580fe5585), 2400000 * pow, ICO_END - block.timestamp + one_year * 4);
62 
63 		// Do inc - Company wallet
64 		_mint(address(0x01Af10f1343C05855955418bb99302A6CF71aCB8), fifty_million);
65 		insertLock(address(0x01Af10f1343C05855955418bb99302A6CF71aCB8), fifty_million, ICO_END - block.timestamp + one_year);
66 		insertLock(address(0x01Af10f1343C05855955418bb99302A6CF71aCB8), fifty_million, ICO_END - block.timestamp + one_year * 2);
67 		insertLock(address(0x01Af10f1343C05855955418bb99302A6CF71aCB8), fifty_million, ICO_END - block.timestamp + one_year * 3);
68 		insertLock(address(0x01Af10f1343C05855955418bb99302A6CF71aCB8), fifty_million, ICO_END - block.timestamp + one_year * 4);
69 
70 		// store the bridge funds (all preminted)
71 		_mint(address(0x7E097A68c0C4139f271912789d10062441017ee6), 125000000 * pow);
72 
73 
74 		//////////////////////////////
75 		//							//
76 		// donations locked as devs //
77 		//							//
78 		//////////////////////////////
79 		// donations from ebalo
80 
81 		_mint(address(0x1513A2c5ebb821080EF7F34DA0EeD06Efb3e5d77), 40000 * pow);
82 		insertLock(address(0x1513A2c5ebb821080EF7F34DA0EeD06Efb3e5d77), 40000 * pow, ICO_END - block.timestamp + one_year);
83 		insertLock(address(0x1513A2c5ebb821080EF7F34DA0EeD06Efb3e5d77), 40000 * pow, ICO_END - block.timestamp + one_year * 2);
84 		insertLock(address(0x1513A2c5ebb821080EF7F34DA0EeD06Efb3e5d77), 40000 * pow, ICO_END - block.timestamp + one_year * 3);
85 		insertLock(address(0x1513A2c5ebb821080EF7F34DA0EeD06Efb3e5d77), 40000 * pow, ICO_END - block.timestamp + one_year * 4);
86 
87 		_mint(address(0xB591244190BF1bE60eA0787C3644cfE12FDc593E), 32000 * pow);
88 		insertLock(address(0xB591244190BF1bE60eA0787C3644cfE12FDc593E), 32000 * pow, ICO_END - block.timestamp + one_year);
89 		insertLock(address(0xB591244190BF1bE60eA0787C3644cfE12FDc593E), 32000 * pow, ICO_END - block.timestamp + one_year * 2);
90 		insertLock(address(0xB591244190BF1bE60eA0787C3644cfE12FDc593E), 32000 * pow, ICO_END - block.timestamp + one_year * 3);
91 		insertLock(address(0xB591244190BF1bE60eA0787C3644cfE12FDc593E), 32000 * pow, ICO_END - block.timestamp + one_year * 4);
92 
93 		_mint(address(0xAC363fC2776368181C83ba48C1e839221D5a9b60), 32000 * pow);
94 		insertLock(address(0xAC363fC2776368181C83ba48C1e839221D5a9b60), 32000 * pow, ICO_END - block.timestamp + one_year);
95 		insertLock(address(0xAC363fC2776368181C83ba48C1e839221D5a9b60), 32000 * pow, ICO_END - block.timestamp + one_year * 2);
96 		insertLock(address(0xAC363fC2776368181C83ba48C1e839221D5a9b60), 32000 * pow, ICO_END - block.timestamp + one_year * 3);
97 		insertLock(address(0xAC363fC2776368181C83ba48C1e839221D5a9b60), 32000 * pow, ICO_END - block.timestamp + one_year * 4);
98 
99 		_mint(address(0x2Be310D9bC184a65c9522E790E894A10eA347539), 24000 * pow);
100 		insertLock(address(0x2Be310D9bC184a65c9522E790E894A10eA347539), 24000 * pow, ICO_END - block.timestamp + one_year);
101 		insertLock(address(0x2Be310D9bC184a65c9522E790E894A10eA347539), 24000 * pow, ICO_END - block.timestamp + one_year * 2);
102 		insertLock(address(0x2Be310D9bC184a65c9522E790E894A10eA347539), 24000 * pow, ICO_END - block.timestamp + one_year * 3);
103 		insertLock(address(0x2Be310D9bC184a65c9522E790E894A10eA347539), 24000 * pow, ICO_END - block.timestamp + one_year * 4);
104 
105 		_mint(address(0x4efA9e79880a604E44Fd90B8FE13aAAFD3fCDB77), 24000 * pow);
106 		insertLock(address(0x4efA9e79880a604E44Fd90B8FE13aAAFD3fCDB77), 24000 * pow, ICO_END - block.timestamp + one_year);
107 		insertLock(address(0x4efA9e79880a604E44Fd90B8FE13aAAFD3fCDB77), 24000 * pow, ICO_END - block.timestamp + one_year * 2);
108 		insertLock(address(0x4efA9e79880a604E44Fd90B8FE13aAAFD3fCDB77), 24000 * pow, ICO_END - block.timestamp + one_year * 3);
109 		insertLock(address(0x4efA9e79880a604E44Fd90B8FE13aAAFD3fCDB77), 24000 * pow, ICO_END - block.timestamp + one_year * 4);
110 
111 		_mint(address(0x6dC6E1Db441c606Ad8557d113e8101fCe10fB44e), 20000 * pow);
112 		insertLock(address(0x6dC6E1Db441c606Ad8557d113e8101fCe10fB44e), 20000 * pow, ICO_END - block.timestamp + one_year);
113 		insertLock(address(0x6dC6E1Db441c606Ad8557d113e8101fCe10fB44e), 20000 * pow, ICO_END - block.timestamp + one_year * 2);
114 		insertLock(address(0x6dC6E1Db441c606Ad8557d113e8101fCe10fB44e), 20000 * pow, ICO_END - block.timestamp + one_year * 3);
115 		insertLock(address(0x6dC6E1Db441c606Ad8557d113e8101fCe10fB44e), 20000 * pow, ICO_END - block.timestamp + one_year * 4);
116 
117 		_mint(address(0xCF29334DC2a09C42430b752978cCE7BD8cbC8112), 20000 * pow);
118 		insertLock(address(0xCF29334DC2a09C42430b752978cCE7BD8cbC8112), 20000 * pow, ICO_END - block.timestamp + one_year);
119 		insertLock(address(0xCF29334DC2a09C42430b752978cCE7BD8cbC8112), 20000 * pow, ICO_END - block.timestamp + one_year * 2);
120 		insertLock(address(0xCF29334DC2a09C42430b752978cCE7BD8cbC8112), 20000 * pow, ICO_END - block.timestamp + one_year * 3);
121 		insertLock(address(0xCF29334DC2a09C42430b752978cCE7BD8cbC8112), 20000 * pow, ICO_END - block.timestamp + one_year * 4);
122 
123 		_mint(address(0xe64352760D6D80e0002f0c0FfE1353fb905bC99C), 8000 * pow);
124 		insertLock(address(0xe64352760D6D80e0002f0c0FfE1353fb905bC99C), 8000 * pow, ICO_END - block.timestamp + one_year);
125 		insertLock(address(0xe64352760D6D80e0002f0c0FfE1353fb905bC99C), 8000 * pow, ICO_END - block.timestamp + one_year * 2);
126 		insertLock(address(0xe64352760D6D80e0002f0c0FfE1353fb905bC99C), 8000 * pow, ICO_END - block.timestamp + one_year * 3);
127 		insertLock(address(0xe64352760D6D80e0002f0c0FfE1353fb905bC99C), 8000 * pow, ICO_END - block.timestamp + one_year * 4);
128 
129 		// donations from rg
130 
131 		_mint(address(0x01ADD5D56e779183F3B52351E2145D1C4Ef4f896), 2000000 * pow);
132 		insertLock(address(0x01ADD5D56e779183F3B52351E2145D1C4Ef4f896), 2000000 * pow, ICO_END - block.timestamp + one_year);
133 		insertLock(address(0x01ADD5D56e779183F3B52351E2145D1C4Ef4f896), 2000000 * pow, ICO_END - block.timestamp + one_year * 2);
134 		insertLock(address(0x01ADD5D56e779183F3B52351E2145D1C4Ef4f896), 2000000 * pow, ICO_END - block.timestamp + one_year * 3);
135 		insertLock(address(0x01ADD5D56e779183F3B52351E2145D1C4Ef4f896), 2000000 * pow, ICO_END - block.timestamp + one_year * 4);
136 
137 		_mint(address(0x6EF4651B5fCc6531C8f25eB1bd9af86923Cb86cb), 50000 * pow);
138 		insertLock(address(0x6EF4651B5fCc6531C8f25eB1bd9af86923Cb86cb), 50000 * pow, ICO_END - block.timestamp + one_year);
139 		insertLock(address(0x6EF4651B5fCc6531C8f25eB1bd9af86923Cb86cb), 50000 * pow, ICO_END - block.timestamp + one_year * 2);
140 		insertLock(address(0x6EF4651B5fCc6531C8f25eB1bd9af86923Cb86cb), 50000 * pow, ICO_END - block.timestamp + one_year * 3);
141 		insertLock(address(0x6EF4651B5fCc6531C8f25eB1bd9af86923Cb86cb), 50000 * pow, ICO_END - block.timestamp + one_year * 4);
142 
143 		_mint(address(0x0C25906Ec039F2073E585D26991AE613544a26E0), 30000 * pow);
144 		insertLock(address(0x0C25906Ec039F2073E585D26991AE613544a26E0), 30000 * pow, ICO_END - block.timestamp + one_year);
145 		insertLock(address(0x0C25906Ec039F2073E585D26991AE613544a26E0), 30000 * pow, ICO_END - block.timestamp + one_year * 2);
146 		insertLock(address(0x0C25906Ec039F2073E585D26991AE613544a26E0), 30000 * pow, ICO_END - block.timestamp + one_year * 3);
147 		insertLock(address(0x0C25906Ec039F2073E585D26991AE613544a26E0), 30000 * pow, ICO_END - block.timestamp + one_year * 4);
148 
149 		_mint(address(0x15939079E39A960D8077d6fEbb92664252a2b7B8), 30000 * pow);
150 		insertLock(address(0x15939079E39A960D8077d6fEbb92664252a2b7B8), 30000 * pow, ICO_END - block.timestamp + one_year);
151 		insertLock(address(0x15939079E39A960D8077d6fEbb92664252a2b7B8), 30000 * pow, ICO_END - block.timestamp + one_year * 2);
152 		insertLock(address(0x15939079E39A960D8077d6fEbb92664252a2b7B8), 30000 * pow, ICO_END - block.timestamp + one_year * 3);
153 		insertLock(address(0x15939079E39A960D8077d6fEbb92664252a2b7B8), 30000 * pow, ICO_END - block.timestamp + one_year * 4);
154 
155 		_mint(address(0x485732157D0aa400081251D53c390a5921bFF0A8), 30000 * pow);
156 		insertLock(address(0x485732157D0aa400081251D53c390a5921bFF0A8), 30000 * pow, ICO_END - block.timestamp + one_year);
157 		insertLock(address(0x485732157D0aa400081251D53c390a5921bFF0A8), 30000 * pow, ICO_END - block.timestamp + one_year * 2);
158 		insertLock(address(0x485732157D0aa400081251D53c390a5921bFF0A8), 30000 * pow, ICO_END - block.timestamp + one_year * 3);
159 		insertLock(address(0x485732157D0aa400081251D53c390a5921bFF0A8), 30000 * pow, ICO_END - block.timestamp + one_year * 4);
160 
161 		_mint(address(0xD2fb1d3cc0bbE8A29bC391Ca435e544d781EA5a7), 30000 * pow);
162 		insertLock(address(0xD2fb1d3cc0bbE8A29bC391Ca435e544d781EA5a7), 30000 * pow, ICO_END - block.timestamp + one_year);
163 		insertLock(address(0xD2fb1d3cc0bbE8A29bC391Ca435e544d781EA5a7), 30000 * pow, ICO_END - block.timestamp + one_year * 2);
164 		insertLock(address(0xD2fb1d3cc0bbE8A29bC391Ca435e544d781EA5a7), 30000 * pow, ICO_END - block.timestamp + one_year * 3);
165 		insertLock(address(0xD2fb1d3cc0bbE8A29bC391Ca435e544d781EA5a7), 30000 * pow, ICO_END - block.timestamp + one_year * 4);
166 
167 		_mint(address(0x319B8D649890490Ab22C9cE8ae7ea2e0Cc61a3f8), 30000 * pow);
168 		insertLock(address(0x319B8D649890490Ab22C9cE8ae7ea2e0Cc61a3f8), 30000 * pow, ICO_END - block.timestamp + one_year);
169 		insertLock(address(0x319B8D649890490Ab22C9cE8ae7ea2e0Cc61a3f8), 30000 * pow, ICO_END - block.timestamp + one_year * 2);
170 		insertLock(address(0x319B8D649890490Ab22C9cE8ae7ea2e0Cc61a3f8), 30000 * pow, ICO_END - block.timestamp + one_year * 3);
171 		insertLock(address(0x319B8D649890490Ab22C9cE8ae7ea2e0Cc61a3f8), 30000 * pow, ICO_END - block.timestamp + one_year * 4);
172 
173 		// donations from wg
174 
175 		_mint(address(0x1b314dcA8Cc5BcA109dFb80bd91f647A3cD62f28), 2400000 * pow);
176 		insertLock(address(0x1b314dcA8Cc5BcA109dFb80bd91f647A3cD62f28), 2400000 * pow, ICO_END - block.timestamp + one_year);
177 		insertLock(address(0x1b314dcA8Cc5BcA109dFb80bd91f647A3cD62f28), 2400000 * pow, ICO_END - block.timestamp + one_year * 2);
178 		insertLock(address(0x1b314dcA8Cc5BcA109dFb80bd91f647A3cD62f28), 2400000 * pow, ICO_END - block.timestamp + one_year * 3);
179 		insertLock(address(0x1b314dcA8Cc5BcA109dFb80bd91f647A3cD62f28), 2400000 * pow, ICO_END - block.timestamp + one_year * 4);
180 
181 		_mint(address(0x435298a529750E8A65bF2589D3F41c59bCB3a274), 80000 * pow);
182 		insertLock(address(0x435298a529750E8A65bF2589D3F41c59bCB3a274), 80000 * pow, ICO_END - block.timestamp + one_year);
183 		insertLock(address(0x435298a529750E8A65bF2589D3F41c59bCB3a274), 80000 * pow, ICO_END - block.timestamp + one_year * 2);
184 		insertLock(address(0x435298a529750E8A65bF2589D3F41c59bCB3a274), 80000 * pow, ICO_END - block.timestamp + one_year * 3);
185 		insertLock(address(0x435298a529750E8A65bF2589D3F41c59bCB3a274), 80000 * pow, ICO_END - block.timestamp + one_year * 4);
186 
187 		_mint(address(0xEe72d0857201bdc932B256A165b9c4e0C8ECF055), 80000 * pow);
188 		insertLock(address(0xEe72d0857201bdc932B256A165b9c4e0C8ECF055), 80000 * pow, ICO_END - block.timestamp + one_year);
189 		insertLock(address(0xEe72d0857201bdc932B256A165b9c4e0C8ECF055), 80000 * pow, ICO_END - block.timestamp + one_year * 2);
190 		insertLock(address(0xEe72d0857201bdc932B256A165b9c4e0C8ECF055), 80000 * pow, ICO_END - block.timestamp + one_year * 3);
191 		insertLock(address(0xEe72d0857201bdc932B256A165b9c4e0C8ECF055), 80000 * pow, ICO_END - block.timestamp + one_year * 4);
192 
193 		_mint(address(0x891539D631d4ed5E401aFa54Cc4b3197BEd73Aae), 20000 * pow);
194 		insertLock(address(0x891539D631d4ed5E401aFa54Cc4b3197BEd73Aae), 20000 * pow, ICO_END - block.timestamp + one_year);
195 		insertLock(address(0x891539D631d4ed5E401aFa54Cc4b3197BEd73Aae), 20000 * pow, ICO_END - block.timestamp + one_year * 2);
196 		insertLock(address(0x891539D631d4ed5E401aFa54Cc4b3197BEd73Aae), 20000 * pow, ICO_END - block.timestamp + one_year * 3);
197 		insertLock(address(0x891539D631d4ed5E401aFa54Cc4b3197BEd73Aae), 20000 * pow, ICO_END - block.timestamp + one_year * 4);
198 
199 		_mint(address(0x382be12c3632Fb45347f1126361Ab94dbd88C5E1), 10000 * pow);
200 		insertLock(address(0x382be12c3632Fb45347f1126361Ab94dbd88C5E1), 10000 * pow, ICO_END - block.timestamp + one_year);
201 		insertLock(address(0x382be12c3632Fb45347f1126361Ab94dbd88C5E1), 10000 * pow, ICO_END - block.timestamp + one_year * 2);
202 		insertLock(address(0x382be12c3632Fb45347f1126361Ab94dbd88C5E1), 10000 * pow, ICO_END - block.timestamp + one_year * 3);
203 		insertLock(address(0x382be12c3632Fb45347f1126361Ab94dbd88C5E1), 10000 * pow, ICO_END - block.timestamp + one_year * 4);
204 
205 		_mint(address(0xB40D8A30E5215DA89490D0209FEc3e6C9008fd80), 2000 * pow);
206 		insertLock(address(0xB40D8A30E5215DA89490D0209FEc3e6C9008fd80), 2000 * pow, ICO_END - block.timestamp + one_year);
207 		insertLock(address(0xB40D8A30E5215DA89490D0209FEc3e6C9008fd80), 2000 * pow, ICO_END - block.timestamp + one_year * 2);
208 		insertLock(address(0xB40D8A30E5215DA89490D0209FEc3e6C9008fd80), 2000 * pow, ICO_END - block.timestamp + one_year * 3);
209 		insertLock(address(0xB40D8A30E5215DA89490D0209FEc3e6C9008fd80), 2000 * pow, ICO_END - block.timestamp + one_year * 4);
210 
211 		_mint(address(0x91A6FfB93Ae9b7F4009978c92259b51DB1814f75), 2000 * pow);
212 		insertLock(address(0x91A6FfB93Ae9b7F4009978c92259b51DB1814f75), 2000 * pow, ICO_END - block.timestamp + one_year);
213 		insertLock(address(0x91A6FfB93Ae9b7F4009978c92259b51DB1814f75), 2000 * pow, ICO_END - block.timestamp + one_year * 2);
214 		insertLock(address(0x91A6FfB93Ae9b7F4009978c92259b51DB1814f75), 2000 * pow, ICO_END - block.timestamp + one_year * 3);
215 		insertLock(address(0x91A6FfB93Ae9b7F4009978c92259b51DB1814f75), 2000 * pow, ICO_END - block.timestamp + one_year * 4);
216 
217 		_mint(address(0x30817A8e6Dc225B89c5670BCc5a9a66f987b7F04), 2000 * pow);
218 		insertLock(address(0x30817A8e6Dc225B89c5670BCc5a9a66f987b7F04), 2000 * pow, ICO_END - block.timestamp + one_year);
219 		insertLock(address(0x30817A8e6Dc225B89c5670BCc5a9a66f987b7F04), 2000 * pow, ICO_END - block.timestamp + one_year * 2);
220 		insertLock(address(0x30817A8e6Dc225B89c5670BCc5a9a66f987b7F04), 2000 * pow, ICO_END - block.timestamp + one_year * 3);
221 		insertLock(address(0x30817A8e6Dc225B89c5670BCc5a9a66f987b7F04), 2000 * pow, ICO_END - block.timestamp + one_year * 4);
222 
223 		_mint(address(0x70adD435e8c9f76a263B161863d4F1f6cc1F055a), 2000 * pow);
224 		insertLock(address(0x70adD435e8c9f76a263B161863d4F1f6cc1F055a), 2000 * pow, ICO_END - block.timestamp + one_year);
225 		insertLock(address(0x70adD435e8c9f76a263B161863d4F1f6cc1F055a), 2000 * pow, ICO_END - block.timestamp + one_year * 2);
226 		insertLock(address(0x70adD435e8c9f76a263B161863d4F1f6cc1F055a), 2000 * pow, ICO_END - block.timestamp + one_year * 3);
227 		insertLock(address(0x70adD435e8c9f76a263B161863d4F1f6cc1F055a), 2000 * pow, ICO_END - block.timestamp + one_year * 4);
228 
229 		_mint(address(0xF40Fccc4fefd2243Cf517ad428661963EA19866F), 2000 * pow);
230 		insertLock(address(0xF40Fccc4fefd2243Cf517ad428661963EA19866F), 2000 * pow, ICO_END - block.timestamp + one_year);
231 		insertLock(address(0xF40Fccc4fefd2243Cf517ad428661963EA19866F), 2000 * pow, ICO_END - block.timestamp + one_year * 2);
232 		insertLock(address(0xF40Fccc4fefd2243Cf517ad428661963EA19866F), 2000 * pow, ICO_END - block.timestamp + one_year * 3);
233 		insertLock(address(0xF40Fccc4fefd2243Cf517ad428661963EA19866F), 2000 * pow, ICO_END - block.timestamp + one_year * 4);
234     }
235 
236     /**
237      * @dev See {ERC20-_mint}.
238      */
239     function _mint(address account, uint256 amount) internal virtual override(ERC20, ERC20Capped) {
240         ERC20Capped._mint(account, amount);
241     }
242 
243     /**
244      * Lock the bought amount:
245      *  - 10% released immediately
246      *  - 15% released after 3 months
247      *  - 25% released after 9 month (every 6 months starting from the third)
248      *  - 25% released after 15 month (every 6 months starting from the third)
249      *  - 25% released after 21 month (every 6 months starting from the third)
250      */
251     function saleLock(address account, uint256 _amount) public onlyRole(CROWDSALE_ROLE) {
252         emit Bought(account, _amount);
253         
254         // immediately release the 10% of the bought amount
255         uint256 immediately_released = _amount / 10; // * 10 / 100 = / 10
256 
257         // 15% released after 3 months
258         uint256 m3_release = _amount * 15 / 100; 
259 
260         // 25% released after 9 months
261         uint256 m9_release = _amount * 25 / 100; 
262         
263         // 25% released after 15 months
264         uint256 m15_release = _amount * 25 / 100; 
265         
266         // 25% released after 21 months
267         uint256 m21_release = _amount - (immediately_released + m3_release + m9_release + m15_release); 
268 
269         uint256 locked_amount = m3_release + m9_release + m15_release + m21_release;
270 
271         // update the counter
272         total_locked_amount += locked_amount;
273 
274         Locks memory lock_m = Locks({
275             locked: m3_release,
276             release_time: block.timestamp + 7776000,    // 60s * 60m * 24h * 90d
277             released: false
278         }); 
279 		_locks[account].push(lock_m);
280 
281 		lock_m.release_time = block.timestamp + 23328000; // 60s * 60m * 24h * 270d
282 		lock_m.locked = m9_release;
283 		_locks[account].push(lock_m);
284 
285 		lock_m.release_time = block.timestamp + 38880000; // 60s * 60m * 24h * 450d
286 		lock_m.locked = m15_release;
287 		_locks[account].push(lock_m);
288 
289 		lock_m.release_time = block.timestamp + 54432000; // 60s * 60m * 24h * 630d
290 		lock_m.locked = m21_release;
291 		_locks[account].push(lock_m);
292 
293         emit Locked(account, locked_amount);
294 
295         _mint(account, immediately_released);
296         emit Released(account, immediately_released);
297     }
298 
299 	function burnUnsold(uint256 _amount) public onlyRole(CROWDSALE_ROLE) {
300 		_mint(address(0), _amount);
301 	}
302 
303 	/**
304 	 * Lock the provided amount of MELD for "_relative_release_time" seconds starting from now
305 	 * NOTE: This method is capped 
306 	 * NOTE: time definition in the locks is relative!
307 	 */
308     function insertLock(address account, uint256 _amount, uint256 _relative_release_time) public onlyRole(DEFAULT_ADMIN_ROLE) {
309 		require(totalSupply() + total_locked_amount + _amount <= cap(), "Unable to lock the defined amount, cap exceeded");
310 		Locks memory lock_ = Locks({
311             locked: _amount,
312             release_time: block.timestamp + _relative_release_time,
313             released: false
314         }); 
315 		_locks[account].push(lock_);
316 
317 		total_locked_amount += _amount;
318 
319 		emit Locked(account, _amount);
320     }
321 
322 	/**
323 	 * Insert an array of locks for the provided account
324 	 * NOTE: time definition in the locks is relative!
325 	 */
326     function batchInsertLock(address account, uint256[] memory _amounts, uint256[] memory _relative_release_time) public onlyRole(DEFAULT_ADMIN_ROLE) {
327         require(_amounts.length == _relative_release_time.length, "Array with different sizes provided");
328 		for(uint256 i = 0; i < _amounts.length; i++) {
329             insertLock(account, _amounts[i], _relative_release_time[i]);
330         }
331     }
332 
333 	/**
334 	 * Retrieve the locks state for the account
335 	 */
336     function locksOf(address account) public view returns(Locks[] memory) {
337         return _locks[account];
338     }
339 
340 	/**
341 	 * Get the number of locks for an account
342 	 */
343     function getLockNumber(address account) public view returns(uint256) {
344         return _locks[account].length;
345     }
346 
347 	/**
348 	 * Release (mint) the amount of token locked
349 	 */
350     function release(uint256 lock_id) public {
351         require(_locks[msg.sender].length > 0, "No locks found for your account");
352         require(_locks[msg.sender].length -1 >= lock_id, "Lock index too high");
353 		require(!_locks[msg.sender][lock_id].released, "Lock already released");
354 		require(block.timestamp > _locks[msg.sender][lock_id].release_time, "Lock not yet ready to be released");
355 
356 		// refresh the amount of tokens locked
357 		total_locked_amount -= _locks[msg.sender][lock_id].locked;
358 
359 		// mark the lock as realeased
360 		_locks[msg.sender][lock_id].released = true;
361 
362 		// mint the tokens to the sender
363 		_mint(msg.sender, _locks[msg.sender][lock_id].locked);
364 		emit Released(msg.sender, _locks[msg.sender][lock_id].locked);
365     }
366 }