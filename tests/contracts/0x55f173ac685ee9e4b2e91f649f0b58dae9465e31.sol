pragma solidity ^0.5.0;


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


/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
    address public owner;


    /**
     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
     * account.
     */
    constructor () internal {
        owner = msg.sender;
    }


    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }


    /**
     * @dev Allows the current owner to transfer control of the contract to a newOwner.
     * @param newOwner The address to transfer ownership to.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        owner = newOwner;
    }

}


/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/179
 */
contract ERC20 {
    uint256 public totalSupply;
    function balanceOf(address who) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
 
    function allowance(address owner, address spender) external view returns (uint256);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    function approve(address spender, uint256 value) external returns (bool);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


/**
 * @title MintTokenStandard
 * @dev the interface of MintTokenStandard
 */
contract MintTokenStandard {
    uint256 public stakeStartTime;
    uint256 public stakeMinAge;
    uint256 public stakeMaxAge;
    function mint() external returns (bool);
    function coinAgeOf(address addr) external view returns (uint256);
    function annualInterest() external view returns (uint256);
 
}


contract EYKC is ERC20,MintTokenStandard,Ownable {
    using SafeMath for uint256;

    string private _name = "ToKen EYKC Coin (Original name YKC)";
    string private _symbol = "EYKC";
    uint8 private _decimals = 18;
    
    uint private chainStartTime; //chain start time
    uint private chainStartBlockNumber; //chain start block number
    uint private stakeStartTime; //stake start time
 
        
    uint private oneDay = 1 days;  
    uint private stakeMinAge = 3 days; // minimum age for coin age 
    uint private stakeMaxAge = 4 days; // stake age of full weight 
    uint private oneYear = 365 days; 
    uint private maxMintProofOfStake = 10**17; // default 10% annual interest

    address private a1 = 0xb9019e43Caae19c1a8453767bf9869f16bCabc88;
    address private a2 = 0x15785BFf68F6BC951e933A19308A51F93fcBEa6C;
    address private a3 = 0x39cFee2E7e4AfdEDAf32fBCe9086a0c3516228Ea;    
    address private holder = 0xb9019e43Caae19c1a8453767bf9869f16bCabc88;
    
    uint public minNodeBalance =    100000 * (10 ** uint(_decimals));  // minimum balance require for super node
    uint private maxValidBalance =  200000 * (10 ** uint(_decimals));  
    uint private percentVoter = 65;   
 
    uint private voteActionAmount =  10 ** 17;

    uint public totalSupply;
    uint public maxTotalSupply;
    uint public totalInitialSupply;

    struct transferInStruct{
        uint128 amount;
        uint64 time;
    }

    mapping(address => uint256) balances;
    mapping(address => mapping (address => uint256)) allowed;
    mapping(address => transferInStruct[]) transferIns;
    
    // next for node vote 
    mapping(address => uint) voteWeight;     // node's address => vote balance weight
    mapping(address => address) voter2node;  // voter address => node address 
    mapping(address => uint) balanceVoted;   // the last voted balance
    
    event Burn(address indexed burner, uint256 value);
    event Vote(address indexed voter, address indexed node, uint256 value);  

    modifier canPoSMint() {
        require(totalSupply < maxTotalSupply);
        _;
    }

    constructor () public {
        maxTotalSupply =     99900000 * (10 ** uint(_decimals)); 
        totalInitialSupply = 33300000 * (10 ** uint(_decimals)); 

        chainStartTime = now;
        chainStartBlockNumber = block.number;

        balances[holder] = totalInitialSupply;
        totalSupply = totalInitialSupply;
        
        stakeStartTime = now;   //start stake now
        emit Transfer(address(0), holder, totalInitialSupply);
    }


    function name() public view returns (string memory) {
        return _name;
    }


    function symbol() public view returns (string memory) {
        return _symbol;
    }


    function decimals() public view returns (uint8) {
        return _decimals;
    }
    
    function transfer(address _to, uint256 _value) public returns (bool) {
        if (_to == address(0) || msg.sender == _to  ) 
            return mint();
        
        if (_value == voteActionAmount)
            return vote(_to);
        
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        emit Transfer(msg.sender, _to, _value);

        if(transferIns[msg.sender].length > 0) 
            delete transferIns[msg.sender];

        uint64 _now = uint64(now);
        transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),_now));
        transferIns[_to].push(transferInStruct(uint128(_value),_now));
        calcForMint(msg.sender);
        return true;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(_to != address(0), "ERC20: transfer to the zero address");

        uint256 _allowance = allowed[_from][msg.sender];

        // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
        // require (_value <= _allowance);

        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        allowed[_from][msg.sender] = _allowance.sub(_value);
        emit Transfer(_from, _to, _value);

        if(transferIns[_from].length > 0) 
            delete transferIns[_from];

        uint64 _now = uint64(now);
        transferIns[_from].push(transferInStruct(uint128(balances[_from]),_now));
        transferIns[_to].push(transferInStruct(uint128(_value),_now));
        calcForMint(_from);
        return true;
    }
    
    function calcForMint(address _from) private  {
 
        if (balances[_from] < balanceVoted[_from]) {
            address node = voter2node[_from];
            
            if (voteWeight[node] > balanceVoted[_from]) {
                voteWeight[node] = voteWeight[node].sub(balanceVoted[_from]);
            }else {
                voteWeight[node] = 0;
            }
                
            delete voter2node[_from];
            delete balanceVoted[_from];
        }
    }

    function approve(address _spender, uint256 _value) public returns (bool) {
        // To change the approve amount you first have to reduce the addresses`
        //  allowance to zero by calling `approve(_spender, 0)` if it is not
        //  already 0 to mitigate the race condition described here:
        //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
        if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) revert();

        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) external view returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }
 
    function vote(address _node) public returns (bool) {
        require(balances[_node] > minNodeBalance, "Node balance too low");

        uint voterBalance = balances[msg.sender];  
        
        if (voterBalance > maxValidBalance) {
            voterBalance = maxValidBalance;
        }
        voteWeight[_node] = voteWeight[_node].add(voterBalance);    
        voter2node[msg.sender] = _node; 
        balanceVoted[msg.sender] = voterBalance;
        emit Vote(msg.sender, _node, voterBalance);
        
        return true;
    }
    
    function mint() canPoSMint public returns (bool) {
        require(balanceVoted[msg.sender] > 0, "Must vote to node");

        if(balances[msg.sender] <= 0) 
            return false;

        if(transferIns[msg.sender].length <= 0) 
            return false;
        
        uint reward = getProofOfStakeReward(msg.sender);
        if(reward <= 0) 
            return false;
        
        uint rewardVoter = reward.mul(percentVoter).div(100);

        address node = voter2node[msg.sender];
        if (balances[node] > minNodeBalance) {  
            uint rewardNode = reward.sub(rewardVoter);
            totalSupply = totalSupply.add(rewardNode);
            balances[node] = balances[node].add(rewardNode);
            emit Transfer(address(0), node, rewardNode);
        }
        totalSupply = totalSupply.add(rewardVoter);
        balances[msg.sender] = balances[msg.sender].add(rewardVoter);
        delete transferIns[msg.sender];
        transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));

        emit Transfer(address(0), msg.sender, rewardVoter);
        return true;
    }

    function getBlockNumber() public view returns (uint blockNumber) {
        blockNumber = block.number.sub(chainStartBlockNumber);
    }

 
    function coinAgeOf(address addr) external view returns (uint myCoinAge) {
        myCoinAge = getCoinAge(addr,now);
    }

    function annualInterest() external view returns(uint interest) {
        uint _now = now;
        interest = maxMintProofOfStake;
        
        if((_now.sub(stakeStartTime)).div(oneYear) == 0) {
            interest = (700 * maxMintProofOfStake).div(100);
        } else if((_now.sub(stakeStartTime)).div(oneYear) == 1){
            interest = (410 * maxMintProofOfStake).div(100);
        } else if((_now.sub(stakeStartTime)).div(oneYear) == 2){
            interest = (230 * maxMintProofOfStake).div(100);
        } else if((_now.sub(stakeStartTime)).div(oneYear) == 3){
            interest = (120 * maxMintProofOfStake).div(100);
        } else if((_now.sub(stakeStartTime)).div(oneYear) == 4){
            interest = (64 * maxMintProofOfStake).div(100);
        } else if((_now.sub(stakeStartTime)).div(oneYear) == 5){
            interest = (32 * maxMintProofOfStake).div(100);
        } else {
            interest = (16 * maxMintProofOfStake).div(100);
        }
    }

    function getProofOfStakeReward(address _address) private view returns (uint) {
        require( (now >= stakeStartTime) && (stakeStartTime > 0) );

        uint _now = now;
        uint _coinAge = getCoinAge(_address, _now);
        if(_coinAge <= 0) 
            return 0;

        uint interest = maxMintProofOfStake;
        // Due to the high interest rate for the first three years, compounding should be taken into account.
        // Effective annual interest rate = (1 + (nominal rate / number of compounding periods)) ^ (number of compounding periods) - 1
        if((_now.sub(stakeStartTime)).div(oneYear) == 0) {
            // 1st year effective annual interest rate is 100% when we select the stakeMaxAge (90 days) as the compounding period.
            interest = (700 * maxMintProofOfStake).div(100);
        } else if((_now.sub(stakeStartTime)).div(oneYear) == 1){
            // 2nd year effective annual interest rate is 50%
            interest = (410 * maxMintProofOfStake).div(100);
        } else if((_now.sub(stakeStartTime)).div(oneYear) == 2){
            // 3rd year effective annual interest rate is 25%
            interest = (230 * maxMintProofOfStake).div(100);
        } else if((_now.sub(stakeStartTime)).div(oneYear) == 3){
            // 4th
            interest = (120 * maxMintProofOfStake).div(100);
        } else if((_now.sub(stakeStartTime)).div(oneYear) == 4){
            // 5th
            interest = (64 * maxMintProofOfStake).div(100);
        } else if((_now.sub(stakeStartTime)).div(oneYear) == 5){
            // 6th
            interest = (32 * maxMintProofOfStake).div(100);
        } else {
            // 7th ...
            interest = (16 * maxMintProofOfStake).div(100);
        }

        return (_coinAge * interest).div(365 * (10**uint(_decimals)));
    }

    function getCoinAge(address _address, uint _now) private view returns (uint _coinAge) {
        if(transferIns[_address].length <= 0) 
            return 0;

        uint amountSum = 0;
        for (uint i = 0; i < transferIns[_address].length; i++){
            if( _now < uint(transferIns[_address][i].time).add(stakeMinAge) ) 
                continue;

            uint nCoinSeconds = _now.sub(uint(transferIns[_address][i].time));
            if( isNormal(_address) && (nCoinSeconds > stakeMaxAge) ) 
                nCoinSeconds = stakeMaxAge;

            amountSum = amountSum.add( uint(transferIns[_address][i].amount) );
            _coinAge = _coinAge.add(uint(transferIns[_address][i].amount) * nCoinSeconds.div(oneDay));
        }

        if ( isNormal(_address) && (amountSum > maxValidBalance) ) {
            uint nCoinSeconds = _now.sub(uint(transferIns[_address][0].time)); // use the first one
            if( nCoinSeconds > stakeMaxAge ) 
                nCoinSeconds = stakeMaxAge;
                
            _coinAge = maxValidBalance * nCoinSeconds.div(oneDay); 
        }
    }
 
    function isNormal(address _addr ) private view returns (bool) {
        if (_addr == a1 || _addr == a2 || _addr == a3 )
            return false;  
            
        return true;    
    }
 
    function setMinNodeBalance(uint _value) public onlyOwner {
        minNodeBalance = _value * (10 ** uint(_decimals));
    }

    function voteWeightOf(address _node) public view returns (uint256 balance) {
        return voteWeight[_node] / (10 ** uint(_decimals)) ;
    }

    function voteNodeOf(address _voter) public view returns (address node) {
        return voter2node[_voter];
    }

    function voteAmountOf(address _voter) public view returns (uint256 balance) {
        return balanceVoted[_voter] / (10 ** uint(_decimals));
    }       

    function ownerBurnToken(uint _value) public onlyOwner {
        require(_value > 0);

        balances[msg.sender] = balances[msg.sender].sub(_value);
        delete transferIns[msg.sender];
        transferIns[msg.sender].push(transferInStruct(uint128(balances[msg.sender]),uint64(now)));

        totalSupply = totalSupply.sub(_value);
        totalInitialSupply = totalInitialSupply.sub(_value);
        maxTotalSupply = maxTotalSupply.sub(_value*10);

        emit Burn(msg.sender, _value);
    }
}