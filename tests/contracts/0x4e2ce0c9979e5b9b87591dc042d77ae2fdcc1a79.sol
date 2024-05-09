/**
 *Submitted for verification at Etherscan.io on 2019-08-29
*/

pragma solidity >=0.4.22 <0.6.0;


contract Ownable {
    address private _owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    constructor () internal {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }
    function owner() public view returns (address) {
        return _owner;
    }
    
    modifier onlyOwner() {
        require(isOwner());
        _;
    }
    
    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }
    
    
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }
   
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0));
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}


contract SafeMath {
  function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b > 0);
    uint256 c = a / b;
    assert(a == b * c + a % b);
    return c;
  }

  function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c>=a && c>=b);
    return c;
  }

}

contract BaseToken is  SafeMath,Ownable{
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;
    mapping (address => bool) public isFreeze;
    event Transfer(address indexed from, address indexed to, uint256  value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event FrozenFunds(address target, bool frozen);
    
    
    constructor(uint256 initialSupply,
        string tokenName,
        string tokenSymbol,
        uint8 decimals
    )public {
        totalSupply = initialSupply * 10 ** uint256(decimals);  
        balanceOf[msg.sender] = totalSupply;                
        name = tokenName;                                  
        symbol = tokenSymbol; 
        decimals=decimals;
    }

    modifier not_frozen(){
        require(isFreeze[msg.sender]==false);
        _;
    }
    function transfer(address _to, uint256 _value) public not_frozen returns (bool) {
        require(_to != address(0));
		require(_value > 0); 
        require(balanceOf[msg.sender] >= _value);
        require(balanceOf[_to] + _value >= balanceOf[_to]);
		uint previousBalances = balanceOf[msg.sender] + balanceOf[_to];		
        balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);
        balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);
        emit Transfer(msg.sender, _to, _value);
		assert(balanceOf[msg.sender]+balanceOf[_to]==previousBalances);
        return true;
    }

    function approve(address _spender, uint256 _value) public not_frozen returns (bool success) {
		require((_value == 0) || (allowance[msg.sender][_spender] == 0));
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public not_frozen returns (bool success) {
        require (_to != address(0));
		require (_value > 0); 
        require (balanceOf[_from] >= _value) ;
        require (balanceOf[_to] + _value > balanceOf[_to]);
        require (_value <= allowance[_from][msg.sender]);
        balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);
        balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);
        allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
        emit Transfer(_from, _to, _value);
        return true;
    }
      //冻结解冻
    function freezeOneAccount(address target, bool freeze) onlyOwner public {
        require(freeze!=isFreeze[target]); 
        isFreeze[target] = freeze;
        emit FrozenFunds(target, freeze);
    }
    
    //批量冻结解冻
    function multiFreeze(address[] targets,bool freeze) onlyOwner public {
        for(uint256 i = 0; i < targets.length ; i++){
            freezeOneAccount(targets[i],freeze);
        }
    }
    
}

contract MBSCoin is BaseToken
{
    string public name = "Mobius";
    string public symbol = "MBS";
    string public version = '1.0.0';
    uint8 public decimals = 18;
    uint256 initialSupply=100000000;
    constructor()BaseToken(initialSupply, name,symbol,decimals)public {}
    bool public auto_lock   = false;
    mapping (address => uint) public lockedAmount;
    address[] public lockedAddress;
    mapping(address => bool) public isExsitLocked;
    uint256 public lockedAddressAmount;
    event LockToken(address indexed target, uint256 indexed amount);
    event OwnerUnlock(address indexed from,uint256 indexed amount);
    event TransferLockedCoin(address indexed from, address indexed to, uint256 indexed value);
    uint256 public buy_price;
    uint256 public buyer_lock_rate; 
    uint8 public usdt_decimal=6;
    uint8 public price_decimal=3;
    function set_buy_price(uint256 price) public onlyOwner
    {
        buy_price=price;
    }
    function set_lock_rate(uint256 new_lock_rate) public onlyOwner
    {
        require(new_lock_rate>=0 && new_lock_rate<=10);
        buyer_lock_rate=new_lock_rate;
    }
    
    function sum(uint256[] data) public  pure returns (uint256) {
        uint256 S;
        for(uint i;i < data.length;i++) {
            S += data[i];
        }
        return S;
    }

    function setAutoLockFlag(bool openOrClose) public onlyOwner {
        require(openOrClose!=auto_lock);
        auto_lock=openOrClose;
    }

    function transfer_locked_coin(address _to, uint256 _value) public not_frozen returns (bool) {
        require(_to != address(0));
		require(_value > 0); 
        require(lockedAmount[msg.sender] >= _value);
        require(lockedAmount[_to] + _value >= lockedAmount[_to]);
		uint previousBalances = lockedAmount[msg.sender] + lockedAmount[_to];		
        lockedAmount[msg.sender] = SafeMath.safeSub(lockedAmount[msg.sender], _value);
        lockedAmount[_to] = SafeMath.safeAdd(lockedAmount[_to], _value);
		assert(lockedAmount[msg.sender]+lockedAmount[_to]==previousBalances);
		emit TransferLockedCoin(msg.sender, _to, _value);
        return true;
    }

    //批量转账
    function SendGiftMultiAddress(address[] _recivers, uint256[] _values) public onlyOwner 
    {
        require (_recivers.length == _values.length);
        require(balanceOf[msg.sender]>=sum(_values));
        address receiver;
        uint256 value;
        for(uint256 i = 0; i < _recivers.length ; i++){
            receiver = _recivers[i];
            value = _values[i];
            transfer(receiver,value);
            //自动锁仓
            if(auto_lock==true)
            {
                lockToken(receiver,value);
            }
        }
    }
    
    function send_to_buyer(uint256 usdt_amount,address buyer_address) public onlyOwner 
    {
        require(buy_price>0);
        require(usdt_amount>0);
        require(buyer_lock_rate>=0 && buyer_lock_rate<=10);
        uint256 can_buy_amount=(usdt_amount*buy_price)* 10**uint256(decimals)/10**uint256(usdt_decimal)/10**uint256(price_decimal);
        require(balanceOf[msg.sender]>=can_buy_amount);
        uint256 lock_amount=can_buy_amount*buyer_lock_rate/10;
        if (can_buy_amount>0)
        {
            transfer(buyer_address,can_buy_amount);
        }
        if(lock_amount>0)
        {
            lockToken(buyer_address,lock_amount);
        }
    }
    
      //锁仓
     function lockToken (address target,uint256 lockAmount) onlyOwner public returns(bool res)
    {
        require(target != address(0));
		require(lockAmount > 0); 
        require(balanceOf[target] >= lockAmount);
        uint previousBalances = balanceOf[target]+lockedAmount[target];
        balanceOf[target] = safeSub(balanceOf[target],lockAmount);
        lockedAmount[target] =safeAdd(lockedAmount[target],lockAmount);
        if  (isExsitLocked[target]==false)
        {
            isExsitLocked[target]=true;
            lockedAddress.push(target);
            lockedAddressAmount+=1;
        }
        emit LockToken(target, lockAmount);
        assert(previousBalances==balanceOf[target]+lockedAmount[target]);
        return true;
    }
    
 //解锁
     function ownerUnlock (address target, uint256 amount) onlyOwner public returns(bool res) 
     {
        require(target != address(0));
        require(amount > 0); 
        require(lockedAmount[target] >= amount);
        uint previousBalances = balanceOf[target]+lockedAmount[target];
        balanceOf[target] = safeAdd(balanceOf[target],amount);
        lockedAmount[target] = safeSub(lockedAmount[target],amount);
        emit OwnerUnlock(target,amount);
        assert(previousBalances==balanceOf[target]+lockedAmount[target]);
        return true;
    }

    function unlockAll(address target) onlyOwner public returns(bool res) 
    {
        require(target != address(0));
        ownerUnlock(target,lockedAmount[target]);
        return true;
    }

}