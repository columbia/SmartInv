pragma experimental ABIEncoderV2;
pragma solidity ^0.6.0;

contract OfferStorage {

  mapping(address => bool) public accessAllowed;
  mapping(address => mapping(uint => bool)) public userOfferClaim;
  mapping(uint256 => address[]) public claimedUsers;

  constructor() public {
    accessAllowed[msg.sender] = true;
  }

  modifier platform() {
    require(accessAllowed[msg.sender] == true);
    _;
  }

  function allowAccess(address _address) platform public {
    accessAllowed[_address] = true;
  }

  function denyAccess(address _address) platform public {
    accessAllowed[_address] = false;
  }

  function setUserClaim(address _address, uint offerId, bool status) platform public returns(bool) {
    userOfferClaim[_address][offerId] = status;
    if (status) {
      claimedUsers[offerId].push(_address);
    }
    return true;
  }

  function getClaimedUsersLength(uint _offerId) platform public view returns(uint256){
      return claimedUsers[_offerId].length;
  }

}

abstract contract OpenAlexalO {

    struct UserStruct {
        bool isExist;
        uint id;
        uint referrerID;
        uint currentLevel;
        uint totalEarningEth;
        address[] referral;
        mapping(uint => uint) levelExpired;
    }

    mapping (address => UserStruct) public users;
    mapping (uint => address) public userList;
    mapping (address => uint) public createdDate;

    function viewUserReferral(address _userAddress) virtual external view returns (address[] memory);

}

contract Offer {
  OfferStorage public offerStorage;
  OpenAlexalO public openAlexa;

  address payable public owner;

  struct UserStruct {
    bool isExist;
    uint id;
    uint referrerID;
    uint currentLevel;
    uint totalEarningEth;
    address[] referral;
    mapping(uint => uint) levelExpired;
  }


  mapping(uint => uint) public offerActiveDate;

  uint public levelOneCashBackId;
  uint public levelOneCashBackAmt;

  uint public goLevelSixId;
  uint public goLevelSixAmt;

  uint public leadersPoolAmt;
  uint public leadersPoolId;
  uint public leadersPoolMaxUsers;

  event Claimed(address indexed _from, address indexed _to, uint256 _offerId, uint256 _value);

  modifier onlyActive(uint offerId) {
    require(offerActiveDate[offerId] < openAlexa.createdDate(msg.sender), "Offer not active for user");
    _;
  }

  constructor(address offerStorageAddress, address payable openAlexaAddress) public {

    owner = msg.sender;

    offerStorage = OfferStorage(offerStorageAddress);
    openAlexa = OpenAlexalO(openAlexaAddress);

    // unique id for each offer
    levelOneCashBackId = 1;
    goLevelSixId = 2;
    leadersPoolId = 3;

    levelOneCashBackAmt = 0.03 ether;
    goLevelSixAmt = 3 ether;
    leadersPoolAmt = 102 ether;

    offerActiveDate[levelOneCashBackId] = 1588886820;
    offerActiveDate[goLevelSixId] = 1588886820;
    offerActiveDate[leadersPoolId] = 1588886820;

    leadersPoolMaxUsers = 21;

  }

  // stack to deep cant add modifier
  function levelOneCashBackEligible(address _userAddress) view external
  returns(
    string [4] memory  _message,
    uint _userId,
    uint _userLevel,
    uint _createdDate,
    address[] memory _refs,
    uint256[4] memory _refDates
  ) {
    if(offerActiveDate[levelOneCashBackId] > openAlexa.createdDate(_userAddress)) _message[0] = "Offer not active for User";

    if (address(this).balance < levelOneCashBackAmt) _message[1] = "Contract Balance Low";

    if (offerStorage.userOfferClaim(_userAddress, levelOneCashBackId)) _message[2] = "Offer Already claimed";

    UserStruct memory user;
    (, user.id, user.referrerID, user.currentLevel, ) = openAlexa.users(_userAddress);

    if (user.currentLevel < 2) _message[3] = "Level less than 2";

    // fetch his referrers
    address[] memory refs = openAlexa.viewUserReferral(_userAddress);
    uint256[4] memory temprefs;

    if (refs.length == 2) {
      UserStruct memory ref1;
      (, ref1.id, , , ) = openAlexa.users(refs[0]);
      UserStruct memory ref2;
      (, ref2.id, , , ) = openAlexa.users(refs[1]);
      temprefs = [ref1.id, openAlexa.createdDate(refs[0]), ref2.id, openAlexa.createdDate(refs[1])];
    }

    return (_message,
      user.id,
      user.currentLevel,
      openAlexa.createdDate(_userAddress),
      refs,
      temprefs
    );

  }


  function claimLevelOneCashBack() public {
    require(offerActiveDate[levelOneCashBackId] < openAlexa.createdDate(msg.sender), "Offer not active for User");
    // check has claimed
    require(!offerStorage.userOfferClaim(msg.sender, levelOneCashBackId), "Offer Already Claimed");
    // check contract has funds
    require(address(this).balance > levelOneCashBackAmt, "Contract Balance Low, try again after sometime");
    // fetch his structure
    UserStruct memory user;
    (user.isExist,
      user.id,
      user.referrerID,
      user.currentLevel,
      user.totalEarningEth) = openAlexa.users(msg.sender);
    // check level at 2
    require(user.currentLevel >= 2, "Level not upgraded from 1");
    // fetch his referrers
    address[] memory children = openAlexa.viewUserReferral(msg.sender);
    // check they are two
    require(children.length == 2, "Two downlines not found");
    // fetch their created at date
    uint child1Date = openAlexa.createdDate(children[0]);
    uint child2Date = openAlexa.createdDate(children[1]);
    // fetch his created at date
    uint userDate = openAlexa.createdDate(msg.sender);
    // match date of user with u2 and u3 < 48 hrs
    require(((child1Date - userDate) < 48 hours) && ((child2Date - userDate) < 48 hours), "Downline not registered within 48 hrs");
    // all good transfer 0.03ETH
    require((payable(msg.sender).send(levelOneCashBackAmt)), "Sending Offer Reward Failure");
    // mark the address for address => (offerid => true/false)
    require(offerStorage.setUserClaim(msg.sender, levelOneCashBackId, true), "Setting Claim failed");
    emit Claimed(address(this), msg.sender, levelOneCashBackId, levelOneCashBackAmt);
  }

  function getLine6Users(address[] memory users) public view returns(address[] memory) {

    uint level = 0;
    uint totalLevels = 5;

    uint8[5] memory levelPartners = [4, 8, 16, 32, 64];

    address[] memory result = new address[](64);

    while (level < totalLevels) {
      if(users.length == 0) return result;    
      users = getEachLevelUsers(users, levelPartners[level]);
      if (level == 4)
        result = users;
      level++;
    }

    return result;

  }

  function getEachLevelUsers(address[] memory users, uint limit) public view returns(address[] memory) {
    address[] memory total = new address[](limit);
    uint index = 0;

    for (uint i = 0; i < users.length; i++) {
      if (users[i] == address(0)) break;
      address[] memory children = openAlexa.viewUserReferral(users[i]);
      for (uint j = 0; j < children.length; j++) {
        if (children[j] == address(0)) break;
        total[index] = children[j];
        index++;
      }
    }
    return total;

  }

  function goLevelSixEligible(address _userAddress) view external
  returns(
    string [4] memory _message,
    uint _userId,
    uint _currentLevel,
    address[] memory _refs,
    address[] memory _lineSixrefs,
    bool lineSixComplete
  ) {
    // string [4] memory message;
    if(offerActiveDate[goLevelSixId] > openAlexa.createdDate(_userAddress)) _message[0] = "Offer not active for User";
     // check contract has funds
    if (address(this).balance < goLevelSixAmt) _message[1] = "Contract Balance Low, try again after sometime";
    // check has claimed
    if (offerStorage.userOfferClaim(_userAddress, goLevelSixId)) _message[2] = "Offer Already Claimed";

    // fetch his structure
    UserStruct memory user;
    (, user.id,, user.currentLevel, ) = openAlexa.users(_userAddress);
    // check level at 6
    if (user.currentLevel < 4) _message[3] = "Minimum level 4 required";
    // get referrals
    address[] memory refs = openAlexa.viewUserReferral(_userAddress);
    // refs at level 6
    address[] memory lineSixrefs = getLine6Users(refs);

    return (_message,
      user.id,
      user.currentLevel,
      refs,
      lineSixrefs,
      checkOfferClaimed(lineSixrefs, levelOneCashBackId)
    );

  }

  function claimGoLevelSix() public {
    require(offerActiveDate[goLevelSixId] < openAlexa.createdDate(msg.sender), "Offer not active for User");
    // check has claimed
    require(!offerStorage.userOfferClaim(msg.sender, goLevelSixId), "Offer Already claimed");
    // check contract has funds
    require(address(this).balance > goLevelSixAmt, "Contract Balance Low, try again after sometime");
    // fetch his structure
    UserStruct memory user;
    (user.isExist,
      user.id,
      user.referrerID,
      user.currentLevel,
      user.totalEarningEth) = openAlexa.users(msg.sender);
    // check level
    require(user.currentLevel >= 4, "Minimum level expected is 4");
    // get user register date
    uint userDate = openAlexa.createdDate(msg.sender);
    // match date of user with u2 and u3 < 48 hrs
    require(((now - userDate) < 12 days), "User registration date passed 12 days");
    // get referrals
    address[] memory children = openAlexa.viewUserReferral(msg.sender);
    // children at level 6
    address[] memory line6children = getLine6Users(children);
    // check they took offer 1
    require(checkOfferClaimed(line6children, levelOneCashBackId), "Level 6 partners not claimed cashback offer");
    // all good transfer 0.03ETH
    require((payable(msg.sender).send(goLevelSixAmt)), "Sending Offer Failure");
    // mark the address for address => (offerid => true/false)
    require(offerStorage.setUserClaim(msg.sender, goLevelSixId, true), "Setting Claim failed");
    emit Claimed(address(this), msg.sender, goLevelSixId, goLevelSixAmt);
  }

  function leadersPoolEligible(address _userAddress) view external returns(
    string [4] memory _message,
    uint _userId,
    uint _earnedEth,
    uint _totalClaims,
    uint _maxClaims,
    uint _OfferAmt
  ) {
    if(offerActiveDate[leadersPoolId] > openAlexa.createdDate(_userAddress)) _message[0] = "Offer not active for User";
    UserStruct memory user;
    (, user.id, , , user.totalEarningEth) = openAlexa.users(_userAddress);
    if(offerStorage.getClaimedUsersLength(leadersPoolId) >= (leadersPoolMaxUsers)) _message[1] = "Offer Max users reached";
    if (offerStorage.userOfferClaim(_userAddress, goLevelSixId)) _message[2] = "Offer Already Claimed";
    if(user.totalEarningEth < leadersPoolAmt) _message[3] = "Earned ETH less than offer amount";
    return (
      _message,
      user.id,
      user.totalEarningEth,
      offerStorage.getClaimedUsersLength(leadersPoolId),
      leadersPoolMaxUsers,
      leadersPoolAmt
    );
  }

  function claimLeadersPool() public {
    require(offerActiveDate[leadersPoolId] < openAlexa.createdDate(msg.sender), "Offer not active for user");
    require(!offerStorage.userOfferClaim(msg.sender, leadersPoolId), "Offer Already Claimed");
    require(offerStorage.getClaimedUsersLength(leadersPoolId) < leadersPoolMaxUsers, "Offer claimed by max users");
    // fetch his structure
    UserStruct memory user;
    (user.isExist,
      user.id,
      user.referrerID,
      user.currentLevel,
      user.totalEarningEth) = openAlexa.users(msg.sender);
    require(user.currentLevel >= 1, "Minimum level expected is 1");
    require(user.totalEarningEth >= leadersPoolAmt, "Earned ether less than required amount");
    require(offerStorage.setUserClaim(msg.sender, leadersPoolId, true), "Setting Claim failed");
    emit Claimed(address(this), msg.sender, leadersPoolId, leadersPoolAmt);

  }

  function checkOfferClaimed(address[] memory user, uint offerId) public view returns(bool) {
    bool claimed;
    for (uint i = 0; i < user.length; i++) {
      claimed = true;
      if (!offerStorage.userOfferClaim(user[i], offerId)) {
        claimed = false;
        break;
      }
    }

    return claimed;
  }

  function getOfferClaimedUser(address userAddress, uint offerId) public view returns(
      bool _isClaimed,
      uint _userId,
      uint _currentLevel,
      uint _earnedEth,
      uint _createdDate
      ) {

    UserStruct memory user;
    (, user.id, ,user.currentLevel,user.totalEarningEth) = openAlexa.users(userAddress);

    return (
        offerStorage.userOfferClaim(userAddress, offerId),
        user.id,
        user.currentLevel,
        user.totalEarningEth,
        openAlexa.createdDate(userAddress)
        );
  }

  function addressToUser(address _user) public view returns(
    bool _isExist,
    uint _userId,
    uint _refId,
    uint _currentLevel,
    uint _totalEarningEth,
    uint _createdDate
  ) {
    UserStruct memory user;
    (user.isExist,
      user.id,
      user.referrerID,
      user.currentLevel,
      user.totalEarningEth) = openAlexa.users(_user);


    return (
      user.isExist,
      user.id,
      user.referrerID,
      user.currentLevel,
      user.totalEarningEth,
      openAlexa.createdDate(_user)
    );
  }
  
  function userIDtoAddress(uint _id) public view returns(address _userAddress){
      return openAlexa.userList(_id);
  }

  function getUserByOfferId(uint offerId, uint index) public view returns(
    uint _length,
    address _address
  ) {
    return (
      offerStorage.getClaimedUsersLength(offerId),
      offerStorage.claimedUsers(offerId, index)
    );
  }


  function changeOfferDetails(uint _levelOneCashBackAmt, uint _goLevelSixAmt, uint _leadersPoolAmt, uint _leadersPoolMaxUsers) public {
    require(msg.sender == owner, "Owner only!");
    levelOneCashBackAmt = _levelOneCashBackAmt;
    goLevelSixAmt = _goLevelSixAmt;
    leadersPoolAmt = _leadersPoolAmt;
    leadersPoolMaxUsers = _leadersPoolMaxUsers;
  }

  function changeOfferActive(uint offerId, uint _startDate) public {
    require(msg.sender == owner, "Owner only!");
    offerActiveDate[offerId] = _startDate;
  }

  function withdraw() public {
    require(msg.sender == owner, "Owner only!");
    owner.transfer(address(this).balance);
  }
  
  function changeOwner(address payable newowner) public {
    require(msg.sender == owner, "Owner only!");
    owner = newowner;
  }

  receive () payable external {
    require(msg.sender == owner, "Owner only!");
  }

}