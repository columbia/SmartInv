1 /*
2  SPDX-License-Identifier: MIT
3 */
4 
5 pragma experimental ABIEncoderV2;
6 pragma solidity =0.7.6;
7 /******************************************************************************\
8 * Author: Nick Mudge <nick@perfectabstractions.com> (https://twitter.com/mudgen)
9 * EIP-2535 Diamonds: https://eips.ethereum.org/EIPS/eip-2535
10 /******************************************************************************/
11 
12 import {IDiamondCut} from "../interfaces/IDiamondCut.sol";
13 import {IDiamondLoupe} from "../interfaces/IDiamondLoupe.sol";
14 import {IERC165} from "../interfaces/IERC165.sol";
15 
16 library LibDiamond {
17     bytes32 constant DIAMOND_STORAGE_POSITION = keccak256("diamond.standard.diamond.storage");
18 
19     struct FacetAddressAndPosition {
20         address facetAddress;
21         uint96 functionSelectorPosition; // position in facetFunctionSelectors.functionSelectors array
22     }
23 
24     struct FacetFunctionSelectors {
25         bytes4[] functionSelectors;
26         uint256 facetAddressPosition; // position of facetAddress in facetAddresses array
27     }
28 
29     struct DiamondStorage {
30         // maps function selector to the facet address and
31         // the position of the selector in the facetFunctionSelectors.selectors array
32         mapping(bytes4 => FacetAddressAndPosition) selectorToFacetAndPosition;
33         // maps facet addresses to function selectors
34         mapping(address => FacetFunctionSelectors) facetFunctionSelectors;
35         // facet addresses
36         address[] facetAddresses;
37         // Used to query if a contract implements an interface.
38         // Used to implement ERC-165.
39         mapping(bytes4 => bool) supportedInterfaces;
40         // owner of the contract
41         address contractOwner;
42     }
43 
44     function diamondStorage() internal pure returns (DiamondStorage storage ds) {
45         bytes32 position = DIAMOND_STORAGE_POSITION;
46         assembly {
47             ds.slot := position
48         }
49     }
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     function setContractOwner(address _newOwner) internal {
54         DiamondStorage storage ds = diamondStorage();
55         address previousOwner = ds.contractOwner;
56         ds.contractOwner = _newOwner;
57         emit OwnershipTransferred(previousOwner, _newOwner);
58     }
59 
60     function contractOwner() internal view returns (address contractOwner_) {
61         contractOwner_ = diamondStorage().contractOwner;
62     }
63 
64     function enforceIsOwnerOrContract() internal view {
65         require(msg.sender == diamondStorage().contractOwner ||
66                 msg.sender == address(this), "LibDiamond: Must be contract or owner"
67         );
68     }
69 
70     function enforceIsContractOwner() internal view {
71         require(msg.sender == diamondStorage().contractOwner, "LibDiamond: Must be contract owner");
72     }
73 
74     event DiamondCut(IDiamondCut.FacetCut[] _diamondCut, address _init, bytes _calldata);
75 
76     function addDiamondFunctions(
77         address _diamondCutFacet,
78         address _diamondLoupeFacet
79     ) internal {
80         IDiamondCut.FacetCut[] memory cut = new IDiamondCut.FacetCut[](2);
81         bytes4[] memory functionSelectors = new bytes4[](1);
82         functionSelectors[0] = IDiamondCut.diamondCut.selector;
83         cut[0] = IDiamondCut.FacetCut({facetAddress: _diamondCutFacet, action: IDiamondCut.FacetCutAction.Add, functionSelectors: functionSelectors});
84         functionSelectors = new bytes4[](5);
85         functionSelectors[0] = IDiamondLoupe.facets.selector;
86         functionSelectors[1] = IDiamondLoupe.facetFunctionSelectors.selector;
87         functionSelectors[2] = IDiamondLoupe.facetAddresses.selector;
88         functionSelectors[3] = IDiamondLoupe.facetAddress.selector;
89         functionSelectors[4] = IERC165.supportsInterface.selector;
90         cut[1] = IDiamondCut.FacetCut({
91             facetAddress: _diamondLoupeFacet,
92             action: IDiamondCut.FacetCutAction.Add,
93             functionSelectors: functionSelectors
94         });
95         diamondCut(cut, address(0), "");
96     }
97 
98     // Internal function version of diamondCut
99     function diamondCut(
100         IDiamondCut.FacetCut[] memory _diamondCut,
101         address _init,
102         bytes memory _calldata
103     ) internal {
104         for (uint256 facetIndex; facetIndex < _diamondCut.length; facetIndex++) {
105             IDiamondCut.FacetCutAction action = _diamondCut[facetIndex].action;
106             if (action == IDiamondCut.FacetCutAction.Add) {
107                 addFunctions(_diamondCut[facetIndex].facetAddress, _diamondCut[facetIndex].functionSelectors);
108             } else if (action == IDiamondCut.FacetCutAction.Replace) {
109                 replaceFunctions(_diamondCut[facetIndex].facetAddress, _diamondCut[facetIndex].functionSelectors);
110             } else if (action == IDiamondCut.FacetCutAction.Remove) {
111                 removeFunctions(_diamondCut[facetIndex].facetAddress, _diamondCut[facetIndex].functionSelectors);
112             } else {
113                 revert("LibDiamondCut: Incorrect FacetCutAction");
114             }
115         }
116         emit DiamondCut(_diamondCut, _init, _calldata);
117         initializeDiamondCut(_init, _calldata);
118     }
119 
120     function addFunctions(address _facetAddress, bytes4[] memory _functionSelectors) internal {
121         require(_functionSelectors.length > 0, "LibDiamondCut: No selectors in facet to cut");
122         DiamondStorage storage ds = diamondStorage();        
123         require(_facetAddress != address(0), "LibDiamondCut: Add facet can't be address(0)");
124         uint96 selectorPosition = uint96(ds.facetFunctionSelectors[_facetAddress].functionSelectors.length);
125         // add new facet address if it does not exist
126         if (selectorPosition == 0) {
127             addFacet(ds, _facetAddress);            
128         }
129         for (uint256 selectorIndex; selectorIndex < _functionSelectors.length; selectorIndex++) {
130             bytes4 selector = _functionSelectors[selectorIndex];
131             address oldFacetAddress = ds.selectorToFacetAndPosition[selector].facetAddress;
132             require(oldFacetAddress == address(0), "LibDiamondCut: Can't add function that already exists");
133             addFunction(ds, selector, selectorPosition, _facetAddress);
134             selectorPosition++;
135         }
136     }
137 
138     function replaceFunctions(address _facetAddress, bytes4[] memory _functionSelectors) internal {
139         require(_functionSelectors.length > 0, "LibDiamondCut: No selectors in facet to cut");
140         DiamondStorage storage ds = diamondStorage();
141         require(_facetAddress != address(0), "LibDiamondCut: Add facet can't be address(0)");
142         uint96 selectorPosition = uint96(ds.facetFunctionSelectors[_facetAddress].functionSelectors.length);
143         // add new facet address if it does not exist
144         if (selectorPosition == 0) {
145             addFacet(ds, _facetAddress);
146         }
147         for (uint256 selectorIndex; selectorIndex < _functionSelectors.length; selectorIndex++) {
148             bytes4 selector = _functionSelectors[selectorIndex];
149             address oldFacetAddress = ds.selectorToFacetAndPosition[selector].facetAddress;
150             require(oldFacetAddress != _facetAddress, "LibDiamondCut: Can't replace function with same function");
151             removeFunction(ds, oldFacetAddress, selector);
152             addFunction(ds, selector, selectorPosition, _facetAddress);
153             selectorPosition++;
154         }
155     }
156 
157     function removeFunctions(address _facetAddress, bytes4[] memory _functionSelectors) internal {
158         require(_functionSelectors.length > 0, "LibDiamondCut: No selectors in facet to cut");
159         DiamondStorage storage ds = diamondStorage();
160         // if function does not exist then do nothing and return
161         require(_facetAddress == address(0), "LibDiamondCut: Remove facet address must be address(0)");
162         for (uint256 selectorIndex; selectorIndex < _functionSelectors.length; selectorIndex++) {
163             bytes4 selector = _functionSelectors[selectorIndex];
164             address oldFacetAddress = ds.selectorToFacetAndPosition[selector].facetAddress;
165             removeFunction(ds, oldFacetAddress, selector);
166         }
167     }
168 
169     function addFacet(DiamondStorage storage ds, address _facetAddress) internal {
170         enforceHasContractCode(_facetAddress, "LibDiamondCut: New facet has no code");
171         ds.facetFunctionSelectors[_facetAddress].facetAddressPosition = ds.facetAddresses.length;
172         ds.facetAddresses.push(_facetAddress);
173     }    
174 
175 
176     function addFunction(DiamondStorage storage ds, bytes4 _selector, uint96 _selectorPosition, address _facetAddress) internal {
177         ds.selectorToFacetAndPosition[_selector].functionSelectorPosition = _selectorPosition;
178         ds.facetFunctionSelectors[_facetAddress].functionSelectors.push(_selector);
179         ds.selectorToFacetAndPosition[_selector].facetAddress = _facetAddress;
180     }
181 
182     function removeFunction(DiamondStorage storage ds, address _facetAddress, bytes4 _selector) internal {        
183         require(_facetAddress != address(0), "LibDiamondCut: Can't remove function that doesn't exist");
184         // an immutable function is a function defined directly in a diamond
185         require(_facetAddress != address(this), "LibDiamondCut: Can't remove immutable function");
186         // replace selector with last selector, then delete last selector
187         uint256 selectorPosition = ds.selectorToFacetAndPosition[_selector].functionSelectorPosition;
188         uint256 lastSelectorPosition = ds.facetFunctionSelectors[_facetAddress].functionSelectors.length - 1;
189         // if not the same then replace _selector with lastSelector
190         if (selectorPosition != lastSelectorPosition) {
191             bytes4 lastSelector = ds.facetFunctionSelectors[_facetAddress].functionSelectors[lastSelectorPosition];
192             ds.facetFunctionSelectors[_facetAddress].functionSelectors[selectorPosition] = lastSelector;
193             ds.selectorToFacetAndPosition[lastSelector].functionSelectorPosition = uint96(selectorPosition);
194         }
195         // delete the last selector
196         ds.facetFunctionSelectors[_facetAddress].functionSelectors.pop();
197         delete ds.selectorToFacetAndPosition[_selector];
198 
199         // if no more selectors for facet address then delete the facet address
200         if (lastSelectorPosition == 0) {
201             // replace facet address with last facet address and delete last facet address
202             uint256 lastFacetAddressPosition = ds.facetAddresses.length - 1;
203             uint256 facetAddressPosition = ds.facetFunctionSelectors[_facetAddress].facetAddressPosition;
204             if (facetAddressPosition != lastFacetAddressPosition) {
205                 address lastFacetAddress = ds.facetAddresses[lastFacetAddressPosition];
206                 ds.facetAddresses[facetAddressPosition] = lastFacetAddress;
207                 ds.facetFunctionSelectors[lastFacetAddress].facetAddressPosition = facetAddressPosition;
208             }
209             ds.facetAddresses.pop();
210             delete ds.facetFunctionSelectors[_facetAddress].facetAddressPosition;
211         }
212     }
213 
214     function initializeDiamondCut(address _init, bytes memory _calldata) internal {
215         if (_init == address(0)) {
216             require(_calldata.length == 0, "LibDiamondCut: _init is address(0) but_calldata is not empty");
217         } else {
218             require(_calldata.length > 0, "LibDiamondCut: _calldata is empty but _init is not address(0)");
219             if (_init != address(this)) {
220                 enforceHasContractCode(_init, "LibDiamondCut: _init address has no code");
221             }
222             (bool success, bytes memory error) = _init.delegatecall(_calldata);
223             if (!success) {
224                 if (error.length > 0) {
225                     // bubble up the error
226                     revert(string(error));
227                 } else {
228                     revert("LibDiamondCut: _init function reverted");
229                 }
230             }
231         }
232     }
233 
234     function enforceHasContractCode(address _contract, string memory _errorMessage) internal view {
235         uint256 contractSize;
236         assembly {
237             contractSize := extcodesize(_contract)
238         }
239         require(contractSize > 0, _errorMessage);
240     }
241 }