1 pragma solidity >= 0.4.24;
2 
3 interface token {
4     function transfer(address receiver, uint amount) external;
5 	function transferFrom(address from, address to, uint value) external;
6     function balanceOf(address tokenOwner) constant external returns (uint balance);
7     function allowance(address _owner, address _spender) constant external returns (uint remaining); 
8 }
9 
10 contract againstTokenTransfer {
11     mapping(address => bool) public active;
12     mapping(address => string) public tkname;
13     mapping(address => uint) public decimals;
14 	mapping(address => uint) public rate; //9 decimal places
15 	mapping(address => uint) public buyoffer; //in AGAINST
16 	token tokenReward = token(0xF7Be133620a7D944595683cE2B14156591EFe609);
17 	
18 	
19     string public name = "AGAINST GR";
20     string public symbol = "AGAINST";
21     string public comment = "AGAINST Graveyard Tokens";
22     address internal owner;
23 	
24 	constructor() public {
25        owner = address(msg.sender); 
26     }
27 	
28 	function registerToken(address _token, string _name, uint _decimals, uint _rate, uint _buyoffer) public {
29 	   if (msg.sender == owner) {
30 	     active[_token] = false;
31 		 tkname[_token] = _name;
32          decimals[_token] = _decimals;
33 		 rate[_token] = _rate; //with 9 decimal places
34 		 buyoffer[_token] = _buyoffer;	//with 18 decimal places	 
35 	   }
36 	}
37 	
38 	function enableToken(address _token) public {
39 	   if (msg.sender == owner) {
40 	      active[_token] = true;
41 	   }
42 	}	
43 	
44 	function disableToken(address _token) public {
45 	   if (msg.sender == owner) {
46 	      active[_token] = false;
47 	   }
48 	}
49 	
50 	function exchangeIt(address _token) public payable {
51 	   require(active[_token],'Token Disabled');
52        token swapToken = token(_token);
53        require(swapToken.allowance(msg.sender, address(this)) > 0);
54        uint tokenAmount = swapToken.allowance(msg.sender, address(this));
55        uint amount = (tokenAmount/(10**decimals[_token]))*(10**9)*rate[_token];
56 	   require(amount <= buyoffer[_token],'Too many coins');
57        require(tokenReward.balanceOf(address(this)) >= amount,'No contract Funds');
58        swapToken.transferFrom(msg.sender, address(this), tokenAmount);
59 	   buyoffer[_token] = buyoffer[_token]-amount;
60 	   tokenReward.transfer(msg.sender, amount);
61        swapToken.transfer(owner, tokenAmount);
62 	}
63 	
64 }