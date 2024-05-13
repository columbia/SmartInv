1 // SPDX-License-Identifier: BUSL-1.1
2 pragma solidity 0.8.19;
3 
4 import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
5 import { ERC721Enumerable } from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
6 import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";
7 import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
8 import { Utils } from "../utility/Utils.sol";
9 import { IVoucher } from "./interfaces/IVoucher.sol";
10 import { CarbonController } from "../carbon/CarbonController.sol";
11 
12 contract Voucher is IVoucher, ERC721Enumerable, Utils, Ownable {
13     using Strings for uint256;
14 
15     error CarbonControllerNotSet();
16 
17     // the carbon controller contract
18     CarbonController private _carbonController;
19 
20     // a flag used to toggle between a unique URI per token / one global URI for all tokens
21     bool private _useGlobalURI;
22 
23     // the prefix of a dynamic URI representing a single token
24     string private __baseURI;
25 
26     // the suffix of a dynamic URI for e.g. `.json`
27     string private _baseExtension;
28 
29     /**
30      @dev triggered when updating useGlobalURI
31      */
32     event UseGlobalURIUpdated(bool newUseGlobalURI);
33 
34     /**
35      * @dev triggered when updating the baseURI
36      */
37     event BaseURIUpdated(string newBaseURI);
38 
39     /**
40      * @dev triggered when updating the baseExtension
41      */
42     event BaseExtensionUpdated(string newBaseExtension);
43 
44     /**
45      * @dev triggered when updating the address of the carbonController contract
46      */
47     event CarbonControllerUpdated(CarbonController carbonController);
48 
49     constructor(
50         bool newUseGlobalURI,
51         string memory newBaseURI,
52         string memory newBaseExtension
53     ) ERC721("Carbon Automated Trading Strategy", "CARBON-STRAT") {
54         useGlobalURI(newUseGlobalURI);
55         setBaseURI(newBaseURI);
56         setBaseExtension(newBaseExtension);
57     }
58 
59     /**
60      * @inheritdoc IVoucher
61      */
62     function mint(address provider, uint256 strategyId) external only(address(_carbonController)) {
63         _safeMint(provider, strategyId);
64     }
65 
66     /**
67      * @inheritdoc IVoucher
68      */
69     function burn(uint256 strategyId) external only(address(_carbonController)) {
70         _burn(strategyId);
71     }
72 
73     /**
74      * @dev stores the carbonController address
75      *
76      * requirements:
77      *
78      * - the caller must be the owner of this contract
79      */
80     function setCarbonController(
81         CarbonController carbonController
82     ) external onlyOwner validAddress(address(carbonController)) {
83         if (_carbonController == carbonController) {
84             return;
85         }
86 
87         _carbonController = carbonController;
88         emit CarbonControllerUpdated(carbonController);
89     }
90 
91     /**
92      * @dev depending on the useGlobalURI flag, returns a unique URI point to a json representing the voucher,
93      * or a URI of a global json used for all tokens
94      */
95     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
96         _requireMinted(tokenId);
97         string memory baseURI = _baseURI();
98         if (_useGlobalURI == true) {
99             return baseURI;
100         } else {
101             return
102                 bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), _baseExtension)) : "";
103         }
104     }
105 
106     /**
107      * @dev sets the base URI
108      *
109      * requirements:
110      *
111      * - the caller must be the owner of this contract
112      */
113     function setBaseURI(string memory newBaseURI) public onlyOwner {
114         __baseURI = newBaseURI;
115 
116         emit BaseURIUpdated(newBaseURI);
117     }
118 
119     /**
120      * @dev sets the base extension
121      *
122      * requirements:
123      *
124      * - the caller must be the owner of this contract
125      */
126     function setBaseExtension(string memory newBaseExtension) public onlyOwner {
127         _baseExtension = newBaseExtension;
128 
129         emit BaseExtensionUpdated(newBaseExtension);
130     }
131 
132     /**
133      * @dev sets the useGlobalURI flag
134      *
135      * requirements:
136      *
137      * - the caller must be the owner of this contract
138      */
139     function useGlobalURI(bool newUseGlobalURI) public onlyOwner {
140         if (_useGlobalURI == newUseGlobalURI) {
141             return;
142         }
143 
144         _useGlobalURI = newUseGlobalURI;
145         emit UseGlobalURIUpdated(newUseGlobalURI);
146     }
147 
148     /**
149      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
150      * token will be the concatenation of the `baseURI`, `tokenId`
151      */
152     function _baseURI() internal view virtual override returns (string memory) {
153         return __baseURI;
154     }
155 }
