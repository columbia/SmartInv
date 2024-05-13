1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 // This contract has been taken from: https://github.com/nomad-xyz/ExcessivelySafeCall
3 pragma solidity 0.8.17;
4 
5 import { InvalidCallData } from "../Errors/GenericErrors.sol";
6 
7 // solhint-disable no-inline-assembly
8 library ExcessivelySafeCall {
9     uint256 private constant LOW_28_MASK =
10         0x00000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
11 
12     /// @notice Use when you _really_ really _really_ don't trust the called
13     /// contract. This prevents the called contract from causing reversion of
14     /// the caller in as many ways as we can.
15     /// @dev The main difference between this and a solidity low-level call is
16     /// that we limit the number of bytes that the callee can cause to be
17     /// copied to caller memory. This prevents stupid things like malicious
18     /// contracts returning 10,000,000 bytes causing a local OOG when copying
19     /// to memory.
20     /// @param _target The address to call
21     /// @param _gas The amount of gas to forward to the remote contract
22     /// @param _value The value in wei to send to the remote contract
23     /// @param _maxCopy The maximum number of bytes of returndata to copy
24     /// to memory.
25     /// @param _calldata The data to send to the remote contract
26     /// @return success and returndata, as `.call()`. Returndata is capped to
27     /// `_maxCopy` bytes.
28     function excessivelySafeCall(
29         address _target,
30         uint256 _gas,
31         uint256 _value,
32         uint16 _maxCopy,
33         bytes memory _calldata
34     ) internal returns (bool, bytes memory) {
35         // set up for assembly call
36         uint256 _toCopy;
37         bool _success;
38         bytes memory _returnData = new bytes(_maxCopy);
39         // dispatch message to recipient
40         // by assembly calling "handle" function
41         // we call via assembly to avoid memcopying a very large returndata
42         // returned by a malicious contract
43         assembly {
44             _success := call(
45                 _gas, // gas
46                 _target, // recipient
47                 _value, // ether value
48                 add(_calldata, 0x20), // inloc
49                 mload(_calldata), // inlen
50                 0, // outloc
51                 0 // outlen
52             )
53             // limit our copy to 256 bytes
54             _toCopy := returndatasize()
55             if gt(_toCopy, _maxCopy) {
56                 _toCopy := _maxCopy
57             }
58             // Store the length of the copied bytes
59             mstore(_returnData, _toCopy)
60             // copy the bytes from returndata[0:_toCopy]
61             returndatacopy(add(_returnData, 0x20), 0, _toCopy)
62         }
63         return (_success, _returnData);
64     }
65 
66     /// @notice Use when you _really_ really _really_ don't trust the called
67     /// contract. This prevents the called contract from causing reversion of
68     /// the caller in as many ways as we can.
69     /// @dev The main difference between this and a solidity low-level call is
70     /// that we limit the number of bytes that the callee can cause to be
71     /// copied to caller memory. This prevents stupid things like malicious
72     /// contracts returning 10,000,000 bytes causing a local OOG when copying
73     /// to memory.
74     /// @param _target The address to call
75     /// @param _gas The amount of gas to forward to the remote contract
76     /// @param _maxCopy The maximum number of bytes of returndata to copy
77     /// to memory.
78     /// @param _calldata The data to send to the remote contract
79     /// @return success and returndata, as `.call()`. Returndata is capped to
80     /// `_maxCopy` bytes.
81     function excessivelySafeStaticCall(
82         address _target,
83         uint256 _gas,
84         uint16 _maxCopy,
85         bytes memory _calldata
86     ) internal view returns (bool, bytes memory) {
87         // set up for assembly call
88         uint256 _toCopy;
89         bool _success;
90         bytes memory _returnData = new bytes(_maxCopy);
91         // dispatch message to recipient
92         // by assembly calling "handle" function
93         // we call via assembly to avoid memcopying a very large returndata
94         // returned by a malicious contract
95         assembly {
96             _success := staticcall(
97                 _gas, // gas
98                 _target, // recipient
99                 add(_calldata, 0x20), // inloc
100                 mload(_calldata), // inlen
101                 0, // outloc
102                 0 // outlen
103             )
104             // limit our copy to 256 bytes
105             _toCopy := returndatasize()
106             if gt(_toCopy, _maxCopy) {
107                 _toCopy := _maxCopy
108             }
109             // Store the length of the copied bytes
110             mstore(_returnData, _toCopy)
111             // copy the bytes from returndata[0:_toCopy]
112             returndatacopy(add(_returnData, 0x20), 0, _toCopy)
113         }
114         return (_success, _returnData);
115     }
116 
117     /**
118      * @notice Swaps function selectors in encoded contract calls
119      * @dev Allows reuse of encoded calldata for functions with identical
120      * argument types but different names. It simply swaps out the first 4 bytes
121      * for the new selector. This function modifies memory in place, and should
122      * only be used with caution.
123      * @param _newSelector The new 4-byte selector
124      * @param _buf The encoded contract args
125      */
126     function swapSelector(
127         bytes4 _newSelector,
128         bytes memory _buf
129     ) internal pure {
130         if (_buf.length < 4) {
131             revert InvalidCallData();
132         }
133         uint256 _mask = LOW_28_MASK;
134         assembly {
135             // load the first word of
136             let _word := mload(add(_buf, 0x20))
137             // mask out the top 4 bytes
138             // /x
139             _word := and(_word, _mask)
140             _word := or(_newSelector, _word)
141             mstore(add(_buf, 0x20), _word)
142         }
143     }
144 }
