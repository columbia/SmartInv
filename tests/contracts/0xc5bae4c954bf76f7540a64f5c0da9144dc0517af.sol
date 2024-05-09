// Sources flattened with hardhat v2.17.1 https://hardhat.org

// SPDX-License-Identifier: MIT

// File @openzeppelin/contracts/utils/Context.sol@v4.9.3

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}


// File @openzeppelin/contracts/access/Ownable.sol@v4.9.3

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)

pragma solidity ^0.8.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}


// File contracts/EspressoRevenueShare.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.9;

contract EspressoRevenueShare is Ownable {
    bool public redeemEnabled = false;
    mapping(address => uint256) public holding;
    mapping(address => bool) public allowing;

    event RedeemEvent(address indexed user, uint256 amount);

    constructor(address[] memory _addresses, uint256[] memory _holding, bool[] memory _allowing) {
        updateState(_addresses, _holding, _allowing);
    }

    receive() external payable {}

    function updateState(address[] memory _addresses, uint256[] memory _holding, bool[] memory _allowing) public onlyOwner {
        require(_addresses.length == _holding.length,"Input arrays must have the same length");
        require(_holding.length == _allowing.length,"Input arrays must have the same length");
        for (uint256 i = 0; i < _addresses.length; i++) {
            holding[_addresses[i]] = _holding[i];
            allowing[_addresses[i]] = _allowing[i];
        }
    }

    function updateHolding(address[] memory _addresses, uint256[] memory _holding) public onlyOwner {
        require(_addresses.length == _holding.length, "Input arrays must have the same length");
        for (uint256 i = 0; i < _addresses.length; i++) {
            holding[_addresses[i]] = _holding[i];
        }
    }

    function updateAllowing(address[] memory _addresses, bool[] memory _allowing) public onlyOwner {
        require(_addresses.length == _allowing.length,"Input arrays must have the same length");
        for (uint256 i = 0; i < _addresses.length; i++) {
            allowing[_addresses[i]] = _allowing[i];
        }
    }

    function updateRedeemStatus(bool enabled) public onlyOwner {
        redeemEnabled = enabled;
    }

    function redeem() public {
        require(redeemEnabled, "Redeem not enabled");
        require(allowing[msg.sender], "Address not allowed");
        uint256 amount = holding[msg.sender];
        require(amount > 0, "Amount insufficient");
        holding[msg.sender] = 0;
        (bool sent, ) = payable(msg.sender).call{value: amount}("");
        require(sent, "Failed to send amount");
        emit RedeemEvent(msg.sender, amount);
    }

    function withdraw(uint256 amount) public onlyOwner {
        require(amount <= address(this).balance, "Insufficient contract balance");
        (bool sent, ) = payable(msg.sender).call{value: amount}("");
        require(sent, "Failed to send amount");
    }
}