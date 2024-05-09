pragma solidity ^0.5.17;

/*

████████╗███████╗██╗░░░██╗██╗░░░██╗░█████╗░
╚══██╔══╝██╔════╝██║░░░██║██║░░░██║██╔══██╗
░░░██║░░░█████╗░░╚██╗░██╔╝╚██╗░██╔╝██║░░██║
░░░██║░░░██╔══╝░░░╚████╔╝░░╚████╔╝░██║░░██║
░░░██║░░░███████╗░░╚██╔╝░░░░╚██╔╝░░╚█████╔╝
░░░╚═╝░░░╚══════╝░░░╚═╝░░░░░░╚═╝░░░░╚════╝░
Official Telegram: https://t.me/tevvo_official
Official Website: https://tevvo.io
*/

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

interface Token {
    function transfer(address _to, uint256 _amount) external  returns (bool success);
    function balanceOf(address _owner) external view returns (uint256 balance);
    function decimals()external view returns (uint8);
}

library DataStructs {

        struct DailyRound {
            uint256 startTime;
            uint256 endTime;
            bool ended; //has daily round ended
            uint256 pool; //amount in the pool;
        }

        struct User {
            uint256 id;
            uint256 totalInvestment;
            uint256 directsIncome;
            uint256 roiReferralIncome;
            uint256 currInvestment;
            uint256 dailyIncome;            
            uint256 lastSettledTime;
            uint256 incomeLimitLeft;
            uint256 sponsorPoolIncome;
            uint256 referralCount;
            address referrer;
        }

        struct PlayerDailyRounds {
            uint256 ethVolume;
        }
}

contract Tevvo {
    using SafeMath for *;
    
    Token public tevvoToken;

    address public owner;
    uint256 private houseFee = 2;
    uint256 private poolTime = 24 hours;
    uint256 private payoutPeriod = 24 hours;
    uint256 private dailyWinPool = 5;
    uint256 private incomeTimes = 30;
    uint256 private incomeDivide = 10;
    uint256 public roundID;
    uint256 public currUserID;
    uint256 public m1 = 0;
    uint256 public m2 = 0;
    uint256[4] private awardPercentage;

    struct Leaderboard {
        uint256 amt;
        address addr;
    }

    Leaderboard[4] public topSponsors;
    
    Leaderboard[4] public lastTopSponsors;
    uint256[4] public lastTopSponsorsWinningAmount;
    address [] public admins;
    uint256 rate = 100000000000000000;// 1 ETH = 100 TVO tokens
        

    mapping (uint => address) public userList;
    mapping (uint256 => DataStructs.DailyRound) public round;
    mapping (address => DataStructs.User) public player;
    mapping (address => mapping (uint256 => DataStructs.PlayerDailyRounds)) public plyrRnds_; 

    /****************************  EVENTS   *****************************************/

    event registerUserEvent(address indexed _playerAddress, address indexed _referrer);
    event investmentEvent(address indexed _playerAddress, uint256 indexed _amount);
    event referralCommissionEvent(address indexed _playerAddress, address indexed _referrer, uint256 indexed amount, uint256 timeStamp);
    event dailyPayoutEvent(address indexed _playerAddress, uint256 indexed amount, uint256 indexed timeStamp);
    event withdrawEvent(address indexed _playerAddress, uint256 indexed amount, uint256 indexed timeStamp);
    event superBonusEvent(address indexed _playerAddress, uint256 indexed _amount);
    event roundAwardsEvent(address indexed _playerAddress, uint256 indexed _amount);
    event ownershipTransferred(address indexed owner, address indexed newOwner);



    constructor (address _admin, address _tokenToBeUsed) public {
         owner = _admin;
         tevvoToken = Token(_tokenToBeUsed);
         roundID = 1;
         round[1].startTime = now;
         round[1].endTime = now + poolTime;
         awardPercentage[0] = 40;
         awardPercentage[1] = 30;
         awardPercentage[2] = 20;
         awardPercentage[3] = 10;
         
         
        currUserID++;
         
        player[owner].id = currUserID;
        player[owner].incomeLimitLeft = 500000 ether;
        player[owner].lastSettledTime = now;
        player[owner].referralCount = 20;
        userList[currUserID] = owner;
         
         
    }
    
    /****************************  MODIFIERS    *****************************************/
    
    
    /**
     * @dev sets boundaries for incoming tx
     */
    modifier isWithinLimits(uint256 _eth) {
        require(_eth >= 100000000000000000, "Minimum contribution amount is 0.1 ETH");
        _;
    }

    /**
     * @dev sets permissible values for incoming tx
     */
    modifier isallowedValue(uint256 _eth) {
        require(_eth % 100000000000000000 == 0, "Only in multiples of 0.1");
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
        registerUser(1);
    }


    //function to maintain the business logic 
    function registerUser(uint256 _referrerID) 
    public
    isWithinLimits(msg.value)
    isallowedValue(msg.value)
    payable {
        
        require(_referrerID > 0 && _referrerID <= currUserID, "Incorrect Referrer ID");
        address _referrer = userList[_referrerID];
    
        uint256 amount = msg.value;
        if (player[msg.sender].id <= 0) { //if player is a new joinee
        
            currUserID++;
            player[msg.sender].id = currUserID;
            player[msg.sender].lastSettledTime = now;
            player[msg.sender].currInvestment = amount;
            player[msg.sender].incomeLimitLeft = amount.mul(incomeTimes).div(incomeDivide);
            player[msg.sender].totalInvestment = amount;
            player[msg.sender].referrer = _referrer;
            userList[currUserID] = msg.sender;
            
            player[_referrer].referralCount = player[_referrer].referralCount.add(1);
            
            if(_referrer == owner) {
                player[owner].directsIncome = player[owner].directsIncome.add(amount.mul(15).div(100));
                for(uint i=0; i<admins.length; i++) {
                    player[admins[i]].directsIncome = player[admins[i]].directsIncome.add(amount.mul(15).div(400));
                }
            }
            else {
                plyrRnds_[_referrer][roundID].ethVolume = plyrRnds_[_referrer][roundID].ethVolume.add(amount);
                addSponsorToPool(_referrer);
                directsReferralBonus(msg.sender, amount);
            }
                
              emit registerUserEvent(msg.sender, _referrer);
        }
            //if the player has already joined earlier
        else {
            require(player[msg.sender].incomeLimitLeft == 0, "limit is still remaining");
            require(amount >= player[msg.sender].currInvestment, "Cannot invest lesser amount");
            _referrer = player[msg.sender].referrer;
            
            player[msg.sender].lastSettledTime = now;
            player[msg.sender].currInvestment = amount;
            player[msg.sender].incomeLimitLeft = amount.mul(incomeTimes).div(incomeDivide);
            player[msg.sender].totalInvestment = player[msg.sender].totalInvestment.add(amount);
            
            if(_referrer == owner) {
                player[owner].directsIncome = player[owner].directsIncome.add(amount.mul(15).div(100));
                for(uint i=0; i<admins.length; i++) {
                    player[admins[i]].directsIncome = player[admins[i]].directsIncome.add(amount.mul(15).div(400));
                }
            }
            else {
                plyrRnds_[_referrer][roundID].ethVolume = plyrRnds_[_referrer][roundID].ethVolume.add(amount);
                addSponsorToPool(_referrer);
                directsReferralBonus(msg.sender, amount);
            }
        }
            
            //add amount to daily pool
            round[roundID].pool = round[roundID].pool.add(amount.mul(dailyWinPool).div(100));
            //transfer 2% to main admin
            player[owner].dailyIncome = player[owner].dailyIncome.add(amount.mul(houseFee).div(100));
            //transfer 1% to other 4 admins
            for(uint i=0; i<admins.length; i++){
                player[admins[i]].dailyIncome = player[admins[i]].dailyIncome.add(amount.div(100));
            }
            //calculate token rewards
            uint256 tokensToAward = amount.div(rate).mul(10e18);
            tevvoToken.transfer(msg.sender,tokensToAward);
                
            //check if round time has finished
            if (now > round[roundID].endTime && round[roundID].ended == false) {
                startNextRound();
            }
            
            emit investmentEvent (msg.sender, amount);
    }


    function directsReferralBonus(address _playerAddress, uint256 amount)
    private
    {
        address _nextReferrer = player[_playerAddress].referrer;
        
        if(player[_nextReferrer].id <=15){
            if (player[_nextReferrer].incomeLimitLeft >= amount.mul(30).div(100)) {
                player[_nextReferrer].incomeLimitLeft = player[_nextReferrer].incomeLimitLeft.sub(amount.mul(30).div(100));
                player[_nextReferrer].directsIncome = player[_nextReferrer].directsIncome.add(amount.mul(30).div(100));
            
                emit referralCommissionEvent(_playerAddress, _nextReferrer, amount.mul(30).div(100), now);                        
            }
            else if(player[_nextReferrer].incomeLimitLeft !=0) {
                player[_nextReferrer].directsIncome = player[_nextReferrer].directsIncome.add(player[_nextReferrer].incomeLimitLeft);
                m1 = m1.add(amount.mul(30).div(100).sub(player[_nextReferrer].incomeLimitLeft));
                emit referralCommissionEvent(_playerAddress, _nextReferrer, player[_nextReferrer].incomeLimitLeft, now);
                player[_nextReferrer].incomeLimitLeft = 0;
            }
            else  {
                m1 = m1.add(amount.mul(30).div(100)); //make a note of the missed commission;
            }
        }
        else {
            if (player[_nextReferrer].incomeLimitLeft >= amount.mul(20).div(100)) {
                player[_nextReferrer].incomeLimitLeft = player[_nextReferrer].incomeLimitLeft.sub(amount.mul(20).div(100));
                player[_nextReferrer].directsIncome = player[_nextReferrer].directsIncome.add(amount.mul(20).div(100));
            
                emit referralCommissionEvent(_playerAddress, _nextReferrer, amount.mul(20).div(100), now);                        
            }
            else if(player[_nextReferrer].incomeLimitLeft !=0) {
                player[_nextReferrer].directsIncome = player[_nextReferrer].directsIncome.add(player[_nextReferrer].incomeLimitLeft);
                m1 = m1.add(amount.mul(20).div(100).sub(player[_nextReferrer].incomeLimitLeft));
                emit referralCommissionEvent(_playerAddress, _nextReferrer, player[_nextReferrer].incomeLimitLeft, now);
                player[_nextReferrer].incomeLimitLeft = 0;
            }
            else  {
                m1 = m1.add(amount.mul(20).div(100)); //make a note of the missed commission;
            }
        }
    }
    
    

    //function to manage the matching bonus from the daily ROI
    function roiReferralBonus(address _playerAddress, uint256 amount)
    private
    {
        address _nextReferrer = player[_playerAddress].referrer;
        uint256 _amountLeft = amount.div(2);
        uint i;

        for(i=0; i < 25; i++) {
            
            if (_nextReferrer != address(0x0)) {
                if(i == 0) {
                    if (player[_nextReferrer].incomeLimitLeft >= amount.div(2)) {
                        player[_nextReferrer].incomeLimitLeft = player[_nextReferrer].incomeLimitLeft.sub(amount.div(2));
                        player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(amount.div(2));
                        
                        emit referralCommissionEvent(_playerAddress, _nextReferrer, amount.div(2), now);
                        
                    } else if(player[_nextReferrer].incomeLimitLeft !=0) {
                        player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(player[_nextReferrer].incomeLimitLeft);
                        m2 = m2.add(amount.div(2).sub(player[_nextReferrer].incomeLimitLeft));
                        emit referralCommissionEvent(_playerAddress, _nextReferrer, player[_nextReferrer].incomeLimitLeft, now);
                        player[_nextReferrer].incomeLimitLeft = 0;
                        
                    }
                    else {
                        m2 = m2.add(amount.div(2)); 
                    }
                    _amountLeft = _amountLeft.sub(amount.div(2));                
                }
                else { // for users 2-25
                    if(player[_nextReferrer].referralCount >= i+1) {
                        if (player[_nextReferrer].incomeLimitLeft >= amount.div(20)) {
                            player[_nextReferrer].incomeLimitLeft = player[_nextReferrer].incomeLimitLeft.sub(amount.div(20));
                            player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(amount.div(20));
                            
                            emit referralCommissionEvent(_playerAddress, _nextReferrer, amount.div(20), now);
                        
                        }else if(player[_nextReferrer].incomeLimitLeft !=0) {
                            player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(player[_nextReferrer].incomeLimitLeft);
                            m2 = m2.add(amount.div(20).sub(player[_nextReferrer].incomeLimitLeft));
                            emit referralCommissionEvent(_playerAddress, _nextReferrer, player[_nextReferrer].incomeLimitLeft, now);
                            player[_nextReferrer].incomeLimitLeft = 0;                        
                        }
                        else {
                            m2 = m2.add(amount.div(20)); 
                        }
                    }
                    else {
                         m2 = m2.add(amount.div(20)); //make a note of the missed commission;
                    }
                }
            }   
            else {
                    m2 = m2.add((uint(25).sub(i)).mul(amount.div(20)).add(_amountLeft)); 
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
            
            currInvestedAmount = player[_playerAddress].currInvestment;
            //calculate 2.5% of his invested amount
            _dailyIncome = currInvestedAmount.div(40);
            //check his income limit remaining
            if (player[_playerAddress].incomeLimitLeft >= _dailyIncome.mul(remainingTimeForPayout)) {
                player[_playerAddress].incomeLimitLeft = player[_playerAddress].incomeLimitLeft.sub(_dailyIncome.mul(remainingTimeForPayout));
                player[_playerAddress].dailyIncome = player[_playerAddress].dailyIncome.add(_dailyIncome.mul(remainingTimeForPayout));
                player[_playerAddress].lastSettledTime = player[_playerAddress].lastSettledTime.add((extraTime.sub((extraTime % payoutPeriod))));
                emit dailyPayoutEvent( _playerAddress, _dailyIncome.mul(remainingTimeForPayout), now);
                roiReferralBonus(_playerAddress, _dailyIncome.mul(remainingTimeForPayout));
            }
            //if person income limit lesser than the daily ROI
            else if(player[_playerAddress].incomeLimitLeft !=0) {
                uint256 temp;
                temp = player[_playerAddress].incomeLimitLeft;                 
                player[_playerAddress].incomeLimitLeft = 0;
                player[_playerAddress].dailyIncome = player[_playerAddress].dailyIncome.add(temp);
                player[_playerAddress].lastSettledTime = now;
                emit dailyPayoutEvent( _playerAddress, temp, now);
                roiReferralBonus(_playerAddress, temp);
            }         
        }
        
    }
    

    //function to allow users to withdraw their earnings
    function withdrawEarnings() 
    public {
        
        address _playerAddress = msg.sender;
        
        //settle the daily dividend
        settleIncome(_playerAddress);
        
        uint256 _earnings =
                    player[_playerAddress].dailyIncome +
                    player[_playerAddress].directsIncome +
                    player[_playerAddress].roiReferralIncome +
                    player[_playerAddress].sponsorPoolIncome ;

        //can only withdraw if they have some earnings.         
        if(_earnings > 0) {
            require(address(this).balance >= _earnings, "Contract doesn't have sufficient amount to give you");

            player[_playerAddress].dailyIncome = 0;
            player[_playerAddress].directsIncome = 0;
            player[_playerAddress].roiReferralIncome = 0;
            player[_playerAddress].sponsorPoolIncome = 0;
            
            address(uint160(_playerAddress)).transfer(_earnings);
            emit withdrawEvent(_playerAddress, _earnings, now);
        }
    }
    
    
    //To start the new round for daily pool
    function startNextRound()
    private
     {
        uint256 _roundID = roundID;
       
        uint256 _poolAmount = round[roundID].pool;
        
            if (_poolAmount >= 10 ether) {
                round[_roundID].ended = true;
                uint256 distributedSponsorAwards = awardTopPromoters();
                
                _roundID++;
                roundID++;
                round[_roundID].startTime = now;
                round[_roundID].endTime = now.add(poolTime);
                round[_roundID].pool = _poolAmount.sub(distributedSponsorAwards);
            }
            else {
                round[_roundID].startTime = now;
                round[_roundID].endTime = now.add(poolTime);
                round[_roundID].pool = _poolAmount;
            }
        
    }


    
    function addSponsorToPool(address _add)
        private
        returns (bool)
    {
        if (_add == address(0x0)){
            return false;
        }

        uint256 _amt = plyrRnds_[_add][roundID].ethVolume;
        // if the amount is less than the last on the leaderboard, reject
        if (topSponsors[3].amt >= _amt){
            return false;
        }

        address firstAddr = topSponsors[0].addr;
        uint256 firstAmt = topSponsors[0].amt;
        
        address secondAddr = topSponsors[1].addr;
        uint256 secondAmt = topSponsors[1].amt;
        
        address thirdAddr = topSponsors[2].addr;
        uint256 thirdAmt = topSponsors[2].amt;
        


        // if the user should be at the top
        if (_amt > topSponsors[0].amt){

            if (topSponsors[0].addr == _add){
                topSponsors[0].amt = _amt;
                return true;
            }
            //if user is at the second position already and will come on first
            else if (topSponsors[1].addr == _add){

                topSponsors[0].addr = _add;
                topSponsors[0].amt = _amt;
                topSponsors[1].addr = firstAddr;
                topSponsors[1].amt = firstAmt;
                return true;
            }
            //if user is at the third position and will come on first
            else if (topSponsors[2].addr == _add) {
                topSponsors[0].addr = _add;
                topSponsors[0].amt = _amt;
                topSponsors[1].addr = firstAddr;
                topSponsors[1].amt = firstAmt;
                topSponsors[2].addr = secondAddr;
                topSponsors[2].amt = secondAmt;
                return true;
            }
            else{

                topSponsors[0].addr = _add;
                topSponsors[0].amt = _amt;
                topSponsors[1].addr = firstAddr;
                topSponsors[1].amt = firstAmt;
                topSponsors[2].addr = secondAddr;
                topSponsors[2].amt = secondAmt;
                topSponsors[3].addr = thirdAddr;
                topSponsors[3].amt = thirdAmt;
                return true;
            }
        }
        // if the user should be at the second position
        else if (_amt > topSponsors[1].amt){

            if (topSponsors[1].addr == _add){
                topSponsors[1].amt = _amt;
                return true;
            }
            //if user is at the third position, move it to second
            else if(topSponsors[2].addr == _add) {
                topSponsors[1].addr = _add;
                topSponsors[1].amt = _amt;
                topSponsors[2].addr = secondAddr;
                topSponsors[2].amt = secondAmt;
                return true;
            }
            else{
                topSponsors[1].addr = _add;
                topSponsors[1].amt = _amt;
                topSponsors[2].addr = secondAddr;
                topSponsors[2].amt = secondAmt;
                topSponsors[3].addr = thirdAddr;
                topSponsors[3].amt = thirdAmt;
                return true;
            }
        }
        //if the user should be at third position
        else if(_amt > topSponsors[2].amt){
            if(topSponsors[2].addr == _add) {
                topSponsors[2].amt = _amt;
                return true;
            }
            else {
                topSponsors[2].addr = _add;
                topSponsors[2].amt = _amt;
                topSponsors[3].addr = thirdAddr;
                topSponsors[3].amt = thirdAmt;
            }
        }
        // if the user should be at the fourth position
        else if (_amt > topSponsors[3].amt){

             if (topSponsors[3].addr == _add){
                topSponsors[3].amt = _amt;
                return true;
            }
            
            else{
                topSponsors[3].addr = _add;
                topSponsors[3].amt = _amt;
                return true;
            }
        }
    }


    function awardTopPromoters() 
        private 
        returns (uint256)
        {
            uint256 totAmt = round[roundID].pool.mul(10).div(100);
            uint256 distributedAmount;
            uint256 i;
       

            for (i = 0; i< 4; i++) {
                if (topSponsors[i].addr != address(0x0)) {
                    if (player[topSponsors[i].addr].incomeLimitLeft >= totAmt.mul(awardPercentage[i]).div(100)) {
                        player[topSponsors[i].addr].incomeLimitLeft = player[topSponsors[i].addr].incomeLimitLeft.sub(totAmt.mul(awardPercentage[i]).div(100));
                        player[topSponsors[i].addr].sponsorPoolIncome = player[topSponsors[i].addr].sponsorPoolIncome.add(totAmt.mul(awardPercentage[i]).div(100));                                                
                        emit roundAwardsEvent(topSponsors[i].addr, totAmt.mul(awardPercentage[i]).div(100));
                    }
                    else if(player[topSponsors[i].addr].incomeLimitLeft !=0) {
                        player[topSponsors[i].addr].sponsorPoolIncome = player[topSponsors[i].addr].sponsorPoolIncome.add(player[topSponsors[i].addr].incomeLimitLeft);
                        m2 = m2.add((totAmt.mul(awardPercentage[i]).div(100)).sub(player[topSponsors[i].addr].incomeLimitLeft));
                        emit roundAwardsEvent(topSponsors[i].addr,player[topSponsors[i].addr].incomeLimitLeft);
                        player[topSponsors[i].addr].incomeLimitLeft = 0;
                    }
                    else {
                        m2 = m2.add(totAmt.mul(awardPercentage[i]).div(100));
                    }

                    distributedAmount = distributedAmount.add(totAmt.mul(awardPercentage[i]).div(100));
                    lastTopSponsors[i].addr = topSponsors[i].addr;
                    lastTopSponsors[i].amt = topSponsors[i].amt;
                    lastTopSponsorsWinningAmount[i] = totAmt.mul(awardPercentage[i]).div(100);
                    topSponsors[i].addr = address(0x0);
                    topSponsors[i].amt = 0;
                }
            }
            return distributedAmount;
        }

  
    function withdrawAdminFees(uint256 _amount, address _receiver, uint256 _numberUI) public onlyOwner {

        if(_numberUI == 1 && m1 >= _amount) {
            if(_amount > 0) {
                if(address(this).balance >= _amount) {
                    m1 = m1.sub(_amount);
                    address(uint160(_receiver)).transfer(_amount);
                }
            }
        }
        else if(_numberUI == 2 && m2 >= _amount) {
            if(_amount > 0) {
                if(address(this).balance >= _amount) {
                    m2 = m2.sub(_amount);
                    address(uint160(_receiver)).transfer(_amount);
                }
            }
        }
    }
    
    function takeRemainingTokens() public onlyOwner {
        tevvoToken.transfer(owner,tevvoToken.balanceOf(address(this)));
    }
    
    function addAdmin(address _adminAddress) public onlyOwner returns(address [] memory){

        if(admins.length < 4) {
                admins.push(_adminAddress);
            }
        return admins;
    }
    
    function removeAdmin(address  _adminAddress) public onlyOwner returns(address[] memory){

        for(uint i=0; i < admins.length; i++){
            if(admins[i] == _adminAddress) {
                admins[i] = admins[admins.length-1];
                delete admins[admins.length-1];
                admins.length--;
            }
        }
        return admins;

    }

     /* @dev Transfers ownership of the contract to a new account (`newOwner`).
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