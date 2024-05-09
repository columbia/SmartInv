pragma solidity ^0.5.15;

library SafeMath {
    
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        
        
        
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        
        require(b > 0, errorMessage);
        uint256 c = a / b;
        

        return c;
    }

    
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: @openzeppelin/contracts/utils/Address.sol

pragma solidity ^0.5.5;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * This test is non-exhaustive, and there may be false-negatives: during the
     * execution of a contract's constructor, its address will be reported as
     * not containing a contract.
     *
     * IMPORTANT: It is unsafe to assume that an address for which this
     * function returns false is an externally-owned account (EOA) and not a
     * contract.
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != 0x0 && codehash != accountHash);
    }

    /**
     * @dev Converts an `address` into `address payable`. Note that this is
     * simply a type cast: the actual underlying value is not changed.
     *
     * _Available since v2.4.0._
     */
    function toPayable(address account) internal pure returns (address payable) {
        return address(uint160(account));
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     *
     * _Available since v2.4.0._
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-call-value
        (bool success, ) = recipient.call.value(amount)("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}


/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves.

        // A Solidity high level call has three parts:
        //  1. The target address is checked to verify it contains contract code
        //  2. The call itself is made, and success asserted
        //  3. The return value is decoded, which in turn checks the size of the returned data.
        // solhint-disable-next-line max-line-length
        require(address(token).isContract(), "SafeERC20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

contract Context {
    
    
    constructor () internal { }
    

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; 
        return msg.data;
    }
}

contract Ownable is Context {
    
    using SafeMath for uint256;
    
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    
    constructor () internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    
    function owner() public view returns (address) {
        return _owner;
    }

    
    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    
    function isOwner() public view returns (bool) {
        return _msgSender() == _owner;
    }

    
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

interface PZSConfig {
    
    function getStage(uint8 version) external view returns(uint256 minimum,uint256 maximum,uint256 period,uint256 scale,uint256 totalSuply,uint256 startTime,uint256 partnerBecome);
    
    function checkStart(uint8 version) external view returns(bool);
    
    function partnerBecome(uint8 version) external view returns(uint256);
    
    function underway() external view returns(uint8);
    
    function getCommon() external view returns(uint256 withdrawFee,uint256 partnerBecomePercent,uint256 partnerDirectPercent,uint256 partnerReferRewardPercent,uint256[2] memory referRewardPercent);

}

contract PZSSub is Ownable{
    
    using SafeMath for uint256;
    
    using SafeERC20 for IERC20;
    
    IERC20 public pzsImpl;
    
    
    address private ROOT_ADDRESS = address(0xe060545d74CF8F5B2fDfC95b0E73673B7Bbfd291);
    
    address payable private PROJECT_NODE_ADDRESS = address(0xf99faD379C981aAf9f5b7537949B2c8D97e77Bba);
    
    address payable private PROJECT_LEADER_ADDRESS = address(0x30D1BcDf6726832f131818FcEDeC9784dD11E18f);
    
    address payable private PROJECT_FEE_ADDRESS = address(0xCE79D3d0A8Ad2c783e11090ECDa57C17c752da36);
    
    
    //---------------------------------------------------------------------------------------------
    constructor(address conf,address pzt) public {
        config = PZSConfig(conf);
        
        //registration(INIT_ADDRESS,address(0),false);
        registration(ROOT_ADDRESS,address(0),true);
        
        pzsImpl = IERC20(pzt);
    }
    
    function upgrade(address[] calldata addList,address referAddress) external onlyOwner returns(bool){
        for(uint8 i;i<addList.length;i++){
            registration(addList[i],referAddress,true);
        }
    }
    
    function changePZS(address pzsAddress) external onlyOwner returns(bool) {
        pzsImpl = IERC20(pzsAddress);
    }
    
    function changeConfig(address conf) external onlyOwner returns(bool) {
        config = PZSConfig(conf);
    }
    
    struct User {
        
        bool active;
        
        address referrer;
        
        uint256 id;
        
        bool node;
        
        uint256 direcCount;
        
        uint256 indirectCount;
        
        uint256 teamCount;
        
        uint256[3] subAmount;
        
        uint256[3] subAward;
        
        uint256[3] partnerAward;
    }
    
    
    PZSConfig private config;
    
    //Recommend reward generation one, generation two
    //uint256[2] public referRewardPercent = [20,15];
    
    //Super node subscription incentive rate
    //uint256 public partnerReferRewardPercent = 15;
    
    uint8 public teamCountLimit = 15;
    //uint256 public withdrawFee = 0.005 ether;
    
    //Under the umbrella of the super node purchase rebate rate
    //uint256 public partnerBecomePercent = 50;
    
    //Ordinary nodes directly push the reward rate
    //uint256 public partnerDirectPercent = 20;
    
    mapping(address=>User) public users;
    
    mapping(address=>uint256[3]) awards;
    
    mapping(uint256=>address) public addressIndexs;
    
    //mapping(address=>uint256[3]) partnerAwards;
    
    uint256 public userCounter;
    
    uint256[3] public totalSubEth;
    
    event Registration(address indexed user, address indexed referrer);
    
    event ApplyForPartner(address indexed user,address indexed referrer,address indexed node,uint256 partnerDirectAward,uint256 partnerBecomeAward);
    
    event Subscribe(address indexed user,uint256 changeAmount,uint256 exchangeAmout);
    
    event WithdrawAward(address indexed user,uint256 subAward);
    
    //event WithdrawPartnerAward(address indexed user,uint256 subAward);
    
    //event AllotPartnerAward(address indexed user,address indexed node,uint256 partnerAward);
    
    //event AllotSubAward(address indexed user,address indexed sub1,address indexed sub2,uint256 subAward1,uint256 subAward2);
    
    event AllotSubAward(address indexed user,address indexed subAddress,uint256 partnerAward,uint8 awardType);
    
    function isUserExists(address userAddress) private view returns(bool) {
        
        return users[userAddress].active;
    }
    
    function underway() public view returns(uint8 version){
        version = config.underway();
        return version;
    }
    
    function getGlobalStats(uint8 version) public view returns(uint256[9] memory stats){
        (uint256 minimum,uint256 maximum,uint256 period,uint256 scale,uint256 totalSuply,uint256 startTime,uint256 partnerBecome) = config.getStage(version);
        stats[0] = minimum;
        stats[1] = maximum;
        stats[2] = period;
        stats[3] = scale;
        stats[4] = totalSuply;
        stats[5] = startTime;
        stats[6] = partnerBecome;
        stats[7] = totalSubEth[version].mul(scale);
        stats[8] = userCounter;
        return stats;
    }
    
    function getPersonalStats(uint8 version,address userAddress) external view returns (uint256[10] memory stats){
        User memory user = users[userAddress];
        stats[0] = user.id;
        stats[1] = user.node?1:0;
        stats[2] = user.teamCount;
        stats[3] = user.direcCount;
        stats[4] = user.indirectCount;
        stats[5] = user.subAmount[version];
        stats[6] = user.subAward[version];
        stats[7] = user.partnerAward[version];
        stats[8] = awards[userAddress][version];
        stats[9] = user.active?1:0;
    }

    function getNodeAddress(address userAddress) public view returns (address nodeAddress){
        
        while(true){
            if (users[users[userAddress].referrer].node) {
                return users[userAddress].referrer;
            }
            userAddress = users[userAddress].referrer;
            
            if(userAddress==address(0)){
                break;
            }
        }
        
    }
    
    
    
    
    function regist(uint256 id) public  {
        require(!Address.isContract(msg.sender),"not allow");
        require(id>0,"error");
        require(!isUserExists(msg.sender),"exist");
        address referAddress = addressIndexs[id];
        require(isUserExists(referAddress),"ref not regist");

        registration(msg.sender,referAddress,false);
    }
    
    function applyForPartner(uint8 version) public payable returns (bool){
        
        require(isUserExists(msg.sender),"User not registered");
        
        require(config.checkStart(version),"Unsupported type");
        
        require(!users[msg.sender].node,"Has been activated");
        
        require(msg.value==config.partnerBecome(version),"amount error");
        
        address referrerAddress = users[msg.sender].referrer;
        
        address nodeAddress = getNodeAddress(msg.sender);
        
        require(referrerAddress!=address(0),"referrerAddress error 0");
        require(nodeAddress!=address(0),"referrerAddress error 0");
        
        (,uint256 partnerBecomePercent,uint256 partnerDirectPercent,,) =  config.getCommon();
        
        uint256 partnerDirectAward = msg.value.mul(partnerDirectPercent).div(100);
        uint256 partnerBecomeAward = msg.value.mul(partnerBecomePercent).div(100);
        
        
        users[msg.sender].node = true;
        
        awards[referrerAddress][version] = awards[referrerAddress][version].add(partnerDirectAward);
        awards[nodeAddress][version] = awards[nodeAddress][version].add(partnerBecomeAward);

        //partnerAwards[referrerAddress][version] = partnerAwards[referrerAddress][version].add(partnerDirectAward);
        //partnerAwards[nodeAddress][version] = partnerAwards[nodeAddress][version].add(partnerBecomeAward);
        
        users[referrerAddress].partnerAward[version] = users[referrerAddress].partnerAward[version].add(partnerDirectAward);
        users[nodeAddress].partnerAward[version] = users[nodeAddress].partnerAward[version].add(partnerBecomeAward);
        

        PROJECT_NODE_ADDRESS.transfer(msg.value.sub(partnerDirectAward).sub(partnerBecomeAward));
        
        emit ApplyForPartner(msg.sender,referrerAddress,nodeAddress,partnerDirectAward,partnerBecomeAward);
        
        return true;
    }
     
    function subscribe(uint8 version) public payable returns(bool) {
        
        require(isUserExists(msg.sender),"User not registered");
        
        require(config.checkStart(version),"Unsupported type");
        
        (uint256 minimum,uint256 maximum,,uint256 scale,,,) = config.getStage(version);
        
        require(msg.value>=minimum,"error sub type");
        
        uint256 subVersionAmount = users[msg.sender].subAmount[version];
        
        require(subVersionAmount.add(msg.value)<=maximum,"Exceeding sub limit");
        
        (uint256 subAward1,uint256 subAward2) = allotSubAward(version,msg.sender,msg.value);
        uint256 partnerAward = allotPartnerAward(version,msg.sender,msg.value);
        
        PROJECT_LEADER_ADDRESS.transfer(msg.value.sub(subAward1).sub(subAward2).sub(partnerAward));
        
        totalSubEth[version] = totalSubEth[version].add(msg.value);
        users[msg.sender].subAmount[version] = users[msg.sender].subAmount[version].add(msg.value);
        
        uint256 exchangePZSAmount = msg.value.mul(scale);
        
        //pzsImpl.approve(address(this),exchangePZSAmount);
        //pzsImpl.safeTransferFrom(address(this),msg.sender,exchangePZSAmount);
        pzsImpl.safeTransfer(msg.sender,exchangePZSAmount);
        
        emit Subscribe(msg.sender,msg.value,exchangePZSAmount);
        
        return true;
    }

    
    function withdrawAward(uint8 version) public returns(uint256){
        uint256 subAward = awards[msg.sender][version];
        (uint256 withdrawFee,,,,) =  config.getCommon();
        require(subAward>withdrawFee,"error ");
        require(address(this).balance >= subAward,"not enought");
        awards[msg.sender][version] = 0;
        PROJECT_FEE_ADDRESS.transfer(withdrawFee);
        msg.sender.transfer(subAward.sub(withdrawFee));
        emit WithdrawAward(msg.sender,subAward);
    }
    
    /*
    function withdrawPartnerAward(uint8 version) public payable returns(uint256){
        uint256 partnerAward = partnerAwards[msg.sender][version];
        require(partnerAward>0,"error ");
        require(address(this).balance >= partnerAward,"not enought");
        partnerAwards[msg.sender][version] = 0;
        msg.sender.transfer(partnerAward);
        emit WithdrawPartnerAward(msg.sender,partnerAward);
    }*/
    
    function allotPartnerAward(uint8 version,address userAddress,uint256 amount) private returns (uint256 partnerAward){
        address nodeAddress = getNodeAddress(msg.sender);
        
        (,,,uint256 partnerReferRewardPercent,) =  config.getCommon();
        partnerAward = amount.mul(partnerReferRewardPercent).div(100);
        if(nodeAddress==address(0)){
            partnerAward = 0;
        }else{
            awards[nodeAddress][version] = awards[nodeAddress][version].add(partnerAward);
            
        }
        
        users[nodeAddress].subAward[version] = users[nodeAddress].subAward[version].add(partnerAward);
        //emit AllotPartnerAward(userAddress,nodeAddress,partnerAward);
        emit AllotSubAward(userAddress,nodeAddress,partnerAward,3);
        
        return partnerAward;
    }
    
    function allotSubAward(uint8 version,address userAddress,uint256 amount) private returns (uint256 subAward1,uint256 subAward2) {
        address sub1 = users[userAddress].referrer;
        address sub2 = users[sub1].referrer;
        (,,,,uint256[2] memory referRewardPercent) =  config.getCommon();
        subAward1 = amount.mul(referRewardPercent[0]).div(100);
        subAward2 = amount.mul(referRewardPercent[1]).div(100);
        
        if(sub1==address(0)){
            subAward1 = 0;
            subAward2 = 0;
        }else{
            
            if(sub2==address(0)){
                subAward2 = 0;
                awards[sub1][version] = awards[sub1][version].add(subAward1);
            }else{
                awards[sub1][version] = awards[sub1][version].add(subAward1);
                awards[sub2][version] = awards[sub2][version].add(subAward2);
            }
        }
        
        
        users[sub1].subAward[version] = users[sub1].subAward[version].add(subAward1);
        users[sub2].subAward[version] = users[sub2].subAward[version].add(subAward2);
        
        emit AllotSubAward(userAddress,sub1,subAward1,1);
        emit AllotSubAward(userAddress,sub2,subAward2,2);
        //emit AllotSubAward(userAddress,sub1,sub2,subAward1,subAward2);
        return (subAward1,subAward2);
    }
    
    function registration (address userAddress,address referAddress,bool node) private {
        require(!isUserExists(msg.sender),"exist");
        users[userAddress] = createUser(userAddress,referAddress,node);
        users[referAddress].direcCount++;
        users[users[referAddress].referrer].indirectCount++;
        
        teamCount(userAddress);
        
        emit Registration(userAddress,referAddress);
    }
    
    function teamCount(address userAddress) private{
        address ref = users[userAddress].referrer;
        
        for(uint8 i = 0;i<teamCountLimit;i++){
            
            if(ref==address(0)){
                break;
            }
            users[ref].teamCount++;

            ref = users[ref].referrer;
        }
        
    }
    
    function createUser(address userAddress,address referrer,bool node) private returns(User memory user){
        uint256[3] memory subAmount;
        uint256[3] memory subAward;
        uint256[3] memory partnerAward;
        userCounter++;
        addressIndexs[userCounter] = userAddress;
        user = User({
            active: true,
            referrer: referrer,
            id: userCounter,
            node: node,
            direcCount: 0,
            indirectCount: 0,
            teamCount: 1,
            subAmount: subAmount,
            subAward: subAward,
            partnerAward: partnerAward
        });
    }
    
}