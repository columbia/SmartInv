1 pragma solidity ^0.6.12;
2 
3 // Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>
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
18 // SPDX-License-Identifier: GPL-3.0-only
19 
20 /**
21  * @title Proxy
22  * @notice Basic proxy that delegates all calls to a fixed implementing contract.
23  * The implementing contract cannot be upgraded.
24  * @author Julien Niset - <julien@argent.xyz>
25  */
26 contract Proxy {
27 
28     address implementation;
29 
30     event Received(uint indexed value, address indexed sender, bytes data);
31 
32     constructor(address _implementation) public {
33         implementation = _implementation;
34     }
35 
36     fallback() external payable {
37         // solhint-disable-next-line no-inline-assembly
38         assembly {
39             let target := sload(0)
40             calldatacopy(0, 0, calldatasize())
41             let result := delegatecall(gas(), target, 0, calldatasize(), 0, 0)
42             returndatacopy(0, 0, returndatasize())
43             switch result
44             case 0 {revert(0, returndatasize())}
45             default {return (0, returndatasize())}
46         }
47     }
48 
49     receive() external payable {
50         emit Received(msg.value, msg.sender, msg.data);
51     }
52 }