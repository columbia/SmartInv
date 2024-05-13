1 // SPDX-License-Identifier: GNU-GPL v3.0 or later
2 
3 pragma solidity ^0.8.0;
4 
5 import "../interfaces/ITokenVault.sol";
6 import "../interfaces/ILockManager.sol";
7 import "../interfaces/IRevest.sol";
8 import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
9 
10 library RevestHelper {
11 
12  
13     function boolToString(bool arg) private pure returns (string memory boolean) {
14         boolean = arg ? "true" : "false";
15     }
16 
17     function getLockType(IRevest.LockType lock) private pure returns (string memory lockType) {
18         if(lock == IRevest.LockType.TimeLock) {
19             lockType = "Time";
20         } 
21         if(lock == IRevest.LockType.TimeLock) {
22             lockType = "Value";
23         }
24         if(lock == IRevest.LockType.TimeLock) {
25             lockType = "Address";
26         }
27     } 
28 
29     function getTicker(address asset) private view returns (string memory ticker) {
30         try IERC20Metadata(asset).symbol() returns (string memory tick) {
31             ticker = tick;
32         } catch {
33             ticker = '???';
34         }
35     }
36 
37     function getName(address asset) private view returns (string memory ticker) {
38         try IERC20Metadata(asset).name() returns (string memory tick) {
39             ticker = tick;
40         } catch {
41             ticker = 'Unknown Token';
42         }
43     }
44 
45     function amountToDecimal(uint amt, address asset) private view returns (string memory decStr) {
46         uint8 decimals;
47         try IERC20Metadata(asset).decimals() returns (uint8 dec) {
48             decimals = dec;
49         } catch {
50             decimals = 18;
51         }
52         decStr = decimalString(amt, decimals);
53     }
54 
55     function toString(uint _i) internal pure returns (string memory _uintAsString) {
56         if (_i == 0) {
57             return "0";
58         }
59         uint j = _i;
60         uint len;
61         while (j != 0) {
62             len++;
63             j /= 10;
64         }
65         bytes memory bstr = new bytes(len);
66         uint k = len;
67         while (_i != 0) {
68             k = k-1;
69             uint8 temp = (48 + uint8(_i - _i / 10 * 10));
70             bytes1 b1 = bytes1(temp);
71             bstr[k] = b1;
72             _i /= 10;
73         }
74         return string(bstr);
75     }
76 
77     function decimalString(uint256 number, uint8 decimals) private pure returns(string memory){
78         uint256 tenPowDecimals = 10 ** decimals;
79 
80         uint256 temp = number;
81         uint8 digits;
82         uint8 numSigfigs;
83         while (temp != 0) {
84             if (numSigfigs > 0) {
85                 // count all digits preceding least significant figure
86                 numSigfigs++;
87             } else if (temp % 10 != 0) {
88                 numSigfigs++;
89             }
90             digits++;
91             temp /= 10;
92         }
93 
94         DecimalStringParams memory params;
95         if((digits - numSigfigs) >= decimals) {
96             // no decimals, ensure we preserve all trailing zeros
97             params.sigfigs = number / tenPowDecimals;
98             params.sigfigIndex = digits - decimals;
99             params.bufferLength = params.sigfigIndex;
100         } else {
101             // chop all trailing zeros for numbers with decimals
102             params.sigfigs = number / (10 ** (digits - numSigfigs));
103             if(tenPowDecimals > number){
104                 // number is less tahn one
105                 // in this case, there may be leading zeros after the decimal place 
106                 // that need to be added
107 
108                 // offset leading zeros by two to account for leading '0.'
109                 params.zerosStartIndex = 2;
110                 params.zerosEndIndex = decimals - digits + 2;
111                 params.sigfigIndex = numSigfigs + params.zerosEndIndex;
112                 params.bufferLength = params.sigfigIndex;
113                 params.isLessThanOne = true;
114             } else {
115                 // In this case, there are digits before and
116                 // after the decimal place
117                 params.sigfigIndex = numSigfigs + 1;
118                 params.decimalIndex = digits - decimals + 1;
119             }
120         }
121         params.bufferLength = params.sigfigIndex;
122         return generateDecimalString(params);
123     }
124 
125     // With modifications, the below taken 
126     // from https://github.com/Uniswap/uniswap-v3-periphery/blob/main/contracts/libraries/NFTDescriptor.sol#L189-L231
127 
128     struct DecimalStringParams {
129         // significant figures of decimal
130         uint256 sigfigs;
131         // length of decimal string
132         uint8 bufferLength;
133         // ending index for significant figures (funtion works backwards when copying sigfigs)
134         uint8 sigfigIndex;
135         // index of decimal place (0 if no decimal)
136         uint8 decimalIndex;
137         // start index for trailing/leading 0's for very small/large numbers
138         uint8 zerosStartIndex;
139         // end index for trailing/leading 0's for very small/large numbers
140         uint8 zerosEndIndex;
141         // true if decimal number is less than one
142         bool isLessThanOne;
143     }
144 
145     function generateDecimalString(DecimalStringParams memory params) private pure returns (string memory) {
146         bytes memory buffer = new bytes(params.bufferLength);
147         if (params.isLessThanOne) {
148             buffer[0] = '0';
149             buffer[1] = '.';
150         }
151 
152         // add leading/trailing 0's
153         for (uint256 zerosCursor = params.zerosStartIndex; zerosCursor < params.zerosEndIndex; zerosCursor++) {
154             buffer[zerosCursor] = bytes1(uint8(48));
155         }
156         // add sigfigs
157         while (params.sigfigs > 0) {
158             if (params.decimalIndex > 0 && params.sigfigIndex == params.decimalIndex) {
159                 buffer[--params.sigfigIndex] = '.';
160             }
161             buffer[--params.sigfigIndex] = bytes1(uint8(uint256(48) + (params.sigfigs % 10)));
162             params.sigfigs /= 10;
163         }
164         return string(buffer);
165     }
166 }