pragma solidity >=0.4.23 <0.7.0;

contract EtherGlobeToken {

    address public owner;
    string  public name = "Ether Globe Decentralised Token";
    string  public symbol = "EGDT";
    string  public standard = "EGDT Token v1.0";
    uint256 public totalSupply;
    uint256  public decimals = 18;
    uint256 public  decimalFactor = 10 ** uint256(decimals);
     uint256 public  TOTAL_COIN_MINT = 2500000000 * decimalFactor;
     

    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 _value
    );

    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    mapping(address => uint256) public balanceOf;

    constructor(uint256 _initialSupply) public {
        owner=msg.sender;
        balanceOf[msg.sender] = _initialSupply;
        totalSupply = _initialSupply;
    }
  function mint(address _to, uint256 _value) public returns (bool success) {
       require(msg.sender==owner,"Only Owner Can Mint");
        totalSupply +=_value;
        if(totalSupply<=TOTAL_COIN_MINT){
             balanceOf[msg.sender] += _value;
        require(balanceOf[msg.sender] >= _value);

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        emit Transfer(msg.sender, _to, _value); 

        }
       

        return true;
    }
  

    function transfer( address _to, uint256 _value) public returns (bool success) {
         
        require(_value <= balanceOf[msg.sender]);
      

        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

      

        emit Transfer(msg.sender, _to, _value);

        return true;
    }
}

contract EtherGlobe {
    
    EtherGlobeToken public token;
    
    struct UserAccount {
        uint id;
        address referrer;
        uint partnersCount;
        uint totalTokens;
         
        mapping(uint256 => bool) activeX3Levels;
        mapping(uint256 => bool) activeX6Levels;
        
        mapping(uint256 => X3) x3Matrix;
        mapping(uint256 => X4) x6Matrix;
    }
    
    struct X3 {
        address currentReferrer;
        address[] referrals;
        bool blocked;
        uint reinvestCount;
    }
    
    struct X4{
        address currentReferrer;
        address[] firstLevelReferrals;
        address[] secondLevelReferrals;
        bool blocked;
        uint reinvestCount;
        address closedPart;
    }

    uint256 public constant LAST_LEVEL = 12;
    uint256  public decimals = 18;
    uint256 public  decimalFactor = 10 ** uint256(decimals);
    uint256 tokenReward = 100 * decimalFactor;
    uint256 ownerReward = 625000000 * decimalFactor;
    
    mapping(address => UserAccount) public users;
    mapping(uint => address) public idToAddress;
    mapping(uint => address) public userIds;

    uint public lastUserId = 2;
    address public owner;
    mapping(uint256 => uint) public levelPrice;

    event Registration(address indexed user, address indexed referrer, uint indexed userId, uint referrerId);
    event Recycle(address indexed user, address indexed currentReferrer, address indexed caller, uint256 matrix, uint256 level);
    event UpgradeLevel(address indexed user, address indexed referrer, uint256 matrix, uint256 level);
    event NewUserPlace(address indexed user, address indexed referrer, uint256 matrix, uint256 level, uint256 place);
    event UserActiveLevels(address indexed user, uint8 indexed matrix, uint256 indexed level);
    event IncomeReceived(address indexed user,address indexed from,uint256 value,uint256 matrix, uint256 level);
    event TokenMinted(address indexed receiver, uint indexed totalTokens, uint256 value, uint256 supply);
    
    constructor(address ownerAddress) public {
        levelPrice[1] = 0.05 ether;
        for (uint256 i = 2; i <= LAST_LEVEL; i++) {
            levelPrice[i] = levelPrice[i-1] * 2;
        }
           owner = ownerAddress;
           token = new EtherGlobeToken(0);
      UserAccount memory user;
          user= UserAccount({
            id: 1,
            referrer: address(0),
            partnersCount: uint(0),
            totalTokens: uint(0)
        });   
        users[ownerAddress] = user;
        idToAddress[1] = ownerAddress;
        for (uint256 j = 1; j <= LAST_LEVEL; j++) {
            users[ownerAddress].activeX3Levels[j] = true;
            emit UserActiveLevels(owner, 1, j);
            users[ownerAddress].activeX6Levels[j] = true;
            emit UserActiveLevels(owner, 2, j);
        }
        userIds[1] = ownerAddress;
        
        token.mint(owner, ownerReward);
        
    }
    
    function regUserExt(address referrerAddress) external payable {
        registration(msg.sender, referrerAddress);
        token.mint(msg.sender, tokenReward);
        users[msg.sender].totalTokens += tokenReward;
        emit TokenMinted(msg.sender, ((users[msg.sender].totalTokens) / decimalFactor), tokenReward, (token.totalSupply() / decimalFactor));
    }
    
    function buyNewLevel(uint256 matrix, uint256 level) external payable {
        uint256 buyNewLevelReward = (50 * (2 ** (level - 1))) * decimalFactor;
        require(msg.value == levelPrice[level] ,"invalid price");
        require(isUserExists(msg.sender), "user is not exists. Register first.");
        require(matrix == 1 || matrix == 2, "invalid matrix");
     
       
        require(level > 1 && level <= LAST_LEVEL, "invalid level");
       
        if (matrix == 1) {
            require(!users[msg.sender].activeX3Levels[level], "level already activated");

            if (users[msg.sender].x3Matrix[level-1].blocked) {
                users[msg.sender].x3Matrix[level-1].blocked = false;
            }
    
            address freeX3Referrer = nextFreeX3Referrer(msg.sender, level);
            users[msg.sender].x3Matrix[level].currentReferrer = freeX3Referrer;
            users[msg.sender].activeX3Levels[level] = true;
            emit UserActiveLevels(msg.sender, 1, level);
            newX3Referrer(msg.sender, freeX3Referrer, level);
            
            emit UpgradeLevel(msg.sender, freeX3Referrer, 1, level);

        } else {
            require(!users[msg.sender].activeX6Levels[level], "level already activated"); 

            if (users[msg.sender].x6Matrix[level-1].blocked) {
                users[msg.sender].x6Matrix[level-1].blocked = false;
            }

            address freeX6Referrer = nextFreeX4Referrer(msg.sender, level);
            
            users[msg.sender].activeX6Levels[level] = true;
            emit UserActiveLevels(msg.sender, 2, level);
            newX4Referrer(msg.sender, freeX6Referrer, level);
            
            emit UpgradeLevel(msg.sender, freeX6Referrer, 2, level);
        }
        
        token.mint(msg.sender, buyNewLevelReward);
        users[msg.sender].totalTokens += buyNewLevelReward;
        emit TokenMinted(msg.sender, ((users[msg.sender].totalTokens) / decimalFactor), buyNewLevelReward, (token.totalSupply() / decimalFactor));
    }
    
    function registration(address userAddress, address referrerAddress) private {
        require(msg.value == (levelPrice[1] * 2), "Invalid Cost");
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
            partnersCount: uint(0),
            totalTokens: uint(0)
        });
        
        users[userAddress] = user;
        idToAddress[lastUserId] = userAddress;
        
        users[userAddress].referrer = referrerAddress;
        
        users[userAddress].activeX3Levels[1] = true;
        emit UserActiveLevels(userAddress, 1, 1);
        users[userAddress].activeX6Levels[1] = true;
        emit UserActiveLevels(userAddress, 2, 1);
        
        
        userIds[lastUserId] = userAddress;
        lastUserId++;
        
        users[referrerAddress].partnersCount++;

        address freeX3Referrer = nextFreeX3Referrer(userAddress, 1);
        users[userAddress].x3Matrix[1].currentReferrer = freeX3Referrer;
        newX3Referrer(userAddress, freeX3Referrer, 1);

        newX4Referrer(userAddress, nextFreeX4Referrer(userAddress, 1), 1);
        
        emit Registration(userAddress, referrerAddress, users[userAddress].id, users[referrerAddress].id);
    }
    
    function newX3Referrer(address userAddress, address referrerAddress, uint256 level) private {
        users[referrerAddress].x3Matrix[level].referrals.push(userAddress);

        if (users[referrerAddress].x3Matrix[level].referrals.length < 3) {
            emit NewUserPlace(userAddress, referrerAddress, 1, level, uint256(users[referrerAddress].x3Matrix[level].referrals.length));
            return sendRewards(referrerAddress, userAddress, 1, level);
        }
        
        emit NewUserPlace(userAddress, referrerAddress, 1, level, 3);
        
        users[referrerAddress].x3Matrix[level].referrals = new address[](0);
        if (!users[referrerAddress].activeX3Levels[level+1] && level != LAST_LEVEL) {
            users[referrerAddress].x3Matrix[level].blocked = true;
        }

        if (referrerAddress != owner) {

            address freeReferrerAddress = nextFreeX3Referrer(referrerAddress, level);
            if (users[referrerAddress].x3Matrix[level].currentReferrer != freeReferrerAddress) {
                users[referrerAddress].x3Matrix[level].currentReferrer = freeReferrerAddress;
            }
            
            users[referrerAddress].x3Matrix[level].reinvestCount++;
            emit Recycle(referrerAddress, freeReferrerAddress, userAddress, 1, level);
            newX3Referrer(referrerAddress, freeReferrerAddress, level);
        } else {
            sendRewards(owner, userAddress, 1, level);
            users[owner].x3Matrix[level].reinvestCount++;
            emit Recycle(owner, address(0), userAddress, 1, level);
        }
    }

    function newX4Referrer(address userAddress, address referrerAddress, uint256 level) private {
        require(users[referrerAddress].activeX6Levels[level], "500");
        
        if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length < 2) {
            users[referrerAddress].x6Matrix[level].firstLevelReferrals.push(userAddress);
            emit NewUserPlace(userAddress, referrerAddress, 2, level, uint256(users[referrerAddress].x6Matrix[level].firstLevelReferrals.length));
            
            users[userAddress].x6Matrix[level].currentReferrer = referrerAddress;

            if (referrerAddress == owner) {
                return sendRewards(referrerAddress, userAddress, 2, level);
            }
            
            address ref = users[referrerAddress].x6Matrix[level].currentReferrer;            
            users[ref].x6Matrix[level].secondLevelReferrals.push(userAddress); 
            
            uint len = users[ref].x6Matrix[level].firstLevelReferrals.length;
            
            if ((len == 2) && 
                (users[ref].x6Matrix[level].firstLevelReferrals[0] == referrerAddress) &&
                (users[ref].x6Matrix[level].firstLevelReferrals[1] == referrerAddress)) {
                if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length == 1) {
                    emit NewUserPlace(userAddress, ref, 2, level, 5);
                } else {
                    emit NewUserPlace(userAddress, ref, 2, level, 6);
                }
            }  else if ((len == 1 || len == 2) &&
                    users[ref].x6Matrix[level].firstLevelReferrals[0] == referrerAddress) {
                if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length == 1) {
                    emit NewUserPlace(userAddress, ref, 2, level, 3);
                } else {
                    emit NewUserPlace(userAddress, ref, 2, level, 4);
                }
            } else if (len == 2 && users[ref].x6Matrix[level].firstLevelReferrals[1] == referrerAddress) {
                if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length == 1) {
                    emit NewUserPlace(userAddress, ref, 2, level, 5);
                } else {
                    emit NewUserPlace(userAddress, ref, 2, level, 6);
                }
            }

            return newX4ReferrerSecondLevel(userAddress, ref, level);
        }
        
        users[referrerAddress].x6Matrix[level].secondLevelReferrals.push(userAddress);

        if (users[referrerAddress].x6Matrix[level].closedPart != address(0)) {
            if ((users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] == 
                users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]) &&
                (users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] ==
                users[referrerAddress].x6Matrix[level].closedPart)) {

                newX4(userAddress, referrerAddress, level, true);
                return newX4ReferrerSecondLevel(userAddress, referrerAddress, level);
            } else if (users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] == 
                users[referrerAddress].x6Matrix[level].closedPart) {
            newX4(userAddress, referrerAddress, level, true);
                return newX4ReferrerSecondLevel(userAddress, referrerAddress, level);
            } else {
                newX4(userAddress, referrerAddress, level, false);
                return newX4ReferrerSecondLevel(userAddress, referrerAddress, level);
            }
        }

        if (users[referrerAddress].x6Matrix[level].firstLevelReferrals[1] == userAddress) {
            newX4(userAddress, referrerAddress, level, false);
            return newX4ReferrerSecondLevel(userAddress, referrerAddress, level);
        } else if (users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] == userAddress) {
            newX4(userAddress, referrerAddress, level, true);
            return newX4ReferrerSecondLevel(userAddress, referrerAddress, level);
        }
        
        if (users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.length <= 
            users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.length) {
            newX4(userAddress, referrerAddress, level, false);
        } else {
            newX4(userAddress, referrerAddress, level, true);
        }
        
        newX4ReferrerSecondLevel(userAddress, referrerAddress, level);
    }

    function newX4(address userAddress, address referrerAddress, uint256 level, bool x2) private {
        if (!x2) {
            users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.push(userAddress);
            emit NewUserPlace(userAddress, users[referrerAddress].x6Matrix[level].firstLevelReferrals[0], 2, level, uint256(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.length));
            emit NewUserPlace(userAddress, referrerAddress, 2, level, 2 + uint256(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.length));
            users[userAddress].x6Matrix[level].currentReferrer = users[referrerAddress].x6Matrix[level].firstLevelReferrals[0];
        } else {
            users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.push(userAddress);
            emit NewUserPlace(userAddress, users[referrerAddress].x6Matrix[level].firstLevelReferrals[1], 2, level, uint256(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.length));
            emit NewUserPlace(userAddress, referrerAddress, 2, level, 4 + uint256(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.length));
            users[userAddress].x6Matrix[level].currentReferrer = users[referrerAddress].x6Matrix[level].firstLevelReferrals[1];
        }
    }
    
    function newX4ReferrerSecondLevel(address userAddress, address referrerAddress, uint256 level) private {
        if (users[referrerAddress].x6Matrix[level].secondLevelReferrals.length < 4) {
            return sendRewards(referrerAddress, userAddress, 2, level);
        }
        
        address[] memory x6 = users[users[referrerAddress].x6Matrix[level].currentReferrer].x6Matrix[level].firstLevelReferrals;
        
        if (x6.length == 2) {
            if (x6[0] == referrerAddress ||
                x6[1] == referrerAddress) {
                users[users[referrerAddress].x6Matrix[level].currentReferrer].x6Matrix[level].closedPart = referrerAddress;
            } else if (x6.length == 1) {
                if (x6[0] == referrerAddress) {
                    users[users[referrerAddress].x6Matrix[level].currentReferrer].x6Matrix[level].closedPart = referrerAddress;
                }
            }
        }
        
        users[referrerAddress].x6Matrix[level].firstLevelReferrals = new address[](0);
        users[referrerAddress].x6Matrix[level].secondLevelReferrals = new address[](0);
        users[referrerAddress].x6Matrix[level].closedPart = address(0);

        if (!users[referrerAddress].activeX6Levels[level+1] && level != LAST_LEVEL) {
            users[referrerAddress].x6Matrix[level].blocked = true;
        }

        users[referrerAddress].x6Matrix[level].reinvestCount++;
        
        if (referrerAddress != owner) {
            address freeReferrerAddress = nextFreeX4Referrer(referrerAddress, level);

            emit Recycle(referrerAddress, freeReferrerAddress, userAddress, 2, level);
            newX4Referrer(referrerAddress, freeReferrerAddress, level);
        } else {
            emit Recycle(owner, address(0), userAddress, 2, level);
            sendRewards(owner, userAddress, 2, level);
        }
    }
    
    function nextFreeX3Referrer(address userAddress, uint256 level) public view returns(address) {
        while (true) {
            if (users[users[userAddress].referrer].activeX3Levels[level]) {
                return users[userAddress].referrer;
            }
            
            userAddress = users[userAddress].referrer;
        }
    }
    
    
    function nextFreeX4Referrer(address userAddress, uint256 level) public view returns(address) {
        while (true) {
            if (users[users[userAddress].referrer].activeX6Levels[level]) {
                return users[userAddress].referrer;
            }
            
            userAddress = users[userAddress].referrer;
        }
    }

    function usersX3Matrix(address userAddress, uint256 level) public view returns(address, address[] memory, bool, bool) {
        return (users[userAddress].x3Matrix[level].currentReferrer,
                users[userAddress].x3Matrix[level].referrals,
                users[userAddress].x3Matrix[level].blocked,
                users[userAddress].activeX3Levels[level]);
    }

    function usersX4Matrix(address userAddress, uint256 level) public view returns(address, address[] memory, address[] memory, bool, bool, address) {
        return (users[userAddress].x6Matrix[level].currentReferrer,
                users[userAddress].x6Matrix[level].firstLevelReferrals,
                users[userAddress].x6Matrix[level].secondLevelReferrals,
                users[userAddress].x6Matrix[level].blocked,
                users[userAddress].activeX6Levels[level],
                users[userAddress].x6Matrix[level].closedPart);
    }
    
    function isUserExists(address user) public view returns (bool) {
        return (users[user].id != 0);
    }

    function getRewardReceiver(address userAddress, address _from, uint256 matrix, uint256 level) private returns(address, bool) {
        address receiver = userAddress;
        bool isExtraDividends;
        if (matrix == 1) {
            while (true) {
                if (users[receiver].x3Matrix[level].blocked) {
                    isExtraDividends = true;
                    receiver = users[receiver].x3Matrix[level].currentReferrer;
                } else {
                    return (receiver, isExtraDividends);
                }
            }
        } else {
            while (true) {
                if (users[receiver].x6Matrix[level].blocked) {
                    isExtraDividends = true;
                    receiver = users[receiver].x6Matrix[level].currentReferrer;
                } else {
                    return (receiver, isExtraDividends);
                }
            }
        }
    }

    function sendRewards(address userAddress, address _from, uint256 matrix, uint256 level) private {
        (address receiver, bool isExtraDividends) = getRewardReceiver(userAddress, _from, matrix, level);
        
       
        if (!address(uint160(receiver)).send(levelPrice[level])) {
            emit  IncomeReceived(receiver,_from,address(this).balance, matrix,level);
            return address(uint160(receiver)).transfer(address(this).balance);
        }
         emit  IncomeReceived(receiver,_from,levelPrice[level],matrix,level);
    }
    
    function bytesToAddress(bytes memory bys) private pure returns (address addr) {
        assembly {
            addr := mload(add(bys, 20))
        }
    }
}