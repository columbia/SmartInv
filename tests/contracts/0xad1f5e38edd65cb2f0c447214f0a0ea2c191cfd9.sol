/*
 * A highly limited supply utility token of Gear Protocol
 * 
 *  Official Website: 
 *  https://www.GearProtocol.com
 */



pragma solidity ^0.4.25;

interface IERC20 
{
    function totalSupply() external view returns (uint256);
    function balanceOf(address who) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
    function approve(address spender, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface ApproveAndCallFallBack 
{
    function receiveApproval(address from, uint256 tokens, address token, bytes data) external;
}


library SafeMath 
{
    function mul(uint256 a, uint256 b) internal pure returns (uint256) 
    {
        if (a == 0) 
        {
            return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }
    
    function div(uint256 a, uint256 b) internal pure returns (uint256) 
    {
        uint256 c = a / b;
        return c;
    }
    
    function sub(uint256 a, uint256 b) internal pure returns (uint256) 
    {
        assert(b <= a);
        return a - b;
    }
    
    function add(uint256 a, uint256 b) internal pure returns (uint256) 
    {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
    
    function ceil(uint256 a, uint256 m) internal pure returns (uint256) 
    {
        uint256 c = add(a,m);
        uint256 d = sub(c,1);
        return mul(div(d,m),m);
    }
}

contract ERC20Detailed is IERC20 
{
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    
    constructor(string memory name, string memory symbol, uint8 decimals) public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
    }
    
    function name() public view returns(string memory) {
        return _name;
    }
    
    function symbol() public view returns(string memory) {
        return _symbol;
    }
    
    function decimals() public view returns(uint8) {
        return _decimals;
    }
}

contract GearAutomatic is ERC20Detailed 
{
    using SafeMath for uint256;
    
    mapping (address => uint256) private balances;
    mapping (address => mapping (address => uint256)) private allowed;
    
    string constant tokenName = "GearAutomatic";
    string constant tokenSymbol = "AUTO"; 
    uint8  constant tokenDecimals = 18;
    uint256 _totalSupply = 0;
  
    address public contractOwner;

    uint256 public fullUnitsFarmed_total = 0;
    uint256 public totalFarmers = 0;
    mapping (address => bool) public isFarming;

    uint256 _totalRewardsPerUnit = 0;
    mapping (address => uint256) private _totalRewardsPerUnit_positions;
    mapping (address => uint256) private _savedRewards;
    
    //these addresses won't be affected by network fee,ie liquidity pools
    mapping(address => bool) public whitelistFrom;
    mapping(address => bool) public whitelistTo;
    event WhitelistFrom(address _addr, bool _whitelisted);
    event WhitelistTo(address _addr, bool _whitelisted);
    
    constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) 
    {
        contractOwner = msg.sender;
        _supply(msg.sender, 10000*(10**uint256(tokenDecimals)));
    }
    
    modifier onlyOwner() {
        require(msg.sender == contractOwner, "only owner");
        _;
    }
    
    function totalSupply() public view returns (uint256) 
    {
        return _totalSupply;
    }
    
    function balanceOf(address owner) public view returns (uint256) 
    {
        return balances[owner];
    }
    
    function fullUnitsFarmed(address owner) external view returns (uint256) 
    {
        return isFarming[owner] ? toFullUnits(balances[owner]) : 0;
    }
    
    function toFullUnits(uint256 valueWithDecimals) public pure returns (uint256) 
    {
        return valueWithDecimals.div(10**uint256(tokenDecimals));
    }
    
    function allowance(address owner, address spender) public view returns (uint256) 
    {
        return allowed[owner][spender];
    }
    
    function transfer(address to, uint256 value) public returns (bool) 
    {
        _executeTransfer(msg.sender, to, value);
        return true;
    }
    
    function multiTransfer(address[] memory receivers, uint256[] memory values) public
    {
        require(receivers.length == values.length);
        for(uint256 i = 0; i < receivers.length; i++)
            _executeTransfer(msg.sender, receivers[i], values[i]);
    }
    
    function transferFrom(address from, address to, uint256 value) public returns (bool) 
    {
        require(value <= allowed[from][msg.sender]);
        allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
        _executeTransfer(from, to, value);
        return true;
    }
    
    function approve(address spender, uint256 value) public returns (bool) 
    {
        require(spender != address(0));
        allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }
    
    
    function approveAndCall(address spender, uint256 tokens, bytes data) external returns (bool) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
        return true;
    }
    
    
    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) 
    {
        require(spender != address(0));
        allowed[msg.sender][spender] = (allowed[msg.sender][spender].add(addedValue));
        emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
        return true;
    }
    
    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) 
    {
        require(spender != address(0));
        allowed[msg.sender][spender] = (allowed[msg.sender][spender].sub(subtractedValue));
        emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
        return true;
    }
    
    function _supply(address account, uint256 value) internal onlyOwner
    {
        require(value != 0);
        
        uint256 initalBalance = balances[account];
        uint256 newBalance = initalBalance.add(value);
        
        balances[account] = newBalance;
        _totalSupply = _totalSupply.add(value);
        
        emit Transfer(address(0), account, value);
    }
    
    function burn(uint256 value) external 
    {
        _burn(msg.sender, value);
    }
    

    function _burn(address account, uint256 value) internal 
    {
        require(value != 0);
        require(value <= balances[account]);
        
        uint256 initalBalance = balances[account];
        uint256 newBalance = initalBalance.sub(value);
        
        balances[account] = newBalance;
        _totalSupply = _totalSupply.sub(value);
        
        //update full units farmed
        if(isFarming[account])
        {
            uint256 fus_total = fullUnitsFarmed_total;
            fus_total = fus_total.sub(toFullUnits(initalBalance));
            fus_total = fus_total.add(toFullUnits(newBalance));
            fullUnitsFarmed_total = fus_total;
        }
        
        emit Transfer(account, address(0), value);
    }
    
    /*
    *   transfer incurring a fee of 5%
    *   the receiver gets 95% of the sent value
    *   5% is distributed to AUTO farming pool
    */
    function _executeTransfer(address from, address to, uint256 value) private
    {
        require(value <= balances[from]);
        require(to != address(0) && to != from);
        require(to != address(this));
        
        
        //Update sender and receivers rewards - changing balances will change rewards shares
        updateRewardsFor(from);
        updateRewardsFor(to);
        
        uint256 fivePercent = 0;
        
        if(!whitelistFrom[from] && !whitelistTo[to])
        {
            fivePercent = value.mul(5).div(100);
            
            
            //set a minimum  rate to prevent no-fee-txs due to precision loss
            if(fivePercent == 0 && value > 0)
                fivePercent = 1;
        }
            
        uint256 initalBalance_from = balances[from];
        balances[from] = initalBalance_from.sub(value);
        
        value = value.sub(fivePercent);
        
        uint256 initalBalance_to = balances[to];
        balances[to] = initalBalance_to.add(value);
        
        emit Transfer(from, to, value);
         
        //update full units farmed
        uint256 fus_total = fullUnitsFarmed_total;
        if(isFarming[from])
        {
            fus_total = fus_total.sub(toFullUnits(initalBalance_from));
            fus_total = fus_total.add(toFullUnits(balances[from]));
        }
        if(isFarming[to])
        {
            fus_total = fus_total.sub(toFullUnits(initalBalance_to));
            fus_total = fus_total.add(toFullUnits(balances[to]));
        }
        
        if(isFarming[from] && balances[from] < 1)
        {
             updateRewardsFor(from);
             isFarming[from] = false;
             fullUnitsFarmed_total = fullUnitsFarmed_total.sub(toFullUnits(balances[from]));
             totalFarmers = totalFarmers.sub(1); 
        }
        
        
        fullUnitsFarmed_total = fus_total;
        
        if(fus_total > 0)
        {
            uint256 farmingRewards = fivePercent;
            //split up to rewards per unit in farm
            uint256 rewardsPerUnit = farmingRewards.div(fus_total);
            //apply reward
            _totalRewardsPerUnit = _totalRewardsPerUnit.add(rewardsPerUnit);
            balances[address(this)] = balances[address(this)].add(farmingRewards);
            if(farmingRewards > 0)
                emit Transfer(msg.sender, address(this), farmingRewards);
        }
        
    }
    
    //catch up with the current total harvest rewards. This needs to be done before an addresses balance is changed
    function updateRewardsFor(address farmer) private
    {
        _savedRewards[farmer] = viewHarvest(farmer);
        _totalRewardsPerUnit_positions[farmer] = _totalRewardsPerUnit;
    }
    
    //get all harvest rewards that have not been claimed yet
    function viewHarvest(address farmer) public view returns (uint256)
    {
        if(!isFarming[farmer])
            return _savedRewards[farmer];
        uint256 newRewardsPerUnit = _totalRewardsPerUnit.sub(_totalRewardsPerUnit_positions[farmer]);
        
        uint256 newRewards = newRewardsPerUnit.mul(toFullUnits(balances[farmer]));
        return _savedRewards[farmer].add(newRewards);
    }
    
    //pay out unclaimed harvest rewards
    function harvest() public
    {
        updateRewardsFor(msg.sender);
        uint256 rewards = _savedRewards[msg.sender];
        require(rewards > 0 && rewards <= balances[address(this)]);
        
        _savedRewards[msg.sender] = 0;
        
         uint256 fivePercent = 0;
         uint256 reward = 0;
        
        fivePercent = rewards.mul(5).div(100);
        
       //set a minimum  rate to prevent no harvest-fee-txs due to precision loss
            if(fivePercent == 0 && rewards > 0) {
                fivePercent = 1;
        }
        
        reward = rewards.sub(fivePercent);
        
        uint256 initalBalance_farmer = balances[msg.sender];
        uint256 newBalance_farmer = initalBalance_farmer.add(reward);
        
        //update full units farmed
        if(isFarming[msg.sender])
        {
            uint256 fus_total = fullUnitsFarmed_total;
            fus_total = fus_total.sub(toFullUnits(initalBalance_farmer));
            fus_total = fus_total.add(toFullUnits(newBalance_farmer));
            fullUnitsFarmed_total = fus_total;
        }
        
        //transfer
        balances[address(this)] = balances[address(this)].sub(rewards);
        balances[msg.sender] = newBalance_farmer;
        balances[contractOwner] = balances[contractOwner].add(fivePercent);
        emit Transfer(address(this), msg.sender, rewards);
        emit Transfer(address(this), contractOwner, fivePercent);
    }
    
    function enableFarming() public { _enableFarming(msg.sender);  }
    
    function disableFarming() public { _disableFarming(msg.sender); }
    
    function enableFarmingFor(address farmer) public onlyOwner { _enableFarming(farmer); }
    
    function disableFarmingFor(address farmer) public onlyOwner { _disableFarming(farmer); }
    
    //enable farming for target address
    function _enableFarming(address farmer) private
    {
        require(!isFarming[farmer]);
        updateRewardsFor(farmer);
        isFarming[farmer] = true;
        fullUnitsFarmed_total = fullUnitsFarmed_total.add(toFullUnits(balances[farmer]));
        totalFarmers = totalFarmers.add(1);
    }
    
    //disable farming for target address
    function _disableFarming(address farmer) private
    {
        require(isFarming[farmer]);
        updateRewardsFor(farmer);
        isFarming[farmer] = false;
        fullUnitsFarmed_total = fullUnitsFarmed_total.sub(toFullUnits(balances[farmer]));
        totalFarmers = totalFarmers.sub(1);
    }
    
    //withdraw tokens that were sent to this contract by accident
    function withdrawERC20Tokens(address tokenAddress, uint256 amount) public onlyOwner
    {
        require(tokenAddress != address(this));
        IERC20(tokenAddress).transfer(msg.sender, amount);
    }
    
    //no fees if receiver is whitelisted
    function setWhitelistedTo(address _addr, bool _whitelisted) external onlyOwner {
        emit WhitelistTo(_addr, _whitelisted);
        whitelistTo[_addr] = _whitelisted;
    }

    //no fees if sender is whitelisted
    function setWhitelistedFrom(address _addr, bool _whitelisted) external onlyOwner {
        emit WhitelistFrom(_addr, _whitelisted);
        whitelistFrom[_addr] = _whitelisted;
    }
    
}