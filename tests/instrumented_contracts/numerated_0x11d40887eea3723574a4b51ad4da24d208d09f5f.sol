1 pragma solidity 0.4.24;
2 pragma experimental "v0.5.0";
3 /******************************************************************************\
4 *..................................Mokens......................................*
5 *.....................General purpose cryptocollectibles.......................*
6 *..............................................................................*
7 /******************************************************************************/
8 
9 /******************************************************************************\
10 * Author: Nick Mudge, nick@mokens.io
11 * Copyright (c) 2018
12 *
13 * The Mokens contract is a proxy contract that delegates all functionality
14 * to delegate contracts. This design enables new functionality and improvements
15 * to be added to the Mokens contract over time.
16 *
17 * Changes to the Mokens contract are transparent and visible. To make changes
18 * easier to monitor the ContractUpdated event is emitted any time a function is
19 * added, removed or updated. The ContractUpdated event exists in the
20 * MokenUpdates delegate contract
21 *
22 * The source code for all delegate contracts used by the Mokens contract can be
23 * found online and inspected.
24 *
25 * The Mokens contract is reflective or self inspecting. It contains functions
26 * for inspecting what delegate contracts it has and what functions they have.
27 * Specifically, the QueryMokenDelegates delegate contract contains functions for
28 * querying delegate contracts and functions.
29 *
30 *    Here are some of the other delegate contracts:
31 *
32 *  - MokenERC721: Implements the ERC721 standard for mokens.
33 *  - MokenERC721Batch: Implements batch transfers and approvals.
34 *  - MokenERC998ERC721TopDown: Implements ERC998 composable functionality.
35 *  - MokenERC998ERC20TopDown: Implements ERC998 composable functionality.
36 *  - MokenERC998ERC721BottomUp: Implements ERC998 composable functionality.
37 *  - MokenMinting: Implements moken minting functionality.
38 *  - MokenEras: Implements moken era functionality.
39 *  - QueryMokenData: Implements functions to query info about mokens.
40 /******************************************************************************/
41 ///////////////////////////////////////////////////////////////////////////////////
42 //Storage contracts
43 ///////////////////////////////////////////////////////////////////////////////////
44 //Mokens
45 ///////////////////////////////////////////////////////////////////////////////////
46 contract Storage0 {
47     // funcId => delegate contract
48     mapping(bytes4 => address) internal delegates;
49 }
50 
51 contract Mokens is Storage0 {
52     constructor(address mokenUpdates) public {
53         //0x584fc325 == "initializeMokensContract()"
54         bytes memory calldata = abi.encodeWithSelector(0x584fc325,mokenUpdates);
55         assembly {
56             let callSuccess := delegatecall(gas, mokenUpdates, add(calldata, 0x20), mload(calldata), 0, 0)
57             let size := returndatasize
58             returndatacopy(calldata, 0, size)
59             if eq(callSuccess,0) {revert(calldata, size)}
60         }
61     }
62     function() external payable {
63         address delegate = delegates[msg.sig];
64         require(delegate != address(0), "Mokens function does not exist.");
65         assembly {
66             let ptr := mload(0x40)
67             calldatacopy(ptr, 0, calldatasize)
68             let result := delegatecall(gas, delegate, ptr, calldatasize, 0, 0)
69             let size := returndatasize
70             returndatacopy(ptr, 0, size)
71             switch result
72             case 0 {revert(ptr, size)}
73             default {return (ptr, size)}
74         }
75     }
76 }