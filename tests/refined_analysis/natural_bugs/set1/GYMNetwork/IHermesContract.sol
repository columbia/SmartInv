// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.9;

interface IHermesContract {
    enum Status { Active, Paused, Punishment, Closed }
    function initialize(address _token, address _operator, uint16 _hermesFee, uint256 _minStake, uint256 _maxStake, address payable _routerAddress) external;
    function openChannel(address _party, uint256 _amountToLend) external;
    function getOperator() external view returns (address);
    function getStake() external view returns (uint256);
    function getStatus() external view returns (Status);
}
