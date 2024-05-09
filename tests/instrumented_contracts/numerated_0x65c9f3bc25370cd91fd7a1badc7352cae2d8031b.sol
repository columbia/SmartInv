1 pragma solidity ^0.4.18;
2 
3 contract ERC20 {
4 
5     function totalSupply() public constant returns (uint256 totalSupply) {}
6     function balanceOf(address _owner) public constant returns (uint256 balance) {}
7     function transfer(address _to, uint256 _value) public returns (bool success) {}
8 
9     event Transfer(address indexed _from, address indexed _to, uint256 _value);
10 }
11 
12 contract StandToken is ERC20 {
13 
14     function transfer(address _to, uint256 _value) public returns (bool success) {
15         require(balances[msg.sender] >= _value);
16         require(_value > 0);
17         require(balances[msg.sender] + _value >= balances[msg.sender]);
18         
19         balances[msg.sender] -= _value;
20         balances[_to] += _value;
21 
22         emit Transfer(msg.sender, _to, _value);
23     }
24 
25     function balanceOf(address _owner) public constant returns (uint256 balance) {
26         return balances[_owner];
27     }
28 
29     mapping (address => uint256) balances;
30     uint256 public totalSupply;
31 }
32 
33 contract COZ is StandToken {
34 
35     string public name;
36     uint8 public decimals;
37     string public symbol;
38     address public fundsWallet;
39     uint256 public dec_multiple;
40 
41     constructor() public {
42         name = "COZ";
43         decimals = 18;
44         symbol = "COZ";
45         dec_multiple = 10 ** uint256(decimals);
46 
47         totalSupply = 3 * 1000 * 1000 * 1000 * dec_multiple;
48         balances[msg.sender] =  totalSupply;        
49         fundsWallet = msg.sender;
50     }
51 }