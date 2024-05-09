pragma solidity 0.6.7;

interface IChiToken {
    function freeFromUpTo(address from, uint256 value)
        external
        returns (uint256 freed);
}

interface IProxyFactory {
    function createProxyWithNonce(
        address _mastercopy,
        bytes calldata initializer,
        uint256 saltNonce
    ) external returns (address proxy);
}

interface IGnosisSafe {
    function execTransaction(
        address to,
        uint256 value, 
        bytes calldata data,
        uint8 operation,
        uint256 safeTxGas,
        uint256 baseGas,
        uint256 gasPrice,
        address gasToken,
        address refundReceiver,
        bytes calldata signatures
    ) external returns (bool success);
}

contract Ownable {
    address public _owner;

    constructor () internal {
        _owner = msg.sender;
    }

    modifier onlyOwner() {
        require(_owner == msg.sender, "Ownable: caller is not the owner");
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _owner = newOwner;
    }
}

contract LinenChiWrapper is Ownable {
    IChiToken public constant _chiToken = IChiToken(0x0000000000004946c0e9F43F4Dee607b0eF1fA1c);
    IProxyFactory public constant _factory = IProxyFactory(0x76E2cFc1F5Fa8F6a5b3fC4c8F4788F0116861F9B);

    modifier discountCHI {
        uint256 gasStart = gasleft();
        _;
        uint256 gasSpent = 21000 + gasStart - gasleft() + 16 * msg.data.length;
        _chiToken.freeFromUpTo(msg.sender, (gasSpent + 14154) / 41130);
    }

    function createProxyWithNonce(
        address _mastercopy,
        bytes calldata initializer,
        uint256 saltNonce
    ) external onlyOwner discountCHI returns (address proxy) {
        return _factory.createProxyWithNonce(_mastercopy, initializer, saltNonce);
    }

    function execTransaction(
        address safeAddress,
        bytes calldata data
    ) external onlyOwner discountCHI returns (bool success) {
        bytes memory _data = data;
        assembly {
            success := call(gas(), safeAddress, 0, add(_data, 0x20), mload(_data), 0, 0)
        }
        require(success, "LinenChiWrapper: call failed");
    }
}