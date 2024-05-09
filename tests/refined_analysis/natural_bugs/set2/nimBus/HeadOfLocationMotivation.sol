pragma solidity =0.8.0;

contract Ownable {
    address public owner;
    address public newOwner;

    event OwnershipTransferred(address indexed from, address indexed to);

    constructor() {
        owner = msg.sender;
        emit OwnershipTransferred(address(0), owner);
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Ownable: Caller is not the owner");
        _;
    }

    function getOwner() external view returns (address) {
        return owner;
    }

    function transferOwnership(address transferOwner) external onlyOwner {
        require(transferOwner != newOwner);
        newOwner = transferOwner;
    }

    function acceptOwnership() virtual external {
        require(msg.sender == newOwner);
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
        newOwner = address(0);
    }
}


abstract contract Pausable is Ownable {
    event Paused(address account);
    event Unpaused(address account);

    bool private _paused;

    constructor () {
        _paused = false;
    }

    function paused() public view returns (bool) {
        return _paused;
    }

    modifier whenNotPaused() {
        require(!_paused, "Pausable: paused");
        _;
    }

    modifier whenPaused() {
        require(_paused, "Pausable: not paused");
        _;
    }


    function pause() external onlyOwner whenNotPaused {
        _paused = true;
        emit Paused(msg.sender);
    }

    function unpause() external onlyOwner whenPaused {
        _paused = false;
        emit Unpaused(msg.sender);
    }
}


interface IBEP20 {
    function totalSupply() external view returns (uint256);
    function decimals() external view returns (uint8);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function getOwner() external view returns (address);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


interface INimbusReferralProgramMarketing {
    function isHeadOfLocation(address user) external view returns(bool);
    function headOfLocationTurnover(address user) external view returns(uint);
}


library Address {
    function isContract(address account) internal view returns (bool) {
        // This method relies in extcodesize, which returns 0 for contracts in construction, 
        // since the code is only stored at the end of the constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }
}

library SafeBEP20 {
    using Address for address;

    function safeTransfer(IBEP20 token, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IBEP20 token, address from, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function safeApprove(IBEP20 token, address spender, uint256 value) internal {
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeBEP20: approve from non-zero to non-zero allowance"
        );
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IBEP20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender) + value;
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IBEP20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender) - value;
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function callOptionalReturn(IBEP20 token, bytes memory data) private {
        require(address(token).isContract(), "SafeBEP20: call to non-contract");

        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeBEP20: low-level call failed");

        if (returndata.length > 0) { 
            require(abi.decode(returndata, (bool)), "SafeBEP20: BEP20 operation did not succeed");
        }
    }
}

library TransferHelper {
    function safeApprove(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes('approve(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
    }

    function safeTransfer(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes('transfer(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
    }

    function safeTransferFrom(address token, address from, address to, uint value) internal {
        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
    }

    function safeTransferBNB(address to, uint value) internal {
        (bool success,) = to.call{value:value}(new bytes(0));
        require(success, 'TransferHelper: BNB_TRANSFER_FAILED');
    }
}


contract HeadOfLocationMotivation is Ownable, Pausable {
    using SafeBEP20 for IBEP20;

    IBEP20 public immutable SYSTEM_TOKEN;
    INimbusReferralProgramMarketing public referralProgramMarketing;

    mapping(address => bool) public isAllowedToReceiveReward;
    mapping(address => uint) public holLastTurnoverAmount;

    uint public percent;

    event HolClaimReward(address indexed user, uint amount);
    event Rescue(address indexed to, uint amount);
    event RescueToken(address indexed token, address indexed to, uint amount);
    event UpdateReferralProgramMarketing(address newContract);
    event ImportUser(address user, uint lastTurnoverAmount);
    event UpdatePercent(uint indexed newPercent);

    constructor (address systemToken, address referralProgramMarketingAddress) {
        require(Address.isContract(systemToken), "HeadOfLocationMotivation: SystemToken is not a contract");
        require(Address.isContract(referralProgramMarketingAddress), "HeadOfLocationMotivation: ReferralProgramMarketing is not a contract");
        SYSTEM_TOKEN = IBEP20(systemToken);
        referralProgramMarketing = INimbusReferralProgramMarketing(referralProgramMarketingAddress);
        percent = 300; //3%
    }

    function claimReward() external returns (uint) {
        require(referralProgramMarketing.isHeadOfLocation(msg.sender), "HeadOfLocationMotivation: User is not head of location");
        require(isAllowedToReceiveReward[msg.sender], "HeadOfLocationMotivation: User disallowed to receive reward");
        uint turnover = referralProgramMarketing.headOfLocationTurnover(msg.sender);
        uint reward = _getRewardAmount(msg.sender, turnover);
        require(reward > 0, "HeadOfLocationMotivation: Reward amount is zero");
        SYSTEM_TOKEN.safeTransfer(msg.sender, reward);
        holLastTurnoverAmount[msg.sender] = turnover;
        emit HolClaimReward(msg.sender, reward);
        return reward;
    }

    function getRewardAmount(address user) external view returns (uint) {
        require(referralProgramMarketing.isHeadOfLocation(user), "HeadOfLocationMotivation: User is not head of location");
        require(isAllowedToReceiveReward[user], "HeadOfLocationMotivation: User disallowed to receive reward");
        uint turnover = referralProgramMarketing.headOfLocationTurnover(user);
        return _getRewardAmount(user,turnover);
    }

    function _getRewardAmount(address user, uint turnover) private view returns (uint){
        uint difference = turnover - holLastTurnoverAmount[user];
        uint reward = difference * percent / 10000;
        return reward;
    }
    


    
    function allowUserToReceiveReward(address user) external onlyOwner {
        require(referralProgramMarketing.isHeadOfLocation(user), "HeadOfLocationMotivation: User is not head of location");
        require(!isAllowedToReceiveReward[user], "HeadOfLocationMotivation: User already allowed");
        isAllowedToReceiveReward[user] = true;
    }

    function disallowUserToReceiveReward(address user) external onlyOwner {
        require(isAllowedToReceiveReward[user], "HeadOfLocationMotivation: User already disallowed");
        isAllowedToReceiveReward[user] = false;
    }

    function updatePercent(uint newPercent) external onlyOwner {
        require(newPercent > 0 && newPercent <= 10000, "HeadOfLocationMotivation: Wrong percent amount");
        require(newPercent != percent, "HeadOfLocationMotivation: New percent is the same as the old one");
        percent = newPercent;
        emit UpdatePercent(newPercent);
    }

    function rescue(address payable to, uint256 amount) external onlyOwner {
        require(to != address(0), "HeadOfLocationMotivation: Can't be zero address");
        require(amount > 0, "HeadOfLocationMotivation: Should be greater than 0");
        TransferHelper.safeTransferBNB(to, amount);
        emit Rescue(to, amount);
    }

    function rescue(address to, address token, uint256 amount) external onlyOwner {
        require(to != address(0), "HeadOfLocationMotivation: Can't be zero address");
        require(amount > 0, "HeadOfLocationMotivation: Should be greater than 0");
        TransferHelper.safeTransfer(token,to, amount);
        emit RescueToken(token, to, amount);
    }

    function importUsers(address[] memory users, uint[] memory amounts, bool[] memory isAllowed, bool addToExistent, bool checkAmount) external onlyOwner {
        require(users.length == amounts.length && users.length == isAllowed.length, "HeadOfLocationMotivation: Wrong lengths");

        for (uint256 i = 0; i < users.length; i++) {
            uint amount;
            if (addToExistent) {
                amount = holLastTurnoverAmount[users[i]] + amounts[i];
            } else {
                amount = amounts[i];
            } 
            if (checkAmount) {
                require(referralProgramMarketing.headOfLocationTurnover(users[i]) >= amount);
            }
            holLastTurnoverAmount[users[i]] = amount;
            isAllowedToReceiveReward[users[i]] = isAllowed[i];
            emit ImportUser(users[i], amount);
        }
    }

    function updateReferralProgramMarketingContract(address newReferralProgramMarketingContract) external onlyOwner {
        require(newReferralProgramMarketingContract != address(0), "HeadOfLocationMotivation: Address is zero");
        referralProgramMarketing = INimbusReferralProgramMarketing(newReferralProgramMarketingContract);
        emit UpdateReferralProgramMarketing(newReferralProgramMarketingContract);
    }
}
