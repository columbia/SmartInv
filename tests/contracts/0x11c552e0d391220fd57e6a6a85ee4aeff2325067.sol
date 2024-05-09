//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.6.10;

/*
 * ----------------------------------------------------------------------------
 * Theuses Token Contract
 * 
 * Website		: https://www.theuses.one
 * Telegram		: https://t.me/TheusToken
 * Twitter		: https://twitter.com/TheusToken
 * 
 * Symbol		: THEUS
 * Name			: THEUSES
 * Total Supply	: 50
 * ----------------------------------------------------------------------------
 */

library SafeMath{
 
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }
    
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }
    
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }
    
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
       if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }
    
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }
    
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;

        return c;
    }
    
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }
    
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
    
    function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
	    uint256 c = add(a,m);
	    uint256 d = sub(c,1);
	    return mul(div(d,m),m);
	  }
}

interface ERC20Interface {
    function totalSupply() external view returns (uint256);
    function balanceOf(address tokenOwner) external view returns (uint256 balance);
    function allowance(address tokenOwner, address spender) external view returns (uint256 remaining);
    function transfer(address to, uint256 tokens) external returns (bool success);
    function approve(address spender, uint256 tokens) external returns (bool success);
    function transferFrom(address from, address to, uint256 tokens) external returns (bool success);

    event Transfer(address indexed from, address indexed to, uint256 tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
    event Burn(address indexed from, uint256 value);
}


contract TheusesToken is ERC20Interface {
    
    using SafeMath for uint256;
    uint256 internal _totalSupply;
    
    string public _symbol;
    string public _name;
    uint8 public _decimals;

    mapping (address => uint256) internal _balances;
    mapping (address => mapping (address => uint256)) internal allowed;
    mapping (address => bool) internal _whitelist;
    bool internal _globalWhitelist = true;
    
    uint256 public theusesBasePercent = 100;
    
     constructor (string memory name, string memory symbol) public {
        _name = name;
        _symbol = symbol;
        _decimals = 18;
        _totalSupply = 50000000000000000000;
        _balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
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

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }
    
    function balanceOf(address tokenOwner) public view override returns (uint256 balance){
        return _balances[tokenOwner];
    }
    
    function allowance(address tokenOwner, address spender) public view override returns (uint256 remaining){
        return allowed[tokenOwner][spender];
    }
    
    function transfer(address to, uint256 tokens) public override returns (bool success){

        require(tokens <= _balances[msg.sender]);
        require(to != address(0));

        uint256 tokensToBurn = theusesPercent(tokens);
        uint256 tokensToTransfer = tokens.sub(tokensToBurn);
    
        _balances[msg.sender] = _balances[msg.sender].sub(tokens);
        _balances[to] = _balances[to].add(tokensToTransfer);
    
        _totalSupply = _totalSupply.sub(tokensToBurn);
    
        emit Transfer(msg.sender, to, tokensToTransfer);
        emit Transfer(msg.sender, address(0), tokensToBurn);
        return true;
    }
    
     function theusesPercent(uint256 value) public view returns (uint256)  {
	    uint256 roundValue = value.ceil(theusesBasePercent);
	    uint256 _theusesPercent = roundValue.mul(theusesBasePercent).div(10000);
	    return _theusesPercent;
	  }
	  
    function approve(address spender, uint256 tokens) public override returns (bool success){
        require(msg.sender != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }
    
    function transferFrom(address from, address to, uint256 tokens) public override returns (bool success){
        _balances[from] = SafeMath.sub(_balances[from], tokens, "ERC20: transfer amount exceeds balance");
        allowed[from][msg.sender] = SafeMath.sub(allowed[from][msg.sender], tokens);
        _balances[to] = SafeMath.add(_balances[to], tokens);
        emit Transfer(from, to, tokens);
        return true;
    }
}