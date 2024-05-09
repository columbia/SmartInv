1 pragma solidity 0.4.24;
2 
3 // File: contracts/ds-auth/auth.sol
4 
5 // This program is free software: you can redistribute it and/or modify
6 // it under the terms of the GNU General Public License as published by
7 // the Free Software Foundation, either version 3 of the License, or
8 // (at your option) any later version.
9 
10 // This program is distributed in the hope that it will be useful,
11 // but WITHOUT ANY WARRANTY; without even the implied warranty of
12 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
13 // GNU General Public License for more details.
14 
15 // You should have received a copy of the GNU General Public License
16 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
17 
18 pragma solidity 0.4.24;
19 
20 contract DSAuthority {
21     function canCall(
22         address src, address dst, bytes4 sig
23     ) public view returns (bool);
24 }
25 
26 contract DSAuthEvents {
27     event LogSetAuthority (address indexed authority);
28     event LogSetOwner     (address indexed owner);
29 }
30 
31 contract DSAuth is DSAuthEvents {
32     DSAuthority  public  authority;
33     address      public  owner;
34 
35     constructor() public {
36         owner = msg.sender;
37         emit LogSetOwner(msg.sender);
38     }
39 
40     function setOwner(address owner_)
41         public
42         auth
43     {
44         owner = owner_;
45         emit LogSetOwner(owner);
46     }
47 
48     function setAuthority(DSAuthority authority_)
49         public
50         auth
51     {
52         authority = authority_;
53         emit LogSetAuthority(authority);
54     }
55 
56     modifier auth {
57         require(isAuthorized(msg.sender, msg.sig));
58         _;
59     }
60 
61     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
62         if (src == address(this)) {
63             return true;
64         } else if (src == owner) {
65             return true;
66         } else if (authority == DSAuthority(0)) {
67             return false;
68         } else {
69             return authority.canCall(src, this, sig);
70         }
71     }
72 }
73 
74 // File: contracts/AssetPriceOracle.sol
75 
76 contract AssetPriceOracle is DSAuth {
77     // Maximum value expressible with uint128 is 340282366920938463463374607431768211456.
78     // Using 18 decimals for price records (standard Ether precision), 
79     // the possible values are between 0 and 340282366920938463463.374607431768211456.
80 
81     struct AssetPriceRecord {
82         uint128 price;
83         bool isRecord;
84     }
85 
86     mapping(uint128 => mapping(uint128 => AssetPriceRecord)) public assetPriceRecords;
87 
88     event AssetPriceRecorded(
89         uint128 indexed assetId,
90         uint128 indexed blockNumber,
91         uint128 indexed price
92     );
93 
94     constructor() public {
95     }
96     
97     function recordAssetPrice(uint128 assetId, uint128 blockNumber, uint128 price) public auth {
98         assetPriceRecords[assetId][blockNumber].price = price;
99         assetPriceRecords[assetId][blockNumber].isRecord = true;
100         emit AssetPriceRecorded(assetId, blockNumber, price);
101     }
102 
103     function getAssetPrice(uint128 assetId, uint128 blockNumber) public view returns (uint128 price) {
104         AssetPriceRecord storage priceRecord = assetPriceRecords[assetId][blockNumber];
105         require(priceRecord.isRecord);
106         return priceRecord.price;
107     }
108 
109     function () public {
110         // dont receive ether via fallback method (by not having 'payable' modifier on this function).
111     }
112 }