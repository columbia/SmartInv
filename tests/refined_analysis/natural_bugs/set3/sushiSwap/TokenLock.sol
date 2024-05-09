// SPDX-License-Identifier: MIT
// Taken from https://github.com/ensdomains/governance/blob/master/contracts/TokenLock.sol
pragma solidity 0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @dev Time-locks tokens according to an unlock schedule.
 */

contract TokenLock is Ownable {
    ERC20 public immutable token;

    struct VestingParams {
        uint256 unlockBegin;
        uint256 unlockCliff;
        uint256 unlockEnd;
        uint256 lockedAmounts;
        uint256 claimedAmounts;
    }

    address public tokenSale;
    mapping(address => VestingParams) public vesting;

    event Setup(
        address indexed recipient,
        uint256 _unlockBegin,
        uint256 _unlockCliff,
        uint256 _unlockEnd
    );
    event Locked(address indexed sender, address indexed recipient, uint256 amount);
    event Claimed(address indexed owner, address indexed recipient, uint256 amount);

    /**
     * @dev Constructor.
     * @param _token The token this contract will lock
     */
    constructor(ERC20 _token) {
        token = _token;
    }

    /**
     * @dev set sale contract
     * @param _tokenSale address of token sale contract
     */
    function setTokenSale(address _tokenSale) external onlyOwner {
        require(_tokenSale != address(0), "TokenLock: Null address");
        tokenSale = _tokenSale;
    }

    /**
     * @dev setup vesting for recipient.
     * @param recipient The account for which vesting will be setup.
     * @param _unlockBegin The time at which unlocking of tokens will begin.
     * @param _unlockCliff The first time at which tokens are claimable.
     * @param _unlockEnd The time at which the last token will unlock.
     */
    function setupVesting(
        address recipient,
        uint256 _unlockBegin,
        uint256 _unlockCliff,
        uint256 _unlockEnd
    ) external {
        require(
            msg.sender == owner() || msg.sender == address(token) || msg.sender == tokenSale,
            "TokenLock: Only owner/ claims/ sale contract can call"
        );
        require(
            _unlockCliff >= _unlockBegin,
            "TokenLock: Unlock cliff must not be before unlock begin"
        );
        require(
            _unlockEnd >= _unlockCliff,
            "TokenLock: Unlock end must not be before unlock cliff"
        );
        vesting[recipient].unlockBegin = _unlockBegin;
        vesting[recipient].unlockCliff = _unlockCliff;
        vesting[recipient].unlockEnd = _unlockEnd;
    }

    /**
     * @dev Returns the maximum number of tokens currently claimable by `owner`.
     * @param owner The account to check the claimable balance of.
     * @return The number of tokens currently claimable.
     */
    function claimableBalance(address owner) public view virtual returns (uint256) {
        if (block.timestamp < vesting[owner].unlockCliff) {
            return 0;
        }

        uint256 locked = vesting[owner].lockedAmounts;
        uint256 claimed = vesting[owner].claimedAmounts;
        if (block.timestamp >= vesting[owner].unlockEnd) {
            return locked - claimed;
        }
        return
            (locked * (block.timestamp - vesting[owner].unlockBegin)) /
            (vesting[owner].unlockEnd - vesting[owner].unlockBegin) -
            claimed;
    }

    /**
     * @dev Transfers tokens from the caller to the token lock contract and locks them for benefit of `recipient`.
     *      Requires that the caller has authorised this contract with the token contract.
     * @param recipient The account the tokens will be claimable by.
     * @param amount The number of tokens to transfer and lock.
     */
    function lock(address recipient, uint256 amount) external {
        require(
            block.timestamp < vesting[recipient].unlockEnd,
            "TokenLock: Unlock period already complete"
        );
        vesting[recipient].lockedAmounts += amount;
        require(
            token.transferFrom(msg.sender, address(this), amount),
            "TokenLock: Transfer failed"
        );
        emit Locked(msg.sender, recipient, amount);
    }

    /**
     * @dev Claims the caller's tokens that have been unlocked, sending them to `recipient`.
     * @param recipient The account to transfer unlocked tokens to.
     * @param amount The amount to transfer. If greater than the claimable amount, the maximum is transferred.
     */
    function claim(address recipient, uint256 amount) external {
        uint256 claimable = claimableBalance(msg.sender);
        if (amount > claimable) {
            amount = claimable;
        }
        if (amount != 0) {
            vesting[msg.sender].claimedAmounts += amount;
            require(token.transfer(recipient, amount), "TokenLock: Transfer failed");
            emit Claimed(msg.sender, recipient, amount);
        }
    }
}
