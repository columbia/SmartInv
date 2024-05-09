1 pragma solidity ^0.4.19;
2 
3 interface IERC20 {
4     function totalSupply () constant returns (uint256 totalSuppy);
5     function balanceOf(address _owner) constant returns (uint256 balance);
6     function transfer(address _to, uint256 _value) returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
8     function approve(address _spender, uint256 _value) returns (bool success);
9     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 contract POS is IERC20 {
14     uint public constant _totalSupply = 200000000;
15     string public constant symbol = "Turd";
16     string public constant name = "POS";
17     uint8 public constant decimals = 0;
18     
19     mapping (address => uint256) balances;
20     mapping(address => mapping(address => uint256)) allowed;
21     function POS() public{
22         balances[msg.sender] = _totalSupply;
23     }
24     
25     function totalSupply() constant returns (uint256 totalSupply) {
26         return _totalSupply;
27     }
28     function balanceOf(address _owner) constant returns (uint256 balance) {
29         return balances[_owner];
30     }
31     function transfer(address _to, uint256 _value) returns (bool success) {
32         require(
33             balances[msg.sender] >= _value
34             && _value > 0
35             );
36             balances[msg.sender] -= _value;
37             balances[_to] += _value;
38             Transfer(msg.sender, _to, _value);
39             return true;
40     }
41     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
42         require(
43             allowed[_from][msg.sender] >= _value
44             && balances[_from] >= _value
45             && _value > 0
46             );
47             balances[_from] -= _value;
48             balances[_to] += _value;
49             allowed[_from][msg.sender] -= _value;
50             Transfer(_from, _to, _value);
51             return true;
52     }
53     function approve(address _spender, uint256 _value) returns (bool success) {
54         allowed[msg.sender][_spender] = _value;
55         Approval(msg.sender, _spender, _value);
56         return true;
57     }
58     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
59         return allowed[_owner][_spender];
60     }
61     
62 }