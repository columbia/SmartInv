// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

import "./libraries/ERC20.sol";
import "./libraries/Ownable.sol";
import "./libraries/SafeMath_para.sol";
// WARNING: There is a known vuln contained within this contract related to vote delegation, 
// it's NOT recommmended to use this in production.  

// ParaToken with Governance.
contract ParaToken is ERC20("ParalUni Token", "T42"), Ownable {
    using SafeMath for uint256;

    uint denominator = 1e18;
    uint256 public hardLimit = 10000000000e18; // Hardtop: upper limit of total T42 issuance
    uint256 public _issuePerBlock = 1150e18;   // Initial issued quantity per block
    uint256 public startBlock;          // Issuing start block height
    uint256 public lastBlockHalve;             // Block height at last production reduction
    uint256 public lastSoftLimit = 0;          // Soft roof at last production reduction
    uint256 constant HALVE_INTERVAL = 880000;   // Number of production reduction interval blocks
    uint256 constant HALVE_RATE = 90;           // Production reduction ratio
    
    mapping(address => bool) public minersAddress;
    //Whereabouts of fines
    address public fineAcceptAddress;
    //
    mapping(address => bool) public whiteAdmins;
    mapping(address => bool) public whitelist;
    mapping(address => bool) public fromWhitelist;
    mapping(address => bool) public toWhitelist;
    //User maturity
    mapping(address => Maturity) public userMaturity;

    struct Maturity {
        //Height of recently transferred block
        uint lastBlockHalve;
        //Number of blocks held (time)
        uint blockNum;
        //Balance in white list contract
        uint whiteBalance;
    }

    constructor(uint _startBlock) public {
        startBlock = _startBlock;
        lastBlockHalve = _startBlock;
    }
    
    //set _setMinerAddress
    function _setMinerAddress(address _minerAddress, bool flag) external onlyOwner{
        minersAddress[_minerAddress] = flag;
    }
    
    //set _setFineAcceptAddress
    function _setFineAcceptAddress(address _fineAcceptAddress) external onlyOwner{
        fineAcceptAddress = _fineAcceptAddress;
    }
    
    //set whiteAdmin
    function _setWhiteAdmin(address _whiteAdmin, bool flag) external onlyOwner{
        whiteAdmins[_whiteAdmin] = flag;
    }

    function _setWhiteListAll(uint whiteType, address[] memory users, bool[] memory flags) external onlyOwner{
        require(users.length == flags.length);
        for(uint i = 0; i < users.length; i++){
           _setWhiteList(whiteType, users[i], flags[i]);
        }
    }

    function _setWhiteList(uint whiteType, address user, bool flag) public{
        //auth
        require(whiteAdmins[address(msg.sender)] || address(msg.sender) == owner(), "WhiteList:auth");
        if(whiteType == 0){
            whitelist[user] = flag;
        }
        if(whiteType == 1){
            fromWhitelist[user] = flag;
        }
        if(whiteType == 2){
            toWhitelist[user] = flag;
        }
    }

    /// @dev overrides transfer function to meet tokenomics of TENGU
    function _transfer(address sender, address recipient, uint256 amount) internal virtual override {
        uint fine = 0;
         //Transfer out determines whether the receiving address is a white list address: accumulates the virtual balance of the transferor
        if(whitelist[recipient] || toWhitelist[recipient]){
            //The recipient is a whitelist sender, not a sender. You only need to update the virtual balance from
            if(!whitelist[sender]){
                //user sender maturity stroage
                Maturity storage maturity = userMaturity[sender];
                maturity.whiteBalance = maturity.whiteBalance.add(amount);
            }
        }else{
            //Update the number of blocks if necessary
            //user recipient maturity stroage
            Maturity storage maturity = userMaturity[recipient];
            if(maturity.lastBlockHalve == 0){
                maturity.lastBlockHalve = block.number;
            }
            //Sender is a white list and recipient is not a white list. You only need to deduct the virtual balance of the recipient
            if(whitelist[sender] || fromWhitelist[sender]){
                if(!fromWhitelist[sender]){
                    if(maturity.whiteBalance >= amount){
                        /** ===== set storage =====   */
                        maturity.whiteBalance = maturity.whiteBalance.sub(amount);
                    }else{
                        /** ===== set storage =====   */
                        maturity.whiteBalance = 0;
                    }
                }
            }else{
                //Neither are whitelisted
                //The penalty calculation for the transferer: non-whitelisted address
                fine = getFine(sender, amount);
                //Calculate the maturity of the transferee
                //Virtual balance
                uint virtualAmount = balanceOf(recipient).add(maturity.whiteBalance);
                (uint currentMaturityTo, ) = currentMaturity(recipient);
                //Update maturity
                uint latestMaturity = 0;
                if(virtualAmount.add(amount) > 0){
                   latestMaturity = virtualAmount.mul(currentMaturityTo).div(virtualAmount.add(amount));
                }        
                //Get the latest x0 according to the latest maturity
                uint newBlockNum = getBlockNumByMaturity(latestMaturity);

                /** ===== set storage =====   */
                maturity.blockNum = newBlockNum;
                maturity.lastBlockHalve = block.number;
            }
        }
        //Modify the penalty disposal method
        super._transfer(sender, recipient, amount.sub(fine));
        if(fine > 0){
            super._transfer(sender, fineAcceptAddress, fine);    
        }
    }

    function currentMaturity(address user) public view returns (uint mturityValue, uint blockNeeded){
        //user recipient maturity stroage
        Maturity memory maturity = userMaturity[user];
        uint short = block.number.sub(maturity.lastBlockHalve);
        if(maturity.lastBlockHalve == 0){
            short = 0;
        }
        uint x0 = maturity.blockNum.add(short);
        (mturityValue, blockNeeded) = getMaturity(x0);
    }

    //mul(1e18)
    function getMaturity(uint blockNum) internal view returns (uint maturity, uint blockNeeded) {
        if(blockNum < uint(403200)){
            blockNeeded = uint(403200).sub(blockNum);
        }
        blockNum = blockNum.mul(denominator);
        if(blockNum < uint(201600).mul(denominator)){
            maturity = blockNum.div(806400);
        }
        if(blockNum >= uint(201600).mul(denominator) && blockNum < uint(403200).mul(denominator)){
            maturity = blockNum.div(268800).sub(5e17); //5e17 = 1e18* 0.5
        }
        if(blockNum >= uint(403200).mul(denominator)){
            maturity = 1e18;
        }
    }

   function getBlockNumByMaturity(uint maturity)internal view returns (uint blockNum){
       if(maturity < 0.25e18){
           return maturity.mul(806400).div(denominator);
       }
       if(maturity >= 0.25e18 && maturity < 1e18){
           return maturity.add(5e17).mul(268800).div(denominator);
       }
       if(maturity >= 1e18){
           return 403200;
       }
   }

   function getFine(address user, uint amount) public view returns (uint) {
        // amount x ( 1 - Maturity ) x 20%
        (uint currentMaturityFrom, ) = currentMaturity(user);
        return amount.mul(denominator.sub(currentMaturityFrom)).div(5).div(denominator);
   }

    /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
    function mint(address _to, uint256 _amount) public { 
        require(minersAddress[msg.sender], "!mint:auth");
        // Check hard top, soft top
        uint256 newTotal = totalSupply().add(_amount);
        updateSoftLimit();
        //TODO
        require(newTotal <= softLimit(), "^softLimit");
        require(newTotal <= hardLimit, "^hardLimit");

        _mint(_to, _amount);
        _moveDelegates(address(0), _delegates[_to], _amount);
    }

    // Calculate T42 current circulation soft top
    function updateSoftLimit() internal {
        if(block.number > startBlock){
            uint256 n = block.number.sub(startBlock).div(HALVE_INTERVAL) 
                    - lastBlockHalve.sub(startBlock).div(HALVE_INTERVAL);
            // Usually n is 0 or 1
            for (uint i = 0; i < n; i++) {
                lastSoftLimit = lastSoftLimit.add(_issuePerBlock.mul(HALVE_INTERVAL));
                _issuePerBlock = _issuePerBlock.mul(HALVE_RATE).div(100);
                lastBlockHalve = block.number;
            }
        }
    }

    function softLimit() public view returns (uint) {
        uint256 _lastSoftLimit = lastSoftLimit;
        uint256 _lastBlockHalve = lastBlockHalve;
        uint256 __issuePerBlock = _issuePerBlock;
        if(block.number > startBlock){
            uint256 n = block.number.sub(startBlock).div(HALVE_INTERVAL) - lastBlockHalve.sub(startBlock).div(HALVE_INTERVAL);
            // Usually n is 0 or 1
            for (uint i = 0; i < n; i++) {
                _lastSoftLimit = _lastSoftLimit.add(__issuePerBlock.mul(HALVE_INTERVAL));
                __issuePerBlock = __issuePerBlock.mul(HALVE_RATE).div(100);
                _lastBlockHalve = block.number;
            }
            uint256 blocks = block.number.sub(_lastBlockHalve).add(1);
            return _lastSoftLimit.add(__issuePerBlock.mul(blocks));
        }
        return 0;
    }

    function issuePerBlock() public view returns (uint) {
        uint retval = _issuePerBlock;
        if (block.number >= startBlock) {
            uint256 n = block.number.sub(startBlock).div(HALVE_INTERVAL) - lastBlockHalve.sub(startBlock).div(HALVE_INTERVAL);
            // Usually n is 0 or 1
            for (uint i = 0; i < n; i++) {
                retval = retval.mul(HALVE_RATE).div(100);
            }
            return retval;
        }
        //There is no profit before mining starts
        return 0;
    }

    // Copied and modified from YAM code:
    // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
    // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
    // Which is copied and modified from COMPOUND:
    // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol

    /// @notice A record of each accounts delegate
    mapping (address => address) internal _delegates;

    /// @notice A checkpoint for marking number of votes from a given block
    struct Checkpoint {
        uint32 fromBlock;
        uint256 votes;
    }

    /// @notice A record of votes checkpoints for each account, by index
    mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;

    /// @notice The number of checkpoints for each account
    mapping (address => uint32) public numCheckpoints;

    /// @notice The EIP-712 typehash for the contract's domain
    bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");

    /// @notice The EIP-712 typehash for the delegation struct used by the contract
    bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");

    /// @notice A record of states for signing / validating signatures
    mapping (address => uint) public nonces;

      /// @notice An event thats emitted when an account changes its delegate
    event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);

    /// @notice An event thats emitted when a delegate account's vote balance changes
    event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);

    /**
     * @notice Delegate votes from `msg.sender` to `delegatee`
     * @param delegator The address to get delegatee for
     */
    function delegates(address delegator)
        external
        view
        returns (address)
    {
        return _delegates[delegator];
    }

   /**
    * @notice Delegate votes from `msg.sender` to `delegatee`
    * @param delegatee The address to delegate votes to
    */
    function delegate(address delegatee) external {
        return _delegate(msg.sender, delegatee);
    }

    /**
     * @notice Delegates votes from signatory to `delegatee`
     * @param delegatee The address to delegate votes to
     * @param nonce The contract state required to match the signature
     * @param expiry The time at which to expire the signature
     * @param v The recovery byte of the signature
     * @param r Half of the ECDSA signature pair
     * @param s Half of the ECDSA signature pair
     */
    function delegateBySig(
        address delegatee,
        uint nonce,
        uint expiry,
        uint8 v,
        bytes32 r,
        bytes32 s
    )
        external
    {
        bytes32 domainSeparator = keccak256(
            abi.encode(
                DOMAIN_TYPEHASH,
                keccak256(bytes(name())),
                getChainId(),
                address(this)
            )
        );

        bytes32 structHash = keccak256(
            abi.encode(
                DELEGATION_TYPEHASH,
                delegatee,
                nonce,
                expiry
            )
        );

        bytes32 digest = keccak256(
            abi.encodePacked(
                "\x19\x01",
                domainSeparator,
                structHash
            )
        );

        address signatory = ecrecover(digest, v, r, s);
        require(signatory != address(0), "PARA::delegateBySig: invalid signature");
        require(nonce == nonces[signatory]++, "PARA::delegateBySig: invalid nonce");
        require(now <= expiry, "PARA::delegateBySig: signature expired");
        return _delegate(signatory, delegatee);
    }

    /**
     * @notice Gets the current votes balance for `account`
     * @param account The address to get votes balance
     * @return The number of current votes for `account`
     */
    function getCurrentVotes(address account)
        external
        view
        returns (uint256)
    {
        uint32 nCheckpoints = numCheckpoints[account];
        return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
    }

    /**
     * @notice Determine the prior number of votes for an account as of a block number
     * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
     * @param account The address of the account to check
     * @param blockNumber The block number to get the vote balance at
     * @return The number of votes the account had as of the given block
     */
    function getPriorVotes(address account, uint blockNumber)
        external
        view
        returns (uint256)
    {
        require(blockNumber < block.number, "PARA::getPriorVotes: not yet determined");

        uint32 nCheckpoints = numCheckpoints[account];
        if (nCheckpoints == 0) {
            return 0;
        }

        // First check most recent balance
        if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
            return checkpoints[account][nCheckpoints - 1].votes;
        }

        // Next check implicit zero balance
        if (checkpoints[account][0].fromBlock > blockNumber) {
            return 0;
        }

        uint32 lower = 0;
        uint32 upper = nCheckpoints - 1;
        while (upper > lower) {
            uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
            Checkpoint memory cp = checkpoints[account][center];
            if (cp.fromBlock == blockNumber) {
                return cp.votes;
            } else if (cp.fromBlock < blockNumber) {
                lower = center;
            } else {
                upper = center - 1;
            }
        }
        return checkpoints[account][lower].votes;
    }

    function _delegate(address delegator, address delegatee)
        internal
    {
        address currentDelegate = _delegates[delegator];
        uint256 delegatorBalance = balanceOf(delegator); // balance of underlying T42s (not scaled);
        _delegates[delegator] = delegatee;

        emit DelegateChanged(delegator, currentDelegate, delegatee);

        _moveDelegates(currentDelegate, delegatee, delegatorBalance);
    }

    function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
        if (srcRep != dstRep && amount > 0) {
            if (srcRep != address(0)) {
                // decrease old representative
                uint32 srcRepNum = numCheckpoints[srcRep];
                uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
                uint256 srcRepNew = srcRepOld.sub(amount);
                _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
            }

            if (dstRep != address(0)) {
                // increase new representative
                uint32 dstRepNum = numCheckpoints[dstRep];
                uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
                uint256 dstRepNew = dstRepOld.add(amount);
                _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
            }
        }
    }

    function _writeCheckpoint(
        address delegatee,
        uint32 nCheckpoints,
        uint256 oldVotes,
        uint256 newVotes
    )
        internal
    {
        uint32 blockNumber = safe32(block.number, "PARA::_writeCheckpoint: block number exceeds 32 bits");

        if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
            checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
        } else {
            checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
            numCheckpoints[delegatee] = nCheckpoints + 1;
        }

        emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
    }

    function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
        require(n < 2**32, errorMessage);
        return uint32(n);
    }

    function getChainId() internal pure returns (uint) {
        uint256 chainId;
        assembly { chainId := chainid() }
        return chainId;
    }
}