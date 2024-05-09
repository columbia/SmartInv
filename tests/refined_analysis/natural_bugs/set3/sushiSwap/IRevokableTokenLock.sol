// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

interface IRevokableTokenLock {
    function setupVesting(
        address recipient,
        uint256 _unlockBegin,
        uint256 _unlockCliff,
        uint256 _unlockEnd
    ) external;

    function lock(address recipient, uint256 amount) external;
}
