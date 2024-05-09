pragma solidity ^0.5.0;

library Address {

    function isContract(address account) internal view returns (bool) {

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }
}

library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
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
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
}

library Counters {
    using SafeMath for uint256;

    struct Counter {
     
        uint256 _value; // default: 0
    }

    function current(Counter storage counter) internal view returns (uint256) {
        return counter._value;
    }

    function increment(Counter storage counter) internal {
        counter._value += 1;
    }

    function decrement(Counter storage counter) internal {
        counter._value = counter._value.sub(1);
    }
}

interface IERC165 {

    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

contract ERC165 is IERC165 {
    /*
     * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
     */
    bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;

    /**
     * @dev Mapping of interface ids to whether or not it's supported.
     */
    mapping(bytes4 => bool) private _supportedInterfaces;

    constructor () internal {
 
        _registerInterface(_INTERFACE_ID_ERC165);
    }

    function supportsInterface(bytes4 interfaceId) external view returns (bool) {
        return _supportedInterfaces[interfaceId];
    }

    function _registerInterface(bytes4 interfaceId) internal {
        require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
        _supportedInterfaces[interfaceId] = true;
    }
}

/**
 * @dev Required interface of an ERC721 compliant contract.
 */
contract IERC721 is IERC165 {
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of NFTs in `owner`'s account.
     */
    function balanceOf(address owner) public view returns (uint256 balance);

    /**
     * @dev Returns the owner of the NFT specified by `tokenId`.
     */
    function ownerOf(uint256 tokenId) public view returns (address owner);

    function transferFrom(address from, address to, uint256 tokenId) public;
} 

contract ERC721 is ERC165, IERC721 {
    using SafeMath for uint256;
    using Address for address;
    using Counters for Counters.Counter;

    bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;

    // Mapping from token ID to owner
    mapping (uint256 => address) private _tokenOwner;

    // Mapping from token ID to approved address
    mapping (uint256 => address) private _tokenApprovals;

    // Mapping from owner to number of owned token
    mapping (address => Counters.Counter) private _ownedTokensCount;

    // Mapping from owner to operator approvals
    mapping (address => mapping (address => bool)) private _operatorApprovals;

    bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;

    constructor () public {
        // register the supported interfaces to conform to ERC721 via ERC165
        _registerInterface(_INTERFACE_ID_ERC721);
    }

    function balanceOf(address owner) public view returns (uint256) {
        require(owner != address(0), "ERC721: balance query for the zero address");

        return _ownedTokensCount[owner].current();
    }

    function ownerOf(uint256 tokenId) public view returns (address) {
        address owner = _tokenOwner[tokenId];
        require(owner != address(0), "ERC721: owner query for nonexistent token");

        return owner;
    }

    function transferFrom(address from, address to, uint256 tokenId) public {
        //solhint-disable-next-line max-line-length
        require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");

        _transferFrom(from, to, tokenId);
    }

    function _exists(uint256 tokenId) internal view returns (bool) {
        address owner = _tokenOwner[tokenId];
        return owner != address(0);
    }

    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
        require(_exists(tokenId), "ERC721: operator query for nonexistent token");
        address owner = ownerOf(tokenId);
        return (spender == owner);
    }

    function _mint(address to, uint256 tokenId) internal {
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");

        _tokenOwner[tokenId] = to;
        _ownedTokensCount[to].increment();

        emit Transfer(address(0), to, tokenId);
    }

    function _transferFrom(address from, address to, uint256 tokenId) internal {
        require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
        require(to != address(0), "ERC721: transfer to the zero address");

        _clearApproval(tokenId);

        _ownedTokensCount[from].decrement();
        _ownedTokensCount[to].increment();

        _tokenOwner[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }

    function _clearApproval(uint256 tokenId) private {
        if (_tokenApprovals[tokenId] != address(0)) {
            _tokenApprovals[tokenId] = address(0);
        }
    }
}

contract ZodiacNFT is ERC721{
    constructor(address[] memory _ownerAddress, uint256[] memory _number) public {
        owner = msg.sender;

        animals[1] = animalSTR; // STR
        animals[2] = animalAGI; // AGI
        animals[3] = animalINT; // INT
        
        for (uint i = 0; i< _ownerAddress.length; i++) {
            whiteListed[_ownerAddress[i]] = _number[i];
        }
    }

    struct Zodiac {
        uint8 animalID;
        uint8 special;
        Stat stat;
        Appearance appearance;
    }
    
    struct Appearance {
        uint64 color;
        uint8 size;
        uint8 pattern; 
        uint8 model;
    }
    
    struct Stat {
        uint256 agility;
        uint256 strength;
        uint256 intelligence;
        uint256 mental;
    }
    
    Zodiac[] zodiacs;
    mapping(uint256 => uint256[]) animals;
    mapping(address => uint256) public whiteListed;
    uint8[12] valueAnimal = [2, 5, 5, 2, 5, 4, 4, 4, 3, 2, 3, 3];
    uint8[4] animalSTR = [2, 8, 10, 12];
    uint8[4] animalAGI = [1, 3, 7, 9];
    uint8[4] animalINT = [4, 5, 6, 11];
    address public owner;
    uint256 private nonce = 0;

    // Functions with this modifier can only be executed by the owner
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function createZodiac() external {
        require(whiteListed[msg.sender] > 0, "You do not have permission to create");
        Zodiac memory newZodiac;
        
        newZodiac.special = uint8(_random() % 9 + 1);
        newZodiac.appearance.color = uint64(_random() % 216 + 1);
        newZodiac.appearance.size = uint8(_random() % 5 + 1);
        newZodiac.appearance.pattern = uint8(_random() % 4 + 1);
        newZodiac.appearance.model = uint8(_random() % 3 + 1);
        (newZodiac.stat.strength, newZodiac.stat.agility, newZodiac.stat.intelligence, newZodiac.animalID) = _randomStat();
        newZodiac.stat.mental = 0;

        uint256 newZodiacId = zodiacs.push(newZodiac) - 1;
        super._mint(msg.sender, newZodiacId);
        whiteListed[msg.sender] -= 1;
    }
    
    // Function to retrieve a specific zodiacs's details.
    function getZodiacDetails(uint256 _zodiacID) public view returns (
        uint8, 
        uint8,
        uint64,
        uint8,
        uint8,
        uint8,
        uint256,
        uint256,
        uint256,
        uint256
        ) {
        Zodiac storage zodiac = zodiacs[_zodiacID];

        return(
               zodiac.animalID,
               zodiac.special,
               zodiac.appearance.color,
               zodiac.appearance.size,
               zodiac.appearance.pattern,
               zodiac.appearance.model,
               zodiac.stat.agility,
               zodiac.stat.strength,
               zodiac.stat.intelligence,
               zodiac.stat.mental);
    }
    
    /** @dev Function to get a list of owned zodiacs' IDs
      * @return A uint array which contains IDs of all owned zodiacss
    */
    function ownedZodiac() public view returns(uint256[] memory) {
        uint256 zodiacCount = balanceOf(msg.sender);
        if (zodiacCount == 0) {
            return new uint256[](0);
        }
        
        uint256[] memory result = new uint256[](zodiacCount);
        uint256 totalZodiacs = zodiacs.length;
        uint256 resultIndex = 0;
        uint256 zodiacID = 0;
        while (zodiacID < totalZodiacs) {
            if (ownerOf(zodiacID) == msg.sender) {
                result[resultIndex] = zodiacID;
                resultIndex = resultIndex + 1;
            }
            zodiacID = zodiacID + 1;
        }
        return result;
    }

    function _randomGacha() private returns(uint256) {
        uint256 gacha = _random() % 10000 + 1;
        if (gacha <= 50) {
            return 30;
        }
        if (gacha <= 150) {
            return 24;
        } 
        if (gacha <= 625) {
            return 15;
        } 
        if (gacha <= 2100) {
            return 9;
        } 
        return 0;
    }
    
    function _randomStat() private returns(uint256, uint256, uint256, uint8) {
        (uint8 animalID, uint256 initSTR, uint256 initAGI, uint256 initINT, uint8 group) = _randomElement();

        uint256 gacha = _randomGacha();
        uint256 b = 0;
        if (gacha > 0) {
            b = _random() % (gacha / 3) + 1;
        } 
        
        return (
                _caculateSTR(group, animalID, initSTR) + b,
                _caculateAGI(group, animalID, initAGI) + b,
                _caculateINT(group, animalID, initINT) + b, 
                uint8(animalID)
                );
    }
    
    function _caculateSTR(uint8 _group, uint8 _animalID, uint256 _initSTR) private returns (uint256) {
        if (_group == 1) {
            return _random() % (valueAnimal[_animalID - 1] * 2) + _initSTR;
        } 
        
        return _random() % (valueAnimal[_animalID - 1]) + _initSTR;
    }
    
    function _caculateAGI(uint8 _group, uint8 _animalID, uint256 _initAGI) private returns (uint256) {
        if (_group == 2) {
            return _random() % (valueAnimal[_animalID - 1] * 2) + _initAGI;
        } 
        
        return _random() % (valueAnimal[_animalID - 1]) + _initAGI;
    }
    
    function _caculateINT(uint8 _group, uint8 _animalID, uint256 _initINT) private returns (uint256) {
        if (_group == 3) {
            return  _random() % (valueAnimal[_animalID - 1] * 2) + _initINT;
        } 
        
        return _random() % (valueAnimal[_animalID - 1]) + _initINT;
    }
    
    // Random animal element
    function _randomElement() private returns(uint8, uint256, uint256, uint256, uint8) {
        uint8 element = uint8(_random() % 9 + 1);
        if (element <= 3) { // STR
            return (uint8(_randomAnimal(1)), 50, 30, 20, 1);
        } 
        if (element <= 6) { // AGI
            return (uint8(_randomAnimal(2)), 25, 50, 25, 2);
        } 
        return (uint8(_randomAnimal(3)), 30, 30, 40, 3);
    }
    
    function _randomAnimal(uint8 _animalGroup) private returns(uint256){
        uint256 animal = _random() % 3 + 1;
        return animals[_animalGroup][animal];
    }
    
    function _random() private returns(uint256) {
        nonce += 1;
        return uint256(keccak256(abi.encodePacked(now, nonce)));
    }
    
    function whiteListAddr(address _addr, uint256 _setCount) public onlyOwner {
        whiteListed[_addr] = _setCount;
    }
    
    // Below two emergency functions will be never used in normal situations.
    // These function is only prepared for emergency case such as smart contract hacking Vulnerability or smart contract abolishment
    // Withdrawn fund by these function cannot belong to any operators or owners.
    // Withdrawn fund should be distributed to individual accounts having original ownership of withdrawn fund.
    function emergencyWithdrawalETH(uint256 amount) public onlyOwner {
        require(msg.sender.send(amount));
    }
    
    // Fallback function
    function() external payable {
    }
}