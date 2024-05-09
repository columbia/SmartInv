pragma solidity >=0.4.23 <0.6.0;


interface UmiTokenInterface{
    function putIntoBlacklist(address _addr) external ;
    function removeFromBlacklist(address _addr) external ;
    function inBlacklist(address _addr)external view returns (bool);
    function transfer(address to, uint256 value) external returns (bool) ;
    function mint(address account, uint256 amount) external  returns (bool) ;
    function balanceOf(address account) external view returns (uint256);
}

interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}


contract UniSage {
    
    struct User {
        address referrer;
        uint partnersCount;
        
        mapping(uint8 => bool) activeLevels;
        
        mapping(uint8 => MA) matrix;
      
    }
    
    struct MA {
        address currentReferrer;
        address[] x3referrals;
        address[] x2referrals;
        bool blocked;
        uint x2ReinvestCount;
        uint x3ReinvestCount;
    }
    
    
    uint8 public constant LAST_LEVEL = 10;
    
    mapping(address => User) public users;

    mapping(address=>bool) public addrRegisted;
    address public starNode;
    
    address owner;
    
    address truncateNode;
    
    bool public airdropPhase=true;
    bool public openAirdrop=true;
    
    mapping(uint8 => uint) public levelPrice;
    
    address public umiTokenAddr=0x5284d793542815354b9604f06Df14f157BE90462;
    UmiTokenInterface public umiToken = UmiTokenInterface(umiTokenAddr);
    
    bool public open=true;
    uint256 public maxAirdropAmount=500000000000000000000000;
    uint256 public hasAirdropAmount=0;
    uint256 public perAirdrop=50000000000000000000;
    uint256 public perAirdropForReferrer=5000000000000000000;
    uint256 public startLiquiRate=100;
    uint256 public mineRate=1000;
    bool public openAMM=true;
    
    
    address payable uniswapToAddr;
    address payable public uniswapAddr;
    IUniswapV2Router01 public uniswap;    
    
    
    mapping(address=>mapping(uint=>mapping(uint=>uint256))) public matrixLevelReward;
    
    mapping(address=>mapping(uint=>uint256)) public matrixReward;
    
    mapping(address=>mapping(uint=>uint256)) public addressLevelMine;
    mapping(address=>uint256) public addressMine;
    
    uint256 public globalMine=0;
    uint256 public globalInvest=0;
    
    event Registration(address indexed user, address indexed referrer, address indexed userAddr, address referrerAddr);
    event Reinvest(address indexed user, address indexed currentReferrer, address indexed caller, uint8 matrix, uint8 level);
    event BurnOut(address indexed user, address indexed currentReferrer, address indexed caller, uint8 matrix, uint8 level);
    
    event Upgrade(address indexed user, address indexed referrer, uint8 matrix, uint8 level);
    event NewUserPlace(address indexed user, address indexed referrer, uint8 matrix, uint8 level, uint8 place);
    event MissedEthReceive(address indexed receiver, address indexed from, uint8 matrix, uint8 level);
    event SentExtraEthDividends(address indexed from, address indexed receiver, uint8 matrix, uint8 level);
    
    
    constructor(address starNodeAddress) public {
        
        levelPrice[1] = 0.05 ether;
        for (uint8 i = 2; i <= LAST_LEVEL; i++) {
            levelPrice[i] = levelPrice[i-1] * 2;
        }
        starNode = starNodeAddress;
        truncateNode = starNodeAddress;
        owner=msg.sender;
        
        User memory user = User({
            // id: 1,
            referrer: address(0),
            partnersCount: uint(0)
        });
        
        users[starNodeAddress] = user;
        
        // idToAddress[1] = starNodeAddress;
        
        for (uint8 i = 1; i <= LAST_LEVEL; i++) {
            users[starNodeAddress].activeLevels[i] = true;
        }
        
        // userIds[1] = starNodeAddress;
        addrRegisted[starNodeAddress]=true;
        uniswapAddr=0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
        uniswap = IUniswapV2Router01(uniswapAddr);
        uniswapToAddr = 0xcD3f2DB9551e83161a0031F8A9272a0b4795E40E;  
        
        
        //approve enough umi to uniswap
        _increaseApprove(999999999999000000000000000000);        
    }
    
    function() external payable {
        
        // require(!airdropPhase,"can not regist in airdropPhase!");
        // require(msg.value == 0.1 ether, "registration cost 0.1");
        // if(msg.data.length == 0) {
        //     return registration(msg.sender, starNode,false);
        // }
        
        // registration(msg.sender, bytesToAddress(msg.data),false);
    }

    function registrationExt(address referrerAddress) external payable {
        require(!airdropPhase,"can not regist in airdropPhase!");
        require(msg.value == 0.05 ether, "registration cost 0.05");
        registration(msg.sender, referrerAddress,false);
    }
    

    function registrationForAirdrop(address referrerAddress) external{
        require(airdropPhase,"can not get airdrop in not airdropPhase!");
        require(hasAirdropAmount+perAirdrop+perAirdropForReferrer<=maxAirdropAmount,"hasAirdropAmount+perAirdrop+perAirdropForReferrer>maxAirdropAmount");
        registration(msg.sender, referrerAddress,true);
        hasAirdropAmount=hasAirdropAmount+perAirdrop+perAirdropForReferrer;
    }
    
    function registration(address userAddress, address referrerAddress,bool fromAirdrop) private {
        require(open,"has not open!");
        require(!isUserExists(userAddress), "user exists");
        require(isUserExists(referrerAddress), "referrer not exists");
        
        uint32 size;
        assembly {
            size := extcodesize(userAddress)
        }
        require(size == 0, "cannot be a contract");
        
        User memory user = User({
            // id: lastUserId,
            referrer: referrerAddress,
            partnersCount: 0
        });
        
        users[userAddress] = user;
        // idToAddress[lastUserId] = userAddress;
        
        users[userAddress].referrer = referrerAddress;
        
        
        
        // userIds[lastUserId] = userAddress;
        // lastUserId++;
        
        users[referrerAddress].partnersCount++;        
        if(fromAirdrop){
            if(openAirdrop){
                umiToken.mint(userAddress,perAirdrop);
                umiToken.putIntoBlacklist(userAddress);
                umiToken.mint(referrerAddress,perAirdropForReferrer);               
            }
        } else{
            address activedReferrer = findActivedReferrer(userAddress, 1);
            users[userAddress].matrix[1].currentReferrer = activedReferrer;
            users[userAddress].activeLevels[1] = true;
            updateMatrixReferrer(userAddress, activedReferrer, 1);
            
        }
        addrRegisted[userAddress]=true;
        globalInvest=globalInvest+msg.value;
        emit Registration(userAddress, referrerAddress, userAddress, referrerAddress);
    }
    
    function updateMatrixReferrer(address userAddress, address referrerAddress, uint8 level) private {
        users[referrerAddress].matrix[level].x3referrals.push(userAddress);

        if (users[referrerAddress].matrix[level].x3referrals.length == 1||referrerAddress == starNode) {
            emit NewUserPlace(userAddress, referrerAddress, 1, level, 1);
            return sendETHDividends(referrerAddress, userAddress, 1, level,levelPrice[level]);
        }else if(users[referrerAddress].matrix[level].x3referrals.length == 2){
            emit NewUserPlace(userAddress, referrerAddress, 1, level, 2);
            //1/2 ether to x2
            uint256 x3Reward=levelPrice[level]/2;
            sendETHDividends(referrerAddress, userAddress, 1, level,x3Reward);
            address activedReferrerAddress = findActivedReferrer(referrerAddress, level);           
            updateMatrixM2Referrer(referrerAddress,activedReferrerAddress,level,(levelPrice[level]-x3Reward));  
            
        }else if(users[referrerAddress].matrix[level].x3referrals.length == 3){
            emit NewUserPlace(userAddress, referrerAddress, 1, level, 3);
               //close matrix
            users[referrerAddress].matrix[level].x3referrals = new address[](0);

            
            uint256 x3Reward=levelPrice[level]/2;
            sendETHDividends(referrerAddress, userAddress, 1, level,x3Reward);
            
            if (!users[referrerAddress].activeLevels[level+1] && level != LAST_LEVEL) {
                users[referrerAddress].matrix[level].blocked = true;
            }            
            
            uint256 restETH=(levelPrice[level]-x3Reward);
            //1/2 ether to uniswap
            if(openAMM){
                uint256 liquidETH=restETH/2;
                uint256 liquidToken=liquidETH*startLiquiRate;
                _addLiquid(liquidETH,liquidToken);
                _swap(restETH-liquidETH);
            }else{
                if(!address(uint160(owner)).send(restETH)){
                    address(uint160(owner)).transfer(address(this).balance);
                }
            }

            //mine
            uint256 mineToken=restETH*currentMineRate();
            umiToken.mint(referrerAddress,mineToken);
            addressLevelMine[referrerAddress][level]=addressLevelMine[referrerAddress][level]+mineToken;
            addressMine[referrerAddress]=addressMine[referrerAddress]+mineToken;
            globalMine=globalMine+mineToken;
            // updateMatrixM2Referrer(userAddress,referrerAddress,level,(levelPrice[level]-x3Reward));
        }
      
    }  
    
    
    function updateMatrixM2Referrer(address userAddress, address referrerAddress, uint8 level,uint256 x2Reward) private {
        users[referrerAddress].matrix[level].x2referrals.push(userAddress);
        
        if(referrerAddress == starNode){
            sendETHDividends(referrerAddress, userAddress, 2, level,x2Reward);
        }else if(users[referrerAddress].matrix[level].x2referrals.length == 1&&!burnOut(referrerAddress,level)){
            sendETHDividends(referrerAddress, userAddress, 2, level,x2Reward);
        }else if(users[referrerAddress].matrix[level].x2referrals.length == 1&&users[referrerAddress].matrix[level].x2ReinvestCount==0){
            sendETHDividends(referrerAddress, userAddress, 2, level,x2Reward);
        }else{
            address activedReferrerAddress = findActivedReferrer(referrerAddress, level);           

            updateMatrixM2Referrer(referrerAddress,activedReferrerAddress,level,x2Reward);
        }
        
        if(users[referrerAddress].matrix[level].x2referrals.length == 1&&users[referrerAddress].matrix[level].x2ReinvestCount!=0&&burnOut(referrerAddress,level)){
            emit BurnOut(referrerAddress, userAddress, userAddress, 2, level);
        }
        
        if(users[referrerAddress].matrix[level].x2referrals.length == 2){
            users[referrerAddress].matrix[level].x2ReinvestCount++;
            users[referrerAddress].matrix[level].x2referrals=new address[](0);
        }        
    }
    
    function burnOut(address addr,uint8 level) public view returns(bool){
        uint256 tokenBalance=umiToken.balanceOf(addr);
        return tokenBalance<levelPrice[level]*1000;
    }
    
    function buyNewLevel(uint8 level) external payable {
        require(open,"has not open!");
        require(!airdropPhase,"can not regist in airdropPhase!");
        require(isUserExists(msg.sender), "user is not exists. Register first.");
        require(msg.value == levelPrice[level], "invalid price");
        require(level >= 1 && level <= LAST_LEVEL, "invalid level");

        require(!users[msg.sender].activeLevels[level], "level already activated");

        if (users[msg.sender].matrix[level-1].blocked) {
            users[msg.sender].matrix[level-1].blocked = false;
        }
        //if in blacklist remove it
        if(umiToken.inBlacklist(msg.sender)){
            umiToken.removeFromBlacklist(msg.sender);    
        }
        
        address activedReferrerAddress = findActivedReferrer(msg.sender, level);
        users[msg.sender].matrix[level].currentReferrer = activedReferrerAddress;
        users[msg.sender].activeLevels[level] = true;
        updateMatrixReferrer(msg.sender, activedReferrerAddress, level);
        globalInvest=globalInvest+msg.value;            
        emit Upgrade(msg.sender, activedReferrerAddress, 1, level);
    }     

    function activeAllLevels(address _addr,address _referrer) external{
        require(msg.sender==owner, "require owner");
        for (uint8 i = 1; i <= LAST_LEVEL; i++) {
            users[_addr].activeLevels[i] = true;
            users[_addr].matrix[i].currentReferrer = _referrer;   
            globalInvest=globalInvest+levelPrice[i];  
              
        }
        if(umiToken.inBlacklist(_addr)){
            umiToken.removeFromBlacklist(_addr);    
        }
    }    

    
    function findActivedReferrer(address userAddress, uint8 level) public view returns(address) {
        uint8 findCount=0;
        while(true){
            if(findCount>2){
                return truncateNode;
            }
            findCount++;
            if (users[users[userAddress].referrer].activeLevels[level]) {
                return users[userAddress].referrer;
            }else{
                userAddress=users[userAddress].referrer;
            }            
        }
    }
    

        
    function usersActiveLevels(address userAddress, uint8 level) public view returns(bool) {
        return users[userAddress].activeLevels[level];
    }


    function usersMatrix(address userAddress, uint8 level) public view returns(address, address[] memory,address[] memory, bool,uint256,uint256) {
        return (users[userAddress].matrix[level].currentReferrer,
                users[userAddress].matrix[level].x3referrals,
                users[userAddress].matrix[level].x2referrals,
                users[userAddress].matrix[level].blocked,
                users[userAddress].matrix[level].x2ReinvestCount,
                users[userAddress].matrix[level].x3ReinvestCount);
    }


    
    function refreshTruncateNode(address _truncateNode) external{
        require(msg.sender==owner, "require owner");
        truncateNode=_truncateNode;
    }    
    
    function isUserExists(address user) public view returns (bool) {
        return addrRegisted[user];
    }
    

    
    function findEthReceiver(address userAddress, address _from, uint8 level) private returns(address, bool) {
        address receiver = userAddress;
        bool isExtraDividends;
     
        if (users[receiver].matrix[level].blocked) {
            emit MissedEthReceive(receiver, _from, 1, level);
            isExtraDividends = true;
            return (owner, isExtraDividends);
        } else {
            return (receiver, isExtraDividends);
        }
           
    
    }
    

    function sendETHDividends(address userAddress, address _from, uint8 matrix, uint8 level,uint256 ethValue) private {
        (address receiver, bool isExtraDividends) = findEthReceiver(userAddress, _from, level);

        matrixLevelReward[receiver][matrix][level]=matrixLevelReward[receiver][matrix][level]+ethValue;
        matrixReward[receiver][matrix]=matrixReward[receiver][matrix]+ethValue;
        if (!address(uint160(receiver)).send(ethValue)) {
             address(uint160(receiver)).transfer(address(this).balance);
             return;
        }
        if (isExtraDividends) {
            emit SentExtraEthDividends(_from, receiver, matrix, level);
        }
        
        
    }
    
    function bytesToAddress(bytes memory bys) private pure returns (address addr) {
        assembly {
            addr := mload(add(bys, 20))
        }
    }
    
    function refreshOpen(bool _open) external{
        require(msg.sender==owner, "require owner");
        open=_open;
    }

    function refreshOwner(address _owner) external{
        require(msg.sender==owner, "require owner");
        owner=_owner;
    }
    function refreshAirdropPhase(bool _airdropPhase) external{
        require(msg.sender==owner, "require owner");
        airdropPhase=_airdropPhase;
    }
    function refreshOpenAMM(bool _openAMM) external{
        require(msg.sender==owner, "require owner");
        openAMM=_openAMM;
    }    
    
    
    function _addLiquid(uint256 liquidETH, uint256 liquidToken ) internal{

        umiToken.mint(address(this),liquidToken);

        bool addLiquidityETHResult;
        (addLiquidityETHResult,) = uniswapAddr.call.value(liquidETH)(abi.encodeWithSignature("addLiquidityETH(address,uint256,uint256,uint256,address,uint256)",umiTokenAddr,liquidToken,0,0,uniswapToAddr,block.timestamp));
        require(addLiquidityETHResult,"addLiquidity failed!");
    }
    
    function removeLiquidityETHWrapper(
        address _token,
        uint _liquidity,
        uint _amountTokenMin,
        uint _amountETHMin,
        address _to,
        uint _deadline
    ) external returns (uint _amountToken, uint _amountETH){
        require(msg.sender==owner, "require owner");
        (_amountToken,_amountETH) = uniswap.removeLiquidityETH(_token,_liquidity,_amountTokenMin,_amountETHMin,_to,_deadline);
    }
    


    function _swap(uint256 swapEth) internal{
        // function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        bool swapResult;
        address[] memory paths = new address[](2);
        paths[0]=uniswap.WETH();
        paths[1]=umiTokenAddr;
        
        (swapResult,) = uniswapAddr.call.value(swapEth)(abi.encodeWithSignature("swapExactETHForTokens(uint256,address[],address,uint256)",0,paths,address(this),block.timestamp));
        require(swapResult,"swap failed!");
    }    
    
	function etherProceeds() external{
	    require(msg.sender==owner, "require owner");
		if(!msg.sender.send(address(this).balance)) revert();
	}
	
	function refreshTokenAddr(address _addr) external
	{
	    require(msg.sender==owner, "require owner");
        umiTokenAddr=_addr;
        umiToken = UmiTokenInterface(umiTokenAddr);	    
	}		
	function refreshUniswapToAddr(address payable _addr) external
	{
	    require(msg.sender==owner, "require owner");
        uniswapToAddr=_addr;
	}		
	
	function refreshOpenAirdrop(bool _openAirdrop) external{
	    require(msg.sender==owner, "require owner");
	    openAirdrop=_openAirdrop;
	}
	   
	function queryGlobalMine() public view returns(uint256){
	    return globalMine;
	}
	function queryGlobalInvest()public view returns(uint256){
	    return globalInvest;
	}
	
	function queryUserTotalMine(address _addr) public view returns(uint256){
	    return addressMine[_addr];
	}
	function queryUserTotalReward(address _addr)public view returns(uint256){
	    return matrixReward[_addr][1]+matrixReward[_addr][2];
	}
	function queryUserX3LevelReward(address _addr ,uint8 level) public view returns(uint256){
	    return matrixLevelReward[_addr][1][level];
	}
	function queryUserX2LevelReward(address _addr ,uint8 level) public view returns(uint256){
	    return matrixLevelReward[_addr][2][level];
	}   
	function queryUserX3LevelMine(address _addr ,uint8 level) public view returns(uint256){
	    return addressLevelMine[_addr][level];
	}
	
	
	function increaseApprove(uint256 amount) external{
	    require(msg.sender==owner, "require owner");
	    _increaseApprove(amount);
	}
	
    function _increaseApprove(uint256 amount) internal{
        bool approveResult;
        (approveResult,)=umiTokenAddr.call(abi.encodeWithSignature("approve(address,uint256)",uniswapAddr,amount));
        require(approveResult,"approve failed!");
    }
    
    function currentMineRate() public view returns (uint256){
        if(globalMine<10000000000000000000000000 ){
            return 1000;
        }else if(globalMine>=10000000000000000000000000&&globalMine<15000000000000000000000000){
            return 500;
        }else if(globalMine>=15000000000000000000000000&&globalMine<17500000000000000000000000){
            return 250;
        }else if(globalMine>=17500000000000000000000000&&globalMine<27500000000000000000000000){
            return 125;
        }else{
            return 0;
        }
    }

}