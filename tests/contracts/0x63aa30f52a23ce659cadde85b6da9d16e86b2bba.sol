/**
 *    ___         _                _        _      
 *   / __\_ _ ___| |_  /\/\   __ _| |_ _ __(_)_  __
 *  / _\/ _` / __| __|/    \ / _` | __| '__| \ \/ /
 * / / | (_| \__ \ |_/ /\/\ \ (_| | |_| |  | |>  < 
 * \/   \__,_|___/\__\/    \/\__,_|\__|_|  |_/_/\_\
 *
**/


pragma solidity ^0.5.11;

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}

contract SafeMath {
    function safeAdd(uint a, uint b) public pure returns(uint c) {
        c = a + b;
        require(c >= a);
    }
    function safeSub(uint a, uint b) public pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }
    function safeMul(uint a, uint b) public pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
    function safeDiv(uint a, uint b) public pure returns (uint c) {
        require(b > 0);
        c = a / b;
    }
}


contract FastMatrix is SafeMath {
    uint public currentUserID;

    mapping (uint => User) public users;
    mapping (address => uint) public userWallets;
    uint[4] public levelBase;
    uint[9] public regBase;
    address public token_contract;

    struct User {
        bool exists;
        address wallet;
        uint referrer;
        mapping (uint => uint) uplines;
        mapping (uint => uint[]) referrals;
        mapping (uint => uint) levelExpiry;
    }

    event RegisterUserEvent(address indexed user, address indexed referrer, uint time);
    event BuyLevelEvent(address indexed user, uint indexed level, uint time);
    event TransferEvent(address indexed recipient, address indexed sender, uint indexed amount, uint time, uint recipientID, uint senderID, bool superprofit);
    event LostProfitEvent(address indexed recipient, address indexed sender, uint indexed amount, uint time, uint senderID);
    event CommissionEvent(address indexed recipient, address indexed sender, uint indexed amount, address referral, uint time, uint recipientID, uint senderID, uint referralID);

    constructor(address _owner, address _token, address[2] memory techAccounts) public {

      currentUserID++;
      levelBase = [0.1 ether, 0.14 ether, 0.3 ether, 1 ether];
      regBase = [0.11 ether, 1.01 ether, 7.02 ether, 13.03 ether, 19.04 ether, 25.05 ether, 31.06 ether, 37.07 ether, 43.08 ether];

      users[currentUserID] =  User({ exists: true, wallet: _owner, referrer: 1});
      userWallets[_owner] = currentUserID;
      emit RegisterUserEvent(_owner, _owner, now);
      
      token_contract = _token;

      for (uint i = 0; i < 36; i++) {
        users[currentUserID].levelExpiry[i] = 1 << 37;
      }
      
      for (uint i = 1; i < 8; i++) {
          users[currentUserID].uplines[i] = 1;
          users[currentUserID].referrals[i] = new uint[](0);
      }
      
      for(uint i = 0; i < techAccounts.length; i++){
          currentUserID++;
          users[currentUserID] =  User({ exists: true, wallet: techAccounts[i], referrer: 1});
          userWallets[techAccounts[i]] = currentUserID;
          emit RegisterUserEvent(techAccounts[i], _owner, now);
          
          for(uint levelID = 0; levelID < 36; levelID++){
             users[currentUserID].levelExpiry[levelID] = 1 << 37;
          }
          
        for (uint j = 1; j < 8; j++) {
        users[currentUserID].uplines[j] = 1;
        users[currentUserID].referrals[j] = new uint[](0);
        users[1].referrals[j].push(currentUserID);
        }
          
      }
      
    }

    function () external payable {
        if (userWallets[msg.sender] == 0) {
            require(msg.value == 0.11 ether, 'Wrong amount');
            registerUser(userWallets[bytesToAddress(msg.data)]);
        } else {
            buyLevel(0);
        }
    }

    function registerUser(uint _referrer) public payable {
        require(_referrer > 0 && _referrer <= currentUserID, 'Invalid referrer ID');
        require(msg.value == regBase[0], 'Wrong amount');
        require(userWallets[msg.sender] == 0, 'User already registered');

        currentUserID++;
        users[currentUserID] = User({ exists: true, wallet: msg.sender, referrer: _referrer });
        userWallets[msg.sender] = currentUserID;

        levelUp(0, 1, 1, currentUserID, _referrer);
        
        emit RegisterUserEvent(msg.sender, users[_referrer].wallet, now);
    }

    function buyLevel(uint _upline) public payable {
        uint userID = userWallets[msg.sender];
        require (userID > 0, 'User not registered');
        
        require(users[userID].referrals[1].length >= 2, 'At least two referrals needed');
        
        (uint round, uint level, uint levelID) = getLevel(msg.value);
        
        if (level == 1 && round > 1) {
            bool prev = false;
            for (uint l = levelID - 2; l < levelID; l++) {
                if (users[userID].levelExpiry[l] >= now) {
                    prev = true;
                    break;
                }
                require(prev == true, 'Previous round not active');
            }
        } else {
            for (uint l = level - 1; l > 0; l--) {
                require(users[userID].levelExpiry[levelID - level + l] >= now, 'Previous level not active');
            }
        }

        levelUp(levelID, level, round, userID, _upline);

        if (level == 4 && round < 9 && users[userID].levelExpiry[levelID + 2] <= now) levelUp(levelID + 1, 1, round + 1, userID, _upline);

        if (address(this).balance > 0) msg.sender.transfer(address(this).balance);
    }
    
    function levelUp(uint _levelid, uint _level, uint _round, uint _userid, uint _upline) internal {

        uint duration = 30 days * _round + 60 days;
        IERC20 token = IERC20(token_contract);
        uint fmxt = token.balanceOf(msg.sender);

        if (users[_userid].levelExpiry[_levelid] == 0 || (users[_userid].levelExpiry[_levelid] < now && fmxt >= _round)) {
            users[_userid].levelExpiry[_levelid] = now + duration;
        } else {
            users[_userid].levelExpiry[_levelid] += duration;
        }
        
        if (_level == 1 && users[_userid].uplines[_round] == 0) {
            if (_upline == 0) _upline = users[_userid].referrer;
            if (_round > 1) _upline = findUplineUp(_upline, _round);
            _upline = findUplineDown(_upline, _round);
            users[_userid].uplines[_round] = _upline;
            users[_upline].referrals[_round].push(_userid);
        }

        payForLevel(_levelid, _userid, _level, _round, false);
        emit BuyLevelEvent(msg.sender, _levelid, now);
    }

    function payForLevel(uint _levelid, uint _userid, uint _height, uint _round, bool _superprofit) internal {
        
      uint refer = users[_userid].referrer;
      uint referrer = getUserUpline(_userid, _height, _round);
      uint amount = lvlAmount(_levelid);

      if (users[referrer].levelExpiry[_levelid] < now) {
          if(users[referrer].levelExpiry[_levelid - 1] < now){
            emit LostProfitEvent(users[referrer].wallet, msg.sender, amount, now, userWallets[msg.sender]);
            payForLevel(_levelid, referrer, _height, _round, true);
          } else {
            levelUp(_levelid, _height, _round, referrer, 0);
          }
        return;
      }

        if(_levelid == 0 && refer != referrer){
            uint comission = safeDiv(amount, 10);
            
            emit CommissionEvent(users[refer].wallet, users[referrer].wallet, comission, msg.sender, now, refer, referrer, userWallets[msg.sender]);
            
              if (address(uint160(users[refer].wallet)).send(safeDiv(amount, 10))) {
                emit TransferEvent(users[refer].wallet, msg.sender, comission, now, refer, userWallets[msg.sender], _superprofit);
              }
              if (address(uint160(users[referrer].wallet)).send(safeMul(safeDiv(amount, 100), 90))) {
                emit TransferEvent(users[referrer].wallet, msg.sender, (amount - comission), now, referrer, userWallets[msg.sender], _superprofit);
              }
        } else {
            
              
              if (address(uint160(users[referrer].wallet)).send(amount)) {
                emit TransferEvent(users[referrer].wallet, msg.sender, amount, now, referrer, userWallets[msg.sender], _superprofit);
              }
        }
    }

    function getUserUpline(uint _user, uint _height, uint _round) public view returns (uint) {
        while (_height > 0) {
            _user = users[_user].uplines[_round];
            _height--;
        }
        return _user;
    }

    function findUplineUp(uint _user, uint _round) public view returns (uint) {
        while (users[_user].uplines[_round] == 0) {
            _user = users[_user].uplines[1];
        }
        return _user;
    }

    function findUplineDown(uint _user, uint _round) public view returns (uint) {
      if (users[_user].referrals[_round].length < 2) {
        return _user;
      }

      uint[1024] memory referrals;
      referrals[0] = users[_user].referrals[_round][0];
      referrals[1] = users[_user].referrals[_round][1];

      uint referrer;

      for (uint i = 0; i < 1024; i++) {
        if (users[referrals[i]].referrals[_round].length < 2) {
          referrer = referrals[i];
          break;
        }

        if (i >= 512) {
          continue;
        }

        referrals[(i+1)*2] = users[referrals[i]].referrals[_round][0];
        referrals[(i+1)*2+1] = users[referrals[i]].referrals[_round][1];
      }

      require(referrer != 0, 'Referrer not found');
      return referrer;
    }


    function getLevel(uint _amount) public view returns(uint, uint, uint) {
        if(_amount == 0.15 ether) // 1
            return (1, 2, 1);
        if(_amount == 1 ether) // 2
            return (2, 2, 5);
        if(_amount == 1.85 ether) // 3
            return (3, 2, 9);
        if(_amount == 2.7 ether) // 4
            return (4, 2, 13);
        if(_amount == 4.4 ether) // 6
            return (6, 2, 21);
        if(_amount == 5.25 ether) // 7
            return (7, 2, 25);
        if(_amount == 6.1 ether) // 8
            return (8, 2, 29);
        if(_amount == 6.95 ether) // 9
            return (9, 2, 33);
        
        uint level = 0;
        uint tmp = _amount % 0.1 ether;
        uint round = tmp / 0.01 ether;
        require(round != 0, 'Wrong amount');

        tmp = (_amount - (0.01 ether * round)) / (6 * (round - 1) + 1);

        for (uint i = 1; i <= 4; i++) {
            if (tmp == levelBase[i - 1]) {
                    level = i;
                    break;
            }
        }
        require(level > 0, 'Wrong amount');

        uint levelID = (round - 1) * 4 + level - 1;
        
        return (round, level, levelID);
    }

    function lvlAmount (uint _levelID) public view returns(uint) {
        uint level = _levelID % 4;
        uint round = (_levelID - level) / 4;
        uint tmp = levelBase[level] * (6 * round + 1);
        uint price = (tmp  + (0.01 ether * (round + 1)));
         if(level == 3 && round < 8) return (price - (levelBase[0] * (6 * (round + 1 ) + 1 ) ) - (0.01 ether * ( round + 2)));
        return price;
    }

    function getReferralTree(uint _user, uint _treeLevel, uint _round) external view returns (uint[] memory, uint[] memory, uint) {

        uint tmp = 2 ** (_treeLevel + 1) - 2;
        uint[] memory ids = new uint[](tmp);
        uint[] memory lvl = new uint[](tmp);

        ids[0] = (users[_user].referrals[_round].length > 0)? users[_user].referrals[_round][0]: 0;
        ids[1] = (users[_user].referrals[_round].length > 1)? users[_user].referrals[_round][1]: 0;
        lvl[0] = getMaxLevel(ids[0], _round);
        lvl[1] = getMaxLevel(ids[1], _round);

        for (uint i = 0; i < (2 ** _treeLevel - 2); i++) {
            tmp = i * 2 + 2;
            ids[tmp] = (users[ids[i]].referrals[_round].length > 0)? users[ids[i]].referrals[_round][0]: 0;
            ids[tmp + 1] = (users[ids[i]].referrals[_round].length > 1)? users[ids[i]].referrals[_round][1]: 0;
            lvl[tmp] = getMaxLevel(ids[tmp], _round);
            lvl[tmp + 1] = getMaxLevel(ids[tmp + 1], _round);
        }
        
        uint curMax = getMaxLevel(_user, _round);

        return(ids, lvl, curMax);
    }

    function getMaxLevel(uint _user, uint _round) private view returns (uint){
        uint max = 0;
        if (_user == 0) return 0;
        if (!users[_user].exists) return 0;
        for (uint i = 1; i <= 4; i++) {
            if (users[_user].levelExpiry[_round * 4 - i] > now) {
                max = 5 - i;
                break;
            }
        }
        return max;
    }
    
    function getUplines(uint _user, uint _round) public view returns (uint[4] memory uplines, address[4] memory uplinesWallets) {
        for(uint i = 0; i < 4; i++) {
            _user = users[_user].uplines[_round];
            uplines[i] = _user;
            uplinesWallets[i] = users[_user].wallet;
        }
    }

    function getUserLevels(uint _user) external view returns (uint[36] memory levels) {
        for (uint i = 0; i < 36; i++) {
            levels[i] = users[_user].levelExpiry[i];
        }
    }

    function bytesToAddress(bytes memory _addr) private pure returns (address addr) {
        assembly {
            addr := mload(add(_addr, 20))
        }
    }
}