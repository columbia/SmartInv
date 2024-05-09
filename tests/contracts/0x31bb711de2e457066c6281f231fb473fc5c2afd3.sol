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
// Uniswap Factory Interface
interface UniswapFactory {
    function getExchange(address token) external view returns (address exchange);
    }
// Uniswap Exchange Interface
interface UniswapExchange {
    function tokenToEthTransferInput(uint tokens_sold,uint min_eth,uint deadline, address recipient) external returns (uint  eth_bought);
    }
    //======================================VETHER=========================================//
contract Vether is ERC20 {
    // ERC-20 Parameters
    string public name; string public symbol;
    uint public decimals; uint public override totalSupply;
    // ERC-20 Mappings
    mapping(address => uint) public override balanceOf;
    mapping(address => mapping(address => uint)) public override allowance;
    // Public Parameters
    uint coin; uint public emission;
    uint public currentEra; uint public currentDay;
    uint public daysPerEra; uint public secondsPerDay;
    uint public genesis; uint public nextEraTime; uint public nextDayTime;
    address payable public burnAddress;
    address public registryAddress;
    uint public totalFees; uint public totalBurnt;
    // Public Mappings
    mapping(uint=>uint) public mapEra_Emission;                                             // Era->Emission
    mapping(uint=>mapping(uint=>uint)) public mapEraDay_Units;                              // Era,Days->Units
    mapping(uint=>mapping(uint=>uint)) public mapEraDay_UnitsRemaining;                     // Era,Days->TotalUnits
    mapping(uint=>mapping(uint=>uint)) public mapEraDay_Emission;                           // Era,Days->Emission
    mapping(uint=>mapping(uint=>uint)) public mapEraDay_EmissionRemaining;                  // Era,Days->Emission
    mapping(uint=>mapping(uint=>mapping(address=>uint))) public mapEraDay_MemberUnits;      // Era,Days,Member->Units
    mapping(address=>mapping(uint=>uint[])) public mapMemberEra_Days;                       // Member,Era->Days[]
    mapping(address=>bool) public mapAddress_Excluded;                                      // Address->Excluded
    // Events
    event NewEra(uint era, uint emission, uint time);
    event NewDay(uint era, uint day, uint time);
    event Burn(address indexed payer, address indexed member, uint era, uint day, uint units);
    event Withdrawal(address indexed caller, address indexed member, uint era, uint day, uint value);

    //=====================================CREATION=========================================//
    // Constructor
    constructor() public {
        name = "Vether"; symbol = "VETH"; decimals = 18; 
        coin = 1*10**decimals; totalSupply = 1000000*coin;                                  // Set Supply
        emission = 2048*coin; currentEra = 1; currentDay = 1;                               // Set emission, Era and Day
        genesis = now; daysPerEra = 244; secondsPerDay = 84200;                             // Set genesis time
        burnAddress = 0x0111011001100001011011000111010101100101;                           // Set Burn Address
        registryAddress = 0xc0a47dFe034B400B47bDaD5FecDa2621de6c4d95;                       // Set UniSwap V1 Mainnet
        
        balanceOf[address(this)] = totalSupply; 
        emit Transfer(burnAddress, address(this), totalSupply);                             // Mint the total supply to this address
        nextEraTime = genesis + (secondsPerDay * daysPerEra);                               // Set next time for coin era
        nextDayTime = genesis + secondsPerDay;                                              // Set next time for coin day
        mapAddress_Excluded[address(this)] = true;                                          // Add this address to be excluded from fees
        mapEra_Emission[currentEra] = emission;                                             // Map Starting emission
        mapEraDay_EmissionRemaining[currentEra][currentDay] = emission; 
        mapEraDay_Emission[currentEra][currentDay] = emission;
    }
    //========================================ERC20=========================================//
    // ERC20 Transfer function
    function transfer(address to, uint value) public override returns (bool success) {
        _transfer(msg.sender, to, value);
        return true;
    }
    // ERC20 Approve function
    function approve(address spender, uint value) public override returns (bool success) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }
    // ERC20 TransferFrom function
    function transferFrom(address from, address to, uint value) public override returns (bool success) {
        require(value <= allowance[from][msg.sender], 'Must not send more than allowance');
        allowance[from][msg.sender] -= value;
        _transfer(from, to, value);
        return true;
    }
    // Internal transfer function which includes the Fee
    function _transfer(address _from, address _to, uint _value) private {
        require(balanceOf[_from] >= _value, 'Must not send more than balance');
        require(balanceOf[_to] + _value >= balanceOf[_to], 'Balance overflow');
        balanceOf[_from] -= _value;
        uint _fee = _getFee(_from, _to, _value);                                            // Get fee amount
        balanceOf[_to] += (_value - _fee);                                                  // Add to receiver
        balanceOf[address(this)] += _fee;                                                   // Add fee to self
        totalFees += _fee;                                                                  // Track fees collected
        emit Transfer(_from, _to, (_value - _fee));                                         // Transfer event
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
    // Burn ERC-20 Tokens
    function burnTokens(address token, uint amount) external {
        _burnTokens(token, amount, msg.sender);                                             // Record Burn
    }
    // Burn tokens for nominated member
    function burnTokensForMember(address token, uint amount, address member) external {
        _burnTokens(token, amount, member);                                                 // Record Burn
    }
    // Calls when sending Tokens
    function _burnTokens (address _token, uint _amount, address _member) private {
        uint _eth; address _ex = getExchange(_token);                                       // Get exchange
        if (_ex == address(0)) {                                                            // Handle Token without Exchange
            uint _startGas = gasleft();                                                     // Start counting gas
            ERC20(_token).transferFrom(msg.sender, address(this), _amount);                 // Must collect tokens
            ERC20(_token).transfer(burnAddress, _amount);                                   // Burn token
            uint gasPrice = tx.gasprice; uint _endGas = gasleft();                          // Stop counting gas
            uint _gasUsed = (_startGas - _endGas) + 20000;                                  // Calculate gas and add gas overhead
            _eth = _gasUsed * gasPrice;                                                     // Attribute gas burnt
        } else {
            ERC20(_token).transferFrom(msg.sender, address(this), _amount);                 // Must collect tokens
            ERC20(_token).approve(_ex, _amount);                                            // Approve Exchange contract to transfer
            _eth = UniswapExchange(_ex).tokenToEthTransferInput(
                    _amount, 1, block.timestamp + 1000, burnAddress);                       // Uniswap Exchange Transfer function
        }
        _recordBurn(msg.sender, _member, currentEra, currentDay, _eth);
    }
    // Get Token Exchange
    function getExchange(address token ) public view returns (address){
        address exchangeToReturn = address(0);
        address exchangeFound = UniswapFactory(registryAddress).getExchange(token);         // Try UniSwap V1
        if (exchangeFound != address(0)) {
            exchangeToReturn = exchangeFound;
        }
        return exchangeToReturn;
    }
    // Internal - Records burn
    function _recordBurn(address _payer, address _member, uint _era, uint _day, uint _eth) private {
        if (mapEraDay_MemberUnits[_era][_day][_member] == 0){                               // If hasn't contributed to this Day yet
            mapMemberEra_Days[_member][_era].push(_day);                                    // Add it
        }
        mapEraDay_MemberUnits[_era][_day][_member] += _eth;                                 // Add member's share
        mapEraDay_UnitsRemaining[_era][_day] += _eth;                                       // Add to total historicals
        mapEraDay_Units[_era][_day] += _eth;                                                // Add to total outstanding
        totalBurnt += _eth;                                                                 // Add to total burnt
        emit Burn(_payer, _member, _era, _day, _eth);                                       // Burn event
        _updateEmission();                                                                  // Update emission Schedule
    }
    // Allows adding an excluded address, once per Era
    function addExcluded(address excluded) external {                   
        _transfer(msg.sender, address(this), mapEra_Emission[1]/16);                        // Pay fee of 128 Vether
        mapAddress_Excluded[excluded] = true;                                               // Add desired address
    }
    //======================================WITHDRAWAL======================================//
    // Used to efficiently track participation in each era
    function getDaysContributedForEra(address member, uint era) public view returns(uint){
        return mapMemberEra_Days[member][era].length;
    }
    // Call to withdraw a claim
    function withdrawShare(uint era, uint day) external {
        _withdrawShare(era, day, msg.sender);                           
    }
    // Call to withdraw a claim for another member
    function withdrawShareForMember(uint era, uint day, address member) external {
        _withdrawShare(era, day, member);
    }
    // Internal - withdraw function
    function _withdrawShare (uint _era, uint _day, address _member) private {               // Update emission Schedule
        _updateEmission();
        if (_era < currentEra) {                                                            // Allow if in previous Era
            _processWithdrawal(_era, _day, _member);                                        // Process Withdrawal
        } else if (_era == currentEra) {                                                    // Handle if in current Era
            if (_day < currentDay) {                                                        // Allow only if in previous Day
                _processWithdrawal(_era, _day, _member);                                    // Process Withdrawal
            }
        }   
    }
    // Internal - Withdrawal function
    function _processWithdrawal (uint _era, uint _day, address _member) private {
        uint memberUnits = mapEraDay_MemberUnits[_era][_day][_member];                      // Get Member Units
        if (memberUnits == 0) {                                                             // Do nothing if 0 (prevents revert)
        } else {
            uint emissionToTransfer = getEmissionShare(_era, _day, _member);                // Get the emission Share for Member
            mapEraDay_MemberUnits[_era][_day][_member] = 0;                                 // Set to 0 since it will be withdrawn
            mapEraDay_UnitsRemaining[_era][_day] -= memberUnits;                            // Decrement Member Units
            mapEraDay_EmissionRemaining[_era][_day] -= emissionToTransfer;                  // Decrement emission
            _transfer(address(this), _member, emissionToTransfer);                          // ERC20 transfer function
            emit Withdrawal(msg.sender, _member, _era, _day, emissionToTransfer);           // Withdrawal Event
        }
    }
         // Get emission Share function
    function getEmissionShare(uint era, uint day, address member) public view returns (uint emissionShare) {
        uint memberUnits = mapEraDay_MemberUnits[era][day][member];                         // Get Member Units
        if (memberUnits == 0) {
            return 0;                                                                       // If 0, return 0
        } else {
            uint totalUnits = mapEraDay_UnitsRemaining[era][day];                           // Get Total Units
            uint emissionRemaining = mapEraDay_EmissionRemaining[era][day];                 // Get emission remaining for Day
            uint balance = balanceOf[address(this)];                                        // Find remaining balance
            if (emissionRemaining > balance) { emissionRemaining = balance; }               // In case less than required emission
            emissionShare = (emissionRemaining * memberUnits) / totalUnits;                 // Calculate share
            return  emissionShare;                            
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
                emit NewEra(currentEra, emission, nextEraTime);                             // Emit Event
            }
            currentDay += 1;                                                                // Increment Day
            nextDayTime = _now + secondsPerDay;                                             // Set next Day time
            emission = getDayEmission();                                                    // Check daily Dmission
            mapEraDay_Emission[currentEra][currentDay] = emission;                          // Map emission to Day
            mapEraDay_EmissionRemaining[currentEra][currentDay] = emission;                 // Map emission to Day
            emit NewDay(currentEra, currentDay, nextDayTime);                               // Emit Event
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
        uint balance = balanceOf[address(this)];                                            // Find remaining balance
        if (balance > emission) {                                                           // Balance is sufficient
            return emission;                                                                // Return emission
        } else {                                                                            // Balance has dropped low
            return balance;                                                                 // Return full balance
        }
    }
}