/**

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

interface SiloControlMigrator {
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

contract SiloControl is Ownable, TokenRecover {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    struct Depositor {
        uint256 amount;
        uint256 mintDebt;
    }

    struct SiloData {
        IERC20 Token;
        uint256 weight;
        uint256 lastMintBlock;
        uint256 mintedTokenPerShare;
    }

    IERC20 public mintedToken;

    address public teller;

    uint256 public mintPerBlock;

    SiloControlMigrator public migrator;


    SiloData[] public siloData;

    mapping(address => bool) public TokenExistsInSilo;

    mapping(uint256 => mapping(address => Depositor)) public depositor;

    uint256 public totalWeight = 0;

    uint256 public startBlock;

    uint256 public halvePeriod = 357120;
    uint256 public minimumMintPerBlock = 43568156563424200;
    uint256 public lastHalveBlock;

    event Deposit(address indexed user, uint256 indexed siloid, uint256 amount);
    event Withdraw(address indexed user, uint256 indexed siloid, uint256 amount);
    event ExitPoolDisgracefully(address indexed user, uint256 indexed siloid, uint256 amount);
    event Halve(uint256 newMintPerBlock, uint256 nextHalveBlockNumber);

    constructor( IERC20 _mintedToken, address _teller, uint256 _startBlock) public {
        mintedToken = _mintedToken;
        teller = _teller;
        mintPerBlock = 181834391801075000;
        startBlock = _startBlock;
        lastHalveBlock = _startBlock;
    }

    function doHalvingCheck(bool _withUpdate) public {
        if (mintPerBlock <= minimumMintPerBlock) {
            return;
        }
        bool doHalve = block.number > lastHalveBlock + halvePeriod;
        if (!doHalve) {
            return;
        }
        uint256 newMintPerBlock = mintPerBlock.mul(96).div(100);
        if (newMintPerBlock >= minimumMintPerBlock) {
            mintPerBlock = newMintPerBlock;
            lastHalveBlock = block.number;
            emit Halve(newMintPerBlock, block.number + halvePeriod);

            if (_withUpdate) {
                massUpdateSilos();
            }
        }
    }

    function siloDepth() external view returns (uint256) {
        return siloData.length;
    }

    function add(uint256 _weight, IERC20 _Token, bool _withUpdate) public onlyOwner {
        require(!TokenExistsInSilo[address(_Token)], "Token Address already exists in silo");

        if (_withUpdate) {
            massUpdateSilos();
        }

        uint256 lastMintBlock = block.number > startBlock ? block.number : startBlock;
        totalWeight = totalWeight.add(_weight);
        siloData.push(
            SiloData({
                Token: _Token,
                weight: _weight,
                lastMintBlock: lastMintBlock,
                mintedTokenPerShare: 0
            })
        );
        TokenExistsInSilo[address(_Token)] = true;
    }

    function updateTokenExists(address _TokenAddr, bool _isExists) external onlyOwner {
        TokenExistsInSilo[_TokenAddr] = _isExists;
    }

    function set(uint256 _siloid, uint256 _weight, bool _withUpdate) public onlyOwner {
        if (_withUpdate) {
            massUpdateSilos();
        }
        totalWeight = totalWeight.sub(siloData[_siloid].weight).add( _weight);
        siloData[_siloid].weight = _weight;
    }

    function setMigrator(SiloControlMigrator _migrator) public onlyOwner {
        migrator = _migrator;
    }

    function migrate(uint256 _siloid) public onlyOwner {
        require(address(migrator) != address(0), "Address of migrator is null");

        SiloData storage silo = siloData[_siloid];
        IERC20 Token = silo.Token;
        uint256 bal = Token.balanceOf(address(this));
        Token.safeApprove(address(migrator), bal);
        IERC20 newToken = migrator.migrate(Token);

        require(!TokenExistsInSilo[address(newToken)], "New Token Address already exists in silo");
        require(bal == newToken.balanceOf(address(this)), "New Token balance incorrect");

        silo.Token = newToken;

        TokenExistsInSilo[address(newToken)] = true;
    }

    function pendingMint(uint256 _siloid, address _user) external view returns (uint256) {
        SiloData storage silo = siloData[_siloid];
        Depositor storage user = depositor[_siloid][_user];
        uint256 mintedTokenPerShare = silo.mintedTokenPerShare;
        uint256 siloedTokenSupply = silo.Token.balanceOf(address(this));
        if (block.number > silo.lastMintBlock && siloedTokenSupply != 0) {
            uint256 blockPassed = block.number.sub(silo.lastMintBlock);
            uint256 tokenMint = blockPassed
                .mul(mintPerBlock)
                .mul(silo.weight)
                .div(totalWeight);
            mintedTokenPerShare = mintedTokenPerShare.add(
                tokenMint.mul(1e12).div(siloedTokenSupply)
            );
        }
        return
          user.amount.mul(mintedTokenPerShare).div(1e12).sub(user.mintDebt);
    }

    function massUpdateSilos() public {
        uint256 length = siloData.length;
        for (uint256 siloid = 0; siloid < length; ++siloid) {
            updateSilo(siloid);
        }
    }

    function updateSilo(uint256 _siloid) public {
        doHalvingCheck(false);
        SiloData storage silo = siloData[_siloid];
        if (block.number <= silo.lastMintBlock) {
            return;
        }

        uint256 siloedTokenSupply = silo.Token.balanceOf(address(this));
        if (siloedTokenSupply == 0) {
            silo.lastMintBlock = block.number;
            return;
        }
        uint256 blockPassed = block.number.sub(silo.lastMintBlock);
        uint256 tokenMint = blockPassed
            .mul(mintPerBlock)
            .mul(silo.weight)
            .div(totalWeight);

        mintedToken.mint(teller, tokenMint.div(10));
        mintedToken.mint(address(this), tokenMint);
        silo.mintedTokenPerShare = silo.mintedTokenPerShare.add(
            tokenMint.mul(1e12).div(siloedTokenSupply)
        );
        silo.lastMintBlock = block.number;
    }

    function deposit(uint256 _siloid, uint256 _amount) public {
        SiloData storage silo = siloData[_siloid];
        Depositor storage user = depositor[_siloid][msg.sender];
        updateSilo(_siloid);
        if (user.amount > 0) {
            uint256 pending = user
                .amount
                .mul(silo.mintedTokenPerShare)
                .div(1e12)
                .sub(user.mintDebt);
            safeMintedTransfer(msg.sender, pending);
        }
        silo.Token.safeTransferFrom(address(msg.sender), address(this), _amount);
        user.amount = user.amount.add(_amount);
        user.mintDebt = user.amount.mul(silo.mintedTokenPerShare).div(1e12);
        emit Deposit(msg.sender, _siloid, _amount);
    }

    function withdraw(uint256 _siloid, uint256 _amount) public {
        SiloData storage silo = siloData[_siloid];
        Depositor storage user = depositor[_siloid][msg.sender];
        require(user.amount >= _amount, "Insufficient Amount to withdraw");
        updateSilo(_siloid);
        uint256 pending = user.amount.mul(silo.mintedTokenPerShare).div(1e12).sub(user.mintDebt);
        safeMintedTransfer(msg.sender, pending);
        user.amount = user.amount.sub(_amount);
        user.mintDebt = user.amount.mul(silo.mintedTokenPerShare).div(1e12);
        silo.Token.safeTransfer(address(msg.sender), _amount);
        emit Withdraw(msg.sender, _siloid, _amount);
    }

    function exitPoolDisgracefully(uint256 _siloid) public {
        SiloData storage silo = siloData[_siloid];
        Depositor storage user = depositor[_siloid][msg.sender];
        silo.Token.safeTransfer(address(msg.sender), user.amount);
        emit ExitPoolDisgracefully(msg.sender, _siloid, user.amount);
        user.amount = 0;
        user.mintDebt = 0;
    }

    function safeMintedTransfer(address _to, uint256 _amount) internal {
        uint256 mintBalance = mintedToken.balanceOf(address(this));
        if (_amount > mintBalance) {
            mintedToken.transfer(_to, mintBalance);
        } else {
            mintedToken.transfer(_to, _amount);
        }
    }
}