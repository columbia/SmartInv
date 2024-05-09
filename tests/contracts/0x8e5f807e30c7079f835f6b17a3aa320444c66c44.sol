// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

/*
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
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

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
    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

// CAUTION
// This version of SafeMath should only be used with Solidity 0.8 or later,
// because it relies on the compiler's built in overflow checks.

/**
 * @dev Wrappers over Solidity's arithmetic operations.
 *
 * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
 * now has built in overflow checking.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
            // benefit is lost if 'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

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
        return a + b;
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
        return a - b;
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
        return a * b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator.
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
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
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
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
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
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
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}

interface Etheria{
	function getOwner(uint8 col, uint8 row) external view returns(address);
	function setOwner(uint8 col, uint8 row, address newowner) external;
}

interface MapElevationRetriever{
    function getElevation(uint8 col, uint8 row) external view returns (uint8);
}

contract EtheriaExchangeV1pt2 is Ownable {
 	using SafeMath for uint256;

	string public name = "EtheriaExchangeV1pt2";

	Etheria public constant etheria = Etheria(0xB21f8684f23Dbb1008508B4DE91a0aaEDEbdB7E4);
	MapElevationRetriever public constant mapElevationRetriever = MapElevationRetriever(0x68549D7Dbb7A956f955Ec1263F55494f05972A6b);

	uint256 public feeRate = 25; // 2.5%, max 5%
	uint256 public withdrawalPenaltyRate = 1; // 0.1%, max 5%
	uint256 public collectedFees = 0;
	uint16 public constant mapSize = 33;

    struct Bid {
        address bidder;
		uint256 amount;
    }

    // A record of the highest Etheria bid
    mapping (uint16 => Bid) public bids;
	mapping (address => uint256) public pendingWithdrawals;

    event EtheriaBidCreated(uint16 indexed index, address indexed bidder, uint256 indexed amount);
    event EtheriaGlobalBidCreated(address indexed bidder, uint256 indexed amount);
    event EtheriaBidWithdrawn(uint16 indexed index, address indexed bidder, uint256 indexed amount);
    event EtheriaBidAccepted(uint16 indexed index, address indexed seller, address indexed bidder, uint256 amount);
    event EtheriaGlobalBidAccepted(uint16 indexed index, address indexed seller, address indexed bidder, uint256 amount);

    constructor() {
    }
    
	function collectFees() external onlyOwner {
		payable(msg.sender).transfer(collectedFees);
		collectedFees = 0;
	}

	function setFeeRate(uint256 newFeeRate) external onlyOwner {
	    require(newFeeRate <= 50, "EtheriaEx: Invalid fee");
		feeRate = newFeeRate;
	}
	
	function setWithdrawalPenaltyRate(uint256 newWithdrawalPenaltyRate) external onlyOwner {
	    require(newWithdrawalPenaltyRate <= 50, "EtheriaEx: Invalid penalty rate");
		withdrawalPenaltyRate = newWithdrawalPenaltyRate;
	}

	function getIndex(uint8 col, uint8 row) public pure returns (uint16) {
		require(col < 33 && row < 33, "EtheriaEx: Invalid col and/or row");
		return uint16(col) * mapSize + uint16(row);
	}

    function getColRow(uint16 index) public pure returns (uint8 col, uint8 row) {
        require(index < 1089, "EtheriaEx: Invalid index");
        col = uint8(index / mapSize);
        row = uint8(index % mapSize);
	}
	
	function getBidDetails(uint8 col, uint8 row) public view returns (address, uint256) {
		Bid storage exitingBid = bids[getIndex(col, row)];
		return (exitingBid.bidder, exitingBid.amount);
	}
	
	function bid(uint8 col, uint8 row, uint256 amount) internal returns (uint16 index) {
	    require(msg.sender == tx.origin, "EtheriaEx: tx origin must be sender"); // etheria doesn't allow tile ownership by contracts, this check prevents blackholing
		require(amount > 0, "EtheriaEx: Invalid bid");
		
		index = getIndex(col, row);
		Bid storage existingbid = bids[index];
		require(amount >= existingbid.amount.mul(101).div(100), "EtheriaEx: bid not 1% higher"); // require higher bid to be at least 1% higher
		
		pendingWithdrawals[existingbid.bidder] += existingbid.amount; // new bid is good. add amount of old (stale) bid to pending withdrawals (incl previous stale bid amounts)
		
		existingbid.bidder = msg.sender;
		existingbid.amount = amount;
	}

	function makeBid(uint8 col, uint8 row) external payable {
		require(mapElevationRetriever.getElevation(col, row) >= 125, "EtheriaEx: Can't bid on water");
		uint16 index = bid(col, row, msg.value);
		emit EtheriaBidCreated(index, msg.sender, msg.value);
	}
	
	function makeGlobalBid() external payable {
		bid(0, 0, msg.value);
		emit EtheriaGlobalBidCreated(msg.sender, msg.value);
	}

    // withdrawal of a still-good bid by the owner
	function withdrawBid(uint8 col, uint8 row) external {
		uint16 index = getIndex(col, row);
		Bid storage existingbid = bids[index];
		require(msg.sender == existingbid.bidder, "EtheriaEx: not existing bidder");

        // to discourage bid withdrawal, take a cut
		uint256 fees = existingbid.amount.mul(withdrawalPenaltyRate).div(1000);
		collectedFees += fees;
		
		uint256 amount = existingbid.amount.sub(fees);
		
		existingbid.bidder = address(0);
		existingbid.amount = 0;
		
		payable(msg.sender).transfer(amount);
		
		emit EtheriaBidWithdrawn(index, msg.sender, existingbid.amount);
	}
	
	function accept(uint8 col, uint8 row, uint256 minPrice, uint16 index) internal returns(address bidder, uint256 amount) {
	    require(etheria.getOwner(col, row) == msg.sender, "EtheriaEx: Not tile owner");
		
        Bid storage existingbid = bids[index];
		require(existingbid.amount > 0, "EtheriaEx: No bid to accept");
		require(existingbid.amount >= minPrice, "EtheriaEx: min price not met");
		
		bidder = existingbid.bidder;
		
		etheria.setOwner(col, row, bidder);
		require(etheria.getOwner(col, row) == bidder, "EtheriaEx: setting owner failed");

		//collect fee
		uint256 fees = existingbid.amount.mul(feeRate).div(1000);
		collectedFees += fees;

        amount = existingbid.amount.sub(fees);
        
		existingbid.bidder = address(0);
		existingbid.amount = 0;
		
        pendingWithdrawals[msg.sender] += amount;
	}

	function acceptBid(uint8 col, uint8 row, uint256 minPrice) external {
	    uint16 index = getIndex(col, row);
		(address bidder, uint256 amount) = accept(col, row, minPrice, index);
		emit EtheriaBidAccepted(index, msg.sender, bidder, amount);
    }
    
    function acceptGlobalBid(uint8 col, uint8 row, uint256 minPrice) external {
        (address bidder, uint256 amount) = accept(col, row, minPrice, 0);
        emit EtheriaGlobalBidAccepted(getIndex(col, row), msg.sender, bidder, amount);
    }

    // withdrawal of funds on any and all stale bids that have been bested
	function withdraw(address payable destination) public {
		uint256 amount = pendingWithdrawals[msg.sender];
		require(amount > 0, "EtheriaEx: no amount to withdraw");
		
        // Remember to zero the pending refund before
        // sending to prevent re-entrancy attacks
        pendingWithdrawals[destination] = 0;
        payable(destination).transfer(amount);
	}
	
	function withdraw() external {
		withdraw(payable(msg.sender));
	}
}