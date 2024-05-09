1 contract Token {
2     event Transfer(address indexed from, address indexed to, uint256 value);
3     function transfer(address _to, uint256 _value);
4     function balanceOf(address) returns (uint256);
5 }
6 
7 contract owned {
8     address public owner;
9 
10     function owned() {
11         owner = msg.sender;
12     }
13 
14     modifier onlyOwner {
15         if (msg.sender != owner) throw;
16         _
17     }
18 
19     function transferOwnership(address newOwner) onlyOwner {
20         owner = newOwner;
21     }
22 }
23 
24 contract TokenSale is owned {
25 
26 	address public asset;
27 	uint256 public price;
28 
29 	function TokenSale()
30 	{
31 	      asset =  0xE0B7927c4aF23765Cb51314A0E0521A9645F0E2A; // DGX
32 	      price = 750000000; // 0.75 ETH
33 	}
34 
35 
36 	function transfer_token(address _token, address _to, uint256 _value)
37 	onlyOwner()
38 	{
39 		Token(_token).transfer(_to,_value);
40 	}
41 
42 	function transfer_eth(address _to, uint256 _value)
43 	onlyOwner()
44 	{
45 		if(this.balance >= _value) {
46                     _to.send(_value);
47                 }
48 	}
49 
50    	function () {
51 
52 		uint order   = msg.value / price;
53 
54 		if(order == 0) throw;
55 		
56 		uint256 balance = Token(asset).balanceOf(address(this));
57 
58 		if(balance == 0) throw;
59 
60 		if(order > balance )
61 		{
62 		    order = balance;
63 		    uint256 change = msg.value - order * price;
64 		    msg.sender.send(change);
65 		}
66 
67 		Token(asset).transfer(msg.sender,order);
68     	}
69 }