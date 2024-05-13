1 // SPDX-License-Identifier: MIT
2 
3 // This program is free software: you can redistribute it and/or modify
4 // it under the terms of the GNU General Public License as published by
5 // the Free Software Foundation, either version 3 of the License, or
6 // (at your option) any later version.
7 
8 // This program is disstributed in the hope that it will be useful,
9 // but WITHOUT ANY WARRANTY; without even the implied warranty of
10 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
11 // GNU General Public License for more details.
12 
13 // You should have received a copy of the GNU General Public License
14 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
15 
16 pragma solidity ^0.7.3;
17 
18 // Finds new Curves! logs their addresses and provides `isCurve(address) -> (bool)`
19 
20 import "./Curve.sol";
21 
22 import "./interfaces/IFreeFromUpTo.sol";
23 
24 import "@openzeppelin/contracts/access/Ownable.sol";
25 
26 contract CurveFactory is Ownable {
27     event NewCurve(address indexed caller, bytes32 indexed id, address indexed curve);
28 
29     mapping(bytes32 => address) public curves;
30 
31     function getCurve(address _baseCurrency, address _quoteCurrency) external view returns (address) {
32         bytes32 curveId = keccak256(abi.encode(_baseCurrency, _quoteCurrency));
33         return (curves[curveId]);
34     }
35 
36     function newCurve(
37         string memory _name,
38         string memory _symbol,
39         address _baseCurrency,
40         address _quoteCurrency,
41         uint256 _baseWeight,
42         uint256 _quoteWeight,
43         address _baseAssimilator,
44         address _quoteAssimilator
45     ) public onlyOwner returns (Curve) {
46         bytes32 curveId = keccak256(abi.encode(_baseCurrency, _quoteCurrency));
47         if (curves[curveId] != address(0)) revert("CurveFactory/currency-pair-already-exists");
48 
49         address[] memory _assets = new address[](10);
50         uint256[] memory _assetWeights = new uint256[](2);
51 
52         // Base Currency
53         _assets[0] = _baseCurrency;
54         _assets[1] = _baseAssimilator;
55         _assets[2] = _baseCurrency;
56         _assets[3] = _baseAssimilator;
57         _assets[4] = _baseCurrency;
58 
59         // Quote Currency (typically USDC)
60         _assets[5] = _quoteCurrency;
61         _assets[6] = _quoteAssimilator;
62         _assets[7] = _quoteCurrency;
63         _assets[8] = _quoteAssimilator;
64         _assets[9] = _quoteCurrency;
65 
66         // Weights
67         _assetWeights[0] = _baseWeight;
68         _assetWeights[1] = _quoteWeight;
69 
70         // New curve
71         Curve curve = new Curve(_name, _symbol, _assets, _assetWeights);
72         curve.transferOwnership(msg.sender);
73         curves[curveId] = address(curve);
74 
75         emit NewCurve(msg.sender, curveId, address(curve));
76 
77         return curve;
78     }
79 }
