// File: contracts/validators/IValidator.sol

pragma solidity ^0.5.0;

interface IValidator {
    function validate(uint256 _building, uint256 _base, uint256 _body, uint256 _roof, uint256 _exterior) external view returns (bool);
}

// File: contracts/validators/CityBuildingValidator.sol

pragma solidity ^0.5.0;


contract CityBuildingValidator is IValidator {

    uint256 public city;
    uint256 public rotation;

    mapping(uint256 => uint256[]) public buildingMappings;
    mapping(uint256 => mapping(uint256 => uint256[])) public buildingBaseMappings;
    mapping(uint256 => mapping(uint256 => uint256[])) public buildingBodyMappings;
    mapping(uint256 => mapping(uint256 => uint256[])) public buildingRoofMappings;

    mapping(uint256 => uint256[]) public exteriorMappings;

    address payable public platform;
    address payable public partner;

    modifier onlyPlatformOrPartner() {
        require(msg.sender == platform || msg.sender == partner);
        _;
    }

    constructor (address payable _platform, uint256 _city) public {
        platform = _platform;
        partner = msg.sender;

        city = _city;
    }

    function validate(uint256 _building, uint256 _base, uint256 _body, uint256 _roof, uint256 _exterior) external view returns (bool) {
        uint256[] memory buildingOptions = buildingMappings[rotation];
        if (!contains(buildingOptions, _building)) {
            return false;
        }

        uint256[] memory baseOptions = buildingBaseMappings[rotation][_building];
        if (!contains(baseOptions, _base)) {
            return false;
        }

        uint256[] memory bodyOptions = buildingBodyMappings[rotation][_building];
        if (!contains(bodyOptions, _body)) {
            return false;
        }

        uint256[] memory roofOptions = buildingRoofMappings[rotation][_building];
        if (!contains(roofOptions, _roof)) {
            return false;
        }

        uint256[] memory exteriorOptions = exteriorMappings[rotation];
        if (!contains(exteriorOptions, _exterior)) {
            return false;
        }

        return true;
    }

    function contains(uint256[] memory _array, uint256 _val) internal pure returns (bool) {

        bool found = false;
        for (uint i = 0; i < _array.length; i++) {
            if (_array[i] == _val) {
                found = true;
                break;
            }
        }

        return found;
    }

    function updateRotation(uint256 _rotation) public onlyPlatformOrPartner {
       rotation = _rotation;
    }

    function updateBuildingMappings(uint256 _rotation, uint256[] memory _params) public onlyPlatformOrPartner {
        buildingMappings[_rotation] = _params;
    }

    function updateBuildingBaseMappings(uint256 _rotation, uint256 _building, uint256[] memory _params) public onlyPlatformOrPartner {
        buildingBaseMappings[_rotation][_building] = _params;
    }

    function updateBuildingBodyMappings(uint256 _rotation, uint256 _building, uint256[] memory _params) public onlyPlatformOrPartner {
        buildingBodyMappings[_rotation][_building] = _params;
    }

    function updateBuildingRoofMappings(uint256 _rotation, uint256 _building, uint256[] memory _params) public onlyPlatformOrPartner {
        buildingRoofMappings[_rotation][_building] = _params;
    }

    function updateExteriorMappings(uint256 _rotation, uint256[] memory _params) public onlyPlatformOrPartner {
        exteriorMappings[_rotation] = _params;
    }

    function buildingMappingsArray() public view returns (uint256[] memory) {
        return buildingMappings[rotation];
    }

    function buildingBaseMappingsArray(uint256 _building) public view returns (uint256[] memory) {
        return buildingBaseMappings[rotation][_building];
    }

    function buildingBodyMappingsArray(uint256 _building) public view returns (uint256[] memory) {
        return buildingBodyMappings[rotation][_building];
    }

    function buildingRoofMappingsArray(uint256 _building) public view returns (uint256[] memory) {
        return buildingRoofMappings[rotation][_building];
    }

    function exteriorMappingsArray() public view returns (uint256[] memory) {
        return exteriorMappings[rotation];
    }

    function currentRotation() public view returns (uint256) {
        return rotation;
    }
}