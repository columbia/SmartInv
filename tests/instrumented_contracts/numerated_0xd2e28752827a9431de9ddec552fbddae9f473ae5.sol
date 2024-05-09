1 pragma solidity ^0.4.0;
2 
3 contract Templar {
4 string public constant symbol = "Templar";
5   string public constant name = "KXT";
6   uint8 public constant decimals = 18;
7   uint256 public totalSupply = 100000000 * (uint256(10)**decimals);
8   address public owner;
9   uint256 public rate =  5000000000000;
10   mapping(address => uint256) balances;
11   mapping(address => mapping (address => uint256)) allowed;
12   modifier onlyOwner {
13         require(msg.sender == owner);
14         _;
15     }
16 event Transfer(address indexed _from, address indexed _to, uint256 _value);
17 event Approval(address indexed _owner, address indexed _spender, uint256 _value);
18 function Mint() public{
19   owner = msg.sender;
20 }
21 function () public payable {
22   create(msg.sender);
23 }
24 function create(address beneficiary)public payable{
25     uint256 amount = msg.value;
26     if(amount > 0){
27       balances[beneficiary] += amount/rate;
28       totalSupply += amount/rate;
29     }
30   }
31 function balanceOf(address _owner) public constant returns (uint256 balance) {
32     return balances[_owner];
33 }
34 function collect(uint256 amount) onlyOwner public{
35   msg.sender.transfer(amount);
36 }
37 function transfer(address _to, uint256 _amount) public returns (bool success) {
38     if (balances[msg.sender] >= _amount
39         && _amount > 0
40         && balances[_to] + _amount > balances[_to]) {
41         balances[msg.sender] -= _amount;
42         balances[_to] += _amount;
43         Transfer(msg.sender, _to, _amount);
44         return true;
45     } else {
46         return false;
47     }
48 }
49 function transferFrom(
50     address _from,
51     address _to,
52     uint256 _amount
53 ) public returns (bool success) {
54     if (balances[_from] >= _amount
55         && allowed[_from][msg.sender] >= _amount
56         && _amount > 0
57         && balances[_to] + _amount > balances[_to]) {
58         balances[_from] -= _amount;
59         allowed[_from][msg.sender] -= _amount;
60         balances[_to] += _amount;
61         Transfer(_from, _to, _amount);
62         return true;
63     } else {
64         return false;
65     }
66 }
67 function approve(address _spender, uint256 _amount) public returns (bool success) {
68     allowed[msg.sender][_spender] = _amount;
69     Approval(msg.sender, _spender, _amount);
70     return true;
71 }
72 function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
73     return allowed[_owner][_spender];
74 }
75 }