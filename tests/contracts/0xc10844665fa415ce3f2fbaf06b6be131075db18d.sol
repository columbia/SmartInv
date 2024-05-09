// SPDX-License-Identifier: MIT

pragma solidity 0.7.6;


// 
/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/179
 */
abstract contract ERC20Basic {
    uint256 public totalSupply;
    function balanceOf(address who) public view virtual returns (uint256);
    function transfer(address to, uint256 value) public virtual returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
}

// 
/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
abstract contract ERC20 is ERC20Basic {
    function allowance(address owner, address spender) public view virtual returns (uint256);
    function transferFrom(address from, address to, uint256 value) public virtual returns (bool);
    function approve(address spender, uint256 value) public virtual returns (bool);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// 
/**
 * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
 *
 * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
 */
/**
 * Safe unsigned safe math.
 *
 * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
 *
 * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
 *
 * Maintained here until merged to mainline zeppelin-solidity.
 *
 */
library SafeMathLibExt {

    function times(uint a, uint b) public pure returns (uint) {
        uint c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function divides(uint a, uint b) public pure returns (uint) {
        assert(b > 0);
        uint c = a / b;
        assert(a == b * c + a % b);
        return c;
    }

    function minus(uint a, uint b) public pure returns (uint) {
        assert(b <= a);
        return a - b;
    }

    function plus(uint a, uint b) public pure returns (uint) {
        uint c = a + b;
        assert(c >= a);
        return c;
    }

}

// 
/**
 * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
 *
 * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
 */
/**
 * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
 *
 * Based on code by FirstBlood:
 * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 */
contract StandardToken is ERC20 {

    using SafeMathLibExt for uint256;

    /* Token supply got increased and a new owner received these tokens */
    event Minted(address receiver, uint256 amount);

    /* Actual balances of token holders */
    mapping(address => uint256) public balances;

    /* approve() allowances */
    mapping (address => mapping (address => uint256)) public allowed;

    /* Interface declaration */
    function isToken() public pure returns (bool weAre) {
        return true;
    }

    function transfer(address _to, uint256 _value) public virtual override returns (bool success) {
        balances[msg.sender] = balances[msg.sender].minus(_value);
        balances[_to] = balances[_to].plus(_value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public virtual override returns (bool success) {
        uint256 _allowance = allowed[_from][msg.sender];

        balances[_to] = balances[_to].plus(_value);
        balances[_from] = balances[_from].minus(_value);
        allowed[_from][msg.sender] = _allowance.minus(_value);
        emit Transfer(_from, _to, _value);
        return true;
    }

    function balanceOf(address _owner) public view virtual override returns (uint256 balance) {
        return balances[_owner];
    }

    function approve(address _spender, uint256 _value) public  virtual override returns (bool success) {

        // To change the approve amount you first have to reduce the addresses`
        //  allowance to zero by calling `approve(_spender, 0)` if it is not
        //  already 0 to mitigate the race condition described here:
        //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
        // if ((_addedValue != 0) && (allowed[msg.sender][_spender] != 0)) revert();
        if(_value == 0 ) revert("Cannot approve 0 value");
        if(_spender == address(0)) revert("Cannot approve for Null aDDRESS");
        if(allowed[msg.sender][_spender] == 0 ) revert("Spender already approved,instead increase/decrease allowance");

        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function increaseAllowance(address _spender, uint256 _addedValue) public virtual returns (bool) {
        if(_addedValue == 0 ) revert("Cannot add 0 allowance value");
        if(_spender == address(0)) revert("Cannot allow for Null address");

        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].plus(allowed[msg.sender][_spender]);
        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender].plus(allowed[msg.sender][_spender]));
        return true;
    }

    function decreaseAllowance(address _spender, uint256 _subtractedValue) public virtual returns (bool) {
        if(_subtractedValue == 0 ) revert("Cannot add 0 decrease value");
        if(_spender == address(0)) revert("Cannot allow for Null address");
        require(_subtractedValue <= allowed[msg.sender][_spender], "Cannot remove more than allowance!");
        
        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].minus(allowed[msg.sender][_spender]);
        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender].minus(allowed[msg.sender][_spender]));
        return true;
    }

    function allowance(address _owner, address _spender) public view virtual override returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

}

// 
/**
 * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
 *
 * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
 */
/**
 * Upgrade agent interface inspired by Lunyr.
 *
 * Upgrade agent transfers tokens to a new contract.
 * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
 */
abstract contract UpgradeAgent {

    uint public originalSupply;

    /** Interface marker */
    function isUpgradeAgent() public pure returns (bool) {
        return true;
    }

    function upgradeFrom(address _from, uint256 _value) public virtual;

}

// 
/**
 * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
 *
 * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
 */
/**
 * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
 *
 * First envisioned by Golem and Lunyr projects.
 */
contract UpgradeableToken is StandardToken {
    using SafeMathLibExt for uint;

    /** Contract / person who can set the upgrade path. 
        This can be the same as team multisig wallet, as what it is with its default value. */
    address public upgradeMaster;

    /** The next contract where the tokens will be migrated. */
    UpgradeAgent public upgradeAgent;

    /** How many tokens we have upgraded by now. */
    uint256 public totalUpgraded;
    /**
    * Upgrade states.
    *
    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
    *
    */
    enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}

    /**
    * Somebody has upgraded some of his tokens.
    */
    event Upgrade(address indexed _from, address indexed _to, uint256 _value);

    /**
    * New upgrade agent available.
    */
    event UpgradeAgentSet(address agent);

    /**
    * New upgrade master available.
    */   
    event UpgradeMasterSet(address agent);


    /**
    * Do not allow construction without upgrade master set.
    */
    constructor(address _upgradeMaster) {
        require(_upgradeMaster != address(0), "Upgrade Master cannot be Null Address");
        upgradeMaster = _upgradeMaster;
    }

    /**
    * Allow the token holder to upgrade some of their tokens to a new contract.
    */
    function upgrade(uint256 value) public {

        UpgradeState state = getUpgradeState();
        if (!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
            // Called in a bad state
            revert("Called in bad State");
        }

        // Validate input value.
        if (value == 0) revert("Invalid input value");

        balances[msg.sender] = balances[msg.sender].minus(value);

        // Take tokens out from circulation
        totalSupply = totalSupply.minus(value);
        totalUpgraded = totalUpgraded.plus(value);

        // Upgrade agent reissues the tokens
        upgradeAgent.upgradeFrom(msg.sender, value);
        emit Upgrade(msg.sender, address(upgradeAgent), value);
    }

    /**
    * Child contract can enable to provide the condition when the upgrade can begun.
    */
    function canUpgrade() public virtual returns(bool) {
        return true;
    }

    /**
    * Set an upgrade agent that handles
    */
    function setUpgradeAgent(address agent) external {
        if (!canUpgrade()) {
            // The token is not yet in a state that we could think upgrading
            revert("The token is not yet in a state that we could think upgrading");
        }

        if (agent == address(0)) revert("Cannot be Zero Address");
        // Only a master can designate the next agent
        if (msg.sender != upgradeMaster) revert("Only a master can designate the next agent");
        // Upgrade has already begun for an agent
        if (getUpgradeState() == UpgradeState.Upgrading) revert("Upgrade has already begun for an agent");

        upgradeAgent = UpgradeAgent(agent);

        // Bad interface
        if (!upgradeAgent.isUpgradeAgent()) revert("Bad interface");      

        emit UpgradeAgentSet(agent);
    }

    /**
    * Get the state of the token upgrade.
    */
    function getUpgradeState() public returns(UpgradeState) {
        if (!canUpgrade()) return UpgradeState.NotAllowed;
        else if (address(upgradeAgent) == address(0)) return UpgradeState.WaitingForAgent;
        else if (totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
        else return UpgradeState.Upgrading;
    }

    /**
    * Change the upgrade master.
    *
    * This allows us to set a new owner for the upgrade mechanism.
    */
    function setUpgradeMaster(address master) public {
        if (master == address(0)) revert("Cannot set master contract to 0");
        if (msg.sender != upgradeMaster) revert("Msg Sender not upgrade master");
        upgradeMaster = master;

        emit UpgradeMasterSet(master);
    }
}

// 
/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
    address public owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
    * account.
    */
    constructor ()  {
        owner = msg.sender;
    }

    /**
    * @dev Throws if called by any account other than the owner.
    */
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    /**
    * @dev Allows the current owner to transfer control of the contract to a newOwner.
    * @param newOwner The address to transfer ownership to.
    */
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}

// 
/**
 * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
 *
 * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
 */
/**
  * Define interface for releasing the token transfer after a successful crowdsale.
  */
contract ReleasableToken is StandardToken, Ownable {
    
    event ReleaseAgentSet(address caller, address agent);
    event TransferAgentSet(address callet, address agent, bool set);
    
    /* The finalizer contract that allows unlift the transfer limits on this token */
    address public releaseAgent;

    /** A crowdsale contract can release us to the wild if ICO success. 
        If false we are are in transfer lock up period.*/
    bool public released = false;

    /** Map of agents that are allowed to transfer tokens regardless of the lock down period. 
        These are crowdsale contracts and possible the team multisig itself. */
    mapping (address => bool) public transferAgents;

    

    /**
    * Limit token transfer until the crowdsale is over.
    *
    */
    modifier canTransfer(address _sender) {

        if (!released) {
            if (!transferAgents[_sender]) {
                revert("Not A Transfer Agent");
            }
        }
        _;
    }

    /**
    * Set the contract that can call release and make the token transferable.
    *
    * Design choice. Allow reset the release agent to fix fat finger mistakes.
    */
    function setReleaseAgent(address addr) public onlyOwner inReleaseState(false) {
        require(addr != address(0), "Release Agent cannot be Null Address");
        // We don't do interface check here as we might want to a normal wallet address to act as a release agent
        releaseAgent = addr;

        emit ReleaseAgentSet(msg.sender, addr);
    }

    /**
    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
    */
    function setTransferAgent(address addr, bool state) public onlyOwner inReleaseState(false) {
        transferAgents[addr] = state;

        emit TransferAgentSet(msg.sender, addr, state);
    }

    /**
    * One way function to release the tokens to the wild.
    *
    * Can be called only from the release agent that is the final ICO contract. 
    * It is only called if the crowdsale has been success (first milestone reached).
    */
    function releaseTokenTransfer() public virtual onlyReleaseAgent {
        released = true;
    }

    /** The function can be called only before or after the tokens have been releasesd */
    modifier inReleaseState(bool releaseState) {
        if (releaseState != released) {
            revert("Not in released state");
        }
        _;
    }

    /** The function can be called only by a whitelisted release agent. */
    modifier onlyReleaseAgent() {
        if (msg.sender != releaseAgent) {
            revert("Not release agent");
        }
        _;
    }

    function transfer(address _to, uint _value) public virtual override canTransfer(msg.sender) returns (bool success) {
        // Call StandardToken.transfer()
        return super.transfer(_to, _value);
    }

    function transferFrom(address _from, address _to, uint _value) public virtual override canTransfer(_from) returns (bool success) {
        // Call StandardToken.transferForm()
        return super.transferFrom(_from, _to, _value);
    }

}

// 
/**
 * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
 *
 * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
 */
/**
 * A token that can increase its supply by another contract.
 *
 * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
 * Only mint agents, contracts whitelisted by owner, can mint new tokens.
 *
 */
contract MintableTokenExt is StandardToken, Ownable {

    using SafeMathLibExt for uint;

    bool public mintingFinished = false;

    /** List of agents that are allowed to create new tokens */
    mapping (address => bool) public mintAgents;

    event MintingAgentChanged(address addr, bool state  );
    event ReversedTokenListMultipleSet(uint length);
    event FinalizedReversedAddress(address addr);

    /** inPercentageUnit is percents of tokens multiplied to 10 up to percents decimals.
    * For example, for reserved tokens in percents 2.54%
    * inPercentageUnit = 254
    * inPercentageDecimals = 2
    */
    struct ReservedTokensData {
        uint inTokens;
        uint inPercentageUnit;
        uint inPercentageDecimals;
        bool isReserved;
        bool isDistributed;
        bool isVested;
    }

    mapping (address => ReservedTokensData) public reservedTokensList;
    address[] public reservedTokensDestinations;
    uint public reservedTokensDestinationsLen = 0;
    bool private reservedTokensDestinationsAreSet = false;

    modifier onlyMintAgent() {
        // Only crowdsale contracts are allowed to mint new tokens
        if (!mintAgents[msg.sender]) {
            revert("Only crowdsale contracts are allowed to mint new tokens");
        }
        _;
    }

    /** Make sure we are not done yet. */
    modifier canMint() {
        if (mintingFinished) revert();
        _;
    }

    function finalizeReservedAddress(address addr) public onlyMintAgent canMint {
        ReservedTokensData storage reservedTokensData = reservedTokensList[addr];
        reservedTokensData.isDistributed = true;

        emit FinalizedReversedAddress(addr);
    }

    function isAddressReserved(address addr)  public  view virtual returns (bool isReserved) {
        return reservedTokensList[addr].isReserved;
    }

    function areTokensDistributedForAddress(address addr) public view returns (bool isDistributed) {
        return reservedTokensList[addr].isDistributed;
    }

    function getReservedTokens(address addr) public view returns (uint inTokens) {
        return reservedTokensList[addr].inTokens;
    }

    function getReservedPercentageUnit(address addr) public view returns (uint inPercentageUnit) {
        return reservedTokensList[addr].inPercentageUnit;
    }

    function getReservedPercentageDecimals(address addr) public view returns (uint inPercentageDecimals) {
        return reservedTokensList[addr].inPercentageDecimals;
    }

    function getReservedIsVested(address addr) public view returns (bool isVested) {
        return reservedTokensList[addr].isVested;
    }

    function setReservedTokensListMultiple(
        address[] memory addrs, 
        uint[] memory inTokens, 
        uint[] memory inPercentageUnit, 
        uint[] memory inPercentageDecimals,
        bool[] memory isVested
        ) public canMint onlyOwner {
        assert(!reservedTokensDestinationsAreSet);
        assert(addrs.length == inTokens.length);
        assert(inTokens.length == inPercentageUnit.length);
        assert(inPercentageUnit.length == inPercentageDecimals.length);
        for (uint iterator = 0; iterator < addrs.length; iterator++) {
            if (addrs[iterator] != address(0)) {
                setReservedTokensList(
                    addrs[iterator],
                    inTokens[iterator],
                    inPercentageUnit[iterator],
                    inPercentageDecimals[iterator],
                    isVested[iterator]
                    );
            }
        }
        reservedTokensDestinationsAreSet = true;

        emit ReversedTokenListMultipleSet(addrs.length);
    }

    /**
    * Create new tokens and allocate them to an address..
    *
    * Only callably by a crowdsale contract (mint agent).
    */
    function mint(address receiver, uint amount) public onlyMintAgent canMint {
        require(receiver != address(0), "Receiver cannot be the Null Address");
        totalSupply = totalSupply.plus(amount);
        balances[receiver] = balances[receiver].plus(amount);

        // This will make the mint transaction apper in EtherScan.io
        // We can remove this after there is a standardized minting event
        emit Transfer(address(0), receiver, amount);
    }

    /**
    * Owner can allow a crowdsale contract to mint new tokens.
    */
    function setMintAgent(address addr, bool state) public onlyOwner canMint {
        require(addr != address(0), "Mint Agent Cannot be Null Address");
        mintAgents[addr] = state;
        emit MintingAgentChanged(addr, state);
    }

    function setReservedTokensList(address addr, uint inTokens, uint inPercentageUnit, uint inPercentageDecimals,bool isVested) 
    private canMint onlyOwner {
        assert(addr != address(0));
        if (!isAddressReserved(addr)) {
            reservedTokensDestinations.push(addr);
            reservedTokensDestinationsLen.plus(1);
        }

        reservedTokensList[addr] = ReservedTokensData({
            inTokens: inTokens,
            inPercentageUnit: inPercentageUnit,
            inPercentageDecimals: inPercentageDecimals,
            isReserved: true,
            isDistributed: false,
            isVested:isVested
        });
    }
}

// 
/**
 * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
 *
 * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
 */
/**
 * A crowdsaled token.
 *
 * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
 *
 * - The token transfer() is disabled until the crowdsale is over
 * - The token contract gives an opt-in upgrade path to a new contract
 * - The same token can be part of several crowdsales through approve() mechanism
 * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
 *
 */
contract CrowdsaleTokenExt is ReleasableToken, MintableTokenExt, UpgradeableToken {
    using SafeMathLibExt for uint256;

    /** Name and symbol were updated. */
    event UpdatedTokenInformation(string newName, string newSymbol);

    event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);

    string public name;

    string public symbol;

    uint public decimals;

    /* Minimum ammount of tokens every buyer can buy. */
    uint256 public minCap;

    /**
    * Construct the token.
    *
    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
    *
    * @param _name Token name
    * @param _symbol Token symbol - should be all caps
    * @param _initialSupply How many tokens we start with
    * @param _decimals Number of decimal places
    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? 
    * Note that when the token becomes transferable the minting always ends.
    */
    constructor(string memory _name, string memory _symbol, uint256 _initialSupply, uint _decimals, bool _mintable, uint256 _globalMinCap) 
     UpgradeableToken(msg.sender) {

        // Create any address, can be transferred
        // to team multisig via changeOwner(),
        // also remember to call setUpgradeMaster()
        owner = msg.sender;

        name = _name;
        symbol = _symbol;

        totalSupply = _initialSupply;

        decimals = _decimals;

        minCap = _globalMinCap;

        // Create initially all balance on the team multisig
        balances[owner] = totalSupply;

        if (totalSupply > 0) {
            emit Minted(owner, totalSupply);
        }

        // No more new supply allowed after the token creation
        if (!_mintable) {
            mintingFinished = true;
            if (totalSupply == 0) {
                revert("annot create a token without supply and no minting"); // Cannot create a token without supply and no minting
            }
        }
    }

    /**
    * When token is released to be transferable, enforce no new tokens can be created.
    */
    function releaseTokenTransfer() public virtual override onlyReleaseAgent {
        mintingFinished = true;
        super.releaseTokenTransfer();
    }

    /**
    * Allow upgrade agent functionality kick in only if the crowdsale was success.
    */
    function canUpgrade() public virtual override returns(bool) {
        return released && super.canUpgrade();
    }

    /**
    * Owner can update token information here.
    *
    * It is often useful to conceal the actual token association, until
    * the token operations, like central issuance or reissuance have been completed.
    *
    * This function allows the token owner to rename the token after the operations
    * have been completed and then point the audience to use the token contract.
    */
    function setTokenInformation(string memory _name, string memory _symbol) external onlyOwner {
        name = _name;
        symbol = _symbol;

        emit UpdatedTokenInformation(name, symbol);
    }

    /**
    * Claim tokens that were accidentally sent to this contract.
    *
    * @param _token The address of the token contract that you want to recover.
    */
    function claimTokens(address _token) external onlyOwner {
        require(_token != address(0));

        ERC20 token = ERC20(_token);
        uint256 balance = token.balanceOf(address(this));
        token.transfer(owner, balance);

        emit ClaimedTokens(_token, owner, balance);
    }

    function transferFrom(address _from, address _to, uint256 _value) public virtual override(StandardToken,ReleasableToken) returns (bool success) {
        uint256 _allowance = allowed[_from][msg.sender];

        balances[_to] = balances[_to].plus(_value);
        balances[_from] = balances[_from].minus(_value);
        allowed[_from][msg.sender] = _allowance.minus(_value);
        emit Transfer(_from, _to, _value);
        return true;
    }

    function transfer(address _to, uint256 _value) public virtual override(StandardToken,ReleasableToken) canTransfer(msg.sender) returns (bool success) {
        // Call StandardToken.transfer()
        return super.transfer(_to, _value);
    }

}

// 
/**
 * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
 *
 * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
 */
/**
 * A crowdsaled token.
 *
 * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
 *
 * - The token transfer() is disabled until the crowdsale is over
 * - The token contract gives an opt-in upgrade path to a new contract
 * - The same token can be part of several crowdsales through approve() mechanism
 * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
 *
 */
contract CrowdsaleTokenExtv1 is CrowdsaleTokenExt {
    using SafeMathLibExt for uint256;

    uint256 public originalSupply;

    address public oldTokenAddress;

    bool public isUpgradeAgent = false;
    /**
    * Construct the token.
    *
    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
    *
    * @param _name Token name
    * @param _symbol Token symbol - should be all caps
    * @param _initialSupply How many tokens we start with
    * @param _decimals Number of decimal places
    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? 
    * Note that when the token becomes transferable the minting always ends.
    */
    constructor(string memory _name, string memory _symbol, uint256 _initialSupply, uint256 _decimals, bool _mintable, 
    uint256 _globalMinCap, address _oldTokenAddress, uint256 _originalSupply) 
     CrowdsaleTokenExt(_name, _symbol, _initialSupply, _decimals, _mintable, _globalMinCap) {    
        originalSupply = _originalSupply;
        oldTokenAddress = _oldTokenAddress;
        isUpgradeAgent = true;    
    }

    function upgradeFrom(address _from, uint256 value) public {
        // Make sure the call is from old token contract
        require(msg.sender == oldTokenAddress);
        // Validate input value.
        balances[_from] = balances[_from].plus(value);
        // Take tokens out from circulation
        totalSupply = totalSupply.plus(value);
    }

}