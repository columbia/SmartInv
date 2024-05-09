1 // SPDX-License-Identifier: AGPL-3.0-or-later
2 /// Autoexec.sol -- Adjust the DC IAM for all MCD collateral types
3 
4 // Copyright (C) 2020  Brian McMichael
5 
6 // This program is free software: you can redistribute it and/or modify
7 // it under the terms of the GNU General Public License as published by
8 // the Free Software Foundation, either version 3 of the License, or
9 // (at your option) any later version.
10 
11 // This program is distributed in the hope that it will be useful,
12 // but WITHOUT ANY WARRANTY; without even the implied warranty of
13 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
14 // GNU General Public License for more details.
15 
16 // You should have received a copy of the GNU General Public License
17 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
18 pragma solidity ^0.6.12;
19 
20 interface Chainlog {
21     function getAddress(bytes32) external returns (address);
22 }
23 
24 interface AutoLine {
25     function exec(bytes32) external returns (uint256);
26 }
27 
28 interface IlkReg {
29     function list() external returns (bytes32[] memory);
30 }
31 
32 contract Autoexec {
33 
34     Chainlog private constant  cl = Chainlog(0xdA0Ab1e0017DEbCd72Be8599041a2aa3bA7e740F);
35     IlkReg   private immutable ir;
36     AutoLine private immutable al;
37 
38     constructor() public {
39         ir = IlkReg(cl.getAddress("ILK_REGISTRY"));
40         al = AutoLine(cl.getAddress("MCD_IAM_AUTO_LINE"));
41     }
42 
43     function bat() public {
44         bytes32[] memory _ilks = ir.list();
45         for (uint256 i = 0; i < _ilks.length; i++) {
46             al.exec(_ilks[i]);
47         }
48     }
49 
50     function registry() external view returns (address) {
51         return address(ir);
52     }
53 
54     function autoline() external view returns (address) {
55         return address(al);
56     }
57 }