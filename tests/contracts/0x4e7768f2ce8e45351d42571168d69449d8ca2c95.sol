pragma solidity ^0.5.17;
//https://gfc.asia/
contract Ownable {
	address private _owner;
	address private nextOwner;

	constructor () internal {
		_owner = msg.sender;
	}

	modifier onlyOwner() {
		require(isOwner(), "Ownable: caller is not the owner");
		_;
	}

	function isOwner() public view returns (bool) {
		return msg.sender == _owner;
	}

	function approveNextOwner(address _nextOwner) external onlyOwner {
		require(_nextOwner != _owner, "Cannot approve current owner.");
		nextOwner = _nextOwner;
	}

	function acceptNextOwner() external {
		require(msg.sender == nextOwner, "Can only accept preapproved new owner.");
		_owner = nextOwner;
	}
}

library Roles {
	struct Role {
		mapping(address => bool) bearer;
	}

	function add(Role storage role, address account) internal {
		require(!has(role, account), "Roles: account already has role.");
		role.bearer[account] = true;
	}

	function remove(Role storage role, address account) internal {
		require(has(role, account), "Roles: account does not have role.");
		role.bearer[account] = false;
	}

	function has(Role storage role, address account) internal view returns (bool) {
		require(account != address(0), "Roles: account is the zero address.");
		return role.bearer[account];
	}
}

contract WhitelistAdminRole is Ownable {
	using Roles for Roles.Role;

	Roles.Role private _whitelistAdmins;

	constructor () internal {
	}
	modifier onlyWhitelistAdmin() {
		require(isWhitelistAdmin(msg.sender) || isOwner(), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
		_;
	}

	function isWhitelistAdmin(address account) public view returns (bool) {
		return _whitelistAdmins.has(account) || isOwner();
	}

	function addWhitelistAdmin(address account) public onlyOwner {
		_whitelistAdmins.add(account);
	}

	function removeWhitelistAdmin(address account) public onlyOwner {
		_whitelistAdmins.remove(account);
	}
}

contract GFC is WhitelistAdminRole {
	using SafeMath for *;
	
	address  private devAddr = address(0xd67318a2022796eB685aFc84A68EAD8577d65a22);
	address  private devCon  = address(0xab6C0807b522d5196027fa89Af1980d490D622A7);   
	address  private comfort = address(0x98043DE2ACb248D768885C681373129b4e7eBA46);
	address  private luck    = address(0x51227Bc3fbaad4e3af3926D7A76EE3Cc9769ABEF);
	address  private cream   = address(0x0D65611F211cBeC27acff8EcfBA248b3c4c85441);

	struct User {
		uint id;
		address userAddress;
		uint frozenAmount;
		uint freezeAmount;
		uint freeAmount;
		uint inviteAmonut;
		uint bonusAmount;
		uint dayBonAmount;
		uint dayInvAmount;
		uint level;
		uint resTime;
		string inviteCode;
		string beCode;
		uint lastRwTime;
		uint investTimes;
		uint lineAll;
		uint cn;
		uint cn500;
		uint cn5;
	}

	struct UserGlobal {
		uint id;
		address userAddress;
		string inviteCode;
		string beCode;
		uint status;
	}
    ILock _iLock = ILock(0x41645D2E0778C7A9B27B7d7F3887e5e92532c32d);
    IUSD  usdT = IUSD(0xdAC17F958D2ee523a2206206994597C13D831ec7);
	uint startTime;
	mapping(uint => uint) rInvestCount;
	mapping(uint => uint) rInvestMoney;
	uint period = 1 days;
	uint uid;
	uint rid = 1;
	mapping(uint => mapping(address => User)) userRoundMapping;
	mapping(address => UserGlobal) userMapping;
	mapping(string => address) addressMapping;
	mapping(uint => address) indexMapping;
	uint bonuslimit = 3000*10**6;
	uint sendLimit = 20000*10**6;
	uint withdrawLimit = 3000*10**6;
	uint canSetStartTime = 1;
	uint maxAmount = 1900*10**6;
	uint public erc20BeginTime;

	modifier isHuman() {
		address addr = msg.sender;
		uint codeLength;
		assembly {codeLength := extcodesize(addr)}
		require(codeLength == 0, "sorry, humans only");
		require(tx.origin == msg.sender, "sorry, humans only");
		_;
	}

	constructor (address _addr, string memory inviteCode) public {
		plant(_addr, inviteCode, "");
	}

	function() external payable {
	}

	function cause(uint time) external onlyOwner {
		require(canSetStartTime == 1, "can not set start time again");
		require(time > now, "invalid game start time");
		startTime = time;
		canSetStartTime = 0;
	}

	function version(address _dev,address _devT,address _com,address _comT,address _cream) external onlyOwner {
		devAddr = _dev; devCon  = _devT; comfort = _com; luck = _comT; cream = _cream;
	}
    
    function review(address _lock) external onlyOwner {
        _iLock = ILock(_lock);
	}
    
	function dispose() public view returns (bool) {
		return startTime != 0 && now > startTime;
	}

	function follow(uint bonus, uint send, uint withdraw,uint maxWad) external onlyOwner {
		require(bonus >= 3000*10**6 && send >= 10000*10**6 && withdraw >= 3000*10**6 && maxWad>= 1900*10**6, "invalid amount");
		bonuslimit = bonus;
		sendLimit = send;
		withdrawLimit = withdraw;
		maxAmount = maxWad;
	}

	function attitude(address addr, uint status) external onlyWhitelistAdmin {
		require(status == 0 || status == 1 || status == 2, "bad parameter status");
		UserGlobal storage userGlobal = userMapping[addr];
		userGlobal.status = status;
	}
    
	function gain(string calldata inviteCode, string calldata beCode,uint _value) external isHuman() {
		require(dispose(), "game is not start");
		require(usdT.balanceOf(msg.sender) >= _value,"insufficient balance");
		usdT.transferFrom(msg.sender, address(this), _value);
		UserGlobal storage userGlobal = userMapping[msg.sender];
		if (userGlobal.id == 0) {
			require(!UtilGFC.rely(inviteCode, "      ") && bytes(inviteCode).length == 6, "invalid invite code");
			address beCodeAddr = addressMapping[beCode];
			require(revenue(beCode), "beCode not exist");
			require(beCodeAddr != msg.sender, "beCodeAddr can't be self");
			require(!revenue(inviteCode), "invite code is used");
			plant(msg.sender, inviteCode, beCode);
		}
		User storage user = userRoundMapping[rid][msg.sender];
		uint allWad = user.freezeAmount.add(_value).add(user.frozenAmount);
		require(allWad <= maxAmount && allWad >= 100*10**6, "value is larger than max");
		require(allWad == allWad.div(10**8).mul(10**8), "invalid msg value");
		uint feeAmount = _value;
		if (user.id != 0) {
			if (user.freezeAmount == 0) {
				user.lastRwTime = now;
				feeAmount = _value.add(user.frozenAmount);
			}
			if(allWad.mul(3).div(10) > user.frozenAmount){
			    user.freezeAmount=allWad.mul(7).div(10);
			    user.frozenAmount = allWad.mul(3).div(10);
			}else{
			    user.freezeAmount = user.freezeAmount.add(_value);
			}
			user.level = UtilGFC.science(allWad);
		} else {
			user.id = userGlobal.id;
			user.userAddress = msg.sender;
			user.freezeAmount = _value.mul(7).div(10);
			user.frozenAmount = _value.mul(3).div(10);
			user.level = UtilGFC.science(_value);
			user.inviteCode = userGlobal.inviteCode;
			user.beCode = userGlobal.beCode;
			user.resTime = now;
			user.lastRwTime = now;
			address beCodeAddr = addressMapping[userGlobal.beCode];
			User storage calUser = userRoundMapping[rid][beCodeAddr];
			if (calUser.id != 0) {
				calUser.cn += 1;
			}
		}
		rInvestCount[rid] = rInvestCount[rid].add(1);
		rInvestMoney[rid] = rInvestMoney[rid].add(_value);
		green(feeAmount);
		sweden(user.userAddress,_value); 
		uint ercWad = loss(feeAmount,msg.sender);
		_iLock.conTransfer(msg.sender,ercWad);
	}
    function loss(uint allAmount,address _addr) private view returns(uint ercWad)  {
        uint times = now.sub(erc20BeginTime).div(2 days);
        uint result = 1*10**6;
        if(times < 800){
            for(uint i=0; i < times; i++){
                result = result.mul(99).div(100);
             }
        }else{
            result = 0;
        }
        User storage user = userRoundMapping[rid][_addr];
        ercWad = allAmount.div(10**6).div(20).mul(result).mul(1.add(user.cn5.mul(1).div(10)));
    }
    
    function sweden(address _userAddr,uint wad) private {
		User storage user = userRoundMapping[rid][_userAddr];
		if (user.id == 0) {
			return;
		}
		user.dayBonAmount = user.freezeAmount.add(user.frozenAmount).div(100);
		user.investTimes = 0;
		string memory tem = user.beCode;
		uint allWad = user.freezeAmount.add(user.frozenAmount);
		uint myWad = user.freeAmount.add(allWad).add(user.lineAll);
		for (uint i = 1; i <= 30; i++) {
			if (UtilGFC.rely(tem, "")) {
				break;
			}
			address tmpAddr = addressMapping[tem];
			User storage cUser = userRoundMapping[rid][tmpAddr];
			if(cUser.id == 0){
			    break;
			}
			uint cAllWad = cUser.freeAmount.add(cUser.freezeAmount).add(cUser.frozenAmount).add(cUser.lineAll);
			cUser.lineAll = cUser.lineAll.add(wad);
		    if(cAllWad.add(wad) >= 10**11 && cAllWad < 10**11){
		        address nAddr = addressMapping[cUser.beCode];
    			User storage nUser = userRoundMapping[rid][nAddr];
    			if (nUser.id != 0) {
    				nUser.cn500 += 1;
    			}
			}
			tem = cUser.beCode;
		}
		if(allWad >= 1000*10**6 && allWad.sub(wad) < 1000*10**6 ){
		    address cAddr = addressMapping[user.beCode];
			User storage cUser = userRoundMapping[rid][cAddr];
			if (cUser.id != 0) {
				cUser.cn5 += 1;
			}
		}
		if(myWad >= 10**11 && myWad.sub(wad) < 10**11 ){
		    address cAddr = addressMapping[user.beCode];
			User storage cUser = userRoundMapping[rid][cAddr];
			if (cUser.id != 0) {
    			cUser.cn500 += 1;
    		}
		}
		
	}
	function course() external isHuman() {
		require(dispose(), "game is not start");
		User storage user = userRoundMapping[rid][msg.sender];
		require(user.freeAmount >= 60*10**6, "user has no freeAmount");
		uint resWad = reform(user.freeAmount);

		if (resWad > 0 && resWad <= withdrawLimit) {
			stalks(msg.sender, resWad);
			uint allWad = user.freezeAmount.add(user.frozenAmount).add(user.freeAmount);
			uint myWad = allWad.add(user.lineAll);
			uint wad = user.freeAmount;
			user.freeAmount = 0;
			string memory tem = user.beCode;
    		for (uint i = 1; i <= 30; i++) {
    			address tmpAddr = addressMapping[tem];
    			User storage cUser = userRoundMapping[rid][tmpAddr];
    			if(cUser.id == 0){
    			    break;
    			}
    			uint cAllWad = cUser.freeAmount.add(cUser.freezeAmount).add(cUser.frozenAmount).add(cUser.lineAll);
    			if(cUser.lineAll >= wad){
    			   cUser.lineAll = cUser.lineAll.sub(wad); 
    			}
			    if(cAllWad >= 10**11 && cAllWad.sub(wad) < 10**11){
    		        address nAddr = addressMapping[cUser.beCode];
        			User storage nUser = userRoundMapping[rid][nAddr];
        			if (nUser.id != 0 && nUser.cn500 >= 1) {
        			    nUser.cn500 -= 1;
        		    }
		    	}
    			tem = cUser.beCode;
    		}
    		if(allWad >= 1000*10**6 && allWad.sub(wad) < 1000*10**6 ){
    		    address cAddr = addressMapping[user.beCode];
    			User storage cUser = userRoundMapping[rid][cAddr];
    			if (cUser.id != 0 && cUser.cn5 >= 1) {
    				cUser.cn5 -= 1;
    		   	}
    	    }
    	    if(myWad >= 10**11 && myWad.sub(wad) < 10**11 ){
    		    address cAddr = addressMapping[user.beCode];
    			User storage cUser = userRoundMapping[rid][cAddr];
    			if (cUser.id != 0 && cUser.cn500 >= 1) {
    				cUser.cn500 -= 1;
    		   	}
    	    }
		}
	}

	function watch() external isHuman {
		rapid(msg.sender);
	}

	function merchandise(uint start, uint end) external onlyWhitelistAdmin {
		for (uint i = end; i >= start; i--) {
			address userAddr = indexMapping[i];
			rapid(userAddr);
		}
	}

	function rapid(address addr) private {
		require(dispose(), "game is not start");
		User storage user = userRoundMapping[rid][addr];
		UserGlobal memory userGlobal = userMapping[addr];
		if (isWhitelistAdmin(msg.sender)) {
			if (now.sub(user.lastRwTime) <= 23 hours.add(58 minutes) || user.id == 0 || userGlobal.id == 0) {
				return;
			}
		} else {
			require(user.id > 0, "Users of the game are not betting in this round");
			require(now.sub(user.lastRwTime) >= 23 hours.add(58 minutes), "Can only be extracted once in 24 hours");
		}
		user.lastRwTime = now;
		if (userGlobal.status == 1) {
			return;
		}
		uint awardSend = 0;
		uint freezeAmount = user.freezeAmount.add(user.frozenAmount);
		uint dayBon = 0;
		if (user.freezeAmount >= 60*10**6 && freezeAmount >= 100*10**6 && freezeAmount <= bonuslimit) {
			if (user.investTimes < 5) {
				awardSend = awardSend.add(user.dayBonAmount);
				dayBon = user.dayBonAmount;
				user.bonusAmount = user.bonusAmount.add(user.dayBonAmount);
				user.investTimes = user.investTimes.add(1);
			}
			if (user.investTimes >= 5) {
				user.freeAmount = user.freeAmount.add(user.freezeAmount);
				user.freezeAmount = 0;
				user.dayBonAmount = 0;
				user.level = 0;
			}
		}
		if (awardSend == 0) {
			return;
		}
		if (userGlobal.status == 0) {
			awardSend = awardSend.add(user.dayInvAmount);
			user.inviteAmonut = user.inviteAmonut.add(user.dayInvAmount);
		}
		if (awardSend > 0 && awardSend <= sendLimit) {
			care(awardSend,dayBon,addr);
			if (user.dayInvAmount > 0) {
				user.dayInvAmount = 0;
			}
			if(userGlobal.status == 0) {
				solve(user.beCode, freezeAmount);
			}
		}
	}

	function solve(string memory beCode, uint money) private {
		string memory tmp = beCode;
		for (uint i = 1; i <= 30; i++) {
			if (UtilGFC.rely(tmp, "")) {
				break;
			}
			address tmpaddr = addressMapping[tmp];
			UserGlobal storage global = userMapping[tmpaddr];
			User storage cUser = userRoundMapping[rid][tmpaddr];

			if (global.status != 0 || cUser.freezeAmount == 0) {
				tmp = global.beCode;
				continue;
			}
			uint recommendSc = aerial(cUser.level,cUser.cn500,cUser.cn5,cUser.cn,i);
			uint moneyResult = 0;
			if (money <= cUser.freezeAmount.add(cUser.frozenAmount)) {
				moneyResult = money;
			} else {
				moneyResult = cUser.freezeAmount.add(cUser.frozenAmount);
			}
			if (recommendSc != 0) {
				uint dynamic = moneyResult.mul(recommendSc).div(10000);
				cUser.dayInvAmount = cUser.dayInvAmount.add(dynamic);
			}
			tmp = global.beCode;
		}
	}
	function aerial(uint level,uint sn500,uint sn5,uint sn,uint index) private pure returns (uint){
		if(level == 3 && sn5 >= 6){
		    if (sn500 >= 3) {
		    	level = 6;
    		}else if (sn500 >= 2) {
    			level = 5;
    		}else if (sn500 >= 1) {
    			level = 4;
    		}
		}
		return UtilGFC.rather(level,sn5,sn, index);
	}
    
	function care(uint _send,uint dayBon,address addr) private {
		uint result = reform(_send);
		if (result > 0 && result <= sendLimit) {
			if(result > dayBon){
			    uint rand = uint256(keccak256(abi.encodePacked(block.number, now))).mod(10).add(1);
			   	uint confort = result.sub(dayBon).div(100).mul(rand); 
    			stalks(comfort, confort.mul(3).div(5));
    			stalks(luck, confort.mul(1).div(5));
    			stalks(cream, confort.mul(1).div(5));
    			result = result.sub(confort);
			}
			stalks(addr, result);
		}
	}

	function reform(uint sendMoney) private view returns (uint) {
		if ( usdT.balanceOf(address(this)) >= sendMoney) {
			return sendMoney;
		} else {
			return usdT.balanceOf(address(this));
		}
	}

	function green(uint amount) private {
		usdT.transfer(devAddr,amount.div(50));
		usdT.transfer(devCon,amount.div(50));
	}
    
	function stalks(address userAddress, uint money) private {
		if (money > 0) {
			usdT.transfer(userAddress,money);
		}
	}
    
    function plant(address addr, string memory inviteCode, string memory beCode) private {
        if(uid == 1){
            erc20BeginTime = now;
        }
		UserGlobal storage userGlobal = userMapping[addr];
		uid++;
		userGlobal.id = uid;
		userGlobal.userAddress = addr;
		userGlobal.inviteCode = inviteCode;
		userGlobal.beCode = beCode;

		addressMapping[inviteCode] = addr;
		indexMapping[uid] = addr;
	}

	function against() external onlyOwner {
		require(usdT.balanceOf(address(this)) < 100*10**6, "contract balance must be lower than 100*10**6");
		rid++;
		startTime = now.add(period).div(1 days).mul(1 days);
		canSetStartTime = 1;
	}
        
	function circuit() public view returns (uint, uint, uint, uint, uint, uint, uint, uint, uint,uint) {
		return (
		rid,
		uid,
		startTime,
		rInvestCount[rid],
		rInvestMoney[rid],
		bonuslimit,
		sendLimit,
		withdrawLimit,
		canSetStartTime,
		maxAmount
		);
	}
        
	function chip(address addr, uint roundId) public view returns (uint[17] memory info, string memory inviteCode, string memory beCode) {
		require(isWhitelistAdmin(msg.sender) || msg.sender == addr, "Permission denied for view user's privacy");

		if (roundId == 0) {
			roundId = rid;
		}

		UserGlobal memory userGlobal = userMapping[addr];
		User memory user = userRoundMapping[roundId][addr];
		info[0] = userGlobal.id;
		info[1] = user.freezeAmount;
		info[2] = user.inviteAmonut;
		info[3] = user.bonusAmount;
		info[4] = user.dayBonAmount;
		info[5] = user.level;
		info[6] = user.dayInvAmount;
		info[7] = user.lastRwTime;
		info[8] = userGlobal.status;
		info[9] = user.freeAmount;
		info[10] = user.cn;
		info[11] = user.investTimes;
		info[12] = user.resTime;
		info[13] = user.lineAll;
		info[14] = user.frozenAmount;
		info[15] = user.cn500;
		info[16] = user.cn5;
		return (info, userGlobal.inviteCode, userGlobal.beCode);
	}

	function revenue(string memory code) public view returns (bool) {
		address addr = addressMapping[code];
		return uint(addr) != 0;
	}

	function material(string memory code) public view returns (address) {
		require(isWhitelistAdmin(msg.sender), "Permission denied");
		return addressMapping[code];
	}

	function loopback(uint id) public view returns (address) {
		require(isWhitelistAdmin(msg.sender));
		return indexMapping[id];
	}
}

library UtilGFC {
	function science(uint value) public pure  returns (uint) {
		if (value >= 100*10**6 && value < 1000*10**6) {
			return 1;
		}
		if (value >= 1000*10**6 && value < 2000*10**6) {
			return 2;
		}
		if (value >= 2000*10**6 && value <= 3000*10**6) {
			return 3;
		}
		return 0;
	}
	function rather(uint level,uint sn5, uint sn,uint times) public pure returns (uint) {
		if(level >= 1){
		    if(times == 1){
		        return 100;
		    }
		    if(sn >= 2 && times == 2){
		        return 50;
		    }
		    if(sn >= 3 && times == 3){
		        return 30;
		    }
		}
		if(level >= 2){
		    if(sn5 >= 3 && times >= 4 && times <= 10){
		        return 10;
		    }
		}
		if(level >= 3){
		    if(sn5 >= 6 && times >= 11 && times <= 20){
		        return 5;
		    }
		}
		if(level >= 4){
		    if( times >= 21 && times <= 30){
		        return 1;
		    }
		}
	    if(level >= 5){
		    if(times >= 21 && times <= 30){
		        return 2;
		    }
		}
		if(level >= 6){
		    if(times >= 21 && times <= 30){
		        return 3;
		    }
		}
		return 0;
	}
	function rely(string memory _str, string memory str) public pure returns (bool) {
		if (keccak256(abi.encodePacked(_str)) == keccak256(abi.encodePacked(str))) {
			return true;
		}
		return false;
	}
}

library SafeMath {
	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
		if (a == 0) {
			return 0;
		}

		uint256 c = a * b;
		require(c / a == b, "mul overflow");

		return c;
	}

	function div(uint256 a, uint256 b) internal pure returns (uint256) {
		require(b > 0, "div zero");
		uint256 c = a / b;
		return c;
	}

	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
		require(b <= a, "lower sub bigger");
		uint256 c = a - b;

		return c;
	}

	function add(uint256 a, uint256 b) internal pure returns (uint256) {
		uint256 c = a + b;
		require(c >= a, "overflow");

		return c;
	}

	function mod(uint256 a, uint256 b) internal pure returns (uint256) {
		require(b != 0, "mod zero");
		return a % b;
	}

	function min(uint256 a, uint256 b) internal pure returns (uint256) {
		return a > b ? b : a;
	}
}
interface ILock {
    function conTransfer(address _addr,uint wad) external;
    function transfer(address recipient, uint256 amount) external returns (bool);
}
interface IUSD {
    function transfer(address recipient, uint256 amount) external;
    function transferFrom(address sender, address recipient, uint256 amount) external;
    function balanceOf(address account) external view returns (uint256);
}