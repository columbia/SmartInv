1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     emit OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 /**
44  * @title ERC20Basic
45  * @dev Simpler version of ERC20 interface
46  * @dev see https://github.com/ethereum/EIPs/issues/179
47  */
48 contract ERC20Basic {
49   function totalSupply() public view returns (uint256);
50   function balanceOf(address who) public view returns (uint256);
51   function transfer(address to, uint256 value) public returns (bool);
52   event Transfer(address indexed from, address indexed to, uint256 value);
53 }
54 
55 
56 /**
57  * @title ERC20 interface
58  * @dev see https://github.com/ethereum/EIPs/issues/20
59  */
60 contract ERC20 is ERC20Basic {
61   function allowance(address owner, address spender) public view returns (uint256);
62   function transferFrom(address from, address to, uint256 value) public returns (bool);
63   function approve(address spender, uint256 value) public returns (bool);
64   function setCrowdsale(address tokenWallet, uint256 amount) public returns (bool);
65   event Approval(address indexed owner, address indexed spender, uint256 value);
66 }
67 
68 contract cDeployer {
69 	function deployCrowdsale(address _tWallet, address _token, address _eWallet, uint _maxETH, address reqBy) public returns (address);
70 }
71 
72 contract tDeployer {
73 	function deployToken(string _tName, string _tSymbol, uint _mint, address _owner) public returns (address);
74 }
75 
76 contract customTkn {
77     function multiTransfer(address[] _to, uint256[] _values) public;
78     function transferFrom(address from, address to, uint256 value) public returns (bool);
79 }
80 
81 contract contractDeployer is Ownable {
82 	
83 	event ContractCreated(address newAddress);
84 	
85     address public tokenAddr;
86 	uint public tokenFee;
87 	uint public crowdsaleFee;
88 	uint public multisendFee;
89 
90 	ERC20 token;
91 	cDeployer cdep;
92 	tDeployer tdep;
93 
94 	function setUp(address _token, address _cdep, address _tdep) public onlyOwner {
95 		tokenAddr = _token;
96 		token = ERC20(tokenAddr);
97 		cdep = cDeployer(_cdep);
98 		tdep = tDeployer(_tdep);
99 	}
100 	function changeTokenFee(uint _amount) public onlyOwner {
101 		tokenFee = _amount;
102 	}
103 	function changeCrowdsaleFee(uint _amount) public onlyOwner {
104 		crowdsaleFee = _amount;
105 	}
106 	function changeMultisendFee(uint _amount) public onlyOwner {
107 		multisendFee = _amount;
108 	}
109 
110 	function deployToken(string _tName, string _tSymbol, uint _mint, address _owner) public returns (address) {
111 		require(token.transferFrom(msg.sender, owner, tokenFee));
112 		emit ContractCreated(tdep.deployToken(_tName, _tSymbol, _mint, _owner));
113 	}
114 	
115 	function deployCrowdsale(address _tWallet, address _token, address _eWallet, uint _maxETH) public returns (address) {
116 		require(token.transferFrom(msg.sender, owner, crowdsaleFee));
117 		emit ContractCreated(cdep.deployCrowdsale(_eWallet, _token, _tWallet, _maxETH, msg.sender));
118 	}
119 
120 
121 	function multiSender(address _token, uint _total, address[] _to, uint[] _amount) public {
122 		require(token.transferFrom(msg.sender, owner, multisendFee));
123 		customTkn er2 = customTkn(_token);
124 		require(er2.transferFrom(msg.sender, this, _total));
125 		er2.multiTransfer(_to, _amount);
126 	}
127 
128 }