pragma solidity >=0.4.22 <0.6.0;

contract IMigrationContract {
    function migrate(address addr, uint256 nas) public returns (bool success);
}

contract SafeMath {


    function safeAdd(uint256 x, uint256 y) internal pure returns(uint256) {
        uint256 z = x + y;
        assert((z >= x) && (z >= y));
        return z;
    }

    function safeSubtract(uint256 x, uint256 y) internal pure returns(uint256) {
        assert(x >= y);
        uint256 z = x - y;
        return z;
    }

    function safeMult(uint256 x, uint256 y) internal pure returns(uint256) {
        uint256 z = x * y;
        assert((x == 0)||(z/x == y));
        return z;
    }

    function safeDiv(uint256 x, uint256 y) internal pure returns (uint256) {
        assert(y > 0);
        uint256 z = x / y;
        assert(x == y * z + x % y);
        return z;
    }

}

contract Token {
    uint256 public totalSupply;
    function balanceOf(address _owner) public view returns (uint256 balance);
    function transfer(address _to, uint256 _value) public returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
    function approve(address _spender, uint256 _value) public returns (bool success);
    function allowance(address _owner, address _spender) public view returns (uint256 remaining);
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}


/*  ERC 20 token */
contract StandardToken is SafeMath, Token {

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(_to != address(0));
        require(_value <= balances[msg.sender]);

        balances[msg.sender] = safeSubtract(balances[msg.sender], _value);
        balances[_to] = safeAdd(balances[_to], _value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_from != address(0));
        require(_to != address(0));
        require(_value <= balances[_from]);
        require(_value > 0);
        require(allowed[_from][msg.sender] >= _value);

        balances[_from] = safeSubtract(balances[_from], _value);
        allowed[_from][msg.sender] = safeSubtract(allowed[_from][msg.sender], _value);
        balances[_to] = safeAdd(balances[_to], _value);
        emit Transfer(_from, _to, _value);
        return true;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;
}

contract GENEToken is StandardToken {
    // metadata
    string  public constant name = "GENE";
    string  public constant symbol = "GE";
    uint8   public constant decimals = 18;
    string  public version = "1.0";

    // contracts
    address payable public ethFundDeposit;  // ETH存放地址
    address public newContractAddr;         // token更新地址

    // crowdsale parameters
    bool    public isFunding;                // 状态切换到true
    uint256 public fundingStartBlock;
    uint256 public fundingStopBlock;

    uint256 public currentSupply;           // 正在售卖中的tokens数量
    uint256 public tokenRaised = 0;         // 总的售卖数量token
    uint256 public tokenMigrated = 0;       // 总的已经交易的 token
    uint256 public tokenExchangeRate = 1;             // 1 GE 兑换 1 ETH

    // events
    event AllocateToken(address indexed _to, uint256 _value);   // 分配的私有交易token;
    event IssueToken(address indexed _to, uint256 _value);      // 公开发行售卖的token;
    event IncreaseSupply(uint256 _value);
    event DecreaseSupply(uint256 _value);
    event Migrate(address indexed _to, uint256 _value);

    // 转换
    function formatDecimals(uint256 _value) internal pure returns (uint256 ) {
        return _value * 10 ** uint256(decimals);
    }

    // constructor
    constructor(address payable _ethFundDeposit, uint256 _currentSupply) public{
        ethFundDeposit = _ethFundDeposit;

        isFunding = false;                           // 通过控制预CrowdS ale状态
        fundingStartBlock = 0;
        fundingStopBlock = 0;

        currentSupply = formatDecimals(_currentSupply);
        totalSupply = formatDecimals(1000000000);
        balances[msg.sender] = totalSupply;
        require(currentSupply <= totalSupply);
    }

    modifier isOwner()  { require(msg.sender == ethFundDeposit); _; }

    /// 设置token汇率
    function setTokenExchangeRate(uint256 _tokenExchangeRate) isOwner external {
        require(_tokenExchangeRate != 0);
        require(_tokenExchangeRate != tokenExchangeRate);

        tokenExchangeRate = _tokenExchangeRate;
    }

    /// @dev 超发token处理
    function increaseSupply (uint256 _value) isOwner external {
        uint256 value = formatDecimals(_value);
        require(value + currentSupply <= totalSupply);
        currentSupply = safeAdd(currentSupply, value);
        emit IncreaseSupply(value);
    }

    /// @dev 被盗token处理
    function decreaseSupply (uint256 _value) isOwner external {
        uint256 value = formatDecimals(_value);
        require(value + tokenRaised <= currentSupply);

        currentSupply = safeSubtract(currentSupply, value);
        emit DecreaseSupply(value);
    }

    /// 启动区块检测 异常的处理
    function startFunding (uint256 _fundingStartBlock, uint256 _fundingStopBlock) isOwner external {
        require(!isFunding);
        require(_fundingStartBlock < _fundingStopBlock);
        require(block.number < _fundingStartBlock);

        fundingStartBlock = _fundingStartBlock;
        fundingStopBlock = _fundingStopBlock;
        isFunding = true;
    }

    /// 关闭区块异常处理
    function stopFunding() isOwner external {
        require(isFunding);
        isFunding = false;
    }

    /// 开发了一个新的合同来接收token（或者更新token）
    function setMigrateContract(address _newContractAddr) isOwner external {
        require(_newContractAddr != newContractAddr);
        newContractAddr = _newContractAddr;
    }

    /// 设置新的所有者地址
    function changeOwner(address payable _newFundDeposit) isOwner external {
        require(_newFundDeposit != address(0x0));
        ethFundDeposit = _newFundDeposit;
    }

    /// 转移token到新的合约
    function migrate() external {
        require(!isFunding);
        require(newContractAddr != address(0x0));

        uint256 tokens = balances[msg.sender];
        require(tokens != 0);

        balances[msg.sender] = 0;
        tokenMigrated = safeAdd(tokenMigrated, tokens);

        IMigrationContract newContract = IMigrationContract(newContractAddr);
        require(newContract.migrate(msg.sender, tokens));

        emit Migrate(msg.sender, tokens);               // log it
    }

    /// 转账ETH 到 GE 团队
    function transferETH() isOwner external {
        require(address(this).balance != 0);
        require(ethFundDeposit.send(address(this).balance));
    }

    /// 将GE token分配到预处理地址。
    function allocateToken (address _addr, uint256 _eth) isOwner external {
        require(_eth != 0);
        require(_addr != address(0x0));
        require(isFunding);

        uint256 tokens = safeDiv(formatDecimals(_eth), tokenExchangeRate);
        require(tokens + tokenRaised <= currentSupply);

        tokenRaised = safeAdd(tokenRaised, tokens);
        balances[_addr] = safeAdd(balances[_addr], tokens);
        balances[msg.sender] = safeSubtract(balances[msg.sender], tokens);

        emit AllocateToken(_addr, tokens); // 记录token日志
    }

    /// 购买token
    function () external payable {
        require(isFunding);
        require(msg.value != 0);

        require(block.number >= fundingStartBlock);
        require(block.number <= fundingStopBlock);

        uint256 tokens = safeDiv(msg.value, tokenExchangeRate);
        require(tokens + tokenRaised <= currentSupply);

        tokenRaised = safeAdd(tokenRaised, tokens);
        balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
        balances[ethFundDeposit] = safeSubtract(balances[ethFundDeposit], tokens);

        emit IssueToken(msg.sender, tokens); //记录日志
    }
}