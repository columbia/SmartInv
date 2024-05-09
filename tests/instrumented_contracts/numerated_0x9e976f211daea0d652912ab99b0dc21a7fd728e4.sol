1 pragma solidity ^0.5.17;
2 // SPDX-License-Identifier: MIT
3   library SafeMath {
4     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
5       assert(b <= a);
6       return a - b;
7     }
8     function add(uint256 a, uint256 b) internal pure returns (uint256) {
9       uint256 c = a + b;
10       assert(c >= a);
11       return c;
12     }
13   }
14   contract map {
15     using SafeMath for uint256;
16     
17     string public constant name = "MAP Protocol";
18     string public constant symbol = "MAP";
19     uint256 public constant decimals = 18;
20     uint256 public constant totalSupply = 10000000000*10**decimals;
21     
22     mapping (address => uint256) private balances;
23     mapping (address => mapping (address => uint256)) private allowed;
24     
25     event Transfer(address indexed _from, address indexed _to, uint256 _value);
26     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
27     
28     constructor(address _moveAddr) public {
29       balances[_moveAddr] = totalSupply;
30     }
31 
32     function balanceOf(address _owner) public view returns (uint256 balance) {
33       return balances[_owner];
34     }
35     
36     function transfer(address _to, uint256 _value) public returns (bool success) {
37       require (_to != address(0), "not enough balance !");
38       require((balances[msg.sender] >= _value), "");
39       balances[msg.sender] = balances[msg.sender].sub(_value);
40       balances[_to] = balances[_to].add(_value);
41       emit Transfer(msg.sender, _to, _value);
42       return true;
43     }
44 
45     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
46       require (_to != address(0), "not enough balance !");
47       require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value, "not enough allowed balance");
48       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
49       balances[_from] = balances[_from].sub(_value);
50       balances[_to] = balances[_to].add(_value);
51       emit Transfer(_from, _to, _value);
52       return true;
53     }
54 
55     function approve(address _spender, uint256 _value) public returns (bool success) {
56       allowed[msg.sender][_spender] = _value;
57       emit Approval(msg.sender, _spender, _value);
58       return true;
59     }
60 
61     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
62       return allowed[_owner][_spender];
63     }
64     
65     function batchTransfer(
66         address payable[] memory _users, 
67         uint256[] memory _amounts
68     ) 
69         public
70         returns (bool)
71     {
72         require(_users.length == _amounts.length,"not same length");
73         
74         for(uint8 i = 0; i < _users.length; i++){
75             require(_users[i] != address(0),"address is zero");
76             require(balances[msg.sender] >= _amounts[i] ,"not enough balance !");
77             balances[msg.sender] = balances[msg.sender].sub(_amounts[i]);
78             balances[_users[i]] = balances[_users[i]].add(_amounts[i]); 
79             emit Transfer(msg.sender, _users[i], _amounts[i]);
80         }
81         return true;
82     }
83   }