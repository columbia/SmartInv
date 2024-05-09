1 pragma solidity 0.5.4;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 contract IERC20 {
8     function transfer(address to, uint256 value) external returns (bool);
9 
10     function approve(address spender, uint256 value) external returns (bool);
11 
12     function transferFrom(address from, address to, uint256 value) external returns (bool);
13 
14     function totalSupply() external view returns (uint256);
15 
16     function balanceOf(address who) external view returns (uint256);
17 
18     function allowance(address owner, address spender) external view returns (uint256);
19 
20     function claimEcoSystemReservePart1() public;
21 
22     function claimEcoSystemReservePart2() public;
23 
24     function recoverToken(address _token) public;
25 
26     function claimTeamReserve() public;
27 
28     event Transfer(address indexed from, address indexed to, uint256 value);
29 
30     event Approval(address indexed owner, address indexed spender, uint256 value);
31 }
32 
33 
34 
35 /**
36  * @title The Multisig contract contains functions to transfer ETH and LYMPO tokens.
37  * @author Roman Holovay
38  */
39 contract Multisig {
40 	struct WithdrawEtherStruct {
41 		address payable toAddr;
42 		uint amount;
43 		address[] confirmators;
44 		bool completed;
45 	}
46 	
47 	struct SendTokensStruct {
48 		address toAddr;
49 		uint amount;
50 		address[] confirmators;
51 		bool completed;
52 	}
53 	
54 	IERC20 public token;
55 
56 	WithdrawEtherStruct[] public withdrawEther;
57 	SendTokensStruct[] public sendTokens;
58 
59 	uint public confirmationCount;
60 	mapping(address => bool) public owners;
61 
62 	modifier onlyOwners { 
63 		require(owners[msg.sender]); 
64 		_; 
65 	}
66 	
67 	constructor(address _tokenAddress, address[] memory _addresses, uint _confirmationCount) public {
68 		require(_addresses.length >= _confirmationCount && _confirmationCount > 1);
69 		
70 		for (uint i = 0; i < _addresses.length; i++){
71 			owners[_addresses[i]] = true;
72 		}
73 		
74 		token = IERC20(_tokenAddress);
75 
76 		confirmationCount = _confirmationCount;
77 	}
78 
79 	/**
80      * @dev changeTokenAddress changing token address only when it is not set yet.
81      * @param _tokenAddress New token address.
82      */
83 	function changeTokenAddress(address _tokenAddress) public  {
84 		require (owners[msg.sender]);
85 		require (token == IERC20(address(0)));
86 		token = IERC20(_tokenAddress);
87 	}
88 	
89     
90     /**
91      * @dev createNewEtherWithdrawRequest creates a new ETH transfer request
92      * @param _toAddr The addresses that will receive ETH.
93      * @param _amount The number of ETH that can be received.
94      */
95 	function createNewEtherWithdrawRequest(address payable _toAddr, uint _amount) public onlyOwners {
96 		address[] memory conf;
97 		withdrawEther.push(WithdrawEtherStruct(_toAddr, _amount, conf, false));
98 		withdrawEther[withdrawEther.length-1].confirmators.push(msg.sender);
99 	}
100 	
101 	/**
102      * @dev approveEtherWithdrawRequest approve already created ETH transfer request.
103      * This function can be used only by one of owners.
104      * @param withdrawEtherId means position of withdrawEther array.
105      */
106 	function approveEtherWithdrawRequest(uint withdrawEtherId) public onlyOwners {
107 	    require(!withdrawEther[withdrawEtherId].completed);
108 	    
109 	    for (uint i = 0; i < withdrawEther[withdrawEtherId].confirmators.length; i++) {
110 	        require (msg.sender != withdrawEther[withdrawEtherId].confirmators[i]);
111 	    }
112 	    
113 	    withdrawEther[withdrawEtherId].confirmators.push(msg.sender);
114 	    
115 	    if (withdrawEther[withdrawEtherId].confirmators.length >= confirmationCount) {
116 	        withdrawEther[withdrawEtherId].completed = true;
117 	        withdrawEther[withdrawEtherId].toAddr.transfer(withdrawEther[withdrawEtherId].amount);
118 	    }
119 	}
120 	
121 	/**
122      * @dev createTransferTokensRequest creates a new Token transfer request
123      * @param _toAddr The addresses that will receive tokens.
124      * @param _amount The number of tokens that can be received.
125      */
126 	function createTransferTokensRequest(address _toAddr, uint _amount) public onlyOwners {
127 	    address[] memory conf;
128 		sendTokens.push(SendTokensStruct(_toAddr, _amount, conf, false));
129 		sendTokens[sendTokens.length-1].confirmators.push(msg.sender);
130 	}
131 	
132 	/**
133      * @dev approveEtherWithdrawRequest approve already created ETH transfer request.
134      * This function can be used only by one of owners.
135      * @param sendTokensId means position of sendTokens array.
136      */
137 	function approveTransferTokensRequest(uint sendTokensId) public onlyOwners {
138 	    require(!sendTokens[sendTokensId].completed);
139 	    
140 	    for (uint i = 0; i < sendTokens[sendTokensId].confirmators.length; i++) {
141 	        require(msg.sender != sendTokens[sendTokensId].confirmators[i]);
142 	    }
143 	    
144 	    sendTokens[sendTokensId].confirmators.push(msg.sender);
145 	    
146 	    if (sendTokens[sendTokensId].confirmators.length >= confirmationCount) {
147 	       sendTokens[sendTokensId].completed = true;
148 	       token.transfer(sendTokens[sendTokensId].toAddr, sendTokens[sendTokensId].amount);
149 	    }
150 	}
151 
152 	function claimTeamReserve() public onlyOwners {
153         token.claimTeamReserve();
154     }
155 
156     function claimEcoSystemReservePart1() public onlyOwners {
157     	token.claimEcoSystemReservePart1();
158     }
159 
160     function claimEcoSystemReservePart2() public onlyOwners {
161     	token.claimEcoSystemReservePart2();
162     }
163 
164     function recoverToken(address _token) public onlyOwners {
165     	token.recoverToken(_token);
166     }
167 }