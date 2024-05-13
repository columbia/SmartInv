1 // SPDX-License-Identifier: GNU-GPL v3.0 or later
2 
3 pragma solidity >=0.8.0;
4 
5 import "./IRevest.sol";
6 
7 interface ITokenVault {
8 
9     function createFNFT(
10         uint fnftId,
11         IRevest.FNFTConfig memory fnftConfig,
12         uint quantity,
13         address from
14     ) external;
15 
16     function withdrawToken(
17         uint fnftId,
18         uint quantity,
19         address user
20     ) external;
21 
22     function depositToken(
23         uint fnftId,
24         uint amount,
25         uint quantity
26     ) external;
27 
28     function cloneFNFTConfig(IRevest.FNFTConfig memory old) external returns (IRevest.FNFTConfig memory);
29 
30     function mapFNFTToToken(
31         uint fnftId,
32         IRevest.FNFTConfig memory fnftConfig
33     ) external;
34 
35     function handleMultipleDeposits(
36         uint fnftId,
37         uint newFNFTId,
38         uint amount
39     ) external;
40 
41     function splitFNFT(
42         uint fnftId,
43         uint[] memory newFNFTIds,
44         uint[] memory proportions,
45         uint quantity
46     ) external;
47 
48     function getFNFT(uint fnftId) external view returns (IRevest.FNFTConfig memory);
49     function getFNFTCurrentValue(uint fnftId) external view returns (uint);
50     function getNontransferable(uint fnftId) external view returns (bool);
51     function getSplitsRemaining(uint fnftId) external view returns (uint);
52 }
