pragma solidity 0.5.12;

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


contract MartiGame {
    using SafeMath for uint;
    uint public fee = 5;
    address payable owner;


    /** State
     *
     * - New: 0
     * - Deleted: 1
     * - OnGoing: 2
     * - Closed: 3
     */
    enum State{New, Deleted, OnGoing, Closed}

    struct _game {
        address payable creator;
        address payable responder;
        uint bet;
        uint blocknumber;
        uint id;
        State state;
    }

    _game[] public Games;

    mapping(uint => address) public gameWinner;

    event NewGame(uint indexed game_id, address indexed creator, address indexed responder, uint bet, uint id);
    event RespondGame(uint indexed game_id, address indexed responder);
    event DeleteGame(uint indexed game_id);
    event RefundGame(uint indexed game_id);
    event ResultGame(uint indexed game_id, address indexed winner, uint winAmount);



    constructor() public {
        owner = msg.sender;
    }


    function createGame(address payable _responder, uint _id) payable external {
        Games.push(_game({
            creator : msg.sender,
            responder : _responder,
            bet : msg.value,
            blocknumber : 0,
            state : State.New,
            id : _id
            }));

        emit NewGame(Games.length - 1, msg.sender, _responder, msg.value, _id);
    }


    function respondGame(uint _gameID) payable external {
        _game storage game = Games[_gameID];

        require(game.state == State.New, '01');
        require(game.bet == msg.value, '02');
        require(game.responder == msg.sender, '03');

        game.state = State.OnGoing;
        game.blocknumber = block.number;

        emit RespondGame(_gameID, msg.sender);
    }


    function deleteGame(uint _gameID) external {
        _game storage game = Games[_gameID];

        require(game.creator == msg.sender, '04');
        require(game.state == State.New, '05');

        game.state = State.Deleted;

        game.creator.transfer(game.bet);

        emit DeleteGame(_gameID);
    }


    function getWin(uint _gameID) external {
        _game storage game = Games[_gameID];

        require(game.state == State.OnGoing, '06');
        require(game.creator == msg.sender || game.responder == msg.sender, '07');
        require(block.number > game.blocknumber + 1, '08');

        game.state = State.Closed;

        if (blockhash(game.blocknumber) == 0 || (block.number - game.blocknumber) > 256) {
            game.creator.transfer(game.bet);
            game.responder.transfer(game.bet);

            emit RefundGame(_gameID);
            gameWinner[_gameID] = address(0);
        } else {
            uint hash = uint(keccak256(abi.encodePacked(blockhash(game.blocknumber + 1), game.creator, game.responder, game.bet)));

            uint game_bet_common = game.bet.mul(2);
            uint owner_fee = game_bet_common.mul(fee).div(100);
            owner.transfer(owner_fee);
            uint winAmount = game_bet_common.sub(owner_fee);

            address winner;

            if (hash % 2 == 0) {
                game.creator.transfer(winAmount);
                winner = game.creator;
                emit ResultGame(_gameID, game.creator, winAmount);
            } else {
                game.responder.transfer(winAmount);
                winner = game.responder;
                emit ResultGame(_gameID, game.responder, winAmount);
            }

            gameWinner[_gameID] = winner;

        }
    }


}