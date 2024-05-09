1 pragma solidity ^0.4.2;
2 
3 contract token { function transfer(address receiver, uint amount){  } }
4 
5 contract Aircoins{
6 	struct Coin{
7 		address addr;
8 	}
9 	address owner;
10 	function Aircoins(){
11 		owner = msg.sender;
12 	}
13 
14 	modifier onlyOwner() {
15 		if (msg.sender != owner) throw;
16 		_;
17 	}
18 
19 	function transferOwnership(address newOwner) onlyOwner {
20         owner = newOwner;
21     }
22 
23 
24 
25 	mapping (address => Coin) public coins;
26 	mapping (address => bool) public coinsAdded;
27 	mapping (address => bool) public userAddressAdded;
28 	mapping (address => string) public messages;
29 
30 
31 	address[] public coinsAddresses;
32 	address[] public userAddresses;
33 
34 	function submitCoin(address _addr, string _msg){
35 		if(coinsAdded[_addr]) throw;
36 		Coin memory newCoin;
37 		newCoin.addr = _addr;
38 		coins[_addr] = newCoin;
39 		messages[_addr] = _msg;
40 		coinsAdded[_addr] = true;
41 		coinsAddresses.push(_addr);
42 	}
43 
44 	function registerUser(address _addr){
45 		if(userAddressAdded[_addr]) return;
46 		userAddresses.push(_addr);
47 		userAddressAdded[_addr] = true;
48 	}
49 
50 	function getAllCoins() constant returns (address[]){
51 		return coinsAddresses;
52 	}
53 
54 	function getAllUsers() constant returns (address[]){
55 		return userAddresses;
56 	}
57 
58 	function userCount() constant returns (uint){
59 		return userAddresses.length;
60 	}
61 
62 	function coinsCount () constant returns(uint) {
63 		return coinsAddresses.length;
64 	}
65 	
66 
67 	function registerUsers(address[] _users) onlyOwner {
68 		for(uint i = 0; i < _users.length; ++i){
69 			registerUser(_users[i]);
70 		}
71 	}
72 
73 	function withdrawCoins(address _coinAddr, uint _amount) onlyOwner {
74 		token tokenReward = token(_coinAddr);
75 		tokenReward.transfer(msg.sender,_amount);
76 	}
77 
78 	function distributeCoins(
79 		address _coinAddress,
80 		uint _amountGivenToEachUser,
81 		uint startIndex,
82 		uint endIndex) onlyOwner {
83 		require(endIndex > startIndex);
84 		token tokenReward = token(_coinAddress);
85 		for(uint i = startIndex; i < endIndex;++i){
86 			tokenReward.transfer(userAddresses[i],_amountGivenToEachUser);
87 		}
88 	}
89 }