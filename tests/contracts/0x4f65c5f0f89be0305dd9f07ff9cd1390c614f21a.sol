// File: contracts/ERC1155/enjin/Common.sol

pragma solidity 0.5.0;

/**
    Note: Simple contract to use as base for const vals
*/
contract CommonConstants {

    bytes4 constant internal ERC1155_ACCEPTED = 0xf23a6e61; // bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))
    bytes4 constant internal ERC1155_BATCH_ACCEPTED = 0xbc197c81; // bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))
}

// File: contracts/ERC1155/enjin/IEnjinERC1155.sol

pragma solidity 0.5.0;

interface IEnjinERC1155 {
  function acceptAssignment ( uint256 _id ) external;
  function assign ( uint256 _id, address _creator ) external;
  function balanceOf ( address _owner, uint256 _id ) external view returns ( uint256 );
  function balanceOfBatch ( address[] calldata _owners, uint256[] calldata _ids ) external view returns ( uint256[] memory);
  function create ( string calldata _name, uint256 _totalSupply, uint256 _initialReserve, address _supplyModel, uint256 _meltValue, uint16 _meltFeeRatio, uint8 _transferable, uint256[3] calldata _transferFeeSettings, bool _nonFungible ) external;
  function isApprovedForAll ( address _owner, address _operator ) external view returns ( bool );
  function melt ( uint256[] calldata _ids, uint256[] calldata _values ) external;
  function mintFungibles ( uint256 _id, address[] calldata _to, uint256[] calldata _values ) external;
  function mintNonFungibles ( uint256 _id, address[] calldata _to ) external;
  function safeBatchTransferFrom ( address _from, address _to, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data ) external;
  function safeTransferFrom ( address _from, address _to, uint256 _id, uint256 _value, bytes calldata _data ) external;
  function setApprovalForAll ( address _operator, bool _approved ) external;
  function setURI ( uint256 _id, string calldata _uri ) external;
  function supportsInterface ( bytes4 _interfaceID ) external pure returns ( bool );
  function uri ( uint256 _id ) external view returns ( string memory );
}

// File: contracts/ERC1155/enjin/IERC1155TokenReceiver.sol

pragma solidity 0.5.0;

/**
    Note: The ERC-165 identifier for this interface is 0x4e2312e0.
*/
interface ERC1155TokenReceiver {
    /**
        @notice Handle the receipt of a single ERC1155 token type.
        @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated.
        This function MUST return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` (i.e. 0xf23a6e61) if it accepts the transfer.
        This function MUST revert if it rejects the transfer.
        Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
        @param _operator  The address which initiated the transfer (i.e. msg.sender)
        @param _from      The address which previously owned the token
        @param _id        The ID of the token being transferred
        @param _value     The amount of tokens being transferred
        @param _data      Additional data with no specified format
        @return           `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
    */
    function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _value, bytes calldata _data) external returns(bytes4);

    /**
        @notice Handle the receipt of multiple ERC1155 token types.
        @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated.
        This function MUST return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` (i.e. 0xbc197c81) if it accepts the transfer(s).
        This function MUST revert if it rejects the transfer(s).
        Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
        @param _operator  The address which initiated the batch transfer (i.e. msg.sender)
        @param _from      The address which previously owned the token
        @param _ids       An array containing ids of each token being transferred (order and length must match _values array)
        @param _values    An array containing amounts of each token being transferred (order and length must match _ids array)
        @param _data      Additional data with no specified format
        @return           `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
    */
    function onERC1155BatchReceived(address _operator, address _from, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) external returns(bytes4);
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

// File: contracts/ERC721/el/forging/ForgeERC1155Operations.sol

pragma solidity 0.5.0;





contract ForgeERC1155Operations is ERC1155TokenReceiver, CommonConstants {

    // The Enjin ERC-1155 smart contract
    IEnjinERC1155 public enjinContract;

    // The Enjin Coin ERC-20 smart contract
    IERC20 public enjinCoinContract;

    function safeTransferFungibleItemWithOptionalMelt(uint256 tokenId, address recipient, bool melt) internal {
      bytes memory extraData = new bytes(0); 
      enjinContract.safeTransferFrom(msg.sender, melt ? address(this) : recipient, tokenId, 1, extraData);

      if(melt) {
        uint256 startingEnjinCoinBalance = enjinCoinContract.balanceOf(address(this));
        uint256[] memory ids = new uint256[](1);
        uint256[] memory values = new uint256[](1);
        ids[0] = tokenId;
        values[0] = 1;
        enjinContract.melt(ids, values);
        uint256 endingEnjinCoinBalance = enjinCoinContract.balanceOf(address(this));
        uint256 changeInEnjinCoinBalance = endingEnjinCoinBalance - startingEnjinCoinBalance;

        if(changeInEnjinCoinBalance > 0) {
          enjinCoinContract.transfer(msg.sender, changeInEnjinCoinBalance);
        }
      }
    }    

    function safeTransferNonFungibleItemWithOptionalMelt(uint256 tokenId, uint256 NFTIndex, address recipient, bool melt) internal {
      uint256[] memory nftIds = new uint256[](1);
      uint256[] memory values = new uint256[](1);
      nftIds[0] = tokenId | NFTIndex;
      values[0] = 1;

      bytes memory extraData = new bytes(0);
      enjinContract.safeBatchTransferFrom(msg.sender, melt ? address(this) : recipient, nftIds, values, extraData);

      if(melt) {
        uint256 startingEnjinCoinBalance = enjinCoinContract.balanceOf(address(this));
        enjinContract.melt(nftIds, values);
        uint256 endingEnjinCoinBalance = enjinCoinContract.balanceOf(address(this));
        uint256 changeInEnjinCoinBalance = endingEnjinCoinBalance - startingEnjinCoinBalance;

        if(changeInEnjinCoinBalance > 0) {
          enjinCoinContract.transfer(msg.sender, changeInEnjinCoinBalance);
        }        
      }      
    }        

    function onERC1155Received(address /*_operator*/, address /*_from*/, uint256 /*_id*/, uint256 /*_value*/, bytes calldata /*_data*/) external returns(bytes4) {
      return ERC1155_ACCEPTED;
    }

    function onERC1155BatchReceived(address /*_operator*/, address /*_from*/, uint256[] calldata /*_ids*/, uint256[] calldata /*_values*/, bytes calldata /*_data*/) external returns(bytes4) {        
      return ERC1155_BATCH_ACCEPTED;        
    }

    // ERC165 interface support
    function supportsInterface(bytes4 interfaceID) external pure returns (bool) {
        return  interfaceID == 0x01ffc9a7 ||    // ERC165
                interfaceID == 0x4e2312e0;      // ERC1155_ACCEPTED ^ ERC1155_BATCH_ACCEPTED;
    }
}

// File: contracts/ERC721/el/forging/IForgePathCatalogCombined.sol

pragma solidity 0.5.0;

interface IForgePathCatalogCombined {        
    function getNumberOfPathDefinitions() external view returns (uint256);
    function getForgePathNameAtIndex(uint256 index) external view returns (string memory);
    function getForgePathIdAtIndex(uint256 index) external view returns (uint256);

    function getForgeType(uint256 pathId) external view returns (uint8);
    function getForgePathDetailsCommon(uint256 pathId) external view returns (uint256, uint256, uint256);
    function getForgePathDetailsTwoGen1Tokens(uint256 pathId) external view returns (uint256, uint256, bool, bool);
    function getForgePathDetailsTwoERC721Addresses(uint256 pathId) external view returns (address, address);
    function getForgePathDetailsERC721AddressWithGen1Token(uint256 pathId) external view returns (address, uint256, bool);
    function getForgePathDetailsTwoERC1155Tokens(uint256 pathId) external view returns (uint256, uint256, bool, bool, bool, bool);
    function getForgePathDetailsERC1155WithGen1Token(uint256 pathId) external view returns (uint256, uint256, bool, bool, bool);
    function getForgePathDetailsERC1155WithERC721Address(uint256 pathId) external view returns (uint256, address, bool, bool);
}

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

// File: contracts/ERC721/el/forging/ForgeCombined.sol

pragma solidity 0.5.0;









contract ForgeCombined is ForgeERC1155Operations, Ownable, ReentrancyGuard {    

    // Address to which elementeum and ETH are transferred
    address public payee;    

    // Address to which non-melted items are transferred
    address public lootWallet;    

    // The forge catalog smart contract
    IForgePathCatalogCombined public catalogContract;    

    // The Elementeum ERC-20 token smart contract
    IERC20 public elementeumContract;

    // The Ether Legends Gen 1 ERC-721 token smart contract
    IEtherLegendsToken public etherLegendsGen1;    

    constructor() public 
      Ownable()
      ReentrancyGuard()
    {
      
    }    

    function() external payable {
        revert("Fallback function not permitted.");
    }

    function destroyContract() external {
      _requireOnlyOwner();
      address payable payableOwner = address(uint160(owner()));
      selfdestruct(payableOwner);
    }

    function setPayee(address addr) external {
      _requireOnlyOwner();
      payee = addr;
    }

    function setLootWallet(address addr) external {
      _requireOnlyOwner();
      lootWallet = addr;
    }

    function setCatalogContractAddress(address addr) external {
      _requireOnlyOwner();
      catalogContract = IForgePathCatalogCombined(addr);
    }

    function setElementeumERC20ContractAddress(address addr) external {
      _requireOnlyOwner();
      elementeumContract = IERC20(addr);
    }    

    function setEtherLegendsGen1(address addr) external {
      _requireOnlyOwner();
      etherLegendsGen1 = IEtherLegendsToken(addr);
    }  

    function setEnjinERC1155ContractAddress(address addr) external {
      _requireOnlyOwner();
      enjinContract = IEnjinERC1155(addr);
    }

    function setEnjinERC20ContractAddress(address addr) external {
      _requireOnlyOwner();
      enjinCoinContract = IERC20(addr);
    }

    function forge(uint256 pathId, uint256 material1TokenId, uint256 material2TokenId) external payable nonReentrant {
      _requireOnlyHuman();      

      uint8 forgeType = catalogContract.getForgeType(pathId);
      (uint256 weiCost, uint256 elementeumCost, uint256 forgedItem) = catalogContract.getForgePathDetailsCommon(pathId);

      require(msg.value >= weiCost, "Insufficient ETH");

      if(forgeType == 1) {
        require(material1TokenId != material2TokenId, "NFT ids must be unique");  
        (uint256 material1, 
         uint256 material2, 
         bool burnMaterial1, 
         bool burnMaterial2) = catalogContract.getForgePathDetailsTwoGen1Tokens(pathId);
         _forgeGen1Token(material1, material1TokenId, burnMaterial1);
         _forgeGen1Token(material2, material2TokenId, burnMaterial2);
      } else if(forgeType == 2) {
        (address material1, address material2) = catalogContract.getForgePathDetailsTwoERC721Addresses(pathId);
        if(material1 == material2) {
          require(material1TokenId != material2TokenId, "NFT ids must be unique");
        }
        _forgeERC721Token(material1, material1TokenId);
        _forgeERC721Token(material2, material2TokenId);
      } else if(forgeType == 3) {
        (address material1, 
         uint256 material2, 
         bool burnMaterial2) = catalogContract.getForgePathDetailsERC721AddressWithGen1Token(pathId);
         _forgeERC721Token(material1, material1TokenId);
         _forgeGen1Token(material2, material2TokenId, burnMaterial2);
      } else if(forgeType == 4) {
        (uint256 material1,
         uint256 material2,
         bool meltMaterial1,
         bool meltMaterial2,
         bool material1IsNonFungible,
         bool material2IsNonFungible) = catalogContract.getForgePathDetailsTwoERC1155Tokens(pathId);
        if(material1 == material2 && material1IsNonFungible && material2IsNonFungible) {
          require(material1TokenId != material2TokenId, "NFT ids must be unique");
        }
        _forgeERC1155Token(material1, material1TokenId, meltMaterial1, material1IsNonFungible);
        _forgeERC1155Token(material2, material2TokenId, meltMaterial2, material2IsNonFungible);
      } else if(forgeType == 5) {
        (uint256 material1,
         uint256 material2,
         bool meltMaterial1,
         bool burnMaterial2,
         bool material1IsNonFungible) = catalogContract.getForgePathDetailsERC1155WithGen1Token(pathId);
         _forgeERC1155Token(material1, material1TokenId, meltMaterial1, material1IsNonFungible);
         _forgeGen1Token(material2, material2TokenId, burnMaterial2);
      } else if(forgeType == 6) {
        (uint256 material1,
         address material2,
         bool meltMaterial1,
         bool material1IsNonFungible) = catalogContract.getForgePathDetailsERC1155WithERC721Address(pathId);
         _forgeERC1155Token(material1, material1TokenId, meltMaterial1, material1IsNonFungible);
         _forgeERC721Token(material2, material2TokenId);
      } else {
        revert("Non-existent forge type");
      }

      if(elementeumCost > 0) {
        elementeumContract.transferFrom(msg.sender, payee, elementeumCost);      
      }                    

      if(msg.value > 0) {                
        address payable payableWallet = address(uint160(payee));
        payableWallet.transfer(weiCost);

        uint256 change = msg.value - weiCost;
        if(change > 0) {
          msg.sender.transfer(change);
        }
      }

      etherLegendsGen1.mintTokenOfType(msg.sender, forgedItem);            
    }

    function _forgeGen1Token(uint256 material, uint256 tokenId, bool burnMaterial) internal {
      _verifyOwnershipAndApprovalERC721(address(etherLegendsGen1), tokenId);
      require(material == etherLegendsGen1.getTypeIdOfToken(tokenId), "Incorrect material type");
      burnMaterial ? etherLegendsGen1.burn(tokenId) : _safeTransferERC721(address(etherLegendsGen1), tokenId);
    } 

    function _forgeERC721Token(address material, uint256 tokenId) internal {
      _verifyOwnershipAndApprovalERC721(material, tokenId);
      _safeTransferERC721(material, tokenId);
    }       

    function _forgeERC1155Token(uint256 material, uint256 materialNFTIndex, bool meltMaterial, bool materialIsNonFungible) internal {
      require(enjinContract.isApprovedForAll(msg.sender, address(this)), "Not approved to spend user's ERC1155 tokens");      
      require(enjinContract.balanceOf(msg.sender, materialIsNonFungible ? ( material | materialNFTIndex ) : material) > 0, "Insufficient material balance");  
      materialIsNonFungible ? 
      safeTransferNonFungibleItemWithOptionalMelt(material, materialNFTIndex, lootWallet, meltMaterial) :
      safeTransferFungibleItemWithOptionalMelt(material, lootWallet, meltMaterial);
    }                 

    function _verifyOwnershipAndApprovalERC721(address tokenAddress, uint256 tokenId) internal view {
      IERC721Full tokenContract = IERC721Full(tokenAddress);
      require(tokenContract.ownerOf(tokenId) == msg.sender, "Token not owned by user");
      require(tokenContract.getApproved(tokenId) == address(this) || tokenContract.isApprovedForAll(msg.sender, address(this)), "Token not approved");      
    }    

    function _safeTransferERC721(address tokenAddress, uint256 tokenId) internal {
      IERC721Full tokenContract = IERC721Full(tokenAddress);
      tokenContract.safeTransferFrom(msg.sender, lootWallet, tokenId);
    }    

    function _requireOnlyOwner() internal view {
      require(isOwner(), "Ownable: caller is not the owner");
    }

    function _requireOnlyHuman() internal view {
      require(msg.sender == tx.origin, "Caller must be human user");
    }
}