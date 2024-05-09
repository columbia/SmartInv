1 pragma solidity ^0.4.18;
2 
3 contract SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6        return 0;
7      }
8      uint256 c = a * b;
9      assert(c / a == b);
10      return c;
11    }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14      uint256 c = a / b;
15      return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20      return a - b;
21    }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24      uint256 c = a + b;
25     assert(c >= a);
26      return c;
27    }
28 }
29 
30 contract ERC20 {
31    uint256 public totalSupply;
32    function balanceOf(address who) public view returns (uint256);
33    function transfer(address to, uint256 value) public returns (bool);
34    event Transfer(address indexed from, address indexed to, uint256 value);
35    function allowance(address owner, address spender) public view returns (uint256);
36    function transferFrom(address from, address to, uint256 value) public returns (bool);
37    function approve(address spender, uint256 value) public returns (bool);
38    event Approval(address indexed owner, address indexed spender, uint256 value);
39 }
40 
41 
42 contract StandardToken is ERC20, SafeMath {
43 
44    mapping(address => uint256) balances;
45    mapping (address => mapping (address => uint256)) internal allowed;
46 
47    function transfer(address _to, uint256 _value) public returns (bool) {
48      require(_to != address(0));
49      require(_value <= balances[msg.sender]);
50      balances[msg.sender] = sub(balances[msg.sender], _value);
51      balances[_to] = add(balances[_to], _value);
52      Transfer(msg.sender, _to, _value);
53      return true;
54    }
55 
56   function balanceOf(address _owner) public view returns (uint256 balance) {
57     return balances[_owner];
58    }
59 
60   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
61     require(_to != address(0));
62      require(_value <= balances[_from]);
63      require(_value <= allowed[_from][msg.sender]);
64 
65     balances[_from] = sub(balances[_from], _value);
66      balances[_to] = add(balances[_to], _value);
67      allowed[_from][msg.sender] = sub(allowed[_from][msg.sender], _value);
68     Transfer(_from, _to, _value);
69      return true;
70    }
71 
72    function approve(address _spender, uint256 _value) public returns (bool) {
73      allowed[msg.sender][_spender] = _value;
74      Approval(msg.sender, _spender, _value);
75      return true;
76    }
77 
78   function allowance(address _owner, address _spender) public view returns (uint256) {
79      return allowed[_owner][_spender];
80    }
81 
82    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
83      allowed[msg.sender][_spender] = add(allowed[msg.sender][_spender], _addedValue);
84      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
85      return true;
86    }
87 
88   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
89      uint oldValue = allowed[msg.sender][_spender];
90      if (_subtractedValue > oldValue) {
91        allowed[msg.sender][_spender] = 0;
92      } else {
93        allowed[msg.sender][_spender] = sub(oldValue, _subtractedValue);
94     }
95      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
96      return true;
97    }
98 
99 }
100 
101 contract AnnJouCoin is StandardToken {
102    string public name = "AnnJouCoin";
103    string public symbol = "ANJ";
104    uint public decimals = 18;
105    uint public INITIAL_SUPPLY = 108000000000000000000000000;
106     string public version = 'A0.1'; 
107     uint256 public unitsOneEthCanBuy = 106;     // How many units of your coin can be bought by 1 ETH?
108     uint256 public totalEthInWei = totalEthInWei + msg.value;         // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.  
109     address public fundsWallet = msg.sender;           // Where should the raised ETH go?
110 
111 
112    function AnnJouCoin() public {
113      totalSupply = INITIAL_SUPPLY;
114      balances[msg.sender] = INITIAL_SUPPLY;
115    }
116 }