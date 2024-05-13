1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import "./interfaces/IRateCalculator.sol";
5 
6 /// @title A formula for calculating interest rates linearly as a function of utilization
7 contract LinearInterestRate is IRateCalculator {
8     
9     uint256 private constant MIN_INT = 0; // 0.00% annual rate
10     uint256 private constant MAX_INT = 146248508681; // 10,000% annual rate
11     uint256 private constant MAX_VERTEX_UTIL = 1e5; // 100%
12     uint256 private constant UTIL_PREC = 1e5;
13 
14     /// @notice The ```name``` function returns the name of the rate contract
15     /// @return memory name of contract
16     function name() external pure returns (string memory) {
17         return "Linear Interest Rate";
18     }
19 
20     /// @notice Returns abi encoded constants
21     /// @return _calldata abi.encode(uint256 MIN_INT, uint256 MAX_INT, uint256 MAX_VERTEX_UTIL, uint256 UTIL_PREC)
22     function getConstants() external pure returns (bytes memory _calldata) {
23         return abi.encode(MIN_INT, MAX_INT, MAX_VERTEX_UTIL, UTIL_PREC);
24     }
25 
26     /// @notice Reverts if initialization data fails to be validated
27     /// @param _initData abi.encode(uint256 _minInterest, uint256 _vertexInterest, uint256 _maxInterest, uint256 _vertexUtilization)
28     function requireValidInitData(bytes calldata _initData) public pure {
29         (uint256 _minInterest, uint256 _vertexInterest, uint256 _maxInterest, uint256 _vertexUtilization) = abi.decode(_initData,(uint256, uint256, uint256, uint256));
30         
31         require(_minInterest < MAX_INT && _minInterest <= _vertexInterest && _minInterest >= MIN_INT,
32             "LinearInterestRate: _minInterest < MAX_INT && _minInterest <= _vertexInterest && _minInterest >= MIN_INT"
33         );
34         require(_maxInterest <= MAX_INT && _vertexInterest <= _maxInterest && _maxInterest > MIN_INT,
35             "LinearInterestRate: _maxInterest <= MAX_INT && _vertexInterest <= _maxInterest && _maxInterest > MIN_INT"
36         );
37         require(_vertexUtilization < MAX_VERTEX_UTIL && _vertexUtilization > 0,
38             "LinearInterestRate: _vertexUtilization < MAX_VERTEX_UTIL && _vertexUtilization > 0"
39         );
40     }
41 
42     /// @notice Calculates interest rates using two linear functions f(utilization)
43     /// @dev We use calldata to remain un-opinionated about future implementations
44     /// @param _data abi.encode(uint64 _currentRatePerSec, uint256 _deltaTime, uint256 _utilization, uint256 _deltaBlocks)
45     /// @param _initData abi.encode(uint256 _minInterest, uint256 _vertexInterest, uint256 _maxInterest, uint256 _vertexUtilization)
46     /// @return _newRatePerSec The new interest rate per second, 1e18 precision
47     function getNewRate(bytes calldata _data, bytes calldata _initData) external pure returns (uint64 _newRatePerSec) {
48         requireValidInitData(_initData);
49         
50         (, , uint256 _utilization, ) = abi.decode(_data, (uint64, uint256, uint256, uint256));
51         
52         (uint256 _minInterest, uint256 _vertexInterest, uint256 _maxInterest, uint256 _vertexUtilization) = abi.decode(_initData,(uint256, uint256, uint256, uint256));
53         
54         if (_utilization < _vertexUtilization) {
55             uint256 _slope = ((_vertexInterest - _minInterest) * UTIL_PREC) / _vertexUtilization;
56             _newRatePerSec = uint64(_minInterest + ((_utilization * _slope) / UTIL_PREC));
57         } else if (_utilization > _vertexUtilization) {
58             uint256 _slope = (((_maxInterest - _vertexInterest) * UTIL_PREC) / (UTIL_PREC - _vertexUtilization));
59             _newRatePerSec = uint64(_vertexInterest + (((_utilization - _vertexUtilization) * _slope) / UTIL_PREC));
60         } else {
61             _newRatePerSec = uint64(_vertexInterest);
62         }
63     }
64 }