// SPDX-License-Identifier: GNU-GPL v3.0 or later

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "../../interfaces/IOutputReceiverV2.sol";
import "../../interfaces/ITokenVault.sol";
import "../../interfaces/IRevest.sol";
import "../../interfaces/IFeeReporter.sol";
import "../../interfaces/IFNFTHandler.sol";
import "../../interfaces/ILockManager.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import '@openzeppelin/contracts/utils/introspection/ERC165.sol';
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/**
 * @title
 * @dev could add ability to airdrop ERC1155s to this, make things even more interesting
 */

contract NFTLocker is IOutputReceiverV2, Ownable, ERC165, ERC721Holder, ReentrancyGuard, IFeeReporter {
    using SafeERC20 for IERC20;

    address public addressRegistry;
    string public  metadata;
    uint public constant PRECISION = 10**27;

    // Will concatenate with ID
    string private constant REWARDS_ENDPOINT = "https://lambda.revest.finance/api/getRewardsForNFTLocker/"; 
    string private constant ARGUMENTS_FACTORY = "https://lambda.revest.finance/api/getParamsForNFTLocker/"; 

    struct ERC721Data {
        uint[] tokenIds;
        uint index;
        address erc721;
    }

    struct Balance {
        uint curMul;
        uint lastMul;
    }

    event AirdropEvent(address indexed token, address indexed erc721, uint indexed update_index, uint amount);
    event LockedNFTEvent(address indexed erc721, uint indexed tokenId, uint indexed fnftId, uint update_index);
    event ClaimedReward(address indexed token, address indexed erc721, uint indexed fnftId, uint update_index, uint amount);

    uint public updateIndex = 1;

    // Map fnftId to ERC721Data object for that token
    mapping (uint => ERC721Data) public nfts;

    // Map ERC20 token address to latest update index for that token
    mapping (address => bytes32) public globalBalances;

    // Map ERC20 token updates from updateIndex to balances
    mapping (bytes32 => Balance) public updateEvents;

    // Map fnftId to mapping of ERC20 tokens to multipliers
    mapping (uint => mapping (address => uint)) public localMuls;

    // Map address of ERC721 to minimum length of locking period
    // If one has been set by the ERC721 owner
    mapping (address => uint) public minTimes;

    // Whitelist of NFTs which can be locked for free
    // Admission awarded by Revest DAO
    mapping (address => bool) public whitelisted;

    uint public MIN_PERIOD = 30 days; //Minimum lock-up of 30 days

    constructor(address _provider, string memory _meta) {
        addressRegistry = _provider;
        metadata = _meta;
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC165, IERC165) returns (bool) {
        return interfaceId == type(IOutputReceiver).interfaceId
            || interfaceId == type(IOutputReceiverV2).interfaceId
            || super.supportsInterface(interfaceId);
    }

    /// Allows for a user to deposit ERC721s
    /// @param endTime UTC for when the enclosing FNFT will unlock
    /// @param tokenIds a list of ERC721 Ids to lock
    /// @param erc721 the address of the ERC721 contract
    /// @param hardLock whether to allow transfer of the enclosing ERC1155 FNFT
    /// @dev you should not stake and fractionalize at the same time, as this results in a race condition
    function mintTimeLock(
        uint endTime,
        uint[] memory tokenIds,
        address erc721,
        bool hardLock
    ) external payable returns (uint fnftId) {
        require(( minTimes[erc721] == 0 && endTime - block.timestamp >= MIN_PERIOD) || 
                ( minTimes[erc721] > 0 && endTime - block.timestamp >= minTimes[erc721]), 
                'Must lock for longer than minimum');
        IRevest.FNFTConfig memory fnftConfig;
        fnftConfig.pipeToContract = address(this);
        fnftConfig.nontransferrable = hardLock;


        // Mint FNFT
        uint[] memory quantities = new uint[](1);
        // FNFT quantity will always be singular
        quantities[0] = 1;
        address[] memory recipients = new address[](1);
        recipients[0] = msg.sender;

        fnftId = getRevest().mintTimeLock{value:msg.value}(endTime, recipients, quantities, fnftConfig);

        // Transfer NFT to this contract
        // Implicitly checks if holder owns NFT
        for(uint i = 0; i < tokenIds.length; i++) {
            IERC721(erc721).safeTransferFrom(msg.sender, address(this), tokenIds[i], '');
            emit LockedNFTEvent(erc721, tokenIds[i], fnftId, updateIndex);
        }

        // Store data
        nfts[fnftId] = ERC721Data(tokenIds, updateIndex, erc721);
    }

    /// Function to allow for the withdrawal of the underlying NFT
    function receiveRevestOutput(
        uint fnftId,
        address,
        address payable owner,
        uint
    ) external override  {
        require(_msgSender() == IAddressRegistry(addressRegistry).getTokenVault(), 'E016');
        ERC721Data memory nft = nfts[fnftId];

        // Transfer ownership of the underlying NFT to the caller
        for(uint i = 0; i < nft.tokenIds.length; i++) {
            IERC721(nft.erc721).safeTransferFrom(address(this), owner, nft.tokenIds[i]);
        }
        // Unfortunately, we do not have a way to detect what tokens need to be auto withdrawn from
        // So you will need to claim all rewards from your NFT prior to withdrawing it
        delete nfts[fnftId]; // Remove the mapping entirely, refund some gas
    }

    // Not applicable, as these cannot be split
    function handleFNFTRemaps(uint, uint[] memory, address, bool) external pure override {
        require(false,'Unauthorized Method');
    }

    // We have no use for this functionality here, and honestly, I'm not sure if it is worthy of being a final candidate
    // Causes all sorts of funkiness with gas, and we can implement much of it with other features
    function receiveSecondaryCallback(
        uint fnftId,
        address payable owner,
        uint quantity,
        IRevest.FNFTConfig memory config,
        bytes memory args
    ) external payable override {}

    // This is crucial
    function triggerOutputReceiverUpdate(
        uint fnftId,
        bytes memory args
    ) external override {
        (uint[] memory timeIndices, address[] memory tokens) = abi.decode(args, (uint[], address[]));
        claimRewardsBatch(fnftId, timeIndices, tokens);
    }

    function airdropTokens(uint amount, address token, address erc721) external {
        IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
        uint totalAllocPoints = IERC721(erc721).balanceOf(address(this));
        require(totalAllocPoints > 0, 'E076');
        uint newMulComponent = amount * PRECISION / totalAllocPoints;
        uint current = updateEvents[globalBalances[token]].curMul;
        if(current == 0) {
            // New token, need to initialize to precision
            current = PRECISION;
        }
        Balance memory bal = Balance(current + newMulComponent, current);
        bytes32 key = getBalanceKey(updateIndex, token);
        updateEvents[key] = bal;
        globalBalances[token] = key;
        emit AirdropEvent(token, erc721, updateIndex, amount);
        updateIndex++;
    }

    /// Allows a user to claim their rewards
    /// @param fnftId the FNFT ID to claim the rewards for
    /// @param timeIndex the time index to look at. Must be discovered off-chain as closest to staking event
    function claimRewards(
        uint fnftId,
        uint timeIndex,
        address token
    ) external nonReentrant {
        IAddressRegistry reg = IAddressRegistry(addressRegistry);
        require(IFNFTHandler(reg.getRevestFNFT()).getBalance(_msgSender(), fnftId) > 0, 'E064');
        _claimRewards(fnftId, timeIndex, token);
    }

    function claimRewardsBatch(
        uint fnftId,
        uint[] memory timeIndices,
        address[] memory tokens
    ) public nonReentrant {
        require(timeIndices.length == tokens.length, 'E067');
        IAddressRegistry reg = IAddressRegistry(addressRegistry);
        require(IFNFTHandler(reg.getRevestFNFT()).getBalance(_msgSender(), fnftId) > 0, 'E064');
        for(uint i = 0; i < timeIndices.length; i++) {
            _claimRewards(fnftId, timeIndices[i], tokens[i]);
        }
    }

    // Time index will correspond to a DepositEvent created after the NFT was staked
    function _claimRewards(
        uint fnftId,
        uint timeIndex,
        address token
    ) internal {
        uint localMul = localMuls[fnftId][token];
        require(nfts[fnftId].index <= timeIndex || localMul > 0, 'E075');
        Balance memory bal =updateEvents[globalBalances[token]];
        

        if(localMul == 0) {
            // Need to derive mul for token when NFT staked - use timeIndex
            localMul = updateEvents[getBalanceKey(timeIndex, token)].lastMul;
            require(localMul != 0, 'E081');
        }
        uint rewards = (bal.curMul - localMul) * nfts[fnftId].tokenIds.length / PRECISION;
        localMuls[fnftId][token] = bal.curMul;
        try IERC20(token).transfer(_msgSender(), rewards) returns (bool success) {
            //If this fails because the token is broken, we don't want to break everything
        } catch {}
        // If anything failed, we still want it wiped from pending rewards, as it has contract-level issues
        emit ClaimedReward(token, nfts[fnftId].erc721, fnftId, updateIndex, rewards);
    }

    function getRewards(
        uint fnftId,
        uint timeIndex,
        address token
    ) external view returns (uint rewards) {
        uint localMul = localMuls[fnftId][token];
        require(nfts[fnftId].index <= timeIndex || localMul > 0, 'E075');
        Balance memory bal =updateEvents[globalBalances[token]];

        if(localMul == 0) {
            // Need to derive mul for token when NFT staked - use timeIndex
            localMul = updateEvents[getBalanceKey(timeIndex, token)].lastMul;
            require(localMul != 0, 'E081');
        }
        rewards = (bal.curMul - localMul) * nfts[fnftId].tokenIds.length / PRECISION;
    }
    
    function setMinPeriod(address erc721, uint min) external {
        require(msg.sender == owner() || msg.sender == Ownable(erc721).owner(), 'Must have admin access to change min period');
        minTimes[erc721] = min;
    }
    
    function setGlobalMin(uint minPer) external onlyOwner {
        MIN_PERIOD = minPer;
    }

    function getCustomMetadata(uint) external view override returns (string memory) {
        return metadata;
    }

    function getValue(uint fnftId) external view override returns (uint) {
        return nfts[fnftId].tokenIds.length;
    }

    function getAsset(uint fnftId) external view override returns (address) {
        return nfts[fnftId].erc721;
    }

    function getOutputDisplayValues(uint fnftId) external view override returns (bytes memory) {
        ERC721Data memory nft = nfts[fnftId];
        // Display only the first image – and even then, we'll need to properly parse it
        string memory tokenURI = IERC721Metadata(nft.erc721).tokenURI(nft.tokenIds[0]);
        string memory endpoint = string(abi.encodePacked(REWARDS_ENDPOINT,uint2str(fnftId), '-',uint2str(block.chainid)));
        string memory argumentsGen = string(abi.encodePacked(ARGUMENTS_FACTORY,uint2str(fnftId),'-',uint2str(block.chainid)));

        return abi.encode(tokenURI, endpoint, argumentsGen, nft.tokenIds, nft.erc721, nft.index);
    }

    function setAddressRegistry(address addressRegistry_) external override onlyOwner {
        addressRegistry = addressRegistry_;
    }

    function getAddressRegistry() external view override returns (address) {
        return addressRegistry;
    }

    function getRevest() internal view returns (IRevest) {
        return IRevest(IAddressRegistry(addressRegistry).getRevest());
    }

    /**
     * @dev See {IERC721Receiver-onERC721Received}.
     *
     * Always returns `IERC721Receiver.onERC721Received.selector`.
     */
    function onERC721Received(
        address,
        address,
        uint256,
        bytes memory
    ) public virtual override returns (bytes4) {
        return this.onERC721Received.selector;
    }

    function getBalanceKey(uint num, address add) public pure returns (bytes32 hash_) {
        hash_ = keccak256(abi.encode(num, add));
    }

    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }   

    function setWhitelisted(address asset, bool whitelist) external onlyOwner {
        whitelisted[asset] = whitelist;
    }

    function emitManualEvent(address token, address erc721, uint fnftId, uint rewards) external onlyOwner {
        emit ClaimedReward(token, erc721, fnftId, updateIndex, rewards);
    }

    // For fees, we simply charge the default fee for using Revest

    function getFlatWeiFee(address asset) external view override returns (uint fee) {
        if(!whitelisted[asset]) {
            fee = getRevest().getFlatWeiFee();
        }
    }

    function getERC20Fee(address asset) external view override returns (uint fee) {
        if(!whitelisted[asset]) {
            fee = getRevest().getERC20Fee();
        }
    }
}
