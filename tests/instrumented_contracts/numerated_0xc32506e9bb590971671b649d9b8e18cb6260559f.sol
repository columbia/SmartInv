1 // SPDX-License-Identifier: AGPL-3.0-or-later
2 // Copyright (C) 2021 Dai Foundation
3 //
4 // This program is free software: you can redistribute it and/or modify
5 // it under the terms of the GNU Affero General Public License as published by
6 // the Free Software Foundation, either version 3 of the License, or
7 // (at your option) any later version.
8 //
9 // This program is distributed in the hope that it will be useful,
10 // but WITHOUT ANY WARRANTY; without even the implied warranty of
11 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
12 // GNU Affero General Public License for more details.
13 //
14 // You should have received a copy of the GNU Affero General Public License
15 // along with this program.  If not, see <https://www.gnu.org/licenses/>.
16 pragma solidity 0.8.13;
17 
18 /// @title Maker Keeper Network Job
19 /// @notice A job represents an independant unit of work that can be done by a keeper
20 interface IJob {
21 
22     /// @notice Executes this unit of work
23     /// @dev Should revert iff workable() returns canWork of false
24     /// @param network The name of the external keeper network
25     /// @param args Custom arguments supplied to the job, should be copied from workable response
26     function work(bytes32 network, bytes calldata args) external;
27 
28     /// @notice Ask this job if it has a unit of work available
29     /// @dev This should never revert, only return false if nothing is available
30     /// @dev This should normally be a view, but sometimes that's not possible
31     /// @param network The name of the external keeper network
32     /// @return canWork Returns true if a unit of work is available
33     /// @return args The custom arguments to be provided to work() or an error string if canWork is false
34     function workable(bytes32 network) external returns (bool canWork, bytes memory args);
35 
36 }
37 
38 interface SequencerLike {
39     function isMaster(bytes32 network) external view returns (bool);
40 }
41 
42 interface VatLike {
43     function sin(address) external view returns (uint256);
44 }
45 
46 interface VowLike {
47     function Sin() external view returns (uint256);
48     function Ash() external view returns (uint256);
49     function heal(uint256) external;
50     function flap() external;
51 }
52 
53 /// @title Call flap when possible
54 contract FlapJob is IJob {
55 
56     SequencerLike public immutable sequencer;
57     VatLike       public immutable vat;
58     VowLike       public immutable vow;
59     uint256       public immutable maxGasPrice;
60 
61     // --- Errors ---
62     error NotMaster(bytes32 network);
63     error GasPriceTooHigh(uint256 gasPrice, uint256 maxGasPrice);
64 
65     // --- Events ---
66     event Work(bytes32 indexed network);
67 
68     constructor(address _sequencer, address _vat, address _vow, uint256 _maxGasPrice) {
69         sequencer   = SequencerLike(_sequencer);
70         vat         = VatLike(_vat);
71         vow         = VowLike(_vow);
72         maxGasPrice = _maxGasPrice;
73     }
74 
75     function work(bytes32 network, bytes calldata args) public {
76         if (!sequencer.isMaster(network)) revert NotMaster(network);
77         if (tx.gasprice > maxGasPrice)    revert GasPriceTooHigh(tx.gasprice, maxGasPrice);
78 
79         uint256 toHeal = abi.decode(args, (uint256));
80         if (toHeal > 0) vow.heal(toHeal);
81         vow.flap();
82 
83         emit Work(network);
84     }
85 
86     function workable(bytes32 network) external override returns (bool, bytes memory) {
87         if (!sequencer.isMaster(network)) return (false, bytes("Network is not master"));
88 
89         bytes memory args;
90         uint256 unbackedTotal = vat.sin(address(vow));
91         uint256 unbackedVow   = vow.Sin() + vow.Ash();
92 
93         // Check if need to cancel out free unbacked debt with system surplus
94         uint256 toHeal = unbackedTotal > unbackedVow ? unbackedTotal - unbackedVow : 0;
95         args = abi.encode(toHeal);
96 
97         try this.work(network, args) {
98             // Flap succeeds
99             return (true, args);
100         } catch {
101             // Can not flap -- carry on
102         }
103         return (false, bytes("Flap not possible"));
104     }
105 }