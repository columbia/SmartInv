pragma solidity ^0.5.12;
 
/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */ 
library SafeMath{
    function mul(uint a, uint b) internal pure returns (uint){
        uint c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }
 
    function div(uint a, uint b) internal pure returns (uint){
        uint c = a / b;
        return c;
    }
 
    function sub(uint a, uint b) internal pure returns (uint){
        assert(b <= a); 
        return a - b; 
    } 
  
    function add(uint a, uint b) internal pure returns (uint){ 
        uint c = a + b; assert(c >= a);
        return c;
    }
}

/**
 * @title ITCM Token token
 * @dev ERC20 Token implementation, with its own specific
 */
contract ITCMToken{
    using SafeMath for uint;
    
    string public constant name = "ITC Money";
    string public constant symbol = "ITCM";
    uint32 public constant decimals = 18;

    address public contractCreator = address(0);
    address public mintingAllowedForAddr = address(0);
    address public constant managementProfitAddr = 0xe0b70c54a1baa2847e210d019Bb8edc291AEA5c7;
    
    uint public totalSupply = 0;
    // 5 billions is for minting with corporate programs and 240 millions will be transferred next.
    uint public leftToMint = (5000000000 + 240000000) * 1 ether;
    
    mapping(address => uint) balances;
    mapping (address => mapping (address => uint)) internal allowed;
    
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);

    /** 
     * @dev Initial token transfers.
     */
    constructor() public{
        contractCreator = msg.sender;
    
        // Initial tokens for company persons and seller address
        _mint(contractCreator, 240000000 * 1 ether);
        // Tokens that was sold till 8 of Nov 2019. On Nov 28 of 2019 another portion will be minted and transfer process will be started.
        _mint(contractCreator, 178184757 * 1 ether);
        // Bonus program tokens that was minted till 8 of Nov 2019. The same process for sold tokens on Nov 28.
        _mint(contractCreator,   6144301 * 1 ether);

        // Transfer initial tokens to its owners. 100 millions ITCM rest is for sell with ITCM coop. program.
        _transfer(0x0306D7da1cAC317755eb943685275F100341C1B6, 70000000 * 1 ether);
        _transfer(0x0306D7da1cAC317755eb943685275F100341C1B6, 50000000 * 1 ether);
        _transfer(0xB5D8849b5b81bB1003AA64eCFdA4938DBDc0C67b,  2000000 * 1 ether);
        _transfer(0x51c082F197449b8dD5587eF85C30d611cf9b1B25,  2500000 * 1 ether);
        _transfer(0x175d3Fe18bFDCdb7c6153e6C46C97Aa9441F02e1,   300000 * 1 ether);
        _transfer(0x1C062078d1A2B9102A9d02e99af2B6973FBd22fe,   500000 * 1 ether);
        _transfer(0xaF578731Ce9EeEf60B67adBE698084345DE9a549,  1000000 * 1 ether);
        _transfer(0xc0fAD716D0E1B2693E1c632dA025FCE72827748f,   500000 * 1 ether);
        _transfer(0x312b2504017216BF76Af55c0A060335D3812D793,   800000 * 1 ether);
        _transfer(0xd3E798A8Fcc53b3e1c781A899A5fA17cD58044f6,   500000 * 1 ether);
        _transfer(0xc161fb641DB022d2Bc88c4a9E9631f7D2a9ce686,   300000 * 1 ether);
        _transfer(0x7276c6e706008ACFe5d6D8B7B5bCe0D577466071,   200000 * 1 ether);
        _transfer(0x714e9c780f92b4460CA12b27c3f3293756245179,   100000 * 1 ether);
        _transfer(0xa194A1e684C0328E1B2411E8B0327d18069B8Fe2,   100000 * 1 ether);
        _transfer(0x596da5961C8940dD207C1C12232d0F06DbfB89b7,  2000000 * 1 ether);
        _transfer(0x2bB71A30206C15F7A84c64C4905a40311cd1C995,  1000000 * 1 ether);
        _transfer(0x32D2A09aD9736195F14eA14dfC243C81D32fE6Cc,  1000000 * 1 ether);
        _transfer(0x176078eb89d501b40502869411667e6C04d6A9d4,  1000000 * 1 ether);
        _transfer(0xc43253800992627c4cB426C2b7c5882962F075b5,  1000000 * 1 ether);
        _transfer(0x2D9Aff7Fc7331225150aff90E4B0f1B90912081B,   500000 * 1 ether);
        _transfer(0xfD568AEA9C86d21a01ea4f7a9bCEDAFddE1bC3F9,   200000 * 1 ether);
        _transfer(0x87AB7A9f019659e6bC5508Cb83C4DBeDf5eeCf48,   200000 * 1 ether);
        _transfer(0xaA23F54D2e1764C18de004085e24e8d05AD3b848,   200000 * 1 ether);
        _transfer(0x0306D7da1cAC317755eb943685275F100341C1B6,  4100000 * 1 ether);
    }
    
    /** 
     * @dev Gets the balance of the specified address.
     * @param _owner The address to query the the balance of.
     * @return An uint256 representing the amount owned by the passed address.
     */
    function balanceOf(address _owner) public view returns (uint){
        return balances[_owner];
    }
 
    /**
     * @dev Transfer token for a specified address
     * @param _to The address to transfer to.
     * @param _value The amount to be transferred.
     */ 
    function _transfer(address _to, uint _value) private returns (bool){
        require(msg.sender != address(0), "Sender address cannon be null");
        require(_to != address(0), "Receiver address cannot be null");
        require(_to != address(this), "Receiver address cannot be ITCM contract address");
        require(_value > 0 && _value <= balances[msg.sender], "Unavailable amount requested");
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        emit Transfer(msg.sender, _to, _value);
        return true; 
    }

    /**
     * @dev Transfer token for a specified address
     * @param _to The address to transfer to.
     * @param _value The amount to be transferred.
     */ 
    function transfer(address _to, uint _value) public returns (bool){
        return _transfer(_to, _value);
    } 
    
    /**
     * @dev Transfer several token for a specified addresses
     * @param _to The array of addresses to transfer to.
     * @param _value The array of amounts to be transferred.
     */ 
    function massTransfer(address[] memory _to, uint[] memory _value) public returns (bool){
        require(_to.length == _value.length, "You have different amount of addresses and amounts");

        uint len = _to.length;
        for(uint i = 0; i < len; i++){
            if(!_transfer(_to[i], _value[i])){
                return false;
            }
        }
        return true;
    } 
    
    /**
     * @dev Transfer tokens from one address to another
     * @param _from address The address which you want to send tokens from
     * @param _to address The address which you want to transfer to
     * @param _value uint256 the amount of tokens to be transferred
     */ 
    function transferFrom(address _from, address _to, uint _value) public returns (bool){
        require(msg.sender != address(0), "Sender address cannon be null");
        require(_to != address(0), "Receiver address cannot be null");
        require(_to != address(this), "Receiver address cannot be ITCM contract address");
        require(_value > 0 && _value <= balances[_from] && _value <= allowed[_from][msg.sender], "Unavailable amount requested");
        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        emit Transfer(_from, _to, _value);
        return true;
    }
 
    /**
     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
     * @param _spender The address which will spend the funds.
     * @param _value The amount of tokens to be spent.
     */
    function approve(address _spender, uint _value) public returns (bool){
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
 
    /** 
     * @dev Function to check the amount of tokens that an owner allowed to a spender.
     * @param _owner address The address which owns the funds.
     * @param _spender address The address which will spend the funds.
     * @return A uint256 specifying the amount of tokens still available for the spender.
     */
    function allowance(address _owner, address _spender) public view returns (uint){
        return allowed[_owner][_spender]; 
    } 
 
    /**
     * @dev Increase approved amount of tokents that could be spent on behalf of msg.sender.
     * @param _spender The address which will spend the funds.
     * @param _addedValue The amount of tokens to be spent.
     */
    function increaseApproval(address _spender, uint _addedValue) public returns (bool){
        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]); 
        return true; 
    }
 
    /**
     * @dev Decrease approved amount of tokents that could be spent on behalf of msg.sender.
     * @param _spender The address which will spend the funds.
     * @param _subtractedValue The amount of tokens to be spent.
     */
    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool){
        uint oldValue = allowed[msg.sender][_spender];
        if(_subtractedValue > oldValue){
            allowed[msg.sender][_spender] = 0;
        }else{
            allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
        }
        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }
    
    /**
     * @dev Emit new tokens and transfer from 0 to client address. This function will generate 21.5% of tokens for management address as well.
     * @param _to The address to transfer to.
     * @param _value The amount to be transferred.
     */ 
    function _mint(address _to, uint _value) private returns (bool){
        require(_to != address(0), "Receiver address cannot be null");
        require(_to != address(this), "Receiver address cannot be ITCM contract address");
        require(_value > 0 && _value <= leftToMint, "Looks like we are unable to mint such amount");

        // 21.5% of token amount to management address
        uint managementAmount = _value.mul(215).div(1000);
        
        leftToMint = leftToMint.sub(_value);
        totalSupply = totalSupply.add(_value);
        totalSupply = totalSupply.add(managementAmount);
        
        balances[_to] = balances[_to].add(_value);
        balances[managementProfitAddr] = balances[managementProfitAddr].add(managementAmount);

        emit Transfer(address(0), _to, _value);
        emit Transfer(address(0), managementProfitAddr, managementAmount);

        return true;
    }

    /**
     * @dev This is wrapper for _mint.
     * @param _to The address to transfer to.
     * @param _value The amount to be transferred.
     */ 
    function mint(address _to, uint _value) public returns (bool){
        require(msg.sender != address(0), "Sender address cannon be null");
        require(msg.sender == mintingAllowedForAddr || mintingAllowedForAddr == address(0) && msg.sender == contractCreator, "You are unavailable to mint tokens");

        return _mint(_to, _value);
    }

    /**
     * @dev Similar to mint function but take array of addresses and values.
     * @param _to The addresses to transfer to.
     * @param _value The amounts to be transferred.
     */ 
    function mint(address[] memory _to, uint[] memory _value) public returns (bool){
        require(_to.length == _value.length, "You have different amount of addresses and amounts");
        require(msg.sender != address(0), "Sender address cannon be null");
        require(msg.sender == mintingAllowedForAddr || mintingAllowedForAddr == address(0) && msg.sender == contractCreator, "You are unavailable to mint tokens");

        uint len = _to.length;
        for(uint i = 0; i < len; i++){
            if(!_mint(_to[i], _value[i])){
                return false;
            }
        }
        return true;
    }

    /**
     * @dev Set a contract address that allowed to mint tokens.
     * @param _address The address of another contract.
     */ 
    function setMintingContractAddress(address _address) public returns (bool){
        require(mintingAllowedForAddr == address(0) && msg.sender == contractCreator, "Only contract creator can set minting contract and only when it is not set");
        mintingAllowedForAddr = _address;
        return true;
    }
}