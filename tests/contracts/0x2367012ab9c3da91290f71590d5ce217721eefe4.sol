// File: contracts/proxies/Proxy.sol

pragma solidity 0.5.15;

/**
 * @title Proxy - Generic proxy contract allows to execute all transactions
 */

contract Proxy {

    // storage position of the address of the current implementation
    bytes32 private constant IMPLEMENTATION_POSITION = keccak256("xsnx.implementationPosition");
    bytes32 private constant PROPOSED_IMPLEMENTATION_POSITION = keccak256("xsnx.proposedImplementationPosition");

    bytes32 private constant PROXY_ADMIN_POSITION = keccak256("xsnx.proxyAdmin");
    bytes32 private constant PROXY_COSIGNER1_POSITION = keccak256("xsnx.cosigner1");
    bytes32 private constant PROXY_COSIGNER2_POSITION = keccak256("xsnx.cosigner2");

    bytes32 private constant PROPOSED_NEW_ADMIN  = keccak256("xsnx.proposedNewAdmin");
    bytes32 private constant PROPOSED_NEW_ADMIN_TIMESTAMP  = keccak256("xsnx.proposedNewAdminTimestamp");

    modifier onlyProxyAdmin() {
        require(msg.sender == readAddressAtPosition(PROXY_ADMIN_POSITION));
        _;
    }

    modifier onlySigner() {
        address signer1 = readAddressAtPosition(PROXY_COSIGNER1_POSITION);
        address signer2 = readAddressAtPosition(PROXY_COSIGNER2_POSITION);
        require(msg.sender == signer1 || msg.sender == signer2);
        _;
    }

    /**
     * @dev Constructor function sets address of master copy contract.
     * @param implementation the address of the implementation contract that this proxy uses
     * @param proxyAdmin the address of the admin of this proxy
     * @param signer1 the first signer of this proxy
     * @param signer2 the second signer of this proxy
     */
    constructor(
        address implementation,
        address proxyAdmin,
        address signer1,
        address signer2
    ) public {
        require(
            implementation != address(0),
            "Invalid implementation address provided"
        );
        require(
            proxyAdmin != address(0),
            "Invalid proxyAdmin address provided"
        );
        require(signer1 != address(0), "Invalid signer1 address provided");
        require(signer2 != address(0), "Invalid signer2 address provided");
        require(signer1 != signer2, "Signers must have different addresses");
        setNewAddressAtPosition(IMPLEMENTATION_POSITION, implementation);
        setNewAddressAtPosition(PROXY_ADMIN_POSITION, proxyAdmin);
        setNewAddressAtPosition(PROXY_COSIGNER1_POSITION, signer1);
        setNewAddressAtPosition(PROXY_COSIGNER2_POSITION, signer2);
    }

    /**
     * @dev Proposes a new implementation contract for this proxy if sender is the Admin
     * @param newImplementation the address of the new implementation
     */
    function proposeNewImplementation(address newImplementation) public onlyProxyAdmin {
        require(newImplementation != address(0), "new proposed implementation cannot be address(0)");
        require(isContract(newImplementation), "new proposed implementation is not a contract");
        require(newImplementation != implementation(), "new proposed address cannot be the same as the current implementation address");
        setNewAddressAtPosition(PROPOSED_IMPLEMENTATION_POSITION, newImplementation);
    }

    /**
     * @dev Confirms a previously proposed implementation if the sender is one of the two cosigners
     * @param confirmedImplementation the address of previously proposed implementation (has to match the previously proposed implementation)
     */
    function confirmImplementation(address confirmedImplementation)
        public
        onlySigner
    {
        address proposedImplementation = readAddressAtPosition(
            PROPOSED_IMPLEMENTATION_POSITION
        );
        require(
            proposedImplementation != address(0),
            "proposed implementation cannot be address(0)"
        );
        require(
            confirmedImplementation == proposedImplementation,
            "proposed implementation doesn't match the confirmed implementation"
        );
        setNewAddressAtPosition(IMPLEMENTATION_POSITION, confirmedImplementation);
        setNewAddressAtPosition(PROPOSED_IMPLEMENTATION_POSITION, address(0));
    }

    /**
     * @dev Proposes a new admin address if the sender is the Admin
     * @param newAdminAddress address of the new admin role
     */
    function proposeAdminTransfer(address newAdminAddress) public onlyProxyAdmin {
        require(newAdminAddress != address(0), "new Admin address cannot be address(0)");
        setProposedAdmin(newAdminAddress);
    }


    /**
     * @dev Changes the admin address to the previously proposed admin address if 24 hours has past since it was proposed
     */
    function confirmAdminTransfer() public onlyProxyAdmin {
        address newAdminAddress = proposedNewAdmin();
        require(newAdminAddress != address(0), "new Admin address cannot be address(0)");
        require(proposedNewAdminTimestamp() <= block.timestamp, "admin change can only be submitted after 1 day");
        setProxyAdmin(newAdminAddress);
        setProposedAdmin(address(0));
    }

    /**
     * @dev Returns whether address is a contract
     */
    function isContract(address _addr) private view returns (bool){
        uint32 size;
        assembly {
            size := extcodesize(_addr)
        }
        return (size > 0);
    }

    /**
     * @dev Returns the address of the implementation contract of this proxy
     */
    function implementation() public view returns (address impl) {
        impl = readAddressAtPosition(IMPLEMENTATION_POSITION);
    }

    /**
     * @dev Returns the admin address of this proxy
     */
    function proxyAdmin() public view returns (address admin) {
        admin = readAddressAtPosition(PROXY_ADMIN_POSITION);
    }

    /**
     * @dev Returns the new proposed implementation address of this proxy (if there is no proposed implementations, returns address(0x0))
     */
    function proposedNewImplementation() public view returns (address impl) {
        impl = readAddressAtPosition(PROPOSED_IMPLEMENTATION_POSITION);
    }

    /**
     * @dev Returns the new proposed admin address of this proxy (if there is no proposed implementations, returns address(0x0))
     */
    function proposedNewAdmin() public view returns (address newAdmin) {
        newAdmin = readAddressAtPosition(PROPOSED_NEW_ADMIN);
    }

    /**
     * @dev Returns the timestamp that the proposed admin can be changed/confirmed
     */
    function proposedNewAdminTimestamp() public view returns (uint256 timestamp) {
        timestamp = readIntAtPosition(PROPOSED_NEW_ADMIN_TIMESTAMP);
    }

    /**
     * @dev Returns the address of the first cosigner if 'id' == 0, otherwise returns the address of the second cosigner
     */
    function proxySigner(uint256 id) public view returns (address signer) {
        if (id == 0) {
            signer = readAddressAtPosition(PROXY_COSIGNER1_POSITION);
        } else {
            signer = readAddressAtPosition(PROXY_COSIGNER2_POSITION);
        }
    }

    /**
     * @dev Returns the proxy type, specified by EIP-897
     * @return Always return 2
     **/
    function proxyType() public pure returns (uint256) {
        return 2; // type 2 is for upgradeable proxy as per EIP-897
    }


    function setProposedAdmin(address proposedAdmin) private {
        setNewAddressAtPosition(PROPOSED_NEW_ADMIN, proposedAdmin);
        setNewIntAtPosition(PROPOSED_NEW_ADMIN_TIMESTAMP, block.timestamp + 1 days);
    }

    function setProxyAdmin(address newAdmin) private {
        setNewAddressAtPosition(PROXY_ADMIN_POSITION, newAdmin);
    }

    function setNewAddressAtPosition(bytes32 position, address newAddr) private {
        assembly { sstore(position, newAddr) }
    }

    function readAddressAtPosition(bytes32 position) private view returns (address result) {
        assembly { result := sload(position) }
    }

    function setNewIntAtPosition(bytes32 position, uint256 newInt) private {
        assembly { sstore(position, newInt) }
    }

    function readIntAtPosition(bytes32 position) private view returns (uint256 result) {
        assembly { result := sload(position) }
    }

    /**
     * @dev Fallback function forwards all transactions and returns all received return data.
     */
    function() external payable {
        bytes32 position = IMPLEMENTATION_POSITION;
        // solium-disable-next-line security/no-inline-assembly
        assembly {
            let masterCopy := and(
                sload(position),
                0xffffffffffffffffffffffffffffffffffffffff
            )
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize())
            let success := delegatecall(
                gas,
                masterCopy,
                ptr,
                calldatasize(),
                0,
                0
            )
            returndatacopy(ptr, 0, returndatasize())
            switch eq(success, 0)
                case 1 {
                    revert(ptr, returndatasize())
                }
            return(ptr, returndatasize())
        }
    }
}

// File: contracts/proxies/xSNXProxy.sol

pragma solidity 0.5.15;


contract xSNXProxy is Proxy {
    constructor(
        address implementation,
        address proxyAdmin,
        address signer1,
        address signer2
    ) public Proxy(
        implementation,
        proxyAdmin,
        signer1,
        signer2
    ) {}
}