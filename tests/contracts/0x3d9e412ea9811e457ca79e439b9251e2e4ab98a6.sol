pragma solidity ^0.4.17;

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
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
 */
contract Ownable {
    address public owner;

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
    function transferOwnership(address newOwner) public onlyOwner {
        if (newOwner != address(0)) {
            owner = newOwner;
        }
    }

}

/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20Basic {
    uint public totalSupplyNum;

    function totalSupply() public constant returns (uint);

    function balanceOf(address who) public constant returns (uint);

    function transfer(address to, uint value) public;

    event Transfer(address indexed from, address indexed to, uint value);
}

/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 is ERC20Basic {
    function allowance(address owner, address spender) public constant returns (uint);

    function transferFrom(address from, address to, uint value) public;

    function approve(address spender, uint value) public;

    event Approval(address indexed owner, address indexed spender, uint value);
}

/**
 * @title Basic token
 * @dev Basic version of StandardToken, with no allowances.
 */
contract BasicToken is Ownable, ERC20Basic {
    using SafeMath for uint;

    mapping(address => uint) public balances;

    // additional variables for use if transaction fees ever became necessary
    uint public basisPointsRate = 0;
    uint public maximumFee = 0;

    /**
    * @dev Fix for the ERC20 short address attack.
    */
    modifier onlyPayloadSize(uint size) {
        require(!(msg.data.length < size + 4));
        _;
    }

    /**
    * @dev transfer token for a specified address
    * @param _to The address to transfer to.
    * @param _value The amount to be transferred.
    */
    function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) {
        uint fee = (_value.mul(basisPointsRate)).div(10000);
        if (fee > maximumFee) {
            fee = maximumFee;
        }
        uint sendAmount = _value.sub(fee);
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(sendAmount);
        if (fee > 0) {
            balances[owner] = balances[owner].add(fee);
            emit Transfer(msg.sender, owner, fee);
        }
        emit Transfer(msg.sender, _to, sendAmount);
    }

    /**
    * @dev Gets the balance of the specified address.
    * @param _owner The address to query the the balance of.
    * @return An uint representing the amount owned by the passed address.
    */
    function balanceOf(address _owner) public constant returns (uint balance) {
        return balances[_owner];
    }

}

/**
 * @title Standard ERC20 token
 *
 * @dev Implementation of the basic standard token.
 * @dev https://github.com/ethereum/EIPs/issues/20
 * @dev Based oncode by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 */
contract StandardToken is BasicToken, ERC20 {

    mapping(address => mapping(address => uint)) public allowed;

    uint public constant MAX_UINT = 2 ** 256 - 1;

    /**
    * @dev Transfer tokens from one address to another
    * @param _from address The address which you want to send tokens from
    * @param _to address The address which you want to transfer to
    * @param _value uint the amount of tokens to be transferred
    */
    function transferFrom(address _from, address _to, uint _value) public onlyPayloadSize(3 * 32) {
        uint _allowance = allowed[_from][msg.sender];

        // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
        // if (_value > _allowance) throw;

        uint fee = (_value.mul(basisPointsRate)).div(10000);
        if (fee > maximumFee) {
            fee = maximumFee;
        }
        if (_allowance < MAX_UINT) {
            allowed[_from][msg.sender] = _allowance.sub(_value);
        }
        uint sendAmount = _value.sub(fee);
        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(sendAmount);
        if (fee > 0) {
            balances[owner] = balances[owner].add(fee);
            emit Transfer(_from, owner, fee);
        }
        emit Transfer(_from, _to, sendAmount);
    }

    /**
    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
    * @param _spender The address which will spend the funds.
    * @param _value The amount of tokens to be spent.
    */
    function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {

        // To change the approve amount you first have to reduce the addresses`
        //  allowance to zero by calling `approve(_spender, 0)` if it is not
        //  already 0 to mitigate the race condition described here:
        //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
        require(!((_value != 0) && (allowed[msg.sender][_spender] != 0)));

        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
    }

    /**
    * @dev Function to check the amount of tokens than an owner allowed to a spender.
    * @param _owner address The address which owns the funds.
    * @param _spender address The address which will spend the funds.
    * @return A uint specifying the amount of tokens still available for the spender.
    */
    function allowance(address _owner, address _spender) public constant returns (uint remaining) {
        return allowed[_owner][_spender];
    }

}

contract BlackList is Ownable, BasicToken {

    /////// Getters to allow the same blacklist to be used also by other contracts (including upgraded Tether) ///////
    function getBlackListStatus(address _maker) external constant returns (bool) {
        return isBlackListed[_maker];
    }

    function getOwner() external constant returns (address) {
        return owner;
    }

    mapping(address => bool) public isBlackListed;

    function addBlackList(address _evilUser) public onlyOwner {
        isBlackListed[_evilUser] = true;
        emit AddedBlackList(_evilUser);
    }

    function removeBlackList(address _clearedUser) public onlyOwner {
        isBlackListed[_clearedUser] = false;
        emit RemovedBlackList(_clearedUser);
    }

    function destroyBlackFunds(address _blackListedUser) public onlyOwner {
        require(isBlackListed[_blackListedUser]);
        uint dirtyFunds = balanceOf(_blackListedUser);
        balances[_blackListedUser] = 0;
        totalSupplyNum -= dirtyFunds;
        emit DestroyedBlackFunds(_blackListedUser, dirtyFunds);
    }

    event DestroyedBlackFunds(address _blackListedUser, uint _balance);

    event AddedBlackList(address _user);

    event RemovedBlackList(address _user);

}

/// @dev Models a uint -> uint mapping where it is possible to iterate over all keys.
contract IterableMapping
{
    struct itmap
    {
        mapping(address => Account) data;
        KeyFlag[] keys;
        uint size;
    }

    struct Account {
        uint keyIndex;
        address parentAddress;
        bool active;
    }

    struct KeyFlag {address key; bool deleted;}

    function insert(itmap storage self, address key, address parentAddress, bool active) internal returns (bool replaced)
    {
        uint keyIndex = self.data[key].keyIndex;
        self.data[key].parentAddress = parentAddress;
        self.data[key].active = active;

        if (keyIndex > 0)
            return true;
        else
        {
            keyIndex = self.keys.length++;
            self.data[key].keyIndex = keyIndex + 1;
            self.keys[keyIndex].key = key;
            self.size++;
            return false;
        }
    }

    function remove(itmap storage self, address key) internal returns (bool success)
    {
        uint keyIndex = self.data[key].keyIndex;
        if (keyIndex == 0)
            return false;
        delete self.data[key];
        self.keys[keyIndex - 1].deleted = true;
        self.size --;
        return true;
    }

    function contains(itmap storage self, address key) internal view returns (bool)
    {
        return self.data[key].keyIndex > 0;
    }

    function index(itmap storage self, address key) internal view returns (uint) {
        return self.data[key].keyIndex;
    }

    function iterate_start(itmap storage self) internal view returns (uint keyIndex)
    {
        return iterate_next(self, uint(- 1));
    }

    function iterate_valid(itmap storage self, uint keyIndex) internal view returns (bool)
    {
        return keyIndex < self.keys.length;
    }

    function iterate_next(itmap storage self, uint keyIndex) internal view returns (uint r_keyIndex)
    {
        keyIndex++;
        while (keyIndex < self.keys.length && self.keys[keyIndex].deleted)
            keyIndex++;
        return keyIndex;
    }

    function iterate_get(itmap storage self, uint keyIndex) internal view returns (address accountAddress, address parentAddress, bool active)
    {
        accountAddress = self.keys[keyIndex].key;
        parentAddress = self.data[accountAddress].parentAddress;
        active = self.data[accountAddress].active;
    }
}


contract CtgToken is StandardToken, BlackList, IterableMapping {
    string public name;
    string public symbol;
    uint public decimals;

    address public pool = 0x9492D2F14d6d4D562a9DA4793b347f2AaB3B607A; //矿池地址
    address public teamAddress = 0x45D1c050C458de9b18104bdFb7ddEbA510f6D9f2; //研发团队地址
    address public peer = 0x87dfEFFa31950584d6211D6A7871c3AdA2157aE1; //节点分红
    address public foundation0 = 0x6eDFEaB0D0B6BD3d6848A3556B2753f53b182cCd;
    address public foundation1 = 0x5CD65995e25EC1D73EcDBc61D4cF32238304D1eA;
    address public foundation2 = 0x7D1E3dD3c5459BAdA93C442442D4072116e21034;
    address public foundation3 = 0x5001c2917B18B18853032C3e944Fe512532E0FD1;
    address public foundation4 = 0x9c131257919aE78B746222661076CF781a8FF7c6;
    address public candy = 0x279C18756568B8717e915FfB8eFe2784abCb89cf;
    address public contractAddress = 0x81E98EfF052837f7c1Dceb8947d08a2b908E8793;
    uint public recommendNum;

    itmap accounts;

    mapping(uint => uint) public shareRate;
    mapping(address => uint8) public levels;
    mapping(uint => uint) public levelProfit;

    struct StaticProfit {
        uint num;
        uint8 day;
        uint8 rate;
    }

    mapping(uint => StaticProfit) public profits;
    mapping(address => AddressInfo) public addressInfos;

    struct AddressInfo {
        address[] children;
        address _address;
        uint[] profitsIndex;
        bool activated;
    }

    struct ProfitLog {
        address _address;
        uint levelNum;
        uint num;
        uint8 day;
        uint8 rate;
        uint8 getDay;
        uint updatedAt;
    }

    mapping(uint => ProfitLog) public profitLogs;
    uint logIndex = 0;

    constructor(string _name, string _symbol, uint _decimals) public {
        totalSupplyNum = formatDecimals(720000000);
        name = _name;
        symbol = _symbol;
        decimals = _decimals;

        balances[pool] = formatDecimals(540000000);
        balances[teamAddress] = formatDecimals(64800000);
        balances[peer] = formatDecimals(43200000);
        balances[foundation0] = formatDecimals(10080000);
        balances[foundation1] = formatDecimals(10080000);
        balances[foundation2] = formatDecimals(10080000);
        balances[foundation3] = formatDecimals(10080000);
        balances[foundation4] = formatDecimals(10080000);
        balances[candy] = formatDecimals(21600000);

        //推广收益比例
        shareRate[1] = 7;
        shareRate[2] = 5;
        shareRate[3] = 3;
        shareRate[4] = 2;
        shareRate[5] = 1;
        shareRate[6] = 1;
        shareRate[7] = 1;
        shareRate[8] = 1;
        shareRate[9] = 1;
        shareRate[10] = 1;

        //等级奖励
        levelProfit[1] = formatDecimals(1000);
        levelProfit[2] = formatDecimals(3000);
        levelProfit[3] = formatDecimals(10000);
        levelProfit[4] = formatDecimals(50000);
        levelProfit[5] = formatDecimals(100000);

        //合约收益配置
        profits[formatDecimals(100)] = StaticProfit(formatDecimals(100), 30, 10);
        profits[formatDecimals(1000)] = StaticProfit(formatDecimals(1000), 30, 15);
        profits[formatDecimals(5000)] = StaticProfit(formatDecimals(5000), 30, 20);
        profits[formatDecimals(10000)] = StaticProfit(formatDecimals(10000), 30, 25);
        profits[formatDecimals(30000)] = StaticProfit(formatDecimals(30000), 30, 30);

        recommendNum = formatDecimals(23).div(10);
    }

    function setLevelProfit(uint level, uint num) public onlyOwner {
        require(levelProfit[level] > 0, "The level config doesn't exist!");
        levelProfit[level] = formatDecimals(num);
    }

    function setRecommendNum(uint num) public onlyOwner {
        require(recommendNum != num, "The value is equal old value!");
        recommendNum = num;
    }


    function setShareRateConfig(uint level, uint rate) public onlyOwner {
        require(shareRate[level] > 0, "This level does not exist");

        uint oldRate = shareRate[level];
        shareRate[level] = rate;

        emit SetShareRateConfig(level, oldRate, rate);
    }

    function getProfitLevelNum(uint num) internal constant returns(uint) {
        if (num < formatDecimals(100)) {
            return 0;
        }
        if (num >=formatDecimals(100) && num < formatDecimals(1000)) {
            return formatDecimals(100);
        }
        if (num >=formatDecimals(1000) && num < formatDecimals(5000)) {
            return formatDecimals(1000);
        }
        if (num >=formatDecimals(5000) && num < formatDecimals(10000)) {
            return formatDecimals(5000);
        }
        if (num >=formatDecimals(10000) && num < formatDecimals(30000)) {
            return formatDecimals(10000);
        }
        if (num >=formatDecimals(30000)) {
            return formatDecimals(30000);
        }
    }

    function getAddressProfitLevel(address _address) public constant returns (uint) {
        uint maxLevel = 0;
        uint[] memory indexes = addressInfos[_address].profitsIndex;
        for (uint i=0; i<indexes.length; i++) {
            uint k = indexes[i];
            if (profitLogs[k].day > 0 && (profitLogs[k].day > profitLogs[k].getDay) && (profitLogs[k].levelNum > maxLevel)) {
                maxLevel = profitLogs[k].levelNum;
            }
        }
        return maxLevel;
    }

    function getAddressProfitNum(address _address) public constant returns (uint) {
        uint num = 0;
        uint[] memory indexes = addressInfos[_address].profitsIndex;
        for (uint i=0; i<indexes.length; i++) {
            uint k = indexes[i];
            if (profitLogs[k].day > 0 && (profitLogs[k].day > profitLogs[k].getDay)) {
                num += profitLogs[k].num;
            }
        }

        return num;
    }

    function getAddressActiveChildrenCount(address _address) public constant returns (uint) {
        uint num  = 0;
        for(uint i=0; i<addressInfos[_address].children.length; i++) {
            address child = addressInfos[_address].children[i];
            AddressInfo memory childInfo = addressInfos[child];
            if (childInfo.activated) {
                num++;
            }
        }

        return num;
    }


    function setProfitConfig(uint256 num, uint8 day, uint8 rate) public onlyOwner {
        require(profits[formatDecimals(num)].num>0, "This profit config not exist");
        profits[formatDecimals(num)] = StaticProfit(formatDecimals(num), day, rate);

        emit SetProfitConfig(num, day, rate);
    }

    function formatDecimals(uint256 _value) internal view returns (uint256) {
        return _value * 10 ** decimals;
    }

    function parent(address _address) public view returns (address) {
        return accounts.data[_address].parentAddress;
    }

    function checkIsCycle(address _child, address _parent) internal view returns (bool) {
        address t = _parent;
        while (t != address(0)) {
            if (t == _child) {
                return true;
            }
            t = parent(t);
        }
        return false;
    }

    function iterate_start() public view returns (uint keyIndex) {
        return super.iterate_start(accounts);
    }

    function iterate_next(uint keyIndex) public view returns (uint r_keyIndex)
    {
        return super.iterate_next(accounts, keyIndex);
    }

    function iterate_valid(uint keyIndex) public view returns (bool) {
        return super.iterate_valid(accounts, keyIndex);
    }

    function iterate_get(uint keyIndex) public view returns (address accountAddress, address parentAddress, bool active) {
        (accountAddress, parentAddress, active) = super.iterate_get(accounts, keyIndex);
    }

    function sendBuyShare(address _address, uint _value) internal  {
        address p = parent(_address);
        uint level = 1;

        while (p != address(0) && level <= 10) {
            uint activeChildrenNum = getAddressActiveChildrenCount(p);
            if (activeChildrenNum < level) {
                p = parent(p);
                level = level + 1;
                continue;
            }

            AddressInfo storage info = addressInfos[p];
            if (!info.activated) {
                p = parent(p);
                level = level + 1;
                continue;
            }

            uint profitLevel = getAddressProfitLevel(p);


            uint addValue = _value.mul(shareRate[level]).div(100);
            if (_value > profitLevel) {
                addValue = profitLevel.mul(shareRate[level]).div(100);
            }


            transferFromPool(p, addValue);
            emit BuyShare(msg.sender, p, addValue);
            p = parent(p);
            level = level + 1;
        }
    }

    function releaseProfit(uint index) public onlyOwner {
        ProfitLog memory log = profitLogs[index];
        if (log.day == 0 || log.day == log.getDay) {
            return;
        }
        uint addValue = log.num.mul(uint(log.rate).add(100)).div(100).div(uint(log.day));

        uint diffDay = 1;
        if (log.updatedAt > 0) {
            diffDay = now.sub(log.updatedAt).div(24*3600);
        }
        if (diffDay > 0) {
            addValue = addValue.mul(diffDay);
            transferFrom(pool, log._address, addValue);
            profitLogs[index].getDay = log.getDay + uint8(diffDay);
            profitLogs[index].updatedAt = now;

            emit ReleaseProfit(log._address, addValue, log.getDay+1);
        }

    }

    function releaseAllProfit() public onlyOwner {
        for (uint i = 0; i<logIndex; i++) {
            releaseProfit(i);
        }
    }


    function setLevel(address _address, uint8 level, bool sendProfit) public onlyOwner {
        levels[_address] = level;

        emit SetLevel(_address, level);
        if (sendProfit) {
            uint num = levelProfit[uint(level)];
            if (num > 0) {
                transferFromPool(_address, num);
                emit SendLevelProfit(_address, level, num);
            }
        }
    }

    function transfer(address _to, uint _value) public {
        address parentAddress = parent(msg.sender);
        if (_value == recommendNum && parentAddress == address(0) && !checkIsCycle(msg.sender, _to)) {
            IterableMapping.insert(accounts, msg.sender, _to, addressInfos[msg.sender].activated);
            AddressInfo storage info = addressInfos[_to];
            info.children.push(msg.sender);
            super.transfer(_to, _value);
            emit SetParent(msg.sender, _to);
        } else if (_to == contractAddress) {
            super.transfer(_to, _value);
            // Static income
            uint profitKey = getProfitLevelNum(_value);
            StaticProfit storage profit = profits[profitKey];
            if (profit.num > 0) {
                profitLogs[logIndex] = ProfitLog({_address:msg.sender, levelNum:profit.num, num : _value, day : profit.day, rate : profit.rate, getDay : 0, updatedAt: 0});
            }
            //activate user
            addressInfos[msg.sender].profitsIndex.push(logIndex);
            logIndex++;
            if (profitKey >= 1000) {
                addressInfos[msg.sender].activated = true;
                IterableMapping.insert(accounts, msg.sender, parentAddress, true);
            }
            //Dynamic  income
            if (profitKey > 0 && addressInfos[msg.sender].activated) {
                sendBuyShare(msg.sender, profitKey);
            }

        } else {
            super.transfer(_to, _value);
        }
    }

    function transferFromPool(address _to, uint _value) internal {
        balances[pool] = balances[pool].sub(_value);
        balances[_to] = balances[_to].add(_value);
        emit Transfer(pool, _to, _value);
    }



    function transferFrom(address _from, address _to, uint _value) public onlyOwner  {
        require(!isBlackListed[_from]);

        //        var _allowance = allowed[_from][msg.sender];

        // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
        // if (_value > _allowance) throw;

        uint fee = (_value.mul(basisPointsRate)).div(10000);
        if (fee > maximumFee) {
            fee = maximumFee;
        }
        //        if (_allowance < MAX_UINT) {
        //            allowed[_from][msg.sender] = _allowance.sub(_value);
        //        }
        uint sendAmount = _value.sub(fee);
        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(sendAmount);
        if (fee > 0) {
            balances[owner] = balances[owner].add(fee);
            emit Transfer(_from, owner, fee);
        }
        emit Transfer(_from, _to, sendAmount);
    }

    // Forward ERC20 methods to upgraded contract if this one is deprecated
    function balanceOf(address who) public constant returns (uint) {
        return super.balanceOf(who);
    }

    // Forward ERC20 methods to upgraded contract if this one is deprecated
    function approve(address _spender, uint _value) public onlyPayloadSize(2 * 32) {
        return super.approve(_spender, _value);
    }

    // Forward ERC20 methods to upgraded contract if this one is deprecated
    function allowance(address _owner, address _spender) public constant returns (uint remaining) {
        return super.allowance(_owner, _spender);
    }

    // deprecate current contract if favour of a new one
    function totalSupply() public constant returns (uint) {
        return totalSupplyNum;
    }


    event SetShareRateConfig(uint level, uint oldRate, uint newRate);
    event SetProfitConfig(uint num, uint8 day, uint8 rate);
    event SetParent(address _childAddress, address _parentAddress);
    event SetLevel(address _address, uint8 level);
    event SendLevelProfit(address _address, uint8 level,uint num);
    event ReleaseProfit(address _address, uint num, uint8 day);
    event BuyShare(address from, address to, uint num);

}