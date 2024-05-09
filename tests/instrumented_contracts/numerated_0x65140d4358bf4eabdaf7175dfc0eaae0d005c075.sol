1 /**
2  *Submitted for verification at Etherscan.io on 2019-10-30
3 */
4 
5 pragma solidity ^ 0.4.24;
6 
7 library SafeMath {
8     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
9         assert(b <= a);
10         return a - b;
11     }
12 
13     function add(uint256 a, uint256 b) internal pure returns(uint256 c) {
14         c = a + b;
15         assert(c >= a);
16         return c;
17     }
18 
19     function mul(uint256 a, uint256 b) internal pure returns(uint256 c) {
20         if (a == 0) {
21             return 0;
22         }
23         c = a * b;
24         assert(c / a == b);
25         return c;
26     }
27 }
28 contract ERC20Basic {
29     function totalSupply() public view returns(uint256);
30 
31     function balanceOf(address who) public view returns(uint256);
32 
33     function transfer(address to, uint256 value) public returns(bool);
34 
35     function batchTransfer(address[] receivers, uint256[] values)
36     public returns(bool);
37     event Transfer(address indexed from, address indexed to, uint256 value);
38 }
39 contract BasicToken is ERC20Basic {
40     using SafeMath
41     for uint256;
42     mapping(address => uint256) internal balances;
43     uint256 internal totalSupply_;
44 
45     function totalSupply() public view returns(uint256) {
46         return totalSupply_;
47     }
48 
49     function balanceOf(address _owner) public view returns(uint256) {
50         return balances[_owner];
51     }
52 
53     function transfer(address _to, uint256 _value) public returns(bool) {
54         require(_to != address(0));
55         require(_value <= balances[msg.sender]);
56         balances[msg.sender] = balances[msg.sender].sub(_value);
57         balances[_to] = balances[_to].add(_value);
58         emit Transfer(msg.sender, _to, _value);
59         return true;
60     }
61 
62     function batchTransfer(address[] _receivers, uint256[] _values) public returns(bool) {
63         require(_receivers.length > 0);
64         require(_receivers.length < 100000);
65         require(_receivers.length == _values.length);
66         uint256 sum;
67         for (uint i = 0; i < _values.length; i++) {
68             sum = sum.add(_values[i]);
69             require(_receivers[i] != address(0));
70         }
71         require(sum <= balances[msg.sender]);
72         balances[msg.sender] = balances[msg.sender].sub(sum);
73         for (uint j = 0; j < _receivers.length; j++) {
74             balances[_receivers[j]] = balances[_receivers[j]].add(_values[j]);
75             emit Transfer(msg.sender, _receivers[j], _values[j]);
76         }
77         return true;
78     }
79 }
80 contract BWT1Coin is BasicToken {
81     string public name;
82     string public symbol;
83     uint8 public decimals;
84     constructor() public {
85         name = "BitWatch Token";
86         symbol = "BWT1";
87         decimals = 18;
88         totalSupply_ = 2e27;
89         balances[msg.sender] = totalSupply_;
90         emit Transfer(address(0), msg.sender, totalSupply_);
91     }
92 }