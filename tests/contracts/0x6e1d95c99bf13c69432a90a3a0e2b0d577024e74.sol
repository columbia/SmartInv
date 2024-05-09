// SPDX-License-Identifier: MIT

// File: @openzeppelin/contracts/utils/Context.sol


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

// File: @openzeppelin/contracts/access/Ownable.sol


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

// File: @openzeppelin/contracts/security/ReentrancyGuard.sol


// OpenZeppelin Contracts (last updated v4.9.0) (security/ReentrancyGuard.sol)

pragma solidity ^0.8.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        // On the first call to nonReentrant, _status will be _NOT_ENTERED
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;
    }

    function _nonReentrantAfter() private {
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
     * `nonReentrant` function in the call stack.
     */
    function _reentrancyGuardEntered() internal view returns (bool) {
        return _status == _ENTERED;
    }
}

// File: contracts/NetjammersPond.sol





pragma solidity ^0.8.18;

interface Netjammers {
    function balanceOf(address owner) external view returns (uint256 balance);
    function totalSupply() external view returns (uint256);
    function Airdrop(uint256 _mintAmount, address _receiver) external;
    function withdraw() external;
    function setSaleStatus(bool _sale) external;
    function transferOwnership(address newOwner) external;
}

interface IERC20 {
    function transfer(address _to, uint256 _amount) external returns (bool);
    function transferFrom(address _from, address _to, uint256 _amount) external returns (bool);
    function balanceOf(address _owner) external returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
}

/*
 _   _  _____ _____  ___  ___  ___  ______  ___ ___________  _____ 
| \ | ||  ___|_   _||_  |/ _ \ |  \/  ||  \/  ||  ___| ___ \/  ___|
|  \| || |__   | |    | / /_\ \| .  . || .  . || |__ | |_/ /\ `--. 
| . ` ||  __|  | |    | |  _  || |\/| || |\/| ||  __||    /  `--. \
| |\  || |___  | |/\__/ / | | || |  | || |  | || |___| |\ \ /\__/ /
\_| \_/\____/  \_/\____/\_| |_/\_|  |_/\_|  |_/\____/\_| \_|\____/ 
                   ~we're dipping into the pond~
*/

// Proxy contract to handle Pond mints.
contract NetjammersPond is Ownable, ReentrancyGuard {
    Netjammers public nj;
    IERC20 public pond;
    uint256 public freeMintCount = 0;
    uint256 public maxFreeMintCount = 500;
    uint256 public freeMintMax = 1;
    uint256 public pondBalance = 10000000000000000000000000; // 10 million $PNDC held for free mint
    uint256 public pondPrice = 18000000000000000000000000; // 18 million $PNDC
    mapping (address => uint) freeMintedPondHolder;

    constructor (address _contractAddress, address _pondContractAddress) {
        nj = Netjammers(_contractAddress);
        pond = IERC20(_pondContractAddress);
    }

    function setPondPrice(uint256 _price) public onlyOwner {
        pondPrice = _price;
    }

    function setPondBalance(uint256 _price) public onlyOwner {
        pondBalance = _price;
    }

    function setFreeMintMax(uint256 _amt) public onlyOwner {
        freeMintMax = _amt;
    }
    
    function setSaleStatus(bool _sale) public onlyOwner {
        nj.setSaleStatus(_sale);
    }

    function acceptPayment(uint256 _amt) public returns(bool) {
       require(pond.allowance(msg.sender, address(this)) >= _amt, "Please approve tokens for transaction");
       pond.transferFrom(msg.sender, address(this), _amt);
       return true;
    }

    function freeMinted() public view returns (uint256) {
        return freeMintCount;
    }

    function freeMint () public {
        require(pond.balanceOf(msg.sender) >= pondBalance, "Gotta hold more $PNDC!");
        require(freeMintMax > freeMintedPondHolder[msg.sender], "You got your free mint already");
        require(nj.totalSupply() + 1 <= 10000, "Max supply exceeded!");
        require(500 > freeMintCount, "Free mints exhausted");
        unchecked {
            freeMintedPondHolder[msg.sender]++;
            freeMintCount++;
        }
        nj.Airdrop(1, msg.sender);
    }

    function mint (uint256 _mintAmount) public payable {
        require(_mintAmount > 0 && _mintAmount <= 10, "Invalid mint amount");
        require(nj.totalSupply() + _mintAmount <= 10000, "Max supply exceeded!");
        require(nj.balanceOf(msg.sender) + _mintAmount <= 20, "Max mint per wallet exceeded");
        require(pond.balanceOf(msg.sender) >= pondPrice * _mintAmount, "Insufficient funds");
        require(acceptPayment(_mintAmount * pondPrice), "Payment failed");
        nj.Airdrop(_mintAmount, msg.sender);
    }

    function transferParentOwnership (address newOwner) public onlyOwner {
        nj.transferOwnership(newOwner);
    }

    // Withdraw all funds from parent contract to this contract, then to owner
    function withdrawAllBalances() external onlyOwner nonReentrant {
        nj.withdraw();
        (bool success, ) = payable(owner()).call{value: address(this).balance}("");
        require(success, "Transaction Failed");
        pond.transfer(owner(), pond.balanceOf(address(this)));
    }

    function withdrawPond() external onlyOwner {
        pond.transfer(owner(), pond.balanceOf(address(this)));
    }

    fallback() external payable {
    }

    receive() external payable {
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}