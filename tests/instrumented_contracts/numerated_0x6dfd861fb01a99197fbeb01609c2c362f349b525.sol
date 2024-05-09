1 pragma solidity ^0.4.4;
2 contract Owned{
3 	address owner;
4 	function Owned() public{
5 		owner = msg.sender;
6 	}
7 	modifier onlyOwner{
8 		require(msg.sender == owner);
9 		_;
10 	}
11 }
12 contract LumenCoin is Owned{
13 	struct User{
14 		string username;
15 		uint balance;
16 	}
17 	string public TokenName;
18     uint8 public decimals= 18;
19     string public symbol;
20     uint public totalSupply= 22000000000000000000000000;
21     uint public reserve = 8000000000000000000000000;
22     
23     uint256 public sellPrice;
24     uint256 public buyPrice;
25 
26 	function LumenCoin(){
27 	    users[msg.sender].balance = totalSupply;
28         TokenName = "LumenCoin";
29         decimals = 18;
30         symbol = "LNC";
31 	}
32 	mapping (address => User) users;
33 	address[] public userAccounts;
34 	
35 	event userInfo(
36 		string username,
37 		uint balance
38 	);
39 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
40 	/**
41 	function () {
42         //if ether is sent to this address, send it back.
43         throw;
44     }
45 	**/
46 	function setUser(address _address,string _username,uint _balance) public {
47 		var user = users[_address];
48 		user.username = _username;
49 		user.balance = _balance;
50 		
51 		if(owner == _address){
52 		user.balance = totalSupply;    
53 		}
54 		userAccounts.push(_address)-1;
55 		userInfo(_username,_balance);
56 	}
57 	
58 	function getUsers() view public returns(address[]){
59 	return userAccounts;
60 	}
61 	
62 	function getUser(address _address) view public returns(string,uint){
63 		return (users[_address].username,users[_address].balance);
64 	}
65 	function countUsers() view public returns (uint){
66 	userAccounts.length;
67 	}
68 	function transfer(address _to, uint256 _value) onlyOwner returns (bool success) {
69         require (_to != 0x0);
70         require (users[owner].balance >= _value);
71         if (users[owner].balance >= _value && _value > 0) {
72             if(totalSupply <= reserve){
73                 users[owner].balance += totalSupply;
74                 return false;
75             }
76             
77             users[owner].balance -= _value;
78             users[_to].balance += _value;
79             totalSupply -= _value;
80             Transfer(owner, _to, _value);
81             return true;
82         } else { return false; }
83     }
84 	function transferFrom(address _from,address _to, uint256 _value) returns (bool success){
85 	    if (users[_from].balance >= _value && _value > 0){
86 	        users[_from].balance -= _value;
87 	        users[_to].balance += _value;
88 	    }
89 	    return false;
90 	}
91 	function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
92         sellPrice = newSellPrice;
93         buyPrice = newBuyPrice;
94     }
95     
96     function buy() payable public {
97         uint amount = msg.value / buyPrice; 
98         transfer(this, amount);              
99     }
100     
101     function sell(uint256 amount) public {
102         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
103         transferFrom(msg.sender, this, amount);              // makes the transfers
104         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
105     }
106 	
107 }