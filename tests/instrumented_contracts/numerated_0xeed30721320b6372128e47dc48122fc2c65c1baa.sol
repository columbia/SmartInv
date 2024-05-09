1 pragma solidity ^0.4.19;
2 
3 
4 contract TestPausedToken {
5   
6   address owner;
7   
8   uint256 public totalSupply = 1000000000000000000000000000;
9   string public name = "Test Paused Token";
10   string public symbol = "TPT1";
11   uint8 public decimals = 18;
12   bool public paused = true;
13   
14   mapping (address => mapping (address => uint256)) allowed;
15   mapping(address => uint256) balances;
16   
17   event Transfer(address indexed _from, address indexed _to, uint256 _value);
18   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
19   
20   modifier whenNotPaused() {
21     require(!paused);
22     _;
23   }
24 
25   function TestPausedToken() public {
26     balances[msg.sender] = totalSupply;
27     owner = msg.sender;
28   }
29   
30   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
31     if (_to == address(0)) {
32       return false;
33     }
34     if (_value > balances[msg.sender]) {
35       return false;
36     }
37     
38     balances[msg.sender] = balances[msg.sender] - _value;
39     balances[_to] = balances[_to] + _value;
40     Transfer(msg.sender, _to, _value);
41     return true;
42   }
43   
44   function balanceOf(address _owner) public constant returns (uint256) {
45     return balances[_owner];
46   }
47   
48   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
49     if (_to == address(0)) {
50       return false;
51     }
52     if (_value > balances[_from]) {
53       return false;
54     }
55     if (_value > allowed[_from][msg.sender]) {
56       return false;
57     }
58 
59     balances[_from] = balances[_from] - _value;
60     balances[_to] = balances[_to] + _value;
61     allowed[_from][msg.sender] = allowed[_from][msg.sender] + _value;
62     Transfer(_from, _to, _value);
63     return true;
64   }
65 
66   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
67     allowed[msg.sender][_spender] = _value;
68     Approval(msg.sender, _spender, _value);
69     return true;
70   }
71   
72 
73   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
74     return allowed[_owner][_spender];
75   }
76   
77   function setPaused(bool _paused) public {
78     if (msg.sender == owner) {
79         paused = _paused;
80     }
81   }
82   
83 }