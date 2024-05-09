/*

CONTRACT DEPLOYED FOR VALIDATION 2020-05-27

HEXRUN.NETWORK

WEBSITE URL: https://hexrun.network/

*/
pragma solidity 0.5.11;


interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract hexrun {
    
    
    IERC20 public hexTokenInterface;
    
    address public hexTokenAddress = 0x2b591e99afE9f32eAA6214f7B7629768c40Eeb39;
    address public ownerWallet;


    struct UserStruct {
        bool isExist;
        uint id;
        uint referrerID;
        address[] referral;
        mapping(uint => uint) levelExpired;
    }

    uint REFERRER_1_LEVEL_LIMIT = 2;
    uint PERIOD_LENGTH = 30 days;

    mapping(uint => uint) public LEVEL_PRICE;

    mapping (address => UserStruct) public users;
    mapping (uint => address) public userList;
    uint public currUserID = 0;
    uint public totalHex = 0;



    event regLevelEvent(address indexed _user, address indexed _referrer, uint _time);
    event buyLevelEvent(address indexed _user, uint _level, uint _time);
    event prolongateLevelEvent(address indexed _user, uint _level, uint _time);
    event getMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time);
    event lostMoneyForLevelEvent(address indexed _user, address indexed _referral, uint _level, uint _time);

    constructor() public {
        hexTokenInterface = IERC20(hexTokenAddress);
        ownerWallet = 0x418EA32f7EB0795aa83ceBA00D6DDD055e6643A7;

        LEVEL_PRICE[1] = 2000 * 1e8;
        LEVEL_PRICE[2] = 4000 * 1e8;
        LEVEL_PRICE[3] = 8000 * 1e8;
        LEVEL_PRICE[4] = 16000 * 1e8;
        LEVEL_PRICE[5] = 32000 * 1e8;
        LEVEL_PRICE[6] = 64000 * 1e8;
        LEVEL_PRICE[7] = 128000 * 1e8;
        LEVEL_PRICE[8] = 256000 * 1e8;
        LEVEL_PRICE[9] = 512000 * 1e8;
        LEVEL_PRICE[10] = 1024000 * 1e8; /// (HEX)

        UserStruct memory userStruct;
        currUserID++;

        userStruct = UserStruct({
            isExist: true,
            id: currUserID,
            referrerID: 0,
            referral: new address[](0)
        });
        users[ownerWallet] = userStruct;
        userList[currUserID] = ownerWallet;

        for(uint i = 1; i <= 10; i++) {
            users[ownerWallet].levelExpired[i] = 55555555555;
        }
    }



    function regUser(uint _referrerID, uint _numHex) public {

        require(!users[msg.sender].isExist, 'User exist');
        require(_referrerID > 0 && _referrerID <= currUserID, 'Incorrect referrer Id');
        require(_numHex == LEVEL_PRICE[1], 'Incorrect number of HEX sent');
        if(users[userList[_referrerID]].referral.length >= REFERRER_1_LEVEL_LIMIT) _referrerID = users[findFreeReferrer(userList[_referrerID])].id;
        
        hexTokenInterface.transferFrom(msg.sender, address(this), _numHex);
        
        UserStruct memory userStruct;
        currUserID++;

        userStruct = UserStruct({
            isExist: true,
            id: currUserID,
            referrerID: _referrerID,
            referral: new address[](0)
        });

        users[msg.sender] = userStruct;
        userList[currUserID] = msg.sender;

        users[msg.sender].levelExpired[1] = now + PERIOD_LENGTH;

        users[userList[_referrerID]].referral.push(msg.sender);

        payForLevel(1, msg.sender);

        emit regLevelEvent(msg.sender, userList[_referrerID], now);
        
    }



    function buyLevel(uint _level, uint _numHex) public {
        require(users[msg.sender].isExist, 'User not exist'); 
        require(_level > 0 && _level <= 10, 'Incorrect level');

        hexTokenInterface.transferFrom(msg.sender, address(this), _numHex);

        if(_level == 1) {
            require(_numHex == LEVEL_PRICE[1], 'Incorrect Value');
            users[msg.sender].levelExpired[1] += PERIOD_LENGTH;
        }
        else {
            require(_numHex == LEVEL_PRICE[_level], 'Incorrect Value');

            for(uint l =_level - 1; l > 0; l--) require(users[msg.sender].levelExpired[l] >= now, 'Buy the previous level');

            if(users[msg.sender].levelExpired[_level] == 0) users[msg.sender].levelExpired[_level] = now + PERIOD_LENGTH;
            else users[msg.sender].levelExpired[_level] += PERIOD_LENGTH;
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

        if(_level == 1 || _level == 6) {
            referer = userList[users[_user].referrerID];
        }
        else if(_level == 2 || _level == 7) {
            referer1 = userList[users[_user].referrerID];
            referer = userList[users[referer1].referrerID];
        }
        else if(_level == 3 || _level == 8) {
            referer1 = userList[users[_user].referrerID]; 
            referer2 = userList[users[referer1].referrerID];
            referer = userList[users[referer2].referrerID];
        }
        else if(_level == 4 || _level == 9) {
            referer1 = userList[users[_user].referrerID];
            referer2 = userList[users[referer1].referrerID];
            referer3 = userList[users[referer2].referrerID];
            referer = userList[users[referer3].referrerID];
        }
        else if(_level == 5 || _level == 10) {
            referer1 = userList[users[_user].referrerID];
            referer2 = userList[users[referer1].referrerID];
            referer3 = userList[users[referer2].referrerID];
            referer4 = userList[users[referer3].referrerID];
            referer = userList[users[referer4].referrerID];
        }

        if(!users[referer].isExist) referer = userList[1];

        bool sent = false;
        if(users[referer].levelExpired[_level] >= now) {

            sent = hexTokenInterface.transfer(referer, LEVEL_PRICE[_level]);

            totalHex += LEVEL_PRICE[_level];

            if (sent) {
                emit getMoneyForLevelEvent(referer, msg.sender, _level, now);
            }
        }
        if(!sent) {
            emit lostMoneyForLevelEvent(referer, msg.sender, _level, now);

            payForLevel(_level, referer);
        }
    }

    function findFreeReferrer(address _user) public view returns(address) {
        if(users[_user].referral.length < REFERRER_1_LEVEL_LIMIT) return _user;

        address[] memory referrals = new address[](126);
        referrals[0] = users[_user].referral[0];
        referrals[1] = users[_user].referral[1];

        address freeReferrer;
        bool noFreeReferrer = true;

        for(uint i = 0; i < 126; i++) {
            if(users[referrals[i]].referral.length == REFERRER_1_LEVEL_LIMIT) {
                if(i < 62) {
                    referrals[(i+1)*2] = users[referrals[i]].referral[0];
                    referrals[(i+1)*2+1] = users[referrals[i]].referral[1];
                }
            }
            else {
                noFreeReferrer = false;
                freeReferrer = referrals[i];
                break;
            }
        }

        
        if(noFreeReferrer == true){
            // nothing found - default
            freeReferrer = userList[1];
        }

        return freeReferrer;
    }

    
    function viewLevelStats() public view returns(uint[10]  memory lvlUserCount) {
        for(uint c=1; c <= currUserID; c++) {    
            if(userList[c] != address(0)){
                for(uint lvl=1; lvl < 11; lvl ++) {
                    if(users[userList[c]].levelExpired[lvl] > now) {
                        lvlUserCount[lvl-1] += 1;
                    }
                }
            }
        }
    }

    function viewUserReferral(address _user) public view returns(address[] memory) {
        return users[_user].referral;
    }

    function viewUserLevelExpired(address _user, uint _level) public view returns(uint) {
        return users[_user].levelExpired[_level];
    }
    

    function bytesToAddress(bytes memory bys) private pure returns (address addr) {
        assembly {
            addr := mload(add(bys, 20))
        }
    }
}