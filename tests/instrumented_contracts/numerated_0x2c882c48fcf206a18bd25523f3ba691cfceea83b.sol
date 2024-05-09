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
12     mapping(address => bool) public exists;
13     mapping(address => uint) public index;
14     mapping(address => string) public tkname;
15     mapping(address => uint) public decimals;
16 	mapping(address => uint) public rate; //with 18 decimal places
17 	mapping(address => uint) public buyoffer; //in AGAINST
18 	token tokenReward = token(0xF7Be133620a7D944595683cE2B14156591EFe609); // Market Token
19 		
20     string public name = "AGAINST TKDEX";
21     string public symbol = "AGAINST";
22     string public comment = "AGAINST Token Market";
23     address internal owner;
24     uint public indexcount = 0;
25 	
26 	constructor() public {
27        owner = address(msg.sender); 
28     }
29 	
30 	function registerToken(address _token, string _name, uint _decimals, uint _rate, uint _buyoffer) public {
31 	   if (msg.sender == owner) {
32          if (!exists[_token]) {
33             exists[_token] = true;
34             indexcount = indexcount+1;
35             index[_token] = indexcount;
36             active[_token] = false;
37          }	     
38 		 tkname[_token] = _name;
39          decimals[_token] = _decimals;
40 		 rate[_token] = _rate; //with 18 decimal places
41 		 buyoffer[_token] = _buyoffer;	//with 18 decimal places (decimals of token base)	 
42 	   }
43 	}
44 	
45 	function enableToken(address _token) public {
46 	   if (msg.sender == owner) {
47 	      active[_token] = true;
48 	   }
49 	}	
50 	
51 	function disableToken(address _token) public {
52 	   if (msg.sender == owner) {
53 	      active[_token] = false;
54 	   }
55 	}
56 	
57 	function exchangeIt(address _token) public payable {
58 	   require(active[_token],'Token Disabled');
59        token swapToken = token(_token);
60        require(swapToken.allowance(msg.sender, address(this)) > 0);
61        uint tokenAmount = swapToken.allowance(msg.sender, address(this));
62        if (tokenAmount > swapToken.balanceOf(msg.sender)) { tokenAmount = swapToken.balanceOf(msg.sender);}
63        uint amount = (tokenAmount/(10**decimals[_token]))*rate[_token];
64 	   require(amount <= buyoffer[_token],'Too many coins');
65        require(tokenReward.balanceOf(address(this)) >= amount,'No contract Funds');
66        swapToken.transferFrom(msg.sender, owner, tokenAmount);
67 	   buyoffer[_token] = buyoffer[_token]-amount;
68 	   tokenReward.transfer(msg.sender, amount);
69 	}
70 	
71 }