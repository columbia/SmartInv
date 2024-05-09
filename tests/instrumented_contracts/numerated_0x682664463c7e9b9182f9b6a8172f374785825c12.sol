1 /*
2  * Copyright(C) 2018 by @phalexo (gitter) and Big Deeper Advisors, Inc. a Wyoming corporation.
3  * All rights reserved.
4  *
5  * A non-exclusive, non-transferable, perpetual license to use is hereby granted to Expercoin, Inc.
6  * For questions about the license contact: bigdeeperadvisors@gmail.com
7  *
8  * Expercoin, Inc. can be reached via support@expercoin.com and expercoin.com website.
9  *
10  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
11  * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE,
12  * TITLE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE
13  * SOFTWARE BE LIABLE FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
14  * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
15  */
16 
17 pragma solidity ^0.4.23;
18 
19 contract References {
20 
21   mapping (bytes32 => address) internal references;
22 
23 }
24 
25 contract AuthorizedList {
26 
27     bytes32 constant PRESIDENT = keccak256("Republics President!");
28     bytes32 constant STAFF_MEMBER = keccak256("Staff Member.");
29     bytes32 constant AIR_DROP = keccak256("Airdrop Permission.");
30     bytes32 constant INTERNAL = keccak256("Internal Authorization.");
31     mapping (address => mapping(bytes32 => bool)) authorized;
32 
33 }
34 
35 contract Authorized is AuthorizedList {
36 
37     /// @dev Set the initial permission for the contract creator
38     /// The contract creator can then add permissions for others
39     function Authorized() public {
40 
41        authorized[msg.sender][PRESIDENT] = true;
42 
43     }
44 
45 
46     /// @dev Ensure that _address is authorized, modifier
47     /// @param _address Address to be checked, usually msg.sender
48     /// @param _authorization key for specific authorization
49     modifier ifAuthorized(address _address, bytes32 _authorization) {
50 
51        require(authorized[_address][_authorization] || authorized[_address][PRESIDENT], "Not authorized to access!");
52        _;
53 
54     }
55 
56     /// @dev Check _address' authorization, boolean function
57     /// @param _address Boolean value, true if authorized, false otherwise
58     /// @param _authorization key for specific authorization
59     function isAuthorized(address _address, bytes32 _authorization) public view returns (bool) {
60 
61        return authorized[_address][_authorization];
62 
63     }
64 
65     /// @dev Toggle boolean flag to allow or prevent access
66     /// @param _address Boolean value, true if authorized, false otherwise
67     /// @param _authorization key for specific authorization
68     function toggleAuthorization(address _address, bytes32 _authorization) public ifAuthorized(msg.sender, PRESIDENT) {
69 
70        /// Prevent inadvertent self locking out, cannot change own authority
71        require(_address != msg.sender, "Cannot change own permissions.");
72 
73        /// No need for lower level authorization to linger
74        if (_authorization == PRESIDENT && !authorized[_address][PRESIDENT])
75            authorized[_address][STAFF_MEMBER] = false;
76 
77        authorized[_address][_authorization] = !authorized[_address][_authorization];
78 
79     }
80 
81 }
82 
83 contract main is References, AuthorizedList, Authorized {
84 
85   event LogicUpgrade(address indexed _oldbiz, address indexed _newbiz);
86   event StorageUpgrade(address indexed _oldvars, address indexed _newvars);
87 
88   function main(address _logic, address _storage) public Authorized() {
89 
90      require(_logic != address(0), "main: Unexpectedly logic address is 0x0.");
91      require(_storage != address(0), "main: Unexpectedly storage address is 0x0.");
92      references[bytes32(0)] = _logic;
93      references[bytes32(1)] = _storage;
94 
95   }
96 
97   /// @dev Set an address at _key location
98   /// @param _address Address to set
99   /// @param _key bytes32 key location
100   function setReference(address _address, bytes32 _key) external ifAuthorized(msg.sender, PRESIDENT) {
101 
102      require(_address != address(0), "setReference: Unexpectedly _address is 0x0");
103 
104      if (_key == bytes32(0)) emit LogicUpgrade(references[bytes32(0)], _address);
105      else emit StorageUpgrade(references[_key], _address);
106 
107      if (references[_key] != address(0))
108           delete references[_key];
109 
110      references[_key] = _address;
111 
112   }
113 
114   /// @dev Retrieve contract address at _key location, mostly for convenience
115   /// @return Contract address or 0x0 if it does not exist
116   function getReference(bytes32 _key) external view ifAuthorized(msg.sender, PRESIDENT) returns(address) {
117 
118       return references[_key];
119 
120   }
121 
122   function() external payable {
123 
124       address _target = references[bytes32(0)];
125       assembly {
126           let _calldata := mload(0x40)
127           mstore(0x40, add(_calldata, calldatasize))
128           calldatacopy(_calldata, 0x0, calldatasize)
129           switch delegatecall(gas, _target, _calldata, calldatasize, 0, 0)
130             case 0 { revert(0, 0) }
131             default {
132               let _returndata := mload(0x40)
133               returndatacopy(_returndata, 0, returndatasize)
134               mstore(0x40, add(_returndata, returndatasize))
135               return(_returndata, returndatasize)
136             }
137        }
138    }
139 
140 }