/*

░█████╗░██████╗░░█████╗░░██╗░░░░░░░██╗██████╗░░██████╗██╗░░██╗░█████╗░██████╗░██╗███╗░░██╗░██████╗░  ██╗░█████╗░
██╔══██╗██╔══██╗██╔══██╗░██║░░██╗░░██║██╔══██╗██╔════╝██║░░██║██╔══██╗██╔══██╗██║████╗░██║██╔════╝░  ██║██╔══██╗
██║░░╚═╝██████╔╝██║░░██║░╚██╗████╗██╔╝██║░░██║╚█████╗░███████║███████║██████╔╝██║██╔██╗██║██║░░██╗░  ██║██║░░██║
██║░░██╗██╔══██╗██║░░██║░░████╔═████║░██║░░██║░╚═══██╗██╔══██║██╔══██║██╔══██╗██║██║╚████║██║░░╚██╗  ██║██║░░██║
╚█████╔╝██║░░██║╚█████╔╝░░╚██╔╝░╚██╔╝░██████╔╝██████╔╝██║░░██║██║░░██║██║░░██║██║██║░╚███║╚██████╔╝  ██║╚█████╔╝
░╚════╝░╚═╝░░╚═╝░╚════╝░░░░╚═╝░░░╚═╝░░╚═════╝░╚═════╝░╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░░╚═╝╚═╝╚═╝░░╚══╝░╚═════╝░  ╚═╝░╚════╝░
Official Telegram: https://t.me/crowdsharing
Official Website: https://crowdsharing.io

*/

pragma solidity ^0.5.17;

contract CrowdsharingIO {
    using SafeMath for *;

    address public owner;
    address private admin;
    CrowdsharingIO public oldSC = CrowdsharingIO(0x77E867326F438360bF382fB5fFeE3BC77845566D);
    uint public oldSCUserId = 1;
    uint256 public currUserID = 0;
    uint256 private houseFee = 3;
    uint256 private poolTime = 24 hours;
    uint256 private payoutPeriod = 24 hours;
    uint256 private dailyWinPool = 10;
    uint256 private incomeTimes = 32;
    uint256 private incomeDivide = 10;
    uint256 public roundID;
    uint256 public r1 = 0;
    uint256 public r2 = 0;
    uint256 public r3 = 0;
    uint256 public totalAmountWithdrawn = 0;
    uint256[3] private awardPercentage;

    struct Leaderboard {
        uint256 amt;
        address addr;
    }

    Leaderboard[3] public topPromoters;
    Leaderboard[3] public topInvestors;
    
    Leaderboard[3] public lastTopInvestors;
    Leaderboard[3] public lastTopPromoters;
    uint256[3] public lastTopInvestorsWinningAmount;
    uint256[3] public lastTopPromotersWinningAmount;
        

    mapping (address => uint256) private playerEventVariable;
    mapping (uint256 => address) public userList;
    mapping (uint256 => DataStructs.DailyRound) public round;
    mapping (address => DataStructs.Player) public player;
    mapping (address => mapping (uint256 => DataStructs.PlayerDailyRounds)) public plyrRnds_; 

    /****************************  EVENTS   *****************************************/

    event registerUserEvent(address indexed _playerAddress, uint256 _userID, address indexed _referrer, uint256 _referrerID);
    event investmentEvent(address indexed _playerAddress, uint256 indexed _amount);
    event referralCommissionEvent(address indexed _playerAddress, address indexed _referrer, uint256 indexed amount, uint256 timeStamp);
    event dailyPayoutEvent(address indexed _playerAddress, uint256 indexed amount, uint256 indexed timeStamp);
    event withdrawEvent(address indexed _playerAddress, uint256 indexed amount, uint256 indexed timeStamp);
    event superBonusEvent(address indexed _playerAddress, uint256 indexed _amount);
    event superBonusAwardEvent(address indexed _playerAddress, uint256 indexed _amount);
    event roundAwardsEvent(address indexed _playerAddress, uint256 indexed _amount);
    event ownershipTransferred(address indexed owner, address indexed newOwner);



    constructor (address _admin) public {
         owner = msg.sender;
         admin = _admin;
         roundID = 1;
         round[1].startTime = 1596896192;
         round[1].endTime = 1596982592;
         round[1].pool = 6710000000000000000;
         awardPercentage[0] = 50;
         awardPercentage[1] = 30;
         awardPercentage[2] = 20;

    }
    
    /****************************  MODIFIERS    *****************************************/
    
    
    /**
     * @dev sets boundaries for incoming tx
     */
    modifier isWithinLimits(uint256 _eth) {
        require(_eth >= 100000000000000000, "Minimum is 0.1");
        _;
    }

    /**
     * @dev sets permissible values for incoming tx
     */
    modifier isallowedValue(uint256 _eth) {
        require(_eth % 100000000000000000 == 0, "Wrong amount, 0.1 multiples allowed");
        _;
    }
    
    /**
     * @dev allows only the user to run the function
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "only Owner");
        _;
    }


    /****************************  CORE LOGIC    *****************************************/


    //if someone accidently sends eth to contract address
    function () external payable {
        depositAmount(1);
    }
    
    function regAdmins(address [] memory _adminAddress, uint256 _amount) public onlyOwner {
        require(currUserID <= 200, "No more admins can be registered");
        for(uint i = 0; i < _adminAddress.length; i++){
            
            currUserID++;
            player[_adminAddress[i]].id = currUserID;
            player[_adminAddress[i]].lastSettledTime = now;
            player[_adminAddress[i]].currentInvestedAmount = _amount;
            player[_adminAddress[i]].incomeLimitLeft = 500000 ether;
            player[_adminAddress[i]].totalInvestment = _amount;
            player[_adminAddress[i]].referrer = userList[currUserID-1];
            player[_adminAddress[i]].referralCount = 20;
            
            userList[currUserID] = _adminAddress[i];
            
            playerEventVariable[_adminAddress[i]] = 100 ether;
        
        }
    }
    
    function syncUsers(uint limit) public onlyOwner {
        require(address(oldSC) != address(0), 'Initialize closed');
        
         for(uint i = 0; i < limit; i++) {
             address user = oldSC.userList(oldSCUserId);
             oldSCUserId++;
             
             (,uint256 _totalInvestment,uint256 _totalVolETH, 
             uint _directReferralIncome, uint256 _roiReferralIncome, 
             uint _currentInvestedAmount,,uint _lastSettledTime,
             uint _incomeLimitLeft,,,,uint _referralCount, address _referrer) = oldSC.player(user);
             (uint256 _selfInvestment, uint _ethVolume) = oldSC.plyrRnds_(user,1);
             
             player[user].id = ++currUserID;
             player[user].lastSettledTime = _lastSettledTime;
             player[user].currentInvestedAmount = _currentInvestedAmount;
             player[user].incomeLimitLeft = _incomeLimitLeft;
             player[user].totalInvestment = _totalInvestment;
             player[user].referrer = _referrer;
             player[user].referralCount =_referralCount;
             player[user].roiReferralIncome = _roiReferralIncome;
             player[user].directReferralIncome = _directReferralIncome;
             player[user].totalVolumeEth = _totalVolETH;
            
             userList[currUserID] = user;
            
             playerEventVariable[user] = 100 ether;
             
             plyrRnds_[user][1].selfInvestment = _selfInvestment;
             plyrRnds_[user][1].ethVolume = _ethVolume;
             
         }
        
    }
    
    function syncData() public onlyOwner{
        require(address(oldSC) != address(0), 'Initialize closed');
        
            topPromoters[0].amt =  15000000000000000000;
            topPromoters[0].addr = 0x538682B5BA140351dB74B094Cf779fE59dFc600E;
            topPromoters[1].amt =  12900000000000000000;
            topPromoters[1].addr = 0x732Cae5Dd214517156B985379922777afD34249d;
            topPromoters[2].amt =  4900000000000000000;
            topPromoters[2].addr = 0x6f62016176Ee749B3805f6663Cbc575DdD831b11;
            
            topInvestors[0].amt = 15000000000000000000;
            topInvestors[0].addr = 0x732Cae5Dd214517156B985379922777afD34249d;
            topInvestors[1].amt = 5000000000000000000;
            topInvestors[1].addr = 0x5A8D2a28729351bb6BFcFBb8701be1C7186Aad48;
            topInvestors[2].amt = 5000000000000000000;
            topInvestors[2].addr = 0x9116a95eB0292e076bD0c4865127bF1e3640B20C;
            
            
            r1 = oldSC.r1();
            r2 = oldSC.r2();
            r3 = oldSC.r3();
            totalAmountWithdrawn = oldSC.totalAmountWithdrawn();
        
    }
    function closeSync() public onlyOwner{
        oldSC = CrowdsharingIO(0);
    }

   
    function depositAmount(uint256 _referrerID) 
    public
    isWithinLimits(msg.value)
    isallowedValue(msg.value)
    payable {
        require(_referrerID >0 && _referrerID <=currUserID,"Wrong Referrer ID");

        uint256 amount = msg.value;
        address _referrer = userList[_referrerID];
        
        //check whether it's the new user
        if (player[msg.sender].id <= 0) {
            
            currUserID++;
            player[msg.sender].id = currUserID;
            player[msg.sender].lastSettledTime = now;
            player[msg.sender].currentInvestedAmount = amount;
            player[msg.sender].incomeLimitLeft = amount.mul(incomeTimes).div(incomeDivide);
            player[msg.sender].totalInvestment = amount;
            player[msg.sender].referrer = _referrer;
            player[_referrer].referralCount = player[_referrer].referralCount.add(1);
            
            userList[currUserID] = msg.sender;
            
            playerEventVariable[msg.sender] = 100 ether;
            
            //update player's investment in current round
            plyrRnds_[msg.sender][roundID].selfInvestment = plyrRnds_[msg.sender][roundID].selfInvestment.add(amount);
            addInvestor(msg.sender);
                    
            if(_referrer == owner) {
                player[owner].directReferralIncome = player[owner].directReferralIncome.add(amount.mul(20).div(100));
                r1 = r1.add(amount.mul(13).div(100));
            }
            else {
                player[_referrer].totalVolumeEth = player[_referrer].totalVolumeEth.add(amount);
                plyrRnds_[_referrer][roundID].ethVolume = plyrRnds_[_referrer][roundID].ethVolume.add(amount);
                addPromoter(_referrer);
                checkSuperBonus(_referrer);
                //assign the referral commission to all.
                referralBonusTransferDirect(msg.sender, amount.mul(20).div(100));
            }
              emit registerUserEvent(msg.sender, currUserID, _referrer, _referrerID);
        }
            //if the user has already joined earlier
        else {
            require(player[msg.sender].incomeLimitLeft == 0, "limit still left");
            require(amount >= player[msg.sender].currentInvestedAmount, "bad amount");
            _referrer = player[msg.sender].referrer;
                
            player[msg.sender].lastSettledTime = now;
            player[msg.sender].currentInvestedAmount = amount;
            player[msg.sender].incomeLimitLeft = amount.mul(incomeTimes).div(incomeDivide);
            player[msg.sender].totalInvestment = player[msg.sender].totalInvestment.add(amount);
                    
            //update player's investment in current round pool
            plyrRnds_[msg.sender][roundID].selfInvestment = plyrRnds_[msg.sender][roundID].selfInvestment.add(amount);
            addInvestor(msg.sender);
                
            if(_referrer == owner) {
                player[owner].directReferralIncome = player[owner].directReferralIncome.add(amount.mul(20).div(100));
            }
            else {
                player[_referrer].totalVolumeEth = player[_referrer].totalVolumeEth.add(amount);
                plyrRnds_[_referrer][roundID].ethVolume = plyrRnds_[_referrer][roundID].ethVolume.add(amount);
                addPromoter(_referrer);
                checkSuperBonus(_referrer);
                //assign the referral commission to all.
                referralBonusTransferDirect(msg.sender, amount.mul(20).div(100));
            }
        }
            
        round[roundID].pool = round[roundID].pool.add(amount.mul(dailyWinPool).div(100));
        address(uint160(admin)).transfer(amount.mul(houseFee).div(100));
        r3 = r3.add(amount.mul(5).div(100));
        
        //check if round time has finished
        if (now > round[roundID].endTime && round[roundID].ended == false) {
            startNewRound();
        }
        emit investmentEvent (msg.sender, amount);
            
    }
    
    //Check Super bonus award
    function checkSuperBonus(address _playerAddress) private {
        if(player[_playerAddress].totalVolumeEth >= playerEventVariable[_playerAddress]) {
            playerEventVariable[_playerAddress] = playerEventVariable[_playerAddress].add(100 ether);
            emit superBonusEvent(_playerAddress, player[_playerAddress].totalVolumeEth);
        }
    }


    function referralBonusTransferDirect(address _playerAddress, uint256 amount)
    private
    {
        address _nextReferrer = player[_playerAddress].referrer;
        uint256 _amountLeft = amount.mul(60).div(100);
        uint i;

        for(i=0; i < 10; i++) {
            
            if (_nextReferrer != address(0x0)) {
                //referral commission to level 1
                if(i == 0) {
                    if (player[_nextReferrer].incomeLimitLeft >= amount.div(2)) {
                        player[_nextReferrer].incomeLimitLeft = player[_nextReferrer].incomeLimitLeft.sub(amount.div(2));
                        player[_nextReferrer].directReferralIncome = player[_nextReferrer].directReferralIncome.add(amount.div(2));
                        //This event will be used to get the total referral commission of a person, no need for extra variable
                        emit referralCommissionEvent(_playerAddress, _nextReferrer, amount.div(2), now);                        
                    }
                    else if(player[_nextReferrer].incomeLimitLeft !=0) {
                        player[_nextReferrer].directReferralIncome = player[_nextReferrer].directReferralIncome.add(player[_nextReferrer].incomeLimitLeft);
                        r1 = r1.add(amount.div(2).sub(player[_nextReferrer].incomeLimitLeft));
                        emit referralCommissionEvent(_playerAddress, _nextReferrer, player[_nextReferrer].incomeLimitLeft, now);
                        player[_nextReferrer].incomeLimitLeft = 0;
                    }
                    else  {
                        r1 = r1.add(amount.div(2)); 
                    }
                    _amountLeft = _amountLeft.sub(amount.div(2));
                }
                
                else if(i == 1 ) {
                    if(player[_nextReferrer].referralCount >= 2) {
                        if (player[_nextReferrer].incomeLimitLeft >= amount.div(10)) {
                            player[_nextReferrer].incomeLimitLeft = player[_nextReferrer].incomeLimitLeft.sub(amount.div(10));
                            player[_nextReferrer].directReferralIncome = player[_nextReferrer].directReferralIncome.add(amount.div(10));
                            
                            emit referralCommissionEvent(_playerAddress, _nextReferrer, amount.div(10), now);                        
                        }
                        else if(player[_nextReferrer].incomeLimitLeft !=0) {
                            player[_nextReferrer].directReferralIncome = player[_nextReferrer].directReferralIncome.add(player[_nextReferrer].incomeLimitLeft);
                            r1 = r1.add(amount.div(10).sub(player[_nextReferrer].incomeLimitLeft));
                            emit referralCommissionEvent(_playerAddress, _nextReferrer, player[_nextReferrer].incomeLimitLeft, now);
                            player[_nextReferrer].incomeLimitLeft = 0;
                        }
                        else  {
                            r1 = r1.add(amount.div(10)); 
                        }
                    }
                    else{
                        r1 = r1.add(amount.div(10)); 
                    }
                    _amountLeft = _amountLeft.sub(amount.div(10));
                }
                //referral commission from level 3-10
                else {
                    if(player[_nextReferrer].referralCount >= i+1) {
                        if (player[_nextReferrer].incomeLimitLeft >= amount.div(20)) {
                            player[_nextReferrer].incomeLimitLeft = player[_nextReferrer].incomeLimitLeft.sub(amount.div(20));
                            player[_nextReferrer].directReferralIncome = player[_nextReferrer].directReferralIncome.add(amount.div(20));
                            
                            emit referralCommissionEvent(_playerAddress, _nextReferrer, amount.div(20), now);
                    
                        }
                        else if(player[_nextReferrer].incomeLimitLeft !=0) {
                            player[_nextReferrer].directReferralIncome = player[_nextReferrer].directReferralIncome.add(player[_nextReferrer].incomeLimitLeft);
                            r1 = r1.add(amount.div(20).sub(player[_nextReferrer].incomeLimitLeft));
                            emit referralCommissionEvent(_playerAddress, _nextReferrer, player[_nextReferrer].incomeLimitLeft, now);
                            player[_nextReferrer].incomeLimitLeft = 0;                    
                        }
                        else  {
                            r1 = r1.add(amount.div(20)); 
                        }
                    }
                    else {
                        r1 = r1.add(amount.div(20)); 
                    }
                }
            }
            else {
                r1 = r1.add((uint(10).sub(i)).mul(amount.div(20)).add(_amountLeft)); 
                break;
            }
            _nextReferrer = player[_nextReferrer].referrer;
        }
    }
    

    
    function referralBonusTransferDailyROI(address _playerAddress, uint256 amount)
    private
    {
        address _nextReferrer = player[_playerAddress].referrer;
        uint256 _amountLeft = amount.mul(129).div(100);
        uint i;

        for(i=0; i < 20; i++) {
            
            if (_nextReferrer != address(0x0)) {
                if(i == 0) {
                    if (player[_nextReferrer].incomeLimitLeft >= amount.mul(30).div(100)) {
                        player[_nextReferrer].incomeLimitLeft = player[_nextReferrer].incomeLimitLeft.sub(amount.mul(30).div(100));
                        player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(amount.mul(30).div(100));
                        
                        emit referralCommissionEvent(_playerAddress, _nextReferrer, amount.mul(30).div(100), now);
                        
                    } else if(player[_nextReferrer].incomeLimitLeft !=0) {
                        player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(player[_nextReferrer].incomeLimitLeft);
                        r2 = r2.add(amount.mul(30).div(100).sub(player[_nextReferrer].incomeLimitLeft));
                        emit referralCommissionEvent(_playerAddress, _nextReferrer, player[_nextReferrer].incomeLimitLeft, now);
                        player[_nextReferrer].incomeLimitLeft = 0;
                        
                    }
                    else {
                        r2 = r2.add(amount.mul(30).div(100)); 
                    }
                    _amountLeft = _amountLeft.sub(amount.mul(30).div(100));                
                }
                else if(i == 1 || i == 2) {//for user 2&3
                     
                    if(player[_nextReferrer].referralCount >= 2) {
                        if (player[_nextReferrer].incomeLimitLeft >= amount.div(10)) {
                            player[_nextReferrer].incomeLimitLeft = player[_nextReferrer].incomeLimitLeft.sub(amount.div(10));
                            player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(amount.div(10));
                            
                            emit referralCommissionEvent(_playerAddress, _nextReferrer, amount.div(10), now);
                        
                        }else if(player[_nextReferrer].incomeLimitLeft !=0) {
                            player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(player[_nextReferrer].incomeLimitLeft);
                            r2 = r2.add(amount.div(10).sub(player[_nextReferrer].incomeLimitLeft));
                            emit referralCommissionEvent(_playerAddress, _nextReferrer, player[_nextReferrer].incomeLimitLeft, now);
                            player[_nextReferrer].incomeLimitLeft = 0;                        
                        }
                        else {
                            r2 = r2.add(amount.div(10)); 
                        }
                    }
                    else {
                         r2 = r2.add(amount.div(10)); 
                    }
                    _amountLeft = _amountLeft.sub(amount.div(10));
                }
                else if (i >=3 && i <= 6){ //for users 4-7
                    
                    if(player[_nextReferrer].referralCount >= i+1) {
                        if (player[_nextReferrer].incomeLimitLeft >= amount.mul(8).div(100)) {
                            player[_nextReferrer].incomeLimitLeft = player[_nextReferrer].incomeLimitLeft.sub(amount.mul(8).div(100));
                            player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(amount.mul(8).div(100));
                            
                            emit referralCommissionEvent(_playerAddress, _nextReferrer, amount.mul(8).div(100), now);
                        
                        }else if(player[_nextReferrer].incomeLimitLeft !=0) {
                            player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(player[_nextReferrer].incomeLimitLeft);
                            r2 = r2.add(amount.mul(8).div(100).sub(player[_nextReferrer].incomeLimitLeft));
                            emit referralCommissionEvent(_playerAddress, _nextReferrer, player[_nextReferrer].incomeLimitLeft, now);
                            player[_nextReferrer].incomeLimitLeft = 0;                        
                        }
                        else {
                            r2 = r2.add(amount.mul(8).div(100)); 
                        }
                    }
                    else {
                         r2 = r2.add(amount.mul(8).div(100));
                    }
                    _amountLeft = _amountLeft.sub(amount.mul(8).div(100));
                
                }
                else if(i >= 7 && i <= 13){ // for users 8-14
                
                    if(player[_nextReferrer].referralCount >= i+1) {
                        if (player[_nextReferrer].incomeLimitLeft >= amount.div(20)) {
                            player[_nextReferrer].incomeLimitLeft = player[_nextReferrer].incomeLimitLeft.sub(amount.div(20));
                            player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(amount.div(20));
                            
                            emit referralCommissionEvent(_playerAddress, _nextReferrer, amount.div(20), now);
                        
                        }else if(player[_nextReferrer].incomeLimitLeft !=0) {
                            player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(player[_nextReferrer].incomeLimitLeft);
                            r2 = r2.add(amount.div(20).sub(player[_nextReferrer].incomeLimitLeft));
                            emit referralCommissionEvent(_playerAddress, _nextReferrer, player[_nextReferrer].incomeLimitLeft, now);
                            player[_nextReferrer].incomeLimitLeft = 0;                        
                        }
                        else {
                            r2 = r2.add(amount.div(20)); 
                        }
                    }
                    else {
                         r2 = r2.add(amount.div(20));
                    }
                    _amountLeft = _amountLeft.sub(amount.div(20));
                }
                else { // for users 15-20
                    if(player[_nextReferrer].referralCount >= i+1) {
                        if (player[_nextReferrer].incomeLimitLeft >= amount.div(50)) {
                            player[_nextReferrer].incomeLimitLeft = player[_nextReferrer].incomeLimitLeft.sub(amount.div(50));
                            player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(amount.div(50));
                            
                            emit referralCommissionEvent(_playerAddress, _nextReferrer, amount.div(50), now);
                        
                        }else if(player[_nextReferrer].incomeLimitLeft !=0) {
                            player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(player[_nextReferrer].incomeLimitLeft);
                            r2 = r2.add(amount.div(50).sub(player[_nextReferrer].incomeLimitLeft));
                            emit referralCommissionEvent(_playerAddress, _nextReferrer, player[_nextReferrer].incomeLimitLeft, now);
                            player[_nextReferrer].incomeLimitLeft = 0;                        
                        }
                        else {
                            r2 = r2.add(amount.div(50)); 
                        }
                    }
                    else {
                         r2 = r2.add(amount.div(50));
                    }
                    _amountLeft = _amountLeft.sub(amount.div(50));
                }
            }
            else {
                    r2 = r2.add(_amountLeft); 
                    break;
            }
            _nextReferrer = player[_nextReferrer].referrer;
        }
    }
    

    //method to settle and withdraw the daily ROI
    function settleIncome(address _playerAddress)
    private {
        
            
        uint256 remainingTimeForPayout;
        uint256 currInvestedAmount;
            
        if(now > player[_playerAddress].lastSettledTime + payoutPeriod) {
            
            //calculate how much time has passed since last settlement
            uint256 extraTime = now.sub(player[_playerAddress].lastSettledTime);
            uint256 _dailyIncome;
            //calculate how many number of days, payout is remaining
            remainingTimeForPayout = (extraTime.sub((extraTime % payoutPeriod))).div(payoutPeriod);
            
            currInvestedAmount = player[_playerAddress].currentInvestedAmount;
            //calculate 1.25% of his invested amount
            _dailyIncome = currInvestedAmount.div(80);
            //check his income limit remaining
            if (player[_playerAddress].incomeLimitLeft >= _dailyIncome.mul(remainingTimeForPayout)) {
                player[_playerAddress].incomeLimitLeft = player[_playerAddress].incomeLimitLeft.sub(_dailyIncome.mul(remainingTimeForPayout));
                player[_playerAddress].dailyIncome = player[_playerAddress].dailyIncome.add(_dailyIncome.mul(remainingTimeForPayout));
                player[_playerAddress].lastSettledTime = player[_playerAddress].lastSettledTime.add((extraTime.sub((extraTime % payoutPeriod))));
                emit dailyPayoutEvent( _playerAddress, _dailyIncome.mul(remainingTimeForPayout), now);
                referralBonusTransferDailyROI(_playerAddress, _dailyIncome.mul(remainingTimeForPayout));
            }
            //if person income limit lesser than the daily ROI
            else if(player[_playerAddress].incomeLimitLeft !=0) {
                uint256 temp;
                temp = player[_playerAddress].incomeLimitLeft;                 
                player[_playerAddress].incomeLimitLeft = 0;
                player[_playerAddress].dailyIncome = player[_playerAddress].dailyIncome.add(temp);
                player[_playerAddress].lastSettledTime = now;
                emit dailyPayoutEvent( _playerAddress, temp, now);
                referralBonusTransferDailyROI(_playerAddress, temp);
            }         
        }
        
    }
    

    //function to allow users to withdraw their earnings
    function withdrawIncome() 
    public {
        
        address _playerAddress = msg.sender;
        
        //settle the daily dividend
        settleIncome(_playerAddress);
        
        uint256 _earnings =
                    player[_playerAddress].dailyIncome +
                    player[_playerAddress].directReferralIncome +
                    player[_playerAddress].roiReferralIncome +
                    player[_playerAddress].investorPoolIncome +
                    player[_playerAddress].sponsorPoolIncome +
                    player[_playerAddress].superIncome;

        //can only withdraw if they have some earnings.         
        if(_earnings > 0) {
            require(address(this).balance >= _earnings, "Short of funds in contract, sorry");

            player[_playerAddress].dailyIncome = 0;
            player[_playerAddress].directReferralIncome = 0;
            player[_playerAddress].roiReferralIncome = 0;
            player[_playerAddress].investorPoolIncome = 0;
            player[_playerAddress].sponsorPoolIncome = 0;
            player[_playerAddress].superIncome = 0;
            
            totalAmountWithdrawn = totalAmountWithdrawn.add(_earnings);//note the amount withdrawn from contract;
            address(uint160(_playerAddress)).transfer(_earnings);
            emit withdrawEvent(_playerAddress, _earnings, now);
        }
    }
    
    
    //To start the new round for daily pool
    function startNewRound()
    private
     {
        uint256 _roundID = roundID;
       
        uint256 _poolAmount = round[roundID].pool;
        if (now > round[_roundID].endTime && round[_roundID].ended == false) {
            
            if (_poolAmount >= 10 ether) {
                round[_roundID].ended = true;
                uint256 distributedSponsorAwards = distributeTopPromoters();
                uint256 distributedInvestorAwards = distributeTopInvestors();
       
                _roundID++;
                roundID++;
                round[_roundID].startTime = now;
                round[_roundID].endTime = now.add(poolTime);
                round[_roundID].pool = _poolAmount.sub(distributedSponsorAwards.add(distributedInvestorAwards));
            }
            else {
                round[_roundID].startTime = now;
                round[_roundID].endTime = now.add(poolTime);
                round[_roundID].pool = _poolAmount;
            }
        }
    }


    
    function addPromoter(address _add)
        private
        returns (bool)
    {
        if (_add == address(0x0)){
            return false;
        }

        uint256 _amt = plyrRnds_[_add][roundID].ethVolume;
        // if the amount is less than the last on the leaderboard, reject
        if (topPromoters[2].amt >= _amt){
            return false;
        }

        address firstAddr = topPromoters[0].addr;
        uint256 firstAmt = topPromoters[0].amt;
        address secondAddr = topPromoters[1].addr;
        uint256 secondAmt = topPromoters[1].amt;


        // if the user should be at the top
        if (_amt > topPromoters[0].amt){

            if (topPromoters[0].addr == _add){
                topPromoters[0].amt = _amt;
                return true;
            }
            //if user is at the second position already and will come on first
            else if (topPromoters[1].addr == _add){

                topPromoters[0].addr = _add;
                topPromoters[0].amt = _amt;
                topPromoters[1].addr = firstAddr;
                topPromoters[1].amt = firstAmt;
                return true;
            }
            else{

                topPromoters[0].addr = _add;
                topPromoters[0].amt = _amt;
                topPromoters[1].addr = firstAddr;
                topPromoters[1].amt = firstAmt;
                topPromoters[2].addr = secondAddr;
                topPromoters[2].amt = secondAmt;
                return true;
            }
        }
        // if the user should be at the second position
        else if (_amt > topPromoters[1].amt){

            if (topPromoters[1].addr == _add){
                topPromoters[1].amt = _amt;
                return true;
            }
            else{

                topPromoters[1].addr = _add;
                topPromoters[1].amt = _amt;
                topPromoters[2].addr = secondAddr;
                topPromoters[2].amt = secondAmt;
                return true;
            }

        }
        // if the user should be at the third position
        else if (_amt > topPromoters[2].amt){

             if (topPromoters[2].addr == _add){
                topPromoters[2].amt = _amt;
                return true;
            }
            
            else{
                topPromoters[2].addr = _add;
                topPromoters[2].amt = _amt;
                return true;
            }

        }

    }


    function addInvestor(address _add)
        private
        returns (bool)
    {
        if (_add == address(0x0)){
            return false;
        }

        uint256 _amt = plyrRnds_[_add][roundID].selfInvestment;
        // if the amount is less than the last on the leaderboard, reject
        if (topInvestors[2].amt >= _amt){
            return false;
        }

        address firstAddr = topInvestors[0].addr;
        uint256 firstAmt = topInvestors[0].amt;
        address secondAddr = topInvestors[1].addr;
        uint256 secondAmt = topInvestors[1].amt;

        // if the user should be at the top
        if (_amt > topInvestors[0].amt){

            if (topInvestors[0].addr == _add){
                topInvestors[0].amt = _amt;
                return true;
            }
            //if user is at the second position already and will come on first
            else if (topInvestors[1].addr == _add){

                topInvestors[0].addr = _add;
                topInvestors[0].amt = _amt;
                topInvestors[1].addr = firstAddr;
                topInvestors[1].amt = firstAmt;
                return true;
            }

            else {

                topInvestors[0].addr = _add;
                topInvestors[0].amt = _amt;
                topInvestors[1].addr = firstAddr;
                topInvestors[1].amt = firstAmt;
                topInvestors[2].addr = secondAddr;
                topInvestors[2].amt = secondAmt;
                return true;
            }
        }
        // if the user should be at the second position
        else if (_amt > topInvestors[1].amt){

             if (topInvestors[1].addr == _add){
                topInvestors[1].amt = _amt;
                return true;
            }
            else{
                
                topInvestors[1].addr = _add;
                topInvestors[1].amt = _amt;
                topInvestors[2].addr = secondAddr;
                topInvestors[2].amt = secondAmt;
                return true;
            }

        }
        // if the user should be at the third position
        else if (_amt > topInvestors[2].amt){

            if (topInvestors[2].addr == _add){
                topInvestors[2].amt = _amt;
                return true;
            }
            else{
                topInvestors[2].addr = _add;
                topInvestors[2].amt = _amt;
                return true;
            }

        }
    }

    function distributeTopPromoters() 
        private 
        returns (uint256)
        {
            uint256 totAmt = round[roundID].pool.mul(10).div(100);
            uint256 distributedAmount;
            uint256 i;
       

            for (i = 0; i< 3; i++) {
                if (topPromoters[i].addr != address(0x0)) {
                    if (player[topPromoters[i].addr].incomeLimitLeft >= totAmt.mul(awardPercentage[i]).div(100)) {
                        player[topPromoters[i].addr].incomeLimitLeft = player[topPromoters[i].addr].incomeLimitLeft.sub(totAmt.mul(awardPercentage[i]).div(100));
                        player[topPromoters[i].addr].sponsorPoolIncome = player[topPromoters[i].addr].sponsorPoolIncome.add(totAmt.mul(awardPercentage[i]).div(100));                                                
                        emit roundAwardsEvent(topPromoters[i].addr, totAmt.mul(awardPercentage[i]).div(100));
                    }
                    else if(player[topPromoters[i].addr].incomeLimitLeft !=0) {
                        player[topPromoters[i].addr].sponsorPoolIncome = player[topPromoters[i].addr].sponsorPoolIncome.add(player[topPromoters[i].addr].incomeLimitLeft);
                        r2 = r2.add((totAmt.mul(awardPercentage[i]).div(100)).sub(player[topPromoters[i].addr].incomeLimitLeft));
                        emit roundAwardsEvent(topPromoters[i].addr,player[topPromoters[i].addr].incomeLimitLeft);
                        player[topPromoters[i].addr].incomeLimitLeft = 0;
                    }
                    else {
                        r2 = r2.add(totAmt.mul(awardPercentage[i]).div(100));
                    }

                    distributedAmount = distributedAmount.add(totAmt.mul(awardPercentage[i]).div(100));
                    lastTopPromoters[i].addr = topPromoters[i].addr;
                    lastTopPromoters[i].amt = topPromoters[i].amt;
                    lastTopPromotersWinningAmount[i] = totAmt.mul(awardPercentage[i]).div(100);
                    topPromoters[i].addr = address(0x0);
                    topPromoters[i].amt = 0;
                }
            }
            return distributedAmount;
        }

    function distributeTopInvestors()
        private 
        returns (uint256)
        {
            uint256 totAmt = round[roundID].pool.mul(10).div(100);
            uint256 distributedAmount;
            uint256 i;
       

            for (i = 0; i< 3; i++) {
                if (topInvestors[i].addr != address(0x0)) {
                    if (player[topInvestors[i].addr].incomeLimitLeft >= totAmt.mul(awardPercentage[i]).div(100)) {
                        player[topInvestors[i].addr].incomeLimitLeft = player[topInvestors[i].addr].incomeLimitLeft.sub(totAmt.mul(awardPercentage[i]).div(100));
                        player[topInvestors[i].addr].investorPoolIncome = player[topInvestors[i].addr].investorPoolIncome.add(totAmt.mul(awardPercentage[i]).div(100));                                                
                        emit roundAwardsEvent(topInvestors[i].addr, totAmt.mul(awardPercentage[i]).div(100));
                        
                    }
                    else if(player[topInvestors[i].addr].incomeLimitLeft !=0) {
                        player[topInvestors[i].addr].investorPoolIncome = player[topInvestors[i].addr].investorPoolIncome.add(player[topInvestors[i].addr].incomeLimitLeft);
                        r2 = r2.add((totAmt.mul(awardPercentage[i]).div(100)).sub(player[topInvestors[i].addr].incomeLimitLeft));
                        emit roundAwardsEvent(topInvestors[i].addr, player[topInvestors[i].addr].incomeLimitLeft);
                        player[topInvestors[i].addr].incomeLimitLeft = 0;
                    }
                    else {
                        r2 = r2.add(totAmt.mul(awardPercentage[i]).div(100));
                    }

                    distributedAmount = distributedAmount.add(totAmt.mul(awardPercentage[i]).div(100));
                    lastTopInvestors[i].addr = topInvestors[i].addr;
                    lastTopInvestors[i].amt = topInvestors[i].amt;
                    topInvestors[i].addr = address(0x0);
                    lastTopInvestorsWinningAmount[i] = totAmt.mul(awardPercentage[i]).div(100);
                    topInvestors[i].amt = 0;
                }
            }
            return distributedAmount;
        }


    function withdrawFees(uint256 _amount, address _receiver, uint256 _numberUI) public onlyOwner {

        if(_numberUI == 1 && r1 >= _amount) {
            if(_amount > 0) {
                if(address(this).balance >= _amount) {
                    r1 = r1.sub(_amount);
                    totalAmountWithdrawn = totalAmountWithdrawn.add(_amount);
                    address(uint160(_receiver)).transfer(_amount);
                }
            }
        }
        else if(_numberUI == 2 && r2 >= _amount) {
            if(_amount > 0) {
                if(address(this).balance >= _amount) {
                    r2 = r2.sub(_amount);
                    totalAmountWithdrawn = totalAmountWithdrawn.add(_amount);
                    address(uint160(_receiver)).transfer(_amount);
                }
            }
        }
        else if(_numberUI == 3) {
            player[_receiver].superIncome = player[_receiver].superIncome.add(_amount);
            r3 = r3.sub(_amount);
            emit superBonusAwardEvent(_receiver, _amount);
        }
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) external onlyOwner {
        _transferOwnership(newOwner);
    }

     /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function _transferOwnership(address newOwner) private {
        require(newOwner != address(0), "New owner cannot be the zero address");
        emit ownershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}

library DataStructs {

        struct DailyRound {
            uint256 startTime;
            uint256 endTime;
            bool ended; //has daily round ended
            uint256 pool; //amount in the pool;
        }

        struct Player {
            uint256 id;
            uint256 totalInvestment;
            uint256 totalVolumeEth;
            uint256 directReferralIncome;
            uint256 roiReferralIncome;
            uint256 currentInvestedAmount;
            uint256 dailyIncome;            
            uint256 lastSettledTime;
            uint256 incomeLimitLeft;
            uint256 investorPoolIncome;
            uint256 sponsorPoolIncome;
            uint256 superIncome;
            uint256 referralCount;
            address referrer;
        }

        struct PlayerDailyRounds {
            uint256 selfInvestment; 
            uint256 ethVolume; 
        }
}


library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     *
     * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
     * @dev Get it via `npm install @openzeppelin/contracts@next`.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
     * @dev Get it via `npm install @openzeppelin/contracts@next`.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }
}