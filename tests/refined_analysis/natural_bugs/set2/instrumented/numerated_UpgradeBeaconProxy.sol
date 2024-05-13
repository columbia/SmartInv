1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.6.11;
3 
4 // ============ External Imports ============
5 import {Address} from "@openzeppelin/contracts/utils/Address.sol";
6 
7 /**
8  * @title UpgradeBeaconProxy
9  * @notice
10  * Proxy contract which delegates all logic, including initialization,
11  * to an implementation contract.
12  * The implementation contract is stored within an Upgrade Beacon contract;
13  * the implementation contract can be changed by performing an upgrade on the Upgrade Beacon contract.
14  * The Upgrade Beacon contract for this Proxy is immutably specified at deployment.
15  * @dev This implementation combines the gas savings of keeping the UpgradeBeacon address outside of contract storage
16  * found in 0age's implementation:
17  * https://github.com/dharma-eng/dharma-smart-wallet/blob/master/contracts/proxies/smart-wallet/UpgradeBeaconProxyV1.sol
18  * With the added safety checks that the UpgradeBeacon and implementation are contracts at time of deployment
19  * found in OpenZeppelin's implementation:
20  * https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/proxy/beacon/BeaconProxy.sol
21  */
22 contract UpgradeBeaconProxy {
23     // ============ Immutables ============
24 
25     // Upgrade Beacon address is immutable (therefore not kept in contract storage)
26     address private immutable upgradeBeacon;
27 
28     // ============ Constructor ============
29 
30     /**
31      * @notice Validate that the Upgrade Beacon is a contract, then set its
32      * address immutably within this contract.
33      * Validate that the implementation is also a contract,
34      * Then call the initialization function defined at the implementation.
35      * The deployment will revert and pass along the
36      * revert reason if the initialization function reverts.
37      * @param _upgradeBeacon Address of the Upgrade Beacon to be stored immutably in the contract
38      * @param _initializationCalldata Calldata supplied when calling the initialization function
39      */
40     constructor(address _upgradeBeacon, bytes memory _initializationCalldata)
41         payable
42     {
43         // Validate the Upgrade Beacon is a contract
44         require(Address.isContract(_upgradeBeacon), "beacon !contract");
45         // set the Upgrade Beacon
46         upgradeBeacon = _upgradeBeacon;
47         // Validate the implementation is a contract
48         address _implementation = _getImplementation(_upgradeBeacon);
49         require(
50             Address.isContract(_implementation),
51             "beacon implementation !contract"
52         );
53         // Call the initialization function on the implementation
54         if (_initializationCalldata.length > 0) {
55             _initialize(_implementation, _initializationCalldata);
56         }
57     }
58 
59     // ============ External Functions ============
60 
61     /**
62      * @notice Forwards all calls with data to _fallback()
63      * No public functions are declared on the contract, so all calls hit fallback
64      */
65     fallback() external payable {
66         _fallback();
67     }
68 
69     /**
70      * @notice Forwards all calls with no data to _fallback()
71      */
72     receive() external payable {
73         _fallback();
74     }
75 
76     // ============ Private Functions ============
77 
78     /**
79      * @notice Call the initialization function on the implementation
80      * Used at deployment to initialize the proxy
81      * based on the logic for initialization defined at the implementation
82      * @param _implementation - Contract to which the initalization is delegated
83      * @param _initializationCalldata - Calldata supplied when calling the initialization function
84      */
85     function _initialize(
86         address _implementation,
87         bytes memory _initializationCalldata
88     ) private {
89         // Delegatecall into the implementation, supplying initialization calldata.
90         (bool _ok, ) = _implementation.delegatecall(_initializationCalldata);
91         // Revert and include revert data if delegatecall to implementation reverts.
92         if (!_ok) {
93             assembly {
94                 returndatacopy(0, 0, returndatasize())
95                 revert(0, returndatasize())
96             }
97         }
98     }
99 
100     /**
101      * @notice Delegates function calls to the implementation contract returned by the Upgrade Beacon
102      */
103     function _fallback() private {
104         _delegate(_getImplementation());
105     }
106 
107     /**
108      * @notice Delegate function execution to the implementation contract
109      * @dev This is a low level function that doesn't return to its internal
110      * call site. It will return whatever is returned by the implementation to the
111      * external caller, reverting and returning the revert data if implementation
112      * reverts.
113      * @param _implementation - Address to which the function execution is delegated
114      */
115     function _delegate(address _implementation) private {
116         assembly {
117             // Copy msg.data. We take full control of memory in this inline assembly
118             // block because it will not return to Solidity code. We overwrite the
119             // Solidity scratch pad at memory position 0.
120             calldatacopy(0, 0, calldatasize())
121             // Delegatecall to the implementation, supplying calldata and gas.
122             // Out and outsize are set to zero - instead, use the return buffer.
123             let result := delegatecall(
124                 gas(),
125                 _implementation,
126                 0,
127                 calldatasize(),
128                 0,
129                 0
130             )
131             // Copy the returned data from the return buffer.
132             returndatacopy(0, 0, returndatasize())
133             switch result
134             // Delegatecall returns 0 on error.
135             case 0 {
136                 revert(0, returndatasize())
137             }
138             default {
139                 return(0, returndatasize())
140             }
141         }
142     }
143 
144     /**
145      * @notice Call the Upgrade Beacon to get the current implementation contract address
146      * @return _implementation Address of the current implementation.
147      */
148     function _getImplementation()
149         private
150         view
151         returns (address _implementation)
152     {
153         _implementation = _getImplementation(upgradeBeacon);
154     }
155 
156     /**
157      * @notice Call the Upgrade Beacon to get the current implementation contract address
158      * @dev _upgradeBeacon is passed as a parameter so that
159      * we can also use this function in the constructor,
160      * where we can't access immutable variables.
161      * @param _upgradeBeacon Address of the UpgradeBeacon storing the current implementation
162      * @return _implementation Address of the current implementation.
163      */
164     function _getImplementation(address _upgradeBeacon)
165         private
166         view
167         returns (address _implementation)
168     {
169         // Get the current implementation address from the upgrade beacon.
170         (bool _ok, bytes memory _returnData) = _upgradeBeacon.staticcall("");
171         // Revert and pass along revert message if call to upgrade beacon reverts.
172         require(_ok, string(_returnData));
173         // Set the implementation to the address returned from the upgrade beacon.
174         _implementation = abi.decode(_returnData, (address));
175     }
176 }
