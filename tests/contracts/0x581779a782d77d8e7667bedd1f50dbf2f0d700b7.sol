// SPDX-License-Identifier: MIT
pragma solidity 0.7.x;

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
    constructor () {}
    // solhint-disable-previous-line no-empty-blocks

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this;
        // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
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
    constructor () {
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


abstract contract Token_interface {
    function owner() public view virtual returns (address);

    function decimals() public view virtual returns (uint8);

    function balanceOf(address who) public view virtual returns (uint256);

    function transfer(address _to, uint256 _value) public virtual returns (bool);

    function allowance(address _owner, address _spender) public virtual returns (uint);

    function transferFrom(address _from, address _to, uint _value) public virtual returns (bool);
}

contract MultiSigPermission is Context {

    uint constant public MAX_OWNER_COUNT = 3;

    event Confirmation(address indexed sender, uint indexed transactionId);
    event Revocation(address indexed sender, uint indexed transactionId);
    event Submission(uint indexed transactionId);
    event Execution(uint indexed transactionId);
    event ExecutionFailure(uint indexed transactionId);
    event Deposit(address indexed sender, uint value);
    event SignRoleAddition(address indexed signRoleAddress);
    event SignRoleRemoval(address indexed signRoleAddress);
    event RequirementChange(uint required);

    mapping (uint => Transaction) public transactions;
    mapping (uint => mapping (address => bool)) public confirmations;
    mapping (address => bool) public isSignRole;
    address[] public signRoleAddresses;
    uint public required;
    uint public transactionCount;

    struct Transaction {
        address destination;
        uint value;
        bytes data;
        bool executed;
    }

    modifier signRoleAddresseExists(address signRoleAddress) {
        require(isSignRole[signRoleAddress], "Role doesn't exists");
        _;
    }

    modifier transactionExists(uint transactionId) {
        require(transactions[transactionId].destination != address(0), "Transaction doesn't exists");
        _;
    }

    modifier confirmed(uint transactionId, address signRoleAddress) {
        require(confirmations[transactionId][signRoleAddress], "Transaction didn't confirm");
        _;
    }

    modifier notConfirmed(uint transactionId, address signRoleAddress) {
        require(!confirmations[transactionId][signRoleAddress], "Transaction already confirmed");
        _;
    }

    modifier notExecuted(uint transactionId) {
        require(!transactions[transactionId].executed, "Transaction already executed");
        _;
    }

    modifier notNull(address _address) {
        require(_address != address(0), "address is 0");
        _;
    }

    modifier validRequirement(uint signRoleAddresseCount, uint _required) {
        require(signRoleAddresseCount <= MAX_OWNER_COUNT
            && _required <= signRoleAddresseCount
            && _required != 0
            && signRoleAddresseCount != 0, "Not valid required count");
        _;
    }

    constructor(uint _required)
    {
        required = _required;
    }

    /// @dev Returns the confirmation status of a transaction.
    /// @param transactionId Transaction ID.
    /// @return Confirmation status.
    function isConfirmed(uint transactionId)
        public
        view returns (bool)
    {
        uint count = 0;
        for (uint i=0; i<signRoleAddresses.length; i++) {
            if (confirmations[transactionId][signRoleAddresses[i]])
                count += 1;
            if (count == required)
                return true;
        }
        return false;
    }

    function checkSignRoleExists(address signRoleAddress)
        public
        view returns (bool)
    {
        return isSignRole[signRoleAddress];
    }



    /// @dev Allows an signRoleAddress to confirm a transaction.
    /// @param transactionId Transaction ID.
    function confirmTransaction(uint transactionId)
        public
        signRoleAddresseExists(_msgSender())
        transactionExists(transactionId)
        notConfirmed(transactionId, _msgSender())
    {
        confirmations[transactionId][_msgSender()] = true;
        Confirmation(_msgSender(), transactionId);
        executeTransaction(transactionId);
    }

    /// @dev Allows anyone to execute a confirmed transaction.
    /// @param transactionId Transaction ID.
    function executeTransaction(uint transactionId)
        private
        signRoleAddresseExists(_msgSender())
        notExecuted(transactionId)
    {
        if (isConfirmed(transactionId)) {
            transactions[transactionId].executed = true;
            (bool success,) = transactions[transactionId].destination.call{value : transactions[transactionId].value}(transactions[transactionId].data);
            if (success)
                Execution(transactionId);
            else {
                ExecutionFailure(transactionId);
                transactions[transactionId].executed = false;
            }
        }
    }


    /*
     * Internal functions
     */
    function addTransaction(address destination, uint value, bytes memory data)
        internal
        notNull(destination)
        returns (uint transactionId)
    {
        transactionId = transactionCount;
        transactions[transactionId] = Transaction({
            destination: destination,
            value: value,
            data: data,
            executed: false
        });
        transactionCount += 1;
        Submission(transactionId);
    }

    function submitTransaction(address destination, uint value, bytes memory data)
        internal
        returns (uint transactionId)
    {
        transactionId = addTransaction(destination, value, data);
        confirmTransaction(transactionId);
    }

    function addSignRole(address signRoleAddress)
        internal
    {
        require(signRoleAddress != address(0), "Address cannot be null");
        require(signRoleAddresses.length + 1 <= MAX_OWNER_COUNT, "Address qty cannot be more then max admins value");
        require(!checkSignRoleExists(signRoleAddress), "Address already exists");

        isSignRole[signRoleAddress] = true;
        signRoleAddresses.push(signRoleAddress);
        SignRoleAddition(signRoleAddress);
    }

}


contract AdminRole is Context, MultiSigPermission {

    uint constant public REQUIRED_CONFIRMATIONS_COUNT = 2;
    
    constructor () MultiSigPermission(REQUIRED_CONFIRMATIONS_COUNT) {
        addSignRole(_msgSender());
        addSignRole(address(0x42586d48C29651f32FC65b8e1D1d0E6ebAD28206));
        addSignRole(address(0x160e529055D084add9634fE1c2059109c8CE044e));
    }

    modifier onlyOwnerOrAdmin() {
        require(checkSignRoleExists(_msgSender()), "you don't have permission to perform that action");
        _;
    }
}


library TxDataBuilder {
    string constant public RTTD_FUNCHASH = '0829d713'; // WizRefund - refundTokensTransferredDirectly
    string constant public EFWD_FUNCHASH = 'eee48b02'; // WizRefund - clearFinalWithdrawData
    string constant public FR_FUNCHASH =   '492b2b37'; // WizRefund - forceRegister
    string constant public RP_FUNCHASH =   '422a042e'; // WizRefund - revertPhase
    string constant public WETH_FUNCHASH =   '4782f779'; // WizRefund - withdrawETH

    function uint2bytes32(uint256 x)
        public
        pure returns (bytes memory b) {
            b = new bytes(32);
            assembly { mstore(add(b, 32), x) }
    }
    
    function uint2bytes8(uint256 x)
        public
        pure returns (bytes memory b) {
            b = new bytes(32);
            assembly { mstore(add(b, 32), x) }
    }
    
    function concatb(bytes memory self, bytes memory other)
        public
        pure returns (bytes memory) {
             return bytes(abi.encodePacked(self, other));
        }
        
    // Convert an hexadecimal character to their value
    function fromHexChar(uint8 c) public pure returns (uint8) {
        if (bytes1(c) >= bytes1('0') && bytes1(c) <= bytes1('9')) {
            return c - uint8(bytes1('0'));
        }
        if (bytes1(c) >= bytes1('a') && bytes1(c) <= bytes1('f')) {
            return 10 + c - uint8(bytes1('a'));
        }
        if (bytes1(c) >= bytes1('A') && bytes1(c) <= bytes1('F')) {
            return 10 + c - uint8(bytes1('A'));
        }
        require(false, "unknown variant");
    }
    
    // Convert an hexadecimal string to raw bytes
    function fromHex(string memory s) public pure returns (bytes memory) {
        bytes memory ss = bytes(s);
        require(ss.length%2 == 0); // length must be even
        bytes memory r = new bytes(ss.length/2);
        for (uint i=0; i<ss.length/2; ++i) {
            r[i] = bytes1(fromHexChar(uint8(ss[2*i])) * 16 +
                        fromHexChar(uint8(ss[2*i+1])));
        }
        return r;
    }

    function buildData(string memory function_hash, uint256[] memory argv)
        public
        pure returns (bytes memory data){
            bytes memory f = fromHex(function_hash);
            data = concatb(data, f);
            for(uint i=0;i<argv.length;i++){
                bytes memory d = uint2bytes32(argv[i]);
                data = concatb(data, d);
            }
    }
}



contract WizRefund is Context, Ownable, AdminRole {
    using SafeMath for uint256;
    
    modifier selfCall() {
        require(_msgSender() == address(this), "You cannot call this method");
        _;
    }

    uint256 constant PHASES_COUNT = 4;
    uint256 private _token_exchange_rate = 273789679021000; //0.000273789679021 ETH per 1 token
    uint256 private _totalburnt = 0;
    uint256 public final_distribution_balance;
    uint256 public sum_burnt_amount_registered;

    address payable[] private _participants;

    mapping(address => uint256) private _burnt_amounts;
    mapping(address => bool) private _participants_with_request;
    mapping(address => bool) private _is_final_withdraw;

    struct PhaseParams {
        string NAME;
        bool IS_STARTED;
        bool IS_FINISHED;
    }
    PhaseParams[] public phases;

    Token_interface public token;

    event BurningRequiredValues(uint256 allowed_value, uint256 topay_value, address indexed sc_address, uint256 sc_balance);
    event LogWithdrawETH(address indexed wallet, uint256 amount);
    event LogRefundValue(address indexed wallet, uint256 amount);

    constructor () {

        token = Token_interface(address(0x2F9b6779c37DF5707249eEb3734BbfC94763fBE2));

        // 0 - first
        PhaseParams memory phaseInitialize;
        phaseInitialize.NAME = "Initialize";
        phaseInitialize.IS_STARTED = true;
        phases.push(phaseInitialize);

        // 1 - second
        // tokens exchanging is active in this phase, tokenholders may burn their tokens using
        //           method approve(params: this SC address, amount in
        //           uint256) method in Token SC, then he/she has to call refund()
        //           method in this SC, all tokens from amount will be exchanged and the
        //           tokenholder will receive his/her own ETH on his/her own address
        // if somebody accidentally sent tokens to this SC directly you may use
        //           refundTokensTransferredDirectly(params: tokenholder ETH address, amount in
        //           uint256) method with mandatory multisignatures
        PhaseParams memory phaseFirst;
        phaseFirst.NAME = "the First Phase";
        phases.push(phaseFirst);

        // 2 - third
        // in this phase tokeholders who exchanged their own tokens in phase 1 may claim a
        // remaining ETH stake with register() method
        PhaseParams memory phaseSecond;
        phaseSecond.NAME = "the Second Phase";
        phases.push(phaseSecond);

        // 3 - last
        // this is a final distribution phase. Everyone who left the request during the
        // phase 2 with register() method will get remaining ETH amount
        // in proportion to their exchanged tokens
        PhaseParams memory phaseFinal;
        phaseFinal.NAME = "Final";
        phases.push(phaseFinal);
        
    }

    //
    // ####################################
    //

    //only owner or admins can top up the smart contract with ETH
    receive() external payable {
        require(checkSignRoleExists(_msgSender()), "the contract can't obtain ETH from this address");
    }

    // owner or admin may withdraw ETH from this SC, multisig is mandatory
    function withdrawETH(address payable recipient, uint256 value) external selfCall {
        require(address(this).balance >= value, "Insufficient funds");
        (bool success,) = recipient.call{value : value}("");
        require(success, "Transfer failed");
        emit LogWithdrawETH(msg.sender, value);
    }

    function getExchangeRate() external view returns (uint256){
        return _token_exchange_rate;
    }

    function getBurntAmountByAddress(address holder) public view returns (uint256){
        return _burnt_amounts[holder];
    }

    function getBurntAmountTotal() external view returns (uint256) {
        return _totalburnt;
    }

    function getParticipantAddressByIndex(uint256 index) external view returns (address){
        return _participants[index];
    }

    function getNumberOfParticipants() public view returns (uint256){
        return _participants.length;
    }

    function isRegistration(address participant) public view returns (bool){
        return _participants_with_request[participant];
    }

    //
    // ####################################
    //
    // tokenholder has to call approve(params: this SC address, amount in uint256)
    // method in Token SC, then he/she has to call refund() method in this
    // SC, all tokens from amount will be exchanged and the tokenholder will receive
    // his/her own ETH on his/her own address
    function refund() external {
        // First phase
        uint256 i = getCurrentPhaseIndex();
        require(i == 1 && !phases[i].IS_FINISHED, "Not Allowed phase");

        address payable sender = _msgSender();
        uint256 value = token.allowance(sender, address(this));

        require(value > 0, "Not Allowed value");

        uint256 topay_value = value.mul(_token_exchange_rate).div(10 ** 18);
        BurningRequiredValues(value, topay_value, address(this), address(this).balance);
        require(address(this).balance >= topay_value, "Insufficient funds");

        require(token.transferFrom(sender, address(0), value), "Insufficient approve() value");

        if (_burnt_amounts[sender] == 0) {
            _participants.push(sender);
        }

        _burnt_amounts[sender] = _burnt_amounts[sender].add(value);
        _totalburnt = _totalburnt.add(value);

        (bool success,) = sender.call{value : topay_value}("");
        require(success, "Transfer failed");
        emit LogRefundValue(msg.sender, topay_value);
    }

    // if somebody accidentally sends tokens to this SC directly you may use
    // burnTokensTransferredDirectly(params: tokenholder ETH address, amount in
    // uint256)
    function refundTokensTransferredDirectly(address payable participant, uint256 value) external selfCall {
        uint256 i = getCurrentPhaseIndex();
        require(i == 1, "Not Allowed phase");
        // First phase

        uint256 topay_value = value.mul(_token_exchange_rate).div(10 ** uint256(token.decimals()));
        require(address(this).balance >= topay_value, "Insufficient funds");

        require(token.transfer(address(0), value), "Error with transfer");

        if (_burnt_amounts[participant] == 0) {
            _participants.push(participant);
        }

        _burnt_amounts[participant] = _burnt_amounts[participant].add(value);
        _totalburnt = _totalburnt.add(value);

        (bool success,) = participant.call{value : topay_value}("");
        require(success, "Transfer failed");
        emit LogRefundValue(participant, topay_value);
    }

    // This is a final distribution after phase 2 is fihished, everyone who left the
    // request with register() method will get remaining ETH amount
    // in proportion to their exchanged tokens
    function startFinalDistribution(uint256 start_index, uint256 end_index) external onlyOwnerOrAdmin {
        require(end_index < getNumberOfParticipants());
        
        uint256 j = getCurrentPhaseIndex();
        require(j == 3 && !phases[j].IS_FINISHED, "Not Allowed phase");
        // Final Phase

        uint256 pointfix = 1000000000000000000;
        // 10^18

        for (uint i = start_index; i <= end_index; i++) {
            if(!isRegistration(_participants[i]) || isFinalWithdraw(_participants[i])){
                continue;
            }
            
            uint256 piece = getBurntAmountByAddress(_participants[i]).mul(pointfix).div(sum_burnt_amount_registered);
            uint256 value = final_distribution_balance.mul(piece).div(pointfix);
            
            if (value > 0) {
                _is_final_withdraw[_participants[i]] = true;
                (bool success,) = _participants[i].call{value : value}("");
                require(success, "Transfer failed");
                emit LogWithdrawETH(_participants[i], value);
            }
        }

    }

    function isFinalWithdraw(address _wallet) public view returns (bool) {
        return _is_final_withdraw[_wallet];
    }
    
    function clearFinalWithdrawData(uint256 start_index, uint256 end_index) external selfCall{
        require(end_index < getNumberOfParticipants());
        
        uint256 i = getCurrentPhaseIndex();
        require(i == 3 && !phases[i].IS_FINISHED, "Not Allowed phase");
        
        for (uint j = start_index; j <= end_index; j++) {
            if(isFinalWithdraw(_participants[j])){
                _is_final_withdraw[_participants[j]] = false;
            }
        }
    }

    // tokeholders who exchanged their own tokens in phase 1 may claim a remaining ETH stake
    function register() external {
        _write_register(_msgSender());
    }

    // admin can claim register() method instead of tokenholder
    function forceRegister(address payable participant) external selfCall {
        _write_register(participant);
    }

    function _write_register(address payable participant) private {
        uint256 i = getCurrentPhaseIndex();
        require(i == 2 && !phases[i].IS_FINISHED, "Not Allowed phase");
        // Second phase

        require(_burnt_amounts[participant] > 0, "This address has not refunded tokens");

        _participants_with_request[participant] = true;
        sum_burnt_amount_registered  = sum_burnt_amount_registered.add(getBurntAmountByAddress(participant));
    }

    function startNextPhase() external onlyOwnerOrAdmin {
        uint256 i = getCurrentPhaseIndex();
        require((i + 1) < PHASES_COUNT);
        require(phases[i].IS_FINISHED);
        phases[i + 1].IS_STARTED = true;
        if (phases[2].IS_STARTED && !phases[2].IS_FINISHED && phases[1].IS_FINISHED) {
            sum_burnt_amount_registered = 0;
        }else if (phases[3].IS_STARTED && phases[2].IS_FINISHED) {
            final_distribution_balance = address(this).balance;
        }
    }

    function finishCurrentPhase() external onlyOwnerOrAdmin {
        uint256 i = getCurrentPhaseIndex();
        phases[i].IS_FINISHED = true;
    }

    // this method reverts the current phase to the previous one
    function revertPhase() external selfCall {
        uint256 i = getCurrentPhaseIndex();

        require(i > 0, "Initialize phase is already active");

        phases[i].IS_STARTED = false;
        phases[i].IS_FINISHED = false;

        phases[i - 1].IS_STARTED = true;
        phases[i - 1].IS_FINISHED = false;
    }

    function getPhaseName() external view returns (string memory){
        uint256 i = getCurrentPhaseIndex();
        return phases[i].NAME;
    }

    function getCurrentPhaseIndex() public view returns (uint256){
        uint256 current_phase = 0;
        for (uint256 i = 0; i < PHASES_COUNT; i++)
        {
            if (phases[i].IS_STARTED) {
                current_phase = i;
            }
        }
        return current_phase;
    }
    
    function _base_submitTx(bytes memory data)
      private 
      returns (uint256 transactionId){
        uint256 value = 0;
        transactionId = submitTransaction(address(this), value, data);
      }
      
    function submitTx_withdrawETH(address payable recipient, uint256 value)
      public
      onlyOwnerOrAdmin
      returns (uint256 transactionId){
        uint256[] memory f_args = new uint256[](2);
        f_args[0] = uint256(recipient);
        f_args[1] = value;
        bytes memory data = TxDataBuilder.buildData(TxDataBuilder.WETH_FUNCHASH, f_args);
        transactionId = _base_submitTx(data);
      }
    
    function submitTx_revertPhase()
      external
      onlyOwnerOrAdmin
      returns (uint256 transactionId){
        uint256[] memory f_args = new uint256[](0);
        bytes memory data = TxDataBuilder.buildData(TxDataBuilder.RP_FUNCHASH, f_args);
        transactionId = _base_submitTx(data);
      }
    
    function submitTx_forceRegister(address payable participant)
      external
      onlyOwnerOrAdmin
      returns (uint256 transactionId){
        uint256[] memory f_args = new uint256[](1);
        f_args[0] = uint256(participant);
        bytes memory data = TxDataBuilder.buildData(TxDataBuilder.FR_FUNCHASH, f_args);
        transactionId = _base_submitTx(data);
      }
    
    function submitTx_clearFinalWithdrawData(uint256 start_index, uint256 end_index)
      external
      onlyOwnerOrAdmin
      returns (uint256 transactionId){
        uint256[] memory f_args = new uint256[](2);
        f_args[0] = start_index;
        f_args[1] = end_index;
        bytes memory data = TxDataBuilder.buildData(TxDataBuilder.EFWD_FUNCHASH, f_args);
        transactionId = _base_submitTx(data);
      }
      
    
    function submitTx_refundTokensTransferredDirectly(address payable participant, uint256 value)
      external
      onlyOwnerOrAdmin
      returns (uint256 transactionId){
        uint256[] memory f_args = new uint256[](2);
        f_args[0] = uint256(participant);
        f_args[1] = value;
        bytes memory data = TxDataBuilder.buildData(TxDataBuilder.RTTD_FUNCHASH, f_args);
        transactionId = _base_submitTx(data);
      }

}