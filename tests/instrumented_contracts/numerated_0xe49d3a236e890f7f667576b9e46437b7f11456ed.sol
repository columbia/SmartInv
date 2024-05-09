1 pragma solidity ^0.4.24;
2 
3 // File: contracts/utility/interfaces/IOwned.sol
4 
5 /*
6     Owned contract interface
7 */
8 contract IOwned {
9     // this function isn't abstract since the compiler emits automatically generated getter functions as external
10     function owner() public view returns (address) {}
11 
12     function transferOwnership(address _newOwner) public;
13     function acceptOwnership() public;
14 }
15 
16 // File: contracts/utility/Owned.sol
17 
18 /*
19     Provides support and utilities for contract ownership
20 */
21 contract Owned is IOwned {
22     address public owner;
23     address public newOwner;
24 
25     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
26 
27     /**
28         @dev constructor
29     */
30     constructor() public {
31         owner = msg.sender;
32     }
33 
34     // allows execution by the owner only
35     modifier ownerOnly {
36         require(msg.sender == owner);
37         _;
38     }
39 
40     /**
41         @dev allows transferring the contract ownership
42         the new owner still needs to accept the transfer
43         can only be called by the contract owner
44 
45         @param _newOwner    new contract owner
46     */
47     function transferOwnership(address _newOwner) public ownerOnly {
48         require(_newOwner != owner);
49         newOwner = _newOwner;
50     }
51 
52     /**
53         @dev used by a new owner to accept an ownership transfer
54     */
55     function acceptOwnership() public {
56         require(msg.sender == newOwner);
57         emit OwnerUpdate(owner, newOwner);
58         owner = newOwner;
59         newOwner = address(0);
60     }
61 }
62 
63 // File: contracts/utility/interfaces/IAddressList.sol
64 
65 /*
66     Address list interface
67 */
68 contract IAddressList {
69     mapping (address => bool) public listedAddresses;
70 }
71 
72 // File: contracts/utility/NonStandardTokenRegistry.sol
73 
74 /*
75     Non standard token registry
76 
77     manages tokens who don't return true/false on transfer/transferFrom/approve but revert on failure instead 
78 */
79 contract NonStandardTokenRegistry is IAddressList, Owned {
80 
81     mapping (address => bool) public listedAddresses;
82 
83     /**
84         @dev constructor
85     */
86     constructor() public {
87 
88     }
89 
90     function setAddress(address token, bool register) public ownerOnly {
91         listedAddresses[token] = register;
92     }
93 }