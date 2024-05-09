pragma solidity ^0.4.24;

/**
 * @title SafeMath
 * @dev Math operations with safety checks that revert on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, reverts on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (a == 0) {
      return 0;
    }

    uint256 c = a * b;
    require(c / a == b);

    return c;
  }

  /**
  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b > 0); // Solidity only automatically asserts when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;
  }

  /**
  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b <= a);
    uint256 c = a - b;

    return c;
  }

  /**
  * @dev Adds two numbers, reverts on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a);

    return c;
  }

  /**
  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
  * reverts when dividing by zero.
  */
  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b != 0);
    return a % b;
  }
}


/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
interface IERC20 {
  function totalSupply() external view returns (uint256);

  function balanceOf(address who) external view returns (uint256);

  function allowance(address owner, address spender)
    external view returns (uint256);

  function transfer(address to, uint256 value) external returns (bool);

  function approve(address spender, uint256 value)
    external returns (bool);

  function transferFrom(address from, address to, uint256 value)
    external returns (bool);

  event Transfer(
    address indexed from,
    address indexed to,
    uint256 value
  );

  event Approval(
    address indexed owner,
    address indexed spender,
    uint256 value
  );
}


/**
 * Abstract contract, requires implementation to specify who can commit blocks and what
 *   happens when a successful proof is presented
 * Verifies Merkle-tree inclusion proofs that show that certain address has
 *   certain earnings balance, according to hash published ("signed") by a
 *   sidechain operator or similar authority
 *
 * ABOUT Merkle-tree inclusion proof: Merkle-tree inclusion proof is an algorithm to prove memebership
 * in a set using minimal [ie log(N)] inputs. The hashes of the items are arranged by hash value in a binary Merkle tree where 
 * each node contains a hash of the hashes of nodes below. The root node (ie "root hash") contains hash information 
 * about the entire set, and that is the data that BalanceVerifier posts to the blockchain. To prove membership, you walk up the 
 * tree from the node in question, and use the supplied hashes (the "proof") to fill in the hashes from the adjacent nodes. The proof  
 * succeeds iff you end up with the known root hash when you get to the top of the tree. 
 * See https://medium.com/crypto-0-nite/merkle-proofs-explained-6dd429623dc5
 *
 * Merkle-tree inclusion proof is a RELATED concept to the blockchain Merkle tree, but a somewhat DIFFERENT application. 
 * BalanceVerifier posts the root hash of the CURRENT ledger only, and this does NOT depend on the hash of previous ledgers.
 * This is different from the blockchain, where each block contains the hash of the previous block. 
 *
 * TODO: see if it could be turned into a library, so many contracts could use it
 */
contract BalanceVerifier {
    event BlockCreated(uint blockNumber, bytes32 rootHash, string ipfsHash);

    /**
     * Sidechain "blocks" are simply root hashes of merkle-trees constructed from its balances
     * @param uint root-chain block number after which the balances were recorded
     * @return bytes32 root of the balances merkle-tree at that time
     */
    mapping (uint => bytes32) public blockHash;

    /**
     * Handler for proof of sidechain balances
     * It is up to the implementing contract to actually distribute out the balances
     * @param blockNumber the block whose hash was used for verification
     * @param account whose balances were successfully verified
     * @param balance the side-chain account balance
     */
    function onVerifySuccess(uint blockNumber, address account, uint balance) internal;

    /**
     * Implementing contract should should do access checks for committing
     */
    function onCommit(uint blockNumber, bytes32 rootHash, string ipfsHash) internal;

    /**
     * Side-chain operator submits commitments to main chain. These
     * For convenience, also publish the ipfsHash of the balance book JSON object
     * @param blockNumber the block after which the balances were recorded
     * @param rootHash root of the balances merkle-tree
     * @param ipfsHash where the whole balances object can be retrieved in JSON format
     */
    function commit(uint blockNumber, bytes32 rootHash, string ipfsHash) external {
        require(blockHash[blockNumber] == 0, "error_overwrite");
        string memory _hash = ipfsHash;
        onCommit(blockNumber, rootHash, _hash);
        blockHash[blockNumber] = rootHash;
        emit BlockCreated(blockNumber, rootHash, _hash);
    }

    /**
     * Proving can be used to record the sidechain balances permanently into root chain
     * @param blockNumber the block after which the balances were recorded
     * @param account whose balances will be verified
     * @param balance side-chain account balance
     * @param proof list of hashes to prove the totalEarnings
     */
    function prove(uint blockNumber, address account, uint balance, bytes32[] memory proof) public {
        require(proofIsCorrect(blockNumber, account, balance, proof), "error_proof");
        onVerifySuccess(blockNumber, account, balance);
    }

    /**
     * Check the merkle proof of balance in the given side-chain block for given account
     */
    function proofIsCorrect(uint blockNumber, address account, uint balance, bytes32[] memory proof) public view returns(bool) {
        bytes32 hash = keccak256(abi.encodePacked(account, balance));
        bytes32 rootHash = blockHash[blockNumber];
        require(rootHash != 0x0, "error_blockNotFound");
        return rootHash == calculateRootHash(hash, proof);
    }

    /**
     * Calculate root hash of a Merkle tree, given
     * @param hash of the leaf to verify
     * @param others list of hashes of "other" branches
     */
    function calculateRootHash(bytes32 hash, bytes32[] memory others) public pure returns (bytes32 root) {
        root = hash;
        for (uint8 i = 0; i < others.length; i++) {
            bytes32 other = others[i];
            if (other == 0x0) continue;     // odd branch, no need to hash
            if (root < other) {
                root = keccak256(abi.encodePacked(root, other));
            } else {
                root = keccak256(abi.encodePacked(other, root));
            }
        }
    }
}

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
    address public owner;
    address public pendingOwner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    constructor() public {
        owner = msg.sender;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "onlyOwner");
        _;
    }

    /**
     * @dev Allows the current owner to set the pendingOwner address.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        pendingOwner = newOwner;
    }

    /**
     * @dev Allows the pendingOwner address to finalize the transfer.
     */
    function claimOwnership() public {
        require(msg.sender == pendingOwner, "onlyPendingOwner");
        emit OwnershipTransferred(owner, pendingOwner);
        owner = pendingOwner;
        pendingOwner = address(0);
    }
}




/**
 * Monoplasma that is managed by an owner, likely the side-chain operator
 * Owner can add and remove recipients.
 */
contract Monoplasma is BalanceVerifier, Ownable {
    using SafeMath for uint256;

    event OperatorChanged(address indexed newOperator);
    event AdminFeeChanged(uint adminFee);
    /**
     * Freeze period during which all side-chain participants should be able to
     *   acquire the whole balance book from IPFS (or HTTP server, or elsewhere)
     *   and validate that the published rootHash is correct
     * In case of incorrect rootHash, all members should issue withdrawals from the
     *   latest block they have validated (that is older than blockFreezeSeconds)
     * So: too short freeze period + bad availability => ether (needlessly) spent withdrawing earnings
     *     long freeze period == lag between purchase and withdrawal => bad UX
     * Blocks older than blockFreezeSeconds can be used to withdraw funds
     */
    uint public blockFreezeSeconds;

    /**
     * Block number => timestamp
     * Publish time of a block, where the block freeze period starts from.
     * Note that block number points to the block after which the root hash is calculated,
     *   not the block where BlockCreated was emitted (event must come later)
     */
    mapping (uint => uint) public blockTimestamp;

    address public operator;

    //fee fraction = adminFee/10^18
    uint public adminFee;

    IERC20 public token;

    mapping (address => uint) public earnings;
    mapping (address => uint) public withdrawn;
    uint public totalWithdrawn;
    uint public totalProven;

    constructor(address tokenAddress, uint blockFreezePeriodSeconds, uint _adminFee) public {
        blockFreezeSeconds = blockFreezePeriodSeconds;
        token = IERC20(tokenAddress);
        operator = msg.sender;
        setAdminFee(_adminFee);
    }

    function setOperator(address newOperator) public onlyOwner {
        operator = newOperator;
        emit OperatorChanged(newOperator);
    }

    /**
     * Admin fee as a fraction of revenue
     * Fixed-point decimal in the same way as ether: 50% === 0.5 ether
     * Smart contract doesn't use it, it's here just for storing purposes
     */
    function setAdminFee(uint _adminFee) public onlyOwner {
        require(adminFee <= 1 ether, "Admin fee cannot be greater than 1");
        adminFee = _adminFee;
        emit AdminFeeChanged(_adminFee);
    }

    /**
     * Operator creates the side-chain blocks
     */
    function onCommit(uint blockNumber, bytes32, string) internal {
        require(msg.sender == operator, "error_notPermitted");
        blockTimestamp[blockNumber] = now;
    }

    /**
     * Called from BalanceVerifier.prove
     * Prove can be called directly to withdraw less than the whole share,
     *   or just "cement" the earnings so far into root chain even without withdrawing
     */
    function onVerifySuccess(uint blockNumber, address account, uint newEarnings) internal {
        uint blockFreezeStart = blockTimestamp[blockNumber];
        require(now > blockFreezeStart + blockFreezeSeconds, "error_frozen");
        require(earnings[account] < newEarnings, "error_oldEarnings");
        totalProven = totalProven.add(newEarnings).sub(earnings[account]);
        require(totalProven.sub(totalWithdrawn) <= token.balanceOf(this), "error_missingBalance");
        earnings[account] = newEarnings;
    }

    /**
     * Prove and withdraw the whole revenue share from sidechain in one transaction
     * @param blockNumber of the leaf to verify
     * @param totalEarnings in the side-chain
     * @param proof list of hashes to prove the totalEarnings
     */
    function withdrawAll(uint blockNumber, uint totalEarnings, bytes32[] proof) external {
        withdrawAllFor(msg.sender, blockNumber, totalEarnings, proof);
    }

    /**
     * Prove and withdraw the whole revenue share for someone else
     * Validator needs to exit those it's watching out for, in case
     *   it detects Operator malfunctioning
     * @param recipient the address we're proving and withdrawing
     * @param blockNumber of the leaf to verify
     * @param totalEarnings in the side-chain
     * @param proof list of hashes to prove the totalEarnings
     */
    function withdrawAllFor(address recipient, uint blockNumber, uint totalEarnings, bytes32[] proof) public {
        prove(blockNumber, recipient, totalEarnings, proof);
        uint withdrawable = totalEarnings.sub(withdrawn[recipient]);
        withdrawTo(recipient, recipient, withdrawable);
    }

    /**
     * "Donate withdraw" function that allows you to prove and transfer
     *   your earnings to a another address in one transaction
     * @param recipient the address the tokens will be sent to (instead of msg.sender)
     * @param blockNumber of the leaf to verify
     * @param totalEarnings in the side-chain
     * @param proof list of hashes to prove the totalEarnings
     */
    function withdrawAllTo(address recipient, uint blockNumber, uint totalEarnings, bytes32[] proof) external {
        prove(blockNumber, msg.sender, totalEarnings, proof);
        uint withdrawable = totalEarnings.sub(withdrawn[msg.sender]);
        withdrawTo(recipient, msg.sender, withdrawable);
    }

    /**
     * Withdraw a specified amount of your own proven earnings (see `function prove`)
     */
    function withdraw(uint amount) public {
        withdrawTo(msg.sender, msg.sender, amount);
    }

    /**
     * Do the withdrawal on behalf of someone else
     * Validator needs to exit those it's watching out for, in case
     *   it detects Operator malfunctioning
     */
    function withdrawFor(address recipient, uint amount) public {
        withdrawTo(recipient, recipient, amount);
    }

    /**
     * Execute token withdrawal into specified recipient address from specified member account
     * @dev It is up to the sidechain implementation to make sure
     * @dev  always token balance >= sum of earnings - sum of withdrawn
     */
    function withdrawTo(address recipient, address account, uint amount) public {
        require(amount > 0, "error_zeroWithdraw");
        uint w = withdrawn[account].add(amount);
        require(w <= earnings[account], "error_overdraft");
        withdrawn[account] = w;
        totalWithdrawn = totalWithdrawn.add(amount);
        require(token.transfer(recipient, amount), "error_transfer");
    }
}


contract CommunityProduct is Monoplasma {

    string public joinPartStream;

    constructor(address operator, string joinPartStreamId, address tokenAddress, uint blockFreezePeriodSeconds, uint adminFeeFraction)
    Monoplasma(tokenAddress, blockFreezePeriodSeconds, adminFeeFraction) public {
        setOperator(operator);
        joinPartStream = joinPartStreamId;
    }
}