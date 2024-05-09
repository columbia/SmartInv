// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

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
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
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
     *
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
     *
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
     *
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
     *
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
     *
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
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
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
     *
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
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

interface RMU {
    function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount, bytes calldata _data) external;
    function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _amounts, bytes calldata _data) external;
    function setApprovalForAll(address _operator, bool _approved) external;
    function isApprovedForAll(address _owner, address _operator) external view returns (bool isOperator);
    function balanceOf(address _owner, uint256 _id) external view returns (uint256);
}

interface Hope {
    function totalSupply() external view returns (uint256);
    function totalClaimed() external view returns (uint256);
    function addClaimed(uint256 _amount) external;
    function setClaimed(uint256 _amount) external;
    function transfer(address receiver, uint numTokens) external returns (bool);
    function transferFrom(address owner, address buyer, uint numTokens) external returns (bool);
    function balanceOf(address owner) external view returns (uint256);
    function mint(address _to, uint256 _amount) external;
    function burn(address _account, uint256 value) external;
}

interface HopeBooster {
    function getMultiplier(uint256 ropeAmount) external view returns (uint256);
    function getMultiplierOfAddress(address _addr) external view returns (uint256);
    function pendingHope(address _user) external view returns (uint256);
    function hopePerDayOfAddress(address _addr) external view returns (uint256);
    function addClaimed(uint256 _amount) external;
}

contract CardKeeper is Ownable {
    using SafeMath for uint256;

    struct CardSet {
        uint256[] cardIds;
        uint256 hopePerDayPerCard;
        uint256 bonusHopeMultiplier; // 100% bonus = 1e5
        bool isRemoved;
    }

    RMU public ropeMaker;
    Hope public hope;
    HopeBooster public hopeBooster;
    address public treasuryAddr;

    uint256[] public cardSetList;
    uint256 public highestCardId;
    mapping (uint256 => CardSet) public cardSets;
    mapping (uint256 => uint256) public cardToSetMap;

    mapping (address => mapping(uint256 => bool)) public userCards;
    mapping (address => uint256) public userLastUpdate;

    event Stake(address indexed user, uint256[] cardIds);
    event Unstake(address indexed user, uint256[] cardIds);
    event Harvest(address indexed user, uint256 amount);

    constructor(RMU _ropeMakerAddr, Hope _hopeAddr, HopeBooster _hopeBoosterAddr, address _treasuryAddr) public {
        ropeMaker = _ropeMakerAddr;
        hope = _hopeAddr;
        hopeBooster = _hopeBoosterAddr;
        treasuryAddr = _treasuryAddr;
    }

    // Utility function to check if a value is inside an array
    function _isInArray(uint256 _value, uint256[] memory _array) internal pure returns(bool) {
        uint256 length = _array.length;
        for (uint256 i = 0; i < length; ++i) {
            if (_array[i] == _value) {
                return true;
            }
        }

        return false;
    }

    // Index of the value in the return array is the cardId, value is whether card is staked or not
    function getCardsStakedOfAddress(address _user) public view returns(bool[] memory) {
        bool[] memory cardsStaked = new bool[](highestCardId + 1);

        for (uint256 i = 0; i < highestCardId + 1; ++i) {
            cardsStaked[i] = userCards[_user][i];
        }

        return cardsStaked;
    }

    // Returns the list of cardIds which are part of a set
    function getCardIdListOfSet(uint256 _setId) external view returns(uint256[] memory) {
        return cardSets[_setId].cardIds;
    }

    function getFullSetsOfAddress(address _user) public view returns(bool[] memory) {
        uint256 length = cardSetList.length;

        bool[] memory isFullSet = new bool[](length);
        for (uint256 i = 0; i < length; ++i) {
            uint256 setId = cardSetList[i];

            if (cardSets[setId].isRemoved) {
                isFullSet[i] = false;
                continue;
            }

            bool _fullSet = true;

            uint256[] memory _cardIds = cardSets[setId].cardIds;
            for (uint256 j = 0; j < _cardIds.length; ++j) {
                if (userCards[_user][_cardIds[j]] == false) {
                    _fullSet = false;
                    break;
                }
            }

            isFullSet[i] = _fullSet;
        }

        return isFullSet;
    }

    // Returns the amount of nft staked by an address for a given set
    function getNbSetNftStakedOfAddress(address _user, uint256 _setId) public view returns(uint256) {
        uint256 nbStaked = 0;

        if (cardSets[_setId].isRemoved) return 0;

        uint256 length = cardSets[_setId].cardIds.length;
        for (uint256 j = 0; j < length; ++j) {
            uint256 cardId = cardSets[_setId].cardIds[j];
            if (userCards[_user][cardId] == true) {
                nbStaked = nbStaked.add(1);
            }
        }

        return nbStaked;
    }

    // Returns the total amount of nft staked by an address across all sets
    function getNbNftStakedOfAddress(address _user) public view returns(uint256) {
        uint256 nbStaked = 0;

        for (uint256 i = 0; i < cardSetList.length; ++i) {
            nbStaked = nbStaked.add(getNbSetNftStakedOfAddress(_user, cardSetList[i]));
        }

        return nbStaked;
    }


    // Returns the total hope pending for a given address
    // Can include the bonus from hopeBooster or not
    function totalPendingHopeOfAddress(address _user, bool _includeHopeBooster) public view returns (uint256) {
        uint256 totalHopePerDay = 0;

        uint256 length = cardSetList.length;
        for (uint256 i = 0; i < length; ++i) {
            uint256 setId = cardSetList[i];
            CardSet storage set = cardSets[setId];

            if (set.isRemoved) continue;

            // bool isFullSet = fullSets[i];

            uint256 cardLength = set.cardIds.length;

            bool isFullSet = true;
            uint256 setHopePerDay = 0;
            for (uint256 j = 0; j < cardLength; ++j) {
                if (userCards[_user][set.cardIds[j]] == false) {
                    isFullSet = false;
                    continue;
                }

                setHopePerDay = setHopePerDay.add(set.hopePerDayPerCard);
            }

            if (isFullSet) {
                setHopePerDay = setHopePerDay.mul(set.bonusHopeMultiplier).div(1e5);
            }

            totalHopePerDay = totalHopePerDay.add(setHopePerDay);
        }

        // Apply hopeBooster bonus
        if (_includeHopeBooster) {
            uint256 toAdd = totalHopePerDay.mul(hopeBooster.getMultiplierOfAddress(_user)).div(1e5);
            totalHopePerDay = totalHopePerDay.add(toAdd);
        }

        uint256 lastUpdate = userLastUpdate[_user];
        uint256 blockTime = block.timestamp;
        return blockTime.sub(lastUpdate).mul(totalHopePerDay.div(86400));
    }

    // Returns the pending hope coming from the bonus generated by HopeBooster
    function totalPendingHopeOfAddressFromBooster(address _user) external view returns (uint256) {
        uint256 totalPending = totalPendingHopeOfAddress(_user, false);
        return totalPending.mul(hopeBooster.getMultiplierOfAddress(_user)).div(1e5);
    }

    //////////////////////////////
    //////////////////////////////
    //////////////////////////////

    // Set manually the highestCardId, in case there has been a mistake while adding a set
    // (This value is used to know the range in which iterate to get the list of staked cards for an address)
    function setHighestCardId(uint256 _highestId) public onlyOwner {
        require(_highestId > 0);
        highestCardId = _highestId;
    }

    function addCardSet(uint256 _setId, uint256[] memory _cardIds, uint256 _bonusHopeMultiplier, uint256 _hopePerDayPerCard) public onlyOwner {
        removeCardSet(_setId);

        uint256 length = _cardIds.length;
        for (uint256 i = 0; i < length; ++i) {
            uint256 cardId = _cardIds[i];

            if (cardId > highestCardId) {
                highestCardId = cardId;
            }

            // Check all cards to assign arent already part of another set
            require(cardToSetMap[cardId] == 0, "Card already assigned to a set");

            // Assign to set
            cardToSetMap[cardId] = _setId;
        }

        if (_isInArray(_setId, cardSetList) == false) {
            cardSetList.push(_setId);
        }

        cardSets[_setId] = CardSet({
        cardIds: _cardIds,
        bonusHopeMultiplier: _bonusHopeMultiplier,
        hopePerDayPerCard: _hopePerDayPerCard,
        isRemoved: false
        });
    }

    // Set the hopePerDayPerCard value for a list of sets
    function setHopeRateOfSets(uint256[] memory _setIds, uint256[] memory _hopePerDayPerCard) public onlyOwner {
        require(_setIds.length == _hopePerDayPerCard.length, "_setId and _hopePerDayPerCard have different length");

        for (uint256 i = 0; i < _setIds.length; ++i) {
            require(cardSets[_setIds[i]].cardIds.length > 0, "Set is empty");
            cardSets[_setIds[i]].hopePerDayPerCard = _hopePerDayPerCard[i];
        }
    }

    // Set the bonusHopeMultiplier value for a list of sets
    function setBonusHopeMultiplierOfSets(uint256[] memory _setIds, uint256[] memory _bonusHopeMultiplier) public onlyOwner {
        require(_setIds.length == _bonusHopeMultiplier.length, "_setId and _hopePerDayPerCard have different length");

        for (uint256 i = 0; i < _setIds.length; ++i) {
            require(cardSets[_setIds[i]].cardIds.length > 0, "Set is empty");
            cardSets[_setIds[i]].bonusHopeMultiplier = _bonusHopeMultiplier[i];
        }
    }

    function removeCardSet(uint256 _setId) public onlyOwner {
        uint256 length = cardSets[_setId].cardIds.length;
        for (uint256 i = 0; i < length; ++i) {
            uint256 cardId = cardSets[_setId].cardIds[i];
            cardToSetMap[cardId] = 0;
        }

        delete cardSets[_setId].cardIds;
        cardSets[_setId].isRemoved = true;
    }

    function harvest() public {
        uint256 pendingHope = totalPendingHopeOfAddress(msg.sender, true);
        userLastUpdate[msg.sender] = block.timestamp;

        if (pendingHope > 0) {
            hope.mint(treasuryAddr, pendingHope.div(40)); // 2.5% HOPE for the treasury (Usable to purchase NFTs)
            hope.mint(msg.sender, pendingHope);
            hope.addClaimed(pendingHope);
        }

        emit Harvest(msg.sender, pendingHope);
    }

    function stake(uint256[] memory _cardIds) public {
        require(_cardIds.length > 0, "_cardIds array empty");

        harvest();

        // Check no card will end up above max stake
        uint256 length = _cardIds.length;
        for (uint256 i = 0; i < length; ++i) {
            uint256 cardId = _cardIds[i];
            require(userCards[msg.sender][cardId] == false, "Card already staked");
            require(cardToSetMap[cardId] != 0, "Card is not part of any set");
        }

        // 1 of each card
        uint256[] memory amounts = new uint256[](_cardIds.length);
        for (uint256 i = 0; i < _cardIds.length; ++i) {
            amounts[i] = 1;
        }

        ropeMaker.safeBatchTransferFrom(msg.sender, address(this), _cardIds, amounts, "");

        for (uint256 i = 0; i < length; ++i) {
            uint256 cardId = _cardIds[i];

            userCards[msg.sender][cardId] = true;
        }

        emit Stake(msg.sender, _cardIds);
    }

    function unstake(uint256[] memory _cardIds) public {
        require(_cardIds.length > 0, "_cardIds array empty");

        harvest();

        uint256 length = _cardIds.length;
        for (uint256 i = 0; i < length; ++i) {
            uint256 cardId = _cardIds[i];

            require(userCards[msg.sender][cardId] == true, "Card not staked");
            userCards[msg.sender][cardId] = false;
        }

        // 1 of each card
        uint256[] memory amounts = new uint256[](_cardIds.length);
        for (uint256 i = 0; i < _cardIds.length; ++i) {
            amounts[i] = 1;
        }

        ropeMaker.safeBatchTransferFrom(address(this), msg.sender, _cardIds, amounts, "");

        emit Unstake(msg.sender, _cardIds);
    }

    // Withdraw without rewards
    function emergencyUnstake(uint256[] memory _cardIds) public {
        userLastUpdate[msg.sender] = block.timestamp;

        uint256 length = _cardIds.length;
        for (uint256 i = 0; i < length; ++i) {
            uint256 cardId = _cardIds[i];

            require(userCards[msg.sender][cardId] == true, "Card not staked");
            userCards[msg.sender][cardId] = false;
        }

        // 1 of each card
        uint256[] memory amounts = new uint256[](_cardIds.length);
        for (uint256 i = 0; i < _cardIds.length; ++i) {
            amounts[i] = 1;
        }

        ropeMaker.safeBatchTransferFrom(address(this), msg.sender, _cardIds, amounts, "");
    }

    // Update treasury address by the previous treasury.
    function treasury(address _treasuryAddr) public {
        require(msg.sender == treasuryAddr, "Must be called from current treasury address");
        treasuryAddr = _treasuryAddr;
    }

    /////////
    /////////
    /////////

    /**
     * @notice Handle the receipt of a single ERC1155 token type
     * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated
     * This function MAY throw to revert and reject the transfer
     * Return of other amount than the magic value MUST result in the transaction being reverted
     * Note: The token contract address is always the message sender
     * @param _operator  The address which called the `safeTransferFrom` function
     * @param _from      The address which previously owned the token
     * @param _id        The id of the token being transferred
     * @param _amount    The amount of tokens being transferred
     * @param _data      Additional data with no specified format
     * @return           `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
     */
    function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _amount, bytes calldata _data) external returns(bytes4) {
        return 0xf23a6e61;
    }

    /**
     * @notice Handle the receipt of multiple ERC1155 token types
     * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated
     * This function MAY throw to revert and reject the transfer
     * Return of other amount than the magic value WILL result in the transaction being reverted
     * Note: The token contract address is always the message sender
     * @param _operator  The address which called the `safeBatchTransferFrom` function
     * @param _from      The address which previously owned the token
     * @param _ids       An array containing ids of each token being transferred
     * @param _amounts   An array containing amounts of each token being transferred
     * @param _data      Additional data with no specified format
     * @return           `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
     */
    function onERC1155BatchReceived(address _operator, address _from, uint256[] calldata _ids, uint256[] calldata _amounts, bytes calldata _data) external returns(bytes4) {
        return 0xbc197c81;
    }

    /**
     * @notice Indicates whether a contract implements the `ERC1155TokenReceiver` functions and so can accept ERC1155 token types.
     * @param  interfaceID The ERC-165 interface ID that is queried for support.s
     * @dev This function MUST return true if it implements the ERC1155TokenReceiver interface and ERC-165 interface.
     *      This function MUST NOT consume more than 5,000 gas.
     * @return Wheter ERC-165 or ERC1155TokenReceiver interfaces are supported.
     */
    function supportsInterface(bytes4 interfaceID) external view returns (bool) {
        return  interfaceID == 0x01ffc9a7 ||    // ERC-165 support (i.e. `bytes4(keccak256('supportsInterface(bytes4)'))`).
        interfaceID == 0x4e2312e0;      // ERC-1155 `ERC1155TokenReceiver` support (i.e. `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)")) ^ bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`).
    }
}