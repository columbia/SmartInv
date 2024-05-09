// SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

interface IZ3 {
    function setFeeExempt(address _addr, bool _value) external;

    function setFeeReceivers(address _marketingReceiver, address _treasuryReceiver) external;

    function setFees(uint256 _liquidityFee, uint256 _marketingFee, uint256 _treasuryFee) external;

    function rescueToken(address tokenAddress, uint256 tokens, address destination) external returns (bool success);

    function setNextRebase(uint256 _nextRebase) external;

    function transferOwnership(address newOwner) external;

    function manualRebase() external;

    function nextRebase() external view returns (uint256);

    function shouldRebase() external view returns (bool);

    function rewardYield() external view returns (uint256);

    function rewardYieldDenominator() external view returns (uint256);

    function getSupplyDeltaOnNextRebase() external view returns (uint256);

    function totalSupply() external view returns (uint256);

    function decimals() external view returns (uint8);
}

contract Ownable {
    address private _owner;

    event OwnershipRenounced(address indexed previousOwner);

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        _owner = msg.sender;
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(msg.sender == _owner, "Not owner");
        _;
    }

    function renounceOwnership() public onlyOwner {
        emit OwnershipRenounced(_owner);
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0));
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract Z3Owner is Ownable {
    mapping (address => bool) public isAuthorized;
    IZ3 public immutable z3Token;

    constructor(address _z3Token){
        isAuthorized[msg.sender] = true;
        isAuthorized[0x14d064f5BceA5808660Dd39868172A7031B38442] = true;
        z3Token = IZ3(_z3Token);
    }

    modifier onlyAuthorized() {
        require(isAuthorized[msg.sender], "Not Authorized");
        _;
    }

    function setAuthorized(address _addr, bool _authorized) external onlyOwner {
        isAuthorized[_addr] = _authorized;
    }

    function setFeeExempt(address _addr, bool _value) external onlyOwner {
        z3Token.setFeeExempt(_addr,_value);
    }

    function setFeeReceivers(address _marketingReceiver, address _treasuryReceiver) external onlyOwner {
        z3Token.setFeeReceivers(_marketingReceiver, _treasuryReceiver);
    }

    function setFees(uint256 _liquidityFee, uint256 _marketingFee, uint256 _treasuryFee) external onlyOwner {
        z3Token.setFees(_liquidityFee, _marketingFee, _treasuryFee);
    }

    function rescueToken(address tokenAddress, uint256 tokens, address destination) external onlyOwner returns (bool success) {
        success = z3Token.rescueToken(tokenAddress, tokens, destination);
    }

    function setNextRebase(uint256 _nextRebase) external onlyAuthorized {
        z3Token.setNextRebase(_nextRebase);
    }

    function manualRebase() external {
        z3Token.manualRebase();
    }

    function transferZ3Ownership(address newOwner) external onlyOwner {
        z3Token.transferOwnership(newOwner);
    }

    function nextRebase() external view returns (uint256){
        return z3Token.nextRebase();
    }

    function rewardYieldDenominator() external view returns (uint256){
        return z3Token.rewardYieldDenominator();
    }

    function rewardYield() external view returns (uint256){
        return z3Token.rewardYield();
    }

    function shouldRebase() external view returns (bool){
        return z3Token.shouldRebase();
    }

    function getSupplyDeltaOnNextRebase() external view returns (uint256){
        return z3Token.getSupplyDeltaOnNextRebase();
    }

    function totalSupply() external view returns (uint256) {
        return z3Token.totalSupply();
    }

    function decimals() external view returns (uint8) {
        return z3Token.decimals();
    }
}