// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import "@openzeppelin/contracts/access/Ownable.sol";

import "./TokenLock.sol";

/// @dev Same as TokenLock, but enables a revoker to end vesting prematurely and send locked tokens to governance.
contract RevokableTokenLock is TokenLock {
    address public revoker;

    event Revoked(address indexed revokedOwner, uint256 amount);

    constructor(ERC20 _token, address _revoker) TokenLock(_token) {
        require(_revoker != address(0), "RevokableTokenLock: revoker address cannot be set to 0");
        revoker = _revoker;
    }

    /**
     * @dev set revoker address
     * @param _revoker The account with revoking rights
     */
    function setRevoker(address _revoker) external onlyOwner {
        require(_revoker != address(0), "RevokableTokenLock: null address");
        revoker = _revoker;
    }

    /**
     * @dev revoke access of a owner and transfer pending
     * @param recipient The account whose access will be revoked.
     */
    function revoke(address recipient) external {
        require(
            msg.sender == revoker || msg.sender == owner(),
            "RevokableTokenLock: onlyAuthorizedActors"
        );

        // claim any vested but unclaimed parts for recipient first
        uint256 claimable = claimableBalance(recipient);
        if (claimable > 0) {
            vesting[recipient].claimedAmounts += claimable;
            require(token.transfer(recipient, claimable), "RevokableTokenLock: Transfer failed");
            emit Claimed(recipient, recipient, claimable);
        }

        // revoke the rest that is still being vested
        uint256 remaining = vesting[recipient].lockedAmounts - vesting[recipient].claimedAmounts;
        if (remaining > 0) {
            require(token.transfer(owner(), remaining), "RevokableTokenLock: Transfer failed");
            // no new claims
            vesting[recipient].lockedAmounts = vesting[recipient].claimedAmounts;
            vesting[recipient].unlockEnd = block.timestamp;
        }
        emit Revoked(recipient, remaining);
    }
}
