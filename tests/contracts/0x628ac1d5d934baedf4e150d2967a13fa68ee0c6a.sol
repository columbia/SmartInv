// File: contracts/bot/CustomOwned.sol

pragma solidity 0.4.26;

contract CustomOwned {
    address public owner;
    address public newOwner;

    event OwnerUpdate(address _prevOwner, address _newOwner);

    constructor () public { owner = msg.sender; }

    modifier ownerOnly {
        assert(msg.sender == owner);
        _;
    }

    function setOwner(address _newOwner) public ownerOnly {
        require(_newOwner != owner && _newOwner != address(0), "Unauthorized");
        emit OwnerUpdate(owner, _newOwner);
        owner = _newOwner;
        newOwner = address(0);
    }

    function transferOwnership(address _newOwner) public ownerOnly {
        require(_newOwner != owner, "Invalid");
        newOwner = _newOwner;
    }

    function acceptOwnership() public {
        require(msg.sender == newOwner, "Unauthorized");
        emit OwnerUpdate(owner, newOwner);
        owner = newOwner;
        newOwner = 0x0;
    }
}

// File: contracts/token/interfaces/IERC20Token.sol

pragma solidity 0.4.26;

/*
    ERC20 Standard Token interface
*/
contract IERC20Token {
    // these functions aren't abstract since the compiler emits automatically generated getter functions as external
    function name() public view returns (string) {this;}
    function symbol() public view returns (string) {this;}
    function decimals() public view returns (uint8) {this;}
    function totalSupply() public view returns (uint256) {this;}
    function balanceOf(address _owner) public view returns (uint256) {_owner; this;}
    function allowance(address _owner, address _spender) public view returns (uint256) {_owner; _spender; this;}

    function transfer(address _to, uint256 _value) public returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
    function approve(address _spender, uint256 _value) public returns (bool success);
}

// File: contracts/utility/interfaces/IOwned.sol

pragma solidity 0.4.26;

/*
    Owned contract interface
*/
contract IOwned {
    // this function isn't abstract since the compiler emits automatically generated getter functions as external
    function owner() public view returns (address) {this;}

    function transferOwnership(address _newOwner) public;
    function acceptOwnership() public;
}

// File: contracts/utility/interfaces/ITokenHolder.sol

pragma solidity 0.4.26;



/*
    Token Holder interface
*/
contract ITokenHolder is IOwned {
    function withdrawTokens(IERC20Token _token, address _to, uint256 _amount) public;
}

// File: contracts/converter/interfaces/IConverterAnchor.sol

pragma solidity 0.4.26;



/*
    Converter Anchor interface
*/
contract IConverterAnchor is IOwned, ITokenHolder {
}

// File: contracts/token/interfaces/ISmartToken.sol

pragma solidity 0.4.26;




/*
    Smart Token interface
*/
contract ISmartToken is IConverterAnchor, IERC20Token {
    function disableTransfers(bool _disable) public;
    function issue(address _to, uint256 _amount) public;
    function destroy(address _from, uint256 _amount) public;
}

// File: contracts/IBancorNetwork.sol

pragma solidity 0.4.26;


/*
    Bancor Network interface
*/
contract IBancorNetwork {
    function convert2(
        IERC20Token[] _path,
        uint256 _amount,
        uint256 _minReturn,
        address _affiliateAccount,
        uint256 _affiliateFee
    ) public payable returns (uint256);

    function claimAndConvert2(
        IERC20Token[] _path,
        uint256 _amount,
        uint256 _minReturn,
        address _affiliateAccount,
        uint256 _affiliateFee
    ) public returns (uint256);

    function convertFor2(
        IERC20Token[] _path,
        uint256 _amount,
        uint256 _minReturn,
        address _for,
        address _affiliateAccount,
        uint256 _affiliateFee
    ) public payable returns (uint256);

    function claimAndConvertFor2(
        IERC20Token[] _path,
        uint256 _amount,
        uint256 _minReturn,
        address _for,
        address _affiliateAccount,
        uint256 _affiliateFee
    ) public returns (uint256);

    // deprecated, backward compatibility
    function convert(
        IERC20Token[] _path,
        uint256 _amount,
        uint256 _minReturn
    ) public payable returns (uint256);

    // deprecated, backward compatibility
    function claimAndConvert(
        IERC20Token[] _path,
        uint256 _amount,
        uint256 _minReturn
    ) public returns (uint256);

    // deprecated, backward compatibility
    function convertFor(
        IERC20Token[] _path,
        uint256 _amount,
        uint256 _minReturn,
        address _for
    ) public payable returns (uint256);

    // deprecated, backward compatibility
    function claimAndConvertFor(
        IERC20Token[] _path,
        uint256 _amount,
        uint256 _minReturn,
        address _for
    ) public returns (uint256);

    function rateByPath(
        IERC20Token[] _path,
        uint256 _amount
    ) public view returns (uint256);
}

// File: contracts/utility/interfaces/IContractRegistry.sol

pragma solidity 0.4.26;

/*
    Contract Registry interface
*/
contract IContractRegistry {
    function addressOf(bytes32 _contractName) public view returns (address);

    // deprecated, backward compatibility
    function getAddress(bytes32 _contractName) public view returns (address);
}

// File: contracts/bot/ArbBot.sol

pragma solidity 0.4.26;







contract ArbBot is CustomOwned {
    bytes32 internal constant BANCOR_NETWORK = "BancorNetwork";

    IERC20Token public tokenBNT;
    IERC20Token public tokenUSDB;
    IERC20Token public tokenDAI;
    IERC20Token public tokenPEGUSD;

    ISmartToken public relayUSDB;
    ISmartToken public relayDAI;
    ISmartToken public relayPEGUSD;

    IContractRegistry public registry;

    uint256 public threshold = 0;

    constructor (
        IERC20Token _tokenBNT,
        IERC20Token _tokenDAI,
        IERC20Token _tokenUSDB,
        IERC20Token _tokenPEGUSD,
        ISmartToken _relayUSDB,
        ISmartToken _relayDAI,
        ISmartToken _relayPEGUSD,
        IContractRegistry _registry
    ) public {
        tokenBNT = _tokenBNT;
        tokenDAI = _tokenDAI;
        tokenUSDB = _tokenUSDB;
        tokenPEGUSD = _tokenPEGUSD;

        relayUSDB = _relayUSDB;
        relayDAI = _relayDAI;
        relayPEGUSD = _relayPEGUSD;

        registry = _registry;
    }

    function generatePath (bool _isUSDB, bool _fromUSD) private view returns(IERC20Token[] memory) {
        IERC20Token tokenUSD = (_isUSDB == true) ? tokenUSDB : tokenPEGUSD;
        ISmartToken relayUSD = (_isUSDB == true) ? relayUSDB : relayPEGUSD;

        IERC20Token[] memory path = new IERC20Token[](5);
        if(_fromUSD) {
            path[0] = tokenUSD;
            path[1] = IERC20Token(relayUSD);
            path[2] = tokenBNT;
            path[3] = IERC20Token(relayDAI);
            path[4] = tokenDAI;
        } else {
            path[0] = tokenDAI;
            path[1] = IERC20Token(relayDAI);
            path[2] = tokenBNT;
            path[3] = IERC20Token(relayUSD);
            path[4] = tokenUSD;
        }

        return path;
    }

    function getReturnDAI (bool _isUSDB, uint256 _amount) public view returns(uint256) {
        IBancorNetwork network = IBancorNetwork(registry.addressOf(BANCOR_NETWORK));
        return network.rateByPath(generatePath(_isUSDB, false), _amount);
    }

    function getReturnUSD (bool _isUSDB, uint256 _amount) public view returns(uint256) {
        IBancorNetwork network = IBancorNetwork(registry.addressOf(BANCOR_NETWORK));
        return network.rateByPath(generatePath(_isUSDB, true), _amount);
    }

    function isReadyToTrade(bool _isUSDB, uint256 _amount) public view returns(bool) {
        IBancorNetwork network = IBancorNetwork(registry.addressOf(BANCOR_NETWORK));
        uint256 returnUSD = network.rateByPath(generatePath(_isUSDB, true), _amount);
        uint256 returnDAI = network.rateByPath(generatePath(_isUSDB, false), _amount);
        if(returnDAI > _amount) {
            return ((returnDAI - _amount) >= threshold);
        } else {
            if(returnUSD > _amount)
                return ((returnUSD - _amount) >= threshold);
            else
                return false;
        }
    }

    function testTrade(bool _isUSDB, bool _fromUSD, uint256 _amount) public ownerOnly returns(bool) {
        IBancorNetwork network = IBancorNetwork(registry.addressOf(BANCOR_NETWORK));
        network.convertFor(generatePath(_isUSDB, _fromUSD), _amount, 1, address(this));
    }

    function trade(bool _isUSDB, uint256 _amount) public returns(bool) {
        IBancorNetwork network = IBancorNetwork(registry.addressOf(BANCOR_NETWORK));
        uint256 returnUSD = network.rateByPath(generatePath(_isUSDB, true), _amount);
        uint256 returnDAI = network.rateByPath(generatePath(_isUSDB, false), _amount);
        IERC20Token tokenUSD = (_isUSDB == true) ? tokenUSDB : tokenPEGUSD;

        if(returnDAI > _amount) {
            require((returnDAI - _amount) >= threshold, 'Trade not yet available.');
            require(tokenUSD.balanceOf(address(this)) >= _amount, 'Insufficient USD balance.');
            network.convertFor(generatePath(_isUSDB, false), _amount, _amount, address(this));
        } else {
            require(returnUSD > _amount, 'Trade not yet available.');
            require((returnUSD - _amount) >= threshold, 'Trade not yet available.');
            require(tokenDAI.balanceOf(address(this)) >= _amount, 'Insufficient DAI balance.');
            network.convertFor(generatePath(_isUSDB, true), _amount, _amount, address(this));
        }
        return true;
    }

    function lockTokens()  public ownerOnly {
        address network = registry.addressOf(BANCOR_NETWORK);

        tokenUSDB.approve(address(relayUSDB.owner()), 0);
        tokenDAI.approve(address(relayDAI.owner()), 0);
        tokenPEGUSD.approve(address(relayPEGUSD.owner()), 0);

        tokenUSDB.approve(network, 0);
        tokenDAI.approve(network, 0);
        tokenPEGUSD.approve(network, 0);
    }

    function unlockTokensConverter()  public ownerOnly {
        tokenUSDB.approve(address(relayUSDB.owner()), 0);
        tokenUSDB.approve(address(relayUSDB.owner()), 1000000 ether);

        tokenDAI.approve(address(relayDAI.owner()), 0);
        tokenDAI.approve(address(relayDAI.owner()), 1000000 ether);

        tokenPEGUSD.approve(address(relayPEGUSD.owner()), 0);
        tokenPEGUSD.approve(address(relayPEGUSD.owner()), 1000000 ether);
    }

    function unlockTokensNetwork() public ownerOnly  {
        address network = registry.addressOf(BANCOR_NETWORK);

        tokenUSDB.approve(network, 0);
        tokenUSDB.approve(network, 1000000 ether);

        tokenDAI.approve(network, 0);
        tokenDAI.approve(network, 1000000 ether);

        tokenPEGUSD.approve(network, 0);
        tokenPEGUSD.approve(network, 1000000 ether);
    }

    function updateThreshold(uint256 _threshold) public ownerOnly {
        threshold = _threshold;
    }

    function updateRegistry(IContractRegistry _registry) public ownerOnly {
        registry = _registry;
    }

    function updateTokens(
        IERC20Token _tokenBNT,
        IERC20Token _tokenDAI,
        IERC20Token _tokenUSDB,
        IERC20Token _tokenPEGUSD
    ) public ownerOnly {
        tokenBNT = _tokenBNT;
        tokenDAI = _tokenDAI;
        tokenUSDB = _tokenUSDB;
        tokenPEGUSD = _tokenPEGUSD;
    }

    function updateRelays(
        ISmartToken _relayUSDB,
        ISmartToken _relayDAI,
        ISmartToken _relayPEGUSD
    ) public ownerOnly {
        relayUSDB = _relayUSDB;
        relayDAI = _relayDAI;
        relayPEGUSD = _relayPEGUSD;
    }

    function transferERC20Token(IERC20Token _token, address _to, uint256 _amount) public ownerOnly {
        _token.transfer(_to, _amount);
    }

    function() public payable {}
    
}