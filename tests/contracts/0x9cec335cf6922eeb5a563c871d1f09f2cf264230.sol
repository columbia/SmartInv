pragma solidity ^0.5.1;

contract NIOXToken {
    uint256 public peopleCount = 0;
    
    mapping(address => Person ) public people;
    
    uint256 constant stage11 = 1584016200; // ---- Thursday, March 12, 2020 6:00:00 PM GMT+05:30
    uint256 constant stage12 = 1591964999; // ---- Friday, June 12, 2020 5:59:59 PM GMT+05:30
    uint256 constant stage21 = 1591965000; // ---- Friday, June 12, 2020 6:00:00 PM GMT+05:30
    uint256 constant stage22 = 1597235399; // ---- Wednesday, August 12, 2020 5:59:59 PM GMT+05:30
    uint256 constant stage31 = 1597235400; // ---- Wednesday, August 12, 2020 6:00:00 PM GMT+05:30
    uint256 constant stage32 = 1599913799; // ---- Saturday, September 12, 2020 5:59:59 PM GMT+05:30
    
   uint256 constant oneyear = 31556926; // 31556926 secs = 1 YEAR
    
    
    uint256 constant sixmonth = 15778458; // 6 month

    
    uint256 constant addAddressLastDate = 1588163399;// Wednesday, April 29, 2020 5:59:59 PM GMT+05:30
    
   uint256 constant minStakeAmt = 3000000000;

    
    // Status of user's address that he has withdrew NIOX or staked or haven't decided yet
    enum userState {Withdraw, Staked, NotDecided}
    
    // Status of user's address after claiming their tokens
    enum withdrawState {NotWithdraw, PartiallyWithdraw, FullyWithdraw}
    
    //users remaining claimed tokens
    enum remainToken {stage0, stage1, stage2, stage3, stage4}
    
    // Token name
    string public constant name = "Autonio";

    // Token symbol
    string public constant symbol = "NIOX";

	// Token decimals
    uint8 public constant decimals = 4;
    
    // Contract owner will be your Link account
    address public owner;

    address public treasury;

    uint256 public totalSupply;

    mapping (address => mapping (address => uint256)) private allowed;
    mapping (address => uint256) private balances;

    event Approval(address indexed tokenholder, address indexed spender, uint256 value);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event AddedNewUser(address indexed, uint _value);

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }   

    modifier checkUser() {
        require(msg.sender == people[msg.sender]._address);
        _;
    }

    struct Person {
        uint _id;
        address _address;
        uint256 _value;
        uint256 _txHashAddress;
        userState _userState;
        withdrawState _withdrawState;
        remainToken _remainToken;
        uint256 _blocktimestamp;
        uint256 _userStateBlocktimestamp;
    }

    constructor() public {
        owner = msg.sender;

        // Add your wallet address here which will contain your total token supply
        treasury = owner;

        // Set your total token supply (default 1000)
        totalSupply = 3000000000000;

        balances[treasury] = totalSupply;
        emit Transfer(address(0), treasury, totalSupply);
    }

    function () external payable {
        revert();
    }

    function allowance(address _tokenholder, address _spender) public view returns (uint256 remaining) {
        return allowed[_tokenholder][_spender];
    }

    function approve(address _spender, uint256 _value) public returns (bool) {
        require(_spender != address(0));
        require(_spender != msg.sender);

        allowed[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);

        return true;
    }

    function balanceOf(address _tokenholder) public view returns (uint256 balance) {
        return balances[_tokenholder];
    }

    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool success) {
        require(_spender != address(0));
        require(_spender != msg.sender);

        if (allowed[msg.sender][_spender] <= _subtractedValue) {
            allowed[msg.sender][_spender] = 0;
        } else {
            allowed[msg.sender][_spender] = allowed[msg.sender][_spender] - _subtractedValue;
        }

        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);

        return true;
    }

    function increaseApproval(address _spender, uint _addedValue) public returns (bool success) {
        require(_spender != address(0));
        require(_spender != msg.sender);
        require(allowed[msg.sender][_spender] <= allowed[msg.sender][_spender] + _addedValue);

        allowed[msg.sender][_spender] = allowed[msg.sender][_spender] + _addedValue;

        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);

        return true;
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != msg.sender);
        require(_to != address(0));
        require(_to != address(this));
        require(balances[msg.sender] - _value <= balances[msg.sender]);
        require(balances[_to] <= balances[_to] + _value);
        require(_value <= transferableTokens(msg.sender));

        balances[msg.sender] = balances[msg.sender] - _value;
        balances[_to] = balances[_to] + _value;

        emit Transfer(msg.sender, _to, _value);

        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(_from != address(0));
        require(_from != address(this));
        require(_to != _from);
        require(_to != address(0));
        require(_to != address(this));
        require(_value <= transferableTokens(_from));
        require(allowed[_from][msg.sender] - _value <= allowed[_from][msg.sender]);
        require(balances[_from] - _value <= balances[_from]);
        require(balances[_to] <= balances[_to] + _value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
        balances[_from] = balances[_from] - _value;
        balances[_to] = balances[_to] + _value;

        emit Transfer(_from, _to, _value);

        return true;
    }

    function transferOwnership(address _newOwner) public {
        require(msg.sender == owner);
        require(_newOwner != address(0));
        require(_newOwner != address(this));
        require(_newOwner != owner);

        address previousOwner = owner;
        owner = _newOwner;

        emit OwnershipTransferred(previousOwner, _newOwner);
    }

    function transferableTokens(address holder) public view returns (uint256) {
        return balanceOf(holder);
    }
    
    function addAddress(address _useraddress, uint256 _value, uint256 _txHashAddress, userState _userState, withdrawState _withdrawState, remainToken _remainToken) public onlyOwner {
        
        require(people[_useraddress]._address != _useraddress);
        require(block.timestamp <= addAddressLastDate);
        
        incrementCount();
        people[_useraddress] = Person(peopleCount, _useraddress, _value, _txHashAddress, _userState, _withdrawState, _remainToken, block.timestamp, 0);
    }
    
    function incrementCount() internal {
        peopleCount += 1;
    }
    
    function getRemainTokenCount(address  _address) public view returns (uint256 tokens) {
        
        require(_address == people[_address]._address);
        
        if(people[_address]._remainToken == remainToken.stage0) {
            
            return people[_address]._value;
        }
        
        else if(people[_address]._remainToken == remainToken.stage1) {
            
            return people[_address]._value / 100 * 50;
        }
        
        else if(people[_address]._remainToken == remainToken.stage2) {
            
            return people[_address]._value / 100 * 30;
        }
        
        else if(people[_address]._remainToken == remainToken.stage3) {
            
            return people[_address]._value / 100 * 20;
        }
        
        else if(people[_address]._remainToken == remainToken.stage4) {
            
            return 0;
        }
    }
    
    function getWithdrawTokenCount(address  _address) public view returns (uint256 tokens) {
        
        require(_address == people[_address]._address);
        
        if(people[_address]._remainToken == remainToken.stage0) {
            
            return 0;
        }
        
        else if(people[_address]._remainToken == remainToken.stage1) {
            
            return people[_address]._value / 100 * 50;
        }
        
        else if(people[_address]._remainToken == remainToken.stage2) {
            
            return people[_address]._value / 100 * 70;
        }
        
        else if(people[_address]._remainToken == remainToken.stage3) {
            
            return people[_address]._value / 100 * 80;
        }
        
        else if(people[_address]._remainToken == remainToken.stage4) {
            
            return people[_address]._value;
        }
    }
    
    function getUserState(address _address) public view returns (userState){
        
        require(_address == people[_address]._address);
        
        return people[_address]._userState;
    }
    
    function withdrawOrStake(userState _userStates) public returns (bool) {
        
        require(msg.sender == people[msg.sender]._address);
        require(people[msg.sender]._userState == userState.NotDecided);
        require(people[msg.sender]._userStateBlocktimestamp == 0);
        
        if(people[msg.sender]._userState == userState.NotDecided && _userStates == userState.Withdraw){
            people[msg.sender]._userState = userState.Withdraw;
            people[msg.sender]._userStateBlocktimestamp = block.timestamp;
            return true;
        }
        else if(people[msg.sender]._userState == userState.NotDecided && _userStates == userState.Staked && people[msg.sender]._value >= minStakeAmt ){
            people[msg.sender]._userState = userState.Staked;
            people[msg.sender]._userStateBlocktimestamp = block.timestamp;
            return true;
        }
        else {
            return false;
        }
        
    }
    
    function changeStakeToWithdraw() public checkUser returns (bool) {
        
        require(msg.sender == people[msg.sender]._address);
        require(people[msg.sender]._userState == userState.Staked);
        require(people[msg.sender]._userStateBlocktimestamp != 0);
        require(block.timestamp >= (people[msg.sender]._userStateBlocktimestamp + sixmonth));
        
        if(people[msg.sender]._userState == userState.Staked){
            people[msg.sender]._userState = userState.Withdraw;
            // people[msg.sender]._blocktimestamp = block.timestamp;
            return true;
        }
        
    }
    
    function withdrawToken() public checkUser returns (bool){
        
        require(msg.sender == people[msg.sender]._address);
        require(people[msg.sender]._userState == userState.Withdraw);
        require(people[msg.sender]._userStateBlocktimestamp != 0);
        require(people[msg.sender]._withdrawState == withdrawState.NotWithdraw);
        require(people[msg.sender]._remainToken == remainToken.stage0);
        
        if (block.timestamp >= stage11 && block.timestamp <= stage12 ){
            
            uint256 clamimTkn = people[msg.sender]._value / 100 * 50; 
             require(owner != msg.sender);
             require(balances[owner] - clamimTkn <= balances[owner]);
             require(balances[msg.sender] <= balances[msg.sender] + clamimTkn);
             require(clamimTkn <= transferableTokens(owner));
        
            balances[owner] = balances[owner] - clamimTkn;
            balances[msg.sender] = balances[msg.sender] + clamimTkn;
    
            emit Transfer(owner, msg.sender, clamimTkn);
            
            people[msg.sender]._withdrawState = withdrawState.PartiallyWithdraw;
            people[msg.sender]._remainToken = remainToken.stage1;
            people[msg.sender]._blocktimestamp = block.timestamp;
            
            return true;
        }
        else if (block.timestamp > stage21 && block.timestamp <= stage22 ){
            
            uint256 clamimTkn = people[msg.sender]._value / 100 * 70; 
             require(owner != msg.sender);
             require(balances[owner] - clamimTkn <= balances[owner]);
             require(balances[msg.sender] <= balances[msg.sender] + clamimTkn);
             require(clamimTkn <= transferableTokens(owner));
        
            balances[owner] = balances[owner] - clamimTkn;
            balances[msg.sender] = balances[msg.sender] + clamimTkn;
    
            emit Transfer(owner, msg.sender, clamimTkn);
            
            people[msg.sender]._withdrawState = withdrawState.PartiallyWithdraw;
            people[msg.sender]._remainToken = remainToken.stage2;
            people[msg.sender]._blocktimestamp = block.timestamp;
            
            return true;
        }
        else if (block.timestamp > stage31 && block.timestamp <= stage32 ){
            
            uint256 clamimTkn = people[msg.sender]._value / 100 * 80; 
             require(owner != msg.sender);
             require(balances[owner] - clamimTkn <= balances[owner]);
             require(balances[msg.sender] <= balances[msg.sender] + clamimTkn);
             require(clamimTkn <= transferableTokens(owner));
        
            balances[owner] = balances[owner] - clamimTkn;
            balances[msg.sender] = balances[msg.sender] + clamimTkn;
    
            emit Transfer(owner, msg.sender, clamimTkn);
            
            people[msg.sender]._withdrawState = withdrawState.PartiallyWithdraw;
            people[msg.sender]._remainToken = remainToken.stage3;
            people[msg.sender]._blocktimestamp = block.timestamp;
            
            return true;
        }
        else if (block.timestamp > stage32){
            
            uint256 clamimTkn = people[msg.sender]._value; 
             require(owner != msg.sender);
             require(balances[owner] - clamimTkn <= balances[owner]);
             require(balances[msg.sender] <= balances[msg.sender] + clamimTkn);
             require(clamimTkn <= transferableTokens(owner));
        
            balances[owner] = balances[owner] - clamimTkn;
            balances[msg.sender] = balances[msg.sender] + clamimTkn;
    
            emit Transfer(owner, msg.sender, clamimTkn);
            
            people[msg.sender]._withdrawState = withdrawState.FullyWithdraw;
            people[msg.sender]._remainToken = remainToken.stage4;
            people[msg.sender]._blocktimestamp = block.timestamp;
            
            return true;
        }
    }
    
    function withdrawRemainPenaltyToken() public checkUser returns (bool){
        
        require(msg.sender == people[msg.sender]._address);
        require(people[msg.sender]._userState == userState.Withdraw);
        require(people[msg.sender]._withdrawState == withdrawState.PartiallyWithdraw);
        require(block.timestamp >= people[msg.sender]._blocktimestamp + oneyear);
        
        if (people[msg.sender]._remainToken == remainToken.stage1){
            
            uint256 clamimTkn = people[msg.sender]._value / 100 * 50; 
             require(owner != msg.sender);
             require(balances[owner] - clamimTkn <= balances[owner]);
             require(balances[msg.sender] <= balances[msg.sender] + clamimTkn);
             require(clamimTkn <= transferableTokens(owner));
        
            balances[owner] = balances[owner] - clamimTkn;
            balances[msg.sender] = balances[msg.sender] + clamimTkn;
    
            emit Transfer(owner, msg.sender, clamimTkn);
            people[msg.sender]._withdrawState = withdrawState.FullyWithdraw;
            people[msg.sender]._remainToken = remainToken.stage4;
            
            return true;
        }
        else if (people[msg.sender]._remainToken == remainToken.stage2){
            
            uint256 clamimTkn = people[msg.sender]._value / 100 * 30; 
             require(owner != msg.sender);
             require(balances[owner] - clamimTkn <= balances[owner]);
             require(balances[msg.sender] <= balances[msg.sender] + clamimTkn);
             require(clamimTkn <= transferableTokens(owner));
        
            balances[owner] = balances[owner] - clamimTkn;
            balances[msg.sender] = balances[msg.sender] + clamimTkn;
    
            emit Transfer(owner, msg.sender, clamimTkn);
            
            people[msg.sender]._withdrawState = withdrawState.FullyWithdraw;
            people[msg.sender]._remainToken = remainToken.stage4;
            
            return true;
        }
        else if (people[msg.sender]._remainToken == remainToken.stage3){
            
            uint256 clamimTkn = people[msg.sender]._value / 100 * 20; 
             require(owner != msg.sender);
             require(balances[owner] - clamimTkn <= balances[owner]);
             require(balances[msg.sender] <= balances[msg.sender] + clamimTkn);
             require(clamimTkn <= transferableTokens(owner));
        
            balances[owner] = balances[owner] - clamimTkn;
            balances[msg.sender] = balances[msg.sender] + clamimTkn;
    
            emit Transfer(owner, msg.sender, clamimTkn);
            
            people[msg.sender]._withdrawState = withdrawState.FullyWithdraw;
            people[msg.sender]._remainToken = remainToken.stage4;
            
            return true;
        }
    }
    
    function remainPenaltyClaimDate(address  _address) public view returns (uint256 date) {
        
         require(_address == people[_address]._address);
         require(people[_address]._withdrawState == withdrawState.PartiallyWithdraw);
         require(people[_address]._userState == userState.Withdraw);
         
         return people[_address]._blocktimestamp + oneyear;
        
    }
}