pragma solidity >=0.4.22 <0.7.0;

library SafeMath {
  function mul(uint a, uint b) internal pure returns (uint) {
    if (a == 0) {
      return 0;
    }
    uint c = a * b;
    assert(c / a == b);
    return c;
  }

  function div(uint a, uint b) internal pure returns (uint) {
    uint c = a / b;
    return c;
  }

  function sub(uint a, uint b) internal pure returns (uint) {
    assert(b <= a);
    return a - b;
  }

  function add(uint a, uint b) internal pure returns (uint) {
    uint c = a + b;
    assert(c >= a);
    return c;
  }
}

contract Sunflower {
    
    using SafeMath for uint;

	uint40 constant CHECK_CYCLE = 2592000;
	uint40 constant GAMBLING_POOL_CYCLE = 259200;
	uint40 constant RELEASE_CYCLE = 86400;
	
   
    uint gambling_pool;
	uint40 gambling_pool_time;
	address[100] gambling_pool_address;
	uint8 gambling_pool_address_pos;
	
	struct InvestParam {
        uint8 releaseRate;
        
        uint8 outMultiple;
		}
    
	mapping(uint => InvestParam) investParams;
	
	uint total_deposit;
	
    struct User {
        address upline;
		
        uint referrals;
		
        uint payouts;
		
        uint invite_bonus;
		uint level_bonus;
		
        uint deposit_amount;
		
        uint release_num;
		
        uint40 deposit_time;
		
        uint total_deposits;
		
		uint total_invite_deposits;

		uint8 level;
		
		uint8 check_level;
		
		uint40 check_time;
		
		uint check_invite_deposits;
		
		uint total_payouts;
    }
	
    mapping(address => User) users;
	uint8[] ref_bonuses;
	uint8[] ref_nums;
	uint[] levels_invite_deposits;
	uint[] levels_check_invite_deposits;
	uint8[] levels_bonus;
	mapping(uint8 => address[]) levels_users;
	
	address[3] operate_address = [0xac2b4501284261ff009f22AfcC7F4997bA77ecB2,0xc9a02f9a161a51Fa48039684d6DFC933f4ACE55C,0xbd4FA6AF1e6fE6b211414948346420694fFab8cD];
	uint[3] operate_bonuses;
    
	event Upline(address indexed addr, address indexed upline);
	event InvitePayout(address indexed addr, address indexed from, uint amount);
	event NewDeposit(address indexed addr, uint amount);
	event LevelPayout(address indexed addr, address indexed from, uint amount);
	
	constructor() public {
        ref_bonuses.push(5);
        ref_bonuses.push(3);
        ref_bonuses.push(2);
        ref_bonuses.push(1);
        ref_bonuses.push(1);
        ref_bonuses.push(1);
        ref_bonuses.push(1);
        ref_bonuses.push(1);
        ref_bonuses.push(1);
        ref_bonuses.push(1);
        ref_bonuses.push(1);
        ref_bonuses.push(1);
        ref_bonuses.push(2);
        ref_bonuses.push(3);
        ref_bonuses.push(5);
		
		ref_nums.push(1);
        ref_nums.push(3);
        ref_nums.push(3);
        ref_nums.push(5);
        ref_nums.push(5);
        ref_nums.push(5);
        ref_nums.push(5);
        ref_nums.push(5);
        ref_nums.push(8);
        ref_nums.push(8);
        ref_nums.push(8);
        ref_nums.push(8);
        ref_nums.push(10);
        ref_nums.push(10);
        ref_nums.push(10);
		
		levels_bonus.push(15);
        levels_bonus.push(20);
        levels_bonus.push(25);

        gambling_pool_time = uint40(now);
		
		levels_invite_deposits.push(500 ether);
        levels_invite_deposits.push(5000 ether);
        levels_invite_deposits.push(50000 ether);
		
		levels_check_invite_deposits.push(50 ether);
        levels_check_invite_deposits.push(500 ether);
        levels_check_invite_deposits.push(2000 ether);
		
		investParams[0.5 ether].releaseRate = 5;
		investParams[0.5 ether].outMultiple = 15;
		investParams[1 ether].releaseRate = 6;
		investParams[1 ether].outMultiple = 18;
		investParams[3 ether].releaseRate = 7;
		investParams[3 ether].outMultiple = 20;
		investParams[5 ether].releaseRate = 8;
		investParams[5 ether].outMultiple = 22;
		investParams[10 ether].releaseRate = 9;
		investParams[10 ether].outMultiple = 24;
		investParams[30 ether].releaseRate = 10;
		investParams[30 ether].outMultiple = 26; 
    }
	
	function getGamblingPoolAddress() public constant returns (address[100]){
		return gambling_pool_address;
	}
	
	function getGamblingPoolAddressPos() public constant returns (uint8){
		return gambling_pool_address_pos;
	}
	
	function getLevelsUsers(uint8 index) public constant returns (address[]){
		return levels_users[index];
	}
	
	function getOperateBonuses() public constant returns (uint[3]){
		return operate_bonuses;
	}
	
	function getSFC() public constant returns (uint){
		return users[msg.sender].total_deposits;
	}

	function getUser() public constant returns (address, uint, uint, uint, uint, uint, uint, uint40, uint, uint8, uint8, uint40, uint, uint){
		return (users[msg.sender].upline, users[msg.sender].referrals, users[msg.sender].payouts, 
		users[msg.sender].invite_bonus, users[msg.sender].level_bonus, users[msg.sender].deposit_amount, users[msg.sender].release_num, 
		users[msg.sender].deposit_time, users[msg.sender].total_invite_deposits, 
		users[msg.sender].level, users[msg.sender].check_level, 
		users[msg.sender].check_time, users[msg.sender].check_invite_deposits, users[msg.sender].total_payouts );
	}
	
	function getInfo() public constant returns (uint, uint, uint40){
		return (total_deposit, gambling_pool, gambling_pool_time);
	}
	
    function _setUpline(address _addr, address _upline) private {

		require(users[_upline].deposit_amount > 0);
		users[_addr].upline = _upline;
        users[_upline].referrals++;

		if(users[_upline].referrals >= 10)
		{
			for(uint8 g=(uint8)(levels_invite_deposits.length); g>0; g--)
			{
				if(users[_upline].total_invite_deposits >= levels_invite_deposits[g-1] && users[_upline].level < g)
				{
					levels_users[g].push(_upline);
					if(users[_upline].level > 0)
					{
						for(uint k=0; k<levels_users[users[_upline].level].length; k++)
						{
							if(levels_users[users[_upline].level][k] == _upline && levels_users[users[_upline].level].length>1)
							{
								levels_users[users[_upline].level][k] = levels_users[users[_upline].level][levels_users[users[_upline].level].length - 1];
								break;
							}
						}
						delete levels_users[users[_upline].level][levels_users[users[_upline].level].length - 1];
						levels_users[users[_upline].level].length--;
					}
					users[_upline].level = g;
					users[_upline].check_time = uint40(now);
					users[_upline].check_level = g;
					users[_upline].check_invite_deposits = 0;
					break;
				}
			}
		}	
        emit Upline(_addr, _upline);
    }
	
	function _levels_bonus(address _addr, uint _amount) private {
		uint[3] memory _levels_num;
		for(uint8 m=1; m<=3; m++)
		{
			for(uint8 n=0; n<levels_users[m].length; n++)
			{
				User storage _user1 = users[levels_users[m][n]];
				if(now >= _user1.check_time + CHECK_CYCLE)
				{
					_user1.check_level = 0;
					for(uint8 s= (uint8)(levels_check_invite_deposits.length); s>0; s--)
					{
						if(_user1.check_invite_deposits >= levels_check_invite_deposits[s-1])
						{
							_user1.check_level = s > _user1.level ? _user1.level : s;
							break;
						}
					}
					uint40 _old_time = _user1.check_time;
					_user1.check_time = _user1.check_time + (uint40)(now.sub(_user1.check_time).div(CHECK_CYCLE).mul(CHECK_CYCLE));
					_user1.check_invite_deposits = 0;
					if(_user1.check_time - _old_time > CHECK_CYCLE)
					{
						_user1.check_level = 0;
					}
				}
				
				if(_user1.check_level > 0 && _user1.deposit_time > 0)
				{
					_levels_num[_user1.check_level-1]++;
				}
			}
		}
		uint[3] memory _levels_bonus_num;
		for(m=0; m<3; m++)
		{
			if(_levels_num[m] != 0)
			{
				_levels_bonus_num[m] = _amount.mul(levels_bonus[m]).div(1000).div(_levels_num[m]);
			}
		}
		for(m=1; m<=3; m++)
		{
			for(n=0; n<levels_users[m].length; n++)
			{
				User storage _user2 = users[levels_users[m][n]];
				if(_user2.check_level > 0 && _user2.deposit_time > 0)
				{	
					_user2.level_bonus =_user2.level_bonus.add(_levels_bonus_num[_user2.check_level-1]);
					
					emit LevelPayout(levels_users[m][n], _addr, _levels_bonus_num[_user2.check_level-1]);
				}
			}
		}
	}
	
	function _gambling_pool_bonus(address _addr, uint _amount) private {
		if(now >= gambling_pool_time + GAMBLING_POOL_CYCLE)
		{
			if(gambling_pool > 0)
			{
				uint _total_deposit = 0;
				for(uint16 i=0; i<gambling_pool_address.length; i++)
				{
					if(gambling_pool_address[i] != address(0))
					{
						_total_deposit = _total_deposit.add(users[gambling_pool_address[i]].deposit_amount);
					}
				}
				address _first_address;
				uint _remaining = gambling_pool;
				uint _bonus;
				for(uint16 j=0; j<gambling_pool_address.length; j++)
				{
					if(gambling_pool_address[j] != address(0))
					{
					    if(_first_address == address(0))
						{
							_first_address = gambling_pool_address[j];
							continue;
						}
						_bonus = users[gambling_pool_address[j]].deposit_amount.mul(gambling_pool).div(_total_deposit);
						_remaining = _remaining.sub(_bonus);
						gambling_pool_address[j].transfer(_bonus);
					}
				}
				if(_first_address != address(0))
				{
					_first_address.transfer(_remaining);
				}
			}
			gambling_pool_time = uint40(now);
			gambling_pool = 0;
			gambling_pool_address_pos = 0;
			for(uint16 k=0; k<gambling_pool_address.length; k++)
			{
				gambling_pool_address[k] = address(0);
			}
		}else{
			gambling_pool_time =  uint40((uint(gambling_pool_time)).add(_amount.div(0.1 ether).mul(3600).div(10)));
			if(gambling_pool_time > uint40(now))
			{
				gambling_pool_time = uint40(now);
			}
			
		}
		
		if(gambling_pool < 1000 ether)
		{
			gambling_pool = gambling_pool.add(_amount.div(100));
			gambling_pool = gambling_pool > 1000 ether ? 1000 ether : gambling_pool;
		}
		gambling_pool_address[gambling_pool_address_pos] = _addr;
		gambling_pool_address_pos ++;
		if(gambling_pool_address_pos == gambling_pool_address.length)
		{
			gambling_pool_address_pos = 0;
		}
	}
	
	function _deposit(address _addr, uint _amount) private {
		require(users[_addr].deposit_time == 0);
		require(_amount >= users[_addr].deposit_amount);
		if(total_deposit < 20000 ether)
		{
			require(_amount == 0.5 ether || _amount == 1 ether || _amount == 3 ether || _amount == 5 ether);
		}else
		{
			if(total_deposit < 50000 ether)
			{
				require(_amount == 0.5 ether || _amount == 1 ether || _amount == 3 ether || _amount == 5 ether || (_amount >= 10 ether && _amount <= 29 ether && _amount % 1 ether == 0));
			}else{
				require(_amount == 0.5 ether || _amount == 1 ether || _amount == 3 ether || _amount == 5 ether || (_amount >= 10 ether && _amount <= 49 ether && _amount % 1 ether == 0));
			}
		}
        users[_addr].deposit_amount = _amount;
        users[_addr].deposit_time = uint40(now);
        users[_addr].total_deposits = users[_addr].total_deposits.add(_amount.mul(100).div(1 ether));
		total_deposit = total_deposit.add(_amount);
        emit NewDeposit(_addr, _amount);
		
		operate_bonuses[0] = operate_bonuses[0].add(_amount.div(100));
		operate_bonuses[1] = operate_bonuses[1].add(_amount.div(100));
		operate_bonuses[2] = operate_bonuses[2].add(_amount.div(100));

		address _upline = _addr;
        for(uint8 i=0; i < ref_bonuses.length; i++)
		{
			_upline = users[_upline].upline;
		    
			if(_upline == address(0)) break;
			if(users[_upline].deposit_time > 0 && users[_upline].referrals >= ref_nums[i])
			{
				uint _upline_amount = users[_upline].deposit_amount > _amount? _amount:users[_upline].deposit_amount;
				users[_upline].invite_bonus = users[_upline].invite_bonus.add(_upline_amount.mul(ref_bonuses[i]).div(100));
				emit InvitePayout(_upline, _addr, _upline_amount.mul(ref_bonuses[i]).div(100));
			}

			if(users[_upline].check_time != 0)
			{
				if(uint40(now) < users[_upline].check_time + CHECK_CYCLE)
				{
					if(uint40(now) >= users[_upline].check_time)
					{
						uint8 _current_check_level = 0;
						users[_upline].check_invite_deposits += _amount;
						for(uint8 j= (uint8)(levels_check_invite_deposits.length); j>0; j--)
						{
							if(users[_upline].check_invite_deposits >= levels_check_invite_deposits[j-1])
							{
								_current_check_level = j > users[_upline].level ? users[_upline].level : j;
								break;
							}
						}
						if(_current_check_level > users[_upline].check_level)
						{
							users[_upline].check_time = uint40(now);
							users[_upline].check_level = _current_check_level;
							users[_upline].check_invite_deposits = 0;
						}
						else if(_current_check_level == users[_upline].level)
						{
							users[_upline].check_time = users[_upline].check_time + CHECK_CYCLE;
							users[_upline].check_level = users[_upline].level;
							users[_upline].check_invite_deposits = 0;
						}
					}
				}
				else
				{
					users[_upline].check_level = 0;
					for(uint8 p = (uint8)(levels_check_invite_deposits.length); p > 0; p--)
					{
						if(users[_upline].check_invite_deposits >= levels_check_invite_deposits[p-1])
						{
							users[_upline].check_level = p > users[_upline].level ? users[_upline].level : p;
							break;
						}
					}
					uint40 _old_time = users[_upline].check_time;
					users[_upline].check_time = users[_upline].check_time + (uint40)(now.sub(users[_upline].check_time).div(CHECK_CYCLE).mul(CHECK_CYCLE));
					users[_upline].check_invite_deposits = _amount;
					if(users[_upline].check_time - _old_time > CHECK_CYCLE)
					{
						users[_upline].check_level = 0;
					}
				}
			}

			users[_upline].total_invite_deposits = users[_upline].total_invite_deposits.add(_amount);
				
			if(users[_upline].referrals >= 10)
			{
				for(uint8 g=(uint8)(levels_invite_deposits.length); g>0; g--)
				{
					if(users[_upline].total_invite_deposits >= levels_invite_deposits[g-1] && users[_upline].level < g)
					{
						levels_users[g].push(_upline);
						if(users[_upline].level > 0)
						{
							for(uint k=0; k<levels_users[users[_upline].level].length; k++)
							{
								if(levels_users[users[_upline].level][k] == _upline && levels_users[users[_upline].level].length>1)
								{
									levels_users[users[_upline].level][k] = levels_users[users[_upline].level][levels_users[users[_upline].level].length - 1];
									break;
								}
							}
							delete levels_users[users[_upline].level][levels_users[users[_upline].level].length - 1];
							levels_users[users[_upline].level].length--;
						}
						users[_upline].level = g;
						users[_upline].check_time = uint40(now);
						users[_upline].check_level = g;
						users[_upline].check_invite_deposits = 0;
						break;
					}
				}
			}
		}
		
		_levels_bonus(_addr, _amount);

		_gambling_pool_bonus(_addr, _amount);
    }
	
	function deposit(address _upline) payable public{
		if(_upline != address(0) && users[msg.sender].upline == address(0) && users[msg.sender].deposit_amount == 0)
		{
			_setUpline(msg.sender, _upline);
		}
        
        _deposit(msg.sender, msg.value);
    }
	
	function user_benefit() public{
		require(users[msg.sender].deposit_time > 0);
	    InvestParam memory _investParam;
		if(users[msg.sender].deposit_amount <= 5 ether)
		{
			_investParam = investParams[users[msg.sender].deposit_amount];
		}else if(users[msg.sender].deposit_amount <= 29 ether)
		{
			_investParam = investParams[10 ether];
		}else{
			_investParam = investParams[30 ether];
		}
		uint _maxPayout = users[msg.sender].deposit_amount.mul(_investParam.outMultiple).div(10);
		uint _releaseNum = (now - users[msg.sender].deposit_time).div(RELEASE_CYCLE);
		uint _currentReleaseNum = _releaseNum - users[msg.sender].release_num;
		uint _releasePayout = users[msg.sender].deposit_amount.mul(_investParam.releaseRate).div(1000).mul(_currentReleaseNum);
		uint _currentPayout = _releasePayout.add(users[msg.sender].invite_bonus);
		
		if(_currentPayout > 0)
		{
			if(users[msg.sender].payouts.add(_currentPayout) >= _maxPayout)
			{
				_currentPayout = _maxPayout.sub(users[msg.sender].payouts);
				users[msg.sender].release_num = 0;
				users[msg.sender].payouts = 0;
				users[msg.sender].invite_bonus = 0;
				users[msg.sender].deposit_time = 0;
			}
			else{
				users[msg.sender].release_num = _releaseNum;
				users[msg.sender].payouts = users[msg.sender].payouts.add(_currentPayout);
				users[msg.sender].invite_bonus = 0;
			}
		}
		
		if(users[msg.sender].level_bonus > 0)
		{
			_currentPayout = _currentPayout.add(users[msg.sender].level_bonus);
			users[msg.sender].level_bonus = 0;
		}
		
		
		require(_currentPayout > 0);
		users[msg.sender].total_payouts = users[msg.sender].total_payouts.add(_currentPayout);
		uint _contractSum = address(this).balance.sub(gambling_pool).sub(operate_bonuses[0]).sub(operate_bonuses[1]).sub(operate_bonuses[2]);
		require(_contractSum >= _currentPayout);
		msg.sender.transfer(_currentPayout);
	}
	
	function operate_benefit() public{
		require(msg.sender == operate_address[0] || msg.sender == operate_address[1] || msg.sender == operate_address[2]);
	    uint8 index;
		if(msg.sender == operate_address[0])
		{
			index = 0;
		}else if(msg.sender == operate_address[1])
		{
			index = 1;
		}
		else if(msg.sender == operate_address[2])
		{
			index = 2;
		}else{
			return;
		}
		if(operate_bonuses[index] > 0)
		{
			msg.sender.transfer(operate_bonuses[index]);
			operate_bonuses[index] = 0;
		}
		
	}
	
	function pledge_sfc(uint _amount) public{
		require(total_deposit >= 500000 ether);
		require(_amount % 10000 == 0 && users[msg.sender].total_deposits >= _amount && _amount > 0);
		users[msg.sender].total_deposits = users[msg.sender].total_deposits.sub(_amount);
		uint _contractSum = address(this).balance.sub(gambling_pool).sub(operate_bonuses[0]).sub(operate_bonuses[1]).sub(operate_bonuses[2]);
		require(_contractSum >= _amount.div(10000).mul(1 ether));
		msg.sender.transfer(_amount.div(10000).mul(1 ether));
	}
}