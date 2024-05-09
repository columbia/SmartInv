pragma solidity ^0.5.10;


/**
 * @title SafeMath
 * @dev Removed mul, div, mod
 */
library SafeMath {
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
}


contract ERC20 {
      function totalSupply() public view returns (uint256);
      function balanceOf(address _who) public view returns (uint256);
      function transfer(address _to, uint256 _value) public returns (bool);
      function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
      function allowance(address _owner, address _spender) public view returns (uint256);
      function approve(address _spender, uint256 _value) public returns (bool);

      event Transfer(address indexed from, address indexed to, uint256 value);
      event Approval(address indexed owner, address indexed spender, uint256 value);
}


contract StandardToken is ERC20 {
        using SafeMath for uint256;

        uint256 internal _totalSupply;
        mapping(address => uint256) internal _balances;
        mapping(address => mapping (address => uint256)) internal _allowed;

        modifier validDestination( address _to )
        {
                require(_to != address(0x0), "Invalid address.");
                require(_to != address(this), "Invalid address.");
                _;
        }

        function totalSupply() public view returns (uint256) {
                return _totalSupply;
        }

        function balanceOf(address _who) public view returns (uint256) {
                return _balances[_who];
        }

        function transfer(address _to, uint256 _value)
                public
                validDestination(_to)
                returns (bool)
        {
                _balances[msg.sender] = _balances[msg.sender].sub(_value);
                _balances[_to] = _balances[_to].add(_value);
                emit Transfer(msg.sender, _to, _value);
                return true;
        }

        function transferFrom(address _from, address _to, uint256 _value)
                public
                validDestination(_to)
                returns (bool)
        {
                require(_value <= _allowed[_from][msg.sender],"Insufficient allowance.");

                _balances[_from] = _balances[_from].sub(_value);
                _balances[_to] = _balances[_to].add(_value);

                _allowed[_from][msg.sender] = _allowed[_from][msg.sender].sub(_value);

                emit Transfer(_from, _to, _value);
                return true;
        }

        function burn(uint _value) public returns (bool)
        {
                _balances[msg.sender] = _balances[msg.sender].sub(_value);
                _totalSupply = _totalSupply.sub(_value);
                emit Transfer(msg.sender, address(0x0), _value);
                return true;
        }

        function burnFrom(address _from, uint256 _value) public validDestination(_from) returns (bool)
        {
                _balances[_from] = _balances[_from].sub(_value);
                _totalSupply = _totalSupply.sub(_value);
                emit Transfer(_from, address(0x0), _value);

                approve(msg.sender, _allowed[_from][msg.sender].sub(_value));

                return true;
        }

        function approve(address _spender, uint256 _value) public validDestination(_spender) returns (bool) {

                _allowed[msg.sender][_spender] = _value;
                emit Approval(msg.sender, _spender, _value);
                return true;
        }

        function allowance(address _owner, address _spender) public view returns (uint256)
        {
                return _allowed[_owner][_spender];
        }
}


contract Ownable {
        address public owner;
        mapping (address => bool) public delegatee;

        event OwnershipTransferred(
                address indexed previousOwner,
                address indexed newOwner
        );

        event LockableDelegated(address indexed delegatee);
        event LockableUndelegated(address indexed delegatee);

        constructor() public {
                owner = msg.sender;
        }

        modifier validateAddress(address _to) {
                require(_to != address(0x0));
				require(_to != address(this));
                _;
        }

        modifier onlyOwner() {
                require(msg.sender == owner, 'Permission denied.');
                _;
        }
		
		modifier onlyLocker() {
                require(msg.sender == owner || delegatee[msg.sender], 'Permission denied');
                _;
        }

        function transferOwnership(address _newOwner) public onlyOwner validateAddress(_newOwner) {
                owner = _newOwner;
                emit OwnershipTransferred(owner, _newOwner);
        }

	function delegateLockable(address _delegatee) public onlyOwner validateAddress(_delegatee) {
		require(!delegatee[_delegatee], 'Delegatee already.');
		delegatee[_delegatee] = true;
		emit LockableDelegated(_delegatee);
	}
	
	function undelegateLockable(address _delegatee) public onlyOwner validateAddress(_delegatee) {
		require(delegatee[_delegatee], 'Not a delegatee.');
		delegatee[_delegatee] = false;
		emit LockableUndelegated(_delegatee);
	}
}


contract Pausable is Ownable {
        event Pause();
        event Unpause();

        bool public paused = false;

        modifier whenNotPaused() {
                require(!paused, 'Paused by owner.');
                _;
        }

        modifier whenPaused() {
                require(paused, 'Paused requied.');
                _;
        }

        function pause() public onlyOwner whenNotPaused {
                paused = true;
                emit Pause();
        }

        function unpause() public onlyOwner whenPaused {
                paused = false;
                emit Unpause();
        }
}


contract Freezable is Ownable {
        mapping (address => bool) public frozenAccount;

        event Freezed(address indexed target, bool frozen);
        event Unfreezed(address indexed target, bool frozen);

        modifier isNotFrozen(address _target) {
                require(!frozenAccount[_target], 'Frozen account.');
                _;
        }

        modifier isFrozen(address _target) {
                require(frozenAccount[_target], 'Not a frozen account.');
                _;
        }

        function freeze(address _target) public onlyOwner isNotFrozen(_target) validateAddress(_target) {
                frozenAccount[_target] = true;
                emit Freezed(_target, true);
        }

        function unfreeze(address _target) public onlyOwner isFrozen(_target) validateAddress(_target) {
                frozenAccount[_target] = false;
                emit Unfreezed(_target, false);
        }

}

contract TimeLockable is Ownable {
        using SafeMath for uint256;

        mapping (address => uint256) internal _lockType1;
	mapping (address => uint256) internal _lockType2;
	mapping (address => uint256) internal _lockType3;

        event LockAccount(address indexed target, uint256 value, uint256 lockedType);

        function _setTimeLockAccount(address _target, uint256 _value, uint256 _newLockType)
                internal
                onlyLocker
                returns (bool)
        {
		if (_newLockType == 1) {
			_lockType1[_target] = _lockType1[_target].add(_value);
			return true;
		} else if (_newLockType == 2) {
			_lockType2[_target] = _lockType2[_target].add(_value);
			return true;
		} else if (_newLockType == 3) {
			_lockType3[_target] = _lockType3[_target].add(_value);
			return true;
		} else {
			return false;
		}
        }

	function balanceLocked(address _target) public view returns ( uint256 lockType1, uint256 lockType2, uint256 lockType3 ) {
		if (now > 1614556800) {				// Mar 1, 2021
			return (0, 0, 0);
		} else if (now > 1598918400) {			// Sep 1, 2020
			return (0, 0, _lockType3[_target]);
		} else if (now > 1593561600) {			// Jul 1, 2020
			return (0, _lockType2[_target], _lockType3[_target]);
		} else {
			return (_lockType1[_target], _lockType2[_target], _lockType3[_target]);
		}
	}
}


contract VKNF is StandardToken, Pausable, Freezable, TimeLockable {
        using SafeMath for uint256;

        string  public  name = "VKenaf";
        string  public  symbol = 'VKNF';
        uint256 public  constant decimals = 12;

        constructor(
                uint256 _initialSupply
        )
                public
        {
                _totalSupply = _initialSupply * 10 ** uint256(decimals);
                _balances[msg.sender] = _totalSupply;                  
        }
		
        modifier balanceValidate(address _from, uint256 _value) {
                require(balanceAvailable(_from) >= _value, 'Insufficient available balance.');
                _;
        }

        function balanceAvailable(address _target) public view returns ( uint256 ) {
		uint256 _locked1;
		uint256 _locked2;
		uint256 _locked3;
		
		(_locked1, _locked2, _locked3) = balanceLocked(_target);
		return _balances[_target].sub(_locked1).sub(_locked2).sub(_locked3);
        }


	function lockAndTransfer(address _to, uint256 _value, uint256 _newLockType) 
		public
		onlyLocker 
	{
		require(_setTimeLockAccount(_to, _value, _newLockType));
		transfer(_to, _value);
	}

        function transfer(address _to, uint256 _value)
                public
                whenNotPaused
                isNotFrozen(msg.sender)
                isNotFrozen(_to)
		balanceValidate(msg.sender, _value)
                returns (bool)
        {
                return super.transfer(_to, _value);
        }

        function transferFrom(address _from, address _to, uint256 _value)
                public
                whenNotPaused
                isNotFrozen(_from)
                isNotFrozen(_to)
				balanceValidate(_from, _value)
                returns (bool)
        {
                return super.transferFrom(_from, _to, _value);
        }

        function burn(uint256 _value)
                public
                whenNotPaused
                isNotFrozen(msg.sender)
				balanceValidate(msg.sender, _value)
                returns (bool)
        {
                return super.burn(_value);
        }

        function burnFrom(address _from, uint256 _value)
                public
                whenNotPaused
                isNotFrozen(_from)
		balanceValidate(_from, _value)
                returns (bool)
        {
                return super.burnFrom(_from, _value);
        }

        function approve(address _spender, uint256 _value)
                public
                whenNotPaused
                isNotFrozen(msg.sender)
                isNotFrozen(_spender)
		balanceValidate(msg.sender, _value)
                returns (bool)
        {
                return super.approve(_spender, _value);
        }

}