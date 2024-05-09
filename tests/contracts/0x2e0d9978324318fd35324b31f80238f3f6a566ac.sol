/**
 *         __  .__                                          .__       ___.    
 *   _____/  |_|  |__   ___________  ____   ____       ____ |  |  __ _\_ |__  
 * _/ __ \   __\  |  \_/ __ \_  __ \/  _ \ /    \    _/ ___\|  | |  |  \ __ \ 
 * \  ___/|  | |   Y  \  ___/|  | \(  <_> )   |  \   \  \___|  |_|  |  / \_\ \
 *  \___  >__| |___|  /\___  >__|   \____/|___|  / /\ \___  >____/____/|___  /
 *      \/          \/     \/                  \/  \/     \/               \/ 
 *
 * https://etheron.club
**/


pragma solidity ^0.5.11;

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}

contract Etheron {
    uint public currentUserID;

    mapping (uint => User) public users;
    mapping (address => uint) public userWallets;
    uint[10] public levelBase;
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

    constructor(address _owner, address _token) public {

      currentUserID++;
      levelBase = [0.5 ether, 1 ether, 2 ether, 4 ether, 5 ether, 6 ether, 7 ether, 8 ether, 9 ether, 10 ether];
      regBase = [0.6 ether, 1.8 ether, 4.1 ether, 8.5 ether, 17 ether, 33.6 ether, 66.3 ether, 131.1 ether, 260 ether];

      users[currentUserID] =  User({ exists: true, wallet: _owner, referrer: 1});
      userWallets[_owner] = currentUserID;
      token_contract = _token;

      for (uint i = 0; i < 90; i++) {
        users[currentUserID].levelExpiry[i] = 1 << 37;
      }
      
      for (uint i = 1; i < 10; i++) {
          users[currentUserID].uplines[i] = 1;
          users[currentUserID].referrals[i] = new uint[](0);
      }
    }

    function () external payable {
        if (userWallets[msg.sender] == 0) {
            require(msg.value == 0.6 ether, 'Wrong amount');
            uint[9] memory tmp;
            registerUser(userWallets[bytesToAddress(msg.data)], 0, tmp);
        } else {
            buyLevel(0);
        }
    }

    function registerUser(uint _referrer, uint _rounds, uint[9] memory _uplines) public payable {
        require(_referrer > 0 && _referrer <= currentUserID, 'Invalid referrer ID');
        require(_rounds < 9);
        require(msg.value == regBase[_rounds], 'Wrong amount');
        require(userWallets[msg.sender] == 0, 'User already registered');

        currentUserID++;
        users[currentUserID] = User({ exists: true, wallet: msg.sender, referrer: _referrer });
        userWallets[msg.sender] = currentUserID;

        for (uint i = 0 ; i <= _rounds; i++ ) {
            levelUp(i * 10, 1, i + 1, currentUserID, _uplines[i]);
        } 
        emit RegisterUserEvent(msg.sender, users[_referrer].wallet, now);
    }

    function buyLevel(uint _upline) public payable {
        uint userID = userWallets[msg.sender];
        require (userID > 0, 'User not registered');
        (uint round, uint level, uint levelID) = getLevel(msg.value);
        
        if (level == 1 && round > 1) {
            bool prev = false;
            for (uint l = levelID - 10; l < levelID; l++) {
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

        if (level == 4 && round < 9 && users[userID].levelExpiry[levelID + 7] <= now) levelUp(levelID + 7, 1, round + 1, userID, _upline);

        if (address(this).balance > 0) msg.sender.transfer(address(this).balance);
    }
    
    function levelUp(uint _levelid, uint _level, uint _round, uint _userid, uint _upline) internal {

        uint duration = 30 days * _round + 90 days;
        IERC20 token = IERC20(token_contract);
        uint eron = token.balanceOf(msg.sender);

        if (users[_userid].levelExpiry[_levelid] == 0 || (users[_userid].levelExpiry[_levelid] < now && eron >= _round)) {
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
      uint referrer = getUserUpline(_userid, _height, _round);
      uint amount = lvlAmount(_levelid);

      if (users[referrer].levelExpiry[_levelid] < now) {
        emit LostProfitEvent(users[referrer].wallet, msg.sender, amount, now, userWallets[msg.sender]);
        payForLevel(_levelid, referrer, _height, _round, true);
        return;
      }

      if (address(uint160(users[referrer].wallet)).send(amount)) {
        emit TransferEvent(users[referrer].wallet, msg.sender, amount, now, referrer, userWallets[msg.sender], _superprofit);
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

        if (_amount == 0.6 ether) return (1, 1, 0);
        uint level = 0;
        uint tmp = _amount % 1 ether;
        uint round = tmp / 0.1 ether;
        require(round != 0, 'Wrong amount');

        tmp = (_amount - tmp) / (2 ** (round - 1));

        for (uint i = 1; i <= 10; i++) {
            if (tmp == levelBase[i - 1]) {
                    level = i;
                    break;
            }
        }
        require(level > 0, 'Wrong amount');

        uint levelID = (round - 1) * 10 + level - 1;
        
        return (round, level, levelID);
    }

    function lvlAmount (uint _levelID) public view returns(uint) {
        uint level = _levelID % 10;
        uint round = (_levelID - level) / 10;
        uint tmp = levelBase[level] * (2 ** round);

        if (level == 3 && round < 8) return (tmp - (2 ** round) * 1 ether - 0.1 ether);
        return (tmp  + (0.1 ether * (round + 1)));
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
        for (uint i = 1; i <= 10; i++) {
            if (users[_user].levelExpiry[_round * 10 - i] > now) {
                max = 11 - i;
                break;
            }
        }
        return max;
    }
    
    function getUplines(uint _user, uint _round) public view returns (uint[10] memory uplines, address[10] memory uplinesWallets) {
        for(uint i = 0; i < 10; i++) {
            _user = users[_user].uplines[_round];
            uplines[i] = _user;
            uplinesWallets[i] = users[_user].wallet;
        }
    }

    function getUserLevels(uint _user) external view returns (uint[90] memory levels) {
        for (uint i = 0; i < 90; i++) {
            levels[i] = users[_user].levelExpiry[i];
        }
    }

    function bytesToAddress(bytes memory _addr) private pure returns (address addr) {
        assembly {
            addr := mload(add(_addr, 20))
        }
    }
}