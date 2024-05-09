// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "./interfaces/IRateCalculator.sol";

/// @title A formula for calculating interest rates linearly as a function of utilization
contract LinearInterestRate is IRateCalculator {
    
    uint256 private constant MIN_INT = 0; // 0.00% annual rate
    uint256 private constant MAX_INT = 146248508681; // 10,000% annual rate
    uint256 private constant MAX_VERTEX_UTIL = 1e5; // 100%
    uint256 private constant UTIL_PREC = 1e5;

    /// @notice The ```name``` function returns the name of the rate contract
    /// @return memory name of contract
    function name() external pure returns (string memory) {
        return "Linear Interest Rate";
    }

    /// @notice Returns abi encoded constants
    /// @return _calldata abi.encode(uint256 MIN_INT, uint256 MAX_INT, uint256 MAX_VERTEX_UTIL, uint256 UTIL_PREC)
    function getConstants() external pure returns (bytes memory _calldata) {
        return abi.encode(MIN_INT, MAX_INT, MAX_VERTEX_UTIL, UTIL_PREC);
    }

    /// @notice Reverts if initialization data fails to be validated
    /// @param _initData abi.encode(uint256 _minInterest, uint256 _vertexInterest, uint256 _maxInterest, uint256 _vertexUtilization)
    function requireValidInitData(bytes calldata _initData) public pure {
        (uint256 _minInterest, uint256 _vertexInterest, uint256 _maxInterest, uint256 _vertexUtilization) = abi.decode(_initData,(uint256, uint256, uint256, uint256));
        
        require(_minInterest < MAX_INT && _minInterest <= _vertexInterest && _minInterest >= MIN_INT,
            "LinearInterestRate: _minInterest < MAX_INT && _minInterest <= _vertexInterest && _minInterest >= MIN_INT"
        );
        require(_maxInterest <= MAX_INT && _vertexInterest <= _maxInterest && _maxInterest > MIN_INT,
            "LinearInterestRate: _maxInterest <= MAX_INT && _vertexInterest <= _maxInterest && _maxInterest > MIN_INT"
        );
        require(_vertexUtilization < MAX_VERTEX_UTIL && _vertexUtilization > 0,
            "LinearInterestRate: _vertexUtilization < MAX_VERTEX_UTIL && _vertexUtilization > 0"
        );
    }

    /// @notice Calculates interest rates using two linear functions f(utilization)
    /// @dev We use calldata to remain un-opinionated about future implementations
    /// @param _data abi.encode(uint64 _currentRatePerSec, uint256 _deltaTime, uint256 _utilization, uint256 _deltaBlocks)
    /// @param _initData abi.encode(uint256 _minInterest, uint256 _vertexInterest, uint256 _maxInterest, uint256 _vertexUtilization)
    /// @return _newRatePerSec The new interest rate per second, 1e18 precision
    function getNewRate(bytes calldata _data, bytes calldata _initData) external pure returns (uint64 _newRatePerSec) {
        requireValidInitData(_initData);
        
        (, , uint256 _utilization, ) = abi.decode(_data, (uint64, uint256, uint256, uint256));
        
        (uint256 _minInterest, uint256 _vertexInterest, uint256 _maxInterest, uint256 _vertexUtilization) = abi.decode(_initData,(uint256, uint256, uint256, uint256));
        
        if (_utilization < _vertexUtilization) {
            uint256 _slope = ((_vertexInterest - _minInterest) * UTIL_PREC) / _vertexUtilization;
            _newRatePerSec = uint64(_minInterest + ((_utilization * _slope) / UTIL_PREC));
        } else if (_utilization > _vertexUtilization) {
            uint256 _slope = (((_maxInterest - _vertexInterest) * UTIL_PREC) / (UTIL_PREC - _vertexUtilization));
            _newRatePerSec = uint64(_vertexInterest + (((_utilization - _vertexUtilization) * _slope) / UTIL_PREC));
        } else {
            _newRatePerSec = uint64(_vertexInterest);
        }
    }
}