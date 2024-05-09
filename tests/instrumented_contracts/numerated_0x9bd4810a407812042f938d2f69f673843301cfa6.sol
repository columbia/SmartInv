1 pragma solidity ^0.4.11;
2 
3 /**
4  * ERC 20 token
5  *
6  * https://github.com/ethereum/EIPs/issues/20
7  */
8 contract JCCoin  {
9     function balanceOf(address _owner) constant returns (uint256 balance) {
10         return balances[_owner];
11     }
12 
13     function approve(address _spender, uint256 _value) returns (bool success) {
14         allowed[msg.sender][_spender] = _value;
15         Approval(msg.sender, _spender, _value);
16         return true;
17     }
18 
19     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
20       return allowed[_owner][_spender];
21     }
22 
23     mapping(address => uint256) balances;
24 
25     mapping (address => mapping (address => uint256)) allowed;
26 
27     string public name = "JC Coin";
28     string public symbol = "JCC";
29     uint public decimals = 18;
30 
31 
32     // Initial founder address (set in constructor)
33     // All deposited ETH will be instantly forwarded to this address.
34     address public founder = 0x0;
35 
36     uint256 public totalSupply = 2000000000 * 10**decimals;
37 
38     event Transfer(address indexed _from, address indexed _to, uint256 _value);
39     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
40 
41     //constructor
42     function JCCoin(address founderInput) {
43         founder = founderInput;
44         balances[founder] = totalSupply;
45     }
46 
47 
48     function transfer(address _to, uint256 _value) returns (bool success) {
49 
50         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
51             balances[msg.sender] -= _value;
52             balances[_to] += _value;
53             Transfer(msg.sender, _to, _value);
54             return true;
55         } else { return false; }
56 
57     }
58 
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
73 
74 	
75     function() {
76         revert();
77     }
78 
79     // only owner can kill
80     function kill() { 
81         if (msg.sender == founder) suicide(founder); 
82     }
83 
84 }