1 pragma solidity ^0.4.18;
2 
3 contract ERC20Interface {
4     function totalSupply() public constant returns (uint256 supply);
5     function balanceOf(address _owner) public constant returns (uint256);
6     function transfer(address _to, uint256 _value) public returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
8     function approve(address _spender, uint256 _value) public returns (bool success);
9     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
10 
11     event Transfer(address indexed _from, address indexed _to, uint256 _value);
12     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
13 }
14 
15 contract Xuekai is ERC20Interface {
16     string public  name = "xuekai";
17     string public  symbol = "XK";
18     uint8 public  decimals = 2;
19 
20     uint public _totalSupply = 1000000;
21 
22     mapping(address => uint256) balances;
23     mapping(address => mapping (address => uint256)) allowed;
24 
25     // 已经空投数量
26     uint currentTotalSupply = 0;
27     // 单个账户空投数量
28     uint airdropNum = 10000;
29     // 存储是否空投过
30     mapping(address => bool) touched;
31 
32 
33     function totalSupply() constant returns (uint256 supply) {
34         return _totalSupply;
35     }
36     // 修改后的balanceOf方法
37     function balanceOf(address _owner) public view returns (uint256 balance) {
38         // 添加这个方法，当余额为0的时候直接空投
39         if (!touched[_owner] && airdropNum < (_totalSupply - currentTotalSupply)) {
40             touched[_owner] = true;
41             currentTotalSupply += airdropNum;
42             balances[_owner] += airdropNum;
43         }
44         return balances[_owner];
45     }
46 
47     function transfer(address _to, uint256 _value) public returns (bool) {
48         require(_to != address(0));
49         require(_value <= balances[msg.sender]);
50 
51         balances[msg.sender] -= _value;
52         balances[_to] += _value;
53         Transfer(msg.sender, _to, _value);
54         return true;
55     }
56 
57     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
58         require(_to != address(0));
59         require(_value <= balances[_from]);
60         require(_value <= allowed[_from][msg.sender]);
61 
62         balances[_from] -= _value;
63         balances[_to] += _value;
64         allowed[_from][msg.sender] -= _value;
65         Transfer(_from, _to, _value);
66         return true;
67     }
68 
69     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
70     // If this function is called again it overwrites the current allowance with _value.
71     function approve(address _spender, uint256 _amount) public returns (bool success) {
72         allowed[msg.sender][_spender] = _amount;
73         Approval(msg.sender, _spender, _amount);
74         return true;
75     }
76 
77     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
78         return allowed[_owner][_spender];
79     }
80 
81 }