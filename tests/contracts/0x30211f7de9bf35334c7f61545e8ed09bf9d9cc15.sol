pragma solidity ^0.4.24;

// ----------------------------------------------------------------------------
// Ownership functionality for authorization controls and user permissions
// ----------------------------------------------------------------------------
contract Owned {
    address public owner;
    address public newOwner;

    event OwnershipTransferred(address indexed _from, address indexed _to);

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }
    function acceptOwnership() public {
        require(msg.sender == newOwner);
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
        newOwner = address(0);
    }
}

// ----------------------------------------------------------------------------
// Pause functionality
// ----------------------------------------------------------------------------
contract Pausable is Owned {
  event Pause();
  event Unpause();

  bool public paused = false;


  // Modifier to make a function callable only when the contract is not paused.
  modifier whenNotPaused() {
    require(!paused);
    _;
  }

  // Modifier to make a function callable only when the contract is paused.
  modifier whenPaused() {
    require(paused);
    _;
  }

  // Called by the owner to pause, triggers stopped state
  function pause() onlyOwner whenNotPaused public {
    paused = true;
    emit Pause();
  }

  // Called by the owner to unpause, returns to normal state
  function unpause() onlyOwner whenPaused public {
    paused = false;
    emit Unpause();
  }
}

/**
 * @title SafeMath
 * @dev Math operations with safety checks that revert on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, reverts on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
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


// ----------------------------------------------------------------------------
// ERC20 Standard Interface
// ----------------------------------------------------------------------------
contract ERC20 {
    function totalSupply() public constant returns (uint);
    function balanceOf(address tokenOwner) public constant returns (uint balance);
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

// ----------------------------------------------------------------------------
// 'AVEX' 'Aevolve' token contract
// Symbol      : AVEX
// Name        : Aevolve
// Total supply: 1,210,000,000
// Decimals    : 18
// ----------------------------------------------------------------------------

// ----------------------------------------------------------------------------
// ERC20 Token. Specifies symbol, name, decimals, and total supply
// ----------------------------------------------------------------------------
contract Aevolve is Owned, Pausable, ERC20 {
    using SafeMath for uint256;

    string public symbol;
    string public  name;
    uint8 public decimals;
    uint public _totalSupply;


    mapping(address => uint) public balances;
    mapping(address => mapping(address => uint)) internal allowed;

    event Burned(address indexed burner, uint256 value);
    event Mint(address indexed to, uint256 amount);


    // ------------------------------------------------------------------------
    // Constructor
    // ------------------------------------------------------------------------
    constructor() public {
        symbol = "AVEX";
        name = "Aevolve";
        decimals = 18;
        _totalSupply = 1210000000 * 10**uint(decimals);
        balances[owner] = _totalSupply;
        emit Transfer(address(0), owner, _totalSupply);
    }

    // ------------------------------------------------------------------------
    // Total supply
    // ------------------------------------------------------------------------
    function totalSupply() public constant returns (uint) {
        return _totalSupply;
    }

    // ------------------------------------------------------------------------
    // Get the token balance for account `tokenOwner`
    // ------------------------------------------------------------------------
    function balanceOf(address tokenOwner) public constant returns (uint balance) {
        return balances[tokenOwner];
    }

    // ------------------------------------------------------------------------
    // Transfer the balance from token owner's account to `_to` account
    // - Owner's account must have sufficient balance to transfer
    // - 0 value transfers are allowed
    // ------------------------------------------------------------------------
    function transfer(address _to, uint256 _value) public returns (bool) {
      require(_value <= balances[msg.sender]);
      require(_to != address(0));

      balances[msg.sender] = balances[msg.sender].sub(_value);
      balances[_to] = balances[_to].add(_value);
      emit Transfer(msg.sender, _to, _value);
      return true;
 }

    // ------------------------------------------------------------------------
    // Token owner can approve for `spender` to transferFrom(...) `tokens`
    // from the token owner's account
    // ------------------------------------------------------------------------
    function approve(address spender, uint tokens) public whenNotPaused returns (bool success) {
        require(spender != address(0));

        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    // ------------------------------------------------------------------------
    // Transfer `tokens` from the `from` account to the `to` account
    //
    // The calling account must already have sufficient tokens approve(...)-d
    // for spending from the `from` account and
    // - From account must have sufficient balance to transfer
    // - Spender must have sufficient allowance to transfer
    // ------------------------------------------------------------------------
    function transferFrom(address from, address to, uint tokens) public whenNotPaused returns (bool success) {
        require(to != address(0));

        //check edge cases
        if (allowed[from][msg.sender] >= tokens
            && balances[from] >= tokens
            && tokens > 0) {

            //update balances and allowances
            balances[from] = balances[from].sub(tokens);
            allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
            balances[to] = balances[to].add(tokens);

            //log event
            emit Transfer(from, to, tokens);
            return true;
        }
        else {
            return false;
        }
    }

    // ------------------------------------------------------------------------
    // Returns the amount of tokens approved by the owner that can be
    // transferred to the spender's account
    // ------------------------------------------------------------------------
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }


    // ------------------------------------------------------------------------
    // Burns a specific number of tokens
    // ------------------------------------------------------------------------
    function burn(uint256 _value) public onlyOwner {
        require(_value > 0);

        address burner = msg.sender;
        balances[burner] = balances[burner].sub(_value);
        _totalSupply = _totalSupply.sub(_value);
        emit Burned(burner, _value);
    }


    // ------------------------------------------------------------------------
    // Doesn't Accept Eth
    // ------------------------------------------------------------------------
    function () public payable {
        revert();
    }
}


/**
 * @title TokenVesting
 * @dev A token holder contract that can release its token balance gradually like a
 * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
 * owner.
 */
contract TokenVesting is Owned, Pausable, ERC20, Aevolve {
  using SafeMath for uint256;


  event Released(uint256 amount);
  event Revoked();

  // beneficiary of tokens after they are released
  address public beneficiary;

  uint256 public cliff;
  uint256 public start;
  uint256 public duration;

  bool public revocable;

  mapping (address => uint256) public released;
  mapping (address => bool) public revoked;

  /**
   * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
   * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
   * of the balance will have vested.
   * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
   * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
   * @param _start the time (as Unix time) at which point vesting starts
   * @param _duration duration in seconds of the period in which the tokens will vest
   * @param _revocable whether the vesting is revocable or not
   */
  constructor(
    address _beneficiary,
    uint256 _start,
    uint256 _cliff,
    uint256 _duration,
    bool _revocable
  )
    public
  {
    require(_beneficiary != address(0));
    require(_cliff <= _duration);

    beneficiary = _beneficiary;
    revocable = _revocable;
    duration = _duration;
    cliff = _start.add(_cliff);
    start = _start;
  }

  /**
   * @notice Transfers vested tokens to beneficiary.
   * @param _token ERC20 token which is being vested
   */
  function release(ERC20 _token) public {
    uint256 unreleased = releasableAmount(_token);

    require(unreleased > 0);

    released[_token] = released[_token].add(unreleased);

    _token.transfer(beneficiary, unreleased);

    emit Released(unreleased);
  }

  /**
   * @notice Allows the owner to revoke the vesting. Tokens already vested
   * remain in the contract, the rest are returned to the owner.
   * @param _token ERC20 token which is being vested
   */
  function revoke(ERC20 _token) public onlyOwner {
    require(revocable);
    require(!revoked[_token]);

    uint256 balance = _token.balanceOf(address(this));

    uint256 unreleased = releasableAmount(_token);
    uint256 refund = balance.sub(unreleased);

    revoked[_token] = true;

    _token.transfer(owner, refund);

    emit Revoked();
  }

  /**
   * @dev Calculates the amount that has already vested but hasn't been released yet.
   * @param _token ERC20 token which is being vested
   */
  function releasableAmount(ERC20 _token) public view returns (uint256) {
    // returns vested amount minus amount that has been released
    return vestedAmount(_token).sub(released[_token]);
  }

  /**
   * @dev Calculates the amount that has already vested.
   * @param _token ERC20 token which is being vested
   */
  function vestedAmount(ERC20 _token) public view returns (uint256) {
    uint256 currentBalance = _token.balanceOf(address(this)); // balance of this contract
    uint256 totalBalance = currentBalance.add(released[_token]); // initial balance of this contract

    if (block.timestamp < cliff) { // can't withdraw if we haven't hit cliff
      return 0;

      // if past end of vesting period or it has been revoked, return balance of contract
    } else if (block.timestamp >= start.add(duration) || revoked[_token]) {
      return totalBalance;

    } else {
      return totalBalance.mul(block.timestamp.sub(start)).div(duration);
    }
  }
}

/**
*@dev Following the contract factory design, this contract allows owner to mass
* create vesting contracts and distribute tokens to them
*/
contract VestingFactory is Owned, Pausable  {
	using SafeMath for uint256;

	// Array of all vesting contracts
	TokenVesting[] public vestingContracts;

	// Mapping individual wallet address to vesting contract
	mapping(address => address) public beneficiaryContracts;

	// initialize token
	Aevolve public token;

	/*Events*/
	event contractCreation(address _creator, address _contract, address _beneficiary);

	// construct the VestingFactory with Aevolve token
	constructor (
		Aevolve _token
	) public {
		token = _token;
	}

	/* @dev Mass deploy vesting contracts
	* @param beneficiaries is an array of wallet addresses that receive tokens
	* @param numTokens is an array of the number of tokens that beneficiaries receive
	* @param start is the date and time that tokens begin to vest
	* @param duration in seconds of the cliff in which tokens will begin to vest
	*/
	function deployVesting(address[] beneficiaries, uint256[] numTokens, uint256 start, uint256 cliff, uint256 duration) public onlyOwner {
		// Check that array lengths match
		require(beneficiaries.length == numTokens.length);

		// temp variable to store vesting contract
		TokenVesting vestingContract;

		// temp variable to store address of beneficiary through the loop, used for efficiency
		address benAddress;

		// Loop through investors and create their vesting vestingContracts
		for(uint256 i = 0; i < beneficiaries.length; i++) {

			// Checks that they do not already have a vesting contract
			if (beneficiaryContracts[beneficiaries[i]] == 0x0) {
				benAddress = beneficiaries[i];
				vestingContract = new TokenVesting(benAddress, start, cliff, duration, false);

				// Update data structures used to track vesting contracts
				vestingContracts.push(vestingContract);
				beneficiaryContracts[benAddress] = vestingContract;

				emit contractCreation(address(this), address(vestingContract), benAddress);

				// Send their tokens to their vesting contract
				token.transfer(vestingContract, numTokens[i]);
			}
		}
	}

	// @dev mass release vested tokens
	function massRelease() public onlyOwner {
		require(vestingContracts.length > 0);
		for(uint256 i = 0; i < vestingContracts.length; i++) {
      // Check that there are tokens to release
      if(vestingContracts[i].releasableAmount(token) != 0) {
        vestingContracts[i].release(token);
      }
		}
	}

	// @dev transfer tokens out of contract
	function tokenTransfer(address recipient, uint256 amount) public onlyOwner {
		token.transfer(recipient, amount);
	}

	// @dev Return the vesting contract for an individual
	function getVestingContracts(address beneficiary) public returns (address){
		return beneficiaryContracts[beneficiary];
	}

}