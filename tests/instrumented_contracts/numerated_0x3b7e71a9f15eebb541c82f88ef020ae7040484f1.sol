1 pragma solidity ^0.4.15;
2 
3 
4 contract Ownable {
5     address public owner;
6 
7     function Ownable() public {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner() {
12         require(msg.sender == owner);
13         _;
14     }
15 }
16 
17 
18 contract Feeable is Ownable {
19 
20     uint8 public feePercent;
21 
22     function Feeable() public {
23         feePercent = 50;
24     }
25 
26     function setFeePercent(uint8 _feePercent) public onlyOwner {
27         feePercent = _feePercent;
28     }
29 
30     function minFee() public view returns(uint256) {
31         return tx.gasprice * msg.gas * feePercent / 100;
32     }
33 }
34 
35 
36 contract ERC20 {
37     function balanceOf(address who) public view returns (uint256);
38     function transfer(address to, uint256 value) public returns (bool);
39     function transferFrom( address from, address to, uint value) returns (bool ok);
40 }
41 
42 
43 contract Multiplexer is Feeable {
44 
45 	function sendEth(address[] _to, uint256[] _value) payable returns (bool _success) {
46 		// input validation
47 		assert(_to.length == _value.length);
48 		assert(_to.length <= 255);
49         uint256 fee = minFee();
50         require(msg.value > fee);
51 
52         uint256 remain_value = msg.value - fee;
53 
54 		// loop through to addresses and send value
55 		for (uint8 i = 0; i < _to.length; i++) {
56             require(remain_value >= _value[i]);
57             remain_value = remain_value - _value[i];
58 
59 			_to[i].transfer(_value[i]);
60 		}
61 
62 		return true;
63 	}
64 
65 	function sendErc20(address _tokenAddress, address[] _to, uint256[] _value) payable returns (bool _success) {
66 		// input validation
67 		assert(_to.length == _value.length);
68 		assert(_to.length <= 255);
69         require(msg.value >= minFee());
70 
71 		// use the erc20 abi
72 		ERC20 token = ERC20(_tokenAddress);
73 		// loop through to addresses and send value
74 		for (uint8 i = 0; i < _to.length; i++) {
75 			assert(token.transferFrom(msg.sender, _to[i], _value[i]) == true);
76 		}
77 		return true;
78 	}
79 
80     function claim(address _token) public onlyOwner {
81         if (_token == 0x0) {
82             owner.transfer(this.balance);
83             return;
84         }
85         ERC20 erc20token = ERC20(_token);
86         uint256 balance = erc20token.balanceOf(this);
87         erc20token.transfer(owner, balance);
88     }
89 }