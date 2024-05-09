pragma solidity 0.6.4;
//ERC20 Interface
interface ERC20 {
    function totalSupply() external view returns (uint);
    function balanceOf(address account) external view returns (uint);
    function transfer(address, uint) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint);
    function approve(address, uint) external returns (bool);
    function transferFrom(address, address, uint) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
    }
interface VETH {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint);
    function totalSupply() external view returns (uint);
    function genesis() external view returns (uint);
    function currentEra() external view returns (uint);
    function currentDay() external view returns (uint);
    function emission() external view returns (uint);
    function daysPerEra() external view returns (uint);
    function secondsPerDay() external view returns (uint);
    function totalBurnt() external view returns (uint);
    function totalFees() external view returns (uint);
    function burnAddress() external view returns (address payable);
}
library SafeMath {
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;
        return c;
    }
}
    //======================================VETHER=========================================//
contract Vether is ERC20 {
    using SafeMath for uint;
    // ERC-20 Parameters
    string public name; string public symbol;
    uint public decimals; uint public override totalSupply;
    // ERC-20 Mappings
    mapping(address => uint) private _balances;
    mapping(address => mapping(address => uint)) private _allowances;
    // Public Parameters
    uint coin = 10**18; uint public emission;
    uint public currentEra; uint public currentDay;
    uint public daysPerEra; uint public secondsPerDay;
    uint public upgradeHeight; uint public upgradedAmount;
    uint public genesis; uint public nextEraTime; uint public nextDayTime;
    address payable public burnAddress; address public vether1; address deployer;
    uint public totalFees; uint public totalBurnt; uint public totalEmitted;
    address[] public holderArray; uint public holders;
    // Public Mappings
    mapping(uint=>uint) public mapEra_Emission;                                             // Era->Emission
    mapping(uint=>mapping(uint=>uint)) public mapEraDay_MemberCount;                        // Era,Days->MemberCount
    mapping(uint=>mapping(uint=>address[])) public mapEraDay_Members;                       // Era,Days->Members
    mapping(uint=>mapping(uint=>uint)) public mapEraDay_Units;                              // Era,Days->Units
    mapping(uint=>mapping(uint=>uint)) public mapEraDay_UnitsRemaining;                     // Era,Days->TotalUnits
    mapping(uint=>mapping(uint=>uint)) public mapEraDay_Emission;                           // Era,Days->Emission
    mapping(uint=>mapping(uint=>uint)) public mapEraDay_EmissionRemaining;                  // Era,Days->Emission
    mapping(uint=>mapping(uint=>mapping(address=>uint))) public mapEraDay_MemberUnits;      // Era,Days,Member->Units
    mapping(address=>mapping(uint=>uint[])) public mapMemberEra_Days;                       // Member,Era->Days[]
    mapping(address=>bool) public mapAddress_Excluded;                                      // Address->Excluded
    mapping(address=>uint) public mapPreviousOwnership;                                     // Map previous owners
    mapping(address=>bool) public mapHolder;                                                // Vether Holder
    // Events
    event NewEra(uint era, uint emission, uint time, uint totalBurnt);
    event NewDay(uint era, uint day, uint time, uint previousDayTotal, uint previousDayMembers);
    event Burn(address indexed payer, address indexed member, uint era, uint day, uint units, uint dailyTotal);
    event Withdrawal(address indexed caller, address indexed member, uint era, uint day, uint value, uint vetherRemaining);

    //=====================================CREATION=========================================//
    // Constructor
    constructor() public {
        vether1 = 0x31Bb711de2e457066c6281f231fb473FC5c2afd3;                               // First Vether
        upgradeHeight = 45;                                                                  // Height at which to upgrade
        name = VETH(vether1).name(); 
        symbol = VETH(vether1).symbol(); 
        decimals = VETH(vether1).decimals(); 
        totalSupply = VETH(vether1).totalSupply();
        genesis = VETH(vether1).genesis();
        currentEra = VETH(vether1).currentEra(); 
        currentDay = upgradeHeight;                                                         // Begin at Upgrade Height
        emission = VETH(vether1).emission(); 
        daysPerEra = VETH(vether1).daysPerEra(); 
        secondsPerDay = VETH(vether1).secondsPerDay();
        totalBurnt = VETH(vether1).totalBurnt(); 
        totalFees = VETH(vether1).totalFees(); 
        totalEmitted = (upgradeHeight-1)*emission;
        burnAddress = VETH(vether1).burnAddress(); 
        deployer = msg.sender;
        _balances[address(this)] = totalSupply; 
        emit Transfer(burnAddress, address(this), totalSupply);                             // Mint the total supply to this address
        nextEraTime = genesis + (secondsPerDay * daysPerEra);                               // Set next time for coin era
        nextDayTime = genesis + (secondsPerDay * upgradeHeight);                            // Set next time for coin day
        mapAddress_Excluded[address(this)] = true;                                          // Add this address to be excluded from fees
        mapEra_Emission[currentEra] = emission;                                             // Map Starting emission
        mapEraDay_EmissionRemaining[currentEra][currentDay] = emission; 
        mapEraDay_Emission[currentEra][currentDay] = emission;
    }

    //========================================ERC20=========================================//
    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        if(mapAddress_Excluded[spender]){
            return totalSupply;
        } else {
            return _allowances[owner][spender];
        }
    }
    // ERC20 Transfer function
    function transfer(address to, uint value) public override returns (bool success) {
        _transfer(msg.sender, to, value);
        return true;
    }
    // ERC20 Approve function
    function approve(address spender, uint value) public override returns (bool success) {
        _allowances[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }
    // ERC20 TransferFrom function
    function transferFrom(address from, address to, uint value) public override returns (bool success) {
        if(!mapAddress_Excluded[msg.sender]){
            require(value <= _allowances[from][msg.sender], 'Must not send more than allowance');
            _allowances[from][msg.sender] -= value;
        }
        _transfer(from, to, value);
        return true;
    }
    // Internal transfer function which includes the Fee
    function _transfer(address _from, address _to, uint _value) private {
        require(_balances[_from] >= _value, 'Must not send more than balance');
        require(_balances[_to] + _value >= _balances[_to], 'Balance overflow');
        if(!mapHolder[_to]){holderArray.push(_to); holders+=1; mapHolder[_to]=true;}
        _balances[_from] -= _value;
        uint _fee = _getFee(_from, _to, _value);                                            // Get fee amount
        _balances[_to] += (_value.sub(_fee));                                               // Add to receiver
        _balances[address(this)] += _fee;                                                   // Add fee to self
        totalFees += _fee;                                                                  // Track fees collected
        emit Transfer(_from, _to, (_value.sub(_fee)));                                      // Transfer event
        if (!mapAddress_Excluded[_from] && !mapAddress_Excluded[_to]) {
            emit Transfer(_from, address(this), _fee);                                      // Fee Transfer event
        }
    }
    // Calculate Fee amount
    function _getFee(address _from, address _to, uint _value) private view returns (uint) {
        if (mapAddress_Excluded[_from] || mapAddress_Excluded[_to]) {
           return 0;                                                                        // No fee if excluded
        } else {
            return (_value / 1000);                                                         // Fee amount = 0.1%
        }
    }
    // Allow to query for remaining upgrade amount
    function getRemainingAmount() public view returns (uint amount){
        uint maxEmissions = (upgradeHeight-1) * mapEra_Emission[1];                         // Max Emission on Old Contract
        uint maxUpgradeAmount = (maxEmissions).sub(VETH(vether1).totalFees());              // Minus any collected fees
        if(maxUpgradeAmount >= upgradedAmount){
            return maxUpgradeAmount.sub(upgradedAmount);                                    // Return remaining
        } else {
            return 0;                                                                       // Return 0
        }
    }
    // Allow any holder of the old asset to upgrade
    function upgrade(uint amount) public returns (bool success){
        uint _amount = amount;
        if(mapPreviousOwnership[msg.sender] < amount){_amount = mapPreviousOwnership[msg.sender];} // Upgrade as much as possible
        uint remainingAmount = getRemainingAmount();
        if(remainingAmount < amount){_amount = remainingAmount;}                            // Handle final amount
        upgradedAmount += _amount; mapPreviousOwnership[msg.sender] -= _amount;             // Update mappings
        ERC20(vether1).transferFrom(msg.sender, burnAddress, _amount);                      // Must collect & burn tokens
        _transfer(address(this), msg.sender, _amount);                                      // Send to owner
        return true;
    }
    function snapshot(address[] memory owners, uint[] memory ownership) public{
        require(msg.sender == deployer);
        for(uint i = 0; i<owners.length; i++){
            mapPreviousOwnership[owners[i]] = ownership[i];
        }
    }
    function purgeDeployer() public{require(msg.sender == deployer);deployer = address(0);}

    //==================================PROOF-OF-VALUE======================================//
    // Calls when sending Ether
    receive() external payable {
        burnAddress.call.value(msg.value)("");                                              // Burn ether
        _recordBurn(msg.sender, msg.sender, currentEra, currentDay, msg.value);             // Record Burn
    }
    // Burn ether for nominated member
    function burnEtherForMember(address member) external payable {
        burnAddress.call.value(msg.value)("");                                              // Burn ether
        _recordBurn(msg.sender, member, currentEra, currentDay, msg.value);                 // Record Burn
    }
    // Internal - Records burn
    function _recordBurn(address _payer, address _member, uint _era, uint _day, uint _eth) private {
        require(VETH(vether1).currentDay() >= upgradeHeight || VETH(vether1).currentEra() > 1); // Prohibit until upgrade height
        if (mapEraDay_MemberUnits[_era][_day][_member] == 0){                               // If hasn't contributed to this Day yet
            mapMemberEra_Days[_member][_era].push(_day);                                    // Add it
            mapEraDay_MemberCount[_era][_day] += 1;                                         // Count member
            mapEraDay_Members[_era][_day].push(_member);                                    // Add member
        }
        mapEraDay_MemberUnits[_era][_day][_member] += _eth;                                 // Add member's share
        mapEraDay_UnitsRemaining[_era][_day] += _eth;                                       // Add to total historicals
        mapEraDay_Units[_era][_day] += _eth;                                                // Add to total outstanding
        totalBurnt += _eth;                                                                 // Add to total burnt
        emit Burn(_payer, _member, _era, _day, _eth, mapEraDay_Units[_era][_day]);          // Burn event
        _updateEmission();                                                                  // Update emission Schedule
    }
    // Allows changing an excluded address
    function changeExcluded(address excluded) external {    
        if(!mapAddress_Excluded[excluded]){
            _transfer(msg.sender, address(this), mapEra_Emission[1]/16);                    // Pay fee of 128 Vether
            mapAddress_Excluded[excluded] = true;                                           // Add desired address
            totalFees += mapEra_Emission[1]/16;
        } else {
            _transfer(msg.sender, address(this), mapEra_Emission[1]/32);                    // Pay fee of 64 Vether
            mapAddress_Excluded[excluded] = false;                                          // Change desired address
            totalFees += mapEra_Emission[1]/32;
        }               
    }
    //======================================WITHDRAWAL======================================//
    // Used to efficiently track participation in each era
    function getDaysContributedForEra(address member, uint era) public view returns(uint){
        return mapMemberEra_Days[member][era].length;
    }
    // Call to withdraw a claim
    function withdrawShare(uint era, uint day) external returns (uint value) {
        value = _withdrawShare(era, day, msg.sender);                           
    }
    // Call to withdraw a claim for another member
    function withdrawShareForMember(uint era, uint day, address member) external returns (uint value) {
        value = _withdrawShare(era, day, member);
    }
    // Internal - withdraw function
    function _withdrawShare (uint _era, uint _day, address _member) private returns (uint value) {
        _updateEmission(); 
        if (_era < currentEra) {                                                            // Allow if in previous Era
            value = _processWithdrawal(_era, _day, _member);                                // Process Withdrawal
        } else if (_era == currentEra) {                                                    // Handle if in current Era
            if (_day < currentDay) {                                                        // Allow only if in previous Day
                value = _processWithdrawal(_era, _day, _member);                            // Process Withdrawal
            }
        }  
        return value;
    }
    // Internal - Withdrawal function
    function _processWithdrawal (uint _era, uint _day, address _member) private returns (uint value) {
        uint memberUnits = mapEraDay_MemberUnits[_era][_day][_member];                      // Get Member Units
        if (memberUnits == 0) { 
            value = 0;                                                                      // Do nothing if 0 (prevents revert)
        } else {
            value = getEmissionShare(_era, _day, _member);                                  // Get the emission Share for Member
            mapEraDay_MemberUnits[_era][_day][_member] = 0;                                 // Set to 0 since it will be withdrawn
            mapEraDay_UnitsRemaining[_era][_day] -= memberUnits;                            // Decrement Member Units
            mapEraDay_EmissionRemaining[_era][_day] -= value;                               // Decrement emission
            totalEmitted += value;                                                          // Add to Total Emitted
            _transfer(address(this), _member, value);                                       // ERC20 transfer function
            emit Withdrawal(msg.sender, _member, _era, _day, 
            value, mapEraDay_EmissionRemaining[_era][_day]);
        }
        return value;
    }
    // Get emission Share function
    function getEmissionShare(uint era, uint day, address member) public view returns (uint value) {
        uint memberUnits = mapEraDay_MemberUnits[era][day][member];                         // Get Member Units
        if (memberUnits == 0) {
            return 0;                                                                       // If 0, return 0
        } else {
            uint totalUnits = mapEraDay_UnitsRemaining[era][day];                           // Get Total Units
            uint emissionRemaining = mapEraDay_EmissionRemaining[era][day];                 // Get emission remaining for Day
            uint balance = _balances[address(this)];                                        // Find remaining balance
            if (emissionRemaining > balance) { emissionRemaining = balance; }               // In case less than required emission
            value = (emissionRemaining * memberUnits) / totalUnits;                         // Calculate share
            return  value;                            
        }
    }
    //======================================EMISSION========================================//
    // Internal - Update emission function
    function _updateEmission() private {
        uint _now = now;                                                                    // Find now()
        if (_now >= nextDayTime) {                                                          // If time passed the next Day time
            if (currentDay >= daysPerEra) {                                                 // If time passed the next Era time
                currentEra += 1; currentDay = 0;                                            // Increment Era, reset Day
                nextEraTime = _now + (secondsPerDay * daysPerEra);                          // Set next Era time
                emission = getNextEraEmission();                                            // Get correct emission
                mapEra_Emission[currentEra] = emission;                                     // Map emission to Era
                emit NewEra(currentEra, emission, nextEraTime, totalBurnt);                 // Emit Event
            }
            currentDay += 1;                                                                // Increment Day
            nextDayTime = _now + secondsPerDay;                                             // Set next Day time
            emission = getDayEmission();                                                    // Check daily Dmission
            mapEraDay_Emission[currentEra][currentDay] = emission;                          // Map emission to Day
            mapEraDay_EmissionRemaining[currentEra][currentDay] = emission;                 // Map emission to Day
            uint _era = currentEra; uint _day = currentDay-1;
            if(currentDay == 1){ _era = currentEra-1; _day = daysPerEra; }                  // Handle New Era
            emit NewDay(currentEra, currentDay, nextDayTime, 
            mapEraDay_Units[_era][_day], mapEraDay_MemberCount[_era][_day]);                // Emit Event
        }
    }
    // Calculate Era emission
    function getNextEraEmission() public view returns (uint) {
        if (emission > coin) {                                                              // Normal Emission Schedule
            return emission / 2;                                                            // Emissions: 2048 -> 1.0
        } else{                                                                             // Enters Fee Era
            return coin;                                                                    // Return 1.0 from fees
        }
    }
    // Calculate Day emission
    function getDayEmission() public view returns (uint) {
        uint balance = _balances[address(this)];                                            // Find remaining balance
        if (balance > emission) {                                                           // Balance is sufficient
            return emission;                                                                // Return emission
        } else {                                                                            // Balance has dropped low
            return balance;                                                                 // Return full balance
        }
    }
}