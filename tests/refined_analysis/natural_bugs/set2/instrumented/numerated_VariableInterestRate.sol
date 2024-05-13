1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 // ███████╗░█████╗░██████╗░████████╗██████╗░███████╗░██████╗░██████╗
5 // ██╔════╝██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗██╔════╝██╔════╝██╔════╝
6 // █████╗░░██║░░██║██████╔╝░░░██║░░░██████╔╝█████╗░░╚█████╗░╚█████╗░
7 // ██╔══╝░░██║░░██║██╔══██╗░░░██║░░░██╔══██╗██╔══╝░░░╚═══██╗░╚═══██╗
8 // ██║░░░░░╚█████╔╝██║░░██║░░░██║░░░██║░░██║███████╗██████╔╝██████╔╝
9 // ╚═╝░░░░░░╚════╝░╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░╚═╝╚══════╝╚═════╝░╚═════╝░
10 // ███████╗██╗███╗░░██╗░█████╗░███╗░░██╗░█████╗░███████╗
11 // ██╔════╝██║████╗░██║██╔══██╗████╗░██║██╔══██╗██╔════╝
12 // █████╗░░██║██╔██╗██║███████║██╔██╗██║██║░░╚═╝█████╗░░
13 // ██╔══╝░░██║██║╚████║██╔══██║██║╚████║██║░░██╗██╔══╝░░
14 // ██║░░░░░██║██║░╚███║██║░░██║██║░╚███║╚█████╔╝███████╗
15 // ╚═╝░░░░░╚═╝╚═╝░░╚══╝╚═╝░░╚═╝╚═╝░░╚══╝░╚════╝░╚══════╝
16 
17 //  _____         _     _   _     _____     _                   _   _____     _       
18 // |  |  |___ ___|_|___| |_| |___|     |___| |_ ___ ___ ___ ___| |_| __  |___| |_ ___ 
19 // |  |  | .'|  _| | .'| . | | -_|-   -|   |  _| -_|  _| -_|_ -|  _|    -| .'|  _| -_|
20 //  \___/|__,|_| |_|__,|___|_|___|_____|_|_|_| |___|_| |___|___|_| |__|__|__,|_| |___|
21 
22 // Github - https://github.com/FortressFinance
23 
24 import "./interfaces/IRateCalculator.sol";
25 
26 /// @title A formula for calculating interest rates as a function of utilization and time
27 contract VariableInterestRate is IRateCalculator {
28     
29     // Utilization Rate Settings
30     uint32 private constant MIN_UTIL = 75000; // 75%
31     uint32 private constant MAX_UTIL = 85000; // 85%
32     uint32 private constant UTIL_PREC = 1e5; // 5 decimals
33 
34     // Interest Rate Settings (all rates are per second), 365.24 days per year
35     uint64 private constant MIN_INT = 79123523; // 0.25% annual rate
36     uint64 private constant MAX_INT = 146248476607; // 10,000% annual rate
37     uint256 private constant INT_HALF_LIFE = 43200e36; // given in seconds, equal to 12 hours, additional 1e36 to make math simpler
38 
39     /// @notice Returns the name of the rate contract
40     /// @return memory name of contract
41     function name() external pure returns (string memory) {
42         return "Variable Time-Weighted Interest Rate";
43     }
44 
45     /// @notice Returns abi encoded constants
46     /// @return _calldata abi.encode(uint32 MIN_UTIL, uint32 MAX_UTIL, uint32 UTIL_PREC, uint64 MIN_INT, uint64 MAX_INT, uint256 INT_HALF_LIFE)
47     function getConstants() external pure returns (bytes memory _calldata) {
48         return abi.encode(MIN_UTIL, MAX_UTIL, UTIL_PREC, MIN_INT, MAX_INT, INT_HALF_LIFE);
49     }
50 
51     /// @notice This contract has no init data
52     function requireValidInitData(bytes calldata _initData) external pure {}
53 
54     /// @notice Calculates the new interest rate as a function of time and utilization
55     /// @param _data abi.encode(uint64 _currentRatePerSec, uint256 _deltaTime, uint256 _utilization, uint256 _deltaBlocks)
56     // / @param _initData empty for this Rate Calculator
57     /// @return _newRatePerSec The new interest rate per second, 1e18 precision
58     function getNewRate(bytes calldata _data, bytes calldata) external pure returns (uint64 _newRatePerSec) {
59         
60         (uint64 _currentRatePerSec, uint256 _deltaTime, uint256 _utilization, ) = abi.decode(_data, (uint64, uint256, uint256, uint256));
61         
62         if (_utilization < MIN_UTIL) {
63             uint256 _deltaUtilization = ((MIN_UTIL - _utilization) * 1e18) / MIN_UTIL;
64             uint256 _decayGrowth = INT_HALF_LIFE + (_deltaUtilization * _deltaUtilization * _deltaTime);
65             _newRatePerSec = uint64((_currentRatePerSec * INT_HALF_LIFE) / _decayGrowth);
66             if (_newRatePerSec < MIN_INT) {
67                 _newRatePerSec = MIN_INT;
68             }
69         } else if (_utilization > MAX_UTIL) {
70             uint256 _deltaUtilization = ((_utilization - MAX_UTIL) * 1e18) / (UTIL_PREC - MAX_UTIL);
71             uint256 _decayGrowth = INT_HALF_LIFE + (_deltaUtilization * _deltaUtilization * _deltaTime);
72             _newRatePerSec = uint64((_currentRatePerSec * _decayGrowth) / INT_HALF_LIFE);
73             if (_newRatePerSec > MAX_INT) {
74                 _newRatePerSec = MAX_INT;
75             }
76         } else {
77             _newRatePerSec = _currentRatePerSec;
78         }
79     }
80 }
