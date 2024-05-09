pragma solidity ^0.5.8;


/**
 * EthPrime - ethprime.io
 * 
 * A defi dapp ecosystem which simplifies and automates the process of playing eth dapps/games by bundling them into a "portfolio/fund"
 * 
 */


contract EthPrime {
    
    LoyaltyScheme loyalty = LoyaltyScheme(0x0);
    UniswapPriceGuard uniswapPriceGuard = UniswapPriceGuard(0x0);

    Subscription[] public activeSubscriptions;
    mapping(address => bool) public subscriptionLoanable;
    
    mapping(address => address payable[]) public userSubscriptionsList;
    mapping(address => mapping(address => bool)) public userSubscriptions;
    mapping(address => Streak) public reinvestStreaks;
    mapping(address => Approval) public pendingDapps;
    mapping(address => uint256) public ethLoaned;
    
    FundPaymentHandler paymentHandler = FundPaymentHandler(0x4f50cAAEA490A5B939ad291d0567093E89649872);
    
    uint256 totalWeighting = 0; // Updates every time subscription is added/removed
    address payable owner = msg.sender;
    
    uint256 fundFee = 10; // 1% on launch, reducing over time
    uint256 loansFee = 50; // 5% (of earnt divs)
    uint256 public newDappDelay;
    
    uint256 platformFees;
    uint256 loanDivs;
    
    struct Subscription {
        address payable dapp;
        uint128 weighting;
        bool requiresFunds;
    }
    
    struct Approval {
        address payable dapp;
        uint128 weighting;
        uint128 delayTimestamp;
        bool requiresFunds;
        bool loanable;
    }
    
    struct Streak {
        uint128 currentStreak;
        uint128 lastReinvestWeek;
    }
    
    event Deposit(address player, address ref, uint256 tron);
    event Cashout(address player, address ref, uint256 tron);
    event Reinvest(address player, address ref, uint256 tron);
    event Withdraw(address player, uint256 tron);
    event Borrow(address player, uint256 tron);
    event Payback(address player, uint256 tron);
    
    function() external payable { }
    
    function reduceFundFee(uint256 newFundFee) external {
        require(msg.sender == owner);
        require(newFundFee < fundFee);
        fundFee = newFundFee;
    }
    
    function withdrawPlatformFees(uint256 amount) external {
        require(msg.sender == owner);
        require(amount <= platformFees);
        platformFees -= amount;
        owner.transfer(amount);
    }
    
    function withdrawLoanDivs(uint256 amount) external {
        require(msg.sender == owner);
        require(amount <= loanDivs);
        loanDivs -= amount;
        owner.transfer(amount);
    }
    
    function updateDappDelay(uint256 newDelay) external {
        require(msg.sender == owner);
        require(newDelay >= 3 days);
        newDappDelay = newDelay;
    }
    
    function updateLoansFee(uint256 newLoansFee) external {
        require(msg.sender == owner);
        require(newLoansFee <= 200); // 20%
        loansFee = newLoansFee;
    }
    
    function updateLoyaltyContract(address loyaltyAddress) external {
        require(msg.sender == owner);
        loyalty = LoyaltyScheme(loyaltyAddress);
    }
    
    function updateUniswapPriceGuard(address guardAddress) external {
        require(msg.sender == owner);
        uniswapPriceGuard = UniswapPriceGuard(guardAddress);
    }
    
    function updateLoanable(address dapp, bool loanable) external {
        require(msg.sender == owner);
        subscriptionLoanable[dapp] = loanable;
    }
    
    function addSubscription(address dappAddress, uint128 dappWeighting, bool requiresFunds, bool loanable) external {
        require(msg.sender == owner); 
        require(dappWeighting > 0);
        require(dappWeighting < 1000);
        
        // If existing then update subscription weighting
        for (uint256 i = 0; i < activeSubscriptions.length; i++) {
            Subscription storage existing = activeSubscriptions[i];
            if (existing.dapp == dappAddress) {
                if (dappWeighting > existing.weighting) {
                    totalWeighting += (dappWeighting - existing.weighting);
                } else if (dappWeighting < existing.weighting) {
                    totalWeighting -= (existing.weighting - dappWeighting);
                }
                existing.weighting = dappWeighting;
                return;
            }
        }

        // Otherwise add new subscription after newDappDelay
        pendingDapps[dappAddress] = Approval(address(uint160(dappAddress)), dappWeighting, uint128(now + newDappDelay), requiresFunds, loanable);
    }
    
    function addPendingSubscription(address dappAddress) external {
        require(msg.sender == owner);
        Approval memory approval = pendingDapps[dappAddress];
        require(now > approval.delayTimestamp);
        activeSubscriptions.push(Subscription(approval.dapp, approval.weighting, approval.requiresFunds));
        subscriptionLoanable[approval.dapp] = approval.loanable;
        totalWeighting += approval.weighting;
        delete pendingDapps[dappAddress];
    }
    
    function removeSubscription(address dappAddress) external {
        require(msg.sender == owner);
        
        for (uint256 i = 0; i < activeSubscriptions.length; i++) {
            Subscription memory existing = activeSubscriptions[i];
            if (existing.dapp == dappAddress) {
                totalWeighting -= existing.weighting;
                
                // Remove subscription (and shift all subscriptions left one position) 
                uint256 length = activeSubscriptions.length - 1;
                for (uint j = i; j < length; j++){
                    activeSubscriptions[j] = activeSubscriptions[j+1]; 
                }
                activeSubscriptions.length--;
                return;
            }
        }
    }
    
    function deposit(address referrer, address[] calldata pathPairs, uint256[] calldata minOuts) external payable {
        require(msg.value > 0.199 ether);
        require(uniswapPriceGuard.overPriceFloorValue(pathPairs, minOuts));
        depositInternal(msg.value, msg.sender, referrer, false);
        emit Deposit(msg.sender, referrer, msg.value);
    }
    
    function depositFor(address player, address referrer, address[] calldata pathPairs, uint256[] calldata minOuts) external payable {
        require(msg.value > 0.199 ether);
        require(uniswapPriceGuard.overPriceFloorValue(pathPairs, minOuts));
        depositInternal(msg.value, player, referrer, false);
        emit Deposit(player, referrer, msg.value);
    }
    
    function depositInternal(uint256 ethDeposit, address player, address referrer, bool alreadyClaimedDivs) internal {
        if (now < 1592866800) {
            player = owner; // Before launch time no-one can deposit
        } else if (now < 1592867100) {
            require(ethDeposit <= 50 ether && tx.gasprice <= 0.1 szabo); // For first 5 mins max buy is 50 eth & 100 gwei
        }
        
        if (fundFee > 0) {
            uint256 fee = (ethDeposit * fundFee) / 1000;
            ethDeposit -= fee;
            platformFees += fee;
        }
        
        uint256 subscriptions = activeSubscriptions.length;
        uint256 remainingWeighting = totalWeighting;
        for (uint256 i = 0; i < subscriptions; i++) {
            if (remainingWeighting == 0) {
                break;
            }
            
            Subscription memory subscription = activeSubscriptions[i];
            SubscriptionDapp dapp = SubscriptionDapp(subscription.dapp);
            uint256 maxDeposit = (ethDeposit * subscription.weighting) / remainingWeighting;
            
            uint256 deposited;
            if (subscription.requiresFunds) {
                deposited = maxDeposit;
            }
            (bool success, bytes memory returnData) = address(dapp).call.value(deposited)(abi.encodePacked(dapp.deposit.selector, abi.encode(player, maxDeposit, referrer, alreadyClaimedDivs)));
            
            if (success) {
                deposited = abi.decode(returnData, (uint256));
            }
            
            require(deposited <= maxDeposit);
            if (deposited > 0) {
                ethDeposit -= deposited;
                if (!userSubscriptions[player][subscription.dapp]) {
                    userSubscriptions[player][subscription.dapp] = true;
                    userSubscriptionsList[player].push(subscription.dapp);
                }
            }
            remainingWeighting -= subscription.weighting;
        }
    }
    
    function cashout(address referrer, uint256 percent, address[] calldata pathPairs, uint256[] calldata minOuts) external {
        require(percent > 0 && percent < 101);
        require(uniswapPriceGuard.overPriceFloorValue(pathPairs, minOuts));
        require(ethLoaned[msg.sender] == 0);
        
        uint256 ethGained;
        uint256 length = userSubscriptionsList[msg.sender].length;
        for (uint256 i = 0; i < length; i++) {
            SubscriptionDapp dapp = SubscriptionDapp(userSubscriptionsList[msg.sender][i]);
            (bool success, bytes memory returnData) = address(dapp).call(abi.encodePacked(dapp.cashout.selector, abi.encode(msg.sender, referrer, percent)));
            if (success) {
                ethGained += abi.decode(returnData, (uint256));
            }
            
        }
        paymentHandler.cashout.value(ethGained)(msg.sender);
        reinvestStreaks[msg.sender] = Streak(0, weeksSinceEpoch());
        
        emit Cashout(msg.sender, referrer, ethGained);
    }
    
    function claimDivs() public {
        uint256 ethGained = claimDivsInternal(msg.sender);
        paymentHandler.cashout.value(ethGained)(msg.sender);
        reinvestStreaks[msg.sender] = Streak(0, weeksSinceEpoch());
        emit Withdraw(msg.sender, ethGained);
    }
    
    function claimDivsInternal(address player) internal returns (uint256) {
        uint256 ethGained;
        uint256 length = userSubscriptionsList[player].length;
        for (uint256 i = 0; i < length; i++) {
            SubscriptionDapp dapp = SubscriptionDapp(userSubscriptionsList[player][i]);
            (bool success, bytes memory returnData) = address(dapp).call(abi.encodePacked(dapp.claimDivs.selector, abi.encode(player)));
            if (success) {
                ethGained += abi.decode(returnData, (uint256));
            }
        }
        
        if (ethLoaned[player] > 0) {
            uint256 fee = ethGained * loansFee / 1000;
            ethGained -= fee;
            loanDivs += fee;
        }
        
        return ethGained;
    }
    
    function reinvest(address referrer, address[] calldata pathPairs, uint256[] calldata minOuts) external {
        require(uniswapPriceGuard.overPriceFloorValue(pathPairs, minOuts));
        reinvestInternal(msg.sender, referrer, 100);
    }
    
    function reinvestInternal(address player, address referrer, uint256 percent) internal {
        uint256 ethGained = claimDivsInternal(player);
        uint256 reinvestPortion = (ethGained * percent) / 100;
        if (percent < 100) {
            paymentHandler.cashout.value(ethGained - reinvestPortion)(player);
            emit Withdraw(player, ethGained - reinvestPortion);
        }
        paymentHandler.reinvest.value(reinvestPortion)(address(this));
        depositInternal(reinvestPortion, player, referrer, true);
        
        // Streak stuff
        Streak memory streak = reinvestStreaks[player];
        uint128 epochWeek = weeksSinceEpoch();
        if (streak.lastReinvestWeek + 1 == epochWeek) {
            streak.currentStreak++;
        } else if (streak.lastReinvestWeek < epochWeek || streak.currentStreak == 0) {
            streak.currentStreak = 1;
        }

        streak.lastReinvestWeek = epochWeek;
        reinvestStreaks[player] = streak;
        
        emit Reinvest(player, referrer, reinvestPortion);
    }
    
    function drawEth(uint256 amount) external {
        uint256 ethValue = loanableValueInternal(msg.sender);
        uint256 maxLoanPercent = loyalty.getLoanPercentMax(msg.sender);
        require(maxLoanPercent < 80);
        uint256 maxLoan = (ethValue * maxLoanPercent) / 100;
        require(amount <= maxLoan);
        require(ethLoaned[msg.sender] + amount <= maxLoan);
        ethLoaned[msg.sender] += amount;
        msg.sender.transfer(amount);
        emit Borrow(msg.sender, amount);
    }
    
    function cashoutPayLoan(address referrer, uint256 percent, address[] calldata pathPairs, uint256[] calldata minOuts) external {
        uint256 existing = ethLoaned[msg.sender];
        require(existing > 0);
        require(percent > 0 && percent < 101);
        require(uniswapPriceGuard.overPriceFloorValue(pathPairs, minOuts));
        
        uint256 ethGained;
        uint256 length = userSubscriptionsList[msg.sender].length;
        for (uint256 i = 0; i < length; i++) {
            SubscriptionDapp dapp = SubscriptionDapp(userSubscriptionsList[msg.sender][i]);
            (bool success, bytes memory returnData) = address(dapp).call(abi.encodePacked(dapp.cashout.selector, abi.encode(msg.sender, referrer, percent)));
            if (success) {
                ethGained += abi.decode(returnData, (uint256));
            }
            
        }
        
        emit Cashout(msg.sender, referrer, ethGained);
        
        if (ethGained > existing) {
            msg.sender.transfer(ethGained - existing);
            ethGained = existing;
        }
        ethLoaned[msg.sender] -= ethGained;
        reinvestStreaks[msg.sender] = Streak(0, weeksSinceEpoch());
    }
    
    function paybackEthWithDivs() public {
        uint256 existing = ethLoaned[msg.sender];
        require(existing > 0);
        
        uint256 ethGained = claimDivsInternal(msg.sender);
        emit Payback(msg.sender, ethGained);
        
        if (ethGained > existing) {
            msg.sender.transfer(ethGained - existing);
            ethGained = existing;
        }
        ethLoaned[msg.sender] -= ethGained;
    }
    
    function paybackEth() external payable {
        claimDivs();
        uint256 amount = msg.value;
        uint256 existing = ethLoaned[msg.sender];
        if (amount > existing) {
            msg.sender.transfer(amount - existing);
            amount = existing;
        }
        ethLoaned[msg.sender] -= amount;
        emit Payback(msg.sender, amount);
    }
    
    function weeksSinceEpoch() public view returns(uint128) {
        return uint128((now - 259200) / 604800);
    }
    
    function totalDivsInternal(address player) internal returns (uint256) {
        uint256 length = userSubscriptionsList[player].length;
        
        uint256 ethDivs;
        for (uint256 i = 0; i < length; i++) {
            SubscriptionDapp dapp = SubscriptionDapp(userSubscriptionsList[player][i]);
            (bool success, bytes memory returnData) = address(dapp).call(abi.encodePacked(dapp.currentDivs.selector, abi.encode(player)));
            if (success) {
                ethDivs += abi.decode(returnData, (uint256));
            }
        }
        
        return ethDivs;
    }
    
    function totalDivs(address player) external view returns (uint256) {
        uint256 length = userSubscriptionsList[player].length;
        
        uint256 ethDivs;
        for (uint256 i = 0; i < length; i++) {
            ethDivs += SubscriptionDapp(userSubscriptionsList[player][i]).currentDivs(player);
        }
        
        return ethDivs;
    }
    
    function accountValue(address player, bool includeFees) external view returns(uint256) {
        uint256 length = userSubscriptionsList[player].length;
        
        uint256 ethValue;
        for (uint256 i = 0; i < length; i++) {
            ethValue += SubscriptionDapp(userSubscriptionsList[player][i]).currentValue(player, includeFees);
        }
        
        return ethValue;
    }
    
    function loanableValueInternal(address player) internal returns(uint256) {
        uint256 length = userSubscriptionsList[player].length;
        
        uint256 ethValue;
        for (uint256 i = 0; i < length; i++) {
            if (subscriptionLoanable[userSubscriptionsList[player][i]]) { // If whitelisted
                SubscriptionDapp dapp = SubscriptionDapp(userSubscriptionsList[player][i]);
                (bool success, bytes memory returnData) = address(dapp).call(abi.encodePacked(dapp.currentValue.selector, abi.encode(player, false)));
                if (success) {
                    ethValue += abi.decode(returnData, (uint256));
                }
            }
        }
        return ethValue;
    }
    
    function loanableValue(address player) external view returns(uint256) {
        uint256 length = userSubscriptionsList[player].length;
        
        uint256 ethValue;
        for (uint256 i = 0; i < length; i++) {
            if (subscriptionLoanable[userSubscriptionsList[player][i]]) { // If whitelisted
                ethValue += SubscriptionDapp(userSubscriptionsList[player][i]).currentValue(player, false);
            }
        }
        return ethValue;
    }
    
    function accountSubscriptions(address player) external view returns (uint256) {
        return userSubscriptionsList[player].length;
    }
}








interface SubscriptionDapp {
    function deposit(address player, uint256 amount, address referrer, bool alreadyClaimedDivs) external payable returns (uint256);
    function cashout(address player, address referrer, uint256 percent) external returns (uint256);
    function claimDivs(address player) external returns (uint256);
    function currentValue(address player, bool removeFees) external view returns(uint256);
    function currentDivs(address player) external view returns(uint256);
    function() external payable;
}


interface FundPaymentHandler {
    function cashout(address player) external payable;
    function reinvest(address player) external payable;
}


interface UniswapPriceGuard {
    function overPriceFloorValue(address[] calldata pathPairs, uint256[] calldata minOuts) external returns(bool);
}


interface LoyaltyScheme {
    function getLoanPercentMax(address player) external view returns (uint256);
}



library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  /**
  * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}