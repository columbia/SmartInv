1 // SPDX-License-Identifier: GPL-3.0-or-later
2 // This program is free software: you can redistribute it and/or modify
3 // it under the terms of the GNU General Public License as published by
4 // the Free Software Foundation, either version 3 of the License, or
5 // (at your option) any later version.
6 
7 // This program is distributed in the hope that it will be useful,
8 // but WITHOUT ANY WARRANTY; without even the implied warranty of
9 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
10 // GNU General Public License for more details.
11 
12 // You should have received a copy of the GNU General Public License
13 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
14 
15 pragma solidity ^0.8.0;
16 
17 // interface with required methods from Balancer V2 IBasePool
18 // https://github.com/balancer-labs/balancer-v2-monorepo/blob/389b52f1fc9e468de854810ce9dc3251d2d5b212/pkg/asset-manager-utils/contracts/IAssetManager.sol
19 
20 interface IAssetManager {
21     struct PoolConfig {
22         uint64 targetPercentage;
23         uint64 criticalPercentage;
24         uint64 feePercentage;
25     }
26 
27     function setPoolConfig(bytes32 poolId, PoolConfig calldata config) external;
28 }
