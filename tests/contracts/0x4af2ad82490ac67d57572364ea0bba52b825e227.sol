/**!
* @mainpage
* @brief     DDL合约文件
* @details  DDL合约逻辑实现文件
* @author     Jason
* @date        2020-9-20
* @version     V1.0
* @copyright    Copyright (c) 2019-2020   
**********************************************************************************
* @attention
* 编译工具: http://remix.ethereum.org
* 编译参数: Enable optimization, EVM Version: petersburg, 默认EVM版本调用address(this).balance时会 throws error invalid opcode SELFBALANCE \n
* 编译器版本：solidity   0.7.0 以上版本
* @par 修改日志:
* <table>
* <tr><th>Date        <th>Version  <th>Author    <th>Description
* <tr><td>2020-9-15  <td>1.0      <td>Jason  <td>创建初始版本
* </table>
*
**********************************************************************************
*/
pragma solidity ^ 0.7.0;

contract DDLClub {
	using SafeMath64 for uint64;
	//Wei转换
	uint64 constant private WEI = 1000000000000000000;

	//Wei转换到 单位：eth*10^2 即 保留小数点后2位
	uint64 constant private WEI_ETH2 = 10000000000000000;

	//Wei转换到 单位：eth*10^4 即 保留小数点后4位
	uint64 constant private WEI_ETH4 = 100000000000000;

	//私网测试地址
	address constant private ROOT_ADDR = 0x5422d363BFBee232382eA65f6a4C0c400b99A6ed;

	address constant private ADMIN_ADDR = 0xa04c077C326C019842fcA35B2Edb74Cd059d8755;
	//操作员地址，由管理员设置
	address private op_addr = 0xeD5830B3cbDdcecB11f8D9F5FC5bfC2DB89dd2Ae;

	uint32 constant private TIME_BASE = 1598889600; //基准时间 2020-09-01 00:00:00

 	uint16 constant private MAX_UINT16 = 65535;
	//高阶人才补助，级差值
	uint16[16] private ADV_ALLOWANCE = [uint16(0),25, 50,75,100,125,150,175,200,225,250,275,300,325,350,375];//高阶人才补助，级差

	// 定义事件
    event ev_join(address indexed addr, address indexed paddr, address indexed refaddr, uint32 sidx, uint32 playid, uint32 nlayer, uint256 _value); //会员参与游戏事件
    event ev_adv_up(address indexed addr,  uint32 playid, uint32 _oldLevel, uint32 _newLevel); //高阶人才升级事件
    event ev_vip_up(address indexed addr,  uint32 playid, uint64 _timestamp, uint32 _ratio); //VIP升级事件
	event ev_set_vip18_bonus(address indexed addr,  uint32 playId, uint16 burnTimes, uint16 slideTimes, uint64 val, string comment); //设置VIP18收益事件
	event ev_bonus(address indexed addr,  uint32 playid,  address indexed saddr,  uint64 val, string comment); //获得收益事件
    event ev_withdraw(address indexed addr,   uint32 playid,  uint256 _value, string comment); //提现
 	event ev_op_setting(address indexed addr, uint32 playid, string comment); //后台操作员设置参数

	//定义会员结构体
	struct Player {
		//在父连接点的位置（0-2）
		uint8 pindex;
		//下一个伞下成员将要存放的位置系统号（0-2）
		uint8 next_idx;
		//高阶身份级别(0:普通,1:初级人才,2:高阶人才,3:一星,4-二星,5-三星,6-四星,7-五星,8-银级,9-金级,10-铂金,11-钻石,12-金钻,13-蓝宝石,14-翡翠级,15-荣誉星钻级)
		uint8 adv_level; 
		//下属2层总会员数
		uint8 m2_count;
		//下属3层总会员数 Number of members on begin 4 floor
		uint8 m3_count;
		//会员当前在VIP级别上的奖金比例 单位：*100
		uint8 vip_ratio;
 
 		//随机认证码，用于中心化系统绑定
		uint16 auth_code;
		//总被烧伤次数
		uint16 burn_times;
		//获得滑落奖金次数
		uint16 slide_times;

		//三个系统高阶人才数
		uint16[3] advN;
		//三个系统上的VIP用户数
		uint16[3] vipN;

		//会员加入时间，相对于基准时间TIME_BASE
		uint32 join_timestamp;
	 	//会员vip升级时间，相对于基准时间TIME_BASE
		uint32 vip_up_timestamp;

		
		//会员代数，从1开始
		uint32 gen_num;
 		//会员伞下层数
		uint32 floors;
		//会员推荐人数
		uint32 ref_num; 

		//会员连接ID，数组下标
		uint32 parent_id;
		//会员推荐人ID，数组下标
		uint32 ref_id;

		//会员伞下团队人数（不包括自己）
		uint32 team_num;

		//下一个伞下成员将要存放的位置
		uint32 next_id;
		//会员子代，三轨
		uint32[3] children;

		//会员已实现收益(1元奖金+直接推荐费) eth*10^4 保留小数点后4位
		uint64 base_earnings;
		//高阶人才补助收益 eth*10^4 保留小数点后4位
		uint64 adv_earnings;
		//会员第18层vip收益 eth*10^4 保留小数点后4位
		uint64 vip18_earnings;
		//会员vip收益 eth*10^4 保留小数点后4位
		uint64 vip_earnings;
		//会员已提现收益 eth*10^4 保留小数点后4位
		uint64 withdraw_earnings;
	}
 
	Player[] players;
	mapping (address => uint32) public playerIdx;
    mapping (uint32 => address) public id2Addr;
 
	/**
	* 获取会员排位信息
	*/
  	function get_player_pos_info(address addr) external view 
  	returns(
  		address parent_addr, //会员连接人地址
  		address ref_addr, //会员推荐人地址
		address children1, //会员子接点1地址
		address children2, //会员子接点2地址
		address children3, //会员子接点3地址
		uint8 adv_level,//高阶身份级别(0-普通,1-高阶人才,2- 一星高阶人才,3-二星高阶人才,4-三星高阶人才,5-四星高阶人才,6-五星高阶人才)
		uint8 vip_ratio,//VIP的奖金比例 单位：*100
		uint8 pindex, //在父连接点的位置（0-2）
		uint8 nextidx, //下一个伞下成员将要存放的位置的系统号（0-2）
		uint32 gen_num, //会员代数，从1开始 
		uint32 nextid,//下一个伞下成员将要存放的位置
		uint32 playerId //会员Id
  		){
	 		uint32 playId = playerIdx[addr];
			if(playId == 0){//如果playId为0, 说明用户不存在
				return(address(0), address(0), address(0), address(0), address(0), 0, 0, 0, 0, 0, 0, 0); //the address have not join the game
			}
			Player storage _p = players[playId];
 			return(id2Addr[_p.parent_id], id2Addr[_p.ref_id], 
 				_p.children[0] > 0 ? id2Addr[_p.children[0]]:address(0), 
 				_p.children[1] > 0 ? id2Addr[_p.children[1]]:address(0), 
 				_p.children[2] > 0 ? id2Addr[_p.children[2]]:address(0), 
 				_p.adv_level,_p.vip_ratio,_p.pindex, _p.next_idx, _p.gen_num, _p.next_id, playId);
	}

	/**
	* 获取会员排位 Id 信息
	*/
  	function get_player_pos_id_info(uint32 playId) external view 
  	returns(
  		uint8 pindex, //在父连接点的位置（0-2）
		uint8 nextidx, //下一个伞下成员将要存放的位置的系统号（0-2）
		uint8 adv_level,//高阶身份级别(0-普通,1-高阶人才,2- 一星高阶人才,3-二星高阶人才,4-三星高阶人才,5-四星高阶人才,6-五星高阶人才)
		uint8 vip_ratio,//VIP的奖金比例 单位：*100
		uint32 gen_num, //会员代数，从1开始 
  		uint32 parentId, //会员连接人Id
  		uint32 refId, //会员推荐人Id
		uint32 children1, //会员子接点1 Id
		uint32 children2, //会员子接点2  Id
		uint32 children3, //会员子接点3  Id
		uint32 nextid,//下一个伞下成员将要存放的位置
		address addr //会员地址
  		){
			if(playId < 1 || playId >= players.length){//说明用户不存在
				return(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, address(0)); //the address have not join the game
			}
			Player storage _p = players[playId];
			addr = id2Addr[playId];
 			return(_p.pindex, _p.next_idx,_p.adv_level,_p.vip_ratio, _p.gen_num, _p.parent_id, _p.ref_id, _p.children[0], _p.children[1], _p.children[2], _p.next_id, addr);
	}

	/**
	* 获取会员总人数
	*/
  	function get_player_count() external view 
  	returns(uint32){
  		return uint32(players.length - 1);
  	}
	/**
	* 获取会员基本信息
	*/
  	function get_player_base_info(address addr) external view 
  	returns(
		uint8 adv_level,//高阶身份级别(0-普通,1-高阶人才,2- 一星高阶人才,3-二星高阶人才,4-三星高阶人才,5-四星高阶人才,6-五星高阶人才)
		uint8 vip_ratio,//VIP的奖金比例 单位：*100
		uint32 ref_num,//会员推荐人数
		uint32 floors, //会员伞下层数
		uint32 playerId, //会员Id
		uint32 team_num,//会员伞下团队人数（不包括自己）
		uint64 join_timestamp //会员加入时间，相对于基准时间TIME_BASE
  		){
	 		uint32 playId = playerIdx[addr];
			if(playId == 0){//如果playId为0, 说明用户不存在
				return(0, 0, 0, 0, 0, 0, 0); //the address have not join the game
			}
			Player storage _p = players[playId];
 			return( _p.adv_level, _p.vip_ratio, _p.ref_num,  _p.floors, playId, _p.team_num, uint64(_p.join_timestamp+TIME_BASE));
	}

	/**
	* 获取会员收益信息
	*/
  	function get_player_earning_info(address addr) external view 
  	returns(
  		uint16 burn_times,//总被烧伤次数
		uint16 slide_times,//获得滑落奖金次数
		uint32 playerId, //会员Id
		uint64 base_earnings, //会员已实现收益(1元奖金+直接推荐费)
		uint64 adv_earnings, //高阶人才补助收益 eth*10^4 保留小数点后4位
		uint64 vip_earnings, //会员vip收益 eth*10^4 保留小数点后4位
		uint64 vip18_earnings, //会员在18层上获得的vip收益 eth*10^4 保留小数点后4位
		uint64 withdraw_earnings//会员已提现收益 eth*10^4 保留小数点后4位
  		){
	 		playerId = playerIdx[addr];
			if(playerId == 0){//如果playId为0, 说明用户不存在
				return(0, 0, 0, 0, 0, 0, 0, 0);
			}
			Player storage _p = players[playerId];
 			return(_p.burn_times, _p.slide_times, playerId, _p.base_earnings, _p.adv_earnings, _p.vip_earnings, _p.vip18_earnings, _p.withdraw_earnings);
	}

	/**
	* 获取会员vip信息
	*/
  	function get_player_vip_info(address addr) external view 
  	returns(
		uint8 ratio,//VIP的奖金比例 单位：*100
		uint16 vip_num1,//第一条线VIP人数
		uint16 vip_num2,//第二条线VIP人数
		uint16 vip_num3,//第三条线VIP人数
		uint32 playerId, //会员Id
		uint64 vipearnings,//在VIP级别上获得的收益 单位：eth*10000
		uint64 vip18earnings,//在18层上获得的收益 单位：eth*10000
		uint64 vip_up_timestamp //会员vip升级时间，相对于基准时间TIME_BASE
  		){
	 		playerId = playerIdx[addr];
			if(playerId == 0){//如果playId为0, 说明用户不存在
				return(0, 0, 0, 0, 0, 0, 0, 0); //the address have not join the game
			}
			Player storage _p = players[playerId];
 			return(_p.vip_ratio, _p.vipN[0], _p.vipN[1], _p.vipN[2], playerId, _p.vip_earnings, _p.vip18_earnings, _p.vip_up_timestamp == 0 ? 0: uint64(_p.vip_up_timestamp+TIME_BASE));
	}

	/**
	* 获取高阶会员信息
	*/
  	function get_player_adv_info(address addr) external view 
  	returns(
		uint8 level,//高阶身份级别(0-普通,1-高阶人才,2- 一星高阶人才,3-二星高阶人才,4-三星高阶人才,5-四星高阶人才,6-五星高阶人才)
		uint8 m2_count,//下属2层总会员数
		uint8 m3_count,//下属3层总会员数
		uint16 advN1,//第一条线上高阶人才数
		uint16 advN2,//第二条线上高阶人才数
		uint16 advN3,//第三条线上高阶人才数
		uint32 playerId //会员Id
  		){
	 		playerId = playerIdx[addr];
			if(playerId == 0){//如果playId为0, 说明用户不存在
				return(0, 0, 0, 0, 0, 0, 0); //the address have not join the game
			}
			Player storage _p = players[playerId];
 			return( _p.adv_level, _p.m2_count, _p.m3_count, _p.advN[0], _p.advN[1],  _p.advN[2], playerId);
	}
 
	constructor() public {
		Player memory _player = Player({
            parent_id: 0,
            ref_id:0, 
	 		join_timestamp: uint32(block.timestamp-TIME_BASE),
            gen_num: 1,
         	floors: 0,
            team_num: 0,
            ref_num: 0,
            burn_times: 0,
            slide_times: 0,
            next_id: 1,
            next_idx: 0,
            pindex: 0,
            m2_count: 0,
            m3_count: 0,
            adv_level: 0,
            vip_ratio:0,
            auth_code:0,
            advN:[uint16(0),0,0],
			vipN:[uint16(0),0,0],
         	children:[uint32(0),0,0],
			vip_up_timestamp:0,
			base_earnings: 0,
			adv_earnings: 0,
			vip_earnings:0,
			vip18_earnings:0,
			withdraw_earnings: 0
        });
		//加入根节点
		players.push(_player);
		players.push(_player); //多复制一次，目的是使第一个元素的数组下标为1，ID也为1，方便后面的逻辑判断
		uint32 playerId = uint32(players.length - 1);
		playerIdx[ROOT_ADDR] = playerId;
		id2Addr[playerId] = ROOT_ADDR;
		//sn2Id[_player.player_sn] = playerId;
	}
	
 	fallback() external {
	}
	receive() payable external {
	   //currentBalance = address(this).balance + msg.value;
	}
	//function() payable external{ }
	modifier onlyAdmin() {
		require(msg.sender == ADMIN_ADDR);
		_;
	}
	modifier onlyOperator() {
		require(msg.sender == op_addr);
		_;
	}
 
 	/**
	* 设置操作员,由管理员操作
	* opAddr 操作员地址
	*/
	function setOperator(address opAddr) public onlyAdmin{
		op_addr = opAddr;
	}
	/**
	* 获取操作员地址
	*/
	function getOperator() external view onlyOperator returns(
		address addr
	){
		return op_addr;
	}
	/*
	function grand() internal view returns(uint16) {
        uint256 random = uint256(keccak256(abi.encode(block.timestamp)));
        return uint16(10000+random%50000);
    }*/

	/**
	* 参与游戏
	* refaddr：推荐人地址
	* paddr：接点人地址(指定为推荐人地址则自动分配)
	*/
	function join(address refaddr, address paddr) public payable 
	returns(
		uint32 playerId
	){
		require(msg.value/WEI_ETH2 == 25 , "Amount is invalid");//激活金额为0.25个ETH

		playerId = playerIdx[msg.sender];
 		require(playerId == 0 , "You are already registered");//激活金额为0.25个ETH

		uint8 status;
		uint8 index;
		uint32 refId;
		uint32 parentId;
        uint32 nextid;

		(refId, parentId, index, status) = calc_player_pos_info(refaddr, paddr);
		if(status == 1) revert("Parent has no free connect points");
		if(status == 2) revert("The parent does not exist");
		require(players[parentId].children[index] == 0 , "parent is invalid");//确保父节点上的点位没有被占位
		require(players[parentId].gen_num < 4294967295 , "gen_num is too large");//确保层深不会溢出
		require(players.length < 4294967295 , "The number exceeds the limit");//42亿
		//require(parentId != 0 , "Parent is invalid!");//确保父节点上的点位没有被占位
		//uint16 authcode = grand();

		playerId = uint32(players.length);
		//函数中声明并创建结构体需要使用memory关键字
		Player memory _player = Player({
            parent_id: parentId,
         	ref_id: refId,
            next_id: playerId,
            next_idx: 0,
	 		join_timestamp: uint32(block.timestamp-TIME_BASE),
            gen_num: players[parentId].gen_num+1,
            floors: 0,
            team_num: 0,
            ref_num: 0,
            burn_times: 0,
            slide_times: 0,
            pindex: index,
            m2_count: 0,
            m3_count: 0,
            adv_level: 0,
           	vip_ratio:0,
            auth_code:0,
            advN:[uint16(0),0,0],
			vipN:[uint16(0),0,0],
         	children:[uint32(0),0,0],
			vip_up_timestamp:0,
			base_earnings: 0,
			adv_earnings: 0,
			vip_earnings:0,
			vip18_earnings:0,
			withdraw_earnings: 0
        });
		players.push(_player);
		//playerId = uint64(players.length - 1);
		playerIdx[msg.sender] = playerId;
		id2Addr[playerId] = msg.sender;
		players[parentId].children[index] = playerId;
 		//修改推荐人数
		players[refId].ref_num++;
  		
  		//直接推荐费 0.075ETH
		players[refId].base_earnings = players[refId].base_earnings.add(750);
  		
		join_calc(_player, parentId);
		emit ev_join(msg.sender, id2Addr[parentId], id2Addr[refId], index, playerId, _player.gen_num, msg.value); //触发会员参与游戏事件
		 
		return playerId;
	}


	function join_calc(Player memory _player, uint32 parentId) internal{
		uint8 tidx;
  		uint8 advLevel;
  		uint16 advNum;
  		uint32 nlayers;
 		uint32 nextid;
  		uint64 diff;
  		Player storage _p;
  		Player storage _tplayer;
  		for(uint32 i=_player.gen_num; i>1; i--){
			_p = players[parentId];
			//往上计算每个父点位的  下一个伞下成员将要存放的位置
			 _tplayer = players[_p.next_id];
 
			if(_tplayer.gen_num > 0 && _tplayer.children[_p.next_idx] > 0){ //被占用
				uint8 nextidx = (_p.next_idx+1) % 3;
				if(_tplayer.children[nextidx] > 0){
					nextidx = (nextidx+1) % 3; //排位占用，继续找
					if(_tplayer.children[nextidx] > 0) nextidx = 3; //说明该位置的3个子节点都放满，需要另外找一个空闲位置
				}
				if(nextidx > 2){
					//取3个孩子伞下 下一个成员将要存放的位置 和当前节点层差最小的 做为本节点的下一个位置
					uint32 uNext0 = players[_p.children[0]].next_id;
					uint32 uNext1 = players[_p.children[1]].next_id;
					uint32 uNext2 = players[_p.children[2]].next_id;
					nextid = players[uNext0].gen_num > players[uNext1].gen_num ? uNext1 : uNext0;
					nextid = players[nextid].gen_num > players[uNext2].gen_num ? uNext2 : nextid;
					nextidx = players[nextid].next_idx;
					_p.next_id = nextid;
				}
				_p.next_idx = nextidx;
			}


			if(advNum > 0){
				if(MAX_UINT16 - _p.advN[tidx] > advNum) _p.advN[tidx]+=advNum; //父节点这条线上的高阶人才数增加,溢出检查
				else _p.advN[tidx] = MAX_UINT16;

				if(_p.adv_level > 1){
					advLevel = get_adv_level(_p.advN);
					if(_p.adv_level != advLevel){
						emit ev_adv_up(id2Addr[parentId], parentId, _p.adv_level, advLevel); //高阶人才升级
						_p.adv_level = advLevel;	
					}
				}
			}
			//父点位团队人数加1，显示用，溢出不管
			_p.team_num++; 

			//计算收益
			//1 元奖金 拿自己伞下 18 层
			if(_player.gen_num - _p.gen_num < 19){
				//_p.base_earnings = _p.base_earnings.add(uint64(msg.value/WEI_ETH4 / 100));
				_p.base_earnings = _p.base_earnings.add(uint64(msg.value/WEI_ETH2));
			}
			//高阶人才补助
			if(_p.adv_level > 0){
				if(ADV_ALLOWANCE[_p.adv_level] > diff){
					_p.adv_earnings = _p.adv_earnings.add(ADV_ALLOWANCE[_p.adv_level] - diff);
					//emit ev_bonus(id2Addr[parentId], parentId, msg.sender, ADV_ALLOWANCE[_p.adv_level] - diff, "adv allowance"); //获得收益事件
					diff = ADV_ALLOWANCE[_p.adv_level];
				}
			}

			nlayers = _player.gen_num - _p.gen_num;
			//高阶人才前3层人数判断
			if(nlayers < 4){
				_p.m3_count++; //只记录伞下3层内的会员数，用于高阶升级判断
				if(nlayers < 3) _p.m2_count++;
				if( _p.m2_count >=12 && _p.adv_level == 0){
					 _p.adv_level = 1; //成为初级人才
					 emit ev_adv_up(id2Addr[parentId], parentId, 0, 1); //人才升级
				}
				if(_p.m3_count >=39 && _p.adv_level == 1){
					 _p.adv_level = 2; //成为高阶人才
					 emit ev_adv_up(id2Addr[parentId], parentId, 1, 2); //高阶人才升级
					 advNum ++;
					 tidx = _p.pindex;
				}

				if(_p.adv_level > 1){
					advLevel = get_adv_level(_p.advN);
					if(_p.adv_level != advLevel){
						emit ev_adv_up(id2Addr[parentId], parentId, _p.adv_level, advLevel); //高阶人才升级
						_p.adv_level = advLevel;	
					}
				}
			}
			//计算会员伞下层数
			if(nlayers > _p.floors) {
				_p.floors = nlayers;
			}
			parentId = _p.parent_id;
  		}
	}
	/**
	* 激活钻石vip系统
	* 返回值： 成功返回true
	*/
	function active_vip() public payable 
	returns(
		bool bOk
	){
		//for test comment
		require(msg.value/WEI_ETH2 == 10, "Amount is invalid.");
		
		uint32 playId = playerIdx[msg.sender];
		require(playId > 0, "You have not registered");
 
		require(players[playId].vip_ratio == 0, "The vip system has been activated");

		Player storage _p = players[playId];
		//_p.vip_level = 1;
		_p.vip_up_timestamp = uint32(block.timestamp-TIME_BASE);
		_p.vip_ratio=get_vip_ratio(_p.vipN);
 		uint8 ratio;
		uint32 gnum = _p.gen_num;
		uint32 parentId = _p.parent_id;
		uint64 diff;
		uint64 val = uint64(msg.value / WEI_ETH2);
		while(gnum > 1){

			//这条线VIP人数增加
			if(players[parentId].vipN[_p.pindex] < MAX_UINT16){
				players[parentId].vipN[_p.pindex] += 1;
			}
 			_p = players[parentId];

 			//计算VIP 系统奖励 
			if(_p.vip_ratio > diff){
				_p.vip_earnings = _p.vip_earnings.add(val*(_p.vip_ratio-diff)); //这里不用再除100，因为前面val 已多除100， vip_earnings 的单位是 eth * 10^4
				diff = _p.vip_ratio;
				//emit ev_bonus(id2Addr[parentId], id2Addr[playId], val*(_p.vip_ratio-diff), "vip up"); //获得收益事件
			}
			if(_p.vip_ratio > 0){ //自己必须先激活VIP
				ratio=get_vip_ratio(_p.vipN); //根据各条线的人数，设置奖金比例
				if(ratio != _p.vip_ratio){
					_p.vip_ratio = ratio;
					//emit ev_vip_up(id2Addr[parentId], parentId, uint64(_p.vip_up_timestamp+TIME_BASE), _p.vip_ratio); //Vip升级事件
				}
			}
			parentId = _p.parent_id;
			gnum --;
  		}
  		emit ev_vip_up(id2Addr[playId], playId, uint64(players[playId].vip_up_timestamp+TIME_BASE),players[playId].vip_ratio); //Vip升级事件
	}
	/**
	* 根据节点VIP 人数，确定收益比例
	* 返回值：收益比例 单位: *100
	*/
	function get_vip_ratio(uint16[3] memory nVipN) internal pure returns (uint8){
		uint16 nmin = min16(nVipN[0], nVipN[1], nVipN[2]);
		uint16 n;
		if(nVipN[0] > 0) n += 1;
		if(nVipN[1] > 0) n += 1;
		if(nVipN[2] > 0) n += 1;
		if(n < 3){
			if(n == 0) return 20;
			if(n == 1) return 25;
			if(n == 2) return 30;
		}else{
			if(nmin < 20) return 35; //三个下属系统中都有会员成功升级成为⾦级VIP会员。
			if(nmin < 50) return 40;  //数量最少的⼀个系统达到了20个但小于50
 			if(nmin < 100) return 45;
			if(nmin < 500) return 50;
			if(nmin < 1000) return 60;
			if(nmin < 10000) return 70;
			else return 70;
		}
	}

	/**
	* 根据节点高阶人才数 ，确定高阶等级
	* 返回值：高阶身份级别(0:普通,1:初级人才,2:高阶人才,3:一星,4-二星,5-三星,6-四星,7-五星,8-银级,9-金级,10-铂金,11-钻石,12-金钻,13-蓝宝石,14-翡翠级,15-荣誉星钻级)
	*/
	function get_adv_level(uint16[3] memory nAdvN) internal pure returns (uint8){
		uint16 nmin = min16(nAdvN[0], nAdvN[1], nAdvN[2]);
		uint16 n;
		if(nAdvN[0] > 0) n += 1;
		if(nAdvN[1] > 0) n += 1;
		if(nAdvN[2] > 0) n += 1;
		if(n < 3){
			if(n == 0) return 2;
			if(n == 1) return 3;
			if(n == 2) return 4;
		}else{
			if(nmin < 10) return 5; //3星高阶人才，三条线各培养一个高阶人才及以上等级
			if(nmin < 30) return 6;
			if(nmin < 60) return 7;
			if(nmin < 100) return 8;
			if(nmin < 500) return 9;
			if(nmin < 1000) return 10;
			if(nmin < 5000) return 11;
			if(nmin < 10000) return 12;
			if(nmin < 100000) return 13;
			if(nmin < 1000000) return 14;
			else return 15;
		}
	}

	/**
	* 根据确定点位, refaddr 为推荐人地址， paddr为接点人地址(可选，指定为推荐人地址则自动分配)
	* 返回值：refId为推荐人Id, parentId为连接人Id，index 为在连接人children的数组索引，status: 0正常，1接点人没有空位，2接点人不存在
	*/
	function calc_player_pos_info(address refaddr, address paddr) internal view
	returns (
		uint32 refId,
        uint32 parentId,
        uint8 index,
        uint8 status
    ){
    	if(refaddr == address(0)){
			refId = playerIdx[ROOT_ADDR];
		}else{
			refId = playerIdx[refaddr]; //如果refaddr没参与游戏，那么refId自动为0，
		}
	 	if(paddr == refaddr){
			paddr = id2Addr[refId];
			parentId = playerIdx[paddr];
		}else{//指定接点人，就必须直接接到他下面
			parentId = playerIdx[paddr]; 
			if(parentId == 0){//如果paddr没参与游戏, 返回
				return (0, 0, 0, 2);
			}
			if(players[parentId].children[0] == 0) index = 0;
			else if(players[parentId].children[1] == 0) index = 1;
			else if(players[parentId].children[2] == 0) index = 2;
			else status = 1;//接点人没有空闲位
			return (refId, parentId, index, status);  
		}
  		parentId = players[parentId].next_id;
		if(players[parentId].children[0] == 0) index = 0;
		else if(players[parentId].children[1] == 0) index = 1;
		else if(players[parentId].children[2] == 0) index = 2;
		else status = 1; //不合法的parent? 永远不会发生
		return (refId, parentId, index, status);
	}
   
	/**
	* 提现,全部提现
	*/
	function withdraw()
	public {
		uint32 playId = playerIdx[msg.sender];
		require(playId > 0, "You have not registered");
 		//uint256 wval = val*WEI_ETH2;
		Player storage _p = players[playId];
		uint256  totalEarnings = uint256(_p.base_earnings) + _p.adv_earnings + _p.vip_earnings  + _p.vip18_earnings;//总收益,   单位eth*10^4
		require(_p.withdraw_earnings <= totalEarnings);
		 
		uint256 undrawnEarnings = totalEarnings - _p.withdraw_earnings;//未提现余额 = 总收益-减已提现收益
		totalEarnings = undrawnEarnings*WEI_ETH4; //将单位eth*10^4 转换为wei
		require(totalEarnings / undrawnEarnings == WEI_ETH4, "undrawn earnings invalid"); //转换合法性检查

		//require(totalEarnings >= wval, "Not enough balance."); //余额检查
		require(address(this).balance >= totalEarnings, "Contract is not enough balance.");//合约余额检查
        
        uint64 withdrawVal = uint64(undrawnEarnings);
        
		_p.withdraw_earnings = _p.withdraw_earnings.add(withdrawVal); //先扣除
		msg.sender.transfer(totalEarnings);
		//触发提现事件
		emit ev_withdraw(msg.sender, playId, withdrawVal, "player");
	}


	/**
	* 管理员提现
	* val: 要提现的额度，单位eth*10^2
	*/
	function withdraw_admin(uint256 val) public payable onlyAdmin{
		val = val * WEI_ETH2; //将单位eth*10^2 转换为wei
		require(val <= address(this).balance, "Not enough balance.");
		address(uint160(ADMIN_ADDR)).transfer(val);
		//触发提现事件
		emit ev_withdraw(ADMIN_ADDR, 0, val,"admin");
	}

 	function min16(uint16 a, uint16 b, uint16 c) internal pure returns (uint16) {
        uint16	d =  a > b ? b : a;
		return d > c ? c : d;
    }

	/**
	* 设置会员18层vip收益,由中心化管理员操作
	* playId 会员Id
	* val： 18层总收益，单位 ETH * 10^4
	* burnTimes： 被烧伤次数
	* slideTimes： 获得滑落奖金次数
	*/
	function op_set_vip18_earnings(uint32 playId, uint64 val, uint16 burnTimes, uint16 slideTimes) external onlyOperator{
		require(id2Addr[playId] != address(0), "playId have not registered");
		Player storage _p = players[playId];
		_p.vip18_earnings = val;
	 	_p.slide_times = slideTimes; //滑落次数
		_p.burn_times = burnTimes; //烧伤次数
		emit ev_set_vip18_bonus(id2Addr[playId], playId, burnTimes, slideTimes, val, "set vip18 earnings"); //设置VIP收益事件
 	}

	 /**
	* 设置会员排位参数, 由管理员操作
	* playId  会员Id
	* nextid 下一个伞下成员将要存放的位置
	* nextidx： 下一个伞下成员将要存放的位置系统号（0-2）
	*/
	function op_set_next_param(uint32 playId, uint32 nextid, uint8 nextidx) external onlyOperator{
		require(id2Addr[playId] != address(0), "playId have not registered");
		Player storage _p = players[playId];	
		_p.next_id=nextid;
		_p.next_idx=nextidx;
		emit ev_op_setting(msg.sender, playId, "set next param"); //后台操作员设置参数
 	}
	//设置会员收益,该接口正常用不到，需以管理员身份调用
	function op_set_earnings_param(uint32 playId,  uint64 baseEarnings, uint64 advEarnings, uint64 vipEarnings, uint64 vip18Earnings, uint64 withdrawEarnings) external onlyAdmin{
		require(id2Addr[playId] != address(0), "playId have not registered");
		Player storage _p = players[playId];	
		 _p.base_earnings=baseEarnings;
		 _p.adv_earnings=advEarnings;
		 _p.vip_earnings=vipEarnings;
		 _p.vip18_earnings=vip18Earnings;
		 _p.withdraw_earnings=withdrawEarnings;
		 emit ev_op_setting(msg.sender, playId, "set earnings param"); //后台操作员设置参数
 	}
	//设置会员在各条线上的VIP、高阶人才人数, 该接口正常用不到，需以操作员身份调用
	function op_set_N_param(uint32 playId,  uint16[3] memory advN, uint16[3] memory vipN) external onlyOperator{
		require(id2Addr[playId] != address(0), "playId have not registered");
		Player storage _p = players[playId];	
		 _p.vipN[0] = vipN[0];
		 _p.vipN[1] = vipN[1];
		 _p.vipN[2] = vipN[2];

		 _p.advN[0] = advN[0];
		 _p.advN[1] = advN[1];
		 _p.advN[2] = advN[2];
		 emit ev_op_setting(msg.sender, playId, "set N param"); //后台操作员设置参数
 	}

	/**
	* 获取会员认证码
	*/
	function get_authcode(address addr) external view onlyAdmin returns (uint16) {
		uint32 playId = playerIdx[addr];
		require(playId > 0, "The address have not registered");
		return players[playId].auth_code;
 	}

	/**
	* 设置会员认证码
	*/
	function set_authcode(uint16 authcode) external{
		uint32 playId = playerIdx[msg.sender];
		require(playId > 0, "The address have not registered");
		players[playId].auth_code = authcode;
 	}
	/**
	* 认证
	*/
	function auth(address addr, uint16 authcode) external view returns(bool){
		uint32 playId = playerIdx[addr];
		if(playId == 0) return false;
		if(authcode == 0) return false;
		return authcode == players[playId].auth_code ? true : false;
	}
}

library SafeMath64 {
    function mul(uint64 a, uint64 b) internal pure returns (uint64) {
        if (a == 0) {
            return 0;
        }
        uint64 c = a * b;
        require(c / a == b);
        return c;
    }
    function sub(uint64 a, uint64 b) internal pure returns (uint64) {
        require(b <= a);
        uint64 c = a - b;
        return c;
    }
    function add(uint64 a, uint64 b) internal pure returns (uint64) {
        uint64 c = a + b;
        require(c >= a);
        return c;
    }
}