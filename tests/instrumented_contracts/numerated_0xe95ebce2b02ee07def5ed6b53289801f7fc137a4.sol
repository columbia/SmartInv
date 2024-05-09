1 /**
2  * Copyright 2017-2021, bZeroX, LLC. All Rights Reserved.
3  * Licensed under the Apache License, Version 2.0.
4  */
5 
6 pragma solidity 0.5.17;
7 
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with GSN meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 contract Context {
20     // Empty internal constructor, to prevent people from mistakenly deploying
21     // an instance of this contract, which should be used via inheritance.
22     constructor () internal { }
23     // solhint-disable-previous-line no-empty-blocks
24 
25     function _msgSender() internal view returns (address payable) {
26         return msg.sender;
27     }
28 
29     function _msgData() internal view returns (bytes memory) {
30         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
31         return msg.data;
32     }
33 }
34 
35 /**
36  * @dev Contract module which provides a basic access control mechanism, where
37  * there is an account (an owner) that can be granted exclusive access to
38  * specific functions.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor () internal {
53         address msgSender = _msgSender();
54         _owner = msgSender;
55         emit OwnershipTransferred(address(0), msgSender);
56     }
57 
58     /**
59      * @dev Returns the address of the current owner.
60      */
61     function owner() public view returns (address) {
62         return _owner;
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         require(isOwner(), "unauthorized");
70         _;
71     }
72 
73     /**
74      * @dev Returns true if the caller is the current owner.
75      */
76     function isOwner() public view returns (bool) {
77         return _msgSender() == _owner;
78     }
79 
80     /**
81      * @dev Transfers ownership of the contract to a new account (`newOwner`).
82      * Can only be called by the current owner.
83      */
84     function transferOwnership(address newOwner) public onlyOwner {
85         _transferOwnership(newOwner);
86     }
87 
88     /**
89      * @dev Transfers ownership of the contract to a new account (`newOwner`).
90      */
91     function _transferOwnership(address newOwner) internal {
92         require(newOwner != address(0), "Ownable: new owner is the zero address");
93         emit OwnershipTransferred(_owner, newOwner);
94         _owner = newOwner;
95     }
96 }
97 
98 /**
99  * @dev Collection of functions related to the address type
100  */
101 library Address {
102     /**
103      * @dev Returns true if `account` is a contract.
104      *
105      * [IMPORTANT]
106      * ====
107      * It is unsafe to assume that an address for which this function returns
108      * false is an externally-owned account (EOA) and not a contract.
109      *
110      * Among others, `isContract` will return false for the following 
111      * types of addresses:
112      *
113      *  - an externally-owned account
114      *  - a contract in construction
115      *  - an address where a contract will be created
116      *  - an address where a contract lived, but was destroyed
117      * ====
118      */
119     function isContract(address account) internal view returns (bool) {
120         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
121         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
122         // for accounts without code, i.e. `keccak256('')`
123         bytes32 codehash;
124         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
125         // solhint-disable-next-line no-inline-assembly
126         assembly { codehash := extcodehash(account) }
127         return (codehash != accountHash && codehash != 0x0);
128     }
129 
130     /**
131      * @dev Converts an `address` into `address payable`. Note that this is
132      * simply a type cast: the actual underlying value is not changed.
133      *
134      * _Available since v2.4.0._
135      */
136     function toPayable(address account) internal pure returns (address payable) {
137         return address(uint160(account));
138     }
139 
140     /**
141      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
142      * `recipient`, forwarding all available gas and reverting on errors.
143      *
144      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
145      * of certain opcodes, possibly making contracts go over the 2300 gas limit
146      * imposed by `transfer`, making them unable to receive funds via
147      * `transfer`. {sendValue} removes this limitation.
148      *
149      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
150      *
151      * IMPORTANT: because control is transferred to `recipient`, care must be
152      * taken to not create reentrancy vulnerabilities. Consider using
153      * {ReentrancyGuard} or the
154      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
155      *
156      * _Available since v2.4.0._
157      */
158     function sendValue(address recipient, uint256 amount) internal {
159         require(address(this).balance >= amount, "Address: insufficient balance");
160 
161         // solhint-disable-next-line avoid-call-value
162         (bool success, ) = recipient.call.value(amount)("");
163         require(success, "Address: unable to send value, recipient may have reverted");
164     }
165 }
166 
167 contract StakingUpgradeable is Ownable {
168     address public implementation;
169 }
170 
171 contract StakingProxy is StakingUpgradeable {
172 
173     function()
174         external
175         payable
176     {
177         if (gasleft() <= 2300) {
178             return;
179         }
180 
181         address impl = implementation;
182 
183         bytes memory data = msg.data;
184         assembly {
185             let result := delegatecall(gas, impl, add(data, 0x20), mload(data), 0, 0)
186             let size := returndatasize
187             let ptr := mload(0x40)
188             returndatacopy(ptr, 0, size)
189             switch result
190             case 0 { revert(ptr, size) }
191             default { return(ptr, size) }
192         }
193     }
194 
195     function replaceImplementation(
196         address impl)
197         public
198         onlyOwner
199     {
200         require(Address.isContract(impl), "not a contract");
201         implementation = impl;
202     }
203 }