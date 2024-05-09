1 contract Ownable {
2     address public owner;
3 
4     function Ownable() public {
5         owner = msg.sender;
6     }
7 
8     modifier onlyOwner() {
9         require(msg.sender == owner);
10         _;
11     }
12 }
13 
14 
15 contract Feeable is Ownable {
16 
17     uint8 public feePercent;
18 
19     function Feeable() public {
20         feePercent = 0;
21     }
22 
23     function setFeePercent(uint8 _feePercent) public onlyOwner {
24         feePercent = _feePercent;
25     }
26 
27     function minFee() public view returns(uint256) {
28         return tx.gasprice * msg.gas * feePercent / 100;
29     }
30 }
31 
32 
33 contract ERC20 {
34     function balanceOf(address who) public view returns (uint256);
35     function transfer(address to, uint256 value) public returns (bool);
36     function transferFrom( address from, address to, uint value) returns (bool ok);
37 }
38 
39 
40 contract Multiplexer is Feeable {
41 
42 	function sendEth(address[] _to, uint256[] _value) payable returns (bool _success) {
43 		// input validation
44 		assert(_to.length == _value.length);
45 		assert(_to.length <= 255);
46         uint256 fee = minFee();
47         require(msg.value > fee);
48 
49         uint256 remain_value = msg.value - fee;
50 
51 		// loop through to addresses and send value
52 		for (uint8 i = 0; i < _to.length; i++) {
53             require(remain_value >= _value[i]);
54             remain_value = remain_value - _value[i];
55 
56 			_to[i].transfer(_value[i]);
57 		}
58 
59 		return true;
60 	}
61 
62 	function sendErc20(address _tokenAddress, address[] _to, uint256[] _value) payable returns (bool _success) {
63 		// input validation
64 		assert(_to.length == _value.length);
65 		assert(_to.length <= 255);
66         require(msg.value >= minFee());
67 
68 		// use the erc20 abi
69 		ERC20 token = ERC20(_tokenAddress);
70 		// loop through to addresses and send value
71 		for (uint8 i = 0; i < _to.length; i++) {
72 			assert(token.transferFrom(msg.sender, _to[i], _value[i]) == true);
73 		}
74 		return true;
75 	}
76 
77     function claim(address _token) public onlyOwner {
78         if (_token == 0x0) {
79             owner.transfer(this.balance);
80             return;
81         }
82         ERC20 erc20token = ERC20(_token);
83         uint256 balance = erc20token.balanceOf(this);
84         erc20token.transfer(owner, balance);
85     }
86 }