// File: contracts/ERC721/el/IBurnableEtherLegendsToken.sol

pragma solidity 0.5.0;

interface IBurnableEtherLegendsToken {        
    function burn(uint256 tokenId) external;
}

// File: contracts/ERC721/el/IMintableEtherLegendsToken.sol

pragma solidity 0.5.0;

interface IMintableEtherLegendsToken {        
    function mintTokenOfType(address to, uint256 idOfTokenType) external;
}

// File: contracts/ERC721/el/ITokenDefinitionManager.sol

pragma solidity 0.5.0;

interface ITokenDefinitionManager {        
    function getNumberOfTokenDefinitions() external view returns (uint256);
    function hasTokenDefinition(uint256 tokenTypeId) external view returns (bool);
    function getTokenTypeNameAtIndex(uint256 index) external view returns (string memory);
    function getTokenTypeName(uint256 tokenTypeId) external view returns (string memory);
    function getTokenTypeId(string calldata name) external view returns (uint256);
    function getCap(uint256 tokenTypeId) external view returns (uint256);
    function getAbbreviation(uint256 tokenTypeId) external view returns (string memory);
}

// File: openzeppelin-solidity/contracts/introspection/IERC165.sol

pragma solidity ^0.5.0;

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * [EIP](https://eips.ethereum.org/EIPS/eip-165).
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others (`ERC165Checker`).
 *
 * For an implementation, see `ERC165`.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

// File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol

pragma solidity ^0.5.0;


/**
 * @dev Required interface of an ERC721 compliant contract.
 */
contract IERC721 is IERC165 {
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of NFTs in `owner`'s account.
     */
    function balanceOf(address owner) public view returns (uint256 balance);

    /**
     * @dev Returns the owner of the NFT specified by `tokenId`.
     */
    function ownerOf(uint256 tokenId) public view returns (address owner);

    /**
     * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
     * another (`to`).
     *
     * 
     *
     * Requirements:
     * - `from`, `to` cannot be zero.
     * - `tokenId` must be owned by `from`.
     * - If the caller is not `from`, it must be have been allowed to move this
     * NFT by either `approve` or `setApproveForAll`.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId) public;
    /**
     * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
     * another (`to`).
     *
     * Requirements:
     * - If the caller is not `from`, it must be approved to move this NFT by
     * either `approve` or `setApproveForAll`.
     */
    function transferFrom(address from, address to, uint256 tokenId) public;
    function approve(address to, uint256 tokenId) public;
    function getApproved(uint256 tokenId) public view returns (address operator);

    function setApprovalForAll(address operator, bool _approved) public;
    function isApprovedForAll(address owner, address operator) public view returns (bool);


    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
}

// File: openzeppelin-solidity/contracts/token/ERC721/IERC721Enumerable.sol

pragma solidity ^0.5.0;


/**
 * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
 * @dev See https://eips.ethereum.org/EIPS/eip-721
 */
contract IERC721Enumerable is IERC721 {
    function totalSupply() public view returns (uint256);
    function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);

    function tokenByIndex(uint256 index) public view returns (uint256);
}

// File: openzeppelin-solidity/contracts/token/ERC721/IERC721Metadata.sol

pragma solidity ^0.5.0;


/**
 * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
 * @dev See https://eips.ethereum.org/EIPS/eip-721
 */
contract IERC721Metadata is IERC721 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function tokenURI(uint256 tokenId) external view returns (string memory);
}

// File: openzeppelin-solidity/contracts/token/ERC721/IERC721Full.sol

pragma solidity ^0.5.0;




/**
 * @title ERC-721 Non-Fungible Token Standard, full implementation interface
 * @dev See https://eips.ethereum.org/EIPS/eip-721
 */
contract IERC721Full is IERC721, IERC721Enumerable, IERC721Metadata {
    // solhint-disable-previous-line no-empty-blocks
}

// File: contracts/ERC721/el/IEtherLegendsToken.sol

pragma solidity 0.5.0;





contract IEtherLegendsToken is IERC721Full, IMintableEtherLegendsToken, IBurnableEtherLegendsToken, ITokenDefinitionManager {
    function totalSupplyOfType(uint256 tokenTypeId) external view returns (uint256);
    function getTypeIdOfToken(uint256 tokenId) external view returns (uint256);
}

// File: contracts/ERC721/el/IBoosterPack.sol

pragma solidity 0.5.0;

interface IBoosterPack {        
    function getNumberOfCards() external view returns (uint256);
    function getCardTypeIdAtIndex(uint256 index) external view returns (uint256);
    function getPricePerCard() external view returns (uint256);
}

// File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol

pragma solidity ^0.5.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see `ERC20Detailed`.
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
     * Emits a `Transfer` event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through `transferFrom`. This is
     * zero by default.
     *
     * This value changes when `approve` or `transferFrom` are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * > Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an `Approval` event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a `Transfer` event.
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
     * a call to `approve`. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: openzeppelin-solidity/contracts/ownership/Ownable.sol

pragma solidity ^0.5.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be aplied to your functions to restrict their use to
 * the owner.
 */
contract Ownable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Returns true if the caller is the current owner.
     */
    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * > Note: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

// File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol

pragma solidity ^0.5.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
 * available, which can be aplied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 */
contract ReentrancyGuard {
    /// @dev counter to allow mutex lock with only one SSTORE operation
    uint256 private _guardCounter;

    constructor () internal {
        // The counter starts at one to prevent changing it from zero to a non-zero
        // value, which is a more expensive operation.
        _guardCounter = 1;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _guardCounter += 1;
        uint256 localCounter = _guardCounter;
        _;
        require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
    }
}

// File: contracts/ERC721/el/BoosterPack.sol

pragma solidity 0.5.0;






contract BoosterPack is IBoosterPack, Ownable, ReentrancyGuard {

  // Address where funds are collected
  address public payee;

  // Address where elementeum funds are payed to users from
  address public funder;

  // Address that is permitted to call destroyContract
  address public permittedDestroyer;

  // ETH price per card
  uint256 public pricePerCard = 50 finney;

  uint256[] public cardTypeIds;
  uint16 private totalWeight;
  mapping (uint16 => uint256) private rollToCard;
  mapping (uint256 => uint256) private cardToElementeumReturned;
  bytes32 private lastHash;

  IEtherLegendsToken public etherLegendsToken;
  IERC20 public elementeumToken;

  constructor(address payeeWallet, address funderWallet) public 
    Ownable() 
    ReentrancyGuard() {
    payee = payeeWallet;
    funder = funderWallet;
    lastHash = keccak256(abi.encodePacked(block.number));
  }

  /**
   * @dev fallback function ***DO NOT OVERRIDE***
   */
  function () external payable {
    purchaseCards(msg.sender);
  }

  function destroyContract() external {
    require(msg.sender == permittedDestroyer, "caller is not the permitted destroyer - should be address of BoosterPackFactory");
    address payable payableOwner = address(uint160(owner()));
    selfdestruct(payableOwner);
  }

  function setEtherLegendsToken(address addr) external {
    _requireOnlyOwner();
    etherLegendsToken = IEtherLegendsToken(addr);
  }  

  function setElementeumERC20ContractAddress(address addr) external {
    _requireOnlyOwner();
    elementeumToken = IERC20(addr);
  }    

  function setPricePerCard(uint256 price) public {
    _requireOnlyOwner();
    pricePerCard = price;
  }

  function permitDestruction(address addr) external {
    _requireOnlyOwner();
    require(addr != address(0));
    permittedDestroyer = addr;
  }

  function setDropWeights(uint256[] calldata tokenTypeIds, uint8[] calldata weights, uint256[] calldata elementeumsReturned) external {
    _requireOnlyOwner();
    require(
      tokenTypeIds.length > 0 && 
      tokenTypeIds.length == weights.length && 
      tokenTypeIds.length == elementeumsReturned.length, 
      "array lengths are not the same");

    for(uint256 i = 0; i < tokenTypeIds.length; i++) {
      setDropWeight(tokenTypeIds[i], weights[i], elementeumsReturned[i]);
    }    
  }

  function setDropWeight(uint256 tokenTypeId, uint8 weight, uint256 elementeumReturned) public {
    _requireOnlyOwner();    
    require(etherLegendsToken.hasTokenDefinition(tokenTypeId), "card is not defined");
    totalWeight += weight;
    for(uint16 i = totalWeight - weight; i < totalWeight; i++) {
      rollToCard[i] = tokenTypeId;
    }
    cardToElementeumReturned[tokenTypeId] = elementeumReturned;
    cardTypeIds.push(tokenTypeId);
  }

  function getNumberOfCards() external view returns (uint256) {
    return cardTypeIds.length;
  }

  function getCardTypeIdAtIndex(uint256 index) external view returns (uint256) {
    require(index < cardTypeIds.length, "Index Out Of Range");
    return cardTypeIds[index];
  }

  function getPricePerCard() external view returns (uint256) {
    return pricePerCard;
  }

  function getCardTypeIds() external view returns (uint256[] memory) {
    return cardTypeIds;
  }  

  function purchaseCards(address beneficiary) public payable nonReentrant {
    require(msg.sender == tx.origin, "caller must be transaction origin (only human)");    
    require(msg.value >= pricePerCard, "purchase price not met");
    require(pricePerCard > 0, "price per card must be greater than 0");
    require(totalWeight > 0, "total weight must be greater than 0");

    uint256 numberOfCards = _min(msg.value / pricePerCard, (gasleft() - 100000) / 200000);
    uint256 totalElementeumToReturn = 0;
    bytes32 tempLastHash =  lastHash;    
    for(uint256 i = 0; i < numberOfCards; i++) {
        tempLastHash = keccak256(abi.encodePacked(block.number, tempLastHash, msg.sender, gasleft()));
        uint16 randNumber = uint16(uint256(tempLastHash) % (totalWeight));        
        uint256 cardType = rollToCard[randNumber];

        etherLegendsToken.mintTokenOfType(beneficiary, cardType);        
        totalElementeumToReturn += cardToElementeumReturned[cardType];                
    }

    lastHash = tempLastHash; // Save in the blockchain for next tx
    
    if(totalElementeumToReturn > 0) {
      uint256 elementeumThatCanBeReturned = _min(totalElementeumToReturn, _min(elementeumToken.allowance(funder, address(this)), elementeumToken.balanceOf(funder)));
      if(elementeumThatCanBeReturned > 0) {
        elementeumToken.transferFrom(funder, beneficiary, elementeumThatCanBeReturned);      
      }            
    }

    uint256 change = msg.value - (pricePerCard * numberOfCards); //This amount to be refunded as it was unused
    address payable payableWallet = address(uint160(payee));
    payableWallet.transfer(pricePerCard  * numberOfCards);
    if(change > 0) {
      msg.sender.transfer(change);
    }
  }

  function _min(uint256 a, uint256 b) internal pure returns (uint256) {
    return a < b ? a : b;
  }  

  function _requireOnlyOwner() internal view {
    require(isOwner(), "Ownable: caller is not the owner");
  }
}