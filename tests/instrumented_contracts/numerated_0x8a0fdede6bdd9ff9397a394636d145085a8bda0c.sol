1 pragma solidity ^0.4.17;
2 
3 /* 7Star Exchange Kangaroo Token */
4 /* www.1234567.io */
5 
6 contract Token {
7     uint256 public totalSupply;
8     uint256 public constant decimals = 18;
9     function balanceOf(address _owner) public view returns (uint256 balance);
10     function transfer(address _to, uint256 _value) public returns (bool success);
11     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
12     function approve(address _spender, uint256 _value) public returns (bool success);
13     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
14     event Transfer(address indexed _from, address indexed _to, uint256 _value);
15     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
16 }
17 
18 /*  ERC 20 token */
19 contract StandardToken is Token {
20     function formatDecimals(uint256 _value) internal pure returns (uint256 ) {
21         return _value * 10 ** decimals;
22     }
23     
24     function transfer(address _to, uint256 _value) public returns (bool success) {
25         _value = formatDecimals(_value);
26         if (balances[msg.sender] >= _value && _value > 0) {
27             balances[msg.sender] -= _value;
28             balances[_to] += _value;
29             emit Transfer(msg.sender, _to, _value);
30             return true;
31         } else {
32             return false;
33         }
34     }
35 
36     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
37         _value = formatDecimals(_value);
38         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
39             balances[_to] += _value;
40             balances[_from] -= _value;
41             allowed[_from][msg.sender] -= _value;
42             emit Transfer(_from, _to, _value);
43             return true;
44         } else {
45             return false;
46         }
47     }
48 
49     function balanceOf(address _owner) public view returns (uint256 balance) {
50         return balances[_owner];
51     }
52 
53     function approve(address _spender, uint256 _value) public returns (bool success) {
54         _value = formatDecimals(_value);
55         allowed[msg.sender][_spender] = _value;
56         emit Approval(msg.sender, _spender, _value);
57         return true;
58     }
59 
60     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
61         return allowed[_owner][_spender];
62     }
63 
64     mapping (address => uint256) balances;
65     mapping (address => mapping (address => uint256)) allowed;
66 }
67 
68 contract KTCoin is StandardToken {
69     string  public constant name = "7Star Exchange Kangaroo Token";
70     string  public constant symbol = "KT";
71     string  public version = "1.0";
72 
73     constructor() public {
74 		totalSupply = formatDecimals(3000000000);
75         balances[msg.sender] =totalSupply;
76     }
77 }