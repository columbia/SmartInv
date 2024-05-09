1 /// @title Public Token Register - Allows to register coins and get it from another contract.
2 /// @author Global Group - <globalinvestplace@gmail.com>
3 pragma solidity ^0.4.24;
4 
5 contract IPublicTokenRegister {
6 	function securityReg(address _securityWallet) public;
7 	function registerCoin(string _name,string _symbol, address coinTokenContract) public;
8 	function getSymbol(string _coin) public view returns(string _symbol);
9 	function getCoinAddress(string _coin) public view returns(address _coinTokenContract);
10 	function getHexSymbol(string _coin) public view returns(bytes4 _hexSymbol);
11 	function getIsCoinReg(string _coin) public view returns(bool _isReg);
12 	function getCoinInfo(string _coin) public view returns(string _symbol, address coinAddress, bytes4 _hexSymbol, bool _isReg);
13 	function getIsSecurityWalletReg(address _wallet) public view returns(bool _isReg);
14 
15 	event RegisterCoin(string _coin, string _name, string _symbol, address _coinTokenContract);
16 	event SecurityReg(address _securityWallet, bool isRegistered);
17 }
18 
19 contract Ownable {
20 	address public owner;
21 	
22 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
23 
24 	constructor() public {
25 		owner = msg.sender;
26 	}
27 
28 	modifier onlyOwner() {
29 		require(msg.sender == owner);
30 		_;
31 	}
32 
33 	function transferOwnership(address newOwner) public onlyOwner {
34 		require(newOwner != address(0));
35 		emit OwnershipTransferred(owner, newOwner);
36 		owner = newOwner;
37 	}
38 }
39 
40 contract PublicTokenRegister is IPublicTokenRegister, Ownable {
41 	mapping(string => Coin) internal coin;
42 	mapping(address => bool) internal registeredSecurity;
43 	address[] internal registeredCoins;
44 	
45 	modifier onlySecurity {
46 		require(registeredSecurity[msg.sender] == true);
47 		_;
48 	}
49     
50     // STRUCTS
51 	struct Coin {
52 		string symbol;
53 		address coinTokenContract;
54 		bytes4 hexSymbol;
55 		bool isReg;
56 	}
57 
58     function() public payable {
59 		revert();
60     }
61     
62     constructor() public {
63     }
64     
65     function registerCoin(string _name, string _symbol, address _coinTokenContract) public onlySecurity {
66 		require(coin[_name].isReg == false);
67 		bytes4 _hexSymbol = convertStringToBytes(_name);
68         coin[_name] = Coin ({
69             symbol: _symbol,
70             coinTokenContract: _coinTokenContract,
71             hexSymbol: _hexSymbol,
72             isReg: true
73         });
74         registeredCoins.push(_coinTokenContract);
75 		
76 		emit RegisterCoin(_name, _name, _symbol, _coinTokenContract);
77     }
78 	
79 	function removeCoin(string _name) public onlyOwner {
80 		require(coin[_name].isReg == true);
81 		coin[_name] = Coin({
82 			symbol: "",
83 			coinTokenContract: 0x0,
84 			hexSymbol: 0x0,
85 			isReg: false
86 		});
87 	}
88 	
89 	function securityReg(address _securityWallet) public onlyOwner {
90 		require(registeredSecurity[_securityWallet] == false);
91 		registeredSecurity[_securityWallet] = true;
92 		emit SecurityReg(_securityWallet, true);
93 	}
94 	
95 	function getSymbol(string _coinName) public view returns(string _symbol) {
96 		return coin[_coinName].symbol;
97 	}
98 	
99 	function getHexSymbol(string _coinName) public view returns(bytes4 _hexSymbol) {
100 		return coin[_coinName].hexSymbol;
101 	}
102 	
103    	function getCoinAddress(string _coinName) public view returns(address _coinTokenContract) {
104 		return coin[_coinName].coinTokenContract;
105 	}
106 	
107 	function getIsCoinReg(string _coinName) public view returns(bool _isCoinReg) {
108 		return coin[_coinName].isReg;
109 	}
110 	
111 	function getCoinInfo(string _coinName) public view returns(string _symbol, address coinAddress, bytes4 _hexSymbol, bool _isReg) {
112 		return (getSymbol(_coinName),getCoinAddress(_coinName),getHexSymbol(_coinName),getIsCoinReg(_coinName));
113 	}
114 	
115 	function getIsSecurityWalletReg(address _wallet) public view returns(bool _isReg) {
116 		return registeredSecurity[_wallet];
117 	}
118 	
119     function convertStringToBytes(string memory source) internal pure returns (bytes4 result) {
120         bytes memory tempEmptyStringTest = bytes(source);
121         if (tempEmptyStringTest.length == 0) {
122             return 0x0;
123         }
124         assembly {
125             result := mload(add(source, 32))
126         }
127     }
128 }