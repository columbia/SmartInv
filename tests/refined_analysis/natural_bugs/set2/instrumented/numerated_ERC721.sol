1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.8.4;
3 
4 import {IERC721Extended} from '../interfaces/IERC721Extended.sol';
5 import {IERC721Receiver} from '@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol';
6 
7 abstract contract ERC721 is IERC721Extended {
8     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
9     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
10     bytes4 private constant _INTERFACE_ID_ERC721METADATA = 0x5b5e139f;
11     bytes4 private constant _INTERFACE_ID_ERC721ENUMERABLE = 0x780e9d63;
12 
13     mapping(address => uint256) private _balances;
14     mapping(uint256 => address) internal _owners;
15     mapping(uint256 => address) private _tokenApprovals;
16     mapping(address => mapping(address => bool)) private _operatorApprovals;
17     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
18     mapping(uint256 => uint256) private _ownedTokensIndex;
19 
20     function balanceOf(address owner) external view override returns (uint256) {
21         require(owner != address(0), 'E613');
22         return _balances[owner];
23     }
24 
25     function ownerOf(uint256 id) external view override returns (address) {
26         address owner = _owners[id];
27         require(owner != address(0), 'E613');
28         return owner;
29     }
30 
31     function getApproved(uint256 id) external view override returns (address) {
32         require(_owners[id] != address(0), 'E614');
33         return _tokenApprovals[id];
34     }
35 
36     function isApprovedForAll(address owner, address operator) external view override returns (bool) {
37         return _operatorApprovals[owner][operator];
38     }
39 
40     function tokenOfOwnerByIndex(address owner, uint256 id) external view override returns (uint256) {
41         require(id < _balances[owner], 'E614');
42         return _ownedTokens[owner][id];
43     }
44 
45     function supportsInterface(bytes4 interfaceID) external pure override returns (bool) {
46         return
47             interfaceID == _INTERFACE_ID_ERC165 ||
48             interfaceID == _INTERFACE_ID_ERC721 ||
49             interfaceID == _INTERFACE_ID_ERC721METADATA ||
50             interfaceID == _INTERFACE_ID_ERC721ENUMERABLE;
51     }
52 
53     modifier isApproved(address owner, uint256 id) {
54         require(
55             owner == msg.sender || _tokenApprovals[id] == msg.sender || _operatorApprovals[owner][msg.sender],
56             '611'
57         );
58         _;
59     }
60 
61     function safeTransferFrom(
62         address from,
63         address to,
64         uint256 id
65     ) external override isApproved(from, id) {
66         _safeTransfer(from, to, id, '');
67     }
68 
69     function safeTransferFrom(
70         address from,
71         address to,
72         uint256 id,
73         bytes memory data
74     ) external override isApproved(from, id) {
75         _safeTransfer(from, to, id, data);
76     }
77 
78     function transferFrom(
79         address from,
80         address to,
81         uint256 id
82     ) external override isApproved(from, id) {
83         _transfer(from, to, id);
84     }
85 
86     function approve(address to, uint256 id) external override {
87         address owner = _owners[id];
88         require(owner == msg.sender || _operatorApprovals[owner][msg.sender], '609');
89         require(to != owner, 'E605');
90 
91         _approve(to, id);
92     }
93 
94     function setApprovalForAll(address operator, bool approved) external override {
95         require(operator != msg.sender, 'E607');
96 
97         _setApprovalForAll(operator, approved);
98     }
99 
100     function _safeTransfer(
101         address from,
102         address to,
103         uint256 id,
104         bytes memory data
105     ) private {
106         _transfer(from, to, id);
107 
108         require(_checkOnERC721Received(from, to, id, data), 'E608');
109     }
110 
111     function _approve(address to, uint256 id) internal {
112         _tokenApprovals[id] = to;
113 
114         emit Approval(_owners[id], to, id);
115     }
116 
117     function _setApprovalForAll(address operator, bool approved) private {
118         _operatorApprovals[msg.sender][operator] = approved;
119 
120         emit ApprovalForAll(msg.sender, operator, approved);
121     }
122 
123     function _safeMint(address to, uint256 id) internal {
124         _mint(to, id);
125 
126         require(_checkOnERC721Received(address(0), to, id, ''), 'E610');
127     }
128 
129     function _mint(address to, uint256 id) private {
130         require(to != address(0), 'E601');
131         require(_owners[id] == address(0), 'E604');
132 
133         uint256 length = _balances[to];
134         _ownedTokens[to][length] = id;
135         _ownedTokensIndex[id] = length;
136 
137         _balances[to]++;
138         _owners[id] = to;
139 
140         emit Transfer(address(0), to, id);
141     }
142 
143     function _transfer(
144         address from,
145         address to,
146         uint256 id
147     ) private {
148         require(to != address(0), 'E601');
149 
150         if (from != to) {
151             uint256 lastTokenIndex = _balances[from] - 1;
152             uint256 tokenIndex = _ownedTokensIndex[id];
153 
154             if (lastTokenIndex != tokenIndex) {
155                 uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
156 
157                 _ownedTokens[from][tokenIndex] = lastTokenId;
158                 _ownedTokensIndex[lastTokenId] = tokenIndex;
159             }
160 
161             delete _ownedTokens[from][lastTokenIndex];
162 
163             uint256 length = _balances[to];
164             _ownedTokens[to][length] = id;
165             _ownedTokensIndex[id] = length;
166         }
167 
168         _owners[id] = to;
169         _balances[from]--;
170         _balances[to]++;
171 
172         _approve(address(0), id);
173 
174         emit Transfer(from, to, id);
175     }
176 
177     function _checkOnERC721Received(
178         address from,
179         address to,
180         uint256 id,
181         bytes memory data
182     ) private returns (bool) {
183         uint256 size;
184         assembly {
185             size := extcodesize(to)
186         }
187         if (size == 0) {
188             return true;
189         } else {
190             bytes memory returnData;
191             (bool success, bytes memory _return) = to.call(
192                 abi.encodeWithSelector(IERC721Receiver(to).onERC721Received.selector, msg.sender, from, id, data)
193             );
194             if (success) {
195                 returnData = _return;
196             } else if (_return.length != 0) {
197                 assembly {
198                     let returnDataSize := mload(_return)
199                     revert(add(32, _return), returnDataSize)
200                 }
201             } else {
202                 revert('E610');
203             }
204             bytes4 retval = abi.decode(returnData, (bytes4));
205             return (retval == 0x150b7a02);
206         }
207     }
208 }
