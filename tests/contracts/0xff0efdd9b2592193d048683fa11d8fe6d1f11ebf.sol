/*
telegram: @gida
hashtag: #gida_corp
*/
pragma solidity ^0.5.7;


library SafeMath {

  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a / b;
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


contract Ownable {

  address public owner;
  address public manager;
  address public introducer;
  address public ownerWallet1;
  address public ownerWallet2;
  address public ownerWallet3;

  constructor() public {
    owner = msg.sender;
    manager = msg.sender;
    ownerWallet1 = 0x42910288DcD576aE8574D611575Dfe35D9fA2Aa2;
    ownerWallet2 = 0xc40A767980fe384BBc367A8A0EeFF2BCC871A6c9;
    ownerWallet3 = 0x7c734D78a247A5eE3f9A64cE061DB270A7cFeF37;
  }

  modifier onlyOwner() {
    require(msg.sender == owner, "only for owner");
    _;
  }

  modifier onlyOwnerOrManager() {
     require((msg.sender == owner)||(msg.sender == manager), "only for owner or manager");
      _;
  }

  function transferOwnership(address newOwner) public onlyOwner {
    owner = newOwner;
  }

  function setManager(address _manager) public onlyOwnerOrManager {
      manager = _manager;
  }
}

contract Gida is Ownable {

    event regLevelEvent(address indexed _user, address indexed _referrer, uint _time);
    event consoleEvent(uint _msg);
    event recoverPasswordEvent(address indexed _user, uint _time);
    event paymentRejectedEvent(string _message, address indexed _user);
    event buyLevelEvent(address indexed _user, uint _level, uint _time);
    event prolongateLevelEvent(address indexed _user, uint _level, uint _time);
    event getIntroducerMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time, uint amount);
    event getMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time, uint amount);
    event lostMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time, uint amount);
    //------------------------------

    mapping (uint => uint) public LEVEL_PRICE;
    uint REFERRER_1_LEVEL_LIMIT = 3;
    uint RECOVER_PASSWORD = 0.01 ether;
    uint PERIOD_LENGTH = 90 days;


    struct UserStruct {
        bool isExist;
        uint id;
        uint referrerID;
        uint introducerID;
        address[] referral;
        mapping (uint => uint) levelExpired;
    }

    mapping (address => UserStruct) public users;
    mapping (uint => address) public userList;
    uint public currUserID = 0;




    constructor() public {

        LEVEL_PRICE[1] =  0.12 ether;
		LEVEL_PRICE[2] =  0.3 ether;
		LEVEL_PRICE[3] =  1 ether;
		LEVEL_PRICE[4] =  3 ether;
		LEVEL_PRICE[5] =  10 ether;
		LEVEL_PRICE[6] =  4 ether;
		LEVEL_PRICE[7] =  11 ether;
		LEVEL_PRICE[8] =  30 ether;
		LEVEL_PRICE[9] =  90 ether;
		LEVEL_PRICE[10] = 300 ether;
		
        UserStruct memory userStruct1;
        UserStruct memory userStruct2;
        UserStruct memory userStruct3;
        currUserID++;

        userStruct1 = UserStruct({
            isExist : true,
            id : currUserID,
            referrerID : 0,
            introducerID : 0,
            referral : new address[](0)
        });
        users[ownerWallet1] = userStruct1;
        userList[currUserID] = ownerWallet1;

        users[ownerWallet1].levelExpired[1] = 77777777777;
        users[ownerWallet1].levelExpired[2] = 77777777777;
        users[ownerWallet1].levelExpired[3] = 77777777777;
        users[ownerWallet1].levelExpired[4] = 77777777777;
        users[ownerWallet1].levelExpired[5] = 77777777777;
        users[ownerWallet1].levelExpired[6] = 77777777777;
        users[ownerWallet1].levelExpired[7] = 77777777777;
        users[ownerWallet1].levelExpired[8] = 77777777777;
        users[ownerWallet1].levelExpired[9] = 77777777777;
        users[ownerWallet1].levelExpired[10] = 77777777777;
		
        currUserID++;

        userStruct2 = UserStruct({
            isExist : true,
            id : currUserID,
            referrerID : 0,
            introducerID : 0,
            referral : new address[](0)
        });
        users[ownerWallet2] = userStruct2;
        userList[currUserID] = ownerWallet2;

        users[ownerWallet2].levelExpired[1] = 77777777777;
        users[ownerWallet2].levelExpired[2] = 77777777777;
        users[ownerWallet2].levelExpired[3] = 77777777777;
        users[ownerWallet2].levelExpired[4] = 77777777777;
        users[ownerWallet2].levelExpired[5] = 77777777777;
        users[ownerWallet2].levelExpired[6] = 77777777777;
        users[ownerWallet2].levelExpired[7] = 77777777777;
        users[ownerWallet2].levelExpired[8] = 77777777777;
        users[ownerWallet2].levelExpired[9] = 77777777777;
        users[ownerWallet2].levelExpired[10] = 77777777777;
		
		currUserID++;

        userStruct3 = UserStruct({
            isExist : true,
            id : currUserID,
            referrerID : 0,
            introducerID : 0,
            referral : new address[](0)
        });
        users[ownerWallet3] = userStruct3;
        userList[currUserID] = ownerWallet3;

        users[ownerWallet3].levelExpired[1] = 77777777777;
        users[ownerWallet3].levelExpired[2] = 77777777777;
        users[ownerWallet3].levelExpired[3] = 77777777777;
        users[ownerWallet3].levelExpired[4] = 77777777777;
        users[ownerWallet3].levelExpired[5] = 77777777777;
        users[ownerWallet3].levelExpired[6] = 77777777777;
        users[ownerWallet3].levelExpired[7] = 77777777777;
        users[ownerWallet3].levelExpired[8] = 77777777777;
        users[ownerWallet3].levelExpired[9] = 77777777777;
        users[ownerWallet3].levelExpired[10] = 77777777777;
    }

    function () external payable {

        uint level;
        uint passwordRecovery = 0;

        if(msg.value == LEVEL_PRICE[1]){
            level = 1;
        }else if(msg.value == LEVEL_PRICE[2]){
            level = 2;
        }else if(msg.value == LEVEL_PRICE[3]){
            level = 3;
        }else if(msg.value == LEVEL_PRICE[4]){
            level = 4;
        }else if(msg.value == LEVEL_PRICE[5]){
            level = 5;
        }else if(msg.value == LEVEL_PRICE[6]){
            level = 6;
        }else if(msg.value == LEVEL_PRICE[7]){
            level = 7;
        }else if(msg.value == LEVEL_PRICE[8]){
            level = 8;
        }else if(msg.value == LEVEL_PRICE[9]){
            level = 9;
        }else if(msg.value == LEVEL_PRICE[10]){
            level = 10;
        }else if(msg.value == RECOVER_PASSWORD){
            passwordRecovery = 1;
        }else {
			emit paymentRejectedEvent('Incorrect Value send', msg.sender);
            revert('Incorrect Value send');
        }

        if(users[msg.sender].isExist){
			if(passwordRecovery==1){
				emit recoverPasswordEvent(msg.sender, now);
			}else{
				buyLevel(level);
			}
        } else if(level == 1) {
			if(passwordRecovery==0){
				
				uint refId = 0;
				address referrer = bytesToAddress(msg.data);
		
				if (users[referrer].isExist){
					refId = users[referrer].id;
				} else {
					emit paymentRejectedEvent('Incorrect referrer', msg.sender);
					revert('Incorrect referrer');
				}
				regUser(refId);
			}else{
				emit paymentRejectedEvent('User does not exist to recover password.', msg.sender);
				revert('User does not exist to recover password.');
			}
        } else {
			emit paymentRejectedEvent('Please buy first level for 0.12 ETH', msg.sender);
            revert('Please buy first level for 0.12 ETH');
        }
    }

    function regUser(uint _introducerID) public payable {
	    uint _referrerID;
        require(!users[msg.sender].isExist, 'User exist');

        require(_introducerID > 0 && _introducerID <= currUserID, 'Incorrect referrer Id');

        require(msg.value==LEVEL_PRICE[1], 'Incorrect Value');

		/* Default will be introducer, if 3 limit not reached */
		_referrerID = _introducerID;
        if(users[userList[_introducerID]].referral.length >= REFERRER_1_LEVEL_LIMIT)
        {
            _referrerID = users[findFreeReferrer(userList[_introducerID])].id;
        }


        UserStruct memory userStruct;
        currUserID++;

        userStruct = UserStruct({
            isExist : true,
            id : currUserID,
            referrerID : _referrerID,
            introducerID : _introducerID,
            referral : new address[](0)
        });

        users[msg.sender] = userStruct;
        userList[currUserID] = msg.sender;

        users[msg.sender].levelExpired[1] = now + PERIOD_LENGTH;
        users[msg.sender].levelExpired[2] = 0;
        users[msg.sender].levelExpired[3] = 0;
        users[msg.sender].levelExpired[4] = 0;
        users[msg.sender].levelExpired[5] = 0;
        users[msg.sender].levelExpired[6] = 0;
        users[msg.sender].levelExpired[7] = 0;
        users[msg.sender].levelExpired[8] = 0;
        users[msg.sender].levelExpired[9] = 0;
        users[msg.sender].levelExpired[10] = 0;

        users[userList[_referrerID]].referral.push(msg.sender);

        payForLevel(1, msg.sender);

        emit regLevelEvent(msg.sender, userList[_referrerID], now);
    }

    function buyLevel(uint _level) public payable {
        require(users[msg.sender].isExist, 'User not exist');

        require( _level>0 && _level<=10, 'Incorrect level');

        if(_level == 1){
            require(msg.value==LEVEL_PRICE[1], 'Incorrect Value');
            users[msg.sender].levelExpired[1] += PERIOD_LENGTH;
        } else {
            require(msg.value==LEVEL_PRICE[_level], 'Incorrect Value');

            for(uint l =_level-1; l>0; l-- ){
                require(users[msg.sender].levelExpired[l] >= now, 'Buy the previous level');
            }

            if(users[msg.sender].levelExpired[_level] == 0){
                users[msg.sender].levelExpired[_level] = now + PERIOD_LENGTH;
            } else {
                users[msg.sender].levelExpired[_level] += PERIOD_LENGTH;
            }
        }
        payForLevel(_level, msg.sender);
        emit buyLevelEvent(msg.sender, _level, now);
    }

    function payForLevel(uint _level, address _user) internal {

        address referer;
        address referer1;
        address referer2;
        address referer3;
        address referer4;
        if(_level == 1 || _level == 6){
            referer = userList[users[_user].referrerID];
        } else if(_level == 2 || _level == 7){
            referer1 = userList[users[_user].referrerID];
            referer = userList[users[referer1].referrerID];
        } else if(_level == 3 || _level == 8){
            referer1 = userList[users[_user].referrerID];
            referer2 = userList[users[referer1].referrerID];
            referer = userList[users[referer2].referrerID];
        } else if(_level == 4 || _level == 9){
            referer1 = userList[users[_user].referrerID];
            referer2 = userList[users[referer1].referrerID];
            referer3 = userList[users[referer2].referrerID];
            referer = userList[users[referer3].referrerID];
        } else if(_level == 5 || _level == 10){
            referer1 = userList[users[_user].referrerID];
            referer2 = userList[users[referer1].referrerID];
            referer3 = userList[users[referer2].referrerID];
            referer4 = userList[users[referer3].referrerID];
            referer = userList[users[referer4].referrerID];
        }
		
		introducer = userList[users[msg.sender].introducerID];
		
		/* Split amount and send comission to admins */
		uint level;
		uint introducerlevel;
		uint firstAdminPart;
		uint finalToAdmin;
		uint introducerPart;
		uint refererPart;
		bool result;
		
		level	=	_level;
		
		if(_level==1){
			introducerPart 			=	0.02 ether; /* introducer will get 0.02*/
			refererPart 			=	0.1 ether; /* remaining 0.1 will go to referer*/
			
		}else{
			firstAdminPart 			=	(msg.value * 3)/100; /* 3% will go to admin*/
			introducerPart 			=	(msg.value * 15)/100; /* introducer will get 15%*/
			refererPart 			=	msg.value - (firstAdminPart + introducerPart); /* remaining 82% will go to referer*/
		}
		
		introducerlevel	=	0;
		
		for(uint l = _level; l <= 10; l++ ){
			if(users[introducer].levelExpired[l] >= now){
				introducerlevel	=	l;
				break;
			}
		}
		
        if(!users[referer].isExist){
			finalToAdmin	=	msg.value;
			if(users[introducer].isExist && _level>1){
				
				if(introducerlevel >= _level){
					if(userList[1] != introducer && userList[2] != introducer){
						result = address(uint160(introducer)).send(introducerPart);
						finalToAdmin	=	finalToAdmin-introducerPart;
					}
				}else{
					firstAdminPart	=	firstAdminPart+introducerPart;
				}
				transferToAdmin3(firstAdminPart, msg.sender, level);
				finalToAdmin	=	finalToAdmin-firstAdminPart;
			}
			/* If referer not exist then transfer amount to admins */
			transferToAdmins(finalToAdmin, msg.sender, level);
        }else{
			
			/* Admins are referer */
			if(userList[1]==referer || userList[2]==referer ){
				finalToAdmin	=	msg.value;
				if(users[introducer].isExist && _level>1){
					
					if(introducerlevel >= _level){
						if(userList[1] != introducer && userList[2] != introducer){
							result = address(uint160(introducer)).send(introducerPart);
							finalToAdmin	=	finalToAdmin-introducerPart;
						}
					}else{
						firstAdminPart	=	firstAdminPart+introducerPart;
					}
					transferToAdmin3(firstAdminPart, msg.sender, level);
					finalToAdmin	=	finalToAdmin-firstAdminPart;
				}
				/* If referer not exist then transfer amount to admins */
				transferToAdmins(finalToAdmin, msg.sender, level);
			}else{
				
				if(users[referer].levelExpired[level] >= now ){
					
					if(level>1){
						if(introducerlevel >= level){
							result = address(uint160(introducer)).send(introducerPart);
							emit getIntroducerMoneyForLevelEvent(introducer, msg.sender, level, now, introducerPart);
						}else{
							firstAdminPart	=	firstAdminPart+introducerPart;
						}
						result = address(uint160(referer)).send(refererPart);
						transferToAdmin3(firstAdminPart, msg.sender, level);
						emit getMoneyForLevelEvent(referer, msg.sender, level, now, refererPart);
					}else{
						result 		= 	address(uint160(introducer)).send(introducerPart);
						emit getIntroducerMoneyForLevelEvent(introducer, msg.sender, level, now, introducerPart);
						result 		= 	address(uint160(referer)).send(refererPart);
						emit getMoneyForLevelEvent(referer, msg.sender, level, now, refererPart);
					}
				} else {
					emit lostMoneyForLevelEvent(referer, msg.sender, level, now, refererPart);
					payForLevel(level,referer);
				}
			}
		}
    }
	
	function transferToAdmins(uint amount, address _sender, uint _level) public payable returns(bool) {
		
		uint firstPart;
		uint secondPart;
		
		firstPart 	=	(amount*70)/100; /* 70% will go to first admin*/
		secondPart =	amount-firstPart; /* remaining 30% will go to second admin*/
		transferToAdmin1(firstPart, _sender, _level);
		transferToAdmin2(secondPart, _sender, _level);
		return true;
	}
	
	function transferToAdmin1(uint amount, address _sender, uint _level) public payable returns(bool) {
		address admin1;
		bool result1;
		admin1 = userList[1];
		result1 = address(uint160(admin1)).send(amount);
		emit getMoneyForLevelEvent(admin1, _sender, _level, now, amount);
		return result1;
	}
	
	function transferToAdmin2(uint amount, address _sender, uint _level) public payable returns(bool) {
		address admin2;
		bool result2;
		admin2 = userList[2];
		result2 = address(uint160(admin2)).send(amount);
		emit getMoneyForLevelEvent(admin2, _sender, _level, now, amount);
		return result2;
	}
	
	function transferToAdmin3(uint amount, address _sender, uint _level) public payable returns(bool) {
		address admin2;
		bool result2;
		admin2 = userList[3];
		result2 = address(uint160(admin2)).send(amount);
		emit getMoneyForLevelEvent(admin2, _sender, _level, now, amount);
		return result2;
	}

    function findFreeReferrer(address _user) public view returns(address) {
        if(users[_user].referral.length < REFERRER_1_LEVEL_LIMIT){
            return _user;
        }

        address[] memory referrals = new address[](363);
        referrals[0] = users[_user].referral[0]; 
        referrals[1] = users[_user].referral[1];
        referrals[2] = users[_user].referral[2];

        address freeReferrer;
        bool noFreeReferrer = true;

        for(uint i =0; i<363;i++){
            if(users[referrals[i]].referral.length == REFERRER_1_LEVEL_LIMIT){
                if(i<120){
                    referrals[(i+1)*3] = users[referrals[i]].referral[0];
                    referrals[(i+1)*3+1] = users[referrals[i]].referral[1];
                    referrals[(i+1)*3+2] = users[referrals[i]].referral[2];
                }
            }else{
                noFreeReferrer = false;
                freeReferrer = referrals[i];
                break;
            }
        }
        require(!noFreeReferrer, 'No Free Referrer');
        return freeReferrer;

    }

    function viewUserReferral(address _user) public view returns(address[] memory) {
        return users[_user].referral;
    }

    function viewUserLevelExpired(address _user, uint _level) public view returns(uint) {
        return users[_user].levelExpired[_level];
    }
    function bytesToAddress(bytes memory bys) private pure returns (address  addr ) {
        assembly {
            addr := mload(add(bys, 20))
        }
    }
}