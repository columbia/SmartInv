pragma solidity ^0.5.1;

contract Multiowned {

    // TYPES
    // struct for the status of a pending operation.
    struct PendingState {
        uint yetNeeded;
        uint ownersDone;
        uint index;
    }

    // EVENTS
    // this contract only has five types of events: it can accept a confirmation, in which case
    // we record owner and operation (hash) alongside it.
    event Confirmation(address owner, bytes32 operation);

    // MODIFIERS
    // simple single-sig function modifier.
    modifier onlyOwner {
        if (!isOwner(msg.sender))
            require(false);
        _;
    }

    // multi-sig function modifier: the operation must have an intrinsic hash in order
    // that later attempts can be realised as the same underlying operation and
    // thus count as confirmations.
    modifier onlyManyOwners(bytes32 _operation) {
        if (confirmAndCheck(_operation))
            _;
    }

    // METHODS
    // constructor is given number of sigs required to do protected "onlymanyowners" transactions
    // as well as the selection of addresses capable of confirming them.
    constructor(address[] memory _owners, uint _required) public{
        m_numOwners = _owners.length;
        for (uint i = 0; i < _owners.length; ++i)
        {
            m_owners[1 + i] = _owners[i];
            m_ownerIndex[_owners[i]] = 1 + i;
        }
        m_required = _required;
    }

    function isOwner(address _addr) public view returns (bool) {
        return m_ownerIndex[_addr] > 0;
    }

    function hasConfirmed(bytes32 _operation, address _owner) view public returns (bool) {
        PendingState storage pending = m_pending[_operation];
        uint ownerIndex = m_ownerIndex[_owner];

        // make sure they're an owner
        if (ownerIndex == 0) return false;

        // determine the bit to set for this owner.
        uint ownerIndexBit = 2 ** ownerIndex;
        if (pending.ownersDone & ownerIndexBit == 0) {
            return false;
        } else {
            return true;
        }
    }

    // INTERNAL METHODS

    function confirmAndCheck(bytes32 _operation) internal returns (bool) {
        // determine what index the present sender is:
        uint ownerIndex = m_ownerIndex[msg.sender];
        // make sure they're an owner
        if (ownerIndex == 0) return false;

        PendingState storage pending = m_pending[_operation];
        // if we're not yet working on this operation, switch over and reset the confirmation status.
        if (pending.yetNeeded == 0) {
            // reset count of confirmations needed.
            pending.yetNeeded = m_required;
            // reset which owners have confirmed (none) - set our bitmap to 0.
            pending.ownersDone = 0;
            pending.index = m_pendingIndex.length++;
            m_pendingIndex[pending.index] = _operation;
        }
        // determine the bit to set for this owner.
        uint ownerIndexBit = 2 ** ownerIndex;
        // make sure we (the message sender) haven't confirmed this operation previously.
        if (pending.ownersDone & ownerIndexBit == 0) {
            emit Confirmation(msg.sender, _operation);
            // ok - check if count is enough to go ahead.
            if (pending.yetNeeded <= 1) {
                // enough confirmations: reset and run interior.
                delete m_pendingIndex[m_pending[_operation].index];
                delete m_pending[_operation];
                return true;
            }
            else
            {
                // not enough: record that this owner in particular confirmed.
                pending.yetNeeded--;
                pending.ownersDone |= ownerIndexBit;
            }
        }
        return false;
    }

    // FIELDS

    // the number of owners that must confirm the same operation before it is run.
    uint public m_required;
    // pointer used to find a free slot in m_owners
    uint public m_numOwners;

    // list of owners
    address[11] m_owners;
    uint constant c_maxOwners = 10;
    // index on the list of owners to allow reverse lookup
    mapping(address => uint) m_ownerIndex;
    // the ongoing operations.
    mapping(bytes32 => PendingState) m_pending;
    bytes32[] m_pendingIndex;
}


/**
 * @title Pausable
 * @dev Base contract which allows children to implement an emergency stop mechanism.
 */
contract Pausable is Multiowned {
    event Pause();
    event Unpause();

    bool public paused = false;


    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     */
    modifier whenNotPaused() {
        require(!paused);
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     */
    modifier whenPaused() {
        require(paused);
        _;
    }

    /**
     * @dev called by the owner to pause, triggers stopped state
     */
    function pause() onlyOwner whenNotPaused public {
        paused = true;
        emit Pause();
    }

    /**
     * @dev called by the owner to unpause, returns to normal state
     */
    function unpause() onlyOwner whenPaused public {
        paused = false;
        emit Unpause();
    }
}
/**
 * Math operations with safety checks
 */
contract SafeMath {
    function safeMul(uint256 a, uint256 b) pure internal returns (uint256) {
        uint256 c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function safeDiv(uint256 a, uint256 b) pure internal returns (uint256) {
        assert(b > 0);
        uint256 c = a / b;
        assert(a == b * c + a % b);
        return c;
    }

    function safeSub(uint256 a, uint256 b) pure internal returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function safeAdd(uint256 a, uint256 b) pure internal returns (uint256) {
        uint256 c = a + b;
        assert(c>=a && c>=b);
        return c;
    }
}

contract tokenRecipientInterface {
    function receiveApproval(address _from, uint256 _value, address _token, bytes memory _extraData) public;
}

contract ZVC is Multiowned, SafeMath, Pausable{
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    address public creator;

    /* This creates an array with all balances */
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;

    /* This creates an array with all PEAccounts */
    mapping (address => bool) public PEAccounts;

    // pending transactions we have at present.
    mapping(bytes32 => Transaction) m_txs;

    // Transaction structure to remember details of transaction lest it need be saved for a later call.
    struct Transaction {
        address to;
        uint value;
    }

    /* This generates a public event on the blockchain that will notify clients */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /* This notifies clients about the amount to mapping */
    event MappingTo(address from, string to, uint256 value);

    // Multi-sig transaction going out of the wallet (record who signed for it last, the operation hash, how much, and to whom it's going).
    event MultiTransact(address owner, bytes32 operation, uint value, address to);
    // Confirmation still needed for a transaction.
    event ConfirmationNeeded(bytes32 operation, address initiator, uint value, address to);

    modifier notHolderAndPE() {
        require(creator != msg.sender && !PEAccounts[msg.sender]);
        _;
    }


    /* Initializes contract with initial supply tokens to the creator of the contract */
    constructor(address[] memory _owners, uint _required) Multiowned(_owners, _required) public payable  {
        balanceOf[msg.sender] = 500000000000000000;              // Give the creator all initial tokens
        totalSupply = 500000000000000000;                        // Update total supply
        name = "ZVC";                                   // Set the name for display purposes
        symbol = "ZVC";                               // Set the symbol for display purposes
        decimals = 9;                            // Amount of decimals for display purposes
        creator = msg.sender;                    // creator holds all tokens
    }

    /* Send coins */
    function transfer(address _to, uint256 _value) whenNotPaused notHolderAndPE public returns (bool success){
        require(_to != address(0x0));                               // Prevent transfer to 0x0 address. Use burn() instead
        require(_value > 0);
        require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
        require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
        balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
        balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
        emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
        return true;
    }


    /* Allow another contract to spend some tokens in your behalf */
    function approve(address _spender, uint256 _value) whenNotPaused notHolderAndPE public returns (bool success) {
        require(_value > 0);
        allowance[msg.sender][_spender] = _value;
        return true;
    }


    /* A contract attempts to get the coins */
    function transferFrom(address _from, address _to, uint256 _value) whenNotPaused public returns (bool success) {
        require (_to != address(0x0));                                // Prevent transfer to 0x0 address. Use burn() instead
        require (_value > 0);
        require (balanceOf[_from] >= _value);                 // Check if the sender has enough
        require (balanceOf[_to] + _value >= balanceOf[_to]);  // Check for overflows
        require (_value <= allowance[_from][msg.sender]);     // Check allowance
        balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
        balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
        allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
        emit Transfer(_from, _to, _value);
        return true;
    }

    /* Approve and then communicate the approved contract in a single tx */
    function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) whenNotPaused notHolderAndPE public returns (bool success) {
        tokenRecipientInterface spender = tokenRecipientInterface(_spender);
        if (approve(_spender, _value)) {
            spender.receiveApproval(msg.sender, _value, address(this), _extraData);
            return true;
        }
        return false;
    }

    // User attempts to mapping to mainnet
    function mappingTo(string memory to, uint256 _value) notHolderAndPE public returns (bool success){
        require (balanceOf[msg.sender] >= _value);            // Check if the sender has enough
        require(_value > 0);
        balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
        totalSupply = SafeMath.safeSub(totalSupply, _value);                                // Updates totalSupply
        emit MappingTo(msg.sender, to, _value);
        return true;
    }

    // Outside-visible transact entry point. Executes transacion immediately if below daily spend limit.
    // If not, goes into multisig process. We provide a hash on return to allow the sender to provide
    // shortcuts for the other confirmations (allowing them to avoid replicating the _to, _value
    // and _data arguments). They still get the option of using them if they want, anyways.
    function execute(address _to, uint _value) external onlyOwner returns (bytes32 _r) {
        _r = keccak256(abi.encode(msg.data, block.number));
        if (!confirm(_r) && m_txs[_r].to == address(0)) {
            m_txs[_r].to = _to;
            m_txs[_r].value = _value;
            emit ConfirmationNeeded(_r, msg.sender, _value, _to);
        }
    }

    // confirm a transaction through just the hash. we use the previous transactions map, m_txs, in order
    // to determine the body of the transaction from the hash provided.
    function confirm(bytes32 _h) public onlyManyOwners(_h) returns (bool) {
        uint256 _value = m_txs[_h].value;
        address _to = m_txs[_h].to;
        if (_to != address(0)) {
            require(_value > 0);
            require(balanceOf[creator] >= _value);           // Check if the sender has enough
            require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
            balanceOf[creator] = SafeMath.safeSub(balanceOf[creator], _value);                     // Subtract from the sender
            balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
            emit Transfer(creator, _to, _value);                   // Notify anyone listening that this transfer took place
            delete m_txs[_h];
            return true;
        }
        return false;
    }

    function addPEAccount(address _to) public onlyOwner{
        PEAccounts[_to] = true;
    }

    function delPEAccount(address _to) public onlyOwner {
        delete PEAccounts[_to];
    }

    function () external payable {
    }

    // transfer balance to owner
    function withdrawEther(uint256 amount) public onlyOwner{
        msg.sender.transfer(amount);
    }
}