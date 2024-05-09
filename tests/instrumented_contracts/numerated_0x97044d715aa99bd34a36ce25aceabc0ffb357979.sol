1 pragma solidity ^0.4.0;
2 contract Justo {
3 string public constant symbol ="JTO";
4   string public constant name ="Justo";
5   uint8 public constant decimals = 18;
6   uint256 public totalSupply = 100000000000 * (uint256(10)**decimals);
7   address public owner;
8   uint256 public rate = 5000000000000;
9   mapping(address => uint256) balances;
10   mapping(address => mapping (address => uint256)) allowed;
11   modifier onlyOwner {
12         require(msg.sender == owner);
13         _;
14     }
15 event Transfer(address indexed _from, address indexed _to, uint256 _value);
16 event Approval(address indexed _owner, address indexed _spender, uint256 _value);
17 function Justo() public{
18   owner = msg.sender;
19 }
20 function () public payable {
21   create(msg.sender);
22 }
23 function create(address beneficiary)public payable{
24     uint256 amount = msg.value;
25     if(amount > 0){
26       balances[beneficiary] += amount/rate;
27       totalSupply += amount/rate;
28     }
29   }
30 function balanceOf(address _owner) public constant returns (uint256 balance) {
31     return balances[_owner];
32 }
33 function collect(uint256 amount) onlyOwner public{
34   msg.sender.transfer(amount);
35 }
36 function transfer(address _to, uint256 _amount) public returns (bool success) {
37     if (balances[msg.sender] >= _amount
38         && _amount > 0
39         && balances[_to] + _amount > balances[_to]) {
40         balances[msg.sender] -= _amount;
41         balances[_to] += _amount;
42         Transfer(msg.sender, _to, _amount);
43         return true;
44     } else {
45         return false;
46     }
47 }
48 function transferFrom(
49     address _from,
50     address _to,
51     uint256 _amount
52 ) public returns (bool success) {
53     if (balances[_from] >= _amount
54         && allowed[_from][msg.sender] >= _amount
55         && _amount > 0
56         && balances[_to] + _amount > balances[_to]) {
57         balances[_from] -= _amount;
58         allowed[_from][msg.sender] -= _amount;
59         balances[_to] += _amount;
60         Transfer(_from, _to, _amount);
61         return true;
62     } else {
63         return false;
64     }
65 }
66 function approve(address _spender, uint256 _amount) public returns (bool success) {
67     allowed[msg.sender][_spender] = _amount;
68     Approval(msg.sender, _spender, _amount);
69     return true;
70 }
71 function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
72     return allowed[_owner][_spender];
73 }
74 }