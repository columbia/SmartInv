1 // SPDX-FileCopyrightText: © 2020 Velox <code@velox.io>
2 // SPDX-License-Identifier: BSD-3-Clause
3 
4 pragma solidity >=0.8.0;
5 
6 abstract contract Context {
7     function _msgSender() internal view virtual returns (address payable) {
8         return payable(msg.sender);
9     }
10 
11     function _msgData() internal view virtual returns (bytes memory) {
12         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
13         return msg.data;
14     }
15 }
16 
17 abstract contract Ownable is Context {
18     address private _owner;
19 
20     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21 
22     /**
23      * @dev Initializes the contract setting the deployer as the initial owner.
24      */
25     constructor () {
26         address msgSender = _msgSender();
27         _owner = msgSender;
28         emit OwnershipTransferred(address(0), msgSender);
29     }
30 
31     /**
32      * @dev Returns the address of the current owner.
33      */
34     function owner() public view returns (address) {
35         return _owner;
36     }
37 
38     /**
39      * @dev Throws if called by any account other than the owner.
40      */
41     modifier onlyOwner() {
42         require(_owner == _msgSender(), "Ownable: caller is not the owner");
43         _;
44     }
45 
46     /**
47      * @dev Leaves the contract without owner. It will not be possible to call
48      * `onlyOwner` functions anymore. Can only be called by the current owner.
49      *
50      * NOTE: Renouncing ownership will leave the contract without an owner,
51      * thereby removing any functionality that is only available to the owner.
52      */
53     function renounceOwnership() public virtual onlyOwner {
54         emit OwnershipTransferred(_owner, address(0));
55         _owner = address(0);
56     }
57 
58     /**
59      * @dev Transfers ownership of the contract to a new account (`newOwner`).
60      * Can only be called by the current owner.
61      */
62     function transferOwnership(address newOwner) public virtual onlyOwner {
63         require(newOwner != address(0), "Ownable: new owner is the zero address");
64         emit OwnershipTransferred(_owner, newOwner);
65         _owner = newOwner;
66     }
67 }
68 
69 abstract contract BackingStore {
70     address public MAIN_CONTRACT;
71     address public UNISWAP_FACTORY_ADDRESS = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
72     address public UNISWAP_ROUTER_ADDRESS = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
73     address public ADMIN_ADDRESS;
74 }
75 
76 /**
77   * @title VeloxProxy (Proxy Contract)
78   *
79   * @dev Call:
80   *
81   * VeloxProxy.at(VeloxProxy.address).setContract(VeloxSwap.address)
82   * VeloxSwap.at(VeloxProxy.address).sellTokenForETH(seller, token, tokenAmount, deadline
83   * VeloxSwap.at(VeloxProxy.address).setUniswapRouter(0xbeefc0debeefbeef)
84   *
85   */
86 contract VeloxProxy is BackingStore, Ownable {
87 
88     function setAdminAddress(address _c) public onlyOwner returns (bool succeeded) {
89         require(_c != owner(), "VELOXPROXY_ADMIN_OWNER");
90         ADMIN_ADDRESS = _c;
91         return true;
92     }
93 
94     // Set main Velox contract address
95     function setMainContract(address _c) public onlyOwner returns (bool succeeded) {
96         require(_c != address(this), "VELOXPROXY_CIRCULAR_REFERENCE");
97         require(isContract(_c), "VELOXPROXY_NOT_CONTRACT");
98         MAIN_CONTRACT = _c;
99         return true;
100     }
101 
102     // ASM fallback function
103     function _fallback () internal {
104         address target = MAIN_CONTRACT;
105 
106         assembly {
107             // Copy the data sent to the memory address starting free mem position
108             let ptr := mload(0x40)
109             calldatacopy(ptr, 0, calldatasize())
110 
111             // Proxy the call to the contract address with the provided gas and data
112             let result := delegatecall(gas(), target, ptr, calldatasize(), 0, 0)
113 
114             // Copy the data returned by the proxied call to memory
115             let size := returndatasize()
116             returndatacopy(ptr, 0, size)
117 
118             // Check what the result is, return and revert accordingly
119             switch result
120             case 0 { revert(ptr, size) }
121             case 1 { return(ptr, size) }
122         }
123     }
124 
125     // ASM fallback function
126     fallback () external {
127         _fallback();
128     }
129 
130     receive () payable external {
131         _fallback();
132     }
133     
134     function isContract (address addr) private view returns (bool) {
135         uint size;
136         assembly { size := extcodesize(addr) }
137         return size > 0;
138     }
139 }