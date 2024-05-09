pragma solidity >=0.4.23 <0.6.0;

contract Eth2PlusV2 {
    
    struct User {
        uint id;
        address referrer;
        uint partnersCount;
        
        mapping(uint8 => bool) activeX3Levels;
        mapping(uint8 => bool) activeX6Levels;
        
        mapping(uint8 => X3) x3Matrix;
        mapping(uint8 => X6) x6Matrix;
    }
    
    struct X3 {
        address currentReferrer;
        address[] referrals;
        bool blocked;
        uint reinvestCount;
    }
    
    struct X6 {
        address currentReferrer;
        address[] firstLevelReferrals;
        address[] secondLevelReferrals;
        bool blocked;
        uint reinvestCount;

        address closedPart;
    }

    uint8 public constant LAST_LEVEL = 12;
    
    mapping(address => User) public users;
    mapping(uint => address) public idToAddress;
    mapping(uint => address) public userIds;
    mapping(address => uint) public balances; 
    
    
    mapping(address=>mapping(uint=>mapping(uint=>uint256))) public matrixLevelReward;
    
    mapping(address=>mapping(uint=>uint256)) public matrixReward;

    //TODO:
    uint public lastUserId = 2;
    address public starNode;
    
    address owner;
    
    address truncateNode;
    
    mapping(uint8 => uint) public levelPrice;
    
    mapping(uint8=>uint256) public global1FallUidForLevel;

    mapping(uint8=>uint256) public global2FallUidForLevel;
    
    mapping(uint8=>mapping(uint256=>uint256)) public globalFallCountForLevel;
    mapping(uint256=>bool) public initedMapping;

    mapping(uint8=>uint256) globalFallTypeForLevel;
    
    event Registration(address indexed user, address indexed referrer, uint indexed userId, uint referrerId);
    event Reinvest(address indexed user, address indexed currentReferrer, address indexed caller, uint8 matrix, uint8 level);
    event Upgrade(address indexed user, address indexed referrer, uint8 matrix, uint8 level);
    event NewUserPlace(address indexed user, address indexed referrer, uint8 matrix, uint8 level, uint8 place);
    event MissedEthReceive(address indexed receiver, address indexed from, uint8 matrix, uint8 level);
    event SentExtraEthDividends(address indexed from, address indexed receiver, uint8 matrix, uint8 level);
    
    
    Eth2PlusV2 public ethPlus= Eth2PlusV2(0x0CC3E2D0e6fCDa36DF11B00213c0C8eA80B9a682);
    
    constructor(address starNodeAddress) public {
        levelPrice[1] = 0.025 ether;
        for (uint8 i = 2; i <= LAST_LEVEL; i++) {
            levelPrice[i] = levelPrice[i-1] * 2;
        }
        starNode = starNodeAddress;
        truncateNode = starNodeAddress;
        owner=msg.sender;
        
        // User memory user = User({
        //     id: 1,
        //     referrer: address(0),
        //     partnersCount: uint(0)
        // });
        
        // users[starNodeAddress] = user;
        // idToAddress[1] = starNodeAddress;
        
        for (uint8 i = 1; i <= LAST_LEVEL; i++) {
            globalFallTypeForLevel[i]=1;
            global1FallUidForLevel[i]=0;
            global2FallUidForLevel[i]=11;
      
        }
        
        // userIds[1] = starNodeAddress;
        
    }
    function initUser(uint256 _fromuid,uint256 _touid)public {
        require(msg.sender==owner, "require owner");
        
        for(uint256 _uid=_fromuid;_uid<_touid;_uid++){
            if(initedMapping[_uid]){
                continue;
            }
            address _userAddr=ethPlus.idToAddress(_uid);
            if(_userAddr==address(0x0)){
                continue;
            }
            (,address _referrer,uint256 _partnersCount)=ethPlus.users(_userAddr);
            initOldUser(_uid,_userAddr,_referrer,_partnersCount);
            
            
            initOldUserMatrixReward(_userAddr,1,ethPlus.matrixReward(_userAddr,1));
            initOldUserMatrixReward(_userAddr,2,ethPlus.matrixReward(_userAddr,2));
            
            
            for(uint8 i=1;i<=LAST_LEVEL;i++){
                if(ethPlus.usersActiveX3Levels(_userAddr,i)){
                    
                    uint256 x3MatrixLevelReward=ethPlus.matrixLevelReward(_userAddr,1,i);
                    initOldUserMatrixLevelReward(_userAddr,1,i,x3MatrixLevelReward);
                    
                    (address x3CurrentReferrer,address[] memory x3referrer,bool x3Block)=ethPlus.usersX3Matrix(_userAddr,i);
                    
                    initOldUserX3(_uid,_userAddr,i,x3CurrentReferrer,x3referrer,x3Block);
                    
                }
                if(ethPlus.usersActiveX6Levels(_userAddr,i)){
                    uint256 x4MatrixLevelReward=ethPlus.matrixLevelReward(_userAddr,2,i);
                    initOldUserMatrixLevelReward(_userAddr,2,i,x4MatrixLevelReward);                    
                    
                    (address x4CurrentReferrer,address[] memory x4FirstReferrer,address[] memory x4SecondReferrer,bool x4Block,address closedPart)=ethPlus.usersX6Matrix(_userAddr,i);
                    
                    initOldUserX4(_uid,_userAddr,i,x4CurrentReferrer,x4FirstReferrer,x4SecondReferrer,x4Block,address(0x0));
                    
                }                
            }
            
            initedMapping[_uid]=true;
        }
    }
    
            
    function initOldUser(uint256 _id,address _addr,address _referrer,uint256 _partnersCount)public {
       require(msg.sender==owner, "require owner");
       User memory user = User({
            id: _id,
            referrer: _referrer,
            partnersCount: _partnersCount
        });        
        users[_addr] = user;
        idToAddress[_id] = _addr;
        userIds[_id] = _addr;
    }
    
    function initOldUserX3(uint256 _uid,address _addr,uint8 _level,address _currentReferrer,address[] memory x3referrer,bool _blocked) public{
        require(msg.sender==owner, "require owner");
        users[_addr].activeX3Levels[_level] = true;
 
        users[_addr].x3Matrix[_level].currentReferrer=_currentReferrer;
      
        users[_addr].x3Matrix[_level].referrals=x3referrer;
        users[_addr].x3Matrix[_level].blocked=_blocked;
        users[_addr].x3Matrix[_level].reinvestCount=0;
           
        
    }

    function initOldUserX4(uint256 _uid,address _addr,uint8 _level,address _currentReferrer,address[] memory x4FirstReferrer,address[] memory x4SecondReferrer,bool _blocked,address _closedPart) public{
        require(msg.sender==owner, "require owner");
        users[_addr].activeX6Levels[_level] = true;

        users[_addr].x6Matrix[_level].currentReferrer=_currentReferrer;
  
        
        users[_addr].x6Matrix[_level].firstLevelReferrals=x4FirstReferrer;
   
        users[_addr].x6Matrix[_level].secondLevelReferrals=x4SecondReferrer;
        users[_addr].x6Matrix[_level].blocked=_blocked;
        users[_addr].x6Matrix[_level].reinvestCount=0;  
        users[_addr].x6Matrix[_level].closedPart=_closedPart;  
        
    }
    
    function initOldUserMatrixReward(address _addr,uint matrix,uint256 _reward) public{
        require(msg.sender==owner, "require owner");
        matrixReward[_addr][matrix]=_reward;
        
    }    
    
    
    function initOldUserMatrixLevelReward(address _addr,uint matrix,uint _level,uint256 _reward) public{
        require(msg.sender==owner, "require owner");
        matrixLevelReward[_addr][matrix][_level]=_reward;
        
    }        
    
    function globalfall(uint8 level) internal{
        if(globalFallTypeForLevel[level]==1){
            globalFallTypeForLevel[level]=2;
            
            if(global1FallUidForLevel[level]>=10){
                global1FallUidForLevel[level]=0;
            }
            
            address receiver=owner;
            
            if(lastUserId>global1FallUidForLevel[level]+1){
                global1FallUidForLevel[level]++;
                receiver=userIds[global1FallUidForLevel[level]];
            }
            sendETHDividendsToGobalFall( receiver,level);
            
            
            
        }else{
            globalFallTypeForLevel[level]=1;
            
            address receiver=owner;
            
            if(lastUserId>global2FallUidForLevel[level]+1){
                if(globalFallCountForLevel[level][global2FallUidForLevel[level]]>=2){
                    global2FallUidForLevel[level]++;
                }
                receiver=userIds[global2FallUidForLevel[level]];
                globalFallCountForLevel[level][global2FallUidForLevel[level]]=globalFallCountForLevel[level][global2FallUidForLevel[level]]+1;
            }
            sendETHDividendsToGobalFall( receiver,level);     
            
         
        }
    }
    
    function() external payable {
        if(msg.data.length == 0) {
            return registration(msg.sender, starNode);
        }
        
        registration(msg.sender, bytesToAddress(msg.data));
    }

    function registrationExt(address referrerAddress) external payable {
        registration(msg.sender, referrerAddress);
    }
    
    function buyNewLevel(uint8 matrix, uint8 level) external payable {
        require(isUserExists(msg.sender), "user is not exists. Register first.");
        require(matrix == 1 || matrix == 2, "invalid matrix");
        require(msg.value == levelPrice[level], "invalid price");
        require(level > 1 && level <= LAST_LEVEL, "invalid level");

        if (matrix == 1) {
            require(!users[msg.sender].activeX3Levels[level], "level already activated");

            if (users[msg.sender].x3Matrix[level-1].blocked) {
                users[msg.sender].x3Matrix[level-1].blocked = false;
            }
    
            address freeX3Referrer = findFreeX3Referrer(msg.sender, level);
            users[msg.sender].x3Matrix[level].currentReferrer = freeX3Referrer;
            users[msg.sender].activeX3Levels[level] = true;
            updateX3Referrer(msg.sender, freeX3Referrer, level);
            
            emit Upgrade(msg.sender, freeX3Referrer, 1, level);

        } else {
            require(!users[msg.sender].activeX6Levels[level], "level already activated"); 

            if (users[msg.sender].x6Matrix[level-1].blocked) {
                users[msg.sender].x6Matrix[level-1].blocked = false;
            }

            address freeX6Referrer = findFreeX6Referrer(msg.sender, level);
            
            users[msg.sender].activeX6Levels[level] = true;
            updateX6Referrer(msg.sender, freeX6Referrer, level,false);
            
            emit Upgrade(msg.sender, freeX6Referrer, 2, level);
        }
    }    
    
    function registration(address userAddress, address referrerAddress) private {
        require(msg.value == 0.05 ether, "registration cost 0.05");
        require(!isUserExists(userAddress), "user exists");
        require(isUserExists(referrerAddress), "referrer not exists");
        
        uint32 size;
        assembly {
            size := extcodesize(userAddress)
        }
        require(size == 0, "cannot be a contract");
        
        User memory user = User({
            id: lastUserId,
            referrer: referrerAddress,
            partnersCount: 0
        });
        
        users[userAddress] = user;
        idToAddress[lastUserId] = userAddress;
        
        users[userAddress].referrer = referrerAddress;
        
        users[userAddress].activeX3Levels[1] = true; 
        users[userAddress].activeX6Levels[1] = true;
        
        
        userIds[lastUserId] = userAddress;
        lastUserId++;
        
        users[referrerAddress].partnersCount++;

        address freeX3Referrer = findFreeX3Referrer(userAddress, 1);
        users[userAddress].x3Matrix[1].currentReferrer = freeX3Referrer;
        updateX3Referrer(userAddress, freeX3Referrer, 1);

        updateX6Referrer(userAddress, findFreeX6Referrer(userAddress, 1), 1,false);
        
        emit Registration(userAddress, referrerAddress, users[userAddress].id, users[referrerAddress].id);
    }
    
    function updateX3Referrer(address userAddress, address referrerAddress, uint8 level) private {
        users[referrerAddress].x3Matrix[level].referrals.push(userAddress);

        if (users[referrerAddress].x3Matrix[level].referrals.length < 3) {
            emit NewUserPlace(userAddress, referrerAddress, 1, level, uint8(users[referrerAddress].x3Matrix[level].referrals.length));
            return sendETHDividends(referrerAddress, userAddress, 1, level);
        }
        
        emit NewUserPlace(userAddress, referrerAddress, 1, level, 3);
        //close matrix
        users[referrerAddress].x3Matrix[level].referrals = new address[](0);
        if (!users[referrerAddress].activeX3Levels[level+1] && level != LAST_LEVEL) {
            users[referrerAddress].x3Matrix[level].blocked = true;
        }

        //create new one by recursion
        if (referrerAddress != starNode) {
            //check referrer active level
            address freeReferrerAddress = findFreeX3Referrer(referrerAddress, level);
            if (users[referrerAddress].x3Matrix[level].currentReferrer != freeReferrerAddress) {
                users[referrerAddress].x3Matrix[level].currentReferrer = freeReferrerAddress;
            }
            
            users[referrerAddress].x3Matrix[level].reinvestCount++;
            emit Reinvest(referrerAddress, freeReferrerAddress, userAddress, 1, level);
            updateX3Referrer(referrerAddress, freeReferrerAddress, level);
        } else {
            sendETHDividends(starNode, userAddress, 1, level);
            users[starNode].x3Matrix[level].reinvestCount++;
            emit Reinvest(starNode, address(0), userAddress, 1, level);
        }
    }

    function updateX6Referrer(address userAddress, address referrerAddress, uint8 level,bool needRSkipecursionDivide) private {
        require(users[referrerAddress].activeX6Levels[level], "500. Referrer level is inactive");
        
        if (users[referrerAddress].x6Matrix[level].firstLevelReferrals.length < 2) {
            users[referrerAddress].x6Matrix[level].firstLevelReferrals.push(userAddress);
            emit NewUserPlace(userAddress, referrerAddress, 2, level, uint8(users[referrerAddress].x6Matrix[level].firstLevelReferrals.length));
            
            //set current level
            users[userAddress].x6Matrix[level].currentReferrer = referrerAddress;

            if (referrerAddress == starNode) {
                return sendETHDividends(referrerAddress, userAddress, 2, level);
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

            return updateX6ReferrerSecondLevel(userAddress, ref, level,needRSkipecursionDivide);
        }
        
        users[referrerAddress].x6Matrix[level].secondLevelReferrals.push(userAddress);

        if (users[referrerAddress].x6Matrix[level].closedPart != address(0)) {
            if ((users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] == 
                users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]) &&
                (users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] ==
                users[referrerAddress].x6Matrix[level].closedPart)) {

                updateX6(userAddress, referrerAddress, level, true);
                return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level,needRSkipecursionDivide);
            } else if (users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] == 
                users[referrerAddress].x6Matrix[level].closedPart) {
                updateX6(userAddress, referrerAddress, level, true);
                return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level,needRSkipecursionDivide);
            } else {
                updateX6(userAddress, referrerAddress, level, false);
                return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level,needRSkipecursionDivide);
            }
        }

        if (users[referrerAddress].x6Matrix[level].firstLevelReferrals[1] == userAddress) {
            updateX6(userAddress, referrerAddress, level, false);
            return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level,needRSkipecursionDivide);
        } else if (users[referrerAddress].x6Matrix[level].firstLevelReferrals[0] == userAddress) {
            updateX6(userAddress, referrerAddress, level, true);
            return updateX6ReferrerSecondLevel(userAddress, referrerAddress, level,needRSkipecursionDivide);
        }
        
        if (users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.length <= 
            users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.length) {
            updateX6(userAddress, referrerAddress, level, false);
        } else {
            updateX6(userAddress, referrerAddress, level, true);
        }
        
        updateX6ReferrerSecondLevel(userAddress, referrerAddress, level,needRSkipecursionDivide);
    }

    function updateX6(address userAddress, address referrerAddress, uint8 level, bool x2) private {
        if (!x2) {
            users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.push(userAddress);
            emit NewUserPlace(userAddress, users[referrerAddress].x6Matrix[level].firstLevelReferrals[0], 2, level, uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.length));
            emit NewUserPlace(userAddress, referrerAddress, 2, level, 2 + uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[0]].x6Matrix[level].firstLevelReferrals.length));
            //set current level
            users[userAddress].x6Matrix[level].currentReferrer = users[referrerAddress].x6Matrix[level].firstLevelReferrals[0];
        } else {
            users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.push(userAddress);
            emit NewUserPlace(userAddress, users[referrerAddress].x6Matrix[level].firstLevelReferrals[1], 2, level, uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.length));
            emit NewUserPlace(userAddress, referrerAddress, 2, level, 4 + uint8(users[users[referrerAddress].x6Matrix[level].firstLevelReferrals[1]].x6Matrix[level].firstLevelReferrals.length));
            //set current level
            users[userAddress].x6Matrix[level].currentReferrer = users[referrerAddress].x6Matrix[level].firstLevelReferrals[1];
        }
    }
    
    function updateX6ReferrerSecondLevel(address userAddress, address referrerAddress, uint8 level,bool needRSkipecursionDivide) private {
        if (users[referrerAddress].x6Matrix[level].secondLevelReferrals.length < 4) {
            if(!needRSkipecursionDivide){
                return sendETHDividends(referrerAddress, userAddress, 2, level);
            }else{
                return;
            }
            
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
        
        if (referrerAddress != starNode) {
            address freeReferrerAddress = findFreeX6Referrer(referrerAddress, level);

            emit Reinvest(referrerAddress, freeReferrerAddress, userAddress, 2, level);
            if(lastUserId>10){
                //cut the divide to global
                globalfall(level);
                
                updateX6Referrer(referrerAddress, freeReferrerAddress, level,true);
            }else{
                updateX6Referrer(referrerAddress, freeReferrerAddress, level,false);
            }
    
        } else {
            emit Reinvest(starNode, address(0), userAddress, 2, level);
            sendETHDividends(starNode, userAddress, 2, level);
        }
    }
    
    function findFreeX3Referrer(address userAddress, uint8 level) public view returns(address) {
        if (users[users[userAddress].referrer].activeX3Levels[level]) {
            return users[userAddress].referrer;
        }else{
            return truncateNode;
        }
    }
    
    function findFreeX6Referrer(address userAddress, uint8 level) public view returns(address) {
        if (users[users[userAddress].referrer].activeX6Levels[level]) {
            return users[userAddress].referrer;
        }else{
            return truncateNode;
        }
    }
        
    function usersActiveX3Levels(address userAddress, uint8 level) public view returns(bool) {
        return users[userAddress].activeX3Levels[level];
    }

    function usersActiveX6Levels(address userAddress, uint8 level) public view returns(bool) {
        return users[userAddress].activeX6Levels[level];
    }

    function usersX3Matrix(address userAddress, uint8 level) public view returns(address, address[] memory, bool) {
        return (users[userAddress].x3Matrix[level].currentReferrer,
                users[userAddress].x3Matrix[level].referrals,
                users[userAddress].x3Matrix[level].blocked);
    }

    function usersX6Matrix(address userAddress, uint8 level) public view returns(address, address[] memory, address[] memory, bool, address) {
        return (users[userAddress].x6Matrix[level].currentReferrer,
                users[userAddress].x6Matrix[level].firstLevelReferrals,
                users[userAddress].x6Matrix[level].secondLevelReferrals,
                users[userAddress].x6Matrix[level].blocked,
                users[userAddress].x6Matrix[level].closedPart);
    }
    
    function refreshTruncateNode(address _truncateNode) external{
        require(msg.sender==owner, "require owner");
        truncateNode=_truncateNode;
    }    
    
    function isUserExists(address user) public view returns (bool) {
        return (users[user].id != 0);
    }
    
    function activeAllLevels(address _addr) external{
        require(msg.sender==owner, "require owner");
        for (uint8 i = 1; i <= LAST_LEVEL; i++) {
            users[_addr].activeX3Levels[i] = true;
            users[_addr].activeX6Levels[i] = true;
        }
    }    
    
    function findEthReceiver(address userAddress, address _from, uint8 matrix, uint8 level) private returns(address, bool) {
        address receiver = userAddress;
        bool isExtraDividends;
        if (matrix == 1) {
                if (users[receiver].x3Matrix[level].blocked) {
                    emit MissedEthReceive(receiver, _from, 1, level);
                    isExtraDividends = true;
                    return (owner, isExtraDividends);
                } else {
                    return (receiver, isExtraDividends);
                }
           
        } else {
                if (users[receiver].x6Matrix[level].blocked) {
                    emit MissedEthReceive(receiver, _from, 2, level);
                    isExtraDividends = true;
                    return (owner, isExtraDividends);
                } else {
                    return (receiver, isExtraDividends);
                }
            
        }
    }
    
    function sendETHDividendsToGobalFall(address receiver, uint8 level) private {

        matrixLevelReward[receiver][2][level]=matrixLevelReward[receiver][2][level]+levelPrice[level];
        matrixReward[receiver][2]=matrixReward[receiver][2]+levelPrice[level];
        if (!address(uint160(receiver)).send(levelPrice[level])) {
            return address(uint160(receiver)).transfer(address(this).balance);
        }
    }

    function sendETHDividends(address userAddress, address _from, uint8 matrix, uint8 level) private {
        (address receiver, bool isExtraDividends) = findEthReceiver(userAddress, _from, matrix, level);

        matrixLevelReward[receiver][matrix][level]=matrixLevelReward[receiver][matrix][level]+levelPrice[level];
        matrixReward[receiver][matrix]=matrixReward[receiver][matrix]+levelPrice[level];

        if (!address(uint160(receiver)).send(levelPrice[level])) {
            return address(uint160(receiver)).transfer(address(this).balance);
        }
        
        if (isExtraDividends) {
            emit SentExtraEthDividends(_from, receiver, matrix, level);
        }
    }
    
    function bytesToAddress(bytes memory bys) private pure returns (address addr) {
        assembly {
            addr := mload(add(bys, 20))
        }
    }
    
    function transferOwnerShip(address _owner) public{
        require(msg.sender==owner, "require owner");
        owner = _owner;
    }
    
    function refreshLastId(uint256 _lastId) public{
        require(msg.sender==owner, "require owner");
        lastUserId = _lastId;
    }    

}