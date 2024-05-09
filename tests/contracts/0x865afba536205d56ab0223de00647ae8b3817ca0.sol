pragma solidity 0.5.0;
pragma experimental ABIEncoderV2;

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
    address public owner;


    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
    constructor() public {
        owner = msg.sender;
    }

  /**
   * @dev Throws if called by any account other than the owner.
   */
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    function getOwner() public view returns (address) {
        return owner;
    }

    function getOwnerStatic(address ownableContract) internal view returns (address) {
        bytes memory callcodeOwner = abi.encodeWithSignature("getOwner()");
        (bool success, bytes memory returnData) = address(ownableContract).staticcall(callcodeOwner);
        require(success, "input address has to be a valid ownable contract");
        return parseAddr(returnData);
    }

    function getTokenVestingStatic(address tokenFactoryContract) internal view returns (address) {
        bytes memory callcodeTokenVesting = abi.encodeWithSignature("getTokenVesting()");
        (bool success, bytes memory returnData) = address(tokenFactoryContract).staticcall(callcodeTokenVesting);
        require(success, "input address has to be a valid TokenFactory contract");
        return parseAddr(returnData);
    }


    function parseAddr(bytes memory data) public pure returns (address parsed){
        assembly {parsed := mload(add(data, 32))}
    }




}

/**
 * @title Registry contract for storing token proposals
 * @dev For storing token proposals. This can be understood as a state contract with minimal CRUD logic.
 * @author Jake Goh Si Yuan @ jakegsy, jake@jakegsy.com
 */
contract Registry is Ownable {

    struct Creator {
        address token;
        string name;
        string symbol;
        uint8 decimals;
        uint256 totalSupply;
        address proposer;
        address vestingBeneficiary;
        uint8 initialPercentage;
        uint256 vestingPeriodInWeeks;
        bool approved;
    }

    mapping(bytes32 => Creator) public rolodex;
    mapping(string => bytes32)  nameToIndex;
    mapping(string => bytes32)  symbolToIndex;

    event LogProposalSubmit(string name, string symbol, address proposer, bytes32 indexed hashIndex);
    event LogProposalApprove(string name, address indexed tokenAddress);

    /**
     * @dev Submit token proposal to be stored, only called by Owner, which is set to be the Manager contract
     * @param _name string Name of token
     * @param _symbol string Symbol of token
     * @param _decimals uint8 Decimals of token
     * @param _totalSupply uint256 Total Supply of token
     * @param _initialPercentage uint8 Initial Percentage of total supply to Vesting Beneficiary
     * @param _vestingPeriodInWeeks uint256 Number of weeks that the remaining of total supply will be linearly vested for
     * @param _vestingBeneficiary address Address of Vesting Beneficiary
     * @param _proposer address Address of Proposer of Token, also the msg.sender of function call in Manager contract
     * @return bytes32 It will return a hash index which is calculated as keccak256(_name, _symbol, _proposer)
     */
    function submitProposal(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint256 _totalSupply,
        uint8 _initialPercentage,
        uint256 _vestingPeriodInWeeks,
        address _vestingBeneficiary,
        address _proposer
    )
    public
    onlyOwner
    returns (bytes32 hashIndex)
    {
        nameDoesNotExist(_name);
        symbolDoesNotExist(_symbol);
        hashIndex = keccak256(abi.encodePacked(_name, _symbol, _proposer));
        rolodex[hashIndex] = Creator({
            token : address(0),
            name : _name,
            symbol : _symbol,
            decimals : _decimals,
            totalSupply : _totalSupply,
            proposer : _proposer,
            vestingBeneficiary : _vestingBeneficiary,
            initialPercentage : _initialPercentage,
            vestingPeriodInWeeks : _vestingPeriodInWeeks,
            approved : false
        });
        emit LogProposalSubmit(_name, _symbol, msg.sender, hashIndex);
    }

    /**
     * @dev Approve token proposal, only called by Owner, which is set to be the Manager contract
     * @param _hashIndex bytes32 Hash Index of Token proposal
     * @param _token address Address of Token which has already been launched
     * @return bool Whether it has completed the function
     * @dev Notice that the only things that have changed from an approved proposal to one that is not
     * is simply the .token and .approved object variables.
     */
    function approveProposal(
        bytes32 _hashIndex,
        address _token
    )
    external
    onlyOwner
    returns (bool)
    {
        Creator memory c = rolodex[_hashIndex];
        nameDoesNotExist(c.name);
        symbolDoesNotExist(c.symbol);
        rolodex[_hashIndex].token = _token;
        rolodex[_hashIndex].approved = true;
        nameToIndex[c.name] = _hashIndex;
        symbolToIndex[c.symbol] = _hashIndex;
        emit LogProposalApprove(c.name, _token);
        return true;
    }

    //Getters

    function getIndexByName(
        string memory _name
        )
    public
    view
    returns (bytes32)
    {
        return nameToIndex[_name];
    }

    function getIndexSymbol(
        string memory _symbol
        )
    public
    view
    returns (bytes32)
    {
        return symbolToIndex[_symbol];
    }

    function getCreatorByIndex(
        bytes32 _hashIndex
    )
    external
    view
    returns (Creator memory)
    {
        return rolodex[_hashIndex];
    }



    //Assertive functions

    function nameDoesNotExist(string memory _name) internal view {
        require(nameToIndex[_name] == 0x0, "Name already exists");
    }

    function symbolDoesNotExist(string memory _name) internal view {
        require(symbolToIndex[_name] == 0x0, "Symbol already exists");
    }
}

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
    }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    // uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return a / b;
    }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}

/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
interface IERC20 {
  function totalSupply() external view returns (uint256);

  function balanceOf(address who) external view returns (uint256);

  function allowance(address owner, address spender)
    external view returns (uint256);

  function transfer(address to, uint256 value) external returns (bool);

  function approve(address spender, uint256 value)
    external returns (bool);

  function transferFrom(address from, address to, uint256 value)
    external returns (bool);

  event Transfer(
    address indexed from,
    address indexed to,
    uint256 value
  );

  event Approval(
    address indexed owner,
    address indexed spender,
    uint256 value
  );
}

    /**
    * @title Standard ERC20 token
    *
    * @dev Implementation of the basic standard token.
    * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
    * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
    */
contract ERC20 is IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowed;

    uint256 private _totalSupply;
    string public name;
    string public symbol;
    uint8 public decimals;

    /**
    * @dev Total number of tokens in existence
    */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    /**
    * @dev Gets the balance of the specified address.
    * @param owner The address to query the the balance of.
    * @return An uint256 representing the amount owned by the passed address.
    */
    function balanceOf(address owner) public view returns (uint256) {
        return _balances[owner];
    }

    /**
    * @dev Function to check the amount of tokens that an owner allowed to a spender.
    * @param owner address The address which owns the funds.
    * @param spender address The address which will spend the funds.
    * @return A uint256 specifying the amount of tokens still available for the spender.
    */
    function allowance(
        address owner,
        address spender
    )
        public
        view
        returns (uint256)
    {
        return _allowed[owner][spender];
    }


    /**
    * @dev Transfer token for a specified address
    * @param to The address to transfer to.
    * @param value The amount to be transferred.
    */
    function transfer(address to, uint256 value) public returns (bool) {
        require(value <= _balances[msg.sender]);
        require(to != address(0));

        _balances[msg.sender] = _balances[msg.sender].sub(value);
        _balances[to] = _balances[to].add(value);
        emit Transfer(msg.sender, to, value);
        return true;
    }

    /**
    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
    * Beware that changing an allowance with this method brings the risk that someone may use both the old
    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
    * @param spender The address which will spend the funds.
    * @param value The amount of tokens to be spent.
    */
    function approve(address spender, uint256 value) public returns (bool) {
        require(spender != address(0));

        _allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    /**
    * @dev Transfer tokens from one address to another
    * @param from address The address which you want to send tokens from
    * @param to address The address which you want to transfer to
    * @param value uint256 the amount of tokens to be transferred
    */
    function transferFrom(
        address from,
        address to,
        uint256 value
    )
        public
        returns (bool)
    {
        require(value <= _balances[from]);
        require(value <= _allowed[from][msg.sender]);
        require(to != address(0));

        _balances[from] = _balances[from].sub(value);
        _balances[to] = _balances[to].add(value);
        _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
        emit Transfer(from, to, value);
        return true;
    }

    /**
    * @dev Increase the amount of tokens that an owner allowed to a spender.
    * approve should be called when allowed_[_spender] == 0. To increment
    * allowed value is better to use this function to avoid 2 calls (and wait until
    * the first transaction is mined)
    * From MonolithDAO Token.sol
    * @param spender The address which will spend the funds.
    * @param addedValue The amount of tokens to increase the allowance by.
    */
    function increaseAllowance(
        address spender,
        uint256 addedValue
    )
        public
        returns (bool)
    {
        require(spender != address(0));

        _allowed[msg.sender][spender] = (
        _allowed[msg.sender][spender].add(addedValue));
        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }

    /**
    * @dev Decrease the amount of tokens that an owner allowed to a spender.
    * approve should be called when allowed_[_spender] == 0. To decrement
    * allowed value is better to use this function to avoid 2 calls (and wait until
    * the first transaction is mined)
    * From MonolithDAO Token.sol
    * @param spender The address which will spend the funds.
    * @param subtractedValue The amount of tokens to decrease the allowance by.
    */
    function decreaseAllowance(
        address spender,
        uint256 subtractedValue
    )
        public
        returns (bool)
    {
        require(spender != address(0));

        _allowed[msg.sender][spender] = (
        _allowed[msg.sender][spender].sub(subtractedValue));
        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }

    /**
    * @dev Internal function that mints an amount of the token and assigns it to
    * an account. This encapsulates the modification of balances such that the
    * proper events are emitted.
    * @param account The account that will receive the created tokens.
    * @param amount The amount that will be created.
    */
    function _mint(address account, uint256 amount) internal {
        require(account != address(0));
        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    /**
    * @dev Internal function that burns an amount of the token of a given
    * account.
    * @param account The account whose tokens will be burnt.
    * @param amount The amount that will be burnt.
    */
    function _burn(address account, uint256 amount) internal {
        require(account != address(0));
        require(amount <= _balances[account]);

        _totalSupply = _totalSupply.sub(amount);
        _balances[account] = _balances[account].sub(amount);
        emit Transfer(account, address(0), amount);
    }

    /**
    * @dev Internal function that burns an amount of the token of a given
    * account, deducting from the sender's allowance for said account. Uses the
    * internal burn function.
    * @param account The account whose tokens will be burnt.
    * @param amount The amount that will be burnt.
    */
    function _burnFrom(address account, uint256 amount) internal {
        require(amount <= _allowed[account][msg.sender]);

        // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
        // this function needs to emit an event with the updated approval.
        _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
        amount);
        _burn(account, amount);
    }

    function burnFrom(address account, uint256 amount) public {
        _burnFrom(account, amount);
    }
}

/**
 * @title Template contract for social money, to be used by TokenFactory
 * @author Jake Goh Si Yuan @ jakegsy, jake@jakegsy.com
 */



contract SocialMoney is ERC20 {

    /**
     * @dev Constructor on SocialMoney
     * @param _name string Name parameter of Token
     * @param _symbol string Symbol parameter of Token
     * @param _decimals uint8 Decimals parameter of Token
     * @param _proportions uint256[3] Parameter that dictates how totalSupply will be divvied up,
                            _proportions[0] = Vesting Beneficiary Initial Supply
                            _proportions[1] = Turing Supply
                            _proportions[2] = Vesting Beneficiary Vesting Supply
     * @param _vestingBeneficiary address Address of the Vesting Beneficiary
     * @param _platformWallet Address of Turing platform wallet
     * @param _tokenVestingInstance address Address of Token Vesting contract
     */
    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint256[3] memory _proportions,
        address _vestingBeneficiary,
        address _platformWallet,
        address _tokenVestingInstance
    )
    public
    {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;

        uint256 totalProportions = _proportions[0].add(_proportions[1]).add(_proportions[2]);

        _mint(_vestingBeneficiary, _proportions[0]);
        _mint(_platformWallet, _proportions[1]);
        _mint(_tokenVestingInstance, _proportions[2]);

        //Sanity check that the totalSupply is exactly where we want it to be
        assert(totalProportions == totalSupply());
    }
}

/**
 * @title TokenVesting contract for linearly vesting tokens to the respective vesting beneficiary
 * @dev This contract receives accepted proposals from the Manager contract, and holds in lieu
 * @dev all the tokens to be vested by the vesting beneficiary. It releases these tokens when called
 * @dev upon in a continuous-like linear fashion.
 * @notice This contract was written with reference to the TokenVesting contract from openZeppelin
 * @notice @ https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/drafts/TokenVesting.sol
 * @author Jake Goh Si Yuan @ jakegsy, jake@jakegsy.com
 */
contract TokenVesting is Ownable{

    using SafeMath for uint256;

    event Released(address indexed token, address vestingBeneficiary, uint256 amount);
    event LogTokenAdded(address indexed token, address vestingBeneficiary, uint256 vestingPeriodInWeeks);

    uint256 constant public WEEKS_IN_SECONDS = 1 * 7 * 24 * 60 * 60;

    struct VestingInfo {
        address vestingBeneficiary;
        uint256 releasedSupply;
        uint256 start;
        uint256 duration;
    }

    mapping(address => VestingInfo) public vestingInfo;

    /**
     * @dev Method to add a token into TokenVesting
     * @param _token address Address of token
     * @param _vestingBeneficiary address Address of vesting beneficiary
     * @param _vestingPeriodInWeeks uint256 Period of vesting, in units of Weeks, to be converted
     * @notice This emits an Event LogTokenAdded which is indexed by the token address
     */
    function addToken
    (
        address _token,
        address _vestingBeneficiary,
        uint256 _vestingPeriodInWeeks
    )
    external
    onlyOwner
    {
        vestingInfo[_token] = VestingInfo({
            vestingBeneficiary : _vestingBeneficiary,
            releasedSupply : 0,
            start : now,
            duration : uint256(_vestingPeriodInWeeks).mul(WEEKS_IN_SECONDS)
        });
        emit LogTokenAdded(_token, _vestingBeneficiary, _vestingPeriodInWeeks);
    }

    /**
     * @dev Method to release any already vested but not yet received tokens
     * @param _token address Address of Token
     * @notice This emits an Event LogTokenAdded which is indexed by the token address
     */

    function release
    (
        address _token
    )
    external
    {
        uint256 unreleased = releaseableAmount(_token);
        require(unreleased > 0);
        vestingInfo[_token].releasedSupply = vestingInfo[_token].releasedSupply.add(unreleased);
        bool success = ERC20(_token).transfer(vestingInfo[_token].vestingBeneficiary, unreleased);
        require(success, "transfer from vesting to beneficiary has to succeed");
        emit Released(_token, vestingInfo[_token].vestingBeneficiary, unreleased);
    }

    /**
     * @dev Method to check the quantity of token that is already vested but not yet received
     * @param _token address Address of Token
     * @return uint256 Quantity of token that is already vested but not yet received
     */
    function releaseableAmount
    (
        address _token
    )
    public
    view
    returns(uint256)
    {
        return vestedAmount(_token).sub(vestingInfo[_token].releasedSupply);
    }

    /**
     * @dev Method to check the quantity of token vested at current block
     * @param _token address Address of Token
     * @return uint256 Quantity of token that is vested at current block
     */

    function vestedAmount
    (
        address _token
    )
    public
    view
    returns(uint256)
    {
        VestingInfo memory info = vestingInfo[_token];
        uint256 currentBalance = ERC20(_token).balanceOf(address(this));
        uint256 totalBalance = currentBalance.add(info.releasedSupply);
        if (now >= info.start.add(info.duration)) {
            return totalBalance;
        } else {
            return totalBalance.mul(now.sub(info.start)).div(info.duration);
        }

    }


    function getVestingInfo
    (
        address _token
    )
    external
    view
    returns(VestingInfo memory)
    {
        return vestingInfo[_token];
    }


}

/**
 * @title TokenFactory contract for creating tokens from token proposals
 * @dev For creating tokens from pre-set parameters. This can be understood as a contract factory.
 * @author Jake Goh Si Yuan @ jakegsy, jake@jakegsy.com
 */
contract TokenFactory is Ownable{

    using SafeMath for uint256;

    uint8 public PLATFORM_PERCENTAGE;
    address public PLATFORM_WALLET;
    TokenVesting public TokenVestingInstance;

    event LogTokenCreated(string name, string symbol, address indexed token, address vestingBeneficiary);
    event LogPlatformPercentageChanged(uint8 oldP, uint8 newP);
    event LogPlatformWalletChanged(address oldPW, address newPW);
    event LogTokenVestingChanged(address oldTV, address newTV);
    event LogTokenFactoryMigrated(address newTokenFactory);

    /**
     * @dev Constructor method
     * @param _tokenVesting address Address of tokenVesting contract. If set to address(0), it will create one instead.
     * @param _turingWallet address Turing Wallet address for sending out proportion of tokens alloted to it.
     */
    constructor(
        address _tokenVesting,
        address _turingWallet,
        uint8 _platformPercentage
    )
    validatePercentage(_platformPercentage)
    validateAddress(_turingWallet)
    public
    {

        require(_turingWallet != address(0), "Turing Wallet address must be non zero");
        PLATFORM_WALLET = _turingWallet;
        PLATFORM_PERCENTAGE = _platformPercentage;
        if (_tokenVesting == address(0)){
            TokenVestingInstance = new TokenVesting();
        }
        else{
            TokenVestingInstance = TokenVesting(_tokenVesting);
        }

    }


    /**
     * @dev Create token method
     * @param _name string Name parameter of Token
     * @param _symbol string Symbol parameter of Token
     * @param _decimals uint8 Decimals parameter of Token, restricted to < 18
     * @param _totalSupply uint256 Total Supply paramter of Token
     * @param _initialPercentage uint8 Initial percentage of total supply that the Vesting Beneficiary will receive from launch, restricted to < 100
     * @param _vestingPeriodInWeeks uint256 Number of weeks that the remaining of total supply will be linearly vested for, restricted to > 1
     * @param _vestingBeneficiary address Address of the Vesting Beneficiary
     * @return address Address of token that has been created by those parameters
     */
    function createToken(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint256 _totalSupply,
        uint8 _initialPercentage,
        uint256 _vestingPeriodInWeeks,
        address _vestingBeneficiary

    )
    public
    onlyOwner
    returns (address token)
    {
        uint256[3] memory proportions = calculateProportions(_totalSupply, _initialPercentage);
        require(proportions[0].add(proportions[1]).add(proportions[2]) == _totalSupply,
        "The supply must be same as the proportion, sanity check.");
        SocialMoney sm = new SocialMoney(
            _name,
            _symbol,
            _decimals,
            proportions,
            _vestingBeneficiary,
            PLATFORM_WALLET,
            address(TokenVestingInstance)
        );
        TokenVestingInstance.addToken(address(sm), _vestingBeneficiary, _vestingPeriodInWeeks);
        token = address(sm);
        emit LogTokenCreated(_name, _symbol, token, _vestingBeneficiary);
    }

    /**
     * @dev Calculate proportions method
     * @param _totalSupply uint256 Total Supply parameter of Token
     * @param _initialPercentage uint8 Initial percentage of total supply that the Vesting Beneficiary will receive from launch, restricted to < 100
     * @dev Calculates supply given to the Turing platform, the Creator and the vesting supply
     * @return bytes32 Hash Index which is composed by the keccak256(name, symbol, msg.sender)
     */
    function calculateProportions(
        uint256 _totalSupply,
        uint8 _initialPercentage
    )
    private
    view
    validateTotalPercentage(_initialPercentage)
    returns (uint256[3] memory proportions)
    {
        proportions[0] = (_totalSupply).mul(_initialPercentage).div(100); //Initial Supply to Creator
        proportions[1] = (_totalSupply).mul(PLATFORM_PERCENTAGE).div(100); //Supply to Platform
        proportions[2] = (_totalSupply).sub(proportions[0]).sub(proportions[1]); // Remaining Supply to vest on
    }



    function setPlatformPercentage(
        uint8 _newPercentage
    )
    external
    validatePercentage(_newPercentage)
    onlyOwner
    {
        emit LogPlatformPercentageChanged(PLATFORM_PERCENTAGE, _newPercentage);
        PLATFORM_PERCENTAGE = _newPercentage;
    }

    function setPlatformWallet(
        address _newPlatformWallet
    )
    external
    validateAddress(_newPlatformWallet)
    onlyOwner
    {
        emit LogPlatformWalletChanged(PLATFORM_WALLET, _newPlatformWallet);
        PLATFORM_WALLET = _newPlatformWallet;
    }

    function migrateTokenFactory(
        address _newTokenFactory
    )
    external
    onlyOwner
    {
        TokenVestingInstance.transferOwnership(_newTokenFactory);
        emit LogTokenFactoryMigrated(_newTokenFactory);
    }

    function setTokenVesting(
        address _newTokenVesting
    )
    external
    onlyOwner
    {
        require(getOwnerStatic(_newTokenVesting) == address(this), "new TokenVesting not owned by TokenFactory");
        emit LogTokenVestingChanged(address(TokenVestingInstance), address(_newTokenVesting));
        TokenVestingInstance = TokenVesting(_newTokenVesting);
    }



    modifier validatePercentage(uint8 percentage){
        require(percentage > 0 && percentage < 100);
        _;
    }

    modifier validateAddress(address addr){
        require(addr != address(0));
        _;
    }

    modifier validateTotalPercentage(uint8 _x) {
        require(PLATFORM_PERCENTAGE + _x < 100);
        _;
    }

    function getTokenVesting() external view returns (address) {
        return address(TokenVestingInstance);
    }
}


/**
 * FOR THE AUDITOR
 * This contract was designed with the idea that it would be owned by
 * another multi-party governance-like contract such as a multi-sig
 * or a yet-to-be researched governance protocol to be placed on top of
 */


/**
 * @title Manager contract for receiving proposals and creating tokens
 * @dev For receiving token proposals and creating said tokens from such parameters.
 * @dev State is separated onto Registry contract
 * @dev To set up a working version of the entire platform, first create TokenFactory,
 * Registry, then transfer ownership to the Manager contract. Ensure as well that TokenVesting is
 * created for a valid TokenFactory. See the truffle
 * test, especially manager_test.js to understand how this would be done offline.
 * @author Jake Goh Si Yuan @jakegsy, jake@jakegsy.com
 */
contract Manager is Ownable {

    using SafeMath for uint256;

    Registry public RegistryInstance;
    TokenFactory public TokenFactoryInstance;

    event LogTokenFactoryChanged(address oldTF, address newTF);
    event LogRegistryChanged(address oldR, address newR);
    event LogManagerMigrated(address indexed newManager);

    /**
     * @dev Constructor on Manager
     * @param _registry address Address of Registry contract
     * @param _tokenFactory address Address of TokenFactory contract
     * @notice It is recommended that all the component contracts be launched before Manager
     */
    constructor(
        address _registry,
        address _tokenFactory
    )
    public
    {
        require(_registry != address(0) && _tokenFactory != address(0));
        TokenFactoryInstance = TokenFactory(_tokenFactory);
        RegistryInstance = Registry(_registry);
    }

    /**
     * @dev Submit Token Proposal
     * @param _name string Name parameter of Token
     * @param _symbol string Symbol parameter of Token
     * @param _decimals uint8 Decimals parameter of Token, restricted to < 18
     * @param _totalSupply uint256 Total Supply paramter of Token
     * @param _initialPercentage uint8 Initial percentage of total supply that the Vesting Beneficiary will receive from launch, restricted to < 100
     * @param _vestingPeriodInWeeks uint256 Number of weeks that the remaining of total supply will be linearly vested for, restricted to > 1
     * @param _vestingBeneficiary address Address of the Vesting Beneficiary
     * @return bytes32 Hash Index which is composed by the keccak256(name, symbol, msg.sender)
     */

    function submitProposal(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint256 _totalSupply,
        uint8 _initialPercentage,
        uint256 _vestingPeriodInWeeks,
        address _vestingBeneficiary
    )
    validatePercentage(_initialPercentage)
    validateDecimals(_decimals)
    validateVestingPeriod(_vestingPeriodInWeeks)
    isInitialized()
    public
    returns (bytes32 hashIndex)
    {
        hashIndex = RegistryInstance.submitProposal(_name,_symbol,_decimals,_totalSupply,
        _initialPercentage, _vestingPeriodInWeeks, _vestingBeneficiary, msg.sender);
    }

    /**
     * @dev Approve Token Proposal
     * @param _hashIndex bytes32 Hash Index of Token Proposal, given by keccak256(name, symbol, msg.sender)
     */
    function approveProposal(
        bytes32 _hashIndex
    )
    isInitialized()
    onlyOwner
    external
    {
        //Registry.Creator memory approvedProposal = RegistryInstance.rolodex(_hashIndex);
        Registry.Creator memory approvedProposal = RegistryInstance.getCreatorByIndex(_hashIndex);
        address ac = TokenFactoryInstance.createToken(
            approvedProposal.name,
            approvedProposal.symbol,
            approvedProposal.decimals,
            approvedProposal.totalSupply,
            approvedProposal.initialPercentage,
            approvedProposal.vestingPeriodInWeeks,
            approvedProposal.vestingBeneficiary
            );
        bool success = RegistryInstance.approveProposal(_hashIndex, ac);
        require(success, "Registry approve proposal has to succeed");
    }


    /*
     * CHANGE PLATFORM VARIABLES AND INSTANCES
     */


    function setPlatformWallet(
        address _newPlatformWallet
    )
    onlyOwner
    isInitialized()
    external
    {
        TokenFactoryInstance.setPlatformWallet(_newPlatformWallet);
    }

    function setTokenFactoryPercentage(
        uint8 _newPercentage
    )
    onlyOwner
    validatePercentage(_newPercentage)
    isInitialized()
    external
    {
        TokenFactoryInstance.setPlatformPercentage(_newPercentage);
    }

    function setTokenFactory(
        address _newTokenFactory
    )
    onlyOwner
    external
    {

        require(getOwnerStatic(_newTokenFactory) == address(this), "new TokenFactory has to be owned by Manager");
        require(getTokenVestingStatic(_newTokenFactory) == address(TokenFactoryInstance.TokenVestingInstance()), "TokenVesting has to be the same");
        TokenFactoryInstance.migrateTokenFactory(_newTokenFactory);
        require(getOwnerStatic(getTokenVestingStatic(_newTokenFactory))== address(_newTokenFactory), "TokenFactory does not own TokenVesting");
        emit LogTokenFactoryChanged(address(TokenFactoryInstance), address(_newTokenFactory));
        TokenFactoryInstance = TokenFactory(_newTokenFactory);
    }

    function setRegistry(
        address _newRegistry
    )

    onlyOwner
    external
    {
        require(getOwnerStatic(_newRegistry) == address(this), "new Registry has to be owned by Manager");
        emit LogRegistryChanged(address(RegistryInstance), _newRegistry);
        RegistryInstance = Registry(_newRegistry);
    }

    function setTokenVesting(
        address _newTokenVesting
    )
    onlyOwner
    external
    {
        TokenFactoryInstance.setTokenVesting(_newTokenVesting);
    }

    function migrateManager(
        address _newManager
    )
    onlyOwner
    isInitialized()
    external
    {
        RegistryInstance.transferOwnership(_newManager);
        TokenFactoryInstance.transferOwnership(_newManager);
        emit LogManagerMigrated(_newManager);
    }

    modifier validatePercentage(uint8 percentage) {
        require(percentage > 0 && percentage < 100, "has to be above 0 and below 100");
        _;
    }

    modifier validateDecimals(uint8 decimals) {
        require(decimals > 0 && decimals < 18, "has to be above 0 and below 18");
        _;
    }

    modifier validateVestingPeriod(uint256 vestingPeriod) {
        require(vestingPeriod > 1, "has to be above 1");
        _;
    }

    modifier isInitialized() {
        require(initialized(), "manager not initialized");
        _;
    }

    function initialized() public view returns (bool){
        return (RegistryInstance.owner() == address(this)) &&
            (TokenFactoryInstance.owner() == address(this)) &&
            (TokenFactoryInstance.TokenVestingInstance().owner() == address(TokenFactoryInstance));
    }



}