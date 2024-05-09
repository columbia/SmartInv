1 from vyper.interfaces import ERC721
2 
3 implements: ERC721
4 
5 interface pria_contract:
6     def balanceOf(_to: address) -> uint256: view
7     def totalSupply() -> uint256: view
8 
9 interface ERC721Receiver:
10     def onERC721Received(
11             _operator: address,
12             _from: address,
13             _tokenId: uint256,
14             _data: Bytes[1024]
15         ) -> bytes32: view
16 
17 event Transfer:
18     sender: indexed(address)
19     receiver: indexed(address)
20     tokenId: indexed(uint256)
21 
22 event Approval:
23     owner: indexed(address)
24     approved: indexed(address)
25     tokenId: indexed(uint256)
26 
27 event ApprovalForAll:
28     owner: indexed(address)
29     operator: indexed(address)
30     approved: bool
31 
32 struct nft_token:
33     name: String[64]
34     thumbnail: String[100]
35     model_url: String[100]
36     Coef_1: uint256
37     Coef_2: uint256
38     Coef_3: uint256
39 
40 tokenName: String[64]
41 tokenSymbol: String[32]
42 tokenUrl: String[100]
43 total_supply: uint256
44 earlyAdopters: public(HashMap[address, bool])
45 idToOwner: HashMap[uint256, address]
46 idToApprovals: HashMap[uint256, address]
47 arAsset: public(HashMap[uint256, nft_token])
48 ownerToNFTokenCount: HashMap[address, uint256]
49 ownerToOperators: HashMap[address, HashMap[address, bool]]
50 minter: address
51 supportedInterfaces: HashMap[bytes32, bool]
52 eav_title: String[64]
53 eav_thumbnail: String[100]
54 eav_model_url: String[100]
55 eav_coef1: uint256
56 eav_coef2: uint256
57 eav_coef3: uint256
58 deadline: uint256
59 eav_contract: address
60 
61 ERC165_INTERFACE_ID: constant(bytes32) = 0x0000000000000000000000000000000000000000000000000000000001ffc9a7
62 ERC721_INTERFACE_ID: constant(bytes32) = 0x0000000000000000000000000000000000000000000000000000000080ac58cd
63 ERC721_TOKEN_RECEIVER_INTERFACE_ID: constant(bytes32) = 0x00000000000000000000000000000000000000000000000000000000150b7a02
64 ERC721_METADATA_INTERFACE_ID: constant(bytes32) = 0x000000000000000000000000000000000000000000000000000000005b5e139f
65 
66 @external
67 def __init__(_name: String[64], _symbol: String[32], _tokenURL: String[64]):
68     self.tokenName = _name
69     self.tokenSymbol = _symbol
70     self.tokenUrl = _tokenURL
71     self.supportedInterfaces[ERC165_INTERFACE_ID] = True
72     self.supportedInterfaces[ERC721_INTERFACE_ID] = True
73     self.supportedInterfaces[ERC721_TOKEN_RECEIVER_INTERFACE_ID] = True
74     self.supportedInterfaces[ERC721_METADATA_INTERFACE_ID] = True
75     self.minter = msg.sender
76     self.total_supply = 0
77 
78 @view
79 @external
80 def name() -> String[64]:
81     return self.tokenName
82 
83 @view
84 @external
85 def symbol() -> String[32]:
86     return self.tokenSymbol
87 
88 @view
89 @external
90 def totalSupply() -> uint256:
91     return self.total_supply
92 
93 @view
94 @external
95 def supportsInterface(_interfaceID: bytes32) -> bool:
96     return self.supportedInterfaces[_interfaceID]
97 
98 @view
99 @external
100 def tokenURL() -> String[100]:
101     return self.tokenUrl
102 
103 @view
104 @external
105 def balanceOf(_owner: address) -> uint256:
106     assert _owner != ZERO_ADDRESS
107     return self.ownerToNFTokenCount[_owner]
108 
109 @view
110 @external
111 def ownerOf(_tokenId: uint256) -> address:
112     owner: address = self.idToOwner[_tokenId]
113     assert owner != ZERO_ADDRESS
114     return owner
115 
116 @view
117 @external
118 def NFT_AR_Name(_tokenId: uint256) -> String[100]:
119     return self.arAsset[_tokenId].name
120 
121 @view
122 @external
123 def NFT_AR_Thumbnail(_tokenId: uint256) -> String[100]:
124     return self.arAsset[_tokenId].thumbnail
125 
126 @view
127 @external
128 def NFT_AR_Contents(_tokenId: uint256) -> String[100]:
129     return self.arAsset[_tokenId].model_url
130 
131 @view
132 @external
133 def NFT_AR_Coef1(_tokenId: uint256) -> uint256:
134     return self.arAsset[_tokenId].Coef_1
135 
136 @view
137 @external
138 def NFT_AR_Coef2(_tokenId: uint256) -> uint256:
139     return self.arAsset[_tokenId].Coef_2
140 
141 @view
142 @external
143 def NFT_AR_Coef3(_tokenId: uint256) -> uint256:
144     return self.arAsset[_tokenId].Coef_3
145 
146 @view
147 @external
148 def getApproved(_tokenId: uint256) -> address:
149     assert self.idToOwner[_tokenId] != ZERO_ADDRESS
150     return self.idToApprovals[_tokenId]
151 
152 @view
153 @external
154 def isApprovedForAll(_owner: address, _operator: address) -> bool:
155     return (self.ownerToOperators[_owner])[_operator]
156 
157 @view
158 @internal
159 def _isApprovedOrOwner(_spender: address, _tokenId: uint256) -> bool:
160     owner: address = self.idToOwner[_tokenId]
161     spenderIsOwner: bool = owner == _spender
162     spenderIsApproved: bool = _spender == self.idToApprovals[_tokenId]
163     spenderIsApprovedForAll: bool = (self.ownerToOperators[owner])[_spender]
164     return (spenderIsOwner or spenderIsApproved) or spenderIsApprovedForAll
165 
166 @internal
167 def _addTokenTo(_to: address, _tokenId: uint256):
168     assert self.idToOwner[_tokenId] == ZERO_ADDRESS
169     self.idToOwner[_tokenId] = _to
170     self.ownerToNFTokenCount[_to] += 1
171 
172 @internal
173 def _removeTokenFrom(_from: address, _tokenId: uint256):
174     assert self.idToOwner[_tokenId] == _from
175     self.idToOwner[_tokenId] = ZERO_ADDRESS
176     self.ownerToNFTokenCount[_from] -= 1
177 
178 @internal
179 def _clearApproval(_owner: address, _tokenId: uint256):
180     assert self.idToOwner[_tokenId] == _owner
181     if self.idToApprovals[_tokenId] != ZERO_ADDRESS:
182         self.idToApprovals[_tokenId] = ZERO_ADDRESS
183 
184 @internal
185 def _transferFrom(_from: address, _to: address, _tokenId: uint256, _sender: address):
186     assert self._isApprovedOrOwner(_sender, _tokenId)
187     assert _to != ZERO_ADDRESS
188     self._clearApproval(_from, _tokenId)
189     self._removeTokenFrom(_from, _tokenId)
190     self._addTokenTo(_to, _tokenId)
191     log Transfer(_from, _to, _tokenId)
192 
193 @external
194 def transferFrom(_from: address, _to: address, _tokenId: uint256):
195     self._transferFrom(_from, _to, _tokenId, msg.sender)
196 
197 @external
198 def safeTransferFrom(_from: address, _to: address, _tokenId: uint256, _data: Bytes[1024]=b""):
199     self._transferFrom(_from, _to, _tokenId, msg.sender)
200     if _to.is_contract:
201         returnValue: bytes32 = ERC721Receiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data)
202         assert returnValue == method_id("onERC721Received(address,address,uint256,bytes)", output_type=bytes32)
203 
204 @external
205 def approve(_approved: address, _tokenId: uint256):
206     owner: address = self.idToOwner[_tokenId]
207     assert owner != ZERO_ADDRESS
208     assert _approved != owner
209     senderIsOwner: bool = self.idToOwner[_tokenId] == msg.sender
210     senderIsApprovedForAll: bool = (self.ownerToOperators[owner])[msg.sender]
211     assert (senderIsOwner or senderIsApprovedForAll)
212     self.idToApprovals[_tokenId] = _approved
213     log Approval(owner, _approved, _tokenId)
214 
215 @external
216 def setApprovalForAll(_operator: address, _approved: bool):
217     assert _operator != msg.sender
218     self.ownerToOperators[msg.sender][_operator] = _approved
219     log ApprovalForAll(msg.sender, _operator, _approved)
220 
221 @external
222 def mint(_to: address, _name: String[64], _image: String[100], _url: String[100], _coef1: uint256, _coef2: uint256, _coef3: uint256) -> bool:
223     assert msg.sender == self.minter
224     assert _to != ZERO_ADDRESS
225     self._addTokenTo(_to, self.total_supply)
226     self.arAsset[self.total_supply].name = _name
227     self.arAsset[self.total_supply].thumbnail = _image
228     self.arAsset[self.total_supply].model_url = _url
229     self.arAsset[self.total_supply].Coef_1 = _coef1
230     self.arAsset[self.total_supply].Coef_2 = _coef2
231     self.arAsset[self.total_supply].Coef_3 = _coef3
232     log Transfer(ZERO_ADDRESS, _to, self.total_supply)
233     self.total_supply += 1
234     return True
235 
236 @external
237 def setEarlyAdoptersNFT(_name: String[64], _thumbnail: String[100], _model_url: String[100], _coef1: uint256, _coef2: uint256, _coef3: uint256, _deadline: uint256) -> bool:
238     assert msg.sender == self.minter
239     assert msg.sender != ZERO_ADDRESS
240     self.eav_title = _name
241     self.eav_thumbnail = _thumbnail
242     self.eav_model_url = _model_url
243     self.eav_coef1 = _coef1
244     self.eav_coef2 = _coef2
245     self.eav_coef3 = _coef3
246     self.deadline = _deadline
247     return True
248 
249 @external
250 def setContract(_contract: address) -> bool:
251     assert msg.sender == self.minter
252     assert msg.sender != ZERO_ADDRESS
253     self.eav_contract = _contract
254     return True
255 
256 @external
257 def setTokenURL(_url: String[100]) -> bool:
258     assert msg.sender == self.minter
259     assert msg.sender != ZERO_ADDRESS
260     self.tokenUrl = _url
261     return True
262 
263 @external
264 def CLAIMearlyAdoptersNFT() -> bool:
265     assert self.earlyAdopters[msg.sender] == True
266     assert msg.sender != ZERO_ADDRESS
267     assert self.deadline > block.timestamp
268     self._addTokenTo(msg.sender, self.total_supply)
269     r: uint256 = pria_contract(self.eav_contract).balanceOf(msg.sender)
270     totalsupply: uint256 = pria_contract(self.eav_contract).totalSupply()
271     pct: uint256 = (r*10**18)/totalsupply
272     self.arAsset[self.total_supply].name = self.eav_title
273     self.arAsset[self.total_supply].thumbnail = self.eav_thumbnail
274     self.arAsset[self.total_supply].model_url = self.eav_model_url
275     self.arAsset[self.total_supply].Coef_1 = pct
276     self.arAsset[self.total_supply].Coef_2 = self.eav_coef2
277     self.arAsset[self.total_supply].Coef_3 = self.eav_coef3
278     log Transfer(ZERO_ADDRESS, msg.sender, self.total_supply)
279     self.total_supply += 1
280     self.earlyAdopters[msg.sender] = False
281     return True
282 
283 @external
284 def burn(_tokenId: uint256):
285     assert self._isApprovedOrOwner(msg.sender, _tokenId)
286     owner: address = self.idToOwner[_tokenId]
287     assert owner != ZERO_ADDRESS
288     self._clearApproval(owner, _tokenId)
289     self._removeTokenFrom(owner, _tokenId)
290     self.arAsset[_tokenId].name = ""
291     self.arAsset[_tokenId].thumbnail = ""
292     self.arAsset[_tokenId].model_url = ""
293     self.arAsset[_tokenId].Coef_1 = 0
294     self.arAsset[_tokenId].Coef_2 = 0
295     self.arAsset[_tokenId].Coef_3 = 0
296     log Transfer(owner, ZERO_ADDRESS, _tokenId)
297 
298 @external
299 def setEligible_Single(_eligibleAddy: address) -> bool:
300     assert msg.sender == self.minter
301     self.earlyAdopters[_eligibleAddy] = True
302     return True
303 
304 @external
305 def remEligible_Single(_eligibleAddy: address) -> bool:
306     assert msg.sender == self.minter
307     self.earlyAdopters[_eligibleAddy] = False
308     return True
309 
310 @external
311 def remEligible_Bulk(_eligibleList: address[100]) -> bool:
312     assert msg.sender == self.minter
313     for addy in range (0, 100):
314         if _eligibleList[addy] != ZERO_ADDRESS:
315             self.earlyAdopters[_eligibleList[addy]] = False
316         else:
317             break
318     return True
319 
320 @external
321 def setEligible_Bulk(_eligibleList: address[100]) -> bool:
322     assert msg.sender == self.minter
323     for addy in range (0, 100):
324         if _eligibleList[addy] != ZERO_ADDRESS:
325             self.earlyAdopters[_eligibleList[addy]] = True
326         else:
327             break
328     return True
329 
330 @external
331 def remEligible_Bulk_300(_eligibleList: address[300]) -> bool:
332     assert msg.sender == self.minter
333     for addy in range (0, 300):
334         if _eligibleList[addy] != ZERO_ADDRESS:
335             self.earlyAdopters[_eligibleList[addy]] = False
336         else:
337             break
338     return True
339 
340 @external
341 def setEligible_Bulk_300(_eligibleList: address[300]) -> bool:
342     assert msg.sender == self.minter
343     for addy in range (0, 300):
344         if _eligibleList[addy] != ZERO_ADDRESS:
345             self.earlyAdopters[_eligibleList[addy]] = True
346         else:
347             break
348     return True
349 
350 @external
351 def sweep():
352     assert msg.sender == self.minter
353     assert msg.sender != ZERO_ADDRESS
354     selfdestruct(msg.sender)