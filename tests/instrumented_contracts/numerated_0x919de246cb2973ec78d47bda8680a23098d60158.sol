1 pragma solidity ^0.4.24;
2   contract SafeMath {
3   function safeMul(uint a, uint b) internal returns (uint) {
4     uint c = a * b;
5     assert(a == 0 || c / a == b);
6     return c;
7   }
8   function safeSub(uint a, uint b) internal returns (uint) {
9     assert(b <= a);
10     return a - b;
11   }
12   function safeAdd(uint a, uint b) internal returns (uint) {
13     uint c = a + b;
14     assert(c>=a && c>=b);
15     return c;
16   }
17   }
18   contract Ownership is SafeMath {
19 	address public fundWallet;
20 	modifier onlyFundWallet {
21         require(msg.sender == fundWallet);
22         _;
23     }
24 	function changeFundWallet(address newFundWallet) external onlyFundWallet {
25         require(newFundWallet != address(0));
26         fundWallet = newFundWallet;
27     }
28 
29 	}    
30   contract Token { // ERC20 standard
31 		function balanceOf(address _owner) public  view returns (uint256 balance);
32 		function transfer(address _to, uint256 _value) public  returns (bool success);
33 		function transferFrom(address _from, address _to, uint256 _value) public  returns (bool success);
34 		function approve(address _spender, uint256 _value)  returns (bool success);
35 		function allowance(address _owner, address _spender) public  view returns (uint256 remaining);
36 		event Transfer(address indexed _from, address indexed _to, uint256 _value);
37 		event Approval(address indexed _owner, address indexed _spender, uint256 _value);
38 	}
39 	
40   contract STCDRListing is Ownership {
41 	string public name = "STCDR Listing";
42 	bool public enable = true;
43 	uint256 public count =0 ;
44 	
45 	// MAPPING
46 	mapping (uint256 => Sendvalue) public receivedEther;
47 		
48 	  // EVENTS
49     event Received(address indexed participant,uint256 amountEther);
50 	event Withdraw(uint256 amountEther);
51 	 
52 	// TYPES
53 	struct Sendvalue { // tokensPerEth
54 		address sender;
55 		uint256 value;
56 	}		
57 	 // CONSTRUCTOR
58 	function STCDRListing() public  {
59         fundWallet = msg.sender;
60     }
61 	function removeLiquidity(uint256 amount) external onlyFundWallet {
62         require(amount <= this.balance);
63         fundWallet.transfer(amount);
64 		Withdraw(amount);
65     }	
66 	function stop() external onlyFundWallet {
67         enable = false;
68     }
69 	function start() external onlyFundWallet {
70         enable = true;
71     }
72 	function() payable {
73 		require(tx.origin == msg.sender);
74 		require(enable);
75 		require(msg.value>0);
76 		count =	safeAdd(count,1);		
77 		receivedEther[count] = Sendvalue(msg.sender,msg.value);
78 		Received(msg.sender,msg.value);
79 	}
80 	function claimTokens(address _token) external onlyFundWallet {
81 			require(_token != address(0));
82 			Token token = Token(_token);
83 			uint256 balance = token.balanceOf(this);
84 			token.transfer(fundWallet, balance);
85 	}	 
86   }