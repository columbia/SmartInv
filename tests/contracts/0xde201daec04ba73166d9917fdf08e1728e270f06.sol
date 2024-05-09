pragma solidity 0.5.16; /*

___________________________________________________________________
  _      _                                        ______           
  |  |  /          /                                /              
--|-/|-/-----__---/----__----__---_--_----__-------/-------__------
  |/ |/    /___) /   /   ' /   ) / /  ) /___)     /      /   )     
__/__|____(___ _/___(___ _(___/_/_/__/_(___ _____/______(___/__o_o_





███╗   ███╗███████╗██╗  ██╗██████╗     ████████╗ ██████╗ ██╗  ██╗███████╗███╗   ██╗
████╗ ████║██╔════╝╚██╗██╔╝██╔══██╗    ╚══██╔══╝██╔═══██╗██║ ██╔╝██╔════╝████╗  ██║
██╔████╔██║█████╗   ╚███╔╝ ██████╔╝       ██║   ██║   ██║█████╔╝ █████╗  ██╔██╗ ██║
██║╚██╔╝██║██╔══╝   ██╔██╗ ██╔═══╝        ██║   ██║   ██║██╔═██╗ ██╔══╝  ██║╚██╗██║
██║ ╚═╝ ██║███████╗██╔╝ ██╗██║            ██║   ╚██████╔╝██║  ██╗███████╗██║ ╚████║
╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝╚═╝            ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝
                                                                                   


                                                                             


=== 'MEXP' Token contract with following features ===
    => TRC20 Compliance
    => Higher degree of control by owner - safeguard functionality
    => SafeMath implementation 
    => Burnable and minting ( For MOJI Players)


======================= Quick Stats ===================
    => Name        : "MOJI Experience Points"
    => Symbol      : MEXP
    => Total supply: 0 (Minted only by MOJI players only)
    => Decimals    : 18
*/


//*******************************************************************//
//------------------------ SafeMath Library -------------------------//
//*******************************************************************//
/**
    * @title SafeMath
    * @dev Math operations with safety checks that throw on error
    */
library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
        return 0;
    }
    uint256 c = a * b;
    require(c / a == b);
    return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b <= a);
    return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a);
    return c;
    }
}


//*******************************************************************//
//------------------ Contract to Manage Ownership -------------------//
//*******************************************************************//
    
contract owned {
    address payable public owner;
    address payable private newOwner;

    /**
        Signer is deligated admin wallet, which can do sub-owner functions.
        Signer calls following four functions:
            => claimOwnerTokens
            => distributeMainDividend
            => distributeLeaders1
            => distributeLeaders2
    */
    address public signer;

    event OwnershipTransferred(address indexed _from, address indexed _to);

    constructor() public {
        owner = msg.sender;
        signer = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    modifier onlySigner {
        require(msg.sender == signer);
        _;
    }

    function changeSigner(address _signer) public onlyOwner {
        signer = _signer;
    }

    function transferOwnership(address payable _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }

    //this flow is to prevent transferring ownership to wrong wallet by mistake
    function acceptOwnership() public {
        require(msg.sender == newOwner);
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
        newOwner = address(0);
    }
}


//**************************************************************************//
//-------------------    NIFTYMOJI CONTRACT INTERFACE    --------------------//
//**************************************************************************//

interface niftyMoji 
{
    function ownerOf(uint256 tokenId) external view returns (address);
    function powerNLucks(uint256 tokenID) external view returns(uint256, uint256);
    function totalSupply() external view returns(uint256);
} 
    

    
//****************************************************************************//
//---------------------    MEXP MAIN CODE STARTS HERE   ---------------------//
//****************************************************************************//
    
contract MEXPToken is owned {

    /*===============================
    =         DATA STORAGE          =
    ===============================*/

    // Public variables of the token
    using SafeMath for uint256;
    uint256 public withdrawnByAdmin; 
    string public constant name = "MOJI Experience Points";
    string public constant symbol = "MEXP";
    uint256 public constant decimals = 18; 
    uint256 public totalSupply;
    uint256 public burnTracker;     //mainly used in mintToken function..
    uint256 public mintingMultiplier=10000;  // 10000 = 1, 123 = 0.0123 admin can set it minting per day, will be factored as luck %
    address public niftyMojiContractAddress = 0xde544E54a330Abd1eA8a0E6693D46BFe95D9A684;  // admin can set / change this address 
    uint256 public battleFees=1;  // default is 0.000000000000000001 Ether for battle fees, which admin can change
    uint256 public mintTokenFee = 0.001 ether;
    uint256 public battleWinReward= 10**18; // = 1 token with 18 decimal places, admin can change
    uint256 public battleLooseReward = 10**17; // = 0.1 token with 10 decimal places, admin can change
    uint256 public maxBattlePerDay=10;  //daily 10 max battles
    bool public globalHalt; // Emergency Break
    uint256 public lastFinishedIndex;

    // This creates a mapping with all data storage
    mapping (address => uint256) public balanceOf;
    mapping(uint256 => uint256) public totalMintedForTokenId;
    mapping(uint256 => uint256) public totalMintedByOwnerForTokenID;
    mapping(uint256 => uint256) public totalMintedByUserForTokenID;
    mapping(uint256 => uint256) public totalMintedByBattleForTokenID;
    mapping(uint256 => uint256) public dayTracker;
    mapping (address => mapping (address => uint256)) public allowance;
    
    mapping(address => uint256) public BattleCountEndTime;
    mapping (address => uint256) public userBattleCount;
    mapping(address => bool) public blackListedUser;
    mapping(uint256 => bool) public blackListedToken;
    


    struct battleInfo
    {
        uint256 tokenID;
        uint256 userSeed;
        uint256 rewardAmount;
        uint256 blockNo;
        uint256 opponentTokenID;
    }

    battleInfo[] public battleInfos;

    /*===============================
    =         PUBLIC EVENTS         =
    ===============================*/

    // This generates a public event of token transfer
    event Transfer(address indexed from, address indexed to, uint256 value);

    // This notifies clients about the amount burnt
    event Burn(address indexed indexed from, uint256 value);

    // This trackes approvals
    event Approval(address indexed owner, address indexed spender, uint256 value );

    /*======================================
    =       STANDARD TRC20 FUNCTIONS       =
    ======================================*/

    /* Internal transfer, only can be called by this contract */
    function _transfer(address _from, address _to, uint _value) internal {
        
        //checking conditions
        require(!globalHalt, "paused by admin");
        require (_to != address(0x0));                      // Prevent transfer to 0x0 address. Use burn() instead      
        // overflow and undeflow checked by SafeMath Library
        balanceOf[_from] = balanceOf[_from].sub(_value);    // Subtract from the sender
        balanceOf[_to] = balanceOf[_to].add(_value);        // Add the same to the recipient       
        // emit Transfer event
        emit Transfer(_from, _to, _value);
    }

    /**
        * Transfer tokens
        *
        * Send `_value` tokens to `_to` from your account
        *
        * @param _to The address of the recipient
        * @param _value the amount to send
        */
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(!blackListedUser[msg.sender], "you are not allowed");
        //no need to check for input validations, as that is ruled by SafeMath
        _transfer(msg.sender, _to, _value);
        
        return true;
    }

    /**
        * Transfer tokens from other address
        *
        * Send `_value` tokens to `_to` in behalf of `_from`
        *
        * @param _from The address of the sender
        * @param _to The address of the recipient
        * @param _value the amount to send
        */
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(!blackListedUser[msg.sender], "you are not allowed");
        //require(_value <= allowance[_from][msg.sender]);     // no need for this condition as it is already checked by SafeMath below
        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
        _transfer(_from, _to, _value);
        
        return true;
    }

    /**
        * Set allowance for other address
        *
        * Allows `_spender` to spend no more than `_value` tokens in your behalf
        *
        * @param _spender The address authorized to spend
        * @param _value the max amount they can spend
        */
    function approve(address _spender, uint256 _value) public returns (bool success) {
        require(!blackListedUser[msg.sender], "you are not allowed");
        require(!globalHalt, "paused by admin");
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }


    /*=====================================
    =       CUSTOM PUBLIC FUNCTIONS       =
    ======================================*/

    /**
        Constructor function
    */
    constructor() public 
    {
        battleInfo memory temp;
        battleInfos.push(temp);
        
    }

    /**
        * Fallback function. It just accepts incoming Ether
    */
    function () payable external {}
    

    /**
        * Destroy tokens
        *
        * Remove `_value` tokens from the system irreversibly
        *
        * @param _value the amount of money to burn
        */
    function burn(uint256 _value) public returns (bool success) {

        require(!globalHalt, "paused by admin");
        require(!blackListedUser[msg.sender], "you are not allowed");
        //checking of enough token balance is done by SafeMath
        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);  // Subtract from the sender
        totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
        burnTracker = burnTracker.add(_value);
        
        emit Transfer(msg.sender, address(0), _value);
        //althogh we can track all the "burn" from the Transfer function, we just kept it as it is. As that is no much harm
        emit Burn(msg.sender, _value);
        return true;
    }

    /**
        * Destroy tokens from other account
        *
        * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
        *
        * @param _from the address of the sender
        * @param _value the amount of money to burn
        */
    function burnFrom(address _from, uint256 _value) public returns (bool success) {

        require(!globalHalt, "paused by admin");
        require(!blackListedUser[msg.sender], "you are not allowed");
        //checking of allowance and token value is done by SafeMath
        balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
        allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value); // Subtract from the sender's allowance
        totalSupply = totalSupply.sub(_value);                                   // Update totalSupply
        burnTracker = burnTracker.add(_value);
        
        emit Transfer(_from, address(0), _value);
        emit  Burn(_from, _value);
        return true;
    }

    function mintTokenOwnerOnly(address user, uint256 _tokenID, uint256 tokenAmount) public onlyOwner returns(bool)
    {
        require(user != address(this) && user != address(0), "invalid address" );
        require(tokenAmount > 0 , "Invalid token to mint");
        require(!blackListedToken[_tokenID], "this token is blacklisted");
        if(_tokenID != 0)
        {
            require(niftyMoji(niftyMojiContractAddress).ownerOf(_tokenID) == user,"user is not the owner of this tokenID");
            totalMintedForTokenId[_tokenID] = totalMintedForTokenId[_tokenID].add(tokenAmount);
            totalMintedByOwnerForTokenID[_tokenID] = totalMintedByOwnerForTokenID[_tokenID].add(tokenAmount);
        }
        totalSupply = totalSupply.add(tokenAmount);
        balanceOf[user] = balanceOf[user].add(tokenAmount);
        //emitting Transfer event
        emit Transfer(address(0),user,tokenAmount);
        return true;
    }       


    function blackListUser(address user) public onlyOwner returns(bool)
    {
        blackListedUser[user] = true;
        return true;
    }


    function removeUserFromBlackList(address user) public onlyOwner returns(bool)
    {
        blackListedUser[user] = false;
        return true;
    }




    function blackListToken(uint256 _tokenID) public onlyOwner returns(bool)
    {
        blackListedToken[_tokenID] = true;
        return true;
    }


    function removeTokenFromBlackList(uint256 _tokenID) public onlyOwner returns(bool)
    {
        blackListedToken[_tokenID] = false;
        return true;
    }

    //Minting according to luck percent of the given token id 
    function mintToken(uint256 _tokenID)  public payable returns(bool) {
        require(!globalHalt, "paused by admin");
        address caller = niftyMoji(niftyMojiContractAddress).ownerOf(_tokenID);
        require(!blackListedUser[caller], "you are not allowed");
        require(!blackListedToken[_tokenID], "this token is blacklisted");
        require(caller == msg.sender,"caller is not the owner of this tokenID");
        require(msg.value >= mintTokenFee, 'Not enough token minting fee');
        uint256 dt = dayTracker[_tokenID];
        if (dt != 0)
        {
            uint256 secPassed  =  now - dt ;
            require(secPassed > 0 , "already minted for the day");
            (,uint256 luckPercent ) = niftyMoji(niftyMojiContractAddress).powerNLucks(_tokenID);
            uint256 mintAmount = (( (mintingMultiplier * (10 ** 18) * ((luckPercent + 9 ) / 10 ) ) / 100000 ) /  86400 ) * secPassed ;
            dayTracker[_tokenID] = now ;            
            totalMintedByUserForTokenID[_tokenID] = totalMintedByUserForTokenID[_tokenID].add(mintAmount);
            totalMintedForTokenId[_tokenID] = totalMintedForTokenId[_tokenID].add(mintAmount);
            totalSupply = totalSupply.add(mintAmount);
            balanceOf[caller] = balanceOf[caller].add(mintAmount);
            //emitting Transfer event
            emit Transfer(address(0),caller,mintAmount);
        }
        else
        {
           dayTracker[_tokenID] = now; 
        }
        owner.transfer(msg.value);
        return true;
    }

    function viewAmountIfIMintNow(uint256 _tokenID) public view returns(uint256 amount)
    {
        uint256 dt = dayTracker[_tokenID];
        if (dt != 0)
        {
            uint256 secPassed  =  now - dt ;
            (,uint256 luckPercent ) = niftyMoji(niftyMojiContractAddress).powerNLucks(_tokenID);
            amount = (( (mintingMultiplier * (10 ** 18) * ((luckPercent + 9 ) / 10 ) ) / 100000 ) /  86400 ) * secPassed ;
            return amount;
        }
        else
        {
           return (0);
        }        
    }

    function setMaxBattlePerDay(uint _maxBattlePerDay) public onlyOwner returns (bool)
    {
        maxBattlePerDay = _maxBattlePerDay;
        return true;
    }


    event initiateBattleEv(address caller,uint256 _tokenID,uint256 _userSeed,uint256 battleInfoIndex, uint256 blockNo);
    function initiateBattle(uint256 _tokenID, uint256 _userSeed) public payable returns (uint256 battleID)
    { 
        require(!globalHalt, "paused by admin");
        require(msg.value == battleFees, "Invalid fees amount");
        address caller = niftyMoji(niftyMojiContractAddress).ownerOf(_tokenID);
        require(!blackListedUser[caller], "you are not allowed");
        require(!blackListedToken[_tokenID], "this token is blacklisted");
        require(caller == msg.sender,"caller is not the owner of this tokenID");
        require( userBattleCount[caller] <= maxBattlePerDay, "enough for the day");
        if(BattleCountEndTime[caller] >= now )
        {
            userBattleCount[caller] += 1;
        }
        else
        {
            BattleCountEndTime[caller] = now + 86400;
            userBattleCount[caller] = 1;
        }        
        battleInfo memory temp;
        temp.tokenID = _tokenID;
        temp.userSeed = _userSeed;
        temp.blockNo = block.number;
        battleInfos.push(temp);
        //emitting Transfer event
        battleID = battleInfos.length - 1;
        address(owner).transfer(msg.value);
        emit initiateBattleEv(caller, _tokenID, _userSeed, battleID,block.number );   
        return battleID;
    }


    event finishBattleEv(address user, uint256 battleInfoIndex, uint256 _tokenID, uint256 randomToken, uint256 mintAmount);
    function finishBattle(uint256 _battleInfoIndex,bytes32 blockHashValue) public onlySigner returns (bool)  // returns winning amount minted
    { 
        require(_battleInfoIndex < battleInfos.length, "Invalid Battle Index");
        require(battleInfos[_battleInfoIndex].rewardAmount == 0, "Already finished");
        uint256 _tokenID = battleInfos[_battleInfoIndex].tokenID;
        uint256 _userSeed = battleInfos[_battleInfoIndex].userSeed;
        address caller = niftyMoji(niftyMojiContractAddress).ownerOf(_tokenID);
        bool success;
        uint256 randomToken;
        address randomTokenUser;
        for(uint256 i=0;i<50;i++)
        {
            randomToken = uint256(keccak256(abi.encodePacked(blockHashValue, _userSeed))) % niftyMoji(niftyMojiContractAddress).totalSupply() + 1;
            randomTokenUser = niftyMoji(niftyMojiContractAddress).ownerOf(_tokenID);
            if(blackListedToken[randomToken] || blackListedUser[randomTokenUser])
            {
                _userSeed += block.number%8;
            }
            else
            {
                success = true;
                break;
            }
        }
        require(success, "try again");
        (uint256 powerPercent,uint256 luckPercent ) = niftyMoji(niftyMojiContractAddress).powerNLucks(_tokenID);
        (uint256 powerPercent2,uint256 luckPercent2 ) = niftyMoji(niftyMojiContractAddress).powerNLucks(randomToken); 
        uint256 mintAmount;
        if( powerPercent + luckPercent > powerPercent2 + luckPercent2) 
        {
            mintAmount = battleWinReward ;           
        } 
        else
        {
            mintAmount = battleLooseReward;
        }
        battleInfos[_battleInfoIndex].rewardAmount = mintAmount;
        battleInfos[_battleInfoIndex].opponentTokenID = randomToken;

        emit finishBattleEv(caller,_battleInfoIndex, _tokenID, randomToken, mintAmount);   
        balanceOf[caller] = balanceOf[caller].add(mintAmount);
        totalSupply = totalSupply.add(mintAmount);
        totalMintedForTokenId[_tokenID] = totalMintedForTokenId[_tokenID].add(mintAmount);
        totalMintedByBattleForTokenID[_tokenID] = totalMintedByBattleForTokenID[_tokenID].add(mintAmount);
        dayTracker[_tokenID] = now;
        lastFinishedIndex = _battleInfoIndex;                       
        emit Transfer(address(0),caller,mintAmount);
        return true;
    }

    function multipleFinishBattle (bytes32[] memory _blockHashValue) public onlySigner returns(bool)
    {
        uint i;

        for(i=0;i<_blockHashValue.length;i++)
        {
           require(finishBattle(lastFinishedIndex + i + 1,_blockHashValue[i]),"could not fihish battle");
        }
        return true;
    }

    function lastUnFinishedIndexNBlock() public view returns (uint256 lastUnFinishedIndex, uint256 blockNo)
    {
        uint len = battleInfos.length-1;
        if(len >  lastFinishedIndex)
        {
            return (lastFinishedIndex +1, battleInfos[lastFinishedIndex +1].blockNo);
        }
        else
        {
            return (0,0);
        }
    }


    function setNiftyMojiContractAddress(address _niftyMojiContractAddress) public onlyOwner returns(bool)
    {
        niftyMojiContractAddress = _niftyMojiContractAddress;
        return true;
    }


    function setMintingMultiplier(uint256 _mintingMultiplier) public onlyOwner returns (bool)
    {
        mintingMultiplier = _mintingMultiplier;
        return true;
    }


    function setbattleFees(uint256 _battleFees) public onlyOwner returns(bool)
    {
        battleFees = _battleFees;
        return true;
    }
    
    function setMintTokenFee(uint256 _mintTokenFee) public onlyOwner returns(bool)
    {
        mintTokenFee = _mintTokenFee;
        return true;
    }
    
    
    

    function setBattleReward(uint256 winReward, uint256 looseReward) public onlyOwner returns(bool)
    {
        battleWinReward = winReward;
        battleLooseReward = looseReward;
        return true;
    }

    /**
        * If global halt is off, then this funtion will on it. And vice versa
        * This also change safeguard for token movement status
    */
    function changeGlobalHalt() onlyOwner public returns(bool) {
        if (globalHalt == false){
            globalHalt = true;
        }
        else{
            globalHalt = false;  
        }
        return true;
    }

 

    /**
        * Function to check Ether balance in this contract
    */
    function totalEtherbalanceContract() public view returns(uint256){
        return address(this).balance;
    }


    /**
     * Just in rare case, owner wants to transfer Ether from contract to owner address
     */
    function manualWithdrawEtherAdmin(uint64 Amount) public onlyOwner returns (bool){
        require (address(this).balance >= Amount);
        address(owner).transfer(Amount);
        withdrawnByAdmin = withdrawnByAdmin.add(Amount);
        return true;
    }


}