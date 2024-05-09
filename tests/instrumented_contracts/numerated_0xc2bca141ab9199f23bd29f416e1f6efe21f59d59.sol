1 pragma solidity ^0.4.8;
2 contract Ownable {
3     address public owner;
4 
5     function Ownable() {
6       owner = msg.sender;
7     }
8 
9     modifier onlyOwner() {
10       if (msg.sender != owner) {
11         throw;
12       }
13       _;
14     }
15 
16     function transferOwnership(address newOwner) onlyOwner {
17       if (newOwner != address(0)) {
18         owner = newOwner;
19       }
20     }
21 
22     function kill() onlyOwner {
23       selfdestruct(owner);
24     }
25 }
26 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
27 
28 contract Token{
29     uint256 public totalSupply;
30     function balanceOf(address _owner) public constant returns (uint256 balance);
31     function transfer(address _to, uint256 _value) public returns (bool success);
32     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
33     function approve(address _spender, uint256 _value) public returns (bool success);
34     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
35     event Transfer(address indexed _from, address indexed _to, uint256 _value);
36     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
37 }
38 
39 contract VPTToken is Ownable, Token{
40 
41     string public name;
42     string public symbol;
43     uint8 public decimals;
44 
45 
46     function VPTToken() {
47         totalSupply = 160000000000000000;
48         balances[msg.sender] = totalSupply;
49         name = "Victory Platform Token";
50         symbol = "VPT";
51         decimals = 8;
52     }
53 
54     function transfer(address _to, uint256 _value) public returns (bool success) {
55         require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
56         require(_to != 0x0);
57         balances[msg.sender] -= _value;
58         balances[_to] += _value;
59         Transfer(msg.sender, _to, _value);
60         return true;
61     }
62 
63     function transferFrom(address _from, address _to, uint256 _value) public returns
64     (bool success) {
65         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
66         balances[_to] += _value;
67         balances[_from] -= _value;
68         allowed[_from][msg.sender] -= _value;
69         Transfer(_from, _to, _value);
70         return true;
71     }
72 
73     function balanceOf(address _owner) public constant returns (uint256 balance) {
74         return balances[_owner];
75     }
76 
77     function approve(address _spender, uint256 _value) public returns (bool success)
78     {
79         allowed[msg.sender][_spender] = _value;
80         Approval(msg.sender, _spender, _value);
81         return true;
82     }
83 
84     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
85         return allowed[_owner][_spender];
86     }
87     mapping (address => uint256) balances;
88     mapping (address => mapping (address => uint256)) allowed;
89 }