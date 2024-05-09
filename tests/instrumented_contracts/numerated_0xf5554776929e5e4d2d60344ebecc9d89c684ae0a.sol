1 pragma solidity ^0.4.25;
2 
3 contract WisNetwork {
4 	using SafeMath for uint256;
5 
6 	mapping (address => uint256) userDeposit;
7 	mapping (address => uint256) userPartners;
8 	mapping (address => uint256) userWithdraw;
9 	mapping (address => uint256) userBlock;
10 
11 	uint256 public allDeps = 0;
12 	uint256 public allPayment = 0;
13     uint256 public allUsers = 0;
14 	address public constant ownerWallet = 0xb6434dEe1CBF061755C2046150cC0d987a768685;
15 	address public constant ownerWallet2 = 0x62FB5f1fc3B6902f2aD169eC7EE631714aD7bf3A;
16 	address public constant adsWallet = 0x48090A3425E94d124fcbF7604d49C22B3eaf391c;
17 
18 	function() payable external {
19 		uint256 cashAdmin = msg.value.mul(3).div(100);
20 		uint256 cashAdmin2 = msg.value.mul(2).div(100);
21 		uint256 cashAdvert = msg.value.mul(10).div(100);
22 
23         if (msg.value > 0) {if (userDeposit[msg.sender] == 0) {allUsers += 1;}}
24 
25 		adsWallet.transfer(cashAdvert);
26 		ownerWallet.transfer(cashAdmin);
27 		ownerWallet2.transfer(cashAdmin2);
28 
29 		if (userDeposit[msg.sender] != 0) {
30 			address investor = msg.sender;
31 			uint256 depositsPercents = userDeposit[msg.sender].mul(5).div(100).mul(block.number-userBlock[msg.sender]).div(6500);
32 			investor.transfer(depositsPercents);
33 			userWithdraw[msg.sender] += depositsPercents;
34 			allPayment = allPayment.add(depositsPercents);
35 		}
36 
37 		address referrer = bytesToAddress(msg.data); //Wallet partner
38 		if (referrer > 0x0 && referrer != msg.sender) {
39 			referrer.transfer(cashAdmin);
40 			userPartners[referrer] += cashAdmin;
41 		}
42 		
43 		userBlock[msg.sender] = block.number;
44 		userDeposit[msg.sender] += msg.value;
45 		allDeps = allDeps.add(msg.value);
46 	}
47 	function userDepositAdd(address _address) public view returns (uint256) {return userDeposit[_address];} //Depo add
48 	function userPayoutAdd(address _address) public view returns (uint256) {return userWithdraw[_address];} //Payout add
49 	function userDepositInfo(address _address) public view returns (uint256) {
50 		return userDeposit[_address].mul(5).div(100).mul(block.number-userBlock[_address]).div(6500);} //Depo info
51 	function userPartnersInfo(address _address) public view returns (uint256) {return userPartners[_address];} //Partners info
52 	function bytesToAddress(bytes bys) private pure returns (address addr) {assembly {addr := mload(add(bys, 20))}} //BalanceContract
53 }
54 
55 library SafeMath {
56 	function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
57 		if (_a == 0) {return 0;} c = _a * _b;
58 		assert(c / _a == _b);return c;
59 	}
60 	function div(uint256 _a, uint256 _b) internal pure returns (uint256) {return _a / _b;}
61 	function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {assert(_b <= _a);return _a - _b;}
62 	function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {c = _a + _b;assert(c >= _a);return c;}
63 }