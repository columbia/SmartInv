pragma solidity ^0.4.20;


contract Lottery{
  function lockTokens(address entrant,uint toLock) external;
  function contestOver() public view returns(bool);
}
contract TOKEN {
   function totalSupply() external view returns (uint256);
   function balanceOf(address account) external view returns (uint256);
   function transfer(address recipient, uint256 amount) external returns (bool);
   function allowance(address owner, address spender) external view returns (uint256);
   function approve(address spender, uint256 amount) external returns (bool);
   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}
contract Spooky {
    /*=================================
    =            MODIFIERS            =
    =================================*/
    // only people with tokens
    modifier onlyBagholders() {
        require(myTokens() > 0);
        _;
    }

    // only people with profits
    modifier onlyStronghands() {
        require(myDividends(true) > 0);
        _;
    }

    // administrators can:
    // -> change the name of the contract
    // -> change the name of the token
    // -> change the PoS difficulty (How many tokens it costs to hold a masternode, in case it gets crazy high later)
    // they CANNOT:
    // -> take funds
    // -> disable withdrawals
    // -> kill the contract
    // -> change the price of tokens
    modifier onlyAdministrator(){
        require(administrators[msg.sender]);
        _;
    }


    // ensures that the first tokens in the contract will be equally distributed
    // meaning, no divine dump will be ever possible
    // result: healthy longevity.
    modifier antiEarlyWhale(uint256 _amountOfGhost){
        address _customerAddress = msg.sender;

        // are we still in the vulnerable phase?
        // if so, enact anti early whale protocol
        if( onlyAmbassadors && ((totalGhostBalance() - _amountOfGhost) <= ambassadorQuota_ )){
            require(
                // is the customer in the ambassador list?
                ambassadors_[_customerAddress] == true &&

                // does the customer purchase exceed the max ambassador quota?
                (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfGhost) <= ambassadorMaxPurchase_

            ,"early phase unsuccessful");

            // updated the accumulated quota
            ambassadorAccumulatedQuota_[_customerAddress] = SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfGhost);

            // execute
            _;
        } else {
            // in case the ether count drops low, the ambassador phase won't reinitiate
            onlyAmbassadors = false;
            _;
        }

    }


    /*==============================
    =            EVENTS            =
    ==============================*/
    event onTokenPurchase(
        address indexed customerAddress,
        uint256 incomingGhost,
        uint256 tokensMinted,
        address indexed referredBy
    );

    event onTokenSell(
        address indexed customerAddress,
        uint256 tokensBurned,
        uint256 ghostEarned
    );

    event onReinvestment(
        address indexed customerAddress,
        uint256 ghostReinvested,
        uint256 tokensMinted
    );

    event onWithdraw(
        address indexed customerAddress,
        uint256 ghostWithdrawn
    );

    // ERC20
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 tokens
    );


    /*=====================================
    =            CONFIGURABLES            =
    =====================================*/
    string public name = "Ghost Town";
    string public symbol = "GTS";
    uint8 constant public decimals = 18;
    //uint8 constant internal dividendFee_ = 10;
    uint256 internal entryFee_ = 13;
    uint256 internal exitFee_ = 13;
    uint256 internal lotteryFee_ = 30; //5%
    uint256 internal referralFee_ = 15; // 10% of the 10% buy or sell fees makes it 1%
    uint256 constant internal tokenPriceInitial_ = 0.0000001 ether;
    uint256 constant internal tokenPriceIncremental_ = 0.00000001 ether;
    uint256 constant internal magnitude = 2**64;

    // proof of stake (defaults at 100 tokens)
    uint256 public stakingRequirement = 0;//100e18;

    // ambassador program
    mapping(address => bool) internal ambassadors_;
    uint256 constant internal ambassadorMaxPurchase_ = 200 ether;
    uint256 constant internal ambassadorQuota_ = 2000 ether;



   /*================================
    =            DATASETS            =
    ================================*/
    // amount of shares for each address (scaled number)
    mapping(address => uint256) internal tokenBalanceLedger_;
    mapping(address => uint256) internal referralBalance_;
    mapping(address => address) public referralLocks_;//mandatory locked in referrals
    mapping(address => int256) internal payoutsTo_;
    mapping(address => uint256) internal ambassadorAccumulatedQuota_;
    uint256 internal tokenSupply_ = 0;
    uint256 internal profitPerShare_;

    // administrator list (see above on what they can do)
    mapping(address => bool) public administrators;

    // when this is set to true, only ambassadors can purchase tokens (this prevents a whale premine, it ensures a fairly distributed upper pyramid)
    bool public onlyAmbassadors = true;

    TOKEN erc20;

    //lottery related
    Lottery public lotteryContract;
    mapping(address => bool) public lotteryLocked;

    //view only referral data
    mapping(address => uint) public referralCount;
    mapping(address => uint) public feesFromReferral;

    /*=======================================
    =            PUBLIC FUNCTIONS            =
    =======================================*/
    /*
    * -- APPLICATION ENTRY POINTS --
    */
    constructor(address tokenaddr)
        public
    {
        // add administrators here
        administrators[0xaEbbd80Fd7dAe979d965A3a5b09bBCD23eB40e5F] = true;
        administrators[msg.sender]=true;

        // add the ambassadors here.
        ambassadors_[0xaEbbd80Fd7dAe979d965A3a5b09bBCD23eB40e5F] = true;
        ambassadors_[0x3dF3766E64C2C85Ce1baa858d2A14F96916d5087] = true;
        ambassadors_[0x8Cc62C4dCF129188ce4b43103eAefc0d6b71af6d] = true;
        ambassadors_[0xE7F53CE9421670AC2f11C5035E6f6f13d9829aa6] = true;
        ambassadors_[0x43678bB266e75F50Fbe5927128Ab51930b447eaB] = true;
        ambassadors_[0xf5C2CbD8207eE1f0C798C59Dcb27ccA46E1093ec] = true;
        ambassadors_[0xd0Ce592b78Cfc6D0EDa67c3ED6fF9994179e8060] = true;

        erc20 = TOKEN(tokenaddr);
    }

    /*
      New functions
    */
    function setLotteryAddress(address l) public onlyAdministrator{
      require(lotteryContract==address(0),"lottery contract already set");
      lotteryContract=Lottery(l);
    }
    /*
      enter the lottery, locking sells until it is concluded
    */
    function enterLottery() public {
      require(!ambassadors_[msg.sender],"ambassadors not eligible for lottery");
      require(!lotteryLocked[msg.sender],"already entered lottery");
      require(tokenBalanceLedger_[msg.sender]>0,"token balance is zero");
      require(!lotteryContract.contestOver(),"lottery over, cannot enter");
      lotteryLocked[msg.sender]=true;
      lotteryContract.lockTokens(msg.sender,tokenBalanceLedger_[msg.sender]);
    }
    function checkAndTransferGHOST(uint256 _amount) private {
        require(erc20.transferFrom(msg.sender, address(this), _amount) == true, "transfer must succeed");
    }

    /**
     * Converts all incoming ghost to tokens for the caller, and passes down the referral addy (if any)
     */
    function buy(uint _amount,address _referredBy)
        public
        returns(uint256)
    {
        checkAndTransferGHOST(_amount);
        purchaseTokens(_amount, _referredBy);
    }

    /**
     * Fallback function to handle ghost that was send straight to the contract
     */
    function()
        payable
        public
    {
        revert();
    }

    /**
     * Converts all of caller's dividends to tokens.
     */
    function reinvest()
        onlyStronghands()
        public
    {
        // fetch dividends
        uint256 _dividends = myDividends(false); // retrieve ref. bonus later in the code

        // pay out the dividends virtually
        address _customerAddress = msg.sender;
        payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);

        // retrieve ref. bonus
        _dividends += referralBalance_[_customerAddress];
        referralBalance_[_customerAddress] = 0;

        // dispatch a buy order with the virtualized "withdrawn dividends"
        uint256 _tokens = purchaseTokens(_dividends, 0x0);

        // fire event
        emit onReinvestment(_customerAddress, _dividends, _tokens);
    }

    /**
     * Alias of sell() and withdraw().
     */
    function exit()
        public
    {
        // get token count for caller & sell them all
        address _customerAddress = msg.sender;
        uint256 _tokens = tokenBalanceLedger_[_customerAddress];
        if(_tokens > 0) sell(_tokens);

        // lambo delivery service
        withdraw();
    }

    /**
     * Withdraws all of the callers earnings.
     */
    function withdraw()
        onlyStronghands()
        public
    {
        // setup data
        address _customerAddress = msg.sender;
        uint256 _dividends = myDividends(false); // get ref. bonus later in the code

        // update dividend tracker
        payoutsTo_[_customerAddress] +=  (int256) (_dividends * magnitude);

        // add ref. bonus
        _dividends += referralBalance_[_customerAddress];
        referralBalance_[_customerAddress] = 0;

        // send ghost
        erc20.transfer(_customerAddress, _dividends);

        // fire event
        emit onWithdraw(_customerAddress, _dividends);
    }

    /**
     * Liquifies tokens to ghost.
     */
    function sell(uint256 _amountOfTokens)
        onlyBagholders()
        public
    {
        //if user has staked their GT tokens, only allow them to sell after the raffle is concluded
        if(lotteryLocked[msg.sender]){
          require(lotteryContract.contestOver(),"locked for lottery but lottery not over");
        }
        // setup data
        address _customerAddress = msg.sender;
        // russian hackers BTFO
        require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
        uint256 _ghost = tokensToGhost_(_amountOfTokens);
        uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_ghost, exitFee_), 100);
        uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, referralFee_), 100);
        uint256 _lotteryFee = SafeMath.div(SafeMath.mul(_undividedDividends,lotteryFee_), 100);
        uint256 _dividends = SafeMath.sub(_undividedDividends, SafeMath.add(_referralBonus,_lotteryFee));
        uint256 _taxedGhost = SafeMath.sub(_ghost,_undividedDividends); //_dividends);

        //transfer lottery fee
        if(lotteryContract!=address(0))
        {
          erc20.transfer(lotteryContract,_lotteryFee);
        }
        //referral locking
        address _referredBy=0x0000000000000000000000000000000000000000;
        if(referralLocks_[msg.sender]!=0x0000000000000000000000000000000000000000){
          _referredBy=referralLocks_[msg.sender];
        }
        // is the user referred by a masternode?
        if(
            // is this a referred purchase?
            _referredBy != 0x0000000000000000000000000000000000000000 &&
            _referredBy != _customerAddress &&
            tokenBalanceLedger_[_referredBy] >= stakingRequirement
        ){
            referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
        } else {
            // no ref purchase
            // add the referral bonus back to the global dividends cake
            _dividends = SafeMath.add(_dividends, _referralBonus);
            //_fee = _dividends * magnitude;
        }

        // burn the sold tokens
        tokenSupply_ = SafeMath.sub(tokenSupply_, _amountOfTokens);
        tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);

        // update dividends tracker
        int256 _updatedPayouts = (int256) (profitPerShare_ * _amountOfTokens + (_taxedGhost * magnitude));
        payoutsTo_[_customerAddress] -= _updatedPayouts;

        // dividing by zero is a bad idea
        if (tokenSupply_ > 0) {
            // update the amount of dividends per token
            profitPerShare_ = SafeMath.add(profitPerShare_, (_dividends * magnitude) / tokenSupply_);
        }

        // fire event
        emit onTokenSell(_customerAddress, _amountOfTokens, _taxedGhost);
    }



    /*----------  ADMINISTRATOR ONLY FUNCTIONS  ----------*/
    /**
     * In case the amassador quota is not met, the administrator can manually disable the ambassador phase.
     */
    function disableInitialStage()
        onlyAdministrator()
        public
    {
        onlyAmbassadors = false;
    }

    /**
     * In case one of us dies, we need to replace ourselves.
     */
    function setAdministrator(address _identifier, bool _status)
        onlyAdministrator()
        public
    {
        administrators[_identifier] = _status;
    }

    /**
     * Precautionary measures in case we need to adjust the masternode rate.
     */
    function setStakingRequirement(uint256 _amountOfTokens)
        onlyAdministrator()
        public
    {
        stakingRequirement = _amountOfTokens;
    }

    /**
     * If we want to rebrand, we can.
     */
    function setName(string _name)
        onlyAdministrator()
        public
    {
        name = _name;
    }

    /**
     * If we want to rebrand, we can.
     */
    function setSymbol(string _symbol)
        onlyAdministrator()
        public
    {
        symbol = _symbol;
    }


    /*----------  HELPERS AND CALCULATORS  ----------*/
    /**
     * Method to view the current Ghost stored in the contract
     * Example: totalGhostBalance()
     */
    function totalGhostBalance()
        public
        view
        returns(uint)
    {
        return erc20.balanceOf(address(this));//this.balance;
    }

    /**
     * Retrieve the total token supply.
     */
    function totalSupply()
        public
        view
        returns(uint256)
    {
        return tokenSupply_;
    }

    /**
     * Retrieve the tokens owned by the caller.
     */
    function myTokens()
        public
        view
        returns(uint256)
    {
        address _customerAddress = msg.sender;
        return balanceOf(_customerAddress);
    }

    /**
     * Retrieve the dividends owned by the caller.
     * If `_includeReferralBonus` is to to 1/true, the referral bonus will be included in the calculations.
     * The reason for this, is that in the frontend, we will want to get the total divs (global + ref)
     * But in the internal calculations, we want them separate.
     */
    function myDividends(bool _includeReferralBonus)
        public
        view
        returns(uint256)
    {
        address _customerAddress = msg.sender;
        return _includeReferralBonus ? dividendsOf(_customerAddress) + referralBalance_[_customerAddress] : dividendsOf(_customerAddress) ;
    }

    /**
     * Retrieve the token balance of any single address.
     */
    function balanceOf(address _customerAddress)
        view
        public
        returns(uint256)
    {
        return tokenBalanceLedger_[_customerAddress];
    }

    /**
     * Retrieve the dividend balance of any single address.
     */
    function dividendsOf(address _customerAddress)
        view
        public
        returns(uint256)
    {
        return (uint256) ((int256)(profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - payoutsTo_[_customerAddress]) / magnitude;
    }

    /**
     * Return the buy price of 1 individual token.
     */
    function sellPrice()
        public
        view
        returns(uint256)
    {
        // our calculation relies on the token supply, so we need supply. Doh.
        if(tokenSupply_ == 0){
            return tokenPriceInitial_ - tokenPriceIncremental_;
        } else {
            uint256 _ghost = tokensToGhost_(1e18);
            uint256 _dividends = SafeMath.div(SafeMath.mul(_ghost, exitFee_ ),100 );
            uint256 _taxedGhost = SafeMath.sub(_ghost, _dividends);
            return _taxedGhost;
        }
    }

    /**
     * Return the sell price of 1 individual token.
     */
    function buyPrice()
        public
        view
        returns(uint256)
    {
        // our calculation relies on the token supply, so we need supply. Doh.
        if(tokenSupply_ == 0){
            return tokenPriceInitial_ + tokenPriceIncremental_;
        } else {
            uint256 _ghost = tokensToGhost_(1e18);
            uint256 _dividends = SafeMath.div(SafeMath.mul(_ghost, entryFee_ ),100 );
            uint256 _taxedGhost = SafeMath.add(_ghost, _dividends);
            return _taxedGhost;
        }
    }

    /**
     * Function for the frontend to dynamically retrieve the price scaling of buy orders.
     */
    function calculateTokensReceived(uint256 _ghostToSpend)
        public
        view
        returns(uint256)
    {
        uint256 _dividends = SafeMath.div(SafeMath.mul(_ghostToSpend, entryFee_),100);
        uint256 _taxedGhost = SafeMath.sub(_ghostToSpend, _dividends);
        uint256 _amountOfTokens = ghostToTokens_(_taxedGhost);

        return _amountOfTokens;
    }

    /**
     * Function for the frontend to dynamically retrieve the price scaling of sell orders.
     */
    function calculateGhostReceived(uint256 _tokensToSell)
        public
        view
        returns(uint256)
    {
        require(_tokensToSell <= tokenSupply_);
        uint256 _ghost = tokensToGhost_(_tokensToSell);
        uint256 _dividends = SafeMath.div(SafeMath.mul(_ghost, exitFee_),100);
        uint256 _taxedGhost = SafeMath.sub(_ghost, _dividends);
        return _taxedGhost;
    }


    /*==========================================
    =            INTERNAL FUNCTIONS            =
    ==========================================*/
    function purchaseTokens(uint256 _incomingGhost, address _referredBy)
        antiEarlyWhale(_incomingGhost)
        internal
        returns(uint256)
    {
        // data setup
        //address _customerAddress = msg.sender;
        uint256 _undividedDividends = SafeMath.div(SafeMath.mul(_incomingGhost, entryFee_),100);
        uint256 _referralBonus = SafeMath.div(SafeMath.mul(_undividedDividends, referralFee_),100);
        uint256 _lotteryFee = SafeMath.div(SafeMath.mul(_undividedDividends,lotteryFee_), 100);
        uint256 _dividends = SafeMath.sub(_undividedDividends, SafeMath.add(_lotteryFee,_referralBonus));
        uint256 _taxedGhost = SafeMath.sub(_incomingGhost, _undividedDividends);
        uint256 _amountOfTokens = ghostToTokens_(_taxedGhost);
        uint256 _fee = _dividends * magnitude;

        require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));

        //transfer lottery fee
        if(lotteryContract!=address(0))
        {
          erc20.transfer(lotteryContract,_lotteryFee);
        }
        //referral locking
        if(referralLocks_[msg.sender]==0x0000000000000000000000000000000000000000){
          referralLocks_[msg.sender]=_referredBy;
          referralCount[_referredBy]+=1;//view only, doesnt affect anything
        }
        else{
          _referredBy=referralLocks_[msg.sender];
        }
        // is the user referred by a masternode?
        if(
            // is this a referred purchase?
            _referredBy != 0x0000000000000000000000000000000000000000 &&
            _referredBy != msg.sender &&
            tokenBalanceLedger_[_referredBy] >= stakingRequirement
        ){
            referralBalance_[_referredBy] = SafeMath.add(referralBalance_[_referredBy], _referralBonus);
            feesFromReferral[_referredBy]+=_referralBonus;//view only, doesn't affect anything
        } else {
            // no ref purchase
            // add the referral bonus back to the global dividends cake
            _dividends = SafeMath.add(_dividends, _referralBonus);
            _fee = _dividends * magnitude;
        }


        // we can't give people infinite ghost
        if(tokenSupply_ > 0){

            // add tokens to the pool
            tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);

            // take the amount of dividends gained through this transaction, and allocates them evenly to each shareholder
            profitPerShare_ += (_dividends * magnitude / (tokenSupply_));

            // calculate the amount of tokens the customer receives over his purchase
            _fee = _fee - (_fee-(_amountOfTokens * (_dividends * magnitude / (tokenSupply_))));

        } else {
            // add tokens to the pool
            tokenSupply_ = _amountOfTokens;
        }

        // update circulating supply & the ledger address for the customer
        tokenBalanceLedger_[msg.sender] = SafeMath.add(tokenBalanceLedger_[msg.sender], _amountOfTokens);

        // Tells the contract that the buyer doesn't deserve dividends for the tokens before they owned them;
        //really i know you think you do but you don't
        int256 _updatedPayouts = (int256) ((profitPerShare_ * _amountOfTokens) - _fee);
        payoutsTo_[msg.sender] += _updatedPayouts;

        // fire event
        emit onTokenPurchase(msg.sender, _incomingGhost, _amountOfTokens, _referredBy);

        return _amountOfTokens;
    }

    /**
     * Calculate Token price based on an amount of incoming ghost
     */
    function ghostToTokens_(uint256 _ghost)
        internal
        view
        returns(uint256)
    {
        uint256 _tokenPriceInitial = tokenPriceInitial_ * 1e18;
        uint256 _tokensReceived =
         (
            (
                // underflow attempts BTFO
                SafeMath.sub(
                    (sqrt
                        (
                            (_tokenPriceInitial**2)
                            +
                            (2*(tokenPriceIncremental_ * 1e18)*(_ghost * 1e18))
                            +
                            (((tokenPriceIncremental_)**2)*(tokenSupply_**2))
                            +
                            (2*(tokenPriceIncremental_)*_tokenPriceInitial*tokenSupply_)
                        )
                    ), _tokenPriceInitial
                )
            )/(tokenPriceIncremental_)
        )-(tokenSupply_)
        ;

        return _tokensReceived;
    }

    /**
     * Calculate token sell value.
     */
     function tokensToGhost_(uint256 _tokens)
        internal
        view
        returns(uint256)
    {

        uint256 tokens_ = (_tokens + 1e18);
        uint256 _tokenSupply = (tokenSupply_ + 1e18);
        uint256 _etherReceived =
        (
            // underflow attempts BTFO
            SafeMath.sub(
                (
                    (
                        (
                            tokenPriceInitial_ +(tokenPriceIncremental_ * (_tokenSupply/1e18))
                        )-tokenPriceIncremental_
                    )*(tokens_ - 1e18)
                ),(tokenPriceIncremental_*((tokens_**2-tokens_)/1e18))/2
            )
        /1e18);
        return _etherReceived;
    }


    //This is where all your gas goes, sorry
    //Not sorry, you probably only paid 1 gwei
    function sqrt(uint x) internal pure returns (uint y) {
        uint z = (x + 1) / 2;
        y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
    }
}

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
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