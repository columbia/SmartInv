1 pragma solidity ^0.4.0;
2 contract Ownable {
3     address public owner;
4 
5     constructor() public {
6         owner = msg.sender;
7     }
8 
9     modifier onlyOwner {
10         require(msg.sender == owner);
11         _;
12     }
13 
14     function transferOwnership(address newOwner) onlyOwner public {
15         owner = newOwner;
16     }
17 }
18 contract LockableToken is Ownable {
19     function totalSupply() public view returns (uint256);
20     function balanceOf(address who) public view returns (uint256);
21     function transfer(address to, uint256 value) public returns (bool);
22     event Transfer(address indexed from, address indexed to, uint256 value);
23     function allowance(address owner, address spender) public view returns (uint256);
24     function transferFrom(address from, address to, uint256 value) public returns (bool);
25     function approve(address spender, uint256 value) public returns (bool);
26     event Approval(address indexed owner, address indexed spender, uint256 value);
27     function approveAndCall(address _spender, uint256 _value, bytes _data) public payable returns (bool);
28     function transferAndCall(address _to, uint256 _value, bytes _data) public payable returns (bool);
29     function transferFromAndCall(address _from, address _to, uint256 _value, bytes _data) public payable returns (bool);
30 }
31 
32 contract Token is Ownable{
33 	LockableToken private token;
34 	string public Detail;
35 	uint256 public SellAmount = 0;
36 	uint256 public WeiRatio = 0;
37 
38 	event TokenAddressChange(address token);
39 	event Buy(address sender,uint256 rate,uint256 value,uint256 amount);
40 
41     function () payable public {
42         buyTokens(msg.sender);
43     }
44     
45 	function tokenDetail(string memory _detail) onlyOwner public {
46 	    Detail = _detail;
47 	}
48 	
49 	function tokenPrice(uint256 _price) onlyOwner public {
50 	    WeiRatio = _price;
51 	}
52 
53 	function tokenAddress(address _token) onlyOwner public {
54 	    require(_token != address(0), "Token address cannot be null-address");
55 	    token = LockableToken(_token);
56 	    emit TokenAddressChange(_token);
57 	}
58 
59 	function tokenBalance() public view returns (uint256) {
60 	    return token.balanceOf(address(this));
61 	}
62 
63     function withdrawEther() onlyOwner public  {
64     	require(address(this).balance > 0, "Not have Ether for withdraw");
65         owner.transfer(address(this).balance);
66     }
67     
68     function withdrawToken() onlyOwner public  {
69     	token.transfer(owner, tokenBalance());
70     }
71 
72 	function buyTokens(address _buyer) private {
73 		require(_buyer != 0x0);
74 		require(msg.value > 0);
75 
76 		uint256 tokens = msg.value * WeiRatio;
77 		require(tokenBalance() >= tokens, "Not enough tokens for sale");
78 		token.transfer(_buyer, tokens);
79 		SellAmount += tokens;
80 
81 		emit Buy(msg.sender,WeiRatio,msg.value,tokens);
82 	}
83 }