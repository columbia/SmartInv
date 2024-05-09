1 pragma solidity ^0.4.12;
2 
3 //ERC20
4 contract ERC20 {
5      function totalSupply() constant returns (uint256 supply);
6      function balanceOf(address _owner) constant returns (uint256 balance);
7      function transfer(address _to, uint256 _value) returns (bool success);
8      function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
9      function approve(address _spender, uint256 _value) returns (bool success);
10      function allowance(address _owner, address _spender) constant returns (uint256 remaining);
11 
12      event Transfer(address indexed _from, address indexed _to, uint256 _value);
13      event Approval(address indexed _owner, address indexed _spender, uint256 _value);
14 }
15 
16 contract YUNLAI is ERC20{
17 
18     // metadata
19     string  public constant name = "YUN LAI COIN";
20     string  public constant symbol = "YLC";
21     string  public version = "1.0";
22     uint256 public constant decimals = 18;
23     uint256 public totalSupply = 1500000000000000000000000000;
24    
25 
26     // contracts
27     address public owner;
28 
29     mapping (address => uint256) public balances;
30     mapping (address => mapping (address => uint256)) public allowance;
31 
32     // format decimals.
33     function formatDecimals(uint256 _value) internal returns (uint256 ) {
34         return _value * 10 ** decimals;
35     }
36 
37     /**
38      * @dev Fix for the ERC20 short address attack.
39      */
40     modifier onlyPayloadSize(uint size) {
41       if(msg.data.length < size + 4) {
42         revert();
43       }
44       _;
45     }
46 
47     modifier isOwner()  {
48       require(msg.sender == owner);
49       _;
50     }
51 
52     // constructor
53     function YUNLAI()
54     {
55         owner = msg.sender;
56         balances[msg.sender] = totalSupply;
57     }
58 
59     function totalSupply() constant returns (uint256 supply)
60     {
61       return totalSupply;
62     }
63 
64     /* Send coins */
65     function transfer(address _to, uint256 _value) onlyPayloadSize(2*32) returns (bool success){
66       if ((_to == 0x0) || (_value <= 0) || (balances[msg.sender] < _value)
67            || (balances[_to] + _value < balances[_to])) return false;
68       balances[msg.sender] -= _value;
69       balances[_to] += _value;
70 
71       Transfer(msg.sender, _to, _value);
72       return true;
73     }
74    
75     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(2*32) returns (bool success) {
76       if ((_to == 0x0) || (_value <= 0) || (balances[_from] < _value)
77           || (balances[_to] + _value < balances[_to])
78           || (_value > allowance[_from][msg.sender]) ) return false;
79 
80       balances[_to] += _value;
81       balances[_from] -= _value;
82       allowance[_from][msg.sender] -= _value;
83 
84       Transfer(_from, _to, _value);
85       return true;
86     }
87 
88     function balanceOf(address _owner) constant returns (uint256 balance) {
89         return balances[_owner];
90     }
91 
92     function approve(address _spender, uint256 _value) returns (bool success) {
93         allowance[msg.sender][_spender] = _value;
94         Approval(msg.sender, _spender, _value);
95         return true;
96     }
97 
98     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
99       return allowance[_owner][_spender];
100     }
101 
102     function () payable {
103         revert();
104     }
105 }