/**
 *Submitted for verification at Etherscan.io on 2020-11-03
*/
pragma experimental ABIEncoderV2;
pragma solidity ^0.6.0;

// SPDX-License-Identifier: UNLICENSED
/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

/**
 * @title SafeMath
 * @dev Unsigned math operations with safety checks that revert on error.
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

contract mr_contract {
    using SafeMath for uint256;
    address public MR;
    address public manager;
    address public FeeAddr;
    mapping(address => uint256) private balances;
    bytes4 private constant SELECTOR = bytes4(keccak256(bytes('transfer(address,uint256)')));

    struct rechangeRecords{
        address rec_addr;
        uint256 rec_value;
        uint256 rec_time;
    }
    mapping(address => rechangeRecords[]) userRec;
    
    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);
    
    constructor(address _mr,address _fee) public {
        MR = _mr;
        FeeAddr = _fee;
        manager = msg.sender;
    }
    
    function deposit(uint256 value) external {
        require(msg.sender != address(0) && value > 0);
        IERC20(MR).transferFrom(msg.sender,address(this),value);
        balances[msg.sender] = balances[msg.sender].add(value);
        userRec[msg.sender].push(rechangeRecords(msg.sender,value,block.timestamp));
        emit Deposit(msg.sender,value);
    }

    function withdraw() external {
        require(msg.sender != address(0) && balances[msg.sender] > 0);
        uint256 amount = balances[msg.sender];
        uint256 contractBalance = IERC20(MR).balanceOf(address(this));
		if (contractBalance < amount) {
			amount = contractBalance;
		}

        uint256 fee = amount.div(10);
		_safeTransfer(MR,FeeAddr,fee);
        _safeTransfer(MR,msg.sender,amount.sub(fee));
        
        balances[msg.sender] = balances[msg.sender].sub(amount);
        emit Withdraw(msg.sender,amount.sub(fee));
    }
    
    function getUserRec(address addr) view external returns(rechangeRecords[] memory){
        return userRec[addr];
    }
    
    function getUserBalances(address addr) view public returns(uint256){
        return balances[addr];
    }
    
    function getPoolTotal()view public returns(uint256){
        return IERC20(MR).balanceOf(address(this));
    }
    
    function emergencyTreatment(address addr,uint256 value) public onlyOwner{
        require(addr != address(0) && IERC20(MR).balanceOf(address(this)) >= value);
        _safeTransfer(MR,addr,value);
    }
    
    function transferOwner(address newOwner)public onlyOwner{
        require(newOwner != address(0));
        manager = newOwner;
    }
    
    function _safeTransfer(address _token, address to, uint value) private {
        (bool success, bytes memory data) = _token.call(abi.encodeWithSelector(SELECTOR, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'UniswapV2: TRANSFER_FAILED');
    }
    
    modifier onlyOwner {
        require(manager == msg.sender);
        _;
    }
    
}