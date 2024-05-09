// Copyright (c) 2018-2020 double jump.tokyo inc.
pragma solidity 0.7.4;
pragma experimental ABIEncoderV2;

library Roles {
    struct Role {
        mapping (address => bool) bearer;
    }

    function add(Role storage role, address account) internal {
        require(!has(role, account), "role already has the account");
        role.bearer[account] = true;
    }

    function remove(Role storage role, address account) internal {
        require(has(role, account), "role dosen't have the account");
        role.bearer[account] = false;
    }

    function has(Role storage role, address account) internal view returns (bool) {
        return role.bearer[account];
    }
}

library Uint96 {

    function cast(uint256 a) public pure returns (uint96) {
        require(a < 2**96);
        return uint96(a);
    }

    function add(uint96 a, uint96 b) internal pure returns (uint96) {
        uint96 c = a + b;
        require(c >= a, "addition overflow");
        return c;
    }

    function sub(uint96 a, uint96 b) internal pure returns (uint96) {
        require(a >= b, "subtraction overflow");
        return a - b;
    }

    function mul(uint96 a, uint96 b) internal pure returns (uint96) {
        if (a == 0) {
            return 0;
        }
        uint96 c = a * b;
        require(c / a == b, "multiplication overflow");
        return c;
    }

    function div(uint96 a, uint96 b) internal pure returns (uint96) {
        require(b != 0, "division by 0");
        return a / b;
    }

    function mod(uint96 a, uint96 b) internal pure returns (uint96) {
        require(b != 0, "modulo by 0");
        return a % b;
    }

    function toString(uint96 a) internal pure returns (string memory) {
        bytes32 retBytes32;
        uint96 len = 0;
        if (a == 0) {
            retBytes32 = "0";
            len++;
        } else {
            uint96 value = a;
            while (value > 0) {
                retBytes32 = bytes32(uint256(retBytes32) / (2 ** 8));
                retBytes32 |= bytes32(((value % 10) + 48) * 2 ** (8 * 31));
                value /= 10;
                len++;
            }
        }

        bytes memory ret = new bytes(len);
        uint96 i;

        for (i = 0; i < len; i++) {
            ret[i] = retBytes32[i];
        }
        return string(ret);
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IERC20Optionals {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
}
contract Operatable {
    using Roles for Roles.Role;

    event OperatorAdded(address indexed account);
    event OperatorRemoved(address indexed account);

    event Paused(address account);
    event Unpaused(address account);

    bool private _paused;
    Roles.Role private operators;

    constructor() {
        operators.add(msg.sender);
        _paused = false;
    }

    modifier onlyOperator() {
        require(isOperator(msg.sender), "Must be operator");
        _;
    }

    modifier whenNotPaused() {
        require(!_paused, "Pausable: paused");
        _;
    }

    modifier whenPaused() {
        require(_paused, "Pausable: not paused");
        _;
    }

    function isOperator(address account) public view returns (bool) {
        return operators.has(account);
    }

    function addOperator(address account) public onlyOperator() {
        operators.add(account);
        emit OperatorAdded(account);
    }

    function removeOperator(address account) public onlyOperator() {
        operators.remove(account);
        emit OperatorRemoved(account);
    }

    function paused() public view returns (bool) {
        return _paused;
    }

    function pause() public onlyOperator() whenNotPaused() {
        _paused = true;
        emit Paused(msg.sender);
    }

    function unpause() public onlyOperator() whenPaused() {
        _paused = false;
        emit Unpaused(msg.sender);
    }

    function withdrawEther() public onlyOperator() {
        msg.sender.transfer(address(this).balance);
    }

}

contract MCHCMine is Operatable {
    using Uint96 for uint96;

    event Claim(address indexed owner, uint96 value);
    event Value(address indexed owner, uint96 value);

    struct Balance {
        address recipient;
        uint96 value;
    }

    IERC20 public token;
    address public validator;
    mapping(address => uint96) public claimed;

    constructor(IERC20 _token, address _validator) {
        token = _token;
        validator = _validator;
    }

    function claim(Balance memory _balance, uint8 v, bytes32 r, bytes32 s) external whenNotPaused {
        require(ecrecover(toEthSignedMessageHash(prepareMessage(_balance)), v, r, s) == validator, "Mine: invalid claim signature");
        require(_balance.recipient == msg.sender, "Mine: receipient must be sender");
        
        address recipient = _balance.recipient;
        uint96 toClaim = _balance.value.sub(claimed[recipient]);
        require(toClaim > 0, "Mine: nothing to claim");
        claimed[recipient] = _balance.value;
        require(token.transfer(msg.sender, toClaim), "Mine: mint is not successful");
        emit Claim(recipient, toClaim);
        emit Value(recipient, claimed[recipient]);
    }

    function doOverride(Balance[] memory _balances) external onlyOperator {
        for (uint i = 0; i < _balances.length; i++) {
            claimed[_balances[i].recipient] = _balances[i].value;
            emit Value(_balances[i].recipient, _balances[i].value);
        }
    }

    function prepareMessage(Balance memory _balance) internal pure returns (bytes32) {
        return keccak256(abi.encode(_balance));
    }
    
    function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
    }

    function withdraw() external onlyOperator {
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }
}