/*

MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWKkkKWMMMMMMWKkkKWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXl''dNMMMMMMNo''oXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWKxoOWMMMMMMWkoxKWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWKONMMMMMMXkKMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMW0kXMMMMMMXk0WMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN0O0XMMMMX0O0NMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWOkXNNXk0WMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWk:;::;c0WMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMNOxOKkdc,....,ldk0Ox0NMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMWOc,',,,;coddddoc;,,,',lOWMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMXd,.';oOXWMMMMMMWXOo;'.,dXMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMNd,'l0WMMMWNXXNWMMMW0c',dNMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMWX0x,'lXMMMNkdxdollkNMMMKc';dOXMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMNo,'.;OMMMNd,cOOd:.'dNMMWk,'',dWMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMXl'..;OMMMXl.',,''.'lXMMMO;..'oNMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMWOdc',xWMMWOc,...',c0WMMNd''cdOWMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMWKl';kWMMMN0kxxk0NMMMNx;'cKWWMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMXd;.,o0NMMMMMMMMMMN0l,.,oXMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMXd;'.',cdk0KKKK0kdc,'..,dXMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMW0l,:l:,',,,,,,,,:oc,c0WMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMO;dNN0o;'..';dKNWk;xWMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMO;oNMWNOc''c0NMMMk;xWMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMKl:dKWMKc..cKMMXkccOWMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXx:lXMXo;;oXMNd;oKWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWOlcdkOkkOOklcxNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM0c'',,;,,':OWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWNNKkxxxxxxxxOXNNWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWWNNNNNNNNNNNNNNNWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM

*/

pragma solidity ^0.6.6;

abstract contract Context {
    function _msgSender() internal virtual view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal virtual view returns (bytes memory) {
        this;
        return msg.data;
    }
}

interface IERC20 {

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    function mint(address _to, uint256 _amount) external;

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
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

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
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

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

interface xiControlMigrator {
    function migrate(IERC20 token) external returns (IERC20);
}

library Address {

    function isContract(address account) internal view returns (bool) {

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(
            address(this).balance >= amount,
            "Address: insufficient balance"
        );

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{value: amount}("");
        require(
            success,
            "Address: unable to send value, recipient may have reverted"
        );
    }

    function functionCall(address target, bytes memory data)
        internal
        returns (bytes memory)
    {
        return functionCall(target, data, "Address: low-level call failed");
    }

    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return
            functionCallWithValue(
                target,
                data,
                value,
                "Address: low-level call with value failed"
            );
    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(
            address(this).balance >= value,
            "Address: insufficient balance for call"
        );
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(
        address target,
        bytes memory data,
        uint256 weiValue,
        string memory errorMessage
    ) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{value: weiValue}(
            data
        );
        if (success) {
            return returndata;
        } else {
            if (returndata.length > 0) {
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

library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(
        IERC20 token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transfer.selector, to, value)
        );
    }

    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
        );
    }

    function safeApprove(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.approve.selector, spender, value)
        );
    }

    function safeIncreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(
            value
        );
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(
                token.approve.selector,
                spender,
                newAllowance
            )
        );
    }

    function safeDecreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(
            value,
            "SafeERC20: decreased allowance below zero"
        );
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(
                token.approve.selector,
                spender,
                newAllowance
            )
        );
    }


    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        bytes memory returndata = address(token).functionCall(
            data,
            "SafeERC20: low-level call failed"
        );
        if (returndata.length > 0) {
            // solhint-disable-next-line max-line-length
            require(
                abi.decode(returndata, (bool)),
                "SafeERC20: ERC20 operation did not succeed"
            );
        }
    }
}

contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract TokenRecover is Ownable {
    function recoverERC20(address tokenAddress, uint256 tokenAmount) public onlyOwner {
        IERC20(tokenAddress).transfer(owner(), tokenAmount);
    }
}

contract XiControl is Ownable, TokenRecover {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    struct UserDat {
        uint256 amount;
        uint256 rewardDebt;
    }

    struct PuddleData {
        IERC20 Univ2Token;
        uint256 allocPoint;
        uint256 lastRewardBlock;
        uint256 accRiPerShare;
    }

    IERC20 public ri;

    address public administrator;

    uint256 public rewardPerBlock;

    xiControlMigrator public migrator;


    PuddleData[] public puddleData;

    mapping(address => bool) public Univ2TokenExistsInPuddle;

    mapping(uint256 => mapping(address => UserDat)) public userDat;

    uint256 public totalAllocPoint = 0;

    uint256 public startBlock;

    uint256 public halvePeriod = 2073600;
    uint256 public minimumRewardPerBlock = 24048 szabo;
    uint256 public lastHalveBlock;

    event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
    event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
    event ExitPoolDisgracefully(address indexed user, uint256 indexed pid, uint256 amount);
    event Halve(uint256 newRewardPerBlock, uint256 nextHalveBlockNumber);

    constructor( IERC20 _ri, address _administrator, uint256 _startBlock) public {
        ri = _ri;
        administrator = _administrator;
        rewardPerBlock = 769544 szabo;
        startBlock = _startBlock;
        lastHalveBlock = _startBlock;
    }

    function doHalvingCheck(bool _withUpdate) public {
        if (rewardPerBlock <= minimumRewardPerBlock) {
            return;
        }
        bool doHalve = block.number > lastHalveBlock + halvePeriod;
        if (!doHalve) {
            return;
        }
        uint256 newRewardPerBlock = rewardPerBlock.div(2);
        if (newRewardPerBlock >= minimumRewardPerBlock) {
            rewardPerBlock = newRewardPerBlock;
            lastHalveBlock = block.number;
            emit Halve(newRewardPerBlock, block.number + halvePeriod);

            if (_withUpdate) {
                massUpdatePuddles();
            }
        }
    }

    function puddleLength() external view returns (uint256) {
        return puddleData.length;
    }

    function add(uint256 _allocPoint, IERC20 _Univ2Token, bool _withUpdate) public onlyOwner {
        require(!Univ2TokenExistsInPuddle[address(_Univ2Token)], "LP Token Address already exists in puddle");

        if (_withUpdate) {
            massUpdatePuddles();
        }
        uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
        totalAllocPoint = totalAllocPoint.add(_allocPoint);
        puddleData.push(
            PuddleData({
                Univ2Token: _Univ2Token,
                allocPoint: _allocPoint,
                lastRewardBlock: lastRewardBlock,
                accRiPerShare: 0
            })
        );
        Univ2TokenExistsInPuddle[address(_Univ2Token)] = true;
    }

    function updateUniv2TokenExists(address _Univ2TokenAddr, bool _isExists) external onlyOwner {
        Univ2TokenExistsInPuddle[_Univ2TokenAddr] = _isExists;
    }

    function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
        if (_withUpdate) {
            massUpdatePuddles();
        }
        totalAllocPoint = totalAllocPoint.sub(puddleData[_pid].allocPoint).add( _allocPoint);
        puddleData[_pid].allocPoint = _allocPoint;
    }

    function setMigrator(xiControlMigrator _migrator) public onlyOwner {
        migrator = _migrator;
    }

    function migrate(uint256 _pid) public onlyOwner {
        require(address(migrator) != address(0), "Address of migrator is null");

        PuddleData storage puddle = puddleData[_pid];
        IERC20 Univ2Token = puddle.Univ2Token;
        uint256 bal = Univ2Token.balanceOf(address(this));
        Univ2Token.safeApprove(address(migrator), bal);
        IERC20 newUniv2Token = migrator.migrate(Univ2Token);

        require(!Univ2TokenExistsInPuddle[address(newUniv2Token)], "New LP Token Address already exists in puddle");
        require(bal == newUniv2Token.balanceOf(address(this)), "New LP Token balance incorrect");

        puddle.Univ2Token = newUniv2Token;

        Univ2TokenExistsInPuddle[address(newUniv2Token)] = true;
    }

    function pendingRI(uint256 _pid, address _user) external view returns (uint256) {
        PuddleData storage puddle = puddleData[_pid];
        UserDat storage user = userDat[_pid][_user];
        uint256 accRiPerShare = puddle.accRiPerShare;
        uint256 poolTokenSupply = puddle.Univ2Token.balanceOf(address(this));
        if (block.number > puddle.lastRewardBlock && poolTokenSupply != 0) {
            uint256 blockPassed = block.number.sub(puddle.lastRewardBlock);
            uint256 riReward = blockPassed
                .mul(rewardPerBlock)
                .mul(puddle.allocPoint)
                .div(totalAllocPoint);
            accRiPerShare = accRiPerShare.add(
                riReward.mul(1e12).div(poolTokenSupply)
            );
        }
        return
            user.amount.mul(accRiPerShare).div(1e12).sub(user.rewardDebt);
    }

    function massUpdatePuddles() public {
        uint256 length = puddleData.length;
        for (uint256 pid = 0; pid < length; ++pid) {
            updatePuddle(pid);
        }
    }

    function updatePuddle(uint256 _pid) public {
        doHalvingCheck(false);
        PuddleData storage puddle = puddleData[_pid];
        if (block.number <= puddle.lastRewardBlock) {
            return;
        }

        uint256 poolTokenSupply = puddle.Univ2Token.balanceOf(address(this));
        if (poolTokenSupply == 0) {
            puddle.lastRewardBlock = block.number;
            return;
        }
        uint256 blockPassed = block.number.sub(puddle.lastRewardBlock);
        uint256 riReward = blockPassed
            .mul(rewardPerBlock)
            .mul(puddle.allocPoint)
            .div(totalAllocPoint);
        ri.mint(administrator, riReward.div(10));
        ri.mint(address(this), riReward);
        puddle.accRiPerShare = puddle.accRiPerShare.add(
            riReward.mul(1e12).div(poolTokenSupply)
        );
        puddle.lastRewardBlock = block.number;
    }

    function deposit(uint256 _pid, uint256 _amount) public {
        PuddleData storage puddle = puddleData[_pid];
        UserDat storage user = userDat[_pid][msg.sender];
        updatePuddle(_pid);
        if (user.amount > 0) {
            uint256 pending = user
                .amount
                .mul(puddle.accRiPerShare)
                .div(1e12)
                .sub(user.rewardDebt);
            safeRiTransfer(msg.sender, pending);
        }
        puddle.Univ2Token.safeTransferFrom(address(msg.sender), address(this), _amount);
        user.amount = user.amount.add(_amount);
        user.rewardDebt = user.amount.mul(puddle.accRiPerShare).div(1e12);
        emit Deposit(msg.sender, _pid, _amount);
    }

    function withdraw(uint256 _pid, uint256 _amount) public {
        PuddleData storage puddle = puddleData[_pid];
        UserDat storage user = userDat[_pid][msg.sender];
        require(user.amount >= _amount, "Insufficient Amount to withdraw");
        updatePuddle(_pid);
        uint256 pending = user.amount.mul(puddle.accRiPerShare).div(1e12).sub(user.rewardDebt);
        safeRiTransfer(msg.sender, pending);
        user.amount = user.amount.sub(_amount);
        user.rewardDebt = user.amount.mul(puddle.accRiPerShare).div(1e12);
        puddle.Univ2Token.safeTransfer(address(msg.sender), _amount);
        emit Withdraw(msg.sender, _pid, _amount);
    }

    function exitPoolDisgracefully(uint256 _pid) public {
        PuddleData storage puddle = puddleData[_pid];
        UserDat storage user = userDat[_pid][msg.sender];
        puddle.Univ2Token.safeTransfer(address(msg.sender), user.amount);
        emit ExitPoolDisgracefully(msg.sender, _pid, user.amount);
        user.amount = 0;
        user.rewardDebt = 0;
    }

    function safeRiTransfer(address _to, uint256 _amount) internal {
        uint256 riBal = ri.balanceOf(address(this));
        if (_amount > riBal) {
            ri.transfer(_to, riBal);
        } else {
            ri.transfer(_to, _amount);
        }
    }
}