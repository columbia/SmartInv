// SPDX-License-Identifier: none

pragma solidity >=0.5.0 <0.8.0;

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

library Address {
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }
    
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
    
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }
    
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }
    
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }
    
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }
    
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }
    
    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }
    
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }
    
    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

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
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

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
    function totalSupply() external view returns (uint256);
    function decimals() external view returns (uint8);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from,address indexed to,uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

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

    function callOptionalReturn(IERC20 token, bytes memory data) private {
        require(address(token).isContract(), "SafeERC20: call to non-contract");
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) {
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

contract YFDOTStake is Context {
    using SafeERC20 for IERC20;
    using Address for address;
    using SafeMath for uint256;
    
    struct periodList{
        uint256 periodTime;
        uint256 cooldownTime;
        uint256 formulaParam1;
        uint256 formulaParam2;
        uint256 formulaPenalty1;
        uint256 formulaPenalty2;
    }
    
    struct userStaking{
        bool activeStake;
        uint periodChoosed;
        address tokenWantStake;
        uint256 amountStaked;
        uint256 startStake;
        uint256 claimStake;
        uint256 endStake;
        uint256 cooldownDate;
        uint256 claimed;
    }
    
    struct rewardDetail{
        string symboltoken;
        uint256 equalReward;
    }
    
    mapping (uint => periodList) private period;
    mapping (address => rewardDetail) private ERC20perYFDOT;
    mapping (address => userStaking) private stakerDetail;
    
    address private _owner;
    address private _YFDOTtoken;
    address[] private _tokenStakeList;
    address[] private _stakerList;
    uint[] private _periodList;
    
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event Stake(address indexed staker, address indexed tokenStakeTarget, uint256 indexed amountTokenStaked);
    event Unstake(address indexed staker, address indexed tokenStakeTarget, uint256 indexed amountTokenStaked);
    event Claim(address indexed staker, address indexed tokenStakeTarget, uint256 indexed amountReward);
    
    constructor(address YFDOTAddress){
        rewardDetail storage est = ERC20perYFDOT[YFDOTAddress];
        rewardDetail storage nul = ERC20perYFDOT[address(0)];
        require(YFDOTAddress.isContract() == true,"This address is not Smartcontract");
        require(IERC20(YFDOTAddress).totalSupply() != 0, "This address is not ERC20 Token");
        address msgSender = _msgSender();
        _YFDOTtoken = YFDOTAddress;
        _owner = msgSender;
        _tokenStakeList.push(YFDOTAddress);
        est.equalReward = 10**18;
        est.symboltoken = "YFDOT";
        nul.symboltoken = "N/A";
        emit OwnershipTransferred(address(0), msgSender);
    }
    
    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == _msgSender(), "Caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }
    
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "New owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
    
    function addTokenReward(address erc20Token, uint256 amountEqual, string memory symboltokens) public virtual onlyOwner{
        require(erc20Token.isContract() == true,"This address is not Smartcontract");
        require(IERC20(erc20Token).totalSupply() != 0, "This address is not ERC20 Token");
        rewardDetail storage est = ERC20perYFDOT[erc20Token];
        est.equalReward = amountEqual;
        est.symboltoken = symboltokens;
        
        _tokenStakeList.push(erc20Token);
    }
    
    function editTokenReward(address erc20Token, uint256 amountEqual, string memory symboltokens) public virtual onlyOwner{
        require(erc20Token.isContract() == true,"This address is not Smartcontract");
        require(IERC20(erc20Token).totalSupply() != 0, "This address is not ERC20 Token");
        
        rewardDetail storage est = ERC20perYFDOT[erc20Token];
        est.equalReward = amountEqual;
        est.symboltoken = symboltokens;
    }
    
    function addPeriod(uint256 timePeriodStake, uint256 timeCooldownUnstake, uint256 formula1, uint256 formula2, uint256 fpel1, uint256 fpel2) public virtual onlyOwner{
        uint newPeriod = _periodList.length;
        if(newPeriod == 0){
            newPeriod = 1;
        }else{
            newPeriod = newPeriod + 1;
        }
        
        periodList storage sys = period[newPeriod];
        sys.periodTime = timePeriodStake;
        sys.cooldownTime = timeCooldownUnstake;
        sys.formulaParam1 = formula1;
        sys.formulaParam2 = formula2;
        sys.formulaPenalty1 = fpel1;
        sys.formulaPenalty2 = fpel2;
        
        _periodList.push(newPeriod);
    }
    
    function editPeriod(uint periodEdit, uint256 timePeriodStake, uint256 timeCooldownUnstake, uint256 formula1, uint256 formula2, uint256 fpel1, uint256 fpel2) public virtual onlyOwner{
        periodList storage sys = period[periodEdit];
        sys.periodTime = timePeriodStake;
        sys.cooldownTime = timeCooldownUnstake;
        sys.formulaParam1 = formula1;
        sys.formulaParam2 = formula2;
        sys.formulaPenalty1 = fpel1;
        sys.formulaPenalty2 = fpel2;
    }
    
    function claimReward() public virtual{
        address msgSender = _msgSender();
        userStaking storage usr = stakerDetail[msgSender];
        uint256 getrewardbalance = IERC20(usr.tokenWantStake).balanceOf(address(this));
        uint256 getReward = getRewardClaimable(msgSender);
        uint256 today = block.timestamp;
        
        require(getrewardbalance >= getReward, "Please wait until reward pool filled, try again later.");
        require(usr.claimStake < block.timestamp, "Please wait until wait time reached.");
        
        usr.claimed = usr.claimed.add(getReward);
        usr.claimStake = today.add(7 days);
        IERC20(usr.tokenWantStake).safeTransfer(msgSender, getReward);
        emit Claim(msgSender, usr.tokenWantStake, getReward);
    }
    
    function stakeNow(address tokenTargetStake, uint256 amountWantStake, uint periodwant) public virtual{
        address msgSender = _msgSender();
        uint256 getallowance = IERC20(_YFDOTtoken).allowance(msgSender, address(this));
        
        if(getRewardClaimable(msgSender) > 0){
            revert("Please claim your reward from previous staking");
        }
        
        require(amountWantStake >= 500000000000, "Minimum staking 0.00005 YFDOT");
        require(getallowance >= amountWantStake, "Insufficient YFDOT token approval balance, you must increase your allowance" );
        
        uint256 today = block.timestamp;
        userStaking storage usr = stakerDetail[msgSender];
        periodList storage sys = period[periodwant];
        
        usr.activeStake = true;
        usr.periodChoosed = periodwant;
        usr.tokenWantStake = tokenTargetStake;
        usr.amountStaked = amountWantStake;
        usr.startStake = today;
        usr.claimStake = today.add(7 days);
        usr.cooldownDate = today.add(sys.cooldownTime);
        usr.endStake = today.add(sys.periodTime);
        usr.claimed = 0;
        
        bool checkregis = false;
        for(uint i = 0; i < _stakerList.length; i++){
            if(_stakerList[i] == msgSender){
                checkregis = true;
            }
        }
        
        if(checkregis == false){
            _stakerList.push(msgSender);
        }
        
        IERC20(_YFDOTtoken).safeTransferFrom(msgSender, address(this), amountWantStake);
        emit Stake(msgSender, tokenTargetStake, amountWantStake);
    }
    
    function unstakeNow() public virtual{
        address msgSender = _msgSender();
        userStaking storage usr = stakerDetail[msgSender];
        periodList storage sys = period[usr.periodChoosed];
        
        require(usr.activeStake == true, "Stake not active yet" );
        
        uint256 tokenUnstake;
        if(block.timestamp < usr.cooldownDate){
            uint256 penfee = usr.amountStaked.mul(sys.formulaPenalty1);
            penfee = penfee.div(sys.formulaPenalty2);
            penfee = penfee.div(100);
            tokenUnstake = usr.amountStaked.sub(penfee);
        }else{
            tokenUnstake = usr.amountStaked;
        }
        
        usr.activeStake = false;
        if(block.timestamp < usr.endStake){
            usr.endStake = block.timestamp;
        }
        
        IERC20(_YFDOTtoken).safeTransfer(msgSender, tokenUnstake);
        
        emit Unstake(msgSender, usr.tokenWantStake, usr.amountStaked);
    }
    
    function getEqualReward(address erc20Token) public view returns(uint256, string memory){
        rewardDetail storage est = ERC20perYFDOT[erc20Token];
        return(
            est.equalReward,
            est.symboltoken
        );
    }
    
    function getTotalStaker() public view returns(uint256){
        return _stakerList.length;
    }
    
    function getActiveStaker() view public returns(uint256){
        uint256 activeStake;
        for(uint i = 0; i < _stakerList.length; i++){
            userStaking memory l = stakerDetail[_stakerList[i]];
            if(l.activeStake == true){
                activeStake = activeStake + 1;
            }
        }
        return activeStake;
    }
    
    function getTokenList() public view returns(address[] memory){
        return _tokenStakeList;
    }
    
    function getPeriodList() public view returns(uint[] memory){
        return _periodList;
    }
    
    function getPeriodDetail(uint periodwant) public view returns(uint256, uint256, uint256, uint256, uint256, uint256){
        periodList storage sys = period[periodwant];
        return(
            sys.periodTime,
            sys.cooldownTime,
            sys.formulaParam1,
            sys.formulaParam2,
            sys.formulaPenalty1,
            sys.formulaPenalty2
        );
    }
    
    function getUserInfo(address stakerAddress) public view returns(bool, uint, address, string memory, uint256, uint256, uint256, uint256, uint256, uint256){
        userStaking storage usr = stakerDetail[stakerAddress];
        rewardDetail storage est = ERC20perYFDOT[usr.tokenWantStake];
        
        uint256 amountTotalStaked;
        if(usr.activeStake == false){
            amountTotalStaked = 0;
        }else{
            amountTotalStaked = usr.amountStaked;
        }
        return(
            usr.activeStake,
            usr.periodChoosed,
            usr.tokenWantStake,
            est.symboltoken,
            amountTotalStaked,
            usr.startStake,
            usr.claimStake,
            usr.endStake,
            usr.cooldownDate,
            usr.claimed
        );
    }
    
    function getRewardClaimable(address stakerAddress) public view returns(uint256){
        userStaking storage usr = stakerDetail[stakerAddress];
        periodList storage sys = period[usr.periodChoosed];
        rewardDetail storage est = ERC20perYFDOT[usr.tokenWantStake];
        
        uint256 rewards;
        
        if(usr.amountStaked == 0 && usr.tokenWantStake == address(0)){
            rewards = 0;
        }else{
            uint256 perSec = usr.amountStaked.mul(sys.formulaParam1);
            perSec = perSec.div(sys.formulaParam2);
            perSec = perSec.div(100);
            
            uint256 today = block.timestamp;
            uint256 diffTime;
            if(today > usr.endStake){
                diffTime = usr.endStake.sub(usr.startStake);
            }else{
                diffTime = today.sub(usr.startStake);
            }
            rewards = perSec.mul(diffTime);
            uint256 getTokenEqual = est.equalReward;
            rewards = rewards.mul(getTokenEqual);
            rewards = rewards.div(10**18);
            rewards = rewards.sub(usr.claimed);
        }
        return rewards;
    }
    
    function getRewardObtained(address stakerAddress) public view returns(uint256){
        userStaking storage usr = stakerDetail[stakerAddress];
        periodList storage sys = period[usr.periodChoosed];
        rewardDetail storage est = ERC20perYFDOT[usr.tokenWantStake];
        uint256 rewards;
        
        if(usr.amountStaked == 0 && usr.tokenWantStake == address(0)){
            rewards = 0;
        }else{
            uint256 perSec = usr.amountStaked.mul(sys.formulaParam1);
            perSec = perSec.div(sys.formulaParam2);
            perSec = perSec.div(100);
            
            uint256 today = block.timestamp;
            uint256 diffTime;
            if(today > usr.endStake){
                diffTime = usr.endStake.sub(usr.startStake);
            }else{
                diffTime = today.sub(usr.startStake);
            }
            rewards = perSec.mul(diffTime);
            uint256 getTokenEqual = est.equalReward;
            rewards = rewards.mul(getTokenEqual);
            rewards = rewards.div(10**18);
        }
        return rewards;
    }
    
    function getRewardEstimator(address stakerAddress) public view returns(uint256,uint256,uint256,uint256,uint256,uint256){
        userStaking storage usr = stakerDetail[stakerAddress];
        periodList storage sys = period[usr.periodChoosed];
        rewardDetail storage est = ERC20perYFDOT[usr.tokenWantStake];
        uint256 amountStakedNow;
        
        if(usr.activeStake == true){
            amountStakedNow = usr.amountStaked;
            uint256 perSec = amountStakedNow.mul(sys.formulaParam1);
            uint256 getTokenEqual = est.equalReward;
            perSec = perSec.div(sys.formulaParam2);
            perSec = perSec.div(100);
            perSec = perSec.mul(getTokenEqual);
            perSec = perSec.div(10**18);
            
            return(
                perSec,
                perSec.mul(60),
                perSec.mul(3600),
                perSec.mul(86400),
                perSec.mul(604800),
                perSec.mul(2592000)
            );
        }else{
            return(0,0,0,0,0,0);
        }
        
    }
    
    function getRewardCalculator(address tokenWantStake, uint256 amountWantStake, uint periodwant) public view returns(uint256){
        periodList storage sys = period[periodwant];
        rewardDetail storage est = ERC20perYFDOT[tokenWantStake];
        
        uint256 perSec = amountWantStake.mul(sys.formulaParam1);
        perSec = perSec.div(sys.formulaParam2);
        perSec = perSec.div(100);
        
        uint256 startDate = block.timestamp;
        uint256 endDate = startDate.add(sys.periodTime);
        uint256 diffTime = endDate.sub(startDate);
        uint256 rewards = perSec.mul(diffTime);
        uint256 getTokenEqual = est.equalReward;
        rewards = rewards.mul(getTokenEqual);
        rewards = rewards.div(10**18);
        return rewards;
    }
}