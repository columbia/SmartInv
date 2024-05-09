// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

interface IFortressCompounder {

    function getUnderlyingAssets() external view returns (address[] memory);

    function getName() external view returns (string memory);

    function getSymbol() external view returns (string memory);

    function getDescription() external view returns (string memory);
}