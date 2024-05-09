pragma solidity ^0.4.23;

library SafeMath {
  
    function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        if (a == 0) {
            return 0;
        }
        c = a * b;
        assert(c / a == b);
        return c;
    }
    
 
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
  
        return a / b;
    }

    
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a + b;
        assert(c >= a);
        return c;
    }

    function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
        uint256 c = add(a,m);
        uint256 d = sub(c,1);
        return mul(div(d,m),m);
  }

}

contract Ownable {
    address public owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

   constructor() public {
      owner = msg.sender;
    }
    
    modifier onlyOwner() {
      require(msg.sender == owner, "Must be an owner");
      _;
    }
    
    function transferOwnership(address newOwner) public onlyOwner {
      require(newOwner != address(0), "New owner must be a non-zero address");
      emit OwnershipTransferred(owner, newOwner);
      owner = newOwner;
    }
}

contract ERC20Basic {
    function totalSupply() public view returns (uint256);
    function balanceOf(address who) public view returns (uint256);
    function transfer(address to, uint256 value) public returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
}

contract ERC20 is ERC20Basic {
    function allowance(address owner, address spender) public view returns (uint256);
    function transferFrom(address from, address to, uint256 value) public returns (bool);
    function approve(address spender, uint256 value) public returns (bool);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract BasicToken is ERC20Basic {
    using SafeMath for uint256;
    mapping(address => uint256) balances;
    mapping(address => uint256) ethBalances;
    
    uint256 totalSupply_;
    
    function totalSupply() public view returns (uint256) {
        return totalSupply_;
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return balances[_owner];
    }

    function checkInvestedETH(address who) public view returns (uint256) {
        return ethBalances[who];
    }

}

contract StandardToken is ERC20, BasicToken {
    mapping (address => mapping (address => uint256)) internal allowed;
    uint256 public basePercent = 100;

    function findOnePercent(uint256 value) public view returns (uint256)  {
     uint256 roundValue = value.ceil(basePercent);
     uint256 onePercent = roundValue.mul(basePercent).div(10000);
     return onePercent;
    }

    function transfer(address to, uint256 value) public returns (bool) {
        require(value <= balances[msg.sender], "Not enough tokens to transfer");
        require(to != address(0), "Receiver must be a non-zero address");

        uint256 tokensToBurn = findOnePercent(value);
        uint256 tokensToTransfer = value.sub(tokensToBurn);

        balances[msg.sender] = balances[msg.sender].sub(value);
        balances[to] = balances[to].add(tokensToTransfer);

        totalSupply_ = totalSupply_.sub(tokensToBurn);

        emit Transfer(msg.sender, to, tokensToTransfer);
        emit Transfer(msg.sender, address(0), tokensToBurn);
        return true;
    }

    function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
        for (uint256 i = 0; i < receivers.length; i++) {
        transfer(receivers[i], amounts[i]);
        }
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        require(value <= balances[from], "Must have sufficient balance");
        require(value <= allowed[from][msg.sender], "Spender has sufficient spending balance");
        require(to != address(0), "Sender must be a non-zero address");

        balances[from] = balances[from].sub(value);

        uint256 tokensToBurn = findOnePercent(value);
        uint256 tokensToTransfer = value.sub(tokensToBurn);

        balances[to] = balances[to].add(tokensToTransfer);
        totalSupply_ = totalSupply_.sub(tokensToBurn);

        allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);

        emit Transfer(from, to, tokensToTransfer);
        emit Transfer(from, address(0), tokensToBurn);

        return true;
    } 

    function approve(address spender, uint256 value) public returns (bool) {
        require(spender != address(0), "Cannot approve to a zero address");
        allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }
    
    function allowance(address _owner, address _spender) public view returns (uint256) {
        return allowed[_owner][_spender];
    }
    
    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        require(spender != address(0), "Must be a non zero address");
        allowed[msg.sender][spender] = (allowed[msg.sender][spender].add(addedValue));
        emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
        return true;
    }

    function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
        uint oldValue = allowed[msg.sender][spender];
        if (subtractedValue > oldValue) {
            allowed[msg.sender][spender] = 0;
        } else {
            allowed[msg.sender][spender] = oldValue.sub(subtractedValue);
        }
        emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
        return true;
    }

}

contract Configurable {
    uint256 public constant cap = 9000*10**18; 
    uint256 public constant basePrice = 180*10**18; 
    uint256 public tokensSold = 0;
    
    uint256 public constant tokenReserve = 15000*10**18;
    uint256 public remainingTokens = 0;
}

contract CrowdsaleToken is StandardToken, Configurable, Ownable {
  
     enum Stages {
        none,
        icoStart, 
        icoEnd
    }
    
    Stages currentStage;

    constructor() public {
        currentStage = Stages.none;
        balances[owner] = balances[owner].add(tokenReserve);
        totalSupply_ = totalSupply_.add(tokenReserve);
        remainingTokens = cap;
        emit Transfer(address(this), owner, tokenReserve);
    }

    function () public payable {
        require(currentStage == Stages.icoStart, "The coin offering has not started yet");
        require(msg.value > 0 && msg.value <= 1e18, "You cannot send 0 Ether or more than 1 Ether");
        require(remainingTokens > 0, "Must be some tokens remaining");
       
        address caller = msg.sender;
        uint256 weiAmount = msg.value;
        uint256 tokens = weiAmount.mul(basePrice).div(1 ether);
        uint256 returnWei = 0;
        
        ethBalances[caller] = ethBalances[caller].add(weiAmount);
        ethBalances[address(this)] = ethBalances[address(this)].add(weiAmount);
       
        require(ethBalances[caller] <= 1e18);
        require(ethBalances[address(this)] <= 50e18);

        if(tokensSold.add(tokens) > cap){
            uint256 newTokens = cap.sub(tokensSold);
            uint256 newWei = newTokens.div(basePrice).mul(1 ether);
            returnWei = weiAmount.sub(newWei);
            weiAmount = newWei;
            tokens = newTokens;
        }
        
        tokensSold = tokensSold.add(tokens); 
        remainingTokens = cap.sub(tokensSold);
        if(returnWei > 0){
            msg.sender.transfer(returnWei);
            emit Transfer(address(this), msg.sender, returnWei);
        }
        
        balances[msg.sender] = balances[msg.sender].add(tokens);
        emit Transfer(address(this), msg.sender, tokens);
        totalSupply_ = totalSupply_.add(tokens);
        owner.transfer(weiAmount);
    }

    function startIco() public onlyOwner {
        require(currentStage != Stages.icoEnd, "The coin offering has ended");
        currentStage = Stages.icoStart;
    }

    function endIco() internal {
        currentStage = Stages.icoEnd;
        if(remainingTokens > 0)
            balances[owner] = balances[owner].add(remainingTokens);
        owner.transfer(address(this).balance); 
    }

    function finalizeIco() public onlyOwner {
        require(currentStage != Stages.icoEnd, "The coin offering has ended");
        endIco();
    }
    
}

contract LETSFKNGO is CrowdsaleToken {
    string public constant name = "LETSFKNGO";
    string public constant symbol = "LFG";
    uint32 public constant decimals = 18;
}