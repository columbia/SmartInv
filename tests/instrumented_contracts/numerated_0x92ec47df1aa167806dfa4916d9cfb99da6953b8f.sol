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
14   contract idavoll {
15     using SafeMath for uint256;
16     
17     string public constant name = "Idavoll Network";
18     string public constant symbol = "IDV";
19     uint256 public constant decimals = 18;
20     uint256 public constant totalSupply = 2000000000*10**decimals;
21     
22     mapping (address => uint256) private balances;
23     mapping (address => mapping (address => uint256)) private allowed;
24     
25     event Transfer(address indexed _from, address indexed _to, uint256 _value);
26     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
27     
28     constructor(address _moveAddr) public {
29       require(_moveAddr != address(0), "_moveAddress is a zero address");
30       balances[_moveAddr] = totalSupply;
31       transfer(_moveAddr, totalSupply);
32     }
33 
34     function balanceOf(address _owner) public view returns (uint256) {
35       return balances[_owner];
36     }
37     
38     function transfer(address _to, uint256 _value) public returns (bool) {
39       //require (_to != address(0), "not enough balance !");
40       require((balances[msg.sender] >= _value), "not enough balance !");
41       balances[msg.sender] = balances[msg.sender].sub(_value);
42       balances[_to] = balances[_to].add(_value);
43       emit Transfer(msg.sender, _to, _value);
44       return true;
45     }
46 
47     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
48       //require (_to != address(0), "not enough balance !");
49       require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value, "not enough allowed balance");
50       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
51       balances[_from] = balances[_from].sub(_value);
52       balances[_to] = balances[_to].add(_value);
53       emit Transfer(_from, _to, _value);
54       return true;
55     }
56 
57     function approve(address _spender, uint256 _value) public returns (bool) {
58       allowed[msg.sender][_spender] = _value;
59       emit Approval(msg.sender, _spender, _value);
60       return true;
61     }
62 
63     function allowance(address _owner, address _spender) public view returns (uint256) {
64       return allowed[_owner][_spender];
65     }
66     
67     function batchTransfer(
68         address payable[] memory _users, 
69         uint256[] memory _amounts
70     ) 
71         public
72         returns (bool)
73     {
74         require(_users.length == _amounts.length,"not same length");
75         
76         for(uint8 i = 0; i < _users.length; i++){
77             transfer(_users[i], _amounts[i]);
78         }
79         return true;
80     }
81   }