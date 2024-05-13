1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity 0.7.6;
3 
4 // ============ Internal Imports ============
5 import {IBridgeToken} from "./IBridgeToken.sol";
6 import {BridgeMessage} from "../BridgeMessage.sol";
7 
8 // ============ External Imports ============
9 import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
10 
11 interface ITokenRegistry {
12     function isLocalOrigin(address _token) external view returns (bool);
13 
14     function ensureLocalToken(uint32 _domain, bytes32 _id)
15         external
16         returns (address _local);
17 
18     function mustHaveLocalToken(uint32 _domain, bytes32 _id)
19         external
20         view
21         returns (IERC20);
22 
23     function getLocalAddress(uint32 _domain, bytes32 _id)
24         external
25         view
26         returns (address _local);
27 
28     function getTokenId(address _token) external view returns (uint32, bytes32);
29 
30     function enrollCustom(
31         uint32 _domain,
32         bytes32 _id,
33         address _custom
34     ) external;
35 
36     function oldReprToCurrentRepr(address _oldRepr)
37         external
38         view
39         returns (address _currentRepr);
40 }
