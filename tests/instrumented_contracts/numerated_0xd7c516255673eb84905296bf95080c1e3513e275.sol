1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
5     assert(b <= a);
6     return a - b;
7   }
8 
9   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
10     c = a + b;
11     assert(c >= a);
12     return c;
13   }
14 
15   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
16     if (a == 0) {
17       return 0;
18     }
19     c = a * b;
20     assert(c / a == b);
21     return c;
22   }
23 }
24 
25 contract ERC20Basic {
26   function totalSupply() public view returns (uint256);
27   function balanceOf(address who) public view returns (uint256);
28   function transfer(address to, uint256 value) public returns (bool);
29   function batchTransfer(address[] receivers, uint256[] values) public returns (bool);
30   event Transfer(address indexed from, address indexed to, uint256 value);
31 }
32 
33 contract BasicToken is ERC20Basic {
34   using SafeMath for uint256;
35 
36   mapping(address => uint256) internal balances;
37   uint256 internal totalSupply_;
38 
39   function totalSupply() public view returns (uint256) {
40     return totalSupply_;
41   }
42 
43   function balanceOf(address _owner) public view returns (uint256) {
44     return balances[_owner];
45   }
46 
47   function transfer(address _to, uint256 _value) public returns (bool) {
48     require(_to != address(0));
49     require(_value <= balances[msg.sender]);
50 
51     balances[msg.sender] = balances[msg.sender].sub(_value);
52     balances[_to] = balances[_to].add(_value);
53     emit Transfer(msg.sender, _to, _value);
54     return true;
55   }
56 
57   function batchTransfer(address[] _receivers, uint256[] _values) public returns (bool) {
58     require(_receivers.length > 0);
59     require(_receivers.length < 100000);
60     require(_receivers.length == _values.length);
61 
62     uint256 sum;
63     for(uint i = 0; i < _values.length; i++) {
64       sum = sum.add(_values[i]);
65     }
66     require(sum <= balances[msg.sender]);
67 
68     balances[msg.sender] = balances[msg.sender].sub(sum);
69     for(uint j = 0; j < _receivers.length; j++) {
70       balances[_receivers[j]] = balances[_receivers[j]].add(_values[j]);
71       emit Transfer(msg.sender, _receivers[j], _values[j]);
72     }
73     return true;
74   }
75 }
76 
77 contract EtfChainCoin is BasicToken {
78   string public name;
79   string public symbol;
80   uint8 public decimals;
81 
82   constructor() public {
83     name = "EtfChain2.0";
84     symbol = "ETF";
85     decimals = 18;
86     totalSupply_ = 3.1e26;
87     balances[msg.sender]=totalSupply_;
88     emit Transfer(address(0), msg.sender, totalSupply_);
89   }
90 }