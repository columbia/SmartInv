pragma solidity >=0.4.23 <0.7.0;

contract X365 {
    
    struct UserAccount {
        uint id;
        address referrer;
        uint partnersCount;
         
        mapping(uint8 => bool) activeZ3Levels;
        mapping(uint8 => bool) activeZ6Levels;
        
        mapping(uint8 => Z3) Z3Matrix;
        mapping(uint8 => Z4) Z6Matrix;
    }
    
    struct Z3 {
        address currentReferrer;
        address[] referrals;
        bool blocked;
        uint reinvestCount;
    }
    
    struct Z4{
        address currentReferrer;
        address[] firstLevelReferrals;
        address[] secondLevelReferrals;
        bool blocked;
        uint reinvestCount;
        address closedPart;
    }

    uint8 public constant LAST_LEVEL = 12;
    
    mapping(address => UserAccount) public users;
    mapping(uint => address) public idToAddress;
    mapping(uint => address) public userIds;

    uint public lastUserId = 2;
    address public  owner;
    address public partner;
    mapping(uint8 => uint) public levelPrice;

    event UserRegistration(address indexed user, address indexed referrer, uint indexed userId, uint referrerId);
    event Recycle(address indexed user, address indexed currentReferrer, address indexed caller, uint8 matrix, uint8 level);
    event UpgradeLevel(address indexed user, address indexed referrer, uint8 matrix, uint8 level);
    event NewReferral(address indexed user, address indexed referrer, uint8 matrix, uint8 level, uint8 place);
    event MissedRewardsReceived(address indexed receiver, address indexed from, uint8 matrix, uint8 level);
    event RewardsSent(address indexed from, address indexed receiver, uint8 matrix, uint8 level);
    event IncomeTransferred(address indexed user,address indexed from,uint256 value,uint8 matrix, uint8 level);
    
    constructor(address ownerAddress, address partnerAddress) public {
        levelPrice[1] = 0.025 ether;
        for (uint8 i = 2; i <= LAST_LEVEL; i++) {
            levelPrice[i] = levelPrice[i-1] * 2;
        }
           owner = ownerAddress;
           partner = partnerAddress;
      UserAccount memory user ;
          user= UserAccount({
            id: 1,
            referrer: address(0),
            partnersCount: uint(0)
        });   
        users[ownerAddress] = user;
        idToAddress[1] = ownerAddress;
        for (uint8 j = 1; j <= LAST_LEVEL; j++) {
            users[ownerAddress].activeZ3Levels[j] = true;
            users[ownerAddress].activeZ6Levels[j] = true;
        }
        userIds[1] = ownerAddress;
        
    }
  
    
    function regUserExternal(address referrerAddress) external payable {
        userRegistration(msg.sender, referrerAddress);
    }
    
    function buyLevel(uint8 matrix, uint8 level) external payable {
        require(msg.value == levelPrice[level] ,"invalid price");
        require(isUserExists(msg.sender), "user is not exists. Register first.");
        require(matrix == 1 || matrix == 2, "invalid matrix");
     
       
        require(level > 1 && level <= LAST_LEVEL, "invalid level");
       
        if (matrix == 1) {
            require(!users[msg.sender].activeZ3Levels[level], "level already activated");

            if (users[msg.sender].Z3Matrix[level-1].blocked) {
                users[msg.sender].Z3Matrix[level-1].blocked = false;
            }
    
            address freeZ3Referrer = nextFreeZ3Referrer(msg.sender, level);
            users[msg.sender].Z3Matrix[level].currentReferrer = freeZ3Referrer;
            users[msg.sender].activeZ3Levels[level] = true;
            newZ3Referrer(msg.sender, freeZ3Referrer, level);
            
            emit UpgradeLevel(msg.sender, freeZ3Referrer, 1, level);

        } else {
            require(!users[msg.sender].activeZ6Levels[level], "level already activated"); 

            if (users[msg.sender].Z6Matrix[level-1].blocked) {
                users[msg.sender].Z6Matrix[level-1].blocked = false;
            }

            address freeZ6Referrer = nextFreeZ4Referrer(msg.sender, level);
            
            users[msg.sender].activeZ6Levels[level] = true;
            newZ4Referrer(msg.sender, freeZ6Referrer, level);
            
            emit UpgradeLevel(msg.sender, freeZ6Referrer, 2, level);
        }
    }    
    
    function userRegistration(address userAddress, address referrerAddress) private {
        require(msg.value == 0.05 ether, "Invalid Cost");
        require(!isUserExists(userAddress), "user exists");
        require(isUserExists(referrerAddress), "referrer not exists");
    
        uint32 size;
        assembly {
            size := extcodesize(userAddress)
        }
        require(size == 0, "cc");
        
        UserAccount memory user = UserAccount({
            id: lastUserId,
            referrer: referrerAddress,
            partnersCount: 0
        });
        
        users[userAddress] = user;
        idToAddress[lastUserId] = userAddress;
        
        users[userAddress].referrer = referrerAddress;
        
        users[userAddress].activeZ3Levels[1] = true; 
        users[userAddress].activeZ6Levels[1] = true;
        
        
        userIds[lastUserId] = userAddress;
        lastUserId++;
        
        users[referrerAddress].partnersCount++;

        address freeZ3Referrer = nextFreeZ3Referrer(userAddress, 1);
        users[userAddress].Z3Matrix[1].currentReferrer = freeZ3Referrer;
        newZ3Referrer(userAddress, freeZ3Referrer, 1);

        newZ4Referrer(userAddress, nextFreeZ4Referrer(userAddress, 1), 1);
        
        emit UserRegistration(userAddress, referrerAddress, users[userAddress].id, users[referrerAddress].id);
    }
    
    function newZ3Referrer(address userAddress, address referrerAddress, uint8 level) private {
        users[referrerAddress].Z3Matrix[level].referrals.push(userAddress);

        if (users[referrerAddress].Z3Matrix[level].referrals.length < 3) {
            emit NewReferral(userAddress, referrerAddress, 1, level, uint8(users[referrerAddress].Z3Matrix[level].referrals.length));
            return sendRewards(referrerAddress, userAddress, 1, level);
        }
        
        emit NewReferral(userAddress, referrerAddress, 1, level, 3);
        //close matrix
        users[referrerAddress].Z3Matrix[level].referrals = new address[](0);
        if (!users[referrerAddress].activeZ3Levels[level+1] && level != LAST_LEVEL) {
            users[referrerAddress].Z3Matrix[level].blocked = true;
        }

        //create new one by recursion
        if (referrerAddress != owner) {
            //check referrer active level
            address freeReferrerAddress = nextFreeZ3Referrer(referrerAddress, level);
            if (users[referrerAddress].Z3Matrix[level].currentReferrer != freeReferrerAddress) {
                users[referrerAddress].Z3Matrix[level].currentReferrer = freeReferrerAddress;
            }
            
            users[referrerAddress].Z3Matrix[level].reinvestCount++;
            emit Recycle(referrerAddress, freeReferrerAddress, userAddress, 1, level);
            newZ3Referrer(referrerAddress, freeReferrerAddress, level);
        } else {
            sendRewards(owner, userAddress, 1, level);
            users[owner].Z3Matrix[level].reinvestCount++;
            emit Recycle(owner, address(0), userAddress, 1, level);
        }
    }

    function newZ4Referrer(address userAddress, address referrerAddress, uint8 level) private {
        require(users[referrerAddress].activeZ6Levels[level], "500");
        
        if (users[referrerAddress].Z6Matrix[level].firstLevelReferrals.length < 2) {
            users[referrerAddress].Z6Matrix[level].firstLevelReferrals.push(userAddress);
            emit NewReferral(userAddress, referrerAddress, 2, level, uint8(users[referrerAddress].Z6Matrix[level].firstLevelReferrals.length));
            
            //set current level
            users[userAddress].Z6Matrix[level].currentReferrer = referrerAddress;

            if (referrerAddress == owner) {
                return sendRewards(referrerAddress, userAddress, 2, level);
            }
            
            address ref = users[referrerAddress].Z6Matrix[level].currentReferrer;            
            users[ref].Z6Matrix[level].secondLevelReferrals.push(userAddress); 
            
            uint len = users[ref].Z6Matrix[level].firstLevelReferrals.length;
            
            if ((len == 2) && 
                (users[ref].Z6Matrix[level].firstLevelReferrals[0] == referrerAddress) &&
                (users[ref].Z6Matrix[level].firstLevelReferrals[1] == referrerAddress)) {
                if (users[referrerAddress].Z6Matrix[level].firstLevelReferrals.length == 1) {
                    emit NewReferral(userAddress, ref, 2, level, 5);
                } else {
                    emit NewReferral(userAddress, ref, 2, level, 6);
                }
            }  else if ((len == 1 || len == 2) &&
                    users[ref].Z6Matrix[level].firstLevelReferrals[0] == referrerAddress) {
                if (users[referrerAddress].Z6Matrix[level].firstLevelReferrals.length == 1) {
                    emit NewReferral(userAddress, ref, 2, level, 3);
                } else {
                    emit NewReferral(userAddress, ref, 2, level, 4);
                }
            } else if (len == 2 && users[ref].Z6Matrix[level].firstLevelReferrals[1] == referrerAddress) {
                if (users[referrerAddress].Z6Matrix[level].firstLevelReferrals.length == 1) {
                    emit NewReferral(userAddress, ref, 2, level, 5);
                } else {
                    emit NewReferral(userAddress, ref, 2, level, 6);
                }
            }

            return newZ4ReferrerSecondLevel(userAddress, ref, level);
        }
        
        users[referrerAddress].Z6Matrix[level].secondLevelReferrals.push(userAddress);

        if (users[referrerAddress].Z6Matrix[level].closedPart != address(0)) {
            if ((users[referrerAddress].Z6Matrix[level].firstLevelReferrals[0] == 
                users[referrerAddress].Z6Matrix[level].firstLevelReferrals[1]) &&
                (users[referrerAddress].Z6Matrix[level].firstLevelReferrals[0] ==
                users[referrerAddress].Z6Matrix[level].closedPart)) {

                newZ4(userAddress, referrerAddress, level, true);
                return newZ4ReferrerSecondLevel(userAddress, referrerAddress, level);
            } else if (users[referrerAddress].Z6Matrix[level].firstLevelReferrals[0] == 
                users[referrerAddress].Z6Matrix[level].closedPart) {
            newZ4(userAddress, referrerAddress, level, true);
                return newZ4ReferrerSecondLevel(userAddress, referrerAddress, level);
            } else {
                newZ4(userAddress, referrerAddress, level, false);
                return newZ4ReferrerSecondLevel(userAddress, referrerAddress, level);
            }
        }

        if (users[referrerAddress].Z6Matrix[level].firstLevelReferrals[1] == userAddress) {
            newZ4(userAddress, referrerAddress, level, false);
            return newZ4ReferrerSecondLevel(userAddress, referrerAddress, level);
        } else if (users[referrerAddress].Z6Matrix[level].firstLevelReferrals[0] == userAddress) {
            newZ4(userAddress, referrerAddress, level, true);
            return newZ4ReferrerSecondLevel(userAddress, referrerAddress, level);
        }
        
        if (users[users[referrerAddress].Z6Matrix[level].firstLevelReferrals[0]].Z6Matrix[level].firstLevelReferrals.length <= 
            users[users[referrerAddress].Z6Matrix[level].firstLevelReferrals[1]].Z6Matrix[level].firstLevelReferrals.length) {
            newZ4(userAddress, referrerAddress, level, false);
        } else {
            newZ4(userAddress, referrerAddress, level, true);
        }
        
        newZ4ReferrerSecondLevel(userAddress, referrerAddress, level);
    }

    function newZ4(address userAddress, address referrerAddress, uint8 level, bool x2) private {
        if (!x2) {
            users[users[referrerAddress].Z6Matrix[level].firstLevelReferrals[0]].Z6Matrix[level].firstLevelReferrals.push(userAddress);
            emit NewReferral(userAddress, users[referrerAddress].Z6Matrix[level].firstLevelReferrals[0], 2, level, uint8(users[users[referrerAddress].Z6Matrix[level].firstLevelReferrals[0]].Z6Matrix[level].firstLevelReferrals.length));
            emit NewReferral(userAddress, referrerAddress, 2, level, 2 + uint8(users[users[referrerAddress].Z6Matrix[level].firstLevelReferrals[0]].Z6Matrix[level].firstLevelReferrals.length));
            //set current level
            users[userAddress].Z6Matrix[level].currentReferrer = users[referrerAddress].Z6Matrix[level].firstLevelReferrals[0];
        } else {
            users[users[referrerAddress].Z6Matrix[level].firstLevelReferrals[1]].Z6Matrix[level].firstLevelReferrals.push(userAddress);
            emit NewReferral(userAddress, users[referrerAddress].Z6Matrix[level].firstLevelReferrals[1], 2, level, uint8(users[users[referrerAddress].Z6Matrix[level].firstLevelReferrals[1]].Z6Matrix[level].firstLevelReferrals.length));
            emit NewReferral(userAddress, referrerAddress, 2, level, 4 + uint8(users[users[referrerAddress].Z6Matrix[level].firstLevelReferrals[1]].Z6Matrix[level].firstLevelReferrals.length));
            //set current level
            users[userAddress].Z6Matrix[level].currentReferrer = users[referrerAddress].Z6Matrix[level].firstLevelReferrals[1];
        }
    }
    
    function newZ4ReferrerSecondLevel(address userAddress, address referrerAddress, uint8 level) private {
        if (users[referrerAddress].Z6Matrix[level].secondLevelReferrals.length < 4) {
            return sendRewards(referrerAddress, userAddress, 2, level);
        }
        
        address[] memory Z6 = users[users[referrerAddress].Z6Matrix[level].currentReferrer].Z6Matrix[level].firstLevelReferrals;
        
        if (Z6.length == 2) {
            if (Z6[0] == referrerAddress ||
                Z6[1] == referrerAddress) {
                users[users[referrerAddress].Z6Matrix[level].currentReferrer].Z6Matrix[level].closedPart = referrerAddress;
            } else if (Z6.length == 1) {
                if (Z6[0] == referrerAddress) {
                    users[users[referrerAddress].Z6Matrix[level].currentReferrer].Z6Matrix[level].closedPart = referrerAddress;
                }
            }
        }
        
        users[referrerAddress].Z6Matrix[level].firstLevelReferrals = new address[](0);
        users[referrerAddress].Z6Matrix[level].secondLevelReferrals = new address[](0);
        users[referrerAddress].Z6Matrix[level].closedPart = address(0);

        if (!users[referrerAddress].activeZ6Levels[level+1] && level != LAST_LEVEL) {
            users[referrerAddress].Z6Matrix[level].blocked = true;
        }

        users[referrerAddress].Z6Matrix[level].reinvestCount++;
        
        if (referrerAddress != owner) {
            address freeReferrerAddress = nextFreeZ4Referrer(referrerAddress, level);

            emit Recycle(referrerAddress, freeReferrerAddress, userAddress, 2, level);
            newZ4Referrer(referrerAddress, freeReferrerAddress, level);
        } else {
            emit Recycle(owner, address(0), userAddress, 2, level);
            sendRewards(owner, userAddress, 2, level);
        }
    }
    
    function nextFreeZ3Referrer(address userAddress, uint8 level) public view returns(address) {
        while (true) {
            if (users[users[userAddress].referrer].activeZ3Levels[level]) {
                return users[userAddress].referrer;
            }
            
            userAddress = users[userAddress].referrer;
        }
    }
    
    
    function nextFreeZ4Referrer(address userAddress, uint8 level) public view returns(address) {
        while (true) {
            if (users[users[userAddress].referrer].activeZ6Levels[level]) {
                return users[userAddress].referrer;
            }
            
            userAddress = users[userAddress].referrer;
        }
    }

    function usersZ3Matrix(address userAddress, uint8 level) public view returns(address, address[] memory, bool, bool) {
        return (users[userAddress].Z3Matrix[level].currentReferrer,
                users[userAddress].Z3Matrix[level].referrals,
                users[userAddress].Z3Matrix[level].blocked,
                users[userAddress].activeZ3Levels[level]);
    }

    function usersZ4Matrix(address userAddress, uint8 level) public view returns(address, address[] memory, address[] memory, bool, bool, address) {
        return (users[userAddress].Z6Matrix[level].currentReferrer,
                users[userAddress].Z6Matrix[level].firstLevelReferrals,
                users[userAddress].Z6Matrix[level].secondLevelReferrals,
                users[userAddress].Z6Matrix[level].blocked,
                users[userAddress].activeZ6Levels[level],
                users[userAddress].Z6Matrix[level].closedPart);
    }
    
    function isUserExists(address user) public view returns (bool) {
        return (users[user].id != 0);
    }

    function getRewardRecipient(address userAddress, address _from, uint8 matrix, uint8 level) private returns(address, bool) {
        address receiver = userAddress;
        bool isExtraDividends;
        if (matrix == 1) {
            while (true) {
                if (users[receiver].Z3Matrix[level].blocked) {
                    emit MissedRewardsReceived(receiver, _from, 1, level);
                    isExtraDividends = true;
                    receiver = users[receiver].Z3Matrix[level].currentReferrer;
                } else {
                    return (receiver, isExtraDividends);
                }
            }
        } else {
            while (true) {
                if (users[receiver].Z6Matrix[level].blocked) {
                    emit MissedRewardsReceived(receiver, _from, 2, level);
                    isExtraDividends = true;
                    receiver = users[receiver].Z6Matrix[level].currentReferrer;
                } else {
                    return (receiver, isExtraDividends);
                }
            }
        }
    }

    function sendRewards(address userAddress, address _from, uint8 matrix, uint8 level) private {
        (address receiver, bool isExtraDividends) = getRewardRecipient(userAddress, _from, matrix, level);
        
       if (receiver == owner) {
           if (!address(uint160(partner)).send(levelPrice[level] * 10/100)) {
            address(uint160(partner)).transfer(address(this).balance*10/100);    
        }
           if (!address(uint160(receiver)).send(levelPrice[level] * 90/100)) {
             emit  IncomeTransferred(receiver,_from,address(this).balance * 90/100, matrix,level);
            address(uint160(receiver)).transfer(address(this).balance*90/100);
            return;              
        }
        
         emit  IncomeTransferred(receiver,_from,levelPrice[level]*90/100,matrix,level);
        if (isExtraDividends) {
            emit RewardsSent(_from, receiver, matrix, level);
        }
       } else {
            if (!address(uint160(receiver)).send(levelPrice[level])) {
             emit  IncomeTransferred(receiver,_from,address(this).balance, matrix,level);
            return address(uint160(receiver)).transfer(address(this).balance);
        }
         emit  IncomeTransferred(receiver,_from,levelPrice[level],matrix,level);
        if (isExtraDividends) {
            emit RewardsSent(_from, receiver, matrix, level);
        }
       }  
    }
    
    function bytesToAddress(bytes memory bys) private pure returns (address addr) {
        assembly {
            addr := mload(add(bys, 20))
        }
    }
}