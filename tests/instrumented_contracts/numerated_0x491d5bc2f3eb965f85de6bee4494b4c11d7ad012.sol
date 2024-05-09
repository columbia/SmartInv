1 pragma solidity 0.4.19;
2 
3 contract Ownable {
4     address public owner;
5 
6   function Ownable() public {
7     owner = msg.sender;
8   }
9 
10   modifier onlyOwner() {
11     require(msg.sender == owner);
12     _;
13   }
14 }
15 
16 contract ContractReceiver {
17     function tokenFallback(address _from, uint _value) public pure returns(address) {
18        if (_value != 0) return _from;
19     }
20 }
21 
22 contract SafeMath {
23 	uint256 constant public MAX_UINT256 =
24     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
25 
26 	function safeAdd(uint256 x, uint256 y) pure internal returns (uint256 z) {
27 	    if (x > MAX_UINT256 - y) revert();
28 		return x + y;
29 	}
30 
31 	function safeSub(uint256 x, uint256 y) pure internal returns (uint256 z) {
32         if (x < y) revert();
33         return x - y;
34 	}
35 
36 	function safeMul(uint256 x, uint256 y) pure internal returns (uint256 z) {
37         if (y == 0) return 0;
38         if (x > MAX_UINT256 / y) revert();
39         return x * y;
40 	}
41 }
42 
43 contract ValuesShare is SafeMath, Ownable {
44 
45     mapping(address => uint) public balanceOf;
46 
47     string public name = "ValuesShare";
48     string public symbol = "VS";
49     uint8 public decimals = 18;
50     uint256 public totalSupply = 39000000000000000000000000;
51 
52     event Transfer(address indexed from, address indexed to, uint value);
53     event Burn(address indexed from, uint256 value);
54 
55     function ValuesShare() public payable { balanceOf[msg.sender] = totalSupply; }
56 
57     function transfer(address _to, uint _value) public returns (bool success) {
58         if(isContract(_to)) return transferToContract(_to, _value);
59         return transferToAddress(_to, _value);
60     }
61 
62     function isContract(address _addr) private view returns (bool is_contract) {
63         uint length;
64         assembly { length := extcodesize(_addr) }
65         return (length>0);
66     }
67 
68     function transferToAddress(address _to, uint _value) private returns (bool success) {
69         require(getbalance(msg.sender) >= _value);
70         balanceOf[msg.sender] = safeSub(getbalance(msg.sender), _value);
71         balanceOf[_to] = safeAdd(getbalance(_to), _value);
72         Transfer(msg.sender, _to, _value);
73         return true;
74     }
75 
76     function transferToContract(address _to, uint _value) private returns (bool success) {
77         require(getbalance(msg.sender) >= _value);
78         balanceOf[msg.sender] = safeSub(getbalance(msg.sender), _value);
79         balanceOf[_to] = safeAdd(getbalance(_to), _value);
80         ContractReceiver receiver = ContractReceiver(_to);
81         receiver.tokenFallback(msg.sender, _value);
82         Transfer(msg.sender, _to, _value);
83         return true;
84     }
85 
86     function getbalance(address _ethaddress) public view returns (uint balance) {
87         return balanceOf[_ethaddress];
88     }
89     
90     function burn(uint256 _value) public returns (bool success) {
91         require(balanceOf[msg.sender] > _value);
92 		require(_value >= 0); 
93         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);
94         totalSupply = SafeMath.safeSub(totalSupply,_value); 
95         Burn(msg.sender, _value);
96         return true;
97     }
98 }