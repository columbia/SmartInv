1 pragma solidity ^0.4.11;
2 
3 contract ERC20Interface {
4 	function totalSupply() constant returns (uint supply);
5 	function balanceOf(address _owner) constant returns (uint balance);
6 	function transfer(address _to, uint _value) returns (bool success);
7 	function transferFrom(address _from, address _to, uint _value) returns (bool success);
8 	function approve(address _spender, uint _value) returns (bool success);
9 	function allowance(address _owner, address _spender) constant returns (uint remaining);
10 	event Transfer(address indexed _from, address indexed _to, uint _value);
11 	event Approval(address indexed _owner, address indexed _spender, uint _value);
12 }
13 
14 contract DepositMasterContract {
15 	address myAddress;
16 	address dedeAddress;
17 	address dedeStorageAddress;
18 	mapping (address => bool) isOurContract;
19 
20 	event ContractCreated(address contractAddress);
21 	event Deposited(address indexed contractAddress, address indexed receivingAddress, address indexed token, uint256 value);
22 
23 	modifier onlyMe() {
24 		require(msg.sender == myAddress);
25 		_;
26 	}
27 	modifier onlyDeDe() {
28 		require(msg.sender == dedeAddress);
29 		_;
30 	}
31 	modifier onlyAdmins() {
32 		require(msg.sender == myAddress || msg.sender == dedeAddress);
33 		_;
34 	}
35 
36 	function DepositMasterContract(address _dedeAddress){
37 		dedeAddress = _dedeAddress;
38 		dedeStorageAddress = _dedeAddress;
39 		myAddress = msg.sender;
40 	}
41 
42 	function createContract() onlyDeDe {
43 		address depositContract = new DepositContract();
44 		isOurContract[depositContract] = true;
45 		ContractCreated(depositContract);
46 	}
47 	function sweep(address contractAddress, address token, uint256 mininumValue) onlyDeDe {
48 		require(isOurContract[contractAddress]);
49 		uint256 result = DepositContract(contractAddress).sweep(token, dedeStorageAddress, mininumValue);
50 		if(result > 0){
51 			Deposited(contractAddress, dedeStorageAddress, token, result);
52 		}
53 	}
54 
55 	function changeMyAddress(address newMyAddress) onlyMe {
56 		myAddress = newMyAddress;
57 	}
58 	function changeDeDeAddress(address newDeDeAddress) onlyAdmins {
59 		dedeAddress = newDeDeAddress;
60 	}
61 	function changeDeDeStorageAddress(address newDeDeStorageAddress) onlyAdmins {
62 		dedeStorageAddress = newDeDeStorageAddress;
63 	}
64 }
65 
66 contract DepositContract {
67 	address masterAddress;
68 
69 	modifier onlyMaster() {
70 		require(msg.sender == masterAddress);
71 		_;
72 	}
73 
74 	function DepositContract(){
75 		masterAddress = msg.sender;
76 	}
77 
78 	function sweep(address token, address dedeStorageAddress, uint256 mininumValue) onlyMaster returns (uint256) {
79 		bool success;
80 		uint256 sendingValue;
81 		if(token == address(0)){ // ether
82 			sendingValue = this.balance;
83 			if(mininumValue > sendingValue){
84 				return 0;
85 			}
86 			success = dedeStorageAddress.send(this.balance);
87 			return (success ? sendingValue : 0);
88 		}
89 		else{ // token
90 			sendingValue = ERC20Interface(token).balanceOf(this);
91 			if(mininumValue > sendingValue){
92 				return 0;
93 			}
94 			success = ERC20Interface(token).transfer(dedeStorageAddress, sendingValue);
95 			return (success ? sendingValue : 0);
96 		}
97 	}
98 
99 	function () payable {}
100 }