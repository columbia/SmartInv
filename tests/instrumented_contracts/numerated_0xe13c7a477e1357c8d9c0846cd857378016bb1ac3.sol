1 pragma solidity ^0.4.26;
2 
3 
4 // Math operations with safety checks that throw on error
5 library SafeMath {
6     
7     function add(uint256 a, uint256 b) internal pure returns (uint256) {
8         uint256 c = a + b;
9         require(c >= a);
10         return c;
11     }
12   
13     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
14         require(b <= a);
15         return a - b;
16     }
17   
18 }
19 
20 
21 // Abstract contract for the full ERC 20 Token standard
22 contract ERC20 {
23     
24     function balanceOf(address _address) public view returns (uint256 balance);
25     
26     function transfer(address _to, uint256 _value) public returns (bool success);
27     
28     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
29     
30     function approve(address _spender, uint256 _value) public returns (bool success);
31     
32     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
33 
34     event Transfer(address indexed _from, address indexed _to, uint256 _value);
35     
36     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
37     
38 }
39 
40 
41 // Token contract
42 contract BHDT is ERC20 {
43     
44     string public name = "Bounty Hunter DEX Token";
45     string public symbol = "BHDT";
46     uint8 public decimals = 18;
47     // 总发行量1千个
48     uint256 public totalSupply = 1000 * 10**18;
49     mapping (address => uint256) public balances;
50     mapping (address => mapping (address => uint256)) public allowed;
51     
52     constructor() public {
53         balances[msg.sender] = totalSupply;
54     }
55     
56     function balanceOf(address _address) public view returns (uint256 balance) {
57         return balances[_address];
58     }
59     
60     function transfer(address _to, uint256 _value) public returns (bool success) {
61         require(_to != address(0));
62         require(balances[msg.sender] >= _value && _value > 0, "Insufficient balance or zero amount");
63         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
64         balances[_to] = SafeMath.add(balances[_to], _value);
65         emit Transfer(msg.sender, _to, _value);
66         return true;
67     }
68     
69     function approve(address _spender, uint256 _amount) public returns (bool success) {
70         require(_spender != address(0));
71         require((allowed[msg.sender][_spender] == 0) || (_amount == 0));
72         allowed[msg.sender][_spender] = _amount;
73         emit Approval(msg.sender, _spender, _amount);
74         return true;
75     }
76     
77     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
78         require(_from != address(0) && _to != address(0));
79         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0, "Insufficient balance or zero amount");
80         balances[_from] = SafeMath.sub(balances[_from], _value);
81         balances[_to] = SafeMath.add(balances[_to], _value);
82         allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
83         emit Transfer(_from, _to, _value);
84         return true;
85     }
86     
87     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
88         return allowed[_owner][_spender];
89     }
90     
91     
92 }