// SPDX-License-Identifier: MIT

pragma solidity 0.7.1;

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
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
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;
        return c;
    }

}

contract ERC20 {
    using SafeMath for uint256;

    string public name;
    string public symbol;
    uint256 public totalBurnValue;
    uint256 _totalSupply;
    uint256 _totalDevSupply;
    uint256 public devSupply;
    uint8 public constant decimals = 18;
    uint256 public constant distSupply = 100 * (10**6) * 10**decimals;   // 100m tokens for distribution
    uint256 public constant devSupplyCap = 5 * (10**6) * 10**decimals;   // 5m tokens for community distribution
    bool public hardCapAchieved;

    mapping(address => uint256) _balances;
    mapping(address => uint256) _burnBalances;

    mapping(address => mapping(address => uint256)) _allowances;
    mapping(address => mapping(address => uint256)) _burnAllowances;

    event Purchase(address indexed from, uint256 ethValue, uint256 tokenValue);
    event Claim(address indexed from, uint256 ethValue);
    event Burn(address indexed from, uint256 tokenValue);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event CommunityTransfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed TokenOwner, address indexed spender, uint256 value);
    event burnApproval(address indexed TokenOwner, address indexed spender, uint256 value);

    function totalSupply() public virtual view returns (uint256) {
        return _totalSupply;
    }

    function totalDevSupply() public virtual view returns (uint256) {
        return _totalDevSupply;
    }

    function balanceOf(address account) public virtual view returns (uint256) {
        return _balances[account];
    }

    function burnBalanceOf(address account) public virtual view returns (uint256) {
        return _burnBalances[account];
    }

    function transfer(address recipient, uint256 amount) public virtual returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address TokenOwner, address spender) public virtual view returns (uint256) {
        return _allowances[TokenOwner][spender];
    }

    function burnAllowance(address TokenOwner, address spender) public virtual view returns (uint256) {
        return _burnAllowances[TokenOwner][spender];
    }

    function approve(address spender, uint256 value) public virtual returns (bool) {
        _approve(msg.sender, spender, value);
        return true;
    }

    function approveBurn(address spender, uint256 value) public virtual returns (bool) {
        _approveBurn(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public virtual returns (bool) {
        require(_allowances[sender][msg.sender] >= amount,"Insufficient balance in delegation.");

        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
        return true;
    }

    function burnFrom(address sender, uint256 amount) public virtual returns (bool) {
        require(_burnAllowances[sender][msg.sender] >= amount,"Insufficient balance in delegation.");

        _burn(sender, amount);
        _approveBurn(sender, msg.sender, _burnAllowances[sender][msg.sender].sub(amount));
        return true;
    }

    function _transfer(address sender,address recipient,uint256 amount) internal{
        require(sender != address(0), "Invalid sender address.");
        require(recipient != address(0), "Invalid recipient address.");
        require(_balances[sender] >= amount, "Insufficient balance.");
        require(amount >0, "Invalid transfer amount.");

        _balances[sender] = _balances[sender].sub(amount);
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "Invalid recipient address.");
        require(hardCapAchieved==false, "New tokens cannot be generated as contract hardcap is over.");

        if (_totalSupply.add(amount) >= distSupply) {
            if (_totalSupply.add(amount) > distSupply) {
                amount = distSupply.sub(_totalSupply); // calculate difference
            }
            hardCapAchieved=true; // no more mint is allowed
        }

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);

        if (devSupply != devSupplyCap) {
            if (_totalSupply.div(10) < devSupplyCap) 
                devSupply = _totalSupply.div(10); // devSupply capped at 10% of totalSupply
            else
                devSupply = devSupplyCap;
        }
        
        emit Transfer(address(0), account, amount);
    }

    function _mintForCommunity(address account, uint256 amount) internal {
        require(account != address(0), "Invalid recipient address.");
        require(amount >0,"Please specefiy the amount of coins to be minted.");
        require(devSupply > _totalDevSupply, "No Balance is left in community bucket for distribution.");

        if (_totalDevSupply.add(amount) > devSupply) {
            amount = devSupply.sub(_totalDevSupply); // calculate difference
        }

        _totalDevSupply = _totalDevSupply.add(amount);
        _balances[account] = _balances[account].add(amount);

        emit CommunityTransfer(address(0), account, amount);
    }

    function _burn(address account, uint256 value) internal {
        require(account != address(0), "Invalid account address.");
        require(hardCapAchieved==true, 'Burn is allowed only after the contract hardcap is achieved.');
        require(_balances[account] >= value, "Insufficient balance.");

        _totalSupply = _totalSupply.sub(value);
        _balances[account] = _balances[account].sub(value);
        _burnBalances[account] = _burnBalances[account].add(value);
        totalBurnValue = totalBurnValue.add(value);

        emit Transfer(account, address(0), value);
        emit Burn(account,value);
    }

    function _approve(address TokenOwner,address spender,uint256 value) internal {
        require(TokenOwner != address(0),"Invalid sender address.");
        require(spender != address(0), "Invalid recipient address.");

        _allowances[TokenOwner][spender] = value;
        emit Approval(TokenOwner, spender, value);
    }

    function _approveBurn(address TokenOwner,address spender,uint256 value) internal {
        require(TokenOwner != address(0),"Invalid sender address.");
        require(spender != address(0), "Invalid recipient address.");

        _burnAllowances[TokenOwner][spender] = value;
        emit burnApproval(TokenOwner, spender, value);
    }
}

contract NBTCToken is ERC20 {
    address OwnerAddress;
    uint256 public hardCapValidTime;

    modifier isOwner() {
        require(msg.sender == OwnerAddress);
        _;
    }

    modifier isContractActive(){
        require(hardCapAchieved == false,"Contract is currently inactive as hardCap period/volume is over.");
        _;
    }

    function checkHardCap() public  {
        if (block.timestamp > hardCapValidTime && hardCapAchieved==false) {
            hardCapAchieved=true; // no more mint is allowed
        }
    }

    constructor() {
        OwnerAddress=msg.sender;
        hardCapAchieved=false;
        _totalSupply=0;
        totalBurnValue=0;
        devSupply=0;
    } 
}

contract ReentrancyGuard {
  bool private reentrancyLock = false;
  
  modifier nonReentrant() {
    require(!reentrancyLock);
    reentrancyLock = true;
    _;
    reentrancyLock = false;
  }
}

contract NBTC is NBTCToken,ReentrancyGuard {
    using SafeMath for uint256;

    mapping (address => User) public users;
    mapping (uint8 => Slab) public mulfact;
    mapping (uint8 => uint8) public levelComm;
    mapping (uint8 => uint256) public levelVolume;

    uint256 public totalUsers;
    uint8 public mfIndex;

    struct User {
        uint8 level;
        uint256 directVolume;
        uint256 indirectVolume;
        uint32 directCount;
        uint32 indirectCount;
        uint256 claimed;  
        address parent;
        uint256 ethBalance; 
        uint256 ethInvest;
    }

    struct Slab {
        uint256 saleVolume;
        uint16 mulFactor;
    }

    constructor(string memory cName, string memory cSymbol,uint256 expireSeconds) {
        name=cName;
        symbol=cSymbol;

        levelComm[1] = 50;
        levelComm[2] = 60;
        levelComm[3] = 65;
        levelComm[4] = 70;
        levelComm[5] = 75;
        levelComm[6] = 80;
        levelComm[7] = 85;
        levelComm[8] = 90;
        levelComm[9] = 95;
        levelComm[10] = 100;

        levelVolume[1] = 0;
        levelVolume[2] = 1000 * 10**decimals; // 1k tokens
        levelVolume[3] = 10000 * 10**decimals; // 10k lakh tokens
        levelVolume[4] = 100000 * 10**decimals; // 1 lakh tokens
        levelVolume[5] = 200000 * 10**decimals; // 2 lakh tokens
        levelVolume[6] = 400000 * 10**decimals; // 4 lakh tokens
        levelVolume[7] = 800000 * 10**decimals; // 8 lakh tokens
        levelVolume[8] = 1600000 * 10**decimals; // 16 lakh tokens
        levelVolume[9] = 3200000 * 10**decimals; // 32 lakh tokens
        levelVolume[10] = 6400000 * 10**decimals; // 64 lakh tokens
        
        mulfact[1] = Slab({ saleVolume: 500000 * 10**decimals, mulFactor: 500 }); // 5 lakh token, 0.5 mil
        mulfact[2] = Slab({ saleVolume: 2500000 * 10**decimals, mulFactor: 300 }); // 25 lakh token, 2.5 mil
        mulfact[3] = Slab({ saleVolume: 5000000 * 10**decimals, mulFactor: 250 }); // 50 lakh token, 5 mil
        mulfact[4] = Slab({ saleVolume: 10000000 * 10**decimals, mulFactor: 200 }); // 1 cr token, 10 mil
        mulfact[5] = Slab({ saleVolume: 20000000 * 10**decimals, mulFactor: 175 }); // 2 cr token, 20 mil,
        mulfact[6] = Slab({ saleVolume: 30000000 * 10**decimals, mulFactor: 150 }); // 3 cr token, 30 mil
        mulfact[7] = Slab({ saleVolume: 40000000 * 10**decimals, mulFactor: 125 }); // 4 cr token, 40 mil
        mulfact[8] = Slab({ saleVolume: 50000000 * 10**decimals, mulFactor: 100 }); // 5 cr token, 50 mil,
        mulfact[9] = Slab({ saleVolume: 100000000 * 10**decimals, mulFactor: 50 }); // 10 cr token, 100 mil

        mfIndex=1;
        totalUsers=0;

        hardCapValidTime = block.timestamp.add(expireSeconds);  // expire in one day ie in 86400 seconds

        users[OwnerAddress] = User({
        level: 10,
        directVolume: 0,
        indirectVolume: 0,
        directCount:0,
        indirectCount:0,
        claimed:0,
        parent: OwnerAddress,
        ethBalance:0,
        ethInvest:0
        });
    }

    modifier userRegistered() {
        require(users[msg.sender].level != 0, 'User does not exist');
        _;
    }

    /* Dont accept eth*/  
    receive() external payable {
        revert("The contract does not accept direct payment, please use the purchase method with a referral address.");
    }

    function mintForCommunity(address account, uint256 amount) public isOwner {
        _mintForCommunity(account,amount) ;
    }

    function burn(uint256 amount) public returns (bool) {
        require(balanceOf(msg.sender) >= amount,'Insufficient tokens to burn');
        require(hardCapAchieved == true,"You can not burn token as hardcap is not achieved.");       

        _burn(msg.sender, amount);
        return true;
    }

    function withdraw(uint256 amount) external userRegistered nonReentrant{
        require(users[msg.sender].ethBalance >=amount,'insufficient balance for withdrawl.');
        require(amount > 0,'Invalid withdrawal amount.');
    
        users[msg.sender].ethBalance = users[msg.sender].ethBalance.sub(amount);
        users[msg.sender].claimed = users[msg.sender].claimed.add(amount);
        (bool success,  ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed.");
        emit Claim(msg.sender,amount);
    }

    function purchase(address refAddress) external payable isContractActive {
        require(refAddress != address(0), 'Referral Address is mandatory.');
        require(users[refAddress].level != 0, 'Referral Address is not registered.');
        require(msg.value >=100000000000000000,'Minimum purchase amount is 0.1 eth');
        require(msg.value <=100000000000000000000,'Maximum purchase amount is 100 eth.');

        bool isNewUser= false;
        uint256 tokenVol;

        uint commLeft;
        uint commPer;
        uint commGiven;
        uint comm;
        uint commVal;
        address userAddr;
        address parentAddr;

        tokenVol= gettokenCount(msg.value); //msg.value.mul(100);

        if (users[msg.sender].level == 0) {
            register(refAddress);
            isNewUser = true;
        }
        else
            require(refAddress == users[msg.sender].parent, "Sender belongs to different referral address");

        _mint(msg.sender, tokenVol);

        // update eth balance and reserve 75 % 
        users[msg.sender].ethInvest = users[msg.sender].ethInvest.add(msg.value);
        commLeft=100;
        commGiven=0;
        userAddr=msg.sender;

        //distribute eth to parent heirarchy until level10
        while (commLeft > 0) {
            parentAddr=users[userAddr].parent;
            commPer=levelComm[users[parentAddr].level];  // commission percentage at parent level
            comm=commPer.sub(commGiven);              // comm to give  
            commGiven=commGiven.add(comm);
            commVal= msg.value.mul(comm).div(100);
            users[parentAddr].ethBalance=users[parentAddr].ethBalance.add(commVal);
            commLeft = commLeft.sub(comm);
            userAddr=parentAddr;
        }
        
        parentAddr=users[msg.sender].parent;

        // add Volume to immediate parent node
        users[parentAddr].directVolume=users[parentAddr].directVolume.add(tokenVol);
        upgradelevel(parentAddr);
        
        //upgrade level and volume of the heirarchy till top node
        userAddr = parentAddr;
        
        while (userAddr !=users[parentAddr].parent)
        {
            parentAddr=users[userAddr].parent;
            users[parentAddr].indirectVolume=users[parentAddr].indirectVolume.add(tokenVol);
            if (isNewUser)
                users[parentAddr].indirectCount+=1;
            upgradelevel(parentAddr);
            userAddr=parentAddr;
        }

        checkHardCap();
        emit Purchase(msg.sender,msg.value,tokenVol);
    }

    function upgradelevel(address refAddr) internal
    {
            uint256 totVolume;
            uint8 idx;
            
            totVolume = users[refAddr].directVolume.add(users[refAddr].indirectVolume);
            idx =users[refAddr].level;

            while (idx <=10)
            {
                if(totVolume >= levelVolume[idx]) 
                    users[refAddr].level = idx;  
                else    
                    break;

                idx++;
            }
    }

    function register(address refAddr) internal
    {
        users[msg.sender] = User({
            level: 1,
            directVolume: 0,
            indirectVolume: 0,
            directCount:0,
            indirectCount:0,
            claimed:0,
            parent: refAddr,
            ethBalance:0,
            ethInvest:0
        });
        
        users[refAddr].directCount+=1;
        totalUsers=totalUsers.add(1);
    }
    
    function estimateTokenCount(uint256 ethVal) public view returns (uint256) {
        require(ethVal >=100000000000000000,'Minimum estimation value is 0.1 ethereum.');
        require(ethVal <=100000000000000000000,'Maximum estimation value is 100 ethereum.');

        uint16 mf;
        uint256 tokenCnt;
        uint256 postSupply;
        uint256 diff;
        uint256 ethUsed;
        uint256 ethLeft;
        
        mf = mulfact[mfIndex].mulFactor;
        tokenCnt=ethVal.mul(mf);
        postSupply=_totalSupply.add(tokenCnt);

        if (postSupply > mulfact[mfIndex].saleVolume && mfIndex !=9)
        {
            diff = mulfact[mfIndex].saleVolume.sub(_totalSupply);
            ethUsed= diff.div(mf);
            ethLeft = ethVal.sub(ethUsed);
            mf = mulfact[mfIndex+1].mulFactor;
            tokenCnt=diff.add(ethLeft.mul(mf));
            postSupply=_totalSupply.add(tokenCnt);
        }

        if (postSupply >distSupply) {
            tokenCnt = distSupply.sub(_totalSupply);
        }
        return tokenCnt;
    }

    function gettokenCount(uint256 ethVal) internal returns (uint256) {
        uint16 mf;
        uint256 tokenCnt;
        uint256 postSupply;
        uint256 diff;
        uint256 ethUsed;
        uint256 ethLeft;
        
        mf = mulfact[mfIndex].mulFactor;
        tokenCnt=ethVal.mul(mf);
        postSupply=_totalSupply.add(tokenCnt);

        if (postSupply > mulfact[mfIndex].saleVolume && mfIndex !=9)
        {
            diff = mulfact[mfIndex].saleVolume.sub(_totalSupply);
            ethUsed= diff.div(mf);
            ethLeft = ethVal.sub(ethUsed);
            mf = mulfact[mfIndex+1].mulFactor;
            tokenCnt=diff.add(ethLeft.mul(mf));
            postSupply=_totalSupply.add(tokenCnt);
            mfIndex +=1;
        }

        if (postSupply >distSupply) {
            tokenCnt = distSupply.sub(_totalSupply);
        }
        return tokenCnt;
    }

    function calculateEthValue(uint256 tokenVal) public view returns (uint256) {
        require(tokenVal >=5000000000000000000,'Minimum estimation value is 5 nbtc tokens.');
        require(tokenVal <=50000000000000000000000,'Maximum estimation value is 50000 nbtc tokens.');

        uint16 mf;
        uint256 ethVal;
        uint256 postSupply;
        uint256 diff;
        uint256 ethUsed;
        uint256 tokenLeft;
        
        mf = mulfact[mfIndex].mulFactor;
        ethVal=tokenVal.div(mf);
        postSupply=_totalSupply.add(tokenVal);

        if (postSupply > mulfact[mfIndex].saleVolume && mfIndex !=9) {
            diff = mulfact[mfIndex].saleVolume.sub(_totalSupply);
            ethUsed= diff.div(mf);
            tokenLeft = tokenVal.sub(diff);
            mf = mulfact[mfIndex+1].mulFactor;
            ethVal= ethUsed.add(tokenLeft.div(mf));
        }
        
        return ethVal;
    }
}