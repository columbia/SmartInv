1 pragma solidity ^0.4.11;
2 
3 
4 contract VCCoin  {
5     function balanceOf(address _owner) constant returns (uint256 balance) {
6         return balances[_owner];
7     }
8 
9     function approve(address _spender, uint256 _value) returns (bool success) {
10         allowed[msg.sender][_spender] = _value;
11         Approval(msg.sender, _spender, _value);
12         return true;
13     }
14 
15     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
16       return allowed[_owner][_spender];
17     }
18 
19     mapping(address => uint256) balances;
20 
21     mapping (address => mapping (address => uint256)) allowed;
22 
23     string public name = "VC Coin";
24     string public symbol = "VCC";
25     uint public decimals = 18;
26 
27 
28     // Initial founder address (set in constructor)
29     // All deposited ETH will be instantly forwarded to this address.
30     address public founder = 0x0;
31 
32     uint256 public totalSupply = 5625000 * 10**decimals;
33 
34     event AllocateFounderTokens(address indexed sender);
35     event Transfer(address indexed _from, address indexed _to, uint256 _value);
36     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
37 
38     //constructor
39     function VCCoin(address founderInput) {
40         founder = founderInput;
41         balances[founder] = totalSupply;
42     }
43 
44 
45 
46     function transfer(address _to, uint256 _value) returns (bool success) {
47 
48         //Default assumes totalSupply can't be over max (2^256 - 1).
49         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
50         //Replace the if with this one instead.
51         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
52             balances[msg.sender] -= _value;
53             balances[_to] += _value;
54             Transfer(msg.sender, _to, _value);
55             return true;
56         } else { return false; }
57 
58     }
59 
60     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
61         if (msg.sender != founder) revert();
62 
63         //same as above. Replace this line with the following if you want to protect against wrapping uints.
64         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
65             balances[_to] += _value;
66             balances[_from] -= _value;
67             allowed[_from][msg.sender] -= _value;
68             Transfer(_from, _to, _value);
69             return true;
70         } else { return false; }
71     }
72 
73     function() {
74         revert();
75     }
76 
77     // only owner can kill
78     function kill() { 
79         if (msg.sender == founder) suicide(founder); 
80     }
81 
82 }