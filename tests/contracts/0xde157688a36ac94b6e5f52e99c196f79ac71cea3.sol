pragma solidity 0.5.17;


interface IERCProxy {
    function proxyType() external pure returns (uint proxyTypeId);
    function implementation() external view returns (address codeAddr);
}

contract Proxy is IERCProxy {
    function delegatedFwd(address _dst, bytes memory _calldata) internal {
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            let result := delegatecall(
                sub(gas(), 10000),
                _dst,
                add(_calldata, 0x20),
                mload(_calldata),
                0,
                0
            )
            let size := returndatasize()

            let ptr := mload(0x40)
            returndatacopy(ptr, 0, size)

            // revert instead of invalid() bc if the underlying call failed with invalid() it already wasted gas.
            // if the call returned error data, forward it
            switch result
                case 0 {
                    revert(ptr, size)
                }
                default {
                    return(ptr, size)
                }
        }
    }

    function proxyType() external pure returns (uint proxyTypeId) {
        // Upgradeable proxy
        proxyTypeId = 2;
    }

    function implementation() public view returns (address);
}

contract OwnableProxy {
    bytes32 constant OWNER_SLOT = keccak256("proxy.owner");

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() internal {
        _transferOwnership(msg.sender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns(address _owner) {
        bytes32 position = OWNER_SLOT;
        assembly {
            _owner := sload(position)
        }
    }

    modifier onlyOwner() {
        require(isOwner(), "NOT_OWNER");
        _;
    }

    function isOwner() public view returns (bool) {
        return owner() == msg.sender;
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "OwnableProxy: new owner is the zero address");
        emit OwnershipTransferred(owner(), newOwner);
        bytes32 position = OWNER_SLOT;
        assembly {
            sstore(position, newOwner)
        }
    }
}

contract UpgradableProxy is OwnableProxy, Proxy {
    bytes32 constant IMPLEMENTATION_SLOT = keccak256("proxy.implementation");

    event ProxyUpdated(address indexed previousImpl, address indexed newImpl);

    function() external payable {
        delegatedFwd(implementation(), msg.data);
    }

    function implementation() public view returns(address _impl) {
        bytes32 position = IMPLEMENTATION_SLOT;
        assembly {
            _impl := sload(position)
        }
    }

    // ACLed on onlyOwner via the call to updateImplementation()
    function updateAndCall(address _newProxyTo, bytes memory data) public {
        updateImplementation(_newProxyTo);
        // sometimes required to initialize the contract
        (bool success, bytes memory returnData) = address(this).call(data);
        require(success, string(returnData));
    }

    function updateImplementation(address _newProxyTo) public onlyOwner {
        require(_newProxyTo != address(0x0), "INVALID_PROXY_ADDRESS");
        require(isContract(_newProxyTo), "DESTINATION_ADDRESS_IS_NOT_A_CONTRACT");
        emit ProxyUpdated(implementation(), _newProxyTo);
        setImplementation(_newProxyTo);
    }

    function setImplementation(address _newProxyTo) private {
        bytes32 position = IMPLEMENTATION_SLOT;
        assembly {
            sstore(position, _newProxyTo)
        }
    }

    function isContract(address _target) internal view returns (bool) {
        if (_target == address(0)) {
            return false;
        }
        uint size;
        assembly {
            size := extcodesize(_target)
        }
        return size > 0;
    }
}

contract ibDFDProxy is UpgradableProxy {

    function name() public pure returns (string memory) {
        return "interest-bearing DFD";
    }

    function symbol() public pure returns (string memory) {
        return "ibDFD";
    }

    /* NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public pure returns (uint8) {
        return 18;
    }
}