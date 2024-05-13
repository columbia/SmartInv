1 /*
2  SPDX-License-Identifier: MIT
3 */
4 
5 pragma solidity =0.7.6;
6 pragma experimental ABIEncoderV2;
7 
8 import "contracts/beanstalk/metadata/MetadataImage.sol";
9 import {LibBytes} from "contracts/libraries/LibBytes.sol";
10 import {LibTokenSilo} from "contracts/libraries/Silo/LibTokenSilo.sol";
11 import {SafeMath} from "@openzeppelin/contracts/math/SafeMath.sol";
12 
13 /**
14  * @author brean
15  * @title MockMetadataFacet is a Mock version of MetadataFacet.
16  * @dev used to deploy on testnets to verify that json data and SVG encoding is correct.
17  * Steps for testing:
18  * 1: deploy MockMetadataFacet
19  * 2: deploy MetadataMockERC1155 with the address of the MockMetadataFacet.
20  * (MockMetadataFacet with ERC1155 exceeds the contract size limit.)
21 **/
22 contract MockMetadataFacet is MetadataImage  {
23     using SafeMath for uint256;
24 
25     // inital conditions: 2 seeds, 1000 seasons has elapsed from milestone season.
26     uint256 public stalkEarnedPerSeason = 2e6;
27     uint256 public seasonsElapsed = 1000;
28     uint256 public stalkIssuedPerBdv = 10000;
29 
30     using LibStrings for uint256;
31     using LibStrings for int256;
32 
33     event URI(string _uri, uint256 indexed _id);
34 
35     /**
36      * @notice Returns the URI for a given depositId.
37      * @param depositId - the id of the deposit
38      * @dev the URI is a base64 encoded JSON object that contains the metadata and base64 encoded svg.
39      * Deposits are stored as a mapping of a uint256 to a Deposit struct.
40      * ERC20 deposits are represented by the concatination of the token address and the stem. (20 + 12 bytes).
41      */
42     function uri(uint256 depositId) external view returns (string memory) {
43         (address token, int96 stem) = LibBytes.unpackAddressAndStem(depositId);
44         int96 stemTip = int96(stalkEarnedPerSeason.mul(seasonsElapsed));
45         bytes memory attributes = abi.encodePacked(
46             ', "attributes": [ { "trait_type": "Token", "value": "', getTokenName(token),
47             '"}, { "trait_type": "Token Address", "value": "', LibStrings.toHexString(uint256(token), 20),
48             '"}, { "trait_type": "Id", "value": "', depositId.toHexString(32),
49             '"}, { "trait_type": "stem", "display_type": "number", "value": ', int256(stem).toString(),
50             '}, { "trait_type": "inital stalk per BDV", "display_type": "number", "value": ', stalkIssuedPerBdv.toString(),
51             '}, { "trait_type": "grown stalk per BDV", "display_type": "number", "value": ', uint256(stemTip - stem).toString(),
52             '}, { "trait_type": "stalk grown per BDV per season", "display_type": "number", "value": ', stalkEarnedPerSeason.toString()
53         );
54         return string(abi.encodePacked("data:application/json;base64,",LibBytes64.encode(abi.encodePacked(
55                 '{',
56                     '"name": "Beanstalk Silo Deposits", "description": "An ERC1155 representing an asset deposited in the Beanstalk Silo. Silo Deposits gain stalk and bean seignorage. ',
57                     '\\n\\nDISCLAIMER: Due diligence is imperative when assessing this NFT. Opensea and other NFT marketplaces cache the svg output and thus, may require the user to refresh the metadata to properly show the correct values."',
58                     attributes,
59                     string(abi.encodePacked('}], "image": "', imageURI(token, stem, stemTip), '"')),
60                 '}'
61             ))
62         ));
63     }
64 
65     function name() external pure returns (string memory){
66         return "Beanstalk Silo Deposits";
67     }
68 
69     function symbol() external pure returns (string memory){
70         return "DEPOSIT";
71     } 
72 
73     function setSeeds(uint256 _stalkEarnedPerSeason) external {
74         stalkEarnedPerSeason = _stalkEarnedPerSeason;
75     }
76 
77     function setSeasonElapsed(uint256 _seasonsElapsed) external {
78         seasonsElapsed = _seasonsElapsed;
79     }
80 
81     function setStalkIssuedPerBdv(uint256 _stalkIssuedPerBdv) external {
82         stalkIssuedPerBdv = _stalkIssuedPerBdv;
83     }
84 
85 }
