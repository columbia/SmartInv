1 // SPDX-License-Identifier: LGPL-3.0-only
2 pragma solidity 0.8.11;
3 
4 // This is adapted from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.0/contracts/presets/ERC721PresetMinterPauserAutoId.sol
5 
6 import "./utils/AccessControl.sol";
7 import "@openzeppelin/contracts/utils/Context.sol";
8 import "@openzeppelin/contracts/utils/Counters.sol";
9 import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
10 import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
11 import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
12 
13 contract ERC721MinterBurnerPauser is Context, AccessControl, ERC721Burnable, ERC721Pausable, ERC721URIStorage {
14     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
15     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
16 
17     string public baseURI;
18 
19     /**
20      * @dev Grants `DEFAULT_ADMIN_ROLE` and `MINTER_ROLE`to the account that
21      * deploys the contract.
22      *
23      * Token URIs will be autogenerated based on `baseURI` and their token IDs.
24      * See {ERC721-tokenURI}.
25      */
26     constructor(string memory name, string memory symbol, string memory baseURI) public ERC721(name, symbol) {
27         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
28 
29         _setupRole(MINTER_ROLE, _msgSender());
30         _setupRole(PAUSER_ROLE, _msgSender());
31 
32         _setBaseURI(baseURI);
33     }
34 
35     /**
36      * @dev Creates a new token for `to`. Its token ID will be automatically
37      * assigned (and available on the emitted {Transfer} event), and the token
38      * URI autogenerated based on the base URI passed at construction.
39      *
40      * See {ERC721-_mint}.
41      *
42      * Requirements:
43      *
44      * - the caller must have the `MINTER_ROLE`.
45      */
46     function mint(address to, uint256 tokenId, string memory _data) public {
47         require(hasRole(MINTER_ROLE, _msgSender()), "ERC721MinterBurnerPauser: must have minter role to mint");
48 
49         _mint(to, tokenId);
50         _setTokenURI(tokenId, _data);
51     }
52 
53     /**
54      * @dev Pauses all token transfers.
55      *
56      * See {ERC721Pausable} and {Pausable-_pause}.
57      *
58      * Requirements:
59      *
60      * - the caller must have the `PAUSER_ROLE`.
61      */
62     function pause() public {
63         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC721MinterBurnerPauser: must have pauser role to pause");
64         _pause();
65     }
66 
67     /**
68      * @dev Unpauses all token transfers.
69      *
70      * See {ERC721Pausable} and {Pausable-_unpause}.
71      *
72      * Requirements:
73      *
74      * - the caller must have the `PAUSER_ROLE`.
75      */
76     function unpause() public {
77         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC721MinterBurnerPauser: must have pauser role to unpause");
78         _unpause();
79     }
80 
81     function tokenURI(uint256 tokenId) public view virtual override(ERC721, ERC721URIStorage) returns (string memory) {
82         return super.tokenURI(tokenId);
83     }
84 
85     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Pausable) {
86         super._beforeTokenTransfer(from, to, tokenId);
87     }
88 
89     function _setBaseURI(string memory baseURI_) internal {
90         baseURI = baseURI_;
91     }
92 
93     function _baseURI() internal view virtual override returns (string memory) {
94         return baseURI;
95     }
96 
97     function _burn(uint256 tokenId) internal virtual override(ERC721, ERC721URIStorage) {
98         super._burn(tokenId);
99     }
100 }
