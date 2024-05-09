// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Melodity.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MelodityCrowdsale is Ownable {
    Melodity token;
    PaymentTier[] payment_tier;
    uint256 sale_start;
    uint256 sale_end;

    // emergency switch to pause the ico errors occurrs
    bool paused;

    // used to store the amount of funds actually in the contract,
    // this value is created in order to avoid eventually running out of funds in case of a large number of
    // interactions occurring at the same time.
    // it will be set to the balance of the contract and reduce at every round of _computeTokensAmount
    // if the reduce flag is set to true, otherwise it won't be reduced
    // TODO: initialize the supply value if not initialized yet
    uint256 supply;
    uint256 distributed;

    event Buy(address indexed from, uint256 amount);
    event Finalize();
    event Redeemed(uint256 amount);
    event SupplyInitialized(uint256 _supply);
    event SalePaused();
    event SaleResumed();

    struct PaymentTier {
        uint256 rate;
        uint256 lower_limit;
        uint256 upper_limit;
    }

    receive() payable external {
        buy();
    }

    modifier whenClosed() {
        require(
            block.timestamp >= sale_end || token.balanceOf(address(this)) == 0, 
            "Crowdsale not yet closed"
        );
        _;
    }

    modifier whenRunning() {
        require(
            block.timestamp >= sale_start && block.timestamp < sale_end && token.balanceOf(address(this)) > 0, 
            "Crowdsale not running"
        );
        _;
    }

    modifier tierSetUp() {
        require(
            payment_tier.length > 0,
            "At least one payment tier is required"
        );
        _;
    }

    modifier isNotPaused() {
        require(!paused, "Sorry the sale is temporarily paused due security concerns");
        _;
    }

    /**
    @param _start Ico starting time
    @param _end Ico ending time, if goal is not reached first
    @param _token Melody token instance
    @param _payment_tier Array of crowdsale price tier
     */
    constructor(uint256 _start, uint256 _end, Melodity _token, PaymentTier[] memory _payment_tier) {
        // this allowes the start time to be set to 0, this mean that the starting time is not set yet
        // so the sale has not yet a scheduled starting time
        if(_start != 0) {
            require(block.timestamp < _start, "Sale starting time cannot be in the past");
        }

        // this allowes the end time to be set to 0, this mean that the end time is not set yet
        // so the sale has not yet a scheduled ending time
        if(_end != 0) {
            require(block.timestamp < _end, "Ending time cannot be in the past");
        }
        
        // empty payment tier is allowed at start, this because the tiers may change due to 
        // unspent pre-ico funds
        
        require(_token != Melodity(payable(address(0))), "Token address cannot be null");

        sale_start = _start;
        sale_end = _end;
        token = _token;

        for(uint256 i = 0; i < _payment_tier.length; i++) {
            payment_tier.push(_payment_tier[i]);
        }
    }

    function initSupply() public {
        supply = token.balanceOf(address(this));
        emit SupplyInitialized(supply);
    }

    function pause() public isNotPaused onlyOwner {
        paused = true;
        emit SalePaused();
    }

    function resume() public onlyOwner {
        paused = false;
        emit SaleResumed();
    }

    function setStartTime(uint256 _start) public onlyOwner {
        require(block.timestamp < _start, "Sale starting time cannot be in the past");
        sale_start = _start;
    }

    function setEndTime(uint256 _end) public onlyOwner {
        require(block.timestamp < _end, "Ending time cannot be in the past");
        sale_end = _end;
    }

    function setPaymentTiers(PaymentTier[] memory _payment_tier) public onlyOwner {
        require(_payment_tier.length > 0, "At least one payment tier must be defined");
        delete payment_tier;
        for(uint256 i = 0; i < _payment_tier.length; i++) {
            payment_tier.push(_payment_tier[i]);
        }
    }

    function buy() public whenRunning isNotPaused payable {
        // If a fixed rate is provided compute the amount of token to buy based on the rate
        (uint256 tokens_to_buy, uint256 exceedingEther) = _computeTokensAmount(msg.value, true);
        if(exceedingEther > 0) {
            payable(msg.sender).transfer(exceedingEther);
        }
        
        // Mint new tokens for each submission
        token.transfer(msg.sender, tokens_to_buy);
        emit Buy(msg.sender, tokens_to_buy);
    }    

    function computeTokensAmount(uint256 funds) public whenRunning isNotPaused returns(uint256, uint256) {
        return _computeTokensAmount(funds, false);
    }

    function _computeTokensAmount(uint256 funds, bool reduce) private whenRunning isNotPaused returns(uint256, uint256) {
        uint256 future_minted = distributed;
        uint256 tokens_to_buy;
        uint256 current_round_tokens;      
        uint256 ether_used = funds; 
        uint256 future_round; 
        uint256 rate;
        uint256 upper_limit;

        for(uint256 i = 0; i < payment_tier.length; i++) {
            // minor performance improvement, caches the value
            upper_limit = payment_tier[i].upper_limit;

            if(
                ether_used > 0 &&                                   // Check if there are still some funds in the request
                future_minted >= payment_tier[i].lower_limit &&     // Check if the current rate can be applied with the lower_limit
                future_minted < upper_limit                         // Check if the current rate can be applied with the upper_limit
                ) {
                // minor performance improvement, caches the value
                rate = payment_tier[i].rate;
                
                // Keep a static counter and reset it in each round
                // NOTE: Order is important in value calculation
                current_round_tokens = ether_used * 1e18 / 1 ether * rate;

                // minor performance optimization, caches the value
                future_round = future_minted + current_round_tokens;
                // If the tokens to mint exceed the upper limit of the tier reduce the number of token bounght in this round
                if(future_round >= upper_limit) {
                    current_round_tokens -= future_round - upper_limit;
                }

                // Update the future_minted counter with the current_round_tokens
                future_minted += current_round_tokens;

                // Recomputhe the available funds
                ether_used -= current_round_tokens * 1 ether / rate / 1e18;

                // And add the funds to the total calculation
                tokens_to_buy += current_round_tokens;
            }
        }

        // minor performance optimization, caches the value
        uint256 new_minted = distributed + tokens_to_buy;
        uint256 exceedingEther;
        // Check if we have reached and exceeded the funding goal to refund the exceeding ether
        if(new_minted >= supply) {
            uint256 exceedingTokens = new_minted - supply;
            
            // Convert the exceedingTokens to ether and refund that ether
            exceedingEther = ether_used + (exceedingTokens * 1 ether / payment_tier[payment_tier.length -1].rate / 1e18);

            // Change the tokens to buy to the new number
            tokens_to_buy -= exceedingTokens;
        }

        if(reduce) {
            // change the core value asap
            distributed += tokens_to_buy;
            supply -= tokens_to_buy;
        }

        return (tokens_to_buy, exceedingEther);
    }

    function redeem() public onlyOwner whenClosed payable {
        uint256 balance = address(this).balance;
        payable(owner()).transfer(balance);

        // transfer the exceeding MELD to the bridge wallet
        uint256 remaining_meld = token.balanceOf(address(this));
        // bridge wallet address 0x7C44bEfc22111e868b3a0B1bbF30Dd48F99682b3
        token.transfer(payable(address(0x15DB902f721214fcf39F979E9b4FA0A3B8EDC7F5)), remaining_meld);

        emit Redeemed(balance);
    }

    function emergencyRedeem() public onlyOwner payable {
        require(paused, "Emergency redemption of tokens can be called only if the sale is paused");

        uint256 balance = address(this).balance;
        payable(owner()).transfer(balance);

        // transfer the exceeding MELD to the bridge wallet
        uint256 remaining_meld = token.balanceOf(address(this));
        // bridge wallet address 0x7C44bEfc22111e868b3a0B1bbF30Dd48F99682b3
        token.transfer(payable(address(0x15DB902f721214fcf39F979E9b4FA0A3B8EDC7F5)), remaining_meld);

        emit Redeemed(balance);
    }

    function getBalance() public view returns(uint256) { return address(this).balance; }
    function getDistributed() public view returns(uint256) { return distributed; }
    function getStartingTime() public view returns(uint256) { return sale_start; }
    function getEndingTime() public view returns(uint256) { return sale_end; }
    function getSupply() public view returns(uint256) { return supply; }
    function getTiers() public view returns(PaymentTier[] memory) { return payment_tier; }
    function isPaused() public onlyOwner view returns(bool) { return paused; }
    function isStarted() public view returns(bool) { return block.timestamp >= sale_start; }
}
