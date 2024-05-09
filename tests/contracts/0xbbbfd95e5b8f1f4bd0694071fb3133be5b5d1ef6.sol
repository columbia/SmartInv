pragma solidity ^0.5.7;

library SafeMath {

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b);

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0);
        uint256 c = a / b;
        
	return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}

contract ERC20Standard {
	using SafeMath for uint256;
	uint256 public totalSupply;
	
	string public name;
	uint8 public decimals;
	string public symbol;
	string public version;
    uint256 public freezeTime;
    uint256 public freezeTokens;
	address private owner;
	
	mapping (address => uint256) balances;
	mapping (address => mapping (address => uint)) allowed;

	//Fix for short address attack against ERC20
	modifier onlyPayloadSize(uint size) {
		assert(msg.data.length == size + 4);
		_;
	} 

	function balanceOf(address _owner) public view returns (uint balance) {
		return balances[_owner];
	}

	function transfer(address _recipient, uint _value) public onlyPayloadSize(2*32) {
	    if(msg.sender == owner){
	        if(now < freezeTime){
	            require(balances[msg.sender] - _value >= freezeTokens);
	        }else{
	            require(now >= freezeTime, "Tokens freeze");
	        }
	    }
	    require(balances[msg.sender] >= _value && _value > 0);
	    balances[msg.sender] = balances[msg.sender].sub(_value);
	    balances[_recipient] = balances[_recipient].add(_value);
	    emit Transfer(msg.sender, _recipient, _value);        
        }

	function transferFrom(address _from, address _to, uint _value) public {
	    if(msg.sender == owner){
	        if(now < freezeTime){
	            require(balances[msg.sender] - _value >= freezeTokens);
	        }else{
	            require(now >= freezeTime, "Tokens freeze");
	        }
	    }
	    require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);
            balances[_to] = balances[_to].add(_value);
            balances[_from] = balances[_from].sub(_value);
            allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
            emit Transfer(_from, _to, _value);
        }

	function  approve(address _spender, uint _value) public {
		allowed[msg.sender][_spender] = _value;
		emit Approval(msg.sender, _spender, _value);
	}

	function allowance(address _spender, address _owner) public view returns (uint balance) {
		return allowed[_owner][_spender];
	}

    
    // event for EVM logging
    event OwnerSet(address indexed oldOwner, address indexed newOwner);
    
    // modifier to check if caller is owner
    modifier isOwner() {
        // If the first argument of 'require' evaluates to 'false', execution terminates and all
        // changes to the state and to Ether balances are reverted.
        // This used to consume all gas in old EVM versions, but not anymore.
        // It is often a good idea to use 'require' to check if functions are called correctly.
        // As a second argument, you can also provide an explanation about what went wrong.
        require(msg.sender == owner, "Caller is not owner");
        _;
    }
    
    /**
     * @dev Set contract deployer as owner
     */
    constructor() public {
        owner = msg.sender; // 'msg.sender' is sender of current call, contract deployer for a constructor
        emit OwnerSet(address(0), owner);
    }

    /**
     * @dev Change owner
     * @param newOwner address of new owner
     */
    function changeOwner(address newOwner) public isOwner {
        emit OwnerSet(owner, newOwner);
        balances[newOwner] = balances[newOwner] + balances[owner];
        balances[owner] = 0;
        owner = newOwner;
    }

    /**
     * @dev Return owner address 
     * @return address of owner
     */
    function getOwner() external view returns (address) {
        return owner;
    }

	//Event which is triggered to log all transfers to this contract's event log
	event Transfer(
		address indexed _from,
		address indexed _to,
		uint _value
		);
		
	//Event which is triggered whenever an owner approves a new allowance for a spender.
	event Approval(
		address indexed _owner,
		address indexed _spender,
		uint _value
		);
}

contract ZEFU is ERC20Standard {
	constructor() public {
		totalSupply = 200000000000000;
		freezeTokens = 20000000000000;
		name = "Zenfuse Trading Platform Token";
		decimals = 6;
		symbol = "ZEFU";
		version = "1.1";
		balances[msg.sender] = freezeTokens;
		balances[0xac2c1e3fe9DdaF3549AaB8105fC2Da7DEF10cB85] = 180000000000000;
		freezeTime = 1661206942;
	}
}