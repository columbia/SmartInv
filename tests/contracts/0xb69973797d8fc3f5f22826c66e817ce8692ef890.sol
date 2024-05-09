pragma solidity >=0.4.23 <0.6.0;

interface UmiTokenInterface {
    function putIntoBlacklist(address _addr) external;

    function removeFromBlacklist(address _addr) external;

    function inBlacklist(address _addr) external view returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

    function mint(address account, uint256 amount) external returns (bool);

    function balanceOf(address account) external view returns (uint256);
}

interface UniSageInterface {
    function isUserExists(address user) external view returns (bool);
}

contract UMIChrismas {
    address owner;

    //mainnet
    address public umiTokenAddr = 0xf61DdA9A827cff208b6242FCF72AD1bB2006A995;
    //goerli
    // address public umiTokenAddr = 0x3B4005397f57804BEbFAf5B0aFA3B2DD13CD7F0F; 
    UmiTokenInterface public umiToken = UmiTokenInterface(umiTokenAddr);

    //mainnet
    address public unisageAddr = 0xd4845cBc79acE2cc6E48C8671a5860FfAB920bC2;
    //goerli
    // address public unisageAddr = 0xf61DdA9A827cff208b6242FCF72AD1bB2006A995;
    
    UniSageInterface public unisage = UniSageInterface(unisageAddr);

    //switch
    bool public open = true;

    //total airdrop
    uint256 public totalAirdropAmount = 100000000000000000000000;
    //single address can receive amount
    uint256 public singleAirdropAmount = 100000000000000000000;
    //referrer address can receive amount
    uint256 public singleAirdropAmountForReferrer = 0;

    //statics
    uint256 public hasAirdropAmount = 0;

    //
    mapping(address => bool) public successList;

    //event list
    event chrismasAirdropEvent(address indexed userAddr, uint256 airdropAmount);

    constructor() public {
        owner = msg.sender;
    }

    ////////////////////////////////////////////////////////////////////////////////
    //user operation

    function isUserJoined(address user) public view returns (bool) {
        return successList[user];
    }

    function getChrismasAirdrop() external {
        //condition 1, switch is open
        require(open, "umi chrismas has been closed");

        //condition 2, not in umi blacklist
        bool isInblacklist = umiToken.inBlacklist(msg.sender);
        require(!isInblacklist, "address is in blacklist");

        //condition 3 , not registered
        bool isRegisterd = unisage.isUserExists(msg.sender);
        require(!isRegisterd, "address is exsits");

        //condition 4, not joined before
        bool isJoined = isUserJoined(msg.sender);
        require(!isJoined, "address has been join already");

        //condition 5, the remain airdrop amount is enough
        require(
            hasAirdropAmount + singleAirdropAmount <= totalAirdropAmount,
            "the remain airdrop amount is not enough"
        );

        //transfer
        umiToken.transfer(msg.sender,singleAirdropAmount);
        umiToken.putIntoBlacklist(msg.sender);

        hasAirdropAmount = hasAirdropAmount + singleAirdropAmount;

        //record
        successList[msg.sender] = true;

        emit chrismasAirdropEvent(msg.sender, singleAirdropAmount);
    }

    ////////////////////////////////////////////////////////////////////////////////
    // owner operation
    function refreshOpen(bool _open) external {
        require(msg.sender == owner, "only owner can do this operation");
        open = _open;
    }

    function changeTotalAirdropAmount(uint256 amount) external {
        require(msg.sender == owner, "only owner can do this operation");
        totalAirdropAmount = amount;
    }

    function changeSingleAirdropAmount(uint256 amount) external {
        require(msg.sender == owner, "only owner can do this operation");
        singleAirdropAmount = amount;
    }

    function changeSingleAirdropAmountForReferrer(uint256 amount) external {
        require(msg.sender == owner, "only owner can do this operation");
        singleAirdropAmountForReferrer = amount;
    }

    function changeUmiTokenAddr(address _addr) external {
        require(msg.sender == owner, "only owner can do this operation");
        umiTokenAddr = _addr;
        umiToken = UmiTokenInterface(umiTokenAddr);
    }

    function changeUnisageAddr(address _addr) external {
        require(msg.sender == owner, "only owner can do this operation");
        unisageAddr = _addr;
        unisage = UniSageInterface(unisageAddr);
    }
}