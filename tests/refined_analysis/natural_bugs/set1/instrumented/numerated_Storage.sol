1 // SPDX-License-Identifier: MIT
2 
3 // This program is free software: you can redistribute it and/or modify
4 // it under the terms of the GNU General Public License as published by
5 // the Free Software Foundation, either version 3 of the License, or
6 // (at your option) any later version.
7 
8 // This program is distributed in the hope that it will be useful,
9 // but WITHOUT ANY WARRANTY; without even the implied warranty of
10 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
11 // GNU General Public License for more details.
12 
13 // You should have received a copy of the GNU General Public License
14 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
15 
16 pragma solidity ^0.7.3;
17 
18 import "./interfaces/IOracle.sol";
19 import "./Assimilators.sol";
20 
21 contract Storage {
22     struct Curve {
23         // Curve parameters
24         int128 alpha;
25         int128 beta;
26         int128 delta;
27         int128 epsilon;
28         int128 lambda;
29         int128[] weights;
30         // Assets and their assimilators
31         Assimilator[] assets;
32         mapping(address => Assimilator) assimilators;
33         // Oracles to determine the price
34         // Note that 0'th index should always be USDC 1e18
35         // Oracle's pricing should be denominated in Currency/USDC
36         mapping(address => IOracle) oracles;
37         // ERC20 Interface
38         uint256 totalSupply;
39         mapping(address => uint256) balances;
40         mapping(address => mapping(address => uint256)) allowances;
41     }
42 
43     struct Assimilator {
44         address addr;
45         uint8 ix;
46     }
47 
48     // Curve parameters
49     Curve public curve;
50 
51     // Ownable
52     address public owner;
53 
54     string public name;
55     string public symbol;
56     uint8 public constant decimals = 18;
57 
58     address[] public derivatives;
59     address[] public numeraires;
60     address[] public reserves;
61 
62     // Curve operational state
63     bool public frozen = false;
64     bool public emergency = false;
65     bool public whitelistingStage = true;
66     bool internal notEntered = true;
67 
68     mapping(address => uint256) public whitelistedDeposited;
69 }
