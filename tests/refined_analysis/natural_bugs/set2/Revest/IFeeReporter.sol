// SPDX-License-Identifier: GNU-GPL v3.0 or later

pragma solidity >=0.8.0;


interface IFeeReporter {

    function getFlatWeiFee(address asset) external view returns (uint);

    function getERC20Fee(address asset) external view returns (uint);

}
