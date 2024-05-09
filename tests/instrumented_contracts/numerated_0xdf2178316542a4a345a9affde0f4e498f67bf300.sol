1 pragma solidity ^0.4.16;
2 contract Token{
3   uint256 public totalSupply;
4 
5   function balanceOf(address _owner) public constant returns (uint256 balance);
6   function transfer(address _to, uint256 _value) public returns (bool success);
7   function transferFrom(address _from, address _to, uint256 _value) public returns
8   (bool success);
9 
10   function approve(address _spender, uint256 _value) public returns (bool success);
11 
12   function allowance(address _owner, address _spender) public constant returns
13   (uint256 remaining);
14 
15   event Transfer(address indexed _from, address indexed _to, uint256 _value);
16   event Approval(address indexed _owner, address indexed _spender, uint256
17   _value);
18   event Burn(address indexed from, uint256 value);
19   event Inflat(address indexed from, uint256 value);
20 
21 }
22 
23 contract FeibeiContract is Token {
24 
25 
26   uint8 constant public decimals = 18;
27   string constant public name = "FeibeiContract";
28   string constant public symbol = "FB";
29   uint public totalSupply = 1000000000 * 10 ** uint256(decimals);
30   address contract_creator;
31 
32 
33   function FeibeiContract() public {
34 
35     balances[msg.sender] = totalSupply; 
36     contract_creator=msg.sender;
37     
38   }
39   
40   function inflat(uint256 _value) public returns(bool success){
41     require(msg.sender == contract_creator);
42     require(_value > 0);
43     totalSupply += _value;
44     balances[contract_creator] +=_value;
45     Inflat(contract_creator, _value);
46     return true;
47   }
48 
49   function transfer(address _to, uint256 _value) public returns (bool success) {
50   
51     require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
52     require(_to != 0x0);
53     balances[msg.sender] -= _value;
54     balances[_to] += _value;
55     Transfer(msg.sender, _to, _value);
56     return true;
57   }
58 
59 
60   function transferFrom(address _from, address _to, uint256 _value) public returns
61   (bool success) {
62     require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
63     balances[_to] += _value;
64     balances[_from] -= _value; 
65     allowed[_from][msg.sender] -= _value;
66     Transfer(_from, _to, _value);
67     return true;
68   }
69   function balanceOf(address _owner) public constant returns (uint256 balance) {
70     return balances[_owner];
71   }
72 
73 
74   function approve(address _spender, uint256 _value) public returns (bool success)
75   {
76     allowed[msg.sender][_spender] = _value;
77     Approval(msg.sender, _spender, _value);
78     return true;
79   }
80 
81   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
82     return allowed[_owner][_spender];
83   }
84   
85   function burn(uint256 _value) public {
86     require(_value > 0);
87     require(_value <= balances[msg.sender]);
88 
89     address burner = msg.sender;
90     balances[burner] -= _value;
91     totalSupply -=_value;
92     Burn(burner, _value);
93   }
94   mapping (address => uint256) balances;
95   mapping (address => mapping (address => uint256)) allowed;
96 }