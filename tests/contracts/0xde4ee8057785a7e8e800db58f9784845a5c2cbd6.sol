{{
  "language": "Solidity",
  "sources": {
    "./Address.sol": {
	  "content": "// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, \"Address: insufficient balance\");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }(\"\");
        require(success, \"Address: unable to send value, recipient may have reverted\");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, \"Address: low-level call failed\");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, \"Address: low-level call with value failed\");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, \"Address: insufficient balance for call\");
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), \"Address: call to non-contract\");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}
"
    },
    "./Context.sol": {
	  "content": "// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

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
abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}
"
    },
    "./Dexe.sol": {
	  "content": "// SPDX-License-Identifier: MIT
pragma solidity 0.7.0;
pragma experimental ABIEncoderV2;

import './Ownable.sol';
import './SafeMath.sol';
import './ERC20Burnable.sol';

import './IPriceFeed.sol';
import './IDexe.sol';

library ExtraMath {
    using SafeMath for uint;

    function divCeil(uint _a, uint _b) internal pure returns(uint) {
        if (_a.mod(_b) > 0) {
            return (_a / _b).add(1);
        }
        return _a / _b;
    }

    function toUInt8(uint _a) internal pure returns(uint8) {
        require(_a <= uint8(-1), 'uint8 overflow');
        return uint8(_a);
    }

    function toUInt32(uint _a) internal pure returns(uint32) {
        require(_a <= uint32(-1), 'uint32 overflow');
        return uint32(_a);
    }

    function toUInt120(uint _a) internal pure returns(uint120) {
        require(_a <= uint120(-1), 'uint120 overflow');
        return uint120(_a);
    }

    function toUInt128(uint _a) internal pure returns(uint128) {
        require(_a <= uint128(-1), 'uint128 overflow');
        return uint128(_a);
    }
}

contract Dexe is Ownable, ERC20Burnable, IDexe {
    using ExtraMath for *;
    using SafeMath for *;

    uint private constant DEXE = 10**18;
    uint private constant USDC = 10**6;
    uint private constant USDT = 10**6;
    uint private constant MONTH = 30 days;
    uint public constant ROUND_SIZE_BASE = 190_476;
    uint public constant ROUND_SIZE = ROUND_SIZE_BASE * DEXE;
    uint public constant FIRST_ROUND_SIZE_BASE = 1_000_000;


    IERC20 public usdcToken;
    IERC20 public usdtToken;
    IPriceFeed public usdtPriceFeed; // Provides USDC per 1 * USDT
    IPriceFeed public dexePriceFeed; // Provides USDC per 1 * DEXE
    IPriceFeed public ethPriceFeed; // Provides USDC per 1 * ETH

    // Deposits are immediately transferred here.
    address payable public treasury;

    enum LockType {
        Staking,
        Foundation,
        Team,
        Partnership,
        School,
        Marketing
    }

    enum ForceReleaseType {
        X7,
        X10,
        X15,
        X20
    }

    struct LockConfig {
        uint32 releaseStart;
        uint32 vesting;
    }

    struct Lock {
        uint128 balance; // Total locked.
        uint128 released; // Released so far.
    }

    uint public averagePrice; // 2-10 rounds average.
    uint public override launchedAfter; // How many seconds passed between sale end and product launch.

    mapping(uint => mapping(address => HolderRound)) internal _holderRounds;
    mapping(address => UserInfo) internal _usersInfo;
    mapping(address => BalanceInfo) internal _balanceInfo;

    mapping(LockType => LockConfig) public lockConfigs;
    mapping(LockType => mapping(address => Lock)) public locks;

    mapping(address => mapping(ForceReleaseType => bool)) public forceReleased;

    uint constant ROUND_DURATION_SEC = 86400;
    uint constant TOTAL_ROUNDS = 22;

    struct Round {
        uint120 totalDeposited; // USDC
        uint128 roundPrice; // USDC per 1 * DEXE
    }

    mapping(uint => Round) public rounds; // Indexes are 1-22.

    // Sunday, September 28, 2020 12:00:00 PM GMT
    uint public constant tokensaleStartDate = 1601294400;
    uint public override constant tokensaleEndDate = tokensaleStartDate + ROUND_DURATION_SEC * TOTAL_ROUNDS;

    event NoteDeposit(address sender, uint value, bytes data);
    event Note(address sender, bytes data);

    modifier noteDeposit() {
        emit NoteDeposit(_msgSender(), msg.value, msg.data);
        _;
    }

    modifier note() {
        emit Note(_msgSender(), msg.data);
        _;
    }

    constructor(address _distributor) ERC20('Dexe', 'DEXE') {
        _mint(address(this), 99_000_000 * DEXE);

        // Market Liquidity Fund.
        _mint(_distributor, 1_000_000 * DEXE);

        // Staking rewards are locked on the Dexe itself.
        locks[LockType.Staking][address(this)].balance = 10_000_000.mul(DEXE).toUInt128();

        locks[LockType.Foundation][_distributor].balance = 33_000_000.mul(DEXE).toUInt128();
        locks[LockType.Team][_distributor].balance = 20_000_000.mul(DEXE).toUInt128();
        locks[LockType.Partnership][_distributor].balance = 16_000_000.mul(DEXE).toUInt128();
        locks[LockType.School][_distributor].balance = 10_000_000.mul(DEXE).toUInt128();
        locks[LockType.Marketing][_distributor].balance = 5_000_000.mul(DEXE).toUInt128();

        lockConfigs[LockType.Staking].releaseStart = (tokensaleEndDate).toUInt32();
        lockConfigs[LockType.Staking].vesting = (365 days).toUInt32();

        lockConfigs[LockType.Foundation].releaseStart = (tokensaleEndDate + 365 days).toUInt32();
        lockConfigs[LockType.Foundation].vesting = (1460 days).toUInt32();

        lockConfigs[LockType.Team].releaseStart = (tokensaleEndDate + 180 days).toUInt32();
        lockConfigs[LockType.Team].vesting = (730 days).toUInt32();

        lockConfigs[LockType.Partnership].releaseStart = (tokensaleEndDate + 90 days).toUInt32();
        lockConfigs[LockType.Partnership].vesting = (365 days).toUInt32();

        lockConfigs[LockType.School].releaseStart = (tokensaleEndDate + 60 days).toUInt32();
        lockConfigs[LockType.School].vesting = (365 days).toUInt32();

        lockConfigs[LockType.Marketing].releaseStart = (tokensaleEndDate + 30 days).toUInt32();
        lockConfigs[LockType.Marketing].vesting = (365 days).toUInt32();

        treasury = payable(_distributor);
    }

    function setUSDTTokenAddress(IERC20 _address) external onlyOwner() note() {
        usdtToken = _address;
    }

    function setUSDCTokenAddress(IERC20 _address) external onlyOwner() note() {
        usdcToken = _address;
    }

    function setUSDTFeed(IPriceFeed _address) external onlyOwner() note() {
        usdtPriceFeed = _address;
    }

    function setDEXEFeed(IPriceFeed _address) external onlyOwner() note() {
        dexePriceFeed = _address;
    }

    function setETHFeed(IPriceFeed _address) external onlyOwner() note() {
        ethPriceFeed = _address;
    }

    function setTreasury(address payable _address) external onlyOwner() note() {
        require(_address != address(0), 'Not zero address required');

        treasury = _address;
    }

    function addToWhitelist(address _address, uint _limit) external onlyOwner() note() {
        _updateWhitelist(_address, _limit);
    }

    function removeFromWhitelist(address _address) external onlyOwner() note() {
        _updateWhitelist(_address, 0);
    }

    function _updateWhitelist(address _address, uint _limit) private {
        _usersInfo[_address].firstRoundLimit = _limit.toUInt120();
    }

    // For UI purposes.
    function getAllRounds() external view returns(Round[22] memory) {
        Round[22] memory _result;
        for (uint i = 1; i <= 22; i++) {
            _result[i-1] = rounds[i];
        }
        return _result;
    }

    // For UI purposes.
    function getFullHolderInfo(address _holder) external view
    returns(
        UserInfo memory _info,
        HolderRound[22] memory _rounds,
        Lock[6] memory _locks,
        bool _isWhitelisted,
        bool[4] memory _forceReleases,
        uint _balance
    ) {
        _info = _usersInfo[_holder];
        for (uint i = 1; i <= 22; i++) {
            _rounds[i-1] = _holderRounds[i][_holder];
        }
        for (uint i = 0; i < 6; i++) {
            _locks[i] = locks[LockType(i)][_holder];
        }
        _isWhitelisted = _usersInfo[_holder].firstRoundLimit > 0;
        for (uint i = 0; i < 4; i++) {
            _forceReleases[i] = forceReleased[_holder][ForceReleaseType(i)];
        }
        _balance = balanceOf(_holder);
        return (_info, _rounds, _locks, _isWhitelisted, _forceReleases, _balance);
    }

    // Excludes possibility of unexpected price change.
    function prepareDistributionPrecise(uint _round, uint _botPriceLimit, uint _topPriceLimit)
    external onlyOwner() note() {
        uint _currentPrice = updateAndGetCurrentPrice();
        require(_botPriceLimit <= _currentPrice && _currentPrice <= _topPriceLimit,
           'Price is out of range');

        _prepareDistribution(_round);
    }

    // Should be performed in the last hour of every round.
    function prepareDistribution(uint _round) external onlyOwner() note() {
        _prepareDistribution(_round);
    }

    function _prepareDistribution(uint _round) private {
        require(isRoundDepositsEnded(_round),
            'Deposit round not ended');

        Round memory _localRound = rounds[_round];
        require(_localRound.roundPrice == 0, 'Round already prepared');
        require(_round > 0 && _round < 23, 'Round is not valid');

        if (_round == 1) {
            _localRound.roundPrice = _localRound.totalDeposited.divCeil(FIRST_ROUND_SIZE_BASE).toUInt128();

            // If nobody deposited.
            if (_localRound.roundPrice == 0) {
                _localRound.roundPrice = 1;
            }
            rounds[_round].roundPrice = _localRound.roundPrice;
            return;
        }

        require(isRoundPrepared(_round.sub(1)), 'Previous round not prepared');

        uint _localRoundPrice = updateAndGetCurrentPrice();
        uint _totalTokensSold = _localRound.totalDeposited.mul(DEXE) / _localRoundPrice;

        if (_totalTokensSold < ROUND_SIZE) {
            // Apply 0-10% discount based on how much tokens left. Empty round applies 10% discount.
            _localRound.roundPrice =
                (uint(9).mul(ROUND_SIZE_BASE).mul(_localRoundPrice).add(_localRound.totalDeposited)).divCeil(
                uint(10).mul(ROUND_SIZE_BASE)).toUInt128();
            uint _discountedTokensSold = _localRound.totalDeposited.mul(DEXE) / _localRound.roundPrice;

            rounds[_round].roundPrice = _localRound.roundPrice;
            _burn(address(this), ROUND_SIZE.sub(_discountedTokensSold));
        } else {
            // Round overflown, calculate price based on even spread of available tokens.
            rounds[_round].roundPrice = _localRound.totalDeposited.divCeil(ROUND_SIZE_BASE).toUInt128();
        }

        if (_round == 10) {
            uint _averagePrice;
            for (uint i = 2; i <= 10; i++) {
                _averagePrice = _averagePrice.add(rounds[i].roundPrice);
            }

            averagePrice = _averagePrice / 9;
        }
    }

    // Receive tokens/rewards for all processed rounds.
    function receiveAll() public {
        _receiveAll(_msgSender());
    }

    function _receiveAll(address _holder) private {
        // Holder received everything.
        if (_holderRounds[TOTAL_ROUNDS][_holder].status == HolderRoundStatus.Received) {
            return;
        }

        // Holder didn't participate in the sale.
        if (_usersInfo[_holder].firstRoundDeposited == 0) {
            return;
        }

        if (_notPassed(tokensaleStartDate)) {
            return;
        }

        uint _currentRound = currentRound();

        for (uint i = _usersInfo[_holder].firstRoundDeposited; i < _currentRound; i++) {
            // Skip received rounds.
            if (_holderRounds[i][_holder].status == HolderRoundStatus.Received) {
                continue;
            }

            Round memory _localRound = rounds[i];
            require(_localRound.roundPrice > 0, 'Round is not prepared');

            _holderRounds[i][_holder].status = HolderRoundStatus.Received;
            _receiveDistribution(i, _holder, _localRound);
            _receiveRewards(i, _holder, _localRound);
        }
    }

    // Receive tokens based on the deposit.
    function _receiveDistribution(uint _round, address _holder, Round memory _localRound) private {
        HolderRound memory _holderRound = _holderRounds[_round][_holder];
        uint _balance = _holderRound.deposited.mul(DEXE) / _localRound.roundPrice;

        uint _endBalance = _holderRound.endBalance.add(_balance);
        _holderRounds[_round][_holder].endBalance = _endBalance.toUInt128();
        if (_round < TOTAL_ROUNDS) {
            _holderRounds[_round.add(1)][_holder].endBalance =
                _holderRounds[_round.add(1)][_holder].endBalance.add(_endBalance).toUInt128();
        }
        _transfer(address(this), _holder, _balance);
    }

    // Receive rewards based on the last round balance, participation in 1st round and this round fill.
    function _receiveRewards(uint _round, address _holder, Round memory _localRound) private {
        if (_round > 21) {
            return;
        }
        HolderRound memory _holderRound = _holderRounds[_round][_holder];

        uint _reward;
        if (_round == 1) {
            // First round is always 5%.
            _reward = (_holderRound.endBalance).mul(5) / 100;
        } else {
            uint _x2 = 1;
            uint _previousRoundBalance = _holderRounds[_round.sub(1)][_holder].endBalance;

            // Double reward if increased balance since last round by 1%+.
            if (_previousRoundBalance > 0 &&
                (_previousRoundBalance.mul(101) / 100) < _holderRound.endBalance)
            {
                _x2 = 2;
            }

            uint _roundPrice = _localRound.roundPrice;
            uint _totalDeposited = _localRound.totalDeposited;
            uint _holderBalance = _holderRound.endBalance;
            uint _minPercent = 2;
            uint _maxBonusPercent = 6;
            if (_holderRounds[1][_holder].endBalance > 0) {
                _minPercent = 5;
                _maxBonusPercent = 15;
            }
            // Apply reward modifiers in the following way:
            // 1. If participated in round 1, then the base is 5%, otherwise 2%.
            // 2. Depending on the round fill 0-100% get extra 15-0% (round 1 participants) or 6-0%.
            // 3. Double reward if increased balance since last round by 1%+.
            _reward = _minPercent.add(_maxBonusPercent).mul(_roundPrice).mul(ROUND_SIZE_BASE)
                .sub(_maxBonusPercent.mul(_totalDeposited)).mul(_holderBalance).mul(_x2) /
                100.mul(_roundPrice).mul(ROUND_SIZE_BASE);
        }

        uint _rewardsLeft = locks[LockType.Staking][address(this)].balance;
        // If not enough left, give everything.
        if (_rewardsLeft < _reward) {
            _reward = _rewardsLeft;
        }

        locks[LockType.Staking][_holder].balance =
            locks[LockType.Staking][_holder].balance.add(_reward).toUInt128();
        locks[LockType.Staking][address(this)].balance = _rewardsLeft.sub(_reward).toUInt128();
    }

    function depositUSDT(uint _amount) external note() {
        usdtToken.transferFrom(_msgSender(), treasury, _amount);
        uint _usdcAmount = _amount.mul(usdtPriceFeed.updateAndConsult()) / USDT;
        _deposit(_usdcAmount);
    }

    function depositETH() payable external noteDeposit() {
        _depositETH();
    }

    receive() payable external noteDeposit() {
        _depositETH();
    }

    function _depositETH() private {
        treasury.transfer(msg.value);
        uint _usdcAmount = msg.value.mul(ethPriceFeed.updateAndConsult()) / 1 ether;
        _deposit(_usdcAmount);
    }

    function depositUSDC(uint _amount) external note() {
        usdcToken.transferFrom(_msgSender(), treasury, _amount);
        _deposit(_amount);
    }

    function _deposit(uint _amount) private {
        uint _depositRound = depositRound();
        uint _newDeposited = _holderRounds[_depositRound][_msgSender()].deposited.add(_amount);
        uint _limit = _usersInfo[_msgSender()].firstRoundLimit;
        if (_depositRound == 1) {
            require(_limit > 0, 'Not whitelisted');
            require(_newDeposited <= _limit, 'Deposit limit is reached');
        }
        require(_amount >= 1 * USDC, 'Less than minimum amount 1 usdc');

        _holderRounds[_depositRound][_msgSender()].deposited = _newDeposited.toUInt120();

        rounds[_depositRound].totalDeposited = rounds[_depositRound].totalDeposited.add(_amount).toUInt120();

        if (_usersInfo[_msgSender()].firstRoundDeposited == 0) {
            _usersInfo[_msgSender()].firstRoundDeposited = _depositRound.toUInt8();
        }
    }

    // In case someone will send USDC/USDT/SomeToken directly.
    function withdrawLocked(IERC20 _token, address _receiver, uint _amount) external onlyOwner() note() {
        require(address(_token) != address(this), 'Cannot withdraw this');
        _token.transfer(_receiver, _amount);
    }

    function currentRound() public view returns(uint) {
        require(_passed(tokensaleStartDate), 'Tokensale not started yet');
        if (_passed(tokensaleEndDate)) {
            return 23;
        }

        return _since(tokensaleStartDate).divCeil(ROUND_DURATION_SEC);
    }

    // Deposit round ends 1 hour before the end of each round.
    function depositRound() public view returns(uint) {
        require(_passed(tokensaleStartDate), 'Tokensale not started yet');
        require(_notPassed(tokensaleEndDate.sub(1 hours)), 'Deposits ended');

        return _since(tokensaleStartDate).add(1 hours).divCeil(ROUND_DURATION_SEC);
    }

    function isRoundDepositsEnded(uint _round) public view returns(bool) {
        return _passed(ROUND_DURATION_SEC.mul(_round).add(tokensaleStartDate).sub(1 hours));
    }

    function isRoundPrepared(uint _round) public view returns(bool) {
        return rounds[_round].roundPrice > 0;
    }

    function currentPrice() public view returns(uint) {
        return dexePriceFeed.consult();
    }

    function updateAndGetCurrentPrice() public returns(uint) {
        return dexePriceFeed.updateAndConsult();
    }

    function _passed(uint _time) private view returns(bool) {
        return block.timestamp > _time;
    }

    function _notPassed(uint _time) private view returns(bool) {
        return _not(_passed(_time));
    }

    function _not(bool _condition) private pure returns(bool) {
        return !_condition;
    }

    // Get released tokens to the main balance.
    function releaseLock(LockType _lock) external note() {
        _release(_lock, _msgSender());
    }

    // Assign locked tokens to another holder.
    function transferLock(LockType _lockType, address _to, uint _amount) external note() {
        receiveAll();
        Lock memory _lock = locks[_lockType][_msgSender()];
        require(_lock.released == 0, 'Cannot transfer after release');
        require(_lock.balance >= _amount, 'Insuffisient locked funds');

        locks[_lockType][_msgSender()].balance = _lock.balance.sub(_amount).toUInt128();
        locks[_lockType][_to].balance = locks[_lockType][_to].balance.add(_amount).toUInt128();
    }

    function _release(LockType _lockType, address _holder) private {
        LockConfig memory _lockConfig = lockConfigs[_lockType];
        require(_passed(_lockConfig.releaseStart),
            'Releasing has no started yet');

        Lock memory _lock = locks[_lockType][_holder];
        uint _balance = _lock.balance;
        uint _released = _lock.released;

        uint _balanceToRelease =
            _balance.mul(_since(_lockConfig.releaseStart)) / _lockConfig.vesting;

        // If more than enough time already passed, release what is left.
        if (_balanceToRelease > _balance) {
            _balanceToRelease = _balance;
        }

        require(_balanceToRelease > _released, 'Insufficient unlocked');

        // Underflow cannot happen here, SafeMath usage left for code style.
        uint _amount = _balanceToRelease.sub(_released);

        locks[_lockType][_holder].released = _balanceToRelease.toUInt128();
        _transfer(address(this), _holder, _amount);
    }


    // Wrap call to updateAndGetCurrentPrice() function before froceReleaseStaking on UI to get
    // most up-to-date price.
    // In case price increased enough since average, allow holders to release Staking rewards with a fee.
    function forceReleaseStaking(ForceReleaseType _forceReleaseType) external note() {
        uint _currentRound = currentRound();
        require(_currentRound > 10, 'Only after 10 round');
        receiveAll();
        Lock memory _lock = locks[LockType.Staking][_msgSender()];
        require(_lock.balance > 0, 'Nothing to force unlock');

        uint _priceMul;
        uint _unlockedPart;
        uint _receivedPart;

        if (_forceReleaseType == ForceReleaseType.X7) {
            _priceMul = 7;
            _unlockedPart = 10;
            _receivedPart = 86;
        } else if (_forceReleaseType == ForceReleaseType.X10) {
            _priceMul = 10;
            _unlockedPart = 15;
            _receivedPart = 80;
        } else if (_forceReleaseType == ForceReleaseType.X15) {
            _priceMul = 15;
            _unlockedPart = 20;
            _receivedPart = 70;
        } else {
            _priceMul = 20;
            _unlockedPart = 30;
            _receivedPart = 60;
        }

        require(_not(forceReleased[_msgSender()][_forceReleaseType]), 'Already force released');

        forceReleased[_msgSender()][_forceReleaseType] = true;

        require(updateAndGetCurrentPrice() >= averagePrice.mul(_priceMul), 'Current price is too small');

        uint _balance = _lock.balance.sub(_lock.released);

        uint _released = _balance.mul(_unlockedPart) / 100;
        uint _receiveAmount = _released.mul(_receivedPart) / 100;
        uint _burned = _released.sub(_receiveAmount);

        locks[LockType.Staking][_msgSender()].released = _lock.released.add(_released).toUInt128();

        if (_currentRound <= TOTAL_ROUNDS) {
            _holderRounds[_currentRound][_msgSender()].endBalance =
                _holderRounds[_currentRound][_msgSender()].endBalance.add(_receiveAmount).toUInt128();
        }
        _burn(address(this), _burned);
        _transfer(address(this), _msgSender(), _receiveAmount);
    }

    function launchProduct() external onlyOwner() note() {
        require(_passed(tokensaleEndDate), 'Tokensale is not ended yet');
        require(launchedAfter == 0, 'Product already launched');
        require(isTokensaleProcessed(), 'Tokensale is not processed');

        launchedAfter = _since(tokensaleEndDate);
    }

    function isTokensaleProcessed() private view returns(bool) {
        return rounds[TOTAL_ROUNDS].roundPrice > 0;
    }

    // Zero address and Dexe itself are not considered as valid holders.
    function _isHolder(address _addr) private view returns(bool) {
        if (_addr == address(this) || _addr == address(0)) {
            return false;
        }
        return true;
    }

    // Happen before every transfer to update all the metrics.
    function _beforeTokenTransfer(address _from, address _to, uint _amount) internal override {
        if (_isHolder(_from)) {
            // Automatically receive tokens/rewards for previous rounds.
            _receiveAll(_from);
        }

        if (_notPassed(tokensaleEndDate)) {
            uint _round = 1;
            if (_passed(tokensaleStartDate)) {
                _round = currentRound();
            }

            if (_isHolder(_from)) {
                _holderRounds[_round][_from].endBalance =
                    _holderRounds[_round][_from].endBalance.sub(_amount).toUInt128();
            }
            if (_isHolder(_to)) {
                UserInfo memory _userToInfo = _usersInfo[_to];
                if (_userToInfo.firstRoundDeposited == 0) {
                    _usersInfo[_to].firstRoundDeposited = _round.toUInt8();
                }
                if (_from != address(this)) {
                    _holderRounds[_round][_to].endBalance =
                        _holderRounds[_round][_to].endBalance.add(_amount).toUInt128();
                }
            }
        }

        if (launchedAfter == 0) {
            if (_isHolder(_from)) {
                _usersInfo[_from].balanceBeforeLaunch = _usersInfo[_from].balanceBeforeLaunch.sub(_amount).toUInt128();
            }
            if (_isHolder(_to)) {
                _usersInfo[_to].balanceBeforeLaunch = _usersInfo[_to].balanceBeforeLaunch.add(_amount).toUInt128();
                if (_balanceInfo[_to].firstBalanceChange == 0) {
                    _balanceInfo[_to].firstBalanceChange = block.timestamp.toUInt32();
                    _balanceInfo[_to].lastBalanceChange = block.timestamp.toUInt32();
                }
            }
        }
        _updateBalanceAverage(_from);
        _updateBalanceAverage(_to);
    }

    function _since(uint _timestamp) private view returns(uint) {
        return block.timestamp.sub(_timestamp);
    }

    function launchDate() public override view returns(uint) {
        uint _launchedAfter = launchedAfter;
        if (_launchedAfter == 0) {
            return 0;
        }
        return tokensaleEndDate.add(_launchedAfter);
    }

    function _calculateBalanceAverage(address _holder) private view returns(BalanceInfo memory) {
        BalanceInfo memory _user = _balanceInfo[_holder];
        if (!_isHolder(_holder)) {
            return _user;
        }

        uint _lastBalanceChange = _user.lastBalanceChange;
        uint _balance = balanceOf(_holder);
        uint _launchDate = launchDate();
        bool _notLaunched = _launchDate == 0;
        uint _accumulatorTillNow = _user.balanceAccumulator
            .add(_balance.mul(_since(_lastBalanceChange)));

        if (_notLaunched) {
            // Last update happened in the current before launch period.
            _user.balanceAccumulator = _accumulatorTillNow;
            _user.balanceAverage = (_accumulatorTillNow /
                _since(_user.firstBalanceChange)).toUInt128();
            _user.lastBalanceChange = block.timestamp.toUInt32();
            return _user;
        }

        // Calculating the end of the last average period.
        uint _timeEndpoint = _since(_launchDate).div(MONTH).mul(MONTH).add(_launchDate);
        if (_lastBalanceChange >= _timeEndpoint) {
            // Last update happened in the current average period.
            _user.balanceAccumulator = _accumulatorTillNow;
        } else {
            // Last update happened before the current average period.
            uint _sinceLastBalanceChangeToEndpoint = _timeEndpoint.sub(_lastBalanceChange);
            uint _accumulatorAtTheEndpoint = _user.balanceAccumulator
                .add(_balance.mul(_sinceLastBalanceChangeToEndpoint));

            if (_timeEndpoint == _launchDate) {
                // Last update happened before the launch period.
                _user.balanceAverage = (_accumulatorAtTheEndpoint /
                    _timeEndpoint.sub(_user.firstBalanceChange)).toUInt128();
            } else if (_sinceLastBalanceChangeToEndpoint <= MONTH) {
                // Last update happened in the previous average period.
                _user.balanceAverage = (_accumulatorAtTheEndpoint / MONTH).toUInt128();
            } else {
                // Last update happened before the previous average period.
                _user.balanceAverage = _balance.toUInt128();
            }

            _user.balanceAccumulator = _balance.mul(_since(_timeEndpoint));
        }

        _user.lastBalanceChange = block.timestamp.toUInt32();
        return _user;
    }

    function _updateBalanceAverage(address _holder) private {
        if (_balanceInfo[_holder].lastBalanceChange == block.timestamp) {
            return;
        }
        _balanceInfo[_holder] = _calculateBalanceAverage(_holder);
    }

    function getAverageBalance(address _holder) external override view returns(uint) {
        return _calculateBalanceAverage(_holder).balanceAverage;
    }

    function firstBalanceChange(address _holder) external override view returns(uint) {
        return _balanceInfo[_holder].firstBalanceChange;
    }

    function holderRounds(uint _round, address _holder) external override view returns(
        HolderRound memory
    ) {
        return _holderRounds[_round][_holder];
    }

    function usersInfo(address _holder) external override view returns(
        UserInfo memory
    ) {
        return _usersInfo[_holder];
    }
}
"
    },
	"./ERC20.sol": {
	  "content": "// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

import \"./Context.sol\";
import \"./IERC20.sol\";
import \"./SafeMath.sol\";
import \"./Address.sol\";

/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin guidelines: functions revert instead
 * of returning `false` on failure. This behavior is nonetheless conventional
 * and does not conflict with the expectations of ERC20 applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 */
contract ERC20 is Context, IERC20 {
    using SafeMath for uint256;
    using Address for address;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    /**
     * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
     * a default value of 18.
     *
     * To select a different value for {decimals}, use {_setupDecimals}.
     *
     * All three of these values are immutable: they can only be set once during
     * construction.
     */
    constructor (string memory name, string memory symbol) {
        _name = name;
        _symbol = symbol;
        _decimals = 18;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
     * called.
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view returns (uint8) {
        return _decimals;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
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
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20};
     *
     * Requirements:
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for ``sender``'s tokens of at least
     * `amount`.
     */
    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, \"ERC20: transfer amount exceeds allowance\"));
        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, \"ERC20: decreased allowance below zero\"));
        return true;
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), \"ERC20: transfer from the zero address\");
        require(recipient != address(0), \"ERC20: transfer to the zero address\");

        _beforeTokenTransfer(sender, recipient, amount);

        _balances[sender] = _balances[sender].sub(amount, \"ERC20: transfer amount exceeds balance\");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements
     *
     * - `to` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), \"ERC20: mint to the zero address\");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), \"ERC20: burn from the zero address\");

        _beforeTokenTransfer(account, address(0), amount);

        _balances[account] = _balances[account].sub(amount, \"ERC20: burn amount exceeds balance\");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), \"ERC20: approve from the zero address\");
        require(spender != address(0), \"ERC20: approve to the zero address\");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Sets {decimals} to a value other than the default one of 18.
     *
     * WARNING: This function should only be called from the constructor. Most
     * applications that interact with token contracts will not expect
     * {decimals} to ever change, and may work incorrectly if it does.
     */
    function _setupDecimals(uint8 decimals_) internal {
        _decimals = decimals_;
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be to transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
}
"
    },
    "./ERC20Burnable.sol": {
	  "content": "// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

import \"./Context.sol\";
import \"./ERC20.sol\";

/**
 * @dev Extension of {ERC20} that allows token holders to destroy both their own
 * tokens and those that they have an allowance for, in a way that can be
 * recognized off-chain (via event analysis).
 */
abstract contract ERC20Burnable is Context, ERC20 {
    using SafeMath for uint256;

    /**
     * @dev Destroys `amount` tokens from the caller.
     *
     * See {ERC20-_burn}.
     */
    function burn(uint256 amount) public virtual {
        _burn(_msgSender(), amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, deducting from the caller's
     * allowance.
     *
     * See {ERC20-_burn} and {ERC20-allowance}.
     *
     * Requirements:
     *
     * - the caller must have allowance for ``accounts``'s tokens of at least
     * `amount`.
     */
    function burnFrom(address account, uint256 amount) public virtual {
        uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, \"ERC20: burn amount exceeds allowance\");

        _approve(account, _msgSender(), decreasedAllowance);
        _burn(account, amount);
    }
}
"
    },
	"./IDexe.sol": {
	  "content": "// SPDX-License-Identifier: MIT
pragma solidity 0.7.0;
pragma experimental ABIEncoderV2;

import './IERC20.sol';

interface IDexe is IERC20 {
    enum HolderRoundStatus {None, Received}

    struct HolderRound {
        uint120 deposited; // USDC
        uint128 endBalance; // DEXE
        HolderRoundStatus status;
    }

    struct UserInfo {
        uint128 balanceBeforeLaunch; // Final balance before product launch.
        uint120 firstRoundLimit; // limit of USDC that could deposited in first round
        uint8 firstRoundDeposited; // First round when holder made a deposit or received DEXE.
    }

    struct BalanceInfo {
        uint32 firstBalanceChange; // Timestamp of first tokens receive.
        uint32 lastBalanceChange; // Timestamp of last balance change.
        uint128 balanceAverage; // Average balance for the previous period.
        uint balanceAccumulator; // Accumulates average for current period.
    }

    function launchedAfter() external view returns (uint);
    function launchDate() external view returns(uint);
    function tokensaleEndDate() external view returns (uint);
    function holderRounds(uint _round, address _holder) external view returns(HolderRound memory);
    function usersInfo(address _holder) external view returns(UserInfo memory);
    function getAverageBalance(address _holder) external view returns(uint);
    function firstBalanceChange(address _holder) external view returns(uint);
}
"
    },
	"./IERC20.sol": {
	  "content": "// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

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
"
    },
	"./Ownable.sol": {
	  "content": "// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

import \"./Context.sol\";
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
        require(_owner == _msgSender(), \"Ownable: caller is not the owner\");
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
        require(newOwner != address(0), \"Ownable: new owner is the zero address\");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}
"
    },
	"./IPriceFeed.sol": {
	  "content": "// SPDX-License-Identifier: MIT
pragma solidity >= 0.6.5 <= 0.7.0;

interface IPriceFeed {
    function update() external returns(uint);
    function consult() external view returns (uint);
    function updateAndConsult() external returns (uint);
}
"
    },
	"./SafeMath.sol": {
	  "content": "// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

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
        require(c >= a, \"SafeMath: addition overflow\");

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
        return sub(a, b, \"SafeMath: subtraction overflow\");
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
        require(c / a == b, \"SafeMath: multiplication overflow\");

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
        return div(a, b, \"SafeMath: division by zero\");
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
        return mod(a, b, \"SafeMath: modulo by zero\");
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
"
    }
  },
  "settings": {
   "evmVersion":"istanbul",
   "libraries":{
   },
   "metadata":{
      "bytecodeHash":"ipfs"
   },
   "optimizer":{
      "enabled":true,
      "runs":10000
   },
   "remappings":[],
   "outputSelection": {
      "*": {
        "*": [
			"metadata",
			"abi",
			"evm.deployedBytecode",
			"evm.bytecode"
        ]
      }
    }
  }
}}