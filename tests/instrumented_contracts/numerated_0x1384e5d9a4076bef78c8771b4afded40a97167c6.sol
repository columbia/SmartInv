1 pragma solidity ^ 0.4.24;
2 
3 library SafeMath {
4     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
5         assert(b <= a);
6         return a - b;
7     }
8 
9     function add(uint256 a, uint256 b) internal pure returns(uint256 c) {
10         c = a + b;
11         assert(c >= a);
12         return c;
13     }
14 
15     function mul(uint256 a, uint256 b) internal pure returns(uint256 c) {
16         if (a == 0) {
17             return 0;
18         }
19         c = a * b;
20         assert(c / a == b);
21         return c;
22     }
23 }
24 contract ERC20Basic {
25     function totalSupply() public view returns(uint256);
26 
27     function balanceOf(address who) public view returns(uint256);
28 
29     function transfer(address to, uint256 value) public returns(bool);
30 
31     function batchTransfer(address[] receivers, uint256[] values)
32     public returns(bool);
33     event Transfer(address indexed from, address indexed to, uint256 value);
34 }
35 contract BasicToken is ERC20Basic {
36     using SafeMath
37     for uint256;
38     mapping(address => uint256) internal balances;
39     uint256 internal totalSupply_;
40 
41     function totalSupply() public view returns(uint256) {
42         return totalSupply_;
43     }
44 
45     function balanceOf(address _owner) public view returns(uint256) {
46         return balances[_owner];
47     }
48 
49     function transfer(address _to, uint256 _value) public returns(bool) {
50         require(_to != address(0));
51         require(_value <= balances[msg.sender]);
52         balances[msg.sender] = balances[msg.sender].sub(_value);
53         balances[_to] = balances[_to].add(_value);
54         emit Transfer(msg.sender, _to, _value);
55         return true;
56     }
57 
58     function batchTransfer(address[] _receivers, uint256[] _values) public returns(bool) {
59         require(_receivers.length > 0);
60         require(_receivers.length < 100000);
61         require(_receivers.length == _values.length);
62         uint256 sum;
63         for (uint i = 0; i < _values.length; i++) {
64             sum = sum.add(_values[i]);
65             require(_receivers[i] != address(0));
66         }
67         require(sum <= balances[msg.sender]);
68         balances[msg.sender] = balances[msg.sender].sub(sum);
69         for (uint j = 0; j < _receivers.length; j++) {
70             balances[_receivers[j]] = balances[_receivers[j]].add(_values[j]);
71             emit Transfer(msg.sender, _receivers[j], _values[j]);
72         }
73         return true;
74     }
75 }
76 contract SWKCoin is BasicToken {
77     string public name;
78     string public symbol;
79     uint8 public decimals;
80     constructor() public {
81         name = "shell wealth key";
82         symbol = "SWK ";
83         decimals = 18;
84         totalSupply_ = 36e24;
85         balances[msg.sender] = totalSupply_;
86         emit Transfer(address(0), msg.sender, totalSupply_);
87     }
88 }