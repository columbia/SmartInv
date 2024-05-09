1 pragma solidity ^0.4.21;
2 
3 contract StandardToken {
4 
5     event Transfer(address indexed from, address indexed to, uint256 value);
6     event Approval(address indexed owner, address indexed spender, uint256 value);
7     event Issuance(address indexed to, uint256 value);
8 
9     function transfer(address _to, uint256 _value) public returns (bool success) {
10         require(balances[msg.sender] >= _value);
11         balances[msg.sender] -= _value;
12         balances[_to] += _value;
13         emit Transfer(msg.sender, _to, _value);
14         return true;
15     }
16 
17     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
18         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
19         balances[_to] += _value;
20         balances[_from] -= _value;
21         allowed[_from][msg.sender] -= _value;
22         emit Transfer(_from, _to, _value);
23         return true;
24     }
25 
26     function balanceOf(address _owner) constant public returns (uint256 balance) {
27         return balances[_owner];
28     }
29 
30     function approve(address _spender, uint256 _value) public returns (bool success) {
31         allowed[msg.sender][_spender] = _value;
32         emit Approval(msg.sender, _spender, _value);
33         return true;
34     }
35 
36     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
37       return allowed[_owner][_spender];
38     }
39 
40     mapping (address => uint256) balances;
41     mapping (address => mapping (address => uint256)) allowed;
42 
43     uint public totalSupply;
44 }
45 
46 contract MintableToken is StandardToken {
47     address public owner;
48 
49     bool public isMinted = false;
50 
51     function mint(address _to) public {
52         assert(msg.sender == owner && !isMinted);
53 
54         balances[_to] = totalSupply;
55         isMinted = true;
56     }
57 }
58 
59 contract SafeNetToken is MintableToken {
60     string public name = 'SafeNet Token';
61     string public symbol = 'SNT';
62     uint8 public decimals = 18;
63 
64     function SafeNetToken(uint _totalSupply) public {
65         owner = msg.sender;
66         totalSupply = _totalSupply;
67     }
68 }