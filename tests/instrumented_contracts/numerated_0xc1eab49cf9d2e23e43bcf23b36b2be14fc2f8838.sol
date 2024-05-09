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
12 * Mokens
13 *
14 * The Mokens contract is a proxy contract that delegates all functionality
15 * to delegate contracts. This design enables new functionality and improvements
16 * to be added to the Mokens contract over time.
17 *
18 * Changes to the Mokens contract are transparent and visible. To make changes
19 * easier to monitor the ContractUpdated event is emitted any time a function is
20 * added, removed or updated. The ContractUpdated event exists in the
21 * MokenUpdates delegate contract
22 *
23 * The source code for all delegate contracts used by the Mokens contract can be
24 * found online and inspected.
25 *
26 * The Mokens contract is reflective or self inspecting. It contains functions
27 * for inspecting what delegate contracts it has and what functions they have.
28 * Specifically, the QueryMokenDelegates delegate contract contains functions for
29 * querying delegate contracts and functions.
30 *
31 *    Here are some of the other delegate contracts:
32 *
33 *  - MokenERC721: Implements the ERC721 standard for mokens.
34 *  - MokenERC721Batch: Implements batch transfers and approvals.
35 *  - MokenERC998ERC721TopDown: Implements ERC998 composable functionality.
36 *  - MokenERC998ERC20TopDown: Implements ERC998 composable functionality.
37 *  - MokenERC998ERC721BottomUp: Implements ERC998 composable functionality.
38 *  - MokenMinting: Implements moken minting functionality.
39 *  - MokenEras: Implements moken era functionality.
40 *  - QueryMokenData: Implements functions to query info about mokens.
41 /******************************************************************************/
42 //////////////////////////////////////
43 //////////////////////////////////////
44 contract Storage0 {
45     // funcId => delegate contract
46     mapping(bytes4 => address) internal delegates;
47 }
48 
49 contract Mokens is Storage0 {
50     constructor(address mokenUpdates) public {
51         //0x584fc325 == "initializeMokensContract()"
52         bytes memory calldata = abi.encodeWithSelector(0x584fc325,mokenUpdates);
53         assembly {
54             let callSuccess := delegatecall(gas, mokenUpdates, add(calldata, 0x20), mload(calldata), 0, 0)
55             let size := returndatasize
56             returndatacopy(calldata, 0, size)
57             if eq(callSuccess,0) {revert(calldata, size)}
58         }
59     }
60     function() external payable {
61         address delegate = delegates[msg.sig];
62         require(delegate != address(0), "Mokens function does not exist.");
63         assembly {
64             let ptr := mload(0x40)
65             calldatacopy(ptr, 0, calldatasize)
66             let result := delegatecall(gas, delegate, ptr, calldatasize, 0, 0)
67             let size := returndatasize
68             returndatacopy(ptr, 0, size)
69             switch result
70             case 0 {revert(ptr, size)}
71             default {return (ptr, size)}
72         }
73     }
74 }