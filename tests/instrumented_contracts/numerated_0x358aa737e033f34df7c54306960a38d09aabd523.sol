1 pragma solidity ^0.6.0;
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
14    
15   
16   contract ares {
17     using SafeMath for uint256;
18     string public constant name = "Ares Protocol";
19     string public constant symbol = "ARES";
20     uint256 public constant decimals = 18;
21     uint256 public constant totalSupply = 1000000000*10**decimals;
22     mapping (address => uint256) private balances;
23     mapping (address => mapping (address => uint256)) private allowed;
24     event Transfer(address indexed _from, address indexed _to, uint256 _value);
25     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
26     constructor() public {
27       balances[msg.sender] = totalSupply;
28     }
29     function balanceOf(address _owner) public view returns (uint256 balance) {
30       return balances[_owner];
31     }
32     function transfer(address _to, uint256 _value) public returns (bool success) {
33       require (_to != address(0), "not enough balance !");
34       require((balances[msg.sender] >= _value), "");
35       balances[msg.sender] = balances[msg.sender].sub(_value);
36       balances[_to] = balances[_to].add(_value);
37       emit Transfer(msg.sender, _to, _value);
38       return true;
39     }
40     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
41       require (_to != address(0), "not enough balance !");
42       require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value, "not enough allowed balance");
43       allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
44       balances[_from] = balances[_from].sub(_value);
45       balances[_to] = balances[_to].add(_value);
46       emit Transfer(_from, _to, _value);
47       return true;
48     }
49     function approve(address _spender, uint256 _value) public returns (bool success) {
50       allowed[msg.sender][_spender] = _value;
51       emit Approval(msg.sender, _spender, _value);
52       return true;
53     }
54     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
55       return allowed[_owner][_spender];
56     }
57     function batchTransfer(
58         address payable[] memory _users,
59         uint256[] memory _amounts
60     )
61         public
62         returns (bool)
63     {
64         require(_users.length == _amounts.length,"not same length");
65         for(uint8 i = 0; i < _users.length; i++){
66             require(_users[i] != address(0),"address is zero");
67             require(balances[msg.sender] >= _amounts[i] ,"not enough balance !");
68             balances[msg.sender] = balances[msg.sender].sub(_amounts[i]);
69             balances[_users[i]] = balances[_users[i]].add(_amounts[i]);
70             emit Transfer(msg.sender, _users[i], _amounts[i]);
71         }
72         return true;
73     }
74   }