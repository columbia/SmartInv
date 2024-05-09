1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC Token Standard #20 Interface
5  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
6  */
7 contract ERC20 {
8     function name() public constant returns (string);
9     function symbol() public constant returns (string);
10     function decimals() public constant returns (uint8);
11     function totalSupply() public constant returns (uint256);
12     function balanceOf(address _owner) public constant returns (uint256);
13     function transfer(address _to, uint256 _value) public returns (bool);
14     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
15     function approve(address _spender, uint256 _value) public returns (bool);
16     function allowance(address _owner, address _spender) public constant returns (uint256);
17     
18     event Transfer(address indexed _from, address indexed _to, uint256 _value);
19     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
20 }
21 
22 /**
23  * @title Standard ERC20 token
24  */
25 contract StandardToken is ERC20 {
26     mapping (address => uint256) balances;
27     mapping (address => mapping (address => uint256)) allowances;
28     uint256 public totalTokens;
29 
30     function totalSupply() public constant returns (uint256) {
31         return totalTokens;
32     }
33 
34     function balanceOf(address _owner) public constant returns (uint256) {
35         return balances[_owner];
36     }
37 
38     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
39         require(_value <= allowances[_from][msg.sender]);
40         allowances[_from][msg.sender] -= _value;
41         _transfer(_from, _to, _value);
42         return true;
43     }
44 
45     function approve(address _spender, uint256 _value) public returns (bool) {
46         require((_value == 0) || (allowances[msg.sender][_spender] == 0));
47         allowances[msg.sender][_spender] = _value;
48         Approval(msg.sender, _spender, _value);
49         return true;        
50     }
51 
52     function transfer(address _to, uint256 _value) public returns (bool) {
53         _transfer(msg.sender, _to, _value);
54         return true;
55     }
56 
57     function allowance(address _owner, address _spender) public constant returns (uint256) {
58         return allowances[_owner][_spender];
59     }
60 
61     /**
62      * Internal transfer, only can be called by this contract
63      */
64     function _transfer(address _from, address _to, uint256 _value) internal {
65         // Prevent transfer to 0x0 address.
66         require(_to != 0x0);
67         // Check if the sender has enough
68         require(balances[_from] >= _value);
69         // Check for overflows
70         require(balances[_to] + _value > balances[_to]);
71         // Subtract from the sender
72         balances[_from] -= _value;
73         // Add the same to the recipient
74         balances[_to] += _value;
75         Transfer(_from, _to, _value);
76     }
77 
78 }
79 
80 contract CoinXExchange is StandardToken {
81     string public constant NAME = "CoinX Exchange";
82     string public constant SYMBOL = "CXE";
83     uint8 public constant DECIMALS = 0;
84 
85     function name() public constant returns (string) {
86         return NAME;
87     }
88 
89     function symbol() public constant returns (string) {
90         return SYMBOL;
91     }
92 
93     function decimals() public constant returns (uint8) {
94         return DECIMALS;
95     }
96 
97     function CoinXExchange() public {
98         totalTokens = 1000000000;
99         balances[msg.sender] = totalTokens;
100     }
101 }