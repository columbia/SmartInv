pragma solidity ^0.4.25;

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
**/

library SafeMathLib{
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
**/
contract Ownable {
    address public owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
    * account.
    */
    constructor() public {
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
    function transferOwnership(address newOwner) onlyOwner public {
        require(newOwner != address(0));
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}

contract APM is Ownable {
    using SafeMathLib for uint256;
    string public name;
    string public symbol;
    uint256 public totalSupply;
    
    // Balances for each account
    mapping(address => uint256) balances;

    // Owner of account approves the transfer of an amount to another account
    mapping(address => mapping (address => uint256)) allowed;
    
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed from, address indexed spender, uint tokens);
    
    constructor(uint256 tokenSupply, string tokenName, string tokenSymbol) public {
        totalSupply = tokenSupply; 
        balances[msg.sender] = totalSupply;  
        name = tokenName;                                 
        symbol = tokenSymbol;                           
    }

    /** ****************************** Internal ******************************** **/ 
        /**
         * @dev Internal transfer for all functions that transfer.
         * @param _from The address that is transferring coins.
         * @param _to The receiving address of the coins.
         * @param _amount The amount of coins being transferred.
        **/

        function _transfer(address _from, address _to, uint256 _amount) internal returns (bool success)
        {
            require (_to != address(0));
            require(balances[_from] >= _amount);
            
            balances[_from] = balances[_from].sub(_amount);
            balances[_to] = balances[_to].add(_amount);
            
            emit Transfer(_from, _to, _amount);
            return true;
        }
        
        /**
         * @dev Internal approve for all functions that require an approve.
         * @param _owner The owner who is allowing spender to use their balance.
         * @param _spender The wallet approved to spend tokens.
         * @param _amount The amount of tokens approved to spend.
        **/
        function _approve(address _owner, address _spender, uint256 _amount) internal returns (bool success)
        {
            allowed[_owner][_spender] = _amount;
            emit Approval(_owner, _spender, _amount);
            return true;
        }
        
        /**
         * @dev Increases the allowed by "_amount" for "_spender" from "owner"
         * @param _owner The address that tokens may be transferred from.
         * @param _spender The address that may transfer these tokens.
         * @param _amount The amount of tokens to transfer.
        **/
        function _increaseApproval(address _owner, address _spender, uint256 _amount) internal returns (bool success)
        {
            allowed[_owner][_spender] = allowed[_owner][_spender].add(_amount);
            emit Approval(_owner, _spender, allowed[_owner][_spender]);
            return true;
        }
        
        /**
         * @dev Decreases the allowed by "_amount" for "_spender" from "_owner"
         * @param _owner The owner of the tokens to decrease allowed for.
         * @param _spender The spender whose allowed will decrease.
         * @param _amount The amount of tokens to decrease allowed by.
        **/
        function _decreaseApproval(address _owner, address _spender, uint256 _amount) internal returns (bool success)
        {
            if (allowed[_owner][_spender] <= _amount) allowed[_owner][_spender] = 0;
            else allowed[_owner][_spender] = allowed[_owner][_spender].sub(_amount);
            
            emit Approval(_owner, _spender, allowed[_owner][_spender]);
            return true;
        }
    /** ****************************** End Internal ******************************** **/
 

    /** ******************************** ERC20 ********************************* **/
        /**
         * @dev Transfers coins from one address to another.
         * @param _to The recipient of the transfer amount.
         * @param _amount The amount of tokens to transfer.
        **/
        function transfer(address _to, uint256 _amount) public returns (bool success)
        {
            require(_transfer(msg.sender, _to, _amount));
            return true;
        }
        
        /**
         * @dev An allowed address can transfer tokens from another's address.
         * @param _from The owner of the tokens to be transferred.
         * @param _to The address to which the tokens will be transferred.
         * @param _amount The amount of tokens to be transferred.
        **/
        function transferFrom(address _from, address _to, uint _amount) public returns (bool success)
        {
            require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount);

            allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
            
            require(_transfer(_from, _to, _amount));
            return true;
        }
        
        /**
         * @dev Approves a wallet to transfer tokens on one's behalf.
         * @param _spender The wallet approved to spend tokens.
         * @param _amount The amount of tokens approved to spend.
        **/
        function approve(address _spender, uint256 _amount) public returns (bool success)
        {
            require(_approve(msg.sender, _spender, _amount));
            return true;
        }
        
        /**
         * @dev Increases the allowed amount for spender from msg.sender.
         * @param _spender The address to increase allowed amount for.
         * @param _amount The amount of tokens to increase allowed amount by.
        **/
        function increaseApproval(address _spender, uint256 _amount) public returns (bool success)
        {
            require(_increaseApproval(msg.sender, _spender, _amount));
            return true;
        }
        
        /**
         * @dev Decreases the allowed amount for spender from msg.sender.
         * @param _spender The address to decrease allowed amount for.
         * @param _amount The amount of tokens to decrease allowed amount by.
        **/
        function decreaseApproval(address _spender, uint256 _amount) public returns (bool success)
        {
            require(_decreaseApproval(msg.sender, _spender, _amount));
            return true;
        }
    /** ******************************** End ERC20 ********************************* **/
    

    /** ******************************** Avior Plus Miles ********************** **/
        function transferDelegate(address _from, address _to, uint256 _amount, uint256 _fee) public onlyOwner returns (bool success) 
        {
            require(balances[_from] >= _amount + _fee);
            require(_transfer(_from, _to, _amount));
            require(_transfer(_from, msg.sender, _fee));
            return true;
        }
    /** ******************************** END Avior Plus Miles ********************** **/

    
    /** ****************************** Constants ******************************* **/
    
        /**
         * @dev Return total supply of token.
        **/
        function totalSupply() external view returns (uint256)
        {
            return totalSupply;
        }

        /**
         * @dev Return balance of a certain address.
         * @param _owner The address whose balance we want to check.
        **/
        function balanceOf(address _owner) external view returns (uint256) 
        {
            return balances[_owner];
        }
        
        function notRedeemed() external view returns (uint256) 
        {
            return totalSupply - balances[owner];
        }
        
        /**
         * @dev Allowed amount for a user to spend of another's tokens.
         * @param _owner The owner of the tokens approved to spend.
         * @param _spender The address of the user allowed to spend the tokens.
        **/
        function allowance(address _owner, address _spender) external view returns (uint256) 
        {
            return allowed[_owner][_spender];
        }
    /** ****************************** END Constants ******************************* **/
}