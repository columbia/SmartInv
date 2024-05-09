1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.17;
3 
4 /////////////////////////////////
5 //                             //
6 //                             //
7 //                             //
8 //                             //
9 //                             //
10 //              N.             //
11 //              —              //
12 //             0xG             //
13 //                             //
14 //                             //
15 //                             //
16 //                             //
17 /////////////////////////////////
18 
19 contract N {
20   uint public tokenId;
21   mapping(address => uint) public collectors;
22   address _owner;
23   address _tokenOwner;
24   string _uri;
25 
26   event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
27 
28   constructor() { _owner = msg.sender; }
29 
30   function supportsInterface(bytes4 interfaceId) public view virtual returns (bool) {
31     return (
32       interfaceId == /* IERC721 */ 0x80ac58cd ||
33       interfaceId == /* IERC721Metadata */ 0x5b5e139f ||
34       interfaceId == /* IERC165 */ 0x01ffc9a7
35     );
36   }
37 
38   function ownerOf(uint256 _tokenId) public view virtual returns (address) {
39     require(_tokenId == 0 || _tokenId == tokenId, "ERC721: invalid token ID");
40     return _tokenOwner;
41   }
42 
43   function balanceOf(address owner) public view virtual returns (uint256) {
44     require(owner != address(0), "ERC721: address zero is not a valid owner");
45     return owner == _tokenOwner ? 1 : 0;
46   }
47 
48   function mint() external {
49     if (tokenId != 0) {
50       // Burn it.
51       emit Transfer(_tokenOwner, address(0), tokenId);
52     } else {
53       require(msg.sender == _owner, "N.ot yet");
54     }
55     _tokenOwner = msg.sender;
56     tokenId += 1;
57     collectors[msg.sender] = tokenId;
58     emit Transfer(address(0), msg.sender, tokenId);
59   }
60 
61   function tokenURI(uint256 _tokenId) public view virtual returns (string memory) {
62     require(_tokenId == tokenId, "ERC721: invalid token ID");
63 
64     return string(
65       abi.encodePacked(
66         "data:application/json;utf8,",
67         '{"name":"N. #',toString(tokenId),'","created_by":"0xG","description":"","image":"',
68         bytes(_uri).length > 0 ? _uri : 'data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBzdGFuZGFsb25lPSJ5ZXMiPz4KPHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAxMDAwIDEwMDAiIHN0eWxlPSJ3aWR0aDogMTAwdmg7IGhlaWdodDogMTAwdmg7IG1heC13aWR0aDogMTAwJTsgbWF4LWhlaWdodDogMTAwJTsgbWFyZ2luOiBhdXRvIj4KICA8IS0tIE4uIOKAkyDCqSAweEcgLS0+CiAgPGRlZnM+CiAgICA8bGluZWFyR3JhZGllbnQgaWQ9IjB4R19iZyIgeDE9IjAlIiB5MT0iMCUiIHgyPSIwJSIgeTI9IjEwMCUiPgogICAgICA8c3RvcCBvZmZzZXQ9IjAlIiBzdG9wLWNvbG9yPSIjMTExIiAvPgogICAgICA8c3RvcCBvZmZzZXQ9IjEwMCUiIHN0b3AtY29sb3I9IiMwMDAiIC8+CiAgICA8L2xpbmVhckdyYWRpZW50PgogICAgPGxpbmVhckdyYWRpZW50IGlkPSIweEdfbCIgeDE9IjAlIiB5MT0iMCUiIHgyPSIwJSIgeTI9IjEwMCUiPgogICAgICA8c3RvcCBvZmZzZXQ9IjAlIiBzdG9wLWNvbG9yPSIjMDAwIiAvPgogICAgICA8c3RvcCBvZmZzZXQ9IjEwMCUiIHN0b3AtY29sb3I9IiMwMDAiIHN0b3Atb3BhY2l0eT0iMCIgLz4KICAgIDwvbGluZWFyR3JhZGllbnQ+CiAgICA8ZmlsdGVyIGlkPSIweEdfbm9pc2UiPgogICAgICA8ZmVUdXJidWxlbmNlIHR5cGU9ImZyYWN0YWxOb2lzZSIgYmFzZUZyZXF1ZW5jeT0iNSIgbnVtT2N0YXZlcz0iMyIgc3RpdGNoVGlsZXM9InN0aXRjaCIgLz4KICAgICAgPGZlQ29sb3JNYXRyaXggdHlwZT0ic2F0dXJhdGUiIHZhbHVlcz0iMCIgLz4KICAgICAgPGZlQ29tcG9uZW50VHJhbnNmZXI+CiAgICAgICAgPGZlRnVuY1IgdHlwZT0ibGluZWFyIiBzbG9wZT0iMC41IiAvPgogICAgICAgIDxmZUZ1bmNHIHR5cGU9ImxpbmVhciIgc2xvcGU9IjAuNSIgLz4KICAgICAgICA8ZmVGdW5jQiB0eXBlPSJsaW5lYXIiIHNsb3BlPSIwLjUiIC8+CiAgICAgIDwvZmVDb21wb25lbnRUcmFuc2Zlcj4KICAgICAgPGZlQmxlbmQgbW9kZT0ic2NyZWVuIiAvPgogICAgPC9maWx0ZXI+CiAgPC9kZWZzPgogIDxyZWN0IHdpZHRoPSIxMDAwIiBoZWlnaHQ9IjEwMDAiIGZpbGw9InVybCgjMHhHX2JnKSIgLz4KICA8cmVjdCBoZWlnaHQ9IjUwMCIgd2lkdGg9IjUwMCIgeT0iMjUwIiB4PSIyNTAiIGZpbGw9InVybCgjMHhHX2wpIiAgLz4KICA8cmVjdCB3aWR0aD0iMTAwMCIgaGVpZ2h0PSIxMDAwIiBmaWx0ZXI9InVybCgjMHhHX25vaXNlKSIgb3BhY2l0eT0iMC4xIi8+Cjwvc3ZnPgo=',
69         '"}'
70       )
71     );
72   }
73 
74   function name() public view virtual returns (string memory) {
75     return "N.";
76   }
77 
78   function symbol() public view virtual returns (string memory) {
79     return "N";
80   }
81 
82   function owner() public view virtual returns (address) {
83     return _owner;
84   }
85 
86   modifier onlyOwner {
87     require(msg.sender == _owner, "Unauthorized");
88     _;
89   }
90 
91   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
92   function transferOwnership(address _new) external virtual onlyOwner {
93     address _old = _owner;
94     _owner = _new;
95     emit OwnershipTransferred(_old, _new);
96   }
97 
98   function setUri(string calldata _new) external onlyOwner {
99     _uri = _new;
100   }
101 
102   // Taken from "@openzeppelin/contracts/utils/Strings.sol";
103   function toString(uint256 value) internal pure returns (string memory) {
104     if (value == 0) {
105       return "0";
106     }
107     uint256 temp = value;
108     uint256 digits;
109     while (temp != 0) {
110       digits++;
111       temp /= 10;
112     }
113     bytes memory buffer = new bytes(digits);
114     while (value != 0) {
115       digits -= 1;
116       buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
117       value /= 10;
118     }
119     return string(buffer);
120   }
121 }