pragma solidity ^0.5.8;

// File: contracts/IndividualCertification.sol

/**
  * @title   Individual Certification Contract
  * @author  Rosen GmbH
  *
  * This contract represents the individual certificate.
  */
contract IndividualCertification {
    address public registryAddress;
    bytes32 public b0;
    bytes32 public b1;

    constructor(bytes32 _b0, bytes32 _b1)
      public
    {
        registryAddress = msg.sender;
        b0 = _b0;
        b1 = _b1;
    }
    
    function updateHashValue(bytes32 _b0, bytes32 _b1)
      public
      onlyRegistry
    {
        b0 = _b0;
        b1 = _b1;
    }

    function changeRegistry(address newRegistryAddress)
      public
      onlyRegistry
    {
        registryAddress = newRegistryAddress;
    }

    function hashValue()
      public
      view
    returns (bytes32, bytes32)
    {
        return (b0, b1);
    }
    modifier onlyRegistry() {
        require(msg.sender == registryAddress, "Call invoked from incorrect address");
        _;
    }
    /**
  * Extinguish this certificate.
  *
  * This can be done by the same certifier contract which has created
  * the certificate in the first place only.
  */
    function deleteCertificate() public onlyRegistry {
        selfdestruct(msg.sender);
    }
}

// File: contracts/OrganizationalCertification.sol

/**
  * @title   Certificate Contract
  * @author  Rosen HCMC Lab
  *
  * Each instance of this contract represents a single certificate.
  */
contract OrganizationalCertification  {

    /**
      * Address of CertificatioRegistry contract this certificate belongs to.
      */
    address public registryAddress;

    string public CompanyName;
    string public Standard;
    string public CertificateId;
    string public IssueDate;
    string public ExpireDate;
    string public Scope;
    string public CertificationBodyName;

    /**
      * Constructor.
      *
      * @param _CompanyName Name of company name the certificate is IssueDate to.
      * @param _Standard The Standard.
      * @param _CertificateId Unique identifier of the certificate.
      * @param _IssueDate Timestamp (Unix epoch) when the certificate was IssueDate.
      * @param _ExpireDate Timestamp (Unix epoch) when the certificate will expire.
      * @param _Scope The scope of the certificate.
      * @param _CertificationBodyName The issuer of the certificate.
      */
    constructor(
        string memory _CompanyName,
        string memory _Standard,
        string memory _CertificateId,
        string memory _IssueDate,
        string memory _ExpireDate,
        string memory _Scope,
        string memory _CertificationBodyName)
        public
    {
        registryAddress = msg.sender;
        CompanyName = _CompanyName;
        Standard = _Standard;
        CertificateId = _CertificateId;
        IssueDate = _IssueDate;
        ExpireDate = _ExpireDate;
        Scope = _Scope;
        CertificationBodyName = _CertificationBodyName;
    }

    function updateCertificate(
        string memory _CompanyName,
        string memory _Standard,
        string memory _IssueDate,
        string memory _ExpireDate,
        string memory _Scope)
        public
        onlyRegistry
    {
        CompanyName = _CompanyName;
        Standard = _Standard;
        IssueDate = _IssueDate;
        ExpireDate = _ExpireDate;
        Scope = _Scope;
    }

    function changeRegistry(address newRegistryAddress)
        public
        onlyRegistry
    {
        registryAddress = newRegistryAddress;
    }

    modifier onlyRegistry() {
        require(msg.sender == registryAddress, "Call invoked from incorrect address");
        _;
    }
    /**
      * Extinguish this certificate.
      *
      * This can be done the same certifier contract which has created
      * the certificate in the first place only.
      */
    function deleteCertificate() public onlyRegistry {
        selfdestruct(msg.sender);
    }

}

// File: contracts\CertificationRegistry.sol

/**
  * @title   Certification Contract
  * @author  Rosen HCMC Lab
  * This contract represents the singleton certificate registry.
  */

contract CertificationRegistry {

    /** @dev Dictionary of all Certificate Contracts issued by the Organization.
             Stores the Organization ID and which Certificates they issued.
             Stores the Certification key derived from the keccak256(CertificateOriginalId) and stores the
             address where the corresponding Certificate is stored.
             Mapping(keccak256(CertificateOriginalId, organizationID) => certAddress))
             */
    mapping (bytes32 => address) public CertificateAddresses;
    mapping (bytes32 => address) public RosenCertificateAddresses;

    /** @dev Dictionary that stores which addresses are owntrated by Certification administrators and
             which Organization those Certification adminisors belong to
             keccak256 (adminAddress, organizationID) => bool
     */
    mapping (bytes32  => bool) public CertAdmins;

    /** @dev Dictionary that stores which addresses are owned by ROSEN Certification administrators
             Mapping(adminAddress => bool)
    */
    mapping (address => bool) public RosenCertAdmins;

    /** @dev stores the address of the Global Administrator */
    address public GlobalAdmin;


    event OrganizationCertificationSet(address indexed contractAddress);
    event OrganizationCertificationUpdated(address indexed contractAddress);
    event IndividualCertificationSet(address indexed contractAddress);
    event IndividualCertificationUpdated(address indexed contractAddress);
    event CertificationDeleted(address indexed contractAddress);
    event CertAdminAdded(address indexed account);
    event CertAdminDeleted(address account);
    event GlobalAdminChanged(address indexed account);
    event Migration(address indexed newRegistryAddress);
    /**
      * Constructor.
      *
      * The creator of this contract becomes the global administrator.
      */
    constructor() public {
        GlobalAdmin = msg.sender;
    }

    // Functions

    /**
      * Create a new certificate contract.
      * This can be done by an certificate administrator only.
      *
      * @param _OriginalCertificateId  Globally uniqueID composed by BEC service.
      * @param _CompanyName Name of company name the certificate is issued to.
      * @param _Standard The norm.
      * @param _CertificateId Certificate physical ID
      * @param _IssueDate Timestamp (Unix epoch) when the certificate was issued.
      * @param _ExpireDate Timestamp (Unix epoch) when the certificate will expire.
      * @param _Scope The scope of the certificate.
      * @param _CertificationBodyName The issuer of the certificate.
      */
    function setOrganizationCertificate(
        string memory _OriginalCertificateId,
        string memory _CompanyName,
        string memory _Standard,
        string memory _CertificateId,
        string memory _IssueDate,
        string memory _ExpireDate,
        string memory _Scope,
        string memory _CertificationBodyName
    )
    public
    onlyRosenCertAdmin
    {
        bytes32 certKey = keccak256(abi.encodePacked(_OriginalCertificateId));

        OrganizationalCertification orgCert = new OrganizationalCertification(
            _CompanyName,
            _Standard,
            _CertificateId,
            _IssueDate,
            _ExpireDate,
            _Scope,
            _CertificationBodyName);

        RosenCertificateAddresses[certKey] = address(orgCert);
        emit OrganizationCertificationSet(address(orgCert));
    }

     /**
      * Update an organization certificate contract.
      * This can be done by an certificate administrator only.
      *
      * @param _OriginalCertificateId  Globally uniqueID composed by BEC service.
      * @param _CompanyName Name of company name the certificate is issued to.
      * @param _Standard The norm.
      * @param _IssueDate Timestamp (Unix epoch) when the certificate was issued.
      * @param _ExpireDate Timestamp (Unix epoch) when the certificate will expire.
      * @param _Scope The scope of the certificate.
      */
    function updateOrganizationCertificate(
        string memory _OriginalCertificateId,
        string memory _CompanyName,
        string memory _Standard,
        string memory _IssueDate,
        string memory _ExpireDate,
        string memory _Scope)
        public
    onlyRosenCertAdmin
    {
        bytes32 certKey = keccak256(abi.encodePacked(_OriginalCertificateId));
        address certAddress = RosenCertificateAddresses[certKey];
        OrganizationalCertification(certAddress).updateCertificate(
            _CompanyName,
            _Standard,
            _IssueDate,
            _ExpireDate,
            _Scope);

        emit OrganizationCertificationUpdated(certAddress);
    }
    function setIndividualCertificate(
        bytes32 b0,
        bytes32 b1,
        string memory _OriginalCertificateId,
        string memory _organizationID)
        public
        onlyPrivilegedCertAdmin(_organizationID)
        entryMustNotExist(_OriginalCertificateId, _organizationID)
    {

        IndividualCertification individualCert = new IndividualCertification(b0, b1);
        CertificateAddresses[toCertificateKey(_OriginalCertificateId, _organizationID)] = address(individualCert);
        emit IndividualCertificationSet(address(individualCert));
    }

    function updateIndividualCertificate(bytes32 b0, bytes32 b1, string memory _OriginalCertificateId, string memory _organizationID)
        public
        onlyPrivilegedCertAdmin(_organizationID)
        duplicatedHashGuard(b0, b1, _OriginalCertificateId, _organizationID)
    {
		address certAddr = CertificateAddresses[toCertificateKey(_OriginalCertificateId, _organizationID)];
        IndividualCertification(certAddr).updateHashValue(b0, b1);
        emit IndividualCertificationUpdated(certAddr);
    }

    /**
      * Delete an existing certificate.
      *
      * This can be done by an certificate administrator only.
      *
      * @param _OriginalCertificateId Unique identifier of the certificate to delete.
      */
    function delOrganizationCertificate(string memory _OriginalCertificateId)
        public
        onlyRosenCertAdmin
    {
		bytes32 certKey = keccak256(abi.encodePacked(_OriginalCertificateId));
        OrganizationalCertification(RosenCertificateAddresses[certKey]).deleteCertificate();

        emit CertificationDeleted(RosenCertificateAddresses[certKey]);
        delete RosenCertificateAddresses[certKey];
    }
    /**
      * Delete an exisiting certificate.
      *
      * This can be done by an certificate administrator only.
      *
      * @param _OriginalCertificateId Unique identifier of the certificate to delete.
      * @param _organizationID UUID of organization tenantID.
      */
    function delIndividualCertificate(
        string memory _OriginalCertificateId,
        string memory _organizationID)
        public
        onlyPrivilegedCertAdmin(_organizationID)
    {
		bytes32 certKey = toCertificateKey(_OriginalCertificateId,_organizationID);
        IndividualCertification(CertificateAddresses[certKey]).deleteCertificate();
        emit CertificationDeleted(CertificateAddresses[certKey]);
        delete CertificateAddresses[certKey];

    }
    /**
      * Register a certificate administrator.
      *
      * This can be done by the global administrator only.
      *
      * @param _CertAdmin Address of certificate administrator to be added.
      * @param _organizationID UUID of organization tenantID.
      */
    function addCertAdmin(address _CertAdmin, string memory _organizationID)
        public
        onlyGlobalAdmin
    {
        CertAdmins[toCertAdminKey(_CertAdmin, _organizationID)] = true;
        emit CertAdminAdded(_CertAdmin);
    }

    /**
      * Delete a certificate administrator.
      *
      * This can be done by the global administrator only.
      *
      * @param _CertAdmin Address of certificate administrator to be removed.
      * @param _organizationID UUID of organization tenantID.
      */
    function delCertAdmin(address _CertAdmin, string memory _organizationID)
    public
    onlyGlobalAdmin
    {
        delete CertAdmins[toCertAdminKey(_CertAdmin, _organizationID)];
        emit CertAdminDeleted(_CertAdmin);
    }

    /**
    * Register a ROSEN certificate administrator.
    *
    * This can be done by the global administrator only.
    *
    * @param _CertAdmin Address of certificate administrator to be added.
    */
    function addRosenCertAdmin(address _CertAdmin) public onlyGlobalAdmin {
        RosenCertAdmins[_CertAdmin] = true;
        emit CertAdminAdded(_CertAdmin);
    }

    /**
      * Delete a ROSEN certificate administrator.
      *
      * This can be done by the global administrator only.
      *
      * @param _CertAdmin Address of certificate administrator to be removed.
      */
    function delRosenCertAdmin(address _CertAdmin) public onlyGlobalAdmin {
        delete RosenCertAdmins[_CertAdmin];
        emit CertAdminDeleted(_CertAdmin);
    }

    /**
      * Change the address of the global administrator.
      *
      * This can be done by the global administrator only.
      *
      * @param _GlobalAdmin Address of new global administrator to be set.
      */
    function changeGlobalAdmin(address _GlobalAdmin) public onlyGlobalAdmin {
        GlobalAdmin=_GlobalAdmin;
        emit GlobalAdminChanged(_GlobalAdmin);

    }

    // Constant Functions

    /**
      * Determines the address of a certificate contract.
      *
      * @param _organizationID UUID of organization tenantID.
      * @param _OriginalCertificateId Unique certificate identifier.
      * @return Address of certification contract.
      */
    function getCertAddressByID(string memory _organizationID, string memory _OriginalCertificateId)
        public
        view
        returns (address)
    {
        return CertificateAddresses[toCertificateKey(_OriginalCertificateId, _organizationID)];
    }

    /**
      * Determines the address of a certificate contract.
      *
      * @param _OriginalCertificateId Unique certificate identifier.
      * @return Address of certification contract.
      */
    function getOrganizationalCertAddressByID(string memory _OriginalCertificateId)
        public
        view
        returns (address)
    {
        return RosenCertificateAddresses[keccak256(abi.encodePacked(_OriginalCertificateId))];
    }


    function getCertAdminByOrganizationID(address _certAdmin, string memory _organizationID)
        public
        view
        returns (bool)
    {
        return CertAdmins[toCertAdminKey(_certAdmin, _organizationID)];
    }

    /**
      * Derives an unique key from a certificate identifier to be used in the
      * global mapping CertificateAddresses.
      *
      * This is necessary due to certificate identifiers are of type string
      * which cannot be used as dictionary keys.
      *
      * @param _OriginalCertificateId The unique certificate identifier.
      * @param _organizationID UUID of organization tenantID.
      * @return The key derived from certificate identifier.
      */
    function toCertificateKey(string memory _OriginalCertificateId, string memory _organizationID)
        public
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(_OriginalCertificateId, _organizationID));
    }


    function toCertAdminKey(address _certAdmin, string memory _organizationID)
        public
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(_certAdmin, _organizationID));
    }

    /**
     * Use conjunction with updateIndividualCertMapping to migrate IndividualCertication contract to new CertificationRegistry
     */
    function migrateIndividualCertificate(address _newRegistryAddress, string memory _OriginalCertificateId, string memory _organizationID)
        public
        onlyGlobalAdmin
    {
        bytes32 certKey = toCertificateKey(_OriginalCertificateId, _organizationID);
        address certAddress = CertificateAddresses[certKey];
        IndividualCertification(certAddress).changeRegistry(_newRegistryAddress);
        emit Migration(_newRegistryAddress);
    }

    /**
     * Use conjunction with updateOrganizationCertMapping to migrate OrganizationalCertification contract to new CertificationRegistry
     */
    function migrateOrganizationCertificate(address _newRegistryAddress, string memory _OriginalCertificateId)
        public
        onlyGlobalAdmin
    {
        bytes32 certKey = keccak256(abi.encodePacked(_OriginalCertificateId));
        address certAddress = RosenCertificateAddresses[certKey];
        IndividualCertification(certAddress).changeRegistry(_newRegistryAddress);
        emit Migration(_newRegistryAddress);
    }

    function updateOrganizationCertMapping(address certAddress, string memory _OriginalCertificateId)
        public
        onlyRosenCertAdmin
    {
        RosenCertificateAddresses[keccak256(abi.encodePacked(_OriginalCertificateId))] = certAddress;
    }

    function updateIndividualCertMapping(address certAddress, string memory _OriginalCertificateId, string memory _organizationID)
        public
        onlyPrivilegedCertAdmin(_organizationID)
    {
        CertificateAddresses[toCertificateKey(_OriginalCertificateId, _organizationID)] = certAddress;
    }

    // Modifiers

    /**
      * Ensure that only the global administrator is able to perform.
      */
    modifier onlyGlobalAdmin() {
        require(msg.sender == GlobalAdmin, "Access denied, require global admin account");
        _;
    }

    /**
      * Ensure that only a privileged certificate administrator is able to perform.
      */
    modifier onlyPrivilegedCertAdmin(string memory organizationID) {
        require(CertAdmins[toCertAdminKey(msg.sender, organizationID)] || RosenCertAdmins[msg.sender], 
        "Access denied, Please use function with certificate admin privileges");
        _;
    }

    modifier onlyRosenCertAdmin() {
        require(RosenCertAdmins[msg.sender], "Access denied, Please use function with certificate admin privileges");
        _;
    }
    /**
     * Ensure individual entry should not exist, prevent re-entrancy
     */
    modifier entryMustNotExist(string memory _OriginalCertificateId, string memory _organizationID) {
        require(CertificateAddresses[toCertificateKey(_OriginalCertificateId, _organizationID)] == address(0), "Entry existed exception!");
        _;
    }
    modifier duplicatedHashGuard(
      bytes32 _b0,
      bytes32 _b1,
      string memory _OriginalCertificateId,
      string memory _organizationID) {

        IndividualCertification individualCert = IndividualCertification(CertificateAddresses[toCertificateKey(_OriginalCertificateId, _organizationID)]);
        require(keccak256(abi.encodePacked(_b0, _b1)) != keccak256(abi.encodePacked(individualCert.b0(), individualCert.b1())),
        "Duplicated hash-value exception!");
        _;
    }
}