pragma solidity ^0.5.1;

library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
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
        return div(a, b, "SafeMath: division by zero");
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

contract Ownable{
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () internal {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), msg.sender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
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

contract ERC20 is Ownable {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    // Addresses that will not be taxed
    struct ExcludeAddress {bool isExist;}

    mapping (address => ExcludeAddress) public excludeSendersAddresses;
    mapping (address => ExcludeAddress) public excludeRecipientsAddresses;

    address serviceWallet;

    uint taxPercent = 4;

    // Token params
    string public constant name = "UniDexGas.com";
    string public constant symbol = "UNDG";
    uint public constant decimals = 18;
    uint constant total = 10000;
    uint256 private _totalSupply;
    // -- Token params

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor() public {
        _mint(msg.sender, total * 10**decimals);
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public returns (bool) {
        _taxTransfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        _taxTransfer(sender, recipient, amount);
        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

     function _taxTransfer(address _sender, address _recipient, uint256 _amount) internal returns (bool) {

       if(!excludeSendersAddresses[_sender].isExist && !excludeRecipientsAddresses[_recipient].isExist){
        uint _taxedAmount = _amount.mul(taxPercent).div(100);
        uint _transferedAmount = _amount.sub(_taxedAmount);

        _transfer(_sender, serviceWallet, _taxedAmount); // tax to serviceWallet
        _transfer(_sender, _recipient, _transferedAmount); // amount - tax to recipient
       } else {
        _transfer(_sender, _recipient, _amount);
       }

        return true;
    }



    // OWNER utils
    function setAddressToExcludeRecipients (address addr) public onlyOwner {
        excludeRecipientsAddresses[addr] = ExcludeAddress({isExist:true});
    }

    function setAddressToExcludeSenders (address addr) public onlyOwner {
        excludeSendersAddresses[addr] = ExcludeAddress({isExist:true});
    }

    function removeAddressFromExcludes (address addr) public onlyOwner {
        excludeSendersAddresses[addr] = ExcludeAddress({isExist:false});
        excludeRecipientsAddresses[addr] = ExcludeAddress({isExist:false});
    }

    function changePercentOfTax(uint percent) public onlyOwner {
        taxPercent = percent;
    }

    function changeServiceWallet(address addr) public onlyOwner {
        serviceWallet = addr;
    }
}


contract Crowdsale {
    address payable owner;
    address me = address(this);
    uint sat = 1e18;

    // *** Config ***
    uint startIco = 1610632800;
    uint stopIco = startIco + 72 hours;
    
    uint percentSell = 35;
    uint manualSaleAmount = 0 * sat;
    
    uint countIfUNDB = 700000; // 1ETH -> 7 UNDG
    uint countIfOther = 650000; // 1 ETH -> 6.5 UNDG
    
    uint maxTokensToOnceHand = 130 * sat; // ~20 ETH for 14.01.2021 
    address undbAddress = 0xd03B6ae96CaE26b743A6207DceE7Cbe60a425c70;
    uint undbMinBalance = 1e17; //0.1 UNDB
    // --- Config ---


    uint priceDecimals = 1e5; // realPrice = Price / priceDecimals
    ERC20 UNDB = ERC20(undbAddress);
    ERC20 token = new ERC20();

    constructor() public {
        owner = msg.sender;
        token.setAddressToExcludeRecipients(owner);
        token.setAddressToExcludeSenders(owner);
        token.changeServiceWallet(owner);
        token.setAddressToExcludeSenders(address(this));
        token.transferOwnership(owner);
        token.transfer(owner, token.totalSupply() / 100 * (100 - percentSell) + manualSaleAmount);
    }

    function() external payable {
        require(startIco < now && now < stopIco, "Period error");
        uint amount = msg.value * getPrice() / priceDecimals;
        require(token.balanceOf(msg.sender) + amount <= maxTokensToOnceHand, "The purchase limit of 130 tokens has been exceeded");
        require(amount <= token.balanceOf(address(this)), "Infucient token balance in ICO");
        token.transfer(msg.sender, amount);
    }


    // OWNER ONLY
    function manualGetETH() public payable {
        require(msg.sender == owner, "You is not owner");
        owner.transfer(address(this).balance);
    }

    function getLeftTokens() public {
        require(msg.sender == owner, "You is not owner");
        token.transfer(owner, token.balanceOf(address(this)));
    }
    //--- OWNER ONLY

    function getPrice() public view returns (uint) {
        return (UNDB.balanceOf(msg.sender) >= undbMinBalance ? countIfUNDB : countIfOther);
    }

    // Utils
    function getStartICO() public view returns (uint) {
        return (startIco - now) / 60;
    }
    function getOwner() public view returns (address) {
        return owner;
    }

    function getStopIco() public view returns(uint){
        return (stopIco - now) / 60;
    }
    function tokenAddress() public view returns (address){
        return address(token);
    }
    function IcoDeposit() public view returns(uint){
        return token.balanceOf(address(this)) / sat;
    }
    function myBalancex10() public view returns(uint){
        return token.balanceOf(msg.sender) / 1e17;
    }
}