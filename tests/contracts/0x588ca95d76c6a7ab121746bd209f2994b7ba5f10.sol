/*
 * Crypto stamp 2 On-Chain Shop
 * Ability to purchase pseudo-random digital-physical collectible postage stamps
 * and to redeem Crypto stamp 2 pre-sale vouchers in a similar manner
 *
 * Developed by Capacity Blockchain Solutions GmbH <capacity.at>
 * for Österreichische Post AG <post.at>
 */


// File: @openzeppelin/contracts/math/SafeMath.sol

pragma solidity ^0.6.0;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

// File: @openzeppelin/contracts/introspection/IERC165.sol

pragma solidity ^0.6.0;

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

// File: @openzeppelin/contracts/token/ERC721/IERC721.sol

pragma solidity ^0.6.2;


/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IERC721 is IERC165 {
    /**
     * @dev Emitted when `tokenId` token is transfered from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from`, `to` cannot be zero.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
     *
     * Requirements:
     *
     * - `from`, `to` cannot be zero.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool _approved) external;

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);

    /**
      * @dev Safely transfers `tokenId` token from `from` to `to`.
      *
      * Requirements:
      *
      * - `from`, `to` cannot be zero.
      * - `tokenId` token must exist and be owned by `from`.
      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
      *
      * Emits a {Transfer} event.
      */
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
}

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol

pragma solidity ^0.6.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: contracts/ENSReverseRegistrarI.sol

/*
 * Interfaces for ENS Reverse Registrar
 * See https://github.com/ensdomains/ens/blob/master/contracts/ReverseRegistrar.sol for full impl
 * Also see https://github.com/wealdtech/wealdtech-solidity/blob/master/contracts/ens/ENSReverseRegister.sol
 *
 * Use this as follows (registryAddress is the address of the ENS registry to use):
 * -----
 * // This hex value is caclulated by namehash('addr.reverse')
 * bytes32 public constant ENS_ADDR_REVERSE_NODE = 0x91d1777781884d03a6757a803996e38de2a42967fb37eeaca72729271025a9e2;
 * function registerReverseENS(address registryAddress, string memory calldata) external {
 *     require(registryAddress != address(0), "need a valid registry");
 *     address reverseRegistrarAddress = ENSRegistryOwnerI(registryAddress).owner(ENS_ADDR_REVERSE_NODE)
 *     require(reverseRegistrarAddress != address(0), "need a valid reverse registrar");
 *     ENSReverseRegistrarI(reverseRegistrarAddress).setName(name);
 * }
 * -----
 * or
 * -----
 * function registerReverseENS(address reverseRegistrarAddress, string memory calldata) external {
 *    require(reverseRegistrarAddress != address(0), "need a valid reverse registrar");
 *     ENSReverseRegistrarI(reverseRegistrarAddress).setName(name);
 * }
 * -----
 * ENS deployments can be found at https://docs.ens.domains/ens-deployments
 * E.g. Etherscan can be used to look up that owner on those contracts.
 * namehash.hash("addr.reverse") == "0x91d1777781884d03a6757a803996e38de2a42967fb37eeaca72729271025a9e2"
 * Ropsten: ens.owner(namehash.hash("addr.reverse")) == "0x6F628b68b30Dc3c17f345c9dbBb1E483c2b7aE5c"
 * Mainnet: ens.owner(namehash.hash("addr.reverse")) == "0x084b1c3C81545d370f3634392De611CaaBFf8148"
 */
pragma solidity ^0.6.0;

interface ENSRegistryOwnerI {
    function owner(bytes32 node) external view returns (address);
}

interface ENSReverseRegistrarI {
    function setName(string calldata name) external returns (bytes32 node);
}

// File: contracts/OracleRequest.sol

/*
Interface for requests to the rate oracle (for EUR/ETH)
Copy this to projects that need to access the oracle.
See rate-oracle project for implementation.
*/
pragma solidity ^0.6.0;


abstract contract OracleRequest {

    uint256 public EUR_WEI; //number of wei per EUR

    uint256 public lastUpdate; //timestamp of when the last update occurred

    function ETH_EUR() public view virtual returns (uint256); //number of EUR per ETH (rounded down!)

    function ETH_EURCENT() public view virtual returns (uint256); //number of EUR cent per ETH (rounded down!)

}

// File: contracts/CS2PropertiesI.sol

/*
Interface for CS2 properties.
*/
pragma solidity ^0.6.0;

interface CS2PropertiesI {

    enum AssetType {
        Honeybadger,
        Llama,
        Panda,
        Doge
    }

    enum Colors {
        Black,
        Green,
        Blue,
        Yellow,
        Red
    }

    function getType(uint256 tokenId) external view returns (AssetType);
    function getColor(uint256 tokenId) external view returns (Colors);

}

// File: contracts/OZ_ERC1155/IERC1155.sol

pragma solidity ^0.6.0;


/**
    @title ERC-1155 Multi Token Standard basic interface
    @dev See https://eips.ethereum.org/EIPS/eip-1155
 */
abstract contract IERC1155 is IERC165 {
    event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);

    event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);

    event ApprovalForAll(address indexed account, address indexed operator, bool approved);

    event URI(string value, uint256 indexed id);

    function balanceOf(address account, uint256 id) public view virtual returns (uint256);

    function balanceOfBatch(address[] memory accounts, uint256[] memory ids) public view virtual returns (uint256[] memory);

    function setApprovalForAll(address operator, bool approved) external virtual;

    function isApprovedForAll(address account, address operator) external view virtual returns (bool);

    function safeTransferFrom(address from, address to, uint256 id, uint256 value, bytes calldata data) external virtual;

    function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata values, bytes calldata data) external virtual;
}

// File: contracts/CS2PresaleRedeemI.sol

/*
Interface for CS2 on-chain presale for usage with redeemer (OCS) contract.
*/
pragma solidity ^0.6.0;


abstract contract CS2PresaleRedeemI is IERC1155 {
    enum AssetType {
        Honeybadger,
        Llama,
        Panda,
        Doge
    }

    // Redeem assets of a multiple types/animals at once.
    // This burns them in this contract, but should be called by a contract that assigns/creates the final assets in turn.
    function redeemBatch(address owner, AssetType[] calldata _type, uint256[] calldata _count) external virtual;
}

// File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol

pragma solidity ^0.6.2;


/**
 * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
 * @dev See https://eips.ethereum.org/EIPS/eip-721
 */
interface IERC721Enumerable is IERC721 {

    /**
     * @dev Returns the total amount of tokens stored by the contract.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
     * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
     */
    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);

    /**
     * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
     * Use along with {totalSupply} to enumerate all tokens.
     */
    function tokenByIndex(uint256 index) external view returns (uint256);
}

// File: contracts/ERC721ExistsI.sol

pragma solidity ^0.6.0;


/**
 * @dev ERC721 compliant contract with an exists() function.
 */
abstract contract ERC721ExistsI is IERC721 {

    // Returns whether the specified token exists
    function exists(uint256 tokenId) public view virtual returns (bool);

}

// File: contracts/CS2OCSBaseI.sol

pragma solidity ^0.6.0;



/**
 * @dev ERC721 compliant contract with an exists() function.
 */
abstract contract CS2OCSBaseI is ERC721ExistsI, IERC721Enumerable {

    // Issue a crypto stamp with a merkle proof.
    function createWithProof(bytes32 tokenData, bytes32[] memory merkleProof) public virtual returns (uint256);

}

// File: contracts/CS2OnChainShop.sol

/*
Implements an on-chain shop for Crypto stamp Edition 2
*/
pragma solidity ^0.6.0;









contract CS2OnChainShop {
    using SafeMath for uint256;

    CS2OCSBaseI internal CS2;
    CS2PresaleRedeemI internal CS2Presale;
    OracleRequest internal oracle;

    address payable public beneficiary;
    address public shippingControl;
    address public tokenAssignmentControl;

    uint256 public basePriceEurCent;
    uint256 public priceTargetTimestamp;
    uint256[4] public lastSaleTimestamp; // Every AssetType has their own sale/price tracking.
    uint256[4] public lastSalePriceEurCent;
    uint256[4] public lastSlotPriceEurCent;
    uint256 public slotSeconds = 600;
    uint256 public increaseFactorMicro; // 2500 for 0.25% (0.0025 * 1M)

    struct SoldInfo {
        address recipient;
        uint256 blocknumber;
        uint256 tokenId;
        bool presale;
        CS2PropertiesI.AssetType aType;
    }

    SoldInfo[] public soldSequence;
    uint256 public lastAssignedSequence;
    uint256 public lastRetrievedSequence;

    address[8] public tokenPools; // Pools for every AssetType as well as "normal" OCS and presale.
    uint256[8] public startIds;
    uint256[8] public tokenPoolSize;
    uint256[8] public unassignedInPool;
    uint256[2500][8] public tokenIdPools; // Max 2500 IDs per pool.

    bool internal _isOpen = true;

    enum ShippingStatus{
        Initial,
        Sold,
        ShippingSubmitted,
        ShippingConfirmed
    }

    mapping(uint256 => ShippingStatus) public deliveryStatus;

    event BasePriceChanged(uint256 previousBasePriceEurCent, uint256 newBasePriceEurCent);
    event PriceTargetTimeChanged(uint256 previousPriceTargetTimestamp, uint256 newPriceTargetTimestamp);
    event IncreaseFactorChanged(uint256 previousIncreaseFactorMicro, uint256 newIncreaseFactorMicro);
    event OracleChanged(address indexed previousOracle, address indexed newOracle);
    event BeneficiaryTransferred(address indexed previousBeneficiary, address indexed newBeneficiary);
    event TokenAssignmentControlTransferred(address indexed previousTokenAssignmentControl, address indexed newTokenAssignmentControl);
    event ShippingControlTransferred(address indexed previousShippingControl, address indexed newShippingControl);
    event ShopOpened();
    event ShopClosed();
    event AssetSold(address indexed buyer, address recipient, bool indexed presale, CS2PropertiesI.AssetType indexed aType, uint256 sequenceNumber, uint256 priceWei);
    event AssetAssigned(address indexed recipient, uint256 indexed tokenId, uint256 sequenceNumber);
    event AssignedAssetRetrieved(uint256 indexed tokenId, address indexed recipient);
    event ShippingSubmitted(address indexed owner, uint256[] tokenIds, string deliveryInfo);
    event ShippingFailed(address indexed owner, uint256 indexed tokenId, string reason);
    event ShippingConfirmed(address indexed owner, uint256 indexed tokenId);
    // ERC721 event - never emitted in this contract but helpful for running our tests.
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    // ERC1155 event - never emitted in this contract but helpful for running our tests.
    event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);

    constructor(OracleRequest _oracle,
        address _CS2Address,
        address _CS2PresaleAddress,
        uint256 _basePriceEurCent,
        uint256 _priceTargetTimestamp,
        uint256 _increaseFactorMicro,
        address payable _beneficiary,
        address _shippingControl,
        address _tokenAssignmentControl,
        uint256 _tokenPoolSize,
        address[] memory _tokenPools,
        uint256[] memory _startIds)
    public
    {
        oracle = _oracle;
        require(address(oracle) != address(0x0), "You need to provide an actual Oracle contract.");
        CS2 = CS2OCSBaseI(_CS2Address);
        require(address(CS2) != address(0x0), "You need to provide an actual Cryptostamp 2 contract.");
        CS2Presale = CS2PresaleRedeemI(_CS2PresaleAddress);
        require(address(CS2Presale) != address(0x0), "You need to provide an actual Cryptostamp 2 Presale contract.");
        beneficiary = _beneficiary;
        require(address(beneficiary) != address(0x0), "You need to provide an actual beneficiary address.");
        shippingControl = _shippingControl;
        require(address(shippingControl) != address(0x0), "You need to provide an actual shippingControl address.");
        tokenAssignmentControl = _tokenAssignmentControl;
        require(address(tokenAssignmentControl) != address(0x0), "You need to provide an actual tokenAssignmentControl address.");
        basePriceEurCent = _basePriceEurCent;
        require(basePriceEurCent > 0, "You need to provide a non-zero base price.");
        priceTargetTimestamp = _priceTargetTimestamp;
        require(priceTargetTimestamp > now, "You need to provide a price target time in the future.");
        increaseFactorMicro = _increaseFactorMicro;
        uint256 poolnum = tokenPools.length;
        require(_tokenPools.length == poolnum, "Need correct amount of token pool addresses.");
        require(_startIds.length == poolnum, "Need correct amount of token pool start IDs.");
        for (uint256 i = 0; i < poolnum; i++) {
            tokenPools[i] = _tokenPools[i];
            startIds[i] = _startIds[i];
            tokenPoolSize[i] = _tokenPoolSize;
        }
    }

    modifier onlyBeneficiary() {
        require(msg.sender == beneficiary, "Only the current benefinicary can call this function.");
        _;
    }

    modifier onlyShippingControl() {
        require(msg.sender == shippingControl, "shippingControl key required for this function.");
        _;
    }

    modifier onlyTokenAssignmentControl() {
        require(msg.sender == tokenAssignmentControl, "tokenAssignmentControl key required for this function.");
        _;
    }

    modifier requireOpen() {
        require(isOpen() == true, "This call only works when the shop is open.");
        _;
    }

    /*** Enable adjusting variables after deployment ***/

    function setBasePrice(uint256 _newBasePriceEurCent)
    public
    onlyBeneficiary
    {
        require(_newBasePriceEurCent > 0, "You need to provide a non-zero price.");
        emit BasePriceChanged(basePriceEurCent, _newBasePriceEurCent);
        basePriceEurCent = _newBasePriceEurCent;
    }

    function setPriceTargetTime(uint256 _newPriceTargetTimestamp)
    public
    onlyBeneficiary
    {
        require(_newPriceTargetTimestamp > now, "You need to provide a price target time in the future.");
        emit PriceTargetTimeChanged(priceTargetTimestamp, _newPriceTargetTimestamp);
        priceTargetTimestamp = _newPriceTargetTimestamp;
    }

    function setIncreaseFactor(uint256 _newIncreaseFactorMicro)
    public
    onlyBeneficiary
    {
        emit IncreaseFactorChanged(increaseFactorMicro, _newIncreaseFactorMicro);
        increaseFactorMicro = _newIncreaseFactorMicro;
    }

    function setOracle(OracleRequest _newOracle)
    public
    onlyBeneficiary
    {
        require(address(_newOracle) != address(0x0), "You need to provide an actual Oracle contract.");
        emit OracleChanged(address(oracle), address(_newOracle));
        oracle = _newOracle;
    }

    function transferBeneficiary(address payable _newBeneficiary)
    public
    onlyBeneficiary
    {
        require(_newBeneficiary != address(0), "beneficiary cannot be the zero address.");
        emit BeneficiaryTransferred(beneficiary, _newBeneficiary);
        beneficiary = _newBeneficiary;
    }

    function transferTokenAssignmentControl(address _newTokenAssignmentControl)
    public
    onlyTokenAssignmentControl
    {
        require(_newTokenAssignmentControl != address(0), "tokenAssignmentControl cannot be the zero address.");
        emit TokenAssignmentControlTransferred(tokenAssignmentControl, _newTokenAssignmentControl);
        tokenAssignmentControl = _newTokenAssignmentControl;
    }

    function transferShippingControl(address _newShippingControl)
    public
    onlyShippingControl
    {
        require(_newShippingControl != address(0), "shippingControl cannot be the zero address.");
        emit ShippingControlTransferred(shippingControl, _newShippingControl);
        shippingControl = _newShippingControl;
    }

    function openShop()
    public
    onlyBeneficiary
    {
        _isOpen = true;
        emit ShopOpened();
    }

    function closeShop()
    public
    onlyBeneficiary
    {
        _isOpen = false;
        emit ShopClosed();
    }

    /*** Actual on-chain shop functionality ***/

    // Return true if OCS is currently open for purchases.
    // This can have additional conditions to just the variable, e.g. actually having items to sell.
    function isOpen()
    public view
    returns (bool)
    {
        return _isOpen;
    }

    // Calculate dynamic asset price in EUR cent.
    function priceEurCent(CS2PropertiesI.AssetType _type)
    public view
    returns (uint256)
    {
        return priceEurCentDynamic(true, _type);
    }

    // Calculate fully dynamic asset price in EUR cent, without any capping for a time period.
    // If freezeSaleSlot is true, the price from the last sale stays frozen during its slot.
    // If that parameter if false, any sale will increase the price, even within the slot (used internally).
    function priceEurCentDynamic(bool freezeSaleSlot, CS2PropertiesI.AssetType _type)
    public view
    returns (uint256)
    {
        uint256 nowSlot = getTimeSlot(now);
        uint256 typeNum = uint256(_type);
        if (lastSaleTimestamp[typeNum] == 0 || nowSlot == 0) {
            // The first stamp as well as any after the target time are sold for the base price.
            return basePriceEurCent;
        }
        uint256 lastSaleSlot = getTimeSlot(lastSaleTimestamp[typeNum]);
        if (freezeSaleSlot) {
            // Keep price static within a time slot of slotSeconds (default 10 minutes).
            if (nowSlot == lastSaleSlot) {
                return lastSlotPriceEurCent[typeNum];
            }
        }
        // The price is increased by a fixed percentage compared to the last sale,
        // and decreased linearly towards the target timestamp and the base price.
        // NOTE that due to the precision in EUR cent, we never end up with fractal EUR cent values.
        uint256 priceIncrease = lastSalePriceEurCent[typeNum] * increaseFactorMicro / 1_000_000;
        // Decrease: current overpricing multiplied by how much of the time between last sale and target has already passed.
        // NOTE: *current* overpricing needs to take the increase into account first (otherwise it's overpricing of last sale)
        // NOTE: getTimeSlot already reports the number of slots remaining to the target.
        uint256 priceDecrease = (lastSalePriceEurCent[typeNum] + priceIncrease - basePriceEurCent) * (lastSaleSlot - nowSlot) / lastSaleSlot;
        return lastSalePriceEurCent[typeNum] + priceIncrease - priceDecrease;
    }

    // Get number of time slot. Slot numbers decrease towards the target timestamp, 0 is anything after that target.
    function getTimeSlot(uint256 _timestamp)
    public view
    returns (uint256)
    {
        if (_timestamp >= priceTargetTimestamp) {
            return 0;
        }
        return (priceTargetTimestamp - _timestamp) / slotSeconds + 1;
    }

    // Calculate current asset price in wei.
    // Note: Price in EUR cent is available from basePriceEurCent().
    function priceWei(CS2PropertiesI.AssetType _type)
    public view
    returns (uint256)
    {
        return priceEurCent(_type).mul(oracle.EUR_WEI()).div(100);
    }

    // Get the index of the pool for presale or normal OCS assets of the given type.
    function getPoolIndex(bool _isPresale, CS2PropertiesI.AssetType _type)
    public pure
    returns (uint256)
    {
        return (_isPresale ? 4 : 0) + uint256(_type);
    }

    // Returns the amount of assets of that type still available for sale.
    function availableForSale(bool _presale, CS2PropertiesI.AssetType _type)
    public view
    returns (uint256)
    {
        uint256 poolIndex = getPoolIndex(_presale, _type);
        return tokenPoolSize[poolIndex].sub(unassignedInPool[poolIndex]);
    }

    // Returns true if the asset of the given type is sold out.
    function isSoldOut(bool _presale, CS2PropertiesI.AssetType _type)
    public view
    returns (bool)
    {
        return availableForSale(_presale, _type) == 0;
    }

    // Buy assets of a single type/animal.
    // The number of assets as well as the recipient are explicitly given.
    // This will fail when the full amount cannot be provided or the payment is too little for that amount.
    // The recipient does not need to match the buyer, so the assets can be sent elsewhere (e.g. into a collection).
    // tokenData and merkleProofs are are collection of mint proofs to optimistically try for retrieving assigned assets.
    function buy(CS2PropertiesI.AssetType _type, uint256 _amount, address payable _recipient, bytes32[] memory tokenData, bytes32[] memory merkleProofsAggregated)
    public payable
    requireOpen
    {
        if (tokenData.length > 0) {
            mintAssetsWithAggregatedProofs(tokenData, merkleProofsAggregated);
        }
        bool isPresale = false;
        require(_amount <= availableForSale(isPresale, _type), "Not enough assets available to buy that amount.");
        uint256 curPriceWei = priceWei(_type);
        uint256 payAmount = _amount.mul(curPriceWei);
        require(msg.value >= payAmount, "You need to send enough currency to buy the specified amount.");
        uint256 typeNum = uint256(_type);
        if (lastSaleTimestamp[typeNum] == 0 || getTimeSlot(now) != getTimeSlot(lastSaleTimestamp[typeNum])) {
            // This is only called when priceEurCent() actually returns something different than the last slot price.
            lastSlotPriceEurCent[typeNum] = priceEurCent(_type);
        }
        // Transfer the actual payment amount to the beneficiary.
        // NOTE: We know this is no contract that causes re-entrancy as we own it.
        (bool sendSuccess, /*bytes memory data*/) = beneficiary.call{value: payAmount}("");
        if (!sendSuccess) { revert("Error in sending payment!"); }
        for (uint256 i = 0; i < _amount; i++) {
            // Assign a sequence number and store block and owner for it.
            soldSequence.push(SoldInfo(_recipient, block.number, 0, isPresale, _type));
            emit AssetSold(msg.sender, _recipient, isPresale, _type, soldSequence.length, curPriceWei);
            // Adjust lastSale parameters for every sale so per-sale increase is calculated correctly.
            lastSalePriceEurCent[typeNum] = priceEurCentDynamic(false, _type);
            lastSaleTimestamp[typeNum] = now;
        }
        uint256 poolIndex = getPoolIndex(isPresale, _type);
        unassignedInPool[poolIndex] = unassignedInPool[poolIndex].add(_amount);
        // Assign a max of one asset/token more than we purchased.
        assignPurchasedAssets(_amount + 1);
        // Try retrieving a max of one asset/token more than we purchased.
        retrieveAssignedAssets(_amount + 1);
        // Send back change money. Do this last as msg.sender could cause re-entrancy.
        if (msg.value > payAmount) {
            (bool returnSuccess, /*bytes memory data*/) = msg.sender.call{value: msg.value.sub(payAmount)}("");
            if (!returnSuccess) { revert("Error in returning change!"); }
        }
    }

    // Redeem presale vouchers for assets of a single type/animal.
    // The number of assets as well as the recipient are explicitly given.
    // This will fail when the full amount cannot be provided or the buyer has too few vouchers.
    // The recipient does not need to match the buyer, so the assets can be sent elsewhere (e.g. into a collection).
    // tokenData and merkleProofs are are collection of mint proofs to optimistically try for retrieving assigned assets.
    function redeemVoucher(CS2PropertiesI.AssetType _type, uint256 _amount, address payable _recipient, bytes32[] memory tokenData, bytes32[] memory merkleProofsAggregated)
    public
    requireOpen
    {
        if (tokenData.length > 0) {
            mintAssetsWithAggregatedProofs(tokenData, merkleProofsAggregated);
        }
        bool isPresale = true;
        require(_amount <= availableForSale(isPresale, _type), "Not enough assets available to buy that amount.");
        uint256 typeNum = uint256(_type);
        require(CS2Presale.balanceOf(msg.sender, typeNum) >= _amount, "You need to own enough presale vouchers to redeem the specified amount.");
        // Redeem the vouchers.
        CS2PresaleRedeemI.AssetType[] memory redeemTypes = new CS2PresaleRedeemI.AssetType[](1);
        uint256[] memory redeemAmounts = new uint256[](1);
        redeemTypes[0] = CS2PresaleRedeemI.AssetType(typeNum);
        redeemAmounts[0] = _amount;
        CS2Presale.redeemBatch(msg.sender, redeemTypes, redeemAmounts);
        //CS2Presale.redeemBatch(msg.sender, [_type], [_amount]);
        for (uint256 i = 0; i < _amount; i++) {
            // Assign a sequence number and store block and owner for it.
            soldSequence.push(SoldInfo(_recipient, block.number, 0, isPresale, _type));
            emit AssetSold(msg.sender, _recipient, isPresale, _type, soldSequence.length, 0);
        }
        uint256 poolIndex = getPoolIndex(isPresale, _type);
        unassignedInPool[poolIndex] = unassignedInPool[poolIndex].add(_amount);
        // Assign a max of one asset/token more than we purchased.
        assignPurchasedAssets(_amount + 1);
        // Try retrieving a max of one asset/token more than we purchased.
        retrieveAssignedAssets(_amount + 1);
    }

    // Get total amount of not-yet-assigned assets
    function getUnassignedAssetCount()
    public view
    returns (uint256)
    {
        return soldSequence.length - lastAssignedSequence;
    }

    // Get total amount of not-yet-retrieved assets
    function getUnretrievedAssetCount()
    public view
    returns (uint256)
    {
        return soldSequence.length - lastRetrievedSequence;
    }

    // Get total amount of sold assets
    function getSoldCount()
    public view
    returns (uint256)
    {
        return soldSequence.length;
    }

    // Get the token ID for any sold asset with the given sequence number.
    // As we do not know the block hash of the current block in Solidity, this can be given from the outside.
    // NOTE that when you hand in a wrong block hash, you will get wrong results!
    function getSoldTokenId(uint256 _sequenceNumber, bytes32 _currentBlockHash)
    public view
    returns (uint256)
    {
        if (_sequenceNumber <= lastAssignedSequence) {
            // We can return the ID directly from the soldSequence.
            uint256 seqIdx = _sequenceNumber.sub(1);
            return soldSequence[seqIdx].tokenId;
        }
        // For unassigned assets, get pool and slot and then a token ID from that.
        uint256 poolIndex;
        uint256 slotIndex;
        if (_sequenceNumber == lastAssignedSequence.add(1)) {
            (poolIndex, slotIndex) = _getNextUnassignedPoolSlot(_currentBlockHash);
        }
        else {
            (poolIndex, slotIndex) = _getUnassignedPoolSlotDeep(_sequenceNumber, _currentBlockHash);
        }
        return _getTokenIdForPoolSlot(poolIndex, slotIndex);
    }

    // Get the actual token ID for a pool slot, including the dance of resolving "0" IDs.
    function _getTokenIdForPoolSlot(uint256 _poolIndex, uint256 _slotIndex)
    internal view
    returns (uint256)
    {
        uint256 tokenId = tokenIdPools[_poolIndex][_slotIndex];
        if (tokenId == 0) {
            // We know we don't have token ID 0 in the pool, so we'll calculate the actual ID.
            tokenId = startIds[_poolIndex].add(_slotIndex);
        }
        return tokenId;
    }

    // Get a slot index for the given sequence index (not sequence number!) and pool size.
    function _getSemiRandomSlotIndex(uint256 seqIdx, uint256 poolSize, bytes32 _currentBlockHash)
    internal view
    returns (uint256)
    {
        // Get block hash. As this only works for the last 256 blocks, fall back to the empty keccak256 hash to keep getting stable results.
        bytes32 bhash;
        if (soldSequence[seqIdx].blocknumber == block.number) {
          require(_currentBlockHash != bytes32(""), "For assets sold in the current block, provide a valid block hash.");
          bhash = _currentBlockHash;
        }
        else if (block.number < 256 || soldSequence[seqIdx].blocknumber >= block.number.sub(256)) {
          bhash = blockhash(soldSequence[seqIdx].blocknumber);
        }
        else {
          bhash = keccak256("");
        }
        return uint256(keccak256(abi.encodePacked(seqIdx, bhash))) % poolSize;
    }

    // Get the pool and slot indexes for the next asset to assign, which is a pretty straight-forward case.
    function _getNextUnassignedPoolSlot(bytes32 _currentBlockHash)
    internal view
    returns (uint256, uint256)
    {
        uint256 seqIdx = lastAssignedSequence; // last + 1 is next seqNo, seqIdx is seqNo - 1
        uint256 poolIndex = getPoolIndex(soldSequence[seqIdx].presale, soldSequence[seqIdx].aType);
        uint256 slotIndex = _getSemiRandomSlotIndex(seqIdx, tokenPoolSize[poolIndex], _currentBlockHash);
        return (poolIndex, slotIndex);
    }

    // Get the pool and slot indexes for any asset that is still to be assigned.
    // This case is rather complicated as it needs to calculate which assets would be removed in sequence before this one.
    function _getUnassignedPoolSlotDeep(uint256 _sequenceNumber, bytes32 _currentBlockHash)
    internal view
    returns (uint256, uint256)
    {
        require(_sequenceNumber > lastAssignedSequence, "The asset was assigned already.");
        require(_sequenceNumber <= soldSequence.length, "Exceeds maximum sequence number.");
        uint256 depth = _sequenceNumber.sub(lastAssignedSequence);
        uint256[] memory poolIndex = new uint256[](depth);
        uint256[] memory slotIndex = new uint256[](depth);
        uint256[] memory slotRedirect = new uint256[](depth);
        uint256[] memory poolSizeReduction = new uint256[](tokenPoolSize.length);
        for (uint256 i = 0; i < depth; i++) {
            uint256 seqIdx = lastAssignedSequence.add(i); // last + 1 is next seqNo, seqIdx is seqNo - 1, then we add i
            poolIndex[i] = getPoolIndex(soldSequence[seqIdx].presale, soldSequence[seqIdx].aType);
            uint256 calcPoolSize = tokenPoolSize[poolIndex[i]].sub(poolSizeReduction[poolIndex[i]]);
            slotIndex[i] = _getSemiRandomSlotIndex(seqIdx, calcPoolSize, _currentBlockHash);
            // Resolve all fitting redirects - this is an O(2) loop!
            for (uint256 fitloop = 0; fitloop < i; fitloop++) {
                for (uint256 j = 0; j < i; j++) {
                    if (poolIndex[i] == poolIndex[j] && slotIndex[i] == slotIndex[j]) {
                        slotIndex[i] = slotRedirect[j];
                    }
                }
            }
            // Instead of actually shuffling the array, do a redirect dance.
            slotRedirect[i] = calcPoolSize.sub(1);
            poolSizeReduction[poolIndex[i]] = poolSizeReduction[poolIndex[i]].add(1);
        }
        return (poolIndex[depth.sub(1)], slotIndex[depth.sub(1)]);
    }

    // Assign _maxCount asset (or less if less are unassigned)
    function assignPurchasedAssets(uint256 _maxCount)
    public
    {
        for (uint256 i = 0; i < _maxCount; i++) {
            if (lastAssignedSequence < soldSequence.length) {
                _assignNextPurchasedAsset(false);
            }
        }
    }

    function assignNextPurchasedAssset()
    public
    {
        _assignNextPurchasedAsset(true);
    }

    function _assignNextPurchasedAsset(bool revertForSameBlock)
    internal
    {
        uint256 nextSequenceNumber = lastAssignedSequence.add(1);
        // Find the stamp to assign and transfer it.
        uint256 seqIdx = nextSequenceNumber.sub(1);
        if (soldSequence[seqIdx].blocknumber < block.number) {
            // Get tokenId in two steps as we need the slot index later.
            (uint256 poolIndex, uint256 slotIndex) = _getNextUnassignedPoolSlot(bytes32(""));
            uint256 tokenId = _getTokenIdForPoolSlot(poolIndex, slotIndex);
            soldSequence[seqIdx].tokenId = tokenId;
            emit AssetAssigned(soldSequence[seqIdx].recipient, tokenId, nextSequenceNumber);
            if (lastRetrievedSequence == lastAssignedSequence && CS2.exists(tokenId)) {
                // If the asset exists and retrieval is caught up, do retrieval right away.
                _retrieveAssignedAsset(seqIdx);
            }
            // Adjust the pool for the transferred asset.
            uint256 lastSlotIndex = tokenPoolSize[poolIndex].sub(1);
            if (slotIndex != lastSlotIndex) {
                // If the removed index is not the last, move the last one to the removed slot.
                uint256 lastValue = tokenIdPools[poolIndex][lastSlotIndex];
                if (lastValue == 0) {
                    // In case we still have a 0 here, set the correct tokenId instead.
                    lastValue = startIds[poolIndex] + lastSlotIndex;
                }
                tokenIdPools[poolIndex][slotIndex] = lastValue;
            }
            tokenPoolSize[poolIndex] = tokenPoolSize[poolIndex].sub(1);
            unassignedInPool[poolIndex] = unassignedInPool[poolIndex].sub(1);
            // Set delivery status for newly sold asset, and update lastAssigned.
            deliveryStatus[tokenId] = ShippingStatus.Sold;
            lastAssignedSequence = nextSequenceNumber;
        }
        else {
            if (revertForSameBlock) {
                revert("Cannot assign assets in the same block.");
            }
        }
    }

    // Retrieve multiple assets with mint proofs, if they match the next ones to retrieve.
    function mintAssetsWithAggregatedProofs(bytes32[] memory tokenData, bytes32[] memory merkleProofsAggregated)
    public
    {
        uint256 count = tokenData.length;
        require(count > 0, "Need actual data and proofs");
        require(merkleProofsAggregated.length % count == 0, "Count of data and proofs need to match");
        uint256 singleProofLength = merkleProofsAggregated.length / count;
        // Try to mint all given proofs.
        for (uint256 i = 0; i < count; i++) {
            uint256 tokenId = uint256(tokenData[i] >> 168); // shift by 20 bytes for address and 1 byte for properties
            if (!CS2.exists(tokenId)) {
                bytes32[] memory merkleProof = new bytes32[](singleProofLength);
                for (uint256 j = 0; j < singleProofLength; j++) {
                    merkleProof[j] = merkleProofsAggregated[singleProofLength.mul(i).add(j)];
                }
                CS2.createWithProof(tokenData[i], merkleProof);
            }
        }
    }

    function retrieveAssignedAssets(uint256 _maxCount)
    public
    {
        for (uint256 i = 0; i < _maxCount; i++) {
            if (lastRetrievedSequence < lastAssignedSequence) {
                uint256 seqIdx = lastRetrievedSequence; // last + 1 is next seqNo, seqIdx is seqNo - 1
                // Only retrieve an asset if the token actually exists.
                if (CS2.exists(soldSequence[seqIdx].tokenId)) {
                    _retrieveAssignedAsset(seqIdx);
                }
            }
        }
    }

    function _retrieveAssignedAsset(uint256 seqIdx)
    internal
    {
        uint256 poolIndex = getPoolIndex(soldSequence[seqIdx].presale, soldSequence[seqIdx].aType);
        require(CS2.ownerOf(soldSequence[seqIdx].tokenId) == tokenPools[poolIndex], "Already transferred out of the pool");
        // NOTE: We know CS2 is no contract that causes re-entrancy as it's our code.
        CS2.safeTransferFrom(tokenPools[poolIndex], soldSequence[seqIdx].recipient, soldSequence[seqIdx].tokenId);
        emit AssignedAssetRetrieved(soldSequence[seqIdx].tokenId, soldSequence[seqIdx].recipient);
        lastRetrievedSequence = seqIdx.add(1); // current SeqNo is SeqIdx + 1
    }

    /*** Handle physical shipping ***/

    // For token owner (after successful purchase): Request shipping.
    // _deliveryInfo is a postal address encrypted with a public key on the client side.
    function shipToMe(string memory _deliveryInfo, uint256[] memory _tokenIds)
    public
    requireOpen
    {
        uint256 count = _tokenIds.length;
        for (uint256 i = 0; i < count; i++) {
            require(CS2.ownerOf(_tokenIds[i]) == msg.sender, "You can only request shipping for your own tokens.");
            require(deliveryStatus[_tokenIds[i]] == ShippingStatus.Sold, "Shipping was already requested for one of these tokens or it was not sold by this shop.");
            deliveryStatus[_tokenIds[i]] = ShippingStatus.ShippingSubmitted;
        }
        emit ShippingSubmitted(msg.sender, _tokenIds, _deliveryInfo);
    }

    // For shipping service: Mark shipping as completed/confirmed.
    function confirmShipping(uint256[] memory _tokenIds)
    public
    onlyShippingControl
    {
        uint256 count = _tokenIds.length;
        for (uint256 i = 0; i < count; i++) {
            deliveryStatus[_tokenIds[i]] = ShippingStatus.ShippingConfirmed;
            emit ShippingConfirmed(CS2.ownerOf(_tokenIds[i]), _tokenIds[i]);
        }
    }

    // For shipping service: Mark shipping as failed/rejected (due to invalid address).
    function rejectShipping(uint256[] memory _tokenIds, string memory _reason)
    public
    onlyShippingControl
    {
        uint256 count = _tokenIds.length;
        for (uint256 i = 0; i < count; i++) {
            deliveryStatus[_tokenIds[i]] = ShippingStatus.Sold;
            emit ShippingFailed(CS2.ownerOf(_tokenIds[i]), _tokenIds[i], _reason);
        }
    }

    /*** Enable reverse ENS registration ***/

    // Call this with the address of the reverse registrar for the respecitve network and the ENS name to register.
    // The reverse registrar can be found as the owner of 'addr.reverse' in the ENS system.
    // For Mainnet, the address needed is 0x9062c0a6dbd6108336bcbe4593a3d1ce05512069
    function registerReverseENS(address _reverseRegistrarAddress, string calldata _name)
    external
    onlyTokenAssignmentControl
    {
        require(_reverseRegistrarAddress != address(0), "need a valid reverse registrar");
        ENSReverseRegistrarI(_reverseRegistrarAddress).setName(_name);
    }

    /*** Make sure currency or NFT doesn't get stranded in this contract ***/

    // If this contract gets a balance in some ERC20 contract after it's finished, then we can rescue it.
    function rescueToken(IERC20 _foreignToken, address _to)
    external
    onlyTokenAssignmentControl
    {
        _foreignToken.transfer(_to, _foreignToken.balanceOf(address(this)));
    }

    // If this contract gets a balance in some ERC721 contract after it's finished, then we can rescue it.
    function approveNFTrescue(IERC721 _foreignNFT, address _to)
    external
    onlyTokenAssignmentControl
    {
        _foreignNFT.setApprovalForAll(_to, true);
    }

}