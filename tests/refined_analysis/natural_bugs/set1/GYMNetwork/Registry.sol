// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.9;

import { ECDSA } from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import { IERC20Token } from "./interfaces/IERC20Token.sol";
import { IHermesContract } from "./interfaces/IHermesContract.sol";
import { FundsRecovery } from "./FundsRecovery.sol";
import { Utils } from "./Utils.sol";

interface Channel {
    function initialize(address _token, address _dex, address _identityHash, address _hermesId, uint256 _fee) external;
}

contract Registry is FundsRecovery, Utils {
    using ECDSA for bytes32;

    uint256 public lastNonce;
    address payable public dex;     // Any uniswap v2 compatible DEX router address
    uint256 public minimalHermesStake;
    Registry public parentRegistry; // Contract could have parent registry if Registry SC was already upgraded

    struct Implementation {
        address channelImplAddress;
        address hermesImplAddress;
    }
    Implementation[] internal implementations;

    struct Hermes {
        address operator;   // hermes operator who will sign promises
        uint256 implVer;    // version of hermes implementation smart contract
        function() external view returns(uint256) stake;
        bytes url;          // hermes service URL
    }
    mapping(address => Hermes) private hermeses;

    mapping(address => address) private identities;   // key: identity, value: beneficiary wallet address

    event RegisteredIdentity(address indexed identity, address beneficiary);
    event RegisteredHermes(address indexed hermesId, address hermesOperator, bytes ur);
    event HermesURLUpdated(address indexed hermesId, bytes newURL);
    event ConsumerChannelCreated(address indexed identity, address indexed hermesId, address channelAddress);
    event BeneficiaryChanged(address indexed identity, address newBeneficiary);
    event MinimalHermesStakeChanged(uint256 newMinimalStake);

    // Reject any ethers sent to this smart-contract
    receive() external payable {
        revert("Registry: Rejecting tx with ethers sent");
    }

    // We're using `initialize` instead of `constructor` to ensure easy way to deploy Registry into
    // deterministic address on any EVM compatible chain. Registry should be first be deployed using
    // `deployRegistry` scripts and then initialized with wanted token and implementations.
    function initialize(address _tokenAddress, address payable _dexAddress, uint256 _minimalHermesStake, address _channelImplementation, address _hermesImplementation, address payable _parentRegistry) public onlyOwner {
        require(!isInitialized(), "Registry: is already initialized");

        minimalHermesStake = _minimalHermesStake;

        require(_tokenAddress != address(0), "Registry: token smart contract can't be deployed into 0x0 address");
        token = IERC20Token(_tokenAddress);

        require(_dexAddress != address(0), "Registry: dex can't be deployed into 0x0 address");
        dex = _dexAddress;

        // Set initial channel implementations
        setImplementations(_channelImplementation, _hermesImplementation);

        // We set initial owner to be sure
        transferOwnership(msg.sender);

        // Set parent registry, if `0x0` then this is root registry
        parentRegistry = Registry(_parentRegistry);
    }

    function isInitialized() public view returns (bool) {
        return address(token) != address(0);
    }

    // Register provider and open his channel with given hermes
    // _stakeAmount - it's amount of tokens staked into hermes to guarantee incomming channel's balance.
    // _beneficiary - payout address during settlements in hermes channel, if provided 0x0 then will be set to consumer channel address.
    function registerIdentity(address _hermesId, uint256 _stakeAmount, uint256 _transactorFee, address _beneficiary, bytes memory _signature) public {
        require(isActiveHermes(_hermesId), "Registry: provided hermes have to be active");

        // Check if given signature is valid
        address _identity = keccak256(abi.encodePacked(getChainID(), address(this), _hermesId, _stakeAmount, _transactorFee, _beneficiary)).recover(_signature);
        require(_identity != address(0), "Registry: wrong identity signature");

        // Tokens amount to get from channel to cover tx fee and provider's stake
        uint256 _totalFee = _stakeAmount + _transactorFee;
        require(_totalFee <= token.balanceOf(getChannelAddress(_identity, _hermesId)), "Registry: not enough funds in channel to cover fees");

        // Open consumer channel
        _openChannel(_identity, _hermesId, _beneficiary, _totalFee);

        // If stake is provided we additionally are opening channel with hermes (a.k.a provider channel)
        if (_stakeAmount > 0) {
            IHermesContract(_hermesId).openChannel(_identity, _stakeAmount);
        }

        // Pay fee for transaction maker
        if (_transactorFee > 0) {
            token.transfer(msg.sender, _transactorFee);
        }
    }

    // Deploys consumer channel and sets beneficiary as newly created channel address
    function openConsumerChannel(address _hermesId, uint256 _transactorFee, bytes memory _signature) public {
        require(isActiveHermes(_hermesId), "Registry: provided hermes have to be active");

        // Check if given signature is valid
        address _identity = keccak256(abi.encodePacked(getChainID(), address(this), _hermesId, _transactorFee)).recover(_signature);
        require(_identity != address(0), "Registry: wrong channel openinig signature");

        require(_transactorFee <= token.balanceOf(getChannelAddress(_identity, _hermesId)), "Registry: not enough funds in channel to cover fees");

        _openChannel(_identity, _hermesId, address(0), _transactorFee);
    }

    // Allows to securely deploy channel's smart contract without consumer signature
    function openConsumerChannel(address _identity, address _hermesId) public {
        require(isActiveHermes(_hermesId), "Registry: provided hermes have to be active");
        require(!isChannelOpened(_identity, _hermesId), "Registry: such consumer channel is already opened");

        _openChannel(_identity, _hermesId, address(0), 0);
    }

    // Deploy payment channel for given consumer identity
    // We're using minimal proxy (EIP1167) to save on gas cost and blockchain space.
    function _openChannel(address _identity, address _hermesId, address _beneficiary, uint256 _fee) internal returns (address) {
        bytes32 _salt = keccak256(abi.encodePacked(_identity, _hermesId));
        bytes memory _code = getProxyCode(getChannelImplementation(hermeses[_hermesId].implVer));
        Channel _channel = Channel(deployMiniProxy(uint256(_salt), _code));
        _channel.initialize(address(token), dex, _identity, _hermesId, _fee);

        emit ConsumerChannelCreated(_identity, _hermesId, address(_channel));

        // If beneficiary was not provided, then we're going to use consumer channel for that
        if (_beneficiary == address(0)) {
            _beneficiary = address(_channel);
        }

        // Mark identity as registered (only during first channel opening)
        if (!isRegistered(_identity)) {
            identities[_identity] = _beneficiary;
            emit RegisteredIdentity(_identity, _beneficiary);
        }

        return address(_channel);
    }

    function registerHermes(address _hermesOperator, uint256 _hermesStake, uint16 _hermesFee, uint256 _minChannelStake, uint256 _maxChannelStake, bytes memory _url) public {
        require(isInitialized(), "Registry: only initialized registry can register hermeses");
        require(_hermesOperator != address(0), "Registry: hermes operator can't be zero address");
        require(_hermesStake >= minimalHermesStake, "Registry: hermes have to stake at least minimal stake amount");

        address _hermesId = getHermesAddress(_hermesOperator);
        require(!isHermes(_hermesId), "Registry: hermes already registered");

        // Deploy hermes contract (mini proxy which is pointing to implementation)
        IHermesContract _hermes = IHermesContract(deployMiniProxy(uint256(uint160(_hermesOperator)), getProxyCode(getHermesImplementation())));

        // Transfer stake into hermes smart contract
        token.transferFrom(msg.sender, address(_hermes), _hermesStake);

        // Initialise hermes
        _hermes.initialize(address(token), _hermesOperator, _hermesFee, _minChannelStake, _maxChannelStake, dex);

        // Save info about newly created hermes
        hermeses[_hermesId] = Hermes(_hermesOperator, getLastImplVer(), _hermes.getStake, _url);

        // Approve hermes contract to `transferFrom` registry (used during hermes channel openings)
        token.approve(_hermesId, type(uint256).max);

        emit RegisteredHermes(_hermesId, _hermesOperator, _url);
    }

    function getChannelAddress(address _identity, address _hermesId) public view returns (address) {
        bytes32 _code = keccak256(getProxyCode(getChannelImplementation(hermeses[_hermesId].implVer)));
        bytes32 _salt = keccak256(abi.encodePacked(_identity, _hermesId));
        return getCreate2Address(_salt, _code);
    }

    function getHermes(address _hermesId) public view returns (Hermes memory) {
        return isHermes(_hermesId) || !hasParentRegistry() ? hermeses[_hermesId] : parentRegistry.getHermes(_hermesId);
    }

    function getHermesAddress(address _hermesOperator) public view returns (address) {
        bytes32 _code = keccak256(getProxyCode(getHermesImplementation()));
        return getCreate2Address(bytes32(uint256(uint160(_hermesOperator))), _code);
    }

    function getHermesAddress(address _hermesOperator, uint256 _implVer) public view returns (address) {
        bytes32 _code = keccak256(getProxyCode(getHermesImplementation(_implVer)));
        return getCreate2Address(bytes32(uint256(uint160(_hermesOperator))), _code);
    }

    function getHermesURL(address _hermesId) public view returns (bytes memory) {
        return hermeses[_hermesId].url;
    }

    function updateHermesURL(address _hermesId, bytes memory _url, bytes memory _signature) public {
        require(isActiveHermes(_hermesId), "Registry: provided hermes has to be active");

        // Check if given signature is valid
        address _operator = keccak256(abi.encodePacked(address(this), _hermesId, _url, lastNonce++)).recover(_signature);
        require(_operator == hermeses[_hermesId].operator, "wrong signature");

        // Update URL
        hermeses[_hermesId].url = _url;

        emit HermesURLUpdated(_hermesId, _url);
    }

    // ------------ UTILS ------------
    function getCreate2Address(bytes32 _salt, bytes32 _code) internal view returns (address) {
        return address(uint160(uint256(keccak256(abi.encodePacked(
            bytes1(0xff),
            address(this),
            bytes32(_salt),
            bytes32(_code)
        )))));
    }

    function getProxyCode(address _implementation) public pure returns (bytes memory) {
        // `_code` is EIP 1167 - Minimal Proxy Contract
        // more information: https://eips.ethereum.org/EIPS/eip-1167
        bytes memory _code = hex"3d602d80600a3d3981f3363d3d373d3d3d363d73bebebebebebebebebebebebebebebebebebebebe5af43d82803e903d91602b57fd5bf3";

        bytes20 _targetBytes = bytes20(_implementation);
        for (uint8 i = 0; i < 20; i++) {
            _code[20 + i] = _targetBytes[i];
        }

        return _code;
    }

    function deployMiniProxy(uint256 _salt, bytes memory _code) internal returns (address payable) {
        address payable _addr;

        assembly {
            _addr := create2(0, add(_code, 0x20), mload(_code), _salt)
            if iszero(extcodesize(_addr)) {
                revert(0, 0)
            }
        }

        return _addr;
    }

    function getBeneficiary(address _identity) public view returns (address) {
        if (hasParentRegistry())
            return parentRegistry.getBeneficiary(_identity);

        return identities[_identity];
    }

    function setBeneficiary(address _identity, address _newBeneficiary, bytes memory _signature) public {
        require(_newBeneficiary != address(0), "Registry: beneficiary can't be zero address");

        // Always set beneficiary into root registry
        if (hasParentRegistry()) {
            parentRegistry.setBeneficiary(_identity, _newBeneficiary, _signature);
        } else {
            lastNonce = lastNonce + 1;

            // In signatures we should always use root registry (for backward compatibility)
            address _rootRegistry = hasParentRegistry() ? address(parentRegistry) : address(this);
            address _signer = keccak256(abi.encodePacked(getChainID(), _rootRegistry, _identity, _newBeneficiary, lastNonce)).recover(_signature);
            require(_signer == _identity, "Registry: have to be signed by identity owner");

            identities[_identity] = _newBeneficiary;

            emit BeneficiaryChanged(_identity, _newBeneficiary);
        }
    }

    function setMinimalHermesStake(uint256 _newMinimalStake) public onlyOwner {
        require(isInitialized(), "Registry: only initialized registry can set new minimal hermes stake");
        minimalHermesStake = _newMinimalStake;
        emit MinimalHermesStakeChanged(_newMinimalStake);
    }

    // -------- UTILS TO WORK WITH CHANNEL AND HERMES IMPLEMENTATIONS ---------

    function getChannelImplementation() public view returns (address) {
        return implementations[getLastImplVer()].channelImplAddress;
    }

    function getChannelImplementation(uint256 _implVer) public view returns (address) {
        return implementations[_implVer].channelImplAddress;
    }

    function getHermesImplementation() public view returns (address) {
        return implementations[getLastImplVer()].hermesImplAddress;
    }

    function getHermesImplementation(uint256 _implVer) public view returns (address) {
        return implementations[_implVer].hermesImplAddress;
    }

    function setImplementations(address _newChannelImplAddress, address _newHermesImplAddress) public onlyOwner {
        require(isInitialized(), "Registry: only initialized registry can set new implementations");
        require(isSmartContract(_newChannelImplAddress) && isSmartContract(_newHermesImplAddress), "Registry: implementations have to be smart contracts");
        implementations.push(Implementation(_newChannelImplAddress, _newHermesImplAddress));
    }

    // Version of latest hermes and channel implementations
    function getLastImplVer() public view returns (uint256) {
        return implementations.length-1;
    }

    // ------------------------------------------------------------------------

    function isSmartContract(address _addr) internal view returns (bool) {
        uint _codeLength;

        assembly {
            _codeLength := extcodesize(_addr)
        }

        return _codeLength != 0;
    }

    // If `parentRegistry` is not set, this is root registry and should return false
    function hasParentRegistry() public view returns (bool) {
        return address(parentRegistry) != address(0);
    }

    function isRegistered(address _identity) public view returns (bool) {
        if (hasParentRegistry())
            return parentRegistry.isRegistered(_identity);

        // If we know its beneficiary address it is registered identity
        return identities[_identity] != address(0);
    }

    function isHermes(address _hermesId) public view returns (bool) {
        // To check if it actually properly created hermes address, we need to check if he has operator
        // and if with that operator we'll get proper hermes address which has code deployed there.
        address _hermesOperator = hermeses[_hermesId].operator;
        uint256 _implVer = hermeses[_hermesId].implVer;
        address _addr = getHermesAddress(_hermesOperator, _implVer);
        if (_addr != _hermesId)
            return false; // hermesId should be same as generated address

        return isSmartContract(_addr) || parentRegistry.isHermes(_hermesId);
    }

    function isActiveHermes(address _hermesId) internal view returns (bool) {
        // First we have to ensure that given address is registered hermes and only then check its status
        require(isHermes(_hermesId), "Registry: hermes have to be registered");

        IHermesContract.Status status = IHermesContract(_hermesId).getStatus();
        return status == IHermesContract.Status.Active;
    }

    function isChannelOpened(address _identity, address _hermesId) public view returns (bool) {
        return isSmartContract(getChannelAddress(_identity, _hermesId)) || isSmartContract(parentRegistry.getChannelAddress(_identity, _hermesId));
    }

    function transferCollectedFeeTo(address _beneficiary) public onlyOwner{
        uint256 _collectedFee = token.balanceOf(address(this));
        require(_collectedFee > 0, "collected fee cannot be less than zero");
        token.transfer(_beneficiary, _collectedFee);
    }
}
