pragma solidity 0.5.16;

// @title SelfDestructingSender
// @notice Sends funds to any address using selfdestruct to bypass fallbacks.
// @dev Is invoked by the _forceTransfer() function in the Game contract.
contract SelfDestructingSender {
    constructor(address payable payee) public payable {
        selfdestruct(payee);
    }
}


// @title Game
// @notice A money game in which only one player can lose. Everyone else leaves with more money than they started with.
// Dozens may play. Only one will lose.
// @dev The UI will initially launch at playescalation.com. If that site ever goes down, look for an `Announce` event at
// https://etherscan.io/address/0xbea62796855548154464f6c8e7bc92672c9f87b8#events for where to find the latest UI.
// IMPORTANT: This is not an investment scheme. This is a game. There is up to one loser per game and that could be you.
// IMPORTANT: Do not play with more money than you are comfortable losing.
// IMPORTANT: It is *impossible* to get back any money you lose, because that money is used to pay out all the other players.
// IMPORTANT: The creators of this game have no control over this game or the payouts. This code is autonomous.
// IMPORTANT: By interacting with this contract you agree to not hold the creators responsible for any loses you may incur. Use it at your own risk.
// IMPORTANT: Have fun and play responsibly!
// @dev This game works as follows:
// - To ready the game, at least 0.0435 ETH is donated to the contract. Anyone can do this. It will probably be done by the game creators.
// - Then anyone can start the game by calling the `firstPlay` function, which requires staking exactly 0.05 ETH with this contract.
// - This starts a countdown clock that counts down from 30 minutes.
// - During the 30 minutes, anyone can play by calling the `play` function, which requires staking funds with this contract.
// - Each play of the game causes the countdown timer to be reset back to 30 minutes.
// - Each successive play of the game requires a stake that is exactly 15% larger than the previous stake.
// - The game ends when the countdown clock gets to 0.
// - If two or more people play after you then you are a "small winner" and you are instantly given your stake back plus an additional 10% profit.
// -    This "small winner" payout happens automatically, as soon as the second player after you plays.
// -    You do not need to wait until the game ends to get paid. You are paid out instantly, with no need to send a withdrawal transaction.
// - If nobody plays after you then you are a "big winner" and, when the clock gets to 0, you are given your stake back plus an additional 20% profit.
// -    This "big winner" payout happens automatically when the game is reset.
// -    Anyone can reset the game by calling the `reset` function. It costs only gas.
// - If *exactly one* other person has played after you when the countdown clock gets to 0 then you are the game's only loser. You lose your stake.
// -    That is, if you are the one sorry bastard who ends up in second place when the countdown clock gets to 0, you lose.
// -    The only way to lose money in this game is to be the second to last person who played.
// - TL;DR: So long as you are not in second place when the countdown clock gets to 0, you will leave with more money that you started with.
//
// NOTES:
// - It is okay for a person to play more than once during a game. Each deposit is treated as a distinct play. The identity of the depositor is not important.
//      For example, if you want to, you can put the profit won from an earlier play towards a later play. Or even play several times in a row.
// - If the countdown clock is getting close to 0 and you are in second place, one possible way to avoid losing your stake
//      is to play again (but only if you are comfortable putting more money at risk). This would knock your old play out of second place
//      so you would get it back immediately, along with 10% profit, and your new deposit would have a chance at being the "big winner".
// - This contract itself can accumulate funds over time. These funds are used to seed future rounds of the game.
//      This seeding of the next round happens automatically when the `reset` function is called.
// - If you ever find that nobody is paying attention to this contract and it has money in it, you can profit from that by being
//      the first player. If nobody else is paying attention then you will also be the last player because nobody will play after you.
//      This means you'll get your deposit back plus 20% profit. You can repeat this over and over until this contract is drained of all its funds.
// - To any copycats thinking of offering similar games and just tweaking the constants: please be very careful.
//      The maths behind the choice of constants is extremely sensitive, and it is easy to introduce critical insolvency vulnerabilities if you
//      don't know what you are doing. This contract was created and rigorously tested by experienced contract developers. If you want to make
//      changes to it please write full integration tests to be sure your choice of constants will not cause security issues.
contract Game {
    using SafeMath for uint256;

    // ======
    // EVENTS
    // ======

    event Action(
        uint256 indexed gameNumber,
        uint256 indexed depositNumber,
        address indexed depositorAddress,
        uint256 block,
        uint256 time,
        address payoutProof, // address of the SelfDestructingSender contract that paid out the `(depositNumber - 2)th` deposit
        bool gameOver
    );

    // ======================================================================
    // CONSTANTS
    // SECURITY: DO NOT CHANGE THESE CONSTANTS! THEY ARE NOT ARBITRARY!
    // CHANGING THESE CONSTANTS MAY RESULT IN AN INSOLVENCY VULNERABILITY!
    // ======================================================================

    uint256 constant internal DEPOSIT_INCREMENT_PERCENT = 15;
    uint256 constant internal BIG_REWARD_PERCENT = 20;
    uint256 constant internal SMALL_REWARD_PERCENT = 10;
    uint256 constant internal MAX_TIME = 30 minutes;
    uint256 constant internal NEVER = uint256(-1);
    uint256 constant internal INITIAL_INCENTIVE = 0.0435 ether;
    address payable constant internal _designers = 0xBea62796855548154464F6C8E7BC92672C9F87b8; // address has no power

    // =========
    // VARIABLES
    // =========

    uint256 public endTime; // UNIX timestamp of when the current game ends
    uint256 public escrow; // the amount of ETH (in wei) currently held in the game's escrow
    uint256 public currentGameNumber;
    uint256 public currentDepositNumber;
    address payable[2] public topDepositors; // stores the addresses of the 2 most recent depositors
    // NOTE: topDepositors[0] is the most recent depositor
    mapping (uint256 => uint256) public requiredDeposit; // maps `n` to the required deposit size (in wei) required for the `n`th play
    // NOTE: in practice, the parameter `n` should never exceed 200, since by then the required deposit would be more ETH than exists.
    uint256[] internal _startBlocks; // for front-end use only: game number i starts at _startBlocks[i]
    bool internal _gameStarted;

    // ============
    // CUSTOM TYPES
    // ============

    // the states of the state machine
    enum GameState {NEEDS_DONATION, READY_FOR_FIRST_PLAY, IN_PROGRESS, GAME_OVER}

    // =========
    // MODIFIERS
    // =========

    // prevents transactions meant for one game from being used in a subsequent game
    modifier currentGame(uint256 gameNumber) {
        require(gameNumber == currentGameNumber, "Wrong game number.");
        _;
    }

    // ensures that the deposit provided is exactly the amount of the current required deposit
    modifier exactDeposit() {
        require(
            msg.value == requiredDeposit[currentDepositNumber],
            "Incorrect deposit amount. Perhaps another player got their txn mined before you. Try again."
        );
        _;
    }

    // ========================
    // FALLBACK AND CONSTRUCTOR
    // ========================

    // SECURITY: Fallback must NOT be payable
    // This prevents players from losing money if they attempt to play by sending money directly to
    // this contract instead of calling one of the play functions
    // Any funds sent to this contract via self-destruct will be applied to the INITIAL_INCENTIVE of subsequent games
    function() external { }

    constructor() public {
        endTime = NEVER;
        currentGameNumber = 1;
        currentDepositNumber = 1;
        _startBlocks.push(0);

        // Here we are precomputing and storing values that we will use later
        // These values will be needed during every play of the game and they are expensive to compute
        // So we compute them up front and store them to save the players gas later
        // These are the required sizes (in wei) of the `depositNumber`th deposit
        // This computes and stores `INITIAL_INCENTIVE * (100 + DEPOSIT_INCREMENT_PERCENT / 100) ^ n`,
        // rounded to 4 (ETH) decimal places, for n=0 to 200.  It must be done using a loop because solidity 0.5 does not
        // support raising fractions to integer powers.
        // SECURITY: The argument `depositNumber` will never be larger than 200 (since then the
        // required deposit would be far more ETH than exists).
        // SECURITY: SafeMath not used here for gas efficiency reasons.
        // Since `depositNumber` will never be > 200 and since `INITIAL_INCENTIVE` and
        // `DEPOSIT_INCREMENT_PERCENT` are small and constant, there is no risk of overflow here.
        uint256 value = INITIAL_INCENTIVE;
        uint256 r = DEPOSIT_INCREMENT_PERCENT;
        requiredDeposit[0] = INITIAL_INCENTIVE;
        for (uint256 i = 1; i <= 200; i++) { // `depositNumber` will never exceed 200
            value += value * r / 100;
            requiredDeposit[i] = value / 1e14 * 1e14; // round output to 4 (ETH) decimal places
        }
        // SECURITY: No entries in the requiredDeposit mapping should ever change again
        // SECURITY: After the constructor runs, requiredDeposit should be read-only
    }

    // ============================
    // PRIVATE / INTERNAL FUNCTIONS
    // ============================

    // @notice Transfers ETH to an address without any possibility of failing
    // @param payee The address to which the ETH will be sent
    // @param amount The amount of ETH (in wei) to be sent
    // @return address The address of the SelfDestructingSender contract that delivered the funds
    // @dev This allows us to use a push-payments pattern with no security risk
    // For most applications the gas cost is too high to do this, but for this game
    // the winnings on every deposit (other than the one losing deposit) far exceed the
    // gas costs of this transfer method when players use reasonable gas prices -- for example, under 40 gwei for `firstPlay`
    // @dev NOTE the following security concerns:
    // SECURITY: MUST BE PRIVATE OR INTERNAL!
    // SECURITY: THE PLAYERS MUST BE ABLE TO VERIFY SelfDestructingSender CONTRACT CODE!
    function _forceTransfer(address payable payee, uint256 amount) internal returns (address) {
        return address((new SelfDestructingSender).value(amount)(payee));
    }

    // @notice Computes the current game state
    // @return The current game state
    function _gameState() private view returns (GameState) {
        if (!_gameStarted) {
            // then the game state is either NEEDS_DONATION or READY_FOR_FIRST_PLAY
            if (escrow < INITIAL_INCENTIVE) {
                return GameState.NEEDS_DONATION;
            } else {
                return GameState.READY_FOR_FIRST_PLAY;
            }
        } else {
            // then the game state is either IN_PROGRESS or GAME_OVER
            if (now >= endTime) {
                return GameState.GAME_OVER;
            } else {
                return GameState.IN_PROGRESS;
            }
        }
    }

    // =============================================
    // EXTERNAL FUNCTIONS THAT MODIFY CONTRACT STATE
    // =============================================

    // @notice This is a function used to donate money that will be used to incentivize the first player to play
    // Anyone can donate money, though in practice only the `_designers` likely will since nobody directly benefits from it
    // Donations can be accepted only when the game is in the NEEDS_DONATION state
    // Donations are added to escrow until escrow == INITIAL_INCENTIVE
    // Any remaining donations are kept in address(this).balance and are used to seed future games
    // SECURITY: Can be called only when the game state is NEEDS_DONATION
    function donate() external payable {
        require(_gameState() == GameState.NEEDS_DONATION, "No donations needed.");
        // NOTE: if the game is in the NEEDS_DONATION state then escrow < INITIAL_INCENTIVE
        uint256 maxAmountToPutInEscrow = INITIAL_INCENTIVE.sub(escrow);
        if (msg.value > maxAmountToPutInEscrow) {
            escrow = escrow.add(maxAmountToPutInEscrow);
        } else {
            escrow = escrow.add(msg.value);
        }
    }

    // @notice Used to make the first play of a game
    // @param gameNumber The current gameNumber
    // SECURITY: Can be called only when the game state is READY_FOR_FIRST_PLAY
    // SECURITY: Function call can be front-run. That is acceptable and may be part of game dynamics during competitive play.
    function firstPlay(uint256 gameNumber) external payable currentGame(gameNumber) exactDeposit {
        require(_gameState() == GameState.READY_FOR_FIRST_PLAY, "Game not ready for first play.");

        emit Action(currentGameNumber, currentDepositNumber, msg.sender, block.number, now, address(0), false);

        topDepositors[0] = msg.sender;
        endTime = now.add(MAX_TIME);
        escrow = escrow.add(msg.value);
        currentDepositNumber++;
        _gameStarted = true;
        _startBlocks.push(block.number);
    }

    // @notice Used to make any subsequent play of the game
    // @param gameNumber The current gameNumber
    // SECURITY: Can be called only when the game state is IN_PROGRESS
    // SECURITY: Function call can be front-run. That is acceptable and may be part of game dynamics during competitive play.
    function play(uint256 gameNumber) external payable currentGame(gameNumber) exactDeposit {
        require(_gameState() == GameState.IN_PROGRESS, "Game is not in progress.");

        // We pay out the person who will no longer be the second-largest depositor
        address payable addressToPay = topDepositors[1];
        // They will receive their original deposit back plus SMALL_REWARD_PERCENT percent more
        // NOTE: The first time the `play` function is called `currentDepositNumber` is at least 2, so
        // the subtraction here will never cause a revert
        uint256 amountToPay = requiredDeposit[currentDepositNumber.sub(2)].mul(SMALL_REWARD_PERCENT.add(100)).div(100);

        address payoutProof = address(0);
        if (addressToPay != address(0)) { // we never send money to the zero address
            payoutProof = _forceTransfer(addressToPay, amountToPay);
        }

        // tell the front end what happened
        emit Action(currentGameNumber, currentDepositNumber, msg.sender, block.number, now, payoutProof, false);

        // store the new top depositors
        topDepositors[1] = topDepositors[0];
        topDepositors[0] = msg.sender;
        // reset the clock
        endTime = now.add(MAX_TIME);
        // track the changes to escrow
        // NOTE: even if addressToPay is address(0) we still reduce escrow by amountToPay
        // Any money that would have gone to address(0) is is later put towards the INITIAL_INCENTIVE
        // for the next game (see the end of the `reset` function)
        escrow = escrow.sub(amountToPay).add(msg.value);
        currentDepositNumber++;
    }

    // @notice Used to pay out the final depositor of a game and reset variables for the next game
    // SECURITY: Can be called only when the game state is GAME_OVER
    function reset() external {
        require(_gameState() == GameState.GAME_OVER, "Game is not over.");
        // We pay out the largest depositor
        address payable addressToPay = topDepositors[0];

        // They will receive their original deposit back plus BIG_REWARD_PERCENT percent more
        uint256 amountToPay = requiredDeposit[currentDepositNumber.sub(1)].mul(BIG_REWARD_PERCENT.add(100)).div(100);
        address payoutProof = _forceTransfer(addressToPay, amountToPay);

        // track the payout in escrow
        escrow = escrow.sub(amountToPay);

        // tell the front end what happened
        emit Action(currentGameNumber, currentDepositNumber, address(0), block.number, now, payoutProof, true);

        // if there is anything left in escrow, give it to the _designers as a reward for maintaining the game
        if (escrow > 0) {
            _forceTransfer(_designers, escrow);
        }

        // reset the game vars for the next game
        endTime = NEVER;
        escrow = 0;
        currentGameNumber++;
        currentDepositNumber = 1;
        _gameStarted = false;
        topDepositors[0] = address(0);
        topDepositors[1] = address(0);

        // apply anything left over in address(this).balance to the next game's escrow
        // being sure not to exceed INITIAL_INCENTIVE
        if (address(this).balance > INITIAL_INCENTIVE) {
            escrow = INITIAL_INCENTIVE;
        } else {
            escrow = address(this).balance;
        }
    }

    // =======================
    // EXTERNAL VIEW FUNCTIONS
    // =======================

    // @notice Returns the required deposit size (in wei) required for the next deposit of the game
    function currentRequiredDeposit() external view returns (uint256) {
        return requiredDeposit[currentDepositNumber];
    }

    // @notice Returns the current state of the game
    function gameState() external view returns (GameState) {
        return _gameState();
    }

    // @notice returns the block at which game number `index` began, or 0 if referring to
    // a game that has not yet started
    function startBlocks(uint256 index) external view returns (uint256) {
        if (index >= _startBlocks.length) {
            return 0; // the front-end will handle this properly
        } else {
            return _startBlocks[index];
        }
    }
}




/**
 * @title SafeMath
 * @dev Unsigned math operations with safety checks that revert on error
 */
library SafeMath {
    /**
     * @dev Multiplies two unsigned integers, reverts on overflow.
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
     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Adds two unsigned integers, reverts on overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);

        return c;
    }

    /**
     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
     * reverts when dividing by zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}