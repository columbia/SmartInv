pragma solidity ^0.5.16;
pragma experimental ABIEncoderV2;


// Math operations with safety checks that throw on error
library SafeMath {
    
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);
        return c;
    }
  
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        return a - b;
    }
    
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b);
        return c;
    }
  
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a / b;
        return c;
    }
    
}

// Abstract contract for the full ERC 20 Token standard
contract ERC20 {
    
    function balanceOf(address _address) public view returns (uint256 balance);
    
    function transfer(address _to, uint256 _value) public returns (bool success);
    
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
    
    function approve(address _spender, uint256 _value) public returns (bool success);
    
    function allowance(address _owner, address _spender) public view returns (uint256 remaining);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    
}

contract UniSwap {
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
}

// Token contract
contract BHT is ERC20, UniSwap {
    
    string public name = "Bounty Hunter Token";
    string public symbol = "BHT";
    uint8 public decimals = 18;
    // 总发行量1万个
    uint256 public totalSupply = 10000 * 10**18;
    mapping (address => uint256) public balances;
    mapping (address => mapping (address => uint256)) public allowed;
    // 合约管理者
    address public owner;
    
    /*****************uniswapp配对合约地址************/
    // uniswapp配对合约地址
    address public pairAddress;
    
    /*********************投资这一块*******************/
    // BHC合约的地址
    address public BHCAddress;
    // BHC授权交易
    bytes4 private constant SELECTOR = bytes4(
        keccak256(bytes("transfer(address,uint256)"))
    );
    // 上次提币的时间
    uint256 public lastTime = 0;
    // 30天只能转出一次; 24个小时乘以30天;
    uint256 public monthTime;
    // 提取投资的时间; 24个小时乘以投资的类型的天数;
    uint256 public dayTime;
    // 用户每隔7天可以提现奖励一次;
    uint256 public wTime;
    // 一个只能转出的数量, 一千个
    uint256 tokenNumber = 1000 * 10**18;
    // 地址的投资信息
    struct invest {
        // 投资的类型 30,90,180,3600
        uint256 genre;
        // 开始的时间
        uint256 time;
        // 可提现的时间
        uint256 withdrawTime;
        // 投资的金额BHT
        uint256 money;
        // 赚取的BHC数量; (投资的加赚取的, 但是没有扣除书续费)
        uint256 earnBHC;
        // 可以提现的BHC数量; (扣除手续费之后的数量)
        uint256 withdrawBHC;
        // 是否已经提现
        bool withdraw;
    }
    // 用户的所有投资
    mapping(address => invest[]) public invests;
    // 用户的上级和推广收益, 以及下级数量
    struct inf {
        // 是否注册; ture已注册, false未注册
        bool register;
        // 上级, 也就是推荐人
        address super1;
        // 上上级
        address super2;
        // 下级数量
        uint256 juniors;
        // 推广的奖励; 也是BHC
        uint256 award;
        // 下级投资了多少钱
        uint256 group;
        // 下次可以提现奖励的时间; (每隔7天可以提现一次推荐奖励)
        uint256 time;
    }
    mapping(address => inf) public info;
    // 提现推广奖励的记录
    struct record {
        // 提现的时间
        uint256 time;
        // 提现的金额
        uint256 money;
    }
    mapping(address => record[]) public records;
    
    /*********************投资这一块*******************/
    
    // 构造函数;
    // 主网使用BHC地址, 时间是86400秒(也就是一天);
    // 测试网使用代币地址(0x...); 时间自定义(60) 
    constructor(address _BHCAddress, uint256 _day) public {
        balances[address(this)] = totalSupply;
        owner = msg.sender;
        // BHC代币合约地址
        BHCAddress = _BHCAddress;
        // 管理员一个月只能转出一次BHT;
        monthTime = _day * 30;
        // 提取投资的时间; 24个小时乘以投资的类型的天数;
        dayTime = _day;
        // 用户提现的间隔时间;
        wTime = _day * 7;
    }
    
    // 管理员修饰符
    modifier onlyOwner { 
        require(msg.sender == owner, "You are not owner");
        _;
    }
    
    function balanceOf(address _address) public view returns (uint256 balance) {
        return balances[_address];
    }
    
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(_to != address(0));
        require(balances[msg.sender] >= _value && _value > 0, "Insufficient balance or zero amount");
        balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
        balances[_to] = SafeMath.add(balances[_to], _value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
    
    function approve(address _spender, uint256 _amount) public returns (bool success) {
        require(_spender != address(0));
        require((allowed[msg.sender][_spender] == 0) || (_amount == 0));
        allowed[msg.sender][_spender] = _amount;
        emit Approval(msg.sender, _spender, _amount);
        return true;
    }
    
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_from != address(0) && _to != address(0));
        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0, "Insufficient balance or zero amount");
        balances[_from] = SafeMath.sub(balances[_from], _value);
        balances[_to] = SafeMath.add(balances[_to], _value);
        allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
        emit Transfer(_from, _to, _value);
        return true;
    }
    
    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }
    
    // 更换管理员
    function setOwner(address _owner) public onlyOwner returns (bool success) {
        require(_owner != address(0));
        owner= _owner;
        return true;
    }
    
    /************************************投资这一块***********************************/
    // 已注册修饰符
    modifier onlyRegistered {
        require(info[msg.sender].register, "You have not registered");
        _;
    }
    // 已投资的修饰符
    modifier onlyInvest {
        require(invests[msg.sender].length > 0, "You have not Invest");
        _;
    }
    
    // 注册事件
    event RegisterInvest(address indexed _super1, address indexed _address);
    // 锁仓投资事件
    event LockedInvest(address indexed _address, uint256 _value, uint256 _genre);
    // 提现锁仓投资事件
    event WithdrawInvest(address indexed _address, uint256 _value);
    // 提现推广奖励事件
    event WithdrawAward(address indexed _address, uint256 _value);
    
    
    // 管理员取出BHT; 每30天只能提币一次, 一次必须是1000个;
    function fetchBHT(address _address) public onlyOwner returns (bool success) {
        // 不能是0地址
        require(_address != address(0));
        require(balances[address(this)] >= tokenNumber, "Contract insufficient balance");
        if(lastTime == 0) {
            // 如果上次提币时间是0, 说明这是第一次提币;
            lastTime = block.timestamp;
        }else {
            // 如果不是0, 说明不是第一次提币; 需要判断时间有没有过30天;
            require(lastTime + monthTime < block.timestamp, "Time is not");
            lastTime += monthTime;
        }
        balances[_address] = SafeMath.add(balances[_address], tokenNumber);
        balances[address(this)] = SafeMath.sub(balances[address(this)], tokenNumber);
        emit Transfer(address(this), _address, tokenNumber);
        success = true;
    }
    
    // 管理员取出BHC
    function fetchBHC(address _to, uint256 _value) public onlyOwner returns (bool success2) {
        // 不能是0地址
        require(_to != address(0));
        (bool success, ) = BHCAddress.call(
            abi.encodeWithSelector(SELECTOR, _to, _value)
        );
        if(!success) {
            revert("transfer fail");
        }
        success2 = true;
    }
    
    // 管理员设置配对合约地址
    function setPairAddress(address _address) public onlyOwner returns (bool success) {
         // 不能是0地址
        require(_address != address(0));
        pairAddress = _address;
        success = true;
    }
    
    // 注册; 投资之前需要先进行一个注册操作, 梳理下上级身份;
    function registerInvest(address _super1) public returns (bool success) {
        // 注册人必须没有注册过;
        require(!(info[msg.sender].register), "You have been registered");
        // 如果推荐人是0地址; 就相当于是没有推荐人, 前端默认的0地址
        if(_super1 == address(0)) {
            // 已注册; 结束
            info[msg.sender].register = true;
            return true;
        }
        // 上级(也就是推荐人)必须是已经注册的地址;
        require(info[_super1].register, "The referee is not registered");
        // 修改注册人信息; 已注册, 赋值上级
        info[msg.sender].register = true;
        info[msg.sender].super1 = _super1;
        // 梳理上下级身份, 最多有二级;
        // 先处理上级; 下级数量加1;
        info[_super1].juniors += 1;
        // 判断有没有上上级;
        address super2 = info[_super1].super1;
        if(super2 != address(0)) {
            // 说明有上上级; 注册人添加上上级, 上上级的下级人数加1
            info[msg.sender].super2 = super2;
            info[super2].juniors += 1;
        }
        // 触发注册事件
        emit RegisterInvest(_super1, msg.sender);
        success = true;
    }
    
    // 锁仓投资;
    function lockedInvest(uint256 _value, uint256 _genre) public onlyRegistered returns (bool success) {
        // 锁仓类型只有四种; 30天平均月化8%, 90天平均月化9%, 180天平均月化10%, 360天平均月化12%;
        require(_genre == 30 || _genre == 90 || _genre == 180 || _genre == 360, "locked position type inexistence");
        // 判断BHT余额是否足够; 并且投资金额必须大于0;
        require(balances[msg.sender] >= _value && _value > 0, "Insufficient balance or zero amount");
        // 把用户投资的币放到合约里
        balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
        balances[address(this)] = SafeMath.add(balances[address(this)], _value);
        emit Transfer(msg.sender, address(this), _value);
        
        // 计算投资的值对应的BHC数量;
        uint256 _value2 = getPro(_value);
        
        // 可提现时间
        uint256 wt = block.timestamp + dayTime * _genre;
        // 赚取金额BHC数量; (投资+收益, 但没有扣除手续费)
        uint256 eb;
        // 应该给到推广奖励的数量;
        uint256 award1;
        uint256 award2;
        if(_genre == 30) {
            // 计算投资赚取BHC的收益
            eb = _value2 + _value2 * 8/100;
            // 计算上级的推荐奖励
            award1 = _value2 * 8/100 * 20/100;
            award2 = _value2 * 8/100 * 10/100;
        }
        if(_genre == 90) {
            eb = _value2 + _value2 * 9/100 * 3;
            award1 = _value2 * 9/100 * 20/100 * 3;
            award2 = _value2 * 9/100 * 10/100 * 3;
        }
        if(_genre == 180) {
            eb = _value2 + _value2 * 10/100 * 6;
            award1 = _value2 * 10/100 * 20/100 * 6;
            award2 = _value2 * 10/100 * 10/100 * 6;
        }
        if(_genre == 360) {
            eb = _value2 + _value2 * 12/100 * 12;
            award1 = _value2 * 12/100 * 20/100 * 12;
            award2 = _value2 * 12/100 * 10/100 * 12;
        }
        // 可提现的金额BHC数量;
        uint256 wb = eb - (eb * 3/100);
        // 保存用户的投资信息; 类型,时间,可提现时间,投资金额BHT,赚取金额BHC,可以提现的金额BHC,未提现
        invest memory i = invest(_genre, block.timestamp, wt, _value, eb, wb, false);
        invests[msg.sender].push(i);
        
        // 给上级增加奖励;
        address super1 = info[msg.sender].super1;
        address super2 = info[msg.sender].super2;
        if(super1 != address(0)) {
           info[super1].award += award1;
           info[super1].group += _value;
        }
        if(super2 != address(0)) {
          info[super2].award += award2;
          info[super2].group += _value;
        }
        
        // 触发锁仓事件
        emit LockedInvest(msg.sender, _value, _genre);
        success = true;
    }
    
    // 提现锁仓投资; 通过索引进行提现, 提现的币是BHC, 收取的手续费也是BHC, 销毁的BHT
    function withdrawInvest(uint256 _index) public onlyInvest returns (bool success2) {
        // 索引必须小于投资数组的长度
        require(invests[msg.sender].length > _index, "invest is not");
        // 先获取索引对应的投资订单;
        invest memory i = invests[msg.sender][_index];
        // 提现时间, 是否提现, 销毁的BHT数量, 用户提现BHC的数量;
        uint256 wt = i.withdrawTime;
        bool w = i.withdraw;
        uint256 m = i.money;
        uint256 wb = i.withdrawBHC;
        // 判断这笔订单是否到达可提现时间
        require(block.timestamp > wt, "Time is not");
        // 判断这笔订单是否已经提现
        require(!w, "already withdraw");
        
        // 销毁投资的BHT;
        balances[address(this)] = SafeMath.sub(balances[address(this)], m);
        balances[address(0)] = SafeMath.add(balances[address(0)], m);
        emit Transfer(address(this), address(0), m);
        // 用户提现BHC
        (bool success, ) = BHCAddress.call(
            abi.encodeWithSelector(SELECTOR, msg.sender, wb)
        );
        if(!success) {
            revert("transfer fail");
        }
        
        // 修改状态; 已经提现
        invests[msg.sender][_index].withdraw = true;
        // 触发提现锁仓事件
        emit WithdrawInvest(msg.sender, wb);
        success2 = true;
         // 确认; 防止攻击者控制gas
        assert(invests[msg.sender][_index].withdraw);
    }
    
    // 提现推广奖励; 通过金额进行提取
    function withdrawAward(uint256 _money) public onlyInvest returns (bool success2) {
        // 可提现奖励的金额, 可提现的时间
        uint256 m = info[msg.sender].award;
        uint256 t = info[msg.sender].time;
        // 金额判断;
        require(m >= _money, "The amount is not enough");
        // 时间判断
        require(t < block.timestamp, "Time is not");
        
        // 实际转账的值; 扣除3%的手续费
        uint256 v = _money - (_money * 3/100);
        // 转账
       (bool success, ) = BHCAddress.call(
            abi.encodeWithSelector(SELECTOR, msg.sender, v)
        );
        if(!success) {
            revert("transfer fail");
        }
        // 修改数据
        info[msg.sender].award -= _money;
        // 触发提现推广奖励事件
        emit WithdrawAward(msg.sender, _money);
        // 重新修改可提现时间
        info[msg.sender].time = block.timestamp + wTime;
        // 保存提现记录
        record memory r = record(block.timestamp, _money);
        records[msg.sender].push(r);
        success2 = true;
    }
    
    // 查询用户所有的投资
    function getInvests(address _address) public view returns (invest[] memory r) {
        // 获取所有投资的数量
        uint256 l = invests[_address].length;
        // 创建定长数组对象
        r = new invest[](l);
        for(uint256 i = 0; i < l; i++) {
            r[i] = invests[_address][i];
        }
    }
    
    // 查询用户所有的提现记录
    function getRecords(address _address) public view returns (record[] memory r) {
        // 获取所有投资的数量
        uint256 l = records[_address].length;
        r = new record[](l);
        for(uint256 i = 0; i < l; i++) {
            r[i] = records[_address][i];
        }
    }
    
    // 查询用户的信息
    function getInfo(address _address) public view returns (inf memory r) {
        r = info[_address];
    }
    
    /* ----------------uniswap配对合约的交互----------------- */
    // 重写这个函数
    function getReserves() public view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast) {
        UniSwap uniswap = UniSwap(pairAddress);
        // 返回的值, 地址小的在前面, 大的在后面
        (_reserve0, _reserve1, _blockTimestampLast) = uniswap.getReserves();
    }
    
    // 根据当时的比例, 给出BHT计算出BHC;
    function getPro(uint256 _value) public view returns (uint256 v) {
        // 显示转换
        (uint256 _reserve0, uint256 _reserve1, ) = getReserves();
        require(address(this) != BHCAddress, "two address identical");
        if(address(this) < BHCAddress) {
            // 说明_reserve0对应的BHT, _reserve1对应BHC;
            v = _value * _reserve1 / _reserve0;
        }else {
            v = _value * _reserve0 / _reserve1;
        }
    }
    
  
    
}