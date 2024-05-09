pragma solidity 0.5.11;


contract Context {
    
    
    constructor () internal { }
    

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; 
        return msg.data;
    }
}

contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    
    constructor () internal {
        _owner = _msgSender();
        emit OwnershipTransferred(address(0), _owner);
    }

    
    function owner() public view returns (address) {
        return _owner;
    }

    
    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    
    function isOwner() public view returns (bool) {
        return _msgSender() == _owner;
    }

    
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

interface IERC165 {
    
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

contract IERC721 is IERC165 {
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    
    function balanceOf(address owner) public view returns (uint256 balance);

    
    function ownerOf(uint256 tokenId) public view returns (address owner);

    
    function safeTransferFrom(address from, address to, uint256 tokenId) public;
    
    function transferFrom(address from, address to, uint256 tokenId) public;
    function approve(address to, uint256 tokenId) public;
    function getApproved(uint256 tokenId) public view returns (address operator);

    function setApprovalForAll(address operator, bool _approved) public;
    function isApprovedForAll(address owner, address operator) public view returns (bool);


    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
}

contract ICards is IERC721 {

    struct Batch {
        uint48 userID;
        uint16 size;
    }

    function batches(uint index) public view returns (uint48 userID, uint16 size);

    function userIDToAddress(uint48 id) public view returns (address);

    function getDetails(
        uint tokenId
    )
        public
        view
        returns (
        uint16 proto,
        uint8 quality
    );

    function setQuality(
        uint tokenId,
        uint8 quality
    ) public;

    function mintCards(
        address to,
        uint16[] memory _protos,
        uint8[] memory _qualities
    )
        public
        returns (uint);

    function mintCard(
        address to,
        uint16 _proto,
        uint8 _quality
    )
        public
        returns (uint);

    function burn(uint tokenId) public;

    function batchSize()
        public
        view
        returns (uint);
}

contract Fusing is Ownable {

    ICards public cards;

    mapping (address => bool) approvedMinters;

    event MinterAdded(
        address indexed minter
    );

    event MinterRemoved(
        address indexed minter
    );

    event CardFused(
        address owner,
        address tokenAddress,
        uint[] references,
        uint indexed tokenId,
        uint indexed lowestReference
    );

    
    modifier onlyMinter(address _minter) {
        require(
            approvedMinters[_minter] == true,
            "Fusing: invalid minter"
        );
        _;
    }

    constructor(ICards _cards) public {
        cards = ICards(_cards);
    }

    
    function addMinter(
        address _minter
    )
        public
        onlyOwner
    {
        approvedMinters[_minter] = true;

        emit MinterAdded(_minter);
    }

    
    function removeMinter(
        address _minter
    )
        public
        onlyOwner
    {
        approvedMinters[_minter] = false;
        delete approvedMinters[_minter];

        emit MinterRemoved(_minter);
    }

    
    function fuse(
        uint16 _proto,
        uint8 _quality,
        address _to,
        uint[] memory _references
    )
        public
        onlyMinter(msg.sender)
        returns (uint tokenId)
    {

        require(
            _to != address(0),
            "Fusing: to address cannot be 0"
        );

        require(
            _references.length > 0,
            "Fusing must have more than one reference"
        );

        tokenId = cards.mintCard(_to, _proto, _quality);

        uint lowestReference = _references[0];
        for (uint i = 0; i < _references.length; i++) {
            if (_references[i] < lowestReference) {
                lowestReference = _references[i];
            }
        }

        emit CardFused(_to, address(cards), _references, tokenId, lowestReference);
    }

    
    function isApprovedMinter(
        address _minter
    )
        public
        returns
        (bool)
    {
        return approvedMinters[_minter];
    }

}