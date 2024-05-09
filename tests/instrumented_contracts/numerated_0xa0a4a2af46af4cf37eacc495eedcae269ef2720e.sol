1 # Modified from: https://github.com/ethereum/vyper/blob/master/examples/tokens/ERC721.vy
2 
3 contract ERC721Receiver:
4     def onERC721Received(
5         _operator: address,
6         _from: address,
7         _tokenId: uint256,
8         _data: bytes[1024]
9     ) -> bytes32: modifying
10 
11 # contract URI:
12 #     def tokenURI(_tokenId: uint256) -> string[128]: constant
13 
14 contract Socks:
15     def totalSupply() -> uint256: constant
16 
17 Transfer: event({_from: indexed(address), _to: indexed(address), _tokenId: indexed(uint256)})
18 Approval: event({_owner: indexed(address), _approved: indexed(address), _tokenId: indexed(uint256)})
19 ApprovalForAll: event({_owner: indexed(address), _operator: indexed(address), _approved: bool})
20 
21 name: public(string[32])
22 symbol: public(string[32])
23 totalSupply: public(uint256)
24 
25 minter: public(address)
26 # socks: public(Socks)
27 newURI: public(string[128])
28 
29 ownerOf: public(map(uint256, address))                     # map(tokenId, owner)
30 balanceOf: public(map(address, uint256))                   # map(owner, balance)
31 getApproved: public(map(uint256, address))                 # map(tokenId, approvedSpender)
32 isApprovedForAll: public(map(address, map(address, bool))) # map(owner, map(operator, bool))
33 supportsInterface: public(map(bytes32, bool))              # map(interfaceId, bool)
34 ownerIndexToTokenId: map(address, map(uint256, uint256))   # map(owner, map(index, tokenId))
35 tokenIdToIndex: map(uint256, uint256)                      # map(tokenId, index)
36 
37 ERC165_INTERFACE_ID: constant(bytes32) = 0x0000000000000000000000000000000000000000000000000000000001ffc9a7
38 ERC721_ENUMERABLE_INTERFACE_ID: constant(bytes32) = 0x00000000000000000000000000000000000000000000000000000000780e9d63
39 ERC721_METADATA_INTERFACE_ID: constant(bytes32) = 0x000000000000000000000000000000000000000000000000000000005b5e139f
40 ERC721_INTERFACE_ID: constant(bytes32) = 0x0000000000000000000000000000000000000000000000000000000080ac58cd
41 
42 # @public
43 # def __init__(_socks: address):
44 @public
45 def __init__():
46     self.name = 'Digital Unisocks Edition 0'
47     self.symbol = 'S0CKS'
48     self.minter = msg.sender
49     # self.socks = Socks(_socks)
50     self.newURI = 'https://cloudflare-ipfs.com/ipfs/QmNXWGs5DFxfQyjr4d6mjBLqRwoTrpcQj98b7KCgGFjN9e'
51     self.supportsInterface[ERC165_INTERFACE_ID] = True
52     self.supportsInterface[ERC721_ENUMERABLE_INTERFACE_ID] = True
53     self.supportsInterface[ERC721_METADATA_INTERFACE_ID] = True
54     self.supportsInterface[ERC721_INTERFACE_ID] = True
55 
56 
57 @public
58 @constant
59 def tokenURI(_tokenId: uint256) -> string[128]:
60     return self.newURI
61 
62 @public
63 def changeURI(_newURI: string[128]):
64     self.newURI = _newURI
65 
66 @public
67 def killContract():
68     selfdestruct(msg.sender)
69 
70 # Token index is same as ID and can't change
71 @public
72 @constant
73 def tokenByIndex(_index: uint256) -> uint256:
74     assert _index < self.totalSupply
75     return _index
76 
77 @public
78 @constant
79 def tokenOfOwnerByIndex(_owner: address, _index: uint256) -> uint256:
80     assert _index < self.balanceOf[_owner]
81     return self.ownerIndexToTokenId[_owner][_index]
82 
83 @private
84 def _transferFrom(_from: address, _to: address, _tokenId: uint256, _sender: address):
85     _owner: address = self.ownerOf[_tokenId]
86     # Check requirements
87     assert _owner == _from and _to != ZERO_ADDRESS
88     _senderIsOwner: bool = _sender == _owner
89     _senderIsApproved: bool = _sender == self.getApproved[_tokenId]
90     _senderIsApprovedForAll: bool = self.isApprovedForAll[_owner][_sender]
91     assert _senderIsOwner or _senderIsApproved or _senderIsApprovedForAll
92     # Update ownerIndexToTokenId for _from
93     _highestIndexFrom: uint256 = self.balanceOf[_from] - 1   # get highest index of _from
94     _tokenIdIndexFrom: uint256 = self.tokenIdToIndex[_tokenId] # get index of _from where _tokenId is
95     if _highestIndexFrom == _tokenIdIndexFrom:               # _tokenId is the last token in _from's list
96         self.ownerIndexToTokenId[_from][_highestIndexFrom] = 0
97     else:
98         self.ownerIndexToTokenId[_from][_tokenIdIndexFrom] = self.ownerIndexToTokenId[_from][_highestIndexFrom]
99         self.ownerIndexToTokenId[_from][_highestIndexFrom] = 0
100     # Update ownerIndexToTokenId for _to
101     _newHighestIndexTo: uint256 = self.balanceOf[_to]
102     self.ownerIndexToTokenId[_to][_newHighestIndexTo] = _tokenId
103     # Update tokenIdToIndex
104     self.tokenIdToIndex[_tokenId] = _newHighestIndexTo
105     # update ownerOf and balanceOf
106     self.ownerOf[_tokenId] = _to
107     self.balanceOf[_from] -= 1
108     self.balanceOf[_to] += 1
109     # Clear approval.
110     if self.getApproved[_tokenId] != ZERO_ADDRESS:
111         self.getApproved[_tokenId] = ZERO_ADDRESS
112     log.Transfer(_from, _to, _tokenId)
113 
114 
115 @public
116 def transferFrom(_from: address, _to: address, _tokenId: uint256):
117     self._transferFrom(_from, _to, _tokenId, msg.sender)
118 
119 
120 @public
121 def safeTransferFrom(_from: address, _to: address, _tokenId: uint256, _data: bytes[1024]=""):
122     self._transferFrom(_from, _to, _tokenId, msg.sender)
123     if _to.is_contract:
124         returnValue: bytes32 = ERC721Receiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data)
125         # Throws if transfer destination is a contract which does not implement 'onERC721Received'
126         assert returnValue == method_id('onERC721Received(address,address,uint256,bytes)', bytes32)
127 
128 
129 @public
130 def approve(_approved: address, _tokenId: uint256):
131     owner: address = self.ownerOf[_tokenId]
132     # Check requirements
133     senderIsOwner: bool = msg.sender == owner
134     senderIsApprovedForAll: bool = (self.isApprovedForAll[owner])[msg.sender]
135     assert senderIsOwner or senderIsApprovedForAll
136     # Set the approval
137     self.getApproved[_tokenId] = _approved
138     log.Approval(owner, _approved, _tokenId)
139 
140 
141 @public
142 def setApprovalForAll(_operator: address, _approved: bool):
143     assert _operator != msg.sender
144     self.isApprovedForAll[msg.sender][_operator] = _approved
145     log.ApprovalForAll(msg.sender, _operator, _approved)
146 
147 
148 @public
149 def mint(_to: address) -> bool:
150     assert msg.sender == self.minter and _to != ZERO_ADDRESS
151     _tokenId: uint256 = self.totalSupply
152     _toBal: uint256 = self.balanceOf[_to]
153     # can only mint if a sock has been burned
154     # _socksSupply: uint256 = self.socks.totalSupply()
155     # _socksBurned: uint256 = 500 * 10**18 - _socksSupply
156     # assert _tokenId * 10**18 < _socksBurned
157     # update mappings
158     self.ownerOf[_tokenId] = _to
159     self.balanceOf[_to] += 1
160     self.ownerIndexToTokenId[_to][_toBal] = _tokenId
161     self.tokenIdToIndex[_tokenId] = _toBal
162     self.totalSupply += 1
163     log.Transfer(ZERO_ADDRESS, _to, _tokenId)
164     return True
165 
166 
167 @public
168 def changeMinter(_minter: address):
169     assert msg.sender == self.minter
170     self.minter = _minter