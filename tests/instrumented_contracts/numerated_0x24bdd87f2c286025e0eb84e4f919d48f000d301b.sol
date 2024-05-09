1 pragma solidity 0.5.13;
2 
3 //https://www.yineu.me
4 
5 interface Callable {
6 	function tokenCallback(address _from, uint256 _tokens, bytes calldata _data) external returns (bool);
7 }
8 
9 contract Yineu {
10 
11 	uint256 constant private initial_supply = 1e3;
12 	uint256 constant private new_address_supply = 1e3;
13 	uint256 constant private precision = 1e3; 
14 	string constant public name = "Yineu";
15 	string constant public symbol = "YIN";
16 	uint8 constant public decimals = 3;
17 
18     address[] public allAddresses;
19     
20 	struct User {
21 		uint256 balance;
22 		mapping(address => uint256) allowance;
23 	}
24 
25 	struct Info {
26 		uint256 totalSupply;
27 		mapping(address => User) users;
28 		address admin;
29 	}
30 	
31 	Info private info;
32 
33 	event Transfer(address indexed from, address indexed to, uint256 tokens);
34 	event Approval(address indexed owner, address indexed spender, uint256 tokens);
35 
36 	constructor() public {
37 		info.admin = msg.sender;
38 		allAddresses.push(msg.sender);
39 		info.totalSupply = initial_supply;
40 		info.users[msg.sender].balance = initial_supply;
41 	}
42 
43 	function totalSupply() public view returns (uint256) {
44 		return info.totalSupply;
45 	}
46 
47 	function balanceOf(address _user) public view returns (uint256) {
48 		return info.users[_user].balance;
49 	}
50 
51 	function allowance(address _user, address _spender) public view returns (uint256) {
52 		return info.users[_user].allowance[_spender];
53 	}
54 
55 	function allInfoFor(address _user) public view returns (uint256 totalTokenSupply, uint256 userBalance) {
56 		return (totalSupply(), balanceOf(_user));
57 	}
58 	
59 	function approve(address _spender, uint256 _tokens) external returns (bool) {
60 		info.users[msg.sender].allowance[_spender] = _tokens;
61 		emit Approval(msg.sender, _spender, _tokens);
62 		return true;
63 	}
64 
65 	function transfer(address _to, uint256 _tokens) external returns (bool) {
66 		_transfer(msg.sender, _to, _tokens);
67 		return true;
68 	}
69 
70 	function transferFrom(address _from, address _to, uint256 _tokens) external returns (bool) {
71 		require(info.users[_from].allowance[msg.sender] >= _tokens);
72 		info.users[_from].allowance[msg.sender] -= _tokens;
73 		_transfer(_from, _to, _tokens);
74 		return true;
75 	}
76 
77 	function _transfer(address _from, address _to, uint256 _tokens) internal returns (uint256) {
78 		require(balanceOf(_from) >= _tokens);
79 	
80 	    bool isNewUser = info.users[_to].balance == 0;
81 	    
82 		info.users[_from].balance -= _tokens;
83 		uint256 _transferred = _tokens;
84 		info.users[_to].balance += _transferred;
85 		
86 		if(isNewUser && _tokens > 0){
87 		   allAddresses.push(_to);
88 	
89 		    uint256 i = 0;
90             while (i < allAddresses.length) {
91                 uint256 addressBalance = info.users[allAddresses[i]].balance;
92                 uint256 supplyNow = info.totalSupply;
93                 uint256 dividends = (addressBalance * precision) / supplyNow;
94                 uint256 _toAdd = (dividends * new_address_supply) / precision;
95 
96                 info.users[allAddresses[i]].balance += _toAdd;
97                 i += 1;
98             }
99             
100             info.totalSupply = info.totalSupply + new_address_supply;
101 		}
102 		
103 		if(info.users[_from].balance == 0){
104 
105 		    uint256 i = 0;
106             while (i < allAddresses.length) {
107                 uint256 addressBalance = info.users[allAddresses[i]].balance;
108                 uint256 supplyNow = info.totalSupply;
109                 uint256 dividends = (addressBalance * precision) / supplyNow;
110                 uint256 _toRemove = (dividends * new_address_supply) / precision;
111              
112                 info.users[allAddresses[i]].balance -= _toRemove;
113                 i += 1;
114             }
115             
116             info.totalSupply = info.totalSupply - new_address_supply;
117 		}
118 		
119 		emit Transfer(_from, _to, _transferred);
120 				
121 		return _transferred;
122 	}
123 }