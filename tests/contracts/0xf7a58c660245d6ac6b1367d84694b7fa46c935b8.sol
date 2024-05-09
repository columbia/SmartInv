pragma solidity ^0.5.1;

contract NIOX {
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
   uint256 constant addAddressLastDate = 1609404905;// DEc 31, 2020 5:59:59 PM GMT+05:30
   uint256 constant minStakeAmt = 3000000000;

    
    // Status of user's address that he has withdrew NIOX or staked or haven't decided yet
    enum userState {Withdraw, Staked, NotDecided}
    
    // Status of user's address after claiming their tokens
    enum withdrawState {NotWithdraw, PartiallyWithdraw, FullyWithdraw}
    
    //users remaining claimed tokens
    enum remainToken {stage0, stage1, stage2, stage3, stage4}
    
    // Token name
    string public constant name = "AutonioK";

    // Token symbol
    string public constant symbol = "NIOXK";

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
contract Token {
    function totalSupply() external view returns (uint256 _totalSupply){}
    function balanceOf(address _owner) external view returns (uint256 _balance){}
    function transfer(address _to, uint256 _value) external returns (bool _success){}
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool _success){}
    function approve(address _spender, uint256 _value) external returns (bool _success){}
    function allowance(address _owner, address _spender) external view returns (uint256 _remaining){}

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

contract Staking {
    
    uint256 public peopleCount = 0;
    
    mapping(address => Person ) public people;
    
    mapping(address => BlockUser ) public blockpeople;
    
    // for new users
    uint256 constant stage11 = 1597708801; // ---- Tuesday, August 18, 2020 12:00:01 AM
    uint256 constant stage12 = 1605657600; // ---- Wednesday, November 18, 2020 12:00:00 AM
    uint256 constant stage21 = 1605657601; // ---- Wednesday, November 18, 2020 12:00:01 AM
    uint256 constant stage22 = 1610928000; // ---- Monday, January 18, 2021 12:00:00 AM
    uint256 constant stage31 = 1610928001; // ---- Monday, January 18, 2021 12:00:01 AM
    uint256 constant stage32 = 1613606400; // ---- Thursday, February 18, 2021 12:00:00 AM
    
    
    //for old users
    uint256 constant ostage11 = 1584016200; // ---- Thursday, March 12, 2020 6:00:00 PM GMT+05:30
    uint256 constant ostage12 = 1591964999; // ---- Friday, June 12, 2020 5:59:59 PM GMT+05:30
    uint256 constant ostage21 = 1591965000; // ---- Friday, June 12, 2020 6:00:00 PM GMT+05:30
    uint256 constant ostage22 = 1597235399; // ---- Wednesday, August 12, 2020 5:59:59 PM GMT+05:30
    uint256 constant ostage31 = 1597235400; // ---- Wednesday, August 12, 2020 6:00:00 PM GMT+05:30
    uint256 constant ostage32 = 1599913799; // ---- Saturday, September 12, 2020 5:59:59 PM GMT+05:30
    
    uint256 constant oneyear = 31556926; // 31556926 secs = 1 YEAR
    
    
    uint256 constant sixmonth = 15778458; // 6 month
    uint256 constant day21 = 1814400; // 21 days /3 weeks;
    
    uint256 constant minStakeAmt = 3000000000;

    
    // Status of user's address that he has withdrew NIOX or staked or haven't decided yet
    enum userState {Withdraw, Staked, NotDecided}
    userState UserState;
    
    // Status of user's address after claiming their tokens
    enum withdrawState {NotWithdraw, PartiallyWithdraw, FullyWithdraw}
    
    //users remaining claimed tokens
    enum remainToken {stage0, stage1, stage2, stage3, stage4}
    

    NIOX token;
    
    NIOX Ntoken;
    
    address public owner;

    mapping (address => mapping (address => uint256)) private allowed;
    mapping (address => uint256) private balances;

    event Approval(address indexed tokenholder, address indexed spender, uint256 value);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event AddedNewUser(address indexed, uint _value);

    modifier onlyOwner() {
        require(msg.sender == owner,"You are not Authorize to call this function");
        _;
    }   

    modifier checkUser() {
        require(msg.sender == people[msg.sender]._address);
        _;
    }

    struct stakeData{
        uint256 id;
        uint256 amt; 
        uint256 _stakeTimeStamp;
        uint256 _withdrawTimestamp;
        uint256 _withdrawOrNotyet;
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
        uint256 _stakeCounter; 
        uint256 _withdrawTimestamp;
        mapping(uint256 => stakeData) stakeStruct; 
    }
    
    struct BlockUser {
        address _address;
    }

   
    constructor() public {
        owner = msg.sender;
    
        token = NIOX(0x9cEc335cf6922eeb5A563C871D1F09f2cf264230); // old niox token
        
        Ntoken = NIOX(0xc813EA5e3b48BEbeedb796ab42A30C5599b01740); // new niox token
    }

    function () external payable {
        revert();
    }

    function addAddressExisting() public {
        
        require(people[msg.sender]._address != msg.sender,"You are already added");
        require(getPeopleAddress(msg.sender) == msg.sender,"You are not addded to previous contract");
        
        incrementCount();
        
        (,address addres,uint256 value,uint256 txhash,,,,uint256 bts,uint256 usbts) = token.people(msg.sender);
        userState us = getUserStateData(msg.sender);
        withdrawState ws = getWithdrawStateData(msg.sender);
        remainToken rt = getRemainTokenData(msg.sender);
       
        people[msg.sender] = Person(peopleCount, addres, value, txhash,us,ws,rt,bts,usbts,0,0);
        
        if(us == Staking.userState.Staked){
            Person storage t =  people[msg.sender];
            people[msg.sender]._stakeCounter += 1;
            t.stakeStruct[people[msg.sender]._stakeCounter] = stakeData(people[msg.sender]._stakeCounter ,value,usbts,0,0);
            
        }
    }
    
    function addAddressNew(address _useraddress, uint256 _value, uint256 _txHashAddress, userState _userState, withdrawState _withdrawState, remainToken _remainToken) public onlyOwner {
        
        require(people[_useraddress]._address != _useraddress, "You are already added");
        require(getPeopleAddress(_useraddress) != _useraddress, "You are in previous contract try to add from addAddressExisting method");
        
        incrementCount();
        people[_useraddress] = Person(peopleCount, _useraddress, _value, _txHashAddress, _userState, _withdrawState, _remainToken, block.timestamp, 0,0,0);

    }
    
    function blockuser(address _useraddress) public onlyOwner {
        
        require(blockpeople[_useraddress]._address != _useraddress, "Already Blocked");
        
        blockpeople[_useraddress] = BlockUser(_useraddress);
        
    }

    function unblockuser(address _useraddress) public onlyOwner {
        
        require(blockpeople[_useraddress]._address == _useraddress, "Already Blocked");
        
        // blockpeople[_useraddress] = BlockUser();
        delete blockpeople[_useraddress];
        
    }
    
    function chkUserInPreviousContract(address _useraddress) public view returns(bool){
        
        if(getPeopleAddress(_useraddress) == _useraddress){
            return true;
        } else {
            return false;
        }
    }
    
    function stake(uint256 _amt) public {
         
         require(people[msg.sender]._address == msg.sender, "You are not added");
         
         Person storage t =  people[msg.sender]; 
        
         if (people[msg.sender]._stakeCounter == 0 ){
             
             if(_amt >= minStakeAmt){
                 // call approve manually
                require(Ntoken.transferFrom((msg.sender),address(this), _amt));
         
                
                 people[msg.sender]._stakeCounter += 1;
                 t.stakeStruct[people[msg.sender]._stakeCounter] = stakeData(people[msg.sender]._stakeCounter, _amt, block.timestamp,0,0);
                 people[msg.sender]._userState = userState.Staked;
                 
             }
             else {
                 revert();
             }
        
         }
         else if (people[msg.sender]._stakeCounter > 0 ){  // if not first then chk last unstake
             
             if(t.stakeStruct[people[msg.sender]._stakeCounter]._withdrawTimestamp == 0){
                 // call approve manually
                  require(Ntoken.transferFrom((msg.sender),address(this), _amt));
                 
                 people[msg.sender]._stakeCounter += 1;
                 t.stakeStruct[people[msg.sender]._stakeCounter] = stakeData(people[msg.sender]._stakeCounter, _amt, block.timestamp,0,0);
             
             }
             else if (t.stakeStruct[people[msg.sender]._stakeCounter]._withdrawTimestamp > 0){
                 
                 if(_amt >= minStakeAmt){
                     // call approve manually
                  require(Ntoken.transferFrom((msg.sender),address(this), _amt));
         
                
                 people[msg.sender]._stakeCounter += 1;
                 t.stakeStruct[people[msg.sender]._stakeCounter] = stakeData(people[msg.sender]._stakeCounter, _amt, block.timestamp,0,0);
                 people[msg.sender]._userState = userState.Staked;
                 
                 }
                 else {
                     revert();
                 }
                 
             }
             
         }
         
    }
    
    function stakeForOther(uint256 _amt, address _useraddress) public onlyOwner {
         
         require(people[_useraddress]._address == _useraddress, "adress are not added");
         
         Person storage t =  people[_useraddress]; 
        
                 // call approve manually
                 require(Ntoken.transferFrom(msg.sender,address(this), _amt));
         
                
                 people[_useraddress]._stakeCounter += 1;
                 t.stakeStruct[people[_useraddress]._stakeCounter] = stakeData(people[_useraddress]._stakeCounter, _amt, block.timestamp,0,0);
                 people[_useraddress]._userState = userState.Staked;
         
    }

    function totalStaked(address _useraddress) public view returns(uint256 _totalStakes) {
           _totalStakes = 0;
           Person storage t =  people[_useraddress];
           for (uint256 s = 1; s <= people[_useraddress]._stakeCounter; s += 1){
               if(t.stakeStruct[s]._withdrawTimestamp == 0){
                   _totalStakes += t.stakeStruct[s].amt;
               }
               
           }
      
      return _totalStakes;
   }
  
    function getStakeTokenById(uint256 _tokenId, address _useraddress) public view returns(address, uint256, uint256,uint256, uint256) {
      Person storage t =  people[_useraddress];
      return (t._address, t.stakeStruct[_tokenId].amt,t.stakeStruct[_tokenId]._stakeTimeStamp ,t.stakeStruct[_tokenId]._withdrawTimestamp, t.stakeStruct[_tokenId]._withdrawOrNotyet);
    }
    
    function getUserStateData(address _useraddress) internal view returns(userState){
        (,,,,NIOX.userState us,,,,) = token.people(_useraddress);
        if(us == NIOX.userState.NotDecided){
        return Staking.userState.NotDecided;
         }
        else if(us == NIOX.userState.Withdraw){
            return Staking.userState.Withdraw;
        }
        else if(us == NIOX.userState.Staked){
            return Staking.userState.Staked;
        }
    }
    
    function getWithdrawStateData(address _useraddress) internal view returns(withdrawState){
        (,,,,,NIOX.withdrawState ws,,,) = token.people(_useraddress);
        if(ws == NIOX.withdrawState.NotWithdraw){
        return Staking.withdrawState.NotWithdraw;
         }
        else if(ws == NIOX.withdrawState.PartiallyWithdraw){
            return Staking.withdrawState.PartiallyWithdraw;
        }
        else if(ws == NIOX.withdrawState.FullyWithdraw){
            return Staking.withdrawState.FullyWithdraw;
        }
    }
    
    function getRemainTokenData(address _useraddress) internal view returns(remainToken){
        (,,,,,,NIOX.remainToken rt,,) = token.people(_useraddress);
        if(rt == NIOX.remainToken.stage0){
        return Staking.remainToken.stage0;
         }
        else if(rt == NIOX.remainToken.stage1){
            return Staking.remainToken.stage1;
        }
        else if(rt == NIOX.remainToken.stage2){
            return Staking.remainToken.stage2;
        }
        else if(rt == NIOX.remainToken.stage3){
            return Staking.remainToken.stage3;
        }
        else if(rt == NIOX.remainToken.stage4){
            return Staking.remainToken.stage4;
        }
    }
    
    function getUsbtsData(address _useraddress) internal view returns(uint256 usbts){
        (,,,,,,,,uint256 _usbts) = token.people(_useraddress);
        return _usbts;
    }
    
    function getPeopleAddress(address _addr)  internal view returns (address _addres){
            (,address _address,,,,,,,) = token.people(_addr);
            return _address;
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
            
            Person storage t =  people[msg.sender];
            people[msg.sender]._stakeCounter += 1;
            t.stakeStruct[people[msg.sender]._stakeCounter] = stakeData(people[msg.sender]._stakeCounter ,people[msg.sender]._value,block.timestamp,0,0);
            
            return true;
        }
        else {
            return false;
        }
        
    }
    
    function getFirstStakeDate(address _useraddress) public view returns(uint256) {
         require(_useraddress == people[_useraddress]._address);
         require(_useraddress != blockpeople[_useraddress]._address);
         Person storage t =  people[_useraddress];
         
         for (uint256 s0 = 1; s0 <= people[_useraddress]._stakeCounter; s0 += 1){
               if(t.stakeStruct[s0]._withdrawTimestamp == 0){
                   uint256 _firstStakeTimestamp = t.stakeStruct[s0]._stakeTimeStamp;
                   return _firstStakeTimestamp;
               }
           }
    }
    
    function unstakeRequest() public {
        require(msg.sender == people[msg.sender]._address);
        require(msg.sender != blockpeople[msg.sender]._address);
        require(getFirstStakeDate(msg.sender) != 0 );
        require(block.timestamp >= getFirstStakeDate(msg.sender) + sixmonth);
        Person storage t =  people[msg.sender];
        require(t.stakeStruct[people[msg.sender]._stakeCounter]._withdrawTimestamp == 0);
         
        for (uint256 s = 1; s <= people[msg.sender]._stakeCounter; s += 1){
                       if(t.stakeStruct[s]._withdrawTimestamp == 0){ //chk that previos withdraws
                           t.stakeStruct[s]._withdrawTimestamp = block.timestamp;
                           t.stakeStruct[s]._withdrawOrNotyet = 1;
                       }
                    
        }
         
        people[msg.sender]._withdrawTimestamp = block.timestamp;
         
    }
    
    function withdrawToken() public returns (bool){
        
        require(msg.sender == people[msg.sender]._address,"You are not authorized"); // chk user is aithorized
        require(people[msg.sender]._userState == userState.Withdraw,"userState Issue"); //user into withdraw state
        // require(people[msg.sender]._userStateBlocktimestamp != 0,"usbts issue"); // must has choosen withdraw or stake 
        require(people[msg.sender]._withdrawState == withdrawState.NotWithdraw,"withdrawState issue"); // not withdraw any tkns
        require(people[msg.sender]._remainToken == remainToken.stage0,"remainToken issue"); // not withdraw any tkns
        require(msg.sender != blockpeople[msg.sender]._address); //not blocked
        require(people[msg.sender]._withdrawTimestamp == 0);  // is not staker

        
        if (getPeopleAddress(msg.sender) !=  msg.sender){
            if (block.timestamp >= stage11 && block.timestamp <= stage12 ){
            
            uint256 clamimTkn = people[msg.sender]._value / 100 * 50; 
            
             require(Ntoken.transfer(msg.sender, clamimTkn));
            
            people[msg.sender]._withdrawState = withdrawState.PartiallyWithdraw;
            people[msg.sender]._remainToken = remainToken.stage1;
            people[msg.sender]._blocktimestamp = block.timestamp;
            
            return true;
        }
        else if (block.timestamp > stage21 && block.timestamp <= stage22 ){
            
            uint256 clamimTkn = people[msg.sender]._value / 100 * 70; 
            
             require(Ntoken.transfer(msg.sender, clamimTkn));
            
            people[msg.sender]._withdrawState = withdrawState.PartiallyWithdraw;
            people[msg.sender]._remainToken = remainToken.stage2;
            people[msg.sender]._blocktimestamp = block.timestamp;
            
            return true;
        }
        else if (block.timestamp > stage31 && block.timestamp <= stage32 ){
            
            uint256 clamimTkn = people[msg.sender]._value / 100 * 80; 
            
             require(Ntoken.transfer(msg.sender, clamimTkn));
            
            people[msg.sender]._withdrawState = withdrawState.PartiallyWithdraw;
            people[msg.sender]._remainToken = remainToken.stage3;
            people[msg.sender]._blocktimestamp = block.timestamp;
            
            return true;
        }
        else if (block.timestamp > stage32 ){
            
            uint256 clamimTkn = people[msg.sender]._value; 
            
             require(Ntoken.transfer(msg.sender, clamimTkn));
            
            people[msg.sender]._withdrawState = withdrawState.FullyWithdraw;
            people[msg.sender]._remainToken = remainToken.stage4;
            people[msg.sender]._blocktimestamp = block.timestamp;
            
            return true;
        }
        } else {
            if (block.timestamp >= ostage11 && block.timestamp <= ostage12 ){
            
            uint256 clamimTkn = people[msg.sender]._value / 100 * 50; 
            
             require(Ntoken.transfer(msg.sender, clamimTkn));
            
            people[msg.sender]._withdrawState = withdrawState.PartiallyWithdraw;
            people[msg.sender]._remainToken = remainToken.stage1;
            people[msg.sender]._blocktimestamp = block.timestamp;
            
            return true;
        }
        else if (block.timestamp > ostage21 && block.timestamp <= ostage22 ){
            
            uint256 clamimTkn = people[msg.sender]._value / 100 * 70; 
            
             require(Ntoken.transfer(msg.sender, clamimTkn));
            
            people[msg.sender]._withdrawState = withdrawState.PartiallyWithdraw;
            people[msg.sender]._remainToken = remainToken.stage2;
            people[msg.sender]._blocktimestamp = block.timestamp;
            
            return true;
        }
        else if (block.timestamp > ostage31 && block.timestamp <= ostage32 ){
            
            uint256 clamimTkn = people[msg.sender]._value / 100 * 80; 
            
             require(Ntoken.transfer(msg.sender, clamimTkn));
            
            people[msg.sender]._withdrawState = withdrawState.PartiallyWithdraw;
            people[msg.sender]._remainToken = remainToken.stage3;
            people[msg.sender]._blocktimestamp = block.timestamp;
            
            return true;
        }
        else if (block.timestamp > ostage32 ){
            
            uint256 clamimTkn = people[msg.sender]._value; 
            
            require(Ntoken.transfer(msg.sender, clamimTkn));
            
            people[msg.sender]._withdrawState = withdrawState.FullyWithdraw;
            people[msg.sender]._remainToken = remainToken.stage4;
            people[msg.sender]._blocktimestamp = block.timestamp;
            
            return true;
        }
        }
        
    }
    
    function unstake() public returns(bool){
        
        require(msg.sender == people[msg.sender]._address,"You are not in previous contract");
        require(msg.sender != blockpeople[msg.sender]._address); // not blocked
        require(people[msg.sender]._withdrawTimestamp != 0 ); // chk that user has done unstakeme
        Person storage t =  people[msg.sender];
        require(block.timestamp >= people[msg.sender]._withdrawTimestamp + day21);
        uint256 clamimTkn = 0;
        for (uint256 s = 1; s <= people[msg.sender]._stakeCounter; s += 1){
            
                       if(t.stakeStruct[s]._withdrawOrNotyet == 1){ //chk that previos withdraws
                           clamimTkn += t.stakeStruct[s].amt;
                           t.stakeStruct[s]._withdrawOrNotyet = 0;
                       }
                    
         }
                
                    
                    require(Ntoken.transfer(msg.sender, clamimTkn));
                    
                    people[msg.sender]._withdrawTimestamp = 0;
                    
                    return true;

    
    }
    
    function withdrawRemainPenaltyToken() public checkUser returns (bool){
        
        require(msg.sender == people[msg.sender]._address);
        require(people[msg.sender]._userState == userState.Withdraw);
        require(people[msg.sender]._withdrawState == withdrawState.PartiallyWithdraw);
        require(block.timestamp >= people[msg.sender]._blocktimestamp + oneyear);
        require(msg.sender != blockpeople[msg.sender]._address);
        
        if (people[msg.sender]._remainToken == remainToken.stage1){
            
            uint256 clamimTkn = people[msg.sender]._value / 100 * 50; 
           
            require(Ntoken.transfer(msg.sender, clamimTkn));
          
            people[msg.sender]._withdrawState = withdrawState.FullyWithdraw;
            people[msg.sender]._remainToken = remainToken.stage4;
            
            return true;
        }
        else if (people[msg.sender]._remainToken == remainToken.stage2){
            
            uint256 clamimTkn = people[msg.sender]._value / 100 * 30; 
            
            require(Ntoken.transfer(msg.sender, clamimTkn));
            
            people[msg.sender]._withdrawState = withdrawState.FullyWithdraw;
            people[msg.sender]._remainToken = remainToken.stage4;
            
            return true;
        }
        else if (people[msg.sender]._remainToken == remainToken.stage3){
            
            uint256 clamimTkn = people[msg.sender]._value / 100 * 20; 
            
            require(Ntoken.transfer(msg.sender, clamimTkn));
            
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
    
    // withdraw owner tokens
    
    function withdrawOwnerNioxToken(uint256 _tkns) public  onlyOwner returns (bool) {
             require(token.transfer(msg.sender, _tkns));
             return true;
        }
        
    function withdrawOtherTokens(address tokenContract, uint256 count) external onlyOwner returns (bool)  {
     Token tc = Token(tokenContract);
     require(tc.transfer(owner, count));
     return true;
    }
    
}