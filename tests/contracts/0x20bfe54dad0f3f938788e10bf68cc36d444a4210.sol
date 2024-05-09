pragma solidity >=0.5.0 <0.6.0;


library Strings {
  // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
  function strConcat(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) internal pure returns (string memory) {
      bytes memory _ba = bytes(_a);
      bytes memory _bb = bytes(_b);
      bytes memory _bc = bytes(_c);
      bytes memory _bd = bytes(_d);
      bytes memory _be = bytes(_e);
      string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
      bytes memory babcde = bytes(abcde);
      uint k = 0; 
      for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
      for (uint i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
      for (uint i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
      for (uint i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
      for (uint i = 0; i < _be.length; i++) babcde[k++] = _be[i];
      return string(babcde);
    }

    function strConcat(string memory _a, string memory _b, string memory _c, string memory _d) internal pure returns (string memory) {
        return strConcat(_a, _b, _c, _d, "");
    }

    function strConcat(string memory _a, string memory _b, string memory _c) internal pure returns (string memory) {
        return strConcat(_a, _b, _c, "", "");
    }

    function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
        return strConcat(_a, _b, "", "", "");
    }

    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (_i != 0) {
            bstr[k--] = byte(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    }
}



/**
 * @title SafeMath
 * @dev Unsigned math operations with safety checks that revert on error
 */
library SafeMath {
    /**
    * @dev Multiplies two unsigned integers, reverts on overflow.
    */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b);

        return c;
    }

    /**
    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
    */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

    /**
    * @dev Adds two unsigned integers, reverts on overflow.
    */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);

        return c;
    }

    /**
    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
    * reverts when dividing by zero.
    */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}



/**
 * Utility library of inline functions on addresses
 */
library Address {
    /**
     * Returns whether the target address is a contract
     * @dev This function will return false if invoked during the constructor of a contract,
     * as the code is not actually created until after the constructor finishes.
     * @param account address of the account to check
     * @return whether the target address is a contract
     */
    function isContract(address account) internal view returns (bool) {
        uint256 size;
        // XXX Currently there is no better way to check if there is a contract in an address
        // than to check the size of the code at that address.
        // See https://ethereum.stackexchange.com/a/14016/36603
        // for more details about how this works.
        // TODO Check this again before the Serenity release, because all addresses will be
        // contracts then.
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    function toString(address _addr) internal pure returns(string memory) {
        bytes32 value = bytes32(uint256(_addr));
        bytes memory alphabet = "0123456789abcdef";

        bytes memory str = new bytes(51);
        str[0] = '0';
        str[1] = 'x';
        for (uint i = 0; i < 20; i++) {
            str[2+i*2] = alphabet[uint8(value[i + 12] >> 4)];
            str[3+i*2] = alphabet[uint8(value[i + 12] & 0x0f)];
        }
        return string(str);
    }
}



contract AccessERC20x {
    address private _ceo;
    address private _coo;
    address private _proxy;

    constructor () internal {
        _ceo = msg.sender;
        _coo = msg.sender;
        _proxy = msg.sender;
    }

    function ceoAddress() public view returns (address) {
        return _ceo;
    }

    function cooAddress() public view returns (address) {
        return _coo;
    }

    function proxyAddress() public view returns (address) {
        return _proxy;
    }

    modifier onlyCEO() {
        require(msg.sender == _ceo);
        _;
    }

    modifier onlyCLevel() {
        require(msg.sender == _ceo || msg.sender == _coo);
        _;
    }

    modifier onlyProxy() {
        require(msg.sender == _ceo || msg.sender == _coo || msg.sender == _proxy);
        _;
    }

    function setCEO(address _newCEO) external onlyCEO {
        require(_newCEO != address(0));

        _ceo = _newCEO;
    }

    function setCOO(address _newCOO) external onlyCLevel {
        require(_newCOO != address(0));

        _coo = _newCOO;
    }

    function setProxy(address _newProxy) external onlyCLevel {
        require(_newProxy != address(0));

        _proxy = _newProxy;
    }
}



interface IERC20x {
    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function tokenURI(address owner, uint256 index) external view returns (string memory);

    function approve(uint256 value) external returns (bool);

    function allowance(address owner) external view returns (uint256);

    function transferFrom(address from, address to, uint256 value) external returns (bool);

    function mintToken(address owner, uint256 value) external returns (bool);

    function burnToken(address owner, uint256 value) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, uint256 value);
}



contract ERC20x is IERC20x, AccessERC20x {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => uint256) private _allowed;

    uint256 private _totalSupply;
	string internal _baseuri;

    /**
    * @dev Transfer token for a specified addresses
    * @param from The address to transfer from.
    * @param to The address to transfer to.
    * @param value The amount to be transferred.
    */
    function _transfer(address from, address to, uint256 value) internal {
        require(to != address(0));

        _balances[from] = _balances[from].sub(value);
        _balances[to] = _balances[to].add(value);
        emit Transfer(from, to, value);
    }

    /**
     * @dev Internal function that mints an amount of the token and assigns it to
     * an account. This encapsulates the modification of balances such that the
     * proper events are emitted.
     * @param account The account that will receive the created tokens.
     * @param value The amount that will be created.
     */
    function _mint(address account, uint256 value) internal {
        require(account != address(0));

        _totalSupply = _totalSupply.add(value);
        _balances[account] = _balances[account].add(value);
        emit Transfer(address(0), account, value);
    }

    /**
     * @dev Internal function that burns an amount of the token of a given
     * account.
     * @param account The account whose tokens will be burnt.
     * @param value The amount that will be burnt.
     */
    function _burn(address account, uint256 value) internal {
        require(account != address(0));
		require(_balances[account] >= value);

        _totalSupply = _totalSupply.sub(value);
        _balances[account] = _balances[account].sub(value);
        emit Transfer(account, address(0), value);
    }

    /**
     * @dev Internal function that burns an amount of the token of a given
     * account, deducting from the sender's allowance for said account. Uses the
     * internal burn function.
     * Emits an Approval event (reflecting the reduced allowance).
     * @param account The account whose tokens will be burnt.
     * @param value The amount that will be burnt.
     */
    function _burnFrom(address account, uint256 value) internal {
        _allowed[account] = _allowed[account].sub(value);
        _burn(account, value);
        emit Approval(account, _allowed[account]);
    }


    /**
    * @dev Total number of tokens in existence
    */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    /**
    * @dev Gets the balance of the specified address.
    * @param owner The address to query the balance of.
    * @return An uint256 representing the amount owned by the passed address.
    */
    function balanceOf(address owner) public view returns (uint256) {
        return _balances[owner];
    }

    function baseTokenURI() public view returns (string memory) {
        return _baseuri;
    }

    function tokenURI(address owner, uint256 index) public view returns (string memory) {
	    string memory p1;
	    string memory p2;

		p1 = Strings.strConcat("?wallet=", Address.toString(owner));
		p2 = Strings.strConcat("&index=",  Strings.uint2str(index));

        return Strings.strConcat(baseTokenURI(), Strings.strConcat(p1, p2));
    }

    /**
     * @dev Approve to spend the specified amount of tokens on behalf of msg.sender.
     * @param value The amount of tokens to be spent.
     */
    function approve(uint256 value) public returns (bool) {
		require(value > 0);
		require(_balances[msg.sender] >= _allowed[msg.sender] + value);

        _allowed[msg.sender] = _allowed[msg.sender].add (value);
        emit Approval(msg.sender, value);
        return true;
    }

    /**
     * @dev Function to check the amount of tokens that an owner allowed to a proxy.
     * @param owner address The address which owns the funds.
     * @return A uint256 specifying the amount of tokens still available for the proxy.
     */
    function allowance(address owner) public view returns (uint256) {
        return _allowed[owner];
    }

    /**
     * @dev Transfer tokens from one address to another.
     * Note that while this function emits an Approval event, this is not required as per the specification,
     * and other compliant implementations may not emit the event.
     * @param from address The address which you want to send tokens from
     * @param to address The address which you want to transfer to
     * @param value uint256 the amount of tokens to be transferred
     */
    function transferFrom(address from, address to, uint256 value) public onlyProxy returns (bool) {
		require(value > 0);

        _allowed[from] = _allowed[from].sub(value);
        _transfer(from, to, value);
        emit Approval(from, _allowed[from]);
        return true;
    }

    function mintToken(address owner, uint256 value) public onlyProxy returns (bool) {
		require(value > 0);

        _mint(owner, value);
        return true;
    }

    function mintApprovedToken(address owner, uint256 value) public onlyProxy returns (bool) {
		require(value > 0);

        _mint(owner, value);

        _allowed[owner] = _allowed[owner].add (value);
        emit Approval(owner, value);
        return true;
    }

    function burnToken(address owner, uint256 value) public onlyProxy returns (bool) {
        _burnFrom(owner, value);
        return true;
    }
}



contract MoonDiaToken is ERC20x {
    string public name = "MoonDiaToken"; 
    string public symbol = "DIA";
    uint public decimals = 0;
    uint public INITIAL_SUPPLY = 60000000;

    constructor() public {
	    _baseuri = "https://reg.diana.io/api/token";

        _mint(msg.sender, INITIAL_SUPPLY);
    }

    function setBaseTokenURI(string memory _uri) public onlyCLevel {
        _baseuri = _uri;
    }
}