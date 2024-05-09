pragma solidity 0.5.12;
pragma experimental ABIEncoderV2;
// File: @airswap/types/contracts/Types.sol
/*
  Copyright 2020 Swap Holdings Ltd.
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
*/
/**
  * @title Types: Library of Swap Protocol Types and Hashes
  */
library Types {
  bytes constant internal EIP191_HEADER = "\x19\x01";
  struct Order {
    uint256 nonce;                // Unique per order and should be sequential
    uint256 expiry;               // Expiry in seconds since 1 January 1970
    Party signer;                 // Party to the trade that sets terms
    Party sender;                 // Party to the trade that accepts terms
    Party affiliate;              // Party compensated for facilitating (optional)
    Signature signature;          // Signature of the order
  }
  struct Party {
    bytes4 kind;                  // Interface ID of the token
    address wallet;               // Wallet address of the party
    address token;                // Contract address of the token
    uint256 amount;               // Amount for ERC-20 or ERC-1155
    uint256 id;                   // ID for ERC-721 or ERC-1155
  }
  struct Signature {
    address signatory;            // Address of the wallet used to sign
    address validator;            // Address of the intended swap contract
    bytes1 version;               // EIP-191 signature version
    uint8 v;                      // `v` value of an ECDSA signature
    bytes32 r;                    // `r` value of an ECDSA signature
    bytes32 s;                    // `s` value of an ECDSA signature
  }
  bytes32 constant internal DOMAIN_TYPEHASH = keccak256(abi.encodePacked(
    "EIP712Domain(",
    "string name,",
    "string version,",
    "address verifyingContract",
    ")"
  ));
  bytes32 constant internal ORDER_TYPEHASH = keccak256(abi.encodePacked(
    "Order(",
    "uint256 nonce,",
    "uint256 expiry,",
    "Party signer,",
    "Party sender,",
    "Party affiliate",
    ")",
    "Party(",
    "bytes4 kind,",
    "address wallet,",
    "address token,",
    "uint256 amount,",
    "uint256 id",
    ")"
  ));
  bytes32 constant internal PARTY_TYPEHASH = keccak256(abi.encodePacked(
    "Party(",
    "bytes4 kind,",
    "address wallet,",
    "address token,",
    "uint256 amount,",
    "uint256 id",
    ")"
  ));
  /**
    * @notice Hash an order into bytes32
    * @dev EIP-191 header and domain separator included
    * @param order Order The order to be hashed
    * @param domainSeparator bytes32
    * @return bytes32 A keccak256 abi.encodePacked value
    */
  function hashOrder(
    Order calldata order,
    bytes32 domainSeparator
  ) external pure returns (bytes32) {
    return keccak256(abi.encodePacked(
      EIP191_HEADER,
      domainSeparator,
      keccak256(abi.encode(
        ORDER_TYPEHASH,
        order.nonce,
        order.expiry,
        keccak256(abi.encode(
          PARTY_TYPEHASH,
          order.signer.kind,
          order.signer.wallet,
          order.signer.token,
          order.signer.amount,
          order.signer.id
        )),
        keccak256(abi.encode(
          PARTY_TYPEHASH,
          order.sender.kind,
          order.sender.wallet,
          order.sender.token,
          order.sender.amount,
          order.sender.id
        )),
        keccak256(abi.encode(
          PARTY_TYPEHASH,
          order.affiliate.kind,
          order.affiliate.wallet,
          order.affiliate.token,
          order.affiliate.amount,
          order.affiliate.id
        ))
      ))
    ));
  }
  /**
    * @notice Hash domain parameters into bytes32
    * @dev Used for signature validation (EIP-712)
    * @param name bytes
    * @param version bytes
    * @param verifyingContract address
    * @return bytes32 returns a keccak256 abi.encodePacked value
    */
  function hashDomain(
    bytes calldata name,
    bytes calldata version,
    address verifyingContract
  ) external pure returns (bytes32) {
    return keccak256(abi.encode(
      DOMAIN_TYPEHASH,
      keccak256(name),
      keccak256(version),
      verifyingContract
    ));
  }
}
// File: @airswap/delegate/contracts/interfaces/IDelegate.sol
/*
  Copyright 2020 Swap Holdings Ltd.
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
*/
interface IDelegate {
  struct Rule {
    uint256 maxSenderAmount;      // The maximum amount of ERC-20 token the delegate would send
    uint256 priceCoef;            // Number to be multiplied by 10^(-priceExp) - the price coefficient
    uint256 priceExp;             // Indicates location of the decimal priceCoef * 10^(-priceExp)
  }
  event SetRule(
    address indexed owner,
    address indexed senderToken,
    address indexed signerToken,
    uint256 maxSenderAmount,
    uint256 priceCoef,
    uint256 priceExp
  );
  event UnsetRule(
    address indexed owner,
    address indexed senderToken,
    address indexed signerToken
  );
  event ProvideOrder(
    address indexed owner,
    address tradeWallet,
    address indexed senderToken,
    address indexed signerToken,
    uint256 senderAmount,
    uint256 priceCoef,
    uint256 priceExp
  );
  function setRule(
    address senderToken,
    address signerToken,
    uint256 maxSenderAmount,
    uint256 priceCoef,
    uint256 priceExp
  ) external;
  function unsetRule(
    address senderToken,
    address signerToken
  ) external;
  function provideOrder(
    Types.Order calldata order
  ) external;
  function rules(address, address) external view returns (Rule memory);
  function getSignerSideQuote(
    uint256 senderAmount,
    address senderToken,
    address signerToken
  ) external view returns (
    uint256 signerAmount
  );
  function getSenderSideQuote(
    uint256 signerAmount,
    address signerToken,
    address senderToken
  ) external view returns (
    uint256 senderAmount
  );
  function getMaxQuote(
    address senderToken,
    address signerToken
  ) external view returns (
    uint256 senderAmount,
    uint256 signerAmount
  );
  function owner()
    external view returns (address);
  function tradeWallet()
    external view returns (address);
}
// File: @airswap/indexer/contracts/interfaces/IIndexer.sol
/*
  Copyright 2020 Swap Holdings Ltd.
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
*/
interface IIndexer {
  event CreateIndex(
    address indexed signerToken,
    address indexed senderToken,
    bytes2 protocol,
    address indexAddress
  );
  event Stake(
    address indexed staker,
    address indexed signerToken,
    address indexed senderToken,
    bytes2 protocol,
    uint256 stakeAmount
  );
  event Unstake(
    address indexed staker,
    address indexed signerToken,
    address indexed senderToken,
    bytes2 protocol,
    uint256 stakeAmount
  );
  event AddTokenToBlacklist(
    address token
  );
  event RemoveTokenFromBlacklist(
    address token
  );
  function setLocatorWhitelist(
    bytes2 protocol,
    address newLocatorWhitelist
  ) external;
  function createIndex(
    address signerToken,
    address senderToken,
    bytes2 protocol
  ) external returns (address);
  function addTokenToBlacklist(
    address token
  ) external;
  function removeTokenFromBlacklist(
    address token
  ) external;
  function setIntent(
    address signerToken,
    address senderToken,
    bytes2 protocol,
    uint256 stakingAmount,
    bytes32 locator
  ) external;
  function unsetIntent(
    address signerToken,
    address senderToken,
    bytes2 protocol
  ) external;
  function stakingToken() external view returns (address);
  function indexes(address, address, bytes2) external view returns (address);
  function tokenBlacklist(address) external view returns (bool);
  function getStakedAmount(
    address user,
    address signerToken,
    address senderToken,
    bytes2 protocol
  ) external view returns (uint256);
  function getLocators(
    address signerToken,
    address senderToken,
    bytes2 protocol,
    address cursor,
    uint256 limit
  ) external view returns (
    bytes32[] memory,
    uint256[] memory,
    address
  );
}
// File: @airswap/transfers/contracts/interfaces/ITransferHandler.sol
/*
  Copyright 2020 Swap Holdings Ltd.
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
*/
/**
  * @title ITransferHandler: interface for token transfers
  */
interface ITransferHandler {
 /**
  * @notice Function to wrap token transfer for different token types
  * @param from address Wallet address to transfer from
  * @param to address Wallet address to transfer to
  * @param amount uint256 Amount for ERC-20
  * @param id token ID for ERC-721
  * @param token address Contract address of token
  * @return bool on success of the token transfer
  */
  function transferTokens(
    address from,
    address to,
    uint256 amount,
    uint256 id,
    address token
  ) external returns (bool);
}
// File: openzeppelin-solidity/contracts/GSN/Context.sol
/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
contract Context {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
    constructor () internal { }
    // solhint-disable-previous-line no-empty-blocks
    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }
    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}
// File: openzeppelin-solidity/contracts/ownership/Ownable.sol
/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Context {
    address private _owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        _owner = _msgSender();
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
        return _msgSender() == _owner;
    }
    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
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
// File: @airswap/transfers/contracts/TransferHandlerRegistry.sol
/*
  Copyright 2020 Swap Holdings Ltd.
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
*/
/**
  * @title TransferHandlerRegistry: holds registry of contract to
  * facilitate token transfers
  */
contract TransferHandlerRegistry is Ownable {
  event AddTransferHandler(
    bytes4 kind,
    address contractAddress
  );
  // Mapping of bytes4 to contract interface type
  mapping (bytes4 => ITransferHandler) public transferHandlers;
  /**
  * @notice Adds handler to mapping
  * @param kind bytes4 Key value that defines a token type
  * @param transferHandler ITransferHandler
  */
  function addTransferHandler(bytes4 kind, ITransferHandler transferHandler)
    external onlyOwner {
      require(address(transferHandlers[kind]) == address(0), "HANDLER_EXISTS_FOR_KIND");
      transferHandlers[kind] = transferHandler;
      emit AddTransferHandler(kind, address(transferHandler));
    }
}
// File: @airswap/swap/contracts/interfaces/ISwap.sol
/*
  Copyright 2020 Swap Holdings Ltd.
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
*/
interface ISwap {
  event Swap(
    uint256 indexed nonce,
    uint256 timestamp,
    address indexed signerWallet,
    uint256 signerAmount,
    uint256 signerId,
    address signerToken,
    address indexed senderWallet,
    uint256 senderAmount,
    uint256 senderId,
    address senderToken,
    address affiliateWallet,
    uint256 affiliateAmount,
    uint256 affiliateId,
    address affiliateToken
  );
  event Cancel(
    uint256 indexed nonce,
    address indexed signerWallet
  );
  event CancelUpTo(
    uint256 indexed nonce,
    address indexed signerWallet
  );
  event AuthorizeSender(
    address indexed authorizerAddress,
    address indexed authorizedSender
  );
  event AuthorizeSigner(
    address indexed authorizerAddress,
    address indexed authorizedSigner
  );
  event RevokeSender(
    address indexed authorizerAddress,
    address indexed revokedSender
  );
  event RevokeSigner(
    address indexed authorizerAddress,
    address indexed revokedSigner
  );
  /**
    * @notice Atomic Token Swap
    * @param order Types.Order
    */
  function swap(
    Types.Order calldata order
  ) external;
  /**
    * @notice Cancel one or more open orders by nonce
    * @param nonces uint256[]
    */
  function cancel(
    uint256[] calldata nonces
  ) external;
  /**
    * @notice Cancels all orders below a nonce value
    * @dev These orders can be made active by reducing the minimum nonce
    * @param minimumNonce uint256
    */
  function cancelUpTo(
    uint256 minimumNonce
  ) external;
  /**
    * @notice Authorize a delegated sender
    * @param authorizedSender address
    */
  function authorizeSender(
    address authorizedSender
  ) external;
  /**
    * @notice Authorize a delegated signer
    * @param authorizedSigner address
    */
  function authorizeSigner(
    address authorizedSigner
  ) external;
  /**
    * @notice Revoke an authorization
    * @param authorizedSender address
    */
  function revokeSender(
    address authorizedSender
  ) external;
  /**
    * @notice Revoke an authorization
    * @param authorizedSigner address
    */
  function revokeSigner(
    address authorizedSigner
  ) external;
  function senderAuthorizations(address, address) external view returns (bool);
  function signerAuthorizations(address, address) external view returns (bool);
  function signerNonceStatus(address, uint256) external view returns (byte);
  function signerMinimumNonce(address) external view returns (uint256);
  function registry() external view returns (TransferHandlerRegistry);
}
// File: openzeppelin-solidity/contracts/math/SafeMath.sol
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
     *
     * _Available since v2.4.0._
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
     *
     * _Available since v2.4.0._
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
     *
     * _Available since v2.4.0._
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}
// File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
/**
 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see {ERC20Detailed}.
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
// File: contracts/Delegate.sol
/*
  Copyright 2020 Swap Holdings Ltd.
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
*/
/**
  * @title Delegate: Deployable Trading Rules for the AirSwap Network
  * @notice Supports fungible tokens (ERC-20)
  * @dev inherits IDelegate, Ownable uses SafeMath library
  */
contract Delegate is IDelegate, Ownable {
  using SafeMath for uint256;
  // The Swap contract to be used to settle trades
  ISwap public swapContract;
  // The Indexer to stake intent to trade on
  IIndexer public indexer;
  // Maximum integer for token transfer approval
  uint256 constant internal MAX_INT =  2**256 - 1;
  // Address holding tokens that will be trading through this delegate
  address public tradeWallet;
  // Mapping of senderToken to signerToken for rule lookup
  mapping (address => mapping (address => Rule)) public rules;
  // ERC-20 (fungible token) interface identifier (ERC-165)
  bytes4 constant internal ERC20_INTERFACE_ID = 0x36372b07;
  // The protocol identifier for setting intents on an Index
  bytes2 public protocol;
  /**
    * @notice Contract Constructor
    * @dev owner defaults to msg.sender if delegateContractOwner is provided as address(0)
    * @param delegateSwap address Swap contract the delegate will deploy with
    * @param delegateIndexer address Indexer contract the delegate will deploy with
    * @param delegateContractOwner address Owner of the delegate
    * @param delegateTradeWallet address Wallet the delegate will trade from
    * @param delegateProtocol bytes2 The protocol identifier for Delegate contracts
    */
  constructor(
    ISwap delegateSwap,
    IIndexer delegateIndexer,
    address delegateContractOwner,
    address delegateTradeWallet,
    bytes2 delegateProtocol
  ) public {
    swapContract = delegateSwap;
    indexer = delegateIndexer;
    protocol = delegateProtocol;
    // If no delegate owner is provided, the deploying address is the owner.
    if (delegateContractOwner != address(0)) {
      transferOwnership(delegateContractOwner);
    }
    // If no trade wallet is provided, the owner's wallet is the trade wallet.
    if (delegateTradeWallet != address(0)) {
      tradeWallet = delegateTradeWallet;
    } else {
      tradeWallet = owner();
    }
    // Ensure that the indexer can pull funds from delegate account.
    require(
      IERC20(indexer.stakingToken())
      .approve(address(indexer), MAX_INT), "STAKING_APPROVAL_FAILED"
    );
  }
  /**
    * @notice Set a Trading Rule
    * @dev only callable by the owner of the contract
    * @dev 1 senderToken = priceCoef * 10^(-priceExp) * signerToken
    * @param senderToken address Address of an ERC-20 token the delegate would send
    * @param signerToken address Address of an ERC-20 token the consumer would send
    * @param maxSenderAmount uint256 Maximum amount of ERC-20 token the delegate would send
    * @param priceCoef uint256 Whole number that will be multiplied by 10^(-priceExp) - the price coefficient
    * @param priceExp uint256 Exponent of the price to indicate location of the decimal priceCoef * 10^(-priceExp)
    */
  function setRule(
    address senderToken,
    address signerToken,
    uint256 maxSenderAmount,
    uint256 priceCoef,
    uint256 priceExp
  ) external onlyOwner {
    _setRule(
      senderToken,
      signerToken,
      maxSenderAmount,
      priceCoef,
      priceExp
    );
  }
  /**
    * @notice Unset a Trading Rule
    * @dev only callable by the owner of the contract, removes from a mapping
    * @param senderToken address Address of an ERC-20 token the delegate would send
    * @param signerToken address Address of an ERC-20 token the consumer would send
    */
  function unsetRule(
    address senderToken,
    address signerToken
  ) external onlyOwner {
    _unsetRule(
      senderToken,
      signerToken
    );
  }
  /**
    * @notice sets a rule on the delegate and an intent on the indexer
    * @dev only callable by owner
    * @dev delegate needs to be given allowance from msg.sender for the newStakeAmount
    * @dev swap needs to be given permission to move funds from the delegate
    * @param senderToken address Token the delgeate will send
    * @param signerToken address Token the delegate will receive
    * @param rule Rule Rule to set on a delegate
    * @param newStakeAmount uint256 Amount to stake for an intent
    */
  function setRuleAndIntent(
    address senderToken,
    address signerToken,
    Rule calldata rule,
    uint256 newStakeAmount
  ) external onlyOwner {
    _setRule(
      senderToken,
      signerToken,
      rule.maxSenderAmount,
      rule.priceCoef,
      rule.priceExp
    );
    // get currentAmount staked or 0 if never staked
    uint256 oldStakeAmount = indexer.getStakedAmount(address(this), signerToken, senderToken, protocol);
    if (oldStakeAmount == newStakeAmount && oldStakeAmount > 0) {
      return; // forgo trying to reset intent with non-zero same stake amount
    } else if (oldStakeAmount < newStakeAmount) {
      // transfer only the difference from the sender to the Delegate.
      require(
        IERC20(indexer.stakingToken())
        .transferFrom(msg.sender, address(this), newStakeAmount - oldStakeAmount), "STAKING_TRANSFER_FAILED"
      );
    }
    indexer.setIntent(
      signerToken,
      senderToken,
      protocol,
      newStakeAmount,
      bytes32(uint256(address(this)) << 96) //NOTE: this will pad 0's to the right
    );
    if (oldStakeAmount > newStakeAmount) {
      // return excess stake back
      require(
        IERC20(indexer.stakingToken())
        .transfer(msg.sender, oldStakeAmount - newStakeAmount), "STAKING_RETURN_FAILED"
      );
    }
  }
  /**
    * @notice unsets a rule on the delegate and removes an intent on the indexer
    * @dev only callable by owner
    * @param senderToken address Maker token in the token pair for rules and intents
    * @param signerToken address Taker token  in the token pair for rules and intents
    */
  function unsetRuleAndIntent(
    address senderToken,
    address signerToken
  ) external onlyOwner {
    _unsetRule(senderToken, signerToken);
    // Query the indexer for the amount staked.
    uint256 stakedAmount = indexer.getStakedAmount(address(this), signerToken, senderToken, protocol);
    indexer.unsetIntent(signerToken, senderToken, protocol);
    // Upon unstaking, the Delegate will be given the staking amount.
    // This is returned to the msg.sender.
    if (stakedAmount > 0) {
      require(
        IERC20(indexer.stakingToken())
          .transfer(msg.sender, stakedAmount),"STAKING_RETURN_FAILED"
      );
    }
  }
  /**
    * @notice Provide an Order
    * @dev Rules get reset with new maxSenderAmount
    * @param order Types.Order Order a user wants to submit to Swap.
    */
  function provideOrder(
    Types.Order calldata order
  ) external {
    Rule memory rule = rules[order.sender.token][order.signer.token];
    require(order.signature.v != 0,
      "SIGNATURE_MUST_BE_SENT");
    // Ensure the order is for the trade wallet.
    require(order.sender.wallet == tradeWallet,
      "SENDER_WALLET_INVALID");
    // Ensure the tokens are valid ERC20 tokens.
    require(order.signer.kind == ERC20_INTERFACE_ID,
      "SIGNER_KIND_MUST_BE_ERC20");
    require(order.sender.kind == ERC20_INTERFACE_ID,
      "SENDER_KIND_MUST_BE_ERC20");
    // Ensure that a rule exists.
    require(rule.maxSenderAmount != 0,
      "TOKEN_PAIR_INACTIVE");
    // Ensure the order does not exceed the maximum amount.
    require(order.sender.amount <= rule.maxSenderAmount,
      "AMOUNT_EXCEEDS_MAX");
    // Ensure the order is priced according to the rule.
    require(order.sender.amount <= _calculateSenderAmount(order.signer.amount, rule.priceCoef, rule.priceExp),
      "PRICE_INVALID");
    // Overwrite the rule with a decremented maxSenderAmount.
    rules[order.sender.token][order.signer.token] = Rule({
      maxSenderAmount: (rule.maxSenderAmount).sub(order.sender.amount),
      priceCoef: rule.priceCoef,
      priceExp: rule.priceExp
    });
    // Perform the swap.
    swapContract.swap(order);
    emit ProvideOrder(
      owner(),
      tradeWallet,
      order.sender.token,
      order.signer.token,
      order.sender.amount,
      rule.priceCoef,
      rule.priceExp
    );
  }
  /**
    * @notice Set a new trade wallet
    * @param newTradeWallet address Address of the new trade wallet
    */
  function setTradeWallet(address newTradeWallet) external onlyOwner {
    require(newTradeWallet != address(0), "TRADE_WALLET_REQUIRED");
    tradeWallet = newTradeWallet;
  }
  /**
    * @notice Get a Signer-Side Quote from the Delegate
    * @param senderAmount uint256 Amount of ERC-20 token the delegate would send
    * @param senderToken address Address of an ERC-20 token the delegate would send
    * @param signerToken address Address of an ERC-20 token the consumer would send
    * @return uint256 signerAmount Amount of ERC-20 token the consumer would send
    */
  function getSignerSideQuote(
    uint256 senderAmount,
    address senderToken,
    address signerToken
  ) external view returns (
    uint256 signerAmount
  ) {
    Rule memory rule = rules[senderToken][signerToken];
    // Ensure that a rule exists.
    if(rule.maxSenderAmount > 0) {
      // Ensure the senderAmount does not exceed maximum for the rule.
      if(senderAmount <= rule.maxSenderAmount) {
        signerAmount = _calculateSignerAmount(senderAmount, rule.priceCoef, rule.priceExp);
        // Return the quote.
        return signerAmount;
      }
    }
    return 0;
  }
  /**
    * @notice Get a Sender-Side Quote from the Delegate
    * @param signerAmount uint256 Amount of ERC-20 token the consumer would send
    * @param signerToken address Address of an ERC-20 token the consumer would send
    * @param senderToken address Address of an ERC-20 token the delegate would send
    * @return uint256 senderAmount Amount of ERC-20 token the delegate would send
    */
  function getSenderSideQuote(
    uint256 signerAmount,
    address signerToken,
    address senderToken
  ) external view returns (
    uint256 senderAmount
  ) {
    Rule memory rule = rules[senderToken][signerToken];
    // Ensure that a rule exists.
    if(rule.maxSenderAmount > 0) {
      // Calculate the senderAmount.
      senderAmount = _calculateSenderAmount(signerAmount, rule.priceCoef, rule.priceExp);
      // Ensure the senderAmount does not exceed the maximum trade amount.
      if(senderAmount <= rule.maxSenderAmount) {
        return senderAmount;
      }
    }
    return 0;
  }
  /**
    * @notice Get a Maximum Quote from the Delegate
    * @param senderToken address Address of an ERC-20 token the delegate would send
    * @param signerToken address Address of an ERC-20 token the consumer would send
    * @return uint256 senderAmount Amount the delegate would send
    * @return uint256 signerAmount Amount the consumer would send
    */
  function getMaxQuote(
    address senderToken,
    address signerToken
  ) external view returns (
    uint256 senderAmount,
    uint256 signerAmount
  ) {
    Rule memory rule = rules[senderToken][signerToken];
    senderAmount = rule.maxSenderAmount;
    // Ensure that a rule exists.
    if (senderAmount > 0) {
      // calculate the signerAmount
      signerAmount = _calculateSignerAmount(senderAmount, rule.priceCoef, rule.priceExp);
      // Return the maxSenderAmount and calculated signerAmount.
      return (
        senderAmount,
        signerAmount
      );
    }
    return (0, 0);
  }
  /**
    * @notice Set a Trading Rule
    * @dev only callable by the owner of the contract
    * @dev 1 senderToken = priceCoef * 10^(-priceExp) * signerToken
    * @param senderToken address Address of an ERC-20 token the delegate would send
    * @param signerToken address Address of an ERC-20 token the consumer would send
    * @param maxSenderAmount uint256 Maximum amount of ERC-20 token the delegate would send
    * @param priceCoef uint256 Whole number that will be multiplied by 10^(-priceExp) - the price coefficient
    * @param priceExp uint256 Exponent of the price to indicate location of the decimal priceCoef * 10^(-priceExp)
    */
  function _setRule(
    address senderToken,
    address signerToken,
    uint256 maxSenderAmount,
    uint256 priceCoef,
    uint256 priceExp
  ) internal {
    require(priceCoef > 0, "PRICE_COEF_INVALID");
    rules[senderToken][signerToken] = Rule({
      maxSenderAmount: maxSenderAmount,
      priceCoef: priceCoef,
      priceExp: priceExp
    });
    emit SetRule(
      owner(),
      senderToken,
      signerToken,
      maxSenderAmount,
      priceCoef,
      priceExp
    );
  }
  /**
    * @notice Unset a Trading Rule
    * @param senderToken address Address of an ERC-20 token the delegate would send
    * @param signerToken address Address of an ERC-20 token the consumer would send
    */
  function _unsetRule(
    address senderToken,
    address signerToken
  ) internal {
    // using non-zero rule.priceCoef for rule existence check
    if (rules[senderToken][signerToken].priceCoef > 0) {
      // Delete the rule.
      delete rules[senderToken][signerToken];
      emit UnsetRule(
        owner(),
        senderToken,
        signerToken
    );
    }
  }
  /**
    * @notice Calculate the signer amount for a given sender amount and price
    * @param senderAmount uint256 The amount the delegate would send in the swap
    * @param priceCoef uint256 Coefficient of the token price defined in the rule
    * @param priceExp uint256 Exponent of the token price defined in the rule
    */
  function _calculateSignerAmount(
    uint256 senderAmount,
    uint256 priceCoef,
    uint256 priceExp
  ) internal pure returns (
    uint256 signerAmount
  ) {
    // Calculate the signer amount using the price formula
    uint256 multiplier = senderAmount.mul(priceCoef);
    signerAmount = multiplier.div(10 ** priceExp);
    // If the div rounded down, round up
    if (multiplier.mod(10 ** priceExp) > 0) {
      signerAmount++;
    }
  }
  /**
    * @notice Calculate the sender amount for a given signer amount and price
    * @param signerAmount uint256 The amount the signer would send in the swap
    * @param priceCoef uint256 Coefficient of the token price defined in the rule
    * @param priceExp uint256 Exponent of the token price defined in the rule
    */
  function _calculateSenderAmount(
    uint256 signerAmount,
    uint256 priceCoef,
    uint256 priceExp
  ) internal pure returns (
    uint256 senderAmount
  ) {
    // Calculate the sender anount using the price formula
    senderAmount = signerAmount
      .mul(10 ** priceExp)
      .div(priceCoef);
  }
}
// File: contracts/interfaces/IDelegateFactory.sol
/*
  Copyright 2020 Swap Holdings Ltd.
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
*/
interface IDelegateFactory {
  event CreateDelegate(
    address indexed delegateContract,
    address swapContract,
    address indexerContract,
    address indexed delegateContractOwner,
    address delegateTradeWallet
  );
  /**
    * @notice Deploy a trusted delegate contract
    * @param delegateTradeWallet the wallet the delegate will trade from
    * @return delegateContractAddress address of the delegate contract created
    */
  function createDelegate(
    address delegateTradeWallet
  ) external returns (address delegateContractAddress);
}
// File: @airswap/indexer/contracts/interfaces/ILocatorWhitelist.sol
/*
  Copyright 2020 Swap Holdings Ltd.
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
*/
interface ILocatorWhitelist {
  function has(
    bytes32 locator
  ) external view returns (bool);
}
// File: contracts/DelegateFactory.sol
/*
  Copyright 2020 Swap Holdings Ltd.
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
*/
contract DelegateFactory is IDelegateFactory, ILocatorWhitelist {
  // Mapping specifying whether an address was deployed by this factory
  mapping(address => bool) internal _deployedAddresses;
  // The swap and indexer contracts to use in the deployment of Delegates
  ISwap public swapContract;
  IIndexer public indexerContract;
  bytes2 public protocol;
  /**
    * @notice Create a new Delegate contract
    * @dev swapContract is unable to be changed after the factory sets it
    * @param factorySwapContract address Swap contract the delegate will deploy with
    * @param factoryIndexerContract address Indexer contract the delegate will deploy with
    * @param factoryProtocol bytes2 Protocol type of the delegates the factory deploys
    */
  constructor(
    ISwap factorySwapContract,
    IIndexer factoryIndexerContract,
    bytes2 factoryProtocol
  ) public {
    swapContract = factorySwapContract;
    indexerContract = factoryIndexerContract;
    protocol = factoryProtocol;
  }
  /**
    * @param delegateTradeWallet address Wallet the delegate will trade from
    * @return address delegateContractAddress Address of the delegate contract created
    */
  function createDelegate(
    address delegateTradeWallet
  ) external returns (address delegateContractAddress) {
    delegateContractAddress = address(
      new Delegate(swapContract, indexerContract, msg.sender, delegateTradeWallet, protocol)
    );
    _deployedAddresses[delegateContractAddress] = true;
    emit CreateDelegate(
      delegateContractAddress,
      address(swapContract),
      address(indexerContract),
      msg.sender,
      delegateTradeWallet
    );
    return delegateContractAddress;
  }
  /**
    * @notice To check whether a locator was deployed
    * @dev Implements ILocatorWhitelist.has
    * @param locator bytes32 Locator of the delegate in question
    * @return bool True if the delegate was deployed by this contract
    */
  function has(bytes32 locator) external view returns (bool) {
    return _deployedAddresses[address(bytes20(locator))];
  }
}
