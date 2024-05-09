1 /*
2 
3     Copyright 2019 The Hydro Protocol Foundation
4 
5     Licensed under the Apache License, Version 2.0 (the "License");
6     you may not use this file except in compliance with the License.
7     You may obtain a copy of the License at
8 
9         http://www.apache.org/licenses/LICENSE-2.0
10 
11     Unless required by applicable law or agreed to in writing, software
12     distributed under the License is distributed on an "AS IS" BASIS,
13     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
14     See the License for the specific language governing permissions and
15     limitations under the License.
16 
17 */
18 
19 pragma solidity 0.5.8;
20 
21 interface IMakerDaoOracle{
22     function peek()
23         external
24         view
25         returns (bytes32, bool);
26 }
27 
28 contract Ownable {
29     address private _owner;
30 
31     event OwnershipTransferred(
32         address indexed previousOwner,
33         address indexed newOwner
34     );
35 
36     /** @dev The Ownable constructor sets the original `owner` of the contract to the sender account. */
37     constructor()
38         internal
39     {
40         _owner = msg.sender;
41         emit OwnershipTransferred(address(0), _owner);
42     }
43 
44     /** @return the address of the owner. */
45     function owner()
46         public
47         view
48         returns(address)
49     {
50         return _owner;
51     }
52 
53     /** @dev Throws if called by any account other than the owner. */
54     modifier onlyOwner() {
55         require(isOwner(), "NOT_OWNER");
56         _;
57     }
58 
59     /** @return true if `msg.sender` is the owner of the contract. */
60     function isOwner()
61         public
62         view
63         returns(bool)
64     {
65         return msg.sender == _owner;
66     }
67 
68     /** @dev Allows the current owner to relinquish control of the contract.
69      * @notice Renouncing to ownership will leave the contract without an owner.
70      * It will not be possible to call the functions with the `onlyOwner`
71      * modifier anymore.
72      */
73     function renounceOwnership()
74         public
75         onlyOwner
76     {
77         emit OwnershipTransferred(_owner, address(0));
78         _owner = address(0);
79     }
80 
81     /** @dev Allows the current owner to transfer control of the contract to a newOwner.
82      * @param newOwner The address to transfer ownership to.
83      */
84     function transferOwnership(
85         address newOwner
86     )
87         public
88         onlyOwner
89     {
90         require(newOwner != address(0), "INVALID_OWNER");
91         emit OwnershipTransferred(_owner, newOwner);
92         _owner = newOwner;
93     }
94 }
95 
96 contract EthPriceOracle is Ownable {
97 
98     uint256 public sparePrice;
99     uint256 public sparePriceBlockNumber;
100 
101     IMakerDaoOracle public constant makerDaoOracle = IMakerDaoOracle(0x729D19f657BD0614b4985Cf1D82531c67569197B);
102 
103     event PriceFeed(
104         uint256 price,
105         uint256 blockNumber
106     );
107 
108     function getPrice(
109         address _asset
110     )
111         external
112         view
113         returns (uint256)
114     {
115         require(_asset == 0x000000000000000000000000000000000000000E, "ASSET_NOT_MATCH");
116         (bytes32 value, bool has) = makerDaoOracle.peek();
117         if (has) {
118             return uint256(value);
119         } else {
120             require(block.number - sparePriceBlockNumber <= 500, "ORACLE_OFFLINE");
121             return sparePrice;
122         }
123     }
124 
125     function feed(
126         uint256 newSparePrice,
127         uint256 blockNumber
128     )
129         external
130         onlyOwner
131     {
132         require(newSparePrice > 0, "PRICE_MUST_GREATER_THAN_0");
133         require(blockNumber <= block.number && blockNumber >= sparePriceBlockNumber, "BLOCKNUMBER_WRONG");
134         sparePrice = newSparePrice;
135         sparePriceBlockNumber = blockNumber;
136 
137         emit PriceFeed(newSparePrice, blockNumber);
138     }
139 
140 }