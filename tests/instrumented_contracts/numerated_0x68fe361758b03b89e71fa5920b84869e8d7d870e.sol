1 pragma solidity ^0.4.21;
2 
3 contract EIP20Interface {
4 	// 获取总的支持量
5     uint256 public totalSupply;
6     // 获取其他地址的余额
7     function balanceOf(address _owner) public view returns (uint256 balance);
8     // 调用者向_to地址发送_value数量的token
9     function transfer(address _to, uint256 _value) public returns (bool success);
10     //从_from地址向_to地址发送_value数量的token
11 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
12     //允许_spender从自己的账户转出_value数量的token，调用多次会覆盖可用量。
13 	function approve(address _spender, uint256 _value) public returns (bool success);
14     // 返回_spender仍然允许从_owner获取的余额数量
15     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
16 
17     // token转移完成后触发
18     event Transfer(address indexed _from, address indexed _to, uint256 _value);
19     // approve调用后触发
20     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
21 }
22 
23 contract MyToken is EIP20Interface {
24     //注意以下四个状态变量必须公开，并且变量名不能变化，如decimals，命名为decimal。否则与其它钱包应用不能兼容。
25     uint256 public totalSupply;
26     uint8 public decimals;
27     string public name;
28     string public symbol;
29     
30     mapping(address=>uint256) public balances;
31     mapping(address=>mapping(address=>uint256)) public allowed;
32     
33     function MyToken(
34         uint256 _totalSupply,
35         uint8 _decimal,
36         string _name,
37         string _symbol) public {
38             
39         totalSupply = _totalSupply;
40         decimals = _decimal;
41         name = _name;
42         symbol = _symbol;
43         
44         balances[msg.sender] = totalSupply;
45     }
46 
47     
48     // 获取其他地址的余额
49     function balanceOf(address _owner) public view returns (uint256 balance) {
50         return balances[_owner];
51     }
52     
53     // 调用者向_to地址发送_value数量的token
54     function transfer(address _to, uint256 _value) public returns (bool success) {
55         require(balances[msg.sender] >= _value && _value > 0);
56         require(balances[_to] + _value > balances[_to]);
57         balances[msg.sender] -= _value;
58         balances[_to] += _value;
59         emit Transfer(msg.sender, _to, _value);
60         return true;
61     }
62     
63     
64     //从_from地址向_to地址发送_value数量的token
65 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
66 	    uint256 allow = allowed[_from][_to];
67 	    require(_to == msg.sender && allow >= _value && balances[_from] >= _value);
68 	    require(balances[_to] + _value > balances[_to]);
69 	    allowed[_from][_to] -= _value;
70 	    balances[_from] -= _value;
71 	    balances[_to] += _value;
72 	    emit Transfer(_from, _to, _value);
73 	    return true;
74 	}
75 	
76     //允许_spender从自己的账户转出_value数量的token，调用多次会覆盖可用量。
77 	function approve(address _spender, uint256 _value) public returns (bool success) {
78 	    require(balances[msg.sender] >= _value && _value > 0 );
79 	    allowed[msg.sender][_spender] = _value;
80 	    emit Approval(msg.sender, _spender, _value);
81 	    return true;
82 	}
83 	
84     // 返回_spender仍然允许从_owner获取的余额数量
85     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
86         return allowed[_owner][_spender];
87     }
88 
89 }